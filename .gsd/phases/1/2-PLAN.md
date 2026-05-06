---
phase: 1
plan: 2
wave: 1
---

# Plan 1.2: Database Connection Setup

## Objective
Configurar a conexão com o banco de dados MySQL 5 utilizando a biblioteca `database/sql` e o driver `go-sql-driver/mysql`.

## Context
- .gsd/SPEC.md

## Tasks

<task type="auto">
  <name>Configure MySQL Driver</name>
  <files>go.mod, database/db.go</files>
  <action>
    - Adicionar a dependência `github.com/go-sql-driver/mysql`.
    - Criar o pacote `database` com a função de conexão `Connect()`.
    - A função deve ler a string de conexão das variáveis de ambiente (ex: DB_USER, DB_PASS, DB_HOST, DB_PORT, DB_NAME).
  </action>
  <verify>go build ./database</verify>
  <done>O pacote de conexão compila e exporta um objeto db válido.</done>
</task>

<task type="auto">
  <name>Bind Database to Wails App</name>
  <files>app.go, main.go</files>
  <action>
    - Conectar ao banco durante a inicialização (startup) do Wails.
    - Injetar o contexto ou a conexão no struct `App`.
    - Garantir o fechamento da conexão (db.Close) no método de shutdown.
  </action>
  <verify>go build ./...</verify>
  <done>Ciclo de vida do banco integrado ao lifecycle do Wails perfeitamente.</done>
</task>

## Success Criteria
- [ ] Pacote database criado.
- [ ] Conexão ao MySQL gerenciada pelo App struct do Wails e pronta para uso nas próximas fases.
