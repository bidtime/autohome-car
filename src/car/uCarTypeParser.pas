unit uCarTypeParser;

interface

uses SysUtils, classes, Generics.Collections, uCarBrand, uCarSys, uCarType,
  uCarParserBase, uCommEvents, uNetHttpClt;

type
  TCarTypeParser = class(TCarParserBase)
  private
    FDicVehType: TDictionary<String, String>;
    FDicVehTypeId: TDictionary<String, String>;
    FMapCarTypeRaw: TDictionary<Integer, String>;
  public
    constructor Create();
    destructor Destroy; override;
    procedure loadDicVehType(const strs: TStrings);
    procedure loadDicVehTypeId(const strs: TStrings);
    //
    function parerToList(const S: string; const carBrand: TCarBrand;
      const carSys: TCarSys; const cb: TGetBrandSysTypeProc;
        const bNew: boolean): boolean;
    function preParerToList(const carBrand: TCarBrand;
        const carSys: TCarSys; const bNew: boolean; const cb: TGetStrProc): string;
  public
    property MapCarTypeRaw: TDictionary<Integer, String> read FMapCarTypeRaw write FMapCarTypeRaw;
  end;

implementation

uses System.json, uCharSplit, uMyTextFile, uStrUtils;

{ TCarTypeParser }

constructor TCarTypeParser.Create();
begin
  inherited create();
  FFileName := 'car-type-all.txt';
  FDicVehType := TDictionary<String, String>.create();
  FDicVehTypeId:= TDictionary<String, String>.create();
  FMapCarTypeRaw:= TDictionary<Integer, String>.create();
end;

destructor TCarTypeParser.Destroy;
begin
  FDicVehType.Free;
  FDicVehTypeId.Free;
  FMapCarTypeRaw.Free;
end;

function TCarTypeParser.parerToList(const S: string; const carBrand: TCarBrand;
  const carSys: TCarSys; const cb: TGetBrandSysTypeProc;
    const bNew: boolean): boolean;

  procedure adjustCar(var year, carTypeName: string);
  var  carTypeMini, carTypeNew, S: string;
        w: char;
  begin
    if getLeftLeftStr(carTypeName, '款', S) then begin
      carTypeMini := trim(getRightChar(carTypeName, #32));
      if (SameText(year, '')) then begin
        if s.Length>2 then begin
          carTypeNew := carTypeName;
        end else begin
          w := s[1];
          if (CharInSet(w, ['0', '1', '2', '3'])) then begin
            year := '20' + S;
            carTypeNew := year + '款 ' + carTypeMini;
          end else if (CharInSet(w, ['9', '8', '7', '6'])) then begin
            year := '19' + S;
            carTypeNew := year + '款 ' + carTypeMini;
          end else begin
            carTypeNew := carTypeName;
          end;
        end;
        carTypeName := carTypeNew;
      end else begin
        carTypeNew := year + '款 ' + carTypeMini;
        carTypeName := carTypeNew;
      end;
    end
  end;

  procedure processOne(const jsonVal: TJSONValue);
    procedure processA(var year: string; const jsonV: TJSONValue);
    var carTypeStrRawId, carName: string;
      carTypeIdRaw: integer;
      carType: TCarType;
    begin
      carType := TCarType.Create;
      try
        jsonV.TryGetValue<String>('id', carTypeStrRawId);
        carTypeStrRawId := StringReplace(carTypeStrRawId, #9, '', [rfReplaceAll]);
        carTypeIdRaw := StrToIntDef(carTypeStrRawId, 0);
        if not FMapCarTypeRaw.ContainsKey(carTypeIdRaw) then begin
          jsonV.TryGetValue<String>('name', carname);
          //do detail
          //if (SameText(FCarT_Id, '')) or SameText(FCarT_Id, carTypeRawId) then begin
          carName := StringReplace(carName, #9, '', [rfReplaceAll]);
          if year.IsEmpty then begin
            adjustCar(year, carName);
          end;
          //doReqCarDetail(carTypeStrRawId, carName, year, carSys);
          carType.car_brand_id := carSys.car_brand_id;
          carType.car_brand_name := carSys.car_brand_name;
          carType.car_oem_name := carSys.car_oem_name;
          carType.car_serie_id := carSys.car_serie_id;
          carType.car_serie_name := carSys.car_serie_name;
          carType.year_model := year;
          carType.setRawId(carTypeStrRawId);
          carType.car_type_name := carName;
          if Assigned(cb) then begin
            cb(carBrand, carSys, carType);
          end;
          // write to file
          FFileText.WriteLine(carType.getSql());
          //FFileText.WriteLn_( carType.updateGearSql() );
          // to cache
          FMapCarTypeRaw.Add(carTypeIdRaw, carName);
        end;
        Result := true;
      finally
        carType.Free;
      end;
   end;
  var
    year: string;
    i: integer;
    jsonArray: TJSONArray; // JSON Array
  begin
    jsonVal.TryGetValue<String>('year', year);
    year := StringReplace(year, '款', '', [rfReplaceAll]);
    //if StrToIntDef(year, 0)<2000 then begin    //remove 2000 year before cartype
    //  exit;
    //end;

    jsonVal.TryGetValue<TJSONArray>('spec', jsonArray);
    for i := 0 to jsonArray.Count - 1 do begin
      if isStop() then begin
        break;
      end;
      processA(year, jsonArray.Items[i]);
    end;
  end;

  procedure processOne2(const jsonVal: TJSONValue);
  var
    year, carTypeRawId, carName: string;
    carId: integer;
    carType: TCarType;
  begin
    carType := TCarType.Create;
    try
      carid := 0;
      if (jsonVal.TryGetValue<Integer>('id', carId)) and (carid>0) then begin
        if not FMapCarTypeRaw.ContainsKey(carId) then begin
          carTypeRawId := IntToStr(carid);
          //if (SameText(FCarT_Id, '')) or SameText(FCarT_Id, carTypeRawId) then begin
          jsonVal.TryGetValue<String>('year', year);
          year := StringReplace(year, '款', '', [rfReplaceAll]);
          jsonVal.TryGetValue<String>('name', carName);
          if year.IsEmpty then begin
            adjustCar(year, carName);
          end;
          //doReqCarDetail(carTypeRawId, carName, year, carSys);
          carType.car_brand_id := carSys.car_brand_id;
          carType.car_brand_name := carSys.car_brand_name;
          carType.car_oem_name := carSys.car_oem_name;
          carType.car_serie_id := carSys.car_serie_id;
          carType.car_serie_name := carSys.car_serie_name;
          carType.year_model := year;
          carType.setRawId(carTypeRawId);
          carType.car_type_name := carName;
          if Assigned(cb) then begin
            cb(carBrand, carSys, carType);
          end;
          // write to file
          FFileText.WriteLine(carType.getSql());
          //FFileText.WriteLn_( carType.updateGearSql() );
          // to cache
          FMapCarTypeRaw.Add(carId, carName);
        end else begin
          //carName := FMapCarTypeRaw.Items[carId];
          //self.addLog(IntToStr(carId) + '/' + carname + ', is exists.');
        end;
      end;
    finally
      carType.Free;
    end;
  end;

  procedure processList(const jsonArray: TJSONArray);
  var
    jsonVal : TJSONValue;
  begin
    for jsonVal in jsonArray do begin
      if isStop() then begin
        break;
      end;
      if bNew then begin
        processOne2(jsonVal);
      end else begin
        processOne(jsonVal);
      end;
    end;
  end;

  procedure processValue(const jsonVal: TJSONValue);
  begin
    if (jsonVal = nil) then begin
      exit;
    end else if (jsonVal.ClassType = TJSONArray) then begin
      processList(jsonVal as TJSONArray);
    end else if (jsonVal.ClassType = TJSONObject) then begin
      processOne(jsonVal);
    end;
  end;

  procedure parserItA(const S: string);
  var
    jsonVal: TJSONValue;
  begin
    if Trim(S) = '' then begin
      exit;
    end;
    jsonVal := TJSONObject.ParseJSONValue(S);
    try
      { from string to JSON } //TEncoding.UTF8.GetBytes(StrJson)
      processValue(jsonVal);
    finally
      jsonVal.Free;
    end;
  end;
var ss: string;
begin
  if bNew then begin
    parserItA(S);
  end else begin
    ss := StringReplace(S, 'spec:', '"spec":', [rfReplaceAll]);
    parserItA(ss);
  end;
end;

function TCarTypeParser.preParerToList(
  const carBrand: TCarBrand; const carSys: TCarSys; const bNew: boolean;
  const cb: TGetStrProc): string;
var url, fname, S, carTypeFileName: string;
  brandSpell, carSysSpell, carsysId, brandName, carSysName: string;
begin
  brandSpell := carBrand.ShortCode;
  carSysSpell := carSys.carSysSpell;
  carsysId := carSys.car_serie_id;
  brandName := carSys.car_brand_name;
  carSysName := carSys.car_serie_name;
  //
  if bNew then begin
    carTypeFileName := 'cartype_';
    //list year
    //https://www.che168.com/handler/usedcarlistv5.ashx?action=seriesYearList&area=china&brand=aodi&ls=aodiq3
    //all year
    //https://www.che168.com/handler/UsedCarListV5.ashx?action=speclist&area=china&brand=aodi&ls=aodia3
    url := 'https://www.che168.com/handler/UsedCarListV5.ashx?action=speclist&area=china&brand=%s&ls=%s';
    url := format(url, [brandSpell, carSysSpell]);
  end else begin
    carTypeFileName := 'cartype';
    //https://i.che168.com/Handler/SaleCar/ScriptCarList_V1.ashx?seriesGroupType=2&needData=3&seriesid=3170
    //url := 'https://www.che168.com//Handler/SaleCar/ScriptCarList_V1.ashx?' +
    //  'seriesGroupType=2&needData=3&seriesid=' + carsysId;
    //https://www.che168.com/Handler/ScriptCarList_V1.ashx?seriesGroupType=2&needData=3&seriesid=3170
    url := 'https://www.che168.com/Handler/ScriptCarList_V1.ashx?seriesGroupType=2&needData=3&seriesid=%s';
    url := format(url, [carSys.RawId]);
  end;
  fname := getSubDataDir(brandName + '\' + carSysName + '\' + carTypeFileName + '.txt');
  S := getGBK(url, fname, true, cb);
  // do parse car-type
  //FCarTypePaser.parerToList(S, carBrand, carSys, doReqCarDetail, isDoNew);
  Result := S;
end;

procedure TCarTypeParser.loadDicVehType(const strs: TStrings);
begin
  loadStand(strs, FDicVehType);
end;

procedure TCarTypeParser.loadDicVehTypeId(const strs: TStrings);
begin
  loadStand(strs, FDicVehTypeId);
end;

end.

