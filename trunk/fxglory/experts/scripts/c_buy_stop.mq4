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
   //OP_SELLSTOP and OP_BUYSTOP
   double tp, sl;
   double price;
   int ticket, error;
   price = Ask + (25 * Point);
   tp = price + (100 * Point);
   sl = 0; //price - (200 * Point);
   ticket=OrderSend(Symbol(),OP_BUYSTOP,0.25,price,3,sl,tp,"multi buy 1.1",255,0,CLR_NONE);
   if(ticket<1)
     {
      error=GetLastError();
      Alert("Error = ",ErrorDescription(error));
      return;
     }
   OrderPrint();
//----
//----
   return(0);
  }
//+------------------------------------------------------------------+