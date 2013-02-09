//+------------------------------------------------------------------+
//|                                                  101_master1.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"
#define MAGICMA  19740605101

extern bool logsi = true;
extern bool logsi2 = true;
int stime;
#include <indicators.mqh>

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   stime = TimeLocal();
    custom_start(1);
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
   custom_start(1);
//----
   return(0);
  }
//+------------------------------------------------------------------+

void custom_start(int num)
{
   int counter = 0;
   int buys = 0;
   int sells = 0;
   int result = 0;
   double digit_change = digitcheck(Digits);
   string infobox;
   infobox = "\n\n";
   //A. Account Information
   //B. ask and bid price
   //C. Indicators 
      infobox = StringConcatenate(infobox, "Number: ", num, "\n");
      //momentum
      result = ind_momentum(num, Symbol(), Period());
      counter = counter + result;
      if (result > 0) buys++;
      else if (result < 0) sells++;
      infobox = StringConcatenate(infobox, "Momentum: ", convertbuysell(result), "\n");
      //Ichimoku
      ichimoku(num, Symbol(), Period());
      infobox = StringConcatenate(infobox, "Ichimoku: ", "");
      infobox = StringConcatenate(infobox, "tenkan_sen: ", ichimoku[0][num], ", ");
      infobox = StringConcatenate(infobox, "kijun_sen: ", ichimoku[1][num], ", ");
      infobox = StringConcatenate(infobox, "senkou_span_a: ", ichimoku[2][num], ", ");
      infobox = StringConcatenate(infobox, "senkou_span_b: ", ichimoku[3][num], ", ");
      infobox = StringConcatenate(infobox, "senkou_span_high: ", ichimoku[4][num], ", ");
      infobox = StringConcatenate(infobox, "senkou_span_low: ", ichimoku[5][num], ", ");
      infobox = StringConcatenate(infobox, "chinkou_span: ", ichimoku[6][num], ", ");
      infobox = StringConcatenate(infobox, "chinkou_span_mode: ", ichimoku[7][num], "\n");
      //Kumo breakout
      result = kumo_breakout(num);
      counter = counter + result;
      if (result > 0) buys++;
      else if (result < 0) sells++;
      infobox = StringConcatenate(infobox, "Kumo Breakout: ", convertbuysell(result), "\n");
      //Tijun Cross
      result = tijun_cross_kijun(num);
      counter = counter + result;
      if (result > 0) buys++;
      else if (result < 0) sells++;
      infobox = StringConcatenate(infobox, "tijun_cross_kijun: ", convertbuysell(result), "\n");
      //kijun_sen_cross
      result = kijun_sen_cross(num);
      counter = counter + result;
      if (result > 0) buys++;
      else if (result < 0) sells++;
      infobox = StringConcatenate(infobox, "kijun_sen_cross: ", convertbuysell(result), "\n");
      //Alligator
      result = alligator(num, Symbol(), Period());
      counter = counter + result;
      if (result > 0) buys++;
      else if (result < 0) sells++;
      infobox = StringConcatenate(infobox, "Alligator: ", convertbuysell(result), "\n");
      //Bollinger Band
      result = bollingerbands(num, Symbol(), Period());
      counter = counter + result;
      if (result > 0) buys++;
      else if (result < 0) sells++;
      infobox = StringConcatenate(infobox, bollingerband, "\nBollinger Band: ", convertbuysell(result), "\n");
      
      //BOLLINGER BAND ANALYSIS
      infobox = StringConcatenate(infobox, "\n\nBollinger Band Upper: ", DoubleToStr(bollingerbandupper, Digits));
      infobox = StringConcatenate(infobox, "\nBollinger Band Lower: ", DoubleToStr(bollingerbandlower, Digits));
      infobox = StringConcatenate(infobox, "\nBollinger Band Difference: ", DoubleToStr((bollingerbandupper - bollingerbandlower), Digits));
      
      bollingerbandpast(num, Symbol(), Period());
      double diff = bollingerbandupper - bollingerbandlower;
      infobox = StringConcatenate(infobox, "\nCurrent Diff: ", DoubleToStr(diff, Digits));
      infobox = StringConcatenate(infobox, "\nMax Diff: ", DoubleToStr(bollingerbandlocal[0], Digits));
      infobox = StringConcatenate(infobox, "\nMin Diff: ", DoubleToStr(bollingerbandlocal[1], Digits));
      if (diff < (bollingerbandlocal[1] + digit_change)) {
         double ma = double iMA(Symbol(), Period(), 20, 0, MODE_SMA, PRICE_CLOSE, num);
         if (Open[num] < Close[num] && ma < Open[num]) {
            if (logsi2) Alert(Symbol(), ", ", TimeframeToString(Period()), ", Possible2 Buy");
            infobox = StringConcatenate(infobox, "\nPossible 2 Buy");
         } else if (Open[num] > Close[num] && ma > Open[num]) {
            if (logsi2) Alert(Symbol(), ", ", TimeframeToString(Period()), ", Possible2 Sell");
            infobox = StringConcatenate(infobox, "\nPossible 2 Sell");
         }
         if (ichimoku[0][1] > ichimoku[1][1]) {
            if (logsi2) Alert(Symbol(), ", ", TimeframeToString(Period()), ", Possible Buy");
            infobox = StringConcatenate(infobox, "\nPossible Buy");
         } else {
            if (logsi2) Alert(Symbol(), ", ", TimeframeToString(Period()), ", Possible Sell");
            infobox = StringConcatenate(infobox, "\nPossible Sell");
         }
         /*Alert(Symbol(), ", ", TimeframeToString(Period()), ", ", ichimoku[0][1], " - ", ichimoku[1][1], ", Possible Change in Price: Max: ", DoubleToStr(bollingerbandlocal[0], Digits), " - Min: "
         , DoubleToStr(bollingerbandlocal[1], Digits), " - Diff: "
         , DoubleToStr(diff, Digits), " - (Min + 20): ", DoubleToStr((bollingerbandlocal[1] + digit_change), Digits));*/
         infobox = StringConcatenate(infobox, "\nPossible Change in Price: Max: ", DoubleToStr(bollingerbandlocal[0], Digits), " - Min: "
         , DoubleToStr(bollingerbandlocal[1], Digits), " - Diff: "
         , DoubleToStr(diff, Digits), " - (Min + 20): ", DoubleToStr((bollingerbandlocal[1] + digit_change), Digits));
      } else {
         infobox = StringConcatenate(infobox, "\nNo Change in Price: Max: ", DoubleToStr(bollingerbandlocal[0], Digits), " - Min: "
         , DoubleToStr(bollingerbandlocal[1], Digits), " - Diff: "
         , DoubleToStr(diff, Digits), " - (Min + 20): ", DoubleToStr((bollingerbandlocal[1] + digit_change), Digits));
      }

     // bollingerbands(num, Symbol(), PERIOD_M1);
     // bollingerbands(num, Symbol(), PERIOD_M5);
      //bollingerbands(num, Symbol(), PERIOD_M15);
      //bollingerbands(num, Symbol(), PERIOD_M30);
      //bollingerbands(num, Symbol(), PERIOD_H1);
      //bollingerbands(num, Symbol(), PERIOD_H4);
      
   
   infobox = StringConcatenate(infobox, "\nBuys: ", buys, "\n", "Sells: ", sells, "\n");
   Comment(infobox);
      
}

string convertbuysell(int val)
{
   if (val > 0) {
      return ("Buy Mode");
   } else if (val < 0) {
      return ("Sell Mode");
   } else {
      return ("Consolidated");
   }
}