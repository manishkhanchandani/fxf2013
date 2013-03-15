//+------------------------------------------------------------------+
//|                                         EMA-Crossover_Signal.mq4 |
//|         Copyright © 2005, Jason Robinson (jnrtrading)            |
//|                   http://www.jnrtading.co.uk                     |
//+------------------------------------------------------------------+

/*
  +------------------------------------------------------------------+
  | Allows you to enter two ema periods and it will then show you at |
  | Which point they crossed over. It is more usful on the shorter   |
  | periods that get obscured by the bars / candlesticks and when    |
  | the zoom level is out. Also allows you then to remove the emas   |
  | from the chart. (emas are initially set at 5 and 6)              |
  +------------------------------------------------------------------+
*/   
#property copyright "Copyright © 2005, Jason Robinson (jnrtrading)"
#property link      "http://www.jnrtrading.co.uk"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 White
#property indicator_color2 Yellow

#include <3_signal_inc.mqh>
double CrossUp[];
double CrossDown[];
double CrossLevel[];
extern bool SoundON=true;
double alertTag;
double control=2147483647;
 
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_ARROW, EMPTY,2);
   SetIndexArrow(0, 233);
   SetIndexBuffer(0, CrossUp);
   SetIndexStyle(1, DRAW_ARROW, EMPTY,2);
   SetIndexArrow(1, 234);
   SetIndexBuffer(1, CrossDown);
   SetIndexStyle(2, DRAW_NONE, EMPTY,2);
   SetIndexBuffer(2, CrossLevel);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
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
int start() {
   int limit, i, counter;
   double Range, AvgRange;
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;

   limit=Bars-counted_bars;
   
   for(i = 0; i <= limit; i++) {
      CrossLevel[i] = i;
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
       int cur = maxindicator(Symbol(), Period(), i);
       int cur2 = maxindicator(Symbol(), Period(), i+1);
       
      if (cur == 1 && cur2 != 1) {
         CrossUp[i] = Low[i] - Range*0.5;
      }
      else if (cur == -1 && cur2 != -1) {
         CrossDown[i] = High[i] + Range*0.5;
      }
        if (SoundON==true && i==1 && CrossUp[i] > CrossDown[i] && alertTag!=Time[0]){
         Alert("EMA Cross Trend going Down on ",Symbol()," ",Period());
        alertTag = Time[0];
      }
        if (SoundON==true && i==1 && CrossUp[i] < CrossDown[i] && alertTag!=Time[0]){
       Alert("EMA Cross Trend going Up on ",Symbol()," ",Period());
        alertTag = Time[0];
        } 
  }
   return(0);
}

