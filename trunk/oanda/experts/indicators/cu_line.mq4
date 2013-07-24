//+------------------------------------------------------------------+
//|                                                      cu_line.mq4 |
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
   ObjectDelete("zero");
   ObjectDelete("buy1");
   ObjectDelete("buy2");
   ObjectDelete("buy3");
   ObjectDelete("buy4");
   ObjectDelete("buy5");
   ObjectDelete("sell1");
   ObjectDelete("sell2");
   ObjectDelete("sell3");
   ObjectDelete("sell4");
   ObjectDelete("sell5");
   double price;
      price = Bid;
      ObjectCreate("zero", OBJ_HLINE, 0, 0, price);
      ObjectSet("zero",OBJPROP_COLOR,White);
      ObjectSet("zero",OBJPROP_WIDTH,2);
   for (int i = 1; i <= 5; i++ ){
      price = Bid + (i * 100 * Point);
      ObjectCreate("buy" + i, OBJ_HLINE, 0, 0, price);
      ObjectSet("buy" + i,OBJPROP_COLOR,Blue);
      ObjectSet("buy" + i,OBJPROP_WIDTH,2);
   }
   for ( i = 1; i <= 5; i++ ){
      price = Bid - (i * 100 * Point);
      ObjectCreate("sell" + i, OBJ_HLINE, 0, 0, price);
      ObjectSet("sell" + i,OBJPROP_COLOR,Red);
      ObjectSet("sell" + i,OBJPROP_WIDTH,2);
   }

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
   ObjectDelete("zero");
   ObjectDelete("buy1");
   ObjectDelete("buy2");
   ObjectDelete("buy3");
   ObjectDelete("buy4");
   ObjectDelete("buy5");
   ObjectDelete("sell1");
   ObjectDelete("sell2");
   ObjectDelete("sell3");
   ObjectDelete("sell4");
   ObjectDelete("sell5");
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

