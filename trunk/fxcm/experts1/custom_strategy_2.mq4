//+------------------------------------------------------------------+
//|                                            custom_strategy_1.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <custom_currency_fetch.mqh>

double initial[30];
double final[30];
int pd[30];
int pd2[30];
int diff = 50;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   custom_init();
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
   custom_start();   
//----
   return(0);
  }
//+------------------------------------------------------------------+

int strategy(string symbol, int number)
{
   double diffamountbuy = 0;
   double diffamountsell = 0;
   if (!initial[number]) {
      initial[number] = MarketInfo(symbol, MODE_BID);
      final[number] = MarketInfo(symbol, MODE_BID);
      pd[number] = TimeCurrent(); 
   }

   if (MarketInfo(symbol, MODE_BID) > initial[number]) {
      diffamountbuy = (MarketInfo(symbol, MODE_BID) - initial[number]) / MarketInfo(symbol, MODE_POINT);
   } else if (MarketInfo(symbol, MODE_BID) < initial[number]) {
      diffamountsell = (initial[number] - MarketInfo(symbol, MODE_BID)) / MarketInfo(symbol, MODE_POINT);
   }
   
   if (diffamountbuy > diff) {
      final[number] = initial[number];
      pd2[number] = TimeCurrent() - pd[number];
      messages[number] = "Buy";
      initial[number] = MarketInfo(symbol, MODE_BID);
      pd[number] = TimeCurrent(); 
      SendAlert("Buy "+ pd2[number], symbol, 0);
   } else if (diffamountsell > diff) {
      final[number] = initial[number];
      pd2[number] = TimeCurrent() - pd[number];
      messages[number] = "Sell";
      initial[number] = MarketInfo(symbol, MODE_BID);
      pd[number] = TimeCurrent(); 
      SendAlert("Sell " + pd2[number], symbol, 0);
   } 

   infobox = StringConcatenate(infobox, " - final[number]: ", DoubleToStr(final[number], MarketInfo(symbol, MODE_DIGITS)));   
   infobox = StringConcatenate(infobox, " - pd2[number]: ", pd2[number]);  
   infobox = StringConcatenate(infobox, " - diffamountbuy: ", diffamountbuy); 
   infobox = StringConcatenate(infobox, " - diffamountsell: ", diffamountsell);
   infobox = StringConcatenate(infobox, " - Message: ", messages[number]);
   infobox = StringConcatenate(infobox, " - Bid: ", DoubleToStr(MarketInfo(symbol, MODE_BID), MarketInfo(symbol, MODE_DIGITS)));
   infobox = StringConcatenate(infobox, " - Ask: ", DoubleToStr(MarketInfo(symbol, MODE_ASK), MarketInfo(symbol, MODE_DIGITS)));
   infobox = StringConcatenate(infobox, " - initial[number]: ", DoubleToStr(initial[number], MarketInfo(symbol, MODE_DIGITS)));  
}