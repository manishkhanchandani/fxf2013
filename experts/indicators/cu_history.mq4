//+------------------------------------------------------------------+
//|                                                   cu_history.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#include <3_signal_inc.mqh>

extern datetime some_time = D'2013.01.01 12:00';

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   custom();
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
//----
   return(0);
  }
//+------------------------------------------------------------------+

int custom()
{
   
   infobox = "";
   int periods[7] = {PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4, PERIOD_D1};
   int s1 = 0;
   int s2 = 0;
   int j;
   int result;
   double price1, price2;
   int totalpoints;
   int strategy = 1;
   string box = "";
   int points;
   FileDelete("history3.txt");
   for (int i=0; i<7; i++) {
      //box = box + "\n\n" + Symbol() + "\nPeriod: " + TimeframeToString(periods[i]);
      int ishift = getShift(Symbol(), periods[i], some_time);
      infobox = infobox + StringConcatenate("\nshift of bar with open time ",TimeToStr(some_time), " i.e. "
      ,TimeframeToString(periods[i])
      ," is ",ishift);
      price1 = 0;
      price2 = 0;
      totalpoints = 0;
      s1 = 0;
      s2 = 0;
      for (j=ishift; j>=0; j--) {
         if (price1 > 0) {
            s2 = checkclose(strategy, Symbol(), periods[i], j+1);
            if (s2 != s1) {
               if (s2 == 1 || s2 == -1) {
                  price2 = iOpen(Symbol(), periods[i], j);
                  points = getPoints(Symbol(), s1, price1, price2);
                  totalpoints += points;
                  //box = box + "\nShift: " + j + ", Price1: " + price1 + ", Price2: " + price2 
                     //+ ", Type: " + s1 + ", type2: " + s2 + ", points: " + points + " ($ " + (points/10) + "), Period: " + TimeframeToString(periods[i]);
                  price1 = 0;
                  price2 = 0;
               }
            }
         } else {
            s1 = checkopen(strategy, Symbol(), periods[i], j+1);
            if (s1 == 1 || s1 == -1) {
               price1 = iOpen(Symbol(), periods[i], j);
               price2 = 0;
            }
         }
         
      }
      box = box + "\n\n" + Symbol() + "\nTime: " + some_time + ", Period: " + TimeframeToString(periods[i]) +",  totalpoints: " + totalpoints + " with app amount (0.10 unit) = $ " + (totalpoints / 100);
      
      infobox = infobox + "\ntotalpoints: " + totalpoints + " with app amount (0.10 unit) = " + (totalpoints / 10);
      FileAppend("history3.txt", box);
   }
   Comment(infobox);
}

int checkclose(int strategy, string symbol, int period, int shift)
{
   int s1;
   int macd, heiken;
   double tenkan_sen_1;
   switch (strategy) {
      case 1://heiken and macd
          macd = macdRCurrentshift(symbol, period, shift);
          heiken = heikenCurrentshift(symbol, period, shift);
         if (macd == 1 && heiken == 1) {
            return (1);
         } else if (macd == -1 && heiken == -1) {
            return (-1);
         }
         return (0);
         break;
      case 2://tenkan and macd
          macd = macdRCurrentshift(symbol, period, shift);
          tenkan_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_TENKANSEN, 1);
         if (macd == 1 && tenkan_sen_1 < MarketInfo(symbol, MODE_BID)) {
            return (1);
         } else if (macd == -1 && tenkan_sen_1  > MarketInfo(symbol, MODE_BID)) {
            return (-1);
         }
         return (0);
         break;
    }

}

int checkopen(int strategy, string symbol, int period, int shift)
{
   int macd, heiken, macdchange, heikenchange;
   switch (strategy) {
      case 1:
          macd = macdRCurrentshift(symbol, period, shift);
          heiken = heikenCurrentshift(symbol, period, shift);

          macdchange = macdRshift(symbol, period, shift);
          heikenchange = heikenshift(symbol, period, shift);
         if ((heikenchange == 1 && macd == 1) || (heiken == 1 && macdchange == 1)) {
            return (1);
         } else if ((heikenchange == -1 && macd == -1) || (heiken == -1 && macdchange == -1)) {
            return (-1);
         }
         return (0);
         break;
   }
}