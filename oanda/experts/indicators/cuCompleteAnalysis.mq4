//+------------------------------------------------------------------+
//|                                           cuCompleteAnalysis.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window

#include <3_signal_inc.mqh>
#include <strategies.mqh>

bool checked = false;
int counter = 0;
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
   counter++;
   if (checked) {
   
   } else {
      if (counter % 5 == 0) {
         for (start=periodStart; start <= periodEnd; start = start + 5) {
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
            bestperiod = period;
         }
      }
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+