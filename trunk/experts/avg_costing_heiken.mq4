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
      history = history2(symbol);
      openPositionTotal = openPositionTotal(symbol);
      //history(symbol, x, magic);
      render_avg_costing(symbol, x, lots);
      getallinfoSingle(symbol);
      string testbox = "\naLookupSingle: " +aLookupSingle + ", aStrengthSingle: " + aStrengthSingle + ", Lots: "+lotnew+"\n";
      
      val2 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",3,0);
      val4 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",2,1);
      val5 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",3,1);
      val6 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,0);
      val7 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,0);
      val8 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,1);
      val9 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,1);
      if (val2 < val3 || val6 < val7) {
         CheckForClose(aPair[x], x, magic, 1);
      } else if (val2 > val3 || val6 > val7) {
         CheckForClose(aPair[x], x, magic, -1);
      }
      if (
      (val2 < val3 && 
      val4 > val5 &&
      val6 < val7)
      ||
      (val2 < val3 &&
      val6 < val7 &&
      val8 > val9)
      ||
      (indication == 1)
      ) {
         createorder(aPair[x], 1, lotnew, magic, "AvgCosting Heiken", 0, 0);
      } else if (
     (val2 > val3 && 
      val4 < val5 &&
      val6 > val7)
      ||
      (val2 > val3 &&
      val6 > val7 &&
      val8 < val9) 
      ||
      (indication == -1)
      ) {
         createorder(aPair[x], -1, lotnew, magic, "AvgCosting Heiken", 0, 0);
      }
   }
   Comment (testbox, infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+