unit UMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage, IniFiles, Clipbrd,Dateutils, Vcl.Menus,
  dxGDIPlusClasses, Vcl.ImgList, cxGraphics, IdHashMessageDigest, EAppProt,
  JvComponentBase, JvSerialMaker;

type
  TfrmMenu = class(TForm)
    conexao: TADOConnection;
    ADOQuery1: TADOQuery;
    lblIdUsr: TLabel;
    btnGerGrupos: TButton;
    btnGerCrianca: TButton;
    Label4: TLabel;
    btnRelatorios: TButton;
    edtGeraRelatorios: TButton;
    btnConfig: TButton;
    Image1: TImage;
    lblVersao: TLabel;
    MainMenu1: TMainMenu;
    Bancodedados1: TMenuItem;
    Fazerbackup1: TMenuItem;
    Restaurarbackup: TMenuItem;
    Executarscript: TMenuItem;
    ExecutarconsultaSQL1: TMenuItem;
    Propriedadesdaconexo1: TMenuItem;
    Restaurar1: TMenuItem;
    Restaurargrupos1: TMenuItem;
    Restaurarcrianas1: TMenuItem;
    Restaurarrelatrios1: TMenuItem;
    btnadm: TMenuItem;
    Acessar1: TMenuItem;
    Login1: TMenuItem;
    Image2: TImage;
    opdAbrirBackUp: TOpenDialog;
    cxImageList1: TcxImageList;
    procedure btnGerGruposClick(Sender: TObject);
    procedure btnGerCriancaClick(Sender: TObject);
    procedure btnRelatoriosClick(Sender: TObject);
    procedure edtGeraRelatoriosClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnConfigClick(Sender: TObject);
    procedure conectarAoBanco;
    procedure preencherVarBanco;
    procedure fazerBackUp;
    function pegaSQL(qry: TADOQuery):string;

    procedure FormCreate(Sender: TObject);
    procedure Propriedadesdaconexo1Click(Sender: TObject);
    procedure Fazerbackup1Click(Sender: TObject);
    procedure ExecutarscriptClick(Sender: TObject);
    procedure ExecutarconsultaSQL1Click(Sender: TObject);
    procedure Acessar1Click(Sender: TObject);
    procedure Login1Click(Sender: TObject);
    procedure Restaurargrupos1Click(Sender: TObject);
    procedure Restaurarcrianas1Click(Sender: TObject);
    procedure Restaurarrelatrios1Click(Sender: TObject);
    procedure RestaurarbackupClick(Sender: TObject);
  private
    { Private declarations }
  public
    idUsuario:string;
    const nnVersao:string='4.2';
    var user: string;
    var senha: string;
    var banco: string;
    var servidor:string;
    var NomeEstacao:string;
    procedure verificarPermissoes;
    procedure restaurarBancoDeDados;
    function volte (sql:String;campo: string):string;
    function encriptar(texto:string):string;
  end;

var
  frmMenu: TfrmMenu;

implementation

{$R *.dfm}

uses ULogin, UGrupos, UCriancas, UCadCrianca, UGerRelatorios,
  UImprimirRelatorio, UEntrarConfig, uConfigCon, uScriptSQL, uConsSQL,
  uVisitador, uRecuperar, uGeral;

procedure TfrmMenu.Acessar1Click(Sender: TObject);
begin
    frmVisitador:=TfrmVisitador.create(self);
    frmVisitador.Show;
end;

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
  con := con +'Integrated Security=SSPI;';
  con := con + 'Persist Security Info=False;';
  con := con + 'Initial Catalog='+banco+';';
  con := con + 'Data Source='+servidor+';';

  try
    conexao.Close;
    conexao.ConnectionString:=con;
    conexao.ConnectOptions:= coAsyncConnect;
    conexao.Connected := true;
  except
    on e: Exception do
      begin
          ShowMessage('erro na conex�o com o banco de dados');
          frmConfuguraCon:=TfrmConfuguraCon.Create(self);
          frmConfuguraCon.Show;
      end;
  end;
end;

procedure TfrmMenu.edtGeraRelatoriosClick(Sender: TObject);
    begin
        frmGerarRelatorio:=TfrmGerarRelatorio.Create(self);
        frmGerarRelatorio.ShowModal;
    end;

function TfrmMenu.encriptar(texto: string): string;
var
    idmd5 : TIdHashMessageDigest5;
begin
    idmd5 := TIdHashMessageDigest5.Create;
  try
    result := idmd5.HashStringAsHex(texto);
  finally
    idmd5.Free;
  end;
end;

procedure TfrmMenu.ExecutarconsultaSQL1Click(Sender: TObject);
begin
    frmConsSQL:=TfrmConsSQL.Create(self);
    frmConsSQL.ShowModal;
end;

procedure TfrmMenu.ExecutarscriptClick(Sender: TObject);
begin
     frmExecScript:=TfrmExecScript.Create(self);
     frmExecScript.ShowModal;
end;

procedure TfrmMenu.fazerBackUp;
var ADOCommand : TADOCommand;
    data:string;
begin
    data:=FormatDateTime('dd-mm-yyyy',Date());
    ADOCommand := TADOCommand.Create(nil); //Cria o objeto de comando para executar a rotina de backup do SQL SERVER 2000
    with ADOCommand do begin
    //ADOCommand.Name := 'ADOGeraBackup'; //Nome do objeto
    ADOCommand.ConnectionString := conexao.ConnectionString; //Cria a conex�o com o Provider do SQL Server
    //ADOCommand.CommandType := cmdText; //Define como command Text para execu��o de linhas de comando
    ADOCommand.CommandText := 'BACKUP DATABASE '+banco+' TO DISK =''c:\CriancaFeliz\Backup\crianca_feliz '+data+'.bak''';
    ADOCommand.Execute; //Executa a linha de comando
  end;
end;

procedure TfrmMenu.Fazerbackup1Click(Sender: TObject);
begin
    fazerBackUp ;
end;

procedure TfrmMenu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
    fazerBackUp;
end;


procedure TfrmMenu.FormCreate(Sender: TObject);
begin
    conectarAoBanco;
    lblVersao.Caption:='V. '+nnVersao;

        idUsuario:='';
        while idUsuario='' do
          begin
              frmLogin:=TfrmLogin.Create(self);
              frmLogin.ShowModal;
          end;

       lblIdUsr.Font.Color:=clBlack;
        verificarPermissoes;
       //lblNome.Caption:=volte('select nomeVisitador from visitador where idVisitador='+idUsuario,'nomeVisitador')
end;

procedure TfrmMenu.Login1Click(Sender: TObject);
begin
frmlogin:=TfrmLogin.Create(self);
frmLogin.ShowModal;
end;

function TfrmMenu.pegaSQL(qry: TADOQuery): string;
begin
   Clipboard.AsText := qry.SQL.GetText;
   Result :='Copiado para �rea de tranfer�ncia';
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


procedure TfrmMenu.Propriedadesdaconexo1Click(Sender: TObject);
begin
    frmConfuguraCon:=TfrmConfuguraCon.Create(self);
    frmConfuguraCon.ShowModal;
end;

procedure TfrmMenu.RestaurarbackupClick(Sender: TObject);
var caminho:string;
    ADOCommand : TADOCommand;
begin
      if opdAbrirBackUp.execute then
         caminho:= opdAbrirBackUp.FileName;

     ADOCommand := TADOCommand.Create(nil);
     with ADOCommand do
     begin
       ADOCommand.ConnectionString := conexao.ConnectionString;
       ADOCommand.CommandText := 'RESTORE DATABASE '+banco+ 'FILEGROUP=' + caminho+'WITH RECOVERY';
       ADOCommand.Execute;
     end;

end;

procedure TfrmMenu.restaurarBancoDeDados;
begin

end;

procedure TfrmMenu.Restaurarcrianas1Click(Sender: TObject);
begin
    frmRecuperar:=TfrmRecuperar.Create(self,'c');
    frmRecuperar.ShowModal;
end;

procedure TfrmMenu.Restaurargrupos1Click(Sender: TObject);
begin
    frmRecuperar:=TfrmRecuperar.Create(self,'g');
    frmRecuperar.ShowModal;
end;

procedure TfrmMenu.Restaurarrelatrios1Click(Sender: TObject);
begin
    frmRecuperar:=TfrmRecuperar.Create(self,'v');
    frmRecuperar.ShowModal;
end;

procedure TfrmMenu.verificarPermissoes;
var permissao:string;
begin
    permissao:=volte('select intTag from visitador where idVisitador='+idUsuario,'intTag');
    if StrToInt(permissao)=0 then
    begin
      btnadm.Visible:=false;
      Executarscript.Enabled:=false;
      Restaurarbackup.Enabled:=false;
    end;

end;

function TfrmMenu.volte(sql: String; campo: string): string;
var qryVolte: TADOQuery;
    resultado:string;
begin
    qryVolte:=TADOQuery.Create(nil);
    qryVolte.Connection:=conexao;
    qryVolte.SQL.Add(sql);
    qryVolte.Open;
    resultado:=qryVolte.FieldByName(campo).AsString;
    qryVolte.Close;

    result:= resultado;
end;

end.
