//+------------------------------------------------------------------+
//|                                                cu_day_heiken.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#include <3_signal_inc.mqh>
int stime;
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
   if (stime != iTime(Symbol(), Period(), 0)) {
      stime = iTime(Symbol(), Period(), 0);
   infobox = "";
   int x;
   string symbol;
   for (x = 0; x < ARRSIZE; x++) {
         if (x == EURJPY || x == CHFJPY || x == GBPJPY || x == CADJPY || x == USDJPY || x == AUDJPY
          || x == NZDJPY || x == GBPNZD) {
         
         } else {
            continue;
         }
         symbol = aPair[x];
         
         infobox = infobox + "\nSymbol: " + symbol;
         int macd = macdR(symbol, PERIOD_M5);
         infobox = infobox + ", Period: " + TimeframeToString(PERIOD_M5) + " MACD: " + macd;
         if (macd == 1 || macd == -1) {
            SendAlert("Macd for symbol: " + symbol + " is " + macd + " with Bid price: " + MarketInfo(symbol, MODE_BID), symbol, PERIOD_M5);
         }
         
   }
   Comment(infobox);
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+