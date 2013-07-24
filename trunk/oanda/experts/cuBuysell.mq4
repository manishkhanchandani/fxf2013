//+------------------------------------------------------------------+
//|                                                        cuJPY.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <3_signal_inc.mqh>
extern double lotsize = 0.01;
extern double maxlot = 0.05;
extern double magicHL = 115;
extern double factor = 0.01;
extern int max = 28;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   magic = magicHL;
 
 trailingstop = 150;
 mintrailingstop = 500;
 mintrailingstopavgcosting = 500;
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
      int period=PERIOD_H1;
      string symbol;
      infobox = "Max = " + max;
      for (x = 0; x < ARRSIZE; x++) {
         symbol = aPair[x];
         
         infobox = infobox + "\nSymbol: " + symbol;
         infobox = infobox + ", Bid: " +
         MarketInfo(symbol, MODE_BID) + 
         ", Ask: " + MarketInfo(symbol, MODE_ASK) +
         ", Spread: " + DoubleToStr(MarketInfo(symbol, MODE_SPREAD), 0);
         int check = buysellstrategy(symbol, PERIOD_H1, 1);
         
         int stopLoss = 500;

         double gtotal = historyProfit(magic, symbol);
         infobox = infobox + ", period: " + period + ", Profit: " + DoubleToStr(gtotal, 2) + ", check: " + check;
          
            string message = "BuySell ";
               message = message + TimeframeToString(period)
               ;
            int count = historyProfitCnt(magic, symbol);
            double newlot = (lotsize * count) + factor;
            if (newlot < lotsize) newlot = lotsize;
            else if (newlot > maxlot) newlot = maxlot;
            if (check == 1) {
               CheckForCloseWithoutProfit(symbol, x, magic, 1);
            } else if (check == -1) {
               CheckForCloseWithoutProfit(symbol, x, magic, -1);
            }
            int orders = CalculateMaxOrders(magic);
            infobox = infobox + ", Orders: " + orders;
            if (orders >= max) {
            
            } else {
               if (check == 1) {
                  if (createneworders) createorder(symbol, 1, newlot, magic, message, stopLoss, 0);
               } else if (check == -1) {
                  if (createneworders) createorder(symbol, -1, newlot, magic, message, stopLoss, 0);
               }
            }
            
         render_avg_costing(symbol, x, lotsize, true, false);
      }
      string orderbox = "\n\nManaging Orders:";
      gtotal = 0;
      for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()==magic) {
         orderbox = orderbox + "\nSymbol: " + OrderSymbol() + ", Type: " + OrderType() + ", Order Profit: " +
         OrderProfit();
         gtotal = gtotal + OrderProfit();
         }
     }
     historybox = "";
     historybox =  historybox + "\nCurrent Profit: " + gtotal;
     double history = historyall(magic);
     historybox = historybox + "\nPast Profit: " + history;
      Comment(infobox, historybox, orderbox);
//----
   return(0);
  }
//+------------------------------------------------------------------+

 