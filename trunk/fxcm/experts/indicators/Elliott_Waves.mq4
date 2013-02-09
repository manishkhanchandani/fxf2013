//+------------------------------------------------------------------+
//|                                                Elliott_Waves.mq4 |
//|                                Copyright � 2009, ������� ������� |
//|                                                �million@narod.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright � 2009, ������� �������"
#property link      "�million@narod.ru"
 
#property indicator_chart_window
 
   datetime X1,X2;
   double   Y1,Y2,LINE[11][6];
   int �����,�_�����,�����,����;
   double High_Win,Low_Win,shift_X,shift_Y;
   string Name[11]={ "-",
                     "1 ����� ","2 ����� ","3 ����� ","4 ����� ","5 ����� ",
                     "a ����� ","b ����� ","c ����� ","d ����� ","e ����� "};
   string �����,Obj_Name,����;
   int per;
   extern bool  ��������_���_������� = true;
   extern color �1=White;
   extern color �2=DeepSkyBlue;
   extern color �3=Yellow;
   extern color �4=Turquoise;
   extern color �5=Magenta;
   extern color �6=Yellow;
   extern color �7=MediumSpringGreen;
   extern color �8=Violet;
   extern color �9=DarkOrchid;
 
//�������������������������������������������������������������������
//////////////////////////////////////////////////////////////////////
int init()
{
   ObjectCreate ("���", OBJ_LABEL, 0, 0, 0);// �������� ���.
   ObjectSet    ("���", OBJPROP_XDISTANCE, 500);      
   ObjectSet    ("���", OBJPROP_YDISTANCE, 0);
   ObjectSet    ("���", OBJPROP_CORNER, 1); //����_������_�������
   per =Period();
   Obj_Name = string_���(per);
   for(int k=0; k<=10; k++) Name[k] = Name[k]+Obj_Name;
   Comment("����� ������� "+Obj_Name+" "+�����(CurTime()));
   return(0);
}
//�������������������������������������������������������������������
//*////////////////////////////////////////////////////////////////*//
int deinit()
  {
      ObjectDelete("���");
      �������_�������("�");
      �������_�������("Name");
      �������_�������("����");
   return(0);
  }
//*////////////////////////////////////////////////////////////////*//
//�������������������������������������������������������������������
 
//�������������������������������������������������������������������
//////////////////////////////////////////////////////////////////////
int start()
{
   High_Win = WindowPriceMax();
   Low_Win  = WindowPriceMin();
   shift_X = WindowBarsPerChart();
   ObjectSetText("���","��� �� ������ "+DoubleToStr(shift_X,0),8,"Arial",White);   
   shift_X = shift_X/80*per;
   shift_Y = (High_Win-Low_Win) / 50;
   for(int k=0; k<=ObjectsTotal(); k++) 
   {
      Obj_Name = ObjectName(k);                           // ����������� ��� �������
      if (Obj_Name=="") continue;
      ����� = N_�����(Obj_Name);
      if (�����>0&&�����<11)
      {
         if (Obj_Name != Name[�����]) redraw_LINE(Obj_Name,Name[�����]);
         X1 =    ObjectGet(Name[�����], OBJPROP_TIME1); 
         Y1 =    ObjectGet(Name[�����], OBJPROP_PRICE1);
         X2 =    ObjectGet(Name[�����], OBJPROP_TIME2); 
         Y2 =    ObjectGet(Name[�����], OBJPROP_PRICE2);
         ����  = ObjectGet(Name[�����], OBJPROP_COLOR);
         ����� = ObjectGet(Name[�����], OBJPROP_STYLE);
         �_�����=ObjectGet(Name[�����], OBJPROP_WIDTH);
         if (X1 > X2) redraw_LINE(Name[�����],Name[�����]+" r ");
         if (Y1 < Y2) LINE[�����][0]=1; else LINE[�����][0]=-1;//����������� �����
         ObjectDelete("� "+Name[�����]);
         ObjectDelete("���� "+Name[�����]);
         LINE[�����][1]=X1;//������ �����
         LINE[�����][2]=Y1;
         LINE[�����][3]=X2;//����� �����
         LINE[�����][4]=Y2;
         LINE[�����][5]=�����_�����(Name[�����]);
         if ((MathAbs(LINE[�����][3]-LINE[�����+1][1])<per*120) || (MathAbs(LINE[�����][4]-LINE[�����+1][2])/Point<=MarketInfo(Symbol(),MODE_STOPLEVEL)))
         {
            ObjectSet   (Name[�����+1], OBJPROP_COLOR, ����); //�������� - ��������� �����
            ObjectSet   (Name[�����+1], OBJPROP_STYLE, �����);// �����   
            ObjectSet   (Name[�����+1], OBJPROP_WIDTH, �_�����);
            ObjectSet   (Name[�����+1], OBJPROP_PRICE1 ,LINE[�����][4]);//�������� ��������� ����� � ������� PRICE1
            ObjectSet   (Name[�����+1], OBJPROP_TIME1  ,LINE[�����][3]);//�������� ��������� ����� � ������� TIME1
         }
         ���� = "���� "+Name[�����]+" ����� "+DoubleToStr(MathAbs(LINE[�����][2]-LINE[�����][4])/Point,0);
         if (�����==3&&(LINE[3][5]<LINE[2][5]||LINE[3][5]<LINE[1][5]||LINE[3][5]<LINE[4][5]||LINE[3][5]<LINE[5][5])) ����� = "����� �� ����� ���� ������ � 3 ����� "+DoubleToStr(LINE[�����][5],0);
         else ����� = "V = "+DoubleToStr(LINE[�����][5],0);
         �������_�������("����");
         ObjectCreate (����, OBJ_TEXT  ,0,LINE[�����][3], LINE[�����][4]+shift_Y*�_�����*3*LINE[�����][0],0,0,0,0);
         ObjectSetText(����,����� ,8,"Arial");
         ObjectSet    (����, OBJPROP_COLOR, ����);
         
         ObjectDelete ("Name "+Name[�����]);
         ObjectCreate ("Name "+Name[�����], OBJ_TEXT  ,0,LINE[�����][3], LINE[�����][4]+shift_Y*�_�����*2*LINE[�����][0]+0.7*shift_Y,0,0,0,0);
         if (�������(LINE[�����][3],Name[�����])==true)
         {
            ObjectSetText("Name "+Name[�����], StringSubstr(Name[�����],0,1),10*�_�����,"Arial");
            ObjectSet    ("Name "+Name[�����], OBJPROP_COLOR, ����);
         }
         else
         {
            ObjectSetText("Name "+Name[�����], "��� ��������" ,10,"Arial");
            ObjectSet    ("Name "+Name[�����], OBJPROP_COLOR, Red);
         }
         if (LINE[�����][3]!=LINE[�����+1][1]) // ���� ��� ��������� �����
         {
               if (LINE[�����][1]!=LINE[�����-1][3]) // ���� ��� ���������� �����
               {
                  X1=LINE[�����][3]+(LINE[�����][3]-LINE[�����][1])*0.38;
                  X2=LINE[�����][3]+(LINE[�����][3]-LINE[�����][1])*0.62;
                  Y1=LINE[�����][4]+(LINE[�����][2]-LINE[�����][4])*0.38; 
                  Y2=LINE[�����][4]+(LINE[�����][2]-LINE[�����][4])*0.62;
 
                  if (�����==6) //������� ����� a
                        Y1=LINE[6][4]+(LINE[6][2]-LINE[6][4])*0.50; 
 
               }
               else//���� ���� �����
               {
                  switch(�����)
                  {
                     case 2 ://������� ����� 2
                        X2=LINE[2][3]+(LINE[2][3]-LINE[1][1])/0.38;
                        X1=LINE[2][3]+(LINE[2][3]-LINE[1][1])/0.62;
                        Y1=LINE[1][4]-MathAbs(LINE[1][2]-LINE[1][4])*LINE[2][0]*1.00; 
                        Y2=LINE[1][4]-MathAbs(LINE[1][2]-LINE[1][4])*LINE[2][0]*1.62;
                        break;
                     case 3 ://������� ����� 3
                        X1=LINE[2][1]+(LINE[3][3]-LINE[1][3])*1.38;
                        X2=LINE[3][1]+(LINE[3][3]-LINE[1][3])*1.62;
                        Y1=LINE[3][4]-MathAbs(LINE[3][2]-LINE[3][4])*LINE[3][0]*0.38; 
                        Y2=LINE[3][4]-MathAbs(LINE[3][2]-LINE[3][4])*LINE[3][0]*0.50;
                        if ((Y2<LINE[1][4] && LINE[3][0]==1)||(Y2>LINE[1][4] && LINE[3][0]==-1))
                        {
                           ObjectSetText("Name "+Name[�����],"4 ����� �� ����� ������ ���� 1 �����",8,"Arial");
                           ObjectSet    ("Name "+Name[�����], OBJPROP_COLOR, Red);
                        }
                        if (LINE[1][3]!=LINE[2][1])
                        {
                           ObjectSet(Name[�����], OBJPROP_COLOR, Red);
                           ObjectSetText("Name "+Name[�����],"��� ����� 1",8,"Arial");
                           ObjectSet    ("Name "+Name[�����], OBJPROP_COLOR, Red);
                        }
                        break;
                     case 4 ://������� ����� 4
                        X1=LINE[4][3]+(LINE[3][3]-LINE[3][1])*0.38;
                        X2=LINE[4][3]+(LINE[3][3]-LINE[3][1])*0.62;
                        Y1=LINE[4][2]-MathAbs(LINE[1][2]-LINE[3][4])*LINE[4][0]*0.62; 
                        Y2=LINE[4][2]-MathAbs(LINE[1][2]-LINE[3][4])*LINE[4][0]*1.00;
                        �����="--4 ����� <> 1 �����--";
                        ObjectDelete(�����);
                        if ((LINE[4][4]<LINE[1][4] && LINE[4][0]==-1)||(LINE[4][4]>LINE[1][4] && LINE[4][0]==1))
                        {
                           ObjectSet(Name[�����], OBJPROP_COLOR, Red);
                           ObjectSetText("Name "+Name[�����],"4 ����� �� ����� ������ ���� 1 �����",8,"Arial");
                           ObjectSet    ("Name "+Name[�����], OBJPROP_COLOR, Red);
                           ObjectCreate(�����, OBJ_TREND, 0,LINE[1][3],LINE[1][4],LINE[4][3],LINE[1][4]);
                           ObjectSet   (�����, OBJPROP_COLOR, Red);    // ����   
                           ObjectSet   (�����, OBJPROP_STYLE, STYLE_DASH);// �����   
                           ObjectSet   (�����, OBJPROP_WIDTH, 0);
                           ObjectSet   (�����, OBJPROP_BACK,  true);
                           ObjectSet   (�����, OBJPROP_RAY,   false);     // ���   
                        }
                        if (LINE[1][3]!=LINE[2][1] || LINE[2][3]!=LINE[3][1])
                        {
                           ObjectSet(Name[�����], OBJPROP_COLOR, Red);
                           ObjectSetText("Name "+Name[�����],"��� ����� 1 ��� 2",8,"Arial");
                           ObjectSet    ("Name "+Name[�����], OBJPROP_COLOR, Red);
                        }
                        break;
                     case 5 ://������� ����� 5
                        X1=LINE[5][3]+(LINE[5][3]-LINE[5][1])*0.38;
                        X2=LINE[5][3]+(LINE[5][3]-LINE[5][1])*0.62;
                        Y1=LINE[5][4]-MathAbs(LINE[5][2]-LINE[5][4])*LINE[5][0]*0.38; 
                        Y2=LINE[5][4]-MathAbs(LINE[5][2]-LINE[5][4])*LINE[5][0]*0.62;
                        double MFI_3=iMACD(NULL,0,5,34,5,PRICE_CLOSE,MODE_MAIN  ,iBarShift(NULL,0,LINE[3][3],FALSE));
                        double MFI_5=iMACD(NULL,0,5,34,5,PRICE_CLOSE,MODE_MAIN  ,iBarShift(NULL,0,LINE[5][3],FALSE));
                        if (LINE[1][3]!=LINE[2][1] || LINE[2][3]!=LINE[3][1] || LINE[3][3]!=LINE[4][1])
                        {
                           ObjectSet(Name[�����], OBJPROP_COLOR, Red);
                           ObjectSetText("Name "+Name[�����],"��� ����� 1,2 ��� 3",8,"Arial");
                           ObjectSet    ("Name "+Name[�����], OBJPROP_COLOR, Red);
                        }
                        if ((MFI_3 < MFI_5 && LINE[5][0]==1)||(MFI_3 > MFI_5 && LINE[5][0]==-1))
                        {
                           ObjectDelete ("MFI "+�����(LINE[3][3]));
                           ObjectCreate ("MFI "+�����(LINE[3][3]),OBJ_TEXT,0,LINE[3][3],LINE[5][4]+shift_Y*LINE[5][0],0,0,0,0);
                           ObjectSetText("MFI "+�����(LINE[3][3]),DoubleToStr(MFI_3,0),8,"Arial");
                           ObjectSet    ("MFI "+�����(LINE[3][3]),OBJPROP_COLOR, ����);
                           ObjectDelete ("MFI "+�����(LINE[5][3]));
                           ObjectCreate ("MFI "+�����(LINE[5][3]),OBJ_TEXT,0,LINE[5][3],LINE[5][4]+shift_Y*LINE[5][0],0,0,0,0);
                           ObjectSetText("MFI "+�����(LINE[5][3]),DoubleToStr(MFI_5,0),8,"Arial");
                           ObjectSet    ("MFI "+�����(LINE[5][3]),OBJPROP_COLOR, ����);
                           ObjectSetText("Name "+Name[�����],"��� ����������� MFI 3 � 5 �����",8,"Arial");
                           ObjectSet    ("Name "+Name[�����], OBJPROP_COLOR, Red);
                        }
                        break;
                     case 6 ://������� ����� a
                        X1=LINE[6][3]+(LINE[6][3]-LINE[6][1])*0.38;
                        X2=LINE[6][3]+(LINE[6][3]-LINE[6][1])*0.62;
                        Y1=LINE[6][4]+(LINE[6][2]-LINE[6][4])*0.50; 
                        Y2=LINE[6][4]+(LINE[6][2]-LINE[6][4])*0.62;
                        break;
                     case 7 ://������� ����� b
                        X2=LINE[7][3]+(LINE[7][3]-LINE[6][1])/0.38;
                        X1=LINE[7][3]+(LINE[7][3]-LINE[6][1])/0.62;
                        Y1=LINE[6][4]-MathAbs(LINE[6][2]-LINE[6][4])*LINE[7][0]*1.00; 
                        Y2=LINE[6][4]-MathAbs(LINE[6][2]-LINE[6][4])*LINE[7][0]*1.62;
                        break;
                     case 8 ://������� ����� c
                        X1=LINE[7][1]+(LINE[8][3]-LINE[6][3])*1.38;
                        X2=LINE[7][1]+(LINE[8][3]-LINE[6][3])*1.62;
                        Y1=LINE[8][4]-MathAbs(LINE[8][2]-LINE[8][4])*LINE[8][0]*0.38; 
                        Y2=LINE[8][4]-MathAbs(LINE[8][2]-LINE[8][4])*LINE[8][0]*0.50;
                        if (LINE[6][3]!=LINE[7][1])
                        {
                           ObjectSet(Name[�����], OBJPROP_COLOR, Red);
                           ObjectSetText("Name "+Name[�����],"��� ����� a",8,"Arial");
                           ObjectSet    ("Name "+Name[�����], OBJPROP_COLOR, Red);
                        }
                        break;
                     case 9 ://������� ����� d
                        X1=LINE[9][3]+(LINE[8][3]-LINE[8][1])*0.38;
                        X2=LINE[9][3]+(LINE[8][3]-LINE[8][1])*0.62;
                        Y1=LINE[9][2]-MathAbs(LINE[6][2]-LINE[8][4])*LINE[9][0]*0.62; 
                        Y2=LINE[9][2]-MathAbs(LINE[6][2]-LINE[8][4])*LINE[9][0]*1.00;
                         if (LINE[6][3]!=LINE[7][1] || LINE[7][3]!=LINE[8][1])
                        {
                           ObjectSet(Name[�����], OBJPROP_COLOR, Red);
                           ObjectSetText("Name "+Name[�����],"��� ����� a ��� b ",8,"Arial");
                           ObjectSet    ("Name "+Name[�����], OBJPROP_COLOR, Red);
                        }
                        break;
                     case 10 ://������� ����� e
                        X1=LINE[10][3]+(LINE[10][3]-LINE[10][1])*0.38;
                        X2=LINE[10][3]+(LINE[10][3]-LINE[10][1])*0.62;
                        Y1=LINE[10][4]-MathAbs(LINE[10][2]-LINE[10][4])*LINE[10][0]*0.38; 
                        Y2=LINE[10][4]-MathAbs(LINE[10][2]-LINE[10][4])*LINE[10][0]*0.62;
                        if (LINE[6][3]!=LINE[7][1] || LINE[7][3]!=LINE[8][1] || LINE[8][3]!=LINE[9][1])
                        {
                           ObjectSet(Name[�����], OBJPROP_COLOR, Red);
                           ObjectSetText("Name "+Name[�����],"��� ����� a,b ��� c",8,"Arial");
                           ObjectSet    ("Name "+Name[�����], OBJPROP_COLOR, Red);
                        }
                        break;
                  }//switch
            }
            ObjectCreate("� "+Name[�����], OBJ_TREND, 0,LINE[�����][3],LINE[�����][4],X1,Y1);
            ObjectSet   ("� "+Name[�����], OBJPROP_COLOR, ����);    // ����   
            ObjectSet   ("� "+Name[�����], OBJPROP_STYLE, STYLE_DASH);// �����   
            ObjectSet   ("� "+Name[�����], OBJPROP_WIDTH, 0);
            ObjectSet   ("� "+Name[�����], OBJPROP_BACK,  true);
            ObjectSet   ("� "+Name[�����], OBJPROP_RAY,   false);     // ���   
               
            ObjectCreate("���� "+Name[�����], OBJ_RECTANGLE,0,0,0,0,0);
            ObjectSet   ("���� "+Name[�����], OBJPROP_STYLE, STYLE_DASH);
            ObjectSet   ("���� "+Name[�����], OBJPROP_COLOR, ����);
            ObjectSet   ("���� "+Name[�����], OBJPROP_BACK,  false);
            ObjectSet   ("���� "+Name[�����], OBJPROP_TIME1 ,X1);
            ObjectSet   ("���� "+Name[�����], OBJPROP_PRICE1,Y1);
            ObjectSet   ("���� "+Name[�����], OBJPROP_TIME2 ,X2);
            ObjectSet   ("���� "+Name[�����], OBJPROP_PRICE2,Y2);
         }
      }//-����� 1 - � --------------------------------------------------------------------------------------------------------+
   }//for
  
   ���� = color_per(per);
   for(k=1; k<=10; k++) 
   {
      ObjectDelete ("Name "+k);
      if (ObjectFind(Name[k])==0)
      {
         ObjectCreate ("Name "+k, OBJ_LABEL, 0, 0, 0);// �������� ���.
         ObjectSetText("Name "+k, Name[k]+�����(LINE[k][1])+" "+DoubleToStr(LINE[k][2],Digits)+" "+�����(LINE[k][3])+" "+DoubleToStr(LINE[k][4],Digits)     ,8,"Arial");
         ObjectSet    ("Name "+k, OBJPROP_CORNER, 3);
         ObjectSet    ("Name "+k, OBJPROP_XDISTANCE, 300);
         ObjectSet    ("Name "+k, OBJPROP_YDISTANCE, 10+10*k);
         ObjectSet    ("Name "+k, OBJPROP_COLOR, ����);    // ���� 
      }
      else //������� �������� ��������� �����
      {
         LINE[k][0]=0;LINE[k][1]=0;LINE[k][2]=0;LINE[k][3]=0;LINE[k][4]=0;LINE[k][5]=0;
         //�������_�������("Name");
         //�������_�������("MFI");
         ObjectDelete("� "+Name[k]);
         ObjectDelete("������� "+Name[k]);
         ObjectDelete("color_MFI "+Name[k]+"1");
         ObjectDelete("color_MFI "+Name[k]+"2");
         ObjectDelete("color_MFI "+Name[k]+"3");
         ObjectDelete("color_MFI "+Name[k]+"4");
         ObjectDelete("color_MFI "+Name[k]+"5");
         �������_�������("���� "+Name[k]);
         ObjectDelete("���� "+Name[k]);
         ObjectDelete("Name "+Name[k]);
      } //������� �������� ��������� �����
   }
return;
}
//////////////////////////////////////////////////////////////////////
//�������������������������������������������������������������������*/
 
//�������������������������������������������������������������������*/
//////////////////////////////////////////////////////////////////////
void redraw_LINE(string old, string ���)
{
   datetime x1,x2;
   double   y1,y2;
   ����� = ObjectGet(old, OBJPROP_STYLE);
   ���� = ObjectGet(old, OBJPROP_COLOR);
   �_����� = ObjectGet(old, OBJPROP_WIDTH);    // � �����
   x1 =     ObjectGet(old, OBJPROP_TIME1);
   y1 =     ObjectGet(old, OBJPROP_PRICE1);
   x2 =     ObjectGet(old, OBJPROP_TIME2);
   y2 =     ObjectGet(old, OBJPROP_PRICE2);
   if (x1>x2)
   {
      x2 =     ObjectGet(old, OBJPROP_TIME1);
      y2 =     ObjectGet(old, OBJPROP_PRICE1);
      x1 =     ObjectGet(old, OBJPROP_TIME2);
      y1 =     ObjectGet(old, OBJPROP_PRICE2);
   }
   ObjectDelete(���); //������� ��������
   ObjectCreate(���, OBJ_TREND, 0,  x1,y1,x2,y2);
   ObjectSet   (���, OBJPROP_COLOR, ����);    // ����   
   ObjectSet   (���, OBJPROP_STYLE, �����);    // �����   
   ObjectSet   (���, OBJPROP_WIDTH, �_�����);    // � �����
   ObjectSet   (���, OBJPROP_BACK,  true);
   ObjectSet   (���, OBJPROP_RAY,   false);    // ���   
   ObjectDelete(old);
 
return;
}
//////////////////////////////////////////////////////////////////////
//�������������������������������������������������������������������*/
 
//�������������������������������������������������������������������*/
//////////////////////////////////////////////////////////////////////
//-- ������� -------------------------------------------------------------------------
bool �������(datetime t,string ���)
{
   int i=0,KOD;
   int ���_���=iBarShift(NULL,0,t,FALSE);
   double fr_DN = iFractals(NULL,0,MODE_LOWER,���_���);
   double fr_UP = iFractals(NULL,0,MODE_UPPER,���_���);
   if (fr_UP==0 &&fr_DN ==0) return(false);
   ObjectDelete("������� "+���);
   double y,Y,fr;
   if (ObjectFind(���)==0)
   {
      if (fr_DN!=0) fr=fr_DN; else fr=fr_UP;
      if (t==ObjectGet(���, OBJPROP_TIME2)) ObjectSet(���, OBJPROP_PRICE2,fr);//�������� ����� � ��������
      if (t==ObjectGet(���, OBJPROP_TIME1)) ObjectSet(���, OBJPROP_PRICE1,fr);//�������� ����� � ��������
      ����  = ObjectGet(���, OBJPROP_COLOR);
      �_����� = ObjectGet(���, OBJPROP_WIDTH);    // � �����
   }
   else
   {
      ����  = Yellow;
      �_����� = 1;    // � �����
   }
   if (fr_DN != 0) {Y = fr_DN-shift_Y * �_����� + 0.5 * shift_Y; y = Y + 0.7 * shift_Y; KOD=218;} 
   if (fr_UP != 0) {Y = fr_UP+shift_Y * �_����� + 0.5 * shift_Y; y = Y - 1.2 * shift_Y; KOD=217;}
   ObjectCreate("������� "+���, OBJ_ARROW,0,t,Y,0,0,0,0);
   ObjectSet   ("������� "+���, OBJPROP_ARROWCODE,KOD);
   ObjectSet   ("������� "+���, OBJPROP_COLOR,���� );
   for(int k=���_���-2; k<=���_���+2; k++) 
   {
      i++;
      ObjectDelete("color_MFI "+���+i);
      ObjectCreate("color_MFI "+���+i, OBJ_ARROW,0,Time[k],y,0,0,0,0);
      ObjectSet   ("color_MFI "+���+i, OBJPROP_ARROWCODE,117);
      ObjectSet   ("color_MFI "+���+i, OBJPROP_WIDTH, 0);    // � �����
      ObjectSet   ("color_MFI "+���+i, OBJPROP_BACK, true);
      if ( iVolume(NULL, 0, k) > iVolume(NULL, 0, k+1) && iBWMFI(NULL, 0, k) > iBWMFI(NULL, 0, k+1) ) ObjectSet("color_MFI "+���+i, OBJPROP_COLOR,Lime); //�������
      if ( iVolume(NULL, 0, k) < iVolume(NULL, 0, k+1) && iBWMFI(NULL, 0, k) < iBWMFI(NULL, 0, k+1) ) ObjectSet("color_MFI "+���+i, OBJPROP_COLOR,Brown); //���������
      if ( iVolume(NULL, 0, k) < iVolume(NULL, 0, k+1) && iBWMFI(NULL, 0, k) > iBWMFI(NULL, 0, k+1) ) ObjectSet("color_MFI "+���+i, OBJPROP_COLOR,Blue); //���������
      if ( iVolume(NULL, 0, k) > iVolume(NULL, 0, k+1) && iBWMFI(NULL, 0, k) < iBWMFI(NULL, 0, k+1) ) ObjectSet("color_MFI "+���+i, OBJPROP_COLOR,Pink); //�����������
      ObjectSet("������� "+���, OBJPROP_WIDTH,�_�����);    // � �����
   }
return(true);
}
   //-- ������� -------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////
//�������������������������������������������������������������������*/
 
//�������������������������������������������������������������������
///////////////////////////////////////////////////////////////////
string �����(int taim)
{
   string sTaim;
   //int YY=TimeYear(taim);   // Year         
   int MN=TimeMonth(taim);  // Month                  
   int DD=TimeDay(taim);    // Day         
   int HH=TimeHour(taim);   // Hour                  
   int MM=TimeMinute(taim); // Minute   
 
   if (DD<10) sTaim = "0"+DoubleToStr(DD,0);
   else sTaim = DoubleToStr(DD,0);
   sTaim = sTaim+"/";
   if (MN<10) sTaim = sTaim+"0"+DoubleToStr(MN,0);
   else sTaim = sTaim+DoubleToStr(MN,0);
   sTaim = sTaim+" ";
   if (HH<10) sTaim = sTaim+"0"+DoubleToStr(HH,0);
   else sTaim = sTaim+DoubleToStr(HH,0);
   if (MM<10) sTaim = sTaim+":0"+DoubleToStr(MM,0);
   else sTaim = sTaim+":"+DoubleToStr(MM,0);
   return(sTaim);
}
//*////////////////////////////////////////////////////////////////*//
//�������������������������������������������������������������������
 
//�������������������������������������������������������������������
//////////////////////////////////////////////////////////////////////
int N_�����(string Obj_Name)
{
   if (ObjectType(Obj_Name)!=2) return(-1);//��� ������� �� �����
   int V=-1;
   string volna = StringSubstr( Obj_Name, 0, 2);
   if (volna=="1 ") V=1; 
   if (volna=="2 ") V=2; 
   if (volna=="3 ") V=3; 
   if (volna=="4 ") V=4; 
   if (volna=="5 ") V=5; 
   if (volna=="a ") V=6; 
   if (volna=="b ") V=7; 
   if (volna=="c ") V=8; 
   if (volna=="d ") V=9; 
   if (volna=="e ") V=10;
   if (V<0) return(-1);
   if (StringFind(Obj_Name,"�����",2) != 2) return(V);
   //�������� ������ ����� ������������ "�����"
   if (StringFind(Obj_Name,string_���(per),8) == 8) //����� ������� � ���� ��������� �������
   {
      ���� = color_per(per);
      ObjectSet(Obj_Name,OBJPROP_COLOR,����);
      return(V);
   }
return(-1);
}
//////////////////////////////////////////////////////////////////////
//�������������������������������������������������������������������*/
 
//�������������������������������������������������������������������
//////////////////////////////////////////////////////////////////////
color color_per(int per)
{
      switch(per)
      {
         case 1    :  //1 ������
            return(�1);
         case 5    :  //5 ����� 
            return(�2);
         case 15   :  //15 �����
            return(�3);
         case 30   :  //30 �����
            return(�4);
         case 60   :  //1 ���
            return(�5);
         case 240  :  //4 ����
            return(�6);
         case 1440 :  //1 ����
            return(�7);
         case 10080:  //1 ������
            return(�8);
         case 43200:  //1 �����
            return(�9);
      }
return(Gray);
}
//////////////////////////////////////////////////////////////////////
//�������������������������������������������������������������������*/
 
 
//�������������������������������������������������������������������
//////////////////////////////////////////////////////////////////////
double �����_�����(string Name)
{
   double vol=0;
   int ���_���,���_���;
   int i=0;
   ���_���=iBarShift(NULL,0,ObjectGet(Name, OBJPROP_TIME1),FALSE);
   ���_���=iBarShift(NULL,0,ObjectGet(Name, OBJPROP_TIME2),FALSE);
   for(int n=���_���; n<=���_���; n++) 
   {
      vol = vol + iVolume(NULL,0,n);
      i++;
   }
   vol = vol/i;
//   vol = iVolume(NULL,0,���_���);
return(vol);
}
//////////////////////////////////////////////////////////////////////
//�������������������������������������������������������������������*/
 
//�������������������������������������������������������������������
//*////////////////////////////////////////////////////////////////*//
string string_���(int per)
{
   switch(per)
   {
      case 1    : return("M_1");   //1 ������
         break;
      case 5    : return("M_5");   //5 ����� 
         break;
      case 15   : return("M15");  //15 �����
         break;
      case 30   : return("M30");  //30 �����
         break;
      case 60   : return("H 1");   //1 ���
         break;
      case 240  : return("H_4");   //4 ����
         break;
      case 1440 : return("D_1");   //1 ����
         break;
      case 10080: return("W_1");   //1 ������
         break;
      case 43200: return("MN1");  //1 �����
         break;
   }
return("������ �������");
}
//*////////////////////////////////////////////////////////////////*//
//�������������������������������������������������������������������
 
//�������������������������������������������������������������������
//*////////////////////////////////////////////////////////////////*//
int �������_�������(string PreName)                                     //������� ������� ������������ �� PreName
  {
   for(int k=ObjectsTotal()-1; k>=0; k--) 
     {
      string Obj_Name=ObjectName(k);                           // ����������� ��� �������
      string Head=StringSubstr(Obj_Name,0,StringLen(PreName)); // ��������� ������ ������
 
      if (Head==PreName)// ������ ������, ..
         {
         ObjectDelete(Obj_Name);
         }                  
     }
   return(0);
  }
//*////////////////////////////////////////////////////////////////*//
//�������������������������������������������������������������������