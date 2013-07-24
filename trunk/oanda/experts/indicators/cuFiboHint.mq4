//+------------------------------------------------------------------+
//|                                                   cuFiboHint.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

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
      if (opentime != Time[0]) {
         string box = "";
         string symbol = Symbol();
         int period = Period();
         int    counted_bars=IndicatorCounted();
         int semaphore1 = semaphoreShift(symbol, period, 0);
            int snumber1 = semaphoreNumber;
            int semaphore2 = semaphoreShift(symbol, period, snumber1+1);
            int snumber2 = semaphoreNumber;
            box = box + "\n\nSemaphore 1: " + semaphore1 + " at " + snumber1 
            + " With High: " + iHigh(symbol, period, snumber1) + " and Low: " + iLow(symbol, period, snumber1);
            box = box + "\nSemaphore 2: " + semaphore2 + " at " + snumber2 
            + " With High: " + iHigh(symbol, period, snumber2) + " and Low: " + iLow(symbol, period, snumber2);
            double highs, lows, diffs;
            double level_0, level_23, level_38, level_50, level_61;
            double tp1, tp2;
            string show;
            double pending_1;
            double pending_2;
            double time1, close1, time2, close2;
            if (semaphore1 == 1) { // sell in this case
               highs = iHigh(symbol, period, snumber2);
               lows = iLow(symbol, period, snumber1);
               time1 = Time[snumber1];
               time2 = Time[snumber2];
               close1 = High[snumber1];
               close2 = Low[snumber2];
               
               diffs = highs - lows;
               level_0 = lows + (diffs * 0.0);
               level_23 = lows + (diffs * 0.236);
               level_38 = lows + (diffs * 0.382);
               level_50 = lows + (diffs * 0.50);
               level_61 = lows + (diffs * 0.618);
               tp1 = lows - (diffs * 0.60);
               show = "Sell";
               pending_1 = (level_38 - MarketInfo(symbol, MODE_BID)) / MarketInfo(symbol, MODE_POINT);
               pending_2 = (level_23 - MarketInfo(symbol, MODE_BID)) / MarketInfo(symbol, MODE_POINT);
            } else if (semaphore1 == -1) { //buy in this case
               highs = iHigh(symbol, period, snumber1);
               lows = iLow(symbol, period, snumber2);
               time1 = Time[snumber2];
               time2 = Time[snumber1];
               close1 = Low[snumber2];
               close2 = High[snumber1];
               diffs = highs - lows;
               level_0 = highs - (diffs * 0.0);
               level_23 = highs - (diffs * 0.236);
               level_38 = highs - (diffs * 0.382);
               level_50 = highs - (diffs * 0.50);
               level_61 = highs - (diffs * 0.618);
               tp1 = highs + (diffs * 0.60);
               show = "Buy";
               pending_1 = (MarketInfo(symbol, MODE_BID) - level_38) / MarketInfo(symbol, MODE_POINT);
               pending_2 = (MarketInfo(symbol, MODE_BID) - level_23) / MarketInfo(symbol, MODE_POINT);
            }
            int digits = MarketInfo(symbol, MODE_DIGITS);
            box = box + "\nHigh: " + highs + ", Low: " + lows + ", Diff: " + diffs + ", Forecast: " + show;
            box = box + "\nLevel 0: " + level_0 + "\nLevel 23: " + level_23 + "\nlevel_38: " + level_38
               + "\nLevel 50: " + level_50
               + "\nLevel 61: " + level_61;
            box = box + "\n" + show + "  at: " + level_38 
            + " (" + DoubleToStr(pending_1, 0) + ") or at: " 
            + level_23 + "(" + DoubleToStr(pending_2, 0) + ")";
            box = box + "\nTake Profit Level 1: " + tp1
            + " (" + DoubleToStr((MathAbs(tp1 - level_38)) / MarketInfo(symbol, MODE_POINT), 0) + ")";
            box = box + "\nStop Loss: " + level_61
            + " (" + DoubleToStr((MathAbs(level_38 - level_61)) / MarketInfo(symbol, MODE_POINT), 0) + ")";
            
            string name = "";
            name = "level_0";
            ObjectDelete(name);
            hline(name, level_0, White);
            name = "level_23";
            ObjectDelete(name);
            hline(name, level_23, Orange);
            name = "level_38";
            ObjectDelete(name);
            hline(name, level_38, Yellow);
            name = "level_50";
            ObjectDelete(name);
            hline(name, level_50, Aqua);
            name = "level_61";
            ObjectDelete(name);
            hline(name, level_61, Olive);
            name = "level_0";
            ObjectDelete(name);
            hline(name, level_0, White);
            name = "tp1";
            ObjectDelete(name);
            hline(name, tp1, Gold);
            name = "lows";
            ObjectDelete(name);
            hline(name, lows, White);
            string upperName = "trendline";
            ObjectDelete(upperName);
            SetTrendlineObject(upperName, time1, close1, time2, close2, Gold, 2);
            
            string upperName2 = "trendline2";
            ObjectDelete(upperName2);
            SetTrendlineObject(upperName2, time2, close2, Time[0], Close[0], Aqua, 1);
          Comment(box);
       opentime = Time[0];
    }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+