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
         if (x == GBPJPY
         ) {
         
         } else {
            continue;
         }
         if (x == GBPJPY) period = PERIOD_M1;

         infobox = infobox + "\n\nSymbol: " + symbol;
         condition_buy = false;
         condition_sell = false;
         infobox = infobox + ", Bid: " +
         MarketInfo(symbol, MODE_BID) + 
         ", Ask: " + MarketInfo(symbol, MODE_ASK) +
         ", Spread: " + MarketInfo(symbol, MODE_SPREAD);
         int macdCurrent = macdRCurrentshift(symbol,period, 1);
         
         double tenkan_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_TENKANSEN, 1);
         double kijun_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, 1);
         bool cb = false;
         bool cs = false;
         if (tenkan_sen_1 > kijun_sen_1 && tenkan_sen_1 < iClose(symbol, period, 1)) {
            cb = true;
         } else if (tenkan_sen_1 < kijun_sen_1 && tenkan_sen_1 > iClose(symbol, period, 1)) {
            cs = true;
         }
         infobox = infobox + ", cb: " + cb +
         ", cs: " + cs + ", macdCurrent: " + macdCurrent;
         
         if (cb && macdCurrent == 1) {
            //buy
            condition_buy = true;
         } else if (cs && macdCurrent == -1) {
            //sell
            condition_sell = true;
         }
         if (forced) {
            if (cb && macdCurrent == 1) {
               //buy
               condition_buy = true;
            } else if (cs && macdCurrent == -1) {
               //sell
               condition_sell = true;
            }
         }
         
         infobox = infobox + ", condition_buy: " +
         condition_buy + 
         ", condition_sell: " + condition_sell;
         
         if (cb && macdCurrent == 1) {
            CheckForCloseWithoutProfit(symbol, x, magic, 1);
         } else if (cs && macdCurrent == -1) {
            CheckForCloseWithoutProfit(symbol, x, magic, -1);
         }
         string message = "MdEA ";
         message = message + TimeframeToString(period) + ", " + cb +
         ", " + cs;
         
         
         infobox = infobox + "\nMessage: " + message;
          
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