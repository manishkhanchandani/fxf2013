//+------------------------------------------------------------------+
//|                                             cu_macd_strength.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#property  indicator_buffers 3
#property  indicator_color1  Silver
#property  indicator_color2  Red
#property  indicator_width1  2


extern int FastEMA=12;
extern int SlowEMA=26;
extern int SignalSMA=9;


double     BufferFast[];
double     BufferSlow[];
double     BufferDiff[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_NONE);

   
   SetIndexBuffer(0,BufferFast);
   SetIndexBuffer(1,BufferSlow);
   SetIndexBuffer(2,BufferDiff);
   IndicatorShortName("MACDCustom("+FastEMA+","+SlowEMA+","+SignalSMA+")");
   
   SetIndexLabel(0,"Fast");
   SetIndexLabel(1,"Slow");
   SetIndexLabel(2,"Diff");
   
   SetIndexEmptyValue(0, EMPTY_VALUE);
   SetIndexEmptyValue(1, EMPTY_VALUE);
   SetIndexEmptyValue(2, EMPTY_VALUE);
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
   int limit;
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   string name;
   for(int i=0; i<limit; i++) {
      BufferFast[i]=iMA(NULL,0,FastEMA,0,MODE_EMA,PRICE_CLOSE,i);
      BufferSlow[i]=iMA(NULL,0,SlowEMA,0,MODE_EMA,PRICE_CLOSE,i);
      BufferDiff[i] = BufferFast[i] - BufferSlow[i];
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+


