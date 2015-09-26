unit serverForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Win.ScktComp, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    ServerSocket1: TServerSocket;
    Edit1: TEdit;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ServerSocket1ClientConnect(Sender: TObject;  Socket: TCustomWinSocket);
    procedure ServerSocket1ClientDisconnect(Sender: TObject;Socket: TCustomWinSocket);
    procedure ServerSocket1ClientRead(Sender: TObject; Socket: TCustomWinSocket);
  private
    Str : string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  i: integer;
begin
     Str:=Edit1.Text;//Take the string (message) sent by the server
     Memo1.Text:=Memo1.Text+'me: '+Str+#13#10;//Adds the message to the memo box
     Edit1.Text:='';//Clears the edit box
//Sends the messages to all clients connected to the server
     for i:=0 to ServerSocket1.Socket.ActiveConnections-1 do
      ServerSocket1.Socket.Connections[i].SendText(str);//Sent
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
   if(ServerSocket1.Active = False)//The button caption is ¡®Start¡¯
   then
   begin
      ServerSocket1.Active := True;//Activates the server socket
      Memo1.Text:=Memo1.Text+'Server Started'+#13#10;
      Button2.Caption:='Stop';//Set the button caption
   end
   else//The button caption is ¡®Stop¡¯
   begin
      ServerSocket1.Active := False;//Stops the server socket
      Memo1.Text:=Memo1.Text+'Server Stopped'+#13#10;
      Button2.Caption:='Start';
     //If the server is closed, then it cannot send any messages
      Button1.Enabled:=false;//Disables the ¡°Send¡± button
      Edit1.Enabled:=false;//Disables the edit box
   end;
end;

procedure TForm1.ServerSocket1ClientConnect(Sender: TObject;  Socket: TCustomWinSocket);
begin
  Socket.SendText('Connected');//Sends a message to the client
//If at least a client is connected to the server, then the server can communicate
//Enables the Send button and the edit box
  Button1.Enabled:=true;
  Edit1.Enabled:=true;
end;

procedure TForm1.ServerSocket1ClientDisconnect(Sender: TObject;Socket: TCustomWinSocket);
Begin
//The server cannot send messages if there is no client connected to it
  if ServerSocket1.Socket.ActiveConnections-1=0 then
  begin
    Button1.Enabled:=false;
    Edit1.Enabled:=false;
  end;
end;

procedure TForm1.ServerSocket1ClientRead(Sender: TObject;Socket: TCustomWinSocket);
Begin
//Read the message received from the client and add it to the memo text
// The client identifier appears in front of the message
  Memo1.Text:=Memo1.Text+'Client'+IntToStr(Socket.SocketHandle)+' :'+Socket.ReceiveText+#13#10;
end;

end.
