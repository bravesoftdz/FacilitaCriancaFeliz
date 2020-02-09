unit uSelVisitas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst, Data.DB,
  Data.Win.ADODB, frxClass, frxDBSet,Clipbrd, frxExportPDF, frxExportDOCX,
  frxExportMail;

type
  TfrmSelecionarRel = class(TForm)
    cblRelatorios: TCheckListBox;
    qryVisitas: TADOQuery;
    btnImprimir: TButton;
    relatorio: TfrxReport;
    dtsCabecalho: TfrxDBDataset;
    dtsFrx: TfrxDBDataset;
    dtsReport: TDataSource;
    dtsCab: TDataSource;
    qryRelatorio: TADOQuery;
    qryReport: TADOQuery;
    Label1: TLabel;
    frxToPDF: TfrxPDFExport;
    frxToDOC: TfrxDOCXExport;
    frxMailExport1: TfrxMailExport;
    procedure carregaOpcoes;
    procedure btnImprimirClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    codCrianca:string;
    nmMes:string;
    nmAno:string;
    procedure montaVisitas;
    procedure montaCabecalho;
    constructor Create(AOwner : TComponent; ano: string;  mes: string; idCrianca:string);
  end;

var
  frmSelecionarRel: TfrmSelecionarRel;

implementation

{$R *.dfm}

uses UMenu;

procedure TfrmSelecionarRel.btnImprimirClick(Sender: TObject);
begin
       montaVisitas;
       if qryReport.RecordCount=0 then
       begin
         ShowMessage('nenhum relatório selecionado');
         exit;
       end;
       montaCabecalho;
       relatorio.ShowReport;
end;

procedure TfrmSelecionarRel.montaCabecalho;
begin
    qryRelatorio.Close;
    with qryRelatorio.SQL do
    begin
      clear;
      add('SELECT *                                  ');
      add('FROM vwCabecalhoRel c                     ');
      add('WHERE c.idCrianca = '+codCrianca           );
      add('and c.idVisitador='+frmMenu.idUsuario      );
    end;
    qryRelatorio.Open
end;

procedure TfrmSelecionarRel.montaVisitas;
var i:integer;
begin
    qryReport.Close;
    with qryReport.SQL do
    begin
        Clear;
        Add('select *                              ');
        Add('from vwVisitaRel v                    ');
        Add('where v.idVisitador='+frmMenu.idUsuario);
        Add('and v.mesVisita='+QuotedStr(nmMes)     );
        Add('and v.anoVisita='+QuotedStr(nmAno)     );
        Add('and v.idVisita in (0                  ');

        i:=0;
        for i := 0 to cblRelatorios.Count-1 do
        begin
          if cblRelatorios.Checked[i] then
            begin
               add(','+inttostr(Integer(cblRelatorios.items.objects[i])));
            end;
        end;

        add(')');
     end;
     qryReport.Open;

end;


procedure TfrmSelecionarRel.carregaOpcoes;
var i:integer;
begin
     qryVisitas.Close;
        with   qryVisitas.SQL do
        begin
          clear;
          Add('SELECT v.idVisita, v.tituloVisita, v.nomeGrupo from vwVisitaResumo v');
          Add('where v.idVisitador='+quotedStr(frmMenu.idUsuario));
          add('and mesVisita = '+quotedStr(nmMes));
          add('and anoVisita = '+quotedStr(nmAno));

          add('order by v.nomeGrupo ');
        end;
        qryVisitas.Open;

        i:=0;
       while i<qryVisitas.RecordCount do
       begin
         cblRelatorios.Items.AddObject( qryVisitas.FieldByName('tituloVisita').asString+'-'+qryVisitas.FieldByName('nomeGrupo').asString,
          tObject(qryVisitas.FieldByName('idVisita').asInteger) );
         qryVisitas.Next;
         i:=i+1;
       end;

end;

constructor TfrmSelecionarRel.Create(AOwner: TComponent; ano: string;
  mes: string; idCrianca:string);
begin
    inherited Create(AOwner);
    nmAno:=ano;
    nmMes:=mes;
    codCrianca:=idCrianca;
    carregaOpcoes;
end;

procedure TfrmSelecionarRel.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    qryVisitas.Close;
    qryRelatorio.Close;
    qryReport.Close;
    Action := caFree;
end;

end.
