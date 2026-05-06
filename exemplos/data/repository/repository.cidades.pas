unit repository.cidades;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  Data.connection,
  FireDAC.Stan.Param,
  repository.base,
  model.cidades;

type
  ICidadesRepository = interface
    ['{B2C3D4E5-F6A7-8901-BCDE-F12345678903}']
    function GetAll: TList<ICidade>;
    function GetAtivas: TList<ICidade>;
  end;

  TCidadesRepository = class(TBaseRepository<ICidade>, ICidadesRepository)
  protected
    function MapRow(AQuery: TFDQuery): ICidade; override;
  public
    function GetAll: TList<ICidade>;
    function GetAtivas: TList<ICidade>;
  end;

function NewCidadesRepository: ICidadesRepository;

implementation

function NewCidadesRepository: ICidadesRepository;
begin
  Result := TCidadesRepository.Create(TConnection.GetDefaultConnection);
end;

{ TCidadesRepository }

function TCidadesRepository.MapRow(AQuery: TFDQuery): ICidade;
begin
  Result := NewCidade;
  Result.Id := AQuery.FieldByName('Id').AsInteger;
  Result.Cidade := AQuery.FieldByName('Cidade').AsString;
  Result.UF := AQuery.FieldByName('UF').AsString;
  Result.Ativa := AQuery.FieldByName('Ativa').AsString;
end;

function TCidadesRepository.GetAll: TList<ICidade>;
var
  Query: TFDQuery;
begin
  Result := TList<ICidade>.Create;
  Query := CreateQuery;
  try
    Query.SQL.Text := 'SELECT Id, Cidade, UF, Ativa FROM cidades ORDER BY Cidade';
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

function TCidadesRepository.GetAtivas: TList<ICidade>;
var
  Query: TFDQuery;
begin
  Result := TList<ICidade>.Create;
  Query := CreateQuery;
  try
    Query.SQL.Text :=
      'SELECT Id, Cidade, UF, Ativa FROM cidades WHERE Ativa = ''S'' ORDER BY Cidade';
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
