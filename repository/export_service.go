package repository

import (
	"fmt"
	"os"
	"strings"
	"time"

	"PainelRelatorios/models"
	"github.com/go-pdf/fpdf"
	"github.com/xuri/excelize/v2"
	"path/filepath"
	"PainelRelatorios/config"
)

func ExportAtendimentosToExcel(data []models.Atendimento, filter models.AtendimentoFilter, filePath string) error {
	f := excelize.NewFile()
	defer f.Close()

	sheetName := "Relatorio"
	f.SetSheetName("Sheet1", sheetName)

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
	if len(filter.Groups) > 0 { filtersText += fmt.Sprintf("Agrupado por: %s | ", strings.Join(filter.Groups, " > ")) }
	if filtersText == "" { filtersText = "Filtros: Todos os registros" } else { filtersText = "Filtros: " + filtersText[:len(filtersText)-3] }
	
	f.SetCellValue(sheetName, "A3", filtersText)
	f.SetRowHeight(sheetName, 3, 25)

	headers := []string{"Cliente", "Pessoa", "Categoria", "Ação", "Setor", "Sistema", "Abertura", "Atendente"}
	headerStyle, _ := f.NewStyle(&excelize.Style{
		Font: &excelize.Font{Bold: true, Color: "FFFFFF"},
		Fill: excelize.Fill{Type: "pattern", Color: []string{"332529"}, Pattern: 1},
	})
	
	currentRow := 5
	
	if len(filter.Groups) == 0 {
		// Normal headers
		for i, header := range headers {
			cell, _ := excelize.CoordinatesToCellName(i+1, currentRow)
			f.SetCellValue(sheetName, cell, header)
		}
		f.SetRowStyle(sheetName, currentRow, currentRow, headerStyle)
		currentRow++

		for _, item := range data {
			f.SetCellValue(sheetName, fmt.Sprintf("A%d", currentRow), item.Cliente)
			f.SetCellValue(sheetName, fmt.Sprintf("B%d", currentRow), item.Pessoa)
			f.SetCellValue(sheetName, fmt.Sprintf("C%d", currentRow), item.Categoria)
			f.SetCellValue(sheetName, fmt.Sprintf("D%d", currentRow), item.Acao)
			f.SetCellValue(sheetName, fmt.Sprintf("E%d", currentRow), item.Setor)
			f.SetCellValue(sheetName, fmt.Sprintf("F%d", currentRow), item.Sistema)
			if item.DataAbertura != nil {
				f.SetCellValue(sheetName, fmt.Sprintf("G%d", currentRow), item.DataAbertura.Format("02/01/2006 15:04"))
			}
			f.SetCellValue(sheetName, fmt.Sprintf("H%d", currentRow), item.Atendente)
			currentRow++
		}
	} else {
		// Grouped data
		groupField := filter.Groups[0]
		groupedData := make(map[string][]models.Atendimento)
		var groupsOrdered []string

		for _, item := range data {
			val := getAtendimentoValue(item, groupField)
			if val == "" { val = "Não Informado" }
			if _, exists := groupedData[val]; !exists {
				groupsOrdered = append(groupsOrdered, val)
			}
			groupedData[val] = append(groupedData[val], item)
		}

		groupStyle, _ := f.NewStyle(&excelize.Style{
			Font: &excelize.Font{Bold: true, Color: "059669"},
			Fill: excelize.Fill{Type: "pattern", Color: []string{"ECFDF5"}, Pattern: 1},
		})

		for _, groupName := range groupsOrdered {
			// Group Header
			f.SetCellValue(sheetName, fmt.Sprintf("A%d", currentRow), fmt.Sprintf("%s: %s (%d)", strings.ToUpper(groupField), groupName, len(groupedData[groupName])))
			f.MergeCell(sheetName, fmt.Sprintf("A%d", currentRow), fmt.Sprintf("H%d", currentRow))
			f.SetRowStyle(sheetName, currentRow, currentRow, groupStyle)
			currentRow++

			// Sub-headers
			for i, header := range headers {
				cell, _ := excelize.CoordinatesToCellName(i+1, currentRow)
				f.SetCellValue(sheetName, cell, header)
			}
			f.SetRowStyle(sheetName, currentRow, currentRow, headerStyle)
			currentRow++

			for _, item := range groupedData[groupName] {
				f.SetCellValue(sheetName, fmt.Sprintf("A%d", currentRow), item.Cliente)
				f.SetCellValue(sheetName, fmt.Sprintf("B%d", currentRow), item.Pessoa)
				f.SetCellValue(sheetName, fmt.Sprintf("C%d", currentRow), item.Categoria)
				f.SetCellValue(sheetName, fmt.Sprintf("D%d", currentRow), item.Acao)
				f.SetCellValue(sheetName, fmt.Sprintf("E%d", currentRow), item.Setor)
				f.SetCellValue(sheetName, fmt.Sprintf("F%d", currentRow), item.Sistema)
				if item.DataAbertura != nil {
					f.SetCellValue(sheetName, fmt.Sprintf("G%d", currentRow), item.DataAbertura.Format("02/01/2006 15:04"))
				}
				f.SetCellValue(sheetName, fmt.Sprintf("H%d", currentRow), item.Atendente)
				currentRow++
			}
			currentRow++ // Empty row between groups
		}
	}

	// Auto-fit columns
	f.SetColWidth(sheetName, "A", "A", 45)
	f.SetColWidth(sheetName, "B", "C", 30)
	f.SetColWidth(sheetName, "D", "G", 25)
	f.SetColWidth(sheetName, "H", "I", 25)

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
	iconPath := filepath.Join(config.GetAppPath(), "icon.png")
	buildIconPath := filepath.Join(config.GetAppPath(), "build", "appicon.png")
	if _, err := os.Stat(iconPath); err == nil {
		pdf.ImageOptions(iconPath, 10, 10, 15, 15, false, fpdf.ImageOptions{ImageType: "PNG", ReadDpi: true}, 0, "")
	} else if _, err := os.Stat(buildIconPath); err == nil {
		pdf.ImageOptions(buildIconPath, 10, 10, 15, 15, false, fpdf.ImageOptions{ImageType: "PNG", ReadDpi: true}, 0, "")
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
	if len(filter.Groups) > 0 { filtersText += fmt.Sprintf("Agrupado por: %s | ", strings.Join(filter.Groups, " > ")) }
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

	groups := filter.Groups
	
	getGroupValue := func(item models.Atendimento, field string) string {
		return getAtendimentoValue(item, field)
	}

	var renderGroupsRecursive func(level int, currentData []models.Atendimento)
	renderGroupsRecursive = func(level int, currentData []models.Atendimento) {
		if level >= len(groups) {
			renderHeader()
			for i, item := range currentData {
				renderRow(i, item)
			}
			pdf.CellFormat(277, 0, "", "T", 1, "", false, 0, "")
			return
		}

		groupField := groups[level]
		groupedData := make(map[string][]models.Atendimento)
		var groupsOrdered []string
		
		for _, item := range currentData {
			val := getGroupValue(item, groupField)
			if val == "" { val = "Não Informado" }
			if _, exists := groupedData[val]; !exists {
				groupsOrdered = append(groupsOrdered, val)
			}
			groupedData[val] = append(groupedData[val], item)
		}

		for _, groupName := range groupsOrdered {
			// Group Header
			pdf.SetFont("Arial", "B", 10-float64(level)*0.5)
			
			if level == 0 {
				pdf.SetFillColor(236, 253, 245) // Emerald-50
				pdf.SetTextColor(5, 150, 105)   // Emerald-600
			} else {
				pdf.SetFillColor(240, 249, 255) // Sky-50
				pdf.SetTextColor(2, 132, 199)   // Sky-600
			}

			indent := strings.Repeat("    ", level)
			pdf.CellFormat(0, 9, tr(fmt.Sprintf("%s %s: %s (%d atendimentos)", indent, groupField, groupName, len(groupedData[groupName]))), "1", 1, "L", true, 0, "")
			
			renderGroupsRecursive(level+1, groupedData[groupName])
			if level == 0 {
				pdf.Ln(2)
			}
		}
	}

	if len(groups) == 0 {
		renderHeader()
		for i, item := range data {
			renderRow(i, item)
		}
		pdf.CellFormat(277, 0, "", "T", 1, "", false, 0, "")
	} else {
		renderGroupsRecursive(0, data)
	}

	if err := pdf.OutputFileAndClose(filePath); err != nil {
		return err
	}
	return nil
}

func GetAtendimentosPDFBuffer(data []models.Atendimento, filter models.AtendimentoFilter) ([]byte, error) {
	pdf := fpdf.New("L", "mm", "A4", "")
	pdf.SetTitle("Relatório de Atendimentos", true)
	
	tr := pdf.UnicodeTranslatorFromDescriptor("")

	pdf.SetFooterFunc(func() {
		pdf.SetY(-15)
		pdf.SetFont("Arial", "I", 8)
		pdf.SetTextColor(150, 150, 150)
		pdf.CellFormat(0, 10, tr(fmt.Sprintf("Página %d", pdf.PageNo())), "", 0, "C", false, 0, "")
	})

	pdf.AddPage()

	headerBgR, headerBgG, headerBgB := 30, 58, 138 
	headerTextR, headerTextG, headerTextB := 255, 255, 255
	stripeR, stripeG, stripeB := 241, 245, 249
	textR, textG, textB := 30, 41, 59

	iconPath := filepath.Join(config.GetAppPath(), "icon.png")
	if _, err := os.Stat(iconPath); err == nil {
		pdf.ImageOptions(iconPath, 10, 10, 15, 15, false, fpdf.ImageOptions{ImageType: "PNG", ReadDpi: true}, 0, "")
	}

	pdf.SetFont("Arial", "B", 18)
	pdf.SetTextColor(33, 37, 41)
	pdf.SetXY(28, 10)
	pdf.CellFormat(0, 10, tr("RELATÓRIO DE ATENDIMENTOS"), "", 1, "L", false, 0, "")
	
	pdf.SetFont("Arial", "I", 9)
	pdf.SetTextColor(150, 150, 150)
	pdf.SetXY(28, 17)
	pdf.CellFormat(0, 6, tr(fmt.Sprintf("Gerado em %s", time.Now().Format("02/01/2006 às 15:04"))), "", 1, "L", false, 0, "")
	pdf.Ln(10)

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
	if len(filter.Groups) > 0 { filtersText += fmt.Sprintf("Agrupado por: %s | ", strings.Join(filter.Groups, " > ")) }
	if filtersText == "" { filtersText = "Todos os registros ativos." } else { filtersText = filtersText[:len(filtersText)-3] }

	pdf.MultiCell(0, 5, tr(" "+filtersText), "LBR", "L", true)
	pdf.Ln(4)

	headers := []string{"Cliente / Categoria", "Pessoa", "Ação", "Setor", "Sistema", "Abertura", "Analista"}
	widths := []float64{75, 40, 45, 30, 30, 27, 30}

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

	if len(filter.Groups) == 0 {
		renderHeader()
		for i, item := range data {
			renderRow(i, item)
		}
		pdf.CellFormat(277, 0, "", "T", 1, "", false, 0, "")
	} else {
		groupedData := make(map[string][]models.Atendimento)
		var groupsOrdered []string
		groupField := filter.Groups[0]

		for _, item := range data {
			val := getAtendimentoValue(item, groupField)
			if val == "" { val = "Não Informado" }
			if _, exists := groupedData[val]; !exists {
				groupsOrdered = append(groupsOrdered, val)
			}
			groupedData[val] = append(groupedData[val], item)
		}

		for _, groupName := range groupsOrdered {
			pdf.SetFont("Arial", "B", 10)
			pdf.SetFillColor(236, 253, 245)
			pdf.SetTextColor(5, 150, 105)
			pdf.CellFormat(0, 9, tr(fmt.Sprintf(" %s: %s (%d atendimentos)", groupField, groupName, len(groupedData[groupName]))), "1", 1, "L", true, 0, "")
			
			renderHeader()
			for i, item := range groupedData[groupName] {
				renderRow(i, item)
			}
			pdf.Ln(2)
		}
	}

	var buf strings.Builder
	err := pdf.Output(&buf)
	if err != nil {
		return nil, err
	}
	return []byte(buf.String()), nil
}





func getAtendimentoValue(item models.Atendimento, field string) string {
	switch strings.ToLower(field) {
	case "cliente":
		return item.Cliente
	case "pessoa":
		return item.Pessoa
	case "ação", "acao":
		return item.Acao
	case "setor":
		return item.Setor
	case "sistema":
		return item.Sistema
	case "atendente", "analista":
		return item.Atendente
	case "categoria":
		return item.Categoria
	default:
		return item.Atendente
	}
}

func ExportSummaryToExcel(data []models.Atendimento, filter models.AtendimentoFilter, filePath string, groupField string, sortField string, sortOrder string) error {
	f := excelize.NewFile()
	defer f.Close()

	sheetName := "Relatório Sintético"
	f.SetSheetName("Sheet1", sheetName)

	// Title
	f.SetCellValue(sheetName, "A1", fmt.Sprintf("RESUMO DE ATENDIMENTOS POR %s", strings.ToUpper(groupField)))
	titleStyle, _ := f.NewStyle(&excelize.Style{
		Font: &excelize.Font{Bold: true, Size: 16},
	})
	f.SetCellStyle(sheetName, "A1", "A1", titleStyle)

	f.SetCellValue(sheetName, "A2", fmt.Sprintf("Gerado em: %s", time.Now().Format("02/01/2006 15:04")))
	f.SetCellValue(sheetName, "A3", fmt.Sprintf("Filtros: %s", filtersTextSummary(filter)))

	// Headers
	startRow := 5
	f.SetCellValue(sheetName, "A5", groupField)
	f.SetCellValue(sheetName, "B5", "Total de Atendimentos")

	headerStyle, _ := f.NewStyle(&excelize.Style{
		Font: &excelize.Font{Bold: true, Color: "FFFFFF"},
		Fill: excelize.Fill{Type: "pattern", Color: []string{"1E3A8A"}, Pattern: 1},
		Alignment: &excelize.Alignment{Horizontal: "center", Vertical: "center"},
	})
	f.SetRowStyle(sheetName, startRow, startRow, headerStyle)
	f.SetRowHeight(sheetName, startRow, 20)

	// Process data
	summary := make(map[string]int)
	for _, item := range data {
		val := getAtendimentoValue(item, groupField)
		if val == "" {
			val = "Não Informado"
		}
		summary[val]++
	}

	// Sort logic
	var keys []string
	for k := range summary {
		keys = append(keys, k)
	}

	if sortField == "count" {
		if sortOrder == "ASC" {
			for i := 0; i < len(keys); i++ {
				for j := i + 1; j < len(keys); j++ {
					if summary[keys[i]] > summary[keys[j]] {
						keys[i], keys[j] = keys[j], keys[i]
					}
				}
			}
		} else {
			for i := 0; i < len(keys); i++ {
				for j := i + 1; j < len(keys); j++ {
					if summary[keys[i]] < summary[keys[j]] {
						keys[i], keys[j] = keys[j], keys[i]
					}
				}
			}
		}
	} else {
		if sortOrder == "DESC" {
			for i := 0; i < len(keys); i++ {
				for j := i + 1; j < len(keys); j++ {
					if keys[i] < keys[j] {
						keys[i], keys[j] = keys[j], keys[i]
					}
				}
			}
		} else {
			for i := 0; i < len(keys); i++ {
				for j := i + 1; j < len(keys); j++ {
					if keys[i] > keys[j] {
						keys[i], keys[j] = keys[j], keys[i]
					}
				}
			}
		}
	}

	// Write data
	totalGeral := 0
	for i, key := range keys {
		row := i + startRow + 1
		f.SetCellValue(sheetName, fmt.Sprintf("A%d", row), key)
		f.SetCellValue(sheetName, fmt.Sprintf("B%d", row), summary[key])
		totalGeral += summary[key]
	}

	// Footer total
	lastRow := len(keys) + startRow + 1
	f.SetCellValue(sheetName, fmt.Sprintf("A%d", lastRow), "TOTAL GERAL")
	f.SetCellValue(sheetName, fmt.Sprintf("B%d", lastRow), totalGeral)
	
	// Table body styles
	bodyStyle, _ := f.NewStyle(&excelize.Style{
		Alignment: &excelize.Alignment{Horizontal: "left", Vertical: "center"},
	})
	countStyle, _ := f.NewStyle(&excelize.Style{
		Alignment: &excelize.Alignment{Horizontal: "center", Vertical: "center"},
	})
	f.SetColStyle(sheetName, "A", bodyStyle)
	f.SetColStyle(sheetName, "B", countStyle)

	f.SetColWidth(sheetName, "A", "A", 50)
	f.SetColWidth(sheetName, "B", "B", 25)

	// Add auto-filter
	lastCellSummary, _ := excelize.CoordinatesToCellName(2, lastRow)
	f.AutoFilter(sheetName, fmt.Sprintf("A4:%s", lastCellSummary), []excelize.AutoFilterOptions{})

	// Freeze header
	f.SetPanes(sheetName, &excelize.Panes{
		Freeze:      true,
		YSplit:      5,
		TopLeftCell: "A6",
		ActivePane:  "bottomLeft",
	})

	if err := f.SaveAs(filePath); err != nil {
		return err
	}

	return nil
}

func ExportSummaryToPDF(data []models.Atendimento, filter models.AtendimentoFilter, filePath string, groupField string, sortField string, sortOrder string) error {
	pdf := fpdf.New("P", "mm", "A4", "") // Portrait for summary
	pdf.SetTitle(fmt.Sprintf("Resumo de Atendimentos por %s", groupField), true)
	
	tr := pdf.UnicodeTranslatorFromDescriptor("")

	pdf.SetFooterFunc(func() {
		pdf.SetY(-15)
		pdf.SetFont("Arial", "I", 8)
		pdf.SetTextColor(150, 150, 150)
		pdf.CellFormat(0, 10, tr(fmt.Sprintf("Página %d", pdf.PageNo())), "", 0, "C", false, 0, "")
	})

	pdf.AddPage()

	headerBgR, headerBgG, headerBgB := 30, 58, 138
	headerTextR, headerTextG, headerTextB := 255, 255, 255
	stripeR, stripeG, stripeB := 241, 245, 249

	// Title
	pdf.SetFont("Arial", "B", 16)
	pdf.SetTextColor(30, 41, 59)
	pdf.CellFormat(0, 10, tr(fmt.Sprintf("RESUMO DE ATENDIMENTOS POR %s", strings.ToUpper(groupField))), "", 1, "C", false, 0, "")
	
	pdf.SetFont("Arial", "I", 9)
	pdf.SetTextColor(150, 150, 150)
	pdf.CellFormat(0, 6, tr(fmt.Sprintf("Gerado em %s", time.Now().Format("02/01/2006 às 15:04"))), "", 1, "C", false, 0, "")
	pdf.Ln(10)

	// Summary data
	summary := make(map[string]int)
	for _, item := range data {
		val := getAtendimentoValue(item, groupField)
		if val == "" {
			val = "Não Informado"
		}
		summary[val]++
	}

	// Sort logic
	var keys []string
	for k := range summary {
		keys = append(keys, k)
	}

	if sortField == "count" {
		if sortOrder == "ASC" {
			for i := 0; i < len(keys); i++ {
				for j := i + 1; j < len(keys); j++ {
					if summary[keys[i]] > summary[keys[j]] {
						keys[i], keys[j] = keys[j], keys[i]
					}
				}
			}
		} else {
			for i := 0; i < len(keys); i++ {
				for j := i + 1; j < len(keys); j++ {
					if summary[keys[i]] < summary[keys[j]] {
						keys[i], keys[j] = keys[j], keys[i]
					}
				}
			}
		}
	} else {
		if sortOrder == "DESC" {
			for i := 0; i < len(keys); i++ {
				for j := i + 1; j < len(keys); j++ {
					if keys[i] < keys[j] {
						keys[i], keys[j] = keys[j], keys[i]
					}
				}
			}
		} else {
			for i := 0; i < len(keys); i++ {
				for j := i + 1; j < len(keys); j++ {
					if keys[i] > keys[j] {
						keys[i], keys[j] = keys[j], keys[i]
					}
				}
			}
		}
	}

	// Table Header
	col1Width := 110.0
	col2Width := 40.0
	col3Width := 30.0
	totalTableWidth := col1Width + col2Width + col3Width
	startX := (210.0 - totalTableWidth) / 2.0
	
	// Branding Header in Summary
	iconPath := filepath.Join(config.GetAppPath(), "icon.png")
	if _, err := os.Stat(iconPath); err == nil {
		pdf.ImageOptions(iconPath, startX, 10, 15, 15, false, fpdf.ImageOptions{ImageType: "PNG", ReadDpi: true}, 0, "")
	}
	
	pdf.SetFont("Arial", "B", 14)
	pdf.SetTextColor(headerBgR, headerBgG, headerBgB)
	pdf.SetXY(startX + 18, 11)
	pdf.CellFormat(0, 8, tr("RELATÓRIO SINTÉTICO"), "", 1, "L", false, 0, "")
	
	pdf.SetFont("Arial", "I", 8)
	pdf.SetTextColor(150, 150, 150)
	pdf.SetXY(startX + 18, 17)
	pdf.CellFormat(0, 6, tr(fmt.Sprintf("Gerado em %s", time.Now().Format("02/01/2006 às 15:04"))), "", 1, "L", false, 0, "")
	pdf.Ln(12)

	// Config Box
	pdf.SetFillColor(248, 250, 252)
	pdf.SetTextColor(71, 85, 105)
	pdf.SetFont("Arial", "B", 8)
	pdf.SetX(startX)
	pdf.CellFormat(totalTableWidth, 6, tr(" CONFIGURAÇÃO: Agrupado por "+groupField), "LTR", 1, "L", true, 0, "")
	
	pdf.SetFont("Arial", "", 8)
	pdf.SetX(startX)
	pdf.MultiCell(totalTableWidth, 5, tr(" Filtros: "+filtersTextSummary(filter)), "LBR", "L", true)
	pdf.Ln(6)

	pdf.SetX(startX)
	pdf.SetFont("Arial", "B", 10)
	pdf.SetFillColor(headerBgR, headerBgG, headerBgB)
	pdf.SetTextColor(headerTextR, headerTextG, headerTextB)
	pdf.CellFormat(col1Width, 10, tr(groupField), "1", 0, "C", true, 0, "")
	pdf.CellFormat(col2Width, 10, tr("Qtd"), "1", 0, "C", true, 0, "")
	pdf.CellFormat(col3Width, 10, tr("%"), "1", 1, "C", true, 0, "")

	// Table Body
	totalGeral := 0
	pdf.SetFont("Arial", "", 9)
	pdf.SetTextColor(30, 41, 59)

	for i, key := range keys {
		pdf.SetX(startX)
		if i%2 == 1 {
			pdf.SetFillColor(stripeR, stripeG, stripeB)
		} else {
			pdf.SetFillColor(255, 255, 255)
		}
		
		count := summary[key]
		percent := (float64(count) / float64(len(data))) * 100
		
		pdf.CellFormat(col1Width, 9, tr(" "+key), "LRB", 0, "L", true, 0, "")
		pdf.CellFormat(col2Width, 9, tr(fmt.Sprintf("%d", count)), "LRB", 0, "C", true, 0, "")
		pdf.CellFormat(col3Width, 9, tr(fmt.Sprintf("%.1f%%", percent)), "LRB", 1, "C", true, 0, "")
		totalGeral += count
	}

	// Total Row
	pdf.SetX(startX)
	pdf.SetFont("Arial", "B", 10)
	pdf.SetFillColor(230, 230, 230)
	pdf.CellFormat(col1Width, 10, tr(" TOTAL GERAL"), "1", 0, "L", true, 0, "")
	pdf.CellFormat(col2Width + col3Width, 10, tr(fmt.Sprintf("%d", totalGeral)), "1", 1, "C", true, 0, "")

	return pdf.OutputFileAndClose(filePath)
}

func GetSummaryPDFBuffer(data []models.Atendimento, filter models.AtendimentoFilter, groupField string, sortField string, sortOrder string) ([]byte, error) {
	pdf := fpdf.New("P", "mm", "A4", "")
	pdf.SetTitle(fmt.Sprintf("Resumo de Atendimentos por %s", groupField), true)
	
	tr := pdf.UnicodeTranslatorFromDescriptor("")

	pdf.SetFooterFunc(func() {
		pdf.SetY(-15)
		pdf.SetFont("Arial", "I", 8)
		pdf.SetTextColor(150, 150, 150)
		pdf.CellFormat(0, 10, tr(fmt.Sprintf("Página %d", pdf.PageNo())), "", 0, "C", false, 0, "")
	})

	pdf.AddPage()

	headerBgR, headerBgG, headerBgB := 30, 58, 138
	headerTextR, headerTextG, headerTextB := 255, 255, 255
	stripeR, stripeG, stripeB := 241, 245, 249

	col1Width := 110.0
	col2Width := 40.0
	col3Width := 30.0
	totalTableWidth := col1Width + col2Width + col3Width
	startX := (210.0 - totalTableWidth) / 2.0

	iconPath := filepath.Join(config.GetAppPath(), "icon.png")
	if _, err := os.Stat(iconPath); err == nil {
		pdf.ImageOptions(iconPath, startX, 10, 15, 15, false, fpdf.ImageOptions{ImageType: "PNG", ReadDpi: true}, 0, "")
	}
	
	pdf.SetFont("Arial", "B", 14)
	pdf.SetTextColor(headerBgR, headerBgG, headerBgB)
	pdf.SetXY(startX + 18, 11)
	pdf.CellFormat(0, 8, tr("RELATÓRIO SINTÉTICO"), "", 1, "L", false, 0, "")
	
	pdf.SetFont("Arial", "I", 8)
	pdf.SetTextColor(150, 150, 150)
	pdf.SetXY(startX + 18, 17)
	pdf.CellFormat(0, 6, tr(fmt.Sprintf("Gerado em %s", time.Now().Format("02/01/2006 às 15:04"))), "", 1, "L", false, 0, "")
	pdf.Ln(12)

	pdf.SetFillColor(248, 250, 252)
	pdf.SetTextColor(71, 85, 105)
	pdf.SetFont("Arial", "B", 8)
	pdf.SetX(startX)
	pdf.CellFormat(totalTableWidth, 6, tr(" CONFIGURAÇÃO: Agrupado por "+groupField), "LTR", 1, "L", true, 0, "")
	
	pdf.SetFont("Arial", "", 8)
	pdf.SetX(startX)
	pdf.MultiCell(totalTableWidth, 5, tr(" Filtros: "+filtersTextSummary(filter)), "LBR", "L", true)
	pdf.Ln(6)

	summary := make(map[string]int)
	for _, item := range data {
		val := getAtendimentoValue(item, groupField)
		if val == "" { val = "Não Informado" }
		summary[val]++
	}

	// Sort logic
	var keys []string
	for k := range summary {
		keys = append(keys, k)
	}

	if sortField == "count" {
		if sortOrder == "ASC" {
			for i := 0; i < len(keys); i++ {
				for j := i + 1; j < len(keys); j++ {
					if summary[keys[i]] > summary[keys[j]] {
						keys[i], keys[j] = keys[j], keys[i]
					}
				}
			}
		} else {
			for i := 0; i < len(keys); i++ {
				for j := i + 1; j < len(keys); j++ {
					if summary[keys[i]] < summary[keys[j]] {
						keys[i], keys[j] = keys[j], keys[i]
					}
				}
			}
		}
	} else {
		if sortOrder == "DESC" {
			for i := 0; i < len(keys); i++ {
				for j := i + 1; j < len(keys); j++ {
					if keys[i] < keys[j] {
						keys[i], keys[j] = keys[j], keys[i]
					}
				}
			}
		} else {
			for i := 0; i < len(keys); i++ {
				for j := i + 1; j < len(keys); j++ {
					if keys[i] > keys[j] {
						keys[i], keys[j] = keys[j], keys[i]
					}
				}
			}
		}
	}

	pdf.SetX(startX)
	pdf.SetFont("Arial", "B", 10)
	pdf.SetFillColor(headerBgR, headerBgG, headerBgB)
	pdf.SetTextColor(headerTextR, headerTextG, headerTextB)
	pdf.CellFormat(col1Width, 10, tr(groupField), "1", 0, "C", true, 0, "")
	pdf.CellFormat(col2Width, 10, tr("Qtd"), "1", 0, "C", true, 0, "")
	pdf.CellFormat(col3Width, 10, tr("%"), "1", 1, "C", true, 0, "")

	totalGeral := 0
	pdf.SetFont("Arial", "", 9)
	pdf.SetTextColor(30, 41, 59)

	for i, key := range keys {
		pdf.SetX(startX)
		if i%2 == 1 { pdf.SetFillColor(stripeR, stripeG, stripeB) } else { pdf.SetFillColor(255, 255, 255) }
		count := summary[key]
		percent := (float64(count) / float64(len(data))) * 100
		pdf.CellFormat(col1Width, 9, tr(" "+key), "LRB", 0, "L", true, 0, "")
		pdf.CellFormat(col2Width, 9, tr(fmt.Sprintf("%d", count)), "LRB", 0, "C", true, 0, "")
		pdf.CellFormat(col3Width, 9, tr(fmt.Sprintf("%.1f%%", percent)), "LRB", 1, "C", true, 0, "")
		totalGeral += count
	}

	pdf.SetX(startX)
	pdf.SetFont("Arial", "B", 10)
	pdf.SetFillColor(230, 230, 230)
	pdf.CellFormat(col1Width, 10, tr(" TOTAL GERAL"), "1", 0, "L", true, 0, "")
	pdf.CellFormat(col2Width + col3Width, 10, tr(fmt.Sprintf("%d", totalGeral)), "1", 1, "C", true, 0, "")

	var buf strings.Builder
	err := pdf.Output(&buf)
	if err != nil {
		return nil, err
	}
	return []byte(buf.String()), nil
}

func formatDateBr(dateStr string) string {
	if dateStr == "" {
		return ""
	}
	t, err := time.Parse("2006-01-02", dateStr)
	if err == nil {
		return t.Format("02/01/2006")
	}
	return dateStr
}

func filtersTextSummary(filter models.AtendimentoFilter) string {
	text := ""
	if filter.DataInicio != "" || filter.DataFim != "" {
		text += fmt.Sprintf("Período: %s a %s | ", formatDateBr(filter.DataInicio), formatDateBr(filter.DataFim))
	}
	if len(filter.Sistemas) > 0 { text += fmt.Sprintf("Sistemas: %s | ", strings.Join(filter.Sistemas, ", ")) }
	if text == "" { return "Sem filtros específicos." }
	return text[:len(text)-3]
}

