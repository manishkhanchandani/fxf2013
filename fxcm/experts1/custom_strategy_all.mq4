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

int condition[30][4];
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

   if (markethours) {
      if (hour == 0 || hour == 1 || hour == 7 || hour == 8 || hour == 13 || hour == 14) {
   
      } else {
         infobox = StringConcatenate(infobox, ": Working hours are 0, 1, 7, 8, 13, 14");
         return (0);
      }
   }
   infobox = StringConcatenate(infobox, " - Time: ", timestr(TimeCurrent()), "(",TimeDayOfWeek(TimeCurrent()),")");
   if (MarketInfo(symbol, MODE_SPREAD) > 70) {
      infobox = StringConcatenate(infobox, " - ", MarketInfo(symbol, MODE_SPREAD), ": Spread greater than 70");
      return (0);
   } else {
      infobox = StringConcatenate(infobox, " - Sp: ", MarketInfo(symbol, MODE_SPREAD));
   }

   string filename = symbol + "/filemulti2_" + Year() + "_" + Month() + "_" + Day()  + ".txt";
   //FileAppend(filename, "Time: "+timestr(TimeCurrent()));
   string condition_name;
   //int period[5] = {PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1}; //, PERIOD_H4, PERIOD_D1
   int period[7] = {PERIOD_D1, PERIOD_H4, PERIOD_H1, PERIOD_M30, PERIOD_M15, PERIOD_M5, PERIOD_M1};
   int limit;
   period[0] = Period();
   limit = 1;  
   string mes;
   int i;
   bool condition_buy, condition_sell;
   double tenkan_sen_1, tenkan_sen_2, tenkan_sen_3, tenkan_sen_4, kijun_sen_1, kijun_sen_2, kijun_sen_3, kijun_sen_4, spanA, spanB, chinkouspan, spanHigh, spanLow, spanHigh2, spanLow2, spanAb, spanBb;
   int strategytype = 3;
   double ima50, ima100;
   for (i=0; i < limit; i++) {
      mes = "";
      infobox = StringConcatenate(infobox, " - P: ", TimeframeToString(period[i])); 
      condition_buy = false;
      condition_sell = false;

      switch (strategytype) {
         case 1:
            condition_name = "Ichimoku";
            tenkan_sen_1=iIchimoku(symbol, period[i], 9, 26, 52, MODE_TENKANSEN, 1);
            tenkan_sen_2=iIchimoku(symbol, period[i], 9, 26, 52, MODE_TENKANSEN, 2);
            kijun_sen_1=iIchimoku(symbol, period[i], 9, 26, 52, MODE_KIJUNSEN, 1);
            kijun_sen_2=iIchimoku(symbol, period[i], 9, 26, 52, MODE_KIJUNSEN, 2);
            chinkouspan = iIchimoku(symbol, period[i], 9, 26, 52, MODE_CHINKOUSPAN, 27);
            spanA = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, 1);
            spanB = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, 1);
            if (spanA > spanB) {
               spanHigh = spanA;
               spanLow = spanB;
               spanHigh2 = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, 2);
               spanLow2 = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, 2);
            } else {
               spanHigh = spanB;
               spanLow = spanA;
               spanHigh2 = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, 2);
               spanLow2 = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, 2);
            }
     
            condition_buy = (tenkan_sen_1 > kijun_sen_1 && tenkan_sen_2 < kijun_sen_2 && chinkouspan > iHigh(symbol, period[i], 27) && kijun_sen_1 > kijun_sen_2);
            condition_sell = (tenkan_sen_1 < kijun_sen_1 && tenkan_sen_2 > kijun_sen_2 && chinkouspan < iLow(symbol, period[i], 27) && kijun_sen_1 < kijun_sen_2);
     
            if (condition_buy) {
               messages[number] = "buy";
               call_order_creation(true, false, condition_name, symbol, period[i], number, i, bids, "");
            } else if (condition_sell) {
               messages[number] = "sell";
               call_order_creation(false, true, condition_name, symbol, period[i], number, i, bids, "");
            }
            break;
         case 2:
            condition_name = "Kumobreakout";
            
            tenkan_sen_1=iIchimoku(symbol, period[i], 9, 26, 52, MODE_TENKANSEN, 1);
            tenkan_sen_2=iIchimoku(symbol, period[i], 9, 26, 52, MODE_TENKANSEN, 2);
            kijun_sen_1=iIchimoku(symbol, period[i], 9, 26, 52, MODE_KIJUNSEN, 1);
            kijun_sen_2=iIchimoku(symbol, period[i], 9, 26, 52, MODE_KIJUNSEN, 2);
            chinkouspan = iIchimoku(symbol, period[i], 9, 26, 52, MODE_CHINKOUSPAN, 27);
            spanA = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, 1);
            spanB = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, 1);
            if (spanA > spanB) {
               spanHigh = spanA;
               spanLow = spanB;
               spanHigh2 = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, 2);
               spanLow2 = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, 2);
            } else {
               spanHigh = spanB;
               spanLow = spanA;
               spanHigh2 = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, 2);
               spanLow2 = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, 2);
            }
     
            condition_buy = (
               tenkan_sen_1 > kijun_sen_1 
               && iClose(symbol, period[i], 1) > spanHigh 
               && iOpen(symbol, period[i], 1) < spanHigh 
               && chinkouspan > iHigh(symbol, period[i], 27) 
               && spanHigh >= spanHigh2
               );
            condition_sell = (
               tenkan_sen_1 < kijun_sen_1 
               && iClose(symbol, period[i], 1) < spanLow 
               && iOpen(symbol, period[i], 1) > spanLow 
               && chinkouspan < iLow(symbol, period[i], 27)
               && spanLow <= spanLow2);
     
            if (condition_buy) {
               messages[number] = "buy";
               call_order_creation(true, false, condition_name, symbol, period[i], number, i, bids, "");
            } else if (condition_sell) {
               messages[number] = "sell";
               call_order_creation(false, true, condition_name, symbol, period[i], number, i, bids, "");
            }
            break;
         case 3:
            condition_name = "SpanAB";
            
            spanA = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, -25);
            spanB = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, -25);
            spanAb = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, -24);
            spanBb = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, -24);
            infobox = StringConcatenate(infobox, ", Spans: ", spanA, " = ", spanB, " = ", spanAb, " = ", spanBb);
            condition_buy = (
               spanAb < spanBb
               && spanA > spanB
               );
            condition_sell = (
               spanAb > spanBb
               && spanA < spanB
               );
            if (condition_buy) {
               messages[number] = "buy";
               call_order_creation(true, false, condition_name, symbol, period[i], number, i, bids, TimeframeToString(period[i]));
            } else if (condition_sell) {
               messages[number] = "sell";
               call_order_creation(false, true, condition_name, symbol, period[i], number, i, bids, TimeframeToString(period[i]));
            }
            break;
      }
   } 
   infobox = StringConcatenate(infobox, " - condition_name: ", condition_name);
   infobox = StringConcatenate(infobox, " - Bid: ", DoubleToStr(bids, digit));
   infobox = StringConcatenate(infobox, " - Ask: ", DoubleToStr(asks, digit));
   infobox = StringConcatenate(infobox, " - messages: ", messages[number]);
   //FileAppend(filename, "");
}

int call_order_creation(bool condition_buy, bool condition_sell, string condition_name, string symbol, int timeperiod, int number, int i, double bids, string str)
{
   string mes = "";
      if (condition_buy) {
         mes = "Buy";
         if (amount_type[number][i] != 1) {
            amount[number][i] = bids;
            amount_type[number][i] = 1;
            Alert("Buy "+ condition_name + ", " + condition[number][0] + ", "+condition[number][1], symbol, timeperiod);
         }
         reverse_bid(symbol, 1);
         createorder(symbol, timeperiod, 1, condition_name+" "+build + ", " + str);
      } else if (condition_sell) {
         mes = "Sell";
         if (amount_type[number][i] != -1) {
            amount[number][i] = bids;
            amount_type[number][i] = -1;
            Alert("Sell "+ condition_name + ", " + condition[number][0] + ", "+condition[number][1], symbol, timeperiod);
         }
         reverse_bid(symbol, -1);
         createorder(symbol, timeperiod, -1, condition_name+" "+build + ", " + str);
      } 
      infobox = StringConcatenate(infobox, "(", mes, ")");
   condition[number][0] = 0;
   condition[number][1] = 0;
      return (0);
}

