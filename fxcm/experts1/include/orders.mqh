//+------------------------------------------------------------------+
//|                                                       orders.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"
#define MAGICMA  1974060500007

extern bool createordersauto = true;
extern int maxorders = 2;
bool pending_order_1 = false;
bool pending_order_2 = false;
bool pending_order_3 = false;
bool pending_order_4 = false;

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2005

//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);

// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import

//+------------------------------------------------------------------+
//| EX4 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex4"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
//common is required

void createorders(double buy, double buytp, double buysl, double sell, double selltp, double sellsl, double lotsize, string message)
{
   Print(Symbol(), ", timeframe: ", TimeframeToString(Period()), ", buy: ", buy, ", lotsize: ", lotsize,
   ", buysl: ", buysl, ", buytp: ", buytp, ", message: ", message);
   Print(Symbol(), ", timeframe: ", TimeframeToString(Period()), ", sell: ", sell, ", lotsize: ", lotsize,
   ", sellsl: ", sellsl, ", selltp: ", selltp, ", message: ", message);

   //if(IsTradeAllowed()==false) {
      //Print(Symbol(), ", timeframe: ", TimeframeToString(Period()), ", Trade is not allowed. Please enable the trade.");
      //return (0);
   //}
 
   if (createordersauto == false) {
      Print(Symbol(), ", timeframe: ", TimeframeToString(Period()), ", Auto Create orders is false");
      return (0);
   }

   if (!(Period() == PERIOD_D1 || Period() == PERIOD_H4 || Period() == PERIOD_H1 || Period() == PERIOD_M30 || Period() == PERIOD_M15)) {
      Print(Symbol(), ", timeframe: ", TimeframeToString(Period()), ", Cannot process orders in period ", TimeframeToString(Period()), 
      ", Orders are processed only in day or 4 hour time format");
      return (0);
   }
   
   int error;
      running_profit = 0;
      profit_1 = 0;
      profit_2 = 0;
   int res;
      res=OrderSend(Symbol(),OP_BUYLIMIT,lotsize, buy,3,buysl,buytp,message,MAGICMA,0,Green);
      Print(Symbol(), ", timeframe: ", TimeframeToString(Period()), ", Result1: ", res, ", error code is",GetLastError());
      pending_order_1 = false;
      /*if(res<1)
      {
         error=GetLastError();
         Alert("Error = ",ErrorDescription(error));
      }*/
      if (GetLastError() == 146) {
         pending_order_1 = true;
         //Sleep(1000);
         //res=OrderSend(Symbol(),OP_BUYLIMIT,lotsize, buy,3,buysl,buytp,message,MAGICMA,0,Green);
         //Print(Symbol(), ", timeframe: ", TimeframeToString(Period()), ", Result1: ", res, ", error code is",GetLastError());
      }
      res=OrderSend(Symbol(),OP_BUYSTOP,lotsize, buy,3,buysl,buytp,message,MAGICMA,0,Blue);
      Print(Symbol(), ", timeframe: ", TimeframeToString(Period()), ", Result2: ", res, ", error code is",GetLastError());
      pending_order_2 = false;
      /*if(res<1)
      {
         error=GetLastError();
         Alert("Error = ",ErrorDescription(error));
      }*/
      if (GetLastError() == 146) {
         pending_order_2 = true;
         //Sleep(1000);
         //res=OrderSend(Symbol(),OP_BUYSTOP,lotsize, buy,3,buysl,buytp,message,MAGICMA,0,Blue);
         //Print(Symbol(), ", timeframe: ", TimeframeToString(Period()), ", Result2: ", res, ", error code is",GetLastError());
      }
      res=OrderSend(Symbol(),OP_SELLSTOP,lotsize, sell,3,sellsl,selltp,message,MAGICMA,0,Red);
      Print(Symbol(), ", timeframe: ", TimeframeToString(Period()), ", Result3: ", res, ", error code is",GetLastError());
      pending_order_3 = false;
      /*if(res<1)
      {
         error=GetLastError();
         Alert("Error = ",ErrorDescription(error));
      }*/
      if (GetLastError() == 146) {
         pending_order_3 = true;
         //Sleep(1000);
         //res=OrderSend(Symbol(),OP_SELLSTOP,lotsize, sell,3,sellsl,selltp,message,MAGICMA,0,Red);
         //Print(Symbol(), ", timeframe: ", TimeframeToString(Period()), ", Result3: ", res, ", error code is",GetLastError());
      }
      res=OrderSend(Symbol(),OP_SELLLIMIT,lotsize, sell,3,sellsl,selltp,message,MAGICMA,0,Black);
      Print(Symbol(), ", timeframe: ", TimeframeToString(Period()), ", Result4: ", res, ", error code is",GetLastError());
      pending_order_4 = false;
      /*if(res<1)
      {
         error=GetLastError();
         Alert("Error = ",ErrorDescription(error));
      }*/
      if (GetLastError() == 146) {
         pending_order_4 = true;
         //Sleep(1000);
         //res=OrderSend(Symbol(),OP_SELLLIMIT,lotsize, sell,3,sellsl,selltp,message,MAGICMA,0,Black);
         //Print(Symbol(), ", timeframe: ", TimeframeToString(Period()), ", Result4: ", res, ", error code is",GetLastError());
      }

   Print(Symbol(), ", timeframe: ", TimeframeToString(Period()), ", orders created successfully");
   return (0);
}

void creatependingorders(double buy, double buytp, double buysl, double sell, double selltp, double sellsl, double lotsize, string message)
{
   if (pending_order_1 == false && pending_order_2 == false && pending_order_3 == false && pending_order_4 == false) {
      return (0);
   }
   int error;
   int res;
   if (pending_order_1 == true) {
      res=OrderSend(Symbol(),OP_BUYLIMIT,lotsize, buy,3,buysl,buytp,message,MAGICMA,0,Green);
      Print(Symbol(), ", timeframe: ", TimeframeToString(Period()), ", Result1: ", res, ", error code is",GetLastError());
      pending_order_1 = false;
      /*if(res<1)
      {
         error=GetLastError();
         Alert("Error = ",ErrorDescription(error));
      }*/
      if (GetLastError() == 146) {
         pending_order_1 = true;
      }
   }
   if (pending_order_2 == true) {
      res=OrderSend(Symbol(),OP_BUYSTOP,lotsize, buy,3,buysl,buytp,message,MAGICMA,0,Blue);
      Print(Symbol(), ", timeframe: ", TimeframeToString(Period()), ", Result2: ", res, ", error code is",GetLastError());
      pending_order_2 = false;
      /*if(res<1)
      {
         error=GetLastError();
         Alert("Error = ",ErrorDescription(error));
      }*/
      if (GetLastError() == 146) {
         pending_order_2 = true;
      }
   }
   if (pending_order_3 == true) {
      res=OrderSend(Symbol(),OP_SELLSTOP,lotsize, sell,3,sellsl,selltp,message,MAGICMA,0,Red);
      Print(Symbol(), ", timeframe: ", TimeframeToString(Period()), ", Result3: ", res, ", error code is",GetLastError());
      pending_order_3 = false;
      /*if(res<1)
      {
         error=GetLastError();
         Alert("Error = ",ErrorDescription(error));
      }*/
      if (GetLastError() == 146) {
         pending_order_3 = true;
      }
   }
   if (pending_order_4 == true) {
      res=OrderSend(Symbol(),OP_SELLLIMIT,lotsize, sell,3,sellsl,selltp,message,MAGICMA,0,Black);
      Print(Symbol(), ", timeframe: ", TimeframeToString(Period()), ", Result4: ", res, ", error code is",GetLastError());
      pending_order_4 = false;
      /*if(res<1)
      {
         error=GetLastError();
         Alert("Error = ",ErrorDescription(error));
      }*/
      if (GetLastError() == 146) {
         pending_order_4 = true;
      }
   }
}

int check(double buy, double buytp, double buysl, double sell, double selltp, double sellsl, double lotsize, string message)
{
   buy = NormalizeDouble(buy, Digits);
   buysl = NormalizeDouble(buysl, Digits);
   buytp = NormalizeDouble(buytp, Digits);
   sell = NormalizeDouble(sell, Digits);
   sellsl = NormalizeDouble(sellsl, Digits);
   selltp = NormalizeDouble(selltp, Digits);
   int orders = 0;
   orders = CalculateCurrentMaxOrders();
   if (orders >= maxorders) {
      return (0);
   }
   orders = CalculateCurrentOrders();
   Print("orders: ", orders);
   if(orders==0) 
      createorders(buy, buytp, buysl, sell, selltp, sellsl, lotsize, message);
}

int CalculateCurrentMaxOrders()
  {
      //Print("Calculating max orders");
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
         //Print("Max orders: ", corders);
         return(corders);
}


int CalculateCurrentOrders()
  {
      Print("Calculating current orders");
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
  
int deletepending()
  {
   if (createordersauto == false) {
      //Print(Symbol(), ", timeframe: ", TimeframeToString(Period()), ", Auto Create orders is false");
      return (0);
   }
      Print("Deleting the pending order");
   bool   result;
   int    cmd,total;
//----
   total=OrdersTotal();
//----
   for(int i=0; i<total; i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
         cmd=OrderType();
         //---- pending orders only are considered
         if(cmd!=OP_BUY && cmd!=OP_SELL)
           {
            //---- print selected order
            OrderPrint();
            //---- delete first pending order
            result=OrderDelete(OrderTicket());
            if(result!=TRUE) Print("LastError = ", GetLastError());
            break;
           }
        }
      else { Print( "Error when order select ", GetLastError()); break; }
     }
//----
   return(0);
  }
  
  
  void CheckForClose()
{
//----
   if (createordersauto == false) {
      return (0);
   }

   int i;
   
   for(i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
      //---- check order type 
      if(OrderType()==OP_BUY || OrderType()==OP_SELL)
        {
         checkprofit(OrderProfit(), OrderLots(), OrderType(), OrderTicket());
        }
     }

   int del = 0;
   
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
  
void checkprofit(double orderprofit, double orderlot, double ordertype, int orderticket)
{
      if (orderprofit < running_profit && running_profit > 0) {
         Alert("Order profit is less than running profit so closing the order. ", orderprofit, ", running profit: ", running_profit);
         running_profit = 0;
         profit_1 = 0;
         profit_2 = 0;
         //close the order;
         if(ordertype==OP_BUY) {
            OrderClose(orderticket,orderlot,Bid,3,White);
         } else if(ordertype==OP_SELL) {
            OrderClose(orderticket,orderlot,Ask,3,White);
         }
      }

      double tmp;
      //if (orderprofit >= profit_2) {
         //running_profit = profit_1;
      //}
      if (orderprofit > half_profit && profit_1 == 0) {
         profit_1 = orderprofit;
         tmp = orderprofit / 10;
         profit_2 = profit_1 + tmp;
      } else if (orderprofit > half_profit && profit_2 > 0 && orderprofit > profit_2) {
         profit_1 = orderprofit;
         tmp = orderprofit / 10;
         profit_2 = profit_1 + tmp;
         running_profit = profit_1 - tmp;
      }
}