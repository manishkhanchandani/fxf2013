//+------------------------------------------------------------------+
//|                                            custom_strategy_multi.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"
//multi strategy
#include <custom_currency_fetch.mqh>
double amount[30][7];
int amount_type[30][7];
int amount_chinkouspan[30][7];
int amount_span[30][7];

int condition_multi[30][9][10];
string filename;
   double previous_bids[30];
   double previous_asks[30];
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
   double bids, asks, point;
   int digit;
   if (current_currency_pair) {
      bids = Bid;
      asks = Ask;
      point = Point;
      digit = Digits;
   } else {
      bids = MarketInfo(symbol, MODE_BID);
      asks = MarketInfo(symbol, MODE_ASK);
      point = MarketInfo(symbol, MODE_POINT);
      digit = MarketInfo(symbol, MODE_DIGITS);
   }

   if(DayOfWeek()==0 || DayOfWeek()==6) {
      infobox = StringConcatenate(infobox, "Holiday so no trading");
      return (0);
   }

   infobox = StringConcatenate(infobox, " - Time: ", timestr(TimeCurrent()), "(",TimeDayOfWeek(TimeCurrent()),")");
   if (MarketInfo(symbol, MODE_SPREAD) > 100) {
      infobox = StringConcatenate(infobox, " - ", MarketInfo(symbol, MODE_SPREAD), ": Spread greater than 100");
      return (0);
   } else {
      infobox = StringConcatenate(infobox, " - Sp: ", MarketInfo(symbol, MODE_SPREAD));
   }

   filename = "customcci2_" + Year() + "_" + Month() + "_" + Day()  + ".txt";
   //FileAppend(filename, "Time: "+timestr(TimeCurrent()));
   string condition_name = "cci";
   int period[5] = {PERIOD_H1, PERIOD_M30, PERIOD_M15, PERIOD_M5, PERIOD_M1};
   int limit;
   if (current_period) {
      period[0] = Period();
      limit = 1;  
   } else {
      limit = 5;
   }
   string mes;
   int i;
   bool condition_buy, condition_sell;
   double val, val2, val3, val4, val5, val6, val7, val8, val9;
   
  
   for (i=0; i < limit; i++) {
      mes = "";
      infobox = StringConcatenate(infobox, " - P: ", TimeframeToString(period[i])); 
      condition_buy = false;
      condition_sell = false;
      val = iCCI(symbol,period[i],45,PRICE_CLOSE,0);
      if (val > 100) {
         condition_multi[number][i][0] = 1;
      } else if (val < -100) {
         condition_multi[number][i][0] = -1;
      } else {
         condition_multi[number][i][0] = 0;
      } 
      
      //val2 = iCustom(symbol, period[i], "MACD_Complete",1,0);
      //val3 = iCustom(symbol, period[i], "MACD_Complete",2,0);
      //if (val2 > val3) {
         //condition_multi[number][i][1] = 1;
      //} else if (val2 < val3) {
         //condition_multi[number][i][1] = -1;
      //} else {
         //condition_multi[number][i][1] = 0;
      //}
      infobox = StringConcatenate(infobox, " - C1: ", condition_multi[number][i][0]);
   } 
      condition_buy = (condition_multi[number][0][0] == 1
         && condition_multi[number][1][0] == 1
         && condition_multi[number][2][0] == 1
         && condition_multi[number][3][0] == 1
         && condition_multi[number][4][0] == 1);
      condition_sell = (condition_multi[number][0][0] == -1
         && condition_multi[number][1][0] == -1
         && condition_multi[number][2][0] == -1
         && condition_multi[number][3][0] == -1
         && condition_multi[number][4][0] == -1);
      if (condition_buy) {
         if (reverse_bid_if_profit) reverse_bid(symbol, 1);
         else if (reverse_bid_force) reverse_bid_force(symbol, 1);
         messages[number] = "buy";
         importantbox = StringConcatenate(importantbox, "\n", symbol, ": Buy");
         call_order_creation(true, false, condition_name, symbol, period[i], number, i, bids, "");
      } else if (condition_sell) {
         if (reverse_bid_if_profit) reverse_bid(symbol, -1);
         else if (reverse_bid_force) reverse_bid_force(symbol, -1);
         messages[number] = "sell";
         importantbox = StringConcatenate(importantbox, "\n", symbol, ": sell");
         call_order_creation(false, true, condition_name, symbol, period[i], number, i, bids, "");
      }
   infobox = StringConcatenate(infobox, " - Bid: ", DoubleToStr(bids, digit));
   infobox = StringConcatenate(infobox, " - Ask: ", DoubleToStr(asks, digit));
   infobox = StringConcatenate(infobox, " - messages: ", messages[number]);
   //FileAppend(filename, "");
}

int call_order_creation(bool condition_buy, bool condition_sell, string condition_name, string symbol, int timeperiod, int number, int i, double bids, string str)
{
   if (markethours) {
      if (hour == 0 || hour == 1 || hour == 7 || hour == 8 || hour == 13 || hour == 14) {
   
      } else {
         infobox = StringConcatenate(infobox, ": Working hours are 0, 1, 7, 8, 13, 14");
         return (0);
      }
   }
   string mes = "";
      if (condition_buy) {
         mes = "Buy";
         if (amount_type[number][i] != iTime(symbol, timeperiod, 0)) {
            amount[number][i] = bids;
            amount_type[number][i] = iTime(symbol, timeperiod, 0);
            Alert("Buy "+ condition_name+" "+build + ", " + str + ", " + symbol);
            FileAppend(filename, "Buy "+ condition_name+" "+build + ", " + str + ", " + symbol + ", "+timestr(TimeCurrent()));
         }
         createorder(symbol, timeperiod, 1, condition_name+" "+build + ", " + str);
      } else if (condition_sell) {
         mes = "Sell";
         if (amount_type[number][i] != iTime(symbol, timeperiod, 0)) {
            amount[number][i] = bids;
            amount_type[number][i] = iTime(symbol, timeperiod, 0);
            Alert("Sell "+ condition_name+" "+build + ", " + str + ", " + symbol);
            FileAppend(filename, "Sell "+ condition_name+" "+build + ", " + str + ", " + symbol + ", "+timestr(TimeCurrent()));
         }
         createorder(symbol, timeperiod, -1, condition_name+" "+build + ", " + str);
      } 
      infobox = StringConcatenate(infobox, "(", mes, ")");
      return (0);
}

