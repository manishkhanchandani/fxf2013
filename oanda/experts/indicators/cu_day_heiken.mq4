//+------------------------------------------------------------------+
//|                                                cu_day_heiken.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#include <3_signal_inc.mqh>
int stime;

int FastEMA=12;
int SlowEMA=26;
int SignalSMA=9;


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
   if (stime != iTime(Symbol(), Period(), 0)) {
      stime = iTime(Symbol(), Period(), 0);
   infobox = "";
   int x;
   int period = Period();
   string symbol;
   int periods[7] = {PERIOD_D1, PERIOD_H4, PERIOD_H1, PERIOD_M30, PERIOD_M15, PERIOD_M5, PERIOD_M1};
   string tmpbox;
   for (x = 0; x < ARRSIZE; x++) {
         tmpbox = "             ";
         if (x == EURJPY || x == CHFJPY || x == GBPJPY || x == CADJPY || x == USDJPY || x == AUDJPY
          || x == NZDJPY || x == GBPNZD) {
         
         } else {
            //continue;
         }
         symbol = aPair[x];
         
         infobox = infobox + "\nSymbol: " + symbol;
         for (int j=0;j<1; j++) {
            double macd = iMA(symbol, periods[j],FastEMA,0,MODE_EMA,PRICE_CLOSE,1);
            double macd2=iMA(symbol, periods[j],SlowEMA,0,MODE_EMA,PRICE_CLOSE,1);
            double macddiff = macd - macd2;
            /*if ((macddiff > 0 && macddiff < 0.0008) || (macddiff < 0 && macddiff > -0.0008)) {
               tmpbox = tmpbox + ", Sp " + TimeframeToString(periods[j]) + " Signal";
            } else 
            if ((macddiff > 0 && macddiff < 0.008) || (macddiff < 0 && macddiff > -0.008)) {
               tmpbox = tmpbox + ", " + TimeframeToString(periods[j]) + " Signal";
            }*/
            int macdR = macdR(symbol, periods[j]);
            int bbtrend = bbtrend(symbol, periods[j], 1);
            int bbtrendDiff = bbtrend(symbol, periods[j], 2);
            int bbtrendDiff3 = bbtrend(symbol, periods[j], 3);
            int bbtrendDiff4 = bbtrend(symbol, periods[j], 4);
            int bbtrendDiff5 = bbtrend(symbol, periods[j], 5);
            //string status = checkbb(bbtrend, bbtrendDiff, 1, periods[j], symbol);
            string status;
            if (bbtrend == 1 && bbtrendDiff == -1) {
               status = "Buy";
               SendAlert("bbtrend 2 for symbol: " + symbol + " is " + status + " with Bid price: " + MarketInfo(symbol, MODE_BID), symbol, PERIOD_D1);
            } else if (bbtrend == -1 && bbtrendDiff == 1) {
               status = "Sell";
               SendAlert("bbtrend 2 for symbol: " + symbol + " is " + status + " with Bid price: " + MarketInfo(symbol, MODE_BID), symbol, PERIOD_D1);
            } 
            
            string status3;
            if (bbtrend == 1 && bbtrendDiff3 == -1) {
               status3 = "Buy";
               SendAlert("bbtrend 3 for symbol: " + symbol + " is " + status + " with Bid price: " + MarketInfo(symbol, MODE_BID), symbol, PERIOD_D1);
            } else if (bbtrend == -1 && bbtrendDiff3 == 1) {
               status3 = "Sell";
               SendAlert("bbtrend 3 for symbol: " + symbol + " is " + status + " with Bid price: " + MarketInfo(symbol, MODE_BID), symbol, PERIOD_D1);
            } 
            
            string status4;
            if (bbtrend == 1 && bbtrendDiff4 == -1) {
               status4 = "Buy";
               SendAlert("bbtrend 4 for symbol: " + symbol + " is " + status + " with Bid price: " + MarketInfo(symbol, MODE_BID), symbol, PERIOD_D1);
            } else if (bbtrend == -1 && bbtrendDiff4 == 1) {
               status4 = "Sell";
               SendAlert("bbtrend 4 for symbol: " + symbol + " is " + status + " with Bid price: " + MarketInfo(symbol, MODE_BID), symbol, PERIOD_D1);
            } 
            
            string status5;
            if (bbtrend == 1 && bbtrendDiff5 == -1) {
               status5 = "Buy";
               SendAlert("bbtrend 5 for symbol: " + symbol + " is " + status + " with Bid price: " + MarketInfo(symbol, MODE_BID), symbol, PERIOD_D1);
            } else if (bbtrend == -1 && bbtrendDiff5 == 1) {
               status5 = "Sell";
               SendAlert("bbtrend 5 for symbol: " + symbol + " is " + status + " with Bid price: " + MarketInfo(symbol, MODE_BID), symbol, PERIOD_D1);
            } 
            
            if (macdR == 1 || macdR == -1) {
               SendAlert("macdR for symbol: " + symbol + " is " + macdR + " with Bid price: " + MarketInfo(symbol, MODE_BID), symbol, PERIOD_D1);
            }
            infobox = infobox + ", " + TimeframeToString(periods[j]) + " MACD: " + macddiff + ", macdR: " + macdR + 
            ", bbtrend: " + bbtrend + 
            ", bbtrendDiff: " + bbtrendDiff + ", status: " + status + ", status3: " + status3
             + ", status4: " + status4 + ", status5: " + status5;
         }
         infobox = infobox + tmpbox;
         
   }
   Comment(infobox);
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

string checkbb(int bbtrend, int bbtrendDiff, int number, int period, string symbol)
{
string status;
            if (bbtrend == 1 && bbtrendDiff == -1) {
               status = "Buy";
               SendAlert("bbtrend (number: " + number + ")" + 
               " for symbol: " + symbol + " is " + status + " with Bid price: " + MarketInfo(symbol, MODE_BID), symbol, period);
            } else if (bbtrend == -1 && bbtrendDiff == 1) {
               status = "Sell";
               SendAlert("bbtrend (number: " + number + ")" + 
               " for symbol: " + symbol + " is " + status + " with Bid price: " + MarketInfo(symbol, MODE_BID), symbol, period);
            }  
            return (status);
}