//+------------------------------------------------------------------+
//|                                               cuChartPattern.mq4 |
//|                                              Manish Khanchandani |
//|                                          http://www.mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://www.mkgalaxy.com"

#property indicator_chart_window
#property indicator_buffers 8

#include <3_signal_inc.mqh>

double USDSymbol[];
double EURSymbol[];
double GBPSymbol[];
double CHFSymbol[];
double CADSymbol[];
double AUDSymbol[];
double JPYSymbol[];
double NZDSymbol[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_NONE);
   SetIndexBuffer(0, USDSymbol);
   SetIndexStyle(1, DRAW_NONE);
   SetIndexBuffer(1, EURSymbol);
   SetIndexStyle(2, DRAW_NONE);
   SetIndexBuffer(2, GBPSymbol);
   SetIndexStyle(3, DRAW_NONE);
   SetIndexBuffer(3, CHFSymbol);
   SetIndexStyle(4, DRAW_NONE);
   SetIndexBuffer(4, CADSymbol);
   SetIndexStyle(5, DRAW_NONE);
   SetIndexBuffer(5, AUDSymbol);
   SetIndexStyle(6, DRAW_NONE);
   SetIndexBuffer(6, JPYSymbol);
   SetIndexStyle(7, DRAW_NONE);
   SetIndexBuffer(7, NZDSymbol);
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

   int bar = getShift(Symbol(), Period(),D'2013.04.21 17:00');
   ObjectDelete("start");
   vline("start", D'2013.04.21 17:00', Yellow);
   return (0);
   limit=Bars-counted_bars;
   int condition = 0;
   infobox = "";
   getallinfo();
   //Alert(bar);
   
   for(i = 0; i <= bar; i++) {
   
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      condition = 0;
      string strength = getallinfoshift(Period(), i);
      USDSymbol[i] = aMeter[USD];
      EURSymbol[i] = aMeter[EUR];
      GBPSymbol[i] = aMeter[GBP];
      CHFSymbol[i] = aMeter[CHF];
      CADSymbol[i] = aMeter[CAD];
      AUDSymbol[i] = aMeter[AUD];
      JPYSymbol[i] = aMeter[JPY];
      NZDSymbol[i] = aMeter[NZD];
      if (i == 0) infobox = infobox + strength;
   }
   Comment(infobox);
   return(0);
  }
//+------------------------------------------------------------------+

/*
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
}*/