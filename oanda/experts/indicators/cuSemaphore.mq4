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
    return (0);
         symbol = aPair[x];
         string current_currency1 = StringSubstr(symbol, 0, 3);
         string current_currency2 = StringSubstr(symbol, 3, 3);
         int semaphore = semaphore(symbol, PERIOD_D1, 0);
         int semaphore2 = semaphore(symbol, PERIOD_H4, 0);
         int semaphore3 = semaphore(symbol, PERIOD_H1, 0);
         infobox = infobox + StringConcatenate("\nSymbol: ", symbol, ", semaphore 1D = ", semaphore, ", semaphore 4H: ", semaphore2
            , ", semaphore 1H: ", semaphore3);
    }
   Comment(infobox);
   opentime = iTime(Symbol(), Period(), 0);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+