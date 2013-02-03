//+------------------------------------------------------------------+
//|                                               cu_perunitcost.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
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
int starttime;
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
   if (starttime != iTime(Symbol(), Period(), 0)) {
   infobox = "";
   getallinfo();
   string symbol;
   for (int x = 0; x < ARRSIZE; x++) {
      if (x == EURJPY || x == CADJPY 
         || x == CHFJPY || x == NZDJPY || x == AUDJPY
         
         ) {
         
         
         } else continue;
      symbol = aPair[x];
      int macd = macdR(symbol, Period());
      int heiken = heiken(symbol, Period());
      int macd2 = macdRCurrent(symbol, Period());
      int heiken2 = heikenCurrent(symbol, Period());
      infobox = infobox + "\nSymbol: " + symbol;
      get_ppf(symbol, x, Period());
      infobox = infobox + ", Fib: R3: " + DoubleToStr(ppf_r3, MarketInfo(symbol, MODE_DIGITS)) + ",R2: " + DoubleToStr(ppf_r2, MarketInfo(symbol, MODE_DIGITS)) +
      ",R1: " + DoubleToStr(ppf_r1, MarketInfo(symbol, MODE_DIGITS)) + ",P: " + DoubleToStr(ppf_p, MarketInfo(symbol, MODE_DIGITS)) + ",S1: " + 
      DoubleToStr(ppf_s1, MarketInfo(symbol, MODE_DIGITS)) + ",S2: " + DoubleToStr(ppf_s2, MarketInfo(symbol, MODE_DIGITS)) 
      + ",S3:" + 
      DoubleToStr(ppf_s3, MarketInfo(symbol, MODE_DIGITS))
      + ",H: " + 
      DoubleToStr(ppf_high, MarketInfo(symbol, MODE_DIGITS)) 
      + ",L: " + 
      DoubleToStr(ppf_low, MarketInfo(symbol, MODE_DIGITS)) 
      + ",C: " + 
      DoubleToStr(ppf_close, MarketInfo(symbol, MODE_DIGITS)) 
      ;
      infobox = infobox + "\nCur MACD: " + macd2 + ", Cur Heikin: " + heiken2;
      if (macd == 1) {
         infobox = infobox + ", MACD Buy Signal";
      } else if (macd == -1) {
         infobox = infobox + ", MACD Sell Signal";
      }
      if (heiken == 1) {
         infobox = infobox + ", Heiken Buy Signal";
      } else if (heiken == -1) {
         infobox = infobox + ", Heiken Sell Signal";
      }
   }
   Comment(infobox);
   starttime = iTime(Symbol(), Period(), 0);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+