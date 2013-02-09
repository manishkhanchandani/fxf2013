//+------------------------------------------------------------------+
//|                                                  101_master1.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"
#define MAGICMA  19740605101

#include <indicators.mqh>

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
    //custom_start(1);
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
      bollingerbands(num, Symbol(), PERIOD_M1);
      bollingerbands(num, Symbol(), PERIOD_M5);
      bollingerbands(num, Symbol(), PERIOD_M15);
      bollingerbands(num, Symbol(), PERIOD_M30);
      bollingerbands(num, Symbol(), PERIOD_H1);
      bollingerbands(num, Symbol(), PERIOD_H4);
      
   
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