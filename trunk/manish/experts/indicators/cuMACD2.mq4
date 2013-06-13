//+------------------------------------------------------------------+
//|                                                  Custom MACD.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2004, MetaQuotes Software Corp."
#property  link      "http://www.metaquotes.net/"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 2
#property  indicator_color1  Silver
#property  indicator_color2  Red
#property  indicator_width1  2
//---- indicator parameters
extern int FastEMA=12;
extern int SlowEMA=26;
extern int SignalSMA=9;
//---- indicator buffers
double     MacdBuffer[];
double     SignalBuffer[];

  int period;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
  
  switch(Period())
   {
      case PERIOD_M1:  period = PERIOD_M15; break;
      case PERIOD_M5:  period = PERIOD_M30; break;
      case PERIOD_M15: period = PERIOD_H1; break;
      case PERIOD_M30: period = PERIOD_H4; break;
      case PERIOD_H1:  period = PERIOD_D1; break;
      case PERIOD_H4:  period = PERIOD_W1; break;
      case PERIOD_D1:  period = PERIOD_MN1; break;
      case PERIOD_W1:  period = PERIOD_MN1; break;
      case PERIOD_MN1: period = PERIOD_MN1; break;
      case 0: period = Period(); break;
   }
//---- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexDrawBegin(1,SignalSMA);
   IndicatorDigits(Digits+1);
//---- indicator buffers mapping
   SetIndexBuffer(0,MacdBuffer);
   SetIndexBuffer(1,SignalBuffer);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("MACD("+FastEMA+","+SlowEMA+","+SignalSMA+","+TimeframeToString(period)+")");
   SetIndexLabel(0,"MACD");
   SetIndexLabel(1,"Signal");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Moving Averages Convergence/Divergence                           |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();
   int bars = iBars(Symbol(), period);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   int      shift;
//---- macd counted in the 1-st buffer
   for(int i=0; i<limit; i++) {
      shift=iBarShift(Symbol(),period,Time[i]);
      MacdBuffer[i]=iMA(NULL,period,FastEMA,0,MODE_EMA,PRICE_CLOSE,shift)-iMA(NULL,period,SlowEMA,0,MODE_EMA,PRICE_CLOSE,shift);
   }
//---- signal line counted in the 2-nd buffer
   for(i=0; i<limit; i++)
      SignalBuffer[i]=iMAOnArray(MacdBuffer,Bars,SignalSMA,0,MODE_SMA,i);
//---- done
   return(0);
  }
//+------------------------------------------------------------------+


string TimeframeToString(int P)
{
   switch(P)
   {
      case PERIOD_M1:  return("M1");
      case PERIOD_M5:  return("M5");
      case PERIOD_M15: return("M15");
      case PERIOD_M30: return("M30");
      case PERIOD_H1:  return("H1");
      case PERIOD_H4:  return("H4");
      case PERIOD_D1:  return("D1");
      case PERIOD_W1:  return("W1");
      case PERIOD_MN1: return("MN1");
      case 0: return ("Any");
   }
}


