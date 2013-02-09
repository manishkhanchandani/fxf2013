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
  string message;
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
   double currentbuy, currentsell, currentopen, high, low, totalmove, twentyfivepercent;
   int opentime;
  i = 0;
  if (opentime != Time[0]) {
  message = "";
  }
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      high = High[1];
      low = Low[1];
      totalmove = high - low;
      twentyfivepercent = totalmove / 4;
      currentopen = Open[0];
      currentbuy = currentopen + twentyfivepercent;
      currentsell = currentopen - twentyfivepercent;
      if (Bid > currentbuy && opentime != Time[0]) {
         CrossUp[i] = Low[i] - Range*0.5;
         opentime = Time[0];
         message = "Buy";
         if (VoiceAlert==true){
            Alert("Daily Range has crossed up");
         }
      } else if (Bid < currentsell && opentime != Time[0]) {
         CrossDown[i] = High[i] + Range*0.5;
         opentime = Time[0];
         message = "Sell";
         if (VoiceAlert==true){
            Alert("Daily Range has crossed down");
         }
      }
      Comment("High: ", DoubleToStr(high, Digits),
               "\n",
               "low : ", DoubleToStr(low, Digits),
               "\n",
               "totalmove : ", DoubleToStr(totalmove, Digits),
               "\n",
               "currentopen : ", DoubleToStr(currentopen, Digits),
               "\n",
               "currentbuy : ", DoubleToStr(currentbuy, Digits),
               "\n",
               "currentsell : ", DoubleToStr(currentsell, Digits),
               "\n",
               "message : ", message,
               "\n",
               "ask : ", DoubleToStr(Ask, Digits),
               "\n",
               "bid : ", DoubleToStr(Bid, Digits));
   
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+