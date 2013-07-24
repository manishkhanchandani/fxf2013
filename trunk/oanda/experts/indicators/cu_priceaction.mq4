//+------------------------------------------------------------------+
//|                                               cu_priceaction.mq4 |
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
//----
   
   int limit, i, counter;
   double Range, AvgRange;
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;

   limit=Bars-counted_bars;
   double val, val2, val3, val4;
   for(i = limit; i >= 0; i--) {
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      val = MorningStar(Symbol(), Period(), i);
      val2 = MorningDogi(Symbol(), Period(), i);
      val3 = EveningStar(Symbol(), Period(), i);
      val4 = EveningDogi(Symbol(), Period(), i);
      if (val == 1 || val2 == 1) {
         CrossUp[i] = Low[i] - Range*0.5;
      } else if (val3 == 1 || val4 == 1) {
         CrossDown[i] = High[i] + Range*0.5;
      }
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+

int MorningStar(string symbol, int timeperiod, int shift)
{
   int num = shift + 1;
   int num2 = shift + 2;
   int num3 = shift + 3;
   int result = 0;
   double open1, open2, open3, close1, close2, close3, AvgBody1, AvgBody2, AvgBody3;
   open1 = iOpen(symbol, timeperiod, num);
   open2 = iOpen(symbol, timeperiod, num2);
   open3 = iOpen(symbol, timeperiod, num3);
   close1 = iClose(symbol, timeperiod, num);
   close2 = iClose(symbol, timeperiod, num2);
   close3 = iClose(symbol, timeperiod, num3);
   AvgBody1 = AvgBody(symbol, timeperiod, num);
   AvgBody2 = AvgBody(symbol, timeperiod, num2);
   AvgBody3 = AvgBody(symbol, timeperiod, num3);

   if (open3 < close3)
      return (0);
   
   if (open3 - close3 > AvgBody1
      && (MathAbs(close2 - open2) < AvgBody1 * 0.5)
      && close2 < close3
      && open2 < open3
      && close1 > MidOpenClose(symbol, timeperiod, num3)
      ) {
         result = 1;      
      }
      
   return (result);
}
int MorningDogi(string symbol, int timeperiod, int shift)
{
   int num = shift + 1;
   int num2 = shift + 2;
   int num3 = shift + 3;
   int result = 0;
   double open1, open2, open3, close1, close2, close3, AvgBody1, AvgBody2, AvgBody3;
   open1 = iOpen(symbol, timeperiod, num);
   open2 = iOpen(symbol, timeperiod, num2);
   open3 = iOpen(symbol, timeperiod, num3);
   close1 = iClose(symbol, timeperiod, num);
   close2 = iClose(symbol, timeperiod, num2);
   close3 = iClose(symbol, timeperiod, num3);
   AvgBody1 = AvgBody(symbol, timeperiod, num);
   AvgBody2 = AvgBody(symbol, timeperiod, num2);
   AvgBody3 = AvgBody(symbol, timeperiod, num3);

   if (open3 < close3)
      return (0);
   
   if (open3 - close3 > AvgBody1
      && (AvgBody2 < AvgBody1 * 0.1)
      && close2 < close3
      && open2 < open3
      && open1 >= close2
      && close1 >= close2
      ) {
         result = 1;      
      }
   return (result);
}
int EveningStar(string symbol, int timeperiod, int shift)
{
   int num = shift + 1;
   int num2 = shift + 2;
   int num3 = shift + 3;
   int result = 0;
   double open1, open2, open3, close1, close2, close3, AvgBody1, AvgBody2, AvgBody3;
   open1 = iOpen(symbol, timeperiod, num);
   open2 = iOpen(symbol, timeperiod, num2);
   open3 = iOpen(symbol, timeperiod, num3);
   close1 = iClose(symbol, timeperiod, num);
   close2 = iClose(symbol, timeperiod, num2);
   close3 = iClose(symbol, timeperiod, num3);
   AvgBody1 = AvgBody(symbol, timeperiod, num);
   AvgBody2 = AvgBody(symbol, timeperiod, num2);
   AvgBody3 = AvgBody(symbol, timeperiod, num3);

   if (open3 > close3)
      return (0);
   
   if (close3 - open3 > AvgBody1
      && (MathAbs(close2 - open2) < AvgBody1 * 0.5)
      && close2 > close3
      && open2 > open3
      && close1 < MidOpenClose(symbol, timeperiod, num3)
      ) {
         result = 1;      
      }
   return (result);
}
int EveningDogi(string symbol, int timeperiod, int shift)
{
   int num = shift + 1;
   int num2 = shift + 2;
   int num3 = shift + 3;
   int result = 0;
   double open1, open2, open3, close1, close2, close3, AvgBody1, AvgBody2, AvgBody3;
   open1 = iOpen(symbol, timeperiod, num);
   open2 = iOpen(symbol, timeperiod, num2);
   open3 = iOpen(symbol, timeperiod, num3);
   close1 = iClose(symbol, timeperiod, num);
   close2 = iClose(symbol, timeperiod, num2);
   close3 = iClose(symbol, timeperiod, num3);
   AvgBody1 = AvgBody(symbol, timeperiod, num);
   AvgBody2 = AvgBody(symbol, timeperiod, num2);
   AvgBody3 = AvgBody(symbol, timeperiod, num3);

   if (open3 > close3)
      return (0);
   
   if (close3 - open3 > AvgBody1
      && (AvgBody2 < AvgBody1 * 0.1)
      && close2 > close3
      && open2 > open3
      && open1 <= close2
      && close1 <= close2
      ) {
         result = 1;      
      }
   return (result);
}
int BearishMeetingLines(string symbol, int timeperiod, int shift)
{
   return (0);
   int num = shift + 1;
   int num2 = shift + 2;
   int num3 = shift + 3;
   int result = 0;
   double open1, open2, open3, close1, close2, close3, AvgBody1, AvgBody2, AvgBody3;
   open1 = iOpen(symbol, timeperiod, num);
   open2 = iOpen(symbol, timeperiod, num2);
   open3 = iOpen(symbol, timeperiod, num3);
   close1 = iClose(symbol, timeperiod, num);
   close2 = iClose(symbol, timeperiod, num2);
   close3 = iClose(symbol, timeperiod, num3);
   AvgBody1 = AvgBody(symbol, timeperiod, num);
   AvgBody2 = AvgBody(symbol, timeperiod, num2);
   AvgBody3 = AvgBody(symbol, timeperiod, num3);

   if (close2 > open2)
      return (0);
   
   if (close2 - open2 > AvgBody1
      && (AvgBody2 < AvgBody1 * 0.1)
      && close2 > close3
      && open2 > open3
      && open1 <= close2
      && close1 <= close2
      ) {
         result = 1;      
      }
   return (result);
}
double AvgBody(string symbol, int timeperiod, int shift)
{
   double result;
   result = MathAbs(iOpen(symbol, timeperiod, shift) - iClose(symbol, timeperiod, shift));
   return (result);
}
double MidOpenClose(string symbol, int timeperiod, int shift)
{
   double result;
   result = iOpen(symbol, timeperiod, shift) + iClose(symbol, timeperiod, shift);
   result = result * 0.5;
   return (result);
}
/*
void alertval(double value, string symbol)
{
   Alert(DoubleToStr(value, MarketInfo(symbol, MODE_DIGITS)));
}*/