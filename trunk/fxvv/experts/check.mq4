//+------------------------------------------------------------------+
//|                                                        check.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

bool email = false;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   if (Bid > 0.81400 && email == false) {
      Print("Email Send");
      SendMail(Symbol() + " Reaches " + Bid, Symbol() + " Reaches " + Bid + " as of " + TimeToStr(TimeCurrent()));
      email = true;
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+