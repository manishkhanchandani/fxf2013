//+------------------------------------------------------------------+
//|                                                  cu_allinone.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#include <3_signal_inc.mqh>
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   del();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   del();
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
   del();
   infobox = "";
   double lookup = getoneinfo(Symbol());
   string name;
   int x, y;
   name = "macdlbl";
   create_label(name, 0, 0, 0, 1, 10, 10, "M", White);
   int macd = macdRCurrent(Symbol(), Period());
   name = "macdside";
   x = 10;
   y = 30;
   if (macd == 1)
      create_arrow(name, x, y, 1);
   else if (macd == -1)
      create_arrow(name, x, y, -1);
   else
      create_arrow(name, x, y, 0);
   
   
   name = "heikenlbl";
   create_label(name, 0, 0, 0, 1, 30, 10, "H", White);
   int heiken = heikenCurrent(Symbol(), Period());
   name = "heikenside";
   x = 30;
   y = 30;
   if (heiken == 1)
      create_arrow(name, x, y, 1);
   else if (heiken == -1)
      create_arrow(name, x, y, -1);
   else
      create_arrow(name, x, y, 0);


   name = "tenkenlbl";
   create_label(name, 0, 0, 0, 1, 50, 10, "T", White);
   int tenken = tenkanCurrent(Symbol(), Period());
   name = "tenkenside";
   x = 50;
   y = 30;
   if (tenken == 1)
      create_arrow(name, x, y, 1);
   else if (tenken == -1)
      create_arrow(name, x, y, -1);
   else
      create_arrow(name, x, y, 0);


   name = "macdcntlbl";
   create_label(name, 0, 0, 0, 1, 70, 10, "Count", White);
   int macdcnt = macdCount(Symbol(), Period());
   name = "macdcnt";
   create_label(name, 0, 0, 0, 1, 80, 30, macdcnt, Yellow);
   
   name = "macddifflbl";
   create_label(name, 0, 0, 0, 1, 140, 10, "Diff", White);
   double macddiff = macdDiffernce(Symbol(), Period());
   name = "macddiff";
   create_label(name, 0, 0, 0, 1, 140, 30, macddiff, Yellow);
   
   name = "currentbid";
   create_label(name, 0, 0, 0, 1, 10, 50, "Bid", White);
   name = "currentbidrate";
   create_label(name, 0, 0, 0, 1, 10, 70, DoubleToStr(Bid, Digits), Yellow);
   
   
   name = "currentask";
   create_label(name, 0, 0, 0, 1, 70, 50, "Ask", White);
   name = "currentaskrate";
   create_label(name, 0, 0, 0, 1, 70, 70, DoubleToStr(Ask, Digits), Yellow);
   
   
   name = "currentspread";
   create_label(name, 0, 0, 0, 1, 140, 50, "Spread", White);
   name = "currentspreadrate";
   create_label(name, 0, 0, 0, 1, 140, 70, DoubleToStr(MarketInfo(Symbol(), MODE_SPREAD), 0), Yellow);
   
   
   name = "rsilbl";
   create_label(name, 0, 0, 0, 1, 10, 90, "RSI", White);
   name = "rsirate";
   double rsi = iRSI(NULL, 0,14,PRICE_CLOSE,0);
   create_label(name, 0, 0, 0, 1, 10, 110, DoubleToStr(rsi, 0), Yellow);
   
   name = "stochlbl";
   create_label(name, 0, 0, 0, 1, 10, 130, "Stochastic", White);
   name = "stochrate";
   double stoch = iStochastic(NULL, 0,14,3,3,MODE_SMA,0,MODE_MAIN,0);
   create_label(name, 0, 0, 0, 1, 10, 150, DoubleToStr(stoch, 0), Yellow);
   
   name = "ccilbl";
   create_label(name, 0, 0, 0, 1, 10, 170, "CCI", White);
   name = "ccirate";
   double cci = iCCI(NULL, 0,14,PRICE_TYPICAL,0);
   create_label(name, 0, 0, 0, 1, 10, 190, DoubleToStr(cci, 0), Yellow);
  
   
   
   name = "pointslbl";
   create_label(name, 0, 0, 0, 1, 10, 210, "Points", White);
   name = "pointsrate";
   create_label(name, 0, 0, 0, 1, 10, 230, DoubleToStr(lookup, 1), Yellow);
   
   name = "entrylbl";
   create_label(name, 0, 0, 0, 1, 60, 210, "Enter", White);
   
   name = "entry";
   int macdchange = macdR(Symbol(), Period());
   double MacdCur =iMACD(Symbol(), Period(),12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   if (MacdCur > 0 && macdchange == 1)
      create_label(name, 0, 0, 0, 1, 60, 230, "Buy", Blue);
   else if (MacdCur < 0 && macdchange == -1)
      create_label(name, 0, 0, 0, 1, 60, 230, "Sell", Red);
   else 
      create_label(name, 0, 0, 0, 1, 60, 230, "Wait", Yellow);
      
      
   name = "exitlbl";
   create_label(name, 0, 0, 0, 1, 110, 210, "Exit", White);
   
   name = "exit";
   if (macd == -1 && tenken == -1 && heiken == -1)
      create_label(name, 0, 0, 0, 1, 110, 230, "Buy", Blue);
   else if (macd == 1 && tenken == 1 && heiken == 1)
      create_label(name, 0, 0, 0, 1, 110, 230, "Sell", Red);
   else 
      create_label(name, 0, 0, 0, 1, 110, 230, "Wait", Yellow);

   //history
   double history = history(Symbol(), 0, 123400);
   
   name = "historylbl";
   create_label(name, 0, 0, 0, 1, 10, 250, "History", White);
   name = "history";
   create_label(name, 0, 0, 0, 1, 10, 270, DoubleToStr(history, 2), Yellow);
   
   Comment(infobox);

//----
   return(0);
  }
//+------------------------------------------------------------------+

int del()
{
   string name;
   name = "macdlbl";
   ObjectDelete(name);
   name = "macdside";
   ObjectDelete(name);
   
   name = "heikenlbl";
   ObjectDelete(name);
   name = "heikenside";
   ObjectDelete(name);


   name = "tenkenlbl";
   ObjectDelete(name);
   name = "tenkenside";
   ObjectDelete(name);

   name = "macdcntlbl";
   ObjectDelete(name);
   name = "macdcnt";
   ObjectDelete(name);
   
   name = "macddifflbl";
   ObjectDelete(name);
   name = "macddiff";
   ObjectDelete(name);
   
   name = "currentbid";
   ObjectDelete(name);
   name = "currentbidrate";
   ObjectDelete(name);
   
   name = "currentask";
   ObjectDelete(name);
   name = "currentaskrate";
   ObjectDelete(name);
   name = "currentspread";
   ObjectDelete(name);
   name = "currentspreadrate";
   ObjectDelete(name);
   name = "suggestion";
   ObjectDelete(name);
   
   
   name = "rsilbl";
   ObjectDelete(name);
   name = "rsirate";
   ObjectDelete(name);
   name = "stochlbl";
   ObjectDelete(name);
   name = "stochrate";
   ObjectDelete(name);
   name = "ccilbl";
   ObjectDelete(name);
   name = "ccirate";
   ObjectDelete(name);
   name = "pointslbl";
   ObjectDelete(name);
   name = "pointsrate";
   ObjectDelete(name);
   
   name = "entrylbl";
   ObjectDelete(name);
   name = "entry";
   ObjectDelete(name);
   
   name = "exitlbl";
   ObjectDelete(name);
   name = "exit";
   ObjectDelete(name);
   name = "historylbl";
   ObjectDelete(name);
   name = "history";
   ObjectDelete(name);
}