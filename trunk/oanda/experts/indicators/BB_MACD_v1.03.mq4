//+------------------------------------------------------------------+
//|                                               Custom BB_MACD.mq4 |
//|                                     Copyright © 2005, adoleh2000 |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+

#property  copyright "Copyright © 2005, adoleh2000"
#property  link      "http://www.metaquotes.net/"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 4
#property  indicator_color1  Blue    //Upperband
#property  indicator_color2  Red     //Lowerband
#property  indicator_color3  Lime    //bbMacd up
#property  indicator_color4  Magenta //bbMacd up

//
//
//
//
//---- indicator parameters
extern int    FastLen         = 12;
extern int    SlowLen         = 26;
extern int    Length          = 10;
extern double StDv            = 2.5;
extern int    barsToCalculate = 300;
extern bool   drawDots        = True;
extern bool   fillGaps        = True;

//
//
//
//
//---- indicator buffers
double ExtMapBuffer1[];  // bbMacd
double ExtMapBuffer2[];  // bbMacd
double ExtMapBuffer3[];  // Upperband Line
double ExtMapBuffer4[];  // Lowerband Line
double bbMacd[];
double trend[];

//
//
//
//
//

double   sDev;
datetime lastBarTime;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   SetIndexBuffer(2, ExtMapBuffer1); // bbMacd line
   SetIndexBuffer(3, ExtMapBuffer2); // bbMacd line
   if (drawDots)
      {
         SetIndexStyle(2, DRAW_ARROW);
         SetIndexArrow(2, 159);
         SetIndexStyle(3, DRAW_ARROW);
         SetIndexArrow(3, 159);
      }         
   else      
      {
         SetIndexStyle(2, DRAW_LINE);
         SetIndexStyle(3, DRAW_LINE);
      }         
   SetIndexBuffer(0, ExtMapBuffer3); // Upperband line
   SetIndexBuffer(1, ExtMapBuffer4); // Lowerband line

   //
   //
   //
   //
   //
   
   barsToCalculate = MathMax(barsToCalculate,150);
   lastBarTime     = EMPTY_VALUE;
      ArrayResize(bbMacd ,barsToCalculate);
      ArrayResize(trend  ,barsToCalculate);
      ArraySetAsSeries(bbMacd,true);
      ArraySetAsSeries(trend ,true);
   

   //
   //
   //
   //
   //
            
   IndicatorShortName("BB MACD (" + FastLen + "," + SlowLen + "," + Length+")");
   SetIndexLabel(0, "Upperband");
   SetIndexLabel(1, "Lowerband");  
   SetIndexLabel(2, "upTrend");
   SetIndexLabel(3, "downTrend");
   SetIndexDrawBegin(0,barsToCalculate-1);
   SetIndexDrawBegin(1,barsToCalculate-1);
   SetIndexDrawBegin(2,barsToCalculate-1);
   SetIndexDrawBegin(3,barsToCalculate-1);
   IndicatorDigits(Digits + 1);
   return(0);
}
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{
   return(0);
}
//+------------------------------------------------------------------+
//| Custom BB_MACD                                                   |
//+------------------------------------------------------------------+
int start()
{
  
   double avg;
   int    limit;
   int    counted_bars = IndicatorCounted();

   if(counted_bars < 0) return(-1);
   if(counted_bars > 0) counted_bars--;
   if(lastBarTime != iTime(NULL,0,0))
      {
         limit = barsToCalculate;
         lastBarTime = iTime(NULL,0,0);
      }
   else  limit = MathMin(Bars - counted_bars,barsToCalculate);


   //
   //
   //
   //
   //
   
   for(int i = 0; i < limit; i++)
       bbMacd[i] = iMA(NULL, 0, FastLen, 0, MODE_EMA, PRICE_CLOSE, i) - 
                   iMA(NULL, 0, SlowLen, 0, MODE_EMA, PRICE_CLOSE, i);


   //
   //
   //
   //
   //
   
   for(i = limit; i >= 0 ; i--)
     {
       avg              = iMAOnArray(bbMacd, 0, Length, 0, MODE_EMA, i);
       sDev             = iStdDevOnArray(bbMacd, 0, Length, MODE_EMA, 0, i);  
       ExtMapBuffer1[i] = bbMacd[i];
       ExtMapBuffer2[i] = bbMacd[i];
       ExtMapBuffer3[i] = avg + (StDv * sDev);
       ExtMapBuffer4[i] = avg - (StDv * sDev);
            trend[i] = trend[i+1];
               if (bbMacd[i]> bbMacd[i+1]) trend[i] = 1;
               if (bbMacd[i]< bbMacd[i+1]) trend[i] =-1;

               
            //
            //
            //
            //
            //
               
               if (!drawDots && fillGaps)
                  {
                    if (trend[i]>0)
                       { 
                          ExtMapBuffer2[i] = EMPTY_VALUE;
                          if (trend[i+1]<0) ExtMapBuffer1[i+1] = bbMacd[i+1]; 
                       }
                    if (trend[i]<0)
                       { 
                          ExtMapBuffer1[i] = EMPTY_VALUE;
                          if (trend[i+1]>0) ExtMapBuffer2[i+1] = bbMacd[i+1]; 
                       }
                  }
               else                                       
                  {
                     if(bbMacd[i] > bbMacd[i+1]) ExtMapBuffer2[i] = EMPTY_VALUE;
                     if(bbMacd[i] < bbMacd[i+1]) ExtMapBuffer1[i] = EMPTY_VALUE;
                  }                     
 
 
          //----
          //----
          
     }
   return(0);
}
//+------------------------------------------------------------------+
 