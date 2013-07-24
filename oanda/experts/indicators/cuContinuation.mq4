//+------------------------------------------------------------------+
//|                                               cuContinuation.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

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
   int limit;
   int counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   int      shift;
//---- macd counted in the 1-st buffer
   string name;
   for(int i=0; i<limit; i++) {
      if ((TimeHour(Time[i]) == 0 
         || TimeHour(Time[i]) == 4 || TimeHour(Time[i]) == 8 || TimeHour(Time[i]) == 12 
         || TimeHour(Time[i]) == 16 || TimeHour(Time[i]) == 20)
         && TimeMinute(Time[i]) == 0
         ) {
         name = "time_"+i;
         ObjectDelete(name);
         vline(name, Time[i], Gold);
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