//+------------------------------------------------------------------+
//|                                                  cu_analysis.mq4 |
//|                                              Manish Khanchandani |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://forexmastery.org"

#property indicator_separate_window
#property indicator_minimum 1
#property indicator_maximum 10
#include <3_signal_inc.mqh>

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
//----
int LastBars = 0;
ObjectDelete("MEVA Line Alto");
   ObjectCreate("MEVA Line Alto", OBJ_RECTANGLE, 0, Time[0], 5);
ObjectSet("MEVA Line Alto", OBJPROP_STYLE, STYLE_DASHDOTDOT);
ObjectSet("MEVA Line Alto", OBJPROP_COLOR, MidnightBlue);
ObjectSet("MEVA Line Alto", OBJPROP_WIDTH, 4);
    int NeedBarsCounted;
   double NoseLength, NoseBody, LeftEyeBody, LeftEyeLength;

   if (LastBars == Bars) return(0);
   NeedBarsCounted = Bars - LastBars;
   LastBars = Bars;
   if (NeedBarsCounted == Bars) NeedBarsCounted--;
   
   for (int i = NeedBarsCounted; i >= 1; i--)
   {
      // Won't have Left Eye for the left-most bar
      if (i == Bars - 1) continue;
      
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+