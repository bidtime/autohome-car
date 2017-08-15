unit uCarSys;

interface

type
  TCarSys=class(TObject)
  private
    raw_id: string;
    //cover_url: string;
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
    class function getMaxId: Int64; static;
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
    class function getColumn(): string;
    procedure setRawId(const S: string);
    function getRow(): string;
    function getRawId: string;
  end;

implementation

uses SysUtils;

{ TCarType }

constructor TCarSys.Create;
begin
  state:='1';
  sort_no:='0';
  create_time:=FormatDateTime('yyyy-mm-dd hh:nn:ss', now);
  modify_time:=create_time;
  creator_id:='0';
  modifier_id:='0';
  //
  car_oem_id := '0';
  nat_enum := '0';
end;

class constructor TCarSys.Create;
begin
  //FMaxId := 67541628432410000;
  FMaxId := 67621203212410000;
end;

destructor TCarSys.Destroy;
begin

end;

class function TCarSys.getMaxId: Int64;
begin
 //Dec(FMaxId);
 Result := FMaxId;
end;

function TCarSys.getRawId: string;
begin
  Result := raw_id;
end;

class function TCarSys.getColumn: string;
begin
  Result :=
    'car_serie_id' + #9 +
    'car_brand_id' + #9 +
    'car_brand_name' + #9 +
    'car_oem_id' + #9 +
    'car_oem_name' + #9 +
    'car_serie_code' + #9 +
    'car_serie_name' + #9 +
    'short_code' + #9 +
    'nat_enum' + #9 +
    //'description' + #9 +
    //'remark' + #9 +
    'state' + #9 +
    'sort_no' + #9 +
    'create_time' + #9 +
    'modify_time' + #9 +
    'creator_id' + #9 +
    'modifier_id' + #9 +
    'raw_id';
end;

function TCarSys.getRow: string;
begin
  Result :=
    car_serie_id + #9 +
    car_brand_id + #9 +
    car_brand_name + #9 +
    car_oem_id + #9 +
    car_oem_name + #9 +
    car_serie_code + #9 +
    car_serie_name + #9 +
    short_code + #9 +
    nat_enum + #9 +
    //description + #9 +
    //remark + #9 +
    state + #9 +
    sort_no + #9 +
    create_time + #9 +
    modify_time + #9 +
    creator_id + #9 +
    modifier_id + #9 +
    raw_id;
end;

procedure TCarSys.setRawId(const S: string);
begin
  raw_id := s;
  self.car_serie_id := IntToStr(getMaxId() + StrToInt(s));
end;

end.

