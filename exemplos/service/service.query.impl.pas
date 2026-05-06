unit service.query.impl;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Variants,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.Comp.DataSet,
  FireDAC.DApt,
  model.conexao,
  service.query;

type
  TQueryEngine = class(TInterfacedObject, IQueryEngine)
  private
    FConnection: TFDConnection;
    FQuery: TFDQuery;
    FConexaoModel: IConexao;
    
    constructor Create;
    destructor Destroy; override;
    
    procedure ConfigureConnection;
    procedure EnsureConnection;
  public
    class function New: IQueryEngine;
    
    function SetConnection(const AValue: IConexao): IQueryEngine;
    function SQL(const AValue: string): IQueryEngine;
    function Param(const AName: string; const AValue: Variant): IQueryEngine;
    function Open: TDataSet;
    function Execute: Integer;
  end;

implementation

{ TQueryEngine }

constructor TQueryEngine.Create;
begin
  FConnection := TFDConnection.Create(nil);
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := FConnection;
  FConnection.LoginPrompt := False;
end;

destructor TQueryEngine.Destroy;
begin
  FQuery.Free;
  FConnection.Free;
  inherited;
end;

class function TQueryEngine.New: IQueryEngine;
begin
  Result := TQueryEngine.Create;
end;

procedure TQueryEngine.ConfigureConnection;
begin
  if not Assigned(FConexaoModel) then
    raise Exception.Create('Conexão não informada para o motor de consultas.');

  FConnection.Connected := False;
  FConnection.Params.Clear;
  FConnection.Params.DriverID := FConexaoModel.Driver;
  FConnection.Params.Database := FConexaoModel.Banco;
  FConnection.Params.UserName := FConexaoModel.Usuario;
  FConnection.Params.Password := FConexaoModel.Senha;
  FConnection.Params.Values['Server'] := FConexaoModel.Servidor;
  
  if FConexaoModel.Porta > 0 then
    FConnection.Params.Values['Port'] := FConexaoModel.Porta.ToString;
    
  // Configurações extras para estabilidade em queries dinâmicas
  FConnection.FormatOptions.MapRules.Clear;
  FConnection.UpdateOptions.ReadOnly := True;
end;

procedure TQueryEngine.EnsureConnection;
begin
  if not FConnection.Connected then
    ConfigureConnection;
    
  FConnection.Connected := True;
end;

function TQueryEngine.Execute: Integer;
begin
  EnsureConnection;
  FQuery.ExecSQL;
  Result := FQuery.RowsAffected;
end;

function TQueryEngine.Open: TDataSet;
begin
  EnsureConnection;
  FQuery.Open;
  Result := FQuery;
end;

function TQueryEngine.Param(const AName: string; const AValue: Variant): IQueryEngine;
begin
  Result := Self;
  FQuery.ParamByName(AName).Value := AValue;
end;

function TQueryEngine.SetConnection(const AValue: IConexao): IQueryEngine;
begin
  Result := Self;
  if FConexaoModel <> AValue then
  begin
    FConexaoModel := AValue;
    FConnection.Connected := False;
  end;
end;

function TQueryEngine.SQL(const AValue: string): IQueryEngine;
begin
  Result := Self;
  FQuery.Close;
  FQuery.SQL.Text := AValue;
end;

end.
