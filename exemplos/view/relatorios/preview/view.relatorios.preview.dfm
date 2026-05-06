object FormPreviewReport: TFormPreviewReport
  Left = 0
  Top = 0
  Align = alClient
  BorderStyle = bsNone
  Caption = 'Preview'
  ClientHeight = 743
  ClientWidth = 1085
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIChild
  Visible = True
  OnClose = FormClose
  TextHeight = 15
  object ReportPreview: TfrxPreview
    Left = 0
    Top = 0
    Width = 1085
    Height = 743
    Align = alClient
    OutlineVisible = False
    OutlineWidth = 120
    ThumbnailVisible = False
    FindFmVisible = False
    UseReportHints = True
    OutlineTreeSortType = dtsUnsorted
    HideScrolls = False
  end
end
