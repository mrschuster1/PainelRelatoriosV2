unit repository.conexao;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  model.conexao,
  repository.base;

type
  IConexaoRepository = interface
    ['{ABC12E34-5678-90AB-CDEF-1234567890BC}']
    function GetAll: TList<IConexao>;
    function GetById(AId: Integer): IConexao;
    procedure Save(AConexao: IConexao);
    procedure Delete(AId: Integer);
  end;

  TConexaoRepository = class(TBaseRepository<IConexao>, IConexaoRepository)
  protected
    function MapRow(AQuery: TFDQuery): IConexao; override;
  public
    function GetAll: TList<IConexao>;
    function GetById(AId: Integer): IConexao;
    procedure Save(AConexao: IConexao);
    procedure Delete(AId: Integer);
  end;

function NewConexaoRepository(AConnection: TFDConnection): IConexaoRepository;

implementation

function NewConexaoRepository(AConnection: TFDConnection): IConexaoRepository;
begin
  Result := TConexaoRepository.Create(AConnection);
end;

{ TConexaoRepository }

function TConexaoRepository.GetAll: TList<IConexao>;
var
  LQuery: TFDQuery;
begin
  Result := TList<IConexao>.Create;
  LQuery := CreateQuery;
  try
    LQuery.Open('SELECT * FROM conexoes ORDER BY nome');
    while not LQuery.Eof do
    begin
      Result.Add(MapRow(LQuery));
      LQuery.Next;
    end;
  finally
    LQuery.Free;
  end;
end;

function TConexaoRepository.GetById(AId: Integer): IConexao;
var
  LQuery: TFDQuery;
begin
  Result := nil;
  LQuery := CreateQuery;
  try
    LQuery.SQL.Text := 'SELECT * FROM conexoes WHERE id = :id';
    LQuery.ParamByName('id').AsInteger := AId;
    LQuery.Open;
    if not LQuery.Eof then
      Result := MapRow(LQuery);
  finally
    LQuery.Free;
  end;
end;

procedure TConexaoRepository.Save(AConexao: IConexao);
var
  LQuery: TFDQuery;
begin
  LQuery := CreateQuery;
  try
    if AConexao.Id > 0 then
    begin
      LQuery.SQL.Text := 'UPDATE conexoes SET ' +
                         ' nome = :nome, driver = :driver, servidor = :servidor, ' +
                         ' banco = :banco, usuario = :usuario, senha = :senha, porta = :porta ' +
                         ' WHERE id = :id';
      LQuery.ParamByName('id').AsInteger := AConexao.Id;
    end
    else
    begin
      LQuery.SQL.Text := 'INSERT INTO conexoes (nome, driver, servidor, banco, usuario, senha, porta) ' +
                         ' VALUES (:nome, :driver, :servidor, :banco, :usuario, :senha, :porta)';
    end;

    LQuery.ParamByName('nome').AsString := AConexao.Nome;
    LQuery.ParamByName('driver').AsString := AConexao.Driver;
    LQuery.ParamByName('servidor').AsString := AConexao.Servidor;
    LQuery.ParamByName('banco').AsString := AConexao.Banco;
    LQuery.ParamByName('usuario').AsString := AConexao.Usuario;
    LQuery.ParamByName('senha').AsString := AConexao.Senha;
    LQuery.ParamByName('porta').AsInteger := AConexao.Porta;
    LQuery.ExecSQL;
  finally
    LQuery.Free;
  end;
end;

procedure TConexaoRepository.Delete(AId: Integer);
var
  LQuery: TFDQuery;
begin
  LQuery := CreateQuery;
  try
    LQuery.ExecSQL('DELETE FROM conexoes WHERE id = :id', [AId]);
  finally
    LQuery.Free;
  end;
end;

function TConexaoRepository.MapRow(AQuery: TFDQuery): IConexao;
begin
  Result := TConexao.New
    .SetId(AQuery.FieldByName('id').AsInteger)
    .SetNome(AQuery.FieldByName('nome').AsString)
    .SetDriver(AQuery.FieldByName('driver').AsString)
    .SetServidor(AQuery.FieldByName('servidor').AsString)
    .SetBanco(AQuery.FieldByName('banco').AsString)
    .SetUsuario(AQuery.FieldByName('usuario').AsString)
    .SetSenha(AQuery.FieldByName('senha').AsString)
    .SetPorta(AQuery.FieldByName('porta').AsInteger);
end;

end.
