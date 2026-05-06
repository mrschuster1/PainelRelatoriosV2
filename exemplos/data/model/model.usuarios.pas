unit model.usuarios;

interface

type
  IUsuario = interface
    ['{C3D4E5F6-7890-ABCD-EF12-34567890ABCD}']
    function GetId: Integer;
    procedure SetId(const Value: Integer);
    function GetNome: string;
    procedure SetNome(const Value: string);
    function GetSenha: string;
    procedure SetSenha(const Value: string);
    function GetRamal: Integer;
    procedure SetRamal(const Value: Integer);
    function GetCelular: string;
    procedure SetCelular(const Value: string);
    function GetTele: string;
    procedure SetTele(const Value: string);
    function GetAnalista: string;
    procedure SetAnalista(const Value: string);
    function GetGerencial: string;
    procedure SetGerencial(const Value: string);
    function GetPre: string;
    procedure SetPre(const Value: string);
    function GetVeiculo: string;
    procedure SetVeiculo(const Value: string);
    function GetValorKM: Double;
    procedure SetValorKM(const Value: Double);
    function GetAtivo: string;
    procedure SetAtivo(const Value: string);
    function GetKmCarro: Double;
    procedure SetKmCarro(const Value: Double);
    function GetImplantacao: string;
    procedure SetImplantacao(const Value: string);
    function GetFinanceiro: string;
    procedure SetFinanceiro(const Value: string);
    function GetComercial: string;
    procedure SetComercial(const Value: string);
    function GetSetor: Integer;
    procedure SetSetor(const Value: Integer);
    function GetSalarioBase: Double;
    procedure SetSalarioBase(const Value: Double);
    function GetPerfilComissao: Integer;
    procedure SetPerfilComissao(const Value: Integer);
    function GetPercMA1: Double;
    procedure SetPercMA1(const Value: Double);
    function GetPercMA2: Double;
    procedure SetPercMA2(const Value: Double);
    function GetPercMA3: Double;
    procedure SetPercMA3(const Value: Double);
    function GetPercCI: Double;
    procedure SetPercCI(const Value: Double);
    function GetSistemasQueAtende: string;
    procedure SetSistemasQueAtende(const Value: string);

    property Id: Integer read GetId write SetId;
    property Nome: string read GetNome write SetNome;
    property Senha: string read GetSenha write SetSenha;
    property Ramal: Integer read GetRamal write SetRamal;
    property Celular: string read GetCelular write SetCelular;
    property Tele: string read GetTele write SetTele;
    property Analista: string read GetAnalista write SetAnalista;
    property Gerencial: string read GetGerencial write SetGerencial;
    property Pre: string read GetPre write SetPre;
    property Veiculo: string read GetVeiculo write SetVeiculo;
    property ValorKM: Double read GetValorKM write SetValorKM;
    property Ativo: string read GetAtivo write SetAtivo;
    property KmCarro: Double read GetKmCarro write SetKmCarro;
    property Implantacao: string read GetImplantacao write SetImplantacao;
    property Financeiro: string read GetFinanceiro write SetFinanceiro;
    property Comercial: string read GetComercial write SetComercial;
    property Setor: Integer read GetSetor write SetSetor;
    property SalarioBase: Double read GetSalarioBase write SetSalarioBase;
    property PerfilComissao: Integer read GetPerfilComissao write SetPerfilComissao;
    property PercMA1: Double read GetPercMA1 write SetPercMA1;
    property PercMA2: Double read GetPercMA2 write SetPercMA2;
    property PercMA3: Double read GetPercMA3 write SetPercMA3;
    property PercCI: Double read GetPercCI write SetPercCI;
    property SistemasQueAtende: string read GetSistemasQueAtende write SetSistemasQueAtende;
  end;

  TUsuario = class(TInterfacedObject, IUsuario)
  private
    FId: Integer;
    FNome: string;
    FSenha: string;
    FRamal: Integer;
    FCelular: string;
    FTele: string;
    FAnalista: string;
    FGerencial: string;
    FPre: string;
    FVeiculo: string;
    FValorKM: Double;
    FAtivo: string;
    FKmCarro: Double;
    FImplantacao: string;
    FFinanceiro: string;
    FComercial: string;
    FSetor: Integer;
    FSalarioBase: Double;
    FPerfilComissao: Integer;
    FPercMA1: Double;
    FPercMA2: Double;
    FPercMA3: Double;
    FPercCI: Double;
    FSistemasQueAtende: string;

    function GetId: Integer;
    procedure SetId(const Value: Integer);
    function GetNome: string;
    procedure SetNome(const Value: string);
    function GetSenha: string;
    procedure SetSenha(const Value: string);
    function GetRamal: Integer;
    procedure SetRamal(const Value: Integer);
    function GetCelular: string;
    procedure SetCelular(const Value: string);
    function GetTele: string;
    procedure SetTele(const Value: string);
    function GetAnalista: string;
    procedure SetAnalista(const Value: string);
    function GetGerencial: string;
    procedure SetGerencial(const Value: string);
    function GetPre: string;
    procedure SetPre(const Value: string);
    function GetVeiculo: string;
    procedure SetVeiculo(const Value: string);
    function GetValorKM: Double;
    procedure SetValorKM(const Value: Double);
    function GetAtivo: string;
    procedure SetAtivo(const Value: string);
    function GetKmCarro: Double;
    procedure SetKmCarro(const Value: Double);
    function GetImplantacao: string;
    procedure SetImplantacao(const Value: string);
    function GetFinanceiro: string;
    procedure SetFinanceiro(const Value: string);
    function GetComercial: string;
    procedure SetComercial(const Value: string);
    function GetSetor: Integer;
    procedure SetSetor(const Value: Integer);
    function GetSalarioBase: Double;
    procedure SetSalarioBase(const Value: Double);
    function GetPerfilComissao: Integer;
    procedure SetPerfilComissao(const Value: Integer);
    function GetPercMA1: Double;
    procedure SetPercMA1(const Value: Double);
    function GetPercMA2: Double;
    procedure SetPercMA2(const Value: Double);
    function GetPercMA3: Double;
    procedure SetPercMA3(const Value: Double);
    function GetPercCI: Double;
    procedure SetPercCI(const Value: Double);
    function GetSistemasQueAtende: string;
    procedure SetSistemasQueAtende(const Value: string);
  public
  end;

function NewUsuario: IUsuario;

implementation

function NewUsuario: IUsuario;
begin
  Result := TUsuario.Create;
end;

{ TUsuario }

function TUsuario.GetId: Integer; begin Result := FId; end;
procedure TUsuario.SetId(const Value: Integer); begin FId := Value; end;
function TUsuario.GetNome: string; begin Result := FNome; end;
procedure TUsuario.SetNome(const Value: string); begin FNome := Value; end;
function TUsuario.GetSenha: string; begin Result := FSenha; end;
procedure TUsuario.SetSenha(const Value: string); begin FSenha := Value; end;
function TUsuario.GetRamal: Integer; begin Result := FRamal; end;
procedure TUsuario.SetRamal(const Value: Integer); begin FRamal := Value; end;
function TUsuario.GetCelular: string; begin Result := FCelular; end;
procedure TUsuario.SetCelular(const Value: string); begin FCelular := Value; end;
function TUsuario.GetTele: string; begin Result := FTele; end;
procedure TUsuario.SetTele(const Value: string); begin FTele := Value; end;
function TUsuario.GetAnalista: string; begin Result := FAnalista; end;
procedure TUsuario.SetAnalista(const Value: string); begin FAnalista := Value; end;
function TUsuario.GetGerencial: string; begin Result := FGerencial; end;
procedure TUsuario.SetGerencial(const Value: string); begin FGerencial := Value; end;
function TUsuario.GetPre: string; begin Result := FPre; end;
procedure TUsuario.SetPre(const Value: string); begin FPre := Value; end;
function TUsuario.GetVeiculo: string; begin Result := FVeiculo; end;
procedure TUsuario.SetVeiculo(const Value: string); begin FVeiculo := Value; end;
function TUsuario.GetValorKM: Double; begin Result := FValorKM; end;
procedure TUsuario.SetValorKM(const Value: Double); begin FValorKM := Value; end;
function TUsuario.GetAtivo: string; begin Result := FAtivo; end;
procedure TUsuario.SetAtivo(const Value: string); begin FAtivo := Value; end;
function TUsuario.GetKmCarro: Double; begin Result := FKmCarro; end;
procedure TUsuario.SetKmCarro(const Value: Double); begin FKmCarro := Value; end;
function TUsuario.GetImplantacao: string; begin Result := FImplantacao; end;
procedure TUsuario.SetImplantacao(const Value: string); begin FImplantacao := Value; end;
function TUsuario.GetFinanceiro: string; begin Result := FFinanceiro; end;
procedure TUsuario.SetFinanceiro(const Value: string); begin FFinanceiro := Value; end;
function TUsuario.GetComercial: string; begin Result := FComercial; end;
procedure TUsuario.SetComercial(const Value: string); begin FComercial := Value; end;
function TUsuario.GetSetor: Integer; begin Result := FSetor; end;
procedure TUsuario.SetSetor(const Value: Integer); begin FSetor := Value; end;
function TUsuario.GetSalarioBase: Double; begin Result := FSalarioBase; end;
procedure TUsuario.SetSalarioBase(const Value: Double); begin FSalarioBase := Value; end;
function TUsuario.GetPerfilComissao: Integer; begin Result := FPerfilComissao; end;
procedure TUsuario.SetPerfilComissao(const Value: Integer); begin FPerfilComissao := Value; end;
function TUsuario.GetPercMA1: Double; begin Result := FPercMA1; end;
procedure TUsuario.SetPercMA1(const Value: Double); begin FPercMA1 := Value; end;
function TUsuario.GetPercMA2: Double; begin Result := FPercMA2; end;
procedure TUsuario.SetPercMA2(const Value: Double); begin FPercMA2 := Value; end;
function TUsuario.GetPercMA3: Double; begin Result := FPercMA3; end;
procedure TUsuario.SetPercMA3(const Value: Double); begin FPercMA3 := Value; end;
function TUsuario.GetPercCI: Double; begin Result := FPercCI; end;
procedure TUsuario.SetPercCI(const Value: Double); begin FPercCI := Value; end;
function TUsuario.GetSistemasQueAtende: string; begin Result := FSistemasQueAtende; end;
procedure TUsuario.SetSistemasQueAtende(const Value: string); begin FSistemasQueAtende := Value; end;

end.
