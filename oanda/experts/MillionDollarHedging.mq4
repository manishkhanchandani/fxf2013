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
   //FINDING LOT SIZE
   finding_lots();
   //FINDING THE STRATEGY
   infobox = infobox + findingStrategy(Symbol(), 0);
   //open condition
   //condition_for_open(Symbol(), 0);
   //close condition
   //condition_for_close(Symbol(), 0);
   string filename = "milliondollarhedging.txt";
   FileDelete(filename);
   FileAppend(filename, infobox);
   Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+

int c_strategy[26];//symbol
int counter1 = 0;

string findingStrategy(string symbol, int mode)
{
   string inference = "";
   int noofdays = 5;
   int best = 0;
   if (opentimeStrategy != iTime(Symbol(), PERIOD_W1, 0)) {
      opentimeStrategy = iTime(Symbol(), PERIOD_W1, 0);
      symbol = Symbol();
      int sel = 0;
      int sel2 = 0;
      int max = -9999;
      int max2 = -9999;
      inference = "";
      for (int j = 1; j <= 25; j++) {
            double val = iCustom(symbol, Period(), "cuSpanTime", j, noofdays, 4, 0);
            if (val > 2000) {
               c_strategy[j] = val;
            }
            /*
            if (val > max && val != EMPTY_VALUE) {
               max = val;
               sel = Period();
               best = j;
            }*/
      }
   }
   for (int k=1;k<=25;k++) {
      int total = c_strategy[k];
      if (c_strategy[k] == 0 || c_strategy[k] == EMPTY_VALUE || c_strategy[k] == NULL) continue;
      inference = inference + "\nSymbol: " + symbol + ", Period: " + Period() + ", Strategy: " + k + " (" + get_strategy_name(k) + ") Val: " + total;
      condition_for_open(symbol, mode, k, Period(), k);
   }
   return (inference);
}


