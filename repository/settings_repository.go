package repository

import (
	"database/sql"
	"encoding/json"
	"fmt"
)

type SettingsRepository struct {
	db *sql.DB
}

func NewSettingsRepository(db *sql.DB) *SettingsRepository {
	return &SettingsRepository{db: db}
}

// FilterPreset represents a saved filter configuration
type FilterPreset struct {
	ID         int    `json:"id"`
	Name       string `json:"name"`
	FilterJSON string `json:"filter_json"`
	UserID     int    `json:"user_id"`
	UserName   string `json:"user_name"`
}

// SaveFilterPreset saves or updates a filter preset
func (r *SettingsRepository) SaveFilterPreset(name string, filter interface{}, userID int, userName string) error {
	filterBytes, err := json.Marshal(filter)
	if err != nil {
		return fmt.Errorf("erro ao serializar filtro: %w", err)
	}

	// First, check if the preset exists and who owns it
	var existingUserID int
	err = r.db.QueryRow("SELECT user_id FROM filter_presets WHERE name = ?", name).Scan(&existingUserID)
	
	if err == sql.ErrNoRows {
		// New preset, just insert
		_, err = r.db.Exec(`INSERT INTO filter_presets (name, filter_json, user_id, user_name) VALUES (?, ?, ?, ?)`,
			name, string(filterBytes), userID, userName)
	} else if err == nil {
		// Existing preset, check ownership
		if existingUserID != userID && existingUserID != 0 {
			return fmt.Errorf("você não tem permissão para alterar este filtro (pertence a outro usuário)")
		}
		// Owns it or it's an old filter without owner (userID=0), update it
		_, err = r.db.Exec(`UPDATE filter_presets SET filter_json = ?, user_id = ?, user_name = ? WHERE name = ?`,
			string(filterBytes), userID, userName, name)
	}

	if err != nil {
		return fmt.Errorf("erro ao salvar preset no sqlite: %w", err)
	}
	return nil
}

// GetFilterPresets returns all saved filter presets
func (r *SettingsRepository) GetFilterPresets() ([]FilterPreset, error) {
	query := `SELECT id, name, filter_json, COALESCE(user_id, 0), COALESCE(user_name, '') FROM filter_presets ORDER BY name ASC`
	rows, err := r.db.Query(query)
	if err != nil {
		return nil, fmt.Errorf("erro ao buscar presets: %w", err)
	}
	defer rows.Close()

	var presets []FilterPreset
	for rows.Next() {
		var p FilterPreset
		if err := rows.Scan(&p.ID, &p.Name, &p.FilterJSON, &p.UserID, &p.UserName); err != nil {
			return nil, err
		}
		presets = append(presets, p)
	}
	return presets, nil
}

// DeleteFilterPreset removes a preset by name if owned by the user
func (r *SettingsRepository) DeleteFilterPreset(name string, userID int) error {
	// Verify ownership before deleting
	var existingUserID int
	err := r.db.QueryRow("SELECT user_id FROM filter_presets WHERE name = ?", name).Scan(&existingUserID)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil // Already deleted or doesn't exist
		}
		return err
	}

	if existingUserID != userID && existingUserID != 0 {
		return fmt.Errorf("você não tem permissão para excluir este filtro")
	}

	_, err = r.db.Exec("DELETE FROM filter_presets WHERE name = ? AND (user_id = ? OR user_id = 0)", name, userID)
	return err
}
