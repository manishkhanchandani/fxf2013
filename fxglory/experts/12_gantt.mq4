//+------------------------------------------------------------------+
//|                                                     12_gantt.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"
#define MAGICMA  1974060512

extern double Lots               = 0.01;


int CalculateCurrentOrders()
  {
   int cnt=0;
//----
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA)
        {
         cnt++;
        }
     }
//---- return orders volume
   return (cnt);
  }


void CheckForOpen()
  {
   string res;
   string description = StringTrimRight(ObjectDescription("Type"));
   double entry_1 = StrToDouble(StringSubstr(ObjectDescription("Entry1"), 12));
   double entry_2 = StrToDouble(StringSubstr(ObjectDescription("Entry2"), 12));
   double tp_1 = StrToDouble(StringSubstr(ObjectDescription("TP1"), 8));
   double tp_2 = StrToDouble(StringSubstr(ObjectDescription("TP2"), 8));
   double sl = StrToDouble(StringSubstr(ObjectDescription("SL "), 7));
   Print("description: ", description, ", entry 1: ", entry_1, ", entry 2: ", entry_2, ", tp1: ", tp_1, ", tp2: ", tp_2,", sl: ", sl);
//---- sell conditions
   if(description == "SELL")  
     {
     //if (Bid > entry_1) {
      res=OrderSend(Symbol(),OP_SELLSTOP,Lots,entry_1,3,sl,tp_1,"Gnatt",MAGICMA,0,Red);
      Print("Result: ", res, ", error code is",GetLastError());
     //} else {
     res=OrderSend(Symbol(),OP_SELLLIMIT,Lots,entry_1,3,sl,tp_1,"Gnatt",MAGICMA,0,Red);
      Print("Result: ", res, ", error code is",GetLastError());
     //}
     //if (Bid < entry_2) {
      res=OrderSend(Symbol(),OP_SELLLIMIT,Lots,entry_2,3,sl,entry_1,"Gnatt2",MAGICMA,0,Red);
      Print("Result: ", res, ", error code is",GetLastError());
     //} else {
     res=OrderSend(Symbol(),OP_SELLSTOP,Lots,entry_2,3,sl,entry_1,"Gnatt2",MAGICMA,0,Red);
      Print("Result: ", res, ", error code is",GetLastError());
     //}
      return;
     }
//---- buy conditions
   if(description == "BUY")  
     {
     //if (Ask > entry_1) {
      res=OrderSend(Symbol(),OP_BUYLIMIT,Lots,entry_1,3,sl,tp_1,"Gnatt",MAGICMA,0,Blue);
      Print("Result: ", res, ", error code is",GetLastError());
     //} else {
      res=OrderSend(Symbol(),OP_BUYSTOP,Lots,entry_1,3,sl,tp_1,"Gnatt",MAGICMA,0,Blue);
      Print("Result: ", res, ", error code is",GetLastError());
     //}
     //if (Ask < entry_2) {
      res=OrderSend(Symbol(),OP_BUYSTOP,Lots,entry_2,3,sl,entry_1,"Gnatt",MAGICMA,0,Blue);
      Print("Result: ", res, ", error code is",GetLastError());
     //} else {
      res=OrderSend(Symbol(),OP_BUYLIMIT,Lots,entry_2,3,sl,entry_1,"Gnatt",MAGICMA,0,Blue);
      Print("Result: ", res, ", error code is",GetLastError());
     //}
      return;
     }
//----
  }

void CheckForClose()
{
//----
   int del = 0;
   int i;
   for(i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
      //---- check order type 
      if(OrderType()==OP_BUY || OrderType()==OP_SELL)
        {
         del = 1;
         break;
        }
     }
     if (del == 1) { // del is 1 so delete all orders which are not buy or sell i.e. pending orders.
         for(i=0;i<OrdersTotal();i++)
         {
          if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
          if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
          //---- check order type 
          if(OrderType()==OP_BUYLIMIT || OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP || OrderType()==OP_SELLLIMIT)
            {
            Print("Delete order with number: ", OrderTicket());
             OrderDelete(OrderTicket());

            }
         }
     }
    
//----
  }
  
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   Print("Expert Advisor : Gnatt");
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
   if(Bars<100 || IsTradeAllowed()==false) return;
   int orders = CalculateCurrentOrders();
   Print("orders: ", orders);
   if(orders==0) CheckForOpen();
   else                                    CheckForClose();
//----
   return(0);
  }
//+------------------------------------------------------------------+


