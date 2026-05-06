unit service.report.impl;

interface

uses
  Data.DB, System.SysUtils, service.report, data.report;

type
  TReportService = class(TInterfacedObject, IReportService)
  private
    FDataReport: TDataReport;
    constructor Create;
  public
    destructor Destroy; override;
    class function New: IReportService;
    
    function LoadReport(const AReportName: string): IReportService;
    function SetDataSet(const ADataSet: TDataSet): IReportService;
    function ShowPreview: IReportService;
    function ExportToPDF(const APath: string): IReportService;
    function ExportToExcel(const APath: string): IReportService;
  end;

implementation

{ TReportService }

constructor TReportService.Create;
begin
  FDataReport := TDataReport.Create(nil);
end;

destructor TReportService.Destroy;
begin
  FDataReport.Free;
  inherited;
end;

function TReportService.ExportToExcel(const APath: string): IReportService;
begin
  Result := Self;
  // Implementação pendente: necessita configuração de exportador XLSX no DFM
end;

function TReportService.ExportToPDF(const APath: string): IReportService;
begin
  Result := Self;
  FDataReport.ExportarPDF(APath);
end;

function TReportService.LoadReport(const AReportName: string): IReportService;
var
  LPath: string;
begin
  Result := Self;
  LPath := ExtractFilePath(ParamStr(0)) + 'reports\' + AReportName;
  if FileExists(LPath) then
    FDataReport.frxReport1.LoadFromFile(LPath);
end;

class function TReportService.New: IReportService;
begin
  Result := Self.Create;
end;

function TReportService.SetDataSet(const ADataSet: TDataSet): IReportService;
begin
  Result := Self;
  FDataReport.PrepararRelatorio(ADataSet);
end;

function TReportService.ShowPreview: IReportService;
begin
  Result := Self;
  FDataReport.Visualizar;
end;

end.
