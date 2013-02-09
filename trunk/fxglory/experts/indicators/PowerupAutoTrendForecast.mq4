//+------------------------------------------------------------------+
//|                                            AutoTrendForecast.mq4 |
//|                                         Copyright © 2011, RoboFx |
//|                                            http://www.robofx.org |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, RoboFx"
#property link      "http://www.robofx.org"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Lime
#property indicator_color2 Red
#property indicator_width1 3
#property indicator_width2 3

// Buffers
double SAR[];
double MA[];
double Uptrend[];
double Dntrend[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
//---- indicators
   IndicatorBuffers(4);
   SetIndexBuffer(0,Uptrend);
   SetIndexBuffer(1,Dntrend);
   SetIndexBuffer(2,SAR);
   SetIndexBuffer(3,MA);
   
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_NONE);
   SetIndexStyle(3,DRAW_NONE);
   
   SetIndexLabel(0,"Uptrend");
   SetIndexLabel(1,"Downtrend");
   
   SetIndexEmptyValue(0,EMPTY_VALUE);
   SetIndexEmptyValue(1,EMPTY_VALUE);
   
   IndicatorShortName("AutoTrendForecast");
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
   int  limit, counted_bars=IndicatorCounted();
//----
   limit = Bars - counted_bars - 1;
   
   for(int i=0;i<limit;i++)
   {
      SAR[i] = iSAR(Symbol(),0,0.01,0.1,i);
      MA[i] = iMA(Symbol(),0,14,0,MODE_SMA,PRICE_CLOSE,i);
   }
   
   
   for(i=0;i<limit;i++)
   {   
      if(SAR[i] < Close[i])
      {
         Uptrend[i] = MA[i];
         Dntrend[i] = EMPTY_VALUE;
      }
      if(SAR[i] < Close[i] && SAR[i+1] > Close[i+1]) Dntrend[i] = MA[i];
      
      if(SAR[i] > Close[i])
      {
         Dntrend[i] = MA[i];
         Uptrend[i] = EMPTY_VALUE;
      }
      if(SAR[i] > Close[i] && SAR[i+1] < Close[i+1]) Uptrend[i] = MA[i];
   }
//----
   return(0);
}
//+------------------------------------------------------------------+