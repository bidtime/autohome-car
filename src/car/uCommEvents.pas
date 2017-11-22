unit uCommEvents;

interface

uses uCarBrand, uCarSys, uCarType;

type
  TBooleanFunc = function(): boolean of object;
  TGetBrandProc = function(const brand: TCarBrand):boolean of object;
  {TGetBrandOemProc = function(const brand: TCarBrand;
    const carOem: TCarOem):boolean of object;}
  TGetBrandSysProc = function(const brand: TCarBrand;
    var carSys: TCarSys):boolean of object;
  TGetBrandSysTypeProc = function(const brand: TCarBrand;
    const carSys: TCarSys; var carType: TCarType):boolean of object;

implementation

end.

