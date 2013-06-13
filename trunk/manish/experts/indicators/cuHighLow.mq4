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
extern double factor = 0.01;
extern int days = 52;
double CrossUp[];
double CrossDown[];
double Cross[];
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
   int limit, i, counter;
   double Range, AvgRange;
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;

   limit=Bars-counted_bars;
   int condition = 0;
   
      infobox = "";
      getallinfo();
      infobox = infobox + "\n";
      //for (int m = 52; m < 500; m = m + 52) {
      int m = 1000;
      int high = iHighest(Symbol(), PERIOD_D1, MODE_HIGH, m, 0);
      int low = iLowest(Symbol(), PERIOD_D1, MODE_LOW, m, 0);
      double diff = High[high] - Low[low];
      int number = diff / Point;
      int max = number * factor;
      int top = (High[high] - MarketInfo(Symbol(), MODE_BID)) / Point;
      int bottom = (MarketInfo(Symbol(), MODE_BID) - Low[low]) / Point;
      int suggested = 0;
      if (top > bottom) {
         suggested = 1;
      } else if (top < bottom) {
         suggested = -1;
      }
      infobox = infobox + StringConcatenate("\nDays = ", m, ", High: ", high, " (", High[high], "), Low: ", low, " (", Low[low], "), Diff: ", diff, ", number: ", number,
         ", max loss: ", max, ", top: ", top, "(", (top * factor), "), bottom: ", 
         bottom, " (", (bottom * factor), "), suggested: ", suggested);
         /*
      i = high;
      
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      CrossDown[i] = High[i] + Range*0.5;
      Cross[i] = -1;
      i = low;
      
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      CrossUp[i] = Low[i] - Range*0.5;
      Cross[i] = 1;
      */
      //ichimoku
         infobox = infobox + "\n";
         string vname = "vertical";
         string hname = "horizontal";
         string name = "text";
         ObjectDelete(vname);
         ObjectDelete(hname);
         ObjectDelete(name);
         string current = "current";
         ObjectDelete(current);
      for (int j = 1; j < 500; j++) {
         int tenkan = tenkan(Symbol(), Period(), j);
         double price;
         double pointsEarned = 0;
         int fpips = 0;
         color lcolor;
         if (tenkan == 1) {
            lcolor = Blue;
            hline(hname, Close[j], Blue);
            vline(vname, Time[j], Blue);
            price = Close[j];
            pointsEarned = MarketInfo(Symbol(), MODE_BID) - price;
            TextToPrint(name, DoubleToStr(price, Digits), 12, "Verdana", Yellow, Time[j], Close[j]);
            fpips = (pointsEarned / Point);
            infobox = infobox + "\nFpips Earned: " + fpips;
            TextToPrint(current, DoubleToStr(MarketInfo(Symbol(), MODE_BID), Digits) 
            + "("+(fpips) +")", 12, "Verdana", Yellow, Time[0], Close[0]);
            break;
         } else if (tenkan == -1) {
            lcolor = Red;
            hline(hname, Close[j], Red);
            vline(vname, Time[j], Red);
            price = Close[j];
            pointsEarned = price - MarketInfo(Symbol(), MODE_BID);
            fpips = (pointsEarned / Point);
            TextToPrint(name, DoubleToStr(price, Digits), 12, "Verdana", Yellow, Time[j], Close[j]);
            infobox = infobox + "\nFpips Earned: " + fpips;
            TextToPrint(current, DoubleToStr(MarketInfo(Symbol(), MODE_BID), Digits) 
            + "("+(fpips) +")", 12, "Verdana", Yellow, Time[0], Close[0]);
            break;
         }
      }
      string upperName = "trendline";
      ObjectDelete(upperName);
      SetTrendlineObject(upperName, Time[j], price, Time[0], Close[0], lcolor, 2);
      hname = "hname2";
      vname = "vname2";
      ObjectDelete(hname);
      ObjectDelete(vname);
      hline(hname, Close[0], Yellow);
      vline(vname, Time[0], Yellow);
      //}
      
      Comment(infobox);
   return(0);
  }
//+------------------------------------------------------------------+


