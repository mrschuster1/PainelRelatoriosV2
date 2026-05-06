---
phase: 4
plan: 1
wave: 1
---

# Plan 4.1: Excel Export Integration

## Objective
Implementar a funcionalidade de exportação dos dados do relatório para o formato Excel (.xlsx).

## Context
- .gsd/SPEC.md
- repository/atendimento_repository.go
- app.go
- frontend/src/components/DataGrid.tsx

## Tasks

<task type="auto">
  <name>Implement Excel Generation Logic</name>
  <files>go.mod, repository/export_service.go</files>
  <action>
    - Executar `go get github.com/xuri/excelize/v2`.
    - Criar o pacote/arquivo `repository/export_service.go` (ou em um pacote separado `services`).
    - Implementar a função que recebe `[]models.Atendimento` e um caminho de arquivo, e gera uma planilha Excel estilizada com os dados.
  </action>
  <verify>grep -q "github.com/xuri/excelize/v2" go.mod && echo "Success"</verify>
  <done>Módulo excelize adicionado e função de geração de Excel implementada no backend.</done>
</task>

<task type="auto">
  <name>Bind Excel Export to Wails and Frontend</name>
  <files>app.go, frontend/src/components/DataGrid.tsx</files>
  <action>
    - Em `app.go`, criar o método `ExportAtendimentosExcel(filters models.AtendimentoFilter)` que: 1) Busca os dados via `a.repo.FetchAtendimentos`, 2) Chama `runtime.SaveFileDialog` para o usuário escolher onde salvar o arquivo, 3) Chama o serviço de exportação para gerar o arquivo nesse caminho, e 4) Retorna uma mensagem de sucesso/erro.
    - Atualizar os bindings no frontend executando `wails generate module`.
    - Modificar o botão "Exportar CSV" no `DataGrid.tsx` para chamar a função de exportação do Wails e mostrar notificações de sucesso/erro nativas ou via alert.
  </action>
  <verify>grep -q "ExportAtendimentosExcel" app.go && echo "Success"</verify>
  <done>Frontend consegue invocar a exportação e o arquivo Excel é gerado via Wails runtime.</done>
</task>

## Success Criteria
- [ ] Bibliotecas de Excel integradas no Go.
- [ ] Exportação gera arquivo XLSX válido com colunas corretas.
- [ ] Frontend possui botão que aciona a exportação, pedindo o local de salvamento (SaveFileDialog).
