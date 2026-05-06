unit model.cidades;

interface

type
  ICidade = interface
    ['{B2C3D4E5-F6A7-8901-BCDE-F12345678902}']
    function GetId: Integer;
    procedure SetId(const Value: Integer);
    function GetCidade: string;
    procedure SetCidade(const Value: string);
    function GetUF: string;
    procedure SetUF(const Value: string);
    function GetAtiva: string;
    procedure SetAtiva(const Value: string);

    property Id: Integer read GetId write SetId;
    property Cidade: string read GetCidade write SetCidade;
    property UF: string read GetUF write SetUF;
    property Ativa: string read GetAtiva write SetAtiva;
  end;

  TCidade = class(TInterfacedObject, ICidade)
  private
    FId: Integer;
    FCidade: string;
    FUF: string;
    FAtiva: string;
    function GetId: Integer;
    procedure SetId(const Value: Integer);
    function GetCidade: string;
    procedure SetCidade(const Value: string);
    function GetUF: string;
    procedure SetUF(const Value: string);
    function GetAtiva: string;
    procedure SetAtiva(const Value: string);
  public
    class function New: ICidade;
  end;

function NewCidade: ICidade;

implementation

function NewCidade: ICidade;
begin
  Result := TCidade.New;
end;

{ TCidade }

class function TCidade.New: ICidade;
begin
  Result := Self.Create;
end;

function TCidade.GetId: Integer; begin Result := FId; end;
procedure TCidade.SetId(const Value: Integer); begin FId := Value; end;

function TCidade.GetCidade: string; begin Result := FCidade; end;
procedure TCidade.SetCidade(const Value: string); begin FCidade := Value; end;

function TCidade.GetUF: string; begin Result := FUF; end;
procedure TCidade.SetUF(const Value: string); begin FUF := Value; end;

function TCidade.GetAtiva: string; begin Result := FAtiva; end;
procedure TCidade.SetAtiva(const Value: string); begin FAtiva := Value; end;

end.
