unit repository.base;

interface

uses
  System.SysUtils,
  System.Classes,
  FireDAC.Comp.Client,
  data.connection;

type
  TRepositoryException = class(Exception);

  TBaseRepository<T: IInterface> = class(TInterfacedObject)
  protected
    FConnection: TFDConnection;
    function CreateQuery: TFDQuery;
    function MapRow(AQuery: TFDQuery): T; virtual; abstract;
  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy; override;
  end;

implementation

{ TBaseRepository<T> }

constructor TBaseRepository<T>.Create(AConnection: TFDConnection);
begin
  FConnection := AConnection;
end;

destructor TBaseRepository<T>.Destroy;
begin
  inherited;
end;

function TBaseRepository<T>.CreateQuery: TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FConnection;
end;

end.
