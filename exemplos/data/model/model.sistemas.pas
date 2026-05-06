unit model.sistemas;

interface

type
  ISistema = interface
    ['{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}']
    function GetId: Integer;
    procedure SetId(const Value: Integer);
    function GetSistema: string;
    procedure SetSistema(const Value: string);
    function GetAtivo: string;
    procedure SetAtivo(const Value: string);
    function IsAtivo: Boolean;

    property Id: Integer read GetId write SetId;
    property Sistema: string read GetSistema write SetSistema;
    property Ativo: string read GetAtivo write SetAtivo;
  end;

  TSistema = class(TInterfacedObject, ISistema)
  private
    FId: Integer;
    FSistema: string;
    FAtivo: string;
    function GetId: Integer;
    procedure SetId(const Value: Integer);
    function GetSistema: string;
    procedure SetSistema(const Value: string);
    function GetAtivo: string;
    procedure SetAtivo(const Value: string);
  public
    function IsAtivo: Boolean;

    property Id: Integer read GetId write SetId;
    property Sistema: string read GetSistema write SetSistema;
    property Ativo: string read GetAtivo write SetAtivo;
  end;

function NewSistema: ISistema;

implementation

function NewSistema: ISistema;
begin
  Result := TSistema.Create;
end;

{ TSistema }

function TSistema.GetId: Integer;
begin
  Result := FId;
end;

procedure TSistema.SetId(const Value: Integer);
begin
  FId := Value;
end;

function TSistema.GetSistema: string;
begin
  Result := FSistema;
end;

procedure TSistema.SetSistema(const Value: string);
begin
  FSistema := Value;
end;

function TSistema.GetAtivo: string;
begin
  Result := FAtivo;
end;

procedure TSistema.SetAtivo(const Value: string);
begin
  FAtivo := Value;
end;

function TSistema.IsAtivo: Boolean;
begin
  Result := FAtivo = 'S';
end;

end.
