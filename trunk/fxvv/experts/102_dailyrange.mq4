//+------------------------------------------------------------------+
//|                                               102_dailyrange.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <stdlib.mqh>
#include <WinUser32.mqh>
extern int number_start = 1;
extern int current_number = 0;
extern double lots = 0.10;
double build = 1.2;
bool confirm = true;
double previousprice;
string infobox, currentbox;
double max_profit;
double half_profit;
double running_profit = 0;
double profit_1 = 0;
double profit_2 = 0;
#include <common.mqh>
#include <orders.mqh>
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   infobox = "Starting the Strategy....";
   Comment(infobox);
   //previousprice = Open[current_number];
         running_profit = 0;
         profit_1 = 0;
         profit_2 = 0;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
         running_profit = 0;
         profit_1 = 0;
         profit_2 = 0;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   custom_start(number_start, current_number);   
//----
   return(0);
  }
//+------------------------------------------------------------------+

int custom_start(int num, int cur_num)
{
   infobox = "";
   double spread = MarketInfo(Symbol(), MODE_SPREAD);
   string custom_message;
   double high, low, open, close, totalmove, twentyfivepercent;
   //double tenpips;
   //tenpips = 100 * Point;
   high = High[num];
   low = Low[num];
   open = Open[num];
   close = Close[num];
   //if (high - low < 20) {
     // confirm = false;
   //}
   double stop;
   stop = 1000 * Point;
   totalmove = high - low;
   //twentyfivepercent = totalmove / 4;
   twentyfivepercent = twentyfivepercent();
   double currentopen, currentbuy, currentsell, currentbuytp, currentbuysl, currentselltp, currentsellsl;
   currentopen = Open[cur_num];
   currentbuy = currentopen + twentyfivepercent;
   currentsell = currentopen - twentyfivepercent;
   //currentbuytp = currentbuy + twentyfivepercent;
   currentbuytp = currentopen + (200 * Point);
   currentbuysl = currentbuy - stop;
   //currentbuysl = currentsell;
   //currentselltp = currentsell - twentyfivepercent;
   currentselltp = currentopen - (200 * Point);
   currentsellsl = currentsell + stop;
   //currentsellsl = currentbuy;
   string message = StringConcatenate("B: ", build, ", Period: ", TimeframeToString(Period()));
   //closing and variables set
   lots = lotsize(lots);
   max_profit = (twentyfivepercent / Point) * lots;
   half_profit = max_profit / 2;
   
   infobox = StringConcatenate("\n",
   "\nCurrent Ask Price: ", DoubleToStr(Ask, Digits),
   "\nCurrent Bid Price: ", DoubleToStr(Bid, Digits),
   "\nCurrent Open Price: ", DoubleToStr(currentopen, Digits),
   "\nPrevious High Price: ", DoubleToStr(high, Digits),
   "\nPrevious Low Price: ", DoubleToStr(low, Digits),
   "\nPrevious Total Move: ", DoubleToStr(totalmove, Digits),
   "\nPrevious Twenty Five Percent: ", DoubleToStr(twentyfivepercent, Digits),
   "\n\nCurrent Buy Price Guess: ", DoubleToStr(currentbuy, Digits),
   "\nCurrent Buy TP Guess: ", DoubleToStr(currentbuytp, Digits),
   "\nCurrent Buy SL Guess: ", DoubleToStr(currentbuysl, Digits),
   "\nCurrent Sell Price Guess: ", DoubleToStr(currentsell, Digits),
   "\nCurrent Sell TP Guess: ", DoubleToStr(currentselltp, Digits),
   "\nCurrent Sell SL Guess: ", DoubleToStr(currentsellsl, Digits),
   "\nLots: ", lots,
   "\nmax_profit: ", DoubleToStr(max_profit, Digits),
   "\nhalf_profit: ", DoubleToStr(half_profit, Digits),
   "\nProfit Level 1: ", DoubleToStr(profit_1, Digits),
   "\nProfit Level 2: ", DoubleToStr(profit_2, Digits),
   "\nRunning Profit: ", DoubleToStr(running_profit, Digits),
   "\nPips to Consider: ", (twentyfivepercent / Point),
   "\nSpread: ", spread
   );
   currentbox = "\nStatus: Wait, calculating.... ";
   Comment(infobox, currentbox);

   CheckForClose();

   if (Open[cur_num] != previousprice) {
      deletepending(); // delete all pending orders
      //create order
      check(currentbuy, currentbuytp, currentbuysl, currentsell, currentselltp, currentsellsl, lots, message);
      confirm = false;
      //send alert with current settings:
      custom_message = StringConcatenate(Symbol(), ", timeframe: ", TimeframeToString(Period()), ", lotsize: ", lots, ", buy: ", currentbuy,
   ", buysl: ", currentbuysl, ", buytp: ", currentbuytp, ", sell: ", currentsell,
   ", sellsl: ", currentsellsl, ", selltp: ", currentselltp);
      //SendAlert(custom_message);
   }
   previousprice = Open[cur_num];
   //create pending orders
   creatependingorders(currentbuy, currentbuytp, currentbuysl, currentsell, currentselltp, currentsellsl, lots, message);

   if (Ask > currentbuy) {
      currentbox = "\nBuy Position Open";
      if (confirm == false) {
         Alert(Symbol(), ", ", TimeframeToString(Period()),", Buy Position Open");
         confirm = true;
      }
   } else if (Bid < currentsell) {
      currentbox = "\nSell Position Open";
      if (confirm == false) {
         Alert(Symbol(), ", ", TimeframeToString(Period()),", Sell Position Open");
         confirm = true;
      }
   }
   //strategies
   //bollinger band with price Bars
   //int result = 0;
   //result = bollingerbands(num);


   Comment(infobox, currentbox);
   return (0);
}