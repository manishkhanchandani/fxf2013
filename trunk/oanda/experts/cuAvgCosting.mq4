//+------------------------------------------------------------------+
//|                                                 cuAvgCosting.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

#include <3_signal_inc.mqh>
extern bool avg_costing = true;
extern bool trailingFun = true;

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
   infobox = "";
   string box = render_avg_costing(Symbol(), 0, lots, trailingFun, avg_costing);
   infobox = infobox + box;
   Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+