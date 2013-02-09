//+------------------------------------------------------------------+
//|                                          custom_trend_finder.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window


extern int InpPeriod1=20;  // Period1
extern int InpPeriod2=100; // Period2

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
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
   int    counted_bars=IndicatorCounted();
   double LowValue1;
   double HighValue1;
   double LowValue2;
   double HighValue2;
   double Period1;
   double Period2;
   LowValue1 = iLowest(Symbol(), Period(), MODE_LOW, InpPeriod1, 0);
   HighValue1 = iHighest(Symbol(), Period(), MODE_HIGH, InpPeriod1, 0);
   LowValue2 = iLowest(Symbol(), Period(), MODE_LOW, InpPeriod2, 0);
   HighValue2 = iHighest(Symbol(), Period(), MODE_HIGH, InpPeriod2, 0);
   Period1 = (Close[0] - LowValue1) / (HighValue1 - LowValue1);
   Period2 = (Close[0] - LowValue2) / (HighValue2 - LowValue2);
   Comment(DoubleToStr(Period1, Digits), " = ", DoubleToStr(Period2, Digits));
   
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+