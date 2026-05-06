unit repository.categorias;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  data.connection,
  repository.base,
  model.categorias;

type
  ICategoriasRepository = interface
    ['{E2B4B2D8-A93E-4158-941A-B47C1C98F873}']
    function GetAtivas: TList<ICategoria>;
    function GetAll: TList<ICategoria>;
  end;

  TCategoriasRepository = class(TBaseRepository<ICategoria>, ICategoriasRepository)
  protected
    function MapRow(AQuery: TFDQuery): ICategoria; override;
  public

    function GetAtivas: TList<ICategoria>;
    function GetAll: TList<ICategoria>;
  end;

function NewCategoriasRepository: ICategoriasRepository;

implementation

function NewCategoriasRepository: ICategoriasRepository;
begin
  Result := TCategoriasRepository.Create(TConnection.GetDefaultConnection);
end;

{ TCategoriasRepository }

function TCategoriasRepository.MapRow(AQuery: TFDQuery): ICategoria;
begin
  Result := NewCategoria;
  Result.Id := AQuery.FieldByName('Id').AsInteger;
  Result.Categoria := AQuery.FieldByName('Categoria').AsString;
  Result.Ativa := AQuery.FieldByName('Ativa').AsString;
end;

function TCategoriasRepository.GetAll: TList<ICategoria>;
var
  Query: TFDQuery;
begin
  Result := TList<ICategoria>.Create;
  Query := CreateQuery;
  try
    Query.SQL.Text := 'SELECT Id, Categoria, Ativa FROM categorias ORDER BY Categoria';
    Query.Open;

    while not Query.Eof do
    begin
      Result.Add(MapRow(Query));
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

function TCategoriasRepository.GetAtivas: TList<ICategoria>;
var
  Query: TFDQuery;
begin
  Result := TList<ICategoria>.Create;
  Query := CreateQuery;
  try
    Query.SQL.Text := 'SELECT Id, Categoria, Ativa FROM categorias WHERE Ativa = ''S'' ORDER BY Categoria';
    Query.Open;

    while not Query.Eof do
    begin
      Result.Add(MapRow(Query));
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

end.

