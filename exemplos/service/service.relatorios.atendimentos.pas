unit service.relatorios.atendimentos;

interface

uses
  System.SysUtils,
  FireDAC.Stan.Param,
  DateUtils,
  StrUtils,
  System.Classes,
  IOUtils,
  FireDAC.Comp.Client;

type
  TFiltroRelatorioAtendimentos = record
    DataInicial: TDate;
    DataFinal: TDate;
    Sistema: string;
    Analista: string;
    Cliente: string;
    Categoria: string;
    Setor: string;
    Acao: string;
    Unidade: string;
  end;

  TRelatorioAtendimentosService = class
  public
    class procedure Consultar(AQuery: TFDQuery;
      const AFiltro: TFiltroRelatorioAtendimentos);
  end;

implementation

{ TRelatorioAtendimentosService }

class procedure TRelatorioAtendimentosService.Consultar(AQuery: TFDQuery;
  const AFiltro: TFiltroRelatorioAtendimentos);
var
  LSQL: string;
  LFiltroDinamico: string;
  LDerivedTable: string;
  LClientFilter: string;
  LValues: TArray<string>;
  LFilterPart: string;
  LVal: string;
  i: Integer;
begin
  if not Assigned(AQuery) then
    Exit;

  LFiltroDinamico := '';

  if AFiltro.Sistema <> '' then
    LFiltroDinamico := LFiltroDinamico + ' and c2.Sistema = :sistema';

  if AFiltro.Analista <> '' then
    LFiltroDinamico := LFiltroDinamico + ' and u2.Nome = :analista';

  LClientFilter := '';
  if AFiltro.Cliente <> '' then
  begin
    LValues := AFiltro.Cliente.Split([';', ',']);
    LFilterPart := '';
    for i := 0 to High(LValues) do
    begin
      LVal := Trim(LValues[i]);
      if LVal <> '' then
      begin
        if LFilterPart <> '' then 
          LFilterPart := LFilterPart + ' OR ';
          
        if Pos('%', LVal) > 0 then
          LFilterPart := LFilterPart + '{TABLE}.Nome LIKE ' + QuotedStr(LVal)
        else
          LFilterPart := LFilterPart + '{TABLE}.Nome = ' + QuotedStr(LVal);
      end;
    end;
    
    if LFilterPart <> '' then
    begin
      if Pos(' OR ', LFilterPart) > 0 then
        LClientFilter := ' and (' + LFilterPart + ')'
      else
        LClientFilter := ' and ' + LFilterPart;
    end;
  end;

  if LClientFilter <> '' then
    LFiltroDinamico := LFiltroDinamico + StringReplace(LClientFilter, '{TABLE}', 'c2', [rfReplaceAll]);

  if AFiltro.Categoria <> '' then
    LFiltroDinamico := LFiltroDinamico + ' and a2.Categoria = :categoria';

  if AFiltro.Setor <> '' then
    LFiltroDinamico := LFiltroDinamico + ' and cel2.Celula = :setor';

  if AFiltro.Acao <> '' then
    LFiltroDinamico := LFiltroDinamico + ' and a2.Acao = :acao';

  if AFiltro.Unidade <> '' then
    LFiltroDinamico := LFiltroDinamico + ' and c2.Unidade = :unidade';

  LDerivedTable :=
    ' LEFT JOIN ( ' +
    '   select a2.UserAtribuido, COUNT(a2.id) as Total ' +
    '   from atendimentos a2 ' +
    '   inner join clientes c2 on c2.id = a2.cliente ' +
    '   inner join usuarios u2 on u2.Id = a2.UserAtribuido ' +
    '   left join celulas cel2 on cel2.id = a2.setor ' +
    '   where a2.DataFechamento between :datainicial and :datafinal ' +
    '   and a2.Fechado = ''S'' ' + LFiltroDinamico +
    '   group by a2.UserAtribuido ' +
    ' ) as totals ON totals.UserAtribuido = a.UserAtribuido ';

  LSQL :=
    'select ' +
    'c.Id, ' +
    'convert(cast(convert(c.Nome using latin1) as binary) using utf8) "Cliente", '
    +
    'convert(cast(convert(a.Pessoa using latin1) as binary) using utf8) "Solicitante", '
    +
    'a.`Data` "DataAbertura", ' +
    'a.Hora "HoraAbertura", ' +
    'a.DataFechamento, ' +
    'a.HoraFechamento, ' +
    'convert(cast(convert(a.Historico using latin1) as binary) using utf8) "Historico", '
    +
    'convert(cast(convert(u.Nome using latin1) as binary) using utf8) "Analista", '
    +
    'COALESCE(totals.Total, 0) as "TotalPorAnalista", ' +
    'convert(cast(convert(c.Sistema using latin1) as binary) using utf8) "Sistema", '
    +
    'convert(cast(convert(a.categoria using latin1) as binary) using utf8) "Categoria", '
    +
    'convert(cast(convert(cel.celula using latin1) as binary) using utf8) "Setor", '
    +
    'convert(cast(convert(a.Acao using latin1) as binary) using utf8) "Acao", '
    +
    'convert(cast(convert(c.Unidade using latin1) as binary) using utf8) "Unidade" '
    +
    'from atendimentos a ' +
    'inner join clientes c on c.id = a.cliente ' +
    'inner join usuarios u on u.Id = a.UserAtribuido ' +
    'left join celulas cel on cel.id = a.setor ' +
    LDerivedTable +
    'where a.DataFechamento between :datainicial and :datafinal ' +
    'and a.Fechado = ''S'' ';

  if AFiltro.Sistema <> '' then
    LSQL := LSQL + ' and c.Sistema = :sistema';

  if AFiltro.Analista <> '' then
    LSQL := LSQL + ' and u.Nome = :analista';

  if LClientFilter <> '' then
    LSQL := LSQL + StringReplace(LClientFilter, '{TABLE}', 'c', [rfReplaceAll]);

  if AFiltro.Categoria <> '' then
    LSQL := LSQL + ' and a.Categoria = :categoria';

  if AFiltro.Setor <> '' then
    LSQL := LSQL + ' and cel.Celula = :setor';

  if AFiltro.Acao <> '' then
    LSQL := LSQL + ' and a.Acao = :acao';

  if AFiltro.Unidade <> '' then
    LSQL := LSQL + ' and c.Unidade = :unidade';

  LSQL := LSQL +
    ' order by TotalPorAnalista desc, a.UserAtribuido, a.Cliente, a.DataFechamento, a.HoraFechamento';

  AQuery.Close;
  AQuery.SQL.Text := LSQL;

  AQuery.ParamByName('datainicial').AsDate := AFiltro.DataInicial;
  AQuery.ParamByName('datafinal').AsDate := AFiltro.DataFinal;

  if AFiltro.Sistema <> '' then
    AQuery.ParamByName('sistema').AsString := AFiltro.Sistema;

  if AFiltro.Analista <> '' then
    AQuery.ParamByName('analista').AsString := AFiltro.Analista;


  if AFiltro.Categoria <> '' then
    AQuery.ParamByName('categoria').AsString := AFiltro.Categoria;

  if AFiltro.Setor <> '' then
    AQuery.ParamByName('setor').AsString := AFiltro.Setor;

  if AFiltro.Acao <> '' then
    AQuery.ParamByName('acao').AsString := AFiltro.Acao;

  if AFiltro.Unidade <> '' then
    AQuery.ParamByName('unidade').AsString := AFiltro.Unidade;

  AQuery.Open;

   if not TDirectory.Exists('./logs/') then
  begin
    TDirectory.CreateDirectory('./logs/');
  end;

  AQuery.SQL.SaveToFile('./logs/SQLAtendimentos.txt')
end;

end.
