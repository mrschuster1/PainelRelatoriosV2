---
phase: 4
plan: 2
wave: 2
---

# Plan 4.2: PDF Export Integration

## Objective
Implementar a funcionalidade de exportação dos dados do relatório para o formato PDF.

## Context
- repository/export_service.go
- app.go
- frontend/src/components/DataGrid.tsx

## Tasks

<task type="auto">
  <name>Implement PDF Generation Logic</name>
  <files>go.mod, repository/export_service.go</files>
  <action>
    - Executar `go get github.com/go-pdf/fpdf`.
    - Em `repository/export_service.go` (ou arquivo equivalente), implementar a função que recebe `[]models.Atendimento` e o caminho do arquivo, gerando um documento PDF tabular formatado.
    - Cuidar para configurar as larguras das colunas para que todas as informações essenciais caibam na página (sugestão: layout A4 paisagem).
  </action>
  <verify>grep -q "github.com/go-pdf/fpdf" go.mod && echo "Success"</verify>
  <done>Módulo fpdf adicionado e função de geração tabular de PDF implementada.</done>
</task>

<task type="auto">
  <name>Bind PDF Export to Wails and Frontend</name>
  <files>app.go, frontend/src/components/DataGrid.tsx</files>
  <action>
    - Em `app.go`, criar o método `ExportAtendimentosPDF(filters models.AtendimentoFilter)` seguindo a mesma lógica do Excel (buscar dados, `runtime.SaveFileDialog`, salvar PDF).
    - Atualizar os bindings no frontend.
    - Adicionar um novo botão "Exportar PDF" ao lado do botão de Excel no `DataGrid.tsx`.
    - Ligar o botão à função Wails gerada.
  </action>
  <verify>grep -q "ExportAtendimentosPDF" app.go && echo "Success"</verify>
  <done>Frontend possui os botões de exportação e a geração de PDF é acionada corretamente.</done>
</task>

## Success Criteria
- [ ] Biblioteca de PDF integrada no Go.
- [ ] Exportação gera arquivo PDF válido, layout paisagem e colunas alinhadas.
- [ ] Frontend permite exportar PDF a partir da tela de listagem.
