unit uMyTextFile;

interface

uses Classes;

type
  TMyTextFile = class(TObject)
  private
    procedure SetFileName(const S: string);
  protected
    FFileText: TTextWriter;
    FFileName: string;
    FWriteFile: boolean;
    procedure Rewrite_; overload;
  public
    constructor Create(const fileName: string); overload;
    //constructor Create(const fileName: string; const writeF: boolean); overload;
    destructor Destroy; override;
    procedure WriteLn_(const S: string);
    //procedure WriteLnClose_(const S: string);
    procedure Rewrite_(const bWrite: boolean); overload;
    procedure CloseFile_;
  public
    property WriteFile: boolean read FWriteFile write FWriteFile;
  end;

implementation

uses SysUtils, uFileUtils;

{ TCarFile }

constructor TMyTextFile.Create(const fileName: string);
begin
  SetFileName(fileName);
  FWriteFile := true;
end;

{constructor TMyTextFile.Create(const fileName: string; const writeF: boolean);
begin
  inherited create;
  SetFileName(fileName);
  FWriteFile := writeF;
end;}

destructor TMyTextFile.Destroy;
begin
end;

procedure TMyTextFile.SetFileName(const S: string);
begin
  FFileName := s;
  //if (not FileExists(tmpFName)) then begin
    //AssignFile(FFileText, FFileName);
    //Rewrite(FFileText);
  //end else begin
  //  AssignFile(FFileCarType, tmpFName);
  //  Append(FFileCarType);
  //end;
end;

procedure TMyTextFile.Rewrite_(const bWrite: boolean);
begin
  FWriteFile := bWrite;
  Rewrite_();
end;

procedure TMyTextFile.Rewrite_();
begin
  if FWriteFile then begin
    TFileUtils.forceDirs(FFileName);
    //AssignFile(FFileText, FFileName);
    //Rewrite(FFileText);
    FFileText := TStreamWriter.Create(FFileName, False);
  end;
end;

procedure TMyTextFile.WriteLn_(const S: string);
begin
  if FWriteFile then begin
    //WriteLn(FFileText, s);
    FFileText.WriteLine(S);
  end;
end;

{procedure TMyTextFile.WriteLnClose_(const S: string);
begin
  if FWriteFile then begin
    //WriteLn(FFileText, s);
    //CloseFile(FFileText);
  end;
end;}

procedure TMyTextFile.CloseFile_();
begin
  if FWriteFile then begin
    //CloseFile(FFileText);
    FFileText.Close;
    FFileText.Free;
  end;
end;

end.

