//+------------------------------------------------------------------+
//|                                                     14_gantt.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"
#define MAGICMA  1974060514

extern double Lots               = 0.01;
extern int maxorders = 1;
double build = 1.0;
string description;
double entry_1;
double entry_2;
double tp_1;
double tp_2;
double sl;

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
   int orders = 0;
   orders = CalculateCurrentMaxOrders();
   if (orders >= maxorders) {
      return (0);
   }
   string res;
   string message;
   message = StringConcatenate("v-",build,", Gnatt", ", Period: ", TimeframeToString(Period()));
//---- sell conditions
   if(description == "SELL")  
     {
     //if (Bid > entry_1) {
      res=OrderSend(Symbol(),OP_SELLSTOP,Lots,entry_1,3,sl,tp_1,message,MAGICMA,0,Red);
      Print("Result: ", res, ", error code is",GetLastError());
     //} else {
     res=OrderSend(Symbol(),OP_SELLLIMIT,Lots,entry_1,3,sl,tp_1,message,MAGICMA,0,Red);
      Print("Result: ", res, ", error code is",GetLastError());
     //}
     //if (Bid < entry_2) {
      res=OrderSend(Symbol(),OP_SELLLIMIT,Lots,entry_2,3,sl,entry_1,message,MAGICMA,0,Red);
      Print("Result: ", res, ", error code is",GetLastError());
     //} else {
     res=OrderSend(Symbol(),OP_SELLSTOP,Lots,entry_2,3,sl,entry_1,message,MAGICMA,0,Red);
      Print("Result: ", res, ", error code is",GetLastError());
     //}
      return;
     }
//---- buy conditions
   if(description == "BUY")  
     {
     
     //if (Ask > entry_1) {
      res=OrderSend(Symbol(),OP_BUYLIMIT,Lots,entry_1,3,sl,tp_1,message,MAGICMA,0,Blue);
      Print("Result: ", res, ", error code is",GetLastError());
     //} else {
      res=OrderSend(Symbol(),OP_BUYSTOP,Lots,entry_1,3,sl,tp_1,message,MAGICMA,0,Blue);
      Print("Result: ", res, ", error code is",GetLastError());
     //}
     //if (Ask < entry_2) {
      res=OrderSend(Symbol(),OP_BUYSTOP,Lots,entry_2,3,sl,entry_1,message,MAGICMA,0,Blue);
      Print("Result: ", res, ", error code is",GetLastError());
     //} else {
      res=OrderSend(Symbol(),OP_BUYLIMIT,Lots,entry_2,3,sl,entry_1,message,MAGICMA,0,Blue);
      Print("Result: ", res, ", error code is",GetLastError());
     //}
      return;
     }
//----
  }

string TimeframeToString(int P)
{
   switch(P)
   {
      case PERIOD_M1:  return("M1");
      case PERIOD_M5:  return("M5");
      case PERIOD_M15: return("M15");
      case PERIOD_M30: return("M30");
      case PERIOD_H1:  return("H1");
      case PERIOD_H4:  return("H4");
      case PERIOD_D1:  return("D1");
      case PERIOD_W1:  return("W1");
      case PERIOD_MN1: return("MN1");
   }
}
void CheckForClose()
{
//----
   int del = 0;
   int i;
   
   int orders = 0;
   orders = CalculateCurrentMaxOrders();
   if (orders >= maxorders) {
      del = 1;
   }

   if (del != 1) {
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
     }
     
     if (del != 1) {
         for(i=0;i<OrdersTotal();i++)
             {
              if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
              if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
              //---- check order type 
              if(OrderType()==OP_BUYLIMIT || OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP || OrderType()==OP_SELLLIMIT)
                {
                   if (entry_1 == OrderOpenPrice() || entry_2 == OrderOpenPrice()) {
                     //Print("entrys are same");
                   } else {
                     Print("entrys are different, old entry: ", OrderOpenPrice(), ", new entry 1: ", entry_1, ", new entry 2: ", entry_2);
                     del = 1;
                   }
                }
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
   description = StringTrimRight(ObjectDescription("Type"));
   entry_1 = StrToDouble(StringSubstr(ObjectDescription("Entry1"), 12));
   entry_2 = StrToDouble(StringSubstr(ObjectDescription("Entry2"), 12));
   tp_1 = StrToDouble(StringSubstr(ObjectDescription("TP1"), 8));
   tp_2 = StrToDouble(StringSubstr(ObjectDescription("TP2"), 8));
   sl = StrToDouble(StringSubstr(ObjectDescription("SL "), 7));
   Print("description: ", description, ", entry 1: ", entry_1, ", entry 2: ", entry_2, ", tp1: ", tp_1, ", tp2: ", tp_2,", sl: ", sl);
   if(orders==0) CheckForOpen();
   else                                    CheckForClose();
//----
   return(0);
  }
//+------------------------------------------------------------------+


int CalculateCurrentMaxOrders()
  {
   int corders=0;
//----
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderMagicNumber()==MAGICMA)
        {
         if(OrderType()==OP_BUY || OrderType()==OP_SELL)
            corders++;
        }
     }
         Print("Max orders: ", corders);
         return(corders);
}


