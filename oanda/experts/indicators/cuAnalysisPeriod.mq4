//+------------------------------------------------------------------+
//|                                                   cuAnalysis.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

#property indicator_chart_window

#property indicator_buffers 5
#property indicator_color1 Yellow
#property indicator_color2 Red
#include <3_signal_inc.mqh>
string symbol;
#include <strategies.mqh>

double CrossUp[];
double CrossDown[];
double Cross[];
double Fpips[];
double Total[];

int lastChange;
int lastChangeType;
double lastChangeClose;
int gtotal;
int best = 0;
int best2 = 0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_ARROW, EMPTY,2);
   SetIndexArrow(0, 233);
   SetIndexBuffer(0, CrossUp);
   SetIndexStyle(1, DRAW_ARROW, EMPTY,2);
   SetIndexArrow(1, 234);
   SetIndexBuffer(1, CrossDown);
   SetIndexStyle(2, DRAW_NONE);
   SetIndexBuffer(2, Cross);
   SetIndexStyle(3, DRAW_NONE);
   SetIndexBuffer(3, Fpips);
   SetIndexStyle(4, DRAW_NONE);
   SetIndexBuffer(4, Total);
   lastChange = 0;
   lastChangeClose = 0;
   lastChangeType = 0;
   symbol = Symbol();
   int periods[10] = {PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4};
   int sel = 0;
   int sel2 = 0;
   int max = -9999;
   int max2 = -9999;
   infobox = "";
   int bar2 = 0; //getShift(Symbol(), Period(), D'2013.05.10 00:00');
   for (int j = 1; j <= 25; j++) {
         double val = iCustom(symbol, Period(), "cuSpan", j, 4, bar2);
         infobox = infobox + "\nSymbol: " + symbol + ", Period: " + Period() + ", Strategy: " + j + " (" + get_strategy_name(j) + ") Val: " + val;
         if (val > max && val != EMPTY_VALUE) {
            max = val;
            sel = Period();
            best = j;
         }
   }
   string inference = "\nmax: " + max + ", sel: " + sel + ", best Strategy = " + best + ", Spread: " + MarketInfo(symbol, MODE_SPREAD);
   /*
   for (j = 1; j <= 23; j++) {
      if (j == 16 || j == 18) {} else continue;
         val = iCustom(symbol, Period(), "cuSpan", j, 4, bar2);
         infobox = infobox + "\nSymbol: " + symbol + ", Period: " + Period() + ", Strategy: " + j + " (" + get_strategy_name(j) + ") , Val: " + val;
         if (val > max2 && val != EMPTY_VALUE) {
            max2 = val;
            sel2 = Period();
            best2 = j;
         }
   }
   inference = inference + ", 16 or 18: max: " + max2 + ", sel: " + sel2 + ", best Strategy = " + best2;*/
   infobox = inference + infobox;
   FileDelete(symbol+"/analysis_"+symbol+"_"+Period()+".txt");
   FileAppend(symbol+"/analysis_"+symbol+"_"+Period()+".txt", infobox);
   Comment(infobox);
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

         
   return(0);
  }
//+------------------------------------------------------------------+