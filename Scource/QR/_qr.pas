unit _qr;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Menus,
  ubarcodes,

  // User_Forms
  QR4OBS,

  //user units
  uConst, uVar, set_data;

type

  { TQR_Frame }

  TQR_Frame                                      = class(TForm)
    procedure FormClose(Sender : TObject; var CloseAction : TCloseAction);
    procedure FormCreate(Sender : TObject);
    procedure formresize(sender :tobject);
  private
    // Alles Objecte, welche sich direkt auf den das QR_Modul beziehen
    QR_Braek                                     : boolean;
    QR_Time                                      : int64;

    QR                                           : TBarcodeQR;
    QR_Name                                      : TLabel;

    QR_Data                                      : TQR4OBSFrame;

    Stream                                       : TTaskDialog;

    procedure QR_Timer_Run(Sender: TObject);

  {$ifdef QR_Prog}
    procedure QR_Edit(Sender: TObject);
  {$endif}
  public
    QR_Timer                                     : TTimer;
    QR_Text                                      : TStringList;
    QR_Load                                      : TQR;
    QR_List                                      : TVeeJee_QR4OBS;

    Rock, Electro                                : boolean;
  end;

var
  QR_Frame                                       : TQR_Frame;
  i                                              : word = 0;
  QR_Break                                       : Boolean = False;

implementation

{$R *.lfm}


{ TQR_Frame }

{$ifdef QR_Prog}
Procedure TQR_Frame.QR_Edit(Sender: TObject);
begin
  QR4OBSFrame.show;
//                                Local Test
//  Caption                         := IDE_Load('/usr/bin/', 'nautilus', ['/home/vamlyktan/Entwicklung', '/home/vamlyktan/Musik', '/home/vamlyktan/.config'], []);
//                                Network Test
end;
{$endif}

procedure TQR_Frame.FormResize(Sender : TObject);
begin
  Caption                                        := IntToStr(Height) + ' | ' + IntToStr(Width);
end;

procedure TQR_Frame.FormCreate(Sender : TObject);
begin
  Color                                          := clBlack;   // $001C78E9
  Height                                         := 75;
  Width                                          := 520;

  QR_Text                                        := TStringList.Create;
  QR_List                                        := TVeeJee_QR4OBS.Create;
  QR_Load                                        := QR_List.QR_Data;

  QR                                             := TBarcodeQR.Create(NIL);
  QR_Data                                        := TQR4OBSFrame.Create(NIL);
  QR_Name                                        := TLabel.Create(NIL);
  QR_Timer                                       := TTimer.Create(NIL);

  // QR_Code
  with QR do begin
    BackgroundColor                              := clWhite;
    Cursor                                       := crNo;
    ECCLevel                                     := eBarcodeQR_ECCLevel_H;
    ForegroundColor                              := clBlack;
    Height                                       := 75;
    Left                                         := 0;
    StrictSize                                   := False;
    Text                                         := 'https://www.paypal.com/donate/?hosted_button_id=JWHXZ5MATXQY6';
    Top                                          := 0;
    Width                                        := 75;
    Parent                                       := QR_Frame;
    {$ifdef QR_Prog}
    OnClick                                      := @QR_Edit;
    {$endif}
    end;

  // Label zur Benennung des QR
  with QR_Name do begin
    Color                                        := clFuchsia;
    with Font do begin
      Height                                     := -14;
      Name                                       := 'DamnedDeluxe';
      Size                                       := 10;
      end;
    Height                                       := 20;
    Left                                         := 140;
    Parent                                       := QR_Frame;
    Transparent                                  := False;
    Top                                          := (QR.Height - Height) div 2;
    end;

  // Timer für den QR
  with QR_Timer do begin
    Enabled                                      := true;
    Interval                                     := 10;
    OnTimer                                      := @QR_Timer_Run;
    end;
  I                                              := 0;
end;

procedure TQR_Frame.FormClose(Sender : TObject; var CloseAction : TCloseAction);
begin
  QR.Free;
  QR_Data.Free;
  QR_List.Free;
  QR_Name.Free;
  QR_Text.Free;
  QR_Timer.Free;
  Application.Terminate;
end;

procedure TQR_Frame.QR_Timer_Run(Sender: TObject);
begin
  if ID_found then begin
//    Caption     := MiXXX_File;
    QR_Text.LoadFromFile(MIXXX_File);
    if QR_Text.Capacity <> 0 then begin
      if QR_Text[0] = 'OST+FRONT - HONKA HONKA           ' then begin
        QR_Break                                 := True;
        QR.Text                                  := TT4OBS_Video.Text[0];
        QR_Name.Caption                          := ' -> ' + TT4OBS_Video.Name[0] + ' ';
        QR_Time                                  := 0;
        end
        else if QR_Text[0] = 'OOMPH! - AUGEN AUF           ' then begin
          QR_Break                               := True;
          QR.Text                                := TT4OBS_Video.Text[1];
          QR_Name.Caption                        := ' -> ' + TT4OBS_Video.Name[1] + ' ';
          QR_Time                                := 0;
          end
          else if QR_Text[0] = 'BEL EPOQ - RAIN IN JULY           ' then begin
            QR_Break                             := True;
            QR.Text                              := TT4OBS_Video.Text[2];
            QR_Name.Caption                      := ' -> ' + TT4OBS_Video.Name[2] + ' ';
            QR_Time                              := 0;
            end
            else if QR_Text[0] = 'HELDMASCHINE - R           ' then begin
              QR_Break                           := True;
              QR.Text                            := TT4OBS_Video.Text[3];
              QR_Name.Caption                    := ' -> ' + TT4OBS_Video.Name[3] + ' ';
              QR_Time                            := 0;
              end
              else if QR_Text[0] = 'SOKO FRIEDHOF - TOTENGRÄBER           ' then begin
                QR_Break                         := True;
                QR.Text                          := TT4OBS_Video.Text[4];
                QR_Name.Caption                  := ' -> ' + TT4OBS_Video.Name[4] + ' ';
                QR_Time                          := 0;
                end
                else if QR_Text[0] = 'FRONTANGEL - UND WIR TANZEN           ' then begin
                  QR_Break                       := True;
                  QR.Text                        := TT4OBS_Video.Text[5];
                  QR_Name.Caption                := ' -> ' + TT4OBS_Video.Name[5] + ' ';
                  QR_Time                        := 0;
                  end
                  else QR_Break                  := false;
      end;
    end;
  if not QR_Break then begin
    if QR_Time = 0 then begin
      {$ifdef Test}
      QR_Time                                    := 50;
      {$else}
      QR_Time                                    := 500;
      {$endif}
      if i = QR_Load.last then
        I                                        := 0;
      if (QR_Load.Genre[i][0] and Rock) then begin
        QR.Text                                  := QR_Load.Link[i];
        QR_Name.Caption                          := QR_Load.Name[i];
        end;
      if (QR_Load.Genre[i][1] and Electro) then begin
        QR.Text                                  := QR_Load.Link[i];
        QR_Name.Caption                          := QR_Load.Name[i];
        end;
      inc(i);
      end;
    {$ifdef Cap}
    Caption      := IntToStr(QR_Time) + ' | ' + IntToStr(I);
    {$endif}
    dec(QR_Time);
    end;
end;

end.
