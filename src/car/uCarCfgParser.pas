unit uCarCfgParser;

interface

uses SysUtils, classes, Generics.Collections, uCarBrand, uCarSys, uCarType,
  uCarParserBase, uCommEvents, uNetHttpClt;

type
  TCarCfgParser = class(TCarParserBase)
  private
    FMapCarTypeRaw: TDictionary<String, Int64>;
    procedure loadStrs();
    function getIdByName(const S: string): Int64;
  public
    constructor Create();
    destructor Destroy; override;
    //
    //property DicNewFactory: TDictionary<String, String> write FDicNewFactory;
    function reqParerToList(//const clt: TNetHttpClt;
      const carBrand: TCarBrand;
        const carSys: TCarSys; var carType: TCarType;
          const checked: boolean; const cb: TGetStrProc): boolean;
    function parerToList(const S: string; const carBrand: TCarBrand;
      const carSys: TCarSys; var carType: TCarType;
        const checked: boolean): boolean;
  public
  end;

implementation

uses System.json, uCharSplit, uMyTextFile, uStrUtils, uCarConfig;

{ TCarCfgParser }

constructor TCarCfgParser.Create();
begin
  inherited create();
  FFileName := 'car-type-cfg-all.txt';
  FMapCarTypeRaw := TDictionary<String, Int64>.create;
  loadStrs();
end;

destructor TCarCfgParser.Destroy;
begin
  FMapCarTypeRaw.Free;
end;

procedure TCarCfgParser.loadStrs;
begin
  FMapCarTypeRaw.Add('主/被动安全装备', 62361026123151121);
  FMapCarTypeRaw.Add('内部配置', 62361026123151122);
  FMapCarTypeRaw.Add('外部/防盗配置', 62361026123151123);
  FMapCarTypeRaw.Add('外部配置', 62361026123151124);
  FMapCarTypeRaw.Add('多媒体配置', 62361026123151125);
  FMapCarTypeRaw.Add('安全装备', 62361026123151126);
  FMapCarTypeRaw.Add('座椅配置', 62361026123151127);
  FMapCarTypeRaw.Add('操控配置', 62361026123151128);
  FMapCarTypeRaw.Add('灯光配置', 62361026123151129);
  FMapCarTypeRaw.Add('玻璃/后视镜', 62361026123151130);
  FMapCarTypeRaw.Add('空调/冰箱', 62361026123151131);
  FMapCarTypeRaw.Add('辅助/操控配置', 62361026123151132);
  FMapCarTypeRaw.Add('高科技配置', 62361026123151133);
end;

function TCarCfgParser.getIdByName(const S: string): Int64;
var b: boolean;
begin
  b := FMapCarTypeRaw.TryGetValue(S, result);
  if not b then begin
    Result := 0;
  end;
end;

function TCarCfgParser.parerToList(const S: string; const carBrand: TCarBrand;
  const carSys: TCarSys; var carType: TCarType;
    const checked: boolean): boolean;

    procedure doConfigTypeItems(JsonResult: TJSONObject);
    var
      typeItem: TJSONObject;
      configTypeItems: TJSONArray;
      I: Integer;
      typeName: string;

      procedure jsonItemToBean(const car_cfg_type_name: string; k,v: string);
      var u: TCarConfig;
      begin
        u := TCarConfig.create;
        try
          u.car_type_id := carType.car_type_id;
          u.car_cfg_type_name := car_cfg_type_name;
          u.car_cfg_type_id := getIdByName(car_cfg_type_name);
          u.car_cfg_name := k;
          u.car_cfg_value := v;
          //
          if (checked) then begin
            FFileText.WriteLine(u.getSql());
          end;
        finally
          u.Free;
        end;
      end;

      procedure doConfigItems(const car_cfg_type_name: string;
        paramItems: TJSONArray);
      var
        I: Integer;
        item: TJSONObject;
        k, v: string;
      begin
        for I := 0 to paramItems.Count-1 do begin
          item := paramItems.Items[I] as TJSONObject;
          //
          k := item.GetValue<String>('name');
          v := item.GetValue<String>('value');
          jsonItemToBean(car_cfg_type_name, k, v);
        end;
      end;

    begin
      configTypeItems := JsonResult.GetValue('configtypeitems') as TJSONArray;
      if Assigned(configTypeItems) then begin
        for I := 0 to configTypeItems.Count-1 do begin
          typeItem := configTypeItems.Items[I] as TJSONObject;
          typeName := typeItem.GetValue<String>('name');
          doConfigItems(typeName, typeItem.GetValue<TJSONArray>('configitems'));
        end;
      end;
    end;

var
  JsonRoot, JsonResult: TJSONObject;
begin
  JsonRoot := TJSONObject.ParseJSONValue(S) as TJSONObject ;
  try
    JsonResult := JsonRoot.GetValue('result') as TJsonObject;
    doConfigTypeItems(JsonResult);
    Result := true;
  finally
    JsonRoot.Free;
  end;
end;

function TCarCfgParser.reqParerToList(//const clt: TNetHttpClt;
  const carBrand: TCarBrand; const carSys: TCarSys; var carType: TCarType;
  const checked: boolean; const cb: TGetStrProc): boolean;

  procedure processCfg(const carRawId: string; const checked: boolean; var carType: TCarType);

    function getFNameOfCarTypeId(const carRawId: string): string;
    var S: string;
    begin
      S := getSubDataDir(carSys.car_brand_name + '\' + carSys.car_serie_name + '\carconfig_'
        + carRawId + '_' + 'config' + '.json');
      Result := S;
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
      //http://www.interface.che168.com/CarProduct/GetConfig.ashx?_callback=config&specid=3906
      url := 'http://www.interface.che168.com/CarProduct/GetConfig.ashx?specid=%s';
      Result := format(url, [carTypeId]);
    end;

  var url, fname, S, str: string;
  begin
    if SameText(carRawId, '16571') then begin
      str := carRawId;
    end;

    url := geUrlOfCarTypeId(carRawId);
    if not SameText(url, '') then begin
      fname := getFNameOfCarTypeId(carRawId);
      S := getGBK(url, fname, false, cb);
      str := preProcessA(S);
      //
      self.parerToList(str, carBrand, carSys, carType, checked);
    end;
  end;

begin
  processCfg(carType.RawId, checked, carType);
  Result := true;
end;

end.

