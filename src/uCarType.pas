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
    sale_date: string;
    //out_date: string;
    //stop_date: string;
    sug_price: string;
    year_model: string;
    fengine: string;
    gear: string;
    fdispunit: string;
    fdisplay: string;

    procedure setDisplay(const S: string);
    procedure setDispunit(const S: string);
    procedure setEngine(const S: string);
  public
    class constructor Create;
    constructor Create;
    destructor Destroy; override;
    //
    procedure setRawId(const S: string); override;
    class function getColumn(const c: char=#9): string; override;
    function getRow(const c: char=#9; const quoted: boolean=false): string; override;
    //
    property dispunit: string read fdispunit write setDispunit;
    property display: string read fdisplay write setDisplay;
    property engine: string read fengine write setEngine;
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
  FTableName := 'ap_car_type_new';
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

    function str_val(const s: string; const defVal: string; const quoted: boolean): string;
    begin
      if s.IsEmpty then begin
        Result := defVal;
      end else begin
        if quoted then begin
          Result := quotedStr(S);
        end else begin
          Result := s;
        end;
      end;
    end;

    function null_str_val(const s: string): string;
    begin
      Result := str_val(s, 'null', true);
    end;

    function null_num_val(const s: string): string;
    begin
      Result := str_val(s, 'null', false);
    end;

    function zero_val(const s: string): string;
    begin
      Result := str_val(s, '0', false);
    end;

    function display_val(const s: string): string;
    var str: string;
    begin
      str := null_num_val(s);
      if str.equals('-') then begin
        Result := 'null';
      end else begin
        Result := str;
      end;
    end;

begin
  {if car_type_id.Equals('67628185763131521') then begin
    Result := null_num_val(fdisplay);
  end;}

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
      null_str_val(sale_date) + c +
      //out_date + c +
      //stop_date + c +
      QuotedStr(sug_price) + c +
      zero_val(year_model) + c +
      QuotedStr(fengine) + c +
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
      QuotedStr(fdispunit) + c +
      display_val(fdisplay);
  {end else begin
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
      fdispunit + c +
      fdisplay;}
  end;
end;

procedure TCarType.setDisplay(const S: string);
begin
  fdisplay := S.Replace(#9, ' ');
end;

procedure TCarType.setDispunit(const S: string);
begin
  fdispunit := S.Replace(#9, ' ');
end;

procedure TCarType.setEngine(const S: string);
begin
  fengine := S.Replace(#9, ' ');
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

