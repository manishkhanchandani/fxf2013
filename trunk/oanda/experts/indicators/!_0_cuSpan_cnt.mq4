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

#include <strategies.mqh>

double CrossUp[];
double CrossDown[];
double Cross[];
double Fpips[];
double Total[];
double GoalB[];
double GoalS[];
int opentime;

int GoalReachedb = 0;
int GoalReacheds = 0;
int lastChange;
int lastChangeType;
double lastChangeClose;
bool checkGoal = false;
int gtotal;
extern int strategy = 1;
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
   SetIndexStyle(5, DRAW_NONE);
   SetIndexBuffer(5, GoalB);
   SetIndexStyle(6, DRAW_NONE);
   SetIndexBuffer(6, GoalS);
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
   checkGoal= false;
   string box = "";
         lastChange = 0;
         lastChangeClose = 0;
         lastChangeType = 0;
         GoalReacheds = 0;
         GoalReachedb = 0;
   int bar = getShift(Symbol(), Period(), D'2013.04.21 00:00');
   //Alert(bar);
   int cntb = 0;
   int cnts = 0;
   int goal = 80;
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
      int tmpPips = 0;
      int check = get_strategy_result(strategy, Symbol(), Period(), i, 0);
      if (checkGoal) {
         box = box + StringConcatenate("\nlast change close: ", lastChangeClose, 
            ", current close: ", Close[i], ", lastchangetype: ", lastChangeType);
         if (lastChangeType == -1) {
            tmpPips = (lastChangeClose - Close[i]) / Point;
            if (tmpPips >= goal) {
               checkGoal = false;
               GoalReacheds++;
            }
         } else if (lastChangeType == 1) {
            tmpPips = (Close[i] - lastChangeClose) / Point;
            if (tmpPips >= goal) {
               checkGoal = false;
               GoalReachedb++;
            }
         }
      }
      if (check == 1 && lastChangeType != 1) {
         cntb++;
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
         checkGoal= true;
      } else if (check == -1 && lastChangeType != -1) {
         cnts++;
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
         checkGoal= true;
      }
   }
   i = 0;
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
         
         GoalB[0] = GoalReachedb;
         GoalS[0] = GoalReacheds;
   Comment("Spread: ", MarketInfo(Symbol(), MODE_SPREAD)
      , "\nCnt Buy: ", cntb, ", Cnt Sell: ", cnts
      , "\nGoal Reached buy: ", GoalReachedb
      , "\nGoal Reached sell: ", GoalReacheds
      //, box
   );
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