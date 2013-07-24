//+------------------------------------------------------------------+
//|                                                       EAmacd.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <3_signal_inc.mqh>
#include <i_indicators.mqh>
int opentime1;
int conditionClose(int i, int action)
{
   //render_avg_costing(Symbol(), 0, 0.01, true, true);
   return(0);
}


int conditionOpen(int i, int action)
{
   int res = 0;
   switch(action) {
      case 1:
         //macd only
         res = strategy_1(Symbol(), Period());
         break;
      case 2:
         //pinbar + stoch only
         res = strategy_2(Symbol(), Period());
         break;
      case 3:
         //pinbar
         res = strategy_3(Symbol(), Period());
         break;
   }
   return (res);
   /*
   //indicators: ema3, ema8, macd, stoch, para, sd, rsi
   double ema3 = iMA(NULL,0,3,0,MODE_EMA,PRICE_CLOSE,i);
   double ema8 = iMA(NULL,0,8,0,MODE_EMA,PRICE_CLOSE,i);
   double ema3_2 = iMA(NULL,0,3,0,MODE_EMA,PRICE_CLOSE,i+1);
   double ema8_2 = iMA(NULL,0,8,0,MODE_EMA,PRICE_CLOSE,i+1);
   double macd = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,i);
   double macd2 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,i+1);
   double macdsignal = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,i);
   double stoch = iStochastic(NULL,0,10,15,15,MODE_EMA,1,MODE_MAIN,i);
   double stochsignal = iStochastic(NULL,0,10,15,15,MODE_EMA,1,MODE_SIGNAL,i);
   double sd = iStdDev(NULL,0,20,0,MODE_SMA,PRICE_CLOSE,i);
   int signal = -1;
   if (Digits == 3) {
      if (sd < 0.10) signal = 0;
      else if (sd >= 0.10 && sd < 0.20) signal = 1;
      else if (sd > 0.20) signal = 2;
   } else if (Digits == 5) {
      if (sd < 0.0005) signal = 0;
      else if (sd >= 0.0005 && sd < 0.0010) signal = 1;
      else if (sd > 0.0010) signal = 2;
   }
   double rsi = iRSI(NULL,0,9,PRICE_CLOSE,i);
   double sar = iSAR(NULL,0,0.02,0.2,i);
   int condition = 0;
   if (ema3 > ema8 && ema3_2 < ema8_2) change = 1;
   else if (ema3 < ema8 && ema3_2 > ema8_2) change = -1;
   Comment("ema3: ", ema3, ", ema8: ", ema8, ", ema3_2: ", ema3_2,
      ", ema8_2: ", ema8_2, ", macd: ", macd, ", macdsignal: ", macdsignal,
      ", stoch: ", stoch, ", stochsignal: ", stochsignal, ", sd: ", sd, ", rsi: ", rsi, ", sar: ", sar, "\nsignal: ",
      signal, ", condition: ", condition, ", change: ", change);

   if (ema3 > ema8 && sar < Low[i] && stoch < 35 && macd > macd2 &&
      signal >= 1 && change == 1) {
      return (1);
   } else if (ema3 < ema8 && sar > High[i] && stoch > 65 && macd > macd2 && 
      signal >= 1 && change == -1) {
      return (-1);
   }
   return (0);
   */
/*
   double s1 = iStochastic(NULL,0,14,3,3,MODE_SMA,0,MODE_MAIN,i);
   double s2 = iStochastic(NULL,0,14,3,3,MODE_SMA,0,MODE_SIGNAL,i);
   Comment(s1, " = ", s2);
   if (s1 < s2 && s1 > 60) {
      return (-1);
   } else if (s1 > s2 && s1 < 40) {
      return (1);
   }
   return (0);
   double high = High[i];
   double low = Low[i];
   double high2 = High[i+1];
   double low2 = Low[i+1];
   double ma = iMA(NULL,0,13,8,MODE_SMA,PRICE_CLOSE,i);
   if (high < high2 && low > low2 && Bid < ma && Bid > High[i]) {
      return (1);
   } else if (high < high2 && low > low2 && Bid > ma && Bid < Low[i]) {
      return (-1);
   }
   return (0);*/
/*
   double macd = iMACD(Symbol(),Period(),12,26,9,PRICE_CLOSE,MODE_MAIN,i);
      double macd2 = iMACD(Symbol(),Period(),12,26,9,PRICE_CLOSE,MODE_MAIN,i+1);
      if (macd > 0 && macd2 < 0) {
         return (1);
      } else if (macd < 0 && macd2 > 0) {
         return (-1);
      }
      return (0);*/
}
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
   if (opentime1 != iTime(Symbol(), Period(), 0)) {
   string symbol = Symbol();
   infobox = "";
   infobox = infobox + "\nSymbol: " + symbol;
         infobox = infobox + ", Bid: " +
         MarketInfo(symbol, MODE_BID) + 
         ", Ask: " + MarketInfo(symbol, MODE_ASK) +
         ", Spread: " + MarketInfo(symbol, MODE_SPREAD);
            int i = 1;
            int x = 0;
            int action = 3;
            int close = conditionClose(i, action);
            if (close == 1) {
              CloseAllWithProfit(symbol, 1);
            } else if (close == -1) {
              CloseAllWithProfit(symbol, -1);
            }
            // check for open
            bool buy, sell;
            buy = true;
            sell = true;
            int open = conditionOpen(i, action);
            if (open == 1 && buy) {
               if (createneworders) createorder(symbol, 1, 0.01, magic, "EA", 1000, 100);
            } else if (open == -1 && sell) {
               if (createneworders) createorder(symbol, -1, 0.01, magic, "EA", 1000, 100);
            }
           double gtotal = openPositionTotal(symbol);
           infobox = StringConcatenate(infobox, "\nProfit for Open Position For Symbol: " + symbol +
   " is: " + DoubleToStr(gtotal, 2)); 
           Comment(infobox);
           opentime1 = iTime(Symbol(), Period(), 0);
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+

//only macd crossing
int strategy_1(string symbol, int period)
{
   int fast_ema_period, slow_ema_period, signal_period;
   fast_ema_period = 12;
   slow_ema_period = 26;
   signal_period = 9;
   int res = strategyMacdCrossing(symbol, period, 
         fast_ema_period, slow_ema_period, signal_period, 
         PRICE_CLOSE, i);
   
   infobox = infobox + ", " + Symbol() + ", " + Period() + ", " + fast_ema_period + ", " + slow_ema_period
    + ", " + signal_period + ", " + res;
   return (res);
}
/*
1 week result
results, initial amount: 10,000
eurjpy 1m: 9931.93
5m: 9935
15M: 9934
30M: 9984
1H: 10002
*/

//pinbar + stoch
int strategy_2(string symbol, int period)
{
   int res = 0;
   int entrybar =  i_entry_bar(symbol, period, i);
   int stoch = i_stoch_level(symbol, period, i, 14, 3, 3, MODE_SMA, 0, 80, 20);
   if (entrybar == 1 && stoch == 1) {
      res = 1;
   } else if (entrybar == -1 && stoch == -1) {
      res = -1;
   }
   infobox = infobox + ", " + Symbol() + ", " + Period() + ", " + res;
   return (res);
}
/*
1 week result
results, initial amount: 10,000
eurjpy 1m: 
5m: 
15M: 
30M: 
1H: 
*/


//pinbar
int strategy_3(string symbol, int period)
{
   int res = 0;
   int entrybar =  i_entry_bar(symbol, period, i);
   if (entrybar == 1) {
      res = 1;
   } else if (entrybar == -1) {
      res = -1;
   }
   infobox = infobox + ", " + Symbol() + ", " + Period() + ", " + res;
   return (res);
}


/*
1 week result
results, initial amount: 10,000
eurjpy 1m: 
5m: 
15M: 
30M: 
1H: 
*/

