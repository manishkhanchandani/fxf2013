//+------------------------------------------------------------------+
//|                                                megamillionea.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

int number = 0;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
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

int custom_start()
{
   double high = High[number+1];
   double low = Low[number+1];
   double diff = high - low;
   double diffint = (diff/Point)/10;
   double twentyfivepercent = diff / 4;
   double tenpercent = diff / 10;
   double stop = 1 * Point;
   double currentopen, currentbuy, currentsell, currentbuytp, currentbuysl, currentselltp, currentsellsl;
   currentopen = Open[number];
   currentbuy = currentopen + tenpercent;
   currentbuytp = currentbuy + twentyfivepercent;
   currentbuysl = currentbuy - stop;
   currentsell = currentopen - tenpercent;
   currentselltp = currentsell - twentyfivepercent;
   currentsellsl = currentsell + stop;
   ObjectDelete("buyline");
   ObjectDelete("sellline");

   ObjectCreate("buyline", OBJ_HLINE, 0, Time[number], currentbuy);
   ObjectCreate("sellline", OBJ_HLINE, 0, Time[number], currentsell);
   Comment("\n\n",
   "High: ", DoubleToStr(high, Digits),
   "\n",
   "Low: ", DoubleToStr(low, Digits),
   "\n",
   "Diff: ", DoubleToStr(diff, Digits),
   "\n",
   "Diffint: ", DoubleToStr(diffint, Digits),
   "\n",
   "twentyfivepercent: ", DoubleToStr(twentyfivepercent, Digits),
   "\n",
   "tenpercent: ", DoubleToStr(tenpercent, Digits),
   "\n",
   "currentopen: ", DoubleToStr(currentopen, Digits),
   "\n",
   "currentbuy: ", DoubleToStr(currentbuy, Digits),
   "\n",
   "currentbuytp: ", DoubleToStr(currentbuytp, Digits),
   "\n",
   "currentsell: ", DoubleToStr(currentsell, Digits),
   "\n",
   "currentselltp: ", DoubleToStr(currentselltp, Digits)
   );
}