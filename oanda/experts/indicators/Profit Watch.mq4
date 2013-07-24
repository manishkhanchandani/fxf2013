//+------------------------------------------------------------------+
//|                                                  ProfitWatch.mq4 |
//|                                       Copyright © 2012,FX Tools. |
//|                                          http://www.fxtools.info |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012,FX Tools."
#property link      "http://www.fxtools.info"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Gold
#property indicator_color2 Red
#property indicator_levelcolor Silver

extern int period=2000;

//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
int tik,t;
double buf[],MaxB,MinB=1000;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_SECTION);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_NONE);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetLevelValue(0,0.0); 
   SetLevelStyle(2,1,Silver);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- 
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i,b;
//---- 
t++;
b=period;
ArrayResize(buf,b);

if(tik==0)
   {
   for(i=0;i<b;i++)
      {
      buf[i]=AccountEquity()-AccountBalance();  
      }
   ExtMapBuffer2[0]=AccountEquity()-AccountBalance();   
   ExtMapBuffer2[1]=AccountEquity()-AccountBalance();   
   tik=1;
   }
   MaxB=0;MinB=1000;
   for(i=b-1;i>0;i--)
      {
      buf[i]=buf[i-1];
      if(MaxB<buf[i])MaxB=buf[i];
      if(MinB>buf[i])MinB=buf[i];
      } 
buf[0]=AccountEquity()-AccountBalance();
for(i=0;i<b;i++)
   {
   ExtMapBuffer1[i]=buf[i];
   } 
if(MathCeil(t/10)*10==t)
   {
   for(i=b;i<Bars;i++)
      {
      ExtMapBuffer1[i]=AccountEquity()-AccountBalance();
      }
      ArrayInitialize(ExtMapBuffer2,AccountEquity()-AccountBalance()); 
      if(MaxB-AccountEquity()-AccountBalance()<5*Point)ExtMapBuffer2[0]=AccountEquity()-AccountBalance();
      if(AccountEquity()-AccountBalance()-MinB<5*Point)ExtMapBuffer2[1]=AccountEquity()-AccountBalance();
      //Print(MaxB,"+",Bid,"+",MinB);
   }   
//----
   return(0);
  }
//+------------------------------------------------------------------+