program Facilita;

uses
  Vcl.Forms,
  ULogin in 'ULogin.pas' {frmLogin},
  UMenu in 'UMenu.pas' {frmMenu},
  UGrupos in 'UGrupos.pas' {frmGerGrupos},
  UCadGrupo in 'UCadGrupo.pas' {frmCadEdtGrupo},
  UCriancas in 'UCriancas.pas' {frmGerCriancas},
  UCadEdtCrianca in 'UCadEdtCrianca.pas' {frmCadEdtCrianca},
  UCadRelatorio in 'UCadRelatorio.pas' {frmCadRelatorio},
  UGerRelatorios in 'UGerRelatorios.pas' {frmGerRelatorios},
  UImprimirRelatorio in 'UImprimirRelatorio.pas' {frmGerarRelatorio},
  UEntrarConfig in 'UEntrarConfig.pas' {frmEntrarConfig},
  UConfig in 'UConfig.pas' {frmConfig},
  UEdtSenha in 'UEdtSenha.pas' {frmEdtSenha},
  uConnection in 'uConnection.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMenu, frmMenu);
  Application.Run;
end.
