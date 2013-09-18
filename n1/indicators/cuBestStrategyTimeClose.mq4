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
extern int noofdays = 5;
extern int noofdaysend = 0;
extern int minimumVal = 0;
int best;
int lastChange;
int lastChangeType;
double lastChangeClose;
int gtotal;
int strategy = 0;
string inference;
int win = 0;
int loss = 0;
int totalgain = 0;
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
   for (int j = 1; j <= 41; j++) {
      if (j == 31) continue;
         double val = iCustom(symbol, Period(), "cuSpanTimeClose", j, noofdays, noofdaysend, 4, 0);
         if (val > minimumVal && val != EMPTY_VALUE) {
            inference = inference + "\nSymbol: " + symbol + ", Period: " + Period() + ", Strategy: " + j + " (" + get_strategy_name(j) + ") Val: " + val;
            //newtotal = newtotal + val;
         }
         if (val > max && val != EMPTY_VALUE) {
            max = val;
            sel = Period();
            best = j;
         }
   }
   strategy = best;
   inference = inference + "\nMax: " + max + ", sel: " + sel + ", best Strategy = " + best + ", Spread: " + MarketInfo(symbol, MODE_SPREAD);
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
   create_label(name, 0, 0, 0, 1, 10, 30, TimeToStr(startdate) + " to " + TimeToStr(enddate), Yellow);
   totalgain = 0;
   win = 0;
   loss = 0;
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
               totalgain++;
               if (Fpips[i] > 0) win++;
               else loss++;
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
               totalgain++;
               if (Fpips[i] > 0) win++;
               else loss++;
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
               totalgain++;
               if (Fpips[i] > 0) win++;
               else loss++;
      } else if (lastChangeType == 1) {
         Fpips[i] = (Close[i] - lastChangeClose) / Point;
         gtotal = gtotal + Fpips[i];
         Total[i] = gtotal;
               totalgain++;
               if (Fpips[i] > 0) win++;
               else loss++;
      }
   }
   Total[0] = Total[i];
   //Comment(MarketInfo(Symbol(), MODE_SPREAD), ", Strategy: ", strategy, ", Strategy Name: ", get_strategy_name(strategy)
   //+ ", gtotal: " + gtotal + ", bar: " + bar + ", bar2: " + bar2);
   
   name = "pips";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 10, 50, "Pips Earned: " + gtotal, White);
   
   name = "gtotal";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 10, 70, gtotal, Yellow);
   name = "sname";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 10, 90, "Strategy Name: ", White);
   name = "snameval";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 10, 110, get_strategy_name(strategy), Yellow);
   name = "totalgain";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 10, 130, "Total Gain: " + totalgain, Yellow);
   name = "win";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 10, 150, "Win: " + win, Yellow);
   name = "loss";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 10, 170, "Loss: " + loss, Yellow);
   
   
   name = "fpips";
   ObjectDelete(name);
   create_label(name, 0, 0, 0, 1, 10, 190, "Pips Travelled: " + DoubleToStr(Fpips[0], 0), White);
   Comment(inference, "\n", MarketInfo(Symbol(), MODE_SPREAD), ", Strategy: ", strategy, ", Strategy Name: ", get_strategy_name(strategy));
   opentime = Time[0];
   }
   return(0);
  }
//+------------------------------------------------------------------+

