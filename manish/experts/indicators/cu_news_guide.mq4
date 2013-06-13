//+------------------------------------------------------------------+
//|                                                cu_news_guide.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#include <cu_news_inc.mqh>

string current_currency1;
string current_currency2;
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_width1 2
#property indicator_color2 Orange
#property indicator_width2 2
double CrossUp[];
double CrossDown[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   current_currency1 = StringSubstr(Symbol(), 0, 3);
   current_currency2 = StringSubstr(Symbol(), 3, 3);
   initialize();
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
    ObjectsDeleteAll();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   for(int i = limit; i >= 0; i--) {
      strategy(i);
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

int strategy(int i)
{
   string name;
   double price;
   int hour = TimeHour(Time[i]);
   int minute = TimeMinute(Time[i]);
   int day = TimeDay(Time[i]);
   int year = TimeYear(Time[i]);
   int month = TimeMonth(Time[i]);
   int counter;
   double Range, AvgRange;
   counter=i;
   Range=0;
   AvgRange=0;
   for (counter=i ;counter<=i+9;counter++)
   {
      AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
   }
   Range=AvgRange/10;
   for (int x = 0; x < currency_limit; x++) {
      if (year == currency_int[x][0] && month == currency_int[x][1] && day == currency_int[x][2] && hour == currency_int[x][3] && minute == currency_int[x][4]) {
         if (current_currency1 == currency_str[x][0] || current_currency2 == currency_str[x][0]) {
            name = currency_str[x][0] + "_" + i;
            price = Close[i];
            putstar(i, name, price);
            if (
               (currency_int[x][5] == 1 && current_currency1 == currency_str[x][0])
               ||
               (currency_int[x][5] == -1 && current_currency2 == currency_str[x][0])
            ) { // buy
               CrossUp[i] = Low[i] - Range*0.5;
            } else if (
               (currency_int[x][5] == -1 && current_currency1 == currency_str[x][0])
               ||
               (currency_int[x][5] == 1 && current_currency2 == currency_str[x][0])
              ) { // sell
               CrossDown[i] = High[i] + Range*0.5;
            }
         }
      }
   }
}