//+------------------------------------------------------------------+
//|                                                   cu_teacher.mq4 |
//|                                              Manish Khanchandani |
//|                                          http://www.mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://www.mkgalaxy.com"

#property indicator_chart_window
string infobox;
double points;
double aLookup2, aStrength2;
bool detail = false;
int timestarted; 

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   Comment("");
   timestarted = TimeCurrent();
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
//----

   Sleep(5000);
   string symbol = Symbol();
   double totalpoints = 0;
   int period[7] = {PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4, PERIOD_D1};
   double increment = 0.1;
   infobox = "\nCURRENCY: " + symbol;
   infobox = infobox + "\nGENERAL:\n";
   infobox = infobox + "Ask: " + DoubleToStr(Ask, Digits) + ", Bid: " + DoubleToStr(Bid, Digits) + ", Spread: " + MarketInfo(symbol, MODE_SPREAD);
   //Range
   double high = -1;
   double low = -1;
   int z;
   for (z=0; z<4; z++) {
      if (high == -1) {
         high = iHigh(symbol, PERIOD_H4, z);
      }
      if (iHigh(symbol, PERIOD_H4, z) > high) {
         high = iHigh(symbol, PERIOD_H4, z);
      }
      if (low == -1) {
         low = iLow(symbol, PERIOD_H4, z);
      }
      if (iLow(symbol, PERIOD_H4, z) < low) {
         low = iLow(symbol, PERIOD_H4, z);
      }
   }
   double aRange    = MathMax((high-low)/Point,1); 
   double aRatio    = (Bid-low)/aRange/Point;
   double aLookup   = iLookup(aRatio*100); 
   double aStrength = 9-aLookup; 
   if (!aLookup2) {
      aLookup2   = aLookup; 
      aStrength2 = aStrength;
   }
   if (aLookup != aLookup2) {
      timestarted = TimeCurrent();
   }
   infobox = infobox + "\naLookup: " + DoubleToStr(aLookup, 2) + ", aStrength: " + DoubleToStr(aStrength, 2);
   if (aLookup > aStrength) {
      infobox = infobox + " - Buy";
   } else if (aLookup < aStrength) {
      infobox = infobox + " - Sell";
   } else {
      infobox = infobox + " - Consolidate";
   }  
   infobox = infobox + ", Since Time: " + TimeToStr(timestarted) + " (Current Time: " + TimeToStr(TimeCurrent()) + ")";
   aLookup2   = aLookup; 
   aStrength2 = aStrength;
   //semafor
   double ZZ_1, ZZ_2;
   double Period1            = 28;
   double Period2            = 56;
   double Period3            = 112;
   string Dev_Step_1         ="3,9";
   string Dev_Step_2         ="24,15";
   string Dev_Step_3         ="63,36";
   int Symbol_1_Kod          =140;
   int Symbol_2_Kod          =141;
   int Symbol_3_Kod          =142;
   bool condition_buy, condition_sell;
   double val, val2, val3;
   string tmp;
   int pinbar, engulf;
   double h1,h2;
   for (z=0; z<5; z++) {
      infobox = infobox + "\nTimeFrame: " + TimeframeToString(period[z]);
      points = 0;
      totalpoints = 0;
      //heiken
      h1 = iCustom(symbol, period[z], "Heiken_Ashi_Smoothed",2,0);
      h2 = iCustom(symbol, period[z], "Heiken_Ashi_Smoothed",3,0);
      totalpoints = totalpoints + increment;
      if (h1 < h2) {
         points = points + increment;
         if (detail) infobox = infobox + " H1";
      } else if (h1 > h2) {
         points = points - increment;
         if (detail) infobox = infobox + " H0";
      }
      //iRSI
      val = iRSI(symbol, period[z],7,PRICE_CLOSE,0);
      totalpoints = totalpoints + increment;
      if (val > 70) {
         points = points + increment;
         if (detail) infobox = infobox + " R1";
      } else if (val < 30) {
         points = points - increment;
         if (detail) infobox = infobox + " R0";
      } 
      //macd
      val2 = iCustom(symbol, period[z], "MACD_Complete",1,0);
      val3 = iCustom(symbol, period[z], "MACD_Complete",2,0);
      totalpoints = totalpoints + increment;
      if (val2 > val3) {
         points = points + increment;
         if (detail) infobox = infobox + " M1";
      } else if (val2 < val3) {
         points = points - increment;
         if (detail) infobox = infobox + " M0";
      } 
      //cci
      val = iCCI(symbol, period[z],45,PRICE_CLOSE,0);
      totalpoints = totalpoints + increment;
      if (val > 100) {
         points = points + increment;
         if (detail) infobox = infobox + " C1";
      } else if (val < -100) {
         points = points - increment;
         if (detail) infobox = infobox + " C0";
      } 
      //ema
      val = iMA(symbol,period[z],17,0,MODE_EMA,PRICE_CLOSE,0);
      val2 = iMA(symbol,period[z],43,0,MODE_EMA,PRICE_CLOSE,0);
      totalpoints = totalpoints + increment;
      if (val > val2) {
         points = points + increment;
         if (detail) infobox = infobox + " E1";
      } else if (val < val2) {
         points = points - increment;
         if (detail) infobox = infobox + " E0";
      }
      //iStochastic
      val = iStochastic(symbol,period[z],14,3,3,MODE_SMA,0,MODE_MAIN,0);
      val2 = iStochastic(symbol,period[z],14,3,3,MODE_SMA,0,MODE_SIGNAL,0);
      totalpoints = totalpoints + increment;
      if (val > val2) {
         points = points + increment;
         if (detail) infobox = infobox + " S1";
      } else if (val < val2) {
         points = points - increment;
         if (detail) infobox = infobox + " S0";
      }
      //parabolic
      val = iSAR(symbol,period[z],0.02,0.2,0);
      totalpoints = totalpoints + increment;
      if (val < iOpen(symbol, period[z], 0)) {
         points = points + increment;
         if (detail) infobox = infobox + " PS1";
      } else if (val > iOpen(symbol, period[z], 0)) {
         points = points - increment;
         if (detail) infobox = infobox + " PS0";
      }
      /*
      //ichimoku      
      val=iIchimoku(symbol,period[z], 9, 26, 52, MODE_TENKANSEN, 0);
      val2=iIchimoku(symbol,period[z], 9, 26, 52, MODE_KIJUNSEN, 0);
      totalpoints = totalpoints + increment;
      if (val > val2) {
         points = points + increment;
         if (detail) infobox = infobox + " TK1";
      } else if (val < val2) {
         points = points - increment;
         if (detail) infobox = infobox + " TK0";
      } 
      //span
      val = iIchimoku(symbol,period[z], 9, 26, 52, MODE_SENKOUSPANA, -25);
      val2 = iIchimoku(symbol,period[z], 9, 26, 52, MODE_SENKOUSPANB, -25);
      totalpoints = totalpoints + increment;
      if (val > val2) {
         points = points + increment;
         if (detail) infobox = infobox + " SP1";
      } else if (val < val2) {
         points = points - increment;
         if (detail) infobox = infobox + " SP0";
      } 
      //chickospan
      val = iIchimoku(symbol,period[z], 9, 26, 52, MODE_CHINKOUSPAN, 0+26);
      totalpoints = totalpoints + increment;
      if (val > iHigh(symbol, period[z], 0+26)) {
         points = points + increment;
         if (detail) infobox = infobox + " CO1";
      } else if (val < iLow(symbol, period[z], 0+26)) {
         points = points - increment;
         if (detail) infobox = infobox + " CO0";
      }
      //adx
      val = iADX(symbol,period[z],14,PRICE_CLOSE,MODE_MAIN,0);
      val2 = iADX(symbol,period[z],14,PRICE_CLOSE,MODE_PLUSDI,0);
      val3 = iADX(symbol,period[z],14,PRICE_CLOSE,MODE_MINUSDI,0);
      totalpoints = totalpoints + increment;
      if (val > 20 && val2 > val3) {
         points = points + increment;
         if (detail) infobox = infobox + " AD1";
      } else if (val > 20 && val2 < val3) {
         points = points - increment;
         if (detail) infobox = infobox + " AD0";
      }
      */
      infobox = infobox + ", Points: " + DoubleToStr(points, 1) + "/" + DoubleToStr(totalpoints, 1);
      if (points > 0) {
         tmp = " (Buy)";
      } else if (points < 0) {
         tmp = " (Sell)";
      } else {
         tmp = " (Consolidate)";
      }
      infobox = infobox + tmp;
      if (h1 < h2) {
         infobox = infobox + " - Heiken Buy";
      } else if (h1 > h2) {
         infobox = infobox + " - Heiken Sell";
      }
      ZZ_1=iCustom(symbol,period[z],"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,5,3);
      ZZ_2=iCustom(symbol,period[z],"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,4,3);
      condition_sell = ZZ_1 > ZZ_2;
      condition_buy = ZZ_1 < ZZ_2;
      infobox = infobox + " - Semaphore: " + ZZ_1 + "/" + ZZ_2 + " Buy: " + condition_buy + ", Sell: " + condition_sell;
      pinbar = pinbar(symbol, period[z]);
      if (pinbar == 1) {
         infobox = infobox + " - Main Bar Formed";
      }
      
      engulf = engulf(symbol, period[z]);
      if (engulf == 1) {
         infobox = infobox + " - Engulf";
      }
   }
   Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+


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

int pinbar(string symbol, int timeperiod)
{
   double open, close, high, low;
   open = iOpen(symbol, timeperiod, 0);
   close = iClose(symbol, timeperiod, 0);
   high = iHigh(symbol, timeperiod, 0);
   low = iLow(symbol, timeperiod, 0);
   if ((2 * MathAbs(open - close)) < (high - low)) {
      return (1);
   }
   return (0);
}
int engulf(string symbol, int timeperiod)
{
   double open, close, high, low;
   open = iOpen(symbol, timeperiod, 0);
   close = iClose(symbol, timeperiod, 0);
   high = iHigh(symbol, timeperiod, 0);
   low = iLow(symbol, timeperiod, 0);
   double open1, close1, high1, low1;
   open1 = iOpen(symbol, timeperiod, 1);
   close1 = iClose(symbol, timeperiod, 1);
   high1 = iHigh(symbol, timeperiod, 1);
   low1 = iLow(symbol, timeperiod, 1);
   double open2, close2, high2, low2;
   open2 = iOpen(symbol, timeperiod, 2);
   close2 = iClose(symbol, timeperiod, 2);
   high2 = iHigh(symbol, timeperiod, 2);
   low2 = iLow(symbol, timeperiod, 2);
   if (high1 < high2 && low1 > low2) {
      return (1);
   }
   return (0);
}

int iLookup(double ratio)                                                   // this function will return a grade value
  {                                                                         // based on its power.
   int    aTable[10]  = {0,3,10,25,40,50,60,75,90,97};                 // grade table for currency's power
   int   index;
   
   if      (ratio <= aTable[0]) index = 0;
   else if (ratio < aTable[1])  index = 0;
   else if (ratio < aTable[2])  index = 1;
   else if (ratio < aTable[3])  index = 2;
   else if (ratio < aTable[4])  index = 3;
   else if (ratio < aTable[5])  index = 4;
   else if (ratio < aTable[6])  index = 5;
   else if (ratio < aTable[7])  index = 6;
   else if (ratio < aTable[8])  index = 7;
   else if (ratio < aTable[9])  index = 8;
   else                         index = 9;
   return(index);                                                           // end of iLookup function
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
   return (L_1);
}
double gold_william_percent_range(string symbol, int timeframe, int shift)
{
   double L_1;
   L_1 = iCustom(symbol, timeframe, "WPR", 55, 0, shift);
   return (L_1);
}