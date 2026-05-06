unit view.main;

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
  Dialogs,
  cxControls,
  cxGraphics,
  cxLookAndFeelPainters,
  cxLookAndFeels,
  dxSkinsCore,
  cxContainer,
  cxEdit,
  dxNavBar,
  cxClasses,
  dxLayoutLookAndFeels,
  dxLayoutContainer,
  dxLayoutControl,
  dxSkinsForm,
  dxSkinsFluentDesignForm,
  dxSkinOffice2019Colorful,
  dxSkinOffice2019Black,
  dxSkinOffice2019White,
  dxCore,
  dxNavBarCollns,
  dxNavBarBase,
  Vcl.FormTabsBar,
  cxPC,
  dxBarBuiltInMenu,
  dxTabbedMDI,
  cxLocalization;

type
  TFormMain = class(TdxFluentDesignForm)
    dxNavBar1: TdxNavBar;
    SkinController: TdxSkinController;
    LayoutLookAndFeelList: TdxLayoutLookAndFeelList;
    dxLayoutSkinLookAndFeel1: TdxLayoutSkinLookAndFeel;
    dxNavBar1Item1: TdxNavBarItem;
    dxNavBar1Group1: TdxNavBarGroup;
    TabbedMDIManager: TdxTabbedMDIManager;
    Idioma: TcxLocalizer;
    procedure dxNavBar1Item1Click(Sender: TObject);
    procedure dxFluentDesignFormCreate(Sender: TObject);
    procedure dxFluentDesignFormClose(Sender: TObject; var Action: TCloseAction);

  private
    procedure CarregarIdioma;

  public

  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses 
  view.relatorios.atendimentos,
  helper.ini,
  helper.Forms;

procedure TFormMain.CarregarIdioma;
var
  Stream: TResourceStream;
begin
  Stream := TResourceStream.Create(HInstance, 'PT_BR', RT_RCDATA);
  try
    Idioma.LoadFromStream(Stream);
    Idioma.Active := True;
    Idioma.Locale := 1046;
  finally
    Stream.Free;
  end;
end;

procedure TFormMain.dxFluentDesignFormClose(Sender: TObject; var Action: TCloseAction);
begin
  TIniHelper.SetValue('ui', 'window-state', Ord(WindowState))
end;

procedure TFormMain.dxFluentDesignFormCreate(Sender: TObject);
begin
  CarregarIdioma;
  Self.WindowState := TWindowState(TIniHelper.GetValue('ui', 'window-state', 2))
end;

procedure TFormMain.dxNavBar1Item1Click(Sender: TObject);
begin
  TFormHelper.CreateTabForm<TFormRelatAtendimento>(Self, False)
end;

end.
