unit ULogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.StdCtrls,
  Vcl.Mask, Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TfrmLogin = class(TForm)
    btnEntrar: TButton;
    edtLogin: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    qryFazerLogin: TADOQuery;
    edtSenha: TMaskEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    btnFechar: TButton;
    procedure btnEntrarClick(Sender: TObject);
    procedure fazerLogin;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnFecharClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

uses UMenu;

procedure TfrmLogin.btnEntrarClick(Sender: TObject);
    begin
        fazerLogin;
        if qryFazerLogin.RecordCount=1 then
          begin
              frmMenu.idUsuario:=qryFazerLogin.FieldByName('idVisitador').AsString;
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

procedure TfrmLogin.fazerLogin;
    begin
        qryFazerLogin.Close;
        with qryFazerLogin do
          begin
              qryFazerLogin.SQL.Clear;
              qryFazerLogin.SQL.add('select v.idVisitador                            ');
              qryFazerLogin.SQL.add('from  visitador v                                ');
              qryFazerLogin.SQL.add('where v.loginVisitador='+QuotedStr(edtLogin.Text));
              qryFazerLogin.SQL.add('and v.senhaVisitador=' + QuotedStr(edtSenha.Text));
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
    end;

end.
