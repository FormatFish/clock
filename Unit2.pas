unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, jpeg;

type
  TForm2 = class(TForm)
    image2: TImage;
    label2: TLabel;
    label3: TLabel;
    label4: TLabel;
    btn1: TSpeedButton;
    label5: TLabel;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.btn1Click(Sender: TObject);
begin
  Form2.close   ;
end;

end.
