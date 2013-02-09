//+------------------------------------------------------------------+
//|                                                    cu_heiken.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <stdlib.mqh>
#include <WinUser32.mqh>
#define MAGICMA  221
extern double Lots = 0.1;
extern bool create_order = true;
extern int pending_margin = 150;
extern int slippage = 10;
string infobox;
string orderbox;
string pendingorderbox;
int curtime;
string filename;               
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
   RefreshRates();
   string aPair = Symbol();
   int timep = Period();
   filename = "heikennewlive3a_" + Year() + "_" + Month() + "_" + Day()  + ".txt";
   double val2, val3, val4, val5;
   string tmp;
   //if (curtime != Time[0]) {
      infobox = "";
      infobox = StringConcatenate(infobox, "\n", "Current Bar Time: ", TimeToStr(Time[0]), ", Current Time: ", TimeToStr(TimeLocal()), ", Period: ", TimeframeToString(timep), ", Symbol: ", aPair,
      ", Lots: ", Lots, ", create_order: ", create_order, ", pending_margin: ", pending_margin
      , "\n");
      
         infobox = StringConcatenate(infobox, "\n", "Currency: ", aPair);
         val2 = iCustom(aPair, timep, "Heiken_Ashi_Smoothed",2,0);
         val3 = iCustom(aPair, timep, "Heiken_Ashi_Smoothed",3,0);
         val4 = iCustom(aPair, timep, "Heiken_Ashi_Smoothed",2,1);
         val5 = iCustom(aPair, timep, "Heiken_Ashi_Smoothed",3,1);
         if (val2 < val3) {
            infobox = StringConcatenate(infobox, ", ", "Current Direction: Buy");
         } else if (val2 > val3) {
            infobox = StringConcatenate(infobox, ", ", "Current Direction: Sell");
         } else {
            infobox = StringConcatenate(infobox, ", ", "Current Direction: Equal");
         }
         if (val2 < val3 && val4 > val5) {
            //Alert(aPair, "Close Sell Position and Open Buy Position");
            infobox = StringConcatenate(infobox, ", ", "Close Sell Position and Open Buy Position");
            reverse_bid(1, aPair);
            createorder(aPair, timep, 1, TimeframeToString(timep));
         } else if (val2 > val3 && val4 < val5) {
            //Alert(aPair, "Close Buy Position and Open Sell Position");
            infobox = StringConcatenate(infobox, ", ", "Close Buy Position and Open Sell Position");
            reverse_bid(-1, aPair);
            createorder(aPair, timep, -1, TimeframeToString(timep));
         } else {
            infobox = StringConcatenate(infobox, ", ", "Thinking....");
         }
      
      curtime = Time[0];
      infobox = infobox + "\n--------------------------------------------------\n\n";
      //FileAppend(filename, infobox);
   //}
   Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+


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


int reverse_bid(int type, string symbol)
{
   bool result;
   for(int cnt=0;cnt<OrdersTotal();cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol() == symbol && OrderMagicNumber()==MAGICMA
       && OrderProfit() > 0
       ) {
         if(OrderType()==OP_BUY) {
            if (type == -1) {
               Alert(symbol, ", Closing buy order");
               OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_BID),3,White);
               Alert(OrderSymbol(), ", Error closing Buy order : ",ErrorDescription(GetLastError()));
            }
         } else if (OrderType()==OP_SELL) {
            if (type == 1) {
               Alert(symbol, ", Closing sell order");
               OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_ASK),3,White);
               Alert(OrderSymbol(), ", Error closing Sell order : ",ErrorDescription(GetLastError()));
            }         
         }
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
   if (MarketInfo(symbol, MODE_SPREAD) > 150) {
      infobox = StringConcatenate(infobox, " - ", MarketInfo(symbol, MODE_SPREAD), ": Spread greater than 150");
      return (0);
   } else {
      infobox = StringConcatenate(infobox, " - Sp: ", MarketInfo(symbol, MODE_SPREAD));
   }
   int orders;
   int ordertype;
   double price;
   double val3;
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
   bids = MarketInfo(symbol, MODE_BID);
   asks = MarketInfo(symbol, MODE_ASK);
   pt = MarketInfo(symbol, MODE_POINT);
   digit = MarketInfo(symbol, MODE_DIGITS);
   bids = NormalizeDouble(bids, digit);
   asks = NormalizeDouble(asks, digit);
   if (type == 1) {
      sl = 0;
      tp = 0;
      ticket=OrderSend(symbol,OP_BUY,Lots, asks,slippage,sl,tp,message+", Heiken1.5",MAGICMA,0,Green);
      if(ticket>0)
         {
          Print("BUY order opened : ", symbol, ", ", timeperiod);
          FileAppend(filename, infobox);
         FileAppend(filename, "BUY order opened : "+symbol+", "+timeperiod);
         }
      else {
         Alert(symbol, ", Error opening BUY order : ",ErrorDescription(GetLastError()), ", price: ", price);
         createorder(symbol, timeperiod, type, message);
         return (0);
      }
      return(0); 
   } else if (type == -1) {
      sl = 0;
      tp = 0;
      ticket=OrderSend(symbol,OP_SELL,Lots, bids,slippage,sl,tp,message+", Heiken1.5",MAGICMA,0,Green);
      if(ticket>0)
         {
          Print("SELL order opened : ", symbol, ", ", timeperiod);
          FileAppend(filename, infobox);
         FileAppend(filename, "SELL order opened : "+symbol+", "+timeperiod);
         }
      else {
         Alert(symbol, ", Error opening SELL order : ",ErrorDescription(GetLastError()), ", price: ", price);
         createorder(symbol, timeperiod, type, message);
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





void FileAppend(string name,string txt)
{
   int handle = FileOpen(name,FILE_READ|FILE_WRITE);
	FileSeek(handle,0,SEEK_END);
	FileWrite(handle,txt);
	FileFlush(handle);
	FileClose(handle);
}