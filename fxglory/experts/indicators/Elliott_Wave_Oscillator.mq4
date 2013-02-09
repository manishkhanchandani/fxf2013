//+------------------------------------------------------------------+
//|                                      Elliott Wave Oscillator.mq4 |
//|                                                tonyc2a@yahoo.com |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "tonyc2a@yahoo.com"
#property link      ""

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 LimeGreen
#property indicator_color2 FireBrick

//---- buffers
double Buffer;
double HistogramBufferUp[];
double HistogramBufferDown[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,2);
   SetIndexStyle(1, DRAW_HISTOGRAM, STYLE_SOLID, 2);
   SetIndexBuffer(0, HistogramBufferUp);
   SetIndexBuffer(1, HistogramBufferDown);
   IndicatorDigits(Digits + 2);
   IndicatorShortName("Elliott Wave Oscillator");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- TODO: add your code here
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   double MA5,MA34;
   int limit=Bars-counted_bars;
   if(counted_bars>0) limit++;
//---- TODO: add your code here
   for(int i=0; i<limit; i++)
   {
      MA5=iMA(NULL,0,5,0,MODE_SMA,PRICE_MEDIAN,i);
      MA34=iMA(NULL,0,34,0,MODE_SMA,PRICE_MEDIAN,i);
      
      Buffer=MA5-MA34;
 
      if(Buffer > 0)
      {
         HistogramBufferUp[i] = Buffer;
         HistogramBufferDown[i] = 0;
      }
      else 
         if(Buffer < 0)
            {
            HistogramBufferDown[i] = Buffer;
            HistogramBufferUp[i] = 0;   
            }
            else
               {
               HistogramBufferUp[i] = 0;
               HistogramBufferDown[i] = 0;   
               }     
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+