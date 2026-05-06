unit model.celulas;

interface

type
  ICelula = interface
    ['{12A4F8E5-7798-4B2D-8C56-ECA8C1265B50}']
    function GetId: Integer;
    procedure SetId(const Value: Integer);
    function GetCelula: string;
    procedure SetCelula(const Value: string);
    function GetAtiva: string;
    procedure SetAtiva(const Value: string);

    property Id: Integer read GetId write SetId;
    property Celula: string read GetCelula write SetCelula;
    property Ativa: string read GetAtiva write SetAtiva;
  end;

  TCelula = class(TInterfacedObject, ICelula)
  private
    FId: Integer;
    FCelula: string;
    FAtiva: string;
    function GetId: Integer;
    procedure SetId(const Value: Integer);
    function GetCelula: string;
    procedure SetCelula(const Value: string);
    function GetAtiva: string;
    procedure SetAtiva(const Value: string);
  public
    property Id: Integer read GetId write SetId;
    property Celula: string read GetCelula write SetCelula;
    property Ativa: string read GetAtiva write SetAtiva;
  end;

function NewCelula: ICelula;

implementation

function NewCelula: ICelula;
begin
  Result := TCelula.Create;
end;

{ TCelula }

function TCelula.GetAtiva: string;
begin
  Result := FAtiva;
end;

function TCelula.GetCelula: string;
begin
  Result := FCelula;
end;

function TCelula.GetId: Integer;
begin
  Result := FId;
end;

procedure TCelula.SetAtiva(const Value: string);
begin
  FAtiva := Value;
end;

procedure TCelula.SetCelula(const Value: string);
begin
  FCelula := Value;
end;

procedure TCelula.SetId(const Value: Integer);
begin
  FId := Value;
end;

end.
