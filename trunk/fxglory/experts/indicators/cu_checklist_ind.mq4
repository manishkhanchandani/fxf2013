//+------------------------------------------------------------------+
//|                                             cu_checklist_ind.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window

int openTime;
int curtime;
string infobox;
string orderbox;
string impbox;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
Comment("");
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
custom_start();
         Comment(impbox, "\n", orderbox, "\n", infobox);
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

void custom_start()
{
      infobox="";
   if (Period() != PERIOD_H4) {
      infobox = "Period should be H4";
      return (0);
   }
      int periods[7] = {PERIOD_H4, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_D1};
      int limit = 1;
      int period, period2;
      int division;
      int indecision, indecision1;
      double close1, close2;
      int result;
      double val, val2, val3, val4, val5;
      period = PERIOD_H4;
      period2 = PERIOD_H1;
      
         if (openTime != iTime(Symbol(), period, 0)) {
            impbox = "\n\nImportant News: \n";
         }
      
      //infobox = StringConcatenate(infobox, "\n", "Current Time: ", TimeToStr(curtime), ", Current Bar Time: ", TimeToStr(Time[0])); 
      infobox = StringConcatenate(infobox, "\n", "Spread: ", MarketInfo(Symbol(), MODE_SPREAD)); 
      infobox = StringConcatenate(infobox, "\n", "Bid: ", DoubleToStr(Bid, Digits), ", Ask: ", DoubleToStr(Ask, Digits));
      int r1 = (iHigh(Symbol(), PERIOD_D1, 1) - iLow(Symbol(), PERIOD_D1, 1)) / Point;
      int r2 = (iHigh(Symbol(), PERIOD_D1, 2) - iLow(Symbol(), PERIOD_D1, 2)) / Point;
      int r3 = (iHigh(Symbol(), PERIOD_D1, 3) - iLow(Symbol(), PERIOD_D1, 3)) / Point;
      double r = (r1 + r2 + r3)/3;
      infobox = StringConcatenate(infobox, "\n", "Avg Range: ", r);
      infobox = StringConcatenate(infobox, ", ", "Range 1: ", r1); 
      infobox = StringConcatenate(infobox, ", ", "Range 2: ", r2);
      infobox = StringConcatenate(infobox, ", ", "Range 3: ", r3);   

      infobox = StringConcatenate(infobox, "\n\n", "Period: ", TimeframeToString(period), ", Period2: ", TimeframeToString(period2));
         
      result = 0;
      close1 = iClose(Symbol(), period2, 1);
      close2 = iClose(Symbol(), period2, division);
         infobox = StringConcatenate(infobox, "\n", "close1: ", DoubleToStr(close1, Digits), ", close2: ", DoubleToStr(close2, Digits));
         if (close2 < close1) { //means pas was lesser and current is greater so sell
            infobox = StringConcatenate(infobox, "\n", "Buy Signal");
            result = 1;
         } else if (close2 > close1) { //means pas was greater and current is lesser so sell
            infobox = StringConcatenate(infobox, "\n", "Sell Signal");
            result = -1;
         }
         //strategy 1: engulfed
         val = iHigh(Symbol(), period, 1) - iLow(Symbol(), period, 1);
         val2 = iHigh(Symbol(), period, 2) - iLow(Symbol(), period, 2);
         indecision = is_indecision_candle(2, period, Symbol());
         if (val2 > val 
            && indecision == 0 
            && iHigh(Symbol(), period, 1) < iHigh(Symbol(), period, 2) 
            && iLow(Symbol(), period, 1) > iLow(Symbol(), period, 2)
           ) {
            if (openTime != iTime(Symbol(), period, 0)) {
               Alert(Symbol(), ", Strategy 1 says: ", ResultToString(result), " for period: ", TimeframeToString(period));
               impbox = StringConcatenate(impbox, "\n", Symbol(), ", Strategy 1 says: ", ResultToString(result), " for period: ", TimeframeToString(period));
            }
            infobox = StringConcatenate(infobox, "\n", "Valid Sign To Enter Using Strategy 1: ", (val2 - val), " and ", indecision, " and result: ", ResultToString(result));
         }
         //strategy 2
         
         //strategy 3
         indecision1 = is_indecision_candle(1, period, Symbol());
         if (indecision1 == 1) {
            if (openTime != iTime(Symbol(), period, 0)) {
               Alert(Symbol(), ", Strategy 3 says: (Indecision Candle) - Result ", ResultToString(result), " for period: ", TimeframeToString(period));
               impbox = StringConcatenate(impbox, "\n", Symbol(), ", Strategy 3 says: (Indecision Candle) - Result ", ResultToString(result), " for period: ", TimeframeToString(period));
            }
            infobox = StringConcatenate(infobox, "\n", "Valid Sign To Enter Using Strategy 3: Indecision Candle ", indecision1, " and result: ", ResultToString(result));
         }
         //heiken strategy
         val2 = iCustom(NULL, period, "Heiken_Ashi_Smoothed",2,1);
         val3 = iCustom(NULL, period, "Heiken_Ashi_Smoothed",3,1);
         val4 = iCustom(NULL, period, "Heiken_Ashi_Smoothed",2,2);
         val5 = iCustom(NULL, period, "Heiken_Ashi_Smoothed",3,2);
         if (val2 < val3 && val4 > val5) {
            if (openTime != iTime(Symbol(), period, 0)) {
               Alert(Symbol(), ", heiken strategy changes to buy");
               impbox = StringConcatenate(impbox, "\n", Symbol(), ", heiken strategy changes to buy for period: ", TimeframeToString(period));
            }
         } else if (val2 > val3 && val4 < val5) {
            if (openTime != iTime(Symbol(), period, 0)) {
               Alert(Symbol(), ", heiken strategy changes to sell");
               impbox = StringConcatenate(impbox, "\n", Symbol(), ", heiken strategy changes to sell for period: ", TimeframeToString(period));
            }
         }
         if (openTime != iTime(Symbol(), period, 0)) {
            openTime = iTime(Symbol(), period, 0);
         }
}

string ResultToString(int result)
{
   switch (result) {
      case 1:
         return ("Buy");
         break;
      case -1:
         return ("Sell");
         break;
      case 0:
         return ("");
         break;
   }
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


int is_indecision_candle(int i, int period, string symbol)
{
   double top, bottom;
   double high = iHigh(symbol, period, i);
   double low = iLow(symbol, period, i);
   double open = iOpen(symbol, period, i);
   double close = iClose(symbol, period, i);
   double body = MathAbs(open - close);
   int result = 0;
   if (open > close) {
      top = high - open;
      bottom = close - low;
      result = 1;
    } else {
      top = high - close;
      bottom = open - low;
      result = -1;
    }
   double totalmove = high - low;
   if (body < (totalmove * 0.30) && (top > (totalmove * 0.50) || bottom > (totalmove * 0.50))) {
      return (1);
   }

   return (0);
}