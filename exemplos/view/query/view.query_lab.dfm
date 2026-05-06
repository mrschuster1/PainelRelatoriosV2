object FormQueryViewer: TFormQueryViewer
  Left = 0
  Top = 0
  Caption = 'Laborat'#243'rio SQL'
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnClose = FormClose
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TcxGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Align = alTop
    Caption = ' Configura'#231#245'es '
    TabOrder = 0
    Height = 86
    Width = 794
    object lblConexao: TLabel
      Left = 16
      Top = 24
      Width = 57
      Height = 15
      Caption = 'Conex'#227'o:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
    end
    object cmbConexao: TcxComboBox
      Left = 16
      Top = 45
      Properties.DropDownListStyle = lsFixedList
      TabOrder = 0
      Width = 250
    end
    object btnExecutar: TcxButton
      Left = 280
      Top = 43
      Width = 120
      Height = 25
      Caption = 'Executar (F5)'
      TabOrder = 1
      OnClick = btnExecutarClick
    end
    object btnImprimir: TcxButton
      Left = 406
      Top = 43
      Width = 120
      Height = 25
      Caption = 'Imprimir'
      TabOrder = 2
      OnClick = btnImprimirClick
    end
  end
  object mmoSQL: TcxMemo
    AlignWithMargins = True
    Left = 3
    Top = 95
    Align = alTop
    Lines.Strings = (
      'SELECT * FROM conexoes')
    Properties.ScrollBars = ssVertical
    TabOrder = 1
    Height = 150
    Width = 794
  end
  object pnlGrid: TcxGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 251
    Align = alClient
    Caption = ' Resultado '
    TabOrder = 2
    Height = 346
    Width = 794
    object gridResultado: TcxGrid
      Left = 3
      Top = 15
      Width = 788
      Height = 328
      Align = alClient
      TabOrder = 0
      object gridViewResultado: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = dsResultado
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
      end
      object gridResultadoLevel1: TcxGridLevel
        GridView = gridViewResultado
      end
    end
  end
  object dsResultado: TDataSource
    Left = 448
    Top = 40
  end
end
