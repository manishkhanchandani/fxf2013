//+------------------------------------------------------------------+
//|                                                 cu_macd_diff.mq4 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

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
   ObjectsDeleteAll(0, OBJ_LABEL); 
   ObjectsDeleteAll(0, OBJ_TEXT);
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
   ObjectsDeleteAll(0, OBJ_LABEL); 
   ObjectsDeleteAll(0, OBJ_TEXT);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   int limit, i, counter;
   if(counted_bars<0) return(-1);
   //---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   double val2, val3;
   double Range, AvgRange;
   int val;
   string name;
   for(i = 0; i <= 4; i++) {
   
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      val2 = iCustom(Symbol(), Period(), "MACD_Complete",1,i);
      val3 = iCustom(Symbol(), Period(), "MACD_Complete",2,i);
      val = (val2 - val3) / Point;
      name = "macddiff_" + i;
      ObjectCreate("text_object"+i, OBJ_TEXT, 0, Time[i], High[i]);
      ObjectSetText("text_object"+i, val, 8, "Tahoma", Black);
      /*
      if (Open[i] > Close[i]) {
         //CrossDown[i] = High[i] + Range*0.5;
         ObjectCreate(name, OBJ_LABEL, 0, Time[i], (High[i] + Range*0.5));
         ObjectSetText(name, val, 10, "Verdana", Red);
      } else {
         //CrossUp[i] = Low[i] - Range*0.5;   
         ObjectCreate(name, OBJ_LABEL, 0, Time[i], (Low[i] - Range*0.5)); 
         ObjectSetText(name, val, 10, "Verdana", Blue);
      }*/
  }
   
//----
   return(0);
  }
//+------------------------------------------------------------------+