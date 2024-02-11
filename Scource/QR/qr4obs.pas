unit QR4OBS;

{$mode ObjFPC}{$H+}

interface

uses
  { Units welche Komponenten enthalten}
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Menus, ubarcodes, iniFiles,
  { Units welche gesammelte Constanten und Variablen enthalten}
  uconst,
  { Units welche Selbstgeschriebene classen enthalten}
  set_data;

type

  { TQR4OBSFrame }

  TQR4OBSFrame = class(TForm)

    Procedure FormCreate(Sender : TObject);
    Procedure FormKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
    procedure FormResize(Sender : TObject);
    procedure FormShow(Sender : TObject);

    Procedure QR_DataOnChange(Sender: TObject);
    Procedure QR_GenreOnChange(Sender: TObject);

    Procedure SaveOnClick(Sender: TObject);
    Procedure BackOnClick(Sender: TObject);
    Procedure NextOnClick(Sender: TObject);
    Procedure DelOnClick(Sender: TObject);
    Procedure ExitOnClick(Sender: TObject);
  private
    QR                                 : TBarcodeQR;

    Button                             : Array [0..5] of TButton;
    QR_Genre                           : Array [0..3] of TCheckBox;
    QR_Data                            : Array [0..1] of TLabeledEdit;

    procedure Load(Value: word);

  public
    _QR4OBS                            : TVeeJee_QR4OBS;
    QR4                                : TQR;
    
    QR_index, Last_QR                  : Word;

    QR_UpDated                         : boolean;

  end;

var
  QR4OBSFrame                          : TQR4OBSFrame;

  i                                    : byte;

implementation

uses
  _qr;

{$R *.lfm}

{ TQR4OBSFrame }

procedure TQR4OBSFrame.Load(Value: word);
begin
  QR_Data[0].Text                      := QR4.Link[Value];
  QR_Data[1].Text                      := QR4.Name[Value];
  QR_Genre[0].Checked                  := QR4.Genre[Value][0];
  QR_Genre[1].Checked                  := QR4.Genre[Value][1];
  QR_Genre[2].Checked                  := QR4.Genre[Value][2];
  QR.Text                              := QR4.Link[Value];
  Caption                              := IntToStr(Value);
  if QR_Index = 0 then begin
    Button[2].Enabled                  := False;
    end else Button[2].Enabled         := True;
end;

procedure TQR4OBSFrame.FormCreate(Sender : TObject);
begin
  _QR4OBS                              := TVeeJee_QR4OBS.Create;
  QR                                   := TBarcodeQR.Create(NIL);
  QR_index                             := 0;

  Height                               := 175;
  KeyPreview                           := True;
  Width                                := 640;
  Caption                              := 'QR Daten';

  QR_UpDated                           := False;

  for i:= 0 to 5 do begin
    Button[i]                          := TButton.Create(NIL);
    Button[i].Height                   := 30;
    Button[i].Top                      := 136;
    Button[i].ShowHint                 := True;
    Button[i].Width                    := 75;
    Button[i].Parent                   := QR4OBSFrame;
    end;

  for i := 0 to 2 do begin
    QR_Genre[i]                        := TCheckBox.Create(NIL);
    QR_Genre[i].AutoSize               := false;
    QR_Genre[i].Enabled                := false;
    QR_Genre[i].Left                   := 300;
    QR_Genre[i].Width                  := 200;
    QR_Genre[i].Height                 := 22;
    QR_Genre[i].Parent                 := QR4OBSFrame;
    QR_Genre[i].OnChange               := @QR_GenreOnChange;
    end;

  for i := 0 to 1 do begin
    QR_Data[i]                         := TLabeledEdit.Create(NIL);
    QR_Data[i].AutoSelect              := True;
    QR_Data[i].AutoSize                := False;
    QR_Data[i].Color                   := clRed;
    QR_Data[i].Height                  := 29;
    QR_Data[i].Left                    := 8;
    QR_Data[i].Parent                  := QR4OBSFrame;
    QR_Data[i].OnChange                := @QR_DataOnChange;
    end;

  with QR do begin
    Cursor                             := crNo;
    Height                             := 128;
    Left                               := 500;
    StrictSize                         := false;
    Top                                := 12;
    Width                              := 128;
    Parent                             := QR4OBSFrame;
    end;

  { Forumaufbau der Buttons }
  with Button[0] do begin
    Caption                            := '&Speichern';
    Enabled                            := False;
    Hint                               := 'Übertragen des aktuellen' + CRLF +
                                          'Datensatzes';
    Left                               := 8;
    OnClick                            := @SaveOnClick;
    end;

  with Button[1] do begin
    Caption                            := '&>';
    Enabled                            := False;
    Hint                               := 'Nächter Datensatz';
    Left                               := 88;
    OnClick                            := @NextOnClick;
    end;

  with Button[2] do begin
    Caption                            := '&<';
    Enabled                            := False;
    Hint                               := 'Datensatz zurück';
    Left                               := 168;
    OnClick                            := @BackOnClick;
    end;

  with Button[3] do begin
    Caption                            := '&Löschen';
    Enabled                            := False;
    Hint                               := 'Löscht den ausgewählten' + CRLF +
                                          'Datensatz';
    Left                               := 248;
    OnClick                            := @DelOnClick;
    end;

  with Button[4] do begin
    Caption                            := 'B&eenden';
    Hint                               := 'Schließt das Formular';
    Left                               := 328;
    OnClick                            := @ExitOnClick;
    end;

  with Button[5] do begin
    Caption                            := '&?';
    Hint                               := 'Informationen';
    Left                               := 408;
//    OnClick                            := @HelpOnClick;

{ Formaufbau QR_Genre }
  end;

  with QR_Genre[0] do begin
    Caption                            := '&Rock/Metal/NDH && Gothic';
    Top                                := 64;
    end;
    
  with QR_Genre[1] do begin
    Caption                            := '&Electro in the Evening';
    Top                                := 86;
    end;

  with QR_Genre[2] do begin
    Caption                            := 'Events and &Gigs';
    Top                                := 108;
    end;
    

  { Formaufbau QR_Data }
  with QR_Data[0] do begin
    EditLabel.Caption                  := 'Link-Adresse für QR...';
    Top                                := 24;
    Width                              := 472;
    end;

  with QR_Data[1] do begin
    EditLabel.Caption                  := 'Name des QR...';
    Enabled                            := False;
    Top                                := 80;
    Visible                            := False;
    Width                              := 280;
  end;
end;

procedure TQR4OBSFrame.FormKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
begin
  if  Key = GShortkey_Alt_Abbrechen                         then ExitOnClick(Sender);               // ALT + A
  if (Key = GShortKey_Back[1]) or (key = GShortKey_Back[2]) then BackOnClick(Sender);               // ALT+B / ALT+< (OEM_0xE1)
  if  Key = GShortKey_Alt_Del                               then DelOnClick(Sender);                // ALT+L
  if (Key = GShortkey_Next[1]) or (Key = GShortkey_Next[2]) then NextOnClick(Sender);               // ALT+N / ALT+> (OEM_0xE1)
  if  Key = GShortKey_Alt_Save                              then SaveOnClick(Sender);               // Alt+S
//  if (Key = GShortkey_Help[1]) or (Key = GShortkey_Help[2]) then HelpOnClick(Sender);               // ALT+H / ALT+?
  if  Key = GShortkey_Enter                                 then begin
    if QR_Data[0].Color = clYellow then begin
      QR_Data[0].Color                 := clGreen;
      QR_Data[1].Enabled               := true;
      QR.Text                          := QR_Data[0].Text;
      end;
    if QR_Data[1].Color = clYellow then begin
      QR_Data[1].Color                 := clGreen;
      QR_Genre[0].Enabled              := True;
      QR_Genre[1].Enabled              := True;
      QR_Genre[2].Enabled              := True;
      end;
    end;
end;

procedure TQR4OBSFrame.FormResize(Sender : TObject);
begin
  Caption                              := IntToStr(QR4OBSFrame.Height) + ' | ' + IntToStr(QR4OBSFrame.Width);
end;

procedure TQR4OBSFrame.FormShow(Sender : TObject);
var
  ID                                   : word;
begin
  if FileExists(_QR4OBS.PConst.fFilename + '.QRD') then begin
    QR4                                := _QR4OBS.QR_Data;
    Caption                            := _QR4OBS.PConst.fFilename+'.QRD';
    end else Caption                   := _QR4OBS.PConst.fFilename+'.QRD Not Found';
    for ID := 0 to 100 do
      if (QR4.Link[ID] <> '') then
        Last_QR                        := ID;
  QR_Index                             := Last_QR;
  Load(Last_QR);
end;

Procedure TQR4OBSFrame.QR_DataOnChange(Sender: TObject);
begin
  if QR_Data[0].Text <> '' then begin
    QR_Data[0].Color                   := clYellow;
    QR_Data[1].Visible                 := True;
    end else QR_Data[0].Color          := clRed;
  if QR_Data[1].Text <> '' then
    QR_Data[1].Color                   := clYellow
    else QR_Data[1].Color              := clRed;
end;

Procedure TQR4OBSFrame.QR_GenreOnChange(Sender: TObject);
begin
  _QR4OBS.fQR_Data.Genre[QR_Index][0]  := QR_Genre[0].Checked;
  _QR4OBS.fQR_Data.Genre[QR_Index][1]  := QR_Genre[1].Checked;
  _QR4OBS.fQR_Data.Genre[QR_Index][2]  := QR_Genre[2].Checked;
  Button[0].Enabled                    := True;
  Button[1].Enabled                    := True;
  Button[2].Enabled                    := True;
  Button[3].Enabled                    := True;
end;

{#todo 1. 17.10.23 Save & Next Button gegenseitig verriegeln und Hin anpassen}
{#todo 2. 17.10.23 Exit-Button umbenennen (A&bbrechen --> S&chließen) }

Procedure TQR4OBSFrame.SaveOnClick(Sender: TObject);
begin
  QR4.Link[QR_Index]                   := QR_Data[0].Text;
  QR4.Name[QR_Index]                   := QR_Data[1].Text;
  QR4.Genre[QR_Index][0]               := QR_Genre[0].Checked;
  QR4.Genre[QR_Index][1]               := QR_Genre[1].Checked;
  QR4.Genre[QR_Index][2]               := QR_Genre[2].Checked;
  _QR4OBS.fQR_Data                     := QR4;
  _QR4OBS.QR_Data                      := _QR4OBS.fQR_Data;
  QR_Frame.QR_List.fQR_Data            := _QR4OBS.QR_Data;
  QR_Frame.QR_Load.last                := _QR4OBS.QR_Data.last;
end;

Procedure TQR4OBSFrame.BackOnClick(Sender: TObject);
begin
  dec(QR_Index);
  Load(QR_Index);
end;

Procedure TQR4OBSFrame.NextOnClick(Sender: TObject);
begin
  inc(QR_Index);
  Load(QR_Index);
end;

Procedure TQR4OBSFrame.DelOnClick(Sender: TObject);
begin
  QR4.Link[QR_Index]                   := '';
  QR4.Name[QR_Index]                   := '';
  QR4.Genre[QR_Index][0]               := false;
  QR4.Genre[QR_Index][1]               := false;
  QR4.Genre[QR_Index][2]               := false;
  QR_Data[0].Text                      := '';
  QR_Data[1].Text                      := '';
  QR_Genre[0].Checked                  := false;
  QR_Genre[1].Checked                  := false;
  QR_Genre[2].Checked                  := false;
  _QR4OBS.fQR_Data                     := QR4;
  _QR4OBS.QR_Data                      := _QR4OBS.fQR_Data;
  QR_Frame.QR_List.fQR_Data            := _QR4OBS.QR_Data;
  QR_Frame.QR_Load.last                := _QR4OBS.QR_Data.last;
end;

Procedure TQR4OBSFrame.ExitOnClick(Sender: TObject);
begin
  Close;
end;

end.
