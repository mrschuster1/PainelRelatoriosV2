package database

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	_ "github.com/go-sql-driver/mysql"
)

// Connect returns a connected *sql.DB instance
func Connect() (*sql.DB, error) {
	user := os.Getenv("DB_USER")
	pass := os.Getenv("DB_PASS")
	host := os.Getenv("DB_HOST")
	port := os.Getenv("DB_PORT")
	name := os.Getenv("DB_NAME")

	// If missing, use defaults or just warn.
	// Wails startup won't crash, we just log warning.
	if host == "" {
		host = "127.0.0.1"
	}
	if port == "" {
		port = "3306"
	}

	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?parseTime=true", user, pass, host, port, name)

	db, err := sql.Open("mysql", dsn)
	if err != nil {
		return nil, fmt.Errorf("erro ao conectar ao banco de dados: %w", err)
	}

	// We ping to verify connection, but we won't panic if fails immediately
	// in case DB is offline at app startup.
	if err := db.Ping(); err != nil {
		log.Printf("Aviso: erro ao tentar conectar ao banco de dados: %v\n", err)
		return db, nil // returning db anyway so user can retry or check logs
	}

	log.Println("Conectado ao banco de dados com sucesso.")
	return db, nil
}
