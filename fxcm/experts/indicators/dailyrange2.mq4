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
   int opentime, closetime, closetime2;
   int buy, sell;
   double moveup, movedown;
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
  double tmp;
   int limit, i, counter;
   double Range, AvgRange;
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;

   limit=Bars-counted_bars;
   double currentbuy, currentsell, currentopen, high, low, totalmove, twentyfivepercent;
  i = 0;
  if (opentime != Time[0]) {
     opentime = Time[0];
  message = "";
  buy = 0;
  sell = 0;
  moveup = Bid;
  movedown = Bid;
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
      twentyfivepercent = totalmove * 0.10;
      currentopen = Open[0];
      currentbuy = currentopen + twentyfivepercent;
      currentsell = currentopen - twentyfivepercent;
      tmp = Bid;
      if (moveup < Bid)
         moveup = Bid;
      if (movedown > Bid)
         movedown = Bid;
      if (Bid > currentbuy && closetime != Time[0]) {
         buy = 1;
         closetime = Time[0];
      } else if (Bid < currentsell && closetime != Time[0]) {
         sell = 1;
         closetime = Time[0];
      }
         if (sell == 1 && Bid > currentbuy && closetime2 != Time[0] && closetime == Time[0]) {
            CrossUp[i] = Low[i] - Range*0.5;
            message = "Buy";
            closetime2 = Time[0];
            if (VoiceAlert==true){
               Alert(Symbol(), " Buy");
            }
         } else if (buy == 1 && Bid < currentsell && closetime2 != Time[0] && closetime == Time[0]) {
            CrossDown[i] = High[i] + Range*0.5;
            message = "Sell";
            closetime2 = Time[0];
            if (VoiceAlert==true){
               Alert(Symbol(), " Sell");
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
               "buy : ", buy,
               "\n",
               "sell : ", sell,
               "\n",
               "moveup : ", DoubleToStr(moveup, Digits),
               "\n",
               "movedown : ", DoubleToStr(movedown, Digits),
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