unit uCarParParser;

interface

uses SysUtils, classes, Generics.Collections, uCarBrand, uCarSys, uCarType,
  uCarParserBase, uCommEvents, uNetHttpClt;

type
  TCarParParser = class(TCarParserBase)
  private
  public
    constructor Create(const fileName: string);
    destructor Destroy; override;
    //
    function reqParerToList(const carBrand: TCarBrand;
      const carSys: TCarSys; var carType: TCarType;
        const checked: boolean; const cb: TGetStrProc): boolean;
    function parerToList(const S: string; const carBrand: TCarBrand;
      const carSys: TCarSys; var carType: TCarType;
        const checked: boolean): boolean;
  public
  end;

implementation

uses System.json, uCharSplit, uMyTextFile, uStrUtils, uCarParam;

{ TCarParParser }

constructor TCarParParser.Create(const fileName: string);
begin
  inherited create(fileName);
end;

destructor TCarParParser.Destroy;
begin
end;

function TCarParParser.parerToList(const S: string; const carBrand: TCarBrand;
  const carSys: TCarSys; var carType: TCarType; const checked: boolean): boolean;

  procedure doParamItems_CarType(const itemName: string; const k, v: string);
  var str: string;
  begin
    if itemName.Equals('基本参数') then begin
      if k.Equals('厂商指导价(元)') then begin
        carType.sug_price := v;
      end else if k.Equals('级别') then begin
      end else if k.Equals('上市时间') then begin
        str := v+'.1';
        carType.sale_date := str.Replace('.', '-');
      //end else if k.Equals('发动机') then begin
      //  carType.engine := v;
      //end else if k.Equals('变速箱') then begin
      //  carType.gear := v;
      end else if k.Equals('车身结构') then begin
      end else if k.Equals('整车质保') then begin
      end;
    end else if itemName.Equals('车身') then begin
      if k.Equals('车身结构') then begin
      end;
    end else if itemName.Equals('发动机') then begin
      if k.Equals('发动机型号') then begin
        carType.engine := v;
      end else if k.Equals('排量(L)') then begin
        carType.display := v;
      end else if k.Equals('进气形式') then begin
        if v.Contains('涡轮增压') then begin
          carType.dispunit := 'T';
        end;
      end;
    end else if itemName.Equals('变速箱') then begin
      //if k.Equals('简称') then begin
      //end else
      if k.Equals('变速箱类型') then begin
        carType.gear := v;
      end;
    end;
  end;

  procedure doParamTypeItems(JsonResult: TJSONObject);
  var
    typeItem: TJSONObject;
    paramTypeItems: TJSONArray;
    I: Integer;
    typeName: string;

    procedure jsonItemToBean(const car_param_type_name: string; k,v: string);
    var carPar: TCarParam;
    begin
      carPar := TCarParam.create;
      try
        //carPar.car_param_id:= IntToStr(strs.Count);
        carPar.car_type_id := carType.car_type_id;
        carPar.car_param_type_name := car_param_type_name;
        carPar.car_param_name := k;
        carPar.car_param_value := v;
        if (checked) then begin
          FFileText.WriteLn_(carPar.getSql());
        end;
      finally
        carPar.Free;
      end;
    end;

    procedure doParamItems(const car_param_type_name: string;
      paramItems: TJSONArray);
    var
      I: Integer;
      item: TJSONObject;
      k,v: string;
    begin
     for I := 0 to paramItems.Count-1 do begin
        item := paramItems.Items[I] as TJSONObject;
        k := item.GetValue<String>('name');
        v := item.GetValue<String>('value');
        jsonItemToBean(car_param_type_name, k, v);
        //
        doParamItems_CarType(car_param_type_name, k, v);
      end;
    end;
  begin
    paramTypeItems := JsonResult.GetValue('paramtypeitems') as TJSONArray;
    if Assigned(paramTypeItems) then begin
      for I := 0 to paramTypeItems.Count-1 do begin
        typeItem := paramTypeItems.Items[I] as TJSONObject;
        typeName := typeItem.GetValue<String>('name');
        doParamItems(typeName, typeItem.GetValue<TJSONArray>('paramitems'));
      end;
    end;
  end;

var
  JsonRoot, JsonResult: TJSONObject;
begin
  JsonRoot := TJSONObject.ParseJSONValue(S) as TJSONObject ;
  try
    JsonResult := JsonRoot.GetValue('result') as TJsonObject;
    doParamTypeItems(JsonResult);
    Result := true;
  finally
    JsonRoot.Free;
  end;
end;

function TCarParParser.reqParerToList(//const clt: TNetHttpClt;
  const carBrand: TCarBrand; const carSys: TCarSys; var carType: TCarType;
  const checked: boolean; const cb: TGetStrProc): boolean;

  procedure processPar(const carTypeId: string;
    const checked: boolean; var carType: TCarType);

    function getFNameOfCarTypeId(const carTypeId: string): string;
    begin
      result := getSubDataDir(carSys.car_brand_name + '\' + carSys.car_serie_name + '\carconfig_'
        + carTypeId + '_' + 'param' + '.json');
    end;

    function preProcessA(const str: string): string;
    var S: string;
    begin
      S := str;
      {S := getRightChar(S, #40);
      S := getLeftChar(S, #41);}
      Result := S;
    end;

    function geUrlOfCarTypeId(const carTypeId: string): string;
    var url: string;
    begin
      //http://www.interface.che168.com/CarProduct/GetParam.ashx?_callback=param&specid=3906
      url := 'http://www.interface.che168.com/CarProduct/GetParam.ashx?specid=%s';
      Result := format(url, [carTypeId]);
    end;

  var url, fname, S, str: string;
  begin
    url := geUrlOfCarTypeId(carTypeId);
    if not SameText(url, '') then begin
      fname := getFNameOfCarTypeId(carTypeId);
      S := getGBK(url, fname, false, cb);
      str := preProcessA(S);
      self.parerToList(str, carBrand, carSys, carType, checked);
    end;
  end;

begin
  processPar(carType.RawId, checked, carType);
  Result := true;
end;

end.

