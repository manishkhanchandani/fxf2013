//+------------------------------------------------------------------+
//|                                                     Reversal.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 LawnGreen
#property indicator_color2 Red

double CrossUp[];
double CrossDown[];

extern int threshold_period_15 =  10;
int maxbars = 10;
double newhigh;
double newlow;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_ARROW, EMPTY);
   SetIndexArrow(0, 233);
   SetIndexBuffer(0, CrossUp);
   SetIndexStyle(1, DRAW_ARROW, EMPTY);
   SetIndexArrow(1, 234);
   SetIndexBuffer(1, CrossDown);
   if (Period() == PERIOD_M15) {
      maxbars = threshold_period_15;
   }
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
  Alert("start");
   int counter;
   double Range, AvgRange;
   int limit, i, j;
   double high, low;
   int    counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   newhigh = High[0];
   newlow = Low[0];
   int found = 0;
   int buy = 1;
   int sell = 0;
   for(i = 0; i <= 200; i++) {
      if (sell != 0) {
         buy = calculate_buy(i);
      }
      if (buy != 0) {
         sell = calculate_sell(i);
      }
      sell = calculate_sell(i);
      if (sell != 0) {
      
      }
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

int calculate_buy(int i)
{
   int counter;
   double Range, AvgRange;
   int found = 0;
   int j = 0;
      for (j = i+1; j <= i + 15; j++) {
         counter=i;
         Range=0;
         AvgRange=0;
         for (counter=i ;counter<=i+9;counter++)
         {
            AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
         }
         Range=AvgRange/10;
         if (High[j] >= newhigh) {
            newhigh = High[j];
            newlow = Low[j];
            found = 1;
            //Alert(i, ", ", j, ", newhigh: ", newhigh);
            if (found > 0) break;
         }
      }
      if (found == 0) {
         CrossDown[i] = High[i] + Range*0.5;
         return (i);
      }

   return (0); 
}

int calculate_sell(int i)
{
   int counter;
   double Range, AvgRange;
   int found = 0;
   int j = 0;
      for (j = i+1; j <= i + 15; j++) {
         counter=i;
         Range=0;
         AvgRange=0;
         for (counter=i ;counter<=i+9;counter++)
         {
            AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
         }
         Range=AvgRange/10;
         if (Low[j] >= newlow) {
            newhigh = High[j];
            newlow = Low[j];
            found = 1;
            //Alert(i, ", ", j, ", newhigh: ", newhigh);
            if (found > 0) break;
         }
      }
      if (found == 0) {
         CrossUp[i] = Low[i] + Range*0.5;
         return (i);
      }

   return (0); 
}