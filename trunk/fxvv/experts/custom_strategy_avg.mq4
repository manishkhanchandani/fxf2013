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
   double macd, macd2, macd3, momentum, macd_cur;
   bool condition_buy, condition_sell;
   //int period[5] = {PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1}; //, PERIOD_H4, PERIOD_D1
   int period[7] = {PERIOD_D1, PERIOD_H4, PERIOD_H1, PERIOD_M30, PERIOD_M15, PERIOD_M5, PERIOD_M1};
   int limit;
   period[0] = PERIOD_M15;
   limit = 1;  
   string mes;
   int i;
   for (i=0; i < limit; i++) {
      mes = "";
      infobox = StringConcatenate(infobox, " - P: ", TimeframeToString(period[i])); 
      macd_cur = iMACD(symbol, period[i],12,26,9,PRICE_CLOSE,MODE_MAIN,0);
      macd = iMACD(symbol, period[i],12,26,9,PRICE_CLOSE,MODE_MAIN,1);
      macd2 = iMACD(symbol, period[i],12,26,9,PRICE_CLOSE,MODE_MAIN,2);
      macd3 = iMACD(symbol, period[i],12,26,9,PRICE_CLOSE,MODE_MAIN,3);
      momentum = iMomentum(symbol, period[i],14,PRICE_CLOSE,1);
      condition_buy = (macd > macd2 && (macd2 < macd3 || macd2 == macd3) && momentum < 100);
      condition_sell = (macd < macd2 && (macd2 > macd3 || macd2 == macd3) && momentum > 100);
      
      if (condition_buy) {
         mes = "Buy";
         if (amount_type[number][i] != 1) {
            amount[number][i] = bids;
            amount_type[number][i] = 1;
            Print("Buy "+ amount_type[number][i]+ " "+amount[number][i], symbol, period[i]);
         }
         reverse_bid(symbol, 1);
         createorder(symbol, period[i], 1, "MACD "+build);
      } else if (condition_sell) {
         mes = "Sell";
         if (amount_type[number][i] != -1) {
            amount[number][i] = bids;
            amount_type[number][i] = -1;
            Print("Sell "+ amount_type[number][i]+ " "+amount[number][i], symbol, period[i]);
         }
         reverse_bid(symbol, -1);
         createorder(symbol, period[i], -1, "MACD "+build);
      } 
      infobox = StringConcatenate(infobox, "(", mes, ")");
   } 
   infobox = StringConcatenate(infobox, " - Bid: ", DoubleToStr(bids, digit));
   infobox = StringConcatenate(infobox, " - Ask: ", DoubleToStr(asks, digit));
   //FileAppend(filename, "");
}

