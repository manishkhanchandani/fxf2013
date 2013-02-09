//+------------------------------------------------------------------+
//|                                             c_sell.mq4 |
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
   double tp = Bid - (100 * Point);
   double sl = Bid + (500 * Point);
   int ticket=OrderSend(Symbol(),OP_SELL,0.20,Bid,3,sl,tp,"custom sell 1.1",255,0,CLR_NONE);
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