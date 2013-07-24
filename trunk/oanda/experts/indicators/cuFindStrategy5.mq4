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
extern int periodStart = 1000;
extern int periodEnd = 0;
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
      infobox = infobox + "\n\nFinding Total for all symbols: ";
      int start, end;
      int gtotal;
      int max;
      int best;
      int ftotal = 0;
      int strategy = 0;
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
         if (i == GBPAUD) {
            period = PERIOD_M30;
            strategy = 10;
         } else if (i == EURAUD) {
            period = PERIOD_M15;
            strategy = 26;
         } else if (i == AUDUSD) {
            period = PERIOD_M15;
            strategy = 27;
         } else if (i == NZDUSD) {
            period = PERIOD_M15;
            strategy = 7;
         } else if (i == EURUSD) {
            period = PERIOD_M15;
            strategy = 21;
         } else if (i == AUDCHF) {
            period = PERIOD_M30;
            strategy = 28;
         } else if (i == NZDCHF) {
            period = PERIOD_H1;
            strategy = 16;
         } else if (i == GBPUSD) {
            period = PERIOD_M30;
            strategy = 26;
         } else if (i == USDCHF) {
            period = PERIOD_M30;
            strategy = 21;
         } else if (i == EURJPY) {
            period = PERIOD_M15;
            strategy = 19;
         } else if (i == AUDJPY) {
            period = PERIOD_M30;
            strategy = 22;
         } else if (i == NZDJPY) {
            period = PERIOD_M15;
            strategy = 3;
         } else if (i == CHFJPY) {
            period = PERIOD_M15;
            strategy = 26;
         } else if (i == GBPJPY) {
            period = PERIOD_M15;
            strategy = 26;
         } else if (i == EURNZD) {
            period = PERIOD_H1;
            strategy = 22;
         } else if (i == GBPNZD) {
            period = PERIOD_H1;
            strategy = 12;
         } else if (i == USDJPY) {
            period = PERIOD_H1;
            strategy = 17;
         }
         symbol = aPair[i];
         gtotal = 0;
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
      string filename = "strategy_"+periodStart+"_"+periodEnd+".txt";
      FileDelete(filename);
      FileAppend(filename, inference + inference2 + infobox);
      
      Comment(inference + inference2 + infobox);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+