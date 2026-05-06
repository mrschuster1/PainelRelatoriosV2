unit view.query_lab;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxNavigator, dxDateRanges,
  dxScrollbarAnnotations, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxMemo, cxGroupBox, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxDropDownEdit,
  cxTextEdit, cxMaskEdit, System.UITypes, System.Generics.Collections,
  service.conexao, service.query, model.conexao, service.report, FireDAC.Comp.Client;

type
  TFormQueryViewer = class(TForm)
    pnlTop: TcxGroupBox;
    lblConexao: TLabel;
    cmbConexao: TcxComboBox;
    btnExecutar: TcxButton;
    btnImprimir: TcxButton;
    mmoSQL: TcxMemo;
    pnlGrid: TcxGroupBox;
    gridResultado: TcxGrid;
    gridViewResultado: TcxGridDBTableView;
    gridResultadoLevel1: TcxGridLevel;
    dsResultado: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure btnExecutarClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    FConexaoService: IConexaoService;
    FQueryEngine: IQueryEngine;
    FListaConexoes: TList<IConexao>;
    procedure CarregarConexoes;
    procedure ConfigurarGrid;
  public
  end;

var
  FormQueryViewer: TFormQueryViewer;

implementation

{$R *.dfm}

uses service.query.impl, service.report.impl;

procedure TFormQueryViewer.FormCreate(Sender: TObject);
begin
  FConexaoService := TConexaoService.New;
  FQueryEngine := TQueryEngine.New;
  FListaConexoes := TList<IConexao>.Create;
  ConfigurarGrid;
  CarregarConexoes;
end;

procedure TFormQueryViewer.FormDestroy(Sender: TObject);
begin
  FListaConexoes.Free;
end;

procedure TFormQueryViewer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  FormQueryViewer := nil;
end;

procedure TFormQueryViewer.btnExecutarClick(Sender: TObject);
var
  LConexao: IConexao;
  LSQL: string;
begin
  if cmbConexao.ItemIndex = -1 then
    raise Exception.Create('Selecione uma conexao primeiro.');

  LSQL := Trim(mmoSQL.Text);
  if LSQL.IsEmpty then
    raise Exception.Create('Digite um comando SQL para executar.');

  LConexao := FListaConexoes[cmbConexao.ItemIndex];

  try
    dsResultado.DataSet := FQueryEngine
      .SetConnection(LConexao)
      .SQL(LSQL)
      .Open;
    gridViewResultado.ClearItems;
    gridViewResultado.DataController.CreateAllItems;
  except
    on E: Exception do
      MessageDlg('Erro ao executar query: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TFormQueryViewer.btnImprimirClick(Sender: TObject);
begin
  if not Assigned(dsResultado.DataSet) or dsResultado.DataSet.IsEmpty then
    raise Exception.Create('Nao ha dados para imprimir.');

  TReportService.New
    .SetDataSet(dsResultado.DataSet)
    .ShowPreview;
end;

procedure TFormQueryViewer.CarregarConexoes;
var
  LLista: TList<IConexao>;
  LItem: IConexao; // <--- DECLARADO AGORA
begin
  cmbConexao.Properties.Items.Clear;
  FListaConexoes.Clear;
  
  LLista := FConexaoService.Listar;
  try
    for LItem in LLista do
    begin
      cmbConexao.Properties.Items.Add(LItem.Nome);
      FListaConexoes.Add(LItem);
    end;
  finally
    LLista.Free;
  end;

  if cmbConexao.Properties.Items.Count > 0 then
    cmbConexao.ItemIndex := 0;
end;

procedure TFormQueryViewer.ConfigurarGrid;
begin
  gridViewResultado.DataController.DataSource := dsResultado;
  gridViewResultado.OptionsView.ColumnAutoWidth := True;
  gridViewResultado.OptionsView.GroupByBox := False;
end;

end.
