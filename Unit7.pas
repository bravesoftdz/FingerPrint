unit Unit7;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  TForm7 = class(TForm)
    Label1: TLabel;
    BitBtn1: TBitBtn;
    Timer1: TTimer;
    Label2: TLabel;
    lblCountDown: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  COUNTDOWN:Integer=5*60;

var
  Form7: TForm7;
  Elapse: Integer;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm7.Timer1Timer(Sender: TObject);
var
  Hour,Second:Integer;
begin
  Elapse:=Elapse-1;
  if Elapse <= 0 then
  begin
    Timer1.Enabled:=False;
    Form1.CZKEM_A.CancelOperation;
    close;
  end
  else
  begin
    Hour:=Elapse div 60;
    Second:=Elapse - (Hour*60);
    lblCountDown.Caption:=IntToStr(Hour)+':'+IntToStr(Second);
  end;
end;

procedure TForm7.BitBtn1Click(Sender: TObject);
begin
  Form1.CZKEM_A.CancelOperation;
  close;
end;

procedure TForm7.FormActivate(Sender: TObject);
var
  Hour,Second:Integer;
begin
  Timer1.Enabled:=true;
  Elapse:=COUNTDOWN;
  Hour:=Elapse div 60;
  Second:=Elapse - (Hour*60);
  lblCountDown.Caption:=IntToStr(Hour)+':'+IntToStr(Second);
end;

end.
