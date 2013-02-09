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
   price = Ask + (50 * Point);
   tp = price + (500 * Point);
   sl = price - (500 * Point);
   ticket=OrderSend(Symbol(),OP_BUYSTOP,0.01,price,3,sl,tp,"multi buy 1.1",255,0,CLR_NONE);
   if(ticket<1)
     {
      error=GetLastError();
      Alert("Error = ",ErrorDescription(error));
      return;
     }
   OrderPrint();
   price = Ask + (100 * Point);
   tp = price + (450 * Point);
   sl = price - (300 * Point);
   ticket=OrderSend(Symbol(),OP_BUYSTOP,0.04,price,3,sl,tp,"multi buy 1.1",255,0,CLR_NONE);
   if(ticket<1)
     {
      error=GetLastError();
      Alert("Error = ",ErrorDescription(error));
      return;
     }
   OrderPrint();
   price = Ask + (150 * Point);
   tp = price + (400 * Point);
   sl = price - (300 * Point);
   ticket=OrderSend(Symbol(),OP_BUYSTOP,0.05,price,3,sl,tp,"multi buy 1.1",255,0,CLR_NONE);
   if(ticket<1)
     {
      error=GetLastError();
      Alert("Error = ",ErrorDescription(error));
      return;
     }
   OrderPrint();
   return;
   price = Ask + (200 * Point);
   tp = price + (350 * Point);
   sl = price - (300 * Point);
   ticket=OrderSend(Symbol(),OP_BUYSTOP,0.05,price,3,sl,tp,"multi buy 1.1",255,0,CLR_NONE);
   if(ticket<1)
     {
      error=GetLastError();
      Alert("Error = ",ErrorDescription(error));
      return;
     }
   OrderPrint();
   price = Ask + (250 * Point);
   tp = price + (300 * Point);
   sl = price - (300 * Point);
   ticket=OrderSend(Symbol(),OP_BUYSTOP,0.05,price,3,sl,tp,"multi buy 1.1",255,0,CLR_NONE);
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