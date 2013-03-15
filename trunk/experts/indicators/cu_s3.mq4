//+------------------------------------------------------------------+
//|                                                   macdchange.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 White
#property indicator_width1 2
#property indicator_color2 White
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
int start()
  {
   int limit, i, counter;
   double Range, AvgRange;
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;

   limit=Bars-counted_bars;
   double val, val2, val3, val4, val5, val6, val7, val8, val9;
   double bbupper, bblower;
   int intval1, intval2, j;
   bool condition_buy, condition_sell;
   for(i = 200; i >= 0; i--) {
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      
      val2 = iCustom(NULL, 0, "Heiken_Ashi_Smoothed",2,i);
      val3 = iCustom(NULL, 0, "Heiken_Ashi_Smoothed",3,i);
      val4 = iCustom(NULL, 0, "Heiken_Ashi_Smoothed",2,i+1);
      val5 = iCustom(NULL, 0, "Heiken_Ashi_Smoothed",3,i+1);
      if (val2 < val3 && val4 > val5) {
         CrossUp[i] = Low[i] - Range*0.5;
      } else if (val2 > val3 && val4 < val5) {
         CrossDown[i] = High[i] + Range*0.5;
      }      
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+