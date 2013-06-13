//+------------------------------------------------------------------+
//|                                       CoronaCyclePeriod_v2.1.mq4 |
//|                                Copyright © 2009, TrendLaboratory |
//|            http://finance.groups.yahoo.com/group/TrendLaboratory |
//|                                   E-mail: igorad2003@yahoo.co.uk |
//+------------------------------------------------------------------+
// List of Prices:
// Price    = 0 - Close  
// Price    = 1 - Open  
// Price    = 2 - High  
// Price    = 3 - Low  
// Price    = 4 - Median Price   = (High+Low)/2  
// Price    = 5 - Typical Price  = (High+Low+Close)/3  
// Price    = 6 - Weighted Close = (High+Low+Close*2)/4
// Price    = 7 - Heiken Ashi Close  
// Price    = 8 - Heiken Ashi Open
// Price    = 9 - Heiken Ashi High
// Price    =10 - Heiken Ashi Low

#property copyright "Copyright © 2009, TrendLaboratory"
#property link      "http://finance.groups.yahoo.com/group/TrendLaboratory"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1  Yellow
#property indicator_width1  2  
#property indicator_maximum 31
#property indicator_minimum 5
//---- 
extern int     TimeFrame         =        0;   //Time Frame in min
extern int     Price             =        4;   //Price Mode (0...10)
extern color   LineColor         =   Yellow;
extern int     FuzzR             =      255;
extern int     FuzzG             =        0;
extern int     FuzzB             =        0;
extern int     VisualMode        =        0;   //0-DC+Corona,1-DC,2-Corona 
extern int     CoronaBars        =     1000;
//---- 
double   DomCyc[];
//----
double   haClose[], haOpen[], haHigh[], haLow[], MaxAmpl;
int      draw_begin, pBars, mcnt_bars, per, win, LineR, LineG, LineB; 
string   short_name, hex;
datetime pTime;
double   Q[60], I[60], Real[60], Imag[60], Ampl[60], DB[60], OldI[60], OlderI[60], OldQ[60], OlderQ[60], 
         OldReal[60], OlderReal[60], OldImag[60], OlderImag[60], OldDB[60];
double   FuzzWidth = 0.5;          
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
//---- 
   hex = IntegerToHexString(LineColor);
//----
   LineR = LineColor&0x000000FF;
   LineG = (LineColor>>8)&0x000000FF;
   LineB = (LineColor>>16)&0x000000FF;
   
   if(TimeFrame == 0 || TimeFrame < Period()) TimeFrame = Period();
   per = 30;   
   draw_begin=2*per*TimeFrame/Period();
//---- 
   switch(TimeFrame)
   {
   case 1     : string TF = "M1"; break;
   case 5     : TF = "M5"; break;
   case 15    : TF = "M15"; break;
   case 30    : TF = "M30"; break;
   case 60    : TF = "H1"; break;
   case 240   : TF = "H4"; break;
   case 1440  : TF = "D1"; break;
   case 10080 : TF = "W1"; break;
   case 43200 : TF = "MN1"; break;
   default    : TF = "Current";
   } 
   short_name = "CoronaCyclePeriod_v2.1 ["+TF+"] ("+Price+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,"Dom Cycle");
//---- 
   SetIndexBuffer(0,DomCyc);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexDrawBegin(0,draw_begin);
//----
 
   return(0);
}

//----  
void deinit()
{ 
   ObjectsDeleteAll(win,OBJ_RECTANGLE);  
  
   return(0);
}
//+------------------------------------------------------------------+
//| CoronaCyclePeriod_v2                                             |
//+------------------------------------------------------------------+
int start()
{
   int limit, y, i, shift, n, cnt_bars=IndicatorCounted(); 
   double price[], mDomCyc[], DC[], SmoothHP[], HP[];
   
   double pi = 4 * MathArctan(1);
   
   win = WindowFind(short_name); 
   
   if(TimeFrame!=Period()) int mBars = iBars(NULL,TimeFrame); else mBars = Bars;   
   
   if(mBars != pBars)
   {
   ArrayResize(price,mBars);
   ArrayResize(mDomCyc,mBars);
   ArrayResize(DC,mBars);
   ArrayResize(SmoothHP,mBars);
   ArrayResize(HP,mBars);
      
      if(Price > 6 && Price <= 10)
      {
      ArrayResize(haClose,mBars);
      ArrayResize(haOpen,mBars);
      ArrayResize(haHigh,mBars);
      ArrayResize(haLow,mBars);
      }
  
   pBars = mBars;
   }  
   
   if(cnt_bars<1)
   {
      for(i=Bars-1;i>0;i--) DomCyc[i]=EMPTY_VALUE;
   
   mcnt_bars = 0;
   }
//---- 
   if(mcnt_bars > 0) mcnt_bars--;
   
   for(y=mcnt_bars+1;y<mBars;y++)
   {
      if(Price <= 6) price[y] = iMA(NULL,TimeFrame,1,0,0,Price,mBars-y-1);   
      else
      if(Price > 6 && Price <= 10) price[y] = HeikenAshi(TimeFrame,Price-7,mBars-y-1);
     
   double alpha1 = (1 - MathSin(2*pi/30)) / MathCos(2*pi/30);
   HP[y] = 0.5*(1 + alpha1)*(price[y] - price[y-1]) + alpha1*HP[y-1];
   SmoothHP[y] = (HP[y] + 2.0*HP[y-1] + 3.0*HP[y-2] + 3.0*HP[y-3] + 2.0*HP[y-4] + HP[y-5]) / 12.0;
   if(y < 6)  SmoothHP[y] = price[y] - price[y-1];
   if(y == 0) SmoothHP[y] = 0;
   
   double delta = -0.015*(y+1) + 0.5;
   if(delta < 0.1) delta = 0.1;
   
      if(y > 11)
      {
         if(iTime(NULL,TimeFrame,mBars-y-1) != pTime)
         {
            for(n = 11; n<= 59; n++)
            { 
            OlderI[n] = OldI[n];
            OldI[n] = I[n];
            OlderQ[n] = OldQ[n];
            OldQ[n] = Q[n];
            OlderReal[n] = OldReal[n];
            OldReal[n] = Real[n];
            OlderImag[n] = OldImag[n];
            OldImag[n] = Imag[n];
            OldDB[n] = DB[n];
            }
         pTime = iTime(NULL,TimeFrame,mBars-y-1);
         }
         
         for(n = 11; n<= 59; n++)
         { 	
         double beta = MathCos(4*pi/(n+1));
         double gamma = 1.0/MathCos(8*pi*delta/(n+1));
         double alpha = gamma - MathSqrt(gamma*gamma - 1);
         Q[n] = ((n+1)/4/pi)*(SmoothHP[y] - SmoothHP[y-1]);
         I[n] = SmoothHP[y];
         Real[n] = 0.5*(1 - alpha)*(I[n] - OlderI[n]) + beta*(1 + alpha)*OldReal[n] - alpha*OlderReal[n];
         Imag[n] = 0.5*(1 - alpha)*(Q[n] - OlderQ[n]) + beta*(1 + alpha)*OldImag[n] - alpha*OlderImag[n];
         Ampl[n] = (Real[n]*Real[n] + Imag[n]*Imag[n]);
         }	  
      
      MaxAmpl = Ampl[11];
      for(n = 11; n<= 59; n++) 
         if(Ampl[n] > MaxAmpl) {MaxAmpl = Ampl[n]; int nmax = n;}
   
         for(n = 11; n<= 59; n++)
         {
         if(MaxAmpl != 0) 
            if (Ampl[n] / MaxAmpl > 0) double dB = -10.0*MathLog(0.01/(1 - 0.99*Ampl[n]/MaxAmpl))/MathLog(10.0);
         
         DB[n] = 0.33*dB + 0.67*OldDB[n];
         if(DB[n] > 20) DB[n] = 20;
         }   
         
         double Num = 0;
         double Denom = 0;
         for(n = 11; n<= 59; n++)
         {
            if(DB[n] <= 6) 
            {  
            Num = Num + (n+1)*(20 - DB[n]);
            Denom = Denom + (20 - DB[n]);
            }      
                 
         if(Denom != 0) DC[y] = 0.5*Num / Denom;
         else DC[y] = DC[y-1];
         }
      mDomCyc[y] = Median(DC, 5, y); 
      }      
   
   if(TimeFrame == Period() && VisualMode != 2) DomCyc[mBars-y-1] = mDomCyc[y];
   
   if(VisualMode != 1 && ((CoronaBars > 0 && y > mBars - CoronaBars)||(CoronaBars == 0 && y > draw_begin)))
      for(n = 11; n<= 59; n++)
      {
         if(DB[n] <= 10)
         {
         int Color1 = LineR + DB[n]*(FuzzR - LineR) / 10.0;
         int Color2 = LineG + DB[n]*(FuzzG - LineG) / 10.0;
		   int Color3 = LineB + DB[n]*(FuzzB - LineB) / 10.0;
         }
         else
         if(DB[n] > 10)
         {
         Color1 = FuzzR*(2 - DB[n] / 10.0);
         Color2 = FuzzG*(2 - DB[n] / 10.0);
		   Color3 = FuzzB*(2 - DB[n] / 10.0);
         }
      Plot(TimeFrame,FuzzWidth*(n+1),win+"CCP"+(n+1)+"_"+y, RGB(Color1, Color2, Color3),FuzzWidth,mBars-y-1);
      }
      
    
   mcnt_bars = mBars-1;
   }
   
   if(TimeFrame > Period() && VisualMode != 2)
   { 
      if(cnt_bars>0) cnt_bars--;
      limit = Bars-cnt_bars+TimeFrame/Period()-1;
      
      for(shift=0,y=0;shift<limit;shift++)
      {
      if (Time[shift] < iTime(NULL,TimeFrame,y)) y++; 
      DomCyc[shift] = mDomCyc[mBars-y-1];
      }
   }
//----------   
   WindowRedraw();
   return(0);
}

double Median(double price[],int per,int bar)
{
   double array[];
   ArrayResize(array,per);
   
   for(int i = 0; i < per;i++) array[i] = price[bar-i];
   ArraySort(array);
   
   int num = MathRound((per-1)/2); 
   if(MathMod(per,2)>0) double median = array[num]; else median = 0.5*(array[num]+array[num+1]);
   
   return(median); 
}

double HeikenAshi(int tf,int price,int bar)
{ 
   if(bar == iBars(NULL,TimeFrame)- 1) 
   {
   haClose[bar] = iClose(NULL,tf,bar);
   haOpen[bar]  = iOpen(NULL,tf,bar);
   haHigh[bar]  = iHigh(NULL,tf,bar);
   haLow[bar]   = iLow(NULL,tf,bar);
   }
   else
   {
   haClose[bar] = (iOpen(NULL,tf,bar)+iHigh(NULL,tf,bar)+iLow(NULL,tf,bar)+iClose(NULL,tf,bar))/4;
   haOpen[bar]  = (haOpen[bar+1]+haClose[bar+1])/2;
   haHigh[bar]  = MathMax(iHigh(NULL,tf,bar),MathMax(haOpen[bar], haClose[bar]));
   haLow[bar]   = MathMin(iLow(NULL,tf,bar),MathMin(haOpen[bar], haClose[bar]));
   }
   
   switch(price)
   {
   case 0: return(haClose[bar]);break;
   case 1: return(haOpen[bar]);break;
   case 2: return(haHigh[bar]);break;
   case 3: return(haLow[bar]);break;
   }
}     

int RGB(int R, int G, int B)
{
   return (256*(256*B + G) + R);
}


void Plot(int tf,double value,string name,color clr,double width,int bar)
{   
   ObjectCreate(name,OBJ_RECTANGLE,win,iTime(NULL,tf,bar+1),value-0.5*width,iTime(NULL,tf,bar),value+0.5*width);
   ObjectSet(name,OBJPROP_COLOR,clr);
}

string IntegerToHexString(int integer_number)
{
   string hex_string="00000000";
   int    value, shift=28;
//----
   for(int i=0; i<8; i++)
     {
      value=(integer_number>>shift)&0x0F;
      if(value<10) hex_string=StringSetChar(hex_string, i, value+'0');
      else         hex_string=StringSetChar(hex_string, i, (value-10)+'A');
      shift-=4;
     }
//----
   return(hex_string);
}

