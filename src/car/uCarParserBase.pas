unit uCarParserBase;

interface

uses SysUtils, classes, uMyTextFile, Generics.Collections, uCommEvents;

type
  TCarParserBase = class(TObject)
  private
  protected
    FFileText: TMyTextFile;
    FStopFunc: TBooleanFunc;
    FDataFullPath: string;
    function isStop(): boolean;
  public
    constructor Create(const fileName: string);
    destructor Destroy; override;
    class procedure loadStand(strs: TStrings; Dic: TDictionary<String, String>;
      const c: char=#9); static;

    function getSubDataDir(const s: string): string;
  public
    property FileText: TMyTextFile read FFileText;
    property StopFunc: TBooleanFunc write FStopFunc;
    property DataFullPath: string write FDataFullPath;
  end;

implementation

//uses uCarBrand, System.json, uCharSplit;
uses uCharSplit;

{ TCarParserBase }

constructor TCarParserBase.Create(const fileName: string);
begin
  inherited create;
  FFileText := TMyTextFile.Create;
end;

destructor TCarParserBase.Destroy;
begin
  FFileText.free;
end;

function TCarParserBase.getSubDataDir(const s: string): string;
begin
  Result := self.FDataFullPath + S;
end;

function TCarParserBase.isStop: boolean;
begin
  if Assigned(FStopFunc) then begin
    Result := FStopFunc;
  end else begin
    Result := false;
  end;
end;

class procedure TCarParserBase.loadStand(strs: TStrings;
    Dic: TDictionary<String, String>; const c: char);
var i: integer;
  S, k, v: string;
begin
  for I := 1 to strs.Count - 1 do begin
    S := strs[I];
    k := TCharSplit.getSplitFirst(S, c);
    v := TCharSplit.getSplitIdx(S, c, 1);
    Dic.Add(k, v);
  end;
end;

end.

