//+------------------------------------------------------------------+
//|                                     ForexMasterMillionDollar.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

#include <strategies.mqh>
int openTime;
string box;
string infobox;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   start();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   Comment("old one, not used");
   return (0);
   findStrategy(Symbol());
//----
   return(0);
  }
//+------------------------------------------------------------------+

int findStrategy(string symbol)
{
   int currentPeriod = Period();
   int period;
   int strategy;
   double val;
   int max = -999999;
   int sm[5];
   int s[0];
   int st[30];
   int count[30];
   int best;
   int i;
   //if (openTime != iTime(symbol, currentPeriod, 0)) {
   
   //} else {
      box = box + "\nCalculating the Strategy";
      period = Period();
      
      for (int k = 20; k <= 100; k = k + 20) {
       max = -999999;
       best = 0;
      for (strategy = 1; strategy <= 26; strategy++) {
         if (strategy == 24 || strategy == 25 || strategy == 4) continue;
         val = iCustom(symbol, period, "cuSpanTimeClose", strategy, k, k-20, 4, 0);
         box = box + "\nStrategy " + strategy + " (" + get_strategy_name(strategy) 
               + "), val: " + val + " for time period: " + TimeframeToString(period)
               + ", Start: " + k + ", End: " + (k-20)
               ;
         if (val > 0 && val != EMPTY_VALUE) {
            count[strategy] = count[strategy] + 1;
         }
         if (val > max && val != EMPTY_VALUE) {
            max = val;
            best = strategy;
         }
      }
      box = box + "\n";
      if (best > 0) {
         st[best] = st[best] + 1;
         box = box + "\nBest Strategy " + best + " (" + get_strategy_name(best) 
               + "), Period " + k + ": " + TimeframeToString(period) + ", Value: " + max + ", Strength: " + st[best];
      }
      
      }
      
      
      
      box = box + "\n\n\n";
      for (i = 1; i <= 26; i++) {
         //if (st[i] == 0) continue;
         box = box + "\nFinal Strategy " + i + " (" + get_strategy_name(i) 
               + "), Strength: " + st[i] + " / count: " + count[i];
      }
      Comment(box);
      string name = symbol + "/mb_" + period + ".txt";
      FileDelete(name);
      FileAppend(name,box);
   //}
}



string TimeframeToString(int P)
{
   switch(P)
   {
      case PERIOD_M1:  return("M1");
      case PERIOD_M5:  return("M5");
      case PERIOD_M15: return("M15");
      case PERIOD_M30: return("M30");
      case PERIOD_H1:  return("H1");
      case PERIOD_H4:  return("H4");
      case PERIOD_D1:  return("D1");
      case PERIOD_W1:  return("W1");
      case PERIOD_MN1: return("MN1");
      case 0: return ("Any");
   }
}



void FileAppend(string name,string txt)
{
   int handle = FileOpen(name,FILE_READ|FILE_WRITE);
	FileSeek(handle,0,SEEK_END);
	FileWrite(handle,txt);
	FileFlush(handle);
	FileClose(handle);
}