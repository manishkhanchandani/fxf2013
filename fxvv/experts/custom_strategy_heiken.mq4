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
   filename = "custheiken_1_" + Year() + "_" + Month() + "_" + Day()  + ".txt";
   //FileAppend(filename, "Time: "+timestr(TimeCurrent()));
   string condition_name;
   int period[9] = {PERIOD_H4, PERIOD_H1, PERIOD_M30, PERIOD_M15, PERIOD_M5, PERIOD_M1};
   int limit = 6;
   int periods, period2;
   int trend;
   int i, j;
   double val, val2, val3, val4, val5, val6, val7, val8, val9;
   for (i=0; i < limit; i++) {
      periods = period[i];
      switch(periods)
      {
         case PERIOD_M1:  period2 = PERIOD_M5; break;
         case PERIOD_M5:  period2 = PERIOD_M15; break;
         case PERIOD_M15: period2 = PERIOD_M30; break;
         case PERIOD_M30: period2 = PERIOD_H1; break;
         case PERIOD_H1:  period2 = PERIOD_H4; break;
         case PERIOD_H4:  period2 = PERIOD_D1; break;
         case PERIOD_D1:  continue; break;
         case PERIOD_W1:  continue; break;
         case PERIOD_MN1: continue; break;
      }
      infobox = StringConcatenate(infobox, " - P: ", TimeframeToString(periods), ", P2: ", TimeframeToString(period2));
      val2 = iCustom(symbol, periods, "Heiken_Ashi_Smoothed",2,1);
      val3 = iCustom(symbol, periods, "Heiken_Ashi_Smoothed",3,1);
      val4 = iCustom(symbol, periods, "Heiken_Ashi_Smoothed",2,2);
      val5 = iCustom(symbol, periods, "Heiken_Ashi_Smoothed",3,2);
      val6 = iCustom(symbol, period2, "Heiken_Ashi_Smoothed",2,1);
      val7 = iCustom(symbol, period2, "Heiken_Ashi_Smoothed",3,1);
      val8 = iCustom(symbol, period2, "Heiken_Ashi_Smoothed",2,2);
      val9 = iCustom(symbol, period2, "Heiken_Ashi_Smoothed",3,2);
      trend = 0;
      if (val6 < val7) {
         trend = 1;
         infobox = StringConcatenate(infobox, "- T: ", trend);
      } else if (val6 > val7) {
         trend = -1;
         infobox = StringConcatenate(infobox, "- T: ", trend);
      }
      if (val2 < val3 && val4 > val5 && trend == 1) {
         infobox = StringConcatenate(infobox, " - C:Buy");
         importantbox = StringConcatenate(importantbox, "\n", symbol, ", P: ", TimeframeToString(periods), " - Enter: Buy");
         //call_order_creation(true, false, condition_name, symbol, period[i], number, i, bids, TimeframeToString(period[i]));
      } else if (val2 > val3 && val4 < val5 && trend == -1) {
         infobox = StringConcatenate(infobox, " - C:Sell");
         importantbox = StringConcatenate(importantbox, "\n", symbol, ", P: ", TimeframeToString(periods), " - Enter: Sell");
         //call_order_creation(false, true, condition_name, symbol, period[i], number, i, bids, TimeframeToString(period[i]));
      } 
      if (val2 > val3 && val4 < val5) {
         infobox = StringConcatenate(infobox, " - Exit Buy");
         importantbox_exit = StringConcatenate(importantbox_exit, "\n", symbol, ", P: ", TimeframeToString(periods), " - Exit Buy");
         //reverse_bid(-1);
      } else if (val2 < val3 && val4 > val5) {
         infobox = StringConcatenate(infobox, " - Exit Buy");
         importantbox_exit = StringConcatenate(importantbox_exit, "\n", symbol, ", P: ", TimeframeToString(periods), " - Exit Buy");
         //reverse_bid(1);
      }
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