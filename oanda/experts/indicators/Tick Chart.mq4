//+------------------------------------------------------------------+
//|                                                   Tick Chart.mq4 |
//|     Copyright © 2005, MetaQuotes Software Corp. © 2010, J.Arent. |
//|              http://www.metaquotes.net/, http://www.fxtools.info |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 Red
#property indicator_color2 Cornsilk
#property indicator_color3 Blue

extern int period=2000;
extern int width=50;

//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];

int tik,t;
double buf[],buf2[],MaxB,MinB=1000;
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
   SetIndexStyle(2,DRAW_SECTION);
   SetIndexBuffer(2,ExtMapBuffer3);
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
ArrayResize(buf2,b); 

if(tik==0)
   {
   for(i=0;i<b;i++)
      {
      buf[i]=Bid;
      buf2[i]=Ask;
      }
   ExtMapBuffer2[0]=Bid+width*Point;   
   ExtMapBuffer2[1]=Bid-width*Point;   
   tik=1;
   }
   MaxB=0;MinB=1000;
   for(i=b-1;i>0;i--)
      {
      buf[i]=buf[i-1];
      if(MaxB<buf[i])MaxB=buf[i];
      if(MinB>buf[i])MinB=buf[i];
      buf2[i]=buf2[i-1];
      if(MaxB<buf2[i])MaxB=buf2[i];
      if(MinB>buf2[i])MinB=buf2[i];
      } 
buf[0]=Bid;
buf2[0]=Ask;
for(i=0;i<b;i++)
   {
   ExtMapBuffer1[i]=buf[i];
   ExtMapBuffer3[i]=buf2[i];
   }
if(MathCeil(t/10)*10==t)
   {
   for(i=b;i<Bars;i++)
      {
      ExtMapBuffer1[i]=Bid;
      ExtMapBuffer3[i]=Ask;
      }
      ArrayInitialize(ExtMapBuffer2,Bid); 
      if(MaxB-Bid<width*Point)ExtMapBuffer2[0]=Bid+width*Point;
      if(Bid-MinB<width*Point)ExtMapBuffer2[1]=Bid-width*Point;
      //Print(MaxB,"+",Bid,"+",MinB);
   }   
//----
   return(0);
  }
//+------------------------------------------------------------------+