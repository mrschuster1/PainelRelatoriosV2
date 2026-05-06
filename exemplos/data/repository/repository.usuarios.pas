unit repository.usuarios;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  Data.DB,
  data.connection,
  FireDAC.Stan.Param,
  repository.base,
  model.usuarios;

type
  IUsuariosRepository = interface
    ['{B1C2D3E4-F5A6-7890-ABCD-E1234567890A}']
    function GetAll: TList<IUsuario>;
    function GetById(AId: Integer): IUsuario;
    function GetAtivos: TList<IUsuario>;
    function GetAnalistas: TList<IUsuario>;
    procedure Insert(AUsuario: IUsuario);
    procedure Update(AUsuario: IUsuario);
    procedure Delete(AId: Integer);
  end;

  TUsuariosRepository = class(TBaseRepository<IUsuario>, IUsuariosRepository)
  protected
    function MapRow(AQuery: TFDQuery): IUsuario; override;
  public
    function GetAll: TList<IUsuario>;
    function GetById(AId: Integer): IUsuario;
    function GetAtivos: TList<IUsuario>;
    function GetAnalistas: TList<IUsuario>;
    procedure Insert(AUsuario: IUsuario);
    procedure Update(AUsuario: IUsuario);
    procedure Delete(AId: Integer);
  end;

function NewUsuariosRepository: IUsuariosRepository;

implementation

function NewUsuariosRepository: IUsuariosRepository;
begin
  Result := TUsuariosRepository.Create(TConnection.GetDefaultConnection);
end;

{ TUsuariosRepository }

function TUsuariosRepository.MapRow(AQuery: TFDQuery): IUsuario;
begin
  Result := NewUsuario;
  if AQuery.FindField('Id') <> nil then Result.Id := AQuery.FieldByName('Id').AsInteger;
  if AQuery.FindField('Nome') <> nil then Result.Nome := AQuery.FieldByName('Nome').AsString;
  if AQuery.FindField('Senha') <> nil then Result.Senha := AQuery.FieldByName('Senha').AsString;
  if AQuery.FindField('Ramal') <> nil then Result.Ramal := AQuery.FieldByName('Ramal').AsInteger;
  if AQuery.FindField('Celular') <> nil then Result.Celular := AQuery.FieldByName('Celular').AsString;
  if AQuery.FindField('Tele') <> nil then Result.Tele := AQuery.FieldByName('Tele').AsString;
  if AQuery.FindField('Analista') <> nil then Result.Analista := AQuery.FieldByName('Analista').AsString;
  if AQuery.FindField('Gerencial') <> nil then Result.Gerencial := AQuery.FieldByName('Gerencial').AsString;
  if AQuery.FindField('Pre') <> nil then Result.Pre := AQuery.FieldByName('Pre').AsString;
  if AQuery.FindField('Veiculo') <> nil then Result.Veiculo := AQuery.FieldByName('Veiculo').AsString;
  if AQuery.FindField('ValorKM') <> nil then Result.ValorKM := AQuery.FieldByName('ValorKM').AsFloat;
  if AQuery.FindField('Ativo') <> nil then Result.Ativo := AQuery.FieldByName('Ativo').AsString;
  if AQuery.FindField('KmCarro') <> nil then Result.KmCarro := AQuery.FieldByName('KmCarro').AsFloat;
  if AQuery.FindField('Implantacao') <> nil then Result.Implantacao := AQuery.FieldByName('Implantacao').AsString;
  if AQuery.FindField('Financeiro') <> nil then Result.Financeiro := AQuery.FieldByName('Financeiro').AsString;
  if AQuery.FindField('Comercial') <> nil then Result.Comercial := AQuery.FieldByName('Comercial').AsString;
  if AQuery.FindField('Setor') <> nil then Result.Setor := AQuery.FieldByName('Setor').AsInteger;
  if AQuery.FindField('SalarioBase') <> nil then Result.SalarioBase := AQuery.FieldByName('SalarioBase').AsFloat;
  if AQuery.FindField('PerfilComissao') <> nil then Result.PerfilComissao := AQuery.FieldByName('PerfilComissao').AsInteger;
  if AQuery.FindField('PercMA1') <> nil then Result.PercMA1 := AQuery.FieldByName('PercMA1').AsFloat;
  if AQuery.FindField('PercMA2') <> nil then Result.PercMA2 := AQuery.FieldByName('PercMA2').AsFloat;
  if AQuery.FindField('PercMA3') <> nil then Result.PercMA3 := AQuery.FieldByName('PercMA3').AsFloat;
  if AQuery.FindField('PercCI') <> nil then Result.PercCI := AQuery.FieldByName('PercCI').AsFloat;
  if AQuery.FindField('SistemasQueAtende') <> nil then Result.SistemasQueAtende := AQuery.FieldByName('SistemasQueAtende').AsString;
end;

function TUsuariosRepository.GetAll: TList<IUsuario>;
var
  Query: TFDQuery;
begin
  Result := TList<IUsuario>.Create;
  Query := CreateQuery;
  try
    Query.SQL.Text := 'SELECT * FROM usuarios ORDER BY 1';
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

function TUsuariosRepository.GetById(AId: Integer): IUsuario;
var
  Query: TFDQuery;
begin
  Result := nil;
  Query := CreateQuery;
  try
    Query.SQL.Text := 'SELECT * FROM usuarios WHERE Id = :Id';
    Query.ParamByName('Id').AsInteger := AId;
    Query.Open;

    if not Query.IsEmpty then
      Result := MapRow(Query);
  finally
    Query.Free;
  end;
end;

function TUsuariosRepository.GetAnalistas: TList<IUsuario>;
var
  Query: TFDQuery;
begin
  Result := TList<IUsuario>.Create;
  Query := CreateQuery;
  try
    Query.SQL.Text := 'SELECT * FROM usuarios WHERE Analista = ''S'' ORDER BY Nome';
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

function TUsuariosRepository.GetAtivos: TList<IUsuario>;
var
  Query: TFDQuery;
begin
  Result := TList<IUsuario>.Create;
  Query := CreateQuery;
  try
    Query.SQL.Text := 'SELECT * FROM usuarios WHERE Ativo = ''S'' ORDER BY Nome';
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

procedure TUsuariosRepository.Insert(AUsuario: IUsuario);
var
  Query: TFDQuery;
begin
  Query := CreateQuery;
  try
    Query.SQL.Text := 'INSERT INTO usuarios (Nome, Analista, Ativo) VALUES (:Nome, :Analista, :Ativo)';
    Query.ParamByName('Nome').AsString := AUsuario.Nome;
    Query.ParamByName('Analista').AsString := AUsuario.Analista;
    Query.ParamByName('Ativo').AsString := AUsuario.Ativo;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

procedure TUsuariosRepository.Update(AUsuario: IUsuario);
var
  Query: TFDQuery;
begin
  Query := CreateQuery;
  try
    Query.SQL.Text := 'UPDATE usuarios SET Nome = :Nome, Analista = :Analista, Ativo = :Ativo WHERE Id = :Id';
    Query.ParamByName('Nome').AsString := AUsuario.Nome;
    Query.ParamByName('Analista').AsString := AUsuario.Analista;
    Query.ParamByName('Ativo').AsString := AUsuario.Ativo;
    Query.ParamByName('Id').AsInteger := AUsuario.Id;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

procedure TUsuariosRepository.Delete(AId: Integer);
var
  Query: TFDQuery;
begin
  Query := CreateQuery;
  try
    Query.SQL.Text := 'DELETE FROM usuarios WHERE Id = :Id';
    Query.ParamByName('Id').AsInteger := AId;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

end.
