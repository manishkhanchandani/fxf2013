//+------------------------------------------------------------------+
//|                                              cuAllStrategies.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#include <3_signal_inc.mqh>
#include <strategies.mqh>
extern int noofdays = 150;
extern int noofdaysend = 0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   ObjectsDeleteAll();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectsDeleteAll();
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
   int periods[5] = {PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4, PERIOD_D1};
   int ys[5] = {20, 100, 180, 260, 340};
   double val;
   int ss_x = 30;
   int p, period;
   string name;
   int x,y,j,check;
   x = 10;
   y = 10;
   int ab;
   double cdiff;
   int max = -9999999;
   int best = 0;
   if (opentime != iTime(Symbol(), PERIOD_M5, 0)) {
      opentime = iTime(Symbol(), PERIOD_M5, 0);
      ObjectsDeleteAll();
      infobox = "";
         period = Period();
         y = 20;
         y = y + 20;
         for (j=1;j<=14;j++) {
            name = "s_"+j;
            create_label(name, 0, 0, 0, 0, x, ss_x*j, "S"+j, White);
            name = get_strategy_name(j);
            create_label("sname_"+j, 0, 0, 0, 0, x+30, ss_x*j, name, Yellow);
            check = get_strategy_result(j, Symbol(), Period(), 1, 1);
            name = "strategy_"+j;
            create_arrow(name, x + 110, ss_x*j, check, 0);
            val = iCustom(Symbol(), Period(), "cuSpanTimeClose", j, noofdays, noofdaysend, 4, 0);
            if (val == EMPTY_VALUE) val = 0;
            if (val >= max) { max = val; best = j; }
            create_label("snameval_"+j, 0, 0, 0, 0, x+140, ss_x*j, DoubleToStr(val, 0), Yellow);
               for (ab = 1; ab < 1500; ab++) {
                  check = get_strategy_result(j, Symbol(), Period(), ab, 0);
                  if (check != 0) {
                     if (check == 1) {
                        cdiff = (iClose(Symbol(), Period(), 0) - iClose(Symbol(), Period(), ab)) / MarketInfo(Symbol(), MODE_POINT);
                     } else if (check == -1) {
                        cdiff = (iClose(Symbol(), Period(), ab) - iClose(Symbol(), Period(), 0)) / MarketInfo(Symbol(), MODE_POINT);
                     }
                     if (ab == 1) {
                        Alert(Symbol(), ", Period: ", TimeframeToString(Period()), ", Change to ", check,
                        ", Strategy: " , j);
                     }
                     break;
                  }
               }
               create_label("snamepast_"+j, 0, 0, 0, 0, x+200, ss_x*j, DoubleToStr(cdiff, 0) + "("+ab+")", Yellow);
         }
         for (j=15;j<=28;j++) {
            name = "s_"+j;
            create_label(name, 0, 0, 0, 1, x, ss_x*(j-14), "S"+j, White);
            name = get_strategy_name(j);
            create_label("sname_"+j, 0, 0, 0, 1, x+30, ss_x*(j-14), name, Yellow);
            check = get_strategy_result(j, Symbol(), Period(), 1, 1);
            name = "strategy_"+j;
            create_arrow(name, x + 110, ss_x*(j-14), check, 1);
            val = iCustom(Symbol(), Period(), "cuSpanTimeClose", j, noofdays, noofdaysend, 4, 0);
            if (val == EMPTY_VALUE) val = 0;
            if (val >= max) { max = val; best = j; }
            create_label("snameval_"+j, 0, 0, 0, 1, x+140, ss_x*(j-14), DoubleToStr(val, 0), Yellow);
               for (ab = 1; ab < 1500; ab++) {
                  check = get_strategy_result(j, Symbol(), Period(), ab, 0);
                  if (check != 0) {
                     if (check == 1) {
                        cdiff = (iClose(Symbol(), Period(), 0) - iClose(Symbol(), Period(), ab)) / MarketInfo(Symbol(), MODE_POINT);
                     } else if (check == -1) {
                        cdiff = (iClose(Symbol(), Period(), ab) - iClose(Symbol(), Period(), 0)) / MarketInfo(Symbol(), MODE_POINT);
                     }
                     if (ab == 1) {
                        //Alert(Symbol(), ", Period: ", TimeframeToString(Period()), ", Change to ", check,
                        //", Strategy: " , j);
                     }
                     break;
                  }
               }
               create_label("snamepast_"+j, 0, 0, 0, 1, x+200, ss_x*(j-14), DoubleToStr(cdiff, 0) + "("+ab+")", Yellow);
         }
      create_label("spread", 0, 0, 0, 0, x+350, 25, "Spread: "+MarketInfo(Symbol(), MODE_SPREAD), White);
      create_label("max", 0, 0, 0, 0, x+350, 55, "Max: "+max+", Best: " + best + "("+get_strategy_name(best)+")", White);
      Comment(infobox);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+