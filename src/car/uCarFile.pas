unit uCarFile;

interface

uses
  uCarBase;

type
  TCarFile = class(TObject)
  private
    procedure SetFileName(const S: string);
  protected
    FFileText: Text;
    FFileName: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure CloseFile;
    procedure WriteLn(const S: string);
  public
    property FileName: string read FFileName write SetFileName;
  end;

implementation

uses SysUtils, classes;

{ TCarFile }

constructor TCarFile.Create;
begin
end;

destructor TCarFile.Destroy;
begin

end;

procedure TCarFile.SetFileName(const S: string);
begin
  FFileName := s;
  //FFileName := s + '\' + 'cartype-all.txt';
  //if (not FileExists(tmpFName)) then begin
    AssignFile(FFileText, FFileName);
    Rewrite(FFileText);
    // WriteLn(FFileCarType, TCarType.getColumn());
    //WriteLn(FFileText, self.getBegin());
end;

procedure TCarFile.WriteLn(const S: string);
begin
  WriteLn(FFileText, s);
end;

procedure TCarFile.CloseFile();
begin
  CloseFile(FFileText);
end;

end.

