# DECISIONS.md

## ADR 001: Initial Architecture
- **Date**: 2026-05-06
- **Decision**: Usar Wails com Go para o backend e um frontend web para renderizar relatórios do MySQL 5. Acesso direto via root/admin, sem intermediário backend web, já que é de uso interno.
- **Rationale**: Requisito de aplicação desktop rápida e bonita (Wails atende perfeitamente) para equipe interna sem dashboard inicialmente, focada apenas em relatórios com grids e exportação.
