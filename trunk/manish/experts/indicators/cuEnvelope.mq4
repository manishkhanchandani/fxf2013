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
         int check = get_strategy_result(16, symbol, PERIOD_M30, 0, 1);
         infobox = infobox + "\nSymbol: " + symbol + ", Check: " + check;
    }
   Comment(infobox);
   opentime = iTime(Symbol(), Period(), 0);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+