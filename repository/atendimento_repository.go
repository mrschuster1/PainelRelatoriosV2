package repository

import (
	"database/sql"
	"fmt"

	"PainelRelatorios/models"
)

type AtendimentoRepository struct {
	db *sql.DB
}

func NewAtendimentoRepository(db *sql.DB) *AtendimentoRepository {
	return &AtendimentoRepository{
		db: db,
	}
}

func (r *AtendimentoRepository) FetchAtendimentos(filter models.AtendimentoFilter) ([]models.Atendimento, error) {
	var atendimentos []models.Atendimento

	// Base query using joins to get names instead of IDs
	query := `SELECT 
		a.Id, 
		IFNULL(c.Nome, ''), 
		IFNULL(a.Pessoa, ''),
		IFNULL(a.Categoria, ''), 
		IFNULL(a.Acao, ''),
		a.Fechado, 
		a.DataAbertura, 
		IFNULL(a.Hora, ''),
		a.DataFechamento, 
		IFNULL(u.Nome, ''),
		IFNULL(cel.Celula, ''),
		IFNULL(c.Sistema, ''),
		IFNULL(a.Historico, '')
	FROM atendimentos a
	LEFT JOIN clientes c ON a.Cliente = c.Id
	LEFT JOIN usuarios u ON a.UserAtribuido = u.Id
	LEFT JOIN celulas cel ON a.Setor = cel.Id
	WHERE 1=1`
	var args []interface{}

	if len(filter.Atendentes) > 0 {
		query += ` AND a.UserAtribuido IN (`
		for i, id := range filter.Atendentes {
			if i > 0 { query += "," }
			query += "?"
			args = append(args, id)
		}
		query += `)`
	}

	if len(filter.Clientes) > 0 {
		query += ` AND a.Cliente IN (`
		for i, id := range filter.Clientes {
			if i > 0 { query += "," }
			query += "?"
			args = append(args, id)
		}
		query += `)`
	}

	if len(filter.Sistemas) > 0 {
		query += ` AND c.Sistema IN (`
		for i, id := range filter.Sistemas {
			if i > 0 { query += "," }
			query += "?"
			args = append(args, id)
		}
		query += `)`
	}

	if len(filter.Categorias) > 0 {
		query += ` AND a.Categoria IN (`
		for i, id := range filter.Categorias {
			if i > 0 { query += "," }
			query += "?"
			args = append(args, id)
		}
		query += `)`
	}

	if len(filter.Setores) > 0 {
		query += ` AND a.Setor IN (`
		for i, id := range filter.Setores {
			if i > 0 { query += "," }
			query += "?"
			args = append(args, id)
		}
		query += `)`
	}

	if len(filter.Acoes) > 0 {
		query += ` AND a.Acao IN (`
		for i, id := range filter.Acoes {
			if i > 0 { query += "," }
			query += "?"
			args = append(args, id)
		}
		query += `)`
	}

	if len(filter.Unidades) > 0 {
		query += ` AND c.Unidade IN (`
		for i, id := range filter.Unidades {
			if i > 0 { query += "," }
			query += "?"
			args = append(args, id)
		}
		query += `)`
	}

	if filter.DataInicio != "" {
		dateCol := "a.Data"
		switch filter.TipoData {
		case "Fechamento":
			dateCol = "a.DataFechamento"
		case "Abertura":
			dateCol = "DATE(a.DataAbertura)"
		case "Atribuicao":
			dateCol = "DATE(a.DataAtribuicao)"
		}
		query += fmt.Sprintf(" AND %s >= ?", dateCol)
		args = append(args, filter.DataInicio)
	}

	if filter.DataFim != "" {
		dateCol := "a.Data"
		switch filter.TipoData {
		case "Fechamento":
			dateCol = "a.DataFechamento"
		case "Abertura":
			dateCol = "DATE(a.DataAbertura)"
		case "Atribuicao":
			dateCol = "DATE(a.DataAtribuicao)"
		}
		query += fmt.Sprintf(" AND %s <= ?", dateCol)
		args = append(args, filter.DataFim)
	}

	query += ` ORDER BY a.Id DESC LIMIT 1000`

	if r.db == nil {
		return nil, fmt.Errorf("conexão com o banco de dados não inicializada")
	}

	LogSQL(query, args...)
	rows, err := r.db.Query(query, args...)
	if err != nil {
		return nil, fmt.Errorf("erro ao buscar atendimentos: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var a models.Atendimento
		err := rows.Scan(
			&a.ID,
			&a.Cliente,
			&a.Pessoa,
			&a.Categoria,
			&a.Acao,
			&a.Fechado,
			&a.DataAbertura,
			&a.HoraAbertura,
			&a.DataFechamento,
			&a.Atendente,
			&a.Setor,
			&a.Sistema,
			&a.Historico,
		)
		if err != nil {
			return nil, fmt.Errorf("erro ao escanear atendimento: %v", err)
		}
		atendimentos = append(atendimentos, a)
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	if atendimentos == nil {
		atendimentos = []models.Atendimento{}
	}

	return atendimentos, nil
}

func (r *AtendimentoRepository) GetLookupOptions(table string, valueField string, labelField string) ([]models.LookupOption, error) {
	var options []models.LookupOption
	query := fmt.Sprintf("SELECT DISTINCT %s, %s FROM %s WHERE %s != '' ORDER BY %s", valueField, labelField, table, labelField, labelField)

	LogSQL(query)
	rows, err := r.db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		var opt models.LookupOption
		if err := rows.Scan(&opt.ID, &opt.Label); err != nil {
			return nil, err
		}
		options = append(options, opt)
	}
	return options, nil
}

func (r *AtendimentoRepository) SearchClientes(term string) ([]models.LookupOption, error) {
	var options []models.LookupOption
	query := `SELECT Id, Nome FROM clientes 
	          WHERE Nome LIKE ? OR RazaoSocial LIKE ? OR Id = ? OR CpfCnpj LIKE ?
	          LIMIT 50`
	
	LogSQL(query, "%"+term+"%", "%"+term+"%", term, "%"+term+"%")
	rows, err := r.db.Query(query, "%"+term+"%", "%"+term+"%", term, "%"+term+"%")
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		var opt models.LookupOption
		if err := rows.Scan(&opt.ID, &opt.Label); err != nil {
			return nil, err
		}
		options = append(options, opt)
	}
	return options, nil
}

func (r *AtendimentoRepository) FetchHistoricos(atendimentoID int) ([]models.HistoricoAtendimento, error) {
	var historicos []models.HistoricoAtendimento
	query := `SELECT Id, Atendimento, IFNULL(Data, ''), IFNULL(Hora, ''), IFNULL(HistAcao, ''), IFNULL(Historico, '') 
	          FROM historicos 
	          WHERE Atendimento = ? 
	          ORDER BY Data DESC, Hora DESC`

	LogSQL(query, atendimentoID)
	rows, err := r.db.Query(query, atendimentoID)
	if err != nil {
		return nil, fmt.Errorf("erro ao buscar historicos: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var h models.HistoricoAtendimento
		err := rows.Scan(&h.ID, &h.Atendimento, &h.Data, &h.Hora, &h.HistAcao, &h.Historico)
		if err != nil {
			return nil, err
		}
		historicos = append(historicos, h)
	}
	return historicos, nil
}
