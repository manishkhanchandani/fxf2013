//+------------------------------------------------------------------+
//|                                                 cuAnalysisMA.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

#property indicator_chart_window
#include <3_signal_inc.mqh>
extern int type = 6;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   string infobox = "";
   int sleeptime = 1000;
   int max = 0;
   int bestFast = 0;
   int bestSlow = 0;
   int sel = -1;
   string symbol = Symbol();
   int fastP[5];
   int slowP[5];
   switch (type) {
      case 1:
            fastP[0] = 5;fastP[1] = 14;fastP[2] = 25;fastP[3] = 35;fastP[4] = 50;
            slowP[0] = 5;slowP[1] = 14;slowP[2] = 25;slowP[3] = 35;slowP[4] = 50;
            break;
      case 2:
            fastP[0] = 9;fastP[1] = 14;fastP[2] = 25;fastP[3] = 35;fastP[4] = 50;
            slowP[0] = 55;slowP[1] = 65;slowP[2] = 75;slowP[3] = 85;slowP[4] = 95;
            break;
      case 3:
            fastP[0] = 9;fastP[1] = 14;fastP[2] = 25;fastP[3] = 35;fastP[4] = 50;
            slowP[0] = 100;slowP[1] = 150;slowP[2] = 200;slowP[3] = 250;slowP[4] = 300;
            break;
      case 4:
            fastP[0] = 9;fastP[1] = 14;fastP[2] = 25;fastP[3] = 35;fastP[4] = 50;
            slowP[0] = 400;slowP[1] = 500;slowP[2] = 1000;slowP[3] = 1500;slowP[4] = 2000;
            break;
      case 5:
            fastP[0] = 50;fastP[1] = 100;fastP[2] = 200;fastP[3] = 300;fastP[4] = 500;
            slowP[0] = 50;slowP[1] = 100;slowP[2] = 200;slowP[3] = 300;slowP[4] = 500;
            break;
      case 6:
            fastP[0] = 5;fastP[1] = 14;fastP[2] = 21;fastP[3] = 25;fastP[4] = 50;
            slowP[0] = 5;slowP[1] = 14;slowP[2] = 21;slowP[3] = 25;slowP[4] = 50;
            break;
   }
   int f;
   int s;
   infobox = infobox + "\nType: " + type + "\n\n";
   for (int fast = 0; fast < 5; fast++) {
      for (int slow = 0; slow < 5; slow++) {
         f = fastP[fast];
         s = slowP[slow];
         if (f == s) continue;
         double val = iCustom(Symbol(), Period(), "cuSpanParam", f, s, 4, 0);
         infobox = infobox + "\nFast: " + f + ", Slow: " + s + ", Result: " + val;
         if (val > max && val != EMPTY_VALUE) {
            max = val;
            sel = Period();
            bestFast = f;
            bestSlow = s;
         }
         //Sleep(sleeptime);
      }
   }
   infobox = infobox + "\nPeriod: " + sel + ", bestFast: " + bestFast + ", bestSlow: " + bestSlow + ", max: " + max;
   Comment(infobox);
   FileDelete(symbol+"_MA/analysis_"+symbol+"_"+Period()+"_"+type+".txt");
   FileAppend(symbol+"_MA/analysis_"+symbol+"_"+Period()+"_"+type+".txt", infobox);
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
   
//----
   return(0);
  }
//+------------------------------------------------------------------+