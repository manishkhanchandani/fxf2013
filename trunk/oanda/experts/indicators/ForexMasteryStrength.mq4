//+------------------------------------------------------------------+
//|                                         ForexMasteryStrength.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

#property indicator_chart_window

#include <strategies.mqh>
#include <3_signal_inc.mqh>

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   del();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   del();
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
   string name = "start";
   int check;
   create_label(name, 0, 0, 0, 1, 10, 10, "Strength", Yellow);
   int buy = 0;
   int sell = 0;
   check = 0;
   check = get_strategy_result(4, Symbol(), Period(), 0, 1);
   if (check == 1) {
      buy++;
   } else if (check == -1) {
      sell++;
   }
   check = get_strategy_result(22, Symbol(), Period(), 0, 1);
   if (check == 1) {
      buy++;
   } else if (check == -1) {
      sell++;
   }
   check = get_strategy_result(2, Symbol(), Period(), 0, 1);
   if (check == 1) {
      buy++;
   } else if (check == -1) {
      sell++;
   }
   name = "resultBuy";
   create_label(name, 0, 0, 0, 1, 10, 30, "Buy: " + buy, Yellow);
   name = "resultSell";
   create_label(name, 0, 0, 0, 1, 10, 50, "Sell: " + sell, Yellow);
   check = get_lasttrendsemaphore(Symbol(), Period(), false);
   name = "trend";
   create_label(name, 0, 0, 0, 1, 10, 70, "Trend: " +  parse(check), Yellow);
   name = "trendbar";
   create_label(name, 0, 0, 0, 1, 10, 90, "Trend Bar: " +  semaphoreNumber, Yellow);
   int best = 0;
   int max = -9999999;
   for (int j = 1; j <= 25; j++) {
      double val = iCustom(Symbol(), Period(), "cuSpanTime", j, 1000, 4, 0);
      if (val > max && val != EMPTY_VALUE) {
         max = val;
         best = j;
      }
   }
   name = "beststrategy";
   create_label(name, 0, 0, 0, 1, 10, 110, "Best: " +  best + " (" + get_strategy_name(best) + ")", Yellow);
   name = "beststrategyval";
   create_label(name, 0, 0, 0, 1, 10, 130, "Value: " +  max, Yellow);
   check = get_strategy_result(best, Symbol(), Period(), 1, 0);
   name = "best";
   if (check == 1) {
      create_label(name, 0, 0, 0, 1, 10, 150, "Type: Buy", Yellow);
   } else if (check == -1) {
      create_label(name, 0, 0, 0, 1, 10, 150, "Type: Sell", Yellow);
   }
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

int del()
{
   ObjectDelete("start");
   ObjectDelete("resultBuy");
   ObjectDelete("resultSell");
   ObjectDelete("trend");
   ObjectDelete("beststrategy");
   ObjectDelete("beststrategyval");
}


