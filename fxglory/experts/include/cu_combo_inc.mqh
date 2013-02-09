//+------------------------------------------------------------------+
//|                                                 cu_combo_inc.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

int opentime;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int custom_init()
  {
//---- indicators
   createlabel("cname", "Signal: ", 20, 20);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int custom_deinit()
  {
//----
   ObjectDelete("cname");
   ObjectDelete("cname_signal");
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int custom_start()
  {
   int    counted_bars=IndicatorCounted();
//----
   if (stage == 0) {
      return (0);
   }
   double val2, val3, val4, val5;
   
   val2 = iCustom(NULL, PERIOD_H1, "MACD_Complete",1,0);
   val3 = iCustom(NULL, PERIOD_H1, "MACD_Complete",2,0);
   val4 = iCustom(NULL, PERIOD_H1, "MACD_Complete",1,1);
   val5 = iCustom(NULL, PERIOD_H1, "MACD_Complete",2,1);
   if (val2 > val3 && stage == 1 && val4 < val5) {
      createlabel("cname_signal", "Buy, Price: " + DoubleToStr(Bid, Digits) + ", Time: " + TimeToStr(TimeCurrent()), 80, 20);
      if (opentime != Time[0]) {
         Alert(Symbol(), " Buy");
         opentime = Time[0];
      }
   } else if (val2 < val3 && stage == -1 && val4 > val5) {
      createlabel("cname_signal", "Sell, Price: " + DoubleToStr(Bid, Digits)+ ", Time: "+TimeToStr(TimeCurrent()), 80, 20);
      if (opentime != Time[0]) {
         Alert(Symbol(), " Sell");
         opentime = Time[0];
      }
   } else {
      createlabel("cname_signal", "Consolidated", 80, 20);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+

void createlabel(string name, string text, int x, int y)
{
   ObjectDelete(name);
   if (ObjectCreate(name, OBJ_LABEL, 0, 0, 0)) {
      ObjectSet(name, OBJPROP_XDISTANCE, x);
      ObjectSet(name, OBJPROP_YDISTANCE, y);
      ObjectSetText(name, text, 10, "Verdana", White);
   }
}