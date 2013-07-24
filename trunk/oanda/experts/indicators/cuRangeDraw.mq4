//+------------------------------------------------------------------+
//|                                                  cuRangeDraw.mq4 |
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
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
infobox = "";
   string symbol = Symbol();
   int period = PERIOD_D1;
         double high=High[iHighest(symbol, period,MODE_HIGH,365,0)];
         double low=Low[iLowest(symbol, period,MODE_LOW,365,0)];
         int pts = (high - low) / MarketInfo(symbol, MODE_POINT);
         infobox = infobox + "\nSymbol: " + symbol + ", High: " + high + ", Low: " + low + ", Diff: " + pts;
         Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+