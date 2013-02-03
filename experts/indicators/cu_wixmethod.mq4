//+------------------------------------------------------------------+
//|                                               cu_forexmarket.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_width1 2
#property indicator_color2 Orange
#property indicator_width2 2
double CrossUp[];
double CrossDown[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   ObjectsDeleteAll(0, OBJ_ARROW); 
   SetIndexStyle(0, DRAW_ARROW, EMPTY);
   SetIndexArrow(0, 233);
   SetIndexBuffer(0, CrossUp);
   SetIndexStyle(1, DRAW_ARROW, EMPTY);
   SetIndexArrow(1, 234);
   SetIndexBuffer(1, CrossDown);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectsDeleteAll(0, OBJ_ARROW); 
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   int i;
//----
   int limit=Bars-counted_bars;
   string name;
   double high, low, open, close;
   double body, totalmove;
   double top, bottom;
   int counter;
   double Range, AvgRange;
   int result;
   for(i = limit; i >= 0; i--) {
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      high = High[i];
      low = Low[i];
      open = Open[i];
      close = Close[i];
      body = MathAbs(Open[i] - Close[i]);
      result = 0;
      if (open > close) {
         top = high - open;
         bottom = close - low;
         result = 1;
      } else {
         top = high - close;
         bottom = open - low;
         result = -1;
      }
      totalmove = high - low;
      if (body < (totalmove * 0.30) && (top > (totalmove * 0.50) || bottom > (totalmove * 0.50))) {
         name = "bar_" + Time[i];
         if (result == 1) {
            CrossDown[i] = High[i] + Range*0.5;
         } else if (result == -1) {
            CrossUp[i] = Low[i] - Range*0.5;
         }
      }
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
/*
void create_vline(string name, int time, color c)
{
   ObjectCreate(name, OBJ_VLINE, 0, time, 0);
   ObjectSet(name, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet(name, OBJPROP_WIDTH, 2);
   ObjectSet(name, OBJPROP_COLOR, c);
}*/

void create_check(string name, int time, color c, double price)
{
   ObjectCreate(name, OBJ_ARROW, 0, time, price);
   ObjectSet(name,OBJPROP_ARROWCODE,SYMBOL_CHECKSIGN);
   ObjectSet(name, OBJPROP_COLOR, c);
}