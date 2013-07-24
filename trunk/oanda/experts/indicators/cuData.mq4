//+------------------------------------------------------------------+
//|                                                       cuData.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#include <3_signal_inc.mqh>
int maxStrategy = 30;
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
         int periods[5] = {PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4, PERIOD_D1};
         int days[7] = {300, 20, 15, 10, 5};
         int p, period, noofdays;
         string txt = "";
         string subject = "";
         string symbol = Symbol();
         period = Period();
         RefreshRates();
               subject = "Analysis: " + symbol + ", Period: " + TimeframeToString(period);
               for (int j = 1; j <= maxStrategy; j++) {
                  for  (int k = 0; k < 5; k++) {  
                     noofdays = days[k];
                     double val = iCustom(symbol, period, "cuSpanTime", j, noofdays, 4, 0);
                     if (val == EMPTY_VALUE) val = 0;
                     //txt = txt + "\n" + symbol + "|" + TimeframeToString(period) + "|" + j + "|" + noofdays + "|" + val;
                     txt = txt + "\nINSERT INTO `new_signals` (`symbol`, `timeperiod`, `noofdays`, `fpips`, `strategy`) VALUES ('" + symbol + "', '" + TimeframeToString(period) + "', '" + noofdays + "', '" + val + "', '" + j + "');";
                     
                  }
               }
         SendMail(subject, txt);
         Comment("done");
      }
   
//----
   return(0);
  }
//+------------------------------------------------------------------+