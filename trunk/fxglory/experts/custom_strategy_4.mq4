//+------------------------------------------------------------------+
//|                                            custom_strategy_1.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <custom_currency_fetch.mqh>
//bollinger band squeeze with 15 Minute
string filename;
double fix[30];
int fixtype[30];
int difference = 20;
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
   filename = symbol + "/file4_" + Year() + "_" + Month() + "_" + Day()  + ".txt";
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
      //infobox = StringConcatenate(infobox, ", Holiday so no trading");
      //return (0);
   }

   infobox = StringConcatenate(infobox, " - Time: ", timestr(TimeCurrent()), "(",TimeDayOfWeek(TimeCurrent()),")");
   if (MarketInfo(symbol, MODE_SPREAD) > 10) {
      //infobox = StringConcatenate(infobox, " - ", MarketInfo(symbol, MODE_SPREAD), ": Spread greater than 10");
      //return (0);
   }

   double squeeze = iCustom(symbol, Period(), "BollingersSqueezejv7", 0, 1);
   double squeeze_1 = iCustom(symbol, Period(), "BollingersSqueezejv7", 0, 2);
   double squeeze2 = iCustom(symbol, Period(), "BollingersSqueezejv7", 1, 1);
   double squeeze2_1 = iCustom(symbol, Period(), "BollingersSqueezejv7", 1, 2);
   double squeezecur_0 = iCustom(symbol, Period(), "BollingersSqueezejv7", 0, 0);
   double squeezecur_1 = iCustom(symbol, Period(), "BollingersSqueezejv7", 1, 0);
   if (!fix[number] || fix[number] == 0) {
      messages[number] = "";
      if (squeeze_1 == 0 && squeeze2_1 == 0) {
         if (squeeze > 0 && squeezecur_0 > squeeze && squeezecur_0 != 0) {
            fix[number] = bids;
            fixtype[number] = 1;
         } else if (squeeze2 < 0 && squeezecur_1 < squeeze2 && squeezecur_1 != 0) {
            fix[number] = bids;
            fixtype[number] = -1;
         }
      } else if(squeeze2_1 < 0 && squeeze_1 == 0 && squeeze > 0 && squeeze2 == 0 && squeezecur_0 > squeeze && squeezecur_0 != 0) {
         fix[number] = bids;
         fixtype[number] = 1;
      } else if(squeeze2_1 == 0 && squeeze_1 > 0 && squeeze == 0 && squeeze2 < 0 && squeezecur_1 < squeeze2 && squeezecur_1 != 0) {
         fix[number] = bids;
         fixtype[number] = -1;
      }
   }
   int cur_diff = 0;
   if (fixtype[number] == 1 || fixtype[number] == -1) {
     if (fixtype[number] == 1)
      cur_diff = (bids - fix[number]) / point;
     else if (fixtype[number] == -1) 
      cur_diff = (fix[number] - bids) / point;

      if (cur_diff > difference && fixtype[number] == 1) {
         reverse_bid(symbol, 1);
         messages[number] = "Buy";
         createorder(symbol, Period(), 1, "strategy 4");
         fix[number] = 0;
         fixtype[number] = 0;
      } else if (cur_diff > difference && fixtype[number] == -1) {
         reverse_bid(symbol, -1);
         messages[number] = "Sell";
         createorder(symbol, Period(), -1, "strategy 4");
         fix[number] = 0;
         fixtype[number] = 0;
      } 
   }
   infobox = StringConcatenate(infobox, " - sq: ", DoubleToStr(squeeze, digit));   
   infobox = StringConcatenate(infobox, " - sq_1: ", DoubleToStr(squeeze_1, digit));
   infobox = StringConcatenate(infobox, " - sq2: ", DoubleToStr(squeeze2, digit));
   infobox = StringConcatenate(infobox, " - sq2_1: ", DoubleToStr(squeeze2_1, digit));
   infobox = StringConcatenate(infobox, " - sq0_0: ", DoubleToStr(squeezecur_0, digit));
   infobox = StringConcatenate(infobox, " - sq0_1: ", DoubleToStr(squeezecur_1, digit));
   infobox = StringConcatenate(infobox, " - Bid: ", DoubleToStr(bids, digit));
   infobox = StringConcatenate(infobox, " - Ask: ", DoubleToStr(asks, digit));
   infobox = StringConcatenate(infobox, " - ft: ", fixtype[number]); 
   infobox = StringConcatenate(infobox, " - fix: ", DoubleToStr(fix[number], digit));
   infobox = StringConcatenate(infobox, " - diff: ", cur_diff);
   infobox = StringConcatenate(infobox, " - Message: ", messages[number]);
   /*if (fixtype[number] == 1)
      infobox = StringConcatenate(infobox, " - diff: ", ((bids - fix[number]) / point));
   else if (fixtype[number] == -1) 
      infobox = StringConcatenate(infobox, " - diff: ", ((fix[number] - bids) / point));*/
}