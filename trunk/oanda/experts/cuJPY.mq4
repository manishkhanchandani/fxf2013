//+------------------------------------------------------------------+
//|                                                        cuJPY.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <3_signal_inc.mqh>
extern double lotsize = 0.05;

int stateCur[28][5];

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
      int period = Period();
      string symbol;
      bool buyorder;
      bool sellorder;
      bool condition_buy, condition_sell;
      bool ich_buy, ich_sell;
      infobox = "";
      int sl = 250;
      for (x = 0; x < ARRSIZE; x++) {
         symbol = aPair[x];
         if (x == EURJPY || x == CHFJPY
         // || x == GBPJPY || x == CADJPY 
         //|| x == AUDJPY  || x == NZDJPY
         ) {
         
         } else {
            continue;
         }
         infobox = infobox + "\n\nSymbol: " + symbol;
         buyorder = false;
         sellorder = false;
         condition_buy = false;
         condition_sell = false;
         if (x == EURJPY) {
            sl = 1000;
            sellorder = true;
            period = PERIOD_H1;
            //render_avg_costing(symbol, x, lotsize, false, false);
         } else if (x == CHFJPY) {
            sl = 1000;
            period = PERIOD_H1;
            buyorder = true;
            //render_avg_costing(symbol, x, lotsize, false, false);
         } else if (x == CADJPY) {
            sl = 1000;
            period = PERIOD_H1;
            sellorder = true;
            //render_avg_costing(symbol, x, lotsize, false, false);
         } else if (x == GBPJPY) {
            sl = 1000;
            period = PERIOD_H1;
            buyorder = true;
            //render_avg_costing(symbol, x, lotsize, false, false);
         } else if (x == AUDJPY) {
            sl = 1000;
            period = PERIOD_H1;
            sellorder = true;
            //render_avg_costing(symbol, x, lotsize, false, false);
         } else if (x == NZDJPY) {
            sl = 1000;
            period = PERIOD_H1;
            buyorder = true;
            //render_avg_costing(symbol, x, lotsize, false, false);
         }
         infobox = infobox + ", Period: " + period + ", sl: " + sl + ", Bid: " +
         MarketInfo(symbol, MODE_BID) + 
         ", Ask: " + MarketInfo(symbol, MODE_ASK) +
         ", Spread: " + MarketInfo(symbol, MODE_SPREAD) + ", B: " + buyorder + ", S: " + sellorder;
         int heiken = heikenshift(symbol, period, 1);
         int heikenCurrent = heikenCurrentshift(symbol, period, 1);
         int heikenCurrent1 = heikenCurrentshift(symbol, PERIOD_M1, 0);
         int heikenCurrent5 = heikenCurrentshift(symbol, PERIOD_M5, 0);
         int macd = macdRshift(symbol, period, 1);
         int macdCurrent = macdRCurrentshift(symbol, period, 1);
         //int semaphore = semaphoreShift(symbol, period, 0);
         double tenkan_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_TENKANSEN, 0);
         double kijun_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, 0);
         ich_buy = (tenkan_sen_1 >= kijun_sen_1 && tenkan_sen_1 < MarketInfo(symbol, MODE_BID));
         ich_sell = (tenkan_sen_1 <= kijun_sen_1 && tenkan_sen_1 > MarketInfo(symbol, MODE_BID));
         if (heiken == 1 || heiken == -1) {
            stateCur[x][0] = heiken;
         }
         if (macdCurrent == 1 || macdCurrent == -1) {
            stateCur[x][1] = macdCurrent;
         }
         if (ich_buy) {
            stateCur[x][2] = 1;
         } else if (ich_sell) {
            stateCur[x][2] = -1;
         } else {
            stateCur[x][2] = 0;
         }
         //calculate Heiken, MACD, ADX
         condition_buy = (heikenCurrent1 == 1 && heikenCurrent5 == 1 &&
                        macdCurrent == 1 && heikenCurrent == 1 &&
                        stateCur[x][0] == 1 && stateCur[x][1] == 1
                        && heiken == 1
                        );
         condition_sell = (heikenCurrent1 == -1 && heikenCurrent5 == -1 &&
                        macdCurrent == -1 && heikenCurrent == -1 &&
                        stateCur[x][0] == -1 && stateCur[x][1] == -1
                        && heiken == -1
                        );
         
         string message = "EA ";
         if (heiken == 1 && macdCurrent == 1) message = message + "H " + TimeframeToString(period);
         else if (macd == 1 && heikenCurrent == 1) message = message + "M " + TimeframeToString(period);
         else if (heiken == -1 && macdCurrent == -1) message = message + "H " + TimeframeToString(period);
         else if (macd == -1 && heikenCurrent == -1) message = message + "M " + TimeframeToString(period);
         
         infobox = infobox + "\nheiken: " + heiken + ", heikenCurrent: " + heikenCurrent +
               ", macd: " + macd + ", macdCurrent: " + macdCurrent + ", condition_buy: " + condition_buy +
               ", condition_sell: " + condition_sell + ", heikenCurrent1: " + heikenCurrent1 +
               ", heikenCurrent5: " + heikenCurrent5 + ", stateCur[x][0]: " + stateCur[x][0] + 
               ", stateCur[x][1]: " + stateCur[x][1]+ 
               ", stateCur[x][2]: " + stateCur[x][2] +
               "\ntenkan: " + tenkan_sen_1 +
               ", kijun_sen: " + kijun_sen_1 +
               ", tenkan signal Sell: " + (tenkan_sen_1 <= kijun_sen_1 && tenkan_sen_1 > MarketInfo(symbol, MODE_BID))+
               ", tenkan signal Buy: " + (tenkan_sen_1 >= kijun_sen_1 && tenkan_sen_1 < MarketInfo(symbol, MODE_BID));
               
               //+ "\nsemaphore: " + semaphore + ", semaphoreNumber: " +
               //semaphoreNumber;
         if (ich_buy && macdCurrent == 1) {
            CheckForClose(symbol, x, magic, 1);
         } else if (ich_sell && macdCurrent == -1) {
            CheckForClose(symbol, x, magic, -1);
         }
         if (condition_buy) {
            //CheckForCloseALL(symbol, x, 1);
            CheckForClose(symbol, x, magic, 1);
            if (buyorder) {
               if (createneworders) createorder(aPair[x], 1, lotsize, magic, message, sl, 0);
            }
         } else if (condition_sell) {
            //CheckForCloseALL(symbol, x, -1);
            CheckForClose(symbol, x, magic, -1);
            if (sellorder) {
               if (createneworders) createorder(aPair[x], -1, lotsize, magic, message, sl, 0);
            }
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
      Comment(infobox, orderbox);
//----
   return(0);
  }
//+------------------------------------------------------------------+