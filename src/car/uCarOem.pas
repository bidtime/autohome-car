unit uCarOem;

interface

uses uCarData;

type
  TCarOem = class(TCarData)
  private
    //FAutoPK: boolean;
    class var FMaxId: Int64;
  public
    car_oem_id: string;
    car_brand_id: string;
    car_brand_name: string;
    car_oem_name: string;
    description: string;
  public
    class constructor Create;
    constructor Create; overload;
    constructor Create(const autoPK: boolean); overload;
    destructor Destroy; override;
    //
    procedure setRawId(const S: string); override;
    class function getColumn(const c: char=#9): string; override;
    function getRow(const c: char=#9; const quoted: boolean=false): string; override;
    //property AutoPK: boolean read FAutoPK write FAutoPK;
  end;

implementation

uses SysUtils;

{ TCarOem }

class constructor TCarOem.Create;
begin
  FMaxId := 67686114558779000;
end;

constructor TCarOem.Create;
begin
  self.Create(false);
end;

constructor TCarOem.Create(const autoPK: boolean);
begin
  inherited create;
  if autoPK then begin
    Inc(FMaxId);
  end;
  //
  description := '';
  FTableName := 'ap_car_oem_new';
end;

destructor TCarOem.Destroy;
begin
end;

class function TCarOem.getColumn(const c: char): string;
begin
  Result :=
    'car_oem_id' + c +
    'car_brand_id' + c +
    'car_brand_name' + c +
    'car_oem_name' + c +
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

function TCarOem.getRow(const c: char; const quoted: boolean): string;
begin
  if quoted then begin
    Result :=
      car_oem_id + c +
      car_brand_id + c +
      QuotedStr(car_brand_name) + c +
      QuotedStr(car_oem_name) + c +
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
      car_oem_id + c +
      car_brand_id + c +
      car_brand_name + c +
      car_oem_name + c +
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

procedure TCarOem.setRawId(const S: string);
begin
  raw_id := s;
  self.car_oem_id := IntToStr(FMaxId+ StrToInt(s));
end;

end.

