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
   double val, val2, spanA, spanB, spanAb, spanBb;
   int intval1, intval2, j;
   bool condition_buy, condition_sell;
   for(i = limit; i >= 1; i--) {
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      val = iCCI(NULL,0,45,PRICE_CLOSE,i);
      val2 = iCCI(NULL,0,45,PRICE_CLOSE,i+1);
      intval1 = 0;
      
               spanA = iIchimoku(NULL,0, 9, 26, 52, MODE_SENKOUSPANA, i-26);
               spanB = iIchimoku(NULL,0, 9, 26, 52, MODE_SENKOUSPANB, i-26);
               condition_buy = (
                  spanA > spanB
                  );
               condition_sell = (
                  spanA < spanB
                  );
                  if (condition_buy) intval1 = 1;
                  else if (condition_sell) intval1 = -1;
      
      if (val > 110 && val2 < 110 && intval1 == 1) {
         CrossUp[i] = Low[i] - Range*0.5;
         if (VoiceAlert==true && (i == 1)){
            Alert("MACD has crossed up");
         }
      } else if (val < -110 && val2 > -110 && intval1 == -1) {
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