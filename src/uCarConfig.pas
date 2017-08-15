unit uCarConfig;

interface

type
  TCarConfig=class(TObject)
  private
    car_cfg_id: string;
    {sort_no: string;
    create_time: string;
    modify_time: string;}
    //creator_id: string;
    //modifier_id: string;
  public
    car_type_id: string;
    //'car_cfg_type_id' + #9 +
    car_cfg_type_name: string;
    car_cfg_name: string;
    car_cfg_value: string;
  private
    class var FMaxId: Int64;
    class function getMaxId: Int64; static;
    class var tableName: string;
  public
    class constructor Create;
    constructor Create;
    destructor Destroy; override;
    //class function getColumn(): string;
    class function getBegin(): string;
    class function getEnd(): string;
    function getRow(): string;
    procedure setRow(const S: string);
    function getSql: string;
  end;

implementation

uses SysUtils, classes;

{ TCarType }

constructor TCarConfig.Create;
begin
  //state:='1';
  car_cfg_id := IntToStr(getMaxId);
  //sort_no:='0';
  //create_time:=FormatDateTime('yyyy-mm-dd hh:nn:ss', now);
  //modify_time:=create_time;
  //creator_id:='0';
  //modifier_id:='0';
end;

class constructor TCarConfig.Create;
begin
  tableName := 'ap_car_cfg';
  //FMaxId := 67628185763100000;
  FMaxId := 62131612811213576;
end;

destructor TCarConfig.Destroy;
begin

end;

class function TCarConfig.getBegin: string;
begin
  Result := 'start transaction;';
  Result := 'truncate table ' + tableName;
end;

//class function TCarConfig.getColumn: string;
//begin
//  Result := '';
//  Result :=
//    'car_cfg_id' + #9 +
//    'car_type_id' + #9 +
//    //'car_param_type_id' + #9 +
//    'car_cfg_type_name' + #9 +
//    'car_cfg_name' + #9 +
//    'car_cfg_value'
    { + #9 +
    'sort_no' + #9 +
    'create_time' + #9 +
    'modify_time' + #9 +
    'creator_id' + #9 +
    'modifier_id'}
//end;

class function TCarConfig.getEnd: string;
begin
  Result := 'commit;';
end;

class function TCarConfig.getMaxId: Int64;
begin
 Dec(FMaxId);
 Result := FMaxId;
end;

function TCarConfig.getRow: string;
begin
  Result := getSql();
//  Result :=
//    car_cfg_id + #9 +
//    car_type_id + #9 +
//    //'car_param_type_id' + #9 +
//    car_cfg_type_name + #9 +
//    car_cfg_name + #9 +
//    car_cfg_value
    { + #9 +
    sort_no + #9 +
    create_time + #9 +
    modify_time + #9 +
    creator_id + #9 +
    modifier_id}
    ;
end;

function TCarConfig.getSql: string;
  function getCol(): string;
  begin
    Result :=
      'car_cfg_id' + ',' +
      'car_type_id' + ',' +
      //'car_param_type_id' + #9 +
      'car_cfg_type_name' + ',' +
      'car_cfg_name' + ',' +
      'car_cfg_value'
      ;
  end;

  function getVal: string;
  begin
    Result :=
      QuotedStr(car_cfg_id) + ',' +
      QuotedStr(car_type_id) + ',' +
      //'car_param_type_id' + #9 +
      QuotedStr(car_cfg_type_name) + ',' +
      QuotedStr(car_cfg_name) + ',' +
      QuotedStr(car_cfg_value)
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

procedure TCarConfig.setRow(const S: string);
  procedure strsToItems(strs: TStrings);
  //var i: integer;
  begin
    {for I := 0 to strs.Count - 1 do begin
      case I of
        0: brand_id := strs[I];
        1: brand_code := strs[I];
        2: brand_name := strs[I];
        3: quick_code := strs[I];
        4: focus_letter := strs[I];
        5: brandLogo := strs[I];
        6: state := strs[I];
        7: sort_no := strs[I];
        8: create_time := strs[I];
        9: modify_time := strs[I];
        10: creator_id := strs[I];
        11: modifier_id := strs[I];
        12: raw_Id := strs[I];
        13: carBrandSpell := strs[I];
      end;
    end;}
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

{procedure TCarConfig.setRawId(const S: string);
begin
  raw_id := s;
  self.car_type_id := IntToStr(getMaxId() + StrToInt(s));
end;

function TCarType.getRawId: string;
begin
  Result := raw_id;
end;}

end.

