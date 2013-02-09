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
   if (MarketInfo(symbol, MODE_SPREAD) > 100) {
      infobox = StringConcatenate(infobox, " - ", MarketInfo(symbol, MODE_SPREAD), ": Spread greater than 10");
      return (0);
   } else {
      infobox = StringConcatenate(infobox, " - Sp: ", MarketInfo(symbol, MODE_SPREAD));
   }

   string filename = symbol + "/filemulti2_" + Year() + "_" + Month() + "_" + Day()  + ".txt";
   //FileAppend(filename, "Time: "+timestr(TimeCurrent()));
   double tenkan_sen_1, tenkan_sen_2, kijun_sen_1, kijun_sen_2, spanA, spanB, chinkouspan, spanHigh, spanLow, spanHigh2, spanLow2;
   bool condition_buy, condition_sell;
   //int period[5] = {PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1}; //, PERIOD_H4, PERIOD_D1
   int period[5] = {PERIOD_H1, PERIOD_M30, PERIOD_M15, PERIOD_M5, PERIOD_M1};
   int limit;
   if (current_period) {
      limit = 1;
      period[0] = Period();
   } else { 
      period[0] = PERIOD_M30;
      limit = 1;      
   }
   string mes;
   int i;
   for (i=0; i < limit; i++) {
      mes = "";
      infobox = StringConcatenate(infobox, " - P: ", TimeframeToString(period[i])); 
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
      amount_chinkouspan[number][i] = 0;
      amount_span[number][i] = 0;
      condition_buy = (iClose(symbol, period[i], 1) > spanHigh && iOpen(symbol, period[i], 1) < spanHigh && spanHigh != spanHigh2);
      condition_sell = (iClose(symbol, period[i], 1) < spanLow && iOpen(symbol, period[i], 1) > spanLow && spanLow != spanLow2);
      if (condition_buy) {
         mes = "Buy";
         if (amount_type[number][i] != 1) {
            amount[number][i] = bids;
            amount_type[number][i] = 1;
            Print("Buy "+ amount_type[number][i]+ " "+amount[number][i], symbol, period[i]);
         }
         if (chinkouspan > iHigh(symbol, period[i], 27)) {
            amount_chinkouspan[number][i] = 1;
         }
         if (tenkan_sen_1 > spanA && tenkan_sen_1 > spanB) {
            amount_span[number][i] = 1;
         }
         createorder(symbol, period[i], 1, "Kumo Breakout "+build+": "+period[i]+","+amount_chinkouspan[number][i]+","+amount_span[number][i]);
      } else if (condition_sell) {
         mes = "Sell";
         if (amount_type[number][i] != -1) {
            amount[number][i] = bids;
            amount_type[number][i] = -1;
            Print("Sell "+ amount_type[number][i]+ " "+amount[number][i], symbol, period[i]);
         }
         if (chinkouspan < iLow(symbol, period[i], 27)) {
            amount_chinkouspan[number][i] = 1;
         }
         if (tenkan_sen_1 < spanA && tenkan_sen_1 < spanB) {
            amount_span[number][i] = 1;
         }
         createorder(symbol, period[i], -1, "Kumo Breakout "+build+": "+period[i]+","+amount_chinkouspan[number][i]+","+amount_span[number][i]);
      } 
      infobox = StringConcatenate(infobox, "(", mes, ")");
   } 
   for (i=0; i < 5; i++) {
      if (amount_type[number][i] == 1) {
         infobox = StringConcatenate(infobox, " P: ", TimeframeToString(period[i])
         , " (", ((bids - amount[number][i]) / point), ", ", amount_type[number][i]
         , ", ", amount_chinkouspan[number][i], ", ", amount_span[number][i], ")");
         //FileAppend(filename, "P: "+TimeframeToString(period[i])+ " ("+((bids - amount[number][i]) / point)+ ")");
      } else if (amount_type[number][i] == -1) {
         infobox = StringConcatenate(infobox, " P: ", TimeframeToString(period[i])
         , " (", ((amount[number][i] - bids) / point), ", ", amount_type[number][i]
         , ", ", amount_chinkouspan[number][i], ", ", amount_span[number][i], ")");
         //FileAppend(filename, "P: "+TimeframeToString(period[i])+ " ("+((amount[number][i] - bids) / point)+ ")");
      }
   }
   infobox = StringConcatenate(infobox, " - Bid: ", DoubleToStr(bids, digit));
   infobox = StringConcatenate(infobox, " - Ask: ", DoubleToStr(asks, digit));
   //FileAppend(filename, "");
}