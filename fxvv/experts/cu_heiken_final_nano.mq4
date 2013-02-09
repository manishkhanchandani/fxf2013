//+------------------------------------------------------------------+
//|                                              cu_time_blaster.mq4 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"


#include <stdlib.mqh>
#include <WinUser32.mqh>
#define MAGICMA  318
extern double Lots = 0.05;
extern int stoploss = 0;
extern int takeprofit = 600;
extern int gmt_offset = 0;
extern bool create_order = false;
extern int pending_margin = 150;
extern int maxorders = 1;
extern int maxspread = 70;
#define ARRSIZE  28


string aPair[ARRSIZE]   = {
                        "USDCHF_Nano","GBPUSD_Nano","EURUSD_Nano","USDJPY_Nano","USDCAD_Nano","AUDUSD_Nano",
                        "EURGBP_Nano","EURAUD_Nano","EURCHF_Nano","EURJPY_Nano","GBPCHF_Nano","CADJPY_Nano",
                        "GBPJPY_Nano","AUDNZD_Nano","AUDCAD_Nano","AUDCHF_Nano","AUDJPY_Nano","CHFJPY_Nano",
                        "EURNZD_Nano","EURCAD_Nano","CADCHF_Nano","NZDJPY_Nano","NZDUSD_Nano","GBPCAD_Nano",
                        "GBPNZD_Nano","GBPAUD_Nano","NZDCHF_Nano","NZDCAD_Nano"
                        };
  
string infobox;   

int hour;
int openTime;
int curtime;
string orderbox;
string pendingorderbox;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   curtime = Time[0];
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
//----;
      strength();
      Comment(orderbox, "\n", pendingorderbox, "\n", infobox);
      return (0);
//----
   return(0);
  }
//+------------------------------------------------------------------+


int createorder(string symbol, int timeperiod, int type, string message)
{
   if (curtime == Time[0]) {
      return (0);
   }

   if (IsTradeAllowed()==false)
      return (0);

   if (!create_order)
      return (0);
   
   if (MarketInfo(symbol, MODE_SPREAD) > maxspread) {
      return (0);
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
      return (0);
   }

   orders = CalculateCurrentOrders(symbol);
   if (orders > 0)
   {
      //Print("order already created for symbol: ", symbol);
       return (0);
   }
   
   orders = CalculateCurrentRealMaxOrders();
   if (orders >= maxorders)
   {
       return (0);
   }
   double bids, asks, pt, digit;
   bids = MarketInfo(symbol, MODE_BID);
            asks = MarketInfo(symbol, MODE_ASK);
            pt = MarketInfo(symbol, MODE_POINT);
            digit = MarketInfo(symbol, MODE_DIGITS);
         bids = NormalizeDouble(bids, digit);
         asks = NormalizeDouble(asks, digit);
   int ticket;
   double tp, sl;
   tp = 0;
   sl = 0;
   if (type == 1) {
      price = asks;
      if (stoploss > 0)
         sl = price - (stoploss * pt);
      if (takeprofit > 0)
         tp = price + (takeprofit * pt);
      ticket=OrderSend(symbol,OP_BUY,Lots,asks,3,sl,tp,message+", Heiken",MAGICMA,0,Green);
      if(ticket>0)
         {
         }
      else {
         Print(symbol, ", Error opening BUY order : ",ErrorDescription(GetLastError()), ", asks: ", asks);
         createorder(symbol, timeperiod, type, message);
      }
         return(0); 
   } else if (type == -1) {
      price = bids;
      if (stoploss > 0)
         sl = price + (stoploss * pt);
      if (takeprofit > 0)
         tp = price - (takeprofit * pt);

       ticket=OrderSend(symbol,OP_SELL,Lots,bids,3,sl,tp,message+", Heiken",MAGICMA,0,Red);
        if(ticket>0)
           {
           }
           else {
               Print(symbol, " Error opening Sell order : ",ErrorDescription(GetLastError()), ", price: ", bids);
               createorder(symbol, timeperiod, type, message); 
            } 
             return(0); 
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

int CalculateCurrentRealMaxOrders()
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
   int i;
//----
   for(i=0;i<OrdersTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
         if(OrderSymbol()==symbol && OrderMagicNumber()==MAGICMA)
           {
            cnt++;
           }
        }
   return (cnt);
  }

int reverse_bid(int type, string symbol)
{
   for(int cnt=0;cnt<OrdersTotal();cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol() == symbol && OrderMagicNumber()==MAGICMA
       //&& OrderProfit() > 0
       ) {
         if(OrderType()==OP_BUY) {
            if (type == -1) {
               Alert(OrderSymbol(), ", Closing buy order");
               OrderClose(OrderTicket(),OrderLots(),Bid,3,White);
            }
         } else if (OrderType()==OP_SELL) {
            if (type == 1) {
               Alert(OrderSymbol(), ", Closing sell order");
               OrderClose(OrderTicket(),OrderLots(),Ask,3,White);
            }         
         }
      }
   }
}

int strength()
{
   if (openTime != Time[0]) {
      infobox="\n";
      hour = Hour() - gmt_offset;
      if (hour < 0) {
         hour = hour + 24;
      }
      infobox="Hour: " + Hour() + ", hour new: " + hour + "\n";
      infobox = StringConcatenate(infobox, "Lots: ", Lots,
         ", stoploss: ", stoploss,
         ", takeprofit: ", takeprofit, 
         ", gmt_offset: ", gmt_offset, "\n",
         ", create_order: ", create_order, "\n",
         ", pending_margin: ", pending_margin,
         ", maxorders: ", maxorders, "\n");
      
      int    index;
      string mySymbol;
      double val2, val3, val4, val5;
      double digits, bid, ask, point;
      for (index = 0; index < ARRSIZE; index++) {
         RefreshRates();
         mySymbol = aPair[index];
         digits = MarketInfo(mySymbol, MODE_DIGITS);
         point = MarketInfo(mySymbol, MODE_POINT);
         bid = MarketInfo(mySymbol, MODE_BID);
         ask = MarketInfo(mySymbol, MODE_ASK);
         val2 = iCustom(mySymbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,1);
         val3 = iCustom(mySymbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,1);
         val4 = iCustom(mySymbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,2);
         val5 = iCustom(mySymbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,2);
         infobox = infobox + "\nVal2: " + DoubleToStr(val2, digits) + "Val3: " + DoubleToStr(val3, digits) + "Val4: " + DoubleToStr(val4, digits) + "Val5: " + DoubleToStr(val5, digits);
         infobox = infobox + "\nBid: " + DoubleToStr(bid, digits) + "Ask: " + DoubleToStr(ask, digits);
         if (val2 < val3 && val4 > val5) {
               //reverse_bid(1, mySymbol)
               createorder(mySymbol, PERIOD_H1, 1, TimeframeToString(PERIOD_H1));
               infobox = infobox + "\n" + mySymbol + ", Create Buy Order";
         } else if (val2 < val3 && val4 > val5) {
               //reverse_bid(-1, mySymbol)
               createorder(mySymbol, PERIOD_H1, -1, TimeframeToString(PERIOD_H1));
               infobox = infobox + "\n" + mySymbol + ", Create Sell Order";
         }
        
      }
      openTime = Time[0];
   }
   return (0);
}