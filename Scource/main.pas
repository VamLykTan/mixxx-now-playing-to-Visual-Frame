unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,

  {User - Units}
  ufunction;

type

  { TForm1 }

  TForm1 = class(TForm)
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

    s                        : TStringList;
  public

  end;

const
  {$if defined (VamLykTan_VeeJee)}
  TrackFile                  = '/home/vamlyktan/mixxx-now-playing.txt';
  {$elseif defined (VamLykTan_Prog)}
  TrackFile                  = 'mixxx-now-playing.txt';
  {$endif}


var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  s                          := TStringList.Create;
  with Form1 do begin
    Caption                  := 'Track - to - OBS';
    Width                    := 650;
    Color                    := $0026267B;
//    if Screen.MonitorCount > 1 then begin;
       Left                  := 1354;
       Top                   := 967;
       Font.Name             := '28 Days Later';
//       end else begin
//         Left                := 0;
//         Top                 := 622;
//         Font.Name           := 'DamnedDeluxe';
//         end;
  end;
  with Label1 do begin
    Alignment                := taCenter;
    Left                     := 10;
    Top                      := 10;
    Height                   := 25;
    with font do begin
//      Name                   := 'DamnedDeluxe';
      Size                   := -15;
      Color                  := $0000A7FF;
      Name                   := 'DamnedDeluxe';
      end;
    Transparent              := True;
    end;
  Timer1.Enabled             := true;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
  var i, i2: byte;
    temp, Temp2: string;
  begin
    s.LoadFromFile(GetUserDir + TrackFile);
    if S.Capacity <> 0 then
       Label1.Caption          := Umlaut_Kill(S[0]);
end;

end.



