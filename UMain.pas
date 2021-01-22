unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, Grids, ExtCtrls;

type
  TFMain = class(TForm)
    Pn1: TPanel;
    Pn2: TPanel;
    Pn3: TPanel;
    Pn4: TPanel;
    SgPoints: TStringGrid;
    Pn5: TPanel;
    Label1: TLabel;
    SeKolStudents: TSpinEdit;
    Label2: TLabel;
    SeKolExperts: TSpinEdit;
    BtLoadStudentData: TButton;
    BtLoadExpertData: TButton;
    MeStudent: TMemo;
    MeExperts: TMemo;
    Pn6: TPanel;
    Pn7: TPanel;
    Label3: TLabel;
    MeProtocol: TMemo;
    BtStart: TButton;
    Pn8: TPanel;
    SgRang: TStringGrid;
    Pn9: TPanel;
    RgTypeVivod: TRadioGroup;
    Pn10: TPanel;
    Label4: TLabel;
    MeResult: TMemo;
    procedure SeKolStudentsChange(Sender: TObject);
    procedure SeKolExpertsChange(Sender: TObject);
    procedure SgPointsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure SgPointsSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure BtStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RgTypeVivodClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

TStudent = record
          Name:string;
          Character:string;
          end;

TExperts = record
          Name:string;
          Character:string;
          Points:array of LongWord;
          end;

TElementResItog = record
                  Alternativa:LongWord;
                  ArrBKrit:array [1..20] of Boolean;
                  end;

TDinArr = array of array of LongInt;
TDinBuf = array of LongInt;

var
  FMain: TFMain;
  ArrStudents:array of TStudent;
  ArrExperts:array of TExperts;
  ArrExpertsPoints:TDinArr;
  ArrOtnoshen:TDinArr;
  ArrPoteri:array of TDinArr;
  ArrPoteriOpt:TDinArr;
  ResOtnBol,ResBorda,ResKomplenda,ResSimpsona,ResMedianaKemeniSh,ResMedianaKemeni:TDinArr;
  ResItog:array of array of TElementResItog;
  KoefKonkordac:Double;

implementation

{$R *.dfm}

procedure TFMain.FormCreate(Sender: TObject);
begin
SgRang.ColWidths[0]:=40;
SgRang.Cells[0,0]:='Место';
SgRang.Cells[1,0]:='Большинство';
SgRang.Cells[2,0]:='по Борда';
SgRang.Cells[3,0]:='по Компленда';
SgRang.Cells[4,0]:='по Симпсону';
SgRang.Cells[5,0]:='Медиана Кемени сущ';
SgRang.Cells[6,0]:='Медиана Кемени нов';
end;

procedure TFMain.SeKolStudentsChange(Sender: TObject);
var
  i:Longword;
begin
SgRang.RowCount:=SeKolStudents.Value+1;
for i:=1 to SeKolStudents.Value do
  SgRang.Cells[0,i]:=IntToStr(i);

SgPoints.RowCount:=SeKolStudents.Value+1;
SetLength(ArrStudents,SeKolStudents.Value);
If SeKolExperts.Value>0 then
for i:=0 to SeKolExperts.Value-1 do
  begin
  SetLength(ArrExperts[i].Points,SeKolStudents.Value);
  end;
end;

procedure TFMain.SeKolExpertsChange(Sender: TObject);
var
  i:Longword;
begin
SgPoints.ColCount:=SeKolExperts.Value+1;
SetLength(ArrExperts,SeKolExperts.Value);
If SeKolExperts.Value>0 then
for i:=0 to SeKolExperts.Value-1 do
  SetLength(ArrExperts[i].Points,SeKolStudents.Value);
end;

procedure TFMain.SgPointsSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
MeStudent.Clear;
If ARow<>0 then
  begin
  MeStudent.Lines.Add('Участник '+ArrStudents[ARow-1].Name);
  MeStudent.Lines.Add(ArrStudents[ARow-1].Character);
  end;
MeExperts.Clear;
if ACol<>0 then
  begin
  MeExperts.Lines.Add('Эксперт '+ArrExperts[ACol-1].Name);
  MeExperts.Lines.Add(ArrExperts[ACol-1].Character);
  end;
end;

procedure TFMain.SgPointsSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: String);
begin
If (ARow=0) and (ACol<>0) then
  begin
  ArrExperts[ACol-1].Name:=SgPoints.Cells[ACol,ARow];
  end
else
if (ACol=0) and (ARow<>0) then
  begin
  ArrStudents[ARow-1].Name:=SgPoints.Cells[ACol,ARow];
  end
else
if (ACol<>0) and (ARow<>0) then
  begin
  //val
  ArrExperts[ACol-1].Points[ARow-1]:=StrToInt(SgPoints.Cells[ACol,ARow])
  end;
end;

//Процедура построения матрицы Эксперт-Альтернатива (Эксперт - столбец, Строка обозначает место, элемент матрицы - номер участника)
procedure GetArrayExpertsPoint;
var
  NomExpert,NomPoint:LongWord;
begin
with FMain do
begin
SetLength(ArrExpertsPoints,SeKolExperts.Value);               //Установить размерность матрицы экспертов
If Length(ArrExpertsPoints)<>0 then
For NomExpert:=0 to SeKolExperts.Value-1 do                   //Пройти всех экспертов
  begin
  setLength(ArrExpertsPoints[NomExpert],SeKolStudents.Value); //Установить размерность вектора мест для каждого эксперта
  If Length(ArrExpertsPoints[NomExpert])<>0 then
  For NomPoint:=0 to SeKolStudents.Value-1 do
    ArrExpertsPoints[NomExpert][ArrExperts[NomExpert].Points[NomPoint]-1]:=NomPoint;
  end;
end;
end;

//Процедура вывода матрицы Эксперт-Альтернатива в поле TMemo
Procedure VisibleArrayExpertPoin(Me:TMemo);
var
  NomExpert,NomPoint:LongWord;
  st:string;
begin
If (Length(ArrExpertsPoints)<>0) and (Length(ArrExpertsPoints[0])<>0) then
For NomPoint:=0 to Length(ArrExpertsPoints[0])-1 do
  begin
  st:='';
  For NomExpert:=0 to Length(ArrExpertsPoints)-1 do
    St:=st+IntTostr(ArrExpertsPoints[NomExpert][NomPoint]+1)+' ';
  Me.Lines.Add(st);
  end;
end;

Procedure VisibleTDinArrMemo(Arr:TDinArr; Me:TMemo; MSt:string; TypeVivod:LongWord);
var
  i,j:LongWord;
  st:string;
begin
Me.Lines.Add(MSt);
If Length(Arr)<>0 then
for i:=0 to Length(Arr)-1 do
  begin
  st:='';
  If Length(Arr[i])<>0 then
  for j:=0 to Length(Arr[i])-1 do
    case TypeVivod of
      0: st:=st+IntTostr(Arr[i][j])+'; ';
      1: st:=st+ArrStudents[Arr[i][j]-1].Name+'; ';
    end;
  Me.Lines.Add(st);
  end;
end;

procedure VisibleTDinBufMemo(Arr:TDinBuf; Me:TMemo; MSt:string);
var
  i:LongWord;
  st:string;
begin
st:='';
Me.Lines.Add(MSt);
If Length(arr)<>0 then
For i:=0 to Length(Arr)-1 do
  st:=st+IntToStr(Arr[i])+' ';
Me.Lines.Add(st);
end;

//Процедура поиска ранжировке, отвечающей правилу относительного большинства
procedure GoOtnBol;
var
  ArrStud:TDinBuf;                 //Дополнительный буффер
  n,k,NomExpert,NomPoint,NomStud,Max,NomSearch,NomSearch1:LongWord;
  SearchOk:Boolean;
begin
If (Length(ArrExpertsPoints)<>0) and (Length(ArrExpertsPoints[0])<>0) then
begin
n:=Length(ArrExpertsPoints[0]);
SetLength(ArrStud,n);
SetLength(ResOtnBol,n);
For NomPoint:=0 to length(ArrStud)-1 do         //Проходим по всем местам
  begin
  for NomStud:=0 to length(ArrStud)-1 do        //Обнуляем буфер
    ArrStud[NomStud]:=0;
  For NomExpert:=0 to Length(ArrExpertsPoints)-1 do         //Проходим по всем экспертам
    inc(ArrStud[ArrExpertsPoints[NomExpert][NomPoint]]);    //увеличим количество "очков" у выбранного на место участника
  Max:=0;
  NomStud:=0;
  While  NomStud<length(ArrStud) do                    //Поиск участника, которого выбрало максимальное количество экспертов
    begin
    If ArrStud[NomStud]>Max then                            //Если нашли участника с большим количеством очков
      begin
      NomSearch:=0;                                //Проверяем на наличие данного участника в ответе
      SearchOk:=False;
      While (NomSearch<NomPoint) and (Length(ResOtnBol[NomSearch])<>0) do  //Пока в ответе остались поля
        begin
        NomSearch1:=0;                                       //Проверяем возможность нахождения в ответе двух участников на одной позиции
        While NomSearch1<Length(ResOtnBol[NomSearch]) do
          begin
          If ResOtnBol[NomSearch][NomSearch1]=NomStud+1 then
            SearchOk:=True;
          inc(NomSearch1);
          end;
        Inc(NomSearch);
        end;

      if not SearchOk then         //Если в ответе нет такого участника
        Max:=ArrStud[NomStud]
      else
        ArrStud[NomStud]:=0;       //Иначе обнуление количества очков у участника (что бы случайно очки не совпали)
      end;
    inc(NomStud);
    end;
  k:=0;
  If Max<>0 then
  for NomStud:=0 to Length(ArrStud)-1 do   //Поиск всех участников с максимальным количеством очков
    If (ArrStud[NomStud]=Max) then
      begin
      Inc(k);
      SetLength(ResOtnBol[NomPoint],k);
      ResOtnBol[NomPoint][k-1]:=NomStud+1;
      end;
  end;
end;
end;

//Создаем ранжировку по принципу максимального значения буфера
procedure GoArrDinInMaxElement(ArrStud:TDinBuf; var ResDin:TDinArr);
var
  n,k,s,NomPoint,NomStud:LongWord;
  Max:LongInt;
begin
n:=Length(ArrStud);
NomPoint:=0;     //Пока не рассмотрены все участники
k:=0;
While NomPoint<n do
  begin
  SetLength(ResDin,k+1);
  Max:=-MaxInt;
  For NomStud:=0 to n-1 do     //Ищем максимальное значение баллов для участников
    If ArrStud[NomStud]>Max then
      Max:= ArrStud[NomStud];
  s:=0;
  For NomStud:=0 to n-1 do //Запоминаем всех участников с максимальным значением
    begin

    If ArrStud[NomStud]=Max then
      begin
      Inc(s);
      SetLength(ResDin[k],s);
      ResDin[k][s-1]:=NomStud+1;
      Inc(NomPoint);     //Увеличиваем количество рассмотренных участников
      ArrStud[NomStud]:=-MaxInt;  //Изменяем количество баллов у участников
      end;
    end;
    Inc(k);
  end;
end;


//Процедура поиска ранжировки по Борда
procedure GoBorda;
var
  ArrStud:TDinBuf;                 //Дополнительный буффер
  n,k,s,NomExpert,NomPoint,NomStud:LongWord;
  Max:LongInt;
begin
If (Length(ArrExpertsPoints)<>0) and (Length(ArrExpertsPoints[0])<>0) then
begin
n:=Length(ArrExpertsPoints[0]);
SetLength(ArrStud,n);
SetLength(ResBorda,n);
for NomStud:=0 to n-1 do        //Обнуляем буфер
  ArrStud[NomStud]:=0;
for NomExpert:=0 to Length(ArrExpertsPoints)-1 do   //Получаем массив значений для алгоритма Борда
  For NomPoint:=0 to n-1 do
     ArrStud[ArrExpertsPoints[NomExpert][NomPoint]]:=ArrStud[ArrExpertsPoints[NomExpert][NomPoint]]+n-NomPoint;

VisibleTDinBufMemo(ArrStud,FMain.MeProtocol,'Очки по Борда');
GoArrDinInMaxElement(ArrStud,ResBorda);
end;
end;

procedure GoKomplendaSimpsona;
var
  NomExpert,NomPoint,NomPoint2,n:LongWord;
  Min:Longint;
  ArrStud:TDinBuf;                 //Дополнительный буффер
begin
If (Length(ArrExpertsPoints)<>0) and (Length(ArrExpertsPoints[0])<>0) then
begin
n:=Length(ArrExpertsPoints[0]);
SetLength(ArrStud,n);
SetLength(ArrOtnoshen,n);
For NomExpert:=0 to n-1 do                           //Задание массива отношений альтернатив (элемент показывает сколько экспертов считает альтернативу столбца предпочтительнее альтеративы строки)
  SetLength(ArrOtnoshen[NomExpert],n);
For NomExpert:=0 to n-1 do                           //Обнуление массива
  For NomPoint:=0 to n-1 do
    ArrOtnoshen[NomExpert][NomPoint]:=0;
For NomExpert:=0 to Length(ArrExpertsPoints)-1 do    //Проход по всем экспертам
  For NomPoint:=0 to n-2 do                          //Выбираем лучшую альтернативу
    For NomPoint2:=NomPoint+1 to n-1 do              //Выбираем альтернативу, которая хуже
      Inc(ArrOtnoshen[ArrExpertsPoints[NomExpert][NomPoint]][ArrExpertsPoints[NomExpert][NomPoint2]]); //Увеличиваем счетчик в таблице

VisibleTDinArrMemo(ArrOtnoshen,FMain.MeProtocol,'Матрица отношений для Компленда и Симпсона',0);

//Вычисляем ранжировку по правилу Компленда
For NomPoint:=0 to n-1 do
  ArrStud[NomPoint]:=0;
For NomPoint:=0 to n-1 do
  For NomPoint2:=0 to n-1 do
    if ArrOtnoshen[NomPoint][NomPoint2]>ArrOtnoshen[NomPoint2][NomPoint] then
      Inc(ArrStud[NomPoint])
    else
    if ArrOtnoshen[NomPoint][NomPoint2]<ArrOtnoshen[NomPoint2][NomPoint] then
      Dec(ArrStud[NomPoint]);
//Создаем ранжировку по принципу максимального значения буфера
VisibleTDinBufMemo(ArrStud,FMain.MeProtocol,'Очки по Компленда');
GoArrDinInMaxElement(ArrStud,ResKomplenda);

//Вычисляем ранжировку по правилу Симпсона
For NomPoint:=0 to n-1 do
  begin
  Min:=n;
  For NomPoint2:=0 to n-1 do
    if (NomPoint<>NomPoint2) and (ArrOtnoshen[NomPoint][NomPoint2]<Min) then
      Min:=ArrOtnoshen[NomPoint][NomPoint2];
  ArrStud[NomPoint]:=Min;
  end;
//Создаем ранжировку по принципу максимального значения буфера
VisibleTDinBufMemo(ArrStud,FMain.MeProtocol,'Очки по Симпсону');
GoArrDinInMaxElement(ArrStud,ResSimpsona);
end;
end;

procedure GoMedianaKemeni;
var
  NomExpert,NomExpert2,NomPoint,NomPoint2,NomPointBuf,n,m,NomMinExpert,NomMinPoint,NomRes:LongWord;
  GoBool:Boolean;
  Min:Longint;
  ArrRast:TDinArr;                 //Матрица расстояний между ранжировками
  ArrStud:TDinBuf;                 //Дополнительный буффер
begin
If (Length(ArrExpertsPoints)<>0) and (Length(ArrExpertsPoints[0])<>0) then
begin
n:=Length(ArrExpertsPoints);  //Тут n-число экспертов, а не альтернатив

SetLength(ArrPoteri,n);
m:=Length(ArrExpertsPoints[0]);
For NomExpert:=0 to n-1 do                        //Задание массива потерь альтернатив (элемент показывает лучше одна альтернатива другой или нет)
  begin
  SetLength(ArrPoteri[NomExpert],m);
  For NomPoint:=0 to m-1 do
    SetLength(ArrPoteri[NomExpert][NomPoint],m);
  end;
For NomExpert:=0 to n-1 do                           //Обнуление массива
  For NomPoint:=0 to m-1 do
    For NomPoint2:=0 to m-1 do
      ArrPoteri[NomExpert][NomPoint][NomPoint2]:=0;
//Составление матриц потерь
For NomExpert:=0 to n-1 do    //Проход по всем экспертам
  For NomPoint:=0 to m-2 do    //Выбираем лучшую альтернативу
    For NomPoint2:=NomPoint+1 to m-1 do    //Выбираем альтернативу, которая хуже
      begin
      ArrPoteri[NomExpert,ArrExpertsPoints[NomExpert][NomPoint],ArrExpertsPoints[NomExpert][NomPoint2]]:=1;
      ArrPoteri[NomExpert,ArrExpertsPoints[NomExpert][NomPoint2],ArrExpertsPoints[NomExpert][NomPoint]]:=-1;
      end;

For NomExpert:=0 to n-1 do    //Проход по всем экспертам
  VisibleTDinArrMemo(ArrPoteri[NomExpert],FMain.MeProtocol,'Матрица потерь для эксперта №'+IntToStr(NomExpert+1),0);

//Вычисляем расстояния между ранжровками
SetLength(ArrRast,n);           //Создание и обнуление матрицы расстояний
For NomExpert:=0 to n-1 do
  begin
  SetLength(ArrRast[NomExpert],n);
  For NomExpert2:=0 to n-1 do
    ArrRast[NomExpert][NomExpert2]:=0;
  end;
For NomExpert:=0 to n-1 do
  For NomExpert2:=0 to n-1 do
    For NomPoint:=0 to m-1 do
      For NomPoint2:=0 to m-1 do
        ArrRast[NomExpert][NomExpert2]:=ArrRast[NomExpert][NomExpert2]+abs(ArrPoteri[NomExpert][NomPoint][NomPoint2]-ArrPoteri[NomExpert2][NomPoint][NomPoint2]);

VisibleTDinArrMemo(ArrRast,FMain.MeProtocol,'Матрица расстояний',0);
//Создаем массив суммарных расстояний и вычисляем минимальное
SetLength(ArrStud,n);
Min:=MaxInt;
For NomExpert:=0 to n-1 do
  begin
  ArrStud[NomExpert]:=0;
  For NomExpert2:=0 to n-1 do
    ArrStud[NomExpert]:=ArrStud[NomExpert]+ArrRast[NomExpert][NomExpert2];
  if ArrStud[NomExpert]<Min then
    begin
    Min:=ArrStud[NomExpert];
    NomMinExpert:=NomExpert;
    end;
  end;

VisibleTDinBufMemo(ArrStud,FMain.MeProtocol,'Суммарные расстояния до других ранжировок');
//Запоминаем ранжировку выбранную согласно медиане Кемени
SetLength(ResMedianaKemeniSh,m);
For NomPoint:=0 to m-1 do
  begin
  SetLength(ResMedianaKemeniSh[NomPoint],1);
  ResMedianaKemeniSh[NomPoint][0]:=ArrExpertsPoints[NomMinExpert][NomPoint]+1;
  end;

//Вычисляем матрицу потерь относительно идеальной ранжировки
SetLength(ArrPoteriOpt,m);
For NomPoint:=0 to m-1 do
  begin
  SetLength(ArrPoteriOpt[NomPoint],m);
  For NomPoint2:=0 to m-1 do
    ArrPoteriOpt[NomPoint][NomPoint2]:=0;
  end;

For NomExpert:=0 to n-1 do       //Вычисляем матрицу потерь
  For NomPoint:=0 to m-1 do
    For NomPoint2:=0 to m-1 do
      if ArrPoteri[NomExpert][NomPoint][NomPoint2]=0 then
        ArrPoteriOpt[NomPoint][NomPoint2]:= ArrPoteriOpt[NomPoint][NomPoint2]+1
      else
        if ArrPoteri[NomExpert][NomPoint][NomPoint2]=-1 then
          ArrPoteriOpt[NomPoint][NomPoint2]:= ArrPoteriOpt[NomPoint][NomPoint2]+2;

VisibleTDinArrMemo(ArrPoteriOpt,FMain.MeProtocol,'Матрица потерь до оптимальной ранжировки',0);

SetLength(ArrStud,m);
SetLength(ResMedianaKemeni,m);
For NomRes:=0 to m-1 do
  begin
  Min:=MaxInt;
  For NomPoint:=0 to m-1 do             //Вычисляем суммы для всех альтернатив, входящих в множество
    begin
    NomPointBuf:=0;
    While (NomPointBuf<NomRes) and (ResMedianaKemeni[NomPointBuf][0]<>NomPoint+1) do
      Inc(NomPointBuf);
    If not (NomPointBuf<NomRes) then
      begin
      ArrStud[NomPoint]:=0;
      For NomPoint2:=0 to m-1 do
        begin
        NomPointBuf:=0;
        While (NomPointBuf<NomRes) and (ResMedianaKemeni[NomPointBuf][0]<>NomPoint2+1) do
          Inc(NomPointBuf);
        if not (NomPointBuf<NomRes) then
          ArrStud[NomPoint]:=ArrStud[NomPoint]+ArrPoteriOpt[NomPoint][NomPoint2];
        end;
      if ArrStud[NomPoint]<Min then    //Поиск минимальной суммы
        begin
        Min:=ArrStud[NomPoint];
        NomMinPoint:=NomPoint;
        end;
      end
    else
      ArrStud[NomPoint]:=-1;
    end;
  VisibleTDinBufMemo(ArrStud,FMain.MeProtocol,'Суммы на шаге №'+IntToStr(NomRes+1));

  SetLength(ResMedianaKemeni[NomRes],1);         //Запоминание альтернативы в конечное решение
  ResMedianaKemeni[NomRes][0]:=NomMinPoint+1;
  end;
end;
end;

Procedure GoKoefKonkordacii;
var
  NomExpert,NomStud,m,n:LongWord;
  mr,s,sum:Double;
begin
m:=Length(ArrExperts);
if m<>0 then
begin
n:=Length(ArrExperts[0].Points);
if n<>0 then
begin
//Вычисляем mr
mr:=0;
for NomExpert:=0 to m-1 do
  for NomStud:=0 to n-1 do
    mr:=mr+ArrExperts[NomExpert].Points[NomStud];
//Определяем S
s:=0;
for NomStud:=0 to n-1 do
  begin
  sum:=0;
  for NomExpert:=0 to m-1 do
    Sum:=Sum+ArrExperts[NomExpert].Points[NomStud];
  s:=s+(sum-mr)*(sum-mr);
  end;

//Вычисляем коэффициент конкордации
KoefKonkordac:=12*s/(m*m*(n*n*n-n))
end;
end;
end;

Procedure VisibleTDinArrSG(Arr:TDinArr; SG:TStringGrid; NomCol:LongWord; TypeVivod:Byte; var MaxLengthSt:Longword);
var
  i,j:LongWord;
  st:string;
begin
If Length(Arr)<>0 then
for i:=0 to Length(Arr)-1 do
  begin
  st:='';
  If Length(Arr[i])<>0 then
  for j:=0 to Length(Arr[i])-1 do
    case TypeVivod of
      0: st:=st+IntTostr(Arr[i][j])+'; ';
      1: st:=st+ArrStudents[Arr[i][j]-1].Name+'; ';
    end;
  If MaxLengthSt<Length(st) then
    MaxLengthSt:=Length(st);
  Sg.Cells[NomCol,i+1]:=st;
  end;
end;

procedure VivodRangInSG;
var
  MaxLengthSt:LongWord;
begin
with FMain do
  begin
  MaxLengthSt:=0;
  VisibleTDinArrSG(ResOtnBol,SgRang,1,RgTypeVivod.ItemIndex,MaxLengthSt);
  If MaxLengthSt>110 then
    SgRang.ColWidths[1]:=MaxLengthSt;
  MaxLengthSt:=0;
  VisibleTDinArrSG(ResBorda,SgRang,2,RgTypeVivod.ItemIndex,MaxLengthSt);
  If MaxLengthSt>110 then
    SgRang.ColWidths[2]:=MaxLengthSt;
  MaxLengthSt:=0;
  VisibleTDinArrSG(ResKomplenda,SgRang,3,RgTypeVivod.ItemIndex,MaxLengthSt);
  If MaxLengthSt>110 then
    SgRang.ColWidths[3]:=MaxLengthSt;
  MaxLengthSt:=0;
  VisibleTDinArrSG(ResSimpsona,SgRang,4,RgTypeVivod.ItemIndex,MaxLengthSt);
  If MaxLengthSt>110 then
    SgRang.ColWidths[4]:=MaxLengthSt;
  MaxLengthSt:=0;
  VisibleTDinArrSG(ResMedianaKemeniSh,SgRang,5,RgTypeVivod.ItemIndex,MaxLengthSt);
  If MaxLengthSt>110 then
    SgRang.ColWidths[5]:=MaxLengthSt;
  MaxLengthSt:=0;
  VisibleTDinArrSG(ResMedianaKemeni,SgRang,6,RgTypeVivod.ItemIndex,MaxLengthSt);
  If MaxLengthSt>110 then
    SgRang.ColWidths[6]:=MaxLengthSt;
  end;
end;

procedure CompareRang(NomPos,NomElement:LongWord; MeResult:TMemo; Arr:TDinArr; st:string; TypeVivod:Byte);
var
NomPosAnother,NomElementAnother:LongWord;
st1:string;
begin
NomPosAnother:=0;
NomElementAnother:=0;
If Length(Arr)<>0 then
  While (NomPosAnother<length(Arr)) and (Length(Arr[NomPosAnother])<>0) and (NomElementAnother<length(Arr[NomPosAnother])) and (Arr[NomPosAnother][NomElementAnother]<>ResMedianaKemeni[NomPos][NomElement]) do
    begin
    inc(NomElementAnother);
    If NomElementAnother>=length(Arr[NomPosAnother]) then
      begin
      Inc(NomPosAnother);
      NomElementAnother:=0;
      end;
    end;
If NomPosAnother<>NomPos then
  begin
  case TypeVivod of
    0:st1:=intToStr(ResMedianaKemeni[NomPos][NomElement]);
    1:st1:=ArrStudents[ResMedianaKemeni[NomPos][NomElement]-1].Name;
    end;
  MeResult.Lines.Add('В ранжировке "'+st+'" альтернатива '+st1+' стоит на '+IntToStr(NomPosAnother+1)+' месте ');
  end;
end;

procedure GoItogRang;
var
  NomPos,NomElement:LongWord;

begin
with FMain do
  begin
  MeResult.Clear;
  MeResult.Lines.Add('Рекомендуемая ранжировка - ранжировка по Медиане Кемени');
  VisibleTDinArrMemo(ResMedianaKemeni,MeResult,'Вычисленная ранжировка по Медиане Кемени в виде новой ранжировки',RgTypeVivod.ItemIndex);
  MeResult.Lines.Add('Отличия других ранжировок:');
  If Length(ResMedianaKemeni)<>0 then
  for NomPos:=0 to Length(ResMedianaKemeni)-1 do
    begin
    If Length(ResMedianaKemeni[NomPos])<>0 then
    for NomElement:=0 to Length(ResMedianaKemeni[NomPos])-1 do       //Выбор элемента на позиции NomPos
      //Поиск позиции  элемента в других ранжировках
      begin
      CompareRang(NomPos,NomElement,MeResult,ResMedianaKemeniSh,'Медиана Кемени среди существующих ранжировок',RgTypeVivod.ItemIndex);
      CompareRang(NomPos,NomElement,MeResult,ResSimpsona,'Симпсона',RgTypeVivod.ItemIndex);
      CompareRang(NomPos,NomElement,MeResult,ResKomplenda,'Компленда',RgTypeVivod.ItemIndex);
      CompareRang(NomPos,NomElement,MeResult,ResBorda,'по принципу Борда',RgTypeVivod.ItemIndex);
      CompareRang(NomPos,NomElement,MeResult,ResOtnBol,'по абсолютному большинству',RgTypeVivod.ItemIndex);
      end;
    end;
  end;
end;

procedure TFMain.BtStartClick(Sender: TObject);
begin
GetArrayExpertsPoint;
MeProtocol.Lines.Add('Матрица Эксперт-Альтернатива');
VisibleArrayExpertPoin(MeProtocol);
GoOtnBol;
VisibleTDinArrMemo(ResOtnBol,MeProtocol,'Вычисление методом абсолютного большинства',RgTypeVivod.ItemIndex);
GoBorda;
VisibleTDinArrMemo(ResBorda,MeProtocol,'Вычисление ранжировки по принципу Борда',RgTypeVivod.ItemIndex);
GoKomplendaSimpsona;
VisibleTDinArrMemo(ResKomplenda,MeProtocol,'Вычисление ранжировки по правилу Компленда',RgTypeVivod.ItemIndex);
VisibleTDinArrMemo(ResSimpsona,MeProtocol,'Вычисление ранжировки по правилу Симпсона',RgTypeVivod.ItemIndex);
GoMedianaKemeni;
VisibleTDinArrMemo(ResMedianaKemeniSh,MeProtocol,'Вычисленная ранжировка по Медиане Кемени среди существующих ранжировок',RgTypeVivod.ItemIndex);
VisibleTDinArrMemo(ResMedianaKemeni,MeProtocol,'Вычисленная ранжировка по Медиане Кемени в виде новой ранжировки',RgTypeVivod.ItemIndex);
GoKoefKonkordacii;
MeProtocol.Lines.Add('Коэффициент конкордации = '+FloatToStr(KoefKonkordac));
VivodRangInSG;
GoItogRang;
end;

procedure TFMain.RgTypeVivodClick(Sender: TObject);
begin
VivodRangInSG;
GoItogRang;
end;

end.
