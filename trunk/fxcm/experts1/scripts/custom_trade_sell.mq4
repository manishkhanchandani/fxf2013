//+------------------------------------------------------------------+
//|                                             custom_trade_sell.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <stdlib.mqh>
#include <WinUser32.mqh>
#include <common.mqh>

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
   double tp;
   tp = Bid - twentyfivepercent();
   double sl = Bid + (1000 * Point);
   double lots = lotsize(0.25);
   int ticket=OrderSend(Symbol(),OP_SELL,lots,Bid,3,sl,tp,"custom sell 1.1",255,0,CLR_NONE);
   if(ticket<1)
     {
      int error=GetLastError();
      Alert("Error = ",ErrorDescription(error));
      return;
     }
//----
   OrderPrint();
//----
   return(0);
  }
//+------------------------------------------------------------------+