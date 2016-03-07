unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DateUtils, ExtCtrls;

type
  TForm5 = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    memMachine_A: TMemo;
    Panel2: TPanel;
    Panel3: TPanel;
    memMachine_B: TMemo;
    BitBtn2: TBitBtn;
    memMachine_C: TMemo;
    BitBtn3: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function VerifyModeToStr(VerifyMode:Integer):string;
    function InOutModeToStr(InOutMode:Integer):string;
  public
    { Public declarations }
  end;

var
  Form5: TForm5;
  cursor: TCursor;
  EnrollNumber: WideString;
  VerifyMode,InOutMode,Year,Month,Day,Hour,Minute,Second,Workcode:Integer;
implementation

uses Unit1;

{$R *.dfm}

function TForm5.VerifyModeToStr(VerifyMode:Integer):string;
begin
  case VerifyMode of
    0: Result:='FP_OR_PW_OR_RF';
    1: Result:='FP';
    2: Result:='PIN';
    3: Result:='PW';
    4: Result:='RF';
    5: Result:='FP_OR_PW';
    6: Result:='FP_OR_RF';
    7: Result:='PW_OR_RF';
    8: Result:='PIN_AND_FP';
    9: Result:='FP_AND_PW';
    10: Result:='FP_AND_RF';
    11: Result:='PW_AND_RF';
    12: Result:='FP_AND_PW_AND_RF';
    13: Result:='PIN_AND_FP_AND_PW';
    14: Result:='FP_AND_OR_PIN';
  end;
end;

function TForm5.InOutModeToStr(InOutMode:Integer):string;
begin
  case InOutMode of
    0: Result:='Check-In';
    1: Result:='Check-Out';
    2: Result:='Break-Out';
    3: Result:='Break-In';
    4: Result:='OT-In';
    5: Result:='OT-Out';
  end;
end;

procedure TForm5.BitBtn1Click(Sender: TObject);
var
  Count,ErrorCode:Integer;
  ActionTime:TDateTime;
begin
  if Unit1.MachineNumber_A_IsConnected then
  begin
    cursor:=screen.Cursor;
    Screen.Cursor := crHourGlass;
    Form1.CZKEM_A.EnableDevice(Unit1.MachineNumber_A, false);
    if Form1.CZKEM_A.ReadGeneralLogData(Unit1.MachineNumber_A) then
    begin
      Count:=0;
      while Form1.CZKEM_A.SSR_GetGeneralLogData(Unit1.MachineNumber_A, EnrollNumber, VerifyMode, InOutMode, Year, Month, Day, Hour, Minute, Second, Workcode) do
      begin
        Inc(Count);
        ActionTime:=EncodeDateTime(Year,Month,Day,Hour,Minute,Second,0);
        memMachine_A.Lines.Add(IntToStr(Count)+',EnrollNumber='+EnrollNumber+',VerifyMode='+VerifyModeToStr(VerifyMode)+',InOutMode='+InOutModeToStr(InOutMode)+',ActionDate='+FormatDateTime('yyyy/mm/dd hh:nn:ss',ActionTime)+',Workcode='+IntToStr(Workcode));
      end;
    end
    else
    begin
      Screen.Cursor:=Cursor;
      Form1.CZKEM_A.GetLastError(ErrorCode);
      if ErrorCode <> 0 then
      begin
        MessageDlg('讀取資料錯誤, 錯誤碼='+IntToStr(ErrorCode),mtError,[mbOK],0);
      end
      else
      begin
        MessageDlg('無任何資料傳回',mtError,[mbOK],0);
      end;
    end;
    Form1.CZKEM_A.EnableDevice(Unit1.MachineNumber_A, true);
    Screen.Cursor:=Cursor;
  end
  else
  begin
    MessageDlg('建檔指紋機尚未連接',mtInformation,[mbOK],0);
  end;
end;

procedure TForm5.BitBtn2Click(Sender: TObject);
var
  Count,ErrorCode:Integer;
  ActionTime:TDateTime;
begin
  if Unit1.MachineNumber_B_IsConnected then
  begin
    cursor:=screen.Cursor;
    Screen.Cursor := crHourGlass;
    Form1.CZKEM_B.EnableDevice(Unit1.MachineNumber_B, false);
    if Form1.CZKEM_B.ReadGeneralLogData(Unit1.MachineNumber_B) then
    begin
      Count:=0;
      while Form1.CZKEM_B.SSR_GetGeneralLogData(Unit1.MachineNumber_B, EnrollNumber, VerifyMode, InOutMode, Year, Month, Day, Hour, Minute, Second, Workcode) do
      begin
        Inc(Count);
        ActionTime:=EncodeDateTime(Year,Month,Day,Hour,Minute,Second,0);
        memMachine_B.Lines.Add(IntToStr(Count)+',EnrollNumber='+EnrollNumber+',VerifyMode='+VerifyModeToStr(VerifyMode)+',InOutMode='+InOutModeToStr(InOutMode)+',ActionDate='+FormatDateTime('yyyy/mm/dd hh:nn:ss',ActionTime)+',Workcode='+IntToStr(Workcode));
      end;
    end
    else
    begin
      Screen.Cursor:=Cursor;
      Form1.CZKEM_B.GetLastError(ErrorCode);
      if ErrorCode <> 0 then
      begin
        MessageDlg('讀取資料錯誤, 錯誤碼='+IntToStr(ErrorCode),mtError,[mbOK],0);
      end
      else
      begin
        MessageDlg('無任何資料傳回',mtError,[mbOK],0);
      end;
    end;
    Form1.CZKEM_B.EnableDevice(Unit1.MachineNumber_B, true);
    Screen.Cursor:=Cursor;
  end
  else
  begin
    MessageDlg('入口指紋機尚未連接',mtInformation,[mbOK],0);
  end;
end;

procedure TForm5.BitBtn3Click(Sender: TObject);
var
  Count,ErrorCode:Integer;
  ActionTime:TDateTime;
begin
  if Unit1.MachineNumber_C_IsConnected then
  begin
    cursor:=screen.Cursor;
    Screen.Cursor := crHourGlass;
    Form1.CZKEM_C.EnableDevice(Unit1.MachineNumber_C, false);
    if Form1.CZKEM_C.ReadGeneralLogData(Unit1.MachineNumber_C) then
    begin
      Count:=0;
      while Form1.CZKEM_C.SSR_GetGeneralLogData(Unit1.MachineNumber_C, EnrollNumber, VerifyMode, InOutMode, Year, Month, Day, Hour, Minute, Second, Workcode) do
      begin
        Inc(Count);
        ActionTime:=EncodeDateTime(Year,Month,Day,Hour,Minute,Second,0);
        memMachine_C.Lines.Add(IntToStr(Count)+',EnrollNumber='+EnrollNumber+',VerifyMode='+VerifyModeToStr(VerifyMode)+',InOutMode='+InOutModeToStr(InOutMode)+',ActionDate='+FormatDateTime('yyyy/mm/dd hh:nn:ss',ActionTime)+',Workcode='+IntToStr(Workcode));
      end;
    end
    else
    begin
      Screen.Cursor:=Cursor;
      Form1.CZKEM_C.GetLastError(ErrorCode);
      if ErrorCode <> 0 then
      begin
        MessageDlg('讀取資料錯誤, 錯誤碼='+IntToStr(ErrorCode),mtError,[mbOK],0);
      end
      else
      begin
        MessageDlg('無任何資料傳回',mtError,[mbOK],0);
      end;
    end;
    Form1.CZKEM_C.EnableDevice(Unit1.MachineNumber_C, true);
    Screen.Cursor:=Cursor;
  end
  else
  begin
    MessageDlg('出口指紋機尚未連接',mtInformation,[mbOK],0);
  end;
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
  Label1.Caption:=Unit1.MachineName_A;
  Label2.Caption:=Unit1.MachineName_B;
  Label3.Caption:=Unit1.MachineName_C;
end;

end.
