//+------------------------------------------------------------------+
//|                                                      cu_know.mq4 |
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
   int period = Period();
   string symbol;
   infobox = "Version 1.1\n\n";
   for (int x = 0; x < ARRSIZE; x++) {
      symbol = aPair[x];
      if (symbol == "USDJPY") continue;
      string current_currency1 = StringSubstr(symbol, 0, 3);
      string current_currency2 = StringSubstr(symbol, 3, 3);
      if (current_currency2 != "JPY") continue;
      infobox = infobox + "\nSymbol: " + symbol + ", Currency 1: " + current_currency1 + ", Currency 2: " + current_currency2;
      infobox = infobox + ", Spread: " + MarketInfo(symbol, MODE_SPREAD);

      double MacdCurrent = iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
      int maxBar = 0;
      for (int i = 0; i < 240; i++) {
         double MacdPast = iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,i);
         if (MacdCurrent > 0) {
            if (MacdPast < 0) {
               maxBar = i - 1;
               break;
            }
         } else if (MacdCurrent < 0) {
            if (MacdPast > 0) {
               maxBar = i - 1;
               break;
            }
         }
      }
      infobox = infobox + ", maxBar: " + maxBar + ", MacdCurrent: " + MacdCurrent + "\n";
      double Macd, Macd2;
      int macdchange = macdR(symbol, period);
      int checknumber;
      if (MacdCurrent > 0) { //sell position
         // checking high and Low
         int highest = iHighest(symbol,period,MODE_HIGH,25,1);
         double high = iHigh(symbol, period, highest);

         checknumber = 25;
         if (maxBar - highest - 25 < 0) {
            checknumber = maxBar - highest;
         }
         infobox = infobox + "Highest: " + highest + ", High: " + high + ", checknumber: " + checknumber;
         int highest2 = iHighest(symbol,period,MODE_HIGH,checknumber,highest+5);
         double high2 = iHigh(symbol, period, highest2);
         infobox = infobox + ", highest2: " + highest2 + ", High2: " + high2;

         //macd calculation
         Macd = iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,highest);
         Macd2 = iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,highest2);
         infobox = infobox + ", Macd: " + Macd + ", Macd2: " + Macd2;
         infobox = infobox + "\n";
         if (Macd > 0 && Macd < Macd2 && macdchange == -1) {
            infobox = infobox + "Possible Sell Condition";
         } 
      } else if (MacdCurrent < 0) { //buy position
         // checking high and Low
         int lowest = iLowest(symbol,period,MODE_LOW,25,1);
         double low = iLow(symbol, period, lowest);
         checknumber = 25;
         if (maxBar - lowest - 25 < 0) {
            checknumber = maxBar - lowest;
         }
         infobox = infobox + ", Lowest: " + lowest + ", low: " + low + ", checknumber: " + checknumber;
         int lowest2 = iLowest(symbol,period,MODE_LOW,checknumber,lowest+5);
         double low2 = iLow(symbol, period, lowest2);
         infobox = infobox + ", Lowest2: " + lowest2 + ", low2: " + low2;

   
         //macd calculation
         Macd = iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,lowest);
         Macd2 = iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,lowest2);
         infobox = infobox + ", Macd: " + Macd + ", Macd2: " + Macd2;
         infobox = infobox + "\n";
         if (Macd < 0 && Macd > Macd2 && macdchange == 1) {
            infobox = infobox + "Possible Buy Condition";
         } 
      }
   }
   Comment(infobox); 
//----
   return(0);
  }
//+------------------------------------------------------------------+