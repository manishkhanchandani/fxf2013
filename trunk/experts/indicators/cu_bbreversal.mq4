//+------------------------------------------------------------------+
//|                                                  Pinbar Detector |
//|                                  Copyright © 2011, EarnForex.com |
//|                                        http://www.earnforex.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, EarnForex"
#property link      "http://www.earnforex.com"

#include <3_signal_inc.mqh>

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_width1 2
#property indicator_color2 Lime
#property indicator_width2 2

// Indicator buffers
double Down[];
double Up[];

// Global variables
int LastBars = 0;

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
   double NoseLength;
   if (LastBars == Bars) return(0);
   NeedBarsCounted = Bars - LastBars;
   LastBars = Bars;
   if (NeedBarsCounted == Bars) NeedBarsCounted--;
   
   for (int i = NeedBarsCounted; i >= 1; i--)
   {
      // Won't have Left Eye for the left-most bar
      if (i == Bars - 1) continue;
      NoseLength = High[i] - Low[i];
      int result = bbreversal(Symbol(), Period(), i);
      if (result == 1) {
         Up[i] = Low[i] - 5 * Point - NoseLength / 5;
      } else if (result == -1) {
         Down[i] = High[i] + 5 * Point + NoseLength / 5;
      }
   }
}

