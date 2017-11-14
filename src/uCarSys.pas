unit uCarSys;

interface

uses uCarData;

type
  TCarSys = class(TCarData)
  private
    class var FMaxId: Int64;
  public
    car_serie_id: string;
    car_brand_id: string;
    car_brand_id_raw: string;
    car_brand_name: string;
    car_oem_id: string;
    car_oem_name: string;
    car_serie_code: string;
    car_serie_name: string;
    short_code: string;
    nat_enum: string;
    //
    carSysSpell: string;
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

uses SysUtils;

{ TCarSys }

class constructor TCarSys.Create;
begin
  FMaxId := 67621203212410000;
end;

constructor TCarSys.Create;
begin
  inherited create;
  //
  car_oem_id := '0';
  nat_enum := '0';
  FTableName := 'ap_car_serie_new';
end;

destructor TCarSys.Destroy;
begin
end;

class function TCarSys.getColumn(const c: char): string;
begin
  Result :=
    'car_serie_id' + c +
    'car_brand_id' + c +
    'car_brand_name' + c +
    'car_oem_id' + c +
    'car_oem_name' + c +
    'car_serie_code' + c +
    'car_serie_name' + c +
    'short_code' + c +
    'nat_enum' + c +
    //'description' + c +
    //'remark' + c +
    'state' + c +
    'sort_no' + c +
    'create_time' + c +
    'modify_time' + c +
    'creator_id' + c +
    'modifier_id' + c +
    'raw_id';
end;

function TCarSys.getRow(const c: char; const quoted: boolean): string;
begin
  if quoted then begin
    Result :=
      car_serie_id + c +
      car_brand_id + c +
      QuotedStr(car_brand_name) + c +
      car_oem_id + c +
      QuotedStr(car_oem_name) + c +
      QuotedStr(car_serie_code) + c +
      QuotedStr(car_serie_name) + c +
      QuotedStr(short_code) + c +
      //nat_enum + c +
      //'description' + c +
      //'remark' + c +
      state + c +
      (sort_no) + c +
      QuotedStr(create_time) + c +
      QuotedStr(modify_time) + c +
      (creator_id) + c +
      (modifier_id) + c +
      (raw_id);
  end else begin
    Result :=
      car_serie_id + c +
      car_brand_id + c +
      car_brand_name + c +
      car_oem_id + c +
      car_oem_name + c +
      car_serie_code + c +
      car_serie_name + c +
      short_code + c +
      nat_enum + c +
      //description + c +
      //remark + c +
      state + c +
      sort_no + c +
      create_time + c +
      modify_time + c +
      creator_id + c +
      modifier_id + c +
      raw_id;
  end;
end;

procedure TCarSys.setRawId(const S: string);
begin
  raw_id := s;
  self.car_serie_id := IntToStr(FMaxId+ StrToInt(s));
end;

end.

