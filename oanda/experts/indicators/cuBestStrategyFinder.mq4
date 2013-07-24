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
#include <3_signal_inc.mqh>

double CrossUp[];
double CrossDown[];
double Cross[];
double Fpips[];
double Total[];
double BarNumber[];
int noofdays = 300;
int noofdaysend = 0;
int best;
int lastChange;
int lastChangeType;
double lastChangeClose;
int gtotal;
int strategy = 0;
string inference;
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
   lastChange = 0;
   lastChangeClose = 0;
   lastChangeType = 0;
   string symbol = Symbol();
   int sel = 0;
   int sel2 = 0;
   int max = -9999;
   int max2 = -9999;
   inference = "";
   int newtotal = 0;
   del();
   string strategiestoconsider = "\nStrategies: ";
   for (int j = 1; j <= 30; j++) {
         if (j == 24 || j == 25 || j == 4) continue;
         double val0 = iCustom(symbol, Period(), "cuSpanTimeClose", j, 20, 0, 4, 0);
         double val1 = iCustom(symbol, Period(), "cuSpanTimeClose", j, 40, 20, 4, 0);
         double val2 = iCustom(symbol, Period(), "cuSpanTimeClose", j, 60, 40, 4, 0);
         double val3 = iCustom(symbol, Period(), "cuSpanTimeClose", j, 80, 60, 4, 0);
         double val4 = iCustom(symbol, Period(), "cuSpanTimeClose", j, 100, 80, 4, 0);
         double val5 = iCustom(symbol, Period(), "cuSpanTimeClose", j, 100, 0, 4, 0);
         if (val0 == EMPTY_VALUE) val0 = 0;
         if (val1 == EMPTY_VALUE) val1 = 0;
         if (val2 == EMPTY_VALUE) val2 = 0;
         if (val3 == EMPTY_VALUE) val3 = 0;
         if (val4 == EMPTY_VALUE) val4 = 0;
         if (val5 == EMPTY_VALUE) val5 = 0;
         double val = (val0+val1+val2+val3+val4+val5) / 6;
         string sign = " ( - )";
         if (val0 > 0 && val1 > 0 && val2 > 0 && val3 > 0 && val4 > 0 && val5 > 0) {
            sign = " ( + )";
            strategiestoconsider = strategiestoconsider + j + ", ";
         }
         //if (val > 2000 && val != EMPTY_VALUE) {
            inference = inference + "\nSymbol: " + symbol + ", Period: " + Period() + ", Strategy: " + j + " (" + get_strategy_name(j) + ") Val: " + DoubleToStr(val, Digits)
               + " (20: " +DoubleToStr(val0, Digits)+ ", 40: " +DoubleToStr(val1, Digits)+ ", 60: " +DoubleToStr(val2, Digits)
               + ", 80: " +DoubleToStr(val3, Digits)+ ", 100: " +DoubleToStr(val4, Digits)+ ", All: " +DoubleToStr(val5, Digits)+ ")"
               + sign;
            //newtotal = newtotal + val;
         //}
         if (val > max && val != EMPTY_VALUE) {
            max = val;
            sel = Period();
            best = j;
         }
   }
   strategy = best;
   inference = inference + "\nMax: " + max + ", sel: " + sel + ", best Strategy = " + best + ", Spread: " + MarketInfo(symbol, MODE_SPREAD)
   + strategiestoconsider;
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
   del();
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
   datetime startdate = (TimeCurrent() - (60*60*24 * noofdays));
   ObjectDelete("start");
   vline("start", (TimeCurrent() - (60*60*24 * noofdays)), Yellow);
   int bar = getShift(Symbol(), Period(), (TimeCurrent() - (60*60*24 * noofdays)));
   
   
   datetime enddate = (TimeCurrent() - (60*60*24 * noofdaysend));
   ObjectDelete("end");
   vline("end", (TimeCurrent() - (60*60*24 * noofdaysend)), Yellow);
   int bar2 = getShift(Symbol(), Period(), (TimeCurrent() - (60*60*24 * noofdaysend)));
   
   string name = "strategy";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 10, 10, "Strategy: " + strategy, White);
   name = "startdate";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 10, 30, TimeToStr(startdate), Yellow);
   name = "startdate2";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 10, 50, "To " + TimeToStr(enddate), Yellow);
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
      } else if (lastChangeType == 1) {
         Fpips[i] = (Close[i] - lastChangeClose) / Point;
         gtotal = gtotal + Fpips[i];
         Total[i] = gtotal;
      }
   }
   Total[0] = Total[i];
   //Comment(MarketInfo(Symbol(), MODE_SPREAD), ", Strategy: ", strategy, ", Strategy Name: ", get_strategy_name(strategy)
   //+ ", gtotal: " + gtotal + ", bar: " + bar + ", bar2: " + bar2);
   
   name = "pips";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 10, 70, "Pips Earned: " + gtotal, White);
   
   name = "gtotal";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 10, 90, gtotal, Yellow);
   name = "sname";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 10, 110, "Strategy Name: ", White);
   name = "snameval";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 10, 130, get_strategy_name(strategy), Yellow);
   
   
   name = "fpips";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 10, 150, "Pips Travelled: " + DoubleToStr(Fpips[0], 0), White);
   Comment(inference, "\n", MarketInfo(Symbol(), MODE_SPREAD), ", Strategy: ", strategy, ", Strategy Name: ", get_strategy_name(strategy));
   opentime = Time[0];
   }
   return(0);
  }
//+------------------------------------------------------------------+

int del()
{
   string name;
   ObjectDelete("start");
   ObjectDelete("end");
   name = "strategy";
   ObjectDelete(name);
   name = "startdate";
   ObjectDelete(name);
   name = "startdate2";
   ObjectDelete(name);
   name = "pips";
   ObjectDelete(name);   
   name = "gtotal";
   ObjectDelete(name);
   name = "sname";
   ObjectDelete(name);
   name = "snameval";
   ObjectDelete(name);
   name = "fpips";
   ObjectDelete(name);
   return (0);
}

