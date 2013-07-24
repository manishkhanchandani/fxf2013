//+------------------------------------------------------------------+
//|                                                         test.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"


#include <3_signal_inc.mqh>
#include <strategies.mqh>

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   start();
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
   if (opentime != iTime(Symbol(), Period(), 0)){
   infobox = "";
   string symbol;
   int x;
    for (x = 0; x < ARRSIZE; x++) {
         symbol = aPair[x];
         if (symbol != Symbol()) continue;
         mathmurry(symbol, x, PERIOD_H1);
    }
   Comment(infobox);
   opentime = iTime(Symbol(), Period(), 0);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+