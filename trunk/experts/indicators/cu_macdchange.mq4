//+------------------------------------------------------------------+
//|                                                   macdchange.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
int opentime;
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
   string symbol = Symbol();
   string infobox;
   if (opentime != iTime(symbol, Period(), 0)) {
      infobox = "";
      double MacdCurrent=iMACD(symbol,0,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
      double MacdCurrent1=iMACD(symbol,0,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
      double MacdCurrent2=iMACD(symbol,0,12,26,9,PRICE_CLOSE,MODE_MAIN,2);
      double SignalCurrent=iMACD(symbol,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
      double SignalCurrent1=iMACD(symbol,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
      infobox = infobox + "MACD: " + MacdCurrent + ", MACD1: " + MacdCurrent1 + ", MACD2: " + MacdCurrent2;
      infobox = infobox + ", Signal: " + SignalCurrent + ", Signal1: " + SignalCurrent1 + "\n";
      if (MacdCurrent > MacdCurrent1 && MacdCurrent1 <= MacdCurrent2) {
         Alert(Symbol(), " MACD Buy");
         infobox = infobox + " - BUY";
      } else if (MacdCurrent < MacdCurrent1 && MacdCurrent1 >= MacdCurrent2) {
         Alert(Symbol(), " MACD Sell");
         infobox = infobox + " - SELL";
      }
      if (MacdCurrent > SignalCurrent && MacdCurrent1 <= SignalCurrent1) {
         Alert(Symbol(), " MACD Signal Buy");
         infobox = infobox + " - Signal BUY";
      } else if (MacdCurrent < SignalCurrent && MacdCurrent1 >= SignalCurrent1) {
         Alert(Symbol(), " MACD Signal Sell");
         infobox = infobox + " - Signal SELL";
      }
      opentime = iTime(symbol, Period(), 0);
      Comment(infobox);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+