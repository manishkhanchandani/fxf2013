//+------------------------------------------------------------------+
//|                                              MillionDollarv3.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

#include <3_signal_inc.mqh>
#include <strategies.mqh>
#include <orders.mqh>
int c_strategy[28];//symbol
int c_checked[28];//checked
int c_max[28];//checked
int period;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   period = PERIOD_M15;
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
   //FINDING LOT SIZE
   finding_lots();
   //FINDING THE STRATEGY
   int xtotal = 0;
   for(int i=0;i<ARRSIZE;i++) {
      string symbol = aPair[i];
      infobox = infobox + findingStrategy(symbol, i);
      xtotal = xtotal + c_max[i];
   }
   infobox = infobox + "\nTotal: " + xtotal;
   string filename = "milliondollarv6.txt";
   FileDelete(filename);
   FileAppend(filename, infobox);
   Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+


string findingStrategy(string symbol, int mode)
{
   string inference = "";
   int noofdays = 5;
   int best = 0;
   if (c_checked[mode] != 1) {
      c_checked[mode] = 1;
      int sel = 0;
      int sel2 = 0;
      int max = -9999;
      int max2 = -9999;
      inference = "";
      for (int j = 1; j <= 25; j++) {
            double val = iCustom(symbol, period, "cuSpanTime", j, noofdays, 4, 0);
            
            if (val > max && val != EMPTY_VALUE) {
               max = val;
               sel = Period();
               best = j;
            }
      }
      if (max > 2000) {
         c_strategy[mode] = best;
         c_max[mode] = max;
      }
   }
   if (c_strategy[mode] > 0) {
         inference = inference + "\nSymbol: " + symbol + ", Period: " + period + ", Strategy: " + c_strategy[mode] 
         + " (" + get_strategy_name(c_strategy[mode]) + ") Val: " + c_max[mode];
         //condition_for_open(symbol, mode, k, period, k);
   }
   return (inference);
}


