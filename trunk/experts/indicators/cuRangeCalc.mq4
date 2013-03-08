//+------------------------------------------------------------------+
//|                                                  cuRangeCalc.mq4 |
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
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
   int x;
      int period = PERIOD_D1;
      string symbol;
      infobox = "";
      for (x = 0; x < ARRSIZE; x++) {
         symbol = aPair[x];
         double high=iHigh(symbol, period, iHighest(symbol, period,MODE_HIGH,365,0));
         double low=iLow(symbol, period, iLowest(symbol, period,MODE_LOW,365,0));
         int pts = (high - low) / MarketInfo(symbol, MODE_POINT);
         
         int semaphore = get_lasttrendsemaphore(symbol, period, false);
         infobox = infobox + "\nSymbol: " + symbol + ", High: " + high + ", Low: " + low + ", Diff: " + pts
         + ", Semaphore: " + semaphore + " (" + semaphoreNumber + ")";
      }
      Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+