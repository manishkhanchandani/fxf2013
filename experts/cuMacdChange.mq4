//+------------------------------------------------------------------+
//|                                                        cuJPY.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <3_signal_inc.mqh>
extern double lotsize = 0.01;
bool forced = false;

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
      hour = Hour() - gmtoffset;
      if (hour < 0) hour = 24 + hour;
      bool markethours = false;
      if ((hour >= 11 && hour <= 2) || (hour >= 7 && hour <= 13) || (hour >= 15 && hour <= 16)) {
         markethours = true;
      }
      //best time is M1 and M5
      int x;
      int period = PERIOD_M1;
      string symbol;
      bool buyorder;
      bool sellorder;
      bool condition_buy, condition_sell;
      bool ich_buy, ich_sell;
      infobox = "";
      infobox = infobox + "\nHour: " + hour + ", markethours: " + markethours;
      for (x = 0; x < ARRSIZE; x++) {
         double tmplots = lotsize;
         symbol = aPair[x];
         if (x == CHFJPY
         //|| x == AUDJPY  || x == NZDJPY
         ) {
         
         } else {
            continue;
         }
         if (x == GBPJPY) period = PERIOD_M5;
         if (x == CHFJPY) period = PERIOD_M5;
         if (x == USDJPY) period = PERIOD_M5;
         if (x == EURJPY) period = PERIOD_M5;
         if (x == CADJPY) period = PERIOD_M5;
         
         infobox = infobox + "\n\nSymbol: " + symbol;
         condition_buy = false;
         condition_sell = false;
         infobox = infobox + ", Bid: " +
         MarketInfo(symbol, MODE_BID) + 
         ", Ask: " + MarketInfo(symbol, MODE_ASK) +
         ", Spread: " + MarketInfo(symbol, MODE_SPREAD);
         double MacdCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
         double MacdPast=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,2);
         if (MacdCurrent > 0 && MacdPast <= 0) {
            //buy
            condition_buy = true;
         } else if (MacdCurrent < 0 && MacdPast >= 0) {
            //sell
            condition_sell = true;
         }
         if (forced) {
            if (MacdCurrent > 0) {
               //buy
               condition_buy = true;
            } else if (MacdCurrent < 0) {
               //sell
               condition_sell = true;
            }
         }
         if (MacdCurrent > 0) {
            CheckForCloseWithoutProfit(symbol, x, magic, 1);
         } else if (MacdCurrent < 0) {
            CheckForCloseWithoutProfit(symbol, x, magic, -1);
         }
         string message = "MdEA ";
         message = message + TimeframeToString(period) + ", " + DoubleToStr(MacdCurrent, MarketInfo(symbol, MODE_DIGITS))
         + " : " + DoubleToStr(MacdPast, MarketInfo(symbol, MODE_DIGITS));
         
         
         infobox = infobox + "\nMacdCurrent: " + MacdCurrent + ", MacdPast: " + MacdPast + ", Message: " + message;
          
         if (condition_buy) {
            if (createneworders) createorder(aPair[x], 1, tmplots, magic, message, 0, 0);
         } else if (condition_sell) {
            if (createneworders) createorder(aPair[x], -1, tmplots, magic, message, 0, 0);
         }
      }
      string orderbox = "\n\nManaging Orders:\n";
      
      for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()==magic) {
         orderbox = orderbox + "\nSymbol: " + OrderSymbol() + ", Type: " + OrderType() + ", Order Profit: " +
         OrderProfit();
         }
     }
      Comment(infobox, orderbox);
//----
   return(0);
  }
//+------------------------------------------------------------------+