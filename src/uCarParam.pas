unit uCarParam;

interface

type
  TCarParam=class(TObject)
  private
    car_param_id: string;
    {sort_no: string;
    create_time: string;
    modify_time: string;}
    //creator_id: string;
    //modifier_id: string;
  private
    class var FMaxId: Int64;
    class function getMaxId: Int64; static;
    class var tableName: string;
  public
    car_type_id: string;
    //'car_param_type_id' + #9 +
    car_param_type_name: string;
    car_param_name: string;
    car_param_value: string;
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

constructor TCarParam.Create;
begin
  //state:='1';
  car_param_id := IntToStr(getMaxId);
  //sort_no:='0';
  //create_time:=FormatDateTime('yyyy-mm-dd hh:nn:ss', now);
  //modify_time:=create_time;
  //creator_id:='0';
  //modifier_id:='0';
end;

class constructor TCarParam.Create;
begin
  //FMaxId := 67521212811165280;
  tableName := 'ap_car_param';
  FMaxId := 61534231325612512;
end;

destructor TCarParam.Destroy;
begin

end;

class function TCarParam.getBegin: string;
begin
  Result := 'start transaction;';
  Result := 'truncate table ' + tableName;
end;

//class function TCarParam.getColumn: string;
//begin
//  Result := '';
  {Result :=
    'car_param_id' + #9 +
    'car_type_id' + #9 +
    //'car_param_type_id' + #9 +
    'car_param_type_name' + #9 +
    'car_param_name' + #9 +
    'car_param_value'}
    { + #9 +
    'sort_no' + #9 +
    'create_time' + #9 +
    'modify_time' + #9 +
    'creator_id' + #9 +
    'modifier_id'}
//end;

class function TCarParam.getEnd: string;
begin
  Result := 'commit;';
end;

class function TCarParam.getMaxId: Int64;
begin
  Dec(FMaxId);
  Result := FMaxId;
end;

function TCarParam.getRow: string;
begin
  Result := getSql();
  {Result :=
    car_param_id + #9 +
    car_type_id + #9 +
    //'car_param_type_id' + #9 +
    car_param_type_name + #9 +
    car_param_name + #9 +
    car_param_value}
    { + #9 +
    sort_no + #9 +
    create_time + #9 +
    modify_time + #9 +
    creator_id + #9 +
    modifier_id};
end;

function TCarParam.getSql: string;

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
  begin
    Result :=
      QuotedStr(car_param_id) + ',' +
      QuotedStr(car_type_id) + ',' +
      //'car_param_type_id' + #9 +
      QuotedStr(car_param_type_name) + ',' +
      QuotedStr(car_param_name) + ',' +
      QuotedStr(car_param_value)
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

procedure TCarParam.setRow(const S: string);
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


end.

