package database

import (
	"database/sql"
	"fmt"
	"log"
	"PainelRelatorios/config"

	_ "modernc.org/sqlite"
)

// ConnectSQLite initializes and returns a connection to the local SQLite database
func ConnectSQLite() (*sql.DB, error) {
	// The database file will be created in the current working directory
	dbPath := config.GetSQLitePath()
	
	db, err := sql.Open("sqlite", dbPath)
	if err != nil {
		return nil, fmt.Errorf("erro ao abrir sqlite: %w", err)
	}

	// Concurrency optimizations
	_, _ = db.Exec("PRAGMA journal_mode=WAL;")
	_, _ = db.Exec("PRAGMA busy_timeout=5000;")
	_, _ = db.Exec("PRAGMA synchronous=NORMAL;")

	// Run migrations
	if err := MigrateSQLite(db); err != nil {
		return nil, fmt.Errorf("erro na migração do sqlite: %w", err)
	}

	log.Println("Conectado ao banco SQLite local com sucesso.")
	return db, nil
}

// MigrateSQLite ensures all necessary tables exist
func MigrateSQLite(db *sql.DB) error {
	// Initial setup migration
	migrations := []struct {
		name string
		sql  string
	}{
		{
			name: "create_migrations_table",
			sql: `CREATE TABLE IF NOT EXISTS migrations (
				id INTEGER PRIMARY KEY AUTOINCREMENT,
				name TEXT UNIQUE,
				applied_at DATETIME DEFAULT CURRENT_TIMESTAMP
			);`,
		},
		{
			name: "create_filter_presets_table",
			sql: `CREATE TABLE IF NOT EXISTS filter_presets (
				id INTEGER PRIMARY KEY AUTOINCREMENT,
				name TEXT UNIQUE,
				filter_json TEXT,
				created_at DATETIME DEFAULT CURRENT_TIMESTAMP
			);`,
		},
		{
			name: "add_user_to_filter_presets",
			sql: `ALTER TABLE filter_presets ADD COLUMN user_id INTEGER;
				  ALTER TABLE filter_presets ADD COLUMN user_name TEXT;`,
		},
	}

	for _, m := range migrations {
		// Check if migration was already applied
		var exists bool
		err := db.QueryRow("SELECT EXISTS(SELECT 1 FROM migrations WHERE name = ?)", m.name).Scan(&exists)
		
		// If migrations table doesn't exist yet, we just catch that error and proceed for the first one
		if err != nil && m.name != "create_migrations_table" {
			return fmt.Errorf("erro ao verificar migração %s: %w", m.name, err)
		}

		if !exists {
			log.Printf("Aplicando migração: %s\n", m.name)
			if _, err := db.Exec(m.sql); err != nil {
				return fmt.Errorf("erro ao aplicar migração %s: %w", m.name, err)
			}
			
			// Log the migration as applied (except for the migrations table itself which we just created)
			if m.name != "create_migrations_table" {
				if _, err := db.Exec("INSERT INTO migrations (name) VALUES (?)", m.name); err != nil {
					return fmt.Errorf("erro ao registrar migração %s: %w", m.name, err)
				}
			} else {
				// Special case for the first migration
				if _, err := db.Exec("INSERT OR IGNORE INTO migrations (name) VALUES (?)", m.name); err != nil {
					log.Printf("Aviso ao registrar migração inicial: %v\n", err)
				}
			}
		}
	}

	return nil
}
