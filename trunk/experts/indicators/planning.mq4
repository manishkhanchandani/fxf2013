//+------------------------------------------------------------------+
//|                                                     planning.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#include <3_signal_inc.mqh>
#property indicator_buffers 2
#property indicator_color1 SeaGreen
#property indicator_color2 Red

double CrossUp[];
double CrossDown[];
extern int FasterEMA = 4;
extern int SlowerEMA = 8;
extern bool SoundON=true;
double alertTag;
 double control=2147483647;
 int openTime;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_ARROW, EMPTY,3);
   SetIndexArrow(0, 233);
   SetIndexBuffer(0, CrossUp);
   SetIndexStyle(1, DRAW_ARROW, EMPTY,3);
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
int start() {
   if (openTime != Time[i]) {
   int limit, i, counter;
   double Range, AvgRange;
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;

   limit=Bars-counted_bars;
   datetime some_time=D'2013.01.07 12:00';
  int      shift=iBarShift(Symbol(),Period(),some_time);
  Print("shift of bar with open time ",TimeToStr(some_time)," is ",shift);
  
   double grandtotal;
   string showbox = "";
   for(i = shift; i >= 1; i--) {
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      
      if (i == shift) {
         ObjectDelete("start");
         ObjectCreate("start", OBJ_TEXT, 0, Time[i], Low[i] - Range*0.5);
         ObjectSetText("start", "Start Here", 10, "Times New Roman", Blue);
      }
      int type, prev_type;
      double score;
      //closure
      if (type != 0) {
         int close = conditionClose(i);
         double result;
         bool resultfind = false;
         if (close == 1 && type == -1) {
            //close sell
            result = score - Open[i];
            resultfind = true;
         } else if (close == -1 && type == 1) {
            //close buy
            result = Open[i] - score;
            resultfind = true;
         }
         if (resultfind) {
            grandtotal = grandtotal + ((result/Point) - (2 * MarketInfo(Symbol(), MODE_SPREAD)));
            showbox = showbox + StringConcatenate("\nScore: ", score, ", open: ", Open[i], ", result: ", result, ", i: ", i, ", type: ", type,
            ", gtotal Points: ", grandtotal
            );
         }
      }
      
      //open
      
      int open = conditionOpen(i);
      if (open == 1) {
         CrossUp[i] = Low[i] - Range*0.5;
         type = 1;
         score = Open[i];
      } else if (open == -1) {
         CrossDown[i] = High[i] + Range*0.5;
         type = -1;
         score = Open[i];
      }
  }
  Comment("Total: ", grandtotal, ", Rate: ", (grandtotal * 0.1), showbox);
  openTime = Time[i];
  }
   return(0);
}


int conditionClose(int i)
{

         double macd3 = iMACD(Symbol(),Period(),12,26,9,PRICE_CLOSE,MODE_MAIN,i);
         double macd4 = iMACD(Symbol(),Period(),12,26,9,PRICE_CLOSE,MODE_MAIN,i+1);
         if (macd3 > 0 && macd4 < 0) {
            return (1);
          } else if (macd3 < 0 && macd4 > 0) {
            return (-1);
          }
      return (0);
}

int conditionOpen(int i)
{
   double macd = iMACD(Symbol(),Period(),12,26,9,PRICE_CLOSE,MODE_MAIN,i);
      double macd2 = iMACD(Symbol(),Period(),12,26,9,PRICE_CLOSE,MODE_MAIN,i+1);
      if (macd > 0 && macd2 < 0) {
         return (1);
      } else if (macd < 0 && macd2 > 0) {
         return (-1);
      }
      return (0);
}