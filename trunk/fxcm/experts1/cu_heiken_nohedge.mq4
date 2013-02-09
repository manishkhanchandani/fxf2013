//+------------------------------------------------------------------+
//|                                              cu_heiken_nohedge.mq4 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"


#include <stdlib.mqh>
#include <WinUser32.mqh>
#define MAGICMA  214
extern double Lots = 0.05;
extern int InitialTrailingStop = 100;
extern int TrailingStop = 100;
extern int stoploss = 200;
extern int takeprofit = 0;

int openTime;
int curtime;
string infobox;
string orderbox;
extern int condition = 0;
extern int condition2 = 0;
extern int condition3 = 0;
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
//----
      trailing_stop();
      double val, val2, val3, val4, val5, val6, val7, valx;
      infobox="";
      infobox = StringConcatenate(infobox, "\n", "Lots: ", Lots, ", Hour: ", Hour(), ", Day: ", Day(), ", Current Time: ", TimeToStr(curtime), ", Current Bar Time: ", TimeToStr(Time[0])); 
      infobox = StringConcatenate(infobox, "\n", "Bid: ", DoubleToStr(Bid, Digits), ", Ask: ", DoubleToStr(Ask, Digits)); 
      infobox = StringConcatenate(infobox, "\n", "Spread: ", MarketInfo(Symbol(), MODE_SPREAD));
         val2 = iCustom(NULL, PERIOD_M15, "Heiken_Ashi_Smoothed",2,0);
         val3 = iCustom(NULL, PERIOD_M15, "Heiken_Ashi_Smoothed",3,0);
         val4 = iCustom(NULL, PERIOD_M15, "Heiken_Ashi_Smoothed",2,1);
         val5 = iCustom(NULL, PERIOD_M15, "Heiken_Ashi_Smoothed",3,1);
         val6 = iCustom(NULL, PERIOD_M30, "Heiken_Ashi_Smoothed",2,0);
         val7 = iCustom(NULL, PERIOD_M30, "Heiken_Ashi_Smoothed",3,0);
         val = iCCI(NULL,PERIOD_M15,45,PRICE_CLOSE,0);
         valx = iCCI(NULL,PERIOD_M15,45,PRICE_CLOSE,1);
         infobox = StringConcatenate(infobox, "\n", "Buy Condition: ", (val2 < val3) && (val4 > val5));
         infobox = StringConcatenate(infobox, "\n", "Sell Condition: ", (val2 > val3) && (val4 < val5));
         infobox = StringConcatenate(infobox, "\n", "Buy Period 30: ", (val6 < val7));
         infobox = StringConcatenate(infobox, "\n", "Sell Period 30: ", (val6 > val7));
         infobox = StringConcatenate(infobox, "\n", "CCI 0: ", val);
         infobox = StringConcatenate(infobox, "\n", "CCI 1: ", valx);
         if (val2 < val3 
         && val4 > val5
         ) {
            condition = 1;
         } else if (val2 > val3 
            && val4 < val5
            ) {
            condition = -1;
         }
         if (val6 < val7) {
            condition2 = 1;
         } else if (val6 > val7) {
            condition2 = -1;
         }
         /*
         if (val > 100 && valx < 100) {
            condition3 = 1;
         } else if (val < -100 && valx > -100) {
            condition3 = -1;
         } else if (val < 100 && valx > 100) {
            condition3 = 0;
         } else if (val > -100 && valx < -100) {
            condition3 = 0;
         }*/
         
         infobox = StringConcatenate(infobox, "\n");
         infobox = StringConcatenate(infobox, "\n", "Condition: ", condition);
         infobox = StringConcatenate(infobox, "\n", "Condition2: ", condition2);
         //infobox = StringConcatenate(infobox, "\n", "Condition3: ", condition3);
         if (condition == 1 && condition2 == 1 
         //&& condition3 == 1
         ) {
            reverse_bid(1);
            createorder(Symbol(), Period(), 1, TimeframeToString(Period()));
         } else if (condition == -1 && condition2 == -1 
         //&& condition3 == -1
         ) {
            reverse_bid(-1);
            createorder(Symbol(), Period(), -1, TimeframeToString(Period()));
         }
      Comment(orderbox, "\n", infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+


int reverse_bid(int type)
{
   for(int cnt=0;cnt<OrdersTotal();cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol() == Symbol() && OrderMagicNumber()==MAGICMA
       //&& OrderProfit() > 0
       ) {
         if(OrderType()==OP_BUY) {
            if (type == -1) {
               Alert(Symbol(), ", Closing buy order");
               OrderClose(OrderTicket(),OrderLots(),Bid,3,White);
            }
         } else if (OrderType()==OP_SELL) {
            if (type == 1) {
               Alert(Symbol(), ", Closing sell order");
               OrderClose(OrderTicket(),OrderLots(),Ask,3,White);
            }         
         }
      }
   }
}

int createorder(string symbol, int timeperiod, int type, string message)
{
   if (curtime == Time[0]) {
      return (0);
   }

   if (IsTradeAllowed()==false)
      return (0);
      
   int orders;
   int ordertype;
   if (type == 1)
      ordertype = OP_BUY;
   else if (type == -1)
      ordertype = OP_SELL;
   else
      return (0);

   orders = CalculateCurrentOrders(symbol);
   if (orders > 0)
   {
      //Print("order already created for symbol: ", symbol);
       return (0);
   }
   double bids, asks, pt, digit;
   bids = Bid;
            asks = Ask;
            pt = Point;
            digit = Digits;
         bids = NormalizeDouble(bids, digit);
         asks = NormalizeDouble(asks, digit);
   int ticket;
   double tp, sl;
   tp = 0;
   sl = 0;
   if (type == 1) {
      if (stoploss > 0)
         sl = Ask - (stoploss * Point);
      if (takeprofit > 0)
         tp = Ask + (takeprofit * Point);
      ticket=OrderSend(symbol,OP_BUY,Lots,asks,3,sl,tp,message+", Heiken1.1",MAGICMA,0,Green);
      if(ticket>0)
         {
          if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
               condition = 0;
            //SendAlert(StringConcatenate("BUY order opened : ",OrderOpenPrice()), symbol, timeperiod);
          }
         }
      else {
         Print(symbol, ", Error opening BUY order : ",ErrorDescription(GetLastError()), ", asks: ", asks);
      }
         return(0); 
   } else if (type == -1) {
      if (stoploss > 0)
         sl = Bid + (stoploss * Point);
      if (takeprofit > 0)
         tp = Bid - (takeprofit * Point);

       ticket=OrderSend(symbol,OP_SELL,Lots,bids,3,sl,tp,message+", Heiken1.1",MAGICMA,0,Red);
        if(ticket>0)
           {
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
               condition = 0;
               //SendAlert(StringConcatenate("SELL order opened : ",OrderOpenPrice()), symbol, timeperiod);
            }
           }
           else {
               Print(symbol, " Error opening Sell order : ",ErrorDescription(GetLastError()), ", price: ", bids); 
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


int trailing_stop()
{
   //return (0);
   orderbox = "";
   orderbox = StringConcatenate(orderbox, "\nCHECKING ORDERS:");
   int cnt, ticket, total;
   total=OrdersTotal();
   double bids, asks, pt;
   int orders;
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         // for more than two orders, return as we dont support trialing stop for more orders as of now
      if(OrderType()<=OP_SELL && OrderMagicNumber()==MAGICMA && OrderSymbol() == Symbol())  // check for symbol
         {
         orderbox = StringConcatenate(orderbox, "\n", OrderSymbol(), " (", OrderProfit(), ")");
         bids = Bid;
            asks = Ask;
            pt = Point;
         orderbox = StringConcatenate(orderbox, " - ordertype: ", OrderType());
            if(OrderType()==OP_BUY) {
               if(InitialTrailingStop>0 
               && OrderProfit() > 0
               )  
               {                 
                  orderbox = StringConcatenate(orderbox, " - pt*InitialTrailingStop: ", (pt*InitialTrailingStop));
                  orderbox = StringConcatenate(orderbox, " - bids-OrderOpenPrice(): ", (bids-OrderOpenPrice()));
                  if(bids-OrderOpenPrice()>pt*InitialTrailingStop)
                  {
                     orderbox = StringConcatenate(orderbox, " - OrderStopLoss(): ", OrderStopLoss());
                     orderbox = StringConcatenate(orderbox, " - bids-pt*TrailingStop: ", (bids-pt*TrailingStop));
                     //Print(OrderSymbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", bids-pt*TrailingStop: ", (bids-pt*TrailingStop));
                     if(OrderStopLoss()<bids-pt*TrailingStop)
                     {
                        //Alert(OrderSymbol(), ", Modify Buy");
                        OrderModify(OrderTicket(),OrderOpenPrice(),bids-pt*TrailingStop,OrderTakeProfit(),0,Green);
                        return(0);
                     }
                  }
               }//end if
            } else if(OrderType()==OP_SELL) {
               // check for trailing stop
               if(InitialTrailingStop>0 
               && OrderProfit() > 0
               )  
                 {             
                  orderbox = StringConcatenate(orderbox, " - pt*InitialTrailingStop: ", (pt*InitialTrailingStop));
                  orderbox = StringConcatenate(orderbox, " - OrderOpenPrice()-asks: ", (OrderOpenPrice()-asks));    
                  if((OrderOpenPrice()-asks)>(pt*InitialTrailingStop))
                    {
                     orderbox = StringConcatenate(orderbox, " - OrderStopLoss(): ", OrderStopLoss());
                     orderbox = StringConcatenate(orderbox, " - asks+pt*TrailingStop: ", (asks+pt*TrailingStop));
                     if((OrderStopLoss()>(asks+pt*TrailingStop)) || (OrderStopLoss()==0))
                       {
                        //Alert(OrderSymbol(), ", Modify Sell");
                        OrderModify(OrderTicket(),OrderOpenPrice(),asks+pt*TrailingStop,OrderTakeProfit(),0,Red);
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

/*

int reverse_bid(int type)
{
   return (0);
   for(int cnt=0;cnt<OrdersTotal();cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol() == Symbol() && OrderMagicNumber()==MAGICMA
       //&& OrderProfit() > 0
       ) {
         if(OrderType()==OP_BUY) {
            if (type == -1) {
               Alert(Symbol(), ", Closing buy order");
               OrderClose(OrderTicket(),OrderLots(),Bid,3,White);
            }
         } else if (OrderType()==OP_SELL) {
            if (type == 1) {
               Alert(Symbol(), ", Closing sell order");
               OrderClose(OrderTicket(),OrderLots(),Ask,3,White);
            }         
         }
      }
   }
}*/