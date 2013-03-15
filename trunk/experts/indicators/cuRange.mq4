//+------------------------------------------------------------------+
//|                                                      cuRange.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#include <3_signal_inc.mqh>
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
int stime;
int start()
  {
   int    counted_bars=IndicatorCounted();
   int x;
   string symbol;
   if (stime != iTime(Symbol(), Period(), 0)) {
   infobox = "";
   int sdiff;
      for (x = 0; x < ARRSIZE; x++) {
         symbol = aPair[x];
         sdiff = get_difference(symbol, x);
         infobox = infobox + "\nSymbol: " + symbol;
         infobox = infobox + ", sdiff: " + sdiff;
      }
      Comment(infobox);
      stime = iTime(Symbol(), Period(), 0);
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+