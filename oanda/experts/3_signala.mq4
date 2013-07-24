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
int start()
  {
//----
   infobox = "";
   lotcalc();
   hour = Hour() - gmtoffset;
   infobox = "\nTime: " + TimeToStr(TimeCurrent()) + " and Hour is: " + hour + ", Server Hour: " + Hour() + 
   ", minutes: " + Minute() + ", createneworders: " + createneworders + ", build: " + build + ", lots: " + lots + "\n";
   
   getallinfo();
   int x;
   int open1, open2;
   string symbol;
   string message = "custom";
   bool condition_buy1, condition_sell1;
   bool condition_buy2, condition_sell2;
   for (x = 0; x < ARRSIZE; x++) {
      symbol = aPair[x];
      if (symbol != Symbol()) {
         continue;
      }
      
      history2(symbol);
      openPositionTotal(symbol);
      
      open1 = checkforopen(symbol, x);
      if (open1 == 1) condition_buy1 = true;
      else if (open1 == -1) condition_sell1 = true;
      if (condition_buy1) {
         CheckForCloseWithoutProfit(symbol, x, magic, 1);
      } else if (condition_sell1) {
         CheckForCloseWithoutProfit(symbol, x, magic, -1);
      }
      open2 = checkforopen2(symbol, x);
      if (open2 == 1) condition_buy2 = true;
      else if (open2 == -1) condition_sell2 = true;
   
      //create currency 1 Order
      if (condition_buy1 && condition_buy2) {
         if (createneworders) {
            createorder(symbol, 1, lots, magic, message, 0, 0);
         }
      } else if (condition_sell1 && condition_sell2) {
         if (createneworders) {
            createorder(symbol, -1, lots, magic, message, 0, 0);
         }
      }
      
   }
   Comment(infobox);   
//----
   return(0);
  }
//+------------------------------------------------------------------+