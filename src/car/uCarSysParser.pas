unit uCarSysParser;

interface

uses SysUtils, classes, Generics.Collections, uCarBrand, uCarSys,
  uCarParserBase, uCommEvents;//, uNetHttpClt;

type
  TCarSysParser = class(TCarParserBase)
  private
  protected
    FDicNewFactory: TDictionary<String, String>;
    FCarSysRmBrd: TDictionary<String, String>;
    //procedure parerToListOldRaw(const S: string; const carBrand: TCarBrand; const carSys: TCarSys);
    //procedure parerToListNewRaw(const S: string; const carBrand: TCarBrand; const carSys: TCarSys);
  public
    constructor Create(const fileName: string);
    destructor Destroy; override;
    //procedure listBrandToStrs(strs: TStrings);
    procedure loadFactReplIt(const strs: TStrings);
    procedure loadCarSysRmBrd(const strs: TStrings);
    // const clt: TNetHttpClt;
    //property DicNewFactory: TDictionary<String, String> write FDicNewFactory;
    function reqParerToList(const carBrand: TCarBrand;
      const bNew: boolean; const cb: TGetStrProc): string;
    procedure parerToList(const S: string; const carBrand: TCarBrand;
      const sysProc: TGetBrandSysProc; const bNew: boolean);
  end;

implementation

uses System.json, uCharSplit, uMyTextFile;

{ TCarSysParser }

constructor TCarSysParser.Create(const fileName: string);
begin
  inherited create(fileName);
  FDicNewFactory := TDictionary<String, String>.create();
  FCarSysRmBrd := TDictionary<String, String>.create();
end;

destructor TCarSysParser.Destroy;
begin
  FDicNewFactory.Free;
  FCarSysRmBrd.Free;
end;

function rmSubStr(const S: string; const sub: string): string;
var
  n: integer;
begin
  n := S.IndexOf(sub);
  if n>=0 then begin
    Result := trim(S.Substring(n+sub.Length));
  end else begin
    Result := S;
  end;
end;

procedure TCarSysParser.parerToList(const S: string;
  const carBrand: TCarBrand; const sysProc: TGetBrandSysProc;
    const bNew: boolean);

  function getNewFactory(const brandName, factory, carSysName: string;
    var v: string): boolean;
  var
    k: string;
  begin
    k := brandName + '/' + factory + '/' + carSysName;
    Result := FDicNewFactory.TryGetValue(k, v);
  end;

  function doTrimSpace(const S: string): string;
  begin
    if s.IndexOf(#32)>0 then begin
      Result := TCharSplit.replaceSplitChar(s, #32, #32);
    end else begin
      Result := S;
    end;
  end;

  procedure splitCarSys(strs: TStrings);

    function doItCarSys(strs: TStrings): boolean;
    var i: integer;
      tmp, carSysSpell, brandName: string;
      rawId, factory, factoryNew, carSysName: string;
      carSys: TCarSys;
    begin
      Result := true;
      brandName := carBrand.car_brand_name;
      carSysSpell := '';
      rawId := '';
      factory := '';
      factoryNew := '';
      carSysName := '';
      carSys := TCarSys.Create();
      try
        for I := 0 to strs.Count - 1 do begin
          //tmp := StringReplace(strs[I], #9, '', [rfReplaceAll]);
          tmp := strs[I];
          case I of
            0: begin
              rawId := tmp;
            end;
            1: begin
              factory := tmp;
            end;
            2: begin
               if not FCarSysRmBrd.ContainsKey(tmp)
                   or (FCarSysRmBrd.Count<=0) then begin
                 if tmp.StartsWith(brandName) and (not SameText(brandName, tmp)) then begin
                   carSysName := rmSubStr(tmp, brandName);
                   carSysName := rmSubStr(carSysName, '-');
                   if carSysname.Length<2 then begin
                     carSysName := tmp;
                   end;
                 end else begin
                   carSysName := tmp;
                 end;
               end else begin
                 carSysName := tmp;
               end;
            end;
            3: begin
              carSysSpell := tmp;
            end;
          end;
          //setStatus(tmp);
        end;
        //doReqCarType
        //if (SameText(FFactoryF, '')) or SameText(FFactoryF, factory) then begin
        if True then begin
          //if (SameText(FCarSysN, '')) or SameText(FCarSysN, carSysName) then begin
          if True then begin
            if not getNewFactory(carBrand.car_brand_name, factory, carSysName, factoryNew) then begin
              factoryNew := factory;
            end;
            //if memoCarSys.Lines.Count<=0 then begin
            //  memoCarSys.Lines.Add(TCarSys.getColumn());
            //end;

            carSys.SetRawId(rawId);
            carSys.car_brand_id := carBrand.car_brand_id;
            carSys.car_brand_id_raw := carBrand.rawId;
            carSys.car_brand_name := carBrand.car_brand_name;
            carSys.car_oem_name := factoryNew;
            carSys.car_serie_name := carSysName;
            carSys.car_serie_code := carSysSpell;
            carSys.short_code := carSysSpell;
            carSys.carSysSpell := carSysSpell;
            //to lines
            //memoCarSys.Lines.Add(carSys.getRow());
            //to file
            FFileText.WriteLn_(carSys.getSql());
            if Assigned(sysProc) then begin
              Result := sysProc(carBrand, carSys);
            end;
          end;
        end;
      finally
        carSys.Free;
      end;
    end;

  var i: integer;
    tmp: string;
    ss: TStrings;
  begin
    ss := TStringList.Create;
    try
      for I := 0 to strs.Count - 1 do begin
        tmp := strs[I];
        //ss.Clear;
        TCharSplit.SplitChar(tmp, #9, ss);
        //
        if isStop() then begin
          break;
        end;
        if not doItCarSys(ss) then begin
          break;
        end;
      end;
    finally
      ss.Free;
    end;
  end;

  procedure parserCarSys(const S: string; strs: TStrings);
    procedure splitSpaceStr(strs: TStrings);
    var i, npos: integer;
      S, tmp, sleft, sright: string;
    begin
      for I := 0 to strs.Count - 1 do begin
        tmp := strs[I];
        npos := tmp.IndexOf(#32);
        if (npos>0) then begin
          sleft:= tmp.Substring(0, npos);
          sright := tmp.Substring(npos+1, tmp.Length);
          S := doTrimSpace(sright);
          S := sleft + #9 + S;
          strs[I] := S;
        end;
      end;
    end;
  var str: string;
  begin
    str := TCharSplit.getSplitIdx(s, #59, 1); // ;
    str := TCharSplit.getSplitLast(str, #61); // =
    str := TCharSplit.getSplitMid(str, #39);  // '
    //再按 , 进行分组，两个一组
    strs.Text := TCharSplit.getSplitCharG(str, #44, 1); // ,
    splitSpaceStr(strs);
  end;

  function parserCarSys2(const S: string; strs: TStrings): string;

    function processOne(const jsonVal: TJSONValue): boolean;
    var rawId, carSysName, carSysSpell, factory, factoryNew: string;
      carSys: TCarSys;
    begin
      Result := true;
      //"id":3170,"name":"audiA3","pinyin":"aodia3","fact":"一汽-大众奥迪"
      carSys := TCarSys.Create();
      try
        if jsonVal.TryGetValue<String>('id', rawId) then begin
          jsonVal.TryGetValue<String>('name', carSysName);
          jsonVal.TryGetValue<String>('pinyin', carSysSpell);
          jsonVal.TryGetValue<String>('fact', factory);
          if not getNewFactory(carBrand.car_brand_name, factory, carSysName, factoryNew) then begin
            factoryNew := factory;
          end;
          //strs.add(id + #9 + fact + #9 + name + #9 + spell);
          carSys.SetRawId(rawId);
          carSys.car_brand_id := carBrand.car_brand_id;
          carSys.car_brand_id_raw := carBrand.rawId;
          carSys.car_brand_name := carBrand.car_brand_name;
          carSys.car_oem_name := factoryNew;
          carSys.car_serie_name := carSysName;
          carSys.car_serie_code := carSysSpell;
          carSys.short_code := carSysSpell;
          carSys.carSysSpell := carSysSpell;
          //to lines
          //memoCarSys.Lines.Add(carSys.getRow());
          //to file
          FFileText.WriteLn_(carSys.getSql());
          if Assigned(sysProc) then begin
            Result := sysProc(carBrand, carSys);
          end;
        end;
      finally
        carSys.Free;
      end;
    end;

    procedure processList(const jsonArray: TJsonArray; strs: TStrings);
    var i: integer;
    begin
      for i := 0 to jsonArray.Count - 1 do begin
        if not processOne(jsonArray.Items[i]) then begin
          break;
        end;
     end;
    end;

  var
    jsonVal: TJSONValue;
  begin
    if Trim(S) = '' then begin
      exit;
    end;
    jsonVal := TJSONObject.ParseJSONValue(S);
    try
      processList(jsonVal as TJsonArray, strs);
    finally
      jsonVal.Free;
    end;
  end;

var strs: TStrings;
begin
  strs := TStringList.Create;
  try
    if bNew then begin
      parserCarSys2(s, strs);
    end else begin
      parserCarSys(s, strs);
    end;
    splitCarSys(strs);
  finally
    strs.Free;
  end;
end;

//const clt: TNetHttpClt;

function TCarSysParser.reqParerToList(const carBrand: TCarBrand;
  const bNew: boolean; const cb: TGetStrProc): string;
var url, fname, S: string;
  brandIdRaw, brandName, brandSpell: string;
begin
  brandIdRaw := carBrand.rawId;
  brandName := carBrand.car_brand_name;
  brandSpell := carBrand.ShortCode;
  //
  if bNew then begin
    fname := getSubDataDir(brandName + '\' + 'carsys_' + '.txt');
    //http://www.che168.com/handler/usedcarlistv5.ashx?action=serieslist&brand=aodi
    url := 'https://www.che168.com/handler/usedcarlistv5.ashx?'
      + 'action=serieslist&brand='+brandSpell;
  end else begin
    fname := getSubDataDir(brandName + '\' + 'carsys' + '.txt');
    //http://i.che168.com/Handler/SaleCar/ScriptCarList_V1.ashx?seriesGroupType=2&needData=2&bid=33
    //      https://www.che168.com/Handler/ScriptCarList_V1.ashx?seriesGroupType=2&needData=2&bid=33
    url := 'https://www.che168.com/Handler/ScriptCarList_V1.ashx?seriesGroupType=2&needData=2&bid=%s';
    url := format(url, [brandIdRaw]);
  end;
  S := getGBK(url, fname, false, cb);
  Result := S;
  // to parse car-system
  //FCarSysPaser.parerToList(S, carBrand, doReqCarType, isDoNew());
end;

procedure TCarSysParser.loadCarSysRmBrd(const strs: TStrings);
begin
  loadStand(strs, FCarSysRmBrd);
end;

procedure TCarSysParser.loadFactReplIt(const strs: TStrings);
  function getKV(const S: string; var k, v: string): boolean;
  var strs: TStrings;
    i: integer;
    tmp: string;
  begin
    Result := false;
    strs := TStringList.Create();
    try
      TCharSplit.SplitChar(s, #9, strs);
      if (strs.Count>=4) then begin
        for I := 0 to strs.Count - 1 do begin
          tmp := StringReplace(strs[I], #9, '', [rfReplaceAll]);
          if i=0 then begin
            k := tmp;
          end else if i<3 then begin
            k := k + '/' + tmp;
          end else if (i=3) then begin
            v := tmp;
          end;
        end;
        Result := true;
      end;
    finally
      strs.Free;
    end;
  end;
var i: integer;
  S, k, v: string;
begin
  FDicNewFactory.Clear;
  for I := 1 to strs.Count - 1 do begin
    S := strs[I];
    if (getKV(S,k,v)) then begin
      FDicNewFactory.Add(k, v);
    end;
  end;
end;

end.

