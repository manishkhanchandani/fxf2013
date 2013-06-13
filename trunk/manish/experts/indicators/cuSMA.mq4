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
         int check1000 = get_strategy_result(25, Symbol(), Period(), 1, 0);
         int check500 = get_strategy_result(24, Symbol(), Period(), 1, 0);
         int check200 = get_strategy_result(23, Symbol(), Period(), 1, 0);
         int check50 = get_strategy_result(18, Symbol(), Period(), 1, 0);
         if (check1000 != 0) Alert(symbol, ", 1000 SMA: ", check1000);
         if (check500 != 0) Alert(symbol, ", 500 SMA: ", check500);
         if (check200 != 0) Alert(symbol, ", 200 SMA: ", check200);
         if (check50 != 0) Alert(symbol, ", 50 SMA: ", check50);
         infobox = infobox + "\nSymbol: " + symbol + ", 1000 SMA: " + check1000 + ", 500 SMA: " + check500
            + ", 200 SMA: " + check200 + ", 50 SMA: " + check50;
    }
   Comment(infobox);
   opentime = iTime(Symbol(), Period(), 0);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+