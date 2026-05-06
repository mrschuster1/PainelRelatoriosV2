package repository

import (
	"fmt"
	"os"
	"strings"
	"time"

	"PainelRelatorios/models"
	"github.com/go-pdf/fpdf"
	"github.com/xuri/excelize/v2"
)

func ExportAtendimentosToExcel(data []models.Atendimento, filter models.AtendimentoFilter, filePath string) error {
	f := excelize.NewFile()
	defer f.Close()

	sheetName := "Relatorio"
	f.SetSheetName("Sheet1", sheetName)

	formatDateBr := func(dateStr string) string {
		if dateStr == "" {
			return ""
		}
		t, err := time.Parse("2006-01-02", dateStr)
		if err == nil {
			return t.Format("02/01/2006")
		}
		return dateStr
	}

	// Filter Information at the top
	f.SetCellValue(sheetName, "A1", "RELATÓRIO DE ATENDIMENTOS")
	titleStyle, _ := f.NewStyle(&excelize.Style{
		Font: &excelize.Font{Bold: true, Size: 16},
	})
	f.SetCellStyle(sheetName, "A1", "A1", titleStyle)

	f.SetCellValue(sheetName, "A2", fmt.Sprintf("Gerado em: %s", time.Now().Format("02/01/2006 15:04")))
	
	filtersText := ""
	if filter.DataInicio != "" || filter.DataFim != "" {
		filtersText += fmt.Sprintf("Período (%s): %s a %s | ", filter.TipoData, formatDateBr(filter.DataInicio), formatDateBr(filter.DataFim))
	}
	if len(filter.Sistemas) > 0 { filtersText += fmt.Sprintf("Sistemas: %s | ", strings.Join(filter.Sistemas, ", ")) }
	if filtersText == "" { filtersText = "Filtros: Todos os registros" } else { filtersText = "Filtros: " + filtersText[:len(filtersText)-3] }
	
	f.SetCellValue(sheetName, "A3", filtersText)
	f.SetRowHeight(sheetName, 3, 25)

	// Headers (starting at row 5)
	startRow := 5
	headers := []string{"Cliente", "Pessoa", "Categoria", "Ação", "Setor", "Sistema", "Abertura", "Atendente"}
	for i, header := range headers {
		cell, _ := excelize.CoordinatesToCellName(i+1, startRow)
		f.SetCellValue(sheetName, cell, header)
	}

	// Styles for headers
	headerStyle, _ := f.NewStyle(&excelize.Style{
		Font: &excelize.Font{Bold: true, Color: "FFFFFF"},
		Fill: excelize.Fill{Type: "pattern", Color: []string{"332529"}, Pattern: 1},
	})
	f.SetRowStyle(sheetName, startRow, startRow, headerStyle)

	// Data
	for i, item := range data {
		row := i + startRow + 1

		f.SetCellValue(sheetName, fmt.Sprintf("A%d", row), item.Cliente)
		f.SetCellValue(sheetName, fmt.Sprintf("B%d", row), item.Pessoa)
		f.SetCellValue(sheetName, fmt.Sprintf("C%d", row), item.Categoria)
		f.SetCellValue(sheetName, fmt.Sprintf("D%d", row), item.Acao)
		f.SetCellValue(sheetName, fmt.Sprintf("E%d", row), item.Setor)
		f.SetCellValue(sheetName, fmt.Sprintf("F%d", row), item.Sistema)
		
		if item.DataAbertura != nil {
			f.SetCellValue(sheetName, fmt.Sprintf("G%d", row), item.DataAbertura.Format("02/01/2006 15:04"))
		}
		f.SetCellValue(sheetName, fmt.Sprintf("H%d", row), item.Atendente)
	}

	// Auto-fit columns
	f.SetColWidth(sheetName, "A", "A", 10)
	f.SetColWidth(sheetName, "B", "C", 30)
	f.SetColWidth(sheetName, "D", "G", 20)
	f.SetColWidth(sheetName, "H", "I", 20)

	if err := f.SaveAs(filePath); err != nil {
		return err
	}

	return nil
}

func ExportAtendimentosToPDF(data []models.Atendimento, filter models.AtendimentoFilter, filePath string) error {
	pdf := fpdf.New("L", "mm", "A4", "")
	pdf.SetTitle("Relatório de Atendimentos", true)
	
	tr := pdf.UnicodeTranslatorFromDescriptor("")

	// Configure Footer to be automatically generated on every page
	pdf.SetFooterFunc(func() {
		pdf.SetY(-15)
		pdf.SetFont("Arial", "I", 8)
		pdf.SetTextColor(150, 150, 150)
		pdf.CellFormat(0, 10, tr(fmt.Sprintf("Página %d", pdf.PageNo())), "", 0, "C", false, 0, "")
	})

	pdf.AddPage()

	// Primary Colors
	headerBgR, headerBgG, headerBgB := 33, 37, 41   // Dark Slate
	primaryR, primaryG, primaryB := 52, 152, 219    // Blue Accent
	textR, textG, textB := 73, 80, 87               // Dark Gray text
	
	// LOGO AND TITLE
	// Try to load logo from local file safely
	if _, err := os.Stat("icon.png"); err == nil {
		pdf.ImageOptions("icon.png", 10, 10, 15, 15, false, fpdf.ImageOptions{ImageType: "PNG", ReadDpi: true}, 0, "")
	} else if _, err := os.Stat("build/appicon.png"); err == nil {
		pdf.ImageOptions("build/appicon.png", 10, 10, 15, 15, false, fpdf.ImageOptions{ImageType: "PNG", ReadDpi: true}, 0, "")
	}
	
	pdf.SetFont("Arial", "B", 18)
	pdf.SetTextColor(headerBgR, headerBgG, headerBgB)
	pdf.SetXY(28, 10)
	pdf.CellFormat(0, 10, tr("RELATÓRIO DE ATENDIMENTOS"), "", 1, "L", false, 0, "")
	
	pdf.SetFont("Arial", "I", 9)
	pdf.SetTextColor(150, 150, 150)
	pdf.SetXY(28, 17)
	pdf.CellFormat(0, 6, tr(fmt.Sprintf("Gerado em %s", time.Now().Format("02/01/2006 às 15:04"))), "", 1, "L", false, 0, "")
	pdf.Ln(10)

	// FILTER INFO BOX
	pdf.SetFillColor(248, 249, 250) // Light Gray
	pdf.SetDrawColor(222, 226, 230)
	pdf.SetLineWidth(0.5)
	
	pdf.SetFont("Arial", "B", 10)
	pdf.SetTextColor(primaryR, primaryG, primaryB)
	pdf.CellFormat(0, 8, tr(" Filtros Aplicados"), "LTR", 1, "L", true, 0, "")
	
	pdf.SetFont("Arial", "", 9)
	pdf.SetTextColor(textR, textG, textB)
	
	formatDateBr := func(dateStr string) string {
		if dateStr == "" {
			return ""
		}
		t, err := time.Parse("2006-01-02", dateStr)
		if err == nil {
			return t.Format("02/01/2006")
		}
		return dateStr
	}

	// Header and Body colors
	headerBgR, headerBgG, headerBgB = 30, 58, 138 // Deep Blue #1E3A8A
	headerTextR, headerTextG, headerTextB := 255, 255, 255
	
	stripeR, stripeG, stripeB := 241, 245, 249 // Slate-50
	textR, textG, textB = 30, 41, 59       // Slate-800
	
	// COLUMN DEFINITIONS
	// Total width available in Landscape: ~277
	headers := []string{"Cliente / Categoria", "Pessoa", "Ação", "Setor", "Sistema", "Abertura", "Analista"}
	widths := []float64{75, 40, 45, 30, 30, 27, 30} // Sum = 277

	// FILTERS BOX
	pdf.SetFillColor(248, 250, 252)
	pdf.SetTextColor(71, 85, 105)
	pdf.SetFont("Arial", "B", 8)
	pdf.CellFormat(0, 6, tr(" CONFIGURAÇÃO DO RELATÓRIO"), "LTR", 1, "L", true, 0, "")
	
	pdf.SetFont("Arial", "", 8)
	filtersText := ""
	if len(filter.Clientes) > 0 { filtersText += fmt.Sprintf("Clientes: %d selec. | ", len(filter.Clientes)) }
	if len(filter.Sistemas) > 0 { filtersText += fmt.Sprintf("Sistemas: %s | ", strings.Join(filter.Sistemas, ", ")) }
	if len(filter.Atendentes) > 0 { filtersText += fmt.Sprintf("Atendentes: %s | ", strings.Join(filter.Atendentes, ", ")) }
	if filter.DataInicio != "" || filter.DataFim != "" {
		filtersText += fmt.Sprintf("Período (%s): %s a %s | ", filter.TipoData, formatDateBr(filter.DataInicio), formatDateBr(filter.DataFim))
	}
	if filtersText == "" { filtersText = "Todos os registros ativos." } else { filtersText = filtersText[:len(filtersText)-3] }
	
	pdf.MultiCell(0, 5, tr(" "+filtersText), "LBR", "L", true)
	pdf.Ln(4)

	renderHeader := func() {
		pdf.SetFont("Arial", "B", 9)
		pdf.SetFillColor(headerBgR, headerBgG, headerBgB)
		pdf.SetTextColor(headerTextR, headerTextG, headerTextB)
		for i, header := range headers {
			pdf.CellFormat(widths[i], 9, tr(header), "1", 0, "C", true, 0, "")
		}
		pdf.Ln(-1)
	}

	renderRow := func(i int, item models.Atendimento) {
		if i%2 == 0 { pdf.SetFillColor(255, 255, 255) } else { pdf.SetFillColor(stripeR, stripeG, stripeB) }
		pdf.SetTextColor(textR, textG, textB)
		pdf.SetFont("Arial", "", 8)

		abertura := ""
		if item.DataAbertura != nil { abertura = item.DataAbertura.Format("02/01/2006 15:04") }
		
		clienteFull := item.Cliente
		if item.Categoria != "" { clienteFull = fmt.Sprintf("%s (%s)", item.Cliente, item.Categoria) }

		pdf.CellFormat(widths[0], 8, tr(clienteFull), "LR", 0, "L", true, 0, "")
		pdf.CellFormat(widths[1], 8, tr(item.Pessoa), "LR", 0, "L", true, 0, "")
		pdf.CellFormat(widths[2], 8, tr(item.Acao), "LR", 0, "L", true, 0, "")
		pdf.CellFormat(widths[3], 8, tr(item.Setor), "LR", 0, "L", true, 0, "")
		pdf.CellFormat(widths[4], 8, tr(item.Sistema), "LR", 0, "C", true, 0, "")
		pdf.CellFormat(widths[5], 8, abertura, "LR", 0, "C", true, 0, "")
		pdf.CellFormat(widths[6], 8, tr(item.Atendente), "LR", 0, "L", true, 0, "")
		pdf.Ln(-1)
	}

	groupBy := filter.GroupBy
	
	if groupBy == "" {
		renderHeader()
		for i, item := range data {
			renderRow(i, item)
		}
		pdf.CellFormat(277, 0, "", "T", 1, "", false, 0, "")
	} else {
		groupedData := make(map[string][]models.Atendimento)
		var groupsOrdered []string
		
		getGroupValue := func(item models.Atendimento, field string) string {
			switch strings.ToLower(field) {
			case "cliente": return item.Cliente
			case "pessoa": return item.Pessoa
			case "acao": return item.Acao
			case "setor": return item.Setor
			case "sistema": return item.Sistema
			case "atendente", "analista": return item.Atendente
			case "categoria": return item.Categoria
			default: return item.Atendente
			}
		}

		for _, item := range data {
			val := getGroupValue(item, groupBy)
			if val == "" { val = "Não Informado" }
			if _, exists := groupedData[val]; !exists {
				groupsOrdered = append(groupsOrdered, val)
			}
			groupedData[val] = append(groupedData[val], item)
		}

		for _, groupName := range groupsOrdered {
			// Group Header
			pdf.SetFont("Arial", "B", 10)
			pdf.SetFillColor(236, 253, 245) // Emerald-50
			pdf.SetTextColor(5, 150, 105)   // Emerald-600
			pdf.CellFormat(0, 10, tr(fmt.Sprintf("  %s: %s (%d atendimentos)", filter.GroupBy, groupName, len(groupedData[groupName]))), "1", 1, "L", true, 0, "")
			
			renderHeader()
			for i, item := range groupedData[groupName] {
				renderRow(i, item)
			}
			pdf.Ln(4)
		}
	}

	err := pdf.OutputFileAndClose(filePath)
	if err != nil {
		fmt.Printf("Erro ao salvar PDF: %v\n", err)
		return err
	}
	return nil
}
