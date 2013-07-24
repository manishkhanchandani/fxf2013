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
    for (x = 0; x < ARRSIZE; x++) {
         symbol = aPair[x];
         string current_currency1 = StringSubstr(symbol, 0, 3);
         string current_currency2 = StringSubstr(symbol, 3, 3);
         //if (current_currency2 == "USD") {} else continue;
         //if (current_currency2 == "JPY") {} else continue;
         //if (current_currency1 == "USD") {} else continue;
         //if (current_currency1 == "EUR") {} else continue;
         int semaphoreH4 = get_lasttrendsemaphore(symbol, PERIOD_H4, false);
         int semaphoreNumberH4 = semaphoreNumber;
         infobox = infobox + "\nSymbol: " + symbol + ", Semaphore H4: " + semaphoreH4 + ", last turn: " + semaphoreNumberH4;
    }
   Comment(infobox);
   opentime = iTime(Symbol(), Period(), 0);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+