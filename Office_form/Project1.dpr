program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {FormBureau};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormBureau, FormBureau);
  Application.Run;
end.
