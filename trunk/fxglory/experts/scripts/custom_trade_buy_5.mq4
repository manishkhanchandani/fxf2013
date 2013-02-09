//+------------------------------------------------------------------+
//|                                             custom_trade_buy.mq4 |
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
         tp = Ask + (20 * Point);
         break;
      case PERIOD_M5: 
         tp = Ask + (50 * Point);
         break;
      case PERIOD_M15:
         tp = Ask + (100 * Point);
         break;
      case PERIOD_M30:
         tp = Ask + (150 * Point);
         break;
      case PERIOD_H1:
         tp = Ask + (200 * Point);
         break;
      case PERIOD_H4:
         tp = Ask + (250 * Point);
         break;
      case PERIOD_D1:
         tp = Ask + (300 * Point);
         break;
      case PERIOD_W1:
         tp = Ask + (350 * Point);
         break;
      case PERIOD_MN1:
         tp = Ask + (400 * Point);
         break;
   }
   double sl = 0; //Ask - (1500 * Point);
   //tp = 0;//Ask + (50 * Point);
   int ticket=OrderSend(Symbol(),OP_BUY,0.05,Ask,3,sl,tp,"custom buy 1.1",255,0,CLR_NONE);
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