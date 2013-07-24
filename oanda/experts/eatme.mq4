//+------------------------------------------------------------------+
//|                                                  avg_costing.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <3_signal_inc.mqh>
extern int indication = 0;
extern bool average_costing = false;
int openTime1, openTime4;
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
   infobox = "\n";
   string symbol;
   double val2, val3, val4, val5, val6, val7, val8, val9; int x;
   double history;
   double openPositionTotal;
   
   double lotnew;
   lotnew = lots;
   if (lots == 0) {
      lotnew = NormalizeDouble((AccountBalance() / 10000)/4, 2);
      if (lotnew < 0.01) lotnew = 0.01;
   }
   for (x = 0; x < ARRSIZE; x++) {
      symbol = aPair[x];
      if (symbol != Symbol()) {
         continue;
      }
      infobox = infobox + "Create New Orders: " + createneworders + ", lot size: " + lotnew + ", magic: " + magic + "\n";
      history = history2(symbol);
      openPositionTotal = openPositionTotal(symbol);
      if (average_costing) {
         render_avg_costing(symbol, x, lotnew, false);
      }
   
      val2 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",3,0);
      val4 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",2,1);
      val5 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",3,1);
      
      val6 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,0);
      val7 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,0);
      val8 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,1);
      val9 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,1);
      if (indication == 1) {
         if (createneworders) {
            createorder(aPair[x], 1, lotnew, magic, "Indication", 0, 0);
         }
      } else if (indication == -1) {
         if (createneworders) {
            createorder(aPair[x], -1, lotnew, magic, "Indication", 0, 0);
         }
      }
      if (openTime1 != iTime(symbol, PERIOD_H1, 0)) {
         Alert(symbol, " checking the hour 1 close for profit");
         openTime1 = iTime(symbol, PERIOD_H1, 0);
         if (val6 < val7) {
            CheckForClose(aPair[x], x, magic, 1);
         } else if (val6 > val7) {
            CheckForClose(aPair[x], x, magic, -1);
         }
      }
      if (openTime4 != iTime(symbol, PERIOD_H4, 0)) {
         openTime4 = iTime(symbol, PERIOD_H4, 0);
         Alert(symbol, " checking the hour 4 close and new order");
         if (
         val2 < val3 && val4 > val5
         ) {
            if (!average_costing)
               CheckForCloseWithoutProfit(symbol, x, magic, 1);
            if (createneworders) {
               createorder(aPair[x], 1, lotnew, magic, "H4 Switch", 0, 0);
            }
         } else if (
         val2 > val3 && val4 < val5) {
            if (!average_costing)
               CheckForCloseWithoutProfit(symbol, x, magic, -1);
            if (createneworders) {
               createorder(aPair[x], -1, lotnew, magic, "H4 Switch", 0, 0);
            }
         } else if (
         val2 < val3 && val6 < val7 && val8 > val9
         ) {
            if (createneworders) {
               createorder(aPair[x], 1, lotnew, magic, "H4 Same H1 Switch", 0, 0);
            }
         } else if (
         val2 > val3 && val6 > val7 && val8 < val9
         ) {
            if (createneworders) {
               createorder(aPair[x], -1, lotnew, magic, "H4 Same H1 Switch", 0, 0);
            }
         }
      }
   }
   Comment (infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+