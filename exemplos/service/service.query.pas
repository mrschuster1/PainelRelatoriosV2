unit service.query;

interface

uses
  Data.DB, model.conexao;

type
  IQueryEngine = interface
    ['{A1B2C3D4-E5F6-47A8-B9C0-D1E2F3A4B5C6}']
    function SetConnection(const AValue: IConexao): IQueryEngine;
    function SQL(const AValue: string): IQueryEngine;
    function Param(const AName: string; const AValue: Variant): IQueryEngine;
    function Open: TDataSet;
    function Execute: Integer;
  end;

implementation

end.
