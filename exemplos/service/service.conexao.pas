unit service.conexao;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  model.conexao,
  repository.conexao,
  FireDAC.Comp.Client,
  FireDAC.Phys.Intf;

type
  IConexaoService = interface
    ['{D1E2F3A4-B5C6-4D7E-8F90-A1B2C3D4E5F6}']
    function Listar: TList<IConexao>;
    function ObterPorId(AId: Integer): IConexao;
    function Salvar(AConexao: IConexao): IConexaoService;
    function Excluir(AId: Integer): IConexaoService;
    function TestarConexao(AConexao: IConexao): Boolean;
  end;

  TConexaoService = class(TInterfacedObject, IConexaoService)
  private
    FRepository: IConexaoRepository;
    constructor Create;
  public
    class function New: IConexaoService;
    function Listar: TList<IConexao>;
    function ObterPorId(AId: Integer): IConexao;
    function Salvar(AConexao: IConexao): IConexaoService;
    function Excluir(AId: Integer): IConexaoService;
    function TestarConexao(AConexao: IConexao): Boolean;
  end;

implementation

uses
  data.connection;

{ TConexaoService }

constructor TConexaoService.Create;
begin
  FRepository := TConexaoRepository.Create(TConnection.GetDefaultConnection);
end;

function TConexaoService.Excluir(AId: Integer): IConexaoService;
begin
  Result := Self;
  FRepository.Delete(AId);
end;

function TConexaoService.Listar: TList<IConexao>;
begin
  Result := FRepository.GetAll;
end;

class function TConexaoService.New: IConexaoService;
begin
  Result := TConexaoService.Create;
end;

function TConexaoService.ObterPorId(AId: Integer): IConexao;
begin
  Result := FRepository.GetById(AId);
end;

function TConexaoService.Salvar(AConexao: IConexao): IConexaoService;
begin
  Result := Self;
  if AConexao.Nome.Trim.IsEmpty then
    raise Exception.Create('O nome da conexão é obrigatório.');
    
  FRepository.Save(AConexao);
end;

function TConexaoService.TestarConexao(AConexao: IConexao): Boolean;
var
  LConn: TFDConnection;
begin
  Result := False;
  LConn := TFDConnection.Create(nil);
  try
    LConn.Params.Clear;
    LConn.Params.DriverID := AConexao.Driver;
    LConn.Params.Database := AConexao.Banco;
    LConn.Params.UserName := AConexao.Usuario;
    LConn.Params.Password := AConexao.Senha;
    LConn.Params.Values['Server'] := AConexao.Servidor;
    if AConexao.Porta > 0 then
      LConn.Params.Values['Port'] := AConexao.Porta.ToString;
    
    LConn.LoginPrompt := False;
    try
      LConn.Connected := True;
      Result := LConn.Connected;
    except
      on E: Exception do
        raise Exception.Create('Falha ao testar conexão: ' + E.Message);
    end;
  finally
    LConn.Free;
  end;
end;

end.
