//+------------------------------------------------------------------+
//|                                             3_signal_macdind.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <3_signal_inc.mqh>
#property indicator_chart_window
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
int openTime;
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
      if (openTime != iTime(Symbol(), Period(), 0)) {
   string symbol;
   int x;
   infobox = "";
   getallinfo();
   for (x = 0; x < ARRSIZE; x++) {
      symbol = aPair[x];
      
         string current_currency1 = StringSubstr(symbol, 0, 3);
         string current_currency2 = StringSubstr(symbol, 3, 3);
      if ( current_currency2 != "JPY") continue;
      infobox = infobox + "\nSymbol: " + symbol;
         display( symbol, PERIOD_H1);
         display( symbol, PERIOD_M30);
         display( symbol, PERIOD_M15);
         display( symbol, PERIOD_M5);
         display( symbol, PERIOD_H4);
      
   }
   Comment(infobox);
   openTime = iTime(Symbol(), Period(), 0);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
int display(string symbol, int period)
{
   
   double macd;
         macd = macdR(symbol, period);
         infobox = infobox + ", Period " + TimeframeToString(period) + ": " + macd;
         if (macd == 1) {
            infobox = infobox + ", Buy";
            SendAlert(symbol + " Buy for period: " + TimeframeToString(period) + " at bid: " + MarketInfo(symbol, MODE_BID), 
            symbol, period);

         } else if (macd == -1) {
            infobox = infobox + ", Sell";
            SendAlert(symbol + " Sell for period: " + TimeframeToString(period) + " at bid: " + MarketInfo(symbol, MODE_BID), 
            symbol, period);
         }
}