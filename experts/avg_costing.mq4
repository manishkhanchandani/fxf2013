//+------------------------------------------------------------------+
//|                                                  avg_costing.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <3_signal_inc.mqh>
extern int indication = 0;

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
   double val2, val3, val4, val5; int x;
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
      history = history2(symbol);
      openPositionTotal = openPositionTotal(symbol);
      //history(symbol, x, magic);
      render_avg_costing(symbol, x, lots);
      getallinfoSingle(symbol);
      
      val2 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",3,0);
      val4 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,0);
      val5 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,0);
      string testbox = "\naLookupSingle: " +aLookupSingle + ", aStrengthSingle: " + aStrengthSingle + ", Lots: "+lotnew+
      ", val2 < val3: " + (val2 < val3) +
      ", val2 > val3: " + (val2 > val3) + ",(" + val2 + "," + val3 + "), Bid: " + MarketInfo(symbol, MODE_BID) +
      "\n";
      if (
      val2 < val3 && 
      val4 < val5 && 
      (indication == 1 || indication == 0) && aLookupSingle >= 8) {
         createorder(aPair[x], 1, lotnew, magic, "", 0, 0);
      } else if (
      val2 > val3 && 
      val4 > val5 && 
      (indication == -1 || indication == 0) && aLookupSingle <= 1) {
         createorder(aPair[x], -1, lotnew, magic, "", 0, 0);
      }
   }
   Comment (testbox, infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+