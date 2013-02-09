//+------------------------------------------------------------------+
//|                                                   macdchange.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_width1 2
#property indicator_color2 Orange
#property indicator_width2 2
double CrossUp[];
double CrossDown[];
extern bool VoiceAlert = false;

int NewPeriod=20;
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
   SetIndexLabel(0,"Buy");
   SetIndexLabel(1,"Sell");
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
   int iHi, iLo, iHi2, iLo2, tmp;
   double xLo, xHig, xLo2, xHig2;
   tmp = 0;
   for(i = tmp; i >= 0; i--) {
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      //Alert("start");
      //sell
      //find the highest point for period iLo;      
      iHi=iHighest(NULL,0,MODE_HIGH,NewPeriod,i);        //Highest bar in n bars
      //Alert("iHi:", iHi);
      xHig=iHigh(NULL,0,iHi);                  //Value of highest in n bars
      //Alert("xHig:", DoubleToStr(xHig, Digits));

      iLo=iLowest(NULL,0,MODE_LOW,iHi-i,i);          //Lowest bar in n bars
      //Alert("iLo:", iLo);
      xLo=iLow(NULL,0,iLo);                    //Value of lowest in n bars
      //Alert("xLo:", DoubleToStr(xLo, Digits));
 
      if (Low[i] <= xLo) {
         CrossDown[iHi] = High[iHi];
      }
      //buy     
      iLo=iLowest(NULL,0,MODE_LOW,NewPeriod,i);          //Lowest bar in n bars
      //Alert("iLo:", iLo);
      xLo=iLow(NULL,0,iLo);                    //Value of lowest in n bars
      //Alert("xLo:", DoubleToStr(xLo, Digits));
 
      iHi=iHighest(NULL,0,MODE_HIGH,iLo-i,i);        //Highest bar in n bars
      //Alert("iHi:", iHi);
      xHig=iHigh(NULL,0,iHi);                  //Value of highest in n bars
      //Alert("xHig:", DoubleToStr(xHig, Digits));

      if (High[i] >= xHig) {
         CrossUp[iLo] = Low[iLo];
      }
      
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+