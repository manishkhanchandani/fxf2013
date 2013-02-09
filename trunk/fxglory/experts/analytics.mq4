//+------------------------------------------------------------------+
//|                                                    analytics.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"


// pivot points variables
double p, r3, r2, r1, s1, s2, s3;
int strategy_1_pos;
int strategy_1_start;
int strategy_1_day;
int signal;
string infobox;
double curtime;
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
   infobox = "";
   custom_start();
   Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+


int custom_start()
  {
//----
   //calculations
   pivot_points(Symbol(), 1);
   analysis(Symbol());
   //strategies
   strategy(Symbol());
//----
   return(0);
  }

string TimeframeToString(int P)
{
   switch(P)
   {
      case PERIOD_M1:  return("M1");
      case PERIOD_M5:  return("M5");
      case PERIOD_M15: return("M15");
      case PERIOD_M30: return("M30");
      case PERIOD_H1:  return("H1");
      case PERIOD_H4:  return("H4");
      case PERIOD_D1:  return("D1");
      case PERIOD_W1:  return("W1");
      case PERIOD_MN1: return("MN1");
   }
}
string TrendtoString(int P)
{
   switch(P)
   {
      case 1:  return("Buy");
      case -1:  return("Sell");
      case 0: return("Consolidated");
   }
}
int analysis(string symbol)
{
   if (curtime != iTime(symbol, PERIOD_M5, 0)) {
      signal = 0;
   }
   int trend = 0;
   double macd4 = iMACD(NULL,PERIOD_H4,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
   double macd4_1 = iMACD(NULL,PERIOD_H4,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   double macd1 = iMACD(NULL,PERIOD_H1,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
   double macd1_1 = iMACD(NULL,PERIOD_H1,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   double macd30 = iMACD(NULL,PERIOD_M30,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
   double macd30_1 = iMACD(NULL,PERIOD_M30,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   double macd15 = iMACD(NULL,PERIOD_M15,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
   double macd15_1 = iMACD(NULL,PERIOD_M15,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   double macd5 = iMACD(NULL,PERIOD_M5,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   double macd5_1 = iMACD(NULL,PERIOD_M5,12,26,9,PRICE_CLOSE,MODE_MAIN,2);
   double macd5_2 = iMACD(NULL,PERIOD_M5,12,26,9,PRICE_CLOSE,MODE_MAIN,3);
   if (macd4 > macd4_1 && macd1 > macd1_1 && macd30 > macd30_1 && macd15 > macd15_1) {
      trend = 1;
      if (macd5 > macd5_1 && macd5_1 < macd5_2 && curtime != iTime(symbol, PERIOD_M5, 0)) {
         signal = 1;
         curtime = iTime(symbol, PERIOD_M5, 0);
         Alert(symbol, " Buy Signal, ", TimeToStr(TimeCurrent()));
      }
   } else if (macd4 < macd4_1 && macd1 < macd1_1 && macd30 < macd30_1 && macd15 < macd15_1) {
      trend = -1;
      if (macd5 < macd5_1 && macd5_1 > macd5_2 && curtime != iTime(symbol, PERIOD_M5, 0)) {
         signal = -1;
         curtime = iTime(symbol, PERIOD_M5, 0);
         Alert(symbol, " Sell Signal, ", TimeToStr(TimeCurrent()));
      }
   }   
   infobox = StringConcatenate(infobox, 
      "\nMACD 4 hour: ", DoubleToStr(macd4, Digits),
      ", MACD 4_1 hour: ", DoubleToStr(macd4_1, Digits),
      "\nMACD 1 hour: ", DoubleToStr(macd1, Digits),
      ", MACD 1_1 hour: ", DoubleToStr(macd1_1, Digits),
      "\nMACD 30 Minute: ", DoubleToStr(macd30, Digits),
      ", MACD 30_1 Minute: ", DoubleToStr(macd30_1, Digits),
      "\nMACD 15 Minute: ", DoubleToStr(macd15, Digits),
      ", MACD 15_1 Minute: ", DoubleToStr(macd15_1, Digits),
      "\nMACD 5 Minute: ", DoubleToStr(macd5, Digits),
      ", MACD 5_1 Minute: ", DoubleToStr(macd5_1, Digits),
      ", MACD 5_2 Minute: ", DoubleToStr(macd5_2, Digits),
      "\nTrend: ", TrendtoString(trend),
      ", Signal: ", TrendtoString(signal)
      );
}
int strategy(string symbol)
{
   //strategy_1(symbol);
}

/*
int strategy_1(string symbol, int timeperiod)
{
   if (strategy_1_day[0] != Day()) { //once order is placed, change strategy_1_day  = Day();
      strategy_1_start[0] = 1;
   }

   if (strategy_1_start[0] == 0)
      return (0);

   double intial_pos = MarketInfo(symbol, MODE_BID);
   int pos = 0;
   if (intial_pos > p && intial_pos < r1) {
      pos = 1;
   } else if (intial_pos > r1 && intial_pos < r2) {
      pos = 2;
   } else if (intial_pos > r2 && intial_pos < r3) {
      pos = 3;
   } else if (intial_pos > r3) {
      pos = 4;
   } else if (intial_pos < p && intial_pos > s1) {
      pos = -1;
   } else if (intial_pos < s1 && intial_pos > s2) {
      pos = -2;
   } else if (intial_pos < s2 && intial_pos > s3) {
      pos = -3;
   } else if (intial_pos < s3) {
      pos = -4;
   }
   if (strategy_1_pos[0] == 0) {
      strategy_1_pos[0] = pos;
   } 
   
   
   //else if (strategy_1_pos != pos) {
      //Alert("Old position: ", strategy_1_pos, ", New Position: ", pos);
      //strategy_1_pos = pos;
   //}
   //Alert(pos);
}
*/
double pivot_points(string symbol, int number)
{
   double high = iHigh(symbol, PERIOD_D1, number);
   double low = iLow(symbol, PERIOD_D1, number);
   double close = iClose(symbol, PERIOD_D1, number);
   double R = high - low;//range
   p = (high + low + close)/3;// Standard Pivot
   r3 = high + 2 * (p - low); //p + (R * 1.000);
   r2 = p + (high - low); //p + (R * 0.618);
   r1 = (2 * p) - low; //p + (R * 0.382);
   s1 = (2 * p) - high; //p - (R * 0.382);
   s2 = p - (high - low); //p - (R * 0.618);
   s3 = low - 2 * (high - p); //p - (R * 1.000);
}