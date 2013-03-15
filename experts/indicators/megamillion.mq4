//+------------------------------------------------------------------+
//|                                                  megamillion.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"


#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Blue
#property indicator_width1 2
#property indicator_color2 Orange
#property indicator_width2 2
#property indicator_color3 Blue
#property indicator_width3 2
#property indicator_color4 Orange
#property indicator_width4 2

#include <megamillioninc.mqh>
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
Comment("");
   ObjectsDeleteAll();
   SetIndexStyle(0, DRAW_ARROW, EMPTY);
   SetIndexArrow(0, 233);
   SetIndexBuffer(0, CrossUp);
   SetIndexStyle(1, DRAW_ARROW, EMPTY);
   SetIndexArrow(1, 234);
   SetIndexBuffer(1, CrossDown);
   SetIndexStyle(2, DRAW_ARROW, EMPTY);
   SetIndexArrow(2, 74);
   SetIndexBuffer(2, CrossUp2);
   SetIndexStyle(3, DRAW_ARROW, EMPTY);
   SetIndexArrow(3, 74);
   SetIndexBuffer(3, CrossDown2);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
Comment("");
   ObjectsDeleteAll();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   infobox2 = "";
   accountinfo = StringConcatenate(
      "\n",
      "\nACCOUNT INFORMATION",
      "\nAccount Name = ", AccountName(),
      "\nAccount balance = ",AccountBalance(),
      "\nAccount free margin = ",AccountFreeMargin(),
      "\n------------------\n"
   );
   int limit, i, counter, strategy;
   double Range, AvgRange;
   int    counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   for(i = 200; i >= 1; i--) {
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      strategy = strategy(Symbol(), Period(), i);
   }
   infobox2 = StringConcatenate(infobox2, "\n", "Ask: ", DoubleToStr(Ask, Digits), ", Bid: ", DoubleToStr(Bid, Digits),"\n");
   infobox2 = StringConcatenate(infobox2, "Spread: ", ((Ask - Bid)/Point)/10,"\n");
   /*strategy = strategy(Symbol(), PERIOD_M1, 1);
   strategy = strategy(Symbol(), PERIOD_M5, 1);
   strategy = strategy(Symbol(), PERIOD_M15, 1);
   strategy = strategy(Symbol(), PERIOD_M30, 1);
   strategy = strategy(Symbol(), PERIOD_H1, 1);
   strategy = strategy(Symbol(), PERIOD_H4, 1);
   strategy = strategy(Symbol(), PERIOD_D1, 1);
   //strategy = strategy(Symbol(), PERIOD_W1, 1);
   //strategy = strategy(Symbol(), PERIOD_MN1, 1);*/
   //Comment(accountinfo,
     // infobox2);
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

