//+------------------------------------------------------------------+
//|                                                     3_signal.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <3_signal_inc.mqh>
int tsStart = 500;
int ts = 150;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   //start();
   
InitialTrailingStop = tsStart;
TrailingStop = ts;
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
   infobox = "";
   string lowbox = trailingstop();
   infobox = infobox + lowbox;
   Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+


