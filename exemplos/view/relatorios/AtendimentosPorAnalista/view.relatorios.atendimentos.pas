unit view.relatorios.atendimentos;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  ShellAPI,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  cxControls,
  cxGraphics,
  cxLookAndFeelPainters,
  dxMessageDialog,
  cxLookAndFeels,
  dxSkinsCore,
  cxContainer,
  DateUtils,
  cxEdit,
  cxGridExportLink,
  dxNavBar,
  cxClasses,
  dxLayoutLookAndFeels,
  dxLayoutContainer,
  dxLayoutControl,
  dxSkinsForm,
  dxSkinsFluentDesignForm,
  dxSkinOffice2019Colorful,
  dxSkinOffice2019Black,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  Vcl.StdCtrls,
  dxLayoutControlAdapters,
  dxLayoutcxEditAdapters,
  FireDAC.UI.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Phys,
  FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef,
  FireDAC.VCLUI.Wait,
  cxStyles,
  cxCustomData,
  cxFilter,
  cxData,
  cxDataStorage,
  cxNavigator,
  dxDateRanges,
  dxScrollbarAnnotations,
  cxDBData,
  Vcl.Menus,
  Vcl.ComCtrls,
  dxCore,
  cxDateUtils,
  cxLabel,
  cxTextEdit,
  cxMaskEdit,
  cxDropDownEdit,
  cxCalendar,
  cxButtons,
  Data.connection,
  cxGridStrs,
  cxGridCustomTableView,
  cxGridTableView,
  cxGridDBTableView,
  cxGridLevel,
  cxGridCustomView,
  cxGrid,
  dxCoreGraphics,
  cxButtonEdit,
  Vcl.ExtCtrls,
  dxPSGlbl,
  dxPSUtl,
  dxPSEngn,
  dxPrnPg,
  dxBkgnd,
  dxWrap,
  dxPrnDev,
  dxPSCompsProvider,
  dxPSFillPatterns,
  dxPSEdgePatterns,
  dxPSPDFExportCore,
  dxPSPDFExport,
  cxDrawTextUtils,
  dxPSPrVwStd,
  dxPSPrVwAdv,
  dxPSPrVwRibbon,
  dxPScxPageControlProducer,
  dxPScxGridLnk,
  dxPScxGridLayoutViewLnk,
  dxPScxEditorProducers,
  dxPScxExtEditorProducers,
  dxPSCore,
  dxPScxCommon,
  frxClass,
  frxDBSet,
  frxPreview,
  dxShellDialogs,
  frxExportCSV,
  frxExportXLSX,
  frxExportBaseDialog,
  frxExportPDF,
  frxExportMail,
  frxExportImage,
  frxExportPPTX,
  frxDMPExport,
  frxExportText,
  frxExportRTF,
  frxExportXML,
  frxExportHTML,
  dxBarBuiltInMenu,
  cxGridCustomPopupMenu,
  cxGridPopupMenu,
  cxLookupEdit,
  cxDBLookupEdit,
  cxDBLookupComboBox,
  cxCheckComboBox,
  FireDAC.Stan.StorageJSON,
  FireDAC.Stan.StorageBin,
  service.relatorios.atendimentos;

type
  TFormRelatAtendimento = class(TdxFluentDesignForm)
    LayoutControlGroup_Root: TdxLayoutGroup;
    LayoutControl: TdxLayoutControl;
    sql: TFDQuery;
    ds: TDataSource;
    dxLayoutItem1: TdxLayoutItem;
    Grid: TcxGrid;
    DBTableView: TcxGridDBTableView;
    GridLevel1: TcxGridLevel;
    dxLayoutItem3: TdxLayoutItem;
    btnListar: TcxButton;
    dxLayoutItem2: TdxLayoutItem;
    edtDataInicial: TcxDateEdit;
    dxLayoutItem4: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayoutItem5: TdxLayoutItem;
    edtDataFinal: TcxDateEdit;
    edtPesquisa: TcxTextEdit;
    dxLayoutItem7: TdxLayoutItem;
    timerPesquisa: TTimer;
    dxLayoutItem6: TdxLayoutItem;
    btnImprimirAnalitico: TcxButton;
    ComponentPrinter: TdxComponentPrinter;
    GridPrinter: TdxGridReportLink;
    sqlId: TIntegerField;
    sqlCliente: TWideStringField;
    sqlSolicitante: TWideStringField;
    sqlDataAbertura: TDateField;
    sqlHoraAbertura: TTimeField;
    sqlDataFechamento: TDateField;
    sqlHoraFechamento: TTimeField;
    sqlHistorico: TWideMemoField;
    sqlAnalista: TWideStringField;
    sqlSistema: TWideStringField;
    ReportAnalitico: TfrxReport;
    ReportDataset: TfrxDBDataset;
    dxLayoutGroup1: TdxLayoutGroup;
    dxLayoutGroup2: TdxLayoutGroup;
    dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup;
    dxLayoutItem8: TdxLayoutItem;
    comboSistema: TcxComboBox;
    dxLayoutItem9: TdxLayoutItem;
    comboAnalista: TcxComboBox;
    dxLayoutItem10: TdxLayoutItem;
    comboCliente: TcxCheckComboBox;
    memClientes: TFDMemTable;
    dsClientes: TDataSource;
    memClientesNome: TWideStringField;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    dxLayoutItem11: TdxLayoutItem;
    btnExportarExcel: TcxButton;
    frxPDFExport1: TfrxPDFExport;
    frxXLSXExport1: TfrxXLSXExport;
    frxCSVExport1: TfrxCSVExport;
    frxHTMLExport1: TfrxHTMLExport;
    frxXMLExport1: TfrxXMLExport;
    frxRTFExport1: TfrxRTFExport;
    frxJPEGExport1: TfrxJPEGExport;
    frxSimpleTextExport1: TfrxSimpleTextExport;
    frxDotMatrixExport1: TfrxDotMatrixExport;
    frxPPTXExport1: TfrxPPTXExport;
    frxPNGExport1: TfrxPNGExport;
    frxMailExport1: TfrxMailExport;
    dxLayoutItem13: TdxLayoutItem;
    comboCategoria: TcxComboBox;
    comboSetor: TcxComboBox;
    comboAcao: TcxComboBox;
    comboUnidade: TcxComboBox;
    dxLayoutItemUnidade: TdxLayoutItem;
    sqlCategoria: TWideStringField;
    sqlSetor: TWideStringField;
    sqlAcao: TWideStringField;
    sqlUnidade: TWideStringField;
    DBTableViewCategoria: TcxGridDBColumn;
    DBTableViewSetor: TcxGridDBColumn;
    DBTableViewAcao: TcxGridDBColumn;
    DBTableViewUnidade: TcxGridDBColumn;
    GridPopupMenu: TcxGridPopupMenu;
    ReportSintetico: TfrxReport;
    dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup;
    dxLayoutItem14: TdxLayoutItem;
    btnImprimirSintetico: TcxButton;
    sqlTotalPorAnalista: TLargeintField;
    DBTableViewTotalPorAnalista: TcxGridDBColumn;
    edtFiltroCliente: TcxTextEdit;
    dxLayoutItemFiltroCliente: TdxLayoutItem;
    btnClearCliente: TcxButton;
    dxLayoutItemClearCliente: TdxLayoutItem;
    procedure dxFluentDesignFormCreate(Sender: TObject);
    procedure btnListarClick(Sender: TObject);
    procedure dxFluentDesignFormClose(Sender: TObject;
      var Action: TCloseAction);
    procedure DBTableViewCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure timerPesquisaTimer(Sender: TObject);
    procedure btnImprimirAnaliticoClick(Sender: TObject);
    procedure dsDataChange(Sender: TObject; Field: TField);
    procedure edtPesquisaPropertiesChange(Sender: TObject);
    procedure comboClientePropertiesChange(Sender: TObject);
    procedure btnExportarExcelClick(Sender: TObject);
    procedure btnImprimirSinteticoClick(Sender: TObject);
    procedure edtFiltroClientePropertiesChange(Sender: TObject);
    procedure btnClearClienteClick(Sender: TObject);
  private
    FConn: TFDConnection;
    FCheckedClientes: TStringList;
    FLockFilter: Boolean;
    procedure ClearLikeFilter;
    procedure AddLikeFilter;
    procedure AddLikeCondition(
      AItemList: TcxFilterCriteriaItemList;
      AColumn: TcxCustomGridTableItem;
      const ALike: string);
    procedure Pesquisar;
    procedure LoadSistemas;
    procedure LoadAnalistas;
    procedure LoadClientes(const AFilter: string = '');
    procedure LoadCategorias;
    procedure LoadSetores;
    procedure LoadAcoes;
    procedure LoadUnidades;

  public
    { Public declarations }
    destructor Destroy; override;
  end;

var
  FormRelatAtendimento: TFormRelatAtendimento;

implementation

uses
  System.Threading,
  System.Generics.Collections,
  repository.sistemas,
  model.sistemas,
  repository.usuarios,
  model.usuarios,
  repository.clientes,
  model.clientes,
  repository.categorias,
  model.categorias,
  repository.celulas,
  model.celulas,
  repository.cidades,
  model.cidades;

{$R *.dfm}


procedure TFormRelatAtendimento.AddLikeCondition(
  AItemList: TcxFilterCriteriaItemList; AColumn: TcxCustomGridTableItem;
  const ALike: string);
begin
  AItemList.AddItem(AColumn, foLike, '%' + UpperCase(ALike) + '%',
    '"' + UpperCase(ALike) + '"');
end;

procedure TFormRelatAtendimento.AddLikeFilter;
var
  ALike: string;
  AItemList: TcxFilterCriteriaItemList;
  i: Integer;
begin
  ALike := UpperCase(StringReplace(edtPesquisa.Text, ' ', '%',
    [rfReplaceAll, rfIgnoreCase]));

  if Trim(ALike) = '' then
    Exit;

  AItemList := DBTableView.DataController.Filter.Root.AddItemList(fboOr);

  for i := 0 to DBTableView.ColumnCount - 1 do
    AddLikeCondition(AItemList, DBTableView.Columns[i], ALike);
end;

procedure TFormRelatAtendimento.btnExportarExcelClick(
  Sender: TObject);
var
  SaveDialog: TdxSaveFileDialog;
begin
  SaveDialog := TdxSaveFileDialog.Create(nil);
  try
    SaveDialog.Title := 'Salvar Exporta??o';
    SaveDialog.Filter := 'Arquivo Excel (.xlsx)|*.xlsx';
    SaveDialog.DefaultExt := 'xlsx';

    if SaveDialog.Execute then
    begin
      try
        ExportGridToXLSX(SaveDialog.FileName, Grid, True, True, True, 'xlsx');
        if FileExists(SaveDialog.FileName) then
        begin
          if dxMessageDlg('Dados exportados com sucesso!' + #13#10 +
            'Deseja abrir o arquivo agora?',
            mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          begin
            ShellExecute(0, 'open', PChar(SaveDialog.FileName), nil, nil,
              SW_SHOWNORMAL);
          end;
        end;

      except
        on E: Exception do
          dxMessageDlg('Erro ao exportar: ' + E.Message, mtError, [mbOK], 0);
      end;
    end;
  finally
    SaveDialog.Free;
  end;
end;

procedure TFormRelatAtendimento.btnImprimirAnaliticoClick(Sender: TObject);
begin
  sql.DisableControls;

  ReportAnalitico.PrepareReport(True);
  ReportAnalitico.ShowPreparedReport;

  sql.EnableControls;
end;

procedure TFormRelatAtendimento.btnImprimirSinteticoClick(Sender: TObject);
begin
  sql.DisableControls;

  ReportSintetico.PrepareReport(True);
  ReportSintetico.ShowPreparedReport;

  sql.EnableControls;
end;

procedure TFormRelatAtendimento.btnListarClick(Sender: TObject);
var
  Filtro: TFiltroRelatorioAtendimentos;
begin
  try
    Filtro.DataInicial := edtDataInicial.Date;
    Filtro.DataFinal := edtDataFinal.Date;

    if (comboSistema.ItemIndex >= 0) and (comboSistema.Text <> '') then
      Filtro.Sistema := comboSistema.Text
    else
      Filtro.Sistema := '';

    if (comboAnalista.ItemIndex >= 0) and (comboAnalista.Text <> '') then
      Filtro.Analista := comboAnalista.Text
    else
      Filtro.Analista := '';

    Filtro.Cliente := comboCliente.Text;

    if (comboCategoria.ItemIndex >= 0) and (comboCategoria.Text <> '') then
      Filtro.Categoria := comboCategoria.Text
    else
      Filtro.Categoria := '';

    if (comboSetor.ItemIndex >= 0) and (comboSetor.Text <> '') then
      Filtro.Setor := comboSetor.Text
    else
      Filtro.Setor := '';

    if (comboAcao.ItemIndex >= 0) and (comboAcao.Text <> '') then
      Filtro.Acao := comboAcao.Text
    else
      Filtro.Acao := '';

    if (comboUnidade.ItemIndex >= 0) and (comboUnidade.Text <> '') then
      Filtro.Unidade := comboUnidade.Text
    else
      Filtro.Unidade := '';

    TRelatorioAtendimentosService.Consultar(sql, Filtro);

    btnImprimirAnalitico.Enabled := not sql.IsEmpty;
    btnImprimirSintetico.Enabled := not sql.IsEmpty;
    btnExportarExcel.Enabled := not sql.IsEmpty;
    Grid.Enabled := True;
    edtPesquisa.Enabled := True;
  except
    on E: Exception do
      ShowMessage('Erro na pesquisa: ' + E.Message);
  end;
end;

procedure TFormRelatAtendimento.ClearLikeFilter;
var
  i: Integer;
  ARoot: TcxFilterCriteriaItemList;
begin
  ARoot := DBTableView.DataController.Filter.Root;
  for i := ARoot.Count - 1 downto 0 do
    if ARoot.Items[i] is TcxFilterCriteriaItemList then
      ARoot.Items[i].Free;
end;

procedure TFormRelatAtendimento.DBTableViewCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  AFoundText, ACellText: string;
  P: Integer;
begin
  inherited;
  ADone := false;
  if (Trim(edtPesquisa.Text) = '') or
    not(AViewInfo.EditViewInfo is TcxCustomTextEditViewInfo) then
    Exit;

  AFoundText := AnsiUpperCase(edtPesquisa.Text);
  ACellText := AViewInfo.Text;
  P := Pos(AFoundText, AnsiUpperCase(ACellText));
  if P > 0 then
    with TcxCustomTextEditViewInfo(AViewInfo.EditViewInfo) do
    begin
      SelStart := P - 1;
      SelLength := Length(AFoundText);
      SelBackgroundColor := RGB(43, 87, 154);
      SelTextColor := clwhite;
    end;
end;

procedure TFormRelatAtendimento.dsDataChange(Sender: TObject;
  Field: TField);
begin
  btnImprimirAnalitico.Enabled := sql.Active;
  btnImprimirSintetico.Enabled := sql.Active;
  btnExportarExcel.Enabled := sql.Active;
  Grid.Enabled := sql.Active;
  edtPesquisa.Enabled := sql.Active;
end;

procedure TFormRelatAtendimento.dxFluentDesignFormClose(
  Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

destructor TFormRelatAtendimento.Destroy;
begin
  FCheckedClientes.Free;
  inherited;
end;

procedure TFormRelatAtendimento.dxFluentDesignFormCreate(
  Sender: TObject);
begin
  FCheckedClientes := TStringList.Create;
  FCheckedClientes.Sorted := True;
  FCheckedClientes.Duplicates := dupIgnore;
  
  FConn := TConnection.GetDefaultConnection;
  sql.Connection := FConn;
  edtDataInicial.Date := StartOfTheMonth(Now);
  edtDataFinal.Date := Date;
  LoadSistemas;
  LoadAnalistas;
  LoadClientes;
  LoadCategorias;
  LoadSetores;
  LoadAcoes;
  LoadUnidades;
end;


procedure TFormRelatAtendimento.edtPesquisaPropertiesChange(
  Sender: TObject);
begin
  timerPesquisa.Enabled := True
end;

procedure TFormRelatAtendimento.Pesquisar;
var
  AFilter: TcxDataFilterCriteria;
begin
  if FLockFilter then
    Exit;

  FLockFilter := True;
  AFilter := DBTableView.DataController.Filter;
  AFilter.BeginUpdate;
  try
    ClearLikeFilter;
    AddLikeFilter;
    AFilter.Active := True;
  finally
    AFilter.EndUpdate;
    FLockFilter := false;
  end;
end;

procedure TFormRelatAtendimento.timerPesquisaTimer(Sender: TObject);
begin
  Pesquisar;
  timerPesquisa.Enabled := false;
end;

procedure TFormRelatAtendimento.LoadSistemas;
var
  repository: ISistemasRepository;
  sistemas: TList<ISistema>;
  i: Integer;
begin
  repository := NewSistemasRepository;
  sistemas := repository.GetAll;
  try
    comboSistema.Properties.Items.BeginUpdate;
    try
      comboSistema.Properties.Items.Clear;
      comboSistema.Properties.Items.Add('');
      for i := 0 to sistemas.Count - 1 do
        comboSistema.Properties.Items.Add(sistemas[i].Sistema);
    finally
      comboSistema.Properties.Items.EndUpdate;
    end;
  finally
    sistemas.Free;
  end;
end;

procedure TFormRelatAtendimento.LoadAnalistas;
var
  repository: IUsuariosRepository;
  Analistas: TList<IUsuario>;
  i: Integer;
begin
  repository := NewUsuariosRepository;
  Analistas := repository.GetAnalistas;
  try
    comboAnalista.Properties.Items.BeginUpdate;
    try
      comboAnalista.Properties.Items.Clear;
      comboAnalista.Properties.Items.Add('');
      for i := 0 to Analistas.Count - 1 do
        comboAnalista.Properties.Items.Add(Analistas[i].Nome);
    finally
      comboAnalista.Properties.Items.EndUpdate;
    end;
  finally
    Analistas.Free;
  end;
end;

procedure TFormRelatAtendimento.edtFiltroClientePropertiesChange(
  Sender: TObject);
begin
  LoadClientes(edtFiltroCliente.Text);
end;

procedure TFormRelatAtendimento.btnClearClienteClick(Sender: TObject);
begin
  FCheckedClientes.Clear;
  edtFiltroCliente.Text := '';
  comboCliente.EditValue := Null;
  LoadClientes;
end;

procedure TFormRelatAtendimento.comboClientePropertiesChange(Sender: TObject);
var
  LCurrentSelection: string;
  LSelectedList: TStringList;
  i: Integer;
begin
  // Sync checked items to our persistent list when selection changes
  LCurrentSelection := VarToStr(comboCliente.EditValue);
  LSelectedList := TStringList.Create;
  try
    LSelectedList.Delimiter := ';';
    LSelectedList.StrictDelimiter := True;
    LSelectedList.DelimitedText := LCurrentSelection;
    
    // Reset and sync
    FCheckedClientes.Clear;
    for i := 0 to LSelectedList.Count - 1 do
      if Trim(LSelectedList[i]) <> '' then
        FCheckedClientes.Add(Trim(LSelectedList[i]));
  finally
    LSelectedList.Free;
  end;
end;

procedure TFormRelatAtendimento.LoadClientes(const AFilter: string = '');
var
  Qry: TFDQuery;
  LItem: TcxCheckComboBoxItem;
  i: Integer;
  LNome: string;
begin
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConn;
    Qry.SQL.Text := 'SELECT Nome FROM clientes WHERE Inativo = ''N'' AND Prospecto = ''N'' ';
    if AFilter <> '' then
      Qry.SQL.Add('AND Nome LIKE ' + QuotedStr('%' + AFilter + '%'));
    Qry.SQL.Add('ORDER BY Nome');
    Qry.Open;

    comboCliente.Properties.Items.BeginUpdate;
    try
      comboCliente.Properties.Items.Clear;
      
      // 1. Add already selected items first
      for i := 0 to FCheckedClientes.Count - 1 do
      begin
        LItem := comboCliente.Properties.Items.Add;
        LItem.Description := FCheckedClientes[i];
      end;

      // 2. Add items from search (skip if already added from selection)
      while not Qry.Eof do
      begin
        LNome := Qry.FieldByName('Nome').AsString;
        if FCheckedClientes.IndexOf(LNome) < 0 then
        begin
          LItem := comboCliente.Properties.Items.Add;
          LItem.Description := LNome;
        end;
        Qry.Next;
      end;
    finally
      comboCliente.Properties.Items.EndUpdate;
    end;
    
    // 3. Restore selection
    comboCliente.EditValue := FCheckedClientes.DelimitedText;
    
  finally
    Qry.Free;
  end;
end;

procedure TFormRelatAtendimento.LoadCategorias;
var
  repository: ICategoriasRepository;
  categorias: TList<ICategoria>;
  i: Integer;
begin
  repository := NewCategoriasRepository;
  categorias := repository.GetAll;
  try
    comboCategoria.Properties.Items.BeginUpdate;
    try
      comboCategoria.Properties.Items.Clear;
      comboCategoria.Properties.Items.Add('');
      for i := 0 to categorias.Count - 1 do
        comboCategoria.Properties.Items.Add(categorias[i].Categoria);
    finally
      comboCategoria.Properties.Items.EndUpdate;
    end;
  finally
    categorias.Free;
  end;
end;

procedure TFormRelatAtendimento.LoadSetores;
var
  repository: ICelulasRepository;
  setores: TList<ICelula>;
  i: Integer;
begin
  repository := NewCelulasRepository;
  setores := repository.GetAtivas;
  try
    comboSetor.Properties.Items.BeginUpdate;
    try
      comboSetor.Properties.Items.Clear;
      comboSetor.Properties.Items.Add('');
      for i := 0 to setores.Count - 1 do
        comboSetor.Properties.Items.Add(setores[i].Celula);
    finally
      comboSetor.Properties.Items.EndUpdate;
    end;
  finally
    setores.Free;
  end;
end;

procedure TFormRelatAtendimento.LoadAcoes;
var
  Qry: TFDQuery;
begin
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := FConn;
    Qry.SQL.Text := 'select distinct Acao from atendimentos where Acao is not null and Trim(Acao) <> '''' order by Acao';
    Qry.Open;
    
    if Assigned(comboAcao) then
    begin
      comboAcao.Properties.Items.BeginUpdate;
      try
        comboAcao.Properties.Items.Clear;
        comboAcao.Properties.Items.Add('');
        while not Qry.Eof do
        begin
          comboAcao.Properties.Items.Add(Qry.FieldByName('Acao').AsString);
          Qry.Next;
        end;
      finally
        comboAcao.Properties.Items.EndUpdate;
      end;
    end;
  finally
    Qry.Free;
  end;
end;

procedure TFormRelatAtendimento.LoadUnidades;
var
  repository: ICidadesRepository;
  cidades: TList<ICidade>;
  i: Integer;
begin
  repository := NewCidadesRepository;
  cidades := repository.GetAtivas;
  try
    if Assigned(comboUnidade) then
    begin
      comboUnidade.Properties.Items.BeginUpdate;
      try
        comboUnidade.Properties.Items.Clear;
        comboUnidade.Properties.Items.Add('');
        for i := 0 to cidades.Count - 1 do
          comboUnidade.Properties.Items.Add(cidades[i].Cidade);
      finally
        comboUnidade.Properties.Items.EndUpdate;
      end;
    end;
  finally
    cidades.Free;
  end;
end;
end.
