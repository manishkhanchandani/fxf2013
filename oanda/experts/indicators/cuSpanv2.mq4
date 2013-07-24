//+------------------------------------------------------------------+
//|                                               cuChartPattern.mq4 |
//|                                              Manish Khanchandani |
//|                                          http://www.mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://www.mkgalaxy.com"

#property indicator_chart_window
#property indicator_buffers 5
#property indicator_color1 Yellow
#property indicator_color2 Red

#include <strategies.mqh>

double CrossUp[];
double CrossDown[];
double Cross[];
double Fpips[];
double Total[];

int lastChange;
int lastChangeType;
double lastChangeClose;
int gtotal;
extern int strategy = 6;
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
   SetIndexStyle(3, DRAW_NONE);
   SetIndexBuffer(3, Fpips);
   SetIndexStyle(4, DRAW_NONE);
   SetIndexBuffer(4, Total);
   lastChange = 0;
   lastChangeClose = 0;
   lastChangeType = 0;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   lastChange = 0;
   lastChangeClose = 0;
   lastChangeType = 0;
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
   gtotal = 0;
   int bar = getShift(Symbol(), Period(), D'2013.05.05 00:00');
   int bar2 = getShift(Symbol(), Period(), D'2013.05.11 00:00');
   //Alert(bar);
   for(i = bar; i >= bar2; i--) {
   
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      condition = 0;
      
      int check = get_strategy_result(strategy, Symbol(), Period(), i, 0);
      if (check == 1 && lastChangeType != 1) {
         if (lastChange > 0) {
            if (lastChangeType == -1) {
               Fpips[i] = (lastChangeClose - Close[i]) / Point;
               gtotal = gtotal + Fpips[i];
               Total[i] = gtotal;
            }
         }
         CrossUp[i] = Low[i] - Range*0.5;
         Cross[i] = 1;
         lastChange = i;
         lastChangeClose = Close[i];
         lastChangeType = 1;
      } else if (check == -1 && lastChangeType != -1) {
         if (lastChange > 0) {
            if (lastChangeType == 1) {
               Fpips[i] = (Close[i] - lastChangeClose) / Point;
               gtotal = gtotal + Fpips[i];
               Total[i] = gtotal;
            }
         }
         CrossDown[i] = High[i] + Range*0.5;
         Cross[i] = -1;
         lastChange = i;
         lastChangeClose = Close[i];
         lastChangeType = -1;
      }
   }
   i = bar2;
   if (lastChange > 0) {
            if (lastChangeType == -1) {
               Fpips[i] = (lastChangeClose - Close[i]) / Point;
               gtotal = gtotal + Fpips[i];
               Total[i] = gtotal;
         //CrossUp[i] = Low[i] - Range*0.5;
         //Cross[i] = 1;
            } else if (lastChangeType == 1) {
               Fpips[i] = (Close[i] - lastChangeClose) / Point;
               gtotal = gtotal + Fpips[i];
               Total[i] = gtotal;
         //CrossDown[i] = High[i] + Range*0.5;
         //Cross[i] = -1;
            }
         }
   Comment(MarketInfo(Symbol(), MODE_SPREAD));
   return(0);
  }
//+------------------------------------------------------------------+


int getShift(string symbol, int period, datetime sometime)
{
  //datetime some_time=D'2004.03.21 12:00';
  int      shift=iBarShift(symbol, period, sometime);
  //infobox = infobox + StringConcatenate("\nshift of bar with open time ",TimeToStr(sometime)," is ",shift);
  return (shift);
}