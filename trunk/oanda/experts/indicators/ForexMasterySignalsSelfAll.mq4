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
            int periods[5] = {PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4, PERIOD_D1};
            for (int p = 0; p < 5; p++) {
               int period = periods[p];
               int best = 0;
               int max = -9999999;
               for (int j = 1; j <= 27; j++) {
                  if (j == 4 || j == 24 || j == 25) continue;
                  double val = iCustom(symbol, period, "cuSpanTime", j, 1000, 4, 0);
                  if (val > max && val != EMPTY_VALUE) {
                     max = val;
                     best = j;
                  }
               }
               for (int k = 1; k <= 500; k++) {
                  int check = get_strategy_result(best, symbol, period, k, 0);
                  string msg = "";
                  if (check != 0) {
                     int fpips;
                     if (check == 1) {
                        fpips = (iClose(symbol, period, 0) - iClose(symbol, period, k)) / MarketInfo(symbol, MODE_POINT);
                        msg = "Symbol: " + symbol + ", Period: " + TimeframeToString(period) 
                        + ", Buy Now at Price " + iClose(symbol, period, k) 
                        + ", Signal send on "
                           + TimeToStr(TimeCurrent())
                           + ", Strategy: " + best + "(" + get_strategy_name(best) + ") with value: " + max ;
                     } else if (check == -1) {
                        fpips = (iClose(symbol, period, k) - iClose(symbol, period, 0)) / MarketInfo(symbol, MODE_POINT);
                        msg = "Symbol: " + symbol + ", Period: " + TimeframeToString(period) 
                        + ", Sell Now at Price " + iClose(symbol, period, k) 
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
                  + ", Period: " + TimeframeToString(period)
                  ;
            }
      Comment(infobox);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+