object frmConfig: TfrmConfig
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Configura'#231#245'es'
  ClientHeight = 240
  ClientWidth = 296
  Color = clMenuHighlight
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 18
    Width = 27
    Height = 13
    Caption = 'Nome'
  end
  object Label2: TLabel
    Left = 8
    Top = 74
    Width = 19
    Height = 13
    Caption = 'CPF'
  end
  object Label3: TLabel
    Left = 8
    Top = 126
    Width = 25
    Height = 13
    Caption = 'Login'
  end
  object Label4: TLabel
    Left = 114
    Top = 180
    Width = 73
    Height = 13
    Cursor = crHandPoint
    Caption = 'EDITAR SENHA'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = Label4Click
  end
  object edtNome: TEdit
    Left = 8
    Top = 37
    Width = 281
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object edtLogin: TEdit
    Left = 8
    Top = 141
    Width = 281
    Height = 21
    TabOrder = 1
  end
  object edtCpf: TMaskEdit
    Left = 8
    Top = 88
    Width = 281
    Height = 21
    EditMask = '000.000.000-00;'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 14
    ParentFont = False
    TabOrder = 2
    Text = '   .   .   -  '
  end
  object Button1: TButton
    Left = 112
    Top = 207
    Width = 75
    Height = 25
    Cursor = crHandPoint
    Caption = 'Salvar'
    TabOrder = 3
    OnClick = Button1Click
  end
  object qryConfig: TADOQuery
    Connection = frmMenu.conexao
    Parameters = <>
    Left = 184
    Top = 8
  end
end
