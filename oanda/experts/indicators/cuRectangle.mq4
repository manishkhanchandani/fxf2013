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
      int start = 1;
      int end = 1 + 4;
      double high = High[start];
      double low = Low[start];
      double high2 = High[end];
      double low2 = Low[end];
      double price1, price2;
      int p1=iHighest(NULL, 0, MODE_HIGH, end-start, start);
		int p2=iLowest (NULL, 0, MODE_LOW , end-start, start);
		price1 = High[p1];
		price2 = Low[p2];
      ObjectDelete("Rectangle");
      ObjectCreate("Rectangle", OBJ_RECTANGLE, 0, Time[end], price1, Time[start], price2);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+