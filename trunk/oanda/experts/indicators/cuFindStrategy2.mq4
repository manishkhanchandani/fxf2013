//+------------------------------------------------------------------+
//|                                              cuFindStrategy2.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

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
   if (opentime != Time[0]) {
      opentime = Time[0];
      string symbol;
      int period;
      double val;
      string infobox = "";
      int start, end;
      int gtotal;
      int strategy;
      int max;
      int best;
   
      symbol = Symbol();
      period = Period();
      for (strategy = 1; strategy <= 30; strategy++) {
         gtotal = 0;
         for (start=5; start <= 40; start = start + 5) {
            end = start - 5;
            val = iCustom(symbol, period, "cuSpanTimeClose", strategy, start, end, 4, 0);
            if (val == EMPTY_VALUE) val = 0;
            gtotal = gtotal + val;
            infobox = infobox + "\nSymbol: " + symbol + ", Time Period: " + TimeframeToString(period)
               + ", Strategy: " + strategy 
               + " (" + get_strategy_name(strategy) + ") "
               + ", Start: " + start + ", End: " + end + " has value: " + val;
         }
         if (gtotal > max) {
            max = gtotal;
            best = strategy;
         }
         infobox = infobox + "\nGtotal For strategy: " + strategy + "(" + get_strategy_name(strategy) + ") is " + gtotal + "\n\n";
      }
      
      string inference = "\nMax Gtotal For Symbol: " + symbol
         + ", Strategy: " + best + "(" + get_strategy_name(best) + ") is " + max
          + ", Time Period: " + TimeframeToString(period) + "\n\n";
      string filename = symbol + "/cuFindStrategy2_"+period+".txt";
      FileDelete(filename);
      FileAppend(filename, inference + infobox);
      
      Comment(inference + infobox);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+