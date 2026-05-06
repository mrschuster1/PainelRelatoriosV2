unit data.connection;

interface

uses
  System.SysUtils,
  System.Classes,
  Winapi.Windows,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client,
  // Drivers
  FireDAC.Phys.MySQLDef,
  FireDAC.Phys.MySQL,
  FireDAC.Phys.FBDef,
  FireDAC.Phys.FB,
  FireDAC.Phys.PGDef,
  FireDAC.Phys.PG,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Phys.SQLite,
  // Helpers
  helper.ini, Data.DB;

type
  IConnection = interface
    ['{F4D5E6C7-B8A9-40D1-B2C3-A4F5E6B7C8D9}']
    function GetConnection: TFDConnection;
    procedure Conectar;
    procedure Desconectar;
  end;

  TConnection = class(TDataModule, IConnection)
    FDConn: TFDConnection;
    MySQLDriver: TFDPhysMySQLDriverLink;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure FDConnBeforeConnect(Sender: TObject);
  private
    procedure CarregarConfigs;
  public
    class function New: IConnection;
    class function GetDefaultConnection: TFDConnection;
    
    procedure Conectar;
    procedure Desconectar;
    function GetConnection: TFDConnection;
    
    destructor Destroy; override;
  end;

implementation

uses Vcl.Forms;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

var
  FConnection: TConnection;
  FIsTerminating: Boolean = False;

{ TConnection }

procedure TConnection.CarregarConfigs;
begin
  FDConn.Params.Clear;
  FDConn.Params.DriverID := 'MySQL';

  FDConn.Params.Database := TIniHelper.GetValue('Conexao', 'Database', 'painel');
  FDConn.Params.UserName := TIniHelper.GetValue('Conexao', 'User_Name', 'root');
  FDConn.Params.Password := TIniHelper.GetValue('Conexao', 'Password', 'root');
  FDConn.Params.Values['Server'] := TIniHelper.GetValue('Conexao', 'Server', 'localhost');
  FDConn.Params.Values['Port'] := TIniHelper.GetValue('Conexao', 'Port', '3306');

  FDConn.Params.Values['CharacterSet'] := 'utf8';
  
  if SameText(FDConn.Params.DriverID, 'MySQL') then
    MySQLDriver.VendorLib := ExtractFilePath(ParamStr(0)) + 'lib\libmySQL.dll';
end;

procedure TConnection.Conectar;
begin
  try
    if not FDConn.Connected then
      FDConn.Connected := True;
  except
    on E: Exception do
      raise Exception.Create('Erro ao conectar ao banco interno: ' + E.Message);
  end;
end;

procedure TConnection.DataModuleCreate(Sender: TObject);
begin
  Conectar;
end;

procedure TConnection.DataModuleDestroy(Sender: TObject);
begin
  Desconectar;
end;

destructor TConnection.Destroy;
begin
  Desconectar;
  inherited;
end;

procedure TConnection.Desconectar;
begin
  if Assigned(FDConn) then
  begin
    if FDConn.Connected then
      FDConn.Connected := False;
  end;
end;

procedure TConnection.FDConnBeforeConnect(Sender: TObject);
begin
  CarregarConfigs;
end;

function TConnection.GetConnection: TFDConnection;
begin
  Result := FDConn;
end;

class function TConnection.GetDefaultConnection: TFDConnection;
begin
  Result := TConnection.New.GetConnection;
end;

class function TConnection.New: IConnection;
begin
  if FIsTerminating then
    Exit(nil);

  if not Assigned(FConnection) then
    FConnection := TConnection.Create(Application);
    
  Result := FConnection;
end;

initialization

finalization
  FIsTerminating := True;
  if Assigned(FConnection) then
    FConnection.Free;

end.


