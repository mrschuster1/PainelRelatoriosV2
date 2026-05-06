---
phase: 1
plan: 1
wave: 1
---

# Plan 1.1: Initialize Wails Project

## Objective
Inicializar o projeto base utilizando Wails e React-TS, além de configurar o suporte a variáveis de ambiente (.env) no Go.

## Context
- .gsd/SPEC.md
- .gsd/ROADMAP.md

## Tasks

<task type="auto">
  <name>Init Wails Project</name>
  <files>wails.json, frontend/package.json, main.go</files>
  <action>
    - Instalar a CLI do Wails caso não exista.
    - Executar `wails init -n app -t react-ts` e organizar os arquivos na raiz.
    - Adaptar o `main.go` e `wails.json` com o nome do projeto "Painel de Relatorios".
  </action>
  <verify>go build ./...</verify>
  <done>O projeto base do Wails deve compilar sem erros estruturais.</done>
</task>

<task type="auto">
  <name>Setup Godotenv</name>
  <files>main.go, config/env.go</files>
  <action>
    - Adicionar `github.com/joho/godotenv` ao `go.mod`.
    - Criar pacote `config` com função no Go para carregar o arquivo `.env`.
    - Chamar o load no início do `main.go` ou em `App.startup`.
  </action>
  <verify>go test ./config -v</verify>
  <done>A aplicação consegue ler variáveis de ambiente corretamente.</done>
</task>

## Success Criteria
- [ ] Projeto Wails estruturado com React e TypeScript.
- [ ] Carregamento de variáveis de ambiente configurado e testado.
