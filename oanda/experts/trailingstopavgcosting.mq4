//+------------------------------------------------------------------+
//|                                                  avg_costing.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

extern bool avgcosting = false;
extern bool trailingfunstop = true;
#include <3_signal_inc.mqh>
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
   infobox = "\n";
   int x;
   string symbol;
   for (x = 0; x < ARRSIZE; x++) {
      symbol = aPair[x];
         if (symbol != Symbol()) {
            continue;
         }
      history2(symbol);
      openPositionTotal(symbol);
      render_avg_costing(symbol, x, lots, trailingfunstop, avgcosting);
   }
   
   Comment (infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+