//+------------------------------------------------------------------+
//|                                                        cuJPY.mq4 |
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
      int period = PERIOD_M1;
      string symbol;
      infobox = "";
      for (x = 0; x < ARRSIZE; x++) {
         symbol = aPair[x];
         if (x == EURCHF || x == EURJPY) {
            continue;
         }
         
         infobox = infobox + "\nSymbol: " + symbol;
         infobox = infobox + ", Bid: " +
         MarketInfo(symbol, MODE_BID) + 
         ", Ask: " + MarketInfo(symbol, MODE_ASK) +
         ", Spread: " + MarketInfo(symbol, MODE_SPREAD);
         if (x == CHFJPY || x == EURUSD
            ) {
            strategy2(symbol, x);
         } else {
            strategy1(symbol, x);
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

int strategy1(string symbol, int x)
{
         //check the trend
         int bbtrend = bbtrend(symbol, PERIOD_D1, 1);
         int bbtrend2 = bbtrend(symbol, PERIOD_D1, 2);
         int bbtrend3 = bbtrend(symbol, PERIOD_D1, 3);
         infobox = infobox + ", Trend: " + bbtrend + ", Trend 2: " + bbtrend2 + ", Trend 3: " + bbtrend3;
         //check close position
            //check current heiken
            int heiken1 = heikenCurrent(symbol, PERIOD_M1);
            int heiken2 = heikenCurrent(symbol, PERIOD_M5);
            int heiken3 = heikenCurrent(symbol, PERIOD_M15);
            int heiken4 = heikenCurrent(symbol, PERIOD_M30);
            int heiken5 = heikenCurrent(symbol, PERIOD_H1);
            int condition_heiken;
            //check heiken condition
            if (heiken1 == 1 && heiken2 == 1 && heiken3 == 1 && heiken4 == 1 && heiken5 == 1) {
               condition_heiken = 1;
            } else if (heiken1 == -1 && heiken2 == -1 && heiken3 == -1 && heiken4 == -1 && heiken5 == -1) {
               condition_heiken = -1;
            }
            int heikenSwitch = heiken(symbol, PERIOD_H1);
            
            string message = "Swing ";
            message = message + TimeframeToString(PERIOD_D1) + ", " + bbtrend + ", " + bbtrend2 + ", " + bbtrend3
               + ", " + condition_heiken
            ;
         
         
            infobox = infobox + ", Condition Heiken: " + condition_heiken + ", Message: " + message;
            /*
            if (bbtrend == 1 && condition_heiken == -1) {
               CheckForClose(symbol, x, magic, -1);
            } else if (bbtrend == -1 && condition_heiken == 1) {
               CheckForClose(symbol, x, magic, 1);
            }
            if (bbtrend == 1 && condition_heiken == 1) {
               CheckForCloseWithoutProfit(symbol, x, magic, 1);
            } else if (bbtrend == -1 && condition_heiken == -1) {
               CheckForCloseWithoutProfit(symbol, x, magic, -1);
            }  */
            if (bbtrend == 1 && condition_heiken == 1) {
               CheckForCloseWithoutProfit(symbol, x, magic, 1);
            } else if (bbtrend == -1 && condition_heiken == -1) {
               CheckForCloseWithoutProfit(symbol, x, magic, -1);
            }
            // check for open
            int orders = CalculateMaxOrders(magic);
            infobox = infobox + ", Orders: " + orders;
            if (orders >= max) {
            
            } else {
               if (bbtrend == 1 && bbtrend2 == -1 && condition_heiken == 1 && heikenSwitch == 1) {
                  if (createneworders) createorder(aPair[x], 1, lotsize, magic, message, 0, 0);
               } else if (bbtrend == -1 && bbtrend2 == 1 && condition_heiken == -1 && heikenSwitch == -1) {
                  if (createneworders) createorder(aPair[x], -1, lotsize, magic, message, 0, 0);
               } else if (bbtrend == 1 && bbtrend3 == -1 && condition_heiken == 1 && heikenSwitch == 1) {
                  if (createneworders) createorder(aPair[x], 1, lotsize, magic, message, 0, 0);
               } else if (bbtrend == -1 && bbtrend3 == 1 && condition_heiken == -1 && heikenSwitch == -1) {
                  if (createneworders) createorder(aPair[x], -1, lotsize, magic, message, 0, 0);
               }
            }
}


int strategy2(string symbol, int x)
{
         //check the trend
         int bbtrend = bbtrend(symbol, PERIOD_D1, 1);
         infobox = infobox + ", Trend: " + bbtrend;
         //check close position
            //check current heiken
            int heiken1 = heikenCurrent(symbol, PERIOD_M1);
            int heiken2 = heikenCurrent(symbol, PERIOD_M5);
            int heiken3 = heikenCurrent(symbol, PERIOD_M15);
            int heiken4 = heikenCurrent(symbol, PERIOD_M30);
            int heiken5 = heikenCurrent(symbol, PERIOD_H1);
            int condition_heiken;
            //check heiken condition
            if (heiken1 == 1 && heiken2 == 1 && heiken3 == 1 && heiken4 == 1 && heiken5 == 1) {
               condition_heiken = 1;
            } else if (heiken1 == -1 && heiken2 == -1 && heiken3 == -1 && heiken4 == -1 && heiken5 == -1) {
               condition_heiken = -1;
            }
            int heikenSwitch = heiken(symbol, PERIOD_H1);
            
            string message = "Swing Close ";
            message = message + TimeframeToString(PERIOD_D1) + ", " + bbtrend
               + ", " + condition_heiken + ", " + heikenSwitch;
            ;
         
         
            infobox = infobox + ", Condition Heiken: " + condition_heiken + ", Message: " + message;
            
            if (bbtrend == 1 && condition_heiken == -1) {
               CheckForClose(symbol, x, magic, -1);
            } else if (bbtrend == -1 && condition_heiken == 1) {
               CheckForClose(symbol, x, magic, 1);
            }
            if (bbtrend == 1 && condition_heiken == 1) {
               CheckForCloseWithoutProfit(symbol, x, magic, 1);
            } else if (bbtrend == -1 && condition_heiken == -1) {
               CheckForCloseWithoutProfit(symbol, x, magic, -1);
            }
            // check for open
            int orders = CalculateMaxOrders(magic);
            infobox = infobox + ", Orders: " + orders;
            if (orders >= max) {
            
            } else {
               if (bbtrend == 1 && condition_heiken == 1 && heikenSwitch == 1) {
                  if (createneworders) createorder(aPair[x], 1, lotsize, magic, message, 0, 0);
               } else if (bbtrend == -1 && condition_heiken == -1 && heikenSwitch == -1) {
                  if (createneworders) createorder(aPair[x], -1, lotsize, magic, message, 0, 0);
               }
            }
}