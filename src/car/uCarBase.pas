unit uCarBase;

interface

type
  TCarBase = class(TObject)
  protected
    FTableName: string;
  public
    constructor Create;
    destructor Destroy; override;
    class function startTrans(): string;
    class function commit(): string;
    //procedure setRow(const S: string);
    function getSql: string;
    //
    function getRow(const c: char=#9; const quoted: boolean=false): string; virtual; abstract;
    class function getColumn(const c: char=#9): string; virtual; abstract;
  end;

implementation

uses SysUtils, classes;

{ TCarBase }

constructor TCarBase.Create;
begin
end;

destructor TCarBase.Destroy;
begin
end;

class function TCarBase.startTrans: string;
begin
  Result := 'start transaction;';
  Result := '-- truncate table ;';// + FTableName;
end;

class function TCarBase.commit: string;
begin
  Result := 'commit;';
end;

function TCarBase.getSql: string;
begin
  Result := 'insert into ' + FTableName +
    '(' +
      getColumn(#44) +
    ')' +
    ' value(' +
      getRow(#44, true) +
    ');'
end;

end.

