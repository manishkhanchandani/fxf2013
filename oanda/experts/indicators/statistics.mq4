//+------------------------------------------------------------------+
//|                                                   statistics.mq4 |
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
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
   infobox = "\n";
   string symbol; int x;
   double history;
   double openPositionTotal;
   double lotnew = NormalizeDouble(AccountBalance() / 10000, 2);
   infobox = infobox + "\nLots: " + lotnew + ", Broker: " + AccountCompany();
   getallinfo();
   int semaphore;
   bool condition_buy, condition_sell;
   double val2, val3, val4, val5, val4a, val5a, val6, val7, val8, val9, val10, val11, val12, val13;
   for (x = 0; x < ARRSIZE; x++) {
      symbol = aPair[x];
      infobox = infobox + "\nSymbol:" + symbol;
      val2 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",3,0);
      val4 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,0);
      val5 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,0);
      val4a = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,1);
      val5a = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,1);
      
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
      infobox = infobox + ", condition_buy: " + condition_buy;
      infobox = infobox + ", condition_sell: " + condition_sell;
      infobox = infobox + ", Spread: " + DoubleToStr(MarketInfo(symbol, MODE_SPREAD), 0);
      
      semaphore = get_lasttrendsemaphore(x, PERIOD_H1, false);
      infobox = infobox + ", Last Semaphore: " + semaphore + "(" + semaphoreNumber + ")";
      double macd_main = iMACD(symbol, PERIOD_H1,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
      double macd_signal = iMACD(symbol, PERIOD_H1,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
      double macd_main1 = iMACD(symbol, PERIOD_H1,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
      double macd_signal1 = iMACD(symbol, PERIOD_H1,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
      if (macd_main > macd_signal && macd_main1 < macd_signal1) {
         infobox = infobox + ", MACD BUY";
      } else if (macd_main < macd_signal && macd_main1 > macd_signal1) {
         infobox = infobox + ", MACD SELL";
      } 
      if (semaphoreNumber < 15 && semaphore == 1 && condition_buy
            && val4a > val5a) {
         infobox = infobox + ", BUY";
      } else if (semaphoreNumber < 15 && semaphore == -1 && condition_sell
            && val4a > val5a) {
         infobox = infobox + ", SELL";
      }
   }
   FileDelete("statisticsInd.txt");
   FileAppend("statisticsInd.txt", infobox);
      
   Comment (infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+