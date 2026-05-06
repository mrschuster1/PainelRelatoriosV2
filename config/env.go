package config

import (
	"log"

	"github.com/joho/godotenv"
)

// LoadEnv loads the .env file if it exists.
// We don't fail if it doesn't exist, as env vars might be provided by the OS.
func LoadEnv() {
	err := godotenv.Load()
	if err != nil {
		log.Println("Arquivo de configuração .env não econtrado.")
	}
}
