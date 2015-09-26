unit ClientForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Win.ScktComp, Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    ClientSocket1: TClientSocket;
    Edit1: TEdit;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ClientSocket1Disconnect(Sender: TObject;  Socket: TCustomWinSocket);
    procedure ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket;  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
  private
    str : string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
    Str:=Edit1.Text;
    Memo1.Text:=Memo1.Text+'me: '+str+#13#10;
    Edit1.Text:='';//Clears the edit box
    ClientSocket1.Socket.SendText(str);//Send the messages to the server
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
   //127.0.0.1 is the standard IP address to loop back to your own machine
    ClientSocket1.Address :='127.0.0.1';
    ClientSocket1.Active := True;//Activates the client

 if(ClientSocket1.Socket.Connected=True)
    then
    begin
      str:='Disconnected';
      ClientSocket1.Active := False;//Disconnects the client
      Button2.Caption:='Connect';
    end;
end;

procedure TForm2.ClientSocket1Disconnect(Sender: TObject;  Socket: TCustomWinSocket);
begin
   Memo1.Text:=Memo1.Text+'Disconnect'+#13#10;
   Socket.SendText(str);//Send the ¡°Disconnected¡± message to the server
//str is set to ¡°Disconnected¡± when the Disconnect button is pressed
//A client cannot send messages if it is not connected to a server
   Button1.Enabled:=False;
   Edit1.Enabled:=False;
   Button2.Caption:='Connect';
end;

procedure TForm2.ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket;  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode:=0;
  ClientSocket1.Active := False;
// This can happen when no active server is started
  Memo1.Text:=Memo1.Text+'No connection found'+#13#10;
end;

procedure TForm2.ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
begin
//Reads and displays the message received from the server;
    Memo1.Text:=Memo1.Text+'Server: '+Socket.ReceiveText+#13#10;
end;

end.
