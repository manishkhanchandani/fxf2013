//+------------------------------------------------------------------+
//|                                               cu_forexmarket.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#property indicator_buffers 3
double Buffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   ObjectsDeleteAll(); 
   SetIndexStyle(0, DRAW_NONE, EMPTY);
   SetIndexBuffer(0, Buffer);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectsDeleteAll(); 
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
   //create_vline("name", OBJ_VLINE, 0, Time[i]);
   int limit=Bars-counted_bars;
   string name;
   double high, low;
   int diff;
   for(i = limit; i >= 0; i--) {
      if (TimeHour(Time[i]) == 0) {
         name = "bar_" + Time[i];
         create_vline(name, Time[i], Red);
      }
      if (TimeHour(Time[i]) == 5) {
         name = "bar_" + Time[i];
         create_vline(name, Time[i], Blue);
      }
      high = High[i+1];
      low = Low[i+1];
      diff = (high - low) / Point;
      Buffer[i] = diff;
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+

void create_vline(string name, int time, color c)
{
   ObjectCreate(name, OBJ_VLINE, 0, time, 0);
   ObjectSet(name, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet(name, OBJPROP_WIDTH, 2);
   ObjectSet(name, OBJPROP_COLOR, c);
}