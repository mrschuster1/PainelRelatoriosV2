unit model.conexao;

interface

type
  IConexao = interface
    ['{FCB12E34-5678-90AB-CDEF-1234567890BC}']
    function GetId: Integer;
    function SetId(const Value: Integer): IConexao;
    function GetNome: string;
    function SetNome(const Value: string): IConexao;
    function GetDriver: string;
    function SetDriver(const Value: string): IConexao;
    function GetServidor: string;
    function SetServidor(const Value: string): IConexao;
    function GetBanco: string;
    function SetBanco(const Value: string): IConexao;
    function GetUsuario: string;
    function SetUsuario(const Value: string): IConexao;
    function GetSenha: string;
    function SetSenha(const Value: string): IConexao;
    function GetPorta: Integer;
    function SetPorta(const Value: Integer): IConexao;
    
    property Id: Integer read GetId;
    property Nome: string read GetNome;
    property Driver: string read GetDriver;
    property Servidor: string read GetServidor;
    property Banco: string read GetBanco;
    property Usuario: string read GetUsuario;
    property Senha: string read GetSenha;
    property Porta: Integer read GetPorta;
  end;

  TConexao = class(TInterfacedObject, IConexao)
  private
    FId: Integer;
    FNome: string;
    FDriver: string;
    FServidor: string;
    FBanco: string;
    FUsuario: string;
    FSenha: string;
    FPorta: Integer;
  public
    function GetId: Integer;
    function SetId(const Value: Integer): IConexao;
    function GetNome: string;
    function SetNome(const Value: string): IConexao;
    function GetDriver: string;
    function SetDriver(const Value: string): IConexao;
    function GetServidor: string;
    function SetServidor(const Value: string): IConexao;
    function GetBanco: string;
    function SetBanco(const Value: string): IConexao;
    function GetUsuario: string;
    function SetUsuario(const Value: string): IConexao;
    function GetSenha: string;
    function SetSenha(const Value: string): IConexao;
    function GetPorta: Integer;
    function SetPorta(const Value: Integer): IConexao;

    class function New: IConexao;
  end;

implementation

{ TConexao }

class function TConexao.New: IConexao;
begin
  Result := TConexao.Create;
end;

function TConexao.GetId: Integer;
begin
  Result := FId;
end;

function TConexao.SetId(const Value: Integer): IConexao;
begin
  Result := Self;
  FId := Value;
end;

function TConexao.GetNome: string;
begin
  Result := FNome;
end;

function TConexao.SetNome(const Value: string): IConexao;
begin
  Result := Self;
  FNome := Value;
end;

function TConexao.GetDriver: string;
begin
  Result := FDriver;
end;

function TConexao.SetDriver(const Value: string): IConexao;
begin
  Result := Self;
  FDriver := Value;
end;

function TConexao.GetServidor: string;
begin
  Result := FServidor;
end;

function TConexao.SetServidor(const Value: string): IConexao;
begin
  Result := Self;
  FServidor := Value;
end;

function TConexao.GetBanco: string;
begin
  Result := FBanco;
end;

function TConexao.SetBanco(const Value: string): IConexao;
begin
  Result := Self;
  FBanco := Value;
end;

function TConexao.GetUsuario: string;
begin
  Result := FUsuario;
end;

function TConexao.SetUsuario(const Value: string): IConexao;
begin
  Result := Self;
  FUsuario := Value;
end;

function TConexao.GetSenha: string;
begin
  Result := FSenha;
end;

function TConexao.SetSenha(const Value: string): IConexao;
begin
  Result := Self;
  FSenha := Value;
end;

function TConexao.GetPorta: Integer;
begin
  Result := FPorta;
end;

function TConexao.SetPorta(const Value: Integer): IConexao;
begin
  Result := Self;
  FPorta := Value;
end;

end.
