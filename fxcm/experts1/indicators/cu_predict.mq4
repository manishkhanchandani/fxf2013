//+------------------------------------------------------------------+
//|                                                   cu_predict.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window

#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_width1 2
#property indicator_color2 Orange
#property indicator_width2 2
double CrossUp[];
double CrossDown[];
extern bool current_currency_pair = false;
extern bool USDCHF = true;
extern bool GBPUSD = true;
extern bool EURUSD = true;
extern bool USDJPY = true;
extern bool USDCAD = true;
extern bool AUDUSD = true;
extern bool EURGBP = true;
extern bool EURAUD = true;
extern bool EURCHF = true;
extern bool EURJPY = true;
extern bool GBPCHF = true;
extern bool CADJPY = true;
extern bool GBPJPY = true;
extern bool AUDNZD = true;
extern bool AUDCAD = true;
extern bool AUDCHF = true;
extern bool AUDJPY = true;
extern bool CHFJPY = true;
extern bool EURNZD = true;
extern bool EURCAD = true;
extern bool CADCHF = true;
extern bool NZDJPY = true;
extern bool NZDUSD = true;
extern bool GBPCAD = true;
extern bool GBPNZD = true;
extern bool GBPAUD = true;
extern bool NZDCHF = true;
extern bool NZDCAD = true;

int newbar[30];
int opentime[30];
int result[30];
int buy[30];
int sell[30];
int opentime2[30];
int result2[30];
int goaltime[30];
int goaltime2[30];
int number_USDCHF = 1;
int number_GBPUSD = 2;
int number_EURUSD = 3;
int number_USDJPY = 4;
int number_USDCAD = 5;
int number_AUDUSD = 6;
int number_EURGBP = 7;
int number_EURAUD = 8;
int number_EURCHF = 9;
int number_EURJPY = 10;
int number_GBPCHF = 11;
int number_CADJPY = 12;
int number_GBPJPY = 13;
int number_AUDNZD = 14;
int number_AUDCAD = 15;
int number_AUDCHF = 16;
int number_AUDJPY = 17;
int number_CHFJPY = 18;
int number_EURNZD = 19;
int number_EURCAD = 20;
int number_CADCHF = 21;
int number_NZDJPY = 22;
int number_NZDUSD = 23;
int number_GBPCAD = 24;
int number_GBPNZD = 25;
int number_GBPAUD = 26;
int number_NZDCHF = 27;
int number_NZDCAD = 28;

string currency_USDCHF;
string currency_GBPUSD;
string currency_EURUSD;
string currency_USDJPY;
string currency_USDCAD;
string currency_AUDUSD;
string currency_EURGBP;
string currency_EURAUD;
string currency_EURCHF;
string currency_EURJPY;
string currency_GBPCHF;
string currency_CADJPY;
string currency_GBPJPY;
string currency_AUDNZD;
string currency_AUDCAD;
string currency_AUDCHF;
string currency_AUDJPY;
string currency_CHFJPY;
string currency_EURNZD;
string currency_EURCAD;
string currency_CADCHF;
string currency_NZDJPY;
string currency_NZDUSD;
string currency_GBPCAD;
string currency_GBPNZD;
string currency_GBPAUD;
string currency_NZDCHF;
string currency_NZDCAD;
string infobox;
string filename;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   conversion();
   SetIndexStyle(0, DRAW_ARROW, EMPTY);
   SetIndexArrow(0, 233);
   SetIndexBuffer(0, CrossUp);
   SetIndexStyle(1, DRAW_ARROW, EMPTY);
   SetIndexArrow(1, 234);
   SetIndexBuffer(1, CrossDown);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   Comment("");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   infobox = "";
   check_for_open();
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

void conversion()
{
   if (current_currency_pair) {
      return;
   }

   if (USDCHF) {
      currency_USDCHF = "USDCHF";
   }

   if (GBPUSD) {
      currency_GBPUSD = "GBPUSD";
   }
   
   if (EURUSD) {
      currency_EURUSD = "EURUSD";
   }
   
   if (USDJPY) {
      currency_USDJPY = "USDJPY";
   }
   
   if (USDCAD) {
      currency_USDCAD = "USDCAD";
   }

   if (AUDUSD) {
      currency_AUDUSD = "AUDUSD";
   }
   
   if (EURGBP) {
      currency_EURGBP = "EURGBP";
   }
   
   if (EURAUD) {
      currency_EURAUD = "EURAUD";
   }
   
   if (EURCHF) {
      currency_EURCHF = "EURCHF";
   }
   
   if (EURJPY) {
      currency_EURJPY = "EURJPY";
   }
   
   if (GBPCHF) {
      currency_GBPCHF = "GBPCHF";
   }
   
   if (CADJPY) {
      currency_CADJPY = "CADJPY";
   }
   
   if (GBPJPY) {
      currency_GBPJPY = "GBPJPY";
   }
   
   if (AUDNZD) {
      currency_AUDNZD = "AUDNZD";
   }
   
   if (AUDCAD) {
      currency_AUDCAD = "AUDCAD";
   }
   
   if (AUDCHF) {
      currency_AUDCHF = "AUDCHF";
   }
   
   if (AUDJPY) {
      currency_AUDJPY = "AUDJPY";
   }
   
   if (CHFJPY) {
      currency_CHFJPY = "CHFJPY";
   }
   
   if (EURNZD) {
      currency_EURNZD = "EURNZD";
   }
   
   if (EURCAD) {
      currency_EURCAD = "EURCAD";
   }
   
   if (CADCHF) {
      currency_CADCHF = "CADCHF";
   }
   
   if (NZDJPY) {
      currency_NZDJPY = "NZDJPY";
   }
   
   if (NZDUSD) {
      currency_NZDUSD = "NZDUSD";
   }
   
   if (GBPCAD) {
      currency_GBPCAD = "GBPCAD";
   }
   
   if (GBPNZD) {
      currency_GBPNZD = "GBPNZD";
   }
   
   if (GBPAUD) {
      currency_GBPAUD = "GBPAUD";
   }
   
   if (NZDCHF) {
      currency_NZDCHF = "NZDCHF";
   }
   if (NZDCAD) {
      currency_NZDCAD = "NZDCAD";
   }
}


void check_for_open()
{
   if (current_currency_pair == true) {
      infobox = StringConcatenate(infobox, "\n//-------------Taking Current Currency Pair-------------//\n");
      trade(Symbol(), 0);
   } else {
      if (currency_USDCHF == "USDCHF") {
         trade(currency_USDCHF, number_USDCHF);
      }
      if (currency_GBPUSD == "GBPUSD") {
         trade(currency_GBPUSD, number_GBPUSD);
      }
      if (currency_EURUSD == "EURUSD") {
         trade(currency_EURUSD, number_EURUSD);
      }
      if (currency_USDJPY == "USDJPY") {
         trade(currency_USDJPY, number_USDJPY);
      }
      if (currency_USDCAD == "USDCAD") {
         trade(currency_USDCAD, number_USDCAD);
      }
      if (currency_AUDUSD == "AUDUSD") {
         trade(currency_AUDUSD, number_AUDUSD);
      }
      if (currency_EURGBP == "EURGBP") {
         trade(currency_EURGBP, number_EURGBP);
      }
      if (currency_EURAUD == "EURAUD") {
         trade(currency_EURAUD, number_EURAUD);
      }
      if (currency_EURCHF == "EURCHF") {
         trade(currency_EURCHF, number_EURCHF);
      }
      if (currency_EURJPY == "EURJPY") {
         trade(currency_EURJPY, number_EURJPY);
      }
      if (currency_GBPCHF == "GBPCHF") {
         trade(currency_GBPCHF, number_GBPCHF);
      }
      if (currency_CADJPY == "CADJPY") {
         trade(currency_CADJPY, number_CADJPY);
      }
      if (currency_GBPJPY == "GBPJPY") {
         trade(currency_GBPJPY, number_GBPJPY);
      }
      if (currency_AUDNZD == "AUDNZD") {
         trade(currency_AUDNZD, number_AUDNZD);
      }
      if (currency_AUDCAD == "AUDCAD") {
         trade(currency_AUDCAD, number_AUDCAD);
      }
      if (currency_AUDCHF == "AUDCHF") {
         trade(currency_AUDCHF, number_AUDCHF);
      }
      if (currency_AUDJPY == "AUDJPY") {
         trade(currency_AUDJPY, number_AUDJPY);
      }
      if (currency_CHFJPY == "CHFJPY") {
         trade(currency_CHFJPY, number_CHFJPY);
      }
      if (currency_EURNZD == "EURNZD") {
         trade(currency_EURNZD, number_EURNZD);
      }
      if (currency_EURCAD == "EURCAD") {
         trade(currency_EURCAD, number_EURCAD);
      }
      if (currency_CADCHF == "CADCHF") {
         trade(currency_CADCHF, number_CADCHF);
      }
      if (currency_NZDJPY == "NZDJPY") {
         trade(currency_NZDJPY, number_NZDJPY);
      }
      if (currency_NZDUSD == "NZDUSD") {
         trade(currency_NZDUSD, number_NZDUSD);
      }
      if (currency_GBPCAD == "GBPCAD") {
         trade(currency_GBPCAD, number_GBPCAD);
      }
      if (currency_GBPNZD == "GBPNZD") {
         trade(currency_GBPNZD, number_GBPNZD);
      }
      if (currency_GBPAUD == "GBPAUD") {
         trade(currency_GBPAUD, number_GBPAUD);
      }
      if (currency_NZDCHF == "NZDCHF") {
         trade(currency_NZDCHF, number_NZDCHF);
      }
      if (currency_NZDCAD == "NZDCAD") {
         trade(currency_NZDCAD, number_NZDCAD);
      }
   }
   Comment(infobox);
}
//opentime[30]
void trade(string symbol, int number)
{
   filename = Year() + "_" + Month() + "_" + Day()  + "d/predict_" + symbol + "_"+Period()+"_.txt";
   infobox = StringConcatenate(infobox, "\n", symbol, " (", number, ")");
   double high, low, open, close;
   double range, rangereal;
   //CALCULATION
   high = iHigh(symbol, Period(), 1);
   low = iLow(symbol, Period(), 1);
   open = iOpen(symbol, Period(), 0);
   rangereal = MathAbs(high - low);
   range = rangereal / MarketInfo(symbol, MODE_POINT);
   infobox = StringConcatenate(infobox, " - high: ", DoubleToStr(high, MarketInfo(symbol, MODE_DIGITS)),
      ", low: ", DoubleToStr(low, MarketInfo(symbol, MODE_DIGITS)),
      ", Range: ", rangereal
   );
   //if (range < 150) {
      //infobox = StringConcatenate(infobox, " - Range is less than 150");
      //return (0);
   //}
   //TREND DECISION
   int trend = 0;
   double ema13 = iMA(symbol,0,13,0,MODE_EMA,PRICE_CLOSE,1);
   double ema26 = iMA(symbol,0,26,0,MODE_EMA,PRICE_CLOSE,1);
   double ema52 = iMA(symbol,0,52,0,MODE_EMA,PRICE_CLOSE,1);
   double ema13b = iMA(symbol,0,13,0,MODE_EMA,PRICE_CLOSE,2);
   if (ema13 > ema26 && ema26 > ema52 && ema13 > ema13b) {
      trend = 1;
   } else if (ema13 < ema26 && ema26 < ema52 && ema13 < ema13b) {
      trend = -1;
   }
   infobox = StringConcatenate(infobox, " - Trend: ", trend);
   if (trend == 0) {
      infobox = StringConcatenate(infobox, " - Trend is not defined");
      //return (0);
   }
   //PERCENT CALCULATION
   double tenpercent = rangereal / 10;
   tenpercent = NormalizeDouble(tenpercent, MarketInfo(symbol, MODE_DIGITS));
   infobox = StringConcatenate(infobox, " - 10%: ", tenpercent);
   double twentyfive = rangereal / 4;
   twentyfive = NormalizeDouble(twentyfive, MarketInfo(symbol, MODE_DIGITS));
   infobox = StringConcatenate(infobox, " - 25%: ", twentyfive);

   if (newbar[number] != iTime(symbol, Period(), 0)) {
      newbar[number] = iTime(symbol, Period(), 0);
      result[number] = 0;
      buy[number] = 0;
      sell[number] = 0;
      result2[number] = 0;
      FileAppend(filename, "");
      FileAppend(filename, "");
      FileAppend(filename, "Time: " + TimeToStr(TimeCurrent()));
      FileAppend(filename, "Period: " + TimeframeToString(Period()));
      
   }
   if (MarketInfo(symbol, MODE_BID) > (open + tenpercent)) {
      buy[number] = 1;
      if (sell[number] == 1 && opentime[number] != iTime(symbol, Period(), 0)) {
         result[number] = 1;
         opentime[number] = iTime(symbol, Period(), 0);
         FileAppend(filename, "Buy1: " + TimeToStr(TimeCurrent()) + " with price: " + DoubleToStr(MarketInfo(symbol, MODE_BID), MarketInfo(symbol, MODE_DIGITS)));
      }
   } else if (MarketInfo(symbol, MODE_BID) < (open - tenpercent)) {
      sell[number] = 1;
      if (buy[number] == 1 && opentime[number] != iTime(symbol, Period(), 0)) {
         result[number] = -1;
         opentime[number] = iTime(symbol, Period(), 0);
         FileAppend(filename, "Sell1: " + TimeToStr(TimeCurrent()) + " with price: " + DoubleToStr(MarketInfo(symbol, MODE_BID), MarketInfo(symbol, MODE_DIGITS)));
      }
   } 
   
   if (MarketInfo(symbol, MODE_BID) > (open + twentyfive) && opentime2[number] != iTime(symbol, Period(), 0)) {
      result2[number] = 1;
      opentime2[number] = iTime(symbol, Period(), 0);
      FileAppend(filename, "Buy2: " + TimeToStr(TimeCurrent()) + " with price: " + DoubleToStr(MarketInfo(symbol, MODE_BID), MarketInfo(symbol, MODE_DIGITS)));
   } else if (MarketInfo(symbol, MODE_BID) < (open - tenpercent) && opentime2[number] != iTime(symbol, Period(), 0)) {
      result2[number] = -1;
      opentime2[number] = iTime(symbol, Period(), 0);
      FileAppend(filename, "Sell2: " + TimeToStr(TimeCurrent()) + " with price: " + DoubleToStr(MarketInfo(symbol, MODE_BID), MarketInfo(symbol, MODE_DIGITS)));
   } 
   infobox = StringConcatenate(infobox, " - Result: ", result[number], ", ", buy[number], ", ", sell[number]);
   infobox = StringConcatenate(infobox, " - Result2: ", result2[number]);
   if (MarketInfo(symbol, MODE_BID) > open)
      infobox = StringConcatenate(infobox, " - Up");
   else if (MarketInfo(symbol, MODE_BID) < open)
      infobox = StringConcatenate(infobox, " - Down");
   // check if goal is reached.
   if (result[number] == 1) {
      if (MarketInfo(symbol, MODE_BID) > (open + tenpercent + twentyfive) && goaltime[number] != iTime(symbol, Period(), 0)) {
         infobox = StringConcatenate(infobox, " - Buy Goal Reached");
         FileAppend(filename, "Buy1 Goal Reached: " + TimeToStr(TimeCurrent()) + " with price: " + DoubleToStr(MarketInfo(symbol, MODE_BID), MarketInfo(symbol, MODE_DIGITS)));
         goaltime[number] = iTime(symbol, Period(), 0);
      }
   } else if (result[number] == -1) {
      if (MarketInfo(symbol, MODE_BID) < (open - (tenpercent + twentyfive)) && goaltime[number] != iTime(symbol, Period(), 0)) {
         infobox = StringConcatenate(infobox, " - Sell Goal Reached");
         FileAppend(filename, "Sell1 Goal Reached: " + TimeToStr(TimeCurrent()) + " with price: " + DoubleToStr(MarketInfo(symbol, MODE_BID), MarketInfo(symbol, MODE_DIGITS)));
         goaltime[number] = iTime(symbol, Period(), 0);
      }
   }
   if (result2[number] == 1) {
      if (MarketInfo(symbol, MODE_BID) > (open + twentyfive + twentyfive) && goaltime2[number] != iTime(symbol, Period(), 0)) {
         infobox = StringConcatenate(infobox, " - Buy2 Goal Reached");
         FileAppend(filename, "Buy2 Goal Reached: " + TimeToStr(TimeCurrent()) + " with price: " + DoubleToStr(MarketInfo(symbol, MODE_BID), MarketInfo(symbol, MODE_DIGITS)));
         goaltime2[number] = iTime(symbol, Period(), 0);
      }
   } else if (result2[number] == -1) {
      if (MarketInfo(symbol, MODE_BID) < (open - (twentyfive + twentyfive)) && goaltime2[number] != iTime(symbol, Period(), 0)) {
         infobox = StringConcatenate(infobox, " - Sell2 Goal Reached");
         FileAppend(filename, "Sell2 Goal Reached: " + TimeToStr(TimeCurrent()) + " with price: " + DoubleToStr(MarketInfo(symbol, MODE_BID), MarketInfo(symbol, MODE_DIGITS)));
         goaltime2[number] = iTime(symbol, Period(), 0);
      }
   }
   if (current_currency_pair && result[number] != 0) {
      int limit, i, counter;
      double Range2, AvgRange;
      counter=i;
      Range2=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range2=AvgRange/10;
      if (result[number] == 1) {
         CrossUp[i] = Low[i] - Range2*0.5;
      } else if (result[number] == -1) {
         CrossDown[i] = High[i] + Range2*0.5;
      }
   }
}


void FileAppend(string name,string txt)
{
   int handle = FileOpen(name,FILE_READ|FILE_WRITE);
	FileSeek(handle,0,SEEK_END);
	FileWrite(handle,txt);
	FileFlush(handle);
	FileClose(handle);
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
      case 0: return ("Any");
   }
}