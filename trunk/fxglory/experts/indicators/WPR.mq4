//+------------------------------------------------------------------+
//|                                      Williams’ Percent Range.mq4 |
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"
//----
#property indicator_separate_window
#property indicator_minimum -100
#property indicator_maximum 0
#property indicator_buffers 1
#property indicator_color1 DodgerBlue
#property indicator_level1 -20
#property indicator_level2 -80
//---- input parameters
extern int ExtWPRPeriod = 14;
//---- buffers
double ExtWPRBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string sShortName;
//---- indicator buffer mapping
   SetIndexBuffer(0, ExtWPRBuffer);
//---- indicator line
   SetIndexStyle(0, DRAW_LINE);
//---- name for DataWindow and indicator subwindow label
   sShortName="%R(" + ExtWPRPeriod + ")";
   IndicatorShortName(sShortName);
   SetIndexLabel(0, sShortName);
//---- first values aren't drawn
   SetIndexDrawBegin(0, ExtWPRPeriod);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Williams’ Percent Range                                          |
//+------------------------------------------------------------------+
int start()
  {
   int i, nLimit, nCountedBars;  
//---- insufficient data
   if(Bars <= ExtWPRPeriod) 
       return(0);
//---- bars count that does not changed after last indicator launch.
   nCountedBars = IndicatorCounted();
//----Williams’ Percent Range calculation
   i = Bars - ExtWPRPeriod - 1;
   if(nCountedBars > ExtWPRPeriod) 
       i = Bars - nCountedBars - 1;  
   while(i >= 0)
     {
       double dMaxHigh = High[Highest(NULL, 0, MODE_HIGH, ExtWPRPeriod, i)];
       double dMinLow = Low[Lowest(NULL, 0, MODE_LOW, ExtWPRPeriod, i)];      
       if(!CompareDouble((dMaxHigh - dMinLow), 0.0))
           ExtWPRBuffer[i] = -100*(dMaxHigh - Close[i]) / (dMaxHigh - dMinLow);
       i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Ôóíêöèÿ ñðàíåíèÿ äâóõ âåùåñòâåííûõ ÷èñåë.                        |
//+------------------------------------------------------------------+
bool CompareDouble(double Number1, double Number2)
  {
    bool Compare = NormalizeDouble(Number1 - Number2, 8) == 0;
    return(Compare);
  } 
//+------------------------------------------------------------------+ 