//+------------------------------------------------------------------+
//|                                                        cu_pt.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property  indicator_separate_window
#property  indicator_buffers 3
#property  indicator_color1  Silver
#property  indicator_width1  2
#property  indicator_color2  Blue
#property  indicator_color3  Red

double Buffer[];
double BufferP[];
double BufferM[];
double totalpoints;
extern int showBuffer = 0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   IndicatorDigits(Digits+2);
   SetIndexBuffer(0,Buffer);
   SetIndexStyle(1,DRAW_LINE);
   IndicatorDigits(Digits+2);
   SetIndexBuffer(1,BufferP);
   SetIndexStyle(2,DRAW_LINE);
   IndicatorDigits(Digits+2);
   SetIndexBuffer(2,BufferM);
   IndicatorShortName("PointSystem("+showBuffer+")");
   SetIndexLabel(1,"Buy");
   SetIndexLabel(2,"Sell");
   SetIndexDrawBegin(0,0);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//---- macd counted in the 1-st additional buffer
   for(int i=0; i<limit; i++) {
      Buffer[i]=get_point_system(Symbol(), Period(), i);
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

double get_point_system(string symbol, int period, int mode)
{
   double points = 0;
   double pointsP = 0;
   double pointsM = 0;
   totalpoints = 0;
   double increment = 1;
   double high = -1;
      double low = -1;
      double bid = MarketInfo(symbol, MODE_BID);
      double ask = MarketInfo(symbol, MODE_ASK);
      double pt = MarketInfo(symbol, MODE_POINT);
      double val, val2, val3, val4, val5, val6;
      string tmp;
      double h1,h2,h3,h4;
      int z;
      int number = get_number(period);
      for (z=mode; z<number; z++) {
         if (high == -1) {
            high = iHigh(symbol, period, z);
         }
         if (iHigh(symbol, period, z) > high) {
            high = iHigh(symbol, period, z);
         }
         if (low == -1) {
            low = iLow(symbol, period, z);
         }
         if (iLow(symbol, period, z) < low) {
            low = iLow(symbol, period, z);
         }
      }
      double aRange    = MathMax((high-low)/pt,1); 
      double aRatio    = (bid-low)/aRange/pt;
      double aLookup   = iLookup(aRatio*100); 
      double aStrength = 9-aLookup;
      totalpoints = totalpoints + increment;
      if (aLookup > aStrength) {
         points = points + increment;
         pointsP = pointsP + (increment * 1);
      } else if (aLookup < aStrength) {
         points = points - increment;
         pointsM = pointsM - (increment * 1);
      }
      //heiken
         h1 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,mode);
         h2 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,mode);
         h3 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,mode+1);
         h4 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,mode+1);
         totalpoints = totalpoints + increment;
         if (h1 < h2) {
            points = points + increment;
            pointsP = pointsP + (increment * 2);
         } else if (h1 > h2) {
            points = points - increment;
            pointsM = pointsM - (increment * 2);
         }
         
         val = iRSI(symbol, period,7,PRICE_CLOSE,mode);
         val2 = iRSI(symbol, period,7,PRICE_CLOSE,mode+1);
         totalpoints = totalpoints + increment;
         if (val > 70) {
            points = points + increment;
            pointsP = pointsP + (increment * 3);
         } else if (val < 30) {
            points = points - increment;
         pointsM = pointsM - (increment * 3);
         } 
         
         //macd
         val2 = iCustom(symbol, period, "MACD_Complete",1,mode);
         val3 = iCustom(symbol, period, "MACD_Complete",2,mode);
         val4 = iCustom(symbol, period, "MACD_Complete",1,mode+1);
         val5 = iCustom(symbol, period, "MACD_Complete",2,mode+1);
         totalpoints = totalpoints + increment;
         if (val2 > val3) {
            points = points + increment;
            pointsP = pointsP + (increment * 4);
         } else if (val2 < val3) {
            points = points - increment;
         pointsM = pointsM - (increment * 4);
         } 
         
         //ema
         val = iMA(symbol,period,17,0,MODE_EMA,PRICE_CLOSE,mode);
         val2 = iMA(symbol,period,43,0,MODE_EMA,PRICE_CLOSE,mode);
         totalpoints = totalpoints + increment;
         if (val > val2) {
            points = points + increment;
            pointsP = pointsP + (increment * 5);
         } else if (val < val2) {
            points = points - increment;
         pointsM = pointsM - (increment * 5);
         }
         
         //iStochastic
         val = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_MAIN,mode);
         val2 = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_SIGNAL,mode);
         totalpoints = totalpoints + increment;
         if (val > val2) {
            points = points + increment;
            pointsP = pointsP + (increment * 6);
         } else if (val < val2) {
            points = points - increment;
         pointsM = pointsM - (increment * 6);
         }
         //parabolic
         val = iSAR(symbol,period,0.02,0.2,mode);
         totalpoints = totalpoints + increment;
         if (val < iOpen(symbol, period, mode)) {
            points = points + increment;
            pointsP = pointsP + (increment * 7);
         } else if (val > iOpen(symbol, period, mode)) {
            points = points - increment;
         pointsM = pointsM - (increment * 7);
         }
         
         //ichimoku      
         val=iIchimoku(symbol,period, 9, 26, 52, MODE_TENKANSEN, mode);
         val2=iIchimoku(symbol,period, 9, 26, 52, MODE_KIJUNSEN, mode);
         totalpoints = totalpoints + increment;
         if (val > val2) {
            points = points + increment;
            pointsP = pointsP + (increment * 8);
         } else if (val < val2) {
            points = points - increment;
         pointsM = pointsM - (increment * 8);
         } 
         
         //adx
         val = iADX(symbol,period,14,PRICE_CLOSE,MODE_MAIN,mode);
         val2 = iADX(symbol,period,14,PRICE_CLOSE,MODE_PLUSDI,mode);
         val3 = iADX(symbol,period,14,PRICE_CLOSE,MODE_MINUSDI,mode);
         totalpoints = totalpoints + increment;
         if (val > 20 && val2 > val3) {
            points = points + increment;
            pointsP = pointsP + (increment * 9);
         } else if (val > 20 && val2 < val3) {
            points = points - increment;
         pointsM = pointsM - (increment * 9);
         }
         if (showBuffer == 1) {
         BufferP[mode]=pointsP;
         BufferM[mode]=pointsM;
         }
    return (points);
}



int get_number(int P)
{
   switch(P)
   {
      case PERIOD_M1:  return(101);
      case PERIOD_M5:  return(76);
      case PERIOD_M15: return(51);
      case PERIOD_M30: return(25);
      case PERIOD_H1:  return(13);
      case PERIOD_H4:  return(4);
      case PERIOD_D1:  return(4);
      case PERIOD_W1:  return(4);
      case PERIOD_MN1: return(4);
      case 0: return (4);
   }
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