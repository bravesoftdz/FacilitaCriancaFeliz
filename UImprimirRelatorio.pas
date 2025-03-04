unit UImprimirRelatorio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Data.Win.ADODB,
  frxClass, frxDBSet, Vcl.Imaging.pngimage,DateUtils, Vcl.ExtCtrls;

type
  TfrmGerarRelatorio = class(TForm)
    cbxCrianca: TComboBox;
    cbxMes: TComboBox;
    cbxAno: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    btnImprimirRelatorio: TButton;
    lblTitulo: TLabel;
    Image1: TImage;
    qry: TADOQuery;
    procedure FormCreate(Sender: TObject);
    procedure pesquisarCriancas;
    procedure btnImprimirRelatorioClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGerarRelatorio: TfrmGerarRelatorio;

implementation

{$R *.dfm}

uses UMenu, uSelVisitas;

procedure TfrmGerarRelatorio.btnImprimirRelatorioClick(Sender: TObject);
    begin
      if (cbxMes.ItemIndex<>0) and (cbxAno.ItemIndex<>0) then
       begin

       frmSelecionarRel:=TfrmSelecionarRel.Create(self,cbxAno.Text,cbxMes.Text,inttostr(Integer(cbxCrianca.items.objects[cbxCrianca.ItemIndex])));
       frmSelecionarRel.ShowModal;

      end
      else
        ShowMessage('Escolha o mes e ano');

    end;

procedure TfrmGerarRelatorio.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action := caFree;
end;

procedure TfrmGerarRelatorio.FormCreate(Sender: TObject);
    begin
       cbxMes.ItemIndex:=monthOf(Date());
       if yearOf(date())=2020 then
        cbxAno.ItemIndex:=2;
        pesquisarCriancas;
    end;


procedure TfrmGerarRelatorio.pesquisarCriancas;
var i:integer;
    begin
        qry.Close;
        with   qry.SQL do
        begin
          clear;
          Add('select c.idCrianca, c.nomeCrianca, c.territorioCrianca');
          Add('from vwCriancaGrupo c                                 ');
          Add('where c.idVisitador=     '+quotedStr(frmMenu.idUsuario));
        end;

        qry.Open;

        i:=0;
       while i<qry.RecordCount do
       begin
         cbxCrianca.Items.AddObject( qry.FieldByName('nomeCrianca').asString+'-'+qry.FieldByName('territorioCrianca').asString,
          tObject(qry.FieldByName('idCrianca').asInteger) );
         qry.Next;
         i:=i+1;
       end;
       cbxCrianca.ItemIndex:=0;
    end;

end.
