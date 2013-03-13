//+------------------------------------------------------------------+
//|                                                        cuJPY.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <3_signal_inc.mqh>
extern double lotsize = 0.01;
extern double maxlot = 0.10;
extern int max = 7;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
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
      int x;
      int period;
      string symbol;
      infobox = "";
      for (x = 0; x < ARRSIZE; x++) {
         symbol = aPair[x];
         if (x == EURJPY
            || x == CHFJPY
            || x == CADJPY
            || x == GBPJPY
            || x == USDJPY
            || x == AUDJPY
            || x == NZDJPY
            || x == EURUSD
            || x == AUDUSD
            || x == NZDUSD
            || x == GBPAUD
            || x == GBPNZD
            || x == EURAUD
            || x == EURNZD
            || x == AUDCHF
            || x == AUDCAD
            || x == NZDCAD
            || x == NZDCHF) {
            
         } else {
            continue;
         }
         
         infobox = infobox + "\nSymbol: " + symbol;
         infobox = infobox + ", Bid: " +
         MarketInfo(symbol, MODE_BID) + 
         ", Ask: " + MarketInfo(symbol, MODE_ASK) +
         ", Spread: " + DoubleToStr(MarketInfo(symbol, MODE_SPREAD), 0);
         int sl = 0;
         if (x == EURJPY || x == CHFJPY || x == GBPJPY) {
            period = PERIOD_M5;
            sl = 500;
         }else if (x == CADJPY) {
            period = PERIOD_M1;
            sl = 500;
         } else if (x == USDJPY || x == AUDJPY || x == NZDJPY) {
            period = PERIOD_M1;
            sl = 500;
         } else if (x == AUDUSD || x == NZDUSD || x == EURUSD) {
            period = PERIOD_M15;
            sl = 500;
         }  else if (x == GBPAUD || x == GBPNZD) {
            period = PERIOD_M1;
            sl = 500;
         } else if (x == EURAUD || x == EURNZD) {
            period = PERIOD_H1;
            sl = 1000;
         } else if (x == AUDCAD || x == NZDCAD) {
            period = PERIOD_M30;
            sl = 1000;
         } else if (x == AUDCHF || x == NZDCHF) {
            period = PERIOD_H4;
            sl = 2000;
         }
         double gtotal = historyProfit(magic, symbol);
         infobox = infobox + ", period: " + period + ", Profit: " + DoubleToStr(gtotal, 2);
            int cur = maxindicator(symbol, period, 1);
            int cur2 = maxindicator(symbol, period, 2);
            string message = "Max4 ";
               message = message + TimeframeToString(period)
               ;
            if (cur == 1) {
               CheckForCloseWithoutProfit(symbol, x, magic, 1);
            } else if (cur == -1) {
               CheckForCloseWithoutProfit(symbol, x, magic, -1);
            }
            int count = historyProfitCnt(magic, symbol);
            double newlot = lotsize * count;
            if (newlot < lotsize) newlot = lotsize;
            else if (newlot > maxlot) newlot = maxlot;
            if (cur == 1 && cur2 != 1) {
               if (createneworders) createorder(symbol, 1, newlot, magic, message, sl, 0);
            } else if (cur == -1 && cur2 != -1) {
               if (createneworders) createorder(symbol, -1, newlot, magic, message, sl, 0);
            }
      }
      string orderbox = "\n\nManaging Orders:\n";
      
      
      for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()==magic) {
         orderbox = orderbox + "\nSymbol: " + OrderSymbol() + ", Type: " + OrderType() + ", Order Profit: " +
         OrderProfit();
         }
     }
     
     double history = historyall(magic);
     orderbox = orderbox + "\n\nPast Profit: " + history;
      Comment(infobox, orderbox);
//----
   return(0);
  }
//+------------------------------------------------------------------+

