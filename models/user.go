package models

type User struct {
	ID    int    `json:"id"`
	Nome  string `json:"nome"`
	Senha string `json:"senha"`
	Ativo string `json:"ativo"`
}
