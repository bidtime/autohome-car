unit uCarCfgParser;

interface

uses SysUtils, classes, Generics.Collections, uCarBrand, uCarSys, uCarType,
  uCarParserBase, uCommEvents, uNetHttpClt;

type
  TCarCfgParser = class(TCarParserBase)
  private
  public
    constructor Create(const fileName: string);
    destructor Destroy; override;
    //
    //property DicNewFactory: TDictionary<String, String> write FDicNewFactory;
    function reqParerToList(const clt: TNetHttpClt; const carBrand: TCarBrand;
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

constructor TCarCfgParser.Create(const fileName: string);
begin
  inherited create(fileName);
end;

destructor TCarCfgParser.Destroy;
begin
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
      var carCfg: TCarConfig;
      begin
        carCfg := TCarConfig.create;
        try
          carCfg.car_type_id := carType.car_type_id;
          carCfg.car_cfg_type_name := car_cfg_type_name;
          carCfg.car_cfg_name := k;
          carCfg.car_cfg_value := v;
          //
          if (checked) then begin
            FFileText.WriteLn_(carCfg.getSql());
          end;
        finally
          carCfg.Free;
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

function TCarCfgParser.reqParerToList(const clt: TNetHttpClt;
  const carBrand: TCarBrand; const carSys: TCarSys; var carType: TCarType;
  const checked: boolean; const cb: TGetStrProc): boolean;

  procedure processCfg(const carTypeId: string; const checked: boolean; var carType: TCarType);

    function getFNameOfCarTypeId(const carTypeId: string): string;
    begin
      result := getSubDataDir(carSys.car_brand_name + '\' + carSys.car_serie_name + '\carconfig_'
        + carTypeId + '_' + 'config' + '.json');
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
    url := geUrlOfCarTypeId(carTypeId);
    if not SameText(url, '') then begin
      fname := getFNameOfCarTypeId(carTypeId);
      S := clt.get(url, fname, false, cb);
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

