unit helper.forms;

interface

uses
  Vcl.forms,
  System.SysUtils,
  Vcl.Controls;

/// <summary>
/// Classe auxiliar para manipulação de formulários em aplicações Delphi.
/// </summary>
/// <remarks>
/// Esta classe fornece métodos úteis para criar formulários modais.
/// </remarks>
type
  TFormHelper = class
  public
    /// <summary>
    /// Cria um formulário modal e o exibe.
    /// </summary>
    /// <typeparam name="Form">
    /// Tipo de formulário a ser criado.
    /// </typeparam>
    /// <returns>
    /// Resultado do método ShowModal do formulário criado.
    /// </returns>
    class function CreateModalForm<Form: TForm>: TModalResult;

    class procedure CreateInPlaceForm<Form: TForm>(AParent: TWinControl);

    /// <summary>
    /// Cria um formulário em modo de guias (MDI) e o exibe.
    /// </summary>
    /// <typeparam name="FormClass">
    /// Tipo de formulário a ser criado.
    /// </typeparam>
    /// <param name="MDIParent">
    /// Formulário principal em modo de guias (MDI).
    /// </param>
    /// <param name="CheckIsOpened">
    /// Indica se deve verificar se o formulário já está aberto.
    /// </param>
    class procedure CreateTabForm<FormClass: TForm>(
      MDIParent: TForm;
      CheckIsOpened: Boolean);

  end;

implementation

{ TFormHelper }

uses
  view.main;

class procedure TFormHelper.CreateInPlaceForm<Form>(AParent: TWinControl);
var
  LForm: Form;
begin
  Application.CreateForm(Form, LForm);

  LForm.Parent := AParent;
  LForm.Align := alClient;
  LForm.BorderStyle := bsNone;
  LForm.Show
end;

class function TFormHelper.CreateModalForm<Form>: TModalResult;
var
  LForm: Form;
begin
  Application.CreateForm(Form, LForm);

  try
    if LForm.FormStyle = fsMDIChild then
      LForm.FormStyle := fsNormal
    else
      LForm.ShowModal;
    result := LForm.ModalResult;
  finally
    LForm.Free;
  end;
end;

class procedure TFormHelper.CreateTabForm<FormClass>(MDIParent: TForm;
  CheckIsOpened: Boolean);
var
  FormCount: Integer;
  i: Integer;
  LForm: TForm;
begin
  FormCount := 0;
  if CheckIsOpened then
  begin
    for i := 0 to MDIParent.MDIChildCount - 1 do
      if (MDIParent.MDIChildren[i] is FormClass) then
      begin
        MDIParent.MDIChildren[i].BringToFront;
        Exit;
      end;
  end
  else
    for i := 0 to MDIParent.MDIChildCount - 1 do
      if (MDIParent.MDIChildren[i] is FormClass) then
        Inc(FormCount);

  Application.CreateForm(FormClass, LForm);
  LForm.Align := alClient;
  LForm.BorderStyle := bsNone;
  LForm.FormStyle := fsMDIChild;

  if FormCount > 0 then
    LForm.Caption := Format(LForm.Caption + ' (%s)', [FormCount.ToString]);

end;

end.
