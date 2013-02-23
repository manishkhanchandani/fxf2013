//+------------------------------------------------------------------+
//|                                                cu_day_heiken.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#include <3_signal_inc.mqh>
int stime;

int FastEMA=12;
int SlowEMA=26;
int SignalSMA=9;


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
   if (stime != iTime(Symbol(), Period(), 0)) {
      stime = iTime(Symbol(), Period(), 0);
   infobox = "";
   int x;
   int period = Period();
   string symbol;
   int periods[7] = {PERIOD_D1, PERIOD_H4, PERIOD_H1, PERIOD_M30, PERIOD_M15, PERIOD_M5, PERIOD_M1};
   string tmpbox;
   for (x = 0; x < ARRSIZE; x++) {
         tmpbox = "             ";
         if (x == EURJPY || x == CHFJPY || x == GBPJPY || x == CADJPY || x == USDJPY || x == AUDJPY
          || x == NZDJPY || x == GBPNZD) {
         
         } else {
            //continue;
         }
         symbol = aPair[x];
         
         infobox = infobox + "\nSymbol: " + symbol;
         for (int j=0;j<3; j++) {
            double macd = iMA(symbol, periods[j],FastEMA,0,MODE_EMA,PRICE_CLOSE,1);
            double macd2=iMA(symbol, periods[j],SlowEMA,0,MODE_EMA,PRICE_CLOSE,1);
            double macddiff = macd - macd2;
            if ((macddiff > 0 && macddiff < 0.0008) || (macddiff < 0 && macddiff > -0.0008)) {
               tmpbox = tmpbox + ", Sp " + TimeframeToString(periods[j]) + " Signal";
            } else 
            if ((macddiff > 0 && macddiff < 0.008) || (macddiff < 0 && macddiff > -0.008)) {
               tmpbox = tmpbox + ", " + TimeframeToString(periods[j]) + " Signal";
            }
            infobox = infobox + ", " + TimeframeToString(periods[j]) + " MACD: " + macddiff;
         }
         infobox = infobox + tmpbox;
         if (macd == 1 || macd == -1) {
            //SendAlert("Macd for symbol: " + symbol + " is " + macd + " with Bid price: " + MarketInfo(symbol, MODE_BID), symbol, PERIOD_M5);
         }
         
   }
   Comment(infobox);
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+