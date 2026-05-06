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
}

// SaveFilterPreset saves or updates a filter preset
func (r *SettingsRepository) SaveFilterPreset(name string, filter interface{}) error {
	filterBytes, err := json.Marshal(filter)
	if err != nil {
		return fmt.Errorf("erro ao serializar filtro: %w", err)
	}

	query := `INSERT INTO filter_presets (name, filter_json) 
			  VALUES (?, ?) 
			  ON CONFLICT(name) DO UPDATE SET filter_json = excluded.filter_json`
	
	_, err = r.db.Exec(query, name, string(filterBytes))
	if err != nil {
		return fmt.Errorf("erro ao salvar preset no sqlite: %w", err)
	}
	return nil
}

// GetFilterPresets returns all saved filter presets
func (r *SettingsRepository) GetFilterPresets() ([]FilterPreset, error) {
	query := `SELECT id, name, filter_json FROM filter_presets ORDER BY name ASC`
	rows, err := r.db.Query(query)
	if err != nil {
		return nil, fmt.Errorf("erro ao buscar presets: %w", err)
	}
	defer rows.Close()

	var presets []FilterPreset
	for rows.Next() {
		var p FilterPreset
		if err := rows.Scan(&p.ID, &p.Name, &p.FilterJSON); err != nil {
			return nil, err
		}
		presets = append(presets, p)
	}
	return presets, nil
}

// DeleteFilterPreset removes a preset by name
func (r *SettingsRepository) DeleteFilterPreset(name string) error {
	_, err := r.db.Exec("DELETE FROM filter_presets WHERE name = ?", name)
	return err
}
