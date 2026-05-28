package main

import (
	"context"
	"database/sql"
	"encoding/base64"
	"fmt"
	"log"
	"os"
	"os/exec"
	"strings"
	"time"

	"PainelRelatorios/config"
	"PainelRelatorios/database"
	"PainelRelatorios/models"
	"PainelRelatorios/repository"
	"github.com/wailsapp/wails/v2/pkg/runtime"
)

// App struct
type App struct {
	ctx              context.Context
	db               *sql.DB
	sqliteDB         *sql.DB
	atendimentosRepo *repository.AtendimentoRepository
	settingsRepo     *repository.SettingsRepository
	userRepo         *repository.UserRepository
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
	a.userRepo = repository.NewUserRepository(a.db)

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

// PreviewAtendimentosPDF generates a temporary PDF and opens it
func (a *App) PreviewAtendimentosPDF(filter models.AtendimentoFilter) error {
	data, err := a.atendimentosRepo.FetchAtendimentos(filter)
	if err != nil {
		return fmt.Errorf("erro ao buscar dados: %v", err)
	}

	tempPath := os.TempDir() + fmt.Sprintf("/preview_atendimentos_%d.pdf", time.Now().Unix())
	
	err = repository.ExportAtendimentosToPDF(data, filter, tempPath)
	if err != nil {
		return fmt.Errorf("erro ao gerar PDF: %v", err)
	}

	return a.OpenFile(tempPath)
}

// ExportSummaryExcel exports a summary grouped by the specified field to an Excel file
func (a *App) ExportSummaryExcel(filter models.AtendimentoFilter, groupField string) (string, error) {
	data, err := a.atendimentosRepo.FetchAtendimentos(filter)
	if err != nil {
		return "", fmt.Errorf("erro ao buscar dados: %v", err)
	}

	path, err := runtime.SaveFileDialog(a.ctx, runtime.SaveDialogOptions{
		Title:           fmt.Sprintf("Salvar Relatório Sintético por %s (Excel)", groupField),
		DefaultFilename: fmt.Sprintf("sintetico_%s_%s.xlsx", strings.ToLower(groupField), time.Now().Format("20060102_150405")),
		Filters: []runtime.FileFilter{
			{DisplayName: "Excel Files (*.xlsx)", Pattern: "*.xlsx"},
		},
	})

	if err != nil || path == "" {
		return "", nil
	}

	err = repository.ExportSummaryToExcel(data, filter, path, groupField, filter.SortField, filter.SortOrder)
	if err != nil {
		return "", fmt.Errorf("erro ao gerar excel: %v", err)
	}

	return path, nil
}

// ExportSummaryPDF exports a summary grouped by the specified field to a PDF file
func (a *App) ExportSummaryPDF(filter models.AtendimentoFilter, groupField string) (string, error) {
	data, err := a.atendimentosRepo.FetchAtendimentos(filter)
	if err != nil {
		return "", fmt.Errorf("erro ao buscar dados: %v", err)
	}

	path, err := runtime.SaveFileDialog(a.ctx, runtime.SaveDialogOptions{
		Title:           fmt.Sprintf("Salvar Relatório Sintético por %s (PDF)", groupField),
		DefaultFilename: fmt.Sprintf("sintetico_%s_%s.pdf", strings.ToLower(groupField), time.Now().Format("20060102_150405")),
		Filters: []runtime.FileFilter{
			{DisplayName: "PDF Files (*.pdf)", Pattern: "*.pdf"},
		},
	})

	if err != nil || path == "" {
		return "", nil
	}

	err = repository.ExportSummaryToPDF(data, filter, path, groupField, filter.SortField, filter.SortOrder)
	if err != nil {
		return "", fmt.Errorf("erro ao gerar PDF: %v", err)
	}

	return path, nil
}

// PreviewSummaryPDF generates a temporary PDF summary and opens it
func (a *App) PreviewSummaryPDF(filter models.AtendimentoFilter, groupField string) error {
	data, err := a.atendimentosRepo.FetchAtendimentos(filter)
	if err != nil {
		return fmt.Errorf("erro ao buscar dados: %v", err)
	}

	tempPath := os.TempDir() + fmt.Sprintf("/preview_sintetico_%s_%d.pdf", strings.ToLower(groupField), time.Now().Unix())
	
	err = repository.ExportSummaryToPDF(data, filter, tempPath, groupField, filter.SortField, filter.SortOrder)
	if err != nil {
		return fmt.Errorf("erro ao gerar PDF: %v", err)
	}

	return a.OpenFile(tempPath)
}

// GetAtendimentosPDFBase64 returns the analytic report PDF as a base64 string
func (a *App) GetAtendimentosPDFBase64(filter models.AtendimentoFilter) (string, error) {
	data, err := a.atendimentosRepo.FetchAtendimentos(filter)
	if err != nil {
		return "", fmt.Errorf("erro ao buscar dados: %v", err)
	}

	buf, err := repository.GetAtendimentosPDFBuffer(data, filter)
	if err != nil {
		return "", fmt.Errorf("erro ao gerar PDF: %v", err)
	}

	return base64.StdEncoding.EncodeToString(buf), nil
}

// GetSummaryPDFBase64 returns the synthetic report PDF as a base64 string
func (a *App) GetSummaryPDFBase64(filter models.AtendimentoFilter, groupField string) (string, error) {
	data, err := a.atendimentosRepo.FetchAtendimentos(filter)
	if err != nil {
		return "", fmt.Errorf("erro ao buscar dados: %v", err)
	}

	buf, err := repository.GetSummaryPDFBuffer(data, filter, groupField, filter.SortField, filter.SortOrder)
	if err != nil {
		return "", fmt.Errorf("erro ao gerar PDF: %v", err)
	}

	return base64.StdEncoding.EncodeToString(buf), nil
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
	err := os.WriteFile(config.GetConfigPath(), []byte(content), 0644)
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
	a.userRepo = repository.NewUserRepository(a.db)
	return "Configuração aplicada com sucesso!", nil
}

// Login authenticates a user
func (a *App) Login(username, password string) (*models.User, error) {
	if a.userRepo == nil {
		return nil, fmt.Errorf("repositório de usuários não inicializado")
	}
	return a.userRepo.Login(username, password)
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

// SaveFilterPreset saves a named filter configuration to SQLite with ownership info
func (a *App) SaveFilterPreset(name string, filter interface{}, userID int, userName string) error {
	if a.settingsRepo == nil {
		return fmt.Errorf("repositório de configurações não inicializado")
	}
	return a.settingsRepo.SaveFilterPreset(name, filter, userID, userName)
}


// GetFilterPresets returns all saved filter configurations
func (a *App) GetFilterPresets() ([]repository.FilterPreset, error) {
	if a.settingsRepo == nil {
		return nil, fmt.Errorf("repositório de configurações não inicializado")
	}
	return a.settingsRepo.GetFilterPresets()
}

// DeleteFilterPreset removes a saved filter configuration
func (a *App) DeleteFilterPreset(name string, userID int) error {
	if a.settingsRepo == nil {
		return fmt.Errorf("repositório de configurações não inicializado")
	}
	return a.settingsRepo.DeleteFilterPreset(name, userID)
}

// Greet returns a greeting for the given name
func (a *App) Greet(name string) string {
	return fmt.Sprintf("Hello %s, It's show time!", name)
}
