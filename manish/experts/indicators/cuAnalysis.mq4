//+------------------------------------------------------------------+
//|                                                   cuAnalysis.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

#property indicator_chart_window

#property indicator_buffers 5
#property indicator_color1 Yellow
#property indicator_color2 Red
#include <3_signal_inc.mqh>
string symbol;
#include <strategies.mqh>

double CrossUp[];
double CrossDown[];
double Cross[];
double Fpips[];
double Total[];

int lastChange;
int lastChangeType;
double lastChangeClose;
int gtotal;
int best = 0;
int best2 = 0;
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
   SetIndexStyle(2, DRAW_NONE);
   SetIndexBuffer(2, Cross);
   SetIndexStyle(3, DRAW_NONE);
   SetIndexBuffer(3, Fpips);
   SetIndexStyle(4, DRAW_NONE);
   SetIndexBuffer(4, Total);
   lastChange = 0;
   lastChangeClose = 0;
   lastChangeType = 0;
   symbol = Symbol();
   int periods[10] = {PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4};
   int sel = 0;
   int sel2 = 0;
   int max = -9999;
   int max2 = -9999;
   infobox = "";
   int bar2 = 0; //getShift(Symbol(), Period(), D'2013.05.10 00:00');
   for (int j = 1; j <= 21; j++) {
      if (j == 16 || j == 18) continue;
      for (int i = 1; i < 5; i++) {
         double val = iCustom(symbol, periods[i], "cuSpan", j, 4, bar2);
         infobox = infobox + "\nSymbol: " + symbol + ", Period: " + periods[i] + ", Strategy: " + j + ", Val: " + val;
         if (val > max && val != EMPTY_VALUE) {
            max = val;
            sel = periods[i];
            best = j;
         }
      }
   }
   string inference = "\nmax: " + max + ", sel: " + sel + ", best Strategy = " + best + ", Spread: " + MarketInfo(symbol, MODE_SPREAD);
   for (j = 1; j <= 21; j++) {
      if (j == 16 || j == 18) {} else continue;
      for (i = 0; i < 6; i++) {
         val = iCustom(symbol, periods[i], "cuSpan", j, 4, bar2);
         infobox = infobox + "\nSymbol: " + symbol + ", Period: " + periods[i] + ", Strategy: " + j + ", Val: " + val;
         if (val > max2 && val != EMPTY_VALUE) {
            max2 = val;
            sel2 = periods[i];
            best2 = j;
         }
      }
   }
   inference = inference + ", 16 or 18: max: " + max2 + ", sel: " + sel2 + ", best Strategy = " + best2;
   infobox = inference + infobox;
   FileDelete("analysis_"+symbol+".txt");
   FileAppend("analysis_"+symbol+".txt", infobox);
   Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   lastChange = 0;
   lastChangeClose = 0;
   lastChangeType = 0;
   
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
   int condition = 0;
   gtotal = 0;
   int bar = getShift(Symbol(), Period(), D'2013.04.21 00:00');
   //Alert(bar);
   for(i = bar; i >= 1; i--) {
   
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      condition = 0;
      
      int check = get_strategy_result(best, Symbol(), Period(), i, 0);
      Print("Strategy: " + symbol + ", " + best);
      if (check == 1 && lastChangeType != 1) {
         if (lastChange > 0) {
            if (lastChangeType == -1) {
               Fpips[i] = (lastChangeClose - Close[i]) / Point;
               gtotal = gtotal + Fpips[i];
               Total[i] = gtotal;
            }
         }
         CrossUp[i] = Low[i] - Range*0.5;
         Cross[i] = 1;
         lastChange = i;
         lastChangeClose = Close[i];
         lastChangeType = 1;
      } else if (check == -1 && lastChangeType != -1) {
         if (lastChange > 0) {
            if (lastChangeType == 1) {
               Fpips[i] = (Close[i] - lastChangeClose) / Point;
               gtotal = gtotal + Fpips[i];
               Total[i] = gtotal;
            }
         }
         CrossDown[i] = High[i] + Range*0.5;
         Cross[i] = -1;
         lastChange = i;
         lastChangeClose = Close[i];
         lastChangeType = -1;
      }
   }
   i = 0;
   if (lastChange > 0) {
            if (lastChangeType == -1) {
               Fpips[i] = (lastChangeClose - Close[i]) / Point;
               gtotal = gtotal + Fpips[i];
               Total[i] = gtotal;
         //CrossUp[i] = Low[i] - Range*0.5;
         //Cross[i] = 1;
            } else if (lastChangeType == 1) {
               Fpips[i] = (Close[i] - lastChangeClose) / Point;
               gtotal = gtotal + Fpips[i];
               Total[i] = gtotal;
         //CrossDown[i] = High[i] + Range*0.5;
         //Cross[i] = -1;
            }
         }
         
   return(0);
  }
//+------------------------------------------------------------------+