object frmConsSQL: TfrmConsSQL
  Left = 0
  Top = 0
  Caption = 'Consulta SQL'
  ClientHeight = 613
  ClientWidth = 848
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object edtScript: TMemo
    Left = 8
    Top = 32
    Width = 825
    Height = 305
    TabOrder = 0
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 352
    Width = 825
    Height = 253
    DataSource = dtsSQL
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object EXECUTAR: TButton
    Left = 8
    Top = 4
    Width = 75
    Height = 25
    Caption = 'EXECUTAR'
    TabOrder = 2
    OnClick = EXECUTARClick
  end
  object qrySQL: TADOQuery
    Connection = frmMenu.conexao
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from crianca')
    Left = 224
    Top = 304
  end
  object dtsSQL: TDataSource
    DataSet = qrySQL
    Left = 336
    Top = 304
  end
end
