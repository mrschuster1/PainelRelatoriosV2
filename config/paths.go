package config

import (
	"log"
	"os"
	"path/filepath"
)

// GetAppPath returns the absolute path to the directory where the executable is located.
func GetAppPath() string {
	ex, err := os.Executable()
	if err != nil {
		log.Printf("Erro ao obter o caminho do executável: %v. Usando diretório atual.", err)
		return "."
	}
	return filepath.Dir(ex)
}

// GetConfigPath returns the absolute path to the .env file.
func GetConfigPath() string {
	return filepath.Join(GetAppPath(), ".env")
}

// GetSQLitePath returns the absolute path to the settings.db file.
func GetSQLitePath() string {
	return filepath.Join(GetAppPath(), "settings.db")
}
