# ROADMAP.md

> **Current Phase**: Not started
> **Milestone**: v1.0

## Must-Haves (from SPEC)
- [ ] Interface Desktop rápida e bonita utilizando Wails + Go
- [ ] Conexão direta com MySQL 5
- [ ] Grid de visualização do relatório "Geral de Atendimentos"
- [ ] Múltiplos filtros dinâmicos na tela
- [ ] Exportação para Excel (.xlsx)
- [ ] Exportação para PDF

## Phases

### Phase 1: Foundation
**Status**: ✅ Complete
**Objective**: Inicializar o projeto Wails, definir a estrutura de pastas e configurar a biblioteca de conexão com o banco MySQL 5.

### Phase 2: Core Data (Backend)
**Status**: ⬜ Not Started
**Objective**: Criar os repositórios em Go para conectar ao banco, mapear as entidades de "Atendimentos" e implementar a query dinâmica que aceita múltiplos filtros.

### Phase 3: UI & Grid (Frontend)
**Status**: ⬜ Not Started
**Objective**: Desenvolver a interface no Wails (escolher um framework web como React/Svelte), criar o painel de filtros e implementar a tabela de dados (Grid) com paginação/scroll infinito.

### Phase 4: Exports (Excel & PDF)
**Status**: ⬜ Not Started
**Objective**: Integrar bibliotecas no Go para geração de relatórios tabulares em Excel e PDF com base nos dados filtrados, e ligar essas ações aos botões da interface.
