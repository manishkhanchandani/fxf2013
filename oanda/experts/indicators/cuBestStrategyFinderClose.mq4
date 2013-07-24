//+------------------------------------------------------------------+
//|                                               cuChartPattern.mq4 |
//|                                              Manish Khanchandani |
//|                                          http://www.mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://www.mkgalaxy.com"

#property indicator_chart_window

#include <strategies.mqh>
#include <3_signal_inc.mqh>

extern int noofdays = 100;
int best;
int bestClose;
string inference;
string inference2;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   string symbol = Symbol();
   int sel = 0;
   int sel2 = 0;
   int max = -9999;
   int max2 = -9999;
   inference = "";
   int newtotal = 0;
   inference = "";
   inference2 = "";
   string strategiestoconsider = "\nStrategies: ";
   for (int strategy = 1; strategy <= 30; strategy++) {
         if (strategy == 24 || strategy == 25 || strategy == 23) continue;
         for (int strategyClose = 1; strategyClose <= 30; strategyClose++) {
            if (strategyClose == 24 || strategyClose == 25 || strategyClose == 23) continue;
               double val = iCustom(symbol, Period(), "cuSpanClose", strategy, strategyClose, noofdays, 0, 6, 0);
               if (val == EMPTY_VALUE) val = 0;
               inference = inference + "\nSymbol: " + symbol + ", Period: " + Period() 
               + ", Strategy: " + strategy + " (" + get_strategy_name(strategy)+ ")" 
               + ", strategyClose: " + strategyClose + " (" + get_strategy_name(strategyClose)+ ")" 
               + ", Val: " + DoubleToStr(val, Digits);
               if (val > 1000) {
                  inference2 = inference2 + "\nSymbol: " + symbol + ", Period: " + Period() 
                  + ", Strategy: " + strategy + " (" + get_strategy_name(strategy)+ ")" 
                  + ", strategyClose: " + strategyClose + " (" + get_strategy_name(strategyClose)+ ")" 
                  + ", Val: " + DoubleToStr(val, Digits);
               }
               if (val > max && val != EMPTY_VALUE) {
                  max = val;
                  sel = Period();
                  best = strategy;
                  bestClose = strategyClose;
               }
          }
   }
   strategy = best;
   inference = inference + "\nMax: " + max + ", sel: " + sel 
   + ", best Strategy = " + best + ", best Close Strategy = " + bestClose + ", Spread: " + MarketInfo(symbol, MODE_SPREAD);
   string fn = "cuBestStrategyFinderClose/" + symbol + "_" + Period()+ "_" + noofdays + ".txt";
   FileDelete(fn);
   FileAppend(fn, inference2 + "\n\n" + inference);
   return (0);
//----
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
   Comment(inference2 + "\n\n" + inference);
   return(0);
  }
//+------------------------------------------------------------------+

