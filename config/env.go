package config

import (
	"log"

	"github.com/joho/godotenv"
)

// LoadEnv loads the .env file if it exists.
// We don't fail if it doesn't exist, as env vars might be provided by the OS.
func LoadEnv() {
	err := godotenv.Load(GetConfigPath())
	if err != nil {
		log.Printf("Arquivo de configuração .env não encontrado em %s. Tentando diretório atual.\n", GetConfigPath())
		_ = godotenv.Load() // Fallback to current directory
	}
}
