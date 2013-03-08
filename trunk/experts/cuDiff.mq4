//+------------------------------------------------------------------+
//|                                                       cuDiff.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <3_signal_inc.mqh>
extern double lotsize = 0.01;
extern int max = 5;
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
      int period = PERIOD_M5;
      string symbol;
      infobox = "";
      for (x = 0; x < ARRSIZE; x++) {
         symbol = aPair[x];
         if (x == AUDUSD || x == NZDUSD || x == EURUSD || x == GBPUSD) {
            
         } else {
            continue;
         }
         bool sellorder = false;
         bool buyorder = false;
         if (x == AUDUSD) sellorder = true;
         if (x == NZDUSD) buyorder = true;
         if (x == GBPUSD) sellorder = true;
         if (x == EURUSD) buyorder = true;
         double sl = 300;
         double tp = 1000;
         infobox = infobox + "\nSymbol: " + symbol;
         infobox = infobox + ", Bid: " +
         MarketInfo(symbol, MODE_BID) + 
         ", Ask: " + MarketInfo(symbol, MODE_ASK) +
         ", Spread: " + MarketInfo(symbol, MODE_SPREAD);
         int condition = 0;
         double bid = MarketInfo(symbol, MODE_BID);
         double close = iClose(symbol, period, 1);
         double tenkan_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_TENKANSEN, 1);
         double kijun_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, 1);
         double tenkan_sen_2=iIchimoku(symbol, period, 9, 26, 52, MODE_TENKANSEN, 2);
         double kijun_sen_2=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, 2);
         int macd = macdRCurrent(symbol, period);
         //check for close
         if (tenkan_sen_1 < kijun_sen_1 && tenkan_sen_1 > close && macd == -1) {
            CheckForClose(symbol, x, magic, -1);
         } else if (tenkan_sen_1 > kijun_sen_1 && tenkan_sen_1 < close  && macd == 1) {
            CheckForClose(symbol, x, magic, 1);
         }
         if (tenkan_sen_1 <= kijun_sen_1 && tenkan_sen_1 > close && tenkan_sen_2 > kijun_sen_2 ) {
            condition = -1;
         } else if (tenkan_sen_1 >= kijun_sen_1 && tenkan_sen_1 < close && tenkan_sen_2 < kijun_sen_2) {
            condition = 1;
         }
         infobox = infobox + ", Condition: " +
         condition + 
         ", macd: " + macd + ", buyorder: " + buyorder + ", sellorder: " + sellorder + ", period: " + TimeframeToString(period)
         + ", S:" + (tenkan_sen_1 <= kijun_sen_1) + "," + (tenkan_sen_1 > close) + "," + (tenkan_sen_2 > kijun_sen_2)
         + ", B:" + (tenkan_sen_1 >= kijun_sen_1) + "," + (tenkan_sen_1 < close) + "," + (tenkan_sen_2 < kijun_sen_2)
         ;
         string message = "ICM2 ";
         message = message + TimeframeToString(period) + ", " + condition + ", " + macd;
         //check for Open
         if (condition == 1 && buyorder && macd == 1 && createneworders) {
            createorder(symbol, 1, lotsize, magic, message, sl, tp);
         } else if (condition == -1 && sellorder && macd == -1 && createneworders) {
            createorder(symbol, -1, lotsize, magic, message, sl, tp);
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