unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Menus, BCLabel, BGRABitmap, BGRABitmapTypes,
  { User - Units }
  uconst, ufunction, uvar, set_data;

type
  TCUEFile                             = record
    Phad, Filename                     : string;
    end;

  { TTrack_ID }

  TTrack_ID                            = class(TForm)
    BCLabel1                           : TBcLabel;
    Blind_Frame, Track_Frame: TLabel;
    TrackTime                          : TTimer;

    procedure FormCreate(Sender: TObject);
    procedure TrackTime_Run(Sender: TObject);

  private
    // Types
    TrackList                          : TTrack;
    Cue_Load, Track_List               : boolean;

    // Var as number
    _2X, _2Y, _i, mm, ss, zzz          : word;
    Index                              : byte;

    // var as bool
    Up, Manuell                        : boolean;

    // var as letter
    MTrackFile, temp, _mm, _ss, _zzz   : String;
  public
    s                                  : TStringList;

    Screen                             : TScreen;

  end;

var
  Track_ID                         : TTrack_ID;
  i                                    : byte;

implementation

{$R *.lfm}

{ TTrack_ID }

procedure TTrack_ID.FormCreate(Sender: TObject);
begin
  Manuell                              := False;
//  Manuell                              := true;
  _2X                                  := 0;
  _2Y                                  := 0;
  UP                                   := True;

  // Komponenten, welche keine Arrays bedürfen
  s                                    := TStringList.Create;
  TrackList                            := TTrack.Create;

  Screen                               := TScreen.Create(NIL);
  with Track_ID do begin
    Caption                            := 'Track - to - OBS';
    Width                              := 1000;
//    Color                              := $0026267B;   // $001C78E9
    Color                              := clBlack;   // $001C78E9
    if Screen.MonitorCount > 1 then begin
       Left                            := 1354;
       Top                             := 967;
       Font.Name                       := '18 Holes BRK';//'28 Days Later';
       end else begin
         Left                          := 0;
         Top                           := 622;
         Font.Name                     := '18 Holes BRK';//'DamnedDeluxe';
         end;
    end;
  with BCLabel1 do begin
    Align                              := alTop;
    Height                             := 40;
    with Background do begin
      Color                            := $0026267B;
      ColorOpacity                     := 80;
      with Gradient1 do begin
        EndColor                       := clMaroon;
        EndColorOpacity                := 255;
        Point1XPercent                 := 50;
        Point1YPercent                 := 50;
        Point2XPercent                 := 0;
        Point2YPercent                 := 0;
        Sinus                          := True;
        end;
      end;
    with FontEx do begin
      Color                            := $0000A7FF;
      Name                             := '18 Holes BRK';
      end;
    end;
  with Track_Frame do begin
    Alignment                          := taCenter;
    Left                               := 500 - (Canvas.TextWidth(Umlaut_Kill('ERROR Enter EXIT - File Not Found')) div 2);
//    Top                                := BCLabel1.Top;
    Height                             := 40;
    with font do begin
      Name                             := 'DamnedDeluxe';
      Size                             := -12;
      Color                            := $0000A7FF;
      Name                             := 'DamnedDeluxe';
      end;
    Transparent                        := True;
    end;
  _i                                   := 0;

  TrackTime.Enabled                    := true;
end;

procedure TTrack_ID.TrackTime_run(Sender: TObject);
begin
  if     Manuell then Mixxx_File       := MTrackFile;
  if not Manuell then begin
    if FileExists(TrackFile) then
      Mixxx_File                       := TrackFile;
    if FileExists(TrackFile[0]) then
      Mixxx_File                       := TrackFile[0];
    if FileExists(TrackFile[1]) then
      Mixxx_File                       := TrackFile[1];
    if FileExists(TrackFile[2]) then
      Mixxx_File                       := TrackFile[2];
    try
      S.LoadFromFile(Mixxx_File);
      if S[0] <> temp then begin
        Cue_Load                               := False;
        temp                                   := S[0];
        end;
      if Not Track_List then begin
        zzz                                    := 0;
        ss                                     := 0;
        mm                                     := 0;
        Index                                  := 0;
        Track_List                             := True;
        end;
      if S.Capacity <> 0 then begin
        BCLabel1.Visible               := True;
        Track_Frame.Caption            := Umlaut_Kill(temp);
        Track_Frame.Left               := (BCLabel1.Width - Track_Frame.Width) div 2;
        Track_Frame.Top                := (BCLabel1.Top + Track_Frame.Height) div 2;
        Track_Frame.Alignment          := taCenter;
        end
        else begin
          BCLabel1.Visible             := False;
          Track_Frame.Caption          := Umlaut_Kill('ERROR Enter EXIT - File Not Found');
          end;
      finally
      end;
    end;
  BCLabel1.Background.Gradient1.Point1xPercent := _2X;
  if up = False then
    if _2X > 0 then
      dec(_2X)
    else Up                            := True;
  if up = False then
    if _2X > 0 then
      dec(_2X)
    else Up                            := True;
end;

end.
