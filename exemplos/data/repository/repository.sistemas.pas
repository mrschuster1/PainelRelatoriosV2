unit repository.sistemas;

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
  model.sistemas;

type
  ISistemasRepository = interface
    ['{B2C3D4E5-F6A7-8901-BCDE-F12345678901}']
    function GetAll: TList<ISistema>;
    function GetById(AId: Integer): ISistema;
    function GetAtivos: TList<ISistema>;
    procedure Insert(ASistema: ISistema);
    procedure Update(ASistema: ISistema);
    procedure Delete(AId: Integer);
  end;

  TSistemasRepository = class(TBaseRepository<ISistema>, ISistemasRepository)
  protected
    function MapRow(AQuery: TFDQuery): ISistema; override;
  public

    function GetAll: TList<ISistema>;
    function GetById(AId: Integer): ISistema;
    function GetAtivos: TList<ISistema>;
    procedure Insert(ASistema: ISistema);
    procedure Update(ASistema: ISistema);
    procedure Delete(AId: Integer);
  end;

function NewSistemasRepository: ISistemasRepository;

implementation

function NewSistemasRepository: ISistemasRepository;
begin
  Result := TSistemasRepository.Create(TConnection.GetDefaultConnection);
end;

{ TSistemasRepository }

function TSistemasRepository.MapRow(AQuery: TFDQuery): ISistema;
begin
  Result := NewSistema;
  Result.Id := AQuery.FieldByName('Id').AsInteger;
  Result.Sistema := AQuery.FieldByName('Sistema').AsString;
  Result.Ativo := AQuery.FieldByName('Ativo').AsString;
end;

function TSistemasRepository.GetAll: TList<ISistema>;
var
  Query: TFDQuery;
begin
  Result := TList<ISistema>.Create;
  Query := CreateQuery;
  try
    Query.SQL.Text := 'SELECT Id, Sistema, Ativo FROM sistemas ORDER BY 1';
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

function TSistemasRepository.GetById(AId: Integer): ISistema;
var
  Query: TFDQuery;
begin
  Result := nil;
  Query := CreateQuery;
  try
    Query.SQL.Text := 'SELECT Id, Sistema, Ativo FROM sistemas WHERE Id = :Id';
    Query.ParamByName('Id').AsInteger := AId;
    Query.Open;

    if not Query.IsEmpty then
      Result := MapRow(Query);
  finally
    Query.Free;
  end;
end;

function TSistemasRepository.GetAtivos: TList<ISistema>;
var
  Query: TFDQuery;
begin
  Result := TList<ISistema>.Create;
  Query := CreateQuery;
  try
    Query.SQL.Text :=
      'SELECT Id, Sistema, Ativo FROM sistemas WHERE Ativo = ''S'' ORDER BY 1';
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

procedure TSistemasRepository.Insert(ASistema: ISistema);
var
  Query: TFDQuery;
begin
  Query := CreateQuery;
  try
    Query.SQL.Text :=
      'INSERT INTO sistemas (Sistema, Ativo) VALUES (:Sistema, :Ativo)';
    Query.ParamByName('Sistema').AsString := ASistema.Sistema;
    Query.ParamByName('Ativo').AsString := ASistema.Ativo;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

procedure TSistemasRepository.Update(ASistema: ISistema);
var
  Query: TFDQuery;
begin
  Query := CreateQuery;
  try
    Query.SQL.Text :=
      'UPDATE sistemas SET Sistema = :Sistema, Ativo = :Ativo WHERE Id = :Id';
    Query.ParamByName('Sistema').AsString := ASistema.Sistema;
    Query.ParamByName('Ativo').AsString := ASistema.Ativo;
    Query.ParamByName('Id').AsInteger := ASistema.Id;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

procedure TSistemasRepository.Delete(AId: Integer);
var
  Query: TFDQuery;
begin
  Query := CreateQuery;
  try
    Query.SQL.Text := 'DELETE FROM sistemas WHERE Id = :Id';
    Query.ParamByName('Id').AsInteger := AId;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

end.
