unit helper.ini;

interface

uses
  System.SysUtils, System.IniFiles, Vcl.Forms;

type
  IIniHelper = interface
    ['{C7E8D9A0-B1C2-4D3E-A4F5-E6B7C8D9A0B1}']
    function GetValue(const ASection, AIdent: string; const ADefault: string = ''): string; overload;
    function GetValue(const ASection, AIdent: string; const ADefault: Integer): Integer; overload;
    function GetValue(const ASection, AIdent: string; const ADefault: Boolean): Boolean; overload;
    procedure SetValue(const ASection, AIdent: string; const AValue: string); overload;
    procedure SetValue(const ASection, AIdent: string; const AValue: Integer); overload;
    procedure SetValue(const ASection, AIdent: string; const AValue: Boolean); overload;
  end;

  TIniHelper = class(TInterfacedObject, IIniHelper)
  private
    FIniFile: TIniFile;
    FFileName: string;
    constructor Create(const AFileName: string = '');
  public
    destructor Destroy; override;
    class function New(const AFileName: string = ''): IIniHelper;
    function GetValue(const ASection, AIdent: string; const ADefault: string = ''): string; overload;
    function GetValue(const ASection, AIdent: string; const ADefault: Integer): Integer; overload;
    function GetValue(const ASection, AIdent: string; const ADefault: Boolean): Boolean; overload;
    procedure SetValue(const ASection, AIdent: string; const AValue: string); overload;
    procedure SetValue(const ASection, AIdent: string; const AValue: Integer); overload;
    procedure SetValue(const ASection, AIdent: string; const AValue: Boolean); overload;
  end;

implementation

{ TIniHelper }

constructor TIniHelper.Create(const AFileName: string);
begin
  FFileName := AFileName;
  if FFileName.IsEmpty then
    FFileName := ChangeFileExt(Application.ExeName, '.ini');
  FIniFile := TIniFile.Create(FFileName);
end;

destructor TIniHelper.Destroy;
begin
  FIniFile.Free;
  inherited;
end;

function TIniHelper.GetValue(const ASection, AIdent: string; const ADefault: string): string;
begin
  Result := FIniFile.ReadString(ASection, AIdent, ADefault);
end;

function TIniHelper.GetValue(const ASection, AIdent: string; const ADefault: Integer): Integer;
begin
  Result := FIniFile.ReadInteger(ASection, AIdent, ADefault);
end;

function TIniHelper.GetValue(const ASection, AIdent: string; const ADefault: Boolean): Boolean;
begin
  Result := FIniFile.ReadBool(ASection, AIdent, ADefault);
end;

class function TIniHelper.New(const AFileName: string): IIniHelper;
begin
  Result := TIniHelper.Create(AFileName);
end;

procedure TIniHelper.SetValue(const ASection, AIdent, AValue: string);
begin
  FIniFile.WriteString(ASection, AIdent, AValue);
end;

procedure TIniHelper.SetValue(const ASection, AIdent: string; const AValue: Integer);
begin
  FIniFile.WriteInteger(ASection, AIdent, AValue);
end;

procedure TIniHelper.SetValue(const ASection, AIdent: string; const AValue: Boolean);
begin
  FIniFile.WriteBool(ASection, AIdent, AValue);
end;

end.
