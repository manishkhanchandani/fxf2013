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
   SetIndexLabel(0,"Buy");
   SetIndexLabel(1,"Sell");
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
   double tenkan_sen_1, tenkan_sen_2, tenkan_sen_3, tenkan_sen_4, kijun_sen_1, kijun_sen_2, kijun_sen_3, kijun_sen_4, spanA, spanB, chinkouspan, spanHigh, spanLow, spanHigh2, spanLow2;
   bool condition_buy, condition_sell, condition_buy2, condition_sell2, condition_buy3, condition_sell3;
   double adx, dip, dim;
   for(i = 0; i <= limit; i++) {
   
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      tenkan_sen_1=iIchimoku(NULL, 0, 9, 26, 52, MODE_TENKANSEN, i);
      tenkan_sen_2=iIchimoku(NULL, 0, 9, 26, 52, MODE_TENKANSEN, i+1);
      //tenkan_sen_3=iIchimoku(NULL, 0, 9, 26, 52, MODE_TENKANSEN, i+2);
      //tenkan_sen_4=iIchimoku(NULL, 0, 9, 26, 52, MODE_TENKANSEN, i+3);
      kijun_sen_1=iIchimoku(NULL, 0, 9, 26, 52, MODE_KIJUNSEN, i);
      kijun_sen_2=iIchimoku(NULL, 0, 9, 26, 52, MODE_KIJUNSEN, i+1);
      //kijun_sen_3=iIchimoku(NULL, 0, 9, 26, 52, MODE_KIJUNSEN, i+2);
      //kijun_sen_4=iIchimoku(NULL, 0, 9, 26, 52, MODE_KIJUNSEN, i+3);
      chinkouspan = iIchimoku(NULL, 0, 9, 26, 52, MODE_CHINKOUSPAN, i+26);
      spanA = iIchimoku(NULL, 0, 9, 26, 52, MODE_SENKOUSPANA, i);
      spanB = iIchimoku(NULL, 0, 9, 26, 52, MODE_SENKOUSPANB, i);
      if (spanA > spanB) {
         spanHigh = spanA;
         spanLow = spanB;
         spanHigh2 = iIchimoku(NULL, 0, 9, 26, 52, MODE_SENKOUSPANA, i+1);
         spanLow2 = iIchimoku(NULL, 0, 9, 26, 52, MODE_SENKOUSPANB, i+1);
      } else {
         spanHigh = spanB;
         spanLow = spanA;
         spanHigh2 = iIchimoku(NULL, 0, 9, 26, 52, MODE_SENKOUSPANB, i+1);
         spanLow2 = iIchimoku(NULL, 0, 9, 26, 52, MODE_SENKOUSPANA, i+1);
      }
      adx = iADX(NULL,0,14,PRICE_CLOSE,MODE_MAIN,i);
      dip = iADX(NULL,0,14,PRICE_CLOSE,MODE_PLUSDI,i);
      dim = iADX(NULL,0,14,PRICE_CLOSE,MODE_MINUSDI,i);
      condition_buy = false;
      condition_sell = false;
      condition_buy2 = false;
      condition_sell2 = false;
      condition_buy3 = false;
      condition_sell3 = false;
      condition_buy = (Close[i] > spanHigh && Open[i] < spanHigh && dip > dim && spanHigh != spanHigh2);// 
      condition_sell = (Close[i] < spanLow && Open[i] > spanLow && dip < dim && spanLow != spanLow2);// 
      condition_buy2 = (tenkan_sen_1 > kijun_sen_1 && tenkan_sen_2 < kijun_sen_2 && dip > dim);
      condition_sell2 = (tenkan_sen_1 < kijun_sen_1 && tenkan_sen_2 > kijun_sen_2 && dip < dim);
      //condition_buy3 = (kijun_sen_1 < Close[i] && kijun_sen_1 > Open[i] && dip > dim);
      //condition_sell3 = (kijun_sen_1 > Close[i] && kijun_sen_1 < Open[i] && dip < dim);
      if (
      condition_buy || condition_buy2 || condition_buy3
      ) {
         CrossUp[i] = Close[i]; //Low[i] - Range*0.5;
      }
      else if (
      condition_sell || condition_sell2 || condition_sell3
      ) {
          CrossDown[i] = Close[i]; //High[i] + Range*0.5;
      }
        if (SoundON==true && i==1 && CrossUp[i] > CrossDown[i] && alertTag!=Time[0]){
         Alert("Trend going Down on ",Symbol()," ",Period());
        alertTag = Time[0];
      }
        if (SoundON==true && i==1 && CrossUp[i] < CrossDown[i] && alertTag!=Time[0]){
       Alert("Trend going Up on ",Symbol()," ",Period());
        alertTag = Time[0];
        } 
  }
   return(0);
}

