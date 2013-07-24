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
   if ((hour >= 17 && hour <= 23) || (hour >= 0 && hour <= 8)) {
      tradingTime = true;
   }
   infobox = "\nTime: " + TimeToStr(TimeCurrent()) + " and Hour is: " + hour + ", Server Hour: " + Hour() + 
   ", minutes: " + Minute() + ", createneworders: " + createneworders + ", build: " + build + ", lots: " + lots + 
   ", Spread: " + MarketInfo(Symbol(), MODE_SPREAD) + ", tradingTime: " + tradingTime + "\n";
   
   getallinfo();
      infobox = infobox + "\n";
   int x;
   int open1, open2;
   string symbol;
   string message = "custom " + TimeframeToString(Period());
   bool condition_buy1, condition_sell1;
   bool condition_buy2, condition_sell2;
   
   bool condition_buy = false;
   bool condition_sell = false;
         double val2, val3, val4, val5, val6, val7, val8, val9;
         int condition_heiken2, condition_heiken3, condition_heiken4, condition_heiken5, condition_heiken6;
   for (x = 0; x < ARRSIZE; x++) {
      symbol = aPair[x];
      render_avg_costing(symbol, x, lots, false, false);
      if (symbol == "AUDNZD" || symbol == "EURGBP" || symbol == "EURCHF"
         || symbol == "AUDUSD" || symbol == "USDJPY"
      ) continue;
      
         string current_currency1 = StringSubstr(symbol, 0, 3);
         string current_currency2 = StringSubstr(symbol, 3, 3);
         if (current_currency2 != "JPY") continue;
         if (current_currency1 == "NZD" || current_currency1 == "AUD") continue;
         
            int heikenM15 = macdR(symbol, PERIOD_M15);
            int heikenCM15 = macdRCurrent(symbol, PERIOD_M15);
         if (totalorders[x] > 0) {
         if (heikenCM15 == 1) {
            //Alert(symbol, ", close sell order, ", heikenCM5, ", ", heikenCM15);
            CheckForCloseALL(symbol, x, 1);
         } else if (heikenCM15 == -1) {
            //Alert(symbol, ", close buy order, ", heikenCM5, ", ", heikenCM15);
            CheckForCloseALL(symbol, x, -1);
         }
         /*
         if (heikenCM5 == 1 || heikenCM15 == 1) {
            Alert(symbol, ", close sell order");
            CheckForCloseALL(symbol, x, 1);
         } else if (heikenCM5 == 1 || heikenCM15 == 1) {
            Alert(symbol, ", close buy order");
            CheckForCloseALL(symbol, x, -1);
         }
         */
         }
         infobox = infobox + "\nSymbol: " + symbol + ", Currency 1: " + current_currency1 + ", Currency 2: " + current_currency2;
            
            infobox = infobox + ": " + heikenCM15 + ": " + heikenM15;
            //message = message + " " + TimeFrame;
            infobox = infobox + ", spread: " + MarketInfo(symbol, MODE_SPREAD);
         
            if (heikenM15 == 1) {
               if (createneworders && tradingTime) createorder(symbol, 1, lots, magic, message + TimeFrame, 0, 0);
            }
        else
            if (heikenM15 == -1) {
               if (createneworders && tradingTime) createorder(symbol, -1, lots, magic, message + TimeFrame, 0, 0);
            }
   }
   Comment(infobox);   
//----
   return(0);
  }
//+------------------------------------------------------------------+