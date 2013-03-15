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
   double bbupper, bblower;
   int intval1, intval2, j;
   bool condition_buy, condition_sell;
   string infobox;
   double tenkan_sen_1, tenkan_sen_2, tenkan_sen_3, tenkan_sen_4, kijun_sen_1, kijun_sen_2, kijun_sen_3, kijun_sen_4, spanA, spanB, chinkouspan, spanHigh, spanLow, spanHigh2, spanLow2, spanAb, spanBb, spanAc, spanBc, spanAd, spanBd;
   double bbupper2, bblower2;
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
      //RSI
      val6 = iRSI(NULL,0,14,PRICE_CLOSE,i);
      //MACD
      val2 = iCustom(NULL, 0, "MACD_Complete",1,i);
      val3 = iCustom(NULL, 0, "MACD_Complete",2,i);
      bbupper = iBands(NULL,0,12,2,0,PRICE_CLOSE,MODE_UPPER,i);
      bblower = iBands(NULL,0,12,2,0,PRICE_CLOSE,MODE_LOWER,i);
      bbupper2 = iBands(NULL,0,12,2,0,PRICE_CLOSE,MODE_UPPER,i+1);
      bblower2 = iBands(NULL,0,12,2,0,PRICE_CLOSE,MODE_LOWER,i+1);
      
      val4 = iCustom(NULL, 0, "Heiken_Ashi_Smoothed",2,i);
      val5 = iCustom(NULL, 0, "Heiken_Ashi_Smoothed",3,i);
      //if (i == 64) {
         //condition_buy = (val6 > 50);
         //Alert(condition_buy);
      //}
      check[i] = i;
      if (val2 > val3 && High[i] > bbupper && High[i+1] < bbupper2 && val4 < val5) {
         CrossUp[i] = Low[i] - Range*0.5;
         if (VoiceAlert==true && (i == 1)){
            Alert("BB Buy");
         }
      } else if (val2 < val3 && Low[i] < bblower && Low[i+1] > bblower2 && val4 > val5) {
         CrossDown[i] = High[i] + Range*0.5;
         if (VoiceAlert==true){
            Alert("BB Sell");
         }
      }
      }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+