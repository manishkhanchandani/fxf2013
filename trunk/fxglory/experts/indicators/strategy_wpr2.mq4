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
#property indicator_color1 LawnGreen
#property indicator_width1 2
#property indicator_color2 Red
#property indicator_width2 2

double CrossUp[];
double CrossDown[];
extern bool VoiceAlert = false;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
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
   int l, r, w, g, ran;
   double down, up;
   int position = 0;
   for(i = 0; i <= limit; i++) {
   
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
       l = get_trend(Symbol(), Period(), i);
       
       down = gold_rsioma_down(Symbol(), Period(), i);
         up = gold_rsioma_up(Symbol(), Period(), i);
         if (down == EMPTY_VALUE && up > 0) {
            r = 1;
         } else if (up == EMPTY_VALUE && down < 0) {
            r = -1; 
         }
         ran = gold_william_percent_range(Symbol(), Period(), i);
         if (ran < -75) {
            w = -1;
         } else if (ran > -25) {
            w = 1;
         }
         
         if (l == 1 && r == 1 && w == 1) {
            CrossUp[i] = Low[i] - Range*0.5;
            if (VoiceAlert==true){
               Alert("Buy for symbol: ", Symbol());
            }
         }
         else if (l == -1 && r == -1 && w == -1) {
            CrossDown[i] = High[i] + Range*0.5;
            if (VoiceAlert==true){
               Alert("Sell for symbol: ", Symbol());
            }
         }
   }
   return(0);
}


double gold_rsioma_down(string symbol, int timeframe, int shift)
{
   double L_1;
   L_1 = iCustom(symbol, timeframe, "RSIOMA_v3", 1, shift);
   return (L_1);
}
double gold_rsioma_up(string symbol, int timeframe, int shift)
{
   double L_1;
   L_1 = iCustom(symbol, timeframe, "RSIOMA_v3", 2, shift);
   return (L_1);
}

double gold_william_percent_range(string symbol, int timeframe, int shift)
{
   double L_1;
   L_1 = iCustom(symbol, timeframe, "WPR", 55, 0, shift);
   return (L_1);
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

int get_trend(string symbol, int timeframe, int shift)
{
   int trend = 0;
   double sell = gold_sell_zone_fibs(symbol, timeframe, shift);
   double buy = gold_buy_zone_fibs(symbol, timeframe, shift);
   if (Bid < buy) {
      trend = -1;
   } else if (Ask > sell) { //Ask
      trend = 1;
   }
   return (trend);
}

/*
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
}*/