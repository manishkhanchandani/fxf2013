//+------------------------------------------------------------------+
//|                                                  Custom MACD.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2004, MetaQuotes Software Corp."
#property  link      "http://www.metaquotes.net/"

#property  indicator_separate_window
#property  indicator_buffers 2
#property  indicator_color1  Silver
#property  indicator_color2  Red
#property  indicator_width1  2
//---- indicator parameters
extern int FastEMA=12;
extern int SlowEMA=26;
extern int SignalSMA=9;

//---- indicator settings
extern string periodlbl = "Period Can be M1-1, M5-2, M15-3, M30-4, H1-5, H4-6, D1-7, W1-8, MN1-9";
extern int periodType = 2;
//---- indicator buffers
double     MacdBuffer[];
double     SignalBuffer[];
int periodCurrent;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexDrawBegin(1,SignalSMA);
   IndicatorDigits(Digits+1);
//---- indicator buffers mapping
   SetIndexBuffer(0,MacdBuffer);
   SetIndexBuffer(1,SignalBuffer);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("MACD("+FastEMA+","+SlowEMA+","+SignalSMA+")");
   SetIndexLabel(0,"MACD");
   SetIndexLabel(1,"Signal");
//---- initialization done
   switch (periodType) {
      case 1:
         periodCurrent = PERIOD_M1;
         break;
      case 2:
         periodCurrent = PERIOD_M5;
         break;
      case 3:
         periodCurrent = PERIOD_M15;
         break;
      case 4:
         periodCurrent = PERIOD_M30;
         break;
      case 5:
         periodCurrent = PERIOD_H1;
         break;
      case 6:
         periodCurrent = PERIOD_H4;
         break;
      case 7:
         periodCurrent = PERIOD_D1;
         break;
      case 8:
         periodCurrent = PERIOD_W1;
         break;
      case 9:
         periodCurrent = PERIOD_MN1;
         break;
   }
   return(0);
  }
//+------------------------------------------------------------------+
//| Moving Averages Convergence/Divergence                           |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();
   datetime some_time;
   int shift;
   int bars = iBars(Symbol(), periodCurrent);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//---- macd counted in the 1-st buffer
   for(int i=0; i<limit; i++) {
      some_time=iTime(Symbol(), periodCurrent, i);
      shift=iBarShift(Symbol(),periodCurrent,some_time);
      MacdBuffer[i]=iMA(Symbol(),periodCurrent,FastEMA,0,MODE_EMA,PRICE_CLOSE,shift)-iMA(Symbol(),periodCurrent,SlowEMA,0,MODE_EMA,PRICE_CLOSE,shift);
   }
//---- signal line counted in the 2-nd buffer
   for(i=0; i<limit; i++) {
      some_time=iTime(Symbol(), periodCurrent, i);
      shift=iBarShift(Symbol(),periodCurrent,some_time);
      SignalBuffer[i]=iMAOnArray(MacdBuffer,Bars,SignalSMA,0,MODE_SMA,shift);
   }
//---- done
   return(0);
  }
//+------------------------------------------------------------------+