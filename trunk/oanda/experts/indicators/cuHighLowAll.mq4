//+------------------------------------------------------------------+
//|                                                  cuMathMurry.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

#property indicator_chart_window
#include <3_signal_inc.mqh>
#include <strategies.mqh>
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
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
   int    counted_bars=IndicatorCounted();
//----
   if (opentime != iTime(Symbol(), Period(), 0)){
   infobox = "";
   string symbol;
   int x;
   int days = 750;
   double factor = 0.01;
    for (x = 0; x < ARRSIZE; x++) {
         symbol = aPair[x];
         string current_currency1 = StringSubstr(symbol, 0, 3);
         string current_currency2 = StringSubstr(symbol, 3, 3);
         int high = iHighest(symbol, PERIOD_D1, MODE_HIGH, days, 0);
         int low = iLowest(symbol, PERIOD_D1, MODE_LOW, days, 0);
         double diff = iHigh(symbol, PERIOD_D1, high) - iLow(symbol, PERIOD_D1, low);
         int number = diff / MarketInfo(symbol, MODE_POINT);
         int max = number * factor;
         int top = (iHigh(symbol, PERIOD_D1, high) - iClose(symbol, PERIOD_M30, 0)) / MarketInfo(symbol, MODE_POINT);
         int bottom = (iClose(symbol, PERIOD_M30, 0) - iLow(symbol, PERIOD_D1, low)) / MarketInfo(symbol, MODE_POINT);
         int suggested = 0;
         if (top > bottom) {
            suggested = 1;
         } else if (top < bottom) {
            suggested = -1;
         }
         infobox = infobox + StringConcatenate("\nSymbol: ", symbol, ", Days = ", days, ", High: ", high, " (", High[high], "), Low: ", low, " (", Low[low], "), Diff: ", diff, ", number: ", number,
            ", max loss: ", max, ", top: ", top, "(", (top * factor), "), bottom: ", 
            bottom, " (", (bottom * factor), "), suggested: ", suggested);
    }
   Comment(infobox);
   opentime = iTime(Symbol(), Period(), 0);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+