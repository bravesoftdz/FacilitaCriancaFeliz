object frmVisitador: TfrmVisitador
  Left = 0
  Top = 0
  Caption = 'frmVisitador'
  ClientHeight = 351
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object page: TPageControl
    Left = 8
    Top = 16
    Width = 612
    Height = 327
    ActivePage = tbCadastro
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Lista'
      object dbgVis: TDBGrid
        Left = 3
        Top = 32
        Width = 598
        Height = 264
        DataSource = dtsVisitador
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDblClick = dbgVisDblClick
      end
      object Button1: TButton
        Left = 3
        Top = 3
        Width = 75
        Height = 25
        Caption = 'atualizar'
        TabOrder = 1
        OnClick = Button1Click
      end
    end
    object tbCadastro: TTabSheet
      Caption = 'Cadastro'
      ImageIndex = 1
      OnShow = tbCadastroShow
      object Label1: TLabel
        Left = 16
        Top = 21
        Width = 25
        Height = 13
        Caption = 'Login'
      end
      object Label2: TLabel
        Left = 16
        Top = 69
        Width = 30
        Height = 13
        Caption = 'Senha'
      end
      object Label3: TLabel
        Left = 16
        Top = 117
        Width = 31
        Height = 13
        Caption = 'Status'
      end
      object Label4: TLabel
        Left = 15
        Top = 165
        Width = 19
        Height = 13
        Caption = 'CPF'
      end
      object Label5: TLabel
        Left = 304
        Top = 21
        Width = 27
        Height = 13
        Caption = 'Nome'
      end
      object Label6: TLabel
        Left = 304
        Top = 69
        Width = 51
        Height = 13
        Caption = 'Supervisor'
      end
      object edtLogin: TEdit
        Left = 16
        Top = 42
        Width = 185
        Height = 21
        TabOrder = 0
        Text = 'login'
      end
      object edtSenha: TEdit
        Left = 16
        Top = 88
        Width = 185
        Height = 21
        PasswordChar = '*'
        TabOrder = 1
        Text = 'edtSenha'
      end
      object cbStatus: TComboBox
        Left = 16
        Top = 136
        Width = 185
        Height = 21
        ItemIndex = 0
        TabOrder = 2
        Text = 'DESATIVADO'
        Items.Strings = (
          'DESATIVADO'
          'ATIVADO')
      end
      object edtCPF: TEdit
        Left = 16
        Top = 184
        Width = 185
        Height = 21
        TabOrder = 3
        Text = 'CPF'
      end
      object edtNome: TEdit
        Left = 304
        Top = 40
        Width = 177
        Height = 21
        TabOrder = 4
        Text = 'Nome'
      end
      object cbSupervisor: TComboBox
        Left = 304
        Top = 88
        Width = 177
        Height = 21
        TabOrder = 5
        Text = 'SUPERVISOR'
      end
      object Button2: TButton
        Left = 240
        Top = 248
        Width = 75
        Height = 25
        Caption = 'Salvar'
        TabOrder = 6
        OnClick = Button2Click
      end
    end
  end
  object qryVisitador: TADOQuery
    Connection = frmMenu.conexao
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from visitador')
    Left = 456
    Top = 8
  end
  object dtsVisitador: TDataSource
    DataSet = qryVisitador
    Left = 392
    Top = 8
  end
  object qryAux: TADOQuery
    Connection = frmMenu.conexao
    Parameters = <>
    Left = 548
    Top = 40
  end
end
