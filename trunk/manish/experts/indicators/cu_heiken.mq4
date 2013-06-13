//+------------------------------------------------------------------+
//|                                                   macdchange.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 White
#property indicator_width1 2
#property indicator_color2 White
#property indicator_width2 2
#property indicator_width3 2
double CrossUp[];
double CrossDown[];
double check[];

extern bool VoiceAlert = false;
   double openTime;
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
   SetIndexStyle(2, DRAW_NONE, EMPTY);
   SetIndexBuffer(2, check);
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
   int limit, i, counter, cntbuy, cntsell, cnt;
   double Range, AvgRange;
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;

   limit=Bars-counted_bars;
   double val, val2, val3, val4, val5, val6, val7, val8, val9;
   bool condition_buy, condition_sell;
   string infobox;
   int      shift;
    datetime some_time;
   for(i = limit; i >= 1; i--) {
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      
      val2 = iCustom(NULL, PERIOD_H1, "Heiken_Ashi_Smoothed",2,i);
      val3 = iCustom(NULL, PERIOD_H1, "Heiken_Ashi_Smoothed",3,i);
      val4 = iCustom(NULL, PERIOD_H1, "Heiken_Ashi_Smoothed",2,i+1);
      val5 = iCustom(NULL, PERIOD_H1, "Heiken_Ashi_Smoothed",3,i+1);
      
      some_time=StrToTime(TimeToStr(Time[i]));
      shift=iBarShift(NULL,PERIOD_H4,some_time);
      val6 = iCustom(NULL, PERIOD_H4, "Heiken_Ashi_Smoothed",2,shift);
      val7 = iCustom(NULL, PERIOD_H4, "Heiken_Ashi_Smoothed",3,shift);
      val8 = iCustom(NULL, PERIOD_H4, "Heiken_Ashi_Smoothed",2,shift+1);
      val9 = iCustom(NULL, PERIOD_H4, "Heiken_Ashi_Smoothed",3,shift+1);
      check[i] = shift;
      
      if ((val2 < val3 && val4 > val5 && val6 < val7) || (val6 < val7 && val8 > val9 )) {
         CrossUp[i] = Low[i] - Range*0.5;
      } else if ((val2 > val3 && val4 < val5 && val6 > val7) || (val6 > val7 && val8 < val9 )) {
         CrossDown[i] = High[i] + Range*0.5;
      }
      }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+