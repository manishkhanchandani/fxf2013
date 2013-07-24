//+------------------------------------------------------------------+
//|                                               cuFindStrategy.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window

#include <3_signal_inc.mqh>
#include <strategies.mqh>
int counter = 0;

extern double initialAmount = 0;
extern int percPerDay = 3;
double todaysPlan;
extern double fixedLots = 0;
extern int startday = 300;
extern int endday = 0;

double lotsize;
int magicNu = 123;
int s[28][4];
int sm[28][4];
//int sAll[28][4][29];
int sAllm[28][3][29];
int checked[28][3];
int periods[3] = {PERIOD_M15, PERIOD_M30, PERIOD_H1};
int strategy;
int strategyPeriod;
int strategyMax;
int opentimeStrategy;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
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
   int    counted_bars=IndicatorCounted();
//----
   counter++;
   infobox = "";
   //FINDING LOT SIZE
   finding_lots();
   //FINDING THE STRATEGY
   for(int i=0;i<ARRSIZE;i++) {
      string symbol = aPair[i];
      findingStrategy(symbol, i);
   }
   string filename = "cuFindStrategy_"+startday+"_"+endday+".txt";
   FileDelete(filename);
   FileAppend(filename, infobox);
   Comment(infobox);
   
//----
   return(0);
  }
//+------------------------------------------------------------------+


int findingStrategy(string symbol, int mode)
{
   
   double val;
   int max;
   int period;
   int p;
   int j;
   if (opentimeStrategy != iTime(Symbol(), PERIOD_W1, 0)) {
      s[mode][0] = 0;
      s[mode][1] = 0;
      s[mode][2] = 0;
      s[mode][3] = 0;
      s[mode][4] = 0;
      for(p = 0; p < 4; p++) {
               period = periods[p];
               for (j = 1; j <= 28; j++) {
                     sAllm[mode][p][j] = 0;
               }
            }
      checked[mode][0] = 0;
      checked[mode][1] = 0;
      checked[mode][2] = 0;
      checked[mode][3] = 0;
      checked[mode][4] = 0;
      opentimeStrategy = iTime(Symbol(), PERIOD_W1, 0);
   }
   if (checked[mode][0] == 1 && checked[mode][1] == 1 && checked[mode][2] == 1) {
      int max2 = 0;
      infobox = infobox + "\n\nSymbol: " + symbol;
      for(p = 0; p < 3; p++) {
         period = periods[p];
         infobox = infobox + "\nSymbol: " + symbol 
         + ", Strategy For Period: " + period + " is " + s[mode][p] + " with max value: " + sm[mode][p];
         if (sm[mode][p] > max2) {
            max2 = sm[mode][p];
            strategy = s[mode][p];
            strategyPeriod = period;
            strategyMax = sm[mode][p];
         }
      }
      infobox = infobox + "\nSymbol: " + symbol + ", Main Strategy is For Period: " + strategyPeriod + " is " + strategy 
      + " (" + get_strategy_name(strategy) + ") "
      + " with max value: " + strategyMax + "\n";
      /*
            infobox = infobox + "\nDETAILS for symbol: " + symbol;
            for(p = 0; p < 4; p++) {
               period = periods[p];
               infobox = infobox + "\nSymbol: " + symbol + ", Period: " + TimeframeToString(period);
               for (j = 1; j <= 28; j++) {
                     infobox = infobox + "\nSymbol: " + symbol + ", Strategy is: " + j 
                     + " (" + get_strategy_name(j) + ") "
                     + " with value: " + sAllm[mode][p][j] + "\n";
               }
            }
            */
   } else {
      if (counter % 5 == 0) {
         for(p = 0; p < 3; p++) {
            period = periods[p];
            if (s[mode][p] > 0) {
               //infobox = infobox + "\nStrategy For Period: " + period + " is " + s[p] + " with max value: " + sm[p];
            } else {
               checked[mode][p] = 1;
               max = 0;
               for (j = 1; j <= 28; j++) {
                     val = iCustom(symbol, period, "cuSpanTimeClose", j, startday, endday, 4, 0);
                     if (val > max && val != EMPTY_VALUE) {
                        max = val;
                        sm[mode][p] = max;
                        s[mode][p] = j;
                        //Print("Checking for period " + period + " sp: " + s[mode][p] + ", checked: " + checked[mode][p]);
                     }
                     //if (val == EMPTY_VALUE) val = 0;
                     //sAllm[mode][p][j] = val;
               }
               break;
            }
         }
      }
   }
}


int finding_lots()
{
   if (initialAmount == 0) initialAmount = AccountBalance();
   double total = initialAmount;
   double aim = (total * percPerDay/100);
   lotsize = ((total / 100) * 0.5) / 100;
   if (lotsize < 0.01) lotsize = 0.01;
   lotsize = NormalizeDouble(lotsize, 2);
   fixedLots = NormalizeDouble(fixedLots, 2);
   if (fixedLots > 0) lotsize = fixedLots;
   infobox = infobox + "\nTotal: " + total + ", Lots: " + DoubleToStr(lotsize, 2) 
      + ", Aim: " + DoubleToStr(aim, 2);
   infobox = infobox + ", fixedLots: " + fixedLots;
}

