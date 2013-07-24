//+------------------------------------------------------------------+
//|                                                      cuAlert.mq4 |
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
string memory;
int start()
  {
   int    counted_bars=IndicatorCounted();
   if (opentime != Time[0]) {
      int check = 0;
      infobox = "";
      for (int x = 0; x < ARRSIZE; x++) {
         string symbol = aPair[x];
         string current_currency1 = StringSubstr(symbol, 0, 3);
         string current_currency2 = StringSubstr(symbol, 3, 3);
         if (x == EURCHF || x == EURGBP || x == AUDNZD) continue;
         if (x == EURJPY) {} else continue;
         for (int j = 1; j <= 18; j++) {
            check = get_strategy_result(j, symbol, PERIOD_M15, 1, 0);
            if (check != 0) { 
              // memory = memory + "\n" + symbol + ": " + iClose(symbol, PERIOD_M15, 1)
               //   + ", strategy: " + j + " (" + parseStrategy(j) + "), Time: " + PERIOD_M15;
               infobox = infobox 
               + StringConcatenate("\nSymbol: ", symbol, ", ", check, ", for strategy: ", j, " (",parseStrategy(j),") and time period: ", PERIOD_M15);
            }
            check = get_strategy_result(j, symbol, PERIOD_M30, 1, 0);
            if (check != 0) { 
               //memory = memory + "\n" + symbol + ": " + iClose(symbol, PERIOD_M30, 1)
               //   + ", strategy: " + j + " (" + parseStrategy(j) +"), Time: " + PERIOD_M30;
               infobox = infobox 
               + StringConcatenate("\nSymbol: ", symbol, ", ", check, ", for strategy: ", j, " (",parseStrategy(j),") and time period: ", PERIOD_M30);
            }
         }
      }
      Comment(infobox);
      opentime = Time[0];
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+