unit uVisitador;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.ComCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls;

type
  TfrmVisitador = class(TForm)
    page: TPageControl;
    TabSheet1: TTabSheet;
    qryVisitador: TADOQuery;
    dbgVis: TDBGrid;
    dtsVisitador: TDataSource;
    tbCadastro: TTabSheet;
    edtLogin: TEdit;
    edtSenha: TEdit;
    cbStatus: TComboBox;
    edtCPF: TEdit;
    edtNome: TEdit;
    cbSupervisor: TComboBox;
    Button1: TButton;
    qryAux: TADOQuery;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure dbgVisDblClick(Sender: TObject);
    procedure tbCadastroShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
     idVisitador:string;
     op:string;
     procedure pesquisaPessoa;
     procedure pesquisaSupervisor;
  end;

var
  frmVisitador: TfrmVisitador;

implementation

{$R *.dfm}

uses UMenu;

procedure TfrmVisitador.Button1Click(Sender: TObject);
begin
      qryVisitador.Close;
      with qryVisitador.SQL do
      begin
        clear;
        add('select * from visitador');

      end;
      qryVisitador.Open;
end;

procedure TfrmVisitador.Button2Click(Sender: TObject);
begin
  if op='e' then
  begin
     qryAux.Close;
     with qryAux.SQL do
     begin
       clear;
       add('UPDATE visitador SET');
       add('loginVisitador='+QuotedStr(edtLogin.Text));
       add(', senhaVisitador='+QuotedStr(frmMenu.encriptar(edtSenha.Text)));
       add(', flAtivo='+inttostr(cbStatus.ItemIndex));
       add(',cpfVisitador='+QuotedStr(edtCPF.Text));
       add(',nomeVisitador='+QuotedStr(edtNome.Text));
       add(',idSupervisor='+inttostr(Integer(cbSupervisor.items.objects[cbSupervisor.ItemIndex]))) ;
       add('where idVisitador='+idVisitador);
     end;
  end
  else
  begin
     qryAux.Close;
     with qryAux.SQL do
     begin
       clear;
       add('insert into visitador (loginVisitador,senhaVisitador,flAtivo,cpfVisitador,nomeVisitador,idSupervisor) ');
       add('values('+QuotedStr(edtLogin.Text));
       add(','+QuotedStr(frmMenu.encriptar(edtSenha.Text)));
       add(','+inttostr(cbStatus.ItemIndex));
       add(','+QuotedStr(edtCPF.Text));
       add(','+QuotedStr(edtNome.Text));
       add(','+inttostr(Integer(cbSupervisor.items.objects[cbSupervisor.ItemIndex])));
       add(')');
     end;

  end;
   if qryAux.ExecSQL=1 then
   begin
      ShowMessage('Executado com sucesso');
      edtLogin.Text:='';
      edtSenha.Text:='';
      edtCPF.Text:='';
      edtNome.Text:='';
      cbStatus.ItemIndex:=0;
      cbSupervisor.ItemIndex:=0;
   end;

end;

procedure TfrmVisitador.dbgVisDblClick(Sender: TObject);
begin
      idVisitador:= dbgVis.DataSource.DataSet.FieldByName('idVisitador').AsString;
      page.ActivePage:=tbCadastro;
      pesquisaPessoa;
      op:='e';
end;

procedure TfrmVisitador.pesquisaPessoa;
begin
    qryAux.Close;

    with qryAux.SQL do
    begin
      clear;
      add('select * from visitador');
      add('where idVisitador='+idVisitador);
    end;
    qryAux.Open;

    edtLogin.Text:=qryAux.FieldByName('loginVisitador').AsString;
    edtSenha.Text:=qryAux.FieldByName('senhaVisitador').AsString;
    edtCPF.Text:=qryAux.FieldByName('cpfVisitador').AsString;
    edtNome.Text:=qryAux.FieldByName('nomeVisitador').AsString;
    cbStatus.ItemIndex:= qryAux.FieldByName('flAtivo').AsInteger;
    qryAux.Close;
end;

procedure TfrmVisitador.pesquisaSupervisor;
var i:integer;
begin
     qryAux.Close;
     with qryAux.SQL do
     begin
       clear;
       add('SELECT * FROM supervisor');
     end;
     qryAux.Open;
      cbSupervisor.Clear;
      i:=0;
       while i<qryAux.RecordCount do
       begin
         cbSupervisor.Items.AddObject( qryAux.FieldByName('nomeSupervisor').asString,
          tObject(qryAux.FieldByName('idSupervisor').asInteger) );
         qryAux.Next;
         i:=i+1;
       end;
       qryAux.Close;
       cbSupervisor.ItemIndex:=0;
end;

procedure TfrmVisitador.tbCadastroShow(Sender: TObject);
begin
pesquisaSupervisor;
end;

end.
