//+------------------------------------------------------------------+
//|                                             cuStrategyTester.mq4 |
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
//----
   int limit;
   int counted_bars=IndicatorCounted();
   int type = 0;
   double price = 0;
   double lots = 0.10;
   int points = 0;
   double earnings = 0;
   int result;
   string name;
   ObjectsDeleteAll(0, OBJ_TEXT);
   for (int i=2000; i >= 0; i--) {
      double MacdCurrent=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,i);
      double MacdPast=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,i+1);
      if (MacdCurrent >=0 && MacdPast < 0) {
         if (type == 0) {
            name = "s_" + i; 
            ObjectCreate(name, OBJ_TEXT, 0, Time[i], Open[i]);
            ObjectSetText(name, "Start: " + DoubleToStr(Open[i], Digits) + " Buy", 10, "Verdana", White);
         }
         //buy
         if (type == -1) {
            result = (price - Open[i]) / Point;
            points = points + result;
            name = "s_" + i;
            ObjectCreate(name, OBJ_TEXT, 0, Time[i], Open[i]);
            ObjectSetText(name, "Result: " + result + "("+DoubleToStr((points * lots), 1)+")", 10, "Verdana", White);
         }
         type = 1;
         price = Open[i];
      } else if (MacdCurrent <=0 && MacdPast > 0) {
         if (type == 0) {
            name = "s_" + i;
            ObjectCreate(name, OBJ_TEXT, 0, Time[i], Open[i]);
            ObjectSetText(name, "Start: " + DoubleToStr(Open[i], Digits) + " Sell", 10, "Verdana", White);
         }
         //sell
         if (type == 1) {
            result = (Open[i] - price) / Point;
            points = points + result;
            name = "s_" + i;
            ObjectCreate(name, OBJ_TEXT, 0, Time[i], Open[i]);
            ObjectSetText(name, "Result: " + result + "("+DoubleToStr((points * lots), 1)+")", 10, "Verdana", White);
         }
         type = -1;
         price = Open[i];
      }
   }
   earnings = points * lots;
   
   Comment(earnings);
   return (0);
//----
   return(0);
  }
//+------------------------------------------------------------------+