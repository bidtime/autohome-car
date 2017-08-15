unit uCarBrand;

interface



type
  TCarBrand=class(TObject)
  private
    class var FMaxId: Int64;
  private
    raw_id: string;
    description: string;
    state: string;
    sort_no: string;
    create_time: string;
    modify_time: string;
    creator_id: string;
    modifier_id: string;
  public
    letter: string;
    short_code: string;
    logo_url: string;
    blood_enum: string;
    car_brand_id: string;
    car_brand_code: string;
    car_brand_name: string;
    //carBrandSpell: string;
  private
  public
    class constructor Create;
    constructor Create;
    destructor Destroy; override;
    class function getColumn(): string;
    class function getMaxId(): Int64;
    function getRow(): string;
    procedure setRow(const S: string);
    procedure setRawId(const n: string);

    function getRawId(): string;
    function getSpell(): string;
  end;

implementation

uses SysUtils, classes;

{ TCarType }

class constructor TCarBrand.Create;
begin
  //Result := 67541628411224064;
  //Result := 67541628411220000;
  FMaxId := 67541628411220000;
end;

constructor TCarBrand.Create;
begin
  state:='1';
  sort_no:='0';
  blood_enum := '0';
  create_time:=FormatDateTime('yyyy-mm-dd hh:nn:ss', now);
  modify_time:=create_time;
  creator_id:='0';
  modifier_id:='0';
end;

destructor TCarBrand.Destroy;
begin

end;

class function TCarBrand.getColumn: string;
begin
  Result :=
    'car_brand_id' + #9 +
    'car_brand_code' + #9 +
    'car_brand_name' + #9 +
    'description' + #9 +
    'state' + #9 +
    'sort_no' + #9 +
    'create_time' + #9 +
    'modify_time' + #9 +
    'creator_id' + #9 +
    'modifier_id' + #9 +
    'letter' + #9 +
    'short_code' + #9 +
    'logo_url' + #9 +
    'blood_enum' + #9 +
    'raw_id';
end;

class function TCarBrand.getMaxId: Int64;
begin
 //Dec(FMaxId);
 Result := FMaxId;
end;

function TCarBrand.getRawId: string;
begin
  Result := raw_id;
end;

function TCarBrand.getRow: string;
begin
  Result :=
    car_brand_id + #9 +
    car_brand_code + #9 +
    car_brand_name + #9 +
    description + #9 +
    state + #9 +
    sort_no + #9 +
    create_time + #9 +
    modify_time + #9 +
    creator_id + #9 +
    modifier_id + #9 +
    letter + #9 +
    short_code + #9 +
    logo_url + #9 +
    blood_enum + #9 +
    raw_id;
end;

function TCarBrand.getSpell: string;
begin
  Result := self.short_code;
end;

procedure TCarBrand.setRawId(const n: string);
begin
  raw_id := n;
  car_brand_id := IntToStr(getMaxId() + StrToInt(n));
end;

procedure TCarBrand.setRow(const S: string);
  procedure strsToItems(strs: TStrings);
  var i: integer;
    str: string;
  begin
    for I := 0 to strs.Count - 1 do begin
      str := strs[I];
      case I of
        0: car_brand_id := str;
        1: car_brand_code := str;
        2: car_brand_name := str;
        3: description := str;
        4: state := str;
        5: sort_no := str;
        6: create_time := str;
        7: modify_time := str;
        8: creator_id := str;
        9: modifier_id := str;
        10: letter := str;
        11: short_code := str;
        12: logo_url := str;
        13: blood_enum := str;
        14: raw_id := str;
      end;
    end;
  end;

var strs: TStrings;
begin
  strs := TStringList.Create;
  try
    strs.StrictDelimiter := true;
    strs.Delimiter := #9;
    strs.DelimitedText := S;
    strsToItems(strs);
  finally
    if Assigned(strs) then strs.Free;
  end;
end;


end.

