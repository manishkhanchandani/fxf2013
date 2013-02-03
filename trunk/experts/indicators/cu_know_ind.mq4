//+------------------------------------------------------------------+
//|                                                  cu_know_ind.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#include <3_signal_inc.mqh>
#property indicator_buffers 6
#property indicator_color1 Yellow 
#property indicator_color2 Yellow 
#property indicator_color3 Yellow
#property indicator_color4 Yellow
#property indicator_color5 Yellow
#property indicator_color6 Yellow
extern int Symbol_1_Kod=140;
extern int Symbol_2_Kod=141;
extern int Symbol_3_Kod=142;
double FP_BuferUp[];
double FP_BuferDn[]; 
double NP_BuferUp[];
double NP_BuferDn[]; 
double HP_BuferUp[];
double HP_BuferDn[];
int starttime;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_ARROW,0,2); 
   SetIndexArrow(0,Symbol_1_Kod); 
   SetIndexBuffer(0,FP_BuferUp); 
   SetIndexEmptyValue(0,0.0); 
   
   SetIndexStyle(1,DRAW_ARROW,0,2); 
   SetIndexArrow(1,Symbol_1_Kod); 
   SetIndexBuffer(1,FP_BuferDn); 
   SetIndexEmptyValue(1,0.0); 
   
   SetIndexStyle(2,DRAW_ARROW,0,2); 
   SetIndexArrow(2,Symbol_2_Kod); 
   SetIndexBuffer(2,NP_BuferUp); 
   SetIndexEmptyValue(2,0.0); 
   
   SetIndexStyle(3,DRAW_ARROW,0,2); 
   SetIndexArrow(3,Symbol_2_Kod); 
   SetIndexBuffer(3,NP_BuferDn); 
   SetIndexEmptyValue(3,0.0); 
   
   SetIndexStyle(4,DRAW_ARROW,0,2); 
   SetIndexArrow(4,Symbol_3_Kod); 
   SetIndexBuffer(4,HP_BuferUp); 
   SetIndexEmptyValue(4,0.0); 

   SetIndexStyle(5,DRAW_ARROW,0,4); 
   SetIndexArrow(5,Symbol_3_Kod); 
   SetIndexBuffer(5,HP_BuferDn); 
   SetIndexEmptyValue(5,0.0); 
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
   if (starttime != iTime(symbol, Period(), 0)) {
   int period = Period();
   infobox = "Version 1.1\n\n";
      string current_currency1 = StringSubstr(symbol, 0, 3);
      string current_currency2 = StringSubstr(symbol, 3, 3);
      infobox = infobox + "\nSymbol: " + symbol + ", Currency 1: " + current_currency1 + ", Currency 2: " + current_currency2;
      infobox = infobox + ", Spread: " + MarketInfo(symbol, MODE_SPREAD) + ", Bid: " + MarketInfo(symbol, MODE_BID)
       + ", Ask: " + MarketInfo(symbol, MODE_ASK);
      double MacdCurrent = iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
      infobox = infobox + ", MacdCurrent: " + MacdCurrent + "\n";
      double Macd, Macd2;
      int macdchange = macdR(symbol, period);
      int checknumber;
      if (MacdCurrent > 0) { //sell position
         // checking high and Low
         int highest = iHighest(symbol,period,MODE_HIGH,50,1);
         double high = iHigh(symbol, period, highest);
         infobox = infobox + "Highest: " + highest + ", High: " + high;
         int highest2 = iHighest(symbol,period,MODE_HIGH,50,highest+5);
         double high2 = iHigh(symbol, period, highest2);
         infobox = infobox + ", highest2: " + highest2 + ", High2: " + high2;
         FP_BuferUp[highest] = high;
         NP_BuferUp[highest2] = high2;
         //macd calculation
         Macd = iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,highest);
         Macd2 = iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,highest2);
         
         FP_BuferDn[highest] = Macd;
         NP_BuferDn[highest2] = Macd2;
         infobox = infobox + ", Macd: " + Macd + ", Macd2: " + Macd2;
         infobox = infobox + "\n";
         if (Macd > 0 && Macd < Macd2 && macdchange == -1) {
            infobox = infobox + "Possible Sell Condition";
            HP_BuferDn[0] = -1.0;
            Alert(symbol, ", Sell");
         } 
      } else if (MacdCurrent < 0) { //buy position
         // checking high and Low
         int lowest = iLowest(symbol,period,MODE_LOW,50,1);
         double low = iLow(symbol, period, lowest);
         FP_BuferDn[lowest] = low;
         infobox = infobox + ", Lowest: " + lowest + ", low: " + low ;
         int lowest2 = iLowest(symbol,period,MODE_LOW,50,lowest+5);
         double low2 = iLow(symbol, period, lowest2);
         FP_BuferDn[lowest] = low;
         NP_BuferDn[lowest2] = low2;
         infobox = infobox + ", Lowest2: " + lowest2 + ", low2: " + low2;

   
         //macd calculation
         Macd = iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,lowest);
         Macd2 = iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,lowest2);
         FP_BuferDn[lowest] = Macd;
         NP_BuferDn[lowest2] = Macd2;
         infobox = infobox + ", Macd: " + Macd + ", Macd2: " + Macd2;
         infobox = infobox + "\n";
         if (Macd < 0 && Macd > Macd2 && macdchange == 1) {
            infobox = infobox + "Possible Buy Condition";
            HP_BuferUp[0] = 1.0;
            Alert(symbol, ", Buy");
         } 
      }
      starttime = iTime(symbol, Period(), 0);
      Comment(infobox);
      }
//----
   return(0);
  }
//+------------------------------------------------------------------+