//+------------------------------------------------------------------+
//|                                                  avg_costing.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
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
int openTime;
int start()
  {
//----
   infobox = "\n";
   string symbol;
   double val2, val3, val4, val5; int x;
   int macd;
   double history;
   double openPositionTotal;
   double lotnew = NormalizeDouble(AccountBalance() / 10000, 2);
   infobox = infobox + "\nLots: " + lotnew + ", Broker: " + AccountCompany();
   for (x = 0; x < ARRSIZE; x++) {
      symbol = aPair[x];
      val2 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",2,1);
      val3 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",3,1);
      val4 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",2,2);
      val5 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",3,2);
         infobox = infobox + "\nSymbol: " + symbol;
      
      macd = macdR(symbol, PERIOD_H1);
      if (macd == 1) {
         infobox = infobox + " MACD BUY";
      } else if (macd == -1) {
         infobox = infobox + " MACD SELL";
      }
      /*
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
      } */
         infobox = infobox + ", Spread: " + DoubleToStr(MarketInfo(symbol, MODE_SPREAD), 0);
   }
   getallinfo();
   FileDelete("statistics.txt");
   FileAppend("statistics.txt", infobox);
      
   Comment (infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+