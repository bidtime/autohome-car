unit uCarOemParser;

interface

uses SysUtils, classes, Generics.Collections, uCarBrand, uCarSys,
  uCarParserBase, uCommEvents;//, uNetHttpClt;

type
  TCarOemParser = class(TCarParserBase)
  private
  protected
    FDicNewFactory: TDictionary<String, String>;
  public
    constructor Create();
    destructor Destroy; override;
    procedure parerToList(const carBrand: TCarBrand; var carSys: TCarSys);
  end;

implementation

uses System.json, uCharSplit, uMyTextFile;

{ TCarOemParser }

constructor TCarOemParser.Create();
begin
  inherited create();
  FFileName := 'car-oem-all.txt';
  FDicNewFactory := TDictionary<String, String>.create();
end;

destructor TCarOemParser.Destroy;
begin
  FDicNewFactory.Free;
end;

procedure TCarOemParser.parerToList(const carBrand: TCarBrand;
  var carSys: TCarSys);
begin

end;

end.

