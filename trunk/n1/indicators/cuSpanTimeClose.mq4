//+------------------------------------------------------------------+
//|                                               cuSpanTimeClose.mq4 |
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
double BarNumber[];
double maxPips[];

int lastChange;
int lastChangeType;
double lastChangeClose;
int gtotal;
extern int strategy = 34;
extern int noofdays = 300;
extern int noofdaysend = 0;
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
   SetIndexBuffer(5, BarNumber);
   SetIndexStyle(6, DRAW_NONE);
   SetIndexBuffer(6, maxPips);
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
   datetime startdate = D'2012.01.02 00:00';
  // ObjectDelete("start");
   //vline("start", startdate, Yellow);
   //int bar = getShift(Symbol(), Period(), startdate);
   
   //ObjectDelete("start");
   //vline("start", (TimeCurrent() - (60*60*24 * (noofdays))), Yellow);
   int bar = getShift(Symbol(), Period(), (TimeCurrent() - (60*60*24 * noofdays)));
   
   
   if (noofdays == -1) {
      bar = Bars - 5;
      ObjectDelete("start");
      vline("start", Time[bar], Yellow);
   }
   //ObjectDelete("end");
   //vline("end", (TimeCurrent() - (60*60*24 * noofdaysend)), Yellow);
   int bar2 = getShift(Symbol(), Period(), (TimeCurrent() - (60*60*24 * noofdaysend)));
   
   //string filename = Symbol() + "/cuSpanTimeClose_" + Period() + "_" + noofdays + "_" + noofdaysend + "_" + strategy + ".txt";
   string infobox = "";
   //FileDelete(filename);
   //Alert(Symbol()+Bars);
   //bar = Bars - 5;
   double riskfactor = 0;
   for(i = bar; i > bar2; i--) {
      BarNumber[i] = i;
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
         //if (i == 1) Alert(Symbol()," buy");
         if (lastChange > 0) {
            if (lastChangeType == -1) {
               Fpips[i] = (lastChangeClose - Close[i]) / Point;
               gtotal = gtotal + Fpips[i];
               Total[i] = gtotal;
               maxPips[i] = getmaxPips(Symbol(), Period(), lastChange, i, 1);
               infobox = infobox + "\nType: " + lastChangeType + ", Last Change Bar: " + lastChange + ", Current Bar: " + i
               + ", Last Change Cost: " + lastChangeClose + ", Current Cost: " + Close[i]
               + ", MaxPips: " + maxPips[i] + ", Fpips: " + Fpips[i];
            }
         }
         CrossUp[i] = Low[i] - Range*0.5;
         Cross[i] = 1;
         lastChange = i;
         lastChangeClose = Close[i];
         lastChangeType = 1;
      } else if (check == -1 && lastChangeType != -1) {
         //if (i == 1) Alert(Symbol()," sell");
         if (lastChange > 0) {
            if (lastChangeType == 1) {
               Fpips[i] = (Close[i] - lastChangeClose) / Point;
               gtotal = gtotal + Fpips[i];
               Total[i] = gtotal;
               maxPips[i] = getmaxPips(Symbol(), Period(), lastChange, i, -1);
               infobox = infobox + "\nType: " + lastChangeType + ", Last Change Bar: " + lastChange + ", Current Bar: " + i
               + ", Last Change Cost: " + lastChangeClose + ", Current Cost: " + Close[i]
               + ", MaxPips: " + maxPips[i] + ", Fpips: " + Fpips[i];
            }
         }
         CrossDown[i] = High[i] + Range*0.5;
         Cross[i] = -1;
         lastChange = i;
         lastChangeClose = Close[i];
         lastChangeType = -1;
      } else if (lastChangeType == -1) {
         Fpips[i] = (lastChangeClose - Close[i]) / Point;
      } else if (lastChangeType == 1) {
         Fpips[i] = (Close[i] - lastChangeClose) / Point;
      }
   }
   i = bar2;
   BarNumber[i] = i;
   if (lastChange > 0) {
      if (lastChangeType == -1) {
         Fpips[i] = (lastChangeClose - Close[i]) / Point;
         gtotal = gtotal + Fpips[i];
         Total[i] = gtotal;
         maxPips[i] = getmaxPips(Symbol(), Period(), lastChange, i, 1);
         infobox = infobox + "\nType: " + lastChangeType + ", Last Change Bar: " + lastChange + ", Current Bar: " + i
               + ", Last Change Cost: " + lastChangeClose + ", Current Cost: " + Close[i]
               + ", MaxPips: " + maxPips[i] + ", Fpips: " + Fpips[i];
      } else if (lastChangeType == 1) {
         Fpips[i] = (Close[i] - lastChangeClose) / Point;
         gtotal = gtotal + Fpips[i];
         Total[i] = gtotal;
         maxPips[i] = getmaxPips(Symbol(), Period(), lastChange, i, -1);
         infobox = infobox + "\nType: " + lastChangeType + ", Last Change Bar: " + lastChange + ", Current Bar: " + i
               + ", Last Change Cost: " + lastChangeClose + ", Current Cost: " + Close[i]
               + ", MaxPips: " + maxPips[i] + ", Fpips: " + Fpips[i];
      }
   }
   Total[0] = Total[i];
   
   //FileAppend(filename, infobox);
   //Comment(MarketInfo(Symbol(), MODE_SPREAD), ", Strategy: ", strategy, ", Strategy Name: ", get_strategy_name(strategy)
   //+ ", gtotal: " + gtotal + ", bar: " + bar + ", bar2: " + bar2);
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

int getmaxPips(string symbol, int period, int lastBar, int currentBar, int type)
{
   int num;
   double numh;
   int lowest, low, pips;
   int count = lastBar-currentBar;
   if (type == -1) {
      num = iHighest(symbol, period, MODE_HIGH, count, currentBar);
      numh = iHigh(symbol, period, num);
      pips = (numh - iClose(symbol, period, lastBar)) / MarketInfo(symbol, MODE_POINT);
   } else if (type == 1) {
      num = iLowest(symbol, period, MODE_LOW, count, currentBar);
      numh = iLow(symbol, period, num);
      pips = (iClose(symbol, period, lastBar) - numh) / MarketInfo(symbol, MODE_POINT);
   }
   return (pips);
}


void FileAppend(string name,string txt)
{
   int handle = FileOpen(name,FILE_READ|FILE_WRITE);
	FileSeek(handle,0,SEEK_END);
	FileWrite(handle,txt);
	FileFlush(handle);
	FileClose(handle);
}