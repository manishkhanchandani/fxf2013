//+------------------------------------------------------------------+
//|                                            custom_strategy_1.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <custom_currency_fetch.mqh>

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
   int period;
   period = PERIOD_D1;
   double high = iHigh(symbol, period, 1);
   double low = iLow(symbol, period, 1);
   double totalmove = high - low;
   double twentyfivepercent = totalmove / 4;
   double currentopen = iOpen(symbol, period, 0);
   double currentbuy = currentopen + twentyfivepercent;
   double currentsell = currentopen - twentyfivepercent;
   if (opentime[number] != iTime(symbol, PERIOD_D1, 0)) {
      messages[number] = "";
      if (MarketInfo(symbol, MODE_ASK) > currentbuy) {
         messages[number] = "Buy";
         opentime[number] = iTime(symbol, PERIOD_D1, 0);
         Alert(symbol, " is ", messages[number]);
         createorder(symbol, period, 1, "strategy 1");
      } else if (MarketInfo(symbol, MODE_BID) < currentsell) {
         messages[number] = "Sell";
         opentime[number] = iTime(symbol, PERIOD_D1, 0);
         createorder(symbol, period, -1, "strategy 1");
      }
   }
   infobox = StringConcatenate(infobox, " - Buy: ", DoubleToStr(currentbuy, MarketInfo(symbol, MODE_DIGITS)));
   infobox = StringConcatenate(infobox, " - Sell: ", DoubleToStr(currentsell, MarketInfo(symbol, MODE_DIGITS)));
   infobox = StringConcatenate(infobox, " - Message: ", messages[number]);
   infobox = StringConcatenate(infobox, " - Total Move: ", totalmove);
   infobox = StringConcatenate(infobox, " - Bid: ", DoubleToStr(MarketInfo(symbol, MODE_BID), MarketInfo(symbol, MODE_DIGITS)));
   infobox = StringConcatenate(infobox, " - Ask: ", DoubleToStr(MarketInfo(symbol, MODE_ASK), MarketInfo(symbol, MODE_DIGITS)));
}