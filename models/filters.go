package models

type AtendimentoFilter struct {
	DataInicio string   `json:"dataInicio"`
	DataFim    string   `json:"dataFim"`
	TipoData   string   `json:"tipoData"` // "Abertura", "Fechamento", "Atribuicao"
	Atendentes []string `json:"atendentes"`
	Clientes   []string `json:"clientes"` // IDs for multi-select
	Sistemas   []string `json:"sistemas"`
	Categorias []string `json:"categorias"`
	Setores    []string `json:"setores"`
	Acoes      []string `json:"acoes"` // Multiple actions/status
	Unidades   []string `json:"unidades"`
	GroupBy    string   `json:"groupBy"`
}

type LookupOption struct {
	ID    string `json:"id"`
	Label string `json:"label"`
}
