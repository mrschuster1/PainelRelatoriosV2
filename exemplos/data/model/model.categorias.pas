unit model.categorias;

interface

type
  ICategoria = interface
    ['{C5D4B6C1-2895-4E7F-A841-B89B2B6471E2}']
    function GetId: Integer;
    procedure SetId(const Value: Integer);
    function GetCategoria: string;
    procedure SetCategoria(const Value: string);
    function GetAtiva: string;
    procedure SetAtiva(const Value: string);

    property Id: Integer read GetId write SetId;
    property Categoria: string read GetCategoria write SetCategoria;
    property Ativa: string read GetAtiva write SetAtiva;
  end;

  TCategoria = class(TInterfacedObject, ICategoria)
  private
    FId: Integer;
    FCategoria: string;
    FAtiva: string;
    function GetId: Integer;
    procedure SetId(const Value: Integer);
    function GetCategoria: string;
    procedure SetCategoria(const Value: string);
    function GetAtiva: string;
    procedure SetAtiva(const Value: string);
  public
    property Id: Integer read GetId write SetId;
    property Categoria: string read GetCategoria write SetCategoria;
    property Ativa: string read GetAtiva write SetAtiva;
  end;

function NewCategoria: ICategoria;

implementation

function NewCategoria: ICategoria;
begin
  Result := TCategoria.Create;
end;

{ TCategoria }

function TCategoria.GetAtiva: string;
begin
  Result := FAtiva;
end;

function TCategoria.GetCategoria: string;
begin
  Result := FCategoria;
end;

function TCategoria.GetId: Integer;
begin
  Result := FId;
end;

procedure TCategoria.SetAtiva(const Value: string);
begin
  FAtiva := Value;
end;

procedure TCategoria.SetCategoria(const Value: string);
begin
  FCategoria := Value;
end;

procedure TCategoria.SetId(const Value: Integer);
begin
  FId := Value;
end;

end.
