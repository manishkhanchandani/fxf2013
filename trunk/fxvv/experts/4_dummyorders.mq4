//+------------------------------------------------------------------+
//|                                                4_dummyorders.mq4 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
#define MAGICMA  20050611

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   string r;
   int buys=0,sells=0;
   Print(Symbol());
   for(int i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol())
        {
         if(OrderType()==OP_BUY)  buys++;
         if(OrderType()==OP_SELL) sells++;
        }
   
   }
   Print("buys: ", buys);
  Print("sells: ", sells);
  if (buys == 0) {
      r = OrderSend(Symbol(),OP_BUY,0.01,Ask,3,0,0,"",MAGICMA,0,Blue);
      Print("Result for buy: ", r);
      //if (r == -1) {
      Print("error: ", GetLastError());
      //}
  }
  if (sells == 0) {
      r = OrderSend(Symbol(),OP_SELL,0.01,Bid,3,0,0,"",MAGICMA,0,Red);
      Print("Result for sell: ", r);
      //if (r == -1) {
      Print("error: ", GetLastError());
      //}
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