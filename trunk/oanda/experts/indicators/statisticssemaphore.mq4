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
   double range[4];
   double rangeD[4];
   double truerange, movement;
   double truerangeD;
   for (x = 0; x < ARRSIZE; x++) {
      symbol = aPair[x];
      infobox = infobox + "\nSymbol:" + symbol;
      
      semaphore = get_lasttrendsemaphore(x, PERIOD_H4, false);
      infobox = infobox + ", Last Semaphore: " + semaphore + "(" + semaphoreNumber + ")";
      infobox = infobox + ", Spread: " + DoubleToStr(MarketInfo(symbol, MODE_SPREAD), 0);
 
      for (int j = 0; j < 4; j++) {
         range[j] = iHigh(symbol, PERIOD_H1, j) - iLow(symbol, PERIOD_H1, j);
         rangeD[j] = iHigh(symbol, PERIOD_D1, j) - iLow(symbol, PERIOD_D1, j);
      }
      movement = iHigh(symbol, PERIOD_H1, 3) - iLow(symbol, PERIOD_H1, 0);
      truerange = (range[0] + range[1] + range[2] + range[3] ) / 4;
      truerangeD = (rangeD[0] + rangeD[1] + rangeD[2] + rangeD[3] ) / 4;
      infobox = infobox + ", Range: " + DoubleToStr(truerange/MarketInfo(symbol, MODE_POINT), 0);
      infobox = infobox + ", Movement: " + DoubleToStr(movement/MarketInfo(symbol, MODE_POINT), 0);
      infobox = infobox + ", Range Day: " + DoubleToStr(truerangeD/MarketInfo(symbol, MODE_POINT), 0);
      if (semaphoreNumber == 4 && semaphore == 1) {
         infobox = infobox + ", BUY";
      } else if (semaphoreNumber == 4 && semaphore == -1) {
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