//+------------------------------------------------------------------+
//|                                              cuFindStrategy2.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
//particular strategy for all currency
#property indicator_chart_window
#include <3_signal_inc.mqh>
#include <strategies.mqh>
extern int strategy = 26;
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
      infobox = infobox + "\n\nFinding Total for all symbols using strategy: " + strategy;
      int start, end;
      int gtotal;
      int max;
      int best;
      int ftotal = 0;
   
      symbol = Symbol();
      period = Period();
      string bestsymbol;
      int bestperiod;
      string inference2 = "\nImportant Symbols";
      for(int i=0;i<ARRSIZE;i++) {
         if (i == USDCAD
            || i == EURGBP
            || i == EURCHF
            || i == GBPCHF
            || i == AUDNZD
            || i == GBPCAD
            || i == EURCAD
            || i == AUDCAD
            || i == NZDCAD
            || i == CADCHF
            || i == CADJPY
         ) continue;
         symbol = aPair[i];
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
         ftotal = ftotal + gtotal;
         if (gtotal > max) {
            max = gtotal;
            best = strategy;
            bestsymbol = symbol;
            bestperiod = period;
         }
         if (gtotal > 10000) {
            inference2 = inference2 + "\nSymbol: " + symbol + ", Time Period: " + TimeframeToString(period)
               + ", Strategy: " + strategy 
               + " (" + get_strategy_name(strategy) + ") "
               + ", Total: " + gtotal;
         }
         infobox = infobox + "\nSymbol: " + symbol 
            + ", Period: " + TimeframeToString(period) + ", Total For strategy: " 
            + strategy + "(" + get_strategy_name(strategy) + ") is " + gtotal + "\n\n";
      }
      
      string inference = "\nGrand total For All Symbols: " + ftotal
         + ", Strategy: " + strategy + "(" + get_strategy_name(strategy) + ")"
          + ", Time Period: " + TimeframeToString(bestperiod) + "\n";
      inference = inference + "\nMax total For Symbol: " + bestsymbol
         + ", Strategy: " + best + "(" + get_strategy_name(best) + ") is " + max
          + ", Time Period: " + TimeframeToString(bestperiod) + "\n\n";
      string filename = "strategy2_" + strategy + "/cuFindStrategy4_"+period+".txt";
      FileDelete(filename);
      FileAppend(filename, inference + inference2 + infobox);
      
      Comment(inference + inference2 + infobox);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+