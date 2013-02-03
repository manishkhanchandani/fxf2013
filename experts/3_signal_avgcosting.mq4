//+------------------------------------------------------------------+
//|                                                    3_signala.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <3_signal_inc.mqh>

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
bool tradingTime = false;
int start()
  {
//----
   infobox = "";
   lotcalc();
   hour = Hour() - gmtoffset;
   if (hour < 0) hour = 24 + hour;
   tradingTime = false;
   if ((hour >= 15 && hour <= 23) || (hour >= 0 && hour <= 8)) {
      tradingTime = true;
   }
   infobox = "\nTime: " + TimeToStr(TimeCurrent()) + " and Hour is: " + hour + ", Server Hour: " + Hour() + 
   ", minutes: " + Minute() + ", createneworders: " + createneworders + ", build: " + build + ", lots: " + lots + 
   ", Spread: " + MarketInfo(Symbol(), MODE_SPREAD) + ", tradingTime: " + tradingTime + "\n";
   
   int x;
   int open1, open2;
   string symbol;
   string message = "custom " + TimeframeToString(Period());
   bool condition_buy1, condition_sell1;
   bool condition_buy2, condition_sell2;
   for (x = 0; x < ARRSIZE; x++) {
      symbol = aPair[x];
      render_avg_costing(symbol, x, lots, true, true);
   }
   Comment(infobox);   
//----
   return(0);
  }
//+------------------------------------------------------------------+