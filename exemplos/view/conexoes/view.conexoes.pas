unit view.conexoes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinOffice2019Colorful,
  dxSkinOffice2019Black, dxSkinOffice2019White, dxSkinsForm,
  dxSkinsFluentDesignForm, cxContainer, cxEdit, dxLayoutControlAdapters,
  dxLayoutcxEditAdapters, dxLayoutContainer, cxClasses, dxLayoutControl,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxNavigator,
  dxDateRanges, dxScrollbarAnnotations, cxDBData, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxDropDownEdit, cxTextEdit, cxMaskEdit, Vcl.Menus, Vcl.StdCtrls,
  cxButtons, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.Generics.Collections, model.conexao, service.conexao;

type
  TFormConexoes = class(TdxFluentDesignForm)
    LayoutControlGroup_Root: TdxLayoutGroup;
    LayoutControl: TdxLayoutControl;
    Grid: TcxGrid;
    DBTableView: TcxGridDBTableView;
    GridLevel: TcxGridLevel;
    groupEdicao: TdxLayoutGroup;
    edtNome: TcxTextEdit;
    liNome: TdxLayoutItem;
    comboDriver: TcxComboBox;
    liDriver: TdxLayoutItem;
    edtServidor: TcxTextEdit;
    liServidor: TdxLayoutItem;
    edtBanco: TcxTextEdit;
    liBanco: TdxLayoutItem;
    edtUsuario: TcxTextEdit;
    liUsuario: TdxLayoutItem;
    edtSenha: TcxTextEdit;
    liSenha: TdxLayoutItem;
    edtPorta: TcxTextEdit;
    liPorta: TdxLayoutItem;
    groupBotoes: TdxLayoutGroup;
    btnSalvar: TcxButton;
    liSalvar: TdxLayoutItem;
    btnExcluir: TcxButton;
    liExcluir: TdxLayoutItem;
    btnTestar: TcxButton;
    liTestar: TdxLayoutItem;
    ds: TDataSource;
    mt: TFDMemTable;
    mtid: TIntegerField;
    mtnome: TStringField;
    mtdriver: TStringField;
    mtservidor: TStringField;
    mtbanco: TStringField;
    mtusuario: TStringField;
    mtsenha: TStringField;
    mtporta: TIntegerField;
    DBTableViewNome: TcxGridDBColumn;
    DBTableViewDriver: TcxGridDBColumn;
    DBTableViewServidor: TcxGridDBColumn;
    DBTableViewBanco: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnTestarClick(Sender: TObject);
    procedure DBTableViewFocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
  private
    FService: IConexaoService;
    procedure Listar;
    function GetConexaoFromUI: IConexao;
  public
  end;

implementation

{$R *.dfm}

procedure TFormConexoes.FormCreate(Sender: TObject);
begin
  FService := TConexaoService.New;
  Listar;
end;

procedure TFormConexoes.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFormConexoes.Listar;
var
  LLista: TList<IConexao>;
  LItem: IConexao;
begin
  LLista := FService.Listar;
  try
    mt.Close;
    mt.Open;
    for LItem in LLista do
    begin
      mt.Append;
      mtid.AsInteger := LItem.Id;
      mtnome.AsString := LItem.Nome;
      mtdriver.AsString := LItem.Driver;
      mtservidor.AsString := LItem.Servidor;
      mtbanco.AsString := LItem.Banco;
      mtusuario.AsString := LItem.Usuario;
      mtsenha.AsString := LItem.Senha;
      mtporta.AsInteger := LItem.Porta;
      mt.Post;
    end;
    
    // Adicionar linha vazia para novo registro se lista estiver vazia ou como padrão
    if mt.IsEmpty then
    begin
       mt.Append;
       mtid.AsInteger := 0;
       mt.Post;
    end;
  finally
    LLista.Free;
  end;
end;

function TFormConexoes.GetConexaoFromUI: IConexao;
begin
  Result := TConexao.New
    .SetId(mtid.AsInteger)
    .SetNome(edtNome.Text)
    .SetDriver(comboDriver.Text)
    .SetServidor(edtServidor.Text)
    .SetBanco(edtBanco.Text)
    .SetUsuario(edtUsuario.Text)
    .SetSenha(edtSenha.Text)
    .SetPorta(StrToIntDef(edtPorta.Text, 0));
end;

procedure TFormConexoes.btnSalvarClick(Sender: TObject);
begin
  try
    FService.Salvar(GetConexaoFromUI);
    Listar;
    ShowMessage('Conexão salva com sucesso!');
  except
    on E: Exception do
      ShowMessage('Erro ao salvar: ' + E.Message);
  end;
end;

procedure TFormConexoes.btnExcluirClick(Sender: TObject);
begin
  if mtid.AsInteger > 0 then
  begin
    if MessageDlg('Deseja excluir esta conexão?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      FService.Excluir(mtid.AsInteger);
      Listar;
    end;
  end;
end;

procedure TFormConexoes.btnTestarClick(Sender: TObject);
begin
  try
    if FService.TestarConexao(GetConexaoFromUI) then
      ShowMessage('Conexão realizada com sucesso!')
    else
      ShowMessage('Falha ao conectar.');
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TFormConexoes.DBTableViewFocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  if Assigned(AFocusedRecord) then
  begin
    edtNome.Text := mtnome.AsString;
    comboDriver.Text := mtdriver.AsString;
    edtServidor.Text := mtservidor.AsString;
    edtBanco.Text := mtbanco.AsString;
    edtUsuario.Text := mtusuario.AsString;
    edtSenha.Text := mtsenha.AsString;
    edtPorta.Text := mtporta.AsString;
  end;
end;

end.
