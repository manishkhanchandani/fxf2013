//+------------------------------------------------------------------+
//|                                               cuChartPattern.mq4 |
//|                                              Manish Khanchandani |
//|                                          http://www.mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://www.mkgalaxy.com"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Yellow
#property indicator_color2 Red

#include <3_signal_inc.mqh>
#include <strategies.mqh>
extern double factor = 0.01;
extern int days = 1000;
double CrossUp[];
double CrossDown[];
double Cross[];
extern int strategy = 15;
extern bool show = true;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_ARROW, EMPTY,2);
   SetIndexArrow(0, 233);
   SetIndexBuffer(0, CrossUp);
   SetIndexStyle(1, DRAW_ARROW, EMPTY,2);
   SetIndexArrow(1, 234);
   SetIndexBuffer(1, CrossDown);
   SetIndexStyle(2, DRAW_NONE);
   SetIndexBuffer(2, Cross);
   dellinefollower();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
   dellinefollower();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int limit, i, counter;
   double Range, AvgRange;
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;

   limit=Bars-counted_bars;
   int condition = 0;
      dellinefollower();
      infobox = "";
      getallinfo();
      infobox = infobox + "\n";
      //for (int m = 52; m < 500; m = m + 52) {
      int high = iHighest(Symbol(), PERIOD_D1, MODE_HIGH, days, 0);
      int low = iLowest(Symbol(), PERIOD_D1, MODE_LOW, days, 0);
      double diff = iHigh(Symbol(), PERIOD_D1, high) - iLow(Symbol(), PERIOD_D1, low);
      int number = diff / Point;
      int max = number * factor;
      int top = (iHigh(Symbol(), PERIOD_D1, high) - MarketInfo(Symbol(), MODE_BID)) / Point;
      int bottom = (MarketInfo(Symbol(), MODE_BID) - iLow(Symbol(), PERIOD_D1, low)) / Point;
      int suggested = 0;
      if (top > bottom) {
         suggested = 1;
      } else if (top < bottom) {
         suggested = -1;
      }
      infobox = infobox + StringConcatenate("\nDays = ", days, ", High: ", high, " (", High[high], "), Low: ", low, " (", Low[low], "), Diff: ", diff, ", number: ", number,
         ", max loss: ", max, ", top: ", top, "(", (top * factor), "), bottom: ", 
         bottom, " (", (bottom * factor), "), suggested: ", suggested);
       
         infobox = infobox + "\n";
     mathmurry(Symbol(), 0, PERIOD_H1);
         infobox = infobox + "\n";
         infobox = infobox + "\n";
     //condition_level[mode], condition[mode]

     /* double initialAmount = AccountBalance();
      double total = initialAmount;
      double aim = (total * 3/100); //3 perc
      double lots = ((total / 100) * 1) / 100; // 1 = perc per day buy or sell
      if (lots < 0.01) lots = 0.01;
      lots = NormalizeDouble(lots, 2);
      infobox = infobox + "\nTotal: " + total + ", Lots: " + DoubleToStr(lots, 2) 
      + ", Aim Per Day: " + DoubleToStr(aim, 2);
         infobox = infobox + "\n";*/
      string strategyText = strategy; //"Tenkan";
         /*switch (strategy) {
            case 1://tenkan
               strategyText = "tenkan";
               break;
            case 2://Fisher
               strategyText = "Fisher";
               break;
            case 3://macd
               strategyText = "macd";
               break;
            case 4: //spanAB
               strategyText = "spanAB";
               break;
          }*/
      infobox = infobox + "Strategy " + strategy + ", strategyText: " +strategyText+ "\n";
         double close1;
         int time1;
         int check = 0;
         double close2;
         int time2 = -1;
         int fpips;
      for (int j = 1; j < 500; j++) {
         check = get_strategy_result(strategy, Symbol(), Period(), j, 0);
         /*switch (strategy) {
            case 1://tenkan
               check = tenkan(Symbol(), Period(), j);
               break;
            case 2://Fisher
               check = fisherDiff(Symbol(), Period(), j);
               break;
            case 3://macd
               check = macdRshift(Symbol(), Period(), j);
               break;
            case 4: //spanAB
               check = spanAB(Symbol(), Period(), j);
               break;
          }*/
         
         if (check != 0) {
            close1 = Close[j];
            time1 = Time[j];
            break;
         }
      }
      if (show)
      fpips = linefollower(check, Symbol(), time1, close1, Time[0], Close[0]);
      infobox = infobox + "\nFpips Earned: " + fpips;
      
      Comment(infobox);
   return(0);
  }
//+------------------------------------------------------------------+


