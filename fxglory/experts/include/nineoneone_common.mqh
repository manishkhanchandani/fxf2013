//+------------------------------------------------------------------+
//|                                            nineoneone_common.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

string return_adx[10];
int i;
string infobox;
int number = 0;
int goldresult;

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

void custom_start()
{
   int handle;
   infobox = "";
   string symbol;
   //Period Calculation
   int period_array[9];
   period_array[0] = PERIOD_M1; 
   period_array[1] = PERIOD_M5; 
   period_array[2] = PERIOD_M15; 
   period_array[3] = PERIOD_M30; 
   period_array[4] = PERIOD_H1;
   period_array[5] = PERIOD_H4; 
   //period_array[6] = PERIOD_D1; 
   //period_array[7] = PERIOD_W1; 
   //period_array[8] = PERIOD_MN1;
   //Period Calculation ends

   //Symbol Calculation
   string currency_array[3];
   currency_array[0] = "EURUSD"; 
   //currency_array[1] = "EURNZD"; 
   //currency_array[2] = "NZDUSD";
   //Symbol Calculation ends
  
   //for (int k=0; k<1; k++) {
      //if (currency_array[k] == "") {
         //continue;
      //}
      symbol = Symbol(); //currency_array[k];
      
      //File open
      string filename = symbol + ".csv";
      handle=FileOpen(filename, FILE_CSV|FILE_WRITE, ';');
      //File open ends
      //Market Analysis
      infobox = StringConcatenate(infobox, "\n");
      infobox = StringConcatenate(infobox, "Symbol: ", symbol);
      for (int j=0; j<9; j++) {
         if (period_array[j] < 1) {
            continue;
         }
         infobox = StringConcatenate(infobox, "\n", "Timeframe: ", TimeframeToString(period_array[j]), "\n");

         //----Gold Result----//
         goldresult = gold(symbol, period_array[j], number);
         infobox = StringConcatenate(infobox, "//----Gold Result(Gold)----// Recommends: ", goldresult, "\n");
         //----Average Directional Index (ADX)----//
         adx(symbol, period_array[j], number);
         for (i = 0; i < 10; i++) {
            if (i > 0 && i < 6) continue;
            if (return_adx[i] != "") {
               infobox = StringConcatenate(infobox, return_adx[i], " | ");
            }
         }
         if(handle>0)
            FileWrite(handle, TimeframeToString(period_array[j]), "ADX", return_adx[1]
            , return_adx[2], return_adx[3], return_adx[4], return_adx[5], return_adx[6], return_adx[7]
            , return_adx[8], return_adx[9], TimeToStr(TimeCurrent()));
      }
      //closing file
      if(handle>0) {
         FileClose(handle);
      }
   //}
   //closing file ends
   infobox = StringConcatenate(infobox, "\n");
   Comment(infobox);
}

int gold(string symbol, int timeframe, int shift)
{
   int result = 0;
   int result1 = 0;
   int result2 = 0;
   int result3 = 0;
   int number2 = number + 1;
   double sell = gold_sell_zone_fibs(symbol, timeframe, number);
   double sell2 = gold_sell_zone_fibs(symbol, timeframe, number2);
   double buy = gold_buy_zone_fibs(symbol, timeframe, number);
   double buy2 = gold_buy_zone_fibs(symbol, timeframe, number2);
   double down = gold_rsioma_down(symbol, timeframe, number);
   double up = gold_rsioma_up(symbol, timeframe, number);
   double range = gold_william_percent_range(symbol, timeframe, number);
   double range2 = gold_william_percent_range(symbol, timeframe, number + 1);
   double range3 = gold_william_percent_range(symbol, timeframe, number + 2);
   //double range4 = gold_william_percent_range(symbol, timeframe, number + 3);
   //double range5 = gold_william_percent_range(symbol, timeframe, number + 4);
   if (MarketInfo(symbol, MODE_ASK) < sell) {
      result1 = -1;
   } else if (MarketInfo(symbol, MODE_BID) > buy) {
      result1 = 1;
   }
   if (down == EMPTY_VALUE && up > 0) {
      result2 = 1;
   } else if (up == EMPTY_VALUE && down < 0) {
      result2 = -1; 
   }
   if (range < 0 && range > -25) {
      result3 = 1;
   } else if (range < -75) {
      result3 = -1;
   }
   if (result1 == 1 && result2 == 1 && result3 == 1) {
      if (range2 < -25 && range3 < range2) {
         result = 1;
      }
   } else if (result1 == -1 && result2 == -1 && result3 == -1) {
      if (range2 > -75 && range3 > range2) {
         result = -1;
      }
   }
   return (result);
}
double gold_sell_zone_fibs(string symbol, int timeframe, int shift)
{
   double L_1;
   int MAPeriod = 55;
   int       MAType=2;
   int fibo1 = 1;
   int fibo2 = 2;
   int fibo3 = 3;
   int fibo4 = 4;
   int fibo5 = 5;
   int fibo6 = 6;
   int fibo7 = 7;
   L_1 = iCustom(symbol, timeframe, "sell zone fibs", MAPeriod, MAType, fibo1, fibo2, fibo3, fibo4, fibo5, fibo6, fibo7, 0, shift);
   //Alert(symbol, " - ", TimeframeToString(timeframe), " - ", DoubleToStr(L_1, MarketInfo(symbol, MODE_DIGITS)), " - ", DoubleToStr(MarketInfo(symbol, MODE_ASK), MarketInfo(symbol, MODE_DIGITS)));
   return (L_1);
}
double gold_buy_zone_fibs(string symbol, int timeframe, int shift)
{
   double L_1;
   int MAPeriod = 55;
   int       MAType=2;
   int fibo1 = 1;
   int fibo2 = 2;
   int fibo3 = 3;
   int fibo4 = 4;
   int fibo5 = 5;
   int fibo6 = 6;
   int fibo7 = 7;
   L_1 = iCustom(symbol, timeframe, "buy zone fibs", MAPeriod, MAType, fibo1, fibo2, fibo3, fibo4, fibo5, fibo6, fibo7, 0, shift);
   //Alert(symbol, " - ", TimeframeToString(timeframe), " - ", DoubleToStr(L_1, MarketInfo(symbol, MODE_DIGITS)), " - ", DoubleToStr(MarketInfo(symbol, MODE_BID), MarketInfo(symbol, MODE_DIGITS)));
   return (L_1);
}

double gold_rsioma_down(string symbol, int timeframe, int shift)
{
   double L_1;
   L_1 = iCustom(symbol, timeframe, "RSIOMA_v3", 1, shift);
   //Alert(symbol, " - ", TimeframeToString(timeframe), " down2 - ", L_1);
   return (L_1);
}

double gold_rsioma_up(string symbol, int timeframe, int shift)
{
   double L_1;
   L_1 = iCustom(symbol, timeframe, "RSIOMA_v3", 2, shift);
   //Alert(symbol, " - ", TimeframeToString(timeframe), " up2 - ", L_1);
   return (L_1);
}


double gold_william_percent_range(string symbol, int timeframe, int shift)
{
   double L_1;
   L_1 = iCustom(symbol, timeframe, "WPR", 55, 0, shift);
   //Alert(symbol, " - ", TimeframeToString(timeframe), " Williams - ", L_1);
   return (L_1);
}
void adx(string symbol, int timeframe, int shift)
{
   return_adx[0] = "//-- Average Directional Index (ADX)--//";
   return_adx[1] = "";
   return_adx[2] = "";
   return_adx[3] = "";
   return_adx[4] = "";
   return_adx[5] = "";
   return_adx[6] = "";
   return_adx[7] = "";
   return_adx[8] = "";
   return_adx[9] = "";
   int num = shift;
   int num_prev = shift+1;
   int num_next = shift-1;
   double iadx = iADX(symbol, timeframe, 14, PRICE_HIGH, MODE_MAIN, num);
   double iadx2 = iADX(symbol, timeframe, 14, PRICE_HIGH, MODE_MAIN, num_prev);
   double iadx3 = iADX(symbol, timeframe, 14, PRICE_HIGH, MODE_MAIN, num_next);
   double iadxpdx = iADX(symbol, timeframe, 14, PRICE_HIGH, MODE_PLUSDI, num);
   double iadxmdx = iADX(symbol, timeframe, 14, PRICE_HIGH, MODE_MINUSDI, num);
   return_adx[1] = iadx;
   return_adx[2] = iadx2;
   return_adx[3] = iadx3;
   return_adx[4] = iadxpdx;
   return_adx[5] = iadxmdx;
   if (iadx < 20) {
      return_adx[6] = "No Trend or Trend is Weak";
   } else if (iadx > 40) {
      return_adx[6] = "Extremely Strong Trend";
   } else if (iadx > 20) {
      return_adx[6] = "Strong Trend";
   }
   if (iadx > iadx2 && iadx > 20) {
      return_adx[7] = "Rising — Trend is going stronger";
   } else if (iadx < iadx2) {
      return_adx[7] = "Falling - Trend is weakening";
   }

   if (iadxpdx > iadxmdx) {
      return_adx[8] = "Uptrend is in place";
   } else if (iadxpdx < iadxmdx) {
      return_adx[8] = "Downtrend is in place";
   }
 

   return_adx[9] = "ADX: " + iadx;
}

