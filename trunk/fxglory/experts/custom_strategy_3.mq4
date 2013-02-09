//+------------------------------------------------------------------+
//|                                            custom_strategy_1.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"
//speed strategy
#include <custom_currency_fetch.mqh>

double initial[30];
double final[30];
int pd[30];
int pd2[30];
int diff = 50;
int order_diff_time = 20;
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
   infobox = StringConcatenate(infobox, " - Diff: ", order_diff_time);
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
   //if (MarketInfo(symbol, MODE_SPREAD) > 10) {
      //infobox = StringConcatenate(infobox, " - ", MarketInfo(symbol, MODE_SPREAD), ": Spread greater than 10");
      //return (0);
   //}

   string filename = symbol + "/file3_" + Year() + "_" + Month() + "_" + Day()  + ".txt";
   double diffamountbuy = 0;
   double diffamountsell = 0;
   double ma;
   if (!initial[number]) {
      initial[number] = bids;
      final[number] = bids;
      pd[number] = TimeCurrent(); 
      FileAppend(filename, "INITIAL DATA: Bid: " + DoubleToStr(initial[number], digit));
      FileAppend(filename, "");
   }

   if (bids > initial[number]) {
      diffamountbuy = (bids - initial[number]) / point;
   } else if (bids < initial[number]) {
      diffamountsell = (initial[number] - bids) / point;
   }
   
   if (diffamountbuy > diff) {
      final[number] = initial[number];
      pd2[number] = TimeCurrent() - pd[number];
      messages[number] = "Buy";
      initial[number] = bids;
      pd[number] = TimeCurrent(); 
      SendAlert("Buy "+ pd2[number], symbol, 0);
      FileAppend(filename, "Initial Bid: " + DoubleToStr(final[number], digit));
      FileAppend(filename, "New Bid: " + DoubleToStr(initial[number], digit));
      FileAppend(filename, "Message: " + messages[number]);
      FileAppend(filename, "Required Difference: " + diff);
      FileAppend(filename, "Actual Difference: " + diffamountbuy);
      FileAppend(filename, "Time Required: " + pd2[number]);
      if (pd2[number] < order_diff_time) {
         ma =iMA(symbol,PERIOD_M15,50,0,MODE_EMA,PRICE_CLOSE,0);
         if (bids > ma) {
            reverse_bid(symbol, 1);
            createorder(symbol, 0, 1, "strategy 3.2: "+pd2[number]);
            FileAppend(filename, "Order Created at " + TimeToStr(TimeCurrent()));
         } else {
            FileAppend(filename, "Could not create order due to lack of ma at " + TimeToStr(TimeCurrent()));
         }
      }
      FileAppend(filename, "");
   } else if (diffamountsell > diff) {
      final[number] = initial[number];
      pd2[number] = TimeCurrent() - pd[number];
      messages[number] = "Sell";
      initial[number] = bids;
      pd[number] = TimeCurrent(); 
      SendAlert("Sell " + pd2[number], symbol, 0);
      FileAppend(filename, "Initial Bid: " + DoubleToStr(final[number], digit));
      FileAppend(filename, "New Bid: " + DoubleToStr(initial[number], digit));
      FileAppend(filename, "Message: " + messages[number]);
      FileAppend(filename, "Required Difference: " + diff);
      FileAppend(filename, "Actual Difference: " + diffamountsell);
      FileAppend(filename, "Time Required: " + pd2[number]);
      if (pd2[number] < order_diff_time) {
         ma =iMA(symbol,PERIOD_M15,50,0,MODE_EMA,PRICE_CLOSE,0);
         if (bids < ma) {
            reverse_bid(symbol, -1);
            createorder(symbol, 0, -1, "strategy 3.2: "+pd2[number]);
            FileAppend(filename, "Order Created at " + TimeToStr(TimeCurrent()));
         } else {
            FileAppend(filename, "Could not create order due to lack of ma at " + TimeToStr(TimeCurrent()));
         }
      }
      FileAppend(filename, "");
   } 

   infobox = StringConcatenate(infobox, " - final[number]: ", DoubleToStr(final[number], digit));   
   infobox = StringConcatenate(infobox, " - pd2[number]: ", pd2[number]);  
   infobox = StringConcatenate(infobox, " - diffamountbuy: ", diffamountbuy); 
   infobox = StringConcatenate(infobox, " - diffamountsell: ", diffamountsell);
   infobox = StringConcatenate(infobox, " - Message: ", messages[number]);
   infobox = StringConcatenate(infobox, " - Bid: ", DoubleToStr(bids, digit));
   infobox = StringConcatenate(infobox, " - Ask: ", DoubleToStr(asks, digit));
   infobox = StringConcatenate(infobox, " - initial[number]: ", DoubleToStr(initial[number], digit)); 
   infobox = StringConcatenate(infobox, " - initial[number]: ", DoubleToStr(initial[number], digit)); 
   infobox = StringConcatenate(infobox, " - start time: ", timestr(pd[number]));  
}