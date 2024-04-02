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
  TBaseThread = class(TThread)
  public
    procedure Log(const Msg: string; AppendLineEnd: boolean = true);
  end;

  TBCLabelThread                       = class(TThread)
  public
    WaitForTitle                       : PRtlEvent;
    procedure Execute;                 override;
//    procedure ReadTitel;
  end;

  TTitelThread                         = class(TThread)
  public
    procedure Execute;                 override;
  end;

  {$endif}

  { TTrack_ID }

  TTrack_ID                            = class(TForm)
    BcLabel1                           : TBcLabel;
    Texte1, Texte2                     : TLabel;
    BCTimer: TTimer;
    TrackTime                          : TTimer;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure BcTimer_Run(sender :tobject);
    procedure TrackTime_Run(Sender: TObject);

  private
    // Components
    ACriticalSection: TRTLCriticalSection;

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
    MsgText                            : string;


    // Testfunctions
    procedure AddMessage;
  public
    s                                  : TStringList;

    Screen                             : TScreen;

    {$ifdef Thread}
    // Threads
    BaseThread                         : TBaseThread;
    BCLabelThread                      : TBCLabelThread;
    TitleThread                        : TTitelThread;
    {$endif}
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

  {$ifndef Thread}
  TrackTime.Enabled                    := true;
  {$else}
  InitCriticalSection(ACriticalSection);
  if BCLabelThread = nil then
    BCLabelThread                                := TBCLabelThread.Create(False);
  {$endif}
end;

procedure TTrack_ID.FormDestroy(Sender: TObject);
begin
  DoneCriticalsection(ACriticalSection);
end;

procedure TTrack_ID.AddMessage;
begin
  Caption                                        := MsgText;
end;

procedure TTrack_ID.BcTimer_Run(sender :tobject);
begin
  BCLabel1.Background.Gradient1.Point1xPercent := _2X;
  if up = False then
     if _2X > 0 then
       dec(_2X)
     else Up                        := True;
  if up = False then
     if _2X > 0 then
        dec(_2X)
     else Up                        := True;
end;

procedure TTrack_ID.TrackTime_run(Sender: TObject);
begin
  {$ifndef Thread}
  if     Manuell then
     Mixxx_File                         := MTrackFile;
  if not Manuell then begin
    if FileExists(TrackFile[0]) then
      Mixxx_File                       := TrackFile[0];
    if FileExists(TrackFile[1]) then
      Mixxx_File                       := TrackFile[1];
    if FileExists(TrackFile[2]) then
      Mixxx_File                       := TrackFile[2];
    S.LoadFromFile(Mixxx_File);
//    Track_ID.Caption                   := 'S.LoadFromFile(Mixxx_File)';
    try
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
      if S[0] = 'DJ VAMLYKTAN - ROCTRONICS @ SUNDAY           ' then
        if NOT Cue_Load then begin
          TrackList.LoadCUE_Data('/run/user/1000/gvfs/smb-share:server=dj-rechner.local,share=musik/Mixxx/Recordings/VamLykTan/Mixe 2023/Live-Mix/Roctronics @ Sunday.cue');
          Track_List                           := True;
          end;
      if S[0] = 'VAMLYKTAN - SPAIN-LATEIN OF METAL & ELECTRO           ' then
        if NOT Cue_Load then begin
          TrackList.LoadCUE_Data('/run/user/1000/gvfs/smb-share:server=dj-rechner.local,share=musik/Mixxx/Recordings/VamLykTan/Mixe 2022/Spain-Latein of Metal & Electro.cue');
          Track_List                           := True;
          end;
        if S.Capacity <> 0 then begin
        BCLabel1.Visible               := True;
        Track_ID.Caption                   := 'BCLabel1.Visible:=True;';
{          if Cue_Load then begin
        inc(zzz);
        if zzz = 100 then begin
          zzz                        := 0;
          inc(ss);
          end;
        if ss = 60 then begin
          ss                       := 0;
          inc(mm);
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
          Texte2.Caption                     := TrackList.Cue.Artist[Index] + #10#13 + TrackList.Cue.Song[index];
          Track_ID.Caption                   := _mm + ':' + _ss + ':' + _zzz;
          inc(index);
          end;
        end
        else    }
          Texte2.Caption                     := Umlaut_Kill(temp);
          Track_ID.Caption                   := 'Umlaut_Kill(temp)';
      Texte2.Left                            := (BCLabel1.Width - Texte2.Width) div 2;
      Track_ID.Caption                       := '(BCLabel1.Width - Texte2.Width) div 2';
      Texte2.Top                             := (BCLabel1.Top + Texte2.Height) div 2;
      Track_ID.Caption                       := '(BCLabel1.Top + Texte2.Height) div 2';
      Texte2.Alignment                       := taCenter;
      Track_ID.Caption                       := 'taCenter';
      end
      else begin
        BCLabel1.Visible               := False;
        Texte2.Caption                 := Umlaut_Kill('ERROR Enter EXIT - File Not Found');
        end;
      Finally
      end;
    end;
  {$endif}
end;

{$ifdef Thread}
{ TBCLabelThread }
Procedure TBCLabelThread.Execute;
begin
  Track_ID.TitleThread                           := TTitelThread.Create(False);
  // Create Event
  WaitForTitle                                   := RTLEventCreate;
  while not Application.Terminated do begin
    RtlEventWaitFor(WaitForTitle);
    Track_ID.Caption                             := 'BCLabel wartet, bis Track_ID ausgefüht wurde';
//    Track_ID.BCTimer.Enabled                     := True;
//    Track_ID.TrackTimer.Enabled                  := True;
    end;
end;

{ TTitelThread }

procedure TTitelThread.Execute;
begin
  while not Application.Terminated do begin
    with Track_ID do begin
      Caption                              := 'Track_ID wird ausgeführt';
      if     Manuell then
         Mixxx_File                         := MTrackFile;
      if not Manuell then begin
        if FileExists(TrackFile[0]) then
          Mixxx_File                       := TrackFile[0];
        if FileExists(TrackFile[1]) then
          Mixxx_File                       := TrackFile[1];
        if FileExists(TrackFile[2]) then
          Mixxx_File                       := TrackFile[2];
        S.LoadFromFile(Mixxx_File);
        Track_ID.Caption                   := 'S.LoadFromFile(Mixxx_File)';
        if S[0] <> temp then begin
          Track_ID.Caption                       := 'if S[0] <> temp then begin';
          Cue_Load                               := False;
          Track_ID.Caption                       := 'Cue_Load:= False;';
          temp                                   := S[0];
          Track_ID.Caption                       := 'temp:= S[0];';
          end;
        Track_ID.Caption                   := '320';
  {      if Not Track_List then begin
          zzz                                    := 0;
          ss                                     := 0;
          mm                                     := 0;
          Index                                  := 0;
          Track_List                             := True;
          end;
        if S[0] = 'DJ VAMLYKTAN - ROCTRONICS @ SUNDAY           ' then
          if NOT Cue_Load then begin
            TrackList.LoadCUE_Data('/run/user/1000/gvfs/smb-share:server=dj-rechner.local,share=musik/Mixxx/Recordings/VamLykTan/Mixe 2023/Live-Mix/Roctronics @ Sunday.cue');
            Track_List                           := True;
            end;
        if S[0] = 'VAMLYKTAN - SPAIN-LATEIN OF METAL & ELECTRO           ' then
          if NOT Cue_Load then begin
            TrackList.LoadCUE_Data('/run/user/1000/gvfs/smb-share:server=dj-rechner.local,share=musik/Mixxx/Recordings/VamLykTan/Mixe 2022/Spain-Latein of Metal & Electro.cue');
            Track_List                           := True;
            end;     }
        if S.Count <> 0 then begin
          Track_ID.Caption                   := 'if S.Count <> 0 then begin';
          BCLabel1.Visible               := True;
          Track_ID.Caption                   := 'BCLabel1.Visible:=True;';
{          if Cue_Load then begin
            inc(zzz);
            if zzz = 100 then begin
              zzz                        := 0;
              inc(ss);
              end;
            if ss = 60 then begin
              ss                       := 0;
              inc(mm);
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
              Texte2.Caption                     := TrackList.Cue.Artist[Index] + #10#13 + TrackList.Cue.Song[index];
              Track_ID.Caption                   := _mm + ':' + _ss + ':' + _zzz;
              inc(index);
              end;
            end
            else    }
              Texte2.Caption                     := Umlaut_Kill(temp);
              Track_ID.Caption                   := '383';
          Texte2.Left                            := (BCLabel1.Width - Texte2.Width) div 2;
          Track_ID.Caption                       := '385';
          Texte2.Top                             := (BCLabel1.Top + Texte2.Height) div 2;
          Track_ID.Caption                       := '387';
          Texte2.Alignment                       := taCenter;
          Track_ID.Caption                       := '389';
          end
          else begin
            BCLabel1.Visible               := False;
            Texte2.Caption                 := Umlaut_Kill('ERROR Enter EXIT - File Not Found');
            end;
        end;
      end;
    RtlEventSetEvent(Track_ID.BCLabelThread.WaitForTitle);
    end;
end;

{ TBaseThread }

procedure TBaseThread.Log(const Msg: string; AppendLineEnd: boolean);
var
  s: String;
begin
  EnterCriticalsection(Track_ID.ACriticalSection);
  s:=Msg;
  if AppendLineEnd then
    s:=s+LineEnding;
  dbgout(s);
  Track_ID.MsgText:=Track_ID.MsgText+s;
  Synchronize(@Track_ID.AddMessage);
  LeaveCriticalsection(Track_ID.ACriticalSection);
end;
{$endif}
end.
