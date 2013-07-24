//+------------------------------------------------------------------+
//|                                                       cu_jpy.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

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
   del();
   string name;
   name = "lbleurjpy";
   create_label(name, 0, 0, 0, 0, 200, 20, "EURJPY", White);
   name = "lblchfjpy";
   create_label(name, 0, 0, 0, 0, 300, 20, "CHFJPY", White);
   name = "lblusdjpy";
   create_label(name, 0, 0, 0, 0, 400, 20, "USDJPY", White);
   name = "lblcadjpy";
   create_label(name, 0, 0, 0, 0, 500, 20, "CADJPY", White);
   name = "lblaudjpy";
   create_label(name, 0, 0, 0, 0, 600, 20, "AUDJPY", White);
   name = "lblnzdjpy";
   create_label(name, 0, 0, 0, 0, 700, 20, "NZDJPY", White);
   name = "lblgbpjpy";
   create_label(name, 0, 0, 0, 0, 800, 20, "GBPJPY", White);
   
   name = "lblmacd";
   create_label(name, 0, 0, 0, 0, 10, 50, "MACD 1M/5M", White);
//----
   return(0);
  }
//+------------------------------------------------------------------+



int del()
{
   string name;
   name = "lbleurjpy";
   ObjectDelete(name);
   name = "lblchfjpy";
   ObjectDelete(name);
   name = "lblusdjpy";
   ObjectDelete(name);
   name = "lblcadjpy";
   ObjectDelete(name);
   name = "lblaudjpy";
   ObjectDelete(name);
   name = "lblnzdjpy";
   ObjectDelete(name);
   name = "lblgbpjpy";
   ObjectDelete(name);
   name = "lblmacd";
   ObjectDelete(name);
}