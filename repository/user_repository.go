package repository

import (
	"database/sql"
	"fmt"
	"PainelRelatorios/models"
)

type UserRepository struct {
	db *sql.DB
}

func NewUserRepository(db *sql.DB) *UserRepository {
	return &UserRepository{db: db}
}

func (r *UserRepository) Login(username, password string) (*models.User, error) {
	if r.db == nil {
		return nil, fmt.Errorf("banco de dados não conectado")
	}

	query := "SELECT Id, Nome, Ativo FROM usuarios WHERE Nome = ? AND Senha = ? AND Ativo = 'S'"
	
	var user models.User
	err := r.db.QueryRow(query, username, password).Scan(&user.ID, &user.Nome, &user.Ativo)
	
	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("usuário ou senha inválidos")
	}
	
	if err != nil {
		return nil, fmt.Errorf("erro ao realizar login: %v", err)
	}

	return &user, nil
}
