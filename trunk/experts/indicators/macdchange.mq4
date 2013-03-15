//+------------------------------------------------------------------+
//|                                                   macdchange.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_width1 2
#property indicator_color2 Orange
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
   double imacd, imacd2;
   for(i = 200; i >= 1; i--) {
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      imacd = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,i);
      imacd2 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,i+1);
      if (imacd > 0 && imacd2 < 0) {
         CrossUp[i] = Low[i] - Range*0.5;
         if (VoiceAlert==true && (i == 1)){
            Alert("MACD has crossed up");
         }
      } else if (imacd < 0 && imacd2 > 0) {
         CrossDown[i] = High[i] + Range*0.5;
         if (VoiceAlert==true){
            Alert("MACD has crossed down");
         }
      }
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+