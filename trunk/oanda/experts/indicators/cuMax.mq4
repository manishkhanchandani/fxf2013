//+------------------------------------------------------------------+
//|                                                        cuMax.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

#property indicator_chart_window
#include <strategies.mqh>
int openTime;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
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
  return (0);
   int    counted_bars=IndicatorCounted();
   if (openTime != Time[0]) {
      string box = "";
      double closeprice = 0;
      int type = 0;
      double closebar = 0;
      double fpips = 0;
      double max = -999999999999;
      for (int i = Bars; i >= 1; i--) {
         //double ma = iMA(NULL,0,1000,0,MODE_SMA,PRICE_CLOSE,i);
         //double ma2 = iMA(NULL,0,1000,0,MODE_SMA,PRICE_CLOSE,i+1);
         //double ma5 = iMA(NULL,0,5,0,MODE_SMA,PRICE_CLOSE,i);
         //double ma52 = iMA(NULL,0,5,0,MODE_SMA,PRICE_CLOSE,i+1);
         int skumo = s_kumo(Symbol(), Period(), i);
         if (closebar > 0 && type == -1) {
            fpips = (closeprice - Close[i]) / Point;
            if (fpips > max) {
               max = fpips;
            } 
         } else if (closebar > 0 && type == 1) {
            fpips = (Close[i] - closeprice) / Point;
            if (fpips > max) {
               max = fpips;
            } 
         }
         if (skumo == 1) {
            if (closebar > 0 && type == -1) {
               box = box + "\nType: " + type + ", bar started: " + closebar + ", bar ended: " + i
                  + ", Max Pips Achieved: " + max;
               max = -999999999999;
            }
            closeprice = Close[i];
            type = 1;
            closebar = i;
         } else if (skumo == -1) {
            if (closebar > 0 && type == 1) {
               box = box + "\nType: " + type + ", bar started: " + closebar + ", bar ended: " + i
                  + ", Max Pips Achieved: " + max;
               max = -999999999999;
            }
            closeprice = Close[i];
            type = -1;
            closebar = i;
         }
      }
      Comment(box);
      string name = Symbol() + "/max_"+Period()+".txt";
      FileDelete(name);
      FileAppend( name, box);
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

void FileAppend(string name,string txt)
{
   int handle = FileOpen(name,FILE_READ|FILE_WRITE);
	FileSeek(handle,0,SEEK_END);
	FileWrite(handle,txt);
	FileFlush(handle);
	FileClose(handle);
}