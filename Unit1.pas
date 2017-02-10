unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, jpeg, Menus,ShellAPI,Registry;
const
  WM_NID = WM_USER+1000;
type
  TForm1 = class(TForm)
    image1: TImage;
    label1: TLabel;
    shape1: TShape;
    timer1: TTimer;
    label2: TLabel;
    pm1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    dlgOpen1: TOpenDialog;
    timer3: TTimer;
    timer4: TTimer;
    N4: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure timer1Timer(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure timer3Timer(Sender: TObject);
    procedure timer4Timer(Sender: TObject);
    procedure SetAutorun(aProgTitle,aCmdLine: string; aRunOnce: boolean );
    procedure WMNID(var msg:TMessage);message WM_NID;
    procedure N4Click(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses Unit2 ;
const
  rc=90;

var
   p: array[0..359] of tpoint;
   flag:Boolean = False;
   j:Integer = 10;
  NotifyIcon:TNotifyIconData;//全局变量
{$R *.dfm}

procedure tform1.WMNID(var msg:TMessage);
 var
   a:TPoint;
 begin
  form1.Visible:=False;
case msg.LParam of

WM_LBUTTONUP:
    begin
      ShowWindow(Form1.Handle,SW_SHOWNORMAL);
      SetForegroundWindow(Form1.Handle);//记住这两个函数
    end;

WM_RBUTTONUP:
    begin
      GetCursorPos(a);
      pm1.Popup(a.X,a.Y);
    end;

 end;
end;


procedure TForm1.FormCreate(Sender: TObject);
var
  x,y: real;
  a: integer;
  rgn: hrgn;
begin
  SetAutorun(Application.Title,application.ExeName,false);
  with NotifyIcon do
   begin
     cbSize:=SizeOf(TNotifyIconData);
     Wnd:=handle;
     uID:=1;
     uFlags:=NIF_ICON or NIF_MESSAGE or NIF_TIP;

    uCallBackMessage:=WM_NID;

    hIcon:=Application.Icon.Handle;

    szTip:='小时钟';

   end;

   SetWindowLong(Application.Handle,GWL_EXSTYLE, WS_EX_TOOLWINDOW or WS_EX_STATICEDGE);


   Shell_NotifyIcon(NIM_ADD,@NotifyIcon);
  for a:=0 to 359 do
  begin
    x:= rc*cos(a*pi/180)+rc;
    y:= rc-rc*sin(a*pi/180);
    p[a].x:=trunc(x);
    p[a].y:=trunc(y);
    end;
    rgn:=createpolygonrgn(p, 360, winding);
     setwindowrgn(handle, rgn, true);
     clientwidth:=rc+rc;
     clientheight:=rc+rc;
     top:=10;
     left:=screen.width-width-10;
     showhint:=true;
     hint:='点击右键关闭哦^_^';
     shape1.width:=rc+rc+1;
    shape1.height:=rc+rc+1;
     shape1.top:=-1;
     shape1.left:=-1;

     image1.width:=rc+rc div 2+25+5;
     image1.height:=rc+rc div 2+25+5;
     image1.top:=rc div 2-25-10-3;
     image1.left:=rc div 2-25-10-3;
     label1.Top:=rc div 2+50;
     label1.Left:=rc div 2;
     label2.Left:=rc div 2;
     label2.Top:=rc div 2+50+25;
end;

procedure TForm1.timer1Timer(Sender: TObject);
begin
  label1.Caption:=TimeToStr(time);
  label2.Caption:=DateToStr(Date);
  
end;


procedure TForm1.N1Click(Sender: TObject);
begin
   dlgOpen1.Filter:='图片文件(*.jpg)|*.JPG';
   if dlgOpen1.Execute then
   begin
   image1.Picture.LoadFromFile(dlgOpen1.FileName);
   end
   else
   Exit;
end;

procedure TForm1.N3Click(Sender: TObject);
begin
  form2.Show;
end;

procedure TForm1.N2Click(Sender: TObject);
begin
  ShellExecute(Handle,'open','http://lovewzan.3vzhuji.com/index.html',nil,nil,SW_SHOWNORMAL)  ;
end;

procedure TForm1.timer3Timer(Sender: TObject);

begin
   if flag then
   begin
     Form1.top:=Form1.top+3;

   end
   else
   Form1.top:=Form1.top-3;
   flag:=not flag;
   
end;

procedure TForm1.timer4Timer(Sender: TObject);
begin
   AlphaBlendValue:=j;
   j:=j+10;
   if j = 230 then
   timer4.Destroy;
end;

procedure TForm1.SetAutorun(aProgTitle,aCmdLine: string; aRunOnce: boolean );
var
  hKey: string;
  hReg: TRegIniFile;
begin
  if aRunOnce then
  //程序只自动运行一次
    hKey := 'Once'
  else
    hKey := '';
  hReg := TRegIniFile.Create('');
  //TregIniFile类的对象需要创建
  hReg.RootKey := HKEY_LOCAL_MACHINE;
  //设置根键
  hReg.WriteString('Software\Microsoft\Windows\CurrentVersion\Run'
                  + hKey + #0,
                  aProgTitle,
                  //程序名称，可以为自定义值
                  aCmdLine );
                  //命令行数据，必须为该程序的绝对路径＋程序完整名称
  hReg.destroy;
  //释放创建的hReg
end;


procedure TForm1.N4Click(Sender: TObject);
begin
  if idok = MessageBox(Handle,'你确定？','提示',MB_OKCANCEL or MB_ICONQUESTION) then
 begin

Shell_NotifyIcon(NIM_DELETE,@NotifyIcon);
close;
 end;
end;

end.
