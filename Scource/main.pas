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
  TCUEFile                   = record
    Phad, Filename           : string;
    end;

  {$ifdef Thread}
  { HauptThread }
  // Hier wird nur der Titel abgefragt.
  TBaseThread                = class(TThread)
  public
    procedure Execute;         override;
    procedure ReadTitel;
  end;

  { QR_Thread }
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
  end;
  {$endif}

  { TTrack_ID }

  TTrack_ID                     = class(TForm)
    BCLabel1                 : TBCLabel;
    Button1                  : TButton;
    Image1 : TImage;
    Texte1, Texte2: TLabel;
    PaintBox1                : TPaintBox;
    TrackTime                : TTimer;

    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender : TObject);

    procedure TrackTime_Run(Sender: TObject);

//    procedure RadioGroup1Click(Sender :TObject);


  private
    // Thread Spezische Kombonenten
    ACriticalSection: TRTLCriticalSection;

    // Components

    // Types
//    CUEFile                  : TCUEFile;

    // Var as number
    _2X, _2Y, _i             : Byte;
    ReadTime                 : word;

    // var as bool
    Up, Manuell, Auto_QR     : boolean;

    // var as letter
    MTrackFile               : String;

  public
    s                        : TStringList;
    Screen                   : TScreen;
    DirectoryDialog          : TSelectDirectoryDialog;
    Button                   : {array [1..2] of }TButton;
    RadioGroup               : array [1..2] of TRadioGroup;

    {$ifdef Thread}
    BaseThread               : TBaseThread;
    QRThread                 : TQRThread;
    VLCThread                : TVLCThread
    {$endif}
  end;

//const;

var
  Track_ID                   : TTrack_ID;
  i                          : byte;
  Clear_Text                 : String;

implementation

{$R *.lfm}

{$ifdef Thread}
{ BaseTHread }

Procedure TBaseThread.ReadTitel;
var Temp                     : String;
begin
  EnterCriticalsection(Track_ID.ACriticalSection);
  with Track_ID do begin
    if     Manuell then Temp := MTrackFile;
    if not Manuell then Temp :=  TrackFile;
    if FileExists(Temp) then
      s.LoadFromFile(Temp);
    end;
  Track_ID.Caption              := 'Ich bin nun im BaseThread';;
//  Track_ID.TrackTime.Enabled    := true;
  LeaveCriticalsection(Track_ID.ACriticalSection);
end;

{$endif}

{ TTrack_ID }

{procedure TTrack_ID.RadioGroup1Click(Sender : TObject);
//var Temp                     : String;
begin
  Manuell                    := True;
  Readtime                   := 0;
//  s.Clear;
  case RadioGroup[1].Items[RadioGroup[1].ItemIndex] of
    '-> Lokal (Entwicklung)'      : begin
                                    MTrackFile             := '/home/vamlyktan/mixxx-now-playing';
                                    CueFile.Phad           := '/home/vamlyktan/Musik/Mixxx/Recordings/VamLykTan/20';
                                    end;
    '-> Lokal'                    : begin
                                    MTrackFile             := '/home/vamlyktan/mixxx-now-playing.txt';
                                    CueFile.Phad           := '/home/vamlyktan/Musik/Mixxx/Recordings/VamLykTan/20';
                                    end;
    '-> Netzwerk - DJ'            : begin
                                    MTrackFile             := '/run/user/1000/gvfs/smb-share:server=dj-system.local,share=dj-rechner/Mixxx/NOW-PLAYING/mixxx-now-playing-master/mixxx-now-playing.txt';
                                    CueFile.Phad           := '/run/user/1000/gvfs/smb-share:server=dj-system.local,share=dj-rechner/Musik/Mixxx/Recordings/VamLykTan/20';
                                    end;
    '-> Netzwerk - VJ'            : begin
                                    MTrackFile             := '/run/user/1000/gvfs/smb-share:server=vj-system.local,share=vj-rechner/Mixxx/NOW-PLAYING/mixxx-now-playing-master/mixxx-now-playing.txt';
                                    CueFile.Phad           := '/run/user/1000/gvfs/smb-share:server=vj-system.local,share=vj-rechner/Musik/Mixxx/Recordings/VamLykTan/20';
                                    end;
{    '--> Mix by VamLykTan 2023'   : begin
                                    DirectoryDialog        := TSelectDirectoryDialog.Create(NIL);
//                                    if DirectoryDialog.Execute then
                                       with DirectoryDialog do begin
                                          Filter            := 'Cue-File|*.cue';
                                          InitialDir        := CUEFile.Phad;
                                      Temp                  := InitialDir + IntToStr(23);
                                      end;
///                                    with RadioGroup[2] do begin
//                                      Autofill             := True;
//                                      Autosize             := True;
//                                      Left                 := 20 + RadioGroup[1].Width;
//                                      Caption              := 'Playing Mixe by VamLykTan';
//                                      Items.Add(' -> 100 % Elektro');
//                                      Items.Add(' -> Gothic Rock 01');
//                                      Items.Add(' -> New Year''s Eve Metal 22_23');
//                                      Top                  := Track_ID.Height - Height - 50;
//                                      Parent               := Track_ID;
                                      DirectoryDialog.Free;
//                                      end;
                                    //Track_ID.Caption          := IntToStr(RadioGroup[2].Top) + ' | ' + IntToStr(RadioGroup[2].Left);
                                    end;      }
    end;
//  Track_ID.Caption                                            := temp;
end;            }

procedure TTrack_ID.FormCreate(Sender: TObject);
begin
  Manuell                    := False;
  _2X                        := 0;
  _2Y                        := 0;
  UP                         := True;
  ReadTime                   := 0;

  // Komponenten, welche keine Arrays bedürfen
  s                          := TStringList.Create;

  Screen                     := TScreen.Create(NIL);
  with Track_ID do begin
    Caption                  := 'Track - to - OBS';
    Width                    := 1000;
    Color                    := $0026267B;   // $001C78E9
    if Screen.MonitorCount > 1 then begin
       Left                  := 1354;
       Top                   := 967;
       Font.Name             := '18 Holes BRK';//'28 Days Later';
       end else begin
         Left                := 0;
         Top                 := 622;
         Font.Name           := '18 Holes BRK';//'DamnedDeluxe';
         end;
    end;
  with BCLabel1 do begin
    Align                    := alTop;
    with Background do begin
      Color                  := $0026267B;
      ColorOpacity           := 80;
      with Gradient1 do begin
        EndColor             := clMaroon;
        EndColorOpacity      := 255;
        Point1XPercent       := 50;
        Point1YPercent       := 50;
        Point2XPercent       := 0;
        Point2YPercent       := 0;
        Sinus                := True;
        end;
      end;
    with FontEx do begin
      Color                  := $0000A7FF;
      Name                   := '18 Holes BRK';
      end;
    end;
  with Texte2 do begin
    Alignment                := taCenter;
    Left                     := 500 - (Canvas.TextWidth(Umlaut_Kill('ERROR Enter EXIT - File Not Found')) div 2);
    Top                      := BCLabel1.Top;
    Height                   := 60;
    with font do begin
      Name                   := 'DamnedDeluxe';
      Size                   := -15;
      Color                  := $0000A7FF;
      Name                   := 'DamnedDeluxe';
      end;
    Transparent              := True;
    end;
  with PaintBox1 do begin
    Height                   := 60;
    Left                     := 900;
    Top                      := 19;
    Width                    := 60;
    end;
  _i                         := 0;
  TrackTime.Enabled          := true;
end;

procedure TTrack_ID.FormResize(Sender : TObject);
begin
  // Komponenten, welche als Array genutzut werden könnten.
  Button                     := TButton.Create(NIL);
  for i:= 1 to 2 do
    RadioGroup[i]            := TRadioGroup.Create(NIL);

  with RadioGroup[1] do begin
    AutoFill                 := True;
    AutoSize                 := True;
    Left                     := 8;
//    Height                   := 144;
    Caption                  := ' Mixxx Quelle (VamLykTan Mixe) or Live ';
    Parent                   := Track_ID;
    with ChildSizing do begin
      LeftRightSpacing       := 6;
      EnlargeHorizontal      := crsHomogenousChildResize;
      EnlargeVertical        := crsHomogenousChildResize;
      ShrinkHorizontal       := crsScaleChilds;
      ShrinkVertical         := crsScaleChilds;
      Layout                 := cclLeftToRightThenTopToBottom;
      ControlsPerLine        := 1;
      end;
    with Font do begin
      Color                  := clFuchsia;
      Name                   := '18 Holes BRK';
      end;
    Items.Add('-> Lokal (Entwicklung)');
    Items.Add('-> Lokal');
    Items.Add('-> Netzwerk - DJ');
    Items.Add('-> Netzwerk - VJ');
    Items.Add('--> Mix by VamLykTan');
//    Top                      := Track_ID.Height - Height;
    end;
//  TrackTime.Enabled          := True;
  end;

procedure TTrack_ID.Button1Click(Sender: TObject);
begin
  ReadTime                   := 0;
end;

procedure TTrack_ID.TrackTime_run(Sender: TObject);
begin
  if     Manuell then Mixxx_File       := MTrackFile;
  if not Manuell then begin
    if FileExists(TrackFile[0]) then
      Mixxx_File                       := TrackFile[0];
    if FileExists(TrackFile[1]) then
      Mixxx_File                       := TrackFile[1];
    S.LoadFromFile(Mixxx_File);
    inc(ReadTime);
    Button1.Caption                    := '&Read ' + intToStr(150 - ReadTime);
    if ReadTime = 150 then
      ReadTime                         := 0;
    if S.Capacity <> 0 then begin
      BCLabel1.Visible                 := True;
      Clear_Text                       := '';
      with Texte2 do begin
        Caption                        := Umlaut_Kill(S[0]);
        Left                           := (BCLabel1.Width - Texte2.Width) div 2;
        Top                            := 35;
        Alignment                      := taCenter;
        end;
      BCLabel1.Background.Gradient1.Point1xPercent := _2X;
      if up = True then begin
        if _2X < 100 then
          inc(_2X)
        else Up                        := False;
        end;
      if up = False then begin
        if _2X > 0 then
          dec(_2X)
        else Up                        := True;
        end;
     Caption                           := Clear_Text;
      end;
    end
    else begin
      BCLabel1.Visible                 := False;
      Texte2.Caption                   := Umlaut_Kill('ERROR Enter EXIT - File Not Found');
      end;
  Texte2.Left                          := (BCLabel1.Width - Texte2.Width) div 2;
end;

end.



