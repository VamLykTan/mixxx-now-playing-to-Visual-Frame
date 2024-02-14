unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  {$ifdef Thread} LCLProc, {$endif}
  Menus, BCLabel, BGRABitmap, BGRABitmapTypes,
  { User - Units }
  uconst, ufunction, uvar, set_data;

type
  TCUEFile                             = record
    Phad, Filename                     : string;
    end;

  {$ifdef Thread}
  { HauptThread }
  // Hier wird nur der Titel abgefragt.
  TBaseThread                          = class(TThread)
  public
    WaitForTitel                       : PRtlEvent;
    procedure Execute;                 override;
//    procedure ReadTitel;
  end;

  TTitelThread                         = class(TThread)
  public
    procedure Execute;                 override;
  end;

 { { QR_Thread
  // Hier werden alle QRs gesteuert
  TQRThread                  = class(TThread)
  public
    Wait4Video               : PRtlEvent;
//    procedure Execute;       override;
  end;

  { VLC_Thread }
  // Wenn Track-ID passt und entsprechende Videos auf dem OBS-Rechner vorhanden sind
  // übernimmt dieser Thread seine Arbeit, Andernfalls bleibt er Inaktiv
  TVLCThread                = class(TThread)
  public
//    procedure VLCLoad(Vod: String);
//    procedure VLCPlay(Sender: TObject);
//    procedure Execute;       override;
  end;         }}
  {$endif}

  { TTrack_ID }

  TTrack_ID                            = class(TForm)
    BcLabel1                           : TBcLabel;
    Texte1, Texte2                     : TLabel;
    TrackTime                          : TTimer;

    procedure FormCreate(Sender: TObject);

    procedure BcTimer_Run(sender :tobject);
    procedure TrackTime_Run(Sender: TObject);

  private
    // Components

    // Types
    TrackList                          : TTrack;
    Cue_Load                           : boolean;

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

    // Threads
    BaseThread                         : TBaseThread;
    TitleThread                        : TTitelThread;
  end;

var
  Track_ID                             : TTrack_ID;
  i                                    : byte;

implementation

{$R *.lfm}

{ TTrack_ID }

procedure TTrack_ID.FormCreate(Sender: TObject);
begin
  Manuell                              := False;
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
  with Texte2 do begin
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

procedure TTrack_ID.BcTimer_Run(sender :tobject);
begin
  BCLabel1.Background.Gradient1.Point1xPercent := _2X;
  if up = True then begin
    if _2X < 100 then
      inc(_2X)
    else Up                  := False;
    end;
    if up = False then begin
      if _2X > 0 then
        dec(_2X)
      else Up              := True;
      end;
end;

procedure TTrack_ID.TrackTime_run(Sender: TObject);
begin
//  ii
end;

{ TTitelThread }

procedure TTitelThread.Execute;
begin
  with Track_ID do begin
    if     Manuell then
       Mixxx_File                         := MTrackFile;
    if not Manuell then begin
      if FileExists(TrackFile[0]) then
        Mixxx_File                       := TrackFile[0];
      if FileExists(TrackFile[1]) then
        Mixxx_File                       := TrackFile[1];
      S.LoadFromFile(Mixxx_File);
      if S[0] <> temp then begin
        Cue_Load                         := False;
        temp                             := S[0];
        end;
      if S[0] = 'DJ VAMLYKTAN - ROCTRONICS @ SUNDAY           ' then
        if NOT Cue_Load then begin
        TrackList.LoadCUE_Data('/run/user/1000/gvfs/smb-share:server=dj-rechner.local,share=musik/Mixxx/Recordings/VamLykTan/Mixe 2023/Live-Mix/Roctronics @ Sunday.cue');
        Cue_Load                       := True;
        zzz                            := 0;
        ss                             := 0;
        mm                             := 0;
        Index                          := 0;
        end;
      if S.Capacity <> 0 then begin
        BCLabel1.Visible               := True;
        with Texte2 do begin
          if Cue_Load then begin
            inc(zzz);
            if zzz = 100 then begin
              zzz                        := 0;
              inc(ss);
              if ss = 60 then begin
                ss                       := 0;
                inc(mm);
                end;
              end;
            case zzz of
              0..9: begin
                    _zzz                 := '0' + IntToStr(zzz);
                    end;
              10..99: begin
                      _zzz               := IntToStr(zzz);
                      end;
              end;
            case ss of
              0..9: begin
                    _ss                  := '0' + IntToStr(ss);
                    end;
              10..59: begin
                      _ss                := IntToStr(ss);
                      end;
              end;
            case mm of
              0..9: begin
                    _mm                  := '0' + IntToStr(mm);
                    end;
              else _mm                   := IntToStr(mm);
              end;
  //          Track_ID.Caption             := _mm + ':' + _ss + ':' + _zzz;
            if TrackList.Cue.Time[index] = _mm + ':' + _ss + ':' + _zzz then begin
            Caption          := TrackList.Cue.Artist[Index] + #10#13 + TrackList.Cue.Song[index];
            Track_ID.Caption := _mm + ':' + _ss + ':' + _zzz;
            inc(index);
            end;
            end else Caption             := Umlaut_Kill(S[0]);
          Left                           := (BCLabel1.Width - Texte2.Width) div 2;
          Top                            := (BCLabel1.Top + Texte2.Height) div 2;
          Alignment                      := taCenter;
          end;
        end
        else begin
          BCLabel1.Visible               := False;
          Texte2.Caption                 := Umlaut_Kill('ERROR Enter EXIT - File Not Found');
        end;
      end;
    end;
end;

{ TBaseThread }

procedure TBaseThread.Execute;
begin
  Track_ID.TitleThread                 := TTitelThread.Create(false);
  // Create Event
  WaitForTitel                         := RTLEventCreate;
  while not Application.Terminated do begin
    RtlEventWaitFor(WaitForTitel);
    Track_ID.TrackTime.Enabled         := True;
    end;
end;

end.
