//+------------------------------------------------------------------+
//|                                                   cu_history.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window

#include <3_signal_inc.mqh>
#property indicator_buffers 2
#property indicator_color1 Yellow
#property indicator_width1 2
#property indicator_color2 White
#property indicator_width2 2


// Indicator buffers
double Down[];
double Up[];

// Global variables
int LastBars = 0;
double MaxNoseBodySize = 0.33;
double NoseBodyPosition = 0.4;
bool   LeftEyeOppositeDirection = true;
bool   NoseSameDirection = false;
bool   NoseBodyInsideLeftEyeBody = false;
double LeftEyeMinBodySize = 0.1;
double NoseProtruding = 0.5;
double NoseBodyToLeftEyeBody = 1;
double NoseLengthToLeftEyeLength = 0;
double LeftEyeDepth = 0.2;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
//---- indicator buffers mapping  
   SetIndexBuffer(0, Down);
   SetIndexBuffer(1, Up);  
//---- drawing settings
   SetIndexStyle(0, DRAW_ARROW);
   SetIndexArrow(0, 74);
   SetIndexStyle(1, DRAW_ARROW);
   SetIndexArrow(1, 74);
//----
   SetIndexEmptyValue(0, EMPTY_VALUE);
   SetIndexEmptyValue(1, EMPTY_VALUE);
//---- indicator labels
   SetIndexLabel(0, "Bearish Pinbar");
   SetIndexLabel(1, "Bullish Pinbar");
//----
   return(0);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   int NeedBarsCounted;
   double NoseLength, NoseBody, LeftEyeBody, LeftEyeLength;

   if (LastBars == Bars) return(0);
   NeedBarsCounted = Bars - LastBars;
   LastBars = Bars;
   if (NeedBarsCounted == Bars) NeedBarsCounted--;
   int heiken, heikenCurrent, macd, macdCurrent, tenken, tenkenCurrent, semaphore;
   bool condition_buy, condition_sell;
   double MacdCurrent;
   double tenkan_sen_1, tenkan_sen_2;
   for (int i = NeedBarsCounted; i >= 1; i--)
   {
      // Won't have Left Eye for the left-most bar
      if (i == Bars - 1) continue;
      
      // Left Eye and Nose bars's paramaters
      NoseLength = High[i] - Low[i];
      if (NoseLength == 0) NoseLength = Point;
      heiken = heikenshift(Symbol(), Period(), i);
      heikenCurrent = heikenCurrentshift(Symbol(), Period(), i);
      macd = macdRshift(Symbol(), Period(), i);
      macdCurrent = macdRCurrentshift(Symbol(), Period(), i);
      tenkan_sen_1=iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_TENKANSEN, i);
      tenkan_sen_2=iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_TENKANSEN, i+1);
      MacdCurrent=iMACD(Symbol(), Period(),12,26,9,PRICE_CLOSE,MODE_MAIN,i);
      semaphore = semaphoreShift(Symbol(), Period(), i);
      condition_buy = (
         (macdCurrent == 1
         && tenkan_sen_1 < iClose(Symbol(), Period(), i))
         && semaphoreNumber < i+7 && semaphore == 1
         
      );
      condition_sell = (
         (macdCurrent == -1
         && tenkan_sen_1 > iClose(Symbol(), Period(), i))
         && semaphoreNumber < i+7 && semaphore == -1
         
      );
      if (condition_buy) {
         Up[i] = Low[i] - 5 * Point - NoseLength / 5;
         if (i == 1) Alert(Symbol(), " Bullish");
      } else if (condition_sell) {
         Down[i] = High[i] + 5 * Point + NoseLength / 5;
         if (i == 1) Alert(Symbol(), " Bearish");
      }
   }
}

