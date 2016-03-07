object Form7: TForm7
  Left = 581
  Top = 501
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Create Finger Print'
  ClientHeight = 139
  ClientWidth = 634
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 48
    Top = 24
    Width = 577
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = 'Create Finger Print, Please Put Your Finger On Machine Sensor'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 433
    Top = 123
    Width = 136
    Height = 16
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Elapse/Seconds:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblCountDown: TLabel
    Left = 577
    Top = 123
    Width = 48
    Height = 16
    AutoSize = False
    Caption = '05:00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object BitBtn1: TBitBtn
    Left = 216
    Top = 72
    Width = 201
    Height = 41
    Caption = 'Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = BitBtn1Click
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 488
    Top = 64
  end
end
