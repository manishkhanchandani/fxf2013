//+------------------------------------------------------------------+
//|                                                      cu_fibo.mq4 |
//|                                              Manish Khanchandani |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://forexmastery.org"

#property indicator_chart_window
#include <3_signal_inc.mqh>
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   del();
   Comment("");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   del();
   Comment("");
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
   del();
   int highest = iHighest(Symbol(), Period(), MODE_HIGH, WindowFirstVisibleBar()-1, 0); //WindowFirstVisibleBar()-1
   double high = iHigh(Symbol(), Period(), highest);
   //ObjectCreate("high", OBJ_HLINE, 0, 0, iHigh(Symbol(), PERIOD_H1, highest), 0, 0);
   //ObjectSet("high", OBJPROP_COLOR, Blue);
   
   int lowest = iLowest(Symbol(), Period(), MODE_LOW, WindowFirstVisibleBar()-1, 0);
   double low = iLow(Symbol(), Period(), lowest);
   //ObjectCreate("low", OBJ_HLINE, 0, 0, iLow(Symbol(), PERIOD_H1, lowest), 0, 0);
   //ObjectSet("low", OBJPROP_COLOR, Red);
   
   datetime highTime = Time[highest];
     datetime lowTime  = Time[lowest];
    if(highest>lowest){
      WindowRedraw();
      ObjectCreate("XIT_FIBO",OBJ_FIBO,0,highTime,High[highest],lowTime,Low[lowest]);
      color levelColor = Red;
      }
      else{
      WindowRedraw();
      ObjectCreate("XIT_FIBO",OBJ_FIBO,0,lowTime,Low[lowest],highTime,High[highest]);
      levelColor = Green;
      }
      
      double fiboPrice1=ObjectGet("XIT_FIBO",OBJPROP_PRICE1);
      double fiboPrice2=ObjectGet("XIT_FIBO",OBJPROP_PRICE2);
      
      double fiboPriceDiff = fiboPrice2-fiboPrice1;
      string fiboValue0 = DoubleToStr(fiboPrice2-fiboPriceDiff*0.0,Digits);
      string fiboValue23 = DoubleToStr(fiboPrice2-fiboPriceDiff*0.236,Digits);
      string fiboValue38 = DoubleToStr(fiboPrice2-fiboPriceDiff*0.382,Digits);
      string fiboValue50 = DoubleToStr(fiboPrice2-fiboPriceDiff*0.50,Digits);
      string fiboValue61 = DoubleToStr(fiboPrice2-fiboPriceDiff*0.618,Digits);
      string fiboValue100 = DoubleToStr(fiboPrice2-fiboPriceDiff*1.0,Digits);
    
     ObjectSet("XIT_FIBO",OBJPROP_FIBOLEVELS,6);
     ObjectSet("XIT_FIBO",OBJPROP_FIRSTLEVEL+0,0.0);
     ObjectSet("XIT_FIBO",OBJPROP_FIRSTLEVEL+1,0.236);
     ObjectSet("XIT_FIBO",OBJPROP_FIRSTLEVEL+2,0.382);
     ObjectSet("XIT_FIBO",OBJPROP_FIRSTLEVEL+3,0.50);
     ObjectSet("XIT_FIBO",OBJPROP_FIRSTLEVEL+4,0.618);
     ObjectSet("XIT_FIBO",OBJPROP_FIRSTLEVEL+5,1.0);
     
     
     ObjectSet("XIT_FIBO",OBJPROP_LEVELCOLOR,levelColor);
     ObjectSet("XIT_FIBO",OBJPROP_LEVELWIDTH,1);
     ObjectSet("XIT_FIBO",OBJPROP_LEVELSTYLE,STYLE_DASHDOTDOT);
     ObjectSetFiboDescription( "XIT_FIBO", 0,fiboValue0+" --> 0.0%"); 
     ObjectSetFiboDescription( "XIT_FIBO", 1,fiboValue23+" --> 23.6%"); 
     ObjectSetFiboDescription( "XIT_FIBO", 2,fiboValue38+" --> 38.2%"); 
     ObjectSetFiboDescription( "XIT_FIBO", 3,fiboValue50+" --> 50.0%");
     ObjectSetFiboDescription( "XIT_FIBO", 4,fiboValue61+" --> 61.8%");
     ObjectSetFiboDescription( "XIT_FIBO", 5,fiboValue100+" --> 100.0%");
     
   infobox = "";
   infobox = infobox + "\nBid: " + Bid + ", Ask: " + Ask;
   infobox = infobox + "\nHighest: " + highest;
   infobox = infobox + "\nHigh: " + high;
   infobox = infobox + "\nLowest: " + lowest;
   infobox = infobox + "\nLow: " + low;
   
   int side = 0;
   double price = 0;
   if (high > low) {
      side = -1;
      price = low;
   } else if (high < low) {
      side = 1;
      price = high;
   }
   infobox = infobox + "\nSide: " + side;
   double p23 = price - ((side * 0.23) * (high - low));
   infobox = infobox + "\np23: " + p23;
   //ObjectCreate("p23", OBJ_HLINE, 0, 0, p23, 0, 0);
   //ObjectSet("p23", OBJPROP_COLOR, Orange);
   
   double p38 = price - ((side * 0.382) * (high - low));
   infobox = infobox + "\np38: " + p38;
   //ObjectCreate("p38", OBJ_HLINE, 0, 0, p38, 0, 0);
   //ObjectSet("p38", OBJPROP_COLOR, Gold);
   
   double p50 = price - ((side * 0.50) * (high - low));
   infobox = infobox + "\np50: " + p50;
   //ObjectCreate("p50", OBJ_HLINE, 0, 0, p50, 0, 0);
   //ObjectSet("p50", OBJPROP_COLOR, White);
   
   double p618 = price - ((side * 0.618) * (high - low));
   infobox = infobox + "\np618: " + p618;
   //ObjectCreate("p618", OBJ_HLINE, 0, 0, p618, 0, 0);
   //ObjectSet("p618", OBJPROP_COLOR, Gold);
   
   
   double p77 = price - ((side * 0.77) * (high - low));
   infobox = infobox + "\np77: " + p77;
   //ObjectCreate("p77", OBJ_HLINE, 0, 0, p77, 0, 0);
   //ObjectSet("p77", OBJPROP_COLOR, Orange);
   
   double p161 = price - (0.618 * (high - low));
   infobox = infobox + "\np161: " + p161 + " (Take Profit)";
   //ObjectCreate("p161", OBJ_HLINE, 0, 0, p161, 0, 0);
   //ObjectSet("p161", OBJPROP_COLOR, Gold);
   
   
   double p261 = price - (1.61 * (high - low));
   infobox = infobox + "\np261: " + p261;
   //ObjectCreate("p261", OBJ_HLINE, 0, 0, p261, 0, 0);
   //ObjectSet("p261", OBJPROP_COLOR, Gold);
   
   /*create_label("fibtext23", 0, 0, p23, 1, 10, -1, DoubleToStr(p23, MarketInfo(Symbol(), MODE_DIGITS)) + " ---> 23%", Yellow);
   create_label("fibtext38", 0, 0, p38, 1, 10, -1, DoubleToStr(p38, MarketInfo(Symbol(), MODE_DIGITS)) + " ---> 38%", Yellow);
   create_label("fibtext50", 0, 0, p50, 1, 10, -1, DoubleToStr(p50, MarketInfo(Symbol(), MODE_DIGITS)) + " ---> 50%", Yellow);
   create_label("fibtext618", 0, 0, p618, 1, 10, -1, DoubleToStr(p618, MarketInfo(Symbol(), MODE_DIGITS)) + " ---> 68%", Yellow);
   create_label("fibtext77", 0, 0, p77, 1, 10, -1, DoubleToStr(p77, MarketInfo(Symbol(), MODE_DIGITS)) + " ---> 77%", Yellow);
   create_label("fibtext161", 0, 0, p161, 1, 10, -1, DoubleToStr(p161, MarketInfo(Symbol(), MODE_DIGITS)) + " ---> 161%", Yellow);
   create_label("fibtext261", 0, 0, p261, 1, 10, -1, DoubleToStr(p261, MarketInfo(Symbol(), MODE_DIGITS)) + " ---> 261%", Yellow);*/
   Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+

int del()
{
   
   ObjectDelete("high");
   ObjectDelete("low");
   ObjectDelete("p23");
   ObjectDelete("p38");
   ObjectDelete("p50");
   ObjectDelete("p618");
   ObjectDelete("p77");
   ObjectDelete("p161");
   ObjectDelete("p261");
   ObjectDelete("p160");
   ObjectDelete("XIT_FIBO");
   /*
   ObjectDelete("fibtext23");
   ObjectDelete("fibtext38");
   ObjectDelete("fibtext50");
   ObjectDelete("fibtext618");
   ObjectDelete("fibtext77");
   ObjectDelete("fibtext161");
   ObjectDelete("fibtext261");*/
}