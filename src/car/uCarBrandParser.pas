unit uCarBrandParser;

interface

uses SysUtils, classes, uCarParserBase, uCommEvents;

type
  TCarBrandParser = class(TCarParserBase)
  protected
    procedure parerToListOld(const S: string; brandProc: TGetBrandProc);
    procedure parerToListNew(const S: string; brandProc: TGetBrandProc);
  public
    constructor Create(const fileName: string);
    destructor Destroy; override;
    //
    procedure parerToList(const S: string; brandProc: TGetBrandProc; const bNew: boolean);
    //procedure listBrandToStrs(strs: TStrings);
  end;

implementation

uses uCarBrand, System.json, uCharSplit, uMyTextFile;

{ TCarBrandParser }

constructor TCarBrandParser.Create(const fileName: string);
begin
  inherited create(fileName);
end;

destructor TCarBrandParser.Destroy;
begin
end;

{procedure TCarBrandParser.listBrandToStrs(strs: TStrings);
var I: integer;
  u: TCarBrand;
begin
  strs.Clear;
  strs.Add(TCarBrand.getColumn());
  for I := 0 to FMyList.Count - 1 do begin
    u := FMyList.Items[I];
    strs.Add(u.getRow());
  end;
end;}

procedure TCarBrandParser.parerToList(const S: string; brandProc: TGetBrandProc;
  const bNew: boolean);
begin
  if bNew then begin
    parerToListNew(S, brandProc);
  end else begin
    parerToListOld(S, brandProc);
  end;
end;

procedure TCarBrandParser.parerToListNew(const S: string; brandProc: TGetBrandProc);
  //listBrandToStrs(strs);

    function processOne(const jsonVal: TJSONValue): boolean;
    var id, name, letter, spell: string;
      carBrand: TCarBrand;
    begin
      Result := true;
      //"id":33, "name":"audi", "pinyin":"audi", "letters":"A"
      carBrand := TCarBrand.Create;
      try
        if jsonVal.TryGetValue<String>('id', id) then begin
          jsonVal.TryGetValue<String>('id', id);
          jsonVal.TryGetValue<String>('name', name);
          jsonVal.TryGetValue<String>('pinyin', spell);
          jsonVal.TryGetValue<String>('letters', letter);
          //
          carBrand.car_brand_name := name;
          carBrand.rawId := id;
          carBrand.short_code := letter;
          carBrand.car_brand_code := carBrand.short_code;
          carBrand.letter := spell;
          //strs.add(id + #9 + letter + #9 + name + #9 + spell);
        end;
        FFileText.WriteLn_(carBrand.getRow());
        if Assigned(brandProc) then begin
          Result := brandProc(carBrand);
        end;
      finally
        carBrand.Free;
      end;
    end;

    procedure processList(const jsonArray: TJsonArray);
    var i: integer;
    begin
      for i := 0 to jsonArray.Count - 1 do begin
        if isStop() then begin
          break;
        end;
        if not processOne(jsonArray.Items[i]) then begin
          break;
        end;
      end;
    end;

var
  jsonVal: TJSONValue;
begin
  FFileText.WriteLn_(TCarBrand.startTrans());
  if Trim(S) = '' then begin
    exit;
  end;
  jsonVal := TJSONObject.ParseJSONValue(S);
  try
    processList(jsonVal as TJsonArray);
  finally
    jsonVal.Free;
  end;
end;

procedure TCarBrandParser.parerToListOld(const S: string; brandProc: TGetBrandProc);

    function doTrimSpace(const S: string): string;
    begin
      if s.IndexOf(#32)>0 then begin
        Result := TCharSplit.replaceSplitChar(s, #32, #32);
      end else begin
        Result := S;
      end;
    end;

    function splitOneBrand(const tmp: String): boolean;
    var npos: integer;
      sleft, sright: string;
      carBrand: TCarBrand;
    begin
      Result := true;
      carBrand := TCarBrand.Create;
      try
        npos := tmp.IndexOf(#32);
        if (npos>0) then begin
          sleft:= tmp.Substring(0, npos);
          sright := tmp.Substring(npos+1, tmp.Length);
          //
          carBrand.car_brand_name := doTrimSpace(sright);
          carBrand.rawId := TCharSplit.getSplitFirst(sleft, #9);
          carBrand.short_code := TCharSplit.getSplitLast(sleft, #9);
          carBrand.car_brand_code := carBrand.short_code;
          carBrand.letter := carBrand.short_code;
        end;
        FFileText.WriteLn_(carBrand.getRow());
        if Assigned(brandProc) then begin
          Result := brandProc(carBrand);
        end;
      finally
        carBrand.Free;
      end;
    end;

    function splitAllBrands(strs: TStrings): boolean;
    var i: integer;
      tmp: string;
    begin
      Result := true;
      try
        for I := 0 to strs.Count - 1 do begin
          tmp := strs[I];
          if not splitOneBrand(tmp) then begin
            break;
          end;
        end;
      finally
      end;
    end;

    function toDoit(const S: string): string;
    var str: string;
    begin
      str := TCharSplit.getSplitIdx(s, #59, 1); // ;
      str := TCharSplit.getSplitLast(str, #61); // =
      str := TCharSplit.getSplitMid(str, #39);  // '
      //group, two is a group
      Result := TCharSplit.getSplitCharG(str, #44, 1); // ,
    end;

var strs: TStrings;
begin
  strs := TStringList.Create;
  FFileText.WriteLn_(TCarBrand.startTrans());
  try
    strs.Text := toDoIt(S);
    splitAllBrands(strs);
  finally
    FFileText.WriteLn_(TCarBrand.commit());
    strs.Free;
  end;
end;

end.

