unit _genre;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus,
  // nachfolgende Units in der Anwendung QR
  _qr,
  // Units welche gesammelte Constanten und Variablen enthalten
  uconst;
  //

type

  { TGenre }

  TGenre = class(TForm)
    Button1                                      : TButton;
    Button2                                      : TButton;
    Label1                                       : TLabel;
    RadioButton1                                 : TRadioButton;
    RadioButton2                                 : TRadioButton;
    RadioButton3                                 : TRadioButton;
    procedure Button1Click(Sender : TObject);
    procedure Button2Click(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure FormKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
    procedure RadioButton1Click(Sender : TObject);
    procedure RadioButton2Click(Sender : TObject);
    procedure radiobutton3change(sender :tobject);
  private

  public

  end;

var
  Genre : TGenre;

implementation

{$R *.lfm}

{ TGenre }

procedure TGenre.FormCreate(Sender : TObject);
begin
  Caption                                        := 'Information';
end;

procedure TGenre.FormKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
begin
  if  Key = 69 then RadioButton2.Checked         := True;
  if  Key = 82 then RadioButton1.Checked         := True;
  if  Key = 83 then RadioButton3.Checked         := True;
  if  Key = GShortKey_Alt_OK then Button1Click(Sender);
  if (Key = GShortkey_ESC) or
     (Key = GSHortkey_Alt_Abbrechen) then
    Button2Click(Sender);
end;

procedure TGenre.RadioButton1Click(Sender : TObject);
begin
  QR_Frame.Rock                      := True;
  QR_Frame.Electro                   := False;
end;

procedure TGenre.RadioButton2Click(Sender : TObject);
begin
  QR_Frame.Rock                      := False;
  QR_Frame.Electro                   := True;
end;

procedure TGenre.RadioButton3Change(Sender: TObject);
begin
  QR_Frame.Rock                      := True;
  QR_Frame.Electro                   := True;
end;

procedure TGenre.Button1Click(Sender : TObject);
begin
  Visible                              := False;
  QR_Frame.Show;
end;

procedure TGenre.Button2Click(Sender : TObject);
begin
  Application.Terminate;
end;

end.

