//+------------------------------------------------------------------+
//|                                           createbuysellorder.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
  if (!IsDemo()) {
  Alert("only demo accounts are allowed");
  return (0);
  }
  Alert(Symbol());
   bool   result = true;
   int    cmd,total;
   int res;
//----
   total=OrdersTotal();
//----
   for(int i=0; i<total; i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
        if(OrderSymbol()!=Symbol()) {
        continue;
        }
         cmd=OrderType();
         //---- pending orders only are considered
         if(cmd==OP_BUY || cmd==OP_SELL)
           {
            //---- print selected order
            OrderPrint();
            result=OrderDelete(OrderTicket());
            if(result!=TRUE) Alert("LastError = ", GetLastError());
           }
        }
     }
     if (result) {
      res=OrderSend(Symbol(),OP_SELL,0.10,Bid,3,0,0,"","",0,Red);
      res=OrderSend(Symbol(),OP_BUY,0.10,Ask,3,0,0,"","",0,Blue);
      }
   
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
   
//----
   return(0);
  }
//+------------------------------------------------------------------+