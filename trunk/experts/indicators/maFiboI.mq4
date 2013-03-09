//+------------------------------------------------------------------+
//|                                                      maFiboI.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   ObjectDelete("XIT_FIBO");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectDelete("XIT_FIBO");
   
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
   
     int fibHigh = iHighest(Symbol(),Period(),MODE_HIGH,WindowFirstVisibleBar()-1,1);
     int fibLow  = iLowest(Symbol(),Period(),MODE_LOW,WindowFirstVisibleBar()-1,1);
     
     datetime highTime = Time[fibHigh];
     datetime lowTime  = Time[fibLow];
     string infobox;
     double firstscore;
     double lastscore;
     int totalpoints;
     int type;
      if(fibHigh>fibLow){
      WindowRedraw();
      ObjectCreate("XIT_FIBO",OBJ_FIBO,0,highTime,High[fibHigh],lowTime,Low[fibLow]);
      color levelColor = Red;
      type = -1;
      infobox = infobox + "\nSell";
      firstscore = High[fibHigh];
      lastscore = Low[fibLow];
      totalpoints = (firstscore - lastscore) / Point;
      }
      else{
      WindowRedraw();
      ObjectCreate("XIT_FIBO",OBJ_FIBO,0,lowTime,Low[fibLow],highTime,High[fibHigh]);
      levelColor = Green;
      type = 1;
      infobox = infobox + "\nBuy";
      firstscore = Low[fibLow];
      lastscore = High[fibHigh];
      totalpoints = (lastscore - firstscore) / Point;
      }
      
      infobox = infobox + "\nTrend Starts From: " + firstscore + " and last curve is at: " + lastscore +
      " with points: " + totalpoints;
      double bid = MarketInfo(Symbol(), MODE_BID);
      
      double fiboPrice1=ObjectGet("XIT_FIBO",OBJPROP_PRICE1);
      double fiboPrice2=ObjectGet("XIT_FIBO",OBJPROP_PRICE2);
      
      double fiboPriceDiff = fiboPrice2-fiboPrice1;
      double f0 = fiboPrice2-fiboPriceDiff*0.0;
      double f23 = fiboPrice2-fiboPriceDiff*0.236;
      double f38 = fiboPrice2-fiboPriceDiff*0.382;
      double f50 = fiboPrice2-fiboPriceDiff*0.50;
      double f61 = fiboPrice2-fiboPriceDiff*0.618;
      double f78 = fiboPrice2-fiboPriceDiff*0.786;
      double f100 = fiboPrice2-fiboPriceDiff*1.0;
      double f138 = fiboPrice2+fiboPriceDiff*1.382;
      double f161 = fiboPrice2+fiboPriceDiff*1.618;
      
      string fiboValue0 = DoubleToStr(fiboPrice2-fiboPriceDiff*0.0,Digits);
      string fiboValue23 = DoubleToStr(fiboPrice2-fiboPriceDiff*0.236,Digits);
      string fiboValue38 = DoubleToStr(fiboPrice2-fiboPriceDiff*0.382,Digits);
      string fiboValue50 = DoubleToStr(fiboPrice2-fiboPriceDiff*0.50,Digits);
      string fiboValue61 = DoubleToStr(fiboPrice2-fiboPriceDiff*0.618,Digits);
      string fiboValue78 = DoubleToStr(fiboPrice2-fiboPriceDiff*0.786,Digits);
      string fiboValue100 = DoubleToStr(fiboPrice2-fiboPriceDiff*1.0,Digits);
      
      infobox = infobox + "\nLevel is as: 0 => " + fiboValue0
               + ", 23 => " + fiboValue23
               + ", 38 => " + fiboValue38
               + ", 50 => " + fiboValue50
               + ", 61 => " + fiboValue61
               + ", 78 => " + fiboValue78
               + ", 100 => " + fiboValue100;
      
      int currentlevel;
      if (type == 1) {
         if (bid > f0) {
            infobox = infobox + "\nCurrent Uptrend.";
         } else if (bid < f0 && bid > f23) {
            infobox = infobox + "\nCurrent Uptrend. Wait for price to bounce Up at 23 %.";
         } else if (bid < f23 && bid > f38) {
            infobox = infobox + "\nCurrent Uptrend. Wait for price to bounce Up at 38 %.";
         } else if (bid < f38 && bid > f50) {
            infobox = infobox + "\nCurrent Uptrend. Wait for price to bounce Up at 50 %.";
         } else if (bid < f50 && bid > f61) {
            infobox = infobox + "\nCurrent Uptrend. Wait for price to bounce Up at 61 %.";
         } else if (bid < f61 && bid > f78) {
            infobox = infobox + "\nWatch out for probable downtrend.";
         } else if (bid < f78 && bid > f100) {
            infobox = infobox + "\nProbable Uptrend Converting to Downtrend.";
         } else if (bid < f100) {
            infobox = infobox + "\nProbable Uptrend Converted to Downtrend.";
         }
      } else if (type == -1) {
         if (bid > f0) {
            infobox = infobox + "\nCurrent Downtrend.";
         } else if (bid > f0 && bid <  f23) {
            infobox = infobox + "\nCurrent Downtrend. Wait for price to bounce Down at 23 %.";
         } else if (bid > f23 && bid <  f38) {
            infobox = infobox + "\nCurrent Downtrend. Wait for price to bounce Down at 38 %.";
         } else if (bid > f38 && bid <  f50) {
            infobox = infobox + "\nCurrent Downtrend. Wait for price to bounce Down at 50 %.";
         } else if (bid > f50 && bid <  f61) {
            infobox = infobox + "\nCurrent Downtrend. Wait for price to bounce Down at 61 %.";
         } else if (bid > f61 && bid <  f78) {
            infobox = infobox + "\nWatch out for probable uptrend.";
         } else if (bid > f78 && bid < f100) {
            infobox = infobox + "\nProbable Uptrend Converting to uptrend.";
         } else if (bid > f100) {
            infobox = infobox + "\nProbable Uptrend Converted to uptrend.";
         }
      }
      infobox = infobox + "\nProfit Level 1: " + f138 + ", Profit Level 2: " + f161;
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
     
     Comment(infobox);
//----
//----
   return(0);
  }
//+------------------------------------------------------------------+