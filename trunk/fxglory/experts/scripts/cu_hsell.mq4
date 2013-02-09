//+------------------------------------------------------------------+
//|                                                      cu_hbuy.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"
#include <stdlib.mqh>
#include <WinUser32.mqh>


//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
   int MAGICMA = 411;
   double Lots = 0.10;
   double bids = MarketInfo(Symbol(), MODE_BID);
   double asks = MarketInfo(Symbol(), MODE_ASK);
   double pt = MarketInfo(Symbol(), MODE_POINT);
   int digit = MarketInfo(Symbol(), MODE_DIGITS);
   bids = NormalizeDouble(bids, digit);
   asks = NormalizeDouble(asks, digit);
   double tp, sl;
   tp = 0;
   sl = 0;
   int ticket=OrderSend(Symbol(),OP_SELL,Lots,bids,3,0,0,"Heiken Blaster S ",MAGICMA,0,Green);
      if(ticket>0)
         {
         if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
            sl = bids + (500 * pt);
            sl = NormalizeDouble(sl, digit);
            tp = bids - (5000 * pt);
            tp = NormalizeDouble(tp, digit);            
            OrderModify(OrderTicket(),OrderOpenPrice(),sl,tp,0,Green);
          }         
         }
      else {
         Print(Symbol(), ", Error opening BUY order : ",ErrorDescription(GetLastError()), ", bids: ", bids);
         }
//----
   return(0);
  }
//+------------------------------------------------------------------+