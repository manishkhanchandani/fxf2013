//+------------------------------------------------------------------+
//|                                            custom_strategy_multi.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"
//multi strategy
#include <custom_currency_fetch.mqh>
double amount[30][7];
int amount_type[30][7];
int amount_chinkouspan[30][7];
int amount_span[30][7];

int condition[30][4];
int condition_multi[30][9][10];
int condition_time[30][9];
int condition_count[30][9];
extern int strategytype = 6;
string filename;
   double previous_bids[30];
   double previous_asks[30];
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   custom_init();
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
   custom_start();   
//----
   return(0);
  }
//+------------------------------------------------------------------+

int strategy(string symbol, int number)
{
   double bids, asks, point;
   int digit;
   if (current_currency_pair) {
      bids = Bid;
      asks = Ask;
      point = Point;
      digit = Digits;
   } else {
      bids = MarketInfo(symbol, MODE_BID);
      asks = MarketInfo(symbol, MODE_ASK);
      point = MarketInfo(symbol, MODE_POINT);
      digit = MarketInfo(symbol, MODE_DIGITS);
   }

   if(DayOfWeek()==0 || DayOfWeek()==6) {
      infobox = StringConcatenate(infobox, "Holiday so no trading");
      return (0);
   }

   infobox = StringConcatenate(infobox, " - Time: ", timestr(TimeCurrent()), "(",TimeDayOfWeek(TimeCurrent()),")");
   if (MarketInfo(symbol, MODE_SPREAD) > 100) {
      infobox = StringConcatenate(infobox, " - ", MarketInfo(symbol, MODE_SPREAD), ": Spread greater than 100");
      return (0);
   } else {
      infobox = StringConcatenate(infobox, " - Sp: ", MarketInfo(symbol, MODE_SPREAD));
   }

   filename = "customall_" + Year() + "_" + Month() + "_" + Day()  + ".txt";
   //FileAppend(filename, "Time: "+timestr(TimeCurrent()));
   string condition_name;
   //int period[5] = {PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1}; //, PERIOD_H4, PERIOD_D1, PERIOD_MN1, PERIOD_W1, 
   int period[9] = {PERIOD_D1, PERIOD_H4, PERIOD_H1, PERIOD_M30, PERIOD_M15, PERIOD_M5, PERIOD_M1, PERIOD_MN1, PERIOD_W1};
   int limit;
   if (current_period) {
      period[0] = Period();
      limit = 1;  
   } else {
      limit = 7;
   }
   string mes;
   int i;
   bool condition_buy, condition_sell, condition_buy2, condition_sell2;
   double tenkan_sen_1, tenkan_sen_2, tenkan_sen_3, tenkan_sen_4, kijun_sen_1, kijun_sen_2, kijun_sen_3, kijun_sen_4, spanA, spanB, chinkouspan, spanHigh, spanLow, spanHigh2, spanLow2, spanAb, spanBb, spanAc, spanBc, spanAd, spanBd;

   double ima50, ima100;
   
   
   //for case 6
   if (strategytype == 6 || strategytype == 7 || strategytype == 11) {
      period[0] = Period();
      limit = 1;  
   }
   
   double StopLoss = 40.0;
   double TakeProfit = 0.0;
   double Slippage = 5.0;
   double beginer = 64.0;
   double periodtotake = 64.0;
   int l_count_0 = 0;
   double l_lots_4 = 0;
   double ld_unused_12 = 0;
   double ld_unused_20 = 0;
   double ld_28 = 0;
   double ld_36 = 0;
   double ld_44 = 0;
   double ld_unused_52 = 0;
   double ld_unused_60 = 0;
   double ld_unused_68 = 0;
   double ld_unused_76 = 0;
   double ld_84 = 0;
   double l_low_92 = 0;
   double l_high_100 = 0;
   double ld_108 = 0;
   double ld_116 = 0;
   double ld_124 = 0;
   double ld_132 = 0;
   double ld_140 = 0;
   double ld_148 = 0;
   double ld_156 = 0;
   double ld_164 = 0;
   double ld_172 = 0;
   double ld_180 = 0;
   double ld_188 = 0;
   double ld_196 = 0;
   double ld_204 = 0;
   double ld_212 = 0;
   double ld_220 = 0;
   double ld_228 = 0;
   double ld_236 = 0;
   double ld_244 = 0;
   double ld_252 = 0;
   double ld_260 = 0;
   double ld_268 = 0;
   double ld_276 = 0;
   double ld_284 = 0;
   double ld_292 = 0;
   double ld_300 = 0;
   double ld_308 = 0;
   double ld_316 = 0;
   double ld_324 = 0;
   double ld_332 = 0;
   double ld_340 = 0;
   double ld_348 = 0;
   double ld_356 = 0;
   double ld_364 = 0;
   ld_28 = 0;
   l_lots_4 = Lots;
   //case 8
   int iHi, iLo, iHi2, iLo2, tmp;
   double xLo, xHig, xLo2, xHig2;
   int NewPeriod = 20;
   //custom
   double val1, val2, val3, val4, val5, val6, val7, val8;
   for (i=0; i < limit; i++) {
      mes = "";
      infobox = StringConcatenate(infobox, " - P: ", TimeframeToString(period[i])); 
      condition_buy = false;
      condition_sell = false;

      switch (strategytype) {
         case 1:
            condition_name = "Ichimoku";
            tenkan_sen_1=iIchimoku(symbol, period[i], 9, 26, 52, MODE_TENKANSEN, 1);
            tenkan_sen_2=iIchimoku(symbol, period[i], 9, 26, 52, MODE_TENKANSEN, 2);
            kijun_sen_1=iIchimoku(symbol, period[i], 9, 26, 52, MODE_KIJUNSEN, 1);
            kijun_sen_2=iIchimoku(symbol, period[i], 9, 26, 52, MODE_KIJUNSEN, 2);
            chinkouspan = iIchimoku(symbol, period[i], 9, 26, 52, MODE_CHINKOUSPAN, 27);
            spanA = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, 1);
            spanB = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, 1);
            if (spanA > spanB) {
               spanHigh = spanA;
               spanLow = spanB;
               spanHigh2 = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, 2);
               spanLow2 = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, 2);
            } else {
               spanHigh = spanB;
               spanLow = spanA;
               spanHigh2 = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, 2);
               spanLow2 = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, 2);
            }
     
            condition_buy = (tenkan_sen_1 > kijun_sen_1 && tenkan_sen_2 < kijun_sen_2 && chinkouspan > iHigh(symbol, period[i], 27));// && kijun_sen_1 > kijun_sen_2
            condition_sell = (tenkan_sen_1 < kijun_sen_1 && tenkan_sen_2 > kijun_sen_2 && chinkouspan < iLow(symbol, period[i], 27));// && kijun_sen_1 < kijun_sen_2
     
            if (condition_buy) {
               if (reverse_bid_if_profit) reverse_bid(symbol, 1);
               else if (reverse_bid_force) reverse_bid_force(symbol, 1);
            } else if (condition_sell) {
               if (reverse_bid_if_profit) reverse_bid(symbol, -1);
               else if (reverse_bid_force) reverse_bid_force(symbol, -1);
            }
            if (condition_buy) {
               messages[number] = "buy";
               call_order_creation(true, false, condition_name, symbol, period[i], number, i, bids, "");
            } else if (condition_sell) {
               messages[number] = "sell";
               call_order_creation(false, true, condition_name, symbol, period[i], number, i, bids, "");
            }
            break;
         case 2:
            condition_name = "Kumobreakout";
            
            tenkan_sen_1=iIchimoku(symbol, period[i], 9, 26, 52, MODE_TENKANSEN, 1);
            tenkan_sen_2=iIchimoku(symbol, period[i], 9, 26, 52, MODE_TENKANSEN, 2);
            kijun_sen_1=iIchimoku(symbol, period[i], 9, 26, 52, MODE_KIJUNSEN, 1);
            kijun_sen_2=iIchimoku(symbol, period[i], 9, 26, 52, MODE_KIJUNSEN, 2);
            chinkouspan = iIchimoku(symbol, period[i], 9, 26, 52, MODE_CHINKOUSPAN, 27);
            spanA = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, 1);
            spanB = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, 1);
            if (spanA > spanB) {
               spanHigh = spanA;
               spanLow = spanB;
               spanHigh2 = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, 2);
               spanLow2 = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, 2);
            } else {
               spanHigh = spanB;
               spanLow = spanA;
               spanHigh2 = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, 2);
               spanLow2 = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, 2);
            }
     
            condition_buy = (
               //tenkan_sen_1 > kijun_sen_1 
               iClose(symbol, period[i], 1) > spanHigh 
               && iOpen(symbol, period[i], 1) < spanHigh 
               && chinkouspan > iHigh(symbol, period[i], 27) 
               //&& spanHigh >= spanHigh2
               );
            condition_sell = (
               //tenkan_sen_1 < kijun_sen_1 
               iClose(symbol, period[i], 1) < spanLow 
               && iOpen(symbol, period[i], 1) > spanLow 
               && chinkouspan < iLow(symbol, period[i], 27)
               //&& spanLow <= spanLow2
               );
     
            if (tenkan_sen_1 > kijun_sen_1 && tenkan_sen_2 < kijun_sen_2) {
               if (reverse_bid_if_profit) reverse_bid(symbol, 1);
               else if (reverse_bid_force) reverse_bid_force(symbol, 1);
            } else if (tenkan_sen_1 < kijun_sen_1 && tenkan_sen_2 > kijun_sen_2) {
               if (reverse_bid_if_profit) reverse_bid(symbol, -1);
               else if (reverse_bid_force) reverse_bid_force(symbol, -1);
            }
            if (condition_buy) {
               messages[number] = "buy";
               call_order_creation(true, false, condition_name, symbol, period[i], number, i, bids, "");
            } else if (condition_sell) {
               messages[number] = "sell";
               call_order_creation(false, true, condition_name, symbol, period[i], number, i, bids, "");
            }
            break;
         case 3:
            condition_name = "SpanAB";
            
            spanA = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, -25);
            spanB = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, -25);
            spanAb = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, -24);
            spanBb = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, -24);
            spanAc = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, -23);
            spanBc = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, -23);
            infobox = StringConcatenate(infobox, ", Sp: ", spanA, " = ", spanB, " = ", spanAb, " = ", spanBb);
            condition_buy = (
               spanAb < spanBb
               && spanA > spanB
               );
            condition_sell = (
               spanAb > spanBb
               && spanA < spanB
               );
            if (condition_buy) {
               if (reverse_bid_if_profit) reverse_bid(symbol, 1);
               else if (reverse_bid_force) reverse_bid_force(symbol, 1);
            } else if (condition_sell) {
               if (reverse_bid_if_profit) reverse_bid(symbol, -1);
               else if (reverse_bid_force) reverse_bid_force(symbol, -1);
            }
            if (condition_buy) {
               importantbox = StringConcatenate(importantbox, symbol, ", ", TimeframeToString(period[i]), ", Buy\n");
               messages[number] = "buy";
               call_order_creation(true, false, condition_name, symbol, period[i], number, i, bids, TimeframeToString(period[i]));
            } else if (condition_sell) {
               importantbox = StringConcatenate(importantbox, symbol, ", ", TimeframeToString(period[i]), ", Sell\n");
               messages[number] = "sell";
               call_order_creation(false, true, condition_name, symbol, period[i], number, i, bids, TimeframeToString(period[i]));
            }
            break;
         
         case 4:
            condition_name = "SpanAB2";
            
            spanA = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, -25);
            spanB = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, -25);
            spanAb = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, -24);
            spanBb = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, -24);
            spanAc = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, -23);
            spanBc = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, -23);
            condition_buy = (
               spanAb < spanBb
               && spanA > spanB
               );
            condition_sell = (
               spanAb > spanBb
               && spanA < spanB
               );
            if (condition_buy) {
               if (reverse_bid_if_profit) reverse_bid(symbol, 1);
               else if (reverse_bid_force) reverse_bid_force(symbol, 1);
               condition_multi[number][i][0] = 1;
            } else if (condition_sell) {
               if (reverse_bid_if_profit) reverse_bid(symbol, -1);
               else if (reverse_bid_force) reverse_bid_force(symbol, -1);
               condition_multi[number][i][0] = -1;
            }
            spanA = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, -22);
            spanB = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, -22);
            spanAb = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, -21);
            spanBb = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, -21);
            spanAc = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, -20);
            spanBc = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, -20);
            importantbox = StringConcatenate(importantbox, symbol, ", condition_multi[number][i][0]: ", condition_multi[number][i][0], ", (", (spanA > spanAb), ", ", (spanAb > spanAc), "), (", (spanA < spanAb), ", ", (spanAb < spanAc), ")\n");
            condition_buy = (
               condition_multi[number][i][0] == 1
               && spanA > spanAb && spanAb > spanAc
               );
            condition_sell = (
               condition_multi[number][i][0] == -1
               && spanA < spanAb && spanAb < spanAc
               );
            if (condition_buy) {
               condition_multi[number][i][0] = 0;
               importantbox = StringConcatenate(importantbox, symbol, ", ", TimeframeToString(period[i]), ", Buy\n");
               messages[number] = "buy";
               call_order_creation(true, false, condition_name, symbol, period[i], number, i, bids, TimeframeToString(period[i]));
            } else if (condition_sell) {
               condition_multi[number][i][0] = 0;
               importantbox = StringConcatenate(importantbox, symbol, ", ", TimeframeToString(period[i]), ", Sell\n");
               messages[number] = "sell";
               call_order_creation(false, true, condition_name, symbol, period[i], number, i, bids, TimeframeToString(period[i]));
            }
            break;
         case 6:
            l_low_92 = Low[iLowest(symbol, period[i], MODE_LOW, beginer, periodtotake)];
            l_high_100 = High[iHighest(symbol, period[i], MODE_HIGH, beginer, periodtotake)];
            if (l_high_100 <= 250000.0 && l_high_100 > 25000.0) ld_108 = 100000;
            else {
               if (l_high_100 <= 25000.0 && l_high_100 > 2500.0) ld_108 = 10000;
               else {
                  if (l_high_100 <= 2500.0 && l_high_100 > 250.0) ld_108 = 1000;
                  else {
                     if (l_high_100 <= 250.0 && l_high_100 > 25.0) ld_108 = 100;
                     else {
                        if (l_high_100 <= 25.0 && l_high_100 > 12.5) ld_108 = 12.5;
                        else {
                           if (l_high_100 <= 12.5 && l_high_100 > 6.25) ld_108 = 12.5;
                           else {
                              if (l_high_100 <= 6.25 && l_high_100 > 3.125) ld_108 = 6.25;
                              else {
                                 if (l_high_100 <= 3.125 && l_high_100 > 1.5625) ld_108 = 3.125;
                                 else {
                                    if (l_high_100 <= 1.5625 && l_high_100 > 0.390625) ld_108 = 1.5625;
                                    else
                                       if (l_high_100 <= 0.390625 && l_high_100 > 0.0) ld_108 = 0.1953125;
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
            ld_228 = l_high_100 - l_low_92;
            ld_84 = MathFloor(MathLog(ld_108 / ld_228) / MathLog(2));
            ld_236 = ld_108 * MathPow(0.5, ld_84);
            ld_244 = MathFloor(l_low_92 / ld_236) * ld_236;
            if (ld_244 + ld_236 > l_high_100) ld_252 = ld_244 + ld_236;
            else ld_252 = ld_244 + 2.0 * ld_236;
            if (l_low_92 >= 0.0 * (ld_252 - ld_244) + ld_244 && l_high_100 <= 0.0 * (ld_252 - ld_244) + ld_244) ld_284 = ld_244 + (ld_252 - ld_244) / 2.0;
            else ld_284 = 0;
            if (l_low_92 >= ld_244 - (ld_252 - ld_244) / 8.0 && l_high_100 <= 0.0 * (ld_252 - ld_244) + ld_244 && ld_284 == 0.0) ld_276 = ld_244 + (ld_252 - ld_244) / 2.0;
            else ld_276 = 0;
            if (l_low_92 >= ld_244 + 7.0 * (ld_252 - ld_244) / 16.0 && l_high_100 <= 0.0 * (ld_252 - ld_244) + ld_244) ld_300 = ld_244 + 3.0 * (ld_252 - ld_244) / 4.0;
            else ld_300 = 0;
            if (l_low_92 >= ld_244 + 3.0 * (ld_252 - ld_244) / 8.0 && l_high_100 <= 1.0 * (ld_252 - ld_244) + ld_244 && ld_300 == 0.0) ld_308 = ld_252;
            else ld_308 = 0;
            if (l_low_92 >= ld_244 + (ld_252 - ld_244) / 8.0 && l_high_100 <= 0.0 * (ld_252 - ld_244) + ld_244 && ld_276 == 0.0 && ld_284 == 0.0 && ld_300 == 0.0 && ld_308 == 0.0) ld_292 = ld_244 + 3.0 * (ld_252 - ld_244) / 4.0;
            else ld_292 = 0;
            if (ld_276 + ld_284 + ld_292 + ld_300 + ld_308 == 0.0) ld_316 = ld_252;
            else ld_316 = 0;
            ld_260 = ld_276 + ld_284 + ld_292 + ld_300 + ld_308 + ld_316;
            if (ld_276 > 0.0) ld_324 = ld_244;
            else ld_324 = 0;
            if (ld_284 > 0.0) ld_332 = ld_244 + (ld_252 - ld_244) / 4.0;
            else ld_332 = 0;
            if (ld_292 > 0.0) ld_340 = ld_244 + (ld_252 - ld_244) / 4.0;
            else ld_340 = 0;
            if (ld_300 > 0.0) ld_348 = ld_244 + (ld_252 - ld_244) / 2.0;
            else ld_348 = 0;
            if (ld_308 > 0.0) ld_356 = ld_244 + (ld_252 - ld_244) / 2.0;
            else ld_356 = 0;
            if (ld_260 > 0.0 && ld_324 + ld_332 + ld_340 + ld_348 + ld_356 == 0.0) ld_364 = ld_244;
            else ld_364 = 0;
            ld_268 = ld_324 + ld_332 + ld_340 + ld_348 + ld_356 + ld_364;
            ld_116 = (ld_260 - ld_268) / 8.0;
            ld_124 = ld_268 - 2.0 * ld_116;
            ld_132 = ld_268 - ld_116;
            ld_140 = ld_268;
            ld_148 = ld_268 + ld_116;
            ld_156 = ld_268 + 2.0 * ld_116;
            ld_164 = ld_268 + 3.0 * ld_116;
            ld_172 = ld_268 + 4.0 * ld_116;
            ld_180 = ld_268 + 5.0 * ld_116;
            ld_188 = ld_268 + 6.0 * ld_116;
            ld_196 = ld_268 + 7.0 * ld_116;
            ld_204 = ld_268 + 8.0 * ld_116;
            ld_220 = ld_268 + 9.0 * ld_116;
            ld_212 = ld_268 + 10.0 * ld_116;
            if (iOpen(symbol, period[i], 1) < (ld_268 - 10.0 * ld_116)) {
               infobox = StringConcatenate(infobox, " - Level: -10");
            } else {
               infobox = StringConcatenate(infobox, " - Not Defined");
            }
            /*infobox = StringConcatenate(infobox, "\nPLACE A BUY ORDER AT ", ld_140, "  PLACE A SELL ORDER AT ", ld_204,  "  PLACE A Take Profit AT ", ld_172);
            infobox = StringConcatenate(infobox, "\nPLACE A stoploss for buy AT ", (ld_140 - StopLoss * point)
            , "  PLACE A stoploss for buy sell AT ", (ld_204 + StopLoss * point));
            infobox = StringConcatenate(infobox, "\n-10th AT ", DoubleToStr((ld_268 - 10.0 * ld_116), digit));
            infobox = StringConcatenate(infobox, " -9th AT ", DoubleToStr((ld_268 - 9.0 * ld_116), digit));
            infobox = StringConcatenate(infobox, "\n-8th AT ", DoubleToStr((ld_268 - 8.0 * ld_116), digit));
            infobox = StringConcatenate(infobox, " -7th AT ", DoubleToStr((ld_268 - 7.0 * ld_116), digit));
            infobox = StringConcatenate(infobox, "\n-6th AT ", DoubleToStr((ld_268 - 6.0 * ld_116), digit));
            infobox = StringConcatenate(infobox, " -5th AT ", DoubleToStr((ld_268 - 5.0 * ld_116), digit));
            infobox = StringConcatenate(infobox, "\n-4th AT ", DoubleToStr((ld_268 - 4.0 * ld_116), digit));
            infobox = StringConcatenate(infobox, " -3th AT ", DoubleToStr((ld_268 - 3.0 * ld_116), digit));
            infobox = StringConcatenate(infobox, "\n-2th AT ", DoubleToStr(ld_124, digit));
            infobox = StringConcatenate(infobox, " -1th AT ", DoubleToStr(ld_132, digit));
            infobox = StringConcatenate(infobox, "\n0th AT ", DoubleToStr(ld_140, digit));
            infobox = StringConcatenate(infobox, " 1th AT ", DoubleToStr(ld_148, digit));
            infobox = StringConcatenate(infobox, " 2th AT ", DoubleToStr(ld_156, digit));
            infobox = StringConcatenate(infobox, "\n3th AT ", DoubleToStr(ld_164, digit));
            infobox = StringConcatenate(infobox, " 4th AT ", DoubleToStr(ld_172, digit));
            infobox = StringConcatenate(infobox, "\n5th AT ", DoubleToStr(ld_180, digit));
            infobox = StringConcatenate(infobox, " 6th AT ", DoubleToStr(ld_188, digit));
            infobox = StringConcatenate(infobox, "\n7th AT ", DoubleToStr(ld_196, digit));
            infobox = StringConcatenate(infobox, " 8th AT ", DoubleToStr(ld_204, digit));
            infobox = StringConcatenate(infobox, "\n9th AT ", DoubleToStr(ld_220, digit));
            infobox = StringConcatenate(infobox, " 10th AT ", DoubleToStr(ld_212, digit));
            */
            /*
            if (iOpen(symbol, period[i], 1) < ld_140) {
               if (ld_28 < 1.0 && ld_36 == 0.0) {
                  ld_36 = 2;
                  MOrderSend(symbol, OP_BUYSTOP, l_lots_4, ld_140, Slippage, ld_140 - StopLoss * point, ld_172, "", MAGICMA, 0, Blue);
                  return (0);
               }
            }
            if (iOpen(symbol, period[i], 1) > ld_140) {
               if (ld_28 < 1.0 && ld_36 == 0.0) {
                  ld_36 = 2;
                  MOrderSend(symbol, OP_BUYLIMIT, l_lots_4, ld_140, Slippage, ld_140 - StopLoss * point, ld_172, "", MAGICMA, 0, Blue);
                  return (0);
               }
            }
            if (iOpen(symbol, period[i], 1) > ld_204) {
               if (ld_28 == 1.0 && ld_44 == 0.0 && ld_36 > 0.0) {
                  ld_44 = 2;
                  MOrderSend(symbol, OP_SELLSTOP, l_lots_4, ld_204, Slippage, ld_204 + StopLoss * point, ld_172, "", MAGICMA, 0, Red);
                  return (0);
               }
            }
            if (iOpen(symbol, period[i], 1) < ld_204) {
               if (ld_28 == 1.0 && ld_44 == 0.0 && ld_36 > 0.0) {
                  ld_44 = 2;
                  MOrderSend(symbol, OP_SELLLIMIT, l_lots_4, ld_204, Slippage, ld_204 + StopLoss * point, ld_172, "", MAGICMA, 0, Red);
                  return (0);
               }
            }
            */
            break;
         case 7://experimental
            
            condition_name = "Ichimoku";
            tenkan_sen_1=iIchimoku(symbol, period[i], 9, 26, 52, MODE_TENKANSEN, 1);
            tenkan_sen_2=iIchimoku(symbol, period[i], 9, 26, 52, MODE_TENKANSEN, 2);
            kijun_sen_1=iIchimoku(symbol, period[i], 9, 26, 52, MODE_KIJUNSEN, 1);
            kijun_sen_2=iIchimoku(symbol, period[i], 9, 26, 52, MODE_KIJUNSEN, 2);
            chinkouspan = iIchimoku(symbol, period[i], 9, 26, 52, MODE_CHINKOUSPAN, 27);
            spanA = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, 1);
            spanB = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, 1);
            if (spanA > spanB) {
               spanHigh = spanA;
               spanLow = spanB;
               spanHigh2 = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, 2);
               spanLow2 = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, 2);
            } else {
               spanHigh = spanB;
               spanLow = spanA;
               spanHigh2 = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, 2);
               spanLow2 = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, 2);
            }
     
            condition_buy = (tenkan_sen_1 > kijun_sen_1 && tenkan_sen_2 <= kijun_sen_2);
            condition_sell = (tenkan_sen_1 < kijun_sen_1 && tenkan_sen_2 >= kijun_sen_2);
     
            if (condition_buy) {
               condition_multi[number][i][0] = 1;
               if (reverse_bid_if_profit) reverse_bid(symbol, 1);
               else if (reverse_bid_force) reverse_bid_force(symbol, 1);
            } else if (condition_sell) {
               condition_multi[number][i][0] = -1;
               if (reverse_bid_if_profit) reverse_bid(symbol, -1);
               else if (reverse_bid_force) reverse_bid_force(symbol, -1);
            }
            
            condition_buy = (
               iClose(symbol, period[i], 1) > spanHigh
               && iOpen(symbol, period[i], 1) < spanHigh
               && spanHigh >= spanHigh2
               );
            condition_sell = (
               iClose(symbol, period[i], 1) < spanLow 
               && iOpen(symbol, period[i], 1) > spanLow 
               && spanLow <= spanLow
               );
            if (condition_buy) {
               condition_multi[number][i][1] = 1;
            } else if (condition_sell) {
               condition_multi[number][i][1] = -1;
            }
            
            condition_buy = (
               chinkouspan > iHigh(symbol, period[i], 27)
               );
            condition_sell = (
               chinkouspan > iLow(symbol, period[i], 27)
               );
            if (condition_buy) {
               condition_multi[number][i][2] = 1;
            } else if (condition_sell) {
               condition_multi[number][i][2] = -1;
            }
            spanA = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, -25);
            spanB = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, -25);
            spanAb = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, -24);
            spanBb = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, -24);
            spanAc = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, -23);
            spanBc = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, -23);
            condition_buy = (
               spanAb < spanBb
               && spanA > spanB
               );
            condition_sell = (
               spanAb > spanBb
               && spanA < spanB
               );
     
            if (condition_buy) {
               condition_multi[number][i][3] = 1;
            } else if (condition_sell) {
               condition_multi[number][i][3] = -1;
            }
            condition_buy = (
               spanA > spanAb
               && spanAb != spanAc
               );
            condition_sell = (
               spanA < spanAb
               && spanAb != spanAc
               );
     
            if (condition_buy) {
               condition_multi[number][i][4] = 1;
            } else if (condition_sell) {
               condition_multi[number][i][4] = -1;
            }
            if (condition_multi[number][i][0] == 1 && condition_multi[number][i][1] == 1 && condition_multi[number][i][2] == 1 && condition_multi[number][i][3] == 1 && condition_multi[number][i][4] == 1) {
               messages[number] = "buy";
               call_order_creation(true, false, condition_name, symbol, period[i], number, i, bids, "");
               condition_multi[number][i][0] = 0;
               condition_multi[number][i][1] = 0;
               condition_multi[number][i][2] = 0;
               condition_multi[number][i][3] = 0;
            } else if (condition_multi[number][i][0] == -1 && condition_multi[number][i][1] == -1 && condition_multi[number][i][2] == -1 && condition_multi[number][i][3] == -1 && condition_multi[number][i][4] == -1) {
               messages[number] = "sell";
               call_order_creation(false, true, condition_name, symbol, period[i], number, i, bids, "");
               condition_multi[number][i][0] = 0;
               condition_multi[number][i][1] = 0;
               condition_multi[number][i][2] = 0;
               condition_multi[number][i][3] = 0;
            }
            break;
            /*
            condition_name = "SpanAB7";
            int trend = 0;
            spanA = iIchimoku(symbol, PERIOD_M15, 9, 26, 52, MODE_SENKOUSPANA, 1);
            spanB = iIchimoku(symbol, PERIOD_M15, 9, 26, 52, MODE_SENKOUSPANB, 1);
            if (spanA > spanB) {
               trend = 1;
            } else if (spanA < spanB) {
               trend = -1;
            }
            spanA = iIchimoku(symbol, PERIOD_M15, 9, 26, 52, MODE_SENKOUSPANA, -25);
            spanB = iIchimoku(symbol, PERIOD_M15, 9, 26, 52, MODE_SENKOUSPANB, -25);
            spanAb = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, -24);
            spanBb = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, -24);
            condition_buy = (
               spanAb < spanBb
               && spanA > spanB
               );
            condition_sell = (
               spanAb > spanBb
               && spanA < spanB
               );
            if (condition_buy) {
               if (reverse_bid_if_profit) reverse_bid(symbol, 1);
               else if (reverse_bid_force) reverse_bid_force(symbol, 1);
            } else if (condition_sell) {
               if (reverse_bid_if_profit) reverse_bid(symbol, -1);
               else if (reverse_bid_force) reverse_bid_force(symbol, -1);
            }
            if (condition_buy
               && trend == 1) {
               importantbox = StringConcatenate(importantbox, symbol, ", ", TimeframeToString(period[i]), ", Buy\n");
               messages[number] = "buy";
               call_order_creation(true, false, condition_name, symbol, period[i], number, i, bids, TimeframeToString(period[i]));
            } else if (condition_sell
               && trend == -1) {
               importantbox = StringConcatenate(importantbox, symbol, ", ", TimeframeToString(period[i]), ", Sell\n");
               messages[number] = "sell";
               call_order_creation(false, true, condition_name, symbol, period[i], number, i, bids, TimeframeToString(period[i]));
            }
            break;*/
         case 8:
            //sell
            iHi=iHighest(symbol, period[i],MODE_HIGH,NewPeriod,1);
            xHig=iHigh(symbol, period[i],iHi); 
            iLo=iLowest(symbol, period[i],MODE_LOW,iHi-1,1);
            xLo=iLow(symbol, period[i],iLo);
            if (iLow(symbol, period[i], 1) <= xLo) {
               if (reverse_bid_if_profit) reverse_bid(symbol, -1);
               else if (reverse_bid_force) reverse_bid_force(symbol, -1);
               importantbox = StringConcatenate(importantbox, symbol, ", ", TimeframeToString(period[i]), ", Sell\n");
               messages[number] = "sell";
               call_order_creation(false, true, condition_name, symbol, period[i], number, i, bids, TimeframeToString(period[i]));
            }
            //buy
            iLo=iLowest(symbol, period[i],MODE_LOW,NewPeriod,1);
            xLo=iLow(symbol, period[i],iLo); 
            iHi=iHighest(symbol, period[i],MODE_HIGH,iLo-1,1);
            xHig=iHigh(symbol, period[i],iHi);
            if (iHigh(symbol, period[i], 1) >= xHig) {
               if (reverse_bid_if_profit) reverse_bid(symbol, 1);
               else if (reverse_bid_force) reverse_bid_force(symbol, 1);
               importantbox = StringConcatenate(importantbox, symbol, ", ", TimeframeToString(period[i]), ", Buy\n");
               messages[number] = "buy";
               call_order_creation(true, false, condition_name, symbol, period[i], number, i, bids, TimeframeToString(period[i]));
            }
            break;
         case 9:
               if (!previous_bids[number]) previous_bids[number] = bids;
               if (!previous_asks[number]) previous_asks[number] = asks;
               infobox = StringConcatenate(infobox, "\nBids Difference: ", ((bids - previous_bids[number])/point));
               infobox = StringConcatenate(infobox, " - Asks Difference: ", ((asks - previous_asks[number])/point));
               infobox = StringConcatenate(infobox, "\n");
               val1 = iCustom(symbol,period[i],"MACD Alert",2,1);
               val2 = iCustom(symbol,period[i],"MACD Alert",3,1);
               val3 = iCustom(symbol,period[i],"MACD Alert",2,2);
               val4 = iCustom(symbol,period[i],"MACD Alert",3,2);
               if (val1 == EMPTY_VALUE) val1 = 0;
               if (val2 == EMPTY_VALUE) val2 = 0;
               if (val3 == EMPTY_VALUE) val3 = 0;
               if (val4 == EMPTY_VALUE) val4 = 0;
               infobox = StringConcatenate(infobox, " - val1: ", DoubleToStr(val1, digit));
               infobox = StringConcatenate(infobox, " - val2: ", DoubleToStr(val2, digit));
               infobox = StringConcatenate(infobox, " - val3: ", DoubleToStr(val3, digit));
               infobox = StringConcatenate(infobox, " - val4: ", DoubleToStr(val4, digit));
               infobox = StringConcatenate(infobox, "\n");
            break;   
         case 10:
               spanA = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, -25);
               spanB = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, -25);
               spanAb = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, -24);
               spanBb = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, -24);
               spanAc = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANA, -23);
               spanBc = iIchimoku(symbol, period[i], 9, 26, 52, MODE_SENKOUSPANB, -23);
               condition_buy = (
                  spanAb < spanBb
                  && spanA > spanB
                  );
               condition_sell = (
                  spanAb > spanBb
                  && spanA < spanB
                  );
               if (condition_buy) {
                  if (reverse_bid_if_profit) reverse_bid(symbol, 1);
                  else if (reverse_bid_force) reverse_bid_force(symbol, 1);
                  condition_multi[number][i][0] = 1;
               } else if (condition_sell) {
                  if (reverse_bid_if_profit) reverse_bid(symbol, -1);
                  else if (reverse_bid_force) reverse_bid_force(symbol, -1);
                  condition_multi[number][i][0] = -1;
               }
               val1 = iCustom(symbol,period[i],"MACD Alert",2,1);
               val2 = iCustom(symbol,period[i],"MACD Alert",3,1);
               val3 = iCustom(symbol,period[i],"MACD Alert",2,2);
               val4 = iCustom(symbol,period[i],"MACD Alert",3,2);
               if (val1 == EMPTY_VALUE) val1 = 0;
               if (val2 == EMPTY_VALUE) val2 = 0;
               if (val3 == EMPTY_VALUE) val3 = 0;
               if (val4 == EMPTY_VALUE) val4 = 0;
               condition_buy2 = ((val1 != 0 && val3 == 0 && val2 == 0) || (val3 != 0 && val4 != 0 && val1 != 0 && val2 == 0));
               condition_sell2 = ((val2 != 0 && val4 == 0 && val1 == 0) || (val3 != 0 && val4 != 0 && val2 != 0 && val1 == 0));
               condition_buy = (condition_buy2
                   && iOpen(symbol, period[i], 1) < iHigh(symbol, period[i], 2) 
                        && iOpen(symbol, period[i], 1) > iLow(symbol, period[i], 2)
                   );
               condition_sell = (condition_sell2
                   && iOpen(symbol, period[i], 1) < iHigh(symbol, period[i], 2) && iOpen(symbol, period[i], 1) > iLow(symbol, period[i], 2)
                   );
               if (condition_buy) {
                  condition_multi[number][i][1] = 1;
               } else if (condition_sell) {
                  condition_multi[number][i][1] = -1;
               }
 
               val5 = iRSI(symbol,period[i],14,PRICE_CLOSE,1);
               val6 = iRSI(symbol,period[i],14,PRICE_CLOSE,2);
               if ((val5 > 50 && val6 < 50) || (condition_multi[number][i][0] == 1 && condition_multi[number][i][1] == 1 && val5 > 50)) {
                  condition_multi[number][i][2] = 1;
               } else if ((val5 < 50 && val6 > 50) || (condition_multi[number][i][0] == -1 && condition_multi[number][i][1] == -1 && val5 < 50)) {
                  condition_multi[number][i][2] = -1;
               }
               //case 1 buy
               if (condition_multi[number][i][0] == 1 && condition_multi[number][i][1] == 1 && condition_multi[number][i][2] == 1) {
                  importantbox = StringConcatenate(importantbox, symbol, ", ", TimeframeToString(period[i]), ", Buy\n");
                  messages[number] = "buy";
                  call_order_creation(true, false, condition_name, symbol, period[i], number, i, bids, TimeframeToString(period[i]));
                  condition_multi[number][i][0] = 0;
                  condition_multi[number][i][1] = 0;
                  condition_multi[number][i][2] = 0;
               }
               //case 2 sell
               else if (condition_multi[number][i][0] == -1 && condition_multi[number][i][1] == -1 && condition_multi[number][i][2] == -1) {
                  importantbox = StringConcatenate(importantbox, symbol, ", ", TimeframeToString(period[i]), ", Sell\n");
                  messages[number] = "sell";
                  call_order_creation(false, true, condition_name, symbol, period[i], number, i, bids, TimeframeToString(period[i]));
                  condition_multi[number][i][0] = 0;
                  condition_multi[number][i][1] = 0;
                  condition_multi[number][i][2] = 0;
               }
            break;  
         case 11:
            condition_name = "SpanAB_v2";
            int period_2[7] = {PERIOD_D1, PERIOD_H4, PERIOD_H1, PERIOD_M30, PERIOD_M15, PERIOD_M5, PERIOD_M1};
            int j;
            for (j = 0; j < 7; j++) {
               spanA = iIchimoku(symbol, period_2[j], 9, 26, 52, MODE_SENKOUSPANA, -25);
               spanB = iIchimoku(symbol, period_2[j], 9, 26, 52, MODE_SENKOUSPANB, -25);
               spanAb = iIchimoku(symbol, period_2[j], 9, 26, 52, MODE_SENKOUSPANA, -24);
               spanBb = iIchimoku(symbol, period_2[j], 9, 26, 52, MODE_SENKOUSPANB, -24);
               condition_buy = (
                  spanA > spanB
                  );
               condition_sell = (
                  spanA < spanB
                  );
               if (condition_buy) {
                  infobox = StringConcatenate(infobox, "\nPeriod: ", TimeframeToString(period_2[j]), " Type: Buy");
                  condition_multi[number][j][0] = 1;
               } else if (condition_sell) {
                  infobox = StringConcatenate(infobox, "\nPeriod: ", TimeframeToString(period_2[j]), " Type: Sell");
                  condition_multi[number][j][0] = -1;
               }
            }
            if (condition_multi[number][0][0] == 1 && condition_multi[number][1][0] == 1 && condition_multi[number][2][0] == 1 && condition_multi[number][3][0] == 1 && condition_multi[number][4][0] == 1 && condition_multi[number][5][0] == 1)
               messages[number] = "Very Strong Buy";
            else if (condition_multi[number][0][0] == -1 && condition_multi[number][1][0] == -1 && condition_multi[number][2][0] == -1 && condition_multi[number][3][0] == -1 && condition_multi[number][4][0] == -1 && condition_multi[number][5][0] == -1)
               messages[number] = "Very Strong Sell";
            if (condition_multi[number][1][0] == 1 && condition_multi[number][2][0] == 1 && condition_multi[number][3][0] == 1 && condition_multi[number][4][0] == 1 && condition_multi[number][5][0] == 1)
               messages[number] = "Strong Buy";
            else if (condition_multi[number][1][0] == -1 && condition_multi[number][2][0] == -1 && condition_multi[number][3][0] == -1 && condition_multi[number][4][0] == -1 && condition_multi[number][5][0] == -1)
               messages[number] = "Strong Sell";
            else if (condition_multi[number][2][0] == 1 && condition_multi[number][3][0] == 1 && condition_multi[number][4][0] == 1 && condition_multi[number][5][0] == 1)
               messages[number] = "Buy";
            else if (condition_multi[number][2][0] == -1 && condition_multi[number][3][0] == -1 && condition_multi[number][4][0] == -1 && condition_multi[number][5][0] == -1)
               messages[number] = "Sell";
            else if (condition_multi[number][3][0] == 1 && condition_multi[number][4][0] == 1 && condition_multi[number][5][0] == 1)
               messages[number] = "Weak Buy";
            else if (condition_multi[number][3][0] == -1 && condition_multi[number][4][0] == -1 && condition_multi[number][5][0] == -1)
               messages[number] = "Weak Sell";
            else if (condition_multi[number][4][0] == 1 && condition_multi[number][5][0] == 1)
               messages[number] = "Very Weak Buy";
            else if (condition_multi[number][4][0] == -1 && condition_multi[number][5][0] == -1)
               messages[number] = "Very Weak Sell";
            else 
               messages[number] = "Consolidated";
            infobox = StringConcatenate(infobox, "\n");
            spanA = iIchimoku(symbol, PERIOD_M15, 9, 26, 52, MODE_SENKOUSPANA, -25);
            spanB = iIchimoku(symbol, PERIOD_M15, 9, 26, 52, MODE_SENKOUSPANB, -25);
            spanAb = iIchimoku(symbol, PERIOD_M15, 9, 26, 52, MODE_SENKOUSPANA, -24);
            spanBb = iIchimoku(symbol, PERIOD_M15, 9, 26, 52, MODE_SENKOUSPANB, -24);
               condition_buy = (
                  spanAb < spanBb
                  && spanA > spanB
                  );
               condition_sell = (
                  spanAb > spanBb
                  && spanA < spanB
                  );
            if (condition_buy) {
               if (reverse_bid_if_profit) reverse_bid(symbol, 1);
               else if (reverse_bid_force) reverse_bid_force(symbol, 1);
            } else if (condition_sell) {
               if (reverse_bid_if_profit) reverse_bid(symbol, -1);
               else if (reverse_bid_force) reverse_bid_force(symbol, -1);
            }
            if (condition_buy) {
               call_order_creation(true, false, condition_name, symbol, period[i], number, i, bids, TimeframeToString(period[i]));
            } else if (condition_sell) {
               call_order_creation(false, true, condition_name, symbol, period[i], number, i, bids, TimeframeToString(period[i]));
            }
            break;       
      }
   } 
   infobox = StringConcatenate(infobox, " - condition_name: ", condition_name);
   infobox = StringConcatenate(infobox, " - Bid: ", DoubleToStr(bids, digit));
   infobox = StringConcatenate(infobox, " - Ask: ", DoubleToStr(asks, digit));
   infobox = StringConcatenate(infobox, " - messages: ", messages[number]);
   previous_bids[number] = bids; 
   previous_asks[number] = asks; 
   //FileAppend(filename, "");
}

int call_order_creation(bool condition_buy, bool condition_sell, string condition_name, string symbol, int timeperiod, int number, int i, double bids, string str)
{
   if (markethours) {
      if (hour == 0 || hour == 1 || hour == 7 || hour == 8 || hour == 13 || hour == 14) {
   
      } else {
         infobox = StringConcatenate(infobox, ": Working hours are 0, 1, 7, 8, 13, 14");
         return (0);
      }
   }
   string mes = "";
      if (condition_buy) {
         mes = "Buy";
         if (amount_type[number][i] != iTime(symbol, timeperiod, 0)) {
            amount[number][i] = bids;
            amount_type[number][i] = iTime(symbol, timeperiod, 0);
            Alert("Buy "+ condition_name+" "+build + ", " + str + ", " + symbol);
            FileAppend(filename, "Buy "+ condition_name+" "+build + ", " + str + ", " + symbol + ", "+timestr(TimeCurrent()));
         }
         createorder(symbol, timeperiod, 1, condition_name+" "+build + ", " + str);
      } else if (condition_sell) {
         mes = "Sell";
         if (amount_type[number][i] != iTime(symbol, timeperiod, 0)) {
            amount[number][i] = bids;
            amount_type[number][i] = iTime(symbol, timeperiod, 0);
            Alert("Sell "+ condition_name+" "+build + ", " + str + ", " + symbol);
            FileAppend(filename, "Sell "+ condition_name+" "+build + ", " + str + ", " + symbol + ", "+timestr(TimeCurrent()));
         }
         createorder(symbol, timeperiod, -1, condition_name+" "+build + ", " + str);
      } 
      infobox = StringConcatenate(infobox, "(", mes, ")");
   condition[number][0] = 0;
   condition[number][1] = 0;
      return (0);
}


int MOrderSend(string a_symbol_0, int a_cmd_8, double a_lots_12, double a_price_20, int a_slippage_28, double a_price_32, double a_price_40, string a_comment_48 = "", int a_magic_56 = 0, int a_datetime_60 = 0, color a_color_64 = -1) {
   
   if (IsTradeAllowed()==false)
      return (0);
   if (!create_order)
      return (0);
   int orders;
   orders = CalculateCurrentMaxOrders();
   if (orders >= maxorders)
      return (0);
   int cnt=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==a_symbol_0 && OrderType() == a_cmd_8)// && OrderMagicNumber()==MAGICMA
        {
         cnt++;
        }
     }
   if (cnt == 0) {
      int g_datetime_148;
      g_datetime_148 = TimeCurrent();
      a_price_20 = MathRound(10000.0 * a_price_20) / 10000.0;
      a_price_32 = MathRound(10000.0 * a_price_32) / 10000.0;
      a_price_40 = MathRound(10000.0 * a_price_40) / 10000.0;
      return (OrderSend(a_symbol_0, a_cmd_8, a_lots_12, a_price_20, a_slippage_28, a_price_32, a_price_40, a_comment_48, a_magic_56, a_datetime_60, a_color_64));
   } else {
      return (0);
   }
}