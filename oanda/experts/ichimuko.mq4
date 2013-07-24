//+------------------------------------------------------------------+
//|                                                     ichimuko.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

int points[28];
double score[28][2];
#include <3_signal_inc.mqh>
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   if (opentime != iTime(Symbol(), Period(), 0)) {
      infobox = "";
      string symbol;
      int period = Period();
      int shift = 1;
      
      //int periods[7] = {PERIOD_D1, PERIOD_H4, PERIOD_H1, PERIOD_M30, PERIOD_M15, PERIOD_M5, PERIOD_M1};
      for (int x = 0; x < ARRSIZE; x++) {
         symbol = aPair[x];
         double close = iClose(symbol, period, shift);
         double tenkan_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_TENKANSEN, shift);
         double kijun_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, shift);
         double tenkan_sen_2=iIchimoku(symbol, period, 9, 26, 52, MODE_TENKANSEN, shift+1);
         double kijun_sen_2=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, shift+1);
         double spanA_1=iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANA, shift);
         double spanB_1=iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANB, shift);
         //check for Close
         if (tenkan_sen_1 < kijun_sen_1 && tenkan_sen_1 > close && score[x][1] > 0) {
            //close buy
            points[x] = points[x] + (MarketInfo(symbol, MODE_BID) - score[x][1]) / MarketInfo(symbol, MODE_POINT);
            score[x][1] = 0;
         } else if (tenkan_sen_1 > kijun_sen_1 && tenkan_sen_1 < close && score[x][2] > 0) {
            //close sell
            points[x] = points[x] + (score[x][2] - MarketInfo(symbol, MODE_ASK)) / MarketInfo(symbol, MODE_POINT);
            score[x][2] = 0;
         }
         //check for Open
         if (tenkan_sen_1 > kijun_sen_1 && tenkan_sen_2 < kijun_sen_2 && tenkan_sen_1 < close && score[x][1] == 0) {
            //open buy
            score[x][1] = MarketInfo(symbol, MODE_ASK);
         } else if (tenkan_sen_1 < kijun_sen_1 && tenkan_sen_2 > kijun_sen_2 && tenkan_sen_1 > close && score[x][2] == 0) {
            //open sell
            score[x][2] = MarketInfo(symbol, MODE_BID);
         }
         infobox = infobox + "\nSymbol: " + symbol + ", Score B: " + score[x][1] + ", Score S: " + score[x][2]
         + ", Points: " + points[x];
      } 
      Comment(infobox);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+