//+------------------------------------------------------------------+
//|                                                    cuCurrent.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window

#include <3_signal_inc.mqh>
#include <strategies.mqh>
extern int maxVal = 20000;
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
   infobox = "";
   int check, check2, check3;
   int buy = 0;
   int sell = 0;
   for (int strategy = 1; strategy <= 30; strategy++) {
         if (strategy == 4 || strategy == 24 || strategy == 25) continue; 
         int val = iCustom(Symbol(), Period(), "cuSpanTimeClose", strategy, 1000, 0, 4, 0);
         if (val == EMPTY_VALUE) continue;
         if (val < 0) continue;
         if (val < maxVal) continue;
         infobox = infobox + "\n\nStrategy: " + strategy + " - " + get_strategy_name(strategy)
            + ", Power: " + val;
         check = get_strategy_result(strategy, Symbol(), Period(), 1, 0);
         check2 = get_strategy_result(strategy, Symbol(), Period(), 1, 1);
         if (check2 == 1) buy++;
         else if (check2 == -1) sell++;
         infobox = infobox + "\nCheck: " + check + ", Check Current: " + check2;
         for (int i = 1; i <= 10000; i++) {
            check3 = get_strategy_result(strategy, Symbol(), Period(), i, 0);
            if (check3 != 0) {
               double close = Close[i];
               int fpips = 0;
               int bar = i;
               if (check3 == 1) {
                  fpips = (Close[0] - close) / Point;
               } else if(check3 == -1) {
                  fpips = (close - Close[0]) / Point;
               }
               break;
            }
         }
         infobox = infobox + ", Fpips: " + fpips + ", Bar: " + bar;
   }
   infobox = infobox + "\n\nBuy: " + buy + ", Sell: " + sell;
   Comment(infobox);
   ObjectDelete("start");
   ObjectDelete("end");
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+


