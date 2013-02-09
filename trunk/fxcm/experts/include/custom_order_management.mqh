//+------------------------------------------------------------------+
//|                                      custom_order_management.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#define MAGICMA  16384
#include <stdlib.mqh>
#include <WinUser32.mqh>

extern int TrailingStop = 150;
extern double Lots = 0.05;
extern double MaximumRisk        = 0.02;
extern double DecreaseFactor     = 3;

extern bool custom_take_profit = false;
extern bool custom_stop_loss = false;
extern double custom_tp = 600;
extern double custom_sl = 500;
extern bool UseAlerts = true;
extern bool UseEmailAlerts = true;
extern bool UsePrintAlerts = true;
extern int maxorders = 2;
extern bool create_order = true;
string orderbox;

int reverse_bid(string symbol, int type)
{
   double bids, asks, pt;
   for(int cnt=0;cnt<OrdersTotal();cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol() == symbol && OrderMagicNumber()==MAGICMA && OrderProfit() >= 0) {
         if (current_currency_pair) {
            bids = Bid;
            asks = Ask;
            pt = Point;
         } else {
            bids = MarketInfo(OrderSymbol(), MODE_BID);
            asks = MarketInfo(OrderSymbol(), MODE_ASK);
            pt = MarketInfo(OrderSymbol(), MODE_POINT);
         }
         if(OrderType()==OP_BUY) {
            if (type == -1) {
               Alert(symbol, ", Closing buy order");
               OrderClose(OrderTicket(),OrderLots(),bids,3,White);
            }
         } else if (OrderType()==OP_SELL) {
            if (type == 1) {
               Alert(symbol, ", Closing sell order");
               OrderClose(OrderTicket(),OrderLots(),asks,3,White);
            }         
         }
      }
   }
}

int reverse_bid_force(string symbol, int type)
{
   double bids, asks, pt;
   for(int cnt=0;cnt<OrdersTotal();cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol() == symbol && OrderMagicNumber()==MAGICMA) {
         if (current_currency_pair) {
            bids = Bid;
            asks = Ask;
            pt = Point;
         } else {
            bids = MarketInfo(OrderSymbol(), MODE_BID);
            asks = MarketInfo(OrderSymbol(), MODE_ASK);
            pt = MarketInfo(OrderSymbol(), MODE_POINT);
         }
         if(OrderType()==OP_BUY) {
            if (type == -1) {
               Alert(symbol, ", Closing buy order");
               OrderClose(OrderTicket(),OrderLots(),bids,3,White);
            }
         } else if (OrderType()==OP_SELL) {
            if (type == 1) {
               Alert(symbol, ", Closing sell order");
               OrderClose(OrderTicket(),OrderLots(),asks,3,White);
            }         
         }
      }
   }
}

int order_send(string symbol, int type, double lotsize, string message)
{
   int ticket;
   double bids = MarketInfo(symbol, MODE_BID);
   double asks = MarketInfo(symbol, MODE_ASK);
   double pt = MarketInfo(symbol, MODE_POINT);
   if (type == 1) {
      ticket=OrderSend(symbol,OP_BUY,lotsize,asks,3,0,0,message,MAGICMA,0,Green);
      if(ticket>0)
         {
          if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
            SendAlert(StringConcatenate("BUY order opened : ",OrderOpenPrice()), symbol, 0);
          }
         }
      else {
         Print(symbol, ", Error opening BUY order : ",ErrorDescription(GetLastError()), ", asks: ", asks);
         order_send(symbol, type, lotsize, message);
      }
   } else if (type == -1) {
      ticket=OrderSend(symbol,OP_SELL,lotsize,bids,3,0,0,message,MAGICMA,0,Green);
      if(ticket>0)
         {
          if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
            SendAlert(StringConcatenate("Sell order opened : ",OrderOpenPrice()), symbol, 0);
          }
         }
      else {
         Print(symbol, ", Error opening Sell order : ",ErrorDescription(GetLastError()), ", bids: ", bids);
         order_send(symbol, type, lotsize, message);
      }
   }
}
int trailing_stop(int ts)
{
   orderbox = StringConcatenate(orderbox, "\nCHECKING ORDERS:");
   int cnt, ticket, total;
   total=OrdersTotal();
   double bids, asks, pt;
   int orders;
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         // for more than two orders, return as we dont support trialing stop for more orders as of now
      if(OrderType()<=OP_SELL && OrderMagicNumber()==MAGICMA)  // check for symbol
         {
         orderbox = StringConcatenate(orderbox, "\n", OrderSymbol(), " (", OrderProfit(), ")");
         if (ts == 0) {
           continue;
         }
         if (current_currency_pair) {
            bids = Bid;
            asks = Ask;
            pt = Point;
            if (OrderSymbol() != Symbol()) {
               orderbox = StringConcatenate(orderbox, " - ", OrderSymbol(), " is different than: ", Symbol());
               continue;
            }
         } else {
            bids = MarketInfo(OrderSymbol(), MODE_BID);
            asks = MarketInfo(OrderSymbol(), MODE_ASK);
            pt = MarketInfo(OrderSymbol(), MODE_POINT);
         }
         orderbox = StringConcatenate(orderbox, " - ordertype: ", OrderType());
         //Print(OrderSymbol(), ", bids: ", bids, ", asks: ", asks);
         //Print(OrderSymbol(), ", Ordder Profit: ", OrderProfit(), ", OrderOpenPrice: ", OrderOpenPrice());
            if(OrderType()==OP_BUY) {
         orderbox = StringConcatenate(orderbox, " - ordertype: ", OrderType());
               if(TrailingStop>0 
               && OrderProfit() > 0
               )  
               {                 
                  orderbox = StringConcatenate(orderbox, " - pt*TrailingStop: ", (pt*TrailingStop));
                  orderbox = StringConcatenate(orderbox, " - asks-OrderOpenPrice(): ", (asks-OrderOpenPrice()));
                  //Print(Symbol(), ", asks-OrderOpenPrice(): ", (asks-OrderOpenPrice()), ", pt*TrailingStop: ", (pt*TrailingStop));
                  if(asks-OrderOpenPrice()>pt*TrailingStop)
                  {
                     orderbox = StringConcatenate(orderbox, " - OrderStopLoss(): ", OrderStopLoss());
                     orderbox = StringConcatenate(orderbox, " - asks-pt*TrailingStop: ", (asks-pt*TrailingStop));
                     //Print(OrderSymbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", asks-pt*TrailingStop: ", (asks-pt*TrailingStop));
                     if(OrderStopLoss()<asks-pt*TrailingStop)
                     {
                        Alert(OrderSymbol(), ", Modify Buy");
                        OrderModify(OrderTicket(),OrderOpenPrice(),asks-pt*TrailingStop,OrderTakeProfit(),0,Green);
                        return(0);
                     }
                  }
               }//end if
            } else if(OrderType()==OP_SELL) {
         orderbox = StringConcatenate(orderbox, " - ordertype: ", OrderType());
               // check for trailing stop
               if(TrailingStop>0 
               && OrderProfit() > 0
               )  
                 {             
                  orderbox = StringConcatenate(orderbox, " - pt*TrailingStop: ", (pt*TrailingStop));
                  orderbox = StringConcatenate(orderbox, " - OrderOpenPrice()-bids: ", (OrderOpenPrice()-bids));    
                  //Print(OrderSymbol(), ", OrderOpenPrice()-bids: ", (OrderOpenPrice()-bids), ", pt*TrailingStop: ", (pt*TrailingStop));
                  if((OrderOpenPrice()-bids)>(pt*TrailingStop))
                    {
                     orderbox = StringConcatenate(orderbox, " - OrderStopLoss(): ", OrderStopLoss());
                     orderbox = StringConcatenate(orderbox, " - bids+pt*TrailingStop: ", (bids+pt*TrailingStop));
                     //Print(OrderSymbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", bids+pt*TrailingStop: ", (bids+pt*TrailingStop));
                     if((OrderStopLoss()>(bids+pt*TrailingStop)) || (OrderStopLoss()==0))
                       {
                        Alert(OrderSymbol(), ", Modify Sell");
                        OrderModify(OrderTicket(),OrderOpenPrice(),bids+pt*TrailingStop,OrderTakeProfit(),0,Red);
                        return(0);
                       }
                    }
                 }
            } 
         }
      }
//----
   return(0);
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
      case 0: return ("Any");
   }
}


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
         return(corders);
}


int CalculateCurrentOrders(string symbol)
  {
   int cnt=0;
//----
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==symbol)// && OrderMagicNumber()==MAGICMA
        {
         cnt++;
        }
     }
   return (cnt);
  }

int CalculateCurrentOrdersLots(string symbol, double lotsize)
  {
   int cnt=0;
//----
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==symbol && OrderLots()==lotsize)// && OrderMagicNumber()==MAGICMA
        {
         cnt++;
        }
     }
   return (cnt);
  }


void SendAlert(string dir, string symbol, int timeperiod)
{
   string per = TimeframeToString(timeperiod);
   if (UseAlerts)
   {
      Alert(symbol, " @ ", per, " - ", TimeToStr(TimeCurrent()), " - ", dir);
      PlaySound("alert.wav");
   }
   if (UseEmailAlerts)
      SendMail(symbol + " @ " + per + " - " + dir, dir + " on " + symbol + " @ " + per + " as of " + TimeToStr(TimeCurrent()));
      
   if (UsePrintAlerts)
      Print(Symbol() + " @ " + per + " - " + dir, dir + " on " + symbol + " @ " + per + " as of " + TimeToStr(TimeCurrent()));
}


int createorder(string symbol, int timeperiod, int type, string message)
{
   if (IsTradeAllowed()==false)
      return (0);
   if (!create_order) {
      //Print("create order is not allowed");
       return (0);
   }
   int orders;
   orders = CalculateCurrentMaxOrders();
   if (orders >= maxorders)
   {
      //Print("max order reached");
       return (0);
   }
   orders = CalculateCurrentOrders(symbol);
   if (orders > 0)
   {
      //Print("order already created for symbol: ", symbol);
       return (0);
   }
   double bids, asks, pt, digit;
   if (current_currency_pair) {
            bids = Bid;
            asks = Ask;
            pt = Point;
            digit = Digits;
         } else {
            bids = MarketInfo(symbol, MODE_BID);
            asks = MarketInfo(symbol, MODE_ASK);
            pt = MarketInfo(symbol, MODE_POINT);
            digit = MarketInfo(symbol, MODE_DIGITS);
         }
         bids = NormalizeDouble(bids, digit);
         asks = NormalizeDouble(asks, digit);
   int ticket;
   double tp, sl;
   tp = 0;
   sl = 0;
   if (type == 1) {
      if (custom_take_profit) tp = asks + (custom_tp * pt);
      if (custom_stop_loss) sl = asks - (custom_sl * pt);
   } else if (type == -1) {
      if (custom_take_profit) tp = bids - (custom_tp * pt);
      if (custom_stop_loss) sl = bids + (custom_sl * pt);
   }
   if (sl > 0) 
         sl = NormalizeDouble(sl, digit);
   if (tp > 0) 
         tp = NormalizeDouble(tp, digit);
   if (type == 1) {
       ticket=OrderSend(symbol,OP_BUY,Lots,asks,3,sl,tp,message,MAGICMA,0,Green);
      if(ticket>0)
         {
          if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
            SendAlert(StringConcatenate("BUY order opened : ",OrderOpenPrice()), symbol, timeperiod);
          }
         }
      else {
         Print(symbol, ", Error opening BUY order : ",ErrorDescription(GetLastError()), ", asks: ", asks);
      }
         return(0); 
   } else if (type == -1) {
       ticket=OrderSend(symbol,OP_SELL,Lots,bids,3,sl,tp,message,MAGICMA,0,Red);
        if(ticket>0)
           {
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
               SendAlert(StringConcatenate("SELL order opened : ",OrderOpenPrice()), symbol, timeperiod);
            }
           }
           else {
               Print(symbol, " Error opening Sell order : ",ErrorDescription(GetLastError()), ", price: ", bids); 
            } 
             return(0); 
   }
}

int createorder_lots(string symbol, int timeperiod, int type, string message, double lotsize, string fn)
{
Print("order started: ");
   if (IsTradeAllowed()==false)
      return (0);
   if (!create_order) {
      //Print("create order is not allowed");
       return (0);
   }
   int orders;
   Print("checking max orders: ");
   orders = CalculateCurrentMaxOrders();
   Print("Max orders are: ", orders);
   Print("Max orders provided are: ", maxorders);
   if (orders >= maxorders)
   {
      //Print("max order reached");
       return (0);
   }
   Print("checking orders: ");
   orders = CalculateCurrentOrdersLots(symbol, lotsize);
   Print("orders are: ", orders);
   if (orders > 0)
   {
      //Print("order already created for symbol: ", symbol);
       return (0);
   }
   double bids, asks, pt, digit;
   if (current_currency_pair) {
            bids = Bid;
            asks = Ask;
            pt = Point;
            digit = Digits;
         } else {
            bids = MarketInfo(symbol, MODE_BID);
            asks = MarketInfo(symbol, MODE_ASK);
            pt = MarketInfo(symbol, MODE_POINT);
            digit = MarketInfo(symbol, MODE_DIGITS);
         }
         bids = NormalizeDouble(bids, digit);
         asks = NormalizeDouble(asks, digit);
   int ticket;
   double tp, sl;
   tp = 0;
   sl = 0;
   if (type == 1) {
      if (custom_take_profit) tp = asks + (custom_tp * pt);
      if (custom_stop_loss) sl = asks - (custom_sl * pt);
   } else if (type == -1) {
      if (custom_take_profit) tp = bids - (custom_tp * pt);
      if (custom_stop_loss) sl = bids + (custom_sl * pt);
   }
   if (sl > 0) 
         sl = NormalizeDouble(sl, digit);
   if (tp > 0) 
         tp = NormalizeDouble(tp, digit);
   if (type == 1) {
       ticket=OrderSend(symbol,OP_BUY,lotsize,asks,3,sl,tp,message,MAGICMA,0,Green);
      if(ticket>0)
         {
          if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
            SendAlert(StringConcatenate("BUY order opened : ",OrderOpenPrice()), symbol, timeperiod);
          }
            FileAppend(fn, symbol + ": " + timestr(TimeCurrent()) + ": Buy Message: " + message);
         }
      else {
         Print(symbol, ", Error opening BUY order : ",ErrorDescription(GetLastError()), ", asks: ", asks);
      }
         return(0); 
   } else if (type == -1) {
       ticket=OrderSend(symbol,OP_SELL,lotsize,bids,3,sl,tp,message,MAGICMA,0,Red);
        if(ticket>0)
           {
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
               SendAlert(StringConcatenate("SELL order opened : ",OrderOpenPrice()), symbol, timeperiod);
            }
            FileAppend(fn, symbol + ": " + timestr(TimeCurrent()) + ": Sell Message: " + message);
           }
           else {
               Print(symbol, " Error opening Sell order : ",ErrorDescription(GetLastError()), ", price: ", bids); 
            } 
             return(0); 
   }
}
string timestr(int tm)
{
   return (TimeToStr(tm));
}

string TrendTostring(int t)
{
   switch (t)
   {
      case 1: return ("Buy");
      case -1: return ("Sell");
      case 0: return ("Consolidated");
   }
}

double LotsOptimized()
  {
   double lot=Lots;
   int    orders=HistoryTotal();     // history orders total
   int    losses=0;                  // number of losses orders without a break
//---- select lot size
   lot=NormalizeDouble(AccountFreeMargin()*MaximumRisk/1000.0,1);
//---- calcuulate number of losses orders without a break
   if(DecreaseFactor>0)
     {
      for(int i=orders-1;i>=0;i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
         if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL) continue;
         //----
         if(OrderProfit()>0) break;
         if(OrderProfit()<0) losses++;
        }
      if(losses>1) lot=NormalizeDouble(lot-lot*losses/DecreaseFactor,1);
     }
//---- return lot size
   if(lot<Lots) lot=Lots;
   return(lot);
  }
  
int create_multi_order(int type, string symbol, double bids, double asks, double point, string message)
  {
//----
   double tp, sl;
   double price;
   int ticket, error;
   if (type == 1) {
      price = asks + (50 * point);
      tp = price + (500 * point);
      sl = price - (300 * point);
      ticket=OrderSend(symbol,OP_BUYSTOP,0.01,price,3,sl,tp,message,255,0,CLR_NONE);
      if(ticket<1)
        {
         error=GetLastError();
         Alert("Error = ",ErrorDescription(error));
         return;
        }
      OrderPrint();
      price = asks + (100 * point);
      tp = price + (450 * point);
      sl = price - (300 * point);
      ticket=OrderSend(symbol,OP_BUYSTOP,0.04,price,3,sl,tp,message,255,0,CLR_NONE);
      if(ticket<1)
        {
         error=GetLastError();
         Alert("Error = ",ErrorDescription(error));
         return;
        }
      OrderPrint();
      price = asks + (150 * point);
      tp = price + (400 * point);
      sl = price - (300 * point);
      ticket=OrderSend(symbol,OP_BUYSTOP,0.05,price,3,sl,tp,message,255,0,CLR_NONE);
      if(ticket<1)
        {
         error=GetLastError();
         Alert("Error = ",ErrorDescription(error));
         return;
        }
      OrderPrint();
   } else if (type == -1) {
      price = bids - (50 * point);
      tp = price - (500 * point);
      sl = price + (300 * point);
      ticket=OrderSend(symbol,OP_SELLSTOP,0.01,price,3,sl,tp,message,255,0,CLR_NONE);
      if(ticket<1)
        {
         error=GetLastError();
         Alert("Error = ",ErrorDescription(error));
         return;
        }
      OrderPrint();
      price = bids - (100 * point);
      tp = price - (450 * point);
      sl = price + (300 * point);
      ticket=OrderSend(symbol,OP_SELLSTOP,0.04,price,3,sl,tp,message,255,0,CLR_NONE);
      if(ticket<1)
        {
         error=GetLastError();
         Alert("Error = ",ErrorDescription(error));
         return;
        }
      OrderPrint();
      price = bids - (150 * point);
      tp = price - (400 * point);
      sl = price + (300 * point);
      ticket=OrderSend(symbol,OP_SELLSTOP,0.05,price,3,sl,tp,message,255,0,CLR_NONE);
      if(ticket<1)
        {
         error=GetLastError();
         Alert("Error = ",ErrorDescription(error));
         return;
        }
      OrderPrint();
   }
//----
   return(0);
  }