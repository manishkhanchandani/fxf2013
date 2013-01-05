//+------------------------------------------------------------------+
//|                                                  avg_costing.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <3_signal_inc.mqh>
extern bool average_costing = false;
extern bool trailingfun = false;
extern bool close_on_loss = true;
extern int lotfactor = 2;
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
   hour = Hour();
   /*hour = Hour(); - gmtoffset;
   if (hour < 0) {
      hour = 24 + hour;
   }*/
   infobox = "\n";
   string symbol;
   double val2, val3, val4, val5, val4a, val5a, val6, val7, val8, val9, val10, val11, val12, val13; int x;
   double history;
   double openPositionTotal;
   bool condition_buy, condition_sell;
   double lotnew;
   lotnew = lots;
   if (lots == 0) {
      lotnew = NormalizeDouble((AccountBalance() / 10000)/lotfactor, 2);
      if (lotnew < 0.01) lotnew = 0.01;
   }
   getallinfo();
   int semaphore;
   infobox = infobox + "\nCreate New Orders: " + createneworders + ", lot size: " + lotnew + ", magic: " + magic + ", hour: " + hour + "\n";
   string particularbox;
   for (x = 0; x < ARRSIZE; x++) {
      if (x == EURCHF || x == EURGBP || x == AUDNZD || x == USDJPY) {
         continue;
      }
      if (x == EURJPY || x == GBPJPY || x == CHFJPY || x == EURUSD || x == USDCHF || x == GBPUSD || x == NZDJPY
         || x == NZDUSD || x == NZDCHF
      ) {
      
      } else {
         continue;
      }
      symbol = aPair[x];
      history = history2(symbol);
      openPositionTotal = openPositionTotal(symbol);
      render_avg_costing(symbol, x, lotnew, trailingfun, average_costing);
      particularbox = particularbox + "\nSymbol:" + symbol;
      val2 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",2,1);
      val3 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",3,1);
      val4 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,1);
      val5 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,1);
      val4a = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,2);
      val5a = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,2);
      
      val6 = iCustom(symbol, PERIOD_M30, "Heiken_Ashi_Smoothed",2,0);
      val7 = iCustom(symbol, PERIOD_M30, "Heiken_Ashi_Smoothed",3,0);
      val8 = iCustom(symbol, PERIOD_M15, "Heiken_Ashi_Smoothed",2,0);
      val9 = iCustom(symbol, PERIOD_M15, "Heiken_Ashi_Smoothed",3,0);
      
      val10 = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",2,0);
      val11 = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",3,0);
      val12 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",2,0);
      val13 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",3,0);
      condition_buy = (val4 < val5
         && val6 < val7
         && val8 < val9
         && val10 < val11
         && val12 < val13
      );
      condition_sell = (val4 > val5
         && val6 > val7
         && val8 > val9
         && val10 > val11
         && val12 > val13
      );
      particularbox = particularbox + ", condition_buy: " + condition_buy;
      particularbox = particularbox + ", condition_sell: " + condition_sell;
      particularbox = particularbox + ", Spread: " + DoubleToStr(MarketInfo(symbol, MODE_SPREAD), 0);
      
      semaphore = get_lasttrendsemaphore(x, PERIOD_H1, false);
      particularbox = particularbox + ", Last Semaphore: " + semaphore + "(" + semaphoreNumber + ")";
      
         particularbox = particularbox + ", Bid: "+ MarketInfo(symbol, MODE_BID);
      if (semaphoreNumber < 15 && semaphore == 1 && condition_buy
            && val4a > val5a) {
         particularbox = particularbox + ", BUY";
      } else if (semaphoreNumber < 15 && semaphore == -1 && condition_sell
            && val4a < val5a) {
         particularbox = particularbox + ", SELL";
      }
      if (condition_buy
            && semaphore == 1) {
         CheckForClose(aPair[x], x, magic, 1);
      } else if (condition_sell
            && semaphore == -1) {
         CheckForClose(aPair[x], x, magic, -1);
      }
      if (
            condition_buy
            && val4a > val5a 
            && semaphore == 1
            //&& val2 < val3 
            //&& aLookupSingle >= 7
         ) {
         particularbox = particularbox + ", BUY2";
            if (createneworders) {
               createorder(aPair[x], 1, lotnew, magic, "Eatmepowerful Ask: " + MarketInfo(symbol, MODE_ASK), 300, 0);
            }
         } else if (
            condition_sell 
            && val4a < val5a
            && semaphore == -1
            //&& val2 > val3 
            //&& aLookupSingle <= 2
         ) {
         particularbox = particularbox + ", SELL2";
            if (createneworders) {
               createorder(aPair[x], -1, lotnew, magic, "Eatmepowerful Bid: " + MarketInfo(symbol, MODE_BID), 300, 0);
            }
         }
   }
   
   Comment (particularbox, infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+