//+------------------------------------------------------------------+
//|                                                      maStudy.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Yellow
#property indicator_color2 Red
#property indicator_color3 White
#property indicator_color4 Brown

double CrossUp[];
double CrossDown[];
double CrossUp1[];
double CrossDown1[];

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
   SetIndexStyle(2, DRAW_ARROW, EMPTY,2);
   SetIndexArrow(2, 233);
   SetIndexBuffer(2, CrossUp1);
   SetIndexStyle(3, DRAW_ARROW, EMPTY,2);
   SetIndexArrow(3, 234);
   SetIndexBuffer(3, CrossDown1);
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
      int fast_ema_period, slow_ema_period, signal_period;
      fast_ema_period = 12;
      slow_ema_period = 26;
      signal_period = 9;
      string symbol = Symbol();
      int period = Period();
      double ma5 = iMA(symbol, period,5,0,MODE_EMA,PRICE_CLOSE,i);
      double ma15 = iMA(symbol, period,15,0,MODE_EMA,PRICE_CLOSE,i);
      double ma60 = iMA(symbol, period,60,0,MODE_EMA,PRICE_CLOSE,i);
      double ma5_2 = iMA(symbol, period,5,0,MODE_EMA,PRICE_CLOSE,i+1);
      double ma15_2 = iMA(symbol, period,15,0,MODE_EMA,PRICE_CLOSE,i+1);
      double ma60_2 = iMA(symbol, period,60,0,MODE_EMA,PRICE_CLOSE,i+1);
      int condition = 0;
      if (ma5 > ma15 && ma15 > ma60 && (ma5_2 < ma15_2 || ma15_2 < ma60_2)) {
         condition = 1;
      } else if (ma5 < ma15 && ma15 < ma60 && (ma5_2 > ma15_2 || ma15_2 > ma60_2)) {
         condition = -1;
      }

      if (condition == 1) {
         CrossUp[i] = Low[i] - Range*0.5;
      }
      else if (condition == -1) {
          CrossDown[i] = High[i] + Range*0.5;
      }
      /*
      condition = i_engulf(Symbol(), Period(), i);


      if (condition == 1) {
         CrossUp1[i] = Low[i] - Range*0.5;
      }
      else if (condition == -1) {
          CrossDown1[i] = High[i] + Range*0.5;
      }*/
   
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+