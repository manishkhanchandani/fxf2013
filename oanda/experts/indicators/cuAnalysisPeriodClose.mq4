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
   return (0);
   int bar2 = 0; //getShift(Symbol(), Period(), D'2013.05.10 00:00');
   for (int s = 1; s <= 25; s++) {
      for (int j = 1; j <= 25; j++) {
            double val = iCustom(symbol, Period(), "cuSpanClose", s, j, 1000, 6, bar2);
            infobox = infobox + "\nSymbol: " + symbol + ", Period: " + Period() 
             + ", Strategy Start: " + s + " (" + get_strategy_name(s) + ")"
             + ", Strategy End: " + j + " (" + get_strategy_name(j) + ") Val: " + val;
            if (val > max && val != EMPTY_VALUE) {
               max = val;
               sel = Period();
               best = s;
               best2 = j;
            }
      }
   }
   string inference = "\nmax: " + max + ", sel: " + sel + ", Best Start Strategy = " + best
   + ", Best End Strategy = " + best2 + ", Spread: " + MarketInfo(symbol, MODE_SPREAD);
   infobox = inference + infobox;
   FileDelete(symbol+"/analysisClose_"+symbol+"_"+Period()+".txt");
   FileAppend(symbol+"/analysisClose_"+symbol+"_"+Period()+".txt", infobox);
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