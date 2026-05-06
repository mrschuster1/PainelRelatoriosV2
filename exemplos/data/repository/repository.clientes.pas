unit repository.clientes;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  Data.DB,
  data.connection,
  model.clientes,
  repository.base;

type
  IClientesRepository = interface
    ['{F6A7B8C9-0123-DEFA-BCDE-234567890123}']
    function GetAll: TList<ICliente>;
    function GetById(AId: Integer): ICliente;
    function GetAtivos: TList<ICliente>;
    function GetNomesAtivos: TList<string>;
    procedure Insert(ACliente: ICliente);
    procedure Update(ACliente: ICliente);
    procedure Delete(AId: Integer);
  end;

  TClientesRepository = class(TBaseRepository<ICliente>, IClientesRepository)
  protected
    function MapRow(AQuery: TFDQuery): ICliente; override;
  public
    constructor Create(AConnection: TFDConnection);
    function GetAll: TList<ICliente>;
    function GetById(AId: Integer): ICliente;
    function GetAtivos: TList<ICliente>;
    function GetNomesAtivos: TList<string>;
    procedure Insert(ACliente: ICliente);
    procedure Update(ACliente: ICliente);
    procedure Delete(AId: Integer);
  end;

function NewClientesRepository: IClientesRepository;

implementation

uses
  repository.sistemas,
  model.sistemas,
  repository.usuarios,
  model.usuarios,
  // ... outras units se necessário
  repository.categorias,
  model.categorias,
  repository.celulas,
  model.celulas;

function NewClientesRepository: IClientesRepository;
begin
  Result := TClientesRepository.Create(TConnection.GetDefaultConnection);
end;

{ TClientesRepository }

constructor TClientesRepository.Create(AConnection: TFDConnection);
begin
  inherited Create(AConnection);
end;

function TClientesRepository.MapRow(AQuery: TFDQuery): ICliente;
begin
  Result := NewCliente;
  Result.Id := AQuery.FieldByName('Id').AsInteger;
  Result.Nome := AQuery.FieldByName('Nome').AsString;
  Result.Telefone := AQuery.FieldByName('Telefone').AsString;
  Result.Contato := AQuery.FieldByName('Contato').AsString;
  Result.Unidade := AQuery.FieldByName('Unidade').AsString;
  Result.Sistema := AQuery.FieldByName('Sistema').AsString;
  Result.Analista := AQuery.FieldByName('Analista').AsString;
  Result.CodAnalista := AQuery.FieldByName('CodAnalista').AsInteger;
  Result.NFe := AQuery.FieldByName('NFe').AsString;
  Result.SPED := AQuery.FieldByName('SPED').AsString;
  Result.Inativo := AQuery.FieldByName('Inativo').AsString;
  Result.Endereco := AQuery.FieldByName('Endereco').AsString;
  Result.UserCadastro := AQuery.FieldByName('UserCadastro').AsInteger;
  Result.IdClienteSOL := AQuery.FieldByName('IdClienteSOL').AsInteger;
  Result.DataCadastro := AQuery.FieldByName('DataCadastro').AsDateTime;
  Result.Implantacao := AQuery.FieldByName('Implantacao').AsString;
  Result.Interno := AQuery.FieldByName('Interno').AsString;
  Result.Prospecto := AQuery.FieldByName('Prospecto').AsString;
  Result.IdProspecto := AQuery.FieldByName('IdProspecto').AsInteger;
  Result.Bloqueado := AQuery.FieldByName('Bloqueado').AsString;
  Result.ValorCI := AQuery.FieldByName('ValorCI').AsFloat;
  Result.ValorMA := AQuery.FieldByName('ValorMA').AsFloat;
  Result.DiaVctoMA := AQuery.FieldByName('DiaVctoMA').AsInteger;
  Result.Faturamento := AQuery.FieldByName('Faturamento').AsInteger;
  Result.DataCtrIni := AQuery.FieldByName('DataCtrIni').AsDateTime;
  Result.DataCtrFim := AQuery.FieldByName('DataCtrFim').AsDateTime;
  Result.ResponsavelContrato := AQuery.FieldByName('ResponsavelContrato').AsInteger;
  Result.Celular := AQuery.FieldByName('Celular').AsString;
  Result.NFeS := AQuery.FieldByName('NFeS').AsString;
  Result.IdContador := AQuery.FieldByName('IdContador').AsInteger;
  Result.NomeContador := AQuery.FieldByName('NomeContador').AsString;
  Result.EMail := AQuery.FieldByName('EMail').AsString;
  Result.TipoTrib := AQuery.FieldByName('TipoTrib').AsString;
  Result.SPEDPISCOFINS := AQuery.FieldByName('SPEDPISCOFINS').AsString;
  Result.IndiceMA := AQuery.FieldByName('IndiceMA').AsFloat;
  Result.PercISSQN := AQuery.FieldByName('PercISSQN').AsFloat;
  Result.Parceiro := AQuery.FieldByName('Parceiro').AsString;
  Result.NumeroEndereco := AQuery.FieldByName('NumeroEndereco').AsInteger;
  Result.RamoAtividade := AQuery.FieldByName('RamoAtividade').AsString;
  Result.Bairro := AQuery.FieldByName('Bairro').AsString;
  Result.CxPostal := AQuery.FieldByName('CxPostal').AsString;
  Result.CEP := AQuery.FieldByName('CEP').AsString;
  Result.EndComplemento := AQuery.FieldByName('EndComplemento').AsString;
  Result.Celula := AQuery.FieldByName('Celula').AsInteger;
  Result.Responsavel := AQuery.FieldByName('Responsavel').AsString;
  Result.Modulos := AQuery.FieldByName('Modulos').AsString;
end;

function TClientesRepository.GetAll: TList<ICliente>;
var
  Query: TFDQuery;
begin
  Result := TList<ICliente>.Create;
  Query := CreateQuery;
  try
    Query.SQL.Text := 'SELECT * FROM clientes WHERE Prospecto = ''N'' ORDER BY Nome';
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

function TClientesRepository.GetById(AId: Integer): ICliente;
var
  Query: TFDQuery;
begin
  Result := nil;
  Query := CreateQuery;
  try
    Query.SQL.Text := 'SELECT * FROM clientes WHERE Id = :Id AND Prospecto = ''N''';
    Query.ParamByName('Id').AsInteger := AId;
    Query.Open;

    if not Query.IsEmpty then
      Result := MapRow(Query);
  finally
    Query.Free;
  end;
end;

function TClientesRepository.GetAtivos: TList<ICliente>;
var
  Query: TFDQuery;
begin
  Result := TList<ICliente>.Create;
  Query := CreateQuery;
  try
    Query.SQL.Text := 'SELECT * FROM clientes WHERE Inativo = ''N'' AND Prospecto = ''N'' ORDER BY Nome';
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

function TClientesRepository.GetNomesAtivos: TList<string>;
var
  Query: TFDQuery;
begin
  Result := TList<string>.Create;
  Query := CreateQuery;
  try
    Query.SQL.Text := 'SELECT Nome FROM clientes WHERE Inativo = ''N'' AND Prospecto = ''N'' ORDER BY Nome';
    Query.Open;

    while not Query.Eof do
    begin
      Result.Add(Query.FieldByName('Nome').AsString);
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

procedure TClientesRepository.Insert(ACliente: ICliente);
begin
end;

procedure TClientesRepository.Update(ACliente: ICliente);
begin
end;

procedure TClientesRepository.Delete(AId: Integer);
begin
end;

end.

