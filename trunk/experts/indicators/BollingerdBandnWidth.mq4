//+------------------------------------------------------------------+
//|                                                      BB_Diff.mq4 |
//|                                       Copyright © 2006, Akuma99. |
//|                                    http://www.beginnertrader.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, Akuma99."
#property link      "http://www.beginnertrader.com"

#property indicator_separate_window
#property indicator_color1 Red

extern double bbPeriod=20;
extern double bbDev=2.0;
extern string displayText="Bollinger Band Difference:";

double bbw[];

int init() {

   SetIndexStyle(0,DRAW_LINE,EMPTY,1,Red);
   SetIndexBuffer(0,bbw);
   
   return(0);

}

int start() {

   int    counted_bars=IndicatorCounted();
   
   double upperBand,lowerBand,bandDifference;

   int   limit = Bars-counted_bars;
   int   i;
   
   for (i=limit; i>=0; i--) {
   
      upperBand = iBands(NULL,0,bbPeriod,bbDev,0,PRICE_CLOSE,MODE_UPPER,i);
      lowerBand = iBands(NULL,0,bbPeriod,bbDev,0,PRICE_CLOSE,MODE_LOWER,i);
      
      bandDifference = upperBand-lowerBand;
   
      bbw[i] = bandDifference;
      
   }
   
   Comment("\n",displayText," ", bandDifference, " (", bandDifference/Point," Pips)");
   
   return(0);

}

