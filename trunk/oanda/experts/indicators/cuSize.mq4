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
   int check = 0;
   double total = 0;
    for (x = 0; x < ARRSIZE; x++) {
         check = 0;
         symbol = aPair[x];
         string current_currency1 = StringSubstr(symbol, 0, 3);
         string current_currency2 = StringSubstr(symbol, 3, 3);
         /*if (x == USDCHF || x == USDCAD || x == NZDCAD || x == EURUSD || x == AUDUSD
         || x == EURGBP || x == EURAUD || x == GBPAUD || x == GBPJPY || x == EURCAD || x == AUDNZD
         || x == AUDCHF || x == CADCHF || x == EURNZD || x == GBPUSD || x == AUDCAD || x == NZDCHF || x == GBPCAD
         || x == NZDUSD || x == EURCHF || x == USDJPY || x == GBPCHF)
         continue;*/
         int size = (iHigh(symbol, PERIOD_W1, 0) - iLow(symbol, PERIOD_W1, 0)) / MarketInfo(symbol, MODE_POINT);
         double qty = iCustom(symbol, PERIOD_M30, "cuSpan", 9, 4, 0);
         total = total + qty;
         infobox = infobox + StringConcatenate("\nSymbol: ", symbol, ", size = ", size, ", qty = ", qty);
    }
         infobox = infobox + StringConcatenate("\n\nTotal: ", total);
   Comment(infobox);
   opentime = iTime(Symbol(), Period(), 0);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+