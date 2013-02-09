//+------------------------------------------------------------------+
//|                                                    cu_heiken.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <stdlib.mqh>
#include <WinUser32.mqh>
#define MAGICMA  219
extern double Lots1 = 0.01;
extern double Lots2 = 0.50;
extern int initial_direction = 0;
extern bool create_order = true;
extern int pending_margin = 100;
extern int slippage = 10;
int openTime;
string infobox;
string orderbox;
string pendingorderbox;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   if (initial_direction == 0) {
      double val, val2, val3;
      val2 = iCustom(NULL, Period(), "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(NULL, Period(), "Heiken_Ashi_Smoothed",3,0);
      if (val2 < val3) {
         initial_direction = 1;
      } else if (val2 > val3) {
         initial_direction = -1;
      }
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
      string filename = Symbol()+"/heiken_" + Year() + "_" + Month() + "_" + Day()  + ".txt";
      cleanup_pending_orders(Symbol());
      double val, val2, val3;
      int i;
      infobox="";
      infobox = StringConcatenate(infobox, "\n", "Current Bar Time: ", TimeToStr(Time[0])); 
      infobox = StringConcatenate(infobox, "\n", "Bid: ", DoubleToStr(Bid, Digits), ", Ask: ", DoubleToStr(Ask, Digits)); 
      infobox = StringConcatenate(infobox, "\n", "Direction: ", initial_direction);
      int condition[7];
      int period[7] = {PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4, PERIOD_D1};
      for (i = 0; i < 7; i++) {
         val2 = iCustom(NULL, period[i], "Heiken_Ashi_Smoothed",2,0);
         val3 = iCustom(NULL, period[i], "Heiken_Ashi_Smoothed",3,0);
         if (val2 < val3) {
            condition[i] = 1;
         } else if (val2 > val3) {
            condition[i] = -1;
         } else {
            condition[i] = 0;
         }
         infobox = StringConcatenate(infobox, "\n", "Period: ", TimeframeToString(period[i]), ", Condition: ", condition[i]);
         if (period[i] == Period())
            break;
      }
      bool condition_buy = true;
      bool condition_sell = true;
      for (i = 0; i < 7; i++) {
         if (condition[i] == 1 && condition_buy) {
            condition_buy = true;
         } else {
            condition_buy = false;
         }
         if (condition[i] == -1 && condition_sell) {
            condition_sell = true;
         } else {
            condition_sell = false;
         }
         if (period[i] == Period())
            break;
      }
      string name = "obj"+Time[0];
      infobox = StringConcatenate(infobox, "\n", "Condition Buy: ", condition_buy, ", Condition Sell: ", condition_sell);
      if (initial_direction == -1 && condition_buy) {
         infobox = StringConcatenate(infobox, "\n", "Create Buy Order and close all sell order if open and positive");
         drawLabel(name, Bid, Green);
         initial_direction = 1;
         //close sell order if positive
         reverse_bid(1);
         //create buy order
         createorder(Symbol(), Period(), 1, TimeframeToString(Period()));
      } else if (initial_direction == 1 && condition_sell) {
         infobox = StringConcatenate(infobox, "\n", "Create Sell Order and close all buy order if open and positive");
         drawLabel(name, Bid, Red);
         initial_direction = -1;
         //close buy order if positive
         reverse_bid(-1);
         //create sell order
         createorder(Symbol(), Period(), -1, TimeframeToString(Period()));
      }
      Comment(orderbox, "\n", infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+


void drawLabel(string name,double lvl,color Color)
{
   return (0);
    if(ObjectFind(name) != 0)
    {
        ObjectCreate(name,OBJ_ARROW,0,Time[0],lvl);
        ObjectSet(name,OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
        ObjectSet(name, OBJPROP_COLOR, Color);
    }
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


int reverse_bid(int type)
{
   bool result;
   for(int cnt=0;cnt<OrdersTotal();cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol() == Symbol() && OrderMagicNumber()==MAGICMA
       && OrderProfit() > 0
       ) {
         if(OrderType()==OP_BUY) {
            if (type == -1) {
               Alert(Symbol(), ", Closing buy order");
               OrderClose(OrderTicket(),OrderLots(),Bid,3,White);
               Alert(OrderSymbol(), ", Error closing Buy order : ",ErrorDescription(GetLastError()));
            }
         } else if (OrderType()==OP_SELL) {
            if (type == 1) {
               Alert(Symbol(), ", Closing sell order");
               OrderClose(OrderTicket(),OrderLots(),Ask,3,White);
               Alert(OrderSymbol(), ", Error closing Sell order : ",ErrorDescription(GetLastError()));
            }         
         }
      } else if((OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP) && OrderSymbol() == Symbol() && OrderMagicNumber()==MAGICMA) {
         result=OrderDelete(OrderTicket());
         if(result!=TRUE) Print("LastError = ", GetLastError());
      }
   }
}


int createorder(string symbol, int timeperiod, int type, string message)
{

   if (IsTradeAllowed()==false) {
      Print(Symbol(), " trading is not allowed");
      return (0);
   }
   if (!create_order) {
      Print(Symbol(), " manual trading is not allowed");
      return (0);
   }
   if(DayOfWeek()==0 || DayOfWeek()==6) {
      infobox = StringConcatenate(infobox, "Holiday so no trading");
      return (0);
   }
   if (MarketInfo(symbol, MODE_SPREAD) > 100) {
      infobox = StringConcatenate(infobox, " - ", MarketInfo(symbol, MODE_SPREAD), ": Spread greater than 100");
      return (0);
   } else {
      infobox = StringConcatenate(infobox, " - Sp: ", MarketInfo(symbol, MODE_SPREAD));
   }
   int orders;
   int ordertype;
   double price;
   double val3;
   double Lots = Lots1 + Lots2;
   if (type == 1) {
      ordertype = OP_BUY;
      val3 = AccountFreeMarginCheck(symbol, OP_BUY, Lots);
      if (val3 < pending_margin) {
         return (0);
      }
   } else if (type == -1) {
      ordertype = OP_SELL;
      val3 = AccountFreeMarginCheck(symbol, OP_SELL, Lots);
      if (val3 < pending_margin) {
         return (0);
      }
   } else {
      Print(Symbol(), " - Free Margin is less");
      return (0);
   }
   orders = CalculateCurrentOrders(symbol, ordertype);
   if (orders > 0)
   {
      //Print(Symbol(), " - Order Already created");
       return (0);
   }
   double bids, asks, pt, digit;
   int ticket;
   double tp, sl;
   tp = 0;
   sl = 0;
   RefreshRates();
   bids = Bid;
   asks = Ask;
   pt = Point;
   digit = Digits;
   bids = NormalizeDouble(bids, digit);
   asks = NormalizeDouble(asks, digit);
   if (type == 1) {
      sl = asks - (150 * Point);
      tp = asks + (10 * Point);
      ticket=OrderSend(symbol,OP_BUY,Lots1,asks,slippage,sl,tp,message+", Heiken1.1",MAGICMA,0,Green);
      if(ticket>0)
         {
          Print("BUY order opened : ", symbol, ", ", timeperiod);
         }
      else {
         Alert(symbol, ", Error opening BUY order : ",ErrorDescription(GetLastError()), ", asks: ", asks);
         return (0);
      }
      price = asks + (50 * pt);
      sl = 0;
      tp = 0;
      ticket=OrderSend(symbol,OP_BUYSTOP,Lots2, price,slippage,sl,tp,message+", Heiken1.1",MAGICMA,0,Green);
      if(ticket>0)
         {
          Print("BUYSTOP order opened : ", symbol, ", ", timeperiod);
         }
      else {
         Alert(symbol, ", Error opening BUY order : ",ErrorDescription(GetLastError()), ", price: ", price);
         return (0);
      }
      return(0); 
   } else if (type == -1) {
      sl = bids + (150 * Point);
      tp = bids - (10 * Point);
      ticket=OrderSend(symbol,OP_SELL,Lots1,bids,slippage,sl,tp,message+", Heiken1.1",MAGICMA,0,Green);
      if(ticket>0)
         {
          Print("Sell order opened : ", symbol, ", ", timeperiod);
         }
      else {
         Alert(symbol, ", Error opening sell order : ",ErrorDescription(GetLastError()), ", bids: ", bids);
         return (0);
      }
      price = bids - (50 * pt);
      sl = 0;
      tp = 0;
      ticket=OrderSend(symbol,OP_SELLSTOP,Lots2, price,slippage,sl,tp,message+", Heiken1.1",MAGICMA,0,Green);
      if(ticket>0)
         {
          Print("SELLSTOP order opened : ", symbol, ", ", timeperiod);
         }
      else {
         Alert(symbol, ", Error opening SELL order : ",ErrorDescription(GetLastError()), ", price: ", price);
         return (0);
      }
      return(0); 
   }
}


int CalculateCurrentOrders(string symbol, int type)
  {
   int cnt=0;
   int i;
//----
   for(i=0;i<OrdersTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
         if (type == OP_BUY) {
            if(OrderSymbol()==symbol && (OrderType() == OP_BUY || OrderType() == OP_BUYSTOP) && OrderMagicNumber()==MAGICMA)
              {
               cnt++;
              }
          } else if (type == OP_SELL) {
            if(OrderSymbol()==symbol && (OrderType() == OP_SELL || OrderType() == OP_SELLSTOP) && OrderMagicNumber()==MAGICMA)
              {
               cnt++;
              }
          }
        }
   return (cnt);
  }



void cleanup_pending_orders(string symbol)
{
   double bids, asks, pt, digit;
   pendingorderbox = "";
   pendingorderbox = StringConcatenate(pendingorderbox, "\nCHECKING PENDING ORDERS:");
   int cnt, ticket, total;
   string deletemsg;
   total=OrdersTotal();
   bool result;
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if((OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP) && OrderSymbol() == symbol) {
         RefreshRates();
         bids = MarketInfo(OrderSymbol(), MODE_BID);
         asks = MarketInfo(OrderSymbol(), MODE_ASK);
         pt = MarketInfo(OrderSymbol(), MODE_POINT);
         digit = MarketInfo(OrderSymbol(), MODE_DIGITS);
         deletemsg = "";
         if(OrderType()==OP_BUYSTOP) {
            if ((OrderOpenPrice() - asks)/pt > 100) {
               deletemsg = ", Delete Pending Buy Order";
               result=OrderDelete(OrderTicket());
               if(result!=TRUE) Print("LastError = ", GetLastError());
            }
            pendingorderbox = StringConcatenate(pendingorderbox, "\nSymbol: ", OrderSymbol(), ", Price: ", DoubleToStr(OrderOpenPrice(), digit)
               , ", (OrderOpenPrice() - bids)/pt: "
               , (OrderOpenPrice() - asks)/pt
               , deletemsg
            ); 
         } else if(OrderType()==OP_SELLSTOP) {
            if ((bids-OrderOpenPrice())/pt > 100) {
               deletemsg = ", Delete Pending Sell Order";
               result=OrderDelete(OrderTicket());
               if(result!=TRUE) Print("LastError = ", GetLastError());
            }
            pendingorderbox = StringConcatenate(pendingorderbox, "\nSymbol: ", OrderSymbol(), ", Price: ", DoubleToStr(OrderOpenPrice(), digit)
               , ", (asks-OrderOpenPrice())/pt: "
               , (bids-OrderOpenPrice())/pt
               , deletemsg
            ); 
         }
      }
   } 
}

