unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, Grids, DBGrids, StdCtrls, ExtCtrls, Buttons, Mask;

type
  TForm3 = class(TForm)
    ADOTable1: TADOTable;
    DataSource1: TDataSource;
    ADOTable2: TADOTable;
    DataSource2: TDataSource;
    Panel1: TPanel;
    Panel2: TPanel;
    dbgUserInfo: TDBGrid;
    dbgUserTemplate: TDBGrid;
    btnDeleteUser: TBitBtn;
    btnDeleteFP: TBitBtn;
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edtUserName: TEdit;
    btnCancel: TBitBtn;
    Memo1: TMemo;
    edtEnrollNumber: TMaskEdit;
    procedure btnDeleteUserClick(Sender: TObject);
    procedure btnDeleteFPClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtEnrollNumberKeyPress(Sender: TObject; var Key: Char);
    procedure edtUserNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses Unit1, Unit2;

{$R *.dfm}

procedure TForm3.btnDeleteUserClick(Sender: TObject);
var
  EnrollNumber,UserName:WideString;
  ErrorCode:Integer;
  FingerIndex:Integer;
  filename,tempstring:string;
  outfile,outfile2:TextFile;
begin
  EnrollNumber:=Trim(edtEnrollNumber.Text);
  cursor:=screen.Cursor;
  Screen.Cursor := crHourGlass;
  //=====================================================================================================================
  //從建檔指紋機(A)將使用者資料刪除
  //=====================================================================================================================
  if Unit1.MachineNumber_A_IsConnected then
  begin
    if Form1.CZKEM_A.SSR_DeleteEnrollData(Unit1.MachineNumber_A, EnrollNumber, 12) then
    begin
      Form1.CZKEM_A.RefreshData(Unit1.MachineNumber_A);
      for FingerIndex:=0 to 9 do
      begin
        Form1.CZKEM_A.SSR_DelUserTmpExt(Unit1.MachineNumber_A, EnrollNumber, FingerIndex);
      end;
      Form1.Memo1.Lines.Add('====================================================================');
      Form1.Memo1.Lines.Add('Delete User Data From '+Unit1.MachineName_A+'......Successful!');
      Form1.Memo1.Lines.Add('====================================================================');
    end
    else
    begin
      Form1.CZKEM_A.GetLastError(ErrorCode);
      Form1.Memo1.Lines.Add('====================================================================');
      Form1.Memo1.Lines.Add('Delete User Data From '+Unit1.MachineName_A+'Failed,ErrorCode='+IntToStr(ErrorCode));
      Form1.Memo1.Lines.Add('====================================================================');
    end;
  end;
  //=====================================================================================================================

  //=====================================================================================================================
  //從入口指紋機(B)將使用者資料刪除
  //=====================================================================================================================
  if Unit1.MachineNumber_B_IsConnected then
  begin
    if Form1.CZKEM_B.SSR_DeleteEnrollData(Unit1.MachineNumber_B, EnrollNumber, 12) then
    begin
      Form1.CZKEM_B.RefreshData(Unit1.MachineNumber_A);
      for FingerIndex:=0 to 9 do
      begin
        Form1.CZKEM_B.SSR_DelUserTmpExt(Unit1.MachineNumber_B, EnrollNumber, FingerIndex);
      end;
      Form1.Memo1.Lines.Add('====================================================================');
      Form1.Memo1.Lines.Add('Delete User Data From '+Unit1.MachineName_B+'......Successful!');
      Form1.Memo1.Lines.Add('====================================================================');
    end
    else
    begin
      Form1.CZKEM_B.GetLastError(ErrorCode);
      Form1.Memo1.Lines.Add('====================================================================');
      Form1.Memo1.Lines.Add('Delete User Data From '+Unit1.MachineName_B+'Failed,ErrorCode='+IntToStr(ErrorCode));
      Form1.Memo1.Lines.Add('====================================================================');
    end;
  end;
  //=====================================================================================================================

  //=====================================================================================================================
  //從出口指紋機(C)將使用者資料刪除
  //=====================================================================================================================
  if Unit1.MachineNumber_C_IsConnected then
  begin
    if Form1.CZKEM_C.SSR_DeleteEnrollData(Unit1.MachineNumber_C, EnrollNumber, 12) then
    begin
      Form1.CZKEM_C.RefreshData(Unit1.MachineNumber_C);
      for FingerIndex:=0 to 9 do
      begin
        Form1.CZKEM_C.SSR_DelUserTmpExt(Unit1.MachineNumber_C, EnrollNumber, FingerIndex);
      end;
      Form1.Memo1.Lines.Add('====================================================================');
      Form1.Memo1.Lines.Add('Delete User Data From '+Unit1.MachineName_C+'......Successful!');
      Form1.Memo1.Lines.Add('====================================================================');
    end
    else
    begin
      Form1.CZKEM_A.GetLastError(ErrorCode);
      Form1.Memo1.Lines.Add('====================================================================');
      Form1.Memo1.Lines.Add('Delete User Data From '+Unit1.MachineName_C+'Failed,ErrorCode='+IntToStr(ErrorCode));
      Form1.Memo1.Lines.Add('====================================================================');
    end;
  end;
  //=====================================================================================================================

  //=====================================================================================================================
  //從資料庫中刪除
  //=====================================================================================================================
  try
    Form1.ADOQuery1.SQL.Clear;
    Form1.ADOQuery1.SQL.Add('DELETE FROM [UserInfo] WHERE EnrollNumber='+''''+EnrollNumber+'''');
    Form1.ADOQuery1.ExecSQL;
    Form1.ADOQuery1.SQL.Clear;
    Form1.ADOQuery1.SQL.Add('DELETE FROM [UserTemplate] WHERE EnrollNumber='+''''+EnrollNumber+'''');
    Form1.ADOQuery1.ExecSQL;
    Form1.Memo1.Lines.Add('====================================================================');
    Form1.Memo1.Lines.Add('Delete User Data From Database Successful !');
    Form1.Memo1.Lines.Add('====================================================================');
  except
    Form1.Memo1.Lines.Add('====================================================================');
    Form1.Memo1.Lines.Add('Delete User Data From Database Failed !');
    Form1.Memo1.Lines.Add('====================================================================');
  end;
  //=====================================================================================================================

  //=====================================================================================================================
  //產生Log
  //=====================================================================================================================
  try
    filename:=FormatDateTime('yyyymmddhhnnss', Now)+'.txt';
    tempstring:='R' + TAB + 'D' + TAB + Trim(Form1.edt_IP_A.Text) + TAB + EnrollNumber + TAB + FormatDateTime('yyyy/mm/dd hh:nn:ss',Now) + TAB + 'DeleteEnroll' + TAB + 'OK';
    AssignFile(outfile, AttLogDir+filename);
    ReWrite(outfile);
    WriteLn(outfile, tempstring);
    AssignFile(outfile2, AttLog_AddDir+filename);
    ReWrite(outfile2);
    WriteLn(outfile2, tempstring);
  finally
    CloseFile(outfile);
    CloseFile(outfile2);
  end;
  Screen.Cursor := cursor;
  //=====================================================================================================================
end;

procedure TForm3.btnDeleteFPClick(Sender: TObject);
var
  EnrollNumber:WideString;
  FingerIndex:Integer;
  ErrorCode:Integer;
begin
  EnrollNumber:=dbgUserTemplate.DataSource.DataSet.FieldByName('EnrollNumber').Value;
  FingerIndex:=dbgUserTemplate.DataSource.DataSet.FieldByName('FingerIndex').Value;
  if MessageDlg('Delete FingerPrint Data, UserID='+EnrollNumber+', FingerIndex='+IntToStr(FingerIndex)+' ?',mtConfirmation,[mbYes,mbNo],1) = mrYes then
  begin
    if Unit1.MachineNumber_A_IsConnected then
    begin
      if Form1.CZKEM_A.SSR_DelUserTmpExt(Unit1.MachineNumber_A, EnrollNumber, FingerIndex) then
      begin
        Form1.CZKEM_A.RefreshData(Unit1.MachineNumber_A);
        Memo1.Lines.Add('Delete FingerPrint From '+Unit1.MachineName_A+'Successful !');
      end
      else
      begin
        Form1.CZKEM_A.GetLastError(ErrorCode);
        Memo1.Lines.Add('Delete FingerPrint From '+Unit1.MachineName_A+'Failed, ErrorCode='+Inttostr(ErrorCode));
      end;
    end;
    if Unit1.MachineNumber_B_IsConnected then
    begin
      if Form1.CZKEM_B.SSR_DeleteEnrollData(Unit1.MachineNumber_B, EnrollNumber, 0) then
      begin
        Form1.CZKEM_B.RefreshData(Unit1.MachineNumber_A);
        Memo1.Lines.Add('Delete FingerPrint From '+Unit1.MachineName_B+'Successful !');
      end
      else
      begin
        Form1.CZKEM_B.GetLastError(ErrorCode);
        Memo1.Lines.Add('Delete FingerPrint From '+Unit1.MachineName_B+'Failed, ErrorCode='+Inttostr(ErrorCode));
      end;
    end;
    if Unit1.MachineNumber_C_IsConnected then
    begin
      if Form1.CZKEM_C.SSR_DeleteEnrollData(Unit1.MachineNumber_C, EnrollNumber, 0) then
      begin
        Form1.CZKEM_C.RefreshData(Unit1.MachineNumber_C);
        Memo1.Lines.Add('Delete FingerPrint From '+Unit1.MachineName_C+'Successful !');
      end
      else
      begin
        Form1.CZKEM_C.GetLastError(ErrorCode);
        Memo1.Lines.Add('Delete FingerPrint From '+Unit1.MachineName_B+'Failed, ErrorCode='+Inttostr(ErrorCode));
      end;
    end;
    try
      dbgUserTemplate.DataSource.DataSet.Delete;
      Memo1.Lines.Add('Delete FingerPrint From Database Successful !');
    except
      Memo1.Lines.Add('Delete FingerPrint Data From Database Failed !');
    end;
  end;
end;

procedure TForm3.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TForm3.edtEnrollNumberKeyPress(Sender: TObject; var Key: Char);
begin
  if key = chr(13) then
  begin
    if Trim(edtEnrollNumber.Text) <> '' then
    begin
      ADOTable1.Filter:='EnrollNumber='+QuotedStr(Trim(edtEnrollNumber.Text));
      ADOTable1.Filtered:=true;
    end
    else
    begin
      ADOTable1.Filtered:=false;
    end;
  end;
end;

procedure TForm3.edtUserNameKeyPress(Sender: TObject; var Key: Char);
begin
  if key = chr(13) then
  begin
    if Trim(edtUserName.Text) <> '' then
    begin
      ADOTable1.Filter:='UserName LIKE '+QuotedStr('%'+Trim(edtUserName.Text)+'%');
      ADOTable1.Filtered:=true;
    end
    else
    begin
      ADOTable1.Filtered:=false;
    end;
  end;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
  ADOTable1.Active:=false;
  ADOTable1.Active:=true;
  ADOTable2.Active:=false;
  ADOTable2.Active:=true;
end;

end.
