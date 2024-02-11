program QR;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, sysutils, // this includes the LCL widgetset
  Forms, _qr, QR4OBS, _genre,
  { you can add units after this }
  // API-Units
  uconst, uvar;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  application.scaled:=true;
  Application.Initialize;
  Application.CreateForm(TGenre, Genre);
  Application.CreateForm(TQR_Frame, QR_Frame);
  Application.CreateForm(TQR4OBSFrame, QR4OBSFrame);
  if FileExists(TrackFile[0]) then begin
    Mixxx_File                         := TrackFile[0];
    ID_found                           := True;
    end else begin
      if FileExists(TrackFile[1]) then begin
        Mixxx_File                     := TrackFile[1];
        ID_found                       := True;
        end else begin
          if FileExists(TrackFile[2]) then begin
            Mixxx_File                 := TrackFile[2];
            ID_found                   := True;
            end;
          end;
        end;
Application.Run;
end.

