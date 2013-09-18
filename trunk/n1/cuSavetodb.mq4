//+------------------------------------------------------------------+
//|                                                   cuSavetodb.mq4 |
//|                                              Manish Khanchandani |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://forexmastery.org"

#include <3_signal_inc.mqh>
#include <strategies.mqh>
extern int factor = 0;
extern int diff = 6;
extern string suffix = "";
extern bool currentSymbol = false;
int timeCur = 0;
int timeCur1 = 0;
int start;
int end;

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
   string symbol = "";
   string query = "";
   string file = "";
   int val;
   if (opentime != Time[0]) {
      infobox = "";
      opentime = Time[0];
      end = (end + diff) * factor;
      start = end + diff - 1;
      timeCur1 = iTime(Symbol(), PERIOD_D1, start);
      timeCur = iTime(Symbol(), PERIOD_D1, end);
      infobox = infobox + StringConcatenate(start, ", ", end, ", ", TimeToStr(timeCur1), ", ", TimeToStr(timeCur));
      //return (0);
      if (currentSymbol) {
         query = query + data(Symbol());
         file = "savetodb/"+Symbol()+"_"+TimeYear(timeCur)+"-"+TimeMonth(timeCur)+"-"+TimeDay(timeCur)+".txt";
         FileDelete(file);
         FileAppend(file, query);
      } else {
         for (int x = 0; x < ARRSIZE; x++) {
            symbol = aPair[x]+suffix;
            infobox = infobox + "\nSymbol: " + symbol;
            query = query + data(symbol);
            /*int periods[6] = {PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4};
            int period;
            int p;
            for(p = 0; p < 6; p++) {
               period = periods[p];
               for (int j = 1; j <= 42; j++) {
                  if (j == 31) continue;
                  val = iCustom(symbol, period, "cuSpanTimeClose", j, 5, 0, 4, 0); 
                  if (val == EMPTY_VALUE) val = 0;
                  query = query + "\nINSERT INTO forex_study_child set strategy = '"+j+"'";
                  query = query + ", points = '"+val+"'";
                  query = query + ", period = '"+period+"'";
                  query = query + ", symbol = '"+symbol+"'";
                  query = query + ", bdate = '"+TimeYear(TimeCurrent())+"-"+TimeMonth(TimeCurrent())+"-"+TimeDay(TimeCurrent())+"';";
               }
            }*/
         }
      
         query = query + data("XAUJPY"+suffix);
         query = query + data("XAGJPY"+suffix);
         query = query + data("XAUUSD"+suffix);
         query = query + data("XAGUSD"+suffix);
         file = "savetodb/"+TimeYear(timeCur)+"-"+TimeMonth(timeCur)+"-"+TimeDay(timeCur)+".txt";
         FileDelete(file);
         FileAppend(file, query);
      }
      Comment(infobox);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+

string data(string symbol)
{
   string subquery = "";
         int periods[6] = {PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4};
         int period;
         int p;
         for(p = 0; p < 6; p++) {
            period = periods[p];
            for (int j = 1; j <= 42; j++) {
               if (j == 31) continue;
               int val = iCustom(symbol, period, "cuSpanTimeClose", j, start, end, 4, 0); 
               if (val == EMPTY_VALUE) val = 0;
               subquery = subquery + "\nINSERT INTO forex_study_child set strategy = '"+j+"'";
               subquery = subquery + ", points = '"+val+"'";
               subquery = subquery + ", period = '"+period+"'";
               subquery = subquery + ", symbol = '"+symbol+"'";
               subquery = subquery + ", bdate = '"+TimeYear(timeCur)+"-"+TimeMonth(timeCur)+"-"+TimeDay(timeCur)+"';";
            }
         }
   return (subquery);
}