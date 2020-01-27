// come�o da unidade

unit uConnection;

interface

uses Classes, DB;

type
  // o que vc quer usar
  TFramework = (fwBDE, fwADO, fwDBExpress);

  // camada de consultas comandos sql etc...
  IQuery = interface;

  // camada de dados
  IConnection = interface
  ['{84A052EE-7AEA-4730-8401-0C820CDE48E8}']
    function getComponent: TComponent;

    // controle de conex�o
    procedure Open;
    procedure Close;
    function isConnected: boolean;

    // controle de transa��o
    procedure StarTransaction;
    procedure Commit;
    procedure Rollback;

    // criador de queries
    function CreateQuery: IQuery;

    // par�metros de conex�o
    function getParams: TStrings;
    function getFramework: TFramework;

    property Params: TStrings read getParams;
  end;

  // defini��o da query
  IQuery = interface
  ['{1D697CB9-A46A-44BE-AC72-85D372771A60}']
    function Conn: IConnection;

    // controle de conex�o
    procedure Open;
    procedure Close;
    function isActive: boolean;

    // execu��o de comandos
    function ExecSQL: Integer;
    function DataSet: TDataSet;

    // comandos sql
    function getSQL: TStrings;
    procedure setSQL(Value: TStrings);
    function getParams: TParams;
    function getFields: TFields;
    function FieldByName(Name: String): TField;

    property SQL: TStrings read getSQL write setSQL;
    property Fields: TFields read getFields;
  end;

implementation

end.

// fim da unidade
