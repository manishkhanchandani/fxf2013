//+------------------------------------------------------------------+
//|                                                     nw_grade.mq4 |
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

//---- indicator parameters
extern int number = 6;
//---- indicator buffers
double     HistBuffer[];
double     LookupBuffer[];
double     StrengthBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(3);
//---- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexDrawBegin(0,0);
   IndicatorDigits(Digits+2);
   SetIndexStyle(1,DRAW_LINE);
   IndicatorDigits(Digits+2);
   SetIndexStyle(2,DRAW_LINE);
   IndicatorDigits(Digits+2);

//---- 3 indicator buffers mapping
   SetIndexBuffer(0,HistBuffer);
   SetIndexBuffer(1,LookupBuffer);
   SetIndexBuffer(2,StrengthBuffer);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("Grade " + number);
   SetIndexLabel(1,"Lookup");
   SetIndexLabel(2,"Strength");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Moving Average of Oscillator                                     |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();
   double high = -1;
   double low = -1;
   string symbol = Symbol();
   int period = Period();
   int z;
   double aRange;
   double aRatio;
   double aLookup;
   double aStrength;

//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//---- macd counted in the 1-st additional buffer
   for(int i=0; i<limit; i++) {
      high = -1;
      low = -1;
      for (z=i; z<(i+number); z++) {
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
      aRange    = MathMax((high-low)/Point,1); 
      aRatio    = (Bid-low)/aRange/Point;
      aLookup   = iLookup(aRatio*100); 
      aStrength = 9-aLookup;
      LookupBuffer[i]=aLookup * 10;
      StrengthBuffer[i]=aStrength * 10;
         HistBuffer[i]=0;
      /*if (aLookup > aStrength) {
         HistBuffer[i]=LookupBuffer[i];
      } else if (aLookup < aStrength) {
         HistBuffer[i]=StrengthBuffer[i];
      } else {
         HistBuffer[i]=0;
      }*/
      
   }
//---- done
   return(0);
  }
//+------------------------------------------------------------------+



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