//+------------------------------------------------------------------+
//|                                               cuChartPattern.mq4 |
//|                                              Manish Khanchandani |
//|                                          http://www.mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://www.mkgalaxy.com"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Yellow
#property indicator_color2 Red

double CrossUp[];
double CrossDown[];
double Cross[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_ARROW, EMPTY,2);
   SetIndexArrow(0, 233);
   SetIndexBuffer(0, CrossUp);
   SetIndexStyle(1, DRAW_ARROW, EMPTY,2);
   SetIndexArrow(1, 234);
   SetIndexBuffer(1, CrossDown);
   SetIndexStyle(2, DRAW_NONE);
   SetIndexBuffer(2, Cross);
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
   int limit, i, counter;
   double Range, AvgRange;
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;

   limit=Bars-counted_bars;
   int condition = 0;
   for(i = 1; i <= limit; i++) {
   
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      condition = 0;
      
      int cobra = cobra(i);
      if (cobra == 1) {
         CrossUp[i] = Low[i] - Range*0.5;
         Cross[i] = 1;
      } else if (cobra == -1) {
         CrossDown[i] = High[i] + Range*0.5;
         Cross[i] = -1;
      }
   }
   return(0);
  }
//+------------------------------------------------------------------+


int cobra(int i)
{
   double ma72h = iMA(NULL,0,72,0,MODE_SMA,PRICE_HIGH,i);
   double ma72l = iMA(NULL,0,72,0,MODE_SMA,PRICE_LOW,i);
   
   if (Close[i] > ma72h && Open[i] > ma72h && (Close[i+1] <= ma72h || Open[i+1] <= ma72h || Low[i+1] <= ma72h)
      //&& High[i] > High[i+1]
      ) {
      return (1);
   } else if (Close[i] < ma72l && Open[i] < ma72l && (Close[i+1] >= ma72l || Open[i+1] >= ma72l || High[i+1] >= ma72h)
      //&& Low[i] < Low[i+1]
      ) {
      return (-1);
   }
   return (0);
}