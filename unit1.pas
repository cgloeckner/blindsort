unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    btnSwap: TButton;
    Button2: TButton;
    Label1: TLabel;
    pboxArray: TPaintBox;
    pboxOutput: TPaintBox;
    sedNum: TSpinEdit;
    procedure btnSwapClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pboxArrayClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

  data: array of integer;
  n, comp, swap, sel1, sel2: integer;

 const
     size = 25;
     pad  = 2;

implementation

{$R *.lfm}

{ TForm1 }

procedure reset();
var i, j: integer;
begin
    sel1 := -1;
    sel2 := -1;
    comp := 0;
    swap := 0;
    n := Form1.sedNum.Value;
    setLength(data, n);
    for i := 0 to n-1 do
        data[i] := random(n*n);
end;

procedure display();
var width, x, i: integer;
begin
    if n > 0 then
    begin
        // setup form
        width := size * n + (n+1) * pad;
        if width < 300 then
            width := 300;
        Form1.Width := width;
        Form1.pboxArray.Width := width;
        Form1.pboxOutput.Left := width div 2 - size div 2;
        // draw array
        Form1.Refresh;
        x := 0;
        for i := 0 to n-1 do
        begin
            if (sel1 = i) or (sel2 = i) then
                Form1.pboxArray.Canvas.Brush.Color := clYellow
            else
                Form1.pboxArray.Canvas.Brush.Color := clBlue;
            Form1.pboxArray.Canvas.Rectangle(x, 0, x+size, size);
            Inc(x, size + pad);
        end;
        // draw output
        if (sel1 <> -1) and (sel2 <> -1) then
        begin
            Inc(comp);
            if data[sel1] <= data[sel2] then
                Form1.pboxOutput.Canvas.Brush.Color := clLime
            else
                Form1.pboxOutput.Canvas.Brush.Color := clRed;
        end
        else
            Form1.pboxOutput.Canvas.Brush.Color := clGray;
        Form1.pboxOutput.Canvas.Rectangle(0,0,size,size);
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    randomize;
    n := 0;
    comp := 0;
    swap := 0;
    sel1 := -1;
    sel2 := -1;
end;

procedure TForm1.pboxArrayClick(Sender: TObject);
var i: integer;
begin
    if n > 0 then
    begin
        // calculate index
        i := Mouse.CursorPos.x - Form1.Left - pad;
        i := i div (size + pad);

        // update selection
        btnSwap.Enabled := False;
        if sel1 = -1 then
            sel1 := i       // select 1st
        else if sel2 = -1 then
        begin
            sel2 := i;      // select 2nd
            btnSwap.Enabled := True;
        end
        else
        begin
            sel1 := i;     // new selection
            sel2 := -1;
        end;

        display;
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    reset;
    display;
end;

procedure TForm1.Button2Click(Sender: TObject);
var i: integer;
    check: boolean;
begin
    check := True;
    for i := 1 to n-1 do
        if data[i] < data[i-1] then
            check := False;

    if not check then
        ShowMessage('Noch nicht!')
    else
        ShowMessage('Okay. Das waren ' + IntToStr(comp)
            + ' Vergleiche und ' + IntToStr(swap)
            + ' Austausche');
end;

procedure TForm1.btnSwapClick(Sender: TObject);
var tmp: integer;
begin
    if (sel1 > -1) and (sel2 > -1) then
    begin
        tmp := data[sel1];
        data[sel1] := data[sel2];
        data[sel2] := tmp;

        Inc(swap);
        sel1 := -1;
        sel2 := -1;
        display;
    end;
end;

end.

