unit uCarBrand;

interface

uses uCarData;

type
  TCarBrand = class(TCarData)
  public
    letter: string;
    short_code: string;
    logo_url: string;
    blood_enum: string;
    description: string;
    car_brand_id: string;
    car_brand_code: string;
    car_brand_name: string;
    //carBrandSpell: string;
  public
    class constructor Create;
    constructor Create;
    destructor Destroy; override;
    //procedure setRow(const S: string);
    //
    procedure setRawId(const n: string); override;
    class function getColumn(const c: char=#9): string; override;
    function getRow(const c: char=#9; const quoted: boolean=false): string; override;
  public
    property ShortCode: string read short_code write short_code;
  end;

implementation

uses SysUtils, classes;

{ TCarBrand }

class constructor TCarBrand.Create;
begin
  FMaxId := 67541628411220000;
  FTableName := 'ap_car_brand';
end;

constructor TCarBrand.Create;
begin
  inherited Create;
  blood_enum := '0';
end;

destructor TCarBrand.Destroy;
begin
end;

procedure TCarBrand.setRawId(const n: string);
begin
  raw_id := n;
  car_brand_id := IntToStr(FMaxId + StrToInt(n));
end;

class function TCarBrand.getColumn(const c: char): string;
begin
  Result :=
    'car_brand_id' + c +
    'car_brand_code' + c +
    'car_brand_name' + c +
    'description' + c +
    'state' + c +
    'sort_no' + c +
    'create_time' + c +
    'modify_time' + c +
    'creator_id' + c +
    'modifier_id' + c +
    'letter' + c +
    'short_code' + c +
    'logo_url' + c +
    'blood_enum' + c +
    'raw_id';
end;

function TCarBrand.getRow(const c: char; const quoted: boolean): string;
begin
  if quoted then begin
    Result :=
      car_brand_id + c +
      QuotedStr(car_brand_code) + c +
      QuotedStr(car_brand_name) + c +
      QuotedStr(description) + c +
      state + c +
      sort_no + c +
      QuotedStr(create_time) + c +
      QuotedStr(modify_time) + c +
      creator_id + c +
      modifier_id + c +
      QuotedStr(letter) + c +
      QuotedStr(short_code) + c +
      QuotedStr(logo_url) + c +
      blood_enum + c +
      raw_id;
  end else begin
    Result :=
      car_brand_id + c +
      car_brand_code + c +
      car_brand_name + c +
      description + c +
      state + c +
      sort_no + c +
      create_time + c +
      modify_time + c +
      creator_id + c +
      modifier_id + c +
      letter + c +
      short_code + c +
      logo_url + c +
      blood_enum + c +
      raw_id;
  end;
end;

{procedure TCarBrand.setRow(const S: string);
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
end;}

end.

