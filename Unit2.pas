unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Buttons;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    edt_UserName: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    Label4: TLabel;
    edt_EnrollNumber: TMaskEdit;
    cb_FingerIndex: TComboBox;
    Label5: TLabel;
    edt_Password: TEdit;
    edt_Repassword: TEdit;
    btnNewUser: TBitBtn;
    BitBtn2: TBitBtn;
    Label6: TLabel;
    cb_Privilege: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure edt_EnrollNumberKeyPress(Sender: TObject; var Key: Char);
    procedure edt_UserNameKeyPress(Sender: TObject; var Key: Char);
    procedure edt_PasswordKeyPress(Sender: TObject; var Key: Char);
    procedure edt_RepasswordKeyPress(Sender: TObject; var Key: Char);
    procedure cb_FingerIndexKeyPress(Sender: TObject; var Key: Char);
    procedure btnNewUserClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1, Unit7;

{$R *.dfm}

procedure TForm2.FormShow(Sender: TObject);
var
  EnrollNumber,Name,Password:WideString;
  Privilege:Integer;
  Enabled:WordBool;
  NextEnrollNumber:WideString;
begin
  {
  if unit1.MachineNumber_A_IsConnected then
  begin
    NextEnrollNumber:='0';
    while Form1.CZKEM_A.SSR_GetAllUserInfo(unit1.MachineNumber_A,EnrollNumber,Name,Password,Privilege,Enabled) do
    begin
      NextEnrollNumber:=EnrollNumber;
    end;
    NextEnrollNumber:=IntToStr(StrToInt(Trim(NextEnrollNumber))+1);
    edt_EnrollNumber.Text:=NextEnrollNumber;
    edt_UserName.SelectAll;
    edt_UserName.SetFocus;
  end;
  }
  edt_EnrollNumber.SelectAll;
  edt_EnrollNumber.SetFocus;
end;

procedure TForm2.edt_EnrollNumberKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
  begin
    edt_UserName.SetFocus;
    edt_UserName.SelectAll;
  end;
end;

procedure TForm2.edt_UserNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
  begin
    edt_Password.SetFocus;
    edt_Password.SelectAll;
  end;
end;

procedure TForm2.edt_PasswordKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
  begin
    edt_Repassword.SetFocus;
    edt_Repassword.SelectAll;
  end;
end;

procedure TForm2.edt_RepasswordKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
  begin
    cb_FingerIndex.SetFocus;
    cb_FingerIndex.SelectAll;
  end;
end;

procedure TForm2.cb_FingerIndexKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
  begin
    btnNewUser.SetFocus;
  end;
end;

procedure TForm2.btnNewUserClick(Sender: TObject);
var
  EnrollNumber:string;
  UserName:string;
  Password,RePassword:string;
  FingerIndex:Integer;
  Flag:Integer;
  ErrorCode:Integer;
  Privilege:Integer;
  Enabled:WordBool;
begin
  if unit1.MachineNumber_A_IsConnected = False then
  begin
    MessageDlg(Unit1.MachineName_A+' Disconnected!',mtError,[mbOK],0);
    Memo1.Lines.Add(Unit1.MachineName_A+' Disconnected!');
  end;
  if unit1.MachineNumber_B_IsConnected = False then
  begin
    MessageDlg(Unit1.MachineName_B+' Disconnected!',mtError,[mbOK],0);
    Memo1.Lines.Add(Unit1.MachineName_B+' Disconnected!');
  end;
  if unit1.MachineNumber_C_IsConnected = False then
  begin
    MessageDlg(Unit1.MachineName_C+' Disconnected!',mtError,[mbOK],0);
    Memo1.Lines.Add(Unit1.MachineName_C+' Disconnected!');
  end;

  if Trim(edt_Password.Text)<>Trim(edt_RePassword.Text) then
  begin
    MessageDlg('Password Discrepancy�APlease Make Sure Password And Repassword are the same!',mtError,[mbOK],0);
    edt_Password.SelectAll;
    edt_Password.SetFocus;
    Abort;
  end;

  if (Unit1.MachineNumber_A_IsConnected = False) and (Unit1.MachineNumber_B_IsConnected = False) and (Unit1.MachineNumber_C_IsConnected = False) then
  begin
    MessageDlg('There Is No FingerPrint Machine Connected, Abort Operation !',mtError,[mbOK],0);
    Abort;
  end;

  EnrollNumber:=Trim(edt_EnrollNumber.Text);
  UserName:=Trim(edt_UserName.Text);
  Password:=Trim(edt_Password.Text);
  RePassword:=Trim(edt_RePassword.Text);
  FingerIndex:=StrToInt(cb_FingerIndex.Text);
  Privilege:=StrToInt(Copy(cb_Privilege.Text,1,1));
  Flag:=1;
  Enabled:=true;
  Form1.CZKEM_A.CancelOperation();
  Form1.CZKEM_A.SSR_DelUserTmpExt(Unit1.MachineNumber_A, EnrollNumber, FingerIndex);
  if Form1.CZKEM_A.StartEnrollEx(EnrollNumber, FingerIndex, Flag) then
  begin
    Memo1.Lines.Add('Registering User Data, UserID='+EnrollNumber+', UserName='+UserName+', FingerIndex='+IntTostr(FingerIndex)+', Privilege='+IntToStr(Privilege));
    Memo1.Lines.Add('Please Put One Finger on '+Unit1.MachineName_A+'...');
    Form1.CZKEM_A.StartIdentify();
    Close;
    Form7.ShowModal;
  end
  else
  begin
    Form1.CZKEM_A.GetLastError(ErrorCode);
    Memo1.Lines.Add('Operation Failed�AErrorCode='+IntToStr(ErrorCode));
  end;
end;

procedure TForm2.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

end.
