//+------------------------------------------------------------------+
//|                                               cuChartPattern.mq4 |
//|                                              Manish Khanchandani |
//|                                          http://www.mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://www.mkgalaxy.com"

#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1 Yellow
#property indicator_color2 Red
#property indicator_color3 White
#property indicator_color4 White

#include <strategies.mqh>

double CrossUp[];
double CrossDown[];
double CloseUp[];
double CloseDown[];
double Cross[];
double Fpips[];
double Total[];

int lastChange;
int lastChangeType;
double lastChangeClose;
int gtotal;
extern int strategy = 5;
extern int strategyClose =5;
extern int noofdays = 5;
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
   
   SetIndexStyle(2, DRAW_ARROW, EMPTY,2);
   SetIndexArrow(2, 233);
   SetIndexBuffer(2, CloseUp);
   SetIndexStyle(3, DRAW_ARROW, EMPTY,2);
   SetIndexArrow(3, 234);
   SetIndexBuffer(3, CloseDown);
   
   SetIndexStyle(4, DRAW_NONE);
   SetIndexBuffer(4, Cross);
   SetIndexStyle(5, DRAW_NONE);
   SetIndexBuffer(5, Fpips);
   SetIndexStyle(6, DRAW_NONE);
   SetIndexBuffer(6, Total);
   lastChange = 0;
   lastChangeClose = 0;
   lastChangeType = 0;
//----
   return(0);
  }
  int opentime;
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
  if (opentime != Time[0]) {
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
   
   lastChange = 0;
   lastChangeClose = 0;
   lastChangeType = 0;
   //datetime startdate = D'2012.01.02 00:00';
   ObjectDelete("start");
   vline("start", (TimeCurrent() - (60*60*24 * noofdays)), Yellow);
   int bar = getShift(Symbol(), Period(), (TimeCurrent() - (60*60*24 * noofdays)));
   
   for(i = bar; i >= 1; i--) {
   
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
      int check2 = get_strategy_result(strategyClose, Symbol(), Period(), i, 0);
      if (check == 1 && lastChangeType == 0) {
         CrossUp[i] = Low[i] - Range*0.5;
         Cross[i] = 1;
         lastChange = i;
         lastChangeClose = Close[i];
         lastChangeType = 1;
      } else if (check == -1 && lastChangeType == 0) {
         CrossDown[i] = High[i] + Range*0.5;
         Cross[i] = -1;
         lastChange = i;
         lastChangeClose = Close[i];
         lastChangeType = -1;
      }
      
      if (check2 == 1 && lastChangeType != 1) {
         if (lastChange > 0) {
            if (lastChangeType == -1) {
               Fpips[i] = (lastChangeClose - Close[i]) / Point;
               gtotal = gtotal + Fpips[i];
               Total[i] = gtotal;
               CloseUp[i] = Low[i] - Range*0.5;
               lastChange = 0;
               lastChangeClose = 0;
               lastChangeType = 0;
            }
         }
      } else if (check2 == -1 && lastChangeType != -1) {
         if (lastChange > 0) {
            if (lastChangeType == 1) {
               Fpips[i] = (Close[i] - lastChangeClose) / Point;
               gtotal = gtotal + Fpips[i];
               Total[i] = gtotal;
               CloseDown[i] = High[i] + Range*0.5;
               lastChange = 0;
               lastChangeClose = 0;
               lastChangeType = 0;
            }
         }
      } else if (lastChangeType == -1) {
         Fpips[i] = (lastChangeClose - Close[i]) / Point;
      } else if (lastChangeType == 1) {
         Fpips[i] = (Close[i] - lastChangeClose) / Point;
      }
   }
   i = 0;
   if (lastChange > 0) {
      if (lastChangeType == -1) {
         Fpips[i] = (lastChangeClose - Close[i]) / Point;
         gtotal = gtotal + Fpips[i];
      } else if (lastChangeType == 1) {
         Fpips[i] = (Close[i] - lastChangeClose) / Point;
         gtotal = gtotal + Fpips[i];
      }
   }
   Total[i] = gtotal;
   //Comment(MarketInfo(Symbol(), MODE_SPREAD), ", Strategy: ", strategy, ", Strategy Name: ", get_strategy_name(strategy));
   opentime = Time[0];
   }
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


void vline(string name, int time, color TextColor)
{
   ObjectCreate(name, OBJ_VLINE, 0, time, 0);
   ObjectSet(name, OBJPROP_COLOR, TextColor);
}