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
extern double magicHL = 111;
extern int LongStopLoss = 86;
extern int LongProfitTarget = 39;
extern int ShortStopLoss = 86;
extern int ShortProfitTarget = 39;

extern double MinimumSLPT = 20;
extern double MaximumSLPT = 100;
double gPointPow = 0;
double gPointCoef = 0;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   magic = magicHL;
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
      infobox = "";
      for (x = 0; x < ARRSIZE; x++) {
         symbol = aPair[x];
         
         infobox = infobox + "\nSymbol: " + symbol;
         infobox = infobox + ", Bid: " +
         MarketInfo(symbol, MODE_BID) + 
         ", Ask: " + MarketInfo(symbol, MODE_ASK) +
         ", Spread: " + DoubleToStr(MarketInfo(symbol, MODE_SPREAD), 0);
         
         int check = highlowstrategy(symbol, PERIOD_H1, 1);
         
         double realDigits = MarketInfo(symbol, MODE_DIGITS);

         gPointPow = MathPow(10, realDigits);
         gPointCoef = 1/gPointPow;
         int stopLoss = 500;
         int profitTarget = 300;

         double gtotal = historyProfit(magic, symbol);
         infobox = infobox + ", period: " + period + ", Profit: " + DoubleToStr(gtotal, 2) + ", check: " + check;
          
            string message = "HL ";
               message = message + TimeframeToString(period)
               ;
            int count = historyProfitCnt(magic, symbol);
            double newlot = lotsize * count;
            if (newlot < lotsize) newlot = lotsize;
            else if (newlot > maxlot) newlot = maxlot;
            if (check == 1) {
               if (createneworders) createorder(symbol, 1, newlot, magic, message, stopLoss, profitTarget);
            } else if (check == -1) {
               if (createneworders) createorder(symbol, -1, newlot, magic, message, stopLoss, profitTarget);
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

 
double checkCorrectMinMaxSLPT(double slptValue) {
   double slptMin = MinimumSLPT * gPointCoef;
   
   if(MinimumSLPT > 0) {
      slptValue = MathMax(MinimumSLPT * gPointCoef, slptValue);
   }
   if(MaximumSLPT > 0) {
      slptValue = MathMin(MaximumSLPT * gPointCoef, slptValue);
   }
   
   return (slptValue);
}
double getStopLoss(int tradeDirection) {
   double atrValue;
   
   if(tradeDirection == 1) {
      // long
      if(LongStopLoss > 0) {
         return(checkCorrectMinMaxSLPT(LongStopLoss * gPointCoef));
      }
         } else {
      // short
      if(ShortStopLoss > 0) {
         return(checkCorrectMinMaxSLPT(ShortStopLoss * gPointCoef));
      }
   }
}
 
//+------------------------------------------------------------------+

double getProfitTarget(int tradeDirection) {
   double atrValue;
   
   if(tradeDirection == 1) {
      // long
      if(LongProfitTarget > 0) {
         return(checkCorrectMinMaxSLPT(LongProfitTarget * gPointCoef));
      }
   } else {
      // short
      if(ShortProfitTarget > 0) {
         return(checkCorrectMinMaxSLPT(ShortProfitTarget * gPointCoef));
      }
   }
} 



