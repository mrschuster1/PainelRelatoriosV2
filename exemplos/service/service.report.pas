unit service.report;

interface

uses
  Data.DB;

type
  IReportService = interface
    ['{B94C2B1C-7F1F-4B8D-A8D9-B6C8F2E4A5B0}']
    function LoadReport(const AReportName: string): IReportService;
    function SetDataSet(const ADataSet: TDataSet): IReportService;
    function ShowPreview: IReportService;
    function ExportToPDF(const APath: string): IReportService;
    function ExportToExcel(const APath: string): IReportService;
  end;

implementation

end.
