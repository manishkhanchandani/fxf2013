//+------------------------------------------------------------------+
//|                                                  ca_analysis.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Blue
#property indicator_width1 2
double Buffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_LINE, EMPTY);
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
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   string name;
   string message;
   for(int i = 10; i >= 1; i--) {
      Buffer[i] = Open[i];
      name = "ca_analysis_" + i;
      if (Open[i] > Close[i])
         type = -1;
      else if (Open[i] < Close[i])
         type = 1;
      else
         type = 0;
      if (type = -1) {
         if (Open[i+1] > Close[i+1])
            ptype = -1;
         else if (Open[i+1] < Close[i+1])
            ptype = 1;
         else
            ptype = 0;
         top = High[i] - Open[i];
         bottom = Close[i] - Low[i];
         middle = Open[i] - Close[i];
         if (ptype == -1) {
            ptop = High[i+1] - Open[i+1];
            pbottom = Close[i+1] - Low[i+1];
            pmiddle = Open[i+1] - Close[i+1];
         } else if (ptype == 1) {
         
         }
      }
      message = StringConcatenate("O: ", Open[i]);
      ObjectCreate(name, OBJ_TEXT, 0, Time[i], (Low[i] - (30 * Point)));
      ObjectSetText(name, message, 8, "Verdana", Red);
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+