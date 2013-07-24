//+------------------------------------------------------------------+
//|                                                      cuChart.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#include <3_signal_inc.mqh>
#include <strategies.mqh>

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
   if (opentime != Time[0]) {
      opentime = Time[0];
      int bar = getShift(Symbol(), Period(), (TimeCurrent() - (60 * 60 * 24 * 10)));
      Print("bar: ", bar);
      string symbol = Symbol();
      Print("symbol: ", symbol);
      int period = Period();
      Print("period: ", period);
      for (int i = 1; i <= bar; i++) {
         //double MacdCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,i);
         //Print("Macd: ", MacdCurrent);
         if (i == bar) {
            vline("start", Time[i], Yellow);
         }
      }
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+