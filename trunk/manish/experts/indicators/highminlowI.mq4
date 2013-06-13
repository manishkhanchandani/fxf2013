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
//+------------------------------------------------------------------+
// -- Indicator Parameters
//+------------------------------------------------------------------+
extern string _s1 = "-----  Indicator Parameters  -------------------";
extern int pMT4_STOCH_SIGNAL_1 = 21; 
extern int pMT4_STOCH_SIGNAL_2 = 3; 
extern int pMT4_STOCH_SIGNAL_3 = 3; 
extern int pMT4_STOCH_4 = 5; 
extern int pMT4_STOCH_5 = 3; 
extern int pMT4_STOCH_6 = 3; 
extern int pMT4_STOCH_SIGNAL_7 = 21; 
extern int pMT4_STOCH_SIGNAL_8 = 3; 
extern int pMT4_STOCH_SIGNAL_9 = 3; 
extern int pMT4_STOCH_10 = 5; 
extern int pMT4_STOCH_11 = 3; 
extern int pMT4_STOCH_12 = 3; 
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
   
   for(i = 0; i <= limit; i++) {
   
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
       
      // LONG: ((StochSignal(21, 3, 3) Crosses Above Stoch(5, 3, 3)) And ((High(16) < Low(14)) Or (Open(6) > High(11))))
      bool LongEntryCondition = (((iStochastic(NULL, 0, pMT4_STOCH_SIGNAL_1, pMT4_STOCH_SIGNAL_2, pMT4_STOCH_SIGNAL_3, MODE_SMA, 0, MODE_SIGNAL, i + 1) < iStochastic(NULL, 0, pMT4_STOCH_4, pMT4_STOCH_5, pMT4_STOCH_6, MODE_SMA, 0, MODE_MAIN, i + 1)) && (iStochastic(NULL, 0, pMT4_STOCH_SIGNAL_1, pMT4_STOCH_SIGNAL_2, pMT4_STOCH_SIGNAL_3, MODE_SMA, 0, MODE_SIGNAL, i) > iStochastic(NULL, 0, pMT4_STOCH_4, pMT4_STOCH_5, pMT4_STOCH_6, MODE_SMA, 0, MODE_MAIN, i))) && ((High[i-1+16] < Low[i-1+14]) || (Open[i-1+6] > High[i-1+11])));
      // SHORT: ((StochSignal(21, 3, 3) Crosses Below Stoch(5, 3, 3)) And ((Low(16) > High(14)) Or (Open(6) < Low(11))))
      bool ShortEntryCondition = (((iStochastic(NULL, 0, pMT4_STOCH_SIGNAL_7, pMT4_STOCH_SIGNAL_8, pMT4_STOCH_SIGNAL_9, MODE_SMA, 0, MODE_SIGNAL, i + 1) > iStochastic(NULL, 0, pMT4_STOCH_10, pMT4_STOCH_11, pMT4_STOCH_12, MODE_SMA, 0, MODE_MAIN, i + 1)) && (iStochastic(NULL, 0, pMT4_STOCH_SIGNAL_7, pMT4_STOCH_SIGNAL_8, pMT4_STOCH_SIGNAL_9, MODE_SMA, 0, MODE_SIGNAL, i) < iStochastic(NULL, 0, pMT4_STOCH_10, pMT4_STOCH_11, pMT4_STOCH_12, MODE_SMA, 0, MODE_MAIN, i))) && ((Low[i-1+16] > High[i-1+14]) || (Open[i-1+6] < Low[i-1+11])));
   
      
      if (LongEntryCondition) {
         CrossUp[i] = Low[i] - Range*0.5;
      }
      else if (ShortEntryCondition) {
         CrossDown[i] = High[i] + Range*0.5;
      }
        if (SoundON==true && i==1 && CrossUp[i] > CrossDown[i] && alertTag!=Time[0]){
         Alert("EMA Cross Trend going Down on ",Symbol()," ",Period());
        alertTag = Time[0];
      }
        if (SoundON==true && i==1 && CrossUp[i] < CrossDown[i] && alertTag!=Time[0]){
       Alert("EMA Cross Trend going Up on ",Symbol()," ",Period());
        alertTag = Time[0];
        } 
  }
   return(0);
}

