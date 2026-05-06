# Phase 4 Research: Export Libraries in Go

## Objective
Identify the most suitable libraries for exporting data to Excel (.xlsx) and PDF formats in a Go/Wails application.

## Excel Export
**Chosen Library**: `github.com/xuri/excelize/v2`
- **Why**: It is the de-facto standard for reading and writing Excel files in Go. It supports all modern XLSX features, is highly performant, and actively maintained.
- **Usage**: Create a new file, create sheets, iterate over the `models.Atendimento` slice, and set cell values. Finally, save the file to a buffer or directly to a path.

## PDF Export
**Chosen Library**: `github.com/go-pdf/fpdf`
- **Why**: It is the actively maintained community fork of the popular but archived `jung-kurt/gofpdf`. It allows for programmatic generation of PDF documents, including tables, formatting, and fonts, which is perfect for tabular reports.
- **Alternative**: `github.com/johnfercher/maroto` (built on top of fpdf, grid-based layout). We will use `fpdf` directly as it provides enough control for a simple data grid report without adding heavy abstractions.

## Implementation approach in Wails
Since this is a desktop app, the typical flow is:
1. Frontend calls a Go method (e.g., `ExportExcel(filters)`) via Wails bindings.
2. Go backend fetches the data using the filters.
3. Go backend prompts the user for a save location using Wails' `runtime.SaveFileDialog`.
4. Go backend generates the Excel/PDF file and writes it to the chosen path.
5. Go backend returns success/failure to the frontend.
