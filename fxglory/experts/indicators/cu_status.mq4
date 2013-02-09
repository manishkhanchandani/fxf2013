//+------------------------------------------------------------------+
//|                                                   macdchange.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 Blue
#property indicator_width1 2
#property indicator_color2 Orange
#property indicator_width2 2
double CrossUp[];
double CrossDown[];

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

   //for(i = limit; i >= 0; i--) {
   i = 0;
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      val = iCCI(NULL,0,45,PRICE_CLOSE,i);
      //bids and asks
      infobox = StringConcatenate(infobox, "\nBids: ", DoubleToStr(Bid, Digits), ", Asks: ", DoubleToStr(Ask, Digits), ", Spread: ", MarketInfo(Symbol(), MODE_SPREAD));
      //MACD
      val2 = iCustom(NULL, 0, "MACD_Complete",1,i);
      val3 = iCustom(NULL, 0, "MACD_Complete",2,i);
      infobox = StringConcatenate(infobox, "\nMACD: ", DoubleToStr(val2, Digits), ", ", DoubleToStr(val3, Digits));
      if (val2 > val3) {
         infobox = StringConcatenate(infobox, ", (+)");
         cnt++;
         cntbuy++;
      } else if (val2 < val3) {
         infobox = StringConcatenate(infobox, ", (-)");
         cnt--;
         cntsell++;
      }
      //RSI
      val4 = iRSI(NULL,0,14,PRICE_CLOSE,i);
      infobox = StringConcatenate(infobox, "\nRSI: ", DoubleToStr(val4, Digits));
      if (val4 > 50) {
         infobox = StringConcatenate(infobox, ", (+)");
         cnt++;
         cntbuy++;
      } else if (val4 < 50) {
         infobox = StringConcatenate(infobox, ", (-)");
         cnt--;
         cntsell++;
      } else {
         infobox = StringConcatenate(infobox, ", (=)");
      }
      //bb
      bbupper = iBands(NULL,0,12,2,0,PRICE_CLOSE,MODE_UPPER,i);
      bblower = iBands(NULL,0,12,2,0,PRICE_CLOSE,MODE_LOWER,i);
      infobox = StringConcatenate(infobox, "\nBB Upper: ", DoubleToStr(bbupper, Digits), ", Lower: ", DoubleToStr(bblower, Digits));
      if (Bid > bbupper) {
         infobox = StringConcatenate(infobox, ", (+)");
         cnt++;
         cntbuy++;
      } else if (Bid < bblower) {
         infobox = StringConcatenate(infobox, ", (-)");
         cnt--;
         cntsell++;
      } else {
         infobox = StringConcatenate(infobox, ", (=)");
      }
      //ichimoku
      tenkan_sen_1=iIchimoku(NULL,0, 9, 26, 52, MODE_TENKANSEN, i);
      kijun_sen_1=iIchimoku(NULL,0, 9, 26, 52, MODE_KIJUNSEN, i);
      chinkouspan = iIchimoku(NULL,0, 9, 26, 52, MODE_CHINKOUSPAN, i+26);
      spanA = iIchimoku(NULL,0, 9, 26, 52, MODE_SENKOUSPANA, i);
      spanB = iIchimoku(NULL,0, 9, 26, 52, MODE_SENKOUSPANB, i);
      if (spanA > spanB) {
         spanHigh = spanA;
         spanLow = spanB;
      } else {
         spanHigh = spanB;
         spanLow = spanA;
      }
      infobox = StringConcatenate(infobox, "\nIchimoku Tenkan Cross tenkan_sen_1: ", DoubleToStr(tenkan_sen_1, Digits), ", kijun_sen_1: ", DoubleToStr(kijun_sen_1, Digits));
      if (tenkan_sen_1 > kijun_sen_1) {
         infobox = StringConcatenate(infobox, ", (+)");
         cnt++;
         cntbuy++;
      } else if (tenkan_sen_1 < kijun_sen_1) {
         infobox = StringConcatenate(infobox, ", (-)");
         cnt--;
         cntsell++;
      } else {
         infobox = StringConcatenate(infobox, ", (=)");
      }
      infobox = StringConcatenate(infobox, "\nIchimoku Kumo Breakout spanHigh: ", DoubleToStr(spanHigh, Digits), ", spanLow: ", DoubleToStr(spanLow, Digits));
      if (Bid > spanHigh) {
         infobox = StringConcatenate(infobox, ", (+)");
         cnt++;
         cntbuy++;
      } else if (Bid < spanLow) {
         infobox = StringConcatenate(infobox, ", (-)");
         cnt--;
         cntsell++;
      } else {
         infobox = StringConcatenate(infobox, ", (=)");
      }
      infobox = StringConcatenate(infobox, "\nIchimoku chinkouspan: ", DoubleToStr(chinkouspan, Digits));
      if (chinkouspan > High[i+26]) {
         infobox = StringConcatenate(infobox, ", (+)");
         cnt++;
         cntbuy++;
      } else if (chinkouspan < Low[i+26]) {
         infobox = StringConcatenate(infobox, ", (-)");
         cnt--;
         cntsell++;
      } else {
         infobox = StringConcatenate(infobox, ", (=)");
      }
      val2 = iCustom(NULL, 0, "Heiken_Ashi_Smoothed",2,i);
      val3 = iCustom(NULL, 0, "Heiken_Ashi_Smoothed",3,i);
      infobox = StringConcatenate(infobox, "\nHeiken_Ashi_Smoothed Value 3: ", DoubleToStr(val2, Digits), ",  Value 4: ", DoubleToStr(val3, Digits));
      if (val2 < val3) {
         infobox = StringConcatenate(infobox, ", (+)");
         cnt++;
         cntbuy++;
      } else if (val2 > val3) {
         infobox = StringConcatenate(infobox, ", (-)");
         cnt--;
         cntsell++;
      } else {
         infobox = StringConcatenate(infobox, ", (=)");
      }
      val4 = iCustom(NULL, 0, "Heiken_Ashi_Smoothed",2,i+1);
      val5 = iCustom(NULL, 0, "Heiken_Ashi_Smoothed",3,i+1);
      val6 = iCustom(NULL, PERIOD_H4, "Heiken_Ashi_Smoothed",2,i);
      val7 = iCustom(NULL, PERIOD_H4, "Heiken_Ashi_Smoothed",3,i);
      infobox = StringConcatenate(infobox, "\nHeiken Comparison Past Value 3: ", DoubleToStr(val4, Digits), ",  Value 4: ", DoubleToStr(val5, Digits));
      if (val2 < val3 && val4 > val5 && val6 < val7) {
         if (openTime != Time[0]) {
            Alert(Symbol(), " Buy Condition Exists");
            openTime = Time[0];
         }
         infobox = StringConcatenate(infobox, ", (+)");
         cnt++;
         cntbuy++;
      } else if (val2 > val3 && val4 < val5 && val6 > val7) {
         if (openTime != Time[0]) {
            Alert(Symbol(), " Sell Condition Exists");
            openTime = Time[0];
         }
         infobox = StringConcatenate(infobox, ", (-)");
         cnt--;
         cntsell++;
      } else {
         infobox = StringConcatenate(infobox, ", (=)");
      }
      
      val2 =ObjectGet("mml_txt10", OBJPROP_PRICE1);
      infobox = StringConcatenate(infobox, "\nRange 8/8 (mml_txt10): ", DoubleToStr(val2, Digits));
      if (Bid > val2) {
         infobox = StringConcatenate(infobox, ", (-)");
      } else {
         infobox = StringConcatenate(infobox, ", (=)");
      }
      val3 =ObjectGet("mml_txt2", OBJPROP_PRICE1);
      infobox = StringConcatenate(infobox, "\nRange 0/8 (mml_txt2): ", DoubleToStr(val3, Digits));
      if (Bid < val3) {
         infobox = StringConcatenate(infobox, ", (+)");
      } else {
         infobox = StringConcatenate(infobox, ", (=)");
      }
      infobox = StringConcatenate(infobox, "\nPast Range Calculation");
      int tmp = 0;
      for (j = i; j <= 200; j++) {
         if (Close[j] < val3) {
            tmp = 1;
            break;
         } else if (Close[j] > val2) {
            tmp = -1;
            break;
         }
      }
      if (tmp == 0) {
         val4 =ObjectGet("mml_txt9", OBJPROP_PRICE1);
         val5 =ObjectGet("mml_txt3", OBJPROP_PRICE1);
         for (j = i; j <= 200; j++) {
            if (Close[j] < val5) {
               tmp = 1;
               break;
            } else if (Close[j] > val4) {
               tmp = -1;
               break;
            }
         }
      }
      if (tmp == 1) {
         infobox = StringConcatenate(infobox, ", (+)");
      } else if (tmp == -1) {
         infobox = StringConcatenate(infobox, ", (-)");
      } else {
         infobox = StringConcatenate(infobox, ", (=)");
      }
      infobox = StringConcatenate(infobox, "\nCnt: ", cnt, ", Cntbuy: ", cntbuy, ", cntsell: ", cntsell);
      Comment(infobox);
/*
      if (
      (
         val2 < 0 && val2 < val3 && val4 < 30
      ) 
      ) {
         CrossDown[i] = High[i] + Range*0.5;
         if (VoiceAlert==true){
            Alert("BB Sell");
         }
      
      } else if (
      (
         val2 > 0 && val2 > val3 && val4 > 70
      ) 
      ) {
         CrossUp[i] = Low[i] - Range*0.5;
         if (VoiceAlert==true && (i == 1)){
            Alert("BB Buy");
         }
      } 
      */
   //}
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+