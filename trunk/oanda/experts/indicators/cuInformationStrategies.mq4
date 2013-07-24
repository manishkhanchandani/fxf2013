//+------------------------------------------------------------------+
//|                                                cuInformation.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

#property indicator_chart_window
#include <3_signal_inc.mqh>
#include <strategies.mqh>

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   del();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   del();
//----
   return(0);
  }
  
void del()
{
   ObjectsDeleteAll();
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   string name;
   color textColor;

   
   
   int lpos = 20;
   
   
   //strategies
   for (int x = 1; x < 24; x++) {
      double s = get_strategy_result(x, Symbol(), Period(), 0, 1);
   
      name = "sbl" + x;
      ObjectDelete(name);
      create_label(name, 0, 0, 0, 0, 10 + (30 * (x-1)), lpos, "S" + x, White);
      name = "sArrow" + x;
      ObjectDelete(name);
      if (x == 16 || x == 18) continue;
      if (s == 1) create_arrow(name, 10 + (30 * (x-1)), lpos + 20, 1, 0);
      else if (s == -1) create_arrow(name, 10 + (30 * (x-1)), lpos + 20, -1, 0);
   }

   lpos = lpos + 40;
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+