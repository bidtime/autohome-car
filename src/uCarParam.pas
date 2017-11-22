unit uCarParam;

interface

uses uCarData, Generics.Collections;

type
  TCarParam=class(TCarData)
  private
    class var FMaxId: Int64;
  private
    car_param_id: string;
    //
    class function getIncMaxId(): Int64;
  public
    car_type_id: string;
    car_param_type_id: Int64;
    car_param_type_name: string;
    car_param_name: string;
    car_param_value: string;
  public
    class constructor Create;
    constructor Create;
    destructor Destroy; override;
    class function startTrans: string; static;
    //
    class function getColumn(const c: char=#9): string; override;
    function getRow(const c: char=#9; const quoted: boolean=false): string; override;
  end;

implementation

uses SysUtils, classes;

{ TCarParam }

class constructor TCarParam.Create;
begin
  FMaxId := 61534231325612500;
end;

constructor TCarParam.Create;
begin
  inherited create;
  car_param_id := IntToStr(getIncMaxId());
  car_param_type_id := 0;
  FTableName := 'ap_car_param_new';
end;

class function TCarParam.getIncMaxId: Int64;
begin
 Inc(FMaxId);
 Result := FMaxId;
end;

destructor TCarParam.Destroy;
begin
end;

class function TCarParam.getColumn(const c: char): string;
begin
  Result :=
    'car_param_id' + c +
    'car_type_id' + c +
    'car_param_type_id' + c +
    'car_param_type_name' + c +
    'car_param_name' + c +
    'car_param_value' + c +
    'sort_no' + c +
    'create_time' + c +
    'modify_time' + c +
    'creator_id' + c +
    'modifier_id';
end;

function TCarParam.getRow(const c: char; const quoted: boolean): string;
begin
  if quoted then begin
     Result :=
      car_param_id + c +
      car_type_id + c +
      IntToStr(car_param_type_id) + c +
      QuotedStr(car_param_type_name) + c +
      QuotedStr(car_param_name) + c +
      QuotedStr(car_param_value) + c +
      sort_no + c +
      QuotedStr(create_time) + c +
      QuotedStr(modify_time) + c +
      creator_id + c +
      modifier_id;
  end else begin
    Result :=
      car_param_id + c +
      car_type_id + c +
      IntToStr(car_param_type_id) + c +
      car_param_type_name + c +
      car_param_name + c +
      car_param_value + c +
      sort_no + c +
      create_time + c +
      modify_time + c +
      creator_id + c +
      modifier_id;
  end;
end;

class function TCarParam.startTrans: string;
var sb: TStringBuilder;
begin
  sb := TStringBuilder.Create;
  try
    sb.Append(TCarData.startTrans());
    sb.AppendLine();
    sb.Append('/**');
    sb.AppendLine();
    sb.Append('update ap_car_param a, ap_car_param_type t ');
    sb.AppendLine();
    sb.Append('set a.car_param_type_id = t.car_param_type_id');
    sb.AppendLine();
    sb.Append('where a.car_param_type_name = t.car_param_type_name');
    sb.AppendLine();
    sb.Append('**/');
    Result := sb.ToString;
  finally
    sb.Free;
  end;
end;

end.

