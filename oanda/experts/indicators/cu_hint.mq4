//+------------------------------------------------------------------+
//|                                                      cu_hint.mq4 |
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
   string symbol = Symbol();
   int period = Period();
   
   int macdCurrent = macdRCurrentshift(symbol, period, 1);
   int semaphore = semaphoreShift(symbol, period, 0);
   double tenkan_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_TENKANSEN, 0);
   string name = "Hint";
   string nameSL = "HintSL";
   string nameBID = "Bid";
   string nameASK = "Ask";
   ObjectDelete(name);
   ObjectDelete(nameSL);
   ObjectDelete(nameBID);
   ObjectDelete(nameASK);
   if (semaphore == 1 && macdCurrent == 1) {
      create_label(name, 0, 0, 0, 1, 10, 10, "BUY", Blue);
      create_label(nameSL, 0, 0, 0, 1, 10, 40, "Stop Loss: " + Low[semaphoreNumber], Yellow);
   } else if (semaphore == -1 && macdCurrent == -1) {
      create_label(name, 0, 0, 0, 1, 10, 10, "SELL", Red);
      create_label(nameSL, 0, 0, 0, 1, 10, 40, "Stop Loss: " + High[semaphoreNumber], Yellow);
   }
      create_label(nameBID, 0, 0, 0, 1, 10, 70, "Bid: " + Bid, White);
      create_label(nameBID, 0, 0, 0, 1, 10, 100, "Ask: " + Ask, White);
//----
   return(0);
  }
//+------------------------------------------------------------------+