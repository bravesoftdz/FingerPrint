unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DateUtils, OleCtrls, zkemkeeper_TLB, ExtCtrls, DB,
  ADODB, Buttons, ComCtrls, SimpleTCP, StrUtils, Sockets, IdBaseComponent,
  IdComponent, IdTCPServer, IdRawBase, IdRawClient, IdIcmpClient,
  OverbyteIcsWndControl, OverbyteIcsPing;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    Panel2: TPanel;
    edt_IP_A: TEdit;
    lbl_machinea: TLabel;
    lbl_machineb: TLabel;
    edt_IP_B: TEdit;
    lbl_machinec: TLabel;
    edt_IP_C: TEdit;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    BitBtn3: TBitBtn;
    btnConnectA: TButton;
    btnConnectB: TButton;
    btnConnectC: TButton;
    imgConnectA: TImage;
    imgConnectB: TImage;
    imgConnectC: TImage;
    imgDisconnectA: TImage;
    imgDisconnectB: TImage;
    imgDisconnectC: TImage;
    GroupBox1: TGroupBox;
    BitBtn5: TBitBtn;
    dtpDate: TDateTimePicker;
    rbBySpecificTime: TRadioButton;
    dtpTime: TDateTimePicker;
    rbByNow: TRadioButton;
    BitBtn4: TBitBtn;
    SimpleTCPServer1: TSimpleTCPServer;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    chkRetryA: TCheckBox;
    chkRetryB: TCheckBox;
    chkRetryC: TCheckBox;
    timer_datetime_synchronize: TTimer;
    CZKEM_A: TCZKEM;
    CZKEM_B: TCZKEM;
    CZKEM_C: TCZKEM;
    Panel3: TPanel;
    Panel4: TPanel;
    Ping_B: TPing;
    Ping_C: TPing;
    Ping_A: TPing;
    procedure CZKEM_AConnected(Sender: TObject);
    procedure CZKEM_ADisConnected(Sender: TObject);
    procedure CZKEM_AVerify(ASender: TObject; UserID: Integer);
    procedure CZKEM_AFinger(Sender: TObject);
    procedure CZKEM_AAttTransactionEx(ASender: TObject;
      const EnrollNumber: WideString; IsInValid, AttState, VerifyMethod,
      Year, Month, Day, Hour, Minute, Second, WorkCode: Integer);
    procedure CZKEM_AEnrollFingerEx(ASender: TObject;
      const EnrollNumber: WideString; FingerIndex, ActionResult,
      TemplateLength: Integer);
    procedure CZKEM_ANewUser(ASender: TObject; EnrollNumber: Integer);
    procedure CZKEM_BAttTransactionEx(ASender: TObject;
      const EnrollNumber: WideString; IsInValid, AttState, VerifyMethod,
      Year, Month, Day, Hour, Minute, Second, WorkCode: Integer);
    procedure CZKEM_BConnected(Sender: TObject);
    procedure CZKEM_BDisConnected(Sender: TObject);
    procedure CZKEM_BEnrollFingerEx(ASender: TObject;
      const EnrollNumber: WideString; FingerIndex, ActionResult,
      TemplateLength: Integer);
    procedure CZKEM_BFinger(Sender: TObject);
    procedure CZKEM_BNewUser(ASender: TObject; EnrollNumber: Integer);
    procedure CZKEM_BVerify(ASender: TObject; UserID: Integer);
    procedure CZKEM_CAttTransactionEx(ASender: TObject;
      const EnrollNumber: WideString; IsInValid, AttState, VerifyMethod,
      Year, Month, Day, Hour, Minute, Second, WorkCode: Integer);
    procedure CZKEM_CConnected(Sender: TObject);
    procedure CZKEM_CDisConnected(Sender: TObject);
    procedure CZKEM_CEnrollFingerEx(ASender: TObject;
      const EnrollNumber: WideString; FingerIndex, ActionResult,
      TemplateLength: Integer);
    procedure CZKEM_CFinger(Sender: TObject);
    procedure CZKEM_CNewUser(ASender: TObject; EnrollNumber: Integer);
    procedure CZKEM_CVerify(ASender: TObject; UserID: Integer);
    procedure BitBtn3Click(Sender: TObject);
    procedure btnConnectAClick(Sender: TObject);
    procedure btnConnectBClick(Sender: TObject);
    procedure btnConnectCClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure rbBySpecificTimeClick(Sender: TObject);
    procedure rbByNowClick(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SimpleTCPServer1Accept(Sender: TObject;
      Client: TSimpleTCPClient; var Accept: Boolean);
    procedure SimpleTCPServer1ClientConnected(Sender: TObject;
      Client: TSimpleTCPClient);
    procedure SimpleTCPServer1ClientDisconnected(Sender: TObject;
      Client: TSimpleTCPClient);
    procedure SimpleTCPServer1ClientRead(Sender: TObject;
      Client: TSimpleTCPClient; Stream: TStream);
    procedure SimpleTCPServer1Error(Sender: TObject; Socket,
      ErrorCode: Integer; ErrorMsg: String);
    procedure BitBtn1Click(Sender: TObject);
    procedure timer_datetime_synchronizeTimer(Sender: TObject);
    procedure DoConnect_A(Sender: TObject);
    procedure DoConnect_B(Sender: TObject);
    procedure DoConnect_C(Sender: TObject);
    procedure UpdateStatus(MachineNumber:Integer; IsConnected:Boolean);
    procedure SyncDateTime(MachineNumber:Integer);
    procedure Ping_BEchoReply(Sender, Icmp: TObject; Status: Integer);
    procedure Ping_CEchoReply(Sender, Icmp: TObject; Status: Integer);
    procedure Ping_AEchoReply(Sender, Icmp: TObject; Status: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ProcessPaintrequests;
    procedure EnrollUser(enrollnumber:string;username:string;password:string);
    procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings);
    //procedure EnrollTemplate();
  end;

var
  Form1: TForm1;
  MachineNumber_A_IsConnected:Boolean=False;
  MachineNumber_B_IsConnected:Boolean=False;
  MachineNumber_C_IsConnected:Boolean=False;
  MachineNumber_A_IsTrying:Boolean=False;
  MachineNumber_B_IsTrying:Boolean=False;
  MachineNumber_C_IsTrying:Boolean=False;
  MachineNumber_A:integer=1;
  MachineNumber_B:integer=2;
  MachineNumber_C:integer=3;
  MachineName_A:string='Build FingerPrint Machine(A) ';
  MachineName_B:string='InDoor FingerPrint Machine(B) ';
  MachineName_C:string='OutDoor FingerPrint Machine(C) ';
  AttLogDir:string='C:\escs\Attlog\';
  AttLog_AddDir:string='C:\escs\Attlog_add\';
  TAB:Char=Chr(9);
  Thread_A:Integer;
implementation

uses Unit2, Unit3, Unit4, Unit5, splash, Unit6, Unit7, UnitMyThread;

{$R *.dfm}

procedure TForm1.DoConnect_A(Sender: TObject);
begin
  while True do
  begin
    if chkRetryA.Checked then
    begin
      Ping_A.Address:=Trim(edt_IP_A.Text);
      Ping_A.Ping;
      Sleep(2000);
    end;
  end;
end;

procedure TForm1.DoConnect_B(Sender: TObject);
begin
  while True do
  begin
    if chkRetryB.Checked then
    begin
      Ping_B.Address:=Trim(edt_IP_B.Text);
      Ping_B.Ping;
      Sleep(2000);
    end;
  end;
end;

procedure TForm1.DoConnect_C(Sender: TObject);
begin
  while True do
  begin
    if chkRetryC.Checked then
    begin
      Ping_C.Address:=Trim(edt_IP_C.Text);
      Ping_C.Ping;
      Sleep(2000);
    end;
  end;
end;

procedure TForm1.UpdateStatus(MachineNumber:Integer; IsConnected:Boolean);
begin
  case MachineNumber of
    1:
    begin
      if IsConnected then
      begin
        MachineNumber_A_IsConnected:=True;
        btnConnectA.Caption:='Disconnect';
        imgDisconnectA.Visible:=False;
        imgConnectA.Visible:=True;
        lbl_machinea.Font.Color:=clWindowText;
      end
      else
      begin
        MachineNumber_A_IsConnected:=False;
        btnConnectA.Caption:='Connect';
        imgDisconnectA.Visible:=True;
        imgConnectA.Visible:=False;
        Memo1.Lines.Add('====================================================================');
        Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]', Now())+MachineName_A+' Connect Failed!');
        Memo1.Lines.Add('====================================================================');
        lbl_machinea.Font.Color:=clRed;
      end;
    end;
    2:
    begin
      if IsConnected then
      begin
        MachineNumber_B_IsConnected:=True;
        btnConnectB.Caption:='Disconnect';
        imgDisconnectB.Visible:=False;
        imgConnectB.Visible:=True;
        lbl_machineb.Font.Color:=clWindowText;
      end
      else
      begin
        MachineNumber_B_IsConnected:=False;
        btnConnectB.Caption:='Connect';
        imgDisconnectB.Visible:=True;
        imgConnectB.Visible:=False;
        Memo1.Lines.Add('====================================================================');
        Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]', Now())+MachineName_B+' Connect Failed!');
        Memo1.Lines.Add('====================================================================');
        lbl_machineb.Font.Color:=clRed;
      end;
    end;
    3:
    begin
      if IsConnected then
      begin
        MachineNumber_C_IsConnected:=True;
        btnConnectC.Caption:='Disconnect';
        imgDisconnectC.Visible:=False;
        imgConnectC.Visible:=True;
        lbl_machinec.Font.Color:=clWindowText;
      end
      else
      begin
        MachineNumber_C_IsConnected:=False;
        btnConnectC.Caption:='Connect';
        imgDisconnectC.Visible:=True;
        imgConnectC.Visible:=False;
        Memo1.Lines.Add('====================================================================');
        Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]', Now())+MachineName_C+' Connect Failed!');
        Memo1.Lines.Add('====================================================================');
        lbl_machinec.Font.Color:=clRed;
      end;
    end;
  end;
end;

procedure TForm1.SyncDateTime(MachineNumber:Integer);
var
  year,month,day,hour,minute,second,msecond:word;
begin
  if rbBySpecificTime.Checked then
  begin
    DecodeDate(dtpDate.DateTime,year,month,day);
    DecodeTime(dtpTime.Time,hour,minute,second,msecond);
  end
  else if rbByNow.Checked then
  begin
    DecodeDate(Now,year,month,day);
    DecodeTime(Now,hour,minute,second,msecond);
  end;

  case MachineNumber of
    1:
    begin
      if MachineNumber_A_IsConnected then
      begin
        CZKEM_A.SetDeviceTime2(MachineNumber_A,year,month,day,hour,minute,second);
        Memo1.Lines.Add('====================================================================');
        Memo1.Lines.Add(FormatDateTime('yyy/mm/dd hh:nn:ss', Now)+unit1.MachineName_A+'DateTime Synchronize Success!');
        Memo1.Lines.Add('====================================================================');
      end;
    end;
    2:
    begin
      if MachineNumber_B_IsConnected then
      begin
        CZKEM_B.SetDeviceTime2(MachineNumber_A,year,month,day,hour,minute,second);
        Memo1.Lines.Add('====================================================================');
        Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]', Now())+unit1.MachineName_B+'DateTime Synchronize Success!');
        Memo1.Lines.Add('====================================================================');
      end;
    end;
    3:
    begin
      if MachineNumber_C_IsConnected then
      begin
        CZKEM_C.SetDeviceTime2(MachineNumber_A,year,month,day,hour,minute,second);
        Memo1.Lines.Add('====================================================================');
        Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]', Now())+unit1.MachineName_C+'DateTime Synchronize Success!');
        Memo1.Lines.Add('====================================================================');
      end;
    end;
  end;
end;

procedure TForm1.Split(Delimiter: Char; Str: string; ListOfStrings: TStrings);
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter:=Delimiter;
   ListOfStrings.DelimitedText:=Str;
end;

procedure TForm1.ProcessPaintrequests;
var
  msg: TMsg;
begin
  while PeekMessage(msg, 0, WM_PAINT, WM_PAINT, PM_REMOVE) do
    DispatchMessage(msg);
end;

procedure TForm1.EnrollUser(enrollnumber:string;username:string;password:string);
begin
  Form2.edt_EnrollNumber.Text:=enrollnumber;
  Form2.edt_UserName.Text:=username;
  Form2.edt_Password.Text:=password;
  Form2.edt_EnrollNumber.Enabled:=false;
  Form2.ShowModal;
end;

procedure TForm1.CZKEM_AConnected(Sender: TObject);
var regReturn:Boolean;
begin
  Memo1.Lines.Add('====================================================================');
  MachineNumber_A_IsConnected:=True;
  regReturn:=CZKEM_A.RegEvent(MachineNumber_A,65535);
  if regReturn then Memo1.Lines.Add(MachineName_A+' RegEvent Success !') else Memo1.Lines.Add(MachineName_A+' RegEvent Failed !');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_A+'Connected!');
  Memo1.Lines.Add('====================================================================');
end;

procedure TForm1.CZKEM_ADisConnected(Sender: TObject);
begin
  Memo1.Lines.Add('====================================================================');
  MachineNumber_A_IsConnected:=False;
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_A+'Disconnected!');
  Memo1.Lines.Add('====================================================================');
end;

procedure TForm1.CZKEM_AVerify(ASender: TObject; UserID: Integer);
var
  filename,tempstring:string;
  outfile:TextFile;
begin
  Memo1.Lines.Add('====================================================================');
  memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_A+'OnVerify');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_A+'UserID='+inttostr(UserID));
  Memo1.Lines.Add('====================================================================');
  {
  if UserID < 0 then
  begin
    try
      //=====================================================================================================================
      //產生比對失敗的Log
      //=====================================================================================================================
      filename:=FormatDateTime('yyyymmddhhnnss', Now)+'.txt';
      AssignFile(outfile, AttLogDir+filename);
      ReWrite(outfile);
      tempstring:='R' + TAB + 'N' + TAB + Trim(edt_IP_A.Text) + TAB + FormatDateTime('yyyy/mm/dd hh:nn:ss',Now) + TAB + 'Verify' + TAB + 'Error';
      WriteLn(outfile, tempstring);
      //=====================================================================================================================
    finally
      CloseFile(outfile);
    end;
  end;
  }
end;

procedure TForm1.CZKEM_AFinger(Sender: TObject);
begin
  Memo1.Lines.Add('====================================================================');
  memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+'OnFinger');
  Memo1.Lines.Add('====================================================================');
end;

procedure TForm1.CZKEM_AAttTransactionEx(ASender: TObject;
  const EnrollNumber: WideString; IsInValid, AttState, VerifyMethod, Year,
  Month, Day, Hour, Minute, Second, WorkCode: Integer);
var
  actiontime:TDateTime;
  outfile:TextFile;
  filename:string;
  tempstring:string;
begin
  Memo1.Lines.Add('====================================================================');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_A+'OnAttTransactionEx');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_A+'EnrollNumber='+EnrollNumber);
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_A+'IsInValid='+inttostr(IsInValid));
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_A+'AttState='+inttostr(AttState));
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_A+'VerifyMethod='+inttostr(VerifyMethod));
  actiontime:=EncodeDateTime(Year,Month,Day,Hour,Minute,Second,0);
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_A+'ActionTime='+DateTimeToStr(actiontime));
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_A+'WorkCode='+inttostr(WorkCode));
  Memo1.Lines.Add('====================================================================');
  try
    filename:=FormatDateTime('yyyymmddhhnnss', actiontime)+'.txt';
    AssignFile(outfile, AttLogDir+filename);
    ReWrite(outfile);
    tempstring:='R' + TAB + 'C' + TAB + Trim(edt_IP_A.Text) + TAB + EnrollNumber + TAB + FormatDateTime('yyyy/mm/dd hh:nn:ss',actiontime) + TAB + 'OK';
    WriteLn(outfile, tempstring);
  finally
    CloseFile(outfile);
  end;
end;

procedure TForm1.CZKEM_AEnrollFingerEx(ASender: TObject;
  const EnrollNumber: WideString; FingerIndex, ActionResult,
  TemplateLength: Integer);
var
  TmpData:WideString;
  TmpLength:Integer;
  Flag:Integer;
  sql:string;
  cursor:TCursor;
  outfile,outfile2:TextFile;
  filename,tempstring:string;
  Privilege:Integer;
  Is_UserEnroll_Sucess_B,Is_UserEnroll_Sucess_C:Boolean;
begin
  Memo1.Lines.Add('====================================================================');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_A+'OnEnrollFingerEx Trigger');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_A+'EnrollNumber='+EnrollNumber);
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_A+'FingerIndex='+inttostr(FingerIndex));
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_A+'Privilege='+form2.cb_Privilege.Text);
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_A+'ActionResult='+inttostr(ActionResult));
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_A+'TemplateLength='+inttostr(TemplateLength));
  Memo1.Lines.Add('====================================================================');
  Privilege:=StrToInt(Copy(Form2.cb_Privilege.Text,1,1));
  Privilege:=0;
  //新增或修改成功
  if ActionResult = 0 then
  begin
    try
      cursor:=screen.Cursor;
      Screen.Cursor := crHourGlass;
      //=====================================================================================================================
      //將建檔指紋機(A)的使用者名稱、密碼更新
      //=====================================================================================================================
      CZKEM_A.CancelOperation();
      CZKEM_A.EnableDevice(MachineNumber_A,False);
      //設定建檔指紋使用者名稱、密碼
      CZKEM_A.SSR_SetUserInfo(MachineNumber_A, EnrollNumber, Trim(Form2.edt_UserName.Text), Trim(Form2.edt_Password.Text), Privilege, True);
      CZKEM_A.RefreshData(MachineNumber_A);
      //將資料使用者及指紋資料讀至記憶體
      CZKEM_A.ReadAllUserID(MachineNumber_A);
      CZKEM_A.ReadAllTemplate(MachineNumber_A);
      //取得建檔指紋資料
      CZKEM_A.GetUserTmpExStr(MachineNumber_A, EnrollNumber, FingerIndex, Flag, TmpData, TmpLength);
      CZKEM_A.EnableDevice(MachineNumber_A,True);
      //=====================================================================================================================

      //=====================================================================================================================
      //新增到Access資料庫
      //=====================================================================================================================
      if Trim(EnrollNumber) <> '' then
      begin
        sql:='DELETE FROM UserInfo WHERE EnrollNumber='+quotedstr(EnrollNumber);
        Adoquery1.SQL.Clear;
        ADOQuery1.SQL.Add(sql);
        ADOQuery1.ExecSQL;
        sql:='INSERT INTO UserInfo([EnrollNumber],[UserName],[Password],[Privilege],[CreateDate]) VALUES(:EnrollNumber,:UserName,:Password,:Privilege,:CreateDate)';
        ADOQuery1.SQL.Clear;
        ADOQuery1.SQL.Add(sql);
        ADOQuery1.Parameters.ParamByName('EnrollNumber').Value:=EnrollNumber;
        ADOQuery1.Parameters.ParamByName('UserName').Value:=Trim(Form2.edt_UserName.Text);
        ADOQuery1.Parameters.ParamByName('Password').Value:=Trim(Form2.edt_Password.Text);
        ADOQuery1.Parameters.ParamByName('Privilege').Value:=Privilege;
        ADOQuery1.Parameters.ParamByName('CreateDate').Value:=Now();
        ADOQuery1.ExecSQL;
        sql:='DELETE FROM UserTemplate WHERE EnrollNumber=:EnrollNumber AND FingerIndex=:FingerIndex';
        ADOQuery1.SQL.Clear;
        ADOQuery1.SQL.Add(sql);
        ADOQuery1.Parameters.ParamByName('EnrollNumber').Value:=EnrollNumber;
        ADOQuery1.Parameters.ParamByName('FingerIndex').Value:=FingerIndex;
        ADOQuery1.ExecSQL;
        sql:='INSERT INTO UserTemplate([EnrollNumber],[FingerIndex],[TmpData],[CreateDate]) VALUES(:EnrollNumber,:FingerIndex,:TmpData,:CreateDate)';
        ADOQuery1.SQL.Clear;
        ADOQuery1.SQL.Add(sql);
        ADOQuery1.Parameters.ParamByName('EnrollNumber').Value:=EnrollNumber;
        ADOQuery1.Parameters.ParamByName('FingerIndex').Value:=FingerIndex;
        ADOQuery1.Parameters.ParamByName('TmpData').Value:=TmpData;
        ADOQuery1.Parameters.ParamByName('CreateDate').Value:=Now();
        ADOQuery1.ExecSQL;
      end;

      //=====================================================================================================================
      //將使用者資料及指紋資料送到入口指紋機(B)
      //=====================================================================================================================
      if MachineNumber_B_IsConnected then
      begin
        //將資料建在入口指紋機(B)
        CZKEM_B.CancelOperation();
        CZKEM_B.SSR_DelUserTmpExt(MachineNumber_B, EnrollNumber, FingerIndex);
        CZKEM_B.EnableDevice(MachineNumber_B,False);
        //將使用者資料新增到入口指紋機
        Is_UserEnroll_Sucess_B:=CZKEM_B.SSR_SetUserInfo(MachineNumber_B, EnrollNumber, Trim(Form2.edt_UserName.Text), Trim(Form2.edt_Password.Text), Privilege, True);
        //將使用者指紋新增到入口指紋機
        Is_UserEnroll_Sucess_B:=CZKEM_B.SetUserTmpExStr(MachineNumber_B, EnrollNumber, FingerIndex, Flag, TmpData);
        CZKEM_B.RefreshData(MachineNumber_B);
        CZKEM_B.EnableDevice(MachineNumber_B,True);
      end;
      //=====================================================================================================================

      //=====================================================================================================================
      //將使用者資料及指紋資料送到出口指紋機(C)
      //=====================================================================================================================
      if MachineNumber_C_IsConnected then
      begin
        //將資料建在出口指紋機(C)
        CZKEM_C.CancelOperation();
        CZKEM_C.SSR_DelUserTmpExt(MachineNumber_B, EnrollNumber, FingerIndex);
        CZKEM_C.EnableDevice(MachineNumber_C,False);
        //將使用者資料新增到出口指紋機
        Is_UserEnroll_Sucess_C:=CZKEM_C.SSR_SetUserInfo(MachineNumber_C, EnrollNumber, Trim(Form2.edt_UserName.Text), Trim(Form2.edt_Password.Text), Privilege, True);
        //將使用者指紋新增到出口指紋機
        Is_UserEnroll_Sucess_C:=CZKEM_C.SetUserTmpExStr(MachineNumber_C, EnrollNumber, FingerIndex, Flag, TmpData);
        CZKEM_C.RefreshData(MachineNumber_C);
        CZKEM_C.EnableDevice(MachineNumber_C,True);
      end;
      //=====================================================================================================================

      //=====================================================================================================================
      //產生成功的Log
      //=====================================================================================================================
      filename:=FormatDateTime('yyyymmddhhnnss', Now)+'.txt';
      tempstring:='R' + TAB + 'B' + TAB + Trim(edt_IP_A.Text) + TAB + EnrollNumber + TAB + FormatDateTime('yyyy/mm/dd hh:nn:ss',Now) + TAB + 'UserEnroll' + TAB + 'OK';
      AssignFile(outfile, AttLogDir+filename);
      ReWrite(outfile);
      WriteLn(outfile, tempstring);
      AssignFile(outfile2, AttLog_AddDir+filename);
      ReWrite(outfile2);
      WriteLn(outfile2, tempstring);
      //=====================================================================================================================
    finally
      Screen.Cursor := cursor;
      CloseFile(outfile);
      CloseFile(outfile2);
      Form7.Close;
    end;
    Form2.Memo1.Lines.Add('New/Modify User Completed');
  end
  else
  begin
    try
      //=====================================================================================================================
      //產生失敗的Log
      //=====================================================================================================================
      filename:=FormatDateTime('yyyymmddhhnnss', Now)+'.txt';
      tempstring:='R' + TAB + 'E' + TAB + Trim(edt_IP_A.Text) + TAB + EnrollNumber + TAB + FormatDateTime('yyyy/mm/dd hh:nn:ss',Now) + TAB + 'UserEnroll' + TAB + 'Error';
      AssignFile(outfile, AttLogDir+filename);
      ReWrite(outfile);
      WriteLn(outfile, tempstring);
      AssignFile(outfile2, AttLog_AddDir+filename);
      ReWrite(outfile2);
      WriteLn(outfile2, tempstring);
      //=====================================================================================================================
    finally
      Screen.Cursor := cursor;
      CloseFile(outfile);
      CloseFile(outfile2);
      Form7.Close;
    end;
    Form2.Memo1.Lines.Add(FormatDateTime('yyyy/mm/dd hh:nn:ss',Now)+' New/Modify User Failed');
    MessageDlg(FormatDateTime('yyyy/mm/dd hh:nn:ss',Now)+' UserEnroll Error !',mtError,[mbok],0);
  end;

  //顯示註開結果
  if (Is_UserEnroll_Sucess_B) then
    MessageDlg(FormatDateTime('yyyy/mm/dd hh:nn:ss ',Now)+MachineName_B+' UserEnroll Success !',mtInformation,[mbok],0)
  else
    MessageDlg(FormatDateTime('yyyy/mm/dd hh:nn:ss ',Now)+MachineName_B+' UserEnroll Failed !',mtError,[mbok],0);
  if (Is_UserEnroll_Sucess_C) then
    MessageDlg(FormatDateTime('yyyy/mm/dd hh:nn:ss ',Now)+MachineName_C+' UserEnroll Success !',mtInformation,[mbok],0)
  else
    MessageDlg(FormatDateTime('yyyy/mm/dd hh:nn:ss ',Now)+MachineName_C+' UserEnroll Failed !',mtError,[mbok],0);

end;

procedure TForm1.CZKEM_ANewUser(ASender: TObject; EnrollNumber: Integer);
begin
  Memo1.Lines.Add('====================================================================');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_A+'OnNewUser Trigger');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_A+'EnrollNumber='+inttostr(EnrollNumber));
  Memo1.Lines.Add('====================================================================');
end;

procedure TForm1.CZKEM_BAttTransactionEx(ASender: TObject;
  const EnrollNumber: WideString; IsInValid, AttState, VerifyMethod, Year,
  Month, Day, Hour, Minute, Second, WorkCode: Integer);
var
  actiontime:TDateTime;
  outfile:TextFile;
  filename:string;
  tempstring:string;
begin
  Memo1.Lines.Add('====================================================================');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_B+'OnAttTransactionEx');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_B+'EnrollNumber='+EnrollNumber);
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_B+'IsInValid='+inttostr(IsInValid));
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_B+'AttState='+inttostr(AttState));
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_B+'VerifyMethod='+inttostr(VerifyMethod));
  actiontime:=EncodeDateTime(Year,Month,Day,Hour,Minute,Second,0);
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_B+'ActionTime='+DateTimeToStr(actiontime));
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_B+'WorkCode='+inttostr(WorkCode));
  Memo1.Lines.Add('====================================================================');
  try
    filename:=FormatDateTime('yyyymmddhhnnss', actiontime)+'.txt';
    AssignFile(outfile, AttLogDir+filename);
    ReWrite(outfile);
    tempstring:='R' + TAB + 'C' + TAB + Trim(edt_IP_B.Text) + TAB + EnrollNumber + TAB + FormatDateTime('yyyy/mm/dd hh:nn:ss',actiontime) + TAB + 'OK';
    WriteLn(outfile, tempstring);
  finally
    CloseFile(outfile);
  end;
end;

procedure TForm1.CZKEM_BConnected(Sender: TObject);
var regReturn:Boolean;
begin
  Memo1.Lines.Add('====================================================================');
  MachineNumber_B_IsConnected:=True;
  CZKEM_B.RegEvent(MachineNumber_B,65535);
  regReturn:=CZKEM_B.RegEvent(MachineNumber_B,65535);
  if regReturn then Memo1.Lines.Add(MachineName_B+' RegEvent Success !') else Memo1.Lines.Add(MachineName_B+' RegEvent Failed !');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_B+'Connected!');
  Memo1.Lines.Add('====================================================================');
end;

procedure TForm1.CZKEM_BDisConnected(Sender: TObject);
begin
  Memo1.Lines.Add('====================================================================');
  MachineNumber_B_IsConnected:=False;
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_B+'Disconnected!');
  Memo1.Lines.Add('====================================================================');
end;

procedure TForm1.CZKEM_BEnrollFingerEx(ASender: TObject;
  const EnrollNumber: WideString; FingerIndex, ActionResult,
  TemplateLength: Integer);
begin
  Memo1.Lines.Add('====================================================================');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_B+'OnEnrollFingerEx Trigger');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_B+'EnrollNumber='+EnrollNumber);
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_B+'FingerIndex='+inttostr(FingerIndex));
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_B+'ActionResult='+inttostr(ActionResult));
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_B+'TemplateLength='+inttostr(TemplateLength));
  Memo1.Lines.Add('====================================================================');
end;

procedure TForm1.CZKEM_BFinger(Sender: TObject);
begin
  Memo1.Lines.Add('====================================================================');
  memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_B+'OnFinger');
  Memo1.Lines.Add('====================================================================');
end;

procedure TForm1.CZKEM_BNewUser(ASender: TObject; EnrollNumber: Integer);
begin
  Memo1.Lines.Add('====================================================================');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_B+'OnNewUser Trigger');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_B+'EnrollNumber='+inttostr(EnrollNumber));
  Memo1.Lines.Add('====================================================================');
end;

procedure TForm1.CZKEM_BVerify(ASender: TObject; UserID: Integer);
var
  filename,tempstring:string;
  outfile:TextFile;
begin
  Memo1.Lines.Add('====================================================================');
  memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_B+'OnVerify');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_B+'UserID='+inttostr(UserID));
  Memo1.Lines.Add('====================================================================');
  {
  if UserID < 0 then
  begin
    try
      //=====================================================================================================================
      //產生比對失敗的Log
      //=====================================================================================================================
      filename:=FormatDateTime('yyyymmddhhnnss', Now)+'.txt';
      AssignFile(outfile, AttLogDir+filename);
      ReWrite(outfile);
      tempstring:='R' + TAB + 'N' + TAB + Trim(edt_IP_B.Text) + TAB + FormatDateTime('yyyy/mm/dd hh:nn:ss',Now) + TAB + 'Verify' + TAB + 'Error';
      WriteLn(outfile, tempstring);
      //=====================================================================================================================
    finally
      CloseFile(outfile);
    end;
  end;
  }
end;

procedure TForm1.CZKEM_CAttTransactionEx(ASender: TObject;
  const EnrollNumber: WideString; IsInValid, AttState, VerifyMethod, Year,
  Month, Day, Hour, Minute, Second, WorkCode: Integer);
var
  actiontime:TDateTime;
  outfile:TextFile;
  filename:string;
  tempstring:string;
begin
  Memo1.Lines.Add('====================================================================');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_C+'OnAttTransactionEx');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_C+'EnrollNumber='+EnrollNumber);
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_C+'IsInValid='+inttostr(IsInValid));
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_C+'AttState='+inttostr(AttState));
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_C+'VerifyMethod='+inttostr(VerifyMethod));
  actiontime:=EncodeDateTime(Year,Month,Day,Hour,Minute,Second,0);
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_C+'ActionTime='+DateTimeToStr(actiontime));
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_C+'WorkCode='+inttostr(WorkCode));
  Memo1.Lines.Add('====================================================================');
  try
    filename:=FormatDateTime('yyyymmddhhnnss', actiontime)+'.txt';
    AssignFile(outfile, AttLogDir+filename);
    ReWrite(outfile);
    tempstring:='R' + TAB + 'C' + TAB + Trim(edt_IP_C.Text) + TAB + EnrollNumber + TAB + FormatDateTime('yyyy/mm/dd hh:nn:ss',actiontime) + TAB + 'OK';
    WriteLn(outfile, tempstring);
  finally
    CloseFile(outfile);
  end;
end;

procedure TForm1.CZKEM_CConnected(Sender: TObject);
var regReturn:Boolean;
begin
  Memo1.Lines.Add('====================================================================');
  MachineNumber_C_IsConnected:=True;
  regReturn:=CZKEM_C.RegEvent(MachineNumber_C,65535);
  if regReturn then Memo1.Lines.Add(MachineName_C+' RegEvent Success !') else Memo1.Lines.Add(MachineName_C+' RegEvent Failed !');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_C+'Connected!');
  Memo1.Lines.Add('====================================================================');
end;

procedure TForm1.CZKEM_CDisConnected(Sender: TObject);
begin
  Memo1.Lines.Add('====================================================================');
  MachineNumber_C_IsConnected:=False;
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_C+'Disconnected!');
  Memo1.Lines.Add('====================================================================');
end;

procedure TForm1.CZKEM_CEnrollFingerEx(ASender: TObject;
  const EnrollNumber: WideString; FingerIndex, ActionResult,
  TemplateLength: Integer);
begin
  Memo1.Lines.Add('====================================================================');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_C+'OnEnrollFingerEx Trigger');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_C+'EnrollNumber='+EnrollNumber);
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_C+'FingerIndex='+inttostr(FingerIndex));
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_C+'ActionResult='+inttostr(ActionResult));
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_C+'TemplateLength='+inttostr(TemplateLength));
  Memo1.Lines.Add('====================================================================');
end;

procedure TForm1.CZKEM_CFinger(Sender: TObject);
begin
  Memo1.Lines.Add('====================================================================');
  memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_C+'OnFinger');
  Memo1.Lines.Add('====================================================================');
end;

procedure TForm1.CZKEM_CNewUser(ASender: TObject; EnrollNumber: Integer);
begin
  Memo1.Lines.Add('====================================================================');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_C+'OnNewUser Trigger');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_C+'EnrollNumber='+inttostr(EnrollNumber));
  Memo1.Lines.Add('====================================================================');
end;

procedure TForm1.CZKEM_CVerify(ASender: TObject; UserID: Integer);
var
  filename,tempstring:string;
  outfile:TextFile;
begin
  Memo1.Lines.Add('====================================================================');
  memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_C+'OnVerify');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]  ', Now())+MachineName_C+'UserID='+inttostr(UserID));
  Memo1.Lines.Add('====================================================================');
  {
  if UserID < 0 then
  begin
    try
      //=====================================================================================================================
      //產生比對失敗的Log
      //=====================================================================================================================
      filename:=FormatDateTime('yyyymmddhhnnss', Now)+'.txt';
      AssignFile(outfile, AttLogDir+filename);
      ReWrite(outfile);
      tempstring:='R' + TAB + 'N' + TAB + Trim(edt_IP_C.Text) + TAB + FormatDateTime('yyyy/mm/dd hh:nn:ss',Now) + TAB + 'Verify' + TAB + 'Error';
      WriteLn(outfile, tempstring);
      //=====================================================================================================================
    finally
      CloseFile(outfile);
    end;
  end;
  }
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
  Form5.ShowModal;
end;

procedure TForm1.btnConnectAClick(Sender: TObject);
var
  isConnected:Boolean;
  i:integer;
begin
  cursor:=screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    if MachineNumber_A_IsConnected then
    begin
      SplashForm.lblMessage.Caption:='Disconnecting '+MachineName_A+'........';
      SplashForm.Show;
      ProcessPaintrequests;
      CZKEM_A.Disconnect;
      btnConnectA.Caption:='Connect';
      imgDisconnectA.Visible:=True;
      imgConnectA.Visible:=False;
      MachineNumber_A_IsConnected:=false;
    end
    else
    begin
      try
        SplashForm.lblMessage.Caption:='Connecting '+MachineName_A+'........trying';
        SplashForm.Show;
        ProcessPaintrequests;
        isConnected:=CZKEM_A.Connect_Net(Trim(edt_IP_A.Text), 4370);
      finally
        SplashForm.Close;
      end;
      if isConnected then
      begin
        MachineNumber_A_IsConnected:=True;
        CZKEM_A.RegEvent(MachineNumber_A,65535);
        btnConnectA.Caption:='Disconnect';
        imgDisconnectA.Visible:=False;
        imgConnectA.Visible:=True;
        lbl_machinea.Font.Color:=clWindowText;
      end
      else
      begin
        MachineNumber_A_IsConnected:=False;
        imgDisconnectA.Visible:=True;
        imgConnectA.Visible:=False;
        Memo1.Lines.Add('====================================================================');
        Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]', Now())+MachineName_A+' Connect Failed!');
        Memo1.Lines.Add('====================================================================');
        lbl_machinea.Font.Color:=clRed;
        MessageDlg('Connecting '+MachineName_A+' Failed !',mtError, [mbOK], 0);
      end;
    end;
  finally
    SplashForm.Close;
    Screen.Cursor:=cursor;
  end;
  UpdateStatus(MachineNumber_A, MachineNumber_A_IsConnected);
end;

procedure TForm1.btnConnectBClick(Sender: TObject);
var
  isConnected:Boolean;
  i:integer;
begin
  cursor:=screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    if MachineNumber_B_IsConnected then
    begin
      SplashForm.lblMessage.Caption:='Disconnecting '+MachineName_B+'........';
      SplashForm.Show;
      ProcessPaintrequests;
      CZKEM_B.Disconnect;
      btnConnectB.Caption:='Connect';
      imgDisconnectB.Visible:=True;
      imgConnectB.Visible:=False;
      MachineNumber_B_IsConnected:=false;
    end
    else
    begin
      try
        SplashForm.lblMessage.Caption:='Connecting '+MachineName_B+'........trying';
        SplashForm.Show;
        ProcessPaintrequests;
        isConnected:=CZKEM_B.Connect_Net(Trim(edt_IP_B.Text), 4370);
      finally
        SplashForm.Close;
      end;
      if isConnected then
      begin
        MachineNumber_B_IsConnected:=True;
        CZKEM_B.RegEvent(MachineNumber_B,65535);
        btnConnectB.Caption:='Disconnect';
        imgDisconnectB.Visible:=False;
        imgConnectB.Visible:=True;
        lbl_machineb.Font.Color:=clWindowText;
      end
      else
      begin
        MachineNumber_B_IsConnected:=False;
        imgDisconnectB.Visible:=True;
        imgConnectB.Visible:=False;
        Memo1.Lines.Add('====================================================================');
        Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]', Now())+MachineName_B+' Connect Failed!');
        Memo1.Lines.Add('====================================================================');
        lbl_machineb.Font.Color:=clRed;
        MessageDlg('Connecting '+MachineName_B+' Failed !',mtError, [mbOK], 0);
      end;
    end;
  finally
    SplashForm.Close;
    Screen.Cursor:=cursor;
  end;
  UpdateStatus(MachineNumber_B, MachineNumber_B_IsConnected);
end;

procedure TForm1.btnConnectCClick(Sender: TObject);
var
  isConnected:Boolean;
  i:integer;
begin
  cursor:=screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    if MachineNumber_C_IsConnected then
    begin
      SplashForm.lblMessage.Caption:='Disconnecting '+MachineName_C+'........';
      SplashForm.Show;
      ProcessPaintrequests;
      CZKEM_C.Disconnect;
      btnConnectC.Caption:='Connect';
      imgDisconnectC.Visible:=True;
      imgConnectC.Visible:=False;
      MachineNumber_C_IsConnected:=false;
    end
    else
    begin
      try
        SplashForm.lblMessage.Caption:='Connecting '+MachineName_C+'........trying';
        SplashForm.Show;
        ProcessPaintrequests;
        isConnected:=CZKEM_C.Connect_Net(Trim(edt_IP_C.Text), 4370);
      finally
        SplashForm.Close;
      end;
      if isConnected then
      begin
        MachineNumber_C_IsConnected:=True;
        CZKEM_C.RegEvent(MachineNumber_C,65535);
        btnConnectC.Caption:='Disconnect';
        imgDisconnectC.Visible:=False;
        imgConnectC.Visible:=True;
        lbl_machinec.Font.Color:=clWindowText;
      end
      else
      begin
        MachineNumber_C_IsConnected:=False;
        imgDisconnectC.Visible:=True;
        imgConnectC.Visible:=False;
        Memo1.Lines.Add('====================================================================');
        Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]', Now())+MachineName_C+' Connect Failed!');
        Memo1.Lines.Add('====================================================================');
        lbl_machinec.Font.Color:=clRed;
        MessageDlg('Connecting '+MachineName_C+' Failed !',mtError, [mbOK], 0);
      end;
    end;
  finally
    SplashForm.Close;
    Screen.Cursor:=cursor;
  end;
  UpdateStatus(MachineNumber_C, MachineNumber_C_IsConnected);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  //Debug用
  //edt_IP_A.Text:='10.10.10.200';
  //btnConnectA.Click;
  //btnConnectA.Enabled:=False;
  //edt_IP_B.Text:='10.10.10.201';
  //btnConnectB.Click;
  //btnConnectB.Enabled:=False;
  //edt_IP_C.Text:='10.10.10.202';
  //btnConnectC.Click;
  //btnConnectC.Enabled:=False;

  //設定MachineNumber
  CZKEM_A.MachineNumber:=MachineNumber_A;
  CZKEM_B.MachineNumber:=MachineNumber_B;
  CZKEM_C.MachineNumber:=MachineNumber_C;

  //預設為目前的日期、時間
  dtpDate.DateTime:=Now;
  dtpTime.Time:=Now;

  //啟動TCPServer等候指令
  SimpleTCPServer1.Listen:=True;
  if SimpleTCPServer1.Listen then
  begin
    Memo1.Lines.Add('Server ready!  LocalIP='+SimpleTCPServer1.LocalIP+', Port='+inttostr(SimpleTCPServer1.Port));
  end
  else
  begin
    Memo1.Lines.Add('Server shutdown');
  end;

  //產生執行緒
  MyThread(DoConnect_A,nil);
  MyThread(DoConnect_B,nil);
  MyThread(DoConnect_C,nil);
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TForm1.rbBySpecificTimeClick(Sender: TObject);
begin
  dtpDate.Enabled:=true;
  dtpTime.Enabled:=true;
end;

procedure TForm1.rbByNowClick(Sender: TObject);
begin
  dtpDate.Enabled:=false;
  dtpTime.Enabled:=false;
end;

procedure TForm1.BitBtn5Click(Sender: TObject);
begin
  SyncDateTime(1);
  SyncDateTime(2);
  SyncDateTime(3);
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if MessageBox(0, 'Do you really want close FingerPrint Program ?', 'FingerPrint Program', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2 + MB_TASKMODAL) = IDYES then
  begin
    try
      if MachineNumber_A_IsConnected then CZKEM_A.Disconnect;
      if MachineNumber_B_IsConnected then CZKEM_B.Disconnect;
      if MachineNumber_C_IsConnected then CZKEM_C.Disconnect;
      Application.Terminate;
    except
      Application.Terminate;
    end;
  end
  else
  begin
    Abort;
  end;
end;

procedure TForm1.SimpleTCPServer1Accept(Sender: TObject;
  Client: TSimpleTCPClient; var Accept: Boolean);
begin
  Memo1.Lines.Add('====================================================================');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]', Now())+'Client Accepted:  (' + Client.Host + ')');
  Memo1.Lines.Add('====================================================================');
end;

procedure TForm1.SimpleTCPServer1ClientConnected(Sender: TObject;
  Client: TSimpleTCPClient);
begin
  Memo1.Lines.Add('====================================================================');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]', Now())+'Client  (' + Client.Host + ') connected to server');
  Memo1.Lines.Add('====================================================================');
end;

procedure TForm1.SimpleTCPServer1ClientDisconnected(Sender: TObject;
  Client: TSimpleTCPClient);
begin
  Memo1.Lines.Add('====================================================================');
  Memo1.Lines.Add(FormatDateTime('[yyyy/mm/dd hh:nn:ss]', Now())+'Client (' + Client.Host + ') disconnected from server.');
  Memo1.Lines.Add('====================================================================');
end;

procedure TForm1.SimpleTCPServer1ClientRead(Sender: TObject;
  Client: TSimpleTCPClient; Stream: TStream);
var
  str:string;
  command:TStringList;
begin
  with Stream as TMemoryStream do
  begin
    SetLength(str, Size);
    Read(str[1], Size);
  end;
  command:=TStringList.Create;
  Split(',',str,command);
  Memo1.Lines.Add('Data received from socket ' + IntToStr(Client.Socket) + ' (' + Client.Host + ') Command='+command[0]);

  case AnsiIndexText(command[0], ['ADD','DELETE']) of
    0: //ADD
    begin
      Form2.edt_EnrollNumber.Text:=command[1];
      Form2.edt_UserName.Text:=command[2];
      Form2.edt_Password.Text:=command[3];
      Form2.edt_Repassword.Text:=command[3];
      Form2.cb_FingerIndex.Text:=command[4];
      Form2.Show;
      Form2.btnNewUser.Click;
      Form2.Close;
    end;
    1: //DELETE
    begin
      Form3.Show;
      Form3.edtEnrollNumber.Text:=command[1];
      Form3.btnDeleteUser.Click;
      Form3.Close;
    end;
  end;
end;

procedure TForm1.SimpleTCPServer1Error(Sender: TObject; Socket,
  ErrorCode: Integer; ErrorMsg: String);
begin
  Memo1.Lines.Add('ERROR: ' + ErrorMsg);
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  Form6.ShowModal;
end;

procedure TForm1.timer_datetime_synchronizeTimer(Sender: TObject);
begin
  BitBtn5.Click;
end;

procedure TForm1.Ping_AEchoReply(Sender, Icmp: TObject; Status: Integer);
begin
  //Success
  if Status <> 0 then
  begin
    if (MachineNumber_A_IsConnected = False) then
    begin
      if CZKEM_A.Connect_Net(Trim(edt_IP_A.Text), 4370) then
      begin
        MachineNumber_A_IsConnected:=True;
        SyncDateTime(MachineNumber_A);
      end
      else
      begin
        MachineNumber_A_IsConnected:=False;
      end;
    end;
  end
  //Failed
  else
  begin
    MachineNumber_A_IsConnected:=False;
  end;
  UpdateStatus(MachineNumber_A, MachineNumber_A_IsConnected);
  Memo1.Refresh;
end;

procedure TForm1.Ping_BEchoReply(Sender, Icmp: TObject; Status: Integer);
begin
  //Success
  if Status <> 0 then
  begin
    if (MachineNumber_B_IsConnected = False) then
    begin
      if CZKEM_B.Connect_Net(Trim(edt_IP_B.Text), 4370) then
      begin
        MachineNumber_B_IsConnected:=True;
        SyncDateTime(MachineNumber_B);
      end
      else
      begin
        MachineNumber_B_IsConnected:=False;
      end;
    end;
  end
  //Failed
  else
  begin
    MachineNumber_B_IsConnected:=False;
  end;
  UpdateStatus(MachineNumber_B, MachineNumber_B_IsConnected);
end;

procedure TForm1.Ping_CEchoReply(Sender, Icmp: TObject; Status: Integer);
begin
  //Success
  if Status <> 0 then
  begin
    if (MachineNumber_C_IsConnected = False) then
    begin
      if CZKEM_C.Connect_Net(Trim(edt_IP_C.Text), 4370) then
      begin
        MachineNumber_C_IsConnected:=True;
        SyncDateTime(MachineNumber_C);
      end
      else
      begin
        MachineNumber_C_IsConnected:=False;
      end;
    end;
  end
  //Failed
  else
  begin
    MachineNumber_C_IsConnected:=False;
  end;
  UpdateStatus(MachineNumber_C, MachineNumber_C_IsConnected);
end;


end.
