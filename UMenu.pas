unit UMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage, IniFiles;

type
  TfrmMenu = class(TForm)
    conexao: TADOConnection;
    ADOQuery1: TADOQuery;
    lblIdUsr: TLabel;
    btnGerGrupos: TButton;
    btnGerCrianca: TButton;
    Label4: TLabel;
    Label3: TLabel;
    btnRelatorios: TButton;
    edtGeraRelatorios: TButton;
    btnConfig: TButton;
    Image1: TImage;
    lblVersao: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnGerGruposClick(Sender: TObject);
    procedure btnGerCriancaClick(Sender: TObject);
    procedure btnRelatoriosClick(Sender: TObject);
    procedure edtGeraRelatoriosClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnConfigClick(Sender: TObject);
    procedure conectarAoBanco;
    procedure preencherVarBanco;
  private
    { Private declarations }
  public
    idUsuario:string;
    nnVersao:string;
    var user: string;
    var senha: string;
    var banco: string;
    var servidor:string;
    var NomeEstacao:string;
  end;

var
  frmMenu: TfrmMenu;

implementation

{$R *.dfm}

uses ULogin, UGrupos, UCriancas, UCadCrianca, UGerRelatorios,
  UImprimirRelatorio, UEntrarConfig;

procedure TfrmMenu.btnConfigClick(Sender: TObject);
    begin
        frmEntrarConfig:=TfrmEntrarConfig.create(self);
        frmEntrarConfig.ShowModal;
    end;

procedure TfrmMenu.btnGerCriancaClick(Sender: TObject);
    begin
       frmGerCriancas:= TfrmGerCriancas.Create(self);
       frmGerCriancas.ShowModal;

    end;

procedure TfrmMenu.btnGerGruposClick(Sender: TObject);
    begin
        frmGerGrupos:= TfrmGerGrupos.Create(self);
        frmGerGrupos.ShowModal;
    end;

procedure TfrmMenu.btnRelatoriosClick(Sender: TObject);
    begin
        frmGerRelatorios:=TfrmGerRelatorios.Create(self);
        frmGerRelatorios.ShowModal;
    end;

procedure TfrmMenu.conectarAoBanco;
 var con : string;
begin
  preencherVarBanco;

  con := 'Provider=SQLOLEDB.1;';
  con := con + 'Persist Security Info=True;';
  con := con + 'User ID='+user+';';
  con := con + 'Password='+senha+';';
  con := con + 'Initial Catalog='+banco+';';
  con := con + 'Data Source='+servidor+';';
  con := con + 'Auto Translate=True;';
  con := con + 'Packet Size=4096;';
  con := con + 'Workstation ID='+NomeEstacao+';';
  con := con + 'Network Library=DBMSSOCN';



  try
    conexao.Close;
    conexao.ConnectionString:=con;
    conexao.Connected := true;
  except
    on e: Exception do
    ShowMessage('Erro ao conectar ao banco de dados');
  end;
end;

procedure TfrmMenu.edtGeraRelatoriosClick(Sender: TObject);
    begin
        frmGerarRelatorio:=TfrmGerarRelatorio.Create(self);
        frmGerarRelatorio.ShowModal;
    end;

procedure TfrmMenu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure TfrmMenu.FormCreate(Sender: TObject);
    begin

    conectarAoBanco;
    lblVersao.Caption:='V. 2.1';

        idUsuario:='';
        while idUsuario='' do
          begin
              frmLogin:=TfrmLogin.Create(self);
              frmLogin.ShowModal;
          end;
       lblIdUsr.Caption:='IdUsr:.'+idUsuario;
       lblIdUsr.Font.Color:=clGreen;
    end;

procedure TfrmMenu.preencherVarBanco;
var
  ArqIni: TIniFile;
begin
  ArqIni := TIniFile.Create('C:\CriancaFeliz\configPCF.ini');
  try
    user := ArqIni.ReadString('Configuracoes', 'user', '');
    senha:= ArqIni.ReadString('Configuracoes', 'senha', '');
    banco:= ArqIni.ReadString('Configuracoes', 'banco', '');
    servidor:= ArqIni.ReadString('Configuracoes', 'servidor', '');
    NomeEstacao:= ArqIni.ReadString('Configuracoes', 'NomeEstacao', '');
  finally
    ArqIni.Free;
  end;
end;


end.
