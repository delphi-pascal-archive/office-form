unit Unit1;
{
___________________________________________________________

Titre: Le Bureau dans la form
Auteur: H@PPyZERØ5
E-mail: happy05@programmer.net
___________________________________________________________

}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,ShlObj,ComObj, ExtDlgs;

//
type
  LogPal = record
  lopal : TLogPalette;
  dummy:Array[0..255] of TPaletteEntry;
  end;

//
const
CLSID_ActiveDesktop: TGUID= '{75048700-EF1F-11D0-9888-006097DEACF9}';

type
  TFormBureau = class(TForm)
    SavePicD1: TSavePictureDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormBureau: TFormBureau;

  Bureauhwnd,Parenthwnd:hwnd;//

implementation

{$R *.dfm}


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
//FormCreate
//Mettre le Bureau dans la form
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
procedure TFormBureau.FormCreate(Sender: TObject);
begin
Bureauhwnd := FindWindow('progman', nil);//progman = "Program Manager"
Parenthwnd := windows.GetParent(Bureauhwnd);//Parent de progman
windows.SetParent(Bureauhwnd,formBureau.Handle);
end;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
//FormKeyPress
//Cliquez sur 's' pour enregistrer la capture
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
procedure TFormBureau.FormKeyPress(Sender: TObject; var Key: Char);
var
  Pal : LogPal;
  tempCanvas: TCanvas;
  destRect,sourceRect : TRect;
  image : TImage;
  cHandle : HWND;
begin
 if Key = 's' then
   begin
  tempCanvas := TCanvas.Create;

  try
    tempCanvas.Handle := GetDeviceContext(cHandle);
    image:=TImage.create(self);

    try
      with image do
      begin
      Height := Self.Height-30;
      Width :=  Self.Width-5;
      destRect := Rect(0,0,Width,Height);
      sourceRect := destRect;
      Canvas.CopyRect(destRect,tempCanvas,sourceRect);
      Pal.loPal.palVersion:=$300;
      Pal.loPal.palNumEntries:=256;
      GetSystemPaletteEntries(tempCanvas.Handle,0,256,Pal.lopal.palPalEntry);
      Picture.Bitmap.Palette:= CreatePalette(Pal.lopal);
      end;

      if SavePicD1.Execute then
      Image.Picture.savetofile(SavePicD1.FileName);

    finally
    image.Free;
    end;

  finally
  tempCanvas.Free;
  end;
   end;
    end;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
//FormResize
//Actualier le Bureau
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
procedure TFormBureau.FormResize(Sender: TObject);
var
  ActiveDesktop: IActiveDesktop;
begin
  ActiveDesktop := CreateComObject(CLSID_ActiveDesktop) as IActiveDesktop;
  ActiveDesktop.ApplyChanges(AD_APPLY_ALL or AD_APPLY_FORCE);
end;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
//FormClose
//Rendre le Bureau a ça place d'origine
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
procedure TFormBureau.FormClose(Sender: TObject; var Action: TCloseAction);
begin
windows.SetParent(Bureauhwnd,Parenthwnd);
end;

end.

//to be continued...
