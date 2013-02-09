//+------------------------------------------------------------------+
//|                                             custom_trade_sell.mq4 |
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
   double tp;
   switch (Period()) {
      case PERIOD_M1:
         tp = Bid - (20 * Point);
         break;
      case PERIOD_M5: 
         tp = Bid - (50 * Point);
         break;
      case PERIOD_M15:
         tp = Bid - (100 * Point);
         break;
      case PERIOD_M30:
         tp = Bid - (150 * Point);
         break;
      case PERIOD_H1:
         tp = Bid - (200 * Point);
         break;
      case PERIOD_H4:
         tp = Bid - (250 * Point);
         break;
      case PERIOD_D1:
         tp = Bid - (300 * Point);
         break;
      case PERIOD_W1:
         tp = Bid - (350 * Point);
         break;
      case PERIOD_MN1:
         tp = Bid - (400 * Point);
         break;
   }
   double sl = 0; //Bid + (1500 * Point);
   tp = 0;//Bid - (50 * Point);
   int ticket=OrderSend(Symbol(),OP_SELL,0.10,Bid,3,sl,tp,"custom sell 1.1",255,0,CLR_NONE);
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