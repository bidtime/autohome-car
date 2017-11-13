unit uCarType;

interface

uses uCarData;

type
  TCarType=class(TCarData)
  private
    class var FMaxId: Int64;
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
    class constructor Create;
    constructor Create;
    destructor Destroy; override;
    //
    procedure setRawId(const S: string); override;
    class function getColumn(const c: char=#9): string; override;
    function getRow(const c: char=#9; const quoted: boolean=false): string; override;
  end;

implementation

uses SysUtils, variants;

{ TCarType }

class constructor TCarType.Create;
begin
  FMaxId := 67628185763100000;
end;

constructor TCarType.Create;
begin
  inherited create;
  car_oem_id := '0';
  FTableName := 'ap_car_type';
end;

destructor TCarType.Destroy;
begin
end;

class function TCarType.getColumn(const c: char): string;
begin
  Result :=
    'car_type_id' + c +
    'car_brand_id' + c +
    'car_brand_name' + c +
    'car_oem_id' + c +
    'car_oem_name' + c +
    'car_serie_id' + c +
    'car_serie_name' + c +
    'car_type_code' + c +
    'car_type_name' + c +
    'short_code' + c +
    'sale_date' + c +
    //'out_date' + c +
    //'stop_date' + c +
    'sug_price' + c +
    'year_model' + c +
    'engine' + c +
    'gear' + c +
    //'description' + c +
    //'remark' + c +
    'state' + c +
    'sort_no' + c +
    'create_time' + c +
    'modify_time' + c +
    'creator_id' + c +
    'modifier_id' + c +
    'raw_id' + c +
    'dispunit' + c +
    'display';
end;

function TCarType.getRow(const c: char; const quoted: boolean): string;

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
  if quoted then begin
    Result :=
      QuotedStr(car_type_id) + c +
      QuotedStr(car_brand_id) + c +
      QuotedStr(car_brand_name) + c +
      QuotedStr(car_oem_id) + c +
      QuotedStr(car_oem_name) + c +
      QuotedStr(car_serie_id) + c +
      QuotedStr(car_serie_name) + c +
      QuotedStr(car_type_code) + c +
      QuotedStr(car_type_name) + c +
      QuotedStr(short_code) + c +
      QuotedStr(getSaleDate()) + c +
      //out_date + c +
      //stop_date + c +
      QuotedStr(sug_price) + c +
      QuotedStr(getyear()) + c +
      QuotedStr(engine.Replace(c, ' ')) + c +
      QuotedStr(gear) + c +
      //description + c +
      //remark + c +
      state + c +
      sort_no + c +
      QuotedStr(create_time) + c +
      QuotedStr(modify_time) + c +
      creator_id + c +
      modifier_id + c +
      raw_id + c +
      QuotedStr(dispunit.Replace(c, ' ')) + c +
      QuotedStr(display.Replace(c, ' '));
  end else begin
    Result :=
      car_type_id + c +
      car_brand_id + c +
      car_brand_name + c +
      car_oem_id + c +
      car_oem_name + c +
      car_serie_id + c +
      car_serie_name + c +
      car_type_code + c +
      car_type_name + c +
      short_code + c +
      getSaleDate() + c +
      //out_date + c +
      //stop_date + c +
      sug_price + c +
      getyear() + c +
      engine.Replace(c, ' ') + c +
      gear + c +
      //description + c +
      //remark + c +
      state + c +
      sort_no + c +
      create_time + c +
      modify_time + c +
      creator_id + c +
      modifier_id + c +
      raw_id + c +
      dispunit.Replace(c, ' ') + c +
      display.Replace(c, ' ');
  end;
end;

procedure TCarType.setRawId(const S: string);
begin
  raw_id := s;
  self.car_type_id := IntToStr(FMaxId + StrToInt(s));
end;

{function TCarType.updateGearSql(): string;
begin
  Result := 'update ' + tableName +
    ' set ' +
      ' gear = ' + QuotedStr(gear) +
      ' where car_type_id = ' + car_type_id +
    ';'
end;}

end.

