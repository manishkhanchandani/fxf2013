//+------------------------------------------------------------------+
//|                                          ForexMasterySignals.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

#property indicator_chart_window

#include <strategies.mqh>
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
   if (opentime != Time[0]) {
      opentime = Time[0];

      infobox = "";
            string symbol = Symbol();
            int best = 0;
            int max = -9999999;
            for (int j = 1; j <= 27; j++) {
               if (j == 4 || j == 24 || j == 25) continue;
               double val = iCustom(symbol, Period(), "cuSpanTime", j, 1000, 4, 0);
               if (val > max && val != EMPTY_VALUE) {
                  max = val;
                  best = j;
               }
            }
            for (int k = 1; k <= 500; k++) {
               int check = get_strategy_result(best, symbol, Period(), k, 0);
               string msg = "";
               if (check != 0) {
                  int fpips;
                  if (check == 1) {
                     fpips = (iClose(symbol, Period(), 0) - iClose(symbol, Period(), k)) / MarketInfo(symbol, MODE_POINT);
                     msg = "Symbol: " + symbol + ", Period: " + TimeframeToString(Period()) 
                     + ", Buy Now at Price " + iClose(symbol, Period(), k) 
                     + ", Signal send on "
                        + TimeToStr(TimeCurrent())
                        + ", Strategy: " + best + "(" + get_strategy_name(best) + ") with value: " + max ;
                  } else if (check == -1) {
                     fpips = (iClose(symbol, Period(), k) - iClose(symbol, Period(), 0)) / MarketInfo(symbol, MODE_POINT);
                     msg = "Symbol: " + symbol + ", Period: " + TimeframeToString(Period()) 
                     + ", Sell Now at Price " + iClose(symbol, Period(), k) 
                     + ", Signal send on "
                        + TimeToStr(TimeCurrent())
                        + ", Strategy: " + best + "(" + get_strategy_name(best) + ") with value: " + max ;
                  }
                  if (k == 1) {
                     SendNotification(msg);
                  }
                  break;
               }
            }
               infobox = infobox + "\nSymbol: " + symbol + ", Best: " + best + "(" + get_strategy_name(best) 
                  + ") with value: " + max + ", Change: " + check + ", Change Bar: " + k + ", fpips: " + fpips
                  //+ ", Close (0): " + iClose(symbol, Period(), 0) + ", Close(k): " + iClose(symbol, Period(), k)
                  ;
      Comment(infobox);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+