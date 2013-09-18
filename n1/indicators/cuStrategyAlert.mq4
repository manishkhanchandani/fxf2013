//+------------------------------------------------------------------+
//|                                              cuStrategyAlert.mq4 |
//|                                              Manish Khanchandani |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://forexmastery.org"

#include <strategies.mqh>
#property indicator_chart_window
extern int no_of_days = 5;
int opentime;
#define STRATEGYMAX  41
      string box = "";
      int grand_total[STRATEGYMAX];
      int grand_strategy[STRATEGYMAX];
      int i;
      int check[STRATEGYMAX];
      int check2[STRATEGYMAX];
      int check3[STRATEGYMAX];
      int check4[STRATEGYMAX];
      int check5[STRATEGYMAX];
      int bar[STRATEGYMAX];
      
         int top1 = 0;
         int top2 = 0;
         int top3 = 0;
         int top4 = 0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators

      string results[];
      for (i = 0; i < STRATEGYMAX; i++) {
         grand_total[i] = 0;
         grand_strategy[i] = 0;
      }
      for (i = 0; i <= STRATEGYMAX; i++) {
         if (i == 31) continue;
         int strategy = i; //StrToInteger(results[i]);
         //check[i] = get_strategy_result(strategy, Symbol(), Period(), 1, 0);
         //check2[i] = get_strategy_result(strategy, Symbol(), Period(), 1, 1);
         for (int j = 1; j < 500; j++) {
            check3[i] = iCustom(Symbol(), Period(), "cuSpanTime", strategy, no_of_days, 2, j);
            if (check3[i] != 0 && check3[i] != EMPTY_VALUE) {
               if (j == 1) {
                  Alert("cuStrategyAlert: ", Symbol(), " strategy: ", strategy, ", Result: ", check3[i], ", ", get_strategy_name(strategy), ", ", Period());
               }
               bar[i] = j;
               check4[i] = iCustom(Symbol(), Period(), "cuSpanTime", strategy, no_of_days, 3, 0);
               check5[i] = iCustom(Symbol(), Period(), "cuSpanTime", strategy, no_of_days, 4, 0);
               grand_total[i] = check5[i];
               grand_strategy[i] = strategy;
               break;
            }
         }
        
      }
      
         int max = -9999;
         for (i = 0; i <= STRATEGYMAX; i++) {
            if (grand_total[i] <= 0) continue;
            if (grand_total[i] > max) {
               max = grand_total[i];
               top1 = i;
            } 
         }
         max = -9999;
         for (i = 0; i <= STRATEGYMAX; i++) {
            if (grand_total[i] <= 0) continue;
            if (grand_total[i] > max && i != top1) {
               max = grand_total[i];
               top2 = i;
            }  
         }
         max = -9999;
         for (i = 0; i <= STRATEGYMAX; i++) {
            if (grand_total[i] <= 0) continue;
            if (grand_total[i] > max && i != top1 && i != top2) {
               max = grand_total[i];
               top3 = i;
            }  
         }
         max = -9999;
         for (i = 0; i <= STRATEGYMAX; i++) {
            if (grand_total[i] <= 0) continue;
            if (grand_total[i] > max && i != top1 && i != top2 && i != top3) {
               max = grand_total[i];
               top4 = i;
            } 
         }
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
      box = "";
      int strategy;
      int j;
         box = box + "\nSpread: " + MarketInfo(Symbol(), MODE_SPREAD) + "\n";
         i = top1;
         strategy = i;
         check[i] = get_strategy_result(strategy, Symbol(), Period(), 1, 0);
         check2[i] = get_strategy_result(strategy, Symbol(), Period(), 1, 1);
         for ( j = 1; j < 500; j++) {
            check3[i] = iCustom(Symbol(), Period(), "cuSpanTime", strategy, no_of_days, 2, j);
            if (check3[i] != 0 && check3[i] != EMPTY_VALUE) {
               bar[i] = j;
               check4[i] = iCustom(Symbol(), Period(), "cuSpanTime", strategy, no_of_days, 3, 0);
               check5[i] = iCustom(Symbol(), Period(), "cuSpanTime", strategy, no_of_days, 4, 0);
               break;
            }
         }
         box = box + "\nTop1 Strategy: " + grand_strategy[i] + ", Name: " + get_strategy_name(grand_strategy[i]) +
            ", Change: " + check[i] + ", Current: " + check2[i] +
            ", Type: " + parse(check3[i]) + " at bar: " + bar[i] + ", Value: " + check4[i] + ", Total: " + check5[i];
         i = top2;
         strategy = i;
         check[i] = get_strategy_result(strategy, Symbol(), Period(), 1, 0);
         check2[i] = get_strategy_result(strategy, Symbol(), Period(), 1, 1);
         for ( j = 1; j < 500; j++) {
            check3[i] = iCustom(Symbol(), Period(), "cuSpanTime", strategy, no_of_days, 2, j);
            if (check3[i] != 0 && check3[i] != EMPTY_VALUE) {
               bar[i] = j;
               check4[i] = iCustom(Symbol(), Period(), "cuSpanTime", strategy, no_of_days, 3, 0);
               check5[i] = iCustom(Symbol(), Period(), "cuSpanTime", strategy, no_of_days, 4, 0);
               break;
            }
         }
         box = box + "\nTop2 Strategy: " + grand_strategy[i] + ", Name: " + get_strategy_name(grand_strategy[i]) +
            ", Change: " + check[i] + ", Current: " + check2[i] +
            ", Type: " + parse(check3[i]) + " at bar: " + bar[i] + ", Value: " + check4[i] + ", Total: " + check5[i];
         i = top3;
         strategy = i;
         check[i] = get_strategy_result(strategy, Symbol(), Period(), 1, 0);
         check2[i] = get_strategy_result(strategy, Symbol(), Period(), 1, 1);
         for ( j = 1; j < 500; j++) {
            check3[i] = iCustom(Symbol(), Period(), "cuSpanTime", strategy, no_of_days, 2, j);
            if (check3[i] != 0 && check3[i] != EMPTY_VALUE) {
               bar[i] = j;
               check4[i] = iCustom(Symbol(), Period(), "cuSpanTime", strategy, no_of_days, 3, 0);
               check5[i] = iCustom(Symbol(), Period(), "cuSpanTime", strategy, no_of_days, 4, 0);
               break;
            }
         }
         box = box + "\nTop3 Strategy: " + grand_strategy[i] + ", Name: " + get_strategy_name(grand_strategy[i]) +
            ", Change: " + check[i] + ", Current: " + check2[i] +
            ", Type: " + parse(check3[i]) + " at bar: " + bar[i] + ", Value: " + check4[i] + ", Total: " + check5[i];
         i = top4;
         strategy = i;
         check[i] = get_strategy_result(strategy, Symbol(), Period(), 1, 0);
         check2[i] = get_strategy_result(strategy, Symbol(), Period(), 1, 1);
         for ( j = 1; j < 500; j++) {
            check3[i] = iCustom(Symbol(), Period(), "cuSpanTime", strategy, no_of_days, 2, j);
            if (check3[i] != 0 && check3[i] != EMPTY_VALUE) {
               bar[i] = j;
               check4[i] = iCustom(Symbol(), Period(), "cuSpanTime", strategy, no_of_days, 3, 0);
               check5[i] = iCustom(Symbol(), Period(), "cuSpanTime", strategy, no_of_days, 4, 0);
               break;
            }
         }
         box = box + "\nTop4 Strategy: " + grand_strategy[i] + ", Name: " + get_strategy_name(grand_strategy[i]) +
            ", Change: " + check[i] + ", Current: " + check2[i] +
            ", Type: " + parse(check3[i]) + " at bar: " + bar[i] + ", Value: " + check4[i] + ", Total: " + check5[i];
         
      Comment(box);
      opentime = Time[0];
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+