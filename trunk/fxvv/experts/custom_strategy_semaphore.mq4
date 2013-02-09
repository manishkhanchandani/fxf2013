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

int condition[30][10][2];
int ordertime[30][10];
extern bool only_buy = true;
extern bool only_sell = true;
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
   Lots = LotsOptimized();
   string filename = symbol + "/filemulti2_" + Year() + "_" + Month() + "_" + Day()  + ".txt";
   //FileAppend(filename, "Time: "+timestr(TimeCurrent()));
   string condition_name;
   //int period[5] = {PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1}; //, PERIOD_H4, PERIOD_D1
   //int period[7] = {PERIOD_D1, PERIOD_H4, PERIOD_H1, PERIOD_M30, PERIOD_M15, PERIOD_M5, PERIOD_M1};
   int limit;
   int period[7] = {PERIOD_D1, PERIOD_H4, PERIOD_H1, PERIOD_M30, PERIOD_M15, PERIOD_M5, PERIOD_M1};
   period[0] = Period();
   limit = 1;  
   string mes;
   int i;
   //semaphore
   
      double ZZ_1, ZZ_2;
   double Period1            = 28;
   double Period2            = 56;
   double Period3            = 112;
   string Dev_Step_1         ="3,9";
   string Dev_Step_2         ="24,15";
   string Dev_Step_3         ="63,36";
   int Symbol_1_Kod          =140;
   int Symbol_2_Kod          =141;
   int Symbol_3_Kod          =142;
   bool condition_buy, condition_sell;
   for (i=0; i < limit; i++) {
      mes = "";
      infobox = StringConcatenate(infobox, " - P: ", TimeframeToString(period[i])); 
      condition_buy = false;
      condition_sell = false;
      condition_name = "semaphore";
      ZZ_1=iCustom(symbol,period[i],"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,5,3);
      ZZ_2=iCustom(symbol,period[i],"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,4,3);
      condition_sell = ZZ_1 > ZZ_2 && only_sell;
      condition_buy = ZZ_1 < ZZ_2 && only_buy;
      
      if (ordertime[number][i] != iTime(symbol, period[i], 0)) {
         if (condition_buy)
            call_order_creation(true, false, condition_name, symbol, period[i], number, i, bids);
         else if (condition_sell)
            call_order_creation(false, true, condition_name, symbol, period[i], number, i, bids);
      }
      infobox = StringConcatenate(infobox, " - (", DoubleToStr(ZZ_1, digit), ", ", DoubleToStr(ZZ_2, digit),", ", condition_buy, ",", condition_sell, ")");
   } 
   infobox = StringConcatenate(infobox, " - Bid: ", DoubleToStr(bids, digit));
   infobox = StringConcatenate(infobox, " - Ask: ", DoubleToStr(asks, digit));
   //FileAppend(filename, "");
}

int call_order_creation(bool condition_buy, bool condition_sell, string condition_name, string symbol, int timeperiod, int number, int i, double bids)
{
   ordertime[number][i] = iTime(symbol, timeperiod, 0);
   string mes = "";
      if (condition_buy) {
         mes = "Buy";
         if (amount_type[number][i] != 1) {
            amount[number][i] = bids;
            amount_type[number][i] = 1;
            Alert("Buy ", condition_name, symbol, timeperiod);
         }
         reverse_bid_force(symbol, 1);
         createorder(symbol, timeperiod, 1, condition_name+" "+build + ", P("+ TimeframeToString(timeperiod)+ ")");
      } else if (condition_sell) {
         mes = "Sell";
         if (amount_type[number][i] != -1) {
            amount[number][i] = bids;
            amount_type[number][i] = -1;
            Alert("Sell ", condition_name, symbol, timeperiod);
         }
         reverse_bid_force(symbol, -1);
         createorder(symbol, timeperiod, -1, condition_name+" "+build + ", P("+ TimeframeToString(timeperiod)+ ")");
      } 
      infobox = StringConcatenate(infobox, "(", mes, ")");
      return (0);
}

