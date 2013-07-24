//+------------------------------------------------------------------+
//|                                            cuProfitableTrend.mq4 |
//|                                              Manish Khanchandani |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://forexmastery.org"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Yellow
#property indicator_color2 White
#property indicator_color3 Blue
#property indicator_color4 Red

double CrossUp[];
double CrossDown[];
double CrossUp2[];
double CrossDown2[];

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
   SetIndexBuffer(2, CrossUp2);
   SetIndexStyle(3, DRAW_ARROW, EMPTY,2);
   SetIndexArrow(3, 234);
   SetIndexBuffer(3, CrossDown2);
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
   int limit;
   int counted_bars=IndicatorCounted();
   int counter;
   double Range, AvgRange;
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//---- macd counted in the 1-st buffer
   string box = "";
   string symbol = Symbol();
   int period = Period();
   for(int i=0; i<limit; i++) {
      
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      double h_12_0 = iCustom(symbol, period, "HMA", 12, 3, 0, 0, i);
      double h_12_1 = iCustom(symbol, period, "HMA", 12, 3, 0, 1, i);
      double h_12_0b = iCustom(symbol, period, "HMA", 12, 3, 0, 0, i+1);
      double h_12_1b = iCustom(symbol, period, "HMA", 12, 3, 0, 1, i+1);
      double h_5_0 = iCustom(symbol, period, "HMA", 5, 3, 0, 0, i);
      double h_5_1 = iCustom(symbol, period, "HMA", 5, 3, 0, 1, i);
      double h_5_0b = iCustom(symbol, period, "HMA", 5, 3, 0, 0, i+1);
      double h_5_1b = iCustom(symbol, period, "HMA", 5, 3, 0, 1, i+1);
      int h_5 = 0;
      if (h_5_0 > 0 && h_5_0 != EMPTY_VALUE && h_5_1b > 0 && h_5_1b != EMPTY_VALUE) {
         h_5 = 1;
      } else if (h_5_1 > 0 && h_5_1 != EMPTY_VALUE && h_5_0b > 0 && h_5_0b != EMPTY_VALUE) {
         h_5 = -1;
      }
      int h_12 = 0;
      if (h_12_0 > 0 && h_12_0 != EMPTY_VALUE && h_12_1b > 0 && h_12_1b != EMPTY_VALUE) {
         h_12 = 1;
      } else if (h_12_1 > 0 && h_12_1 != EMPTY_VALUE && h_12_0b > 0 && h_12_0b != EMPTY_VALUE) {
         h_12 = -1;
      }
      double ma20 = iMA(symbol,period,20,0,MODE_EMA,PRICE_CLOSE,i);
      double ma30 = iMA(symbol,period,30,0,MODE_EMA,PRICE_CLOSE,i);
      double gmmaslow = iCustom(symbol, period, "GMMASLow", 0, i);
      double macdMain = iCustom(symbol, period, "realMACD", 30, 60, 30, 2, i);
      double macdSignal = iCustom(symbol, period, "realMACD", 30, 60, 30, 1, i);
      double macd = iCustom(symbol, period, "realMACD", 30, 60, 30, 0, i);
      int trend = 0;
      if (macdMain > macdSignal && ma20 > ma30) {
         trend = 1;
      } else if (macdMain < macdSignal && ma20 < ma30) {
         trend = -1;
      }
      if (h_5 == 1 && trend == 1) {
         CrossUp[i] = Low[i] - Range*0.5;
      } else if (h_5 == -1 && trend == -1) {
         CrossDown[i] = High[i] + Range*0.5;
      }
      if (h_12 == 1 && trend == 1) {
         CrossUp2[i] = Low[i] - Range*0.5;
      } else if (h_12 == -1 && trend == -1) {
         CrossDown2[i] = High[i] + Range*0.5;
      }
      if (i == 1) {
         box = box + "\nFinding the Solution: ";
         box = box + "\nH 12 0: " + h_12_0;
         box = box + "\nH 12 1: " + h_12_1;
         box = box + "\nH 5 0: " + h_5_0;
         box = box + "\nH 5 1: " + h_5_1;
         box = box + "\nH 5 Turn: " + h_5;
         box = box + "\nH 12 Turn: " + h_12;
         box = box + "\nMA20: " + ma20;
         box = box + "\nMA30: " + ma30;
         box = box + "\nGMMASlow: " + gmmaslow;
         box = box + "\nmacd: " + macd;
         box = box + "\nmacdSignal: " + macdSignal;
         box = box + "\nmacdMain: " + macdMain;
         box = box + "\nTrend: " + trend;
      }
   }
   Comment(box);
   
//----
   return(0);
  }
//+------------------------------------------------------------------+