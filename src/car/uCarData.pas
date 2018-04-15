unit uCarData;

interface

uses uCarBase;

type
  TCarData = class(TCarBase)
  protected
    state: string;
    sort_no: string;
    create_time: string;
    modify_time: string;
    creator_id: string;
    modifier_id: string;
    raw_id: string;
    org_id: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure setRawId(const n: string); virtual;
    function  getUpdateOrgSql(): string;
  public
    property RawId: string read raw_id write setRawId;
  end;

implementation

uses SysUtils, classes;

{ TCarData }

constructor TCarData.Create;
begin
  state := '1';
  sort_no := '0';
  create_time := FormatDateTime('yyyy-mm-dd hh:nn:ss', now);
  modify_time := create_time;
  creator_id := '0';
  modifier_id := '0';
  //
  org_id := '1';
end;

destructor TCarData.Destroy;
begin
end;

function TCarData.getUpdateOrgSql: string;
begin
  Result := '/** set org id' +
    ' update ' + FTableName +
    ' set orgId = 1' +
    ' where org_id is null;' +
    ' **/ '
end;

procedure TCarData.setRawId(const n: string);
begin
  raw_id := n;
end;

end.

