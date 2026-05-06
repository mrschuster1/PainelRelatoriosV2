unit data.report;

interface

uses
  System.SysUtils, System.Classes, Data.DB, 
  frxClass, frxDBSet, frxExportPDF, frxExportBaseDialog, frxExportXLSX;

type
  TDataReport = class(TDataModule)
    frxReport1: TfrxReport;
    frxDBDataset1: TfrxDBDataset;
    frxPDFExport1: TfrxPDFExport;
    frxXLSXExport1: TfrxXLSXExport;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure PrepararRelatorio(ADataSet: TDataSet);
    procedure Visualizar;
    procedure ExportarPDF(const APath: string);
  end;

var
  DataReport: TDataReport;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDataReport.PrepararRelatorio(ADataSet: TDataSet);
begin
  frxDBDataset1.DataSet := ADataSet;
  frxReport1.DataSet := frxDBDataset1;
  // Aqui poderíamos carregar um template dinâmico no futuro
end;

procedure TDataReport.Visualizar;
begin
  frxReport1.ShowReport;
end;

procedure TDataReport.ExportarPDF(const APath: string);
begin
  frxPDFExport1.FileName := APath;
  frxPDFExport1.ShowDialog := False;
  frxReport1.Export(frxPDFExport1);
end;

end.
