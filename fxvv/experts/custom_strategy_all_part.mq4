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

int condition[30][2];
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
   //ichimoku
   double tenkan_sen_1, tenkan_sen_2, tenkan_sen_3, tenkan_sen_4, kijun_sen_1, kijun_sen_2, kijun_sen_3, kijun_sen_4, spanA, spanB, chinkouspan, spanHigh, spanLow, spanHigh2, spanLow2;
   bool condition_buy, condition_sell, condition_buy2, condition_sell2;
   double adx, dip, dim;
   for (i=0; i < limit; i++) {
      mes = "";
      infobox = StringConcatenate(infobox, " - P: ", TimeframeToString(period[i])); 
      condition_buy = false;
      condition_sell = false;
      condition_buy2 = false;
      condition_sell2 = false;
      condition_name = "Ichimoku";
      //adx = iADX(symbol, period[i],14,PRICE_CLOSE,MODE_MAIN,1);
      dip = iADX(symbol, period[i],14,PRICE_CLOSE,MODE_PLUSDI,1);
      dim = iADX(symbol, period[i],14,PRICE_CLOSE,MODE_MINUSDI,1);
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
      condition_buy = (iClose(symbol, period[i], 1) > spanHigh && iOpen(symbol, period[i], 1) < spanHigh && dip > dim);// && iOpen(symbol, period[i], 1) > spanLow
      condition_sell = (iClose(symbol, period[i], 1) < spanLow && iOpen(symbol, period[i], 1) > spanLow && dip < dim );// && iOpen(symbol, period[i], 1) < spanHigh
      condition_buy2 = (tenkan_sen_1 > kijun_sen_1 && tenkan_sen_2 < kijun_sen_2 && dip > dim);
      condition_sell2 = (tenkan_sen_1 < kijun_sen_1 && tenkan_sen_2 > kijun_sen_2 && dip < dim);
      if (condition_buy)
         condition[number][0] = 1;
      else if (condition_sell)
         condition[number][0] = -1;
      if (condition_buy2)
         condition[number][1] = 1;
      else if (condition_sell2)
         condition[number][1] = -1;
      if (condition[number][0] == 1 && condition[number][1] == 1)
         call_order_creation(true, false, condition_name, symbol, period[i], number, i, bids);
      else if (condition[number][0] == -1 && condition[number][1] == -1)
         call_order_creation(false, true, condition_name, symbol, period[i], number, i, bids);
      /*
      if (condition_buy) {
         mes = "Buy";
         if (amount_type[number][i] != 1) {
            amount[number][i] = bids;
            amount_type[number][i] = 1;
            Alert("Buy "+ condition_name + ", " + amount_type[number][i] + " "+amount[number][i], symbol, period[i]);
         }
         reverse_bid(symbol, 1);
         createorder(symbol, period[i], 1, condition_name+" "+build);
      } else if (condition_sell) {
         mes = "Sell";
         if (amount_type[number][i] != -1) {
            amount[number][i] = bids;
            amount_type[number][i] = -1;
            Alert("Sell "+ condition_name + ", " + amount_type[number][i]+ " "+amount[number][i], symbol, period[i]);
         }
         reverse_bid(symbol, -1);
         createorder(symbol, period[i], -1, condition_name+" "+build);
      } 
      infobox = StringConcatenate(infobox, "(", mes, ")");
      */
   } 
   infobox = StringConcatenate(infobox, " - c[0]: ", condition[number][0]);
   infobox = StringConcatenate(infobox, " - c[1]: ", condition[number][1]);
   infobox = StringConcatenate(infobox, " - cb: ", condition_buy);
   infobox = StringConcatenate(infobox, " - cs: ", condition_sell);
   infobox = StringConcatenate(infobox, " - cb2: ", condition_buy2);
   infobox = StringConcatenate(infobox, " - cs2: ", condition_sell2);
   infobox = StringConcatenate(infobox, " - Bid: ", DoubleToStr(bids, digit));
   infobox = StringConcatenate(infobox, " - Ask: ", DoubleToStr(asks, digit));
   //FileAppend(filename, "");
}

int call_order_creation(bool condition_buy, bool condition_sell, string condition_name, string symbol, int timeperiod, int number, int i, double bids)
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
         createorder(symbol, timeperiod, 1, condition_name+" "+build + ", " + condition[number][0] + ", "+condition[number][1]);
      } else if (condition_sell) {
         mes = "Sell";
         if (amount_type[number][i] != -1) {
            amount[number][i] = bids;
            amount_type[number][i] = -1;
            Alert("Sell "+ condition_name + ", " + condition[number][0] + ", "+condition[number][1], symbol, timeperiod);
         }
         reverse_bid(symbol, -1);
         createorder(symbol, timeperiod, -1, condition_name+" "+build + ", " + condition[number][0] + ", "+condition[number][1]);
      } 
      infobox = StringConcatenate(infobox, "(", mes, ")");
   condition[number][0] = 0;
   condition[number][1] = 0;
      return (0);
}

