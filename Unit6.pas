unit Unit6;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TForm6 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Label1: TLabel;
    edtEnrollNumber: TEdit;
    BitBtn1: TBitBtn;
    Panel6: TPanel;
    lblDatabase: TLabel;
    lblFingerPrintMachine_A: TLabel;
    lblFingerPrintMachine_B: TLabel;
    lblFingerPrintMachine_C: TLabel;
    memDatabase: TMemo;
    memFingerPrintMachine_A: TMemo;
    memFingerPrintMachine_B: TMemo;
    memFingerPrintMachine_C: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm6.FormCreate(Sender: TObject);
begin
  lblFingerPrintMachine_A.Caption:=Unit1.MachineName_A;
  lblFingerPrintMachine_B.Caption:=Unit1.MachineName_B;
  lblFingerPrintMachine_C.Caption:=Unit1.MachineName_C;
end;

procedure TForm6.BitBtn1Click(Sender: TObject);
var
  EnrollNumber,UserName,Password:WideString;
  Privilege:Integer;
  Enable:WordBool;
  FingerIndex,Flag,TmpLength:Integer;
  TmpData:WideString;
begin
  EnrollNumber:=Trim(edtEnrollNumber.Text);
  if EnrollNumber <> '' then
  begin
    //======================================================================================================
    //取得資料庫中的資料
    //======================================================================================================
    memDatabase.Lines.Clear;
    Form1.ADOQuery1.Active:=False;
    Form1.ADOQuery1.SQL.Clear;
    Form1.ADOQuery1.SQL.Add('SELECT * FROM [UserInfo] WHERE EnrollNumber='+''''+EnrollNumber+'''');
    Form1.ADOQuery1.Active:=True;
    memDatabase.Lines.Add('============================================================');
    memDatabase.Lines.Add('Enrollment User Data');
    memDatabase.Lines.Add('============================================================');
    while not Form1.ADOQuery1.Eof do
    begin
      memDatabase.Lines.Add('EnrollNumber='+EnrollNumber);
      memDatabase.Lines.Add('UserName='+Form1.ADOQuery1.FieldValues['UserName']);
      memDatabase.Lines.Add('CreateDate='+Form1.ADOQuery1.FieldValues['CreateDate']);
      Form1.ADOQuery1.Next;
    end;
    Form1.ADOQuery1.Active:=False;
    Form1.ADOQuery1.SQL.Clear;
    Form1.ADOQuery1.SQL.Add('SELECT * FROM [UserTemplate] WHERE EnrollNumber='+''''+EnrollNumber+''''+' ORDER BY FingerIndex');
    Form1.ADOQuery1.Active:=True;
    memDatabase.Lines.Clear;
    memDatabase.Lines.Add('============================================================');
    memDatabase.Lines.Add('Enrollment Template Data');
    memDatabase.Lines.Add('============================================================');
    while not Form1.ADOQuery1.Eof do
    begin
      memDatabase.Lines.Add('FingerIndex='+IntToStr(Form1.ADOQuery1.FieldValues['FingerIndex'])+', CreateDate='+DateTimeToStr(Form1.ADOQuery1.FieldValues['CreateDate']));
      Form1.ADOQuery1.Next;
    end;
    //======================================================================================================

    //======================================================================================================
    //取得FingerPrint Machine A中的資料
    //======================================================================================================
    memFingerPrintMachine_A.Lines.Clear;
    if Unit1.MachineNumber_A_IsConnected then
    begin
      memFingerPrintMachine_A.Lines.Add('============================================================');
      memFingerPrintMachine_A.Lines.Add('Enrollment User Data');
      memFingerPrintMachine_A.Lines.Add('============================================================');
      if Form1.CZKEM_A.SSR_GetUserInfo(Unit1.MachineNumber_A,EnrollNumber,UserName,Password,Privilege,Enable) then
      begin
        memFingerPrintMachine_A.Lines.Add('EnrollNumber='+EnrollNumber);
        memFingerPrintMachine_A.Lines.Add('UserName='+UserName);
      end;
      memFingerPrintMachine_A.Lines.Add('============================================================');
      memFingerPrintMachine_A.Lines.Add('Enrollment Template Data');
      memFingerPrintMachine_A.Lines.Add('============================================================');
      for FingerIndex:=0 to 9 do
      begin
        if (Form1.CZKEM_A.GetUserTmpExStr(Unit1.MachineNumber_A, EnrollNumber, FingerIndex, Flag, TmpData, TmpLength)) then
        begin
          memFingerPrintMachine_A.Lines.Add('FingerIndex='+IntToStr(FingerIndex)+', Flag='+IntToStr(Flag));
        end;
      end;
    end;
    //======================================================================================================

    //======================================================================================================
    //取得FingerPrint Machine B中的資料
    //======================================================================================================
    memFingerPrintMachine_B.Lines.Clear;
    if Unit1.MachineNumber_B_IsConnected then
    begin
      memFingerPrintMachine_B.Lines.Add('============================================================');
      memFingerPrintMachine_B.Lines.Add('Enrollment User Data');
      memFingerPrintMachine_B.Lines.Add('============================================================');
      if Form1.CZKEM_B.SSR_GetUserInfo(Unit1.MachineNumber_B,EnrollNumber,UserName,Password,Privilege,Enable) then
      begin
        memFingerPrintMachine_B.Lines.Add('EnrollNumber='+EnrollNumber);
        memFingerPrintMachine_B.Lines.Add('UserName='+UserName);
      end;
      memFingerPrintMachine_B.Lines.Add('============================================================');
      memFingerPrintMachine_B.Lines.Add('Enrollment Template Data');
      memFingerPrintMachine_B.Lines.Add('============================================================');
      for FingerIndex:=0 to 9 do
      begin
        if (Form1.CZKEM_B.GetUserTmpExStr(Unit1.MachineNumber_B, EnrollNumber, FingerIndex, Flag, TmpData, TmpLength)) then
        begin
          memFingerPrintMachine_B.Lines.Add('FingerIndex='+IntToStr(FingerIndex)+', Flag='+IntToStr(Flag));
        end;
      end;
    end;
    //======================================================================================================

    //======================================================================================================
    //取得FingerPrint Machine C中的資料
    //======================================================================================================
    memFingerPrintMachine_C.Lines.Clear;
    if Unit1.MachineNumber_C_IsConnected then
    begin
      memFingerPrintMachine_C.Lines.Add('============================================================');
      memFingerPrintMachine_C.Lines.Add('Enrollment User Data');
      memFingerPrintMachine_B.Lines.Add('============================================================');
      if Form1.CZKEM_C.SSR_GetUserInfo(Unit1.MachineNumber_C,EnrollNumber,UserName,Password,Privilege,Enable) then
      begin
        memFingerPrintMachine_C.Lines.Add('EnrollNumber='+EnrollNumber);
        memFingerPrintMachine_C.Lines.Add('UserName='+UserName);
      end;
      memFingerPrintMachine_C.Lines.Add('============================================================');
      memFingerPrintMachine_C.Lines.Add('Enrollment Template Data');
      memFingerPrintMachine_C.Lines.Add('============================================================');
      for FingerIndex:=0 to 9 do
      begin
        if (Form1.CZKEM_C.GetUserTmpExStr(Unit1.MachineNumber_C, EnrollNumber, FingerIndex, Flag, TmpData, TmpLength)) then
        begin
          memFingerPrintMachine_C.Lines.Add('FingerIndex='+IntToStr(FingerIndex)+', Flag='+IntToStr(Flag));
        end;
      end;
    end;
    //======================================================================================================
  end
  else
  begin
    ShowMessage('EnrollNumber can not be empty');
  end;
end;

end.
