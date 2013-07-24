//+------------------------------------------------------------------+
//|                                                      bbwidth.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_width1 1
#property indicator_color2 Red
double CrossUp[];
double CrossDown[];
double alertTag;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_ARROW, EMPTY);
   SetIndexArrow(0, 241);
   SetIndexBuffer(0, CrossUp);
   SetIndexStyle(1, DRAW_ARROW, EMPTY);
   SetIndexArrow(1, 242);
   SetIndexBuffer(1, CrossDown);
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
   int    counted_bars=IndicatorCounted();
   int maxnum = 200;
   double L_1, L_2, L_3;
   int i;
   //double b1, b2, ma;
   //double low[3];
   //double high[3];
   for(i = maxnum; i >= 0; i--) {
      L_1 = iCustom(Symbol(), Period(), "Squeeze_Break", 0, i);
      L_2 = iCustom(Symbol(), Period(), "Squeeze_Break", 1, i);
      L_3 = iCustom(Symbol(), Period(), "Squeeze_Break", 2, i);
      //Alert(DoubleToStr(L_1, Digits), ", ", DoubleToStr(L_2, Digits), ", ", DoubleToStr(L_3, Digits));
      if (L_1 < (1*Point)) {
         if (L_3 < 0 && Open[i] > Close[i]) { // && Low[i] <= iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_LOWER,i)
            CrossDown[i] = High[i];
            if (i == 1 && alertTag!=Time[0]) {
               Alert(Symbol(), ", Possible Sell Breakout");
               alertTag = Time[0];
            }
         } else if (L_3 > 0 && Open[i] < Close[i]) { // && High[i] >= iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_UPPER,i)
            CrossUp[i] = Low[i];
            if (i == 1 && alertTag!=Time[0]) {
               Alert(Symbol(), ", Possible Buy Breakout");
               alertTag = Time[0];
            }
         }
      }
      /*
      b1 = iBands(Symbol(),Period(),20,2,0,PRICE_CLOSE,MODE_UPPER,i);
      b2 = iBands(Symbol(),Period(),20,2,0,PRICE_CLOSE,MODE_LOWER,i);
      ma = iMA(Symbol(), Period(), 20, 0, MODE_SMA, PRICE_CLOSE, i);
      high[0] = High[(i)];
      high[1] = High[(i+1)];
      high[2] = High[(i+2)];
      low[0] = Low[(i)];
      low[1] = Low[(i+1)];
      low[2] = Low[(i+2)];
      if (low[0] > ma && low[1] > ma && low[2] > ma && high[0] < high[1] && high[2] < high[1] && Open[(i-1)] > Close[(i-1)]) {
         CrossBDown[i] = High[(i+1)];
      } else if (high[0] < ma && high[1] < ma && high[2] < ma && low[0] > low[1] && low[2] > high[1] && Open[(i-1)] < Close[(i-1)]) {
         CrossBUp[i] = Low[(i+1)];
      }*/
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+