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
bool detail = true;
int timestarted; 
int opentime;


#define ARRSIZE  28
#define USD 0
#define EUR 1
#define GBP 2
#define CHF 3                                                                                      
#define CAD 4                                                                                      
#define AUD 5                                                                                      
#define JPY 6                                                                                      
#define NZD 7

#define PAIRSIZE 8

#define USDCHF 0
#define GBPUSD 1
#define EURUSD 2
#define USDJPY 3
#define USDCAD 4
#define AUDUSD 5
#define EURGBP 6
#define EURAUD 7
#define EURCHF 8
#define EURJPY 9
#define GBPCHF 10
#define CADJPY 11
#define GBPJPY 12
#define AUDNZD 13
#define AUDCAD 14
#define AUDCHF 15
#define AUDJPY 16
#define CHFJPY 17
#define EURNZD 18
#define EURCAD 19
#define CADCHF 20
#define NZDJPY 21
#define NZDUSD 22
#define GBPCAD 23
#define GBPNZD 24
#define GBPAUD 25
#define NZDCHF 26
#define NZDCAD 27
string aPair[ARRSIZE]   = {
                        "USDCHF","GBPUSD","EURUSD","USDJPY","USDCAD","AUDUSD",
                        "EURGBP","EURAUD","EURCHF","EURJPY","GBPCHF","CADJPY",
                        "GBPJPY","AUDNZD","AUDCAD","AUDCHF","AUDJPY","CHFJPY",
                        "EURNZD","EURCAD","CADCHF","NZDJPY","NZDUSD","GBPCAD",
                        "GBPNZD","GBPAUD","NZDCHF","NZDCAD"
                        };
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

   if (opentime != Time[0]) {
      string symbol = Symbol();
      double totalpoints = 0;
      int period = Period();
      double increment = 0.1;
      infobox = "\nCURRENCY: " + symbol;
      infobox = infobox + "\nGENERAL:\n";
      infobox = infobox + "Ask: " + DoubleToStr(Ask, Digits) + ", Bid: " + DoubleToStr(Bid, Digits) + ", Spread: " + MarketInfo(symbol, MODE_SPREAD);
      //Range
      double high = -1;
      double low = -1;
      double high2, low2;
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
      double Period1            = 5;
      double Period2            = 13;
      double Period3            = 34;
      string Dev_Step_1         ="1,3";
      string Dev_Step_2         ="8,5";
      string Dev_Step_3         ="21,12";
      int Symbol_1_Kod          =140;
      int Symbol_2_Kod          =141;
      int Symbol_3_Kod          =142;
      bool condition_buy, condition_sell;
      bool condition_top, condition_bottom;
      double val, val2, val3, val4, val5, val6;
      string tmp;
      int pinbar, engulf;
      double h1,h2,h3,h4;
      double range_top[100];
      double range_bottom[100];
      double range_top2[100];
      double range_bottom2[100];
         infobox = infobox + "\n\nTimeFrame: " + TimeframeToString(period);
         points = 0;
         totalpoints = 0;
         //heiken
         h1 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,1);
         h2 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,1);
         h3 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,2);
         h4 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,2);
         totalpoints = totalpoints + increment;
         if (h1 < h2) {
            points = points + increment;
            if (detail) infobox = infobox + " H1";
         } else if (h1 > h2) {
            points = points - increment;
            if (detail) infobox = infobox + " H0";
         }
         if (h1 < h2 && h3 > h4) {
            Alert(symbol, ", ", TimeframeToString(period), ", Heiken change to Buy");
         } else if (h1 > h2 && h3 < h4) {
            Alert(symbol, ", ", TimeframeToString(period), ", Heiken change to Sell");
         }
         //iRSI
         val = iRSI(symbol, period,7,PRICE_CLOSE,1);
         val2 = iRSI(symbol, period,7,PRICE_CLOSE,2);
         totalpoints = totalpoints + increment;
         if (val > 70) {
            points = points + increment;
            if (detail) infobox = infobox + " R1";
         } else if (val < 30) {
            points = points - increment;
            if (detail) infobox = infobox + " R0";
         } 
         if (val > 70 && val2 < 70) {
            Alert(symbol, ", ", TimeframeToString(period), ", RSI change to Buy");
         } else if (val < 30 && val2 > 30) {
            Alert(symbol, ", ", TimeframeToString(period), ", RSI change to Sell");
         } 
         //macd
         val2 = iCustom(symbol, period, "MACD_Complete",1,1);
         val3 = iCustom(symbol, period, "MACD_Complete",2,1);
         val4 = iCustom(symbol, period, "MACD_Complete",1,2);
         val5 = iCustom(symbol, period, "MACD_Complete",2,2);
         totalpoints = totalpoints + increment;
         if (val2 > val3) {
            points = points + increment;
            if (detail) infobox = infobox + " M1";
         } else if (val2 < val3) {
            points = points - increment;
            if (detail) infobox = infobox + " M0";
         } 
         if (val2 > val3 && val4 < val5) {
            Alert(symbol, ", ", TimeframeToString(period), ", MACD change to Buy");
         } else if (val2 < val3 && val4 > val5) {
            Alert(symbol, ", ", TimeframeToString(period), ", MACD change to Sell");
         } 
         //cci
         val = iCCI(symbol, period,45,PRICE_CLOSE,1);
         totalpoints = totalpoints + increment;
         if (val > 100) {
            points = points + increment;
            if (detail) infobox = infobox + " C1";
         } else if (val < -100) {
            points = points - increment;
            if (detail) infobox = infobox + " C0";
         } 
         //ema
         val = iMA(symbol,period,17,0,MODE_EMA,PRICE_CLOSE,1);
         val2 = iMA(symbol,period,43,0,MODE_EMA,PRICE_CLOSE,1);
         totalpoints = totalpoints + increment;
         if (val > val2) {
            points = points + increment;
            if (detail) infobox = infobox + " E1";
         } else if (val < val2) {
            points = points - increment;
            if (detail) infobox = infobox + " E0";
         }
         //iStochastic
         val = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_MAIN,1);
         val2 = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_SIGNAL,1);
         totalpoints = totalpoints + increment;
         if (val > val2) {
            points = points + increment;
            if (detail) infobox = infobox + " S1";
         } else if (val < val2) {
            points = points - increment;
            if (detail) infobox = infobox + " S0";
         }
         //parabolic
         val = iSAR(symbol,period,0.02,0.2,1);
         totalpoints = totalpoints + increment;
         if (val < iOpen(symbol, period, 1)) {
            points = points + increment;
            if (detail) infobox = infobox + " PS1";
         } else if (val > iOpen(symbol, period, 1)) {
            points = points - increment;
            if (detail) infobox = infobox + " PS0";
         }
         
         //ichimoku      
         val=iIchimoku(symbol,period, 9, 26, 52, MODE_TENKANSEN, 1);
         val2=iIchimoku(symbol,period, 9, 26, 52, MODE_KIJUNSEN, 1);
         totalpoints = totalpoints + increment;
         if (val > val2) {
            points = points + increment;
            if (detail) infobox = infobox + " TK1";
         } else if (val < val2) {
            points = points - increment;
            if (detail) infobox = infobox + " TK0";
         } 
         //span
         val = iIchimoku(symbol,period, 9, 26, 52, MODE_SENKOUSPANA, -25);
         val2 = iIchimoku(symbol,period, 9, 26, 52, MODE_SENKOUSPANB, -25);
         totalpoints = totalpoints + increment;
         if (val > val2) {
            points = points + increment;
            if (detail) infobox = infobox + " SP1";
         } else if (val < val2) {
            points = points - increment;
            if (detail) infobox = infobox + " SP0";
         } 
         //chickospan
         val = iIchimoku(symbol,period, 9, 26, 52, MODE_CHINKOUSPAN, 0+26);
         totalpoints = totalpoints + increment;
         if (val > iHigh(symbol, period, 0+26)) {
            points = points + increment;
            if (detail) infobox = infobox + " CO1";
         } else if (val < iLow(symbol, period, 0+26)) {
            points = points - increment;
            if (detail) infobox = infobox + " CO0";
         }
         //adx
         val = iADX(symbol,period,14,PRICE_CLOSE,MODE_MAIN,1);
         val2 = iADX(symbol,period,14,PRICE_CLOSE,MODE_PLUSDI,1);
         val3 = iADX(symbol,period,14,PRICE_CLOSE,MODE_MINUSDI,1);
         totalpoints = totalpoints + increment;
         if (val > 20 && val2 > val3) {
            points = points + increment;
            if (detail) infobox = infobox + " AD1";
         } else if (val > 20 && val2 < val3) {
            points = points - increment;
            if (detail) infobox = infobox + " AD0";
         }
         
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
         //Tikensen U Turn          
         val=iIchimoku(symbol,PERIOD_M15, 9, 26, 52, MODE_TENKANSEN, 1);
         val2=iIchimoku(symbol,PERIOD_M15, 9, 26, 52, MODE_TENKANSEN, 2);
         val3=iIchimoku(symbol,PERIOD_M15, 9, 26, 52, MODE_TENKANSEN, 3);
         val4=iIchimoku(symbol,PERIOD_M15, 9, 26, 52, MODE_TENKANSEN, 4);
         val5=iIchimoku(symbol,PERIOD_M15, 9, 26, 52, MODE_TENKANSEN, 5);
         //probable from sell to buy
         if (val > val2 && val2 > val3 && val3 <= val4 && val4 <= val5) {
            Alert(symbol, " TIKENSEN UTURN TO BUY, PREVIOUS SELL");
            infobox = infobox + "\nTikenSen UTURN TO BUY";
         } else if (val < val2 && val2 < val3 && val3 >= val4 && val4 >= val5) { //probable from buy to sell
            Alert(symbol, " TIKENSEN UTURN TO SELL, PREVIOUS BUY");
            infobox = infobox + "\nTikenSen UTURN TO SELL";
         } else {
            infobox = infobox + "\nNo TikenSen UTURN";
         }
         
         
         ZZ_1=iCustom(symbol,period,"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,5,3);
         ZZ_2=iCustom(symbol,period,"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,4,3);
         condition_sell = ZZ_1 > ZZ_2;
         condition_buy = ZZ_1 < ZZ_2;
         infobox = infobox + "\n Semaphore: " + ZZ_1 + "/" + ZZ_2 + " Buy: " + condition_buy + ", Sell: " + condition_sell;
         int h=0;
         int k=0;
         int l=0;
         int g = 0;
         int bidcount = 0;
         for (g=0; g<200; g++) {
            //checking range
            high = iHigh(symbol, PERIOD_H1, g);
            low = iLow(symbol, PERIOD_H1, g);
            if (MarketInfo(symbol, MODE_BID) < high && MarketInfo(symbol, MODE_BID) > low) {
               bidcount++;
            }
            //checking semafor
            ZZ_1=iCustom(symbol,PERIOD_H1,"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,5,g);
            ZZ_2=iCustom(symbol,PERIOD_H1,"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,4,g);
            condition_top = ZZ_1 > ZZ_2;
            condition_bottom = ZZ_1 < ZZ_2;
            if (condition_top) {
               range_top[h] = ZZ_1;
               //infobox = infobox + "\nTop Range " + (g) + ": " + ZZ_1;
               h++;
               l++;
            } else if (condition_bottom) {
               range_bottom[k] = ZZ_2;
               //infobox = infobox + "\nBottom Range " + (g) + ": " + ZZ_2;
               k++;
               l++;
            }
         }
         infobox = infobox + "\n\nTop Range: ";
         for (g=0; g<h; g++){
               infobox = infobox + range_top[g];
               if (
                  MarketInfo(symbol, MODE_BID) < (range_top[g] + (100 * MarketInfo(symbol, MODE_POINT)))
                  &&
                  MarketInfo(symbol, MODE_BID) > (range_top[g] - (100 * MarketInfo(symbol, MODE_POINT)))
               ) {
                  infobox = infobox + " (Position Near Top " + DoubleToStr(((MarketInfo(symbol, MODE_BID) - range_top[g]) /  MarketInfo(symbol, MODE_POINT)), 0) + ")";
               }
               infobox = infobox + ", ";
         }
         infobox = infobox + "\nBottom Range: ";
         for (g=0; g<k; g++){
               infobox = infobox + range_bottom[g];
               if (
                  MarketInfo(symbol, MODE_BID) < (range_bottom[g] + (100 * MarketInfo(symbol, MODE_POINT)))
                  &&
                  MarketInfo(symbol, MODE_BID) > (range_bottom[g] - (100 * MarketInfo(symbol, MODE_POINT)))
               ) {
                  infobox = infobox + " (Position Near Bottom " + DoubleToStr(((MarketInfo(symbol, MODE_BID) - range_bottom[g]) /  MarketInfo(symbol, MODE_POINT)), 0) + ")";
               }
               infobox = infobox + ", ";
         }
         
         
         h=0;
         k=0;
         l=0;
         g = 0;
         for (g=0; g<240; g++) {
            ZZ_1=iCustom(symbol,PERIOD_H1,"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,3,g);
            ZZ_2=iCustom(symbol,PERIOD_H1,"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,2,g);
            condition_top = ZZ_1 > ZZ_2;
            condition_bottom = ZZ_1 < ZZ_2;
            if (condition_top) {
               range_top2[h] = ZZ_1;
               //infobox = infobox + "\nTop Range " + (g) + ": " + ZZ_1;
               h++;
               l++;
            } else if (condition_bottom) {
               range_bottom2[k] = ZZ_2;
               //infobox = infobox + "\nBottom Range " + (g) + ": " + ZZ_2;
               k++;
               l++;
            }
         }
         infobox = infobox + "\n\nTop Sub Range: ";
         for (g=0; g<h; g++){
               infobox = infobox + range_top2[g];
               if (
                  MarketInfo(symbol, MODE_BID) < (range_top2[g] + (100 * MarketInfo(symbol, MODE_POINT)))
                  &&
                  MarketInfo(symbol, MODE_BID) > (range_top2[g] - (100 * MarketInfo(symbol, MODE_POINT)))
               ) {
                  infobox = infobox + " (Position Near Top " + DoubleToStr(((MarketInfo(symbol, MODE_BID) - range_top2[g]) /  MarketInfo(symbol, MODE_POINT)), 0) + ")";
               }
               infobox = infobox + ", ";
         }
         infobox = infobox + "\nBottom Sub Range: ";
         for (g=0; g<k; g++){
               infobox = infobox + range_bottom2[g];
               if (
                  MarketInfo(symbol, MODE_BID) < (range_bottom2[g] + (100 * MarketInfo(symbol, MODE_POINT)))
                  &&
                  MarketInfo(symbol, MODE_BID) > (range_bottom2[g] - (100 * MarketInfo(symbol, MODE_POINT)))
               ) {
                  infobox = infobox + " (Position Near Bottom " + DoubleToStr(((MarketInfo(symbol, MODE_BID) - range_bottom2[g]) /  MarketInfo(symbol, MODE_POINT)), 0) + ")";
               }
               infobox = infobox + ", ";
         }
         
         infobox = infobox + "\n\nCurrent Bid Count: " + bidcount + " i.e. how many times current bid has appeared in last 10 days.\n";
         pinbar = pinbar(symbol, PERIOD_H4);
         if (pinbar == 1) {
            infobox = infobox + ": Decision 4H Bar Formed";
         }
      
         engulf = engulf(symbol, PERIOD_H4);
         if (engulf == 1) {
            infobox = infobox + ": Engulf 4H";
         }
         pinbar = pinbar(symbol, PERIOD_D1);
         if (pinbar == 1) {
            infobox = infobox + ": Decision D1 Bar Formed";
         }
      
         engulf = engulf(symbol, PERIOD_D1);
         if (engulf == 1) {
            infobox = infobox + ": Engulf D1";
         }
         getallinfo();
      Comment(infobox);
      opentime = Time[0];
      }
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
   open = iOpen(symbol, timeperiod, 1);
   close = iClose(symbol, timeperiod, 1);
   high = iHigh(symbol, timeperiod, 1);
   low = iLow(symbol, timeperiod, 1);
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

int getallinfo()
{
   string mySymbol;
   double high, low, bid, ask, point, spread, digits;
      double aHigh[ARRSIZE];
      double aLow[ARRSIZE];
      double aHigh1[ARRSIZE];
      double aBid[ARRSIZE];
      double aAsk[ARRSIZE];
      double aRatio[ARRSIZE];
      double aRange[ARRSIZE];
      double aLookup[ARRSIZE];
      double aStrength[ARRSIZE];
      int z;
         int index;
         infobox = infobox + "\n\n";
         for (index=0; index<ARRSIZE; index++) {
            infobox = infobox + aPair[index] + ": " + DoubleToStr(((iHigh(aPair[index], PERIOD_D1, 0) - iLow(aPair[index], PERIOD_D1, 0)) / MarketInfo(aPair[index], MODE_POINT)), 0) + ", ";
            if (index % 7 == 0 && index > 0) infobox = infobox + "\n";
            
         RefreshRates();
         mySymbol = aPair[index];
         //infobox = infobox + "\n" + mySymbol;
         bid = MarketInfo(mySymbol, MODE_BID);
         ask = MarketInfo(mySymbol, MODE_ASK);
         point = MarketInfo(mySymbol, MODE_POINT);
         spread = MarketInfo(mySymbol, MODE_SPREAD);
         digits = MarketInfo(mySymbol, MODE_DIGITS);
         //Calculating the points:
         high = -1;
         low = -1;
         for (z=0; z<4; z++) {
            if (high == -1) {
               high = iHigh(mySymbol, PERIOD_H4, z);
            }
            if (iHigh(mySymbol, PERIOD_H4, z) > high) {
               high = iHigh(mySymbol, PERIOD_H4, z);
            }
            if (low == -1) {
               low = iLow(mySymbol, PERIOD_H4, z);
            }
            if (iLow(mySymbol, PERIOD_H4, z) < low) {
               low = iLow(mySymbol, PERIOD_H4, z);
            }
         }
         aHigh[index] = high;
         aLow[index]      = low; 
         aBid[index]      = bid;                 
         aAsk[index]      = ask;                 
         aRange[index]    = MathMax((aHigh[index]-aLow[index])/point,1);      // calculate range today  
         aRatio[index]    = (aBid[index]-aLow[index])/aRange[index]/point;     // calculate pair ratio
         aLookup[index]   = iLookup(aRatio[index]*100);                        // set a pair grade
         aStrength[index] = 9-aLookup[index];
         aBid[index]      = MarketInfo(mySymbol,MODE_BID);                 
         aAsk[index]      = MarketInfo(mySymbol,MODE_ASK);                 
         aRange[index]    = MathMax((aHigh[index]-aLow[index])/point,1);      // calculate range today  
         aRatio[index]    = (aBid[index]-aLow[index])/aRange[index]/point;     // calculate pair ratio
         aLookup[index]   = iLookup(aRatio[index]*100);                        // set a pair grade
         aStrength[index] = 9-aLookup[index];                                  // set a pair strengh
         }
         double aMeter[PAIRSIZE];
         aMeter[USD] = NormalizeDouble((aLookup[USDJPY]+aLookup[USDCHF]+aLookup[USDCAD]+aStrength[EURUSD]+aStrength[GBPUSD]+aStrength[AUDUSD]+aStrength[NZDUSD])/7,1);
   aMeter[EUR] = NormalizeDouble((aLookup[EURUSD]+aLookup[EURJPY]+aLookup[EURGBP]+aLookup[EURCHF]+aLookup[EURAUD]+aLookup[EURCAD]+aLookup[EURNZD])/7,1);
   aMeter[GBP] = NormalizeDouble((aLookup[GBPUSD]+aLookup[GBPJPY]+aLookup[GBPCHF]+aStrength[EURGBP]+aLookup[GBPCAD]+aLookup[GBPAUD]+aLookup[GBPNZD])/7,1);
   aMeter[CHF] = NormalizeDouble((aStrength[USDCHF]+aStrength[EURCHF]+aStrength[GBPCHF]+aStrength[AUDCHF]+aLookup[CHFJPY]+aStrength[CADCHF]+aStrength[NZDCHF])/7,1);
   aMeter[CAD] = NormalizeDouble((aStrength[USDCAD]+aLookup[CADCHF]+aStrength[AUDCAD]+aLookup[CADJPY]+aStrength[EURCAD]+aStrength[GBPCAD]+aStrength[NZDCAD])/7,1);
   aMeter[AUD] = NormalizeDouble((aLookup[AUDUSD]+aStrength[EURAUD]+aLookup[AUDCHF]+aLookup[AUDCAD]+aStrength[GBPAUD]+aLookup[AUDNZD]+aLookup[AUDJPY])/7,1);
   aMeter[JPY] = NormalizeDouble((aStrength[USDJPY]+aStrength[EURJPY]+aStrength[GBPJPY]+aStrength[NZDJPY]+aStrength[AUDJPY]+aStrength[CHFJPY]+aStrength[CADJPY])/7,1);     
   aMeter[NZD] = NormalizeDouble((aLookup[NZDUSD]+aStrength[EURNZD]+aStrength[GBPNZD]+aStrength[AUDNZD]+aLookup[NZDCAD]+aLookup[NZDCHF]+aLookup[NZDJPY])/7,1);
   string strength = "\n\nUSD: " + aMeter[USD] + ", EUR: " + aMeter[EUR] + "\nGBP: " + aMeter[GBP]
         + ", CHF: " + aMeter[CHF] + "\nCAD: " + aMeter[CAD] + ", AUD: " + aMeter[AUD]
          + "\nJPY: " + aMeter[JPY] + ", NZD: " + aMeter[NZD];
   infobox = infobox + strength;
}