//+------------------------------------------------------------------+
//|                                                   create_buy.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
   string symbol = Symbol();
   string message = "Auto";
   int magicnumber = 1234;
   double Lots = 0.01;//NormalizeDouble(AccountBalance() / 10000, 2);
   int ticket=OrderSend(symbol,OP_SELL,Lots,Bid,3,0,0,message,magicnumber,0,Green);
//----
   return(0);
  }
//+------------------------------------------------------------------+