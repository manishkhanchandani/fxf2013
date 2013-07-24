//+------------------------------------------------------------------+
//|                                                    cuDayline.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

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
   int    counted_bars=IndicatorCounted();
//----
   
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;

   int limit=Bars-counted_bars;
   for(int i=0; i<limit; i++)
   {
      if (TimeHour(Time[i]) == 0 && TimeMinute(Time[i]) == 0) {
         vline("line_"+i, Time[i], Yellow);
      }
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+


void vline(string name, int time, color TextColor)
{
   ObjectCreate(name, OBJ_VLINE, 0, time, 0);
   ObjectSet(name, OBJPROP_COLOR, TextColor);
}