package models

import "time"

type Atendimento struct {
	ID             int        `json:"id"`
	Cliente        string     `json:"cliente"`
	Pessoa         string     `json:"pessoa"`
	Categoria      string     `json:"categoria"`
	Acao           string     `json:"acao"`
	Fechado        string     `json:"fechado"`
	DataAbertura   *time.Time `json:"dataAbertura"`
	HoraAbertura   string     `json:"horaAbertura"`
	DataFechamento *time.Time `json:"dataFechamento"`
	Atendente      string     `json:"atendente"`
	Setor          string     `json:"setor"`
	Sistema        string     `json:"sistema"`
	Historico      string     `json:"historico"`
}

type HistoricoAtendimento struct {
	ID          int    `json:"id"`
	Atendimento int    `json:"atendimento"`
	Data        string `json:"data"`
	Hora        string `json:"hora"`
	HistAcao    string `json:"histAcao"`
	Historico   string `json:"historico"`
}
