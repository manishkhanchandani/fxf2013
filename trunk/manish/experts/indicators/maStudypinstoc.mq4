//+------------------------------------------------------------------+
//|                                                      maStudy.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Yellow
#property indicator_color2 Red

double CrossUp[];
double CrossDown[];

#include <3_signal_inc.mqh>
#include <i_indicators.mqh>
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
int start()
  {
    int limit, i, counter;
   double Range, AvgRange;
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;

   limit=Bars-counted_bars;
   for(i = 0; i <= limit; i++) {
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      int entrybar =  i_entry_bar(Symbol(), Period(), i);
      int stoch = i_stoch_level(Symbol(), Period(), i, 14, 3, 3, MODE_SMA, 0, 80, 20);
      if (entrybar == 1 && stoch == 1) {
         CrossUp[i] = Low[i] - Range*0.5;
      }
      else if (entrybar == -1 && stoch == -1) {
          CrossDown[i] = High[i] + Range*0.5;
      }
   
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+