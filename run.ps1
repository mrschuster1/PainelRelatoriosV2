# Script para Rebuild Automático
$processName = "PainelRelatoriosV2"
$exePath = "build\bin\PainelRelatoriosV2.exe"

Write-Host "--- Encerrando processo antigo ($processName)..." -ForegroundColor Yellow
Stop-Process -Name $processName -ErrorAction SilentlyContinue

Write-Host "--- Iniciando Wails Build..." -ForegroundColor Cyan
wails build

if ($LASTEXITCODE -eq 0) {
    Write-Host "--- Build concluído com sucesso! Abrindo aplicativo..." -ForegroundColor Green
    Start-Process $exePath -WorkingDirectory "$PSScriptRoot\build\bin"
} else {
    Write-Host "--- Erro no build. Verifique as mensagens acima." -ForegroundColor Red
}
