//+------------------------------------------------------------------+
//|                                             MACD_Complete.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2004, MetaQuotes Software Corp."
#property  link      "http://www.metaquotes.net/"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 3
#property  indicator_color1  Silver
#property  indicator_width1  2
#property  indicator_color2  Blue
#property  indicator_color3  Red

//---- indicator parameters
extern int FastEMA=12;
extern int SlowEMA=26;
extern int SignalEMA=9;
//---- indicator buffers
double     HistBuffer[];
double     MacdBuffer[];
double     SignalBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(3);
//---- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexDrawBegin(0,SignalEMA);
   IndicatorDigits(Digits+2);
   SetIndexStyle(1,DRAW_LINE);
   IndicatorDigits(Digits+2);
   SetIndexStyle(2,DRAW_LINE);
   IndicatorDigits(Digits+2);

//---- 3 indicator buffers mapping
   SetIndexBuffer(0,HistBuffer);
   SetIndexBuffer(1,MacdBuffer);
   SetIndexBuffer(2,SignalBuffer);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("MACD_Histogram ("+FastEMA+","+SlowEMA+","+SignalEMA+")");
   SetIndexLabel(1,"MACD");
   SetIndexLabel(2,"Signal");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Moving Average of Oscillator                                     |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//---- macd counted in the 1-st additional buffer
   for(int i=0; i<limit; i++)
      MacdBuffer[i]=iMA(NULL,0,FastEMA,0,MODE_EMA,PRICE_CLOSE,i)-iMA(NULL,0,SlowEMA,0,MODE_EMA,PRICE_CLOSE,i);
//---- signal line counted in the 2-nd additional buffer
   for(i=0; i<limit; i++)
      SignalBuffer[i]=iMAOnArray(MacdBuffer,Bars,SignalEMA,0,MODE_EMA,i);
//---- main loop
   for(i=0; i<limit; i++)
      HistBuffer[i]=MacdBuffer[i]-SignalBuffer[i];
//---- done
   return(0);
  }
//+------------------------------------------------------------------+

