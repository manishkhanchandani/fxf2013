//+------------------------------------------------------------------+
//|                                            custom_strategy_multi.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"
//multi strategy
#include <custom_currency_fetch.mqh>

int condition_check[30][20];
string filename;
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


   infobox = StringConcatenate(infobox, " - Time: ", timestr(TimeCurrent()), "(",TimeDayOfWeek(TimeCurrent()),")");
   int i = 0;
   bool condition_buy, condition_sell, condition_buy2, condition_sell2;
   double tenkan_sen_1, tenkan_sen_2, tenkan_sen_3, tenkan_sen_4, kijun_sen_1, kijun_sen_2, kijun_sen_3, 
   kijun_sen_4, spanA, spanB, chinkouspan, spanHigh, spanLow, spanHigh2, spanLow2, spanAb, spanBb, spanAc, spanBc, spanAd, spanBd;
   
   double val, val2, val3, val4, val5, val6, val7, val8, val9, val10, val11;
   double bbupper_1, bblower_1, bbupper_2, bblower_2, bbupper, bblower;
   int intval1, intval2, j;

   filename = "custmix_1_" + Year() + "_" + Month() + "_" + Day()  + ".txt";
   //FileAppend(filename, "Time: "+timestr(TimeCurrent()));
   string condition_name;
   int period[9] = {PERIOD_D1, PERIOD_H4, PERIOD_H1, PERIOD_M30, PERIOD_M15, PERIOD_M5, PERIOD_M1, PERIOD_MN1, PERIOD_W1};
   period[0] = Period();
   
   
            spanA = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, -25);
            spanB = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, -25);
            spanAb = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, -24);
            spanBb = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, -24);
            if (spanAb < spanBb
               && spanA > spanB) {
               if (reverse_bid_if_profit) reverse_bid(symbol, 1);
               else if (reverse_bid_force) reverse_bid_force(symbol, 1);
               } else if (spanAb > spanBb
               && spanA < spanB) {
               if (reverse_bid_if_profit) reverse_bid(symbol, -1);
               else if (reverse_bid_force) reverse_bid_force(symbol, -1);
               }
   //MACD Condition
   val2 = iCustom(symbol, period[i], "MACD_Complete",1,1);
   val3 = iCustom(symbol, period[i], "MACD_Complete",2,1);
   if (val2 > val3) {
      condition_check[number][0] = 1;
   } else if (val2 < val3) {
      condition_check[number][0] = -1;
   }
   infobox = StringConcatenate(infobox, ", MACD: ", condition_check[number][0]);
   //RSI Condition
   val4 = iRSI(symbol, period[i], 14,PRICE_CLOSE,1);
   if (val4 > 50) {
      condition_check[number][1] = 1;
   } else if (val4 < 50) {
      condition_check[number][1] = -1;
   }
   infobox = StringConcatenate(infobox, ", RSI: ", condition_check[number][1]);
   
      tenkan_sen_1=iIchimoku(symbol, period[i], 9, 26, 52, MODE_TENKANSEN, 1);
      kijun_sen_1=iIchimoku(symbol, period[i], 9, 26, 52, MODE_KIJUNSEN, 1);
      chinkouspan = iIchimoku(symbol, period[i], 9, 26, 52, MODE_CHINKOUSPAN, 27);
      spanA = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, 1);
      spanB = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, 1);
      if (spanA > spanB) {
         spanHigh = spanA;
         spanLow = spanB;
      } else {
         spanHigh = spanB;
         spanLow = spanA;
      }
      if (tenkan_sen_1 > kijun_sen_1) {
         condition_check[number][2] = 1;
      } else if (tenkan_sen_1 < kijun_sen_1) {
         condition_check[number][2] = -1;
      }
      infobox = StringConcatenate(infobox, ", Tenkensen: ", condition_check[number][2]);
      if (chinkouspan > iHigh(symbol, period[i], 27)) {
         condition_check[number][3] = 1;
      } else if (chinkouspan < iLow(symbol, period[i], 27)) {
         condition_check[number][3] = -1;
      }
      infobox = StringConcatenate(infobox, ", chinkouspan: ", condition_check[number][3]);
      if (iClose(symbol, period[i], 1) > spanHigh) {
         condition_check[number][4] = 1;
      } else if (iClose(symbol, period[i], 1) < spanLow) {
         condition_check[number][4] = -1;
      }
      infobox = StringConcatenate(infobox, ", Kumo: ", condition_check[number][4]);
      
   //heiken
   val2 = iCustom(symbol, period[i], "Heiken_Ashi_Smoothed",2,1);
   val3 = iCustom(symbol, period[i], "Heiken_Ashi_Smoothed",3,1);
   val4 = iCustom(symbol, period[i], "Heiken_Ashi_Smoothed",2,2);
   val5 = iCustom(symbol, period[i], "Heiken_Ashi_Smoothed",3,2);
   if (val2 < val3 && val4 > val5) {
      condition_check[number][5] = 1;
   } else if (val2 > val3 && val4 < val5) {
      condition_check[number][5] = -1;
   } 
   infobox = StringConcatenate(infobox, ", Heiken: ", condition_check[number][5]);
   condition_buy = (
      condition_check[number][0] == 1 
      && condition_check[number][1] == 1 
      && condition_check[number][2] == 1 
      && condition_check[number][3] == 1
      && condition_check[number][4] == 1
      && condition_check[number][5] == 1
      );
   condition_sell = (
      condition_check[number][0] == -1 
      && condition_check[number][1] == -1 
      && condition_check[number][2] == -1 
      && condition_check[number][3] == -1
      && condition_check[number][4] == -1
      && condition_check[number][5] == -1
      );
   if (condition_buy) {
      call_order_creation(true, false, condition_name, symbol, period[i], number, i, bids, TimeframeToString(period[i]));
   } else if (condition_sell) {
      call_order_creation(false, true, condition_name, symbol, period[i], number, i, bids, TimeframeToString(period[i]));
   }
   infobox = StringConcatenate(infobox, " - Bid: ", DoubleToStr(bids, digit));
   infobox = StringConcatenate(infobox, " - Ask: ", DoubleToStr(asks, digit));
   if (markethours) {
      if (hour == 0 || hour == 1 || hour == 7 || hour == 8 || hour == 13 || hour == 14) {
   
      } else {
         infobox = StringConcatenate(infobox, ": Working hours are 0, 1, 7, 8, 13, 14");
      }
   }
}
/*
int call_order_creation(bool condition_buy, bool condition_sell, string condition_name, string symbol, int timeperiod, int number, int i, double bids, string str, double lotsize)
{
   if (markethours) {
      if (hour == 0 || hour == 1 || hour == 7 || hour == 8 || hour == 13 || hour == 14) {
   
      } else {
         infobox = StringConcatenate(infobox, ": Working hours are 0, 1, 7, 8, 13, 14");
         return (0);
      }
   }
      if (condition_buy) {
         createorder_lots(symbol, timeperiod, 1, condition_name+" "+build + ", " + str, lotsize, filename);
      } else if (condition_sell) {
         createorder_lots(symbol, timeperiod, -1, condition_name+" "+build + ", " + str, lotsize, filename);
      } 
      return (0);
}
*/

int call_order_creation(bool condition_buy, bool condition_sell, string condition_name, string symbol, int timeperiod, int number, int i, double bids, string str)
{
   string mes = "";
   if (condition_buy) {
      mes = "Buy";
   } else if (condition_sell) {
      mes = "Sell";
   }
   infobox = StringConcatenate(infobox, "(", mes, ")");
   if(DayOfWeek()==0 || DayOfWeek()==6) {
      infobox = StringConcatenate(infobox, "Holiday so no trading");
      return (0);
   }
   if (MarketInfo(symbol, MODE_SPREAD) > 80) {
      infobox = StringConcatenate(infobox, " - ", MarketInfo(symbol, MODE_SPREAD), ": Spread greater than 80");
      return (0);
   } else {
      infobox = StringConcatenate(infobox, " - Sp: ", MarketInfo(symbol, MODE_SPREAD));
   }
   if (markethours) {
      if (hour == 0 || hour == 1 || hour == 7 || hour == 8 || hour == 13 || hour == 14) {
   
      } else {
         //infobox = StringConcatenate(infobox, ": Working hours are 0, 1, 7, 8, 13, 14");
         return (0);
      }
   }
   
      if (condition_buy) {
         createorder(symbol, timeperiod, 1, condition_name+" "+build + ", " + str);
      } else if (condition_sell) {
         createorder(symbol, timeperiod, -1, condition_name+" "+build + ", " + str);
      } 
      return (0);
}