object DataReport: TDataReport
  OldCreateOrder = False
  Height = 250
  Width = 400
  object frxReport1: TfrxReport
    Version = '2023.2.0'
    DotMatrixReport = False
    IniFile = '\Software\FastReports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbThumbnails]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 45293.500000000000000000
    ReportOptions.LastChange = 45293.500000000000000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 48
    Top = 32
    Datasets = <
      item
        DataSet = frxDBDataset1
        DataSetName = 'frxDBDataset1'
      end>
    Variables = <>
    Style = <>
  end
  object frxDBDataset1: TfrxDBDataset
    UserName = 'frxDBDataset1'
    CloseDataSource = False
    DataSet = DataReport.frxDBDataset1
    BCDToCurrency = False
    Left = 144
    Top = 32
  end
  object frxPDFExport1: TfrxPDFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    EmbedFonts = False
    OpenAfterExport = False
    RepeatIndex = 0
    Quality = 95
    Transparency = False
    Type3Font = False
    Creator = 'FastReport'
    ProtectionFlags = [ePrint, eModify, eCopy, eAnnot]
    HideToolbar = False
    HideMenubar = False
    HideWindowUI = False
    FitWindow = False
    CenterWindow = False
    PrintScaling = False
    Left = 48
    Top = 104
  end
  object frxXLSXExport1: TfrxXLSXExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    OpenAfterExport = False
    RepeatIndex = 0
    ExportPageBreaks = True
    ExportType = xtXLSX
    Left = 144
    Top = 104
  end
end
