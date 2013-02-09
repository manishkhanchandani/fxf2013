//+------------------------------------------------------------------+
//|                                               102_dailyrange.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

extern int number_start = 1;
extern int current_number = 0;
extern double lots = 0.10;
double build = 1.1;
#include <common.mqh>
#include <orders.mqh>
bool confirm = true;
double previousprice;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   //custom_start(number_start, current_number);
   Print("Starting the Strategy");
   //previousprice = Open[current_number];
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
   custom_start(number_start, current_number);   
//----
   return(0);
  }
//+------------------------------------------------------------------+

int custom_start(int num, int cur_num)
{
   CheckForClose();
   string custom_message;
   double high, low, open, close, totalmove, twentyfivepercent;
   high = High[num];
   low = Low[num];
   open = Open[num];
   close = Close[num];
   //if (high - low < 20) {
     // confirm = false;
   //}
   double stop;
   stop = 500 * Point;
   totalmove = high - low;
   twentyfivepercent = totalmove / 4;
   double currentopen, currentbuy, currentsell, currentbuytp, currentbuysl, currentselltp, currentsellsl;
   currentopen = Open[cur_num];
   currentbuy = currentopen + twentyfivepercent;
   currentbuytp = currentbuy + twentyfivepercent;
   currentbuysl = currentbuy - stop;
   currentsell = currentopen - twentyfivepercent;
   currentselltp = currentsell - twentyfivepercent;
   currentsellsl = currentsell + stop;
   string status = "Wait, calculating.... ";
   string message = StringConcatenate("B: ", build, ", Period: ", TimeframeToString(Period()));
   
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
      status = "Buy Position Open";
      if (confirm == false) {
         //Alert(Symbol(), ", ", TimeframeToString(Period()),", ", status);
         SendAlert(status);
         confirm = true;
      }
   } else if (Bid < currentsell) {
      status = "Sell Position Open";
      if (confirm == false) {
         //Alert(Symbol(), ", ", TimeframeToString(Period()),", ", status);
         SendAlert(status);
         confirm = true;
      }
   }
   //strategies
   //bollinger band with price Bars
   int result = 0;
   result = bollingerbands(num);


   Comment("\n\nBest Used in Day Chart",
   "\nCurrent Number: ", cur_num,
   "\nPrevious Number: ", num,
   "\nCurrent Ask Price: ", DoubleToStr(Ask, Digits),
   "\nCurrent Bid Price: ", DoubleToStr(Bid, Digits),
   "\nCurrent Open Price: ", DoubleToStr(currentopen, Digits),
   "\nPrevious High Price: ", DoubleToStr(high, Digits),
   "\nPrevious Low Price: ", DoubleToStr(low, Digits),
   "\nPrevious Open Price: ", DoubleToStr(open, Digits),
   "\nPrevious Close Price: ", DoubleToStr(close, Digits),
   "\nPrevious Total Move: ", DoubleToStr(totalmove, Digits),
   "\nPrevious Twenty Five Percent: ", DoubleToStr(twentyfivepercent, Digits),
   "\n\nCurrent Buy Price Guess: ", DoubleToStr(currentbuy, Digits),
   "\nCurrent Buy TP Guess: ", DoubleToStr(currentbuytp, Digits),
   "\nCurrent Buy SL Guess: ", DoubleToStr(currentbuysl, Digits),
   "\nCurrent Sell Price Guess: ", DoubleToStr(currentsell, Digits),
   "\nCurrent Sell TP Guess: ", DoubleToStr(currentselltp, Digits),
   "\nCurrent Sell SL Guess: ", DoubleToStr(currentsellsl, Digits),
   "\nStatus: ", status,
   "\n\nBollinger Band With Price Action: ", result,
   "\n\n"
   

   );
   return (0);
}