unit uCarType;

interface

type
  TCarType=class(TObject)
  private
    raw_id: string;
    //description: string;
    //remark: string;
    state: string;
    sort_no: string;
    create_time: string;
    modify_time: string;
    creator_id: string;
    modifier_id: string;
  private
    class var FMaxId: Int64;
    class var tableName: string;
    class function getMaxId: Int64; static;
    class function getColumn(): string;
    function getRow(): string;
  public
    car_type_id: string;
    car_brand_id: string;
    car_brand_name: string;
    car_oem_id: string;
    car_oem_name: string;
    car_serie_id: string;
    car_serie_name: string;
    car_type_code: string;
    car_type_name: string;
    short_code: string;
    sale_date: variant;
    //out_date: string;
    //stop_date: string;
    sug_price: string;
    year_model: string;
    engine: string;
    gear: string;
    dispunit: string;
    display: string;
  public
    //constructor Create(i:integer); overload;
    class constructor Create;
    constructor Create;
    destructor Destroy; override;
    procedure setRawId(const S: string);
    function getRawId: string;
    function updateGearSql(): string;
    function getSql: string;
    class function getBegin(): string;
    class function getEnd(): string;
  end;

implementation

uses SysUtils, variants;

{ TCarType }

constructor TCarType.Create;
begin
  state:='1';
  sort_no:='0';
  create_time:=FormatDateTime('yyyy-mm-dd hh:nn:ss', now);
  modify_time:=create_time;
  creator_id:='0';
  modifier_id:='0';
  //
  car_oem_id := '0';
end;

class constructor TCarType.Create;
begin
  tableName := 'ap_car_type';
  //FMaxId := 67541625896120000;
  FMaxId := 67628185763100000;
end;

destructor TCarType.Destroy;
begin

end;

class function TCarType.getBegin: string;
begin
  Result := 'start transaction;';
  // Result := 'truncate table ' + tableName;
end;

class function TCarType.getColumn: string;
begin
  Result :=
    'car_type_id' + #9 +
    'car_brand_id' + #9 +
    'car_brand_name' + #9 +
    'car_oem_id' + #9 +
    'car_oem_name' + #9 +
    'car_serie_id' + #9 +
    'car_serie_name' + #9 +
    'car_type_code' + #9 +
    'car_type_name' + #9 +
    'short_code' + #9 +
    'sale_date' + #9 +
    //'out_date' + #9 +
    //'stop_date' + #9 +
    'sug_price' + #9 +
    'year_model' + #9 +
    'engine' + #9 +
    'gear' + #9 +
    //'description' + #9 +
    //'remark' + #9 +
    'state' + #9 +
    'sort_no' + #9 +
    {'create_time' + #9 +
    'modify_time' + #9 +
    'creator_id' + #9 +
    'modifier_id' + #9 +}
    'raw_id' + #9 +
    'dispunit' + #9 +
    'display';
end;

class function TCarType.getEnd: string;
begin
  Result := 'commit;';
end;

function TCarType.getRow: string;
  function getSaleDate(): variant;
  begin
    if VarIsEmpty(sale_date) then begin
      Result := 'null';
    end else begin
      Result := sale_date;
    end;
  end;

  function getyear(): string;
  begin
    if year_model.IsEmpty then begin
      Result := '0';
    end else begin
      Result := year_model;
    end;
  end;

begin
  Result :=
    car_type_id + #9 +
    car_brand_id + #9 +
    car_brand_name + #9 +
    car_oem_id + #9 +
    car_oem_name + #9 +
    car_serie_id + #9 +
    car_serie_name + #9 +
    car_type_code + #9 +
    car_type_name + #9 +
    short_code + #9 +
    getSaleDate() + #9 +
    //out_date + #9 +
    //stop_date + #9 +
    sug_price + #9 +
    getyear() + #9 +
    engine.Replace(#9, ' ') + #9 +
    gear + #9 +
    //description + #9 +
    //remark + #9 +
    state + #9 +
    sort_no + #9 +
    {create_time + #9 +
    modify_time + #9 +
    creator_id + #9 +
    modifier_id + #9 + }
    raw_id + #9 +
    dispunit.Replace(#9, ' ') + #9 +
    display.Replace(#9, ' ');
end;

procedure TCarType.setRawId(const S: string);
begin
  raw_id := s;
  self.car_type_id := IntToStr(getMaxId() + StrToInt(s));
end;

class function TCarType.getMaxId: Int64;
begin
 //Dec(FMaxId);
 Result := FMaxId;
end;

function TCarType.updateGearSql(): string;

  {function getCol(): string;
  begin
    Result :=
      'car_param_id' + ',' +
      'car_type_id' + ',' +
      //'car_param_type_id' + #9 +
      'car_param_type_name' + ',' +
      'car_param_name' + ',' +
      'car_param_value'
      ;
  end;

  function getVal: string;
  begin
    Result :=
      QuotedStr(gear) + ',' +
      QuotedStr(car_type_id);
      ;
  end;}

begin
  Result := 'update ' + tableName +
    ' set ' +
      ' gear = ' + QuotedStr(gear) +
      ' where car_type_id = ' + car_type_id +
    ';'
end;

function TCarType.getSql: string;

  function getCol(): string;
  begin
    Result :=
      'car_type_id' + ', ' +
      'car_brand_id' + ', ' +
      'car_brand_name' + ', ' +
      'car_oem_id' + ', ' +
      'car_oem_name' + ', ' +
      'car_serie_id' + ', ' +
      'car_serie_name' + ', ' +
      'car_type_code' + ', ' +
      'car_type_name' + ', ' +
      'short_code' + ', ' +
      'sale_date' + ', ' +
      //'out_date' + ', ' +
      //'stop_date' + ', ' +
      'sug_price' + ', ' +
      'year_model' + ', ' +
      'engine' + ', ' +
      'gear' + ', ' +
      //'description' + ', ' +
      //'remark' + ', ' +
      'state' + ', ' +
      'sort_no' + ', ' +
      {'create_time' + ', ' +
      'modify_time' + ', ' +
      'creator_id' + ', ' +
      'modifier_id' + ', ' +}
      'raw_id' + ', ' +
      'dispunit' + ', ' +
      'display';
  end;

  function getVal: string;
    function getSaleDate(): variant;
    begin
      if VarIsEmpty(sale_date) then begin
        Result := 'null';
      end else begin
        Result := sale_date;
      end;
    end;

    function getyear(): string;
    begin
      if year_model.IsEmpty then begin
        Result := '0';
      end else begin
        Result := year_model;
      end;
    end;
begin
    Result :=
      QuotedStr(car_type_id) + #9 +
      QuotedStr(car_brand_id) + #9 +
      QuotedStr(car_brand_name) + #9 +
      QuotedStr(car_oem_id) + #9 +
      QuotedStr(car_oem_name) + #9 +
      QuotedStr(car_serie_id) + #9 +
      QuotedStr(car_serie_name) + #9 +
      QuotedStr(car_type_code) + #9 +
      QuotedStr(car_type_name) + #9 +
      QuotedStr(short_code) + #9 +
      QuotedStr(getSaleDate()) + #9 +
      //out_date + #9 +
      //stop_date + #9 +
      QuotedStr(sug_price) + #9 +
      QuotedStr(getyear()) + #9 +
      QuotedStr(engine.Replace(#9, ' ')) + #9 +
      QuotedStr(gear) + #9 +
      //description + #9 +
      //remark + #9 +
      state + #9 +
      sort_no + #9 +
      {create_time + #9 +
      modify_time + #9 +
      creator_id + #9 +
      modifier_id + #9 + }
      raw_id + #9 +
      QuotedStr(dispunit.Replace(#9, ' ')) + #9 +
      QuotedStr(display.Replace(#9, ' '));
      ;
  end;

begin
  Result := 'insert into ' + tableName + '(' +
      getCol() +
    ')' +
    ' value(' +
      getVal() +
    ');'
end;

function TCarType.getRawId: string;
begin
  Result := raw_id;
end;

end.

