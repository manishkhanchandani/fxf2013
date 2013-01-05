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
   string symbol;
   double val2, val3, val4, val5; int x;
   double history;
   double openPositionTotal;
   double lotnew = NormalizeDouble(AccountBalance() / 10000, 2);
   infobox = infobox + "\nLots: " + lotnew + ", Broker: " + AccountCompany();
   getallinfo();
   int semaphore;
   for (x = 0; x < ARRSIZE; x++) {
      symbol = aPair[x];
      
      if (symbol != Symbol()) continue;
      val2 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",2,1);
      val3 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",3,1);
      val4 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",2,2);
      val5 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",3,2);
         infobox = infobox + "\nSymbol: " + symbol;
      if (
      val2 < val3 && val4 > val5
      ) {
         infobox = infobox + ", Trigger Buy, Buy now";
      } else if (
      val2 > val3 && val4 < val5) {
         infobox = infobox + ", Trigger Sell, Sell now";
      } else if (
      val2 < val3
      ) {
         infobox = infobox + ", Current Buy";
      } else if (
      val2 > val3) {
         infobox = infobox + ", Current Sell";
      } 
      if (
      val4 < val5
      ) {
         infobox = infobox + ", Previous Buy";
      } else if (
      val4 > val5) {
         infobox = infobox + ", Previous Sell";
      }
      //stats
      val2 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",3,0);
      if (
      val2 < val3
      ) {
         infobox = infobox + ", H4:1";
      } else if (
      val2 > val3) {
         infobox = infobox + ", H4:0";
      } 
      val2 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,0);
      if (
      val2 < val3
      ) {
         infobox = infobox + ", H1:1";
      } else if (
      val2 > val3) {
         infobox = infobox + ", H1:0";
      } 
      val2 = iCustom(symbol, PERIOD_M30, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_M30, "Heiken_Ashi_Smoothed",3,0);
      if (
      val2 < val3
      ) {
         infobox = infobox + ", M30:1";
      } else if (
      val2 > val3) {
         infobox = infobox + ", M30:0";
      } 
      val2 = iCustom(symbol, PERIOD_M15, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_M15, "Heiken_Ashi_Smoothed",3,0);
      if (
      val2 < val3
      ) {
         infobox = infobox + ", M15:1";
      } else if (
      val2 > val3) {
         infobox = infobox + ", M15:0";
      } 
      val2 = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",3,0);
      if (
      val2 < val3
      ) {
         infobox = infobox + ", M5:1";
      } else if (
      val2 > val3) {
         infobox = infobox + ", M5:0";
      } 
      val2 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",3,0);
      if (
      val2 < val3
      ) {
         infobox = infobox + ", M1:1";
      } else if (
      val2 > val3) {
         infobox = infobox + ", M1:0";
      } 
         infobox = infobox + ", Spread: " + DoubleToStr(MarketInfo(symbol, MODE_SPREAD), 0);
    infobox = infobox + "\n\n";
   double tenkan_sen_1, tenkan_sen_2;
   tenkan_sen_1=iIchimoku(symbol,PERIOD_H1, 9, 26, 52, MODE_TENKANSEN, 0);
   tenkan_sen_2=iIchimoku(symbol,PERIOD_H1, 9, 26, 52, MODE_TENKANSEN, 1);
   
   if (tenkan_sen_1 < MarketInfo(symbol, MODE_BID)) {
     infobox = infobox + "Tenkan Sen Buy";
   } else if (tenkan_sen_1 > MarketInfo(symbol, MODE_BID)) {
     infobox = infobox + "Tenkan Sen Sell";
   }
   infobox = infobox + "\n";
   double macd2, macd3, macd4, macd5;
   macd2 = iCustom(symbol, PERIOD_H1, "MACD_Complete",1,0);
   macd3 = iCustom(symbol, PERIOD_H1, "MACD_Complete",2,0);
   macd4 = iCustom(symbol, PERIOD_H1, "MACD_Complete",1,1);
   macd5 = iCustom(symbol, PERIOD_H1, "MACD_Complete",2,1);
   if (macd2 > macd3) {
     infobox = infobox + "MACD Buy";
   } else if (macd2 < macd3) {
     infobox = infobox + "MACD Sell";
   }
      infobox = infobox + "\n\n";
      mathmurry(symbol, x);
      
      semaphore = get_lasttrendsemaphore(x, PERIOD_H1, false);
      infobox = infobox + "\nLast Semaphore: " + semaphore + "(" + semaphoreNumber + ")";
   }
   //FileDelete("statisticsIndsingle.txt");
   FileAppend("statisticsIndsingle.txt", infobox);
      
   Comment (infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+