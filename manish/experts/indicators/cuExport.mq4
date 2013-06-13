//+------------------------------------------------------------------+
//|                                                     cuExport.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

#property indicator_chart_window
#include <strategies.mqh>
int opentime;
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
   int    counted_bars=IndicatorCounted();
//----
   if (opentime != Time[0]) {
   
   int check[25];
   FileDelete("reports/"+Symbol()+"_"+Period()+".csv");
   int handle = FileOpen("reports/"+Symbol()+"_"+Period()+".csv",FILE_CSV|FILE_READ|FILE_WRITE,',');
   FileWrite(handle,"Bar,Symbol,Period,Time,Date,Open,High,Low,Close,Volume,Point,Digits,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16,S17,S18,S19,S20,S21,S22,S23,S24,S25");
   for(int i = Bars; i >= 1; i--) {
      if (Open[i] == 0) continue;
      if (TimeYear(Time[0]) < 2010) {
         continue;
      } 
      for (int j = 1; j <= 25; j++) {
         check[j] = get_strategy_result(j, Symbol(), Period(), i, 0);
      }
      FileWrite(handle,i,Symbol(),Period(),Time[i],TimeToStr(Time[i]),Open[i],High[i],Low[i],Close[i],Volume[i],
      Point,Digits,
      check[1],check[2],check[3],check[4],check[5],check[6],check[7],check[8],check[9],check[10],
      check[11],check[12],check[13],check[14],check[15],check[16],check[17],check[18],check[19],check[20],check[21],check[22],
      check[23],check[24],check[25]);
   }
   FileClose(handle);
   opentime = Time[0];
   Comment("done");
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+