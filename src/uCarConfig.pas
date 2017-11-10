unit uCarConfig;

interface

uses uCarData;

type
  TCarConfig=class(TCarData)
  private
    car_cfg_id: string;
  public
    car_type_id: string;
    //'car_cfg_type_id' + #9 +
    car_cfg_type_name: string;
    car_cfg_name: string;
    car_cfg_value: string;
  public
    class constructor Create;
    constructor Create;
    destructor Destroy; override;
    //
    class function getColumn(const c: char=#9): string; override;
    function getRow(const c: char=#9; const quoted: boolean=false): string; override;
  end;

implementation

uses SysUtils, classes;

{ TCarConfig }

constructor TCarConfig.Create;
begin
  inherited create;
  car_cfg_id := IntToStr(getIncMaxId());
end;

class constructor TCarConfig.Create;
begin
  FTableName := 'ap_car_cfg';
  FMaxId := 62131612811213576;
end;

destructor TCarConfig.Destroy;
begin
end;

class function TCarConfig.getColumn(const c: char): string;
begin
  Result :=
    'car_cfg_id' + c +
    'car_type_id' + c +
    //'car_cfg_type_id' + c +
    'car_cfg_type_name' + c +
    'car_cfg_name' + c +
    'car_cfg_value' + c +
    'sort_no' + c +
    'create_time' + c +
    'modify_time' + c +
    'creator_id' + c +
    'modifier_id';
end;

function TCarConfig.getRow(const c: char; const quoted: boolean): string;
begin
  if quoted then begin
     Result :=
      car_cfg_id + c +
      car_type_id + c +
      //'car_cfg_type_id' + c +
      QuotedStr(car_cfg_type_name) + c +
      QuotedStr(car_cfg_name) + c +
      QuotedStr(car_cfg_value) + c +
      sort_no + c +
      QuotedStr(create_time) + c +
      QuotedStr(modify_time) + c +
      creator_id + c +
      modifier_id;
  end else begin
    Result :=
      car_cfg_id + c +
      car_type_id + c +
      //'car_cfg_type_id' + c +
      car_cfg_type_name + c +
      car_cfg_name + c +
      car_cfg_value + c +
      sort_no + c +
      create_time + c +
      modify_time + c +
      creator_id + c +
      modifier_id;
  end;
end;

end.

