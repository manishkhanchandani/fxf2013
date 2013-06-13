//+------------------------------------------------------------------+
//|                                                    cuthinbar.mq4 |
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
   int x;
   string symbol;
   int periods[7] = {PERIOD_D1, PERIOD_H4, PERIOD_H1, PERIOD_M30, PERIOD_M15, PERIOD_M5, PERIOD_M1};
   string tmpbox;
   for (x = 0; x < ARRSIZE; x++) {
         symbol = aPair[x];
         infobox = infobox + "\nSymbol: " + symbol;
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+

int lightbar(string symbol, int period, int shift)
{
   double priceTop, priceBottom;
   int topcnt, bottomcnt;
   for (int i = shift; i < shift+4; i++) {
      double open = iOpen(symbol, period, i);
      double close = iClose(symbol, period, i);
      double high = iHigh(symbol, period, i);
      double low = iLow(symbol, period, i);
      double body = MathAbs(open - close);
      if (open > close) {
         priceTop = open;
         priceBottom = close;
      }
      else if (open < close) {
         priceTop = close;
         priceBottom = open;
      }
      double top = high - priceTop;
      double bottom = priceBottom - low;
      if (top > body && top > bottom) {
         topcnt++;
      } else if (bottom > body && bottom > top) {
         bottomcnt++;
      }
      if (bottomcnt > topcnt && bottomcnt > 0) {
         SendAlert("Bullish, topcnt: " + topcnt + ", bottomcnt: " + bottomcnt + ", Broker: " + AccountCompany() + ", AccType Demo: " + IsDemo(), symbol, period);
      } else 
      if (topcnt > bottomcnt && topcnt > 0) {
         SendAlert("Bearish, topcnt: " + topcnt + ", bottomcnt: " + bottomcnt + ", Broker: " + AccountCompany() + ", AccType Demo: " + IsDemo(), symbol, period);
      }
   }
}