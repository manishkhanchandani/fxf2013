//+------------------------------------------------------------------+
//|                                              cu_size.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 SeaGreen
#property indicator_color2 Red


double CrossUp[];
double CrossDown[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   ObjectsDeleteAll();
   SetIndexStyle(0, DRAW_ARROW, EMPTY,3);
   SetIndexArrow(0, 233);
   SetIndexBuffer(0, CrossUp);
   SetIndexStyle(1, DRAW_ARROW, EMPTY,3);
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
   ObjectsDeleteAll();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//----
   int limit, i, counter;
   double Range, AvgRange;
   string name, str;
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;

   limit=Bars-counted_bars;
   double first, second, third;
   double firsth, secondh, thirdh;
   for(i = 0; i <= limit; i++) {
   
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      str = DoubleToStr((High[i] - Low[i]) / Point, 0);
      if (Open[i] > Close[i]) {
         name = "size_";
         name = StringConcatenate(name, i);
         createobj(name, OBJ_TEXT, i, Low[i] - Range*0.5, str);
      }
      else if (Open[i] < Close[i]) {
         name = "size_";
         name = StringConcatenate(name, i);
         createobj(name, OBJ_TEXT, i, High[i] + Range*0.5, str);
      }
  }
   
//----
   return(0);
  }
//+------------------------------------------------------------------+



void createobj(string name, int type, int shift, double price, string message)
{
   if (ObjectCreate(name, type, 0, Time[shift], price)) {
      if (type == OBJ_TEXT)
         ObjectSetText(name, message, 10, "Times New Roman", Blue);
   } else {
      Print("error: can't create text_object! code #",GetLastError());
      return(0);

   
   }

}