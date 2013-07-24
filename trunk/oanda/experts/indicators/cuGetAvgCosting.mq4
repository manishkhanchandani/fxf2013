//+------------------------------------------------------------------+
//|                                              cuGetAvgCosting.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

#property indicator_chart_window
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
   string box = "";
   difference[0] = get_difference(Symbol(), 0);
   box = box + "\nSymbol: " + Symbol() + ", Difference: " + difference[0];
   box = box + get_average_costing(Symbol(), 0);
   Comment(box);
//----
   return(0);
  }
//+------------------------------------------------------------------+