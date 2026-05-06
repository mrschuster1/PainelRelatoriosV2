package main

import (
	"context"
	"database/sql"
	"fmt"
	"log"
	"time"

	"PainelRelatorios/config"
	"PainelRelatorios/database"
	"PainelRelatorios/models"
	"PainelRelatorios/repository"
	"github.com/wailsapp/wails/v2/pkg/runtime"
	"os"
	"os/exec"
)

// App struct
type App struct {
	ctx              context.Context
	db               *sql.DB
	sqliteDB         *sql.DB
	atendimentosRepo *repository.AtendimentoRepository
	settingsRepo     *repository.SettingsRepository
}

// NewApp creates a new App application struct
func NewApp() *App {
	return &App{}
}

// startup is called when the app starts. The context is saved
// so we can call the runtime methods
func (a *App) startup(ctx context.Context) {
	a.ctx = ctx

	// Connect to main MySQL DB
	db, err := database.Connect()
	if err != nil {
		log.Printf("Erro ao conectar ao banco de dados MySQL: %v\n", err)
	}
	a.db = db
	a.atendimentosRepo = repository.NewAtendimentoRepository(a.db)

	// Connect to local SQLite DB for settings
	sqldb, err := database.ConnectSQLite()
	if err != nil {
		log.Printf("Erro ao conectar ao banco SQLite: %v\n", err)
	}
	a.sqliteDB = sqldb
	a.settingsRepo = repository.NewSettingsRepository(a.sqliteDB)
}

// shutdown is called when the app closes
func (a *App) shutdown(ctx context.Context) {
	if a.db != nil {
		a.db.Close()
		log.Println("Conexão com MySQL fechada.")
	}
	if a.sqliteDB != nil {
		a.sqliteDB.Close()
		log.Println("Conexão com SQLite fechada.")
	}
}

// GetAtendimentos fetches the atendimentos based on the provided filter
func (a *App) GetAtendimentos(filter models.AtendimentoFilter) ([]models.Atendimento, error) {
	if a.atendimentosRepo == nil {
		return nil, fmt.Errorf("repositório não inicializado")
	}
	return a.atendimentosRepo.FetchAtendimentos(filter)
}

// ExportAtendimentosExcel exports the filtered atendimentos to an Excel file
func (a *App) ExportAtendimentosExcel(filter models.AtendimentoFilter) (string, error) {
	data, err := a.atendimentosRepo.FetchAtendimentos(filter)
	if err != nil {
		return "", fmt.Errorf("erro ao buscar dados: %v", err)
	}

	path, err := runtime.SaveFileDialog(a.ctx, runtime.SaveDialogOptions{
		Title:           "Salvar Relatório Excel",
		DefaultFilename: fmt.Sprintf("relatorio_atendimentos_%s.xlsx", time.Now().Format("20060102_150405")),
		Filters: []runtime.FileFilter{
			{DisplayName: "Excel Files (*.xlsx)", Pattern: "*.xlsx"},
		},
	})

	if err != nil || path == "" {
		return "", nil
	}

	err = repository.ExportAtendimentosToExcel(data, filter, path)
	if err != nil {
		return "", fmt.Errorf("erro ao gerar excel: %v", err)
	}

	return path, nil
}

// ExportAtendimentosPDF exports the filtered atendimentos to a PDF file
func (a *App) ExportAtendimentosPDF(filter models.AtendimentoFilter) (string, error) {
	data, err := a.atendimentosRepo.FetchAtendimentos(filter)
	if err != nil {
		return "", fmt.Errorf("erro ao buscar dados: %v", err)
	}

	path, err := runtime.SaveFileDialog(a.ctx, runtime.SaveDialogOptions{
		Title:           "Salvar Relatório PDF",
		DefaultFilename: fmt.Sprintf("relatorio_atendimentos_%s.pdf", time.Now().Format("20060102_150405")),
		Filters: []runtime.FileFilter{
			{DisplayName: "PDF Files (*.pdf)", Pattern: "*.pdf"},
		},
	})

	if err != nil || path == "" {
		return "", nil
	}

	err = repository.ExportAtendimentosToPDF(data, filter, path)
	if err != nil {
		return "", fmt.Errorf("erro ao gerar PDF: %v", err)
	}

	return path, nil
}

// OpenFile opens a file with the default system handler
func (a *App) OpenFile(path string) error {
	if path == "" {
		return fmt.Errorf("caminho do arquivo vazio")
	}
	
	// Use Windows start command to open the file with its default handler
	cmd := exec.Command("cmd", "/c", "start", "", path)
	err := cmd.Start()
	if err != nil {
		// Fallback to Wails browser open URL with file protocol
		runtime.BrowserOpenURL(a.ctx, "file://"+path)
	}
	return nil
}

// IsDatabaseConfigured checks if the database is already configured via .env
func (a *App) IsDatabaseConfigured() bool {
	return os.Getenv("DB_NAME") != "" && os.Getenv("DB_USER") != ""
}

// TestDatabaseConfig attempts to connect to the database with the provided settings without saving them
func (a *App) TestDatabaseConfig(host, port, user, pass, name string) (string, error) {
	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?parseTime=true", user, pass, host, port, name)
	db, err := sql.Open("mysql", dsn)
	if err != nil {
		return "", fmt.Errorf("configuração de DSN inválida: %w", err)
	}
	defer db.Close()

	err = db.Ping()
	if err != nil {
		return "", fmt.Errorf("falha ao conectar ao banco: %w", err)
	}

	return "Conexão estabelecida com sucesso!", nil
}

// SaveDatabaseConfig saves the database configuration to a .env file and initializes the connection
func (a *App) SaveDatabaseConfig(host, port, user, pass, name string) (string, error) {
	content := fmt.Sprintf("DB_HOST=%s\nDB_PORT=%s\nDB_USER=%s\nDB_PASS=%s\nDB_NAME=%s\n", host, port, user, pass, name)
	err := os.WriteFile(".env", []byte(content), 0644)
	if err != nil {
		return "", fmt.Errorf("erro ao salvar arquivo .env: %w", err)
	}

	// Reload env
	config.LoadEnv()

	// Initialize connection
	db, err := database.Connect()
	if err != nil {
		return "", fmt.Errorf("erro ao conectar com as novas configurações: %w", err)
	}

	if a.db != nil {
		a.db.Close()
	}

	a.db = db
	a.atendimentosRepo = repository.NewAtendimentoRepository(a.db)
	return "Configuração aplicada com sucesso!", nil
}

// GetSistemas returns the list of available systems (from clientes table as requested)
func (a *App) GetSistemas() ([]models.LookupOption, error) {
	return a.atendimentosRepo.GetLookupOptions("clientes", "Sistema", "Sistema")
}

// GetAnalistas returns the list of available analysts
func (a *App) GetAnalistas() ([]models.LookupOption, error) {
	return a.atendimentosRepo.GetLookupOptions("usuarios", "Id", "Nome")
}

// GetCategorias returns the list of available categories
func (a *App) GetCategorias() ([]models.LookupOption, error) {
	return a.atendimentosRepo.GetLookupOptions("categorias", "Categoria", "Categoria")
}

// GetSetores returns the list of available sectors (cells)
func (a *App) GetSetores() ([]models.LookupOption, error) {
	return a.atendimentosRepo.GetLookupOptions("celulas", "Id", "Celula")
}

// GetAcoes returns the list of distinct actions from atendimentos
func (a *App) GetAcoes() ([]models.LookupOption, error) {
	return a.atendimentosRepo.GetLookupOptions("atendimentos", "Acao", "Acao")
}

// GetUnidades returns the list of distinct units from clients
func (a *App) GetUnidades() ([]models.LookupOption, error) {
	return a.atendimentosRepo.GetLookupOptions("clientes", "Unidade", "Unidade")
}

// SearchClientes searches for clients based on a term
func (a *App) SearchClientes(term string) ([]models.LookupOption, error) {
	return a.atendimentosRepo.SearchClientes(term)
}

// GetHistoricos returns the list of histories for a specific atendimento
func (a *App) GetHistoricos(atendimentoID int) ([]models.HistoricoAtendimento, error) {
	if a.atendimentosRepo == nil {
		return nil, fmt.Errorf("repositório não inicializado")
	}
	return a.atendimentosRepo.FetchHistoricos(atendimentoID)
}

// SaveFilterPreset saves a named filter configuration to SQLite
func (a *App) SaveFilterPreset(name string, filter models.AtendimentoFilter) error {
	if a.settingsRepo == nil {
		return fmt.Errorf("repositório de configurações não inicializado")
	}
	return a.settingsRepo.SaveFilterPreset(name, filter)
}

// GetFilterPresets returns all saved filter configurations
func (a *App) GetFilterPresets() ([]repository.FilterPreset, error) {
	if a.settingsRepo == nil {
		return nil, fmt.Errorf("repositório de configurações não inicializado")
	}
	return a.settingsRepo.GetFilterPresets()
}

// DeleteFilterPreset removes a saved filter configuration
func (a *App) DeleteFilterPreset(name string) error {
	if a.settingsRepo == nil {
		return fmt.Errorf("repositório de configurações não inicializado")
	}
	return a.settingsRepo.DeleteFilterPreset(name)
}

// Greet returns a greeting for the given name
func (a *App) Greet(name string) string {
	return fmt.Sprintf("Hello %s, It's show time!", name)
}
