//+------------------------------------------------------------------+
//|                                                        1_buy.mq4 |
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
   double Lots = 0.01;
   string message = "sc1";
   int magicnumber = 123400;
   int ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,3,0,0,message,magicnumber,0,Green);
   if(ticket>0) {
      double sl = Ask - (300 * Point);
      OrderModify(OrderTicket(),OrderOpenPrice(),sl,0,0,Green);
   } else {
      Print(Symbol(), ", Error opening BUY order : ",ErrorDescription(GetLastError()), ", Ask: ", Ask, ", lots: ", Lots);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+