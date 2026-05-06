package repository

import (
	"fmt"
	"os"
	"time"
)

var logFilename string

func init() {
	os.MkdirAll("logs", 0755)
	logFilename = fmt.Sprintf("logs/sql_log_%s.txt", time.Now().Format("20060102_150405"))
}

func LogSQL(query string, args ...interface{}) {
	f, err := os.OpenFile(logFilename, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		fmt.Printf("Erro ao abrir arquivo de log: %v\n", err)
		return
	}
	defer f.Close()

	timestamp := time.Now().Format("2006-01-02 15:04:05")
	logLine := fmt.Sprintf("[%s] QUERY: %s | ARGS: %v\n", timestamp, query, args)
	
	if _, err := f.WriteString(logLine); err != nil {
		fmt.Printf("Erro ao escrever no arquivo de log: %v\n", err)
	}
}
