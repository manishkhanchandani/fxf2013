//+------------------------------------------------------------------+
//|                                                         test.mq4 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#include <3_signal_inc.mqh>
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   Comment(AccountLeverage());
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
   string symbol;
   infobox = "\nLeverage: "+AccountLeverage();
   for (int x = 0; x < ARRSIZE; x++) {
      symbol = aPair[x];
      infobox = infobox + "\nSymbol: " + symbol + ", spread: " + MarketInfo(symbol, MODE_SPREAD);
   }
   Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+