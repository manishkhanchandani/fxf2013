//+------------------------------------------------------------------+
//|                                             custom_trade_buy.mq4 |
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
   double tp;
   tp = Ask + twentyfivepercent();
   double sl = Ask - (1000 * Point);
   double lots = lotsize(0.25);
   int ticket=OrderSend(Symbol(),OP_BUY,lots,Ask,3,sl,tp,"custom buy 1.1",255,0,CLR_NONE);
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