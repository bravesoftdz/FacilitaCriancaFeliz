unit UGrupos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, Data.DB,
  Data.Win.ADODB, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TfrmGerGrupos = class(TForm)
    Label1: TLabel;
    qryPesquisarGrupos: TADOQuery;
    dtsGrupos: TDataSource;
    dbgGrupos: TDBGrid;
    btnAtualizar: TButton;
    btnNovoGrupo: TButton;
    btnEditarGrupo: TButton;
    btnExcluirGrupo: TButton;
    lblTotal: TLabel;
    qryGrupos: TADOQuery;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure PesquisarGrupos;
    procedure ExcluirGrupos;
    procedure btnExcluirGrupoClick(Sender: TObject);
    procedure btnNovoGrupoClick(Sender: TObject);
    procedure btnEditarGrupoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGerGrupos: TfrmGerGrupos;

implementation

{$R *.dfm}

uses UMenu, UCadGrupo;

procedure TfrmGerGrupos.btnAtualizarClick(Sender: TObject);
    begin
        PesquisarGrupos;
    end;

procedure TfrmGerGrupos.btnEditarGrupoClick(Sender: TObject);
    begin
        frmCadEdtGrupo:=TfrmCadEdtGrupo.Create(self,'e',dbgGrupos.DataSource.DataSet.FieldByName('idGrupo').AsString);
        frmCadEdtGrupo.ShowModal;
    end;

procedure TfrmGerGrupos.btnExcluirGrupoClick(Sender: TObject);
    begin
        try
         ExcluirGrupos;
      except
         on e:exception do
         ShowMessage('Erro ao excluir grupo: '+e.Message);
      end;
    end;

procedure TfrmGerGrupos.btnNovoGrupoClick(Sender: TObject);
    begin
        frmCadEdtGrupo:=TfrmCadEdtGrupo.Create(self,'c','0');
        frmCadEdtGrupo.ShowModal;
    end;

procedure TfrmGerGrupos.ExcluirGrupos;
var botaoSelecionado:integer;
    begin
        botaoSelecionado:= messagedlg('Deseja excluir o grupo '+dbgGrupos.DataSource.DataSet.FieldByName('nomeGrupo').AsString+'?',mtConfirmation, [mbYes,mbCancel], 0);
          if botaoSelecionado=6 then
            begin
              qryGrupos.Close;
              with qryGrupos do
                begin
                  qryGrupos.SQL.Clear;
                  qryGrupos.SQL.Add('UPDATE grupo set dtExcluido=getDate()');
                  qryGrupos.SQL.Add('where idGrupo='+dbgGrupos.DataSource.DataSet.FieldByName('idGrupo').AsString);
                end;
              if qryGrupos.ExecSQL=1 then
                begin
                    ShowMessage('Excluido com sucesso!');
                    PesquisarGrupos;
                end;
            end;
    end;

procedure TfrmGerGrupos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := caFree;
end;

procedure TfrmGerGrupos.FormCreate(Sender: TObject);
    begin
        qryPesquisarGrupos.Close;
        PesquisarGrupos;
    end;

procedure TfrmGerGrupos.PesquisarGrupos;
    begin
        qryPesquisarGrupos.Close;
         with qryPesquisarGrupos.SQL do
          begin
              Clear;
              Add('select g.idGrupo         ');
              Add('      ,g.nomeGrupo       ');
              Add('from grupo g             ');
              Add('where g.idVisitador='+frmMenu.idUsuario);
              Add('and dtExcluido is null');

          end;
         qryPesquisarGrupos.Open;
         lblTotal.Caption:='Total de grupos: '+IntToStr(qryPesquisarGrupos.RecordCount);
    end;

end.
