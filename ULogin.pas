unit ULogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.StdCtrls,
  Vcl.Mask, Vcl.Imaging.pngimage, Vcl.ExtCtrls,WinInet, dxGDIPlusClasses,inifiles,
  EAppProt;

type
  TfrmLogin = class(TForm)
    btnEntrar: TButton;
    edtLogin: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    qryFazerLogin: TADOQuery;
    edtSenha: TMaskEdit;
    Label4: TLabel;
    lblVersao: TLabel;
    Label6: TLabel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    btnFechar: TButton;
    Button1: TButton;
    Image5: TImage;
    procedure btnEntrarClick(Sender: TObject);
    procedure fazerLogin;
    procedure FormCreate(Sender: TObject);
    procedure verificaChaveDeAtivacao;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnFecharClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

uses UMenu, uConfigCon;

procedure TfrmLogin.btnEntrarClick(Sender: TObject);
    begin
        fazerLogin;
        if qryFazerLogin.RecordCount=1 then
          begin
              frmMenu.idUsuario:=qryFazerLogin.FieldByName('idVisitador').AsString;
              frmMenu.lblIdUsr.Caption:='IdUsr:.'+frmMenu.idUsuario;
              frmLogin.Close;
          end
        else
          begin
            ShowMessage('Verifique o login ou senha!');
          end;
    end;

procedure TfrmLogin.btnFecharClick(Sender: TObject);
    begin
        Halt(0);
    end;

procedure TfrmLogin.Button1Click(Sender: TObject);
begin
    frmConfuguraCon:=TfrmConfuguraCon.Create(self);
    frmConfuguraCon.ShowModal;
end;

procedure TfrmLogin.fazerLogin;
    begin
        qryFazerLogin.Close;
        with qryFazerLogin.SQL do
          begin
              Clear;
              add('select v.idVisitador                            ');
              add('from  visitador v                               ');
              add('where v.loginVisitador='+QuotedStr(edtLogin.Text));
              add('and v.senhaVisitador=' + QuotedStr(frmMenu.encriptar(edtSenha.Text)));
              add('and flAtivo = 1                                 ');
          end;
         qryFazerLogin.Open;
    end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
    begin
        Action := caFree;
    end;

procedure TfrmLogin.FormCreate(Sender: TObject);
    begin
        qryFazerLogin.Close;
        verificaChaveDeAtivacao;
        lblVersao.Caption:='Vers�o'+frmMenu.nnVersao;
    end;

procedure TfrmLogin.verificaChaveDeAtivacao;
var chave:string;
ArqIni: TIniFile;
i:dword;
begin

     if InternetGetConnectedState(@i,0) then
      begin
          ArqIni := TIniFile.Create('C:\CriancaFeliz\configPCF.ini');
            try
            chave := ArqIni.ReadString('Chave', 'chaveDeAtivacao', '');

            if chave<>'123456' then
            begin
                ShowMessage('ERRO: CHAVE DE VERIFICA�AO INV�LIDA');
                edtLogin.Enabled:=false;
                edtSenha.Enabled:=false;
                btnEntrar.Enabled:=false;
            end;

            finally
            ArqIni.Free;
          end;
      end;


end;

end.
