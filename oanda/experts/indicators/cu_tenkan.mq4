//+------------------------------------------------------------------+
//|                                                  cu_allinone.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#include <3_signal_inc.mqh>
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
   infobox = "";
   string mainbox = "";
   
      getallinfo();
      infobox = infobox + "\n";
      double initialAmount = AccountBalance();
      double total = initialAmount;
      double aim = (total * 3/100); //3 perc
      double lots = ((total / 100) * 1) / 100; // 1 = perc per day buy or sell
      if (lots < 0.01) lots = 0.01;
      lots = NormalizeDouble(lots, 2);
      infobox = infobox + "\nTotal: " + total + ", Lots: " + DoubleToStr(lots, 2) 
      + ", Aim Per Day: " + DoubleToStr(aim, 2);
         infobox = infobox + "\n";
   for (int x = 0; x < ARRSIZE; x++) {
         string symbol = aPair[x];
         if (x == EURGBP || x == AUDNZD || x == EURCHF || x == GBPCHF) continue;
         infobox = infobox + "\nSymbol: " + symbol;
         int tenkan15 = tenkan(symbol, PERIOD_M15, 0);
         int tenkan30 = tenkan(symbol, PERIOD_M30, 0);
         int tenkan1h = tenkan(symbol, PERIOD_H1, 0);
         infobox = infobox + ", tenkan15: " + tenkan15;
         infobox = infobox + ", tenkan30: " + tenkan30;
         infobox = infobox + ", tenkan1h: " + tenkan1h;
         if (tenkan15 != 0 || tenkan30 != 0 || tenkan1h != 0) {
            mainbox = mainbox + "\nSymbol: " + symbol;
            if (tenkan15 != 0) mainbox = mainbox + ", tenkan15: " + tenkan15;
            if (tenkan30 != 0) mainbox = mainbox + ", tenkan30: " + tenkan30;
            if (tenkan1h != 0) mainbox = mainbox + ", tenkan1h: " + tenkan1h;
         }
   }
   Comment(mainbox, "\n", infobox);
   return (0);
//----
  }
//+------------------------------------------------------------------+

