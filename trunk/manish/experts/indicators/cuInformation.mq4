//+------------------------------------------------------------------+
//|                                                cuInformation.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

#property indicator_chart_window
#include <3_signal_inc.mqh>
#include <strategies.mqh>

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
  
void del()
{
   string name;
   name = "wprlbl";
   ObjectDelete(name);
   name = "wpr";
   ObjectDelete(name);
   name = "wprArrow";
   ObjectDelete(name);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   string name;
   color textColor;
   int pos = 10;
   //wpr
   double wpr = iWPR(NULL, 0, 55, 0);
   double wpr1 = iWPR(NULL, 0, 55, 1);
   name = "wprlbl";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 10, pos, "WPR %R", Yellow);
   name = "wpr";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 20, pos + 20, DoubleToStr(wpr, Digits), White);
   name = "wprArrow";
   ObjectDelete(name);
   if (wpr > -30 && wpr < wpr1) create_arrow(name, 5, pos + 20, -1, 1);
   else if (wpr < -70 && wpr > wpr1) create_arrow(name, 5, pos + 20, 1, 1);
   else create_arrow(name, 5, pos + 20, 0, 1);
   
   pos = pos + 40;
   //spanAB
   double spanA_1 =iIchimoku(NULL, 0, 9, 26, 52, MODE_SENKOUSPANA, 0-26);
   double spanB_1=iIchimoku(NULL, 0, 9, 26, 52, MODE_SENKOUSPANB, 0-26);
   name = "spanlbl";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 10, pos, "SpanAB", Yellow);
   name = "span";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 20, pos + 20, DoubleToStr(spanA_1, Digits) + " / " + DoubleToStr(spanB_1, Digits), White);
   name = "spanArrow";
   ObjectDelete(name);
   if (spanA_1 > spanB_1) create_arrow(name, 5, pos + 20, 1, 1);
   else if (spanA_1 < spanB_1) create_arrow(name, 5, pos + 20, -1, 1);
   else create_arrow(name, 5, pos + 20, 0, 1);

   
   pos = pos + 40;
   //tenkan
   double tenkan_sen_1=iIchimoku(NULL, 0, 9, 26, 52, MODE_TENKANSEN, 0);
   double kijun_sen_1=iIchimoku(NULL, 0, 9, 26, 52, MODE_KIJUNSEN, 0);
   name = "tenkanlbl";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 10, pos, "Tenkan", Yellow);
   name = "tenkan";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 20, pos + 20, DoubleToStr(tenkan_sen_1, Digits) + " / " + DoubleToStr(kijun_sen_1, Digits), White);
   name = "tenkanArrow";
   ObjectDelete(name);
   if (tenkan_sen_1 < kijun_sen_1) create_arrow(name, 5, pos + 20, -1, 1);
   else if (tenkan_sen_1 > kijun_sen_1) create_arrow(name, 5, pos + 20, 1, 1);
   else create_arrow(name, 5, pos + 20, 0, 1);
   
   pos = pos + 40;
   
   //macd
   double MacdCurrent=iMACD(NULL, 0,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
   double SignalCurrent=iMACD(NULL, 0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
   name = "macdlbl";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 10, pos, "MACD", Yellow);
   name = "macd";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 20, pos + 20, DoubleToStr(MacdCurrent, Digits) + " / " + DoubleToStr(SignalCurrent, Digits), White);
   name = "macdArrow";
   ObjectDelete(name);
   if (MacdCurrent > SignalCurrent) create_arrow(name, 5, pos + 20, 1, 1);
   else if (MacdCurrent < SignalCurrent) create_arrow(name, 5, pos + 20, -1, 1);
   else create_arrow(name, 5, pos + 20, 0, 1);
   
   pos = pos + 40;
   
   
   //stock
   double stoch = iStochastic(NULL, 0,14,3,3,MODE_SMA,0,MODE_MAIN,0);
   double stoch2 = iStochastic(NULL, 0,14,3,3,MODE_SMA,0,MODE_SIGNAL,0);
   name = "stochlbl";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 10, pos, "Stochastic", Yellow);
   name = "stoch";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 20, pos + 20, DoubleToStr(stoch, Digits) + " / " + DoubleToStr(stoch2, Digits), White);
   name = "stochArrow";
   ObjectDelete(name);
   if (stoch > stoch2) create_arrow(name, 5, pos + 20, 1, 1);
   else if (stoch < stoch2) create_arrow(name, 5, pos + 20, -1, 1);
   else create_arrow(name, 5, pos + 20, 0, 1);
   
   
   pos = pos + 40;
   //sar
   double sar = iSAR(NULL, 0,0.02,0.2,0);
   name = "sarlbl";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 10, pos, "SAR", Yellow);
   name = "sar";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 20, pos + 20, DoubleToStr(sar, Digits) + " / " + DoubleToStr(Bid, Digits), White);
   name = "sarArrow";
   ObjectDelete(name);
   if (sar < Low[0]) create_arrow(name, 5, pos + 20, 1, 1);
   else if (sar > High[0]) create_arrow(name, 5, pos + 20, -1, 1);
   else create_arrow(name, 5, pos + 20, 0, 1);
   
   
   pos = pos + 40;
   //sar
   double rsi = iRSI(NULL, 0,9,PRICE_CLOSE,0);
   double rsi1 = iRSI(NULL, 0,9,PRICE_CLOSE,1);
   name = "rsilbl";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 10, pos, "RSI", Yellow);
   name = "rsi";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 20, pos + 20, DoubleToStr(rsi, Digits) + " / " + DoubleToStr(rsi1, Digits), White);
   name = "rsiArrow";
   ObjectDelete(name);
   if (rsi > 30 && rsi > rsi1) create_arrow(name, 5, pos + 20, 1, 1);
   else if (rsi < 70 && rsi < rsi1) create_arrow(name, 5, pos + 20, -1, 1);
   else create_arrow(name, 5, pos + 20, 0, 1);
   
   pos = pos + 40;
   //semaphore
   int semaphoreH4 = get_lasttrendsemaphore(Symbol(), PERIOD_H4, false);
   int semaphoreNumberH4 = semaphoreNumber;
   int semaphore = get_lasttrendsemaphore(Symbol(), Period(), false);
   int semphoreNumberP = semaphoreNumber;
   int      shiftSemaphore = iBarShift(Symbol(), Period(), Time[semaphoreNumberH4]);
   int semaphoreCurrent = semaphore(Symbol(), Period(), shiftSemaphore);
   name = "semaphorelbl";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 10, pos, "Semaphore", Yellow);
   name = "semaphore";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 20, pos + 20, semaphore + " / " + semphoreNumberP + " / " + TimeToStr(Time[semphoreNumberP])
      + " / 4H: " + semaphoreH4 + " - " + semaphoreNumberH4
      , White);
   name = "semaphore2";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 20, pos + 40, "C: " + semaphoreCurrent + " / " + shiftSemaphore + " / " + TimeToStr(Time[shiftSemaphore])
      , White);
   name = "semaphoreArrow";
   ObjectDelete(name);
   if (semaphore == 1) create_arrow(name, 5, pos + 20, 1, 1);
   else if (semaphore == -1) create_arrow(name, 5, pos + 20, -1, 1);
   else create_arrow(name, 5, pos + 20, 0, 1);
   
   
   
   
   int lpos = 10;
   //heiken
   double heiken2 = iCustom(Symbol(), Period(), "Heiken_Ashi_Smoothed",2,0);
   double heiken3 = iCustom(Symbol(), Period(), "Heiken_Ashi_Smoothed",3,0);
   
   name = "heikenlbl";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 0, 10, lpos, "Heiken", Yellow);
   name = "heiken";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 0, 20, lpos + 20, DoubleToStr(heiken2, Digits) + " / " + DoubleToStr(heiken3, Digits), White);
   name = "heikenArrow";
   ObjectDelete(name);
   if (heiken2 < heiken3) create_arrow(name, 5, lpos + 20, 1, 0);
   else if (heiken2 > heiken3) create_arrow(name, 5, lpos + 20, -1, 0);

   lpos = lpos + 40;
   
   //sma 14 21
   double ma14 = iMA(NULL,0,14,0,MODE_SMA,PRICE_CLOSE,0);
   double ma21 = iMA(NULL,0,21,0,MODE_SMA,PRICE_CLOSE,0);
   
   name = "sma1421lbl";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 0, 10, lpos, "SMA 14-21", Yellow);
   name = "sma1421";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 0, 20, lpos + 20, DoubleToStr(ma14, Digits) + " / " + DoubleToStr(ma21, Digits), White);
   name = "sma1421Arrow";
   ObjectDelete(name);
   if (ma14 > ma21) create_arrow(name, 5, lpos + 20, 1, 0);
   else if (ma14 < ma21) create_arrow(name, 5, lpos + 20, -1, 0);

   lpos = lpos + 40;
   
   //sma 200 5
   double ma5 = iMA(NULL,0,5,0,MODE_SMA,PRICE_CLOSE,0);
   double ma200 = iMA(NULL,0,200,0,MODE_SMA,PRICE_CLOSE,0);
   
   name = "sma5200lbl";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 0, 10, lpos, "SMA 5 - 200", Yellow);
   name = "sma5200";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 0, 20, lpos + 20, DoubleToStr(ma5, Digits) + " / " + DoubleToStr(ma200, Digits), White);
   name = "sma5200Arrow";
   ObjectDelete(name);
   if (ma5 > ma200) create_arrow(name, 5, lpos + 20, 1, 0);
   else if (ma5 < ma200) create_arrow(name, 5, lpos + 20, -1, 0);

   lpos = lpos + 40;
   
   
   //strategies
   for (int x = 1; x < 24; x++) {
      double s = get_strategy_result(x, Symbol(), Period(), 0, 1);
   
      name = "sbl" + x;
      ObjectDelete(name);
      create_label(name, 0, 0, 0, 0, 10 + (30 * (x-1)), lpos, "S" + x, White);
      name = "sArrow" + x;
      ObjectDelete(name);
      if (s == 1) create_arrow(name, 10 + (30 * (x-1)), lpos + 20, 1, 0);
      else if (s == -1) create_arrow(name, 10 + (30 * (x-1)), lpos + 20, -1, 0);
   }

   lpos = lpos + 40;
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+