program Frame;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  {$ifdef Thread}
  cmem, cthreads,
  {$endif}
  {$elseif defined HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, sysutils, Dialogs, Forms,// this includes the LCL widgetset

  // User Forms
  main,

  // User Units
  uconst, ufunction, set_data, uvar;

{$R *.res}

{#todo 1. 07.10.23; Terminate einbinden in Anhänigkeit, ob Verbindung zum einem der DJ-Rechner besteht}
{#done 1. 09.10.23; Aufgabe erledigt und Funktion auf Programmierrechner erfolgreich getestet.}

procedure Run(value: boolean);
begin
  {$ifdef DJ}
  if value then begin
    if MessageDlg('Frage?!', 'Willkommen bei der Track-ID-4-OBS werder "VamLykTan"' + #13 +
                  'Haben sie Heute einen' +
                  '---> Rock|Metal|NDH & Gothic <---' + #13 +
                  'Stream?', mtConfirmation, mbYesNo, '0') = 6 {mrYes} then
      MessageDlg('Info', 'Die QR_Codes für "Rock|Metal|NDH & Gothic" werden geladen.', mtInformation, [mbOK], '0')
      else if MessageDlg('Frage?!', 'Handelt es sich hierbei um den Stream' + #13 +
                         '---> Electronics in the Evening <--- Stream?', mtConfirmation, mbYesNo, '0') =6 {mrYes}  then
             MessageDlg('Info', 'Die QR_Codes für "Electronics in the Evening" werden geladen.', mtInformation, [mbOK], '0')
             else MessageDlg('Info', 'Ok, da es wohl ein Gemischter Stream wird,' + #13 +
                             'werden alle QR-Codes geladen.', mtInformation, [mbOK], '0');
    end;
  {$endif}
  Application.Run;
end;

begin
  RequireDerivedFormResource:=True;
  application.scaled:=true;
  Application.Initialize;
  Application.CreateForm(TTrack_ID,    Track_ID);
//  IDE_Load('/usr/bin/', 'nautilus', [TrackFile[0]], []);
  {$ifdef VJ}
  IDE_Load('/usr/bin/', 'nautilus', ['smb://DJ-RECHNER/musik/Mixxx/NOW-PLAYING/mixxx-now-playing-master/'], []);
  sleep(1500);
  if not FileExists(TrackFile[0]) then begin
    sleep(1500);
    IDE_Load('/usr/bin/', 'nautilus', ['smb://192.168.188.6/musik/Mixxx/NOW-PLAYING/mixxx-now-playing-master/'], []);
    if not FileExists(TrackFile[1]) then begin
      sleep(1500);
      IDE_Load('/usr/bin/', 'nautilus', ['smb://192.168.188.5/musik/Mixxx/NOW-PLAYING/mixxx-now-playing-master/'], []);
      if not FileExists(TrackFile[2]) then begin
        if MessageDlg('Warnung', 'Das Programm "Frame-4-OSB" hat KEINE verbindung zum Netzwerk' + #13 +
                      'weder ' + TrackFile[0] + #13 +
                      'noch ' + TrackFile[1] + #13 +
                      'können geladen werden.', mtWarning, [mbOK], '0') = 1 then
          Application.Terminate
          end;
      end;
      Run(false);
    end else
    {$endif}
    Run(False);
end.

