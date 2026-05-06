unit repository.celulas;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  data.connection,
  repository.base,
  model.celulas;

type
  ICelulasRepository = interface
    ['{8A1E6B9D-2C4F-407A-9D3E-5E1C3F7A9B2D}']
    function GetAtivas: TList<ICelula>;
  end;

  TCelulasRepository = class(TBaseRepository<ICelula>, ICelulasRepository)
  protected
    function MapRow(AQuery: TFDQuery): ICelula; override;
  public

    function GetAtivas: TList<ICelula>;
  end;

function NewCelulasRepository: ICelulasRepository;

implementation

function NewCelulasRepository: ICelulasRepository;
begin
  Result := TCelulasRepository.Create(TConnection.GetDefaultConnection);
end;

{ TCelulasRepository }

function TCelulasRepository.MapRow(AQuery: TFDQuery): ICelula;
begin
  Result := NewCelula;
  Result.Id := AQuery.FieldByName('Id').AsInteger;
  Result.Celula := AQuery.FieldByName('Celula').AsString;
  Result.Ativa := AQuery.FieldByName('Ativa').AsString;
end;

function TCelulasRepository.GetAtivas: TList<ICelula>;
var
  Query: TFDQuery;
begin
  Result := TList<ICelula>.Create;
  Query := CreateQuery;
  try
    Query.SQL.Text := 'SELECT Id, Celula, Ativa FROM celulas WHERE Ativa = ''S'' ORDER BY Celula';
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

