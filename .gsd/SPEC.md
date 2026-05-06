# SPEC.md — Project Specification

> **Status**: `FINALIZED`

## Vision
Desenvolver uma ferramenta desktop rápida e com design moderno para geração de relatórios de um sistema de helpdesk. A aplicação permitirá que a equipe interna extraia, visualize e exporte dados de atendimentos com agilidade, conectando-se diretamente ao banco de dados legado MySQL 5.

## Goals
1. Construir uma aplicação Desktop utilizando **Wails** e **Go**, garantindo performance e uma interface bonita (HTML/CSS/JS).
2. Conectar-se diretamente ao banco de dados MySQL 5 do sistema de helpdesk.
3. Disponibilizar um relatório "Geral de Atendimentos" com visualização em Grid na tela.
4. Oferecer múltiplas opções de filtros avançados para esse relatório.
5. Permitir a exportação dos dados filtrados para os formatos Excel (.xlsx) e PDF.

## Non-Goals (Out of Scope)
- Criação de dashboards gráficos (gráficos de pizza, barras, etc.) nesta primeira versão.
- Acesso para clientes finais (uso estritamente interno).
- Alteração ou inserção de dados no banco (a ferramenta tem como foco inicial apenas a leitura e extração de relatórios).

## Users
- Equipe interna (Gerentes, Supervisores e Atendentes) que precisam analisar e extrair dados de suporte.

## Constraints
- **Banco de Dados:** MySQL 5.
- **Backend:** Go (Golang).
- **Frontend/Desktop:** Wails (tecnologia web embarcada).
- Permissões do banco: Utilizará acesso direto (podendo ser root).

## Success Criteria
- [ ] A aplicação compila e roda como um executável desktop (Windows).
- [ ] Conexão com o MySQL 5 é estabelecida com sucesso.
- [ ] O relatório de Atendimentos exibe os dados no grid corretamente.
- [ ] Os filtros aplicados no frontend refletem as consultas dinâmicas no banco.
- [ ] É possível exportar a visualização atual do grid para Excel.
- [ ] É possível exportar a visualização atual do grid para PDF.
