object FormConexoes: TFormConexoes
  Left = 0
  Top = 0
  Caption = 'Gerenciar Conex'#245'es'
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LayoutControl: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 800
    Height = 600
    Align = alClient
    TabOrder = 0
    object Grid: TcxGrid
      Left = 11
      Top = 11
      Width = 778
      Height = 250
      TabOrder = 0
      object DBTableView: TcxGridDBTableView
        OnFocusedRecordChanged = DBTableViewFocusedRecordChanged
        DataController.DataSource = ds
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsData.Deleting = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        object DBTableViewNome: TcxGridDBColumn
          Caption = 'Nome'
          DataBinding.FieldName = 'nome'
          Width = 200
        end
        object DBTableViewDriver: TcxGridDBColumn
          Caption = 'Driver'
          DataBinding.FieldName = 'driver'
          Width = 100
        end
        object DBTableViewServidor: TcxGridDBColumn
          Caption = 'Servidor'
          DataBinding.FieldName = 'servidor'
          Width = 150
        end
        object DBTableViewBanco: TcxGridDBColumn
          Caption = 'Banco'
          DataBinding.FieldName = 'banco'
          Width = 150
        end
      end
      object GridLevel: TcxGridLevel
        GridView = DBTableView
      end
    end
    object edtNome: TcxTextEdit
      Left = 47
      Top = 301
      Style.HotTrack = False
      TabOrder = 1
      Width = 300
    end
    object comboDriver: TcxComboBox
      Left = 387
      Top = 301
      Properties.Items.Strings = (
        'MySQL'
        'Firebird'
        'PostgreSQL'
        'SQLite')
      Style.HotTrack = False
      TabOrder = 2
      Width = 150
    end
    object edtServidor: TcxTextEdit
      Left = 57
      Top = 349
      Style.HotTrack = False
      TabOrder = 3
      Width = 300
    end
    object edtBanco: TcxTextEdit
      Left = 397
      Top = 349
      Style.HotTrack = False
      TabOrder = 4
      Width = 150
    end
    object edtUsuario: TcxTextEdit
      Left = 53
      Top = 397
      Style.HotTrack = False
      TabOrder = 5
      Width = 150
    end
    object edtSenha: TcxTextEdit
      Left = 243
      Top = 397
      Properties.EchoMode = eemPassword
      Style.HotTrack = False
      TabOrder = 6
      Width = 150
    end
    object edtPorta: TcxTextEdit
      Left = 428
      Top = 397
      Style.HotTrack = False
      TabOrder = 7
      Width = 50
    end
    object btnSalvar: TcxButton
      Left = 11
      Top = 445
      Width = 100
      Height = 25
      Caption = 'Salvar'
      TabOrder = 8
      OnClick = btnSalvarClick
    end
    object btnExcluir: TcxButton
      Left = 117
      Top = 445
      Width = 100
      Height = 25
      Caption = 'Excluir'
      TabOrder = 9
      OnClick = btnExcluirClick
    end
    object btnTestar: TcxButton
      Left = 223
      Top = 445
      Width = 100
      Height = 25
      Caption = 'Testar'
      TabOrder = 10
      OnClick = btnTestarClick
    end
    object LayoutControlGroup_Root: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      ButtonOptions.Buttons = <>
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object liGrid: TdxLayoutItem
      Parent = LayoutControlGroup_Root
      AlignVert = avClient
      CaptionOptions.Text = 'Conex'#245'es'
      CaptionOptions.Visible = False
      Control = Grid
      ControlOptions.OriginalHeight = 250
      ControlOptions.OriginalWidth = 780
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object groupEdicao: TdxLayoutGroup
      Parent = LayoutControlGroup_Root
      CaptionOptions.Text = 'Dados da Conex'#227'o'
      ButtonOptions.Buttons = <>
      Index = 1
    end
    object row1: TdxLayoutAutoCreatedGroup
      Parent = groupEdicao
      LayoutDirection = ldHorizontal
      Index = 0
      AutoCreated = True
    end
    object liNome: TdxLayoutItem
      Parent = row1
      CaptionOptions.Text = 'Nome'
      Control = edtNome
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 300
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object liDriver: TdxLayoutItem
      Parent = row1
      CaptionOptions.Text = 'Driver'
      Control = comboDriver
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 150
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object row2: TdxLayoutAutoCreatedGroup
      Parent = groupEdicao
      LayoutDirection = ldHorizontal
      Index = 1
      AutoCreated = True
    end
    object liServidor: TdxLayoutItem
      Parent = row2
      CaptionOptions.Text = 'Servidor'
      Control = edtServidor
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 300
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object liBanco: TdxLayoutItem
      Parent = row2
      CaptionOptions.Text = 'Banco'
      Control = edtBanco
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 150
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object row3: TdxLayoutAutoCreatedGroup
      Parent = groupEdicao
      LayoutDirection = ldHorizontal
      Index = 2
      AutoCreated = True
    end
    object liUsuario: TdxLayoutItem
      Parent = row3
      CaptionOptions.Text = 'Usu'#225'rio'
      Control = edtUsuario
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 150
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object liSenha: TdxLayoutItem
      Parent = row3
      CaptionOptions.Text = 'Senha'
      Control = edtSenha
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 150
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liPorta: TdxLayoutItem
      Parent = row3
      CaptionOptions.Text = 'Porta'
      Control = edtPorta
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 50
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object groupBotoes: TdxLayoutGroup
      Parent = LayoutControlGroup_Root
      CaptionOptions.Text = 'A'#231#245'es'
      ButtonOptions.Buttons = <>
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object liSalvar: TdxLayoutItem
      Parent = groupBotoes
      CaptionOptions.Visible = False
      Control = btnSalvar
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object liExcluir: TdxLayoutItem
      Parent = groupBotoes
      CaptionOptions.Visible = False
      Control = btnExcluir
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object liTestar: TdxLayoutItem
      Parent = groupBotoes
      CaptionOptions.Visible = False
      Control = btnTestar
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      Index = 2
    end
  end
  object ds: TDataSource
    DataSet = mt
    Left = 600
    Top = 300
  end
  object mt: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 550
    Top = 300
    object mtid: TIntegerField
      FieldName = 'id'
    end
    object mtnome: TStringField
      FieldName = 'nome'
      Size = 100
    end
    object mtdriver: TStringField
      FieldName = 'driver'
    end
    object mtservidor: TStringField
      FieldName = 'servidor'
      Size = 255
    end
    object mtbanco: TStringField
      FieldName = 'banco'
      Size = 255
    end
    object mtusuario: TStringField
      FieldName = 'usuario'
    end
    object mtsenha: TStringField
      FieldName = 'senha'
    end
    object mtporta: TIntegerField
      FieldName = 'porta'
    end
  end
end
