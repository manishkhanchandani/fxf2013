//+------------------------------------------------------------------+
//|                                         EMA-Crossover_Signal.mq4 |
//|         Copyright © 2005, Jason Robinson (jnrtrading)            |
//|                   http://www.jnrtading.co.uk                     |
//+------------------------------------------------------------------+

/*
  +------------------------------------------------------------------+
  | Allows you to enter two ema periods and it will then show you at |
  | Which point they crossed over. It is more usful on the shorter   |
  | periods that get obscured by the bars / candlesticks and when    |
  | the zoom level is out. Also allows you then to remove the emas   |
  | from the chart. (emas are initially set at 5 and 6)              |
  +------------------------------------------------------------------+
*/   
#property copyright "Copyright © 2005, Jason Robinson (jnrtrading)"
#property link      "http://www.jnrtrading.co.uk"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 SeaGreen
#property indicator_color2 Red

double CrossUp[];
double CrossDown[];
extern int FasterEMA = 4;
extern int SlowerEMA = 8;
extern bool SoundON=true;
double alertTag;
 double control=2147483647;
 
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_ARROW, EMPTY,3);
   SetIndexArrow(0, 233);
   SetIndexBuffer(0, CrossUp);
   SetIndexStyle(1, DRAW_ARROW, EMPTY,3);
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

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start() {
   int limit, i, counter;
   double Range, AvgRange;
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;

   limit=Bars-counted_bars;
    int      FiboNumPeriod  = 11;//  Numbers in the following integer sequence;
 int      nAppliedPrice  = 0;//   PRICE_CLOSE=0; PRICE_OPEN=1; PRICE_HIGH=2; PRICE_LOW=3; PRICE_MEDIAN=4; PRICE_TYPICAL=5; PRICE_WEIGHTED=6;
 int      maPeriod       = 21;//  Averaging period for calculation;
 int      maMethod       = 2;//   MODE_SMA=0; MODE_EMA=1; MODE_SMMA=2; MODE_LWMA=3;
   for(i = 0; i <= limit; i++) {
   
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      double rm00 = iCustom(NULL, 0, "Fibo-Average-2B", FiboNumPeriod, nAppliedPrice, maPeriod, maMethod, 0, i);
      double rm01 = iCustom(NULL, 0, "Fibo-Average-2B", FiboNumPeriod, nAppliedPrice, maPeriod, maMethod, 0, i+1);
      double rm10 = iCustom(NULL, 0, "Fibo-Average-2B", FiboNumPeriod, nAppliedPrice, maPeriod, maMethod, 1, i);
      double rm11 = iCustom(NULL, 0, "Fibo-Average-2B", FiboNumPeriod, nAppliedPrice, maPeriod, maMethod, 1, i+1);
   
      if(rm01 < rm11 && rm00 > rm10) {
         CrossUp[i] = Low[i] - Range*0.5;
      }
      else if(rm01 > rm11 && rm00 < rm10) {
         CrossDown[i] = High[i] + Range*0.5;
      }
  }
   return(0);
}

