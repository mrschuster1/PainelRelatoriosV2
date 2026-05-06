unit view.relatorios.preview;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  frxClass,
  frxPreview;

type
  TFormPreviewReport = class(TForm)
    ReportPreview: TfrxPreview;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FReport: TfrxReport;
  public
    class procedure ShowReport(AReport: TfrxReport;
      const ACaption: string = '');

  end;

var
  FormPreviewReport: TFormPreviewReport;

implementation

{$R *.dfm}


procedure TFormPreviewReport.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if FReport <> nil then
    FReport.Preview := nil;
  Action := caFree;
end;

class procedure TFormPreviewReport.ShowReport(AReport: TfrxReport;
  const ACaption: string);
var
  LFormPreview: TFormPreviewReport;
begin
  LFormPreview := TFormPreviewReport.Create(Application);
  LFormPreview.FReport := TfrxReport.Create(LFormPreview);
  LFormPreview.FReport.Assign(AReport);

  // Sincroniza os DataSets do relatório original para a nova instância
  LFormPreview.FReport.DataSets.Clear;
  for var i := 0 to AReport.DataSets.Count - 1 do
    LFormPreview.FReport.DataSets.Add(AReport.DataSets[i].DataSet);

  if ACaption <> '' then
    LFormPreview.Caption := ACaption;

  LFormPreview.FReport.Preview := LFormPreview.ReportPreview;
  if LFormPreview.FReport.PrepareReport(True) then
  begin
    LFormPreview.Show;
    LFormPreview.FReport.ShowPreparedReport;
  end
  else
    LFormPreview.Free;
end;

end.
