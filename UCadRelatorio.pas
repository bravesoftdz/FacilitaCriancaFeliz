unit UCadRelatorio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Data.DB,
  Data.Win.ADODB;

type
  TfrmCadRelatorio = class(TForm)
    edtTitulo: TEdit;
    Label1: TLabel;
    cbxGrupos: TComboBox;
    Label6: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblTitulo: TLabel;
    cbxMes: TComboBox;
    cbxAno: TComboBox;
    btnSalvarRelatorio: TButton;
    qryRelatorio: TADOQuery;
    edtObjetivo: TMemo;
    edtAcolhimento: TMemo;
    edtDesenvolvimento: TMemo;
    edtMomentoFinal: TMemo;
    procedure carregarGrupos;
    procedure salvarNovoRelatorio;
    procedure editarRelatorio;
    procedure preencherRelatorio;
    procedure btnSalvarRelatorioClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    idRelatorio:string;
    operacao:char;
  public
    constructor Create(AOwner : TComponent; paramOP:char; paramId:string);
  end;

var
  frmCadRelatorio: TfrmCadRelatorio;

implementation

{$R *.dfm}

uses UMenu;

{ TfrmCadRelatorio }

procedure TfrmCadRelatorio.btnSalvarRelatorioClick(Sender: TObject);
    begin
        if operacao='c' then
              begin
                    try
                       salvarNovoRelatorio;
                    except
                       on e:exception do
                       ShowMessage('Erro: '+e.Message);
                    end;
              end
        else if operacao = 'e' then
              begin
                    try
                       editarRelatorio;
                    except
                       on e:exception do
                       ShowMessage('Erro: '+e.Message);
                    end;
              end
    end;

procedure TfrmCadRelatorio.carregarGrupos;
var i:integer;
    begin
        qryRelatorio.Close;
       with qryRelatorio.SQL do
       begin
         Add('select g.idGrupo         ');
         Add('      ,g.nomeGrupo       ');
         Add('from grupo g             ');
         Add('where g.idVisitador='+frmMenu.idUsuario);
         Add('and dtExcluido is null');
       end;
       qryRelatorio.Open;

       i:=0;
       while i<qryRelatorio.RecordCount do
       begin
         cbxGrupos.Items.AddObject( qryRelatorio.FieldByName('nomeGrupo').asString,
          tObject(qryRelatorio.FieldByName('idGrupo').asInteger) );
         qryRelatorio.Next;
         i:=i+1;
       end;
       cbxGrupos.ItemIndex:=0;
    end;

constructor TfrmCadRelatorio.Create(AOwner: TComponent; paramOP: char; paramId: string);
    begin
        inherited Create(AOwner);
        operacao:=paramOP;
        carregarGrupos;
        if operacao='e' then
          begin
             idRelatorio:=paramId;
             lblTitulo.Caption:='Editar relat�rio '+idRelatorio;
             preencherRelatorio;
          end
        else if operacao='v' then
           begin
              idRelatorio:=paramId;
              lblTitulo.Caption:='Visualizar relat�rio '+idRelatorio;
              preencherRelatorio;
              edtTitulo.Enabled:=false;
              edtObjetivo.Enabled:=false;
              edtAcolhimento.Enabled:=false;
              edtDesenvolvimento.Enabled:=false;
              edtMomentoFinal.Enabled:=false;
              cbxGrupos.Enabled:=false;
              cbxMes.Enabled:=false;
              cbxAno.Enabled:=false;
              btnSalvarRelatorio.Visible:=false;
           end;
    end;

procedure TfrmCadRelatorio.editarRelatorio;
    begin
        qryRelatorio.Close;
        if (cbxMes.ItemIndex=0) OR (cbxAno.ItemIndex=0) then
          begin
            ShowMessage('SELECIONE O M�S E ANO DO RELAT�RIO');
          end
        else
          begin
             if operacao='e' then
             begin
                 with qryRelatorio do
                    begin
                      qryRelatorio.SQL.Clear;
                      qryRelatorio.SQL.Add('UPDATE visita ');
                      qryRelatorio.SQL.Add('set tituloVisita='+ QuotedStr(edtTitulo.Text));
                      qryRelatorio.SQL.Add(',objetivo= '+ QuotedStr(edtObjetivo.Lines.GetText));
                      qryRelatorio.SQL.Add(',acolhimento='+ QuotedStr(edtAcolhimento.Lines.GetText));
                      qryRelatorio.SQL.Add(',desenvolvimento='+ QuotedStr(edtDesenvolvimento.Lines.GetText));
                      qryRelatorio.SQL.Add(',momentoFinal='+ QuotedStr(edtMomentoFinal.Lines.GetText));
                      qryRelatorio.SQL.Add(',idGrupo='+inttostr(Integer(cbxGrupos.items.objects[cbxGrupos.ItemIndex])));
                      qryRelatorio.SQL.Add(',mesVisita='+ QuotedStr(cbxMes.Text));
                      qryRelatorio.SQL.Add(',anoVisita='+ cbxAno.Text);
                      qryRelatorio.SQL.Add('where idVisita='+ idRelatorio);
                    end;
                 if qryRelatorio.ExecSQL=1 then
                    begin
                        ShowMessage('Editado com sucesso');
                        frmCadRelatorio.Close;
                    end;
            end
        end;
    end;

procedure TfrmCadRelatorio.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := caFree;
end;

procedure TfrmCadRelatorio.preencherRelatorio;
    begin
        qryRelatorio.Close;
        with qryRelatorio do
        begin
            qryRelatorio.SQL.Clear;
            qryRelatorio.SQL.Add('select v.tituloVisita, v.objetivo, v.acolhimento, v.desenvolvimento');
            qryRelatorio.SQL.Add(', v.momentoFinal, v.idGrupo, v.mesVisita, v.anoVisita, g.nomeGrupo');
            qryRelatorio.SQL.Add('from visita v');
            qryRelatorio.SQL.Add('inner join grupo g on v.idGrupo=g.idGrupo');
            qryRelatorio.SQL.Add('where v.idVisita='+idRelatorio);
        end;
        qryRelatorio.Open;

        //preencher campos
        edtTitulo.Text:=qryRelatorio.FieldByName('tituloVisita').AsString;
        edtObjetivo.Lines.Text:=qryRelatorio.FieldByName('objetivo').AsString;
        edtAcolhimento.Lines.Text:=qryRelatorio.FieldByName('acolhimento').AsString;
        edtDesenvolvimento.Lines.Text:=qryRelatorio.FieldByName('desenvolvimento').AsString;
        edtMomentoFinal.Lines.Text:=qryRelatorio.FieldByName('momentoFinal').AsString;

        if qryRelatorio.FieldByName('mesVisita').AsString = 'JAN' then
          cbxMes.ItemIndex:=1
        else if qryRelatorio.FieldByName('mesVisita').AsString = 'FEV' then
          cbxMes.ItemIndex:=2
        else if qryRelatorio.FieldByName('mesVisita').AsString = 'MAR' then
           cbxMes.ItemIndex:=3
        else if qryRelatorio.FieldByName('mesVisita').AsString = 'ABR' then
          cbxMes.ItemIndex:=4
        else if qryRelatorio.FieldByName('mesVisita').AsString = 'MAI' then
          cbxMes.ItemIndex:=5
        else if qryRelatorio.FieldByName('mesVisita').AsString = 'JUN' then
          cbxMes.ItemIndex:=6
        else if qryRelatorio.FieldByName('mesVisita').AsString = 'JUL' then
          cbxMes.ItemIndex:=7
        else if qryRelatorio.FieldByName('mesVisita').AsString = 'AGO' then
          cbxMes.ItemIndex:=8
        else if qryRelatorio.FieldByName('mesVisita').AsString = 'SET' then
          cbxMes.ItemIndex:=9
        else if qryRelatorio.FieldByName('mesVisita').AsString = 'OUT' then
          cbxMes.ItemIndex:=10
        else if qryRelatorio.FieldByName('mesVisita').AsString = 'NOV' then
          cbxMes.ItemIndex:=11
        else if qryRelatorio.FieldByName('mesVisita').AsString = 'DEZ' then
          cbxMes.ItemIndex:=12 ;

        case qryRelatorio.FieldByName('anoVisita').AsInteger of
            2019:cbxAno.ItemIndex:=1;
            2020:cbxAno.ItemIndex:=2;
        end;
    end;

procedure TfrmCadRelatorio.salvarNovoRelatorio;
    begin
       qryRelatorio.Close;
        if (cbxMes.ItemIndex=0) OR (cbxAno.ItemIndex=0) then
          begin
            ShowMessage('SELECIONE O M�S E ANO DO RELAT�RIO');
          end
        else
          begin
             if operacao='c' then
             begin
                 with qryRelatorio do
                    begin
                      qryRelatorio.SQL.Clear;
                      qryRelatorio.SQL.Add('insert into visita (tituloVisita, dtVisita, objetivo, acolhimento,desenvolvimento,momentoFinal, idGrupo,mesVisita,anoVisita,idVisitador)');
                      qryRelatorio.SQL.Add('values ('+ QuotedStr(edtTitulo.Text));
                      qryRelatorio.SQL.Add(', GETDATE()');
                      qryRelatorio.SQL.Add(','+ QuotedStr(edtObjetivo.Lines.GetText));
                      qryRelatorio.SQL.Add(','+ QuotedStr(edtAcolhimento.Lines.GetText));
                      qryRelatorio.SQL.Add(','+ QuotedStr(edtDesenvolvimento.Lines.GetText));
                      qryRelatorio.SQL.Add(','+ QuotedStr(edtMomentoFinal.Lines.GetText));
                      qryRelatorio.SQL.Add(','+inttostr(Integer(cbxGrupos.items.objects[cbxGrupos.ItemIndex])));
                      qryRelatorio.SQL.Add(','+ QuotedStr(cbxMes.Text));
                      qryRelatorio.SQL.Add(','+ cbxAno.Text);
                      qryRelatorio.SQL.Add(','+frmMenu.idUsuario+')')
                    end;
                 if qryRelatorio.ExecSQL=1 then
                    begin
                        ShowMessage('Cadastrado com sucesso');
                        frmCadRelatorio.Close;
                    end;
            end
        end;
    end;

end.
