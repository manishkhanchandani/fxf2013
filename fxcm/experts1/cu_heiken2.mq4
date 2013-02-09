//+------------------------------------------------------------------+
//|                                                    cu_heiken.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <stdlib.mqh>
#include <WinUser32.mqh>
#define MAGICMA  211
extern double Lots = 0.05;
int openTime;
int curtime;
string infobox;
string orderbox;
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
  return(0);
//----
      string filename = Symbol()+"/heiken2b_" + Year() + "_" + Month() + "_" + Day()  + ".txt";
      trailing_stop();
      double val, val2, val3;
      infobox="";
      infobox = StringConcatenate(infobox, "\n", "Current Time: ", TimeToStr(curtime), ", Current Bar Time: ", TimeToStr(Time[0])); 
      infobox = StringConcatenate(infobox, "\n", "Bid: ", DoubleToStr(Bid, Digits), ", Ask: ", DoubleToStr(Ask, Digits)); 
      checkorder();
      int condition[9];
      int condition2[9];
      int period[5] = {PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1};
      for (int i = 0; i < 5; i++) {
         val = iCCI(NULL,period[i],45,PRICE_CLOSE,0);
         if (val > 100) {
            condition2[i] = 1;
         } else if (val < -100) {
            condition2[i] = -1;
         } else {
            condition2[i] = 0;
         }
         val2 = iCustom(NULL, period[i], "Heiken_Ashi_Smoothed",2,0);
         val3 = iCustom(NULL, period[i], "Heiken_Ashi_Smoothed",3,0);
         if (val2 < val3) {
            condition[i] = 1;
         } else if (val2 > val3) {
            condition[i] = -1;
         } else {
            condition[i] = 0;
         }
         infobox = StringConcatenate(infobox, "\n", "Period: ", TimeframeToString(period[i]), ", Condition: ", condition[i], ", Condition2: ", condition2[i]);
      }
      string name = "obj"+Time[0];
      if (
         condition[0] == 1
         && condition[1] == 1
         && condition[2] == 1
         && condition[3] == 1
         && condition[4] == 1
         && condition2[0] == 1
         && condition2[1] == 1
         && condition2[2] == 1
         && condition2[3] == 1
         && condition2[4] == 1
      ) {
         reverse_bid(1);
         drawLabel(name, Bid, Green);
         FileAppend(filename, "Buy: " + TimeToStr(TimeCurrent()) + ", Bid: " + Bid + ", Ask: " + Ask + ", Spread: " + MarketInfo(Symbol(), MODE_SPREAD));
         createorder(Symbol(), Period(), 1, TimeframeToString(Period()));
      } else if(
         condition[0] == -1
         && condition[1] == -1
         && condition[2] == -1
         && condition[3] == -1
         && condition[4] == -1
         && condition2[0] == -1
         && condition2[1] == -1
         && condition2[2] == -1
         && condition2[3] == -1
         && condition2[4] == -1
      ) {
         reverse_bid(-1);
         drawLabel(name, Bid, Red);
         FileAppend(filename, "Sell: " + TimeToStr(TimeCurrent()) + ", Bid: " + Bid + ", Ask: " + Ask + ", Spread: " + MarketInfo(Symbol(), MODE_SPREAD));
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

void checkorder()
{
   for(int cnt=0;cnt<OrdersTotal();cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol() == Symbol() && OrderMagicNumber()==MAGICMA) {
         infobox = StringConcatenate(infobox, "\n", "Order Profit for symbol ", OrderSymbol(), " is ", OrderProfit());
      }
   }
}

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
      sl = Ask - (200 * Point);
      tp = 0; //Ask + (500 * Point);
      ticket=OrderSend(symbol,OP_BUY,Lots,asks,3,sl,tp,message+", 1.3",MAGICMA,0,Green);
      //ticket=OrderSend(symbol,OP_BUYSTOP,Lots, asks,3,sl,tp,message+", 1.1",MAGICMA,0,Green);
      if(ticket>0)
         {
          if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
            //SendAlert(StringConcatenate("BUY order opened : ",OrderOpenPrice()), symbol, timeperiod);
          }
         }
      else {
         Print(symbol, ", Error opening BUY order : ",ErrorDescription(GetLastError()), ", asks: ", asks);
      }
         return(0); 
   } else if (type == -1) {
      sl = Bid + (200 * Point);
      tp = 0; //Bid - (500 * Point);
       ticket=OrderSend(symbol,OP_SELL,Lots,bids,3,sl,tp,message+", 1.3",MAGICMA,0,Red);
       //ticket=OrderSend(symbol,OP_SELLSTOP,Lots, bids,3,sl,tp,message+", 1.1",MAGICMA,0,Red);
        if(ticket>0)
           {
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
               //SendAlert(StringConcatenate("SELL order opened : ",OrderOpenPrice()), symbol, timeperiod);
            }
           }
           else {
               Print(symbol, " Error opening Sell order : ",ErrorDescription(GetLastError()), ", price: ", bids); 
            } 
             return(0); 
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
   int InitialTrailingStop = 500;
   int TrailingStop = 100;
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
                  orderbox = StringConcatenate(orderbox, " - asks-OrderOpenPrice(): ", (asks-OrderOpenPrice()));
                  if(asks-OrderOpenPrice()>pt*InitialTrailingStop)
                  {
                     orderbox = StringConcatenate(orderbox, " - OrderStopLoss(): ", OrderStopLoss());
                     orderbox = StringConcatenate(orderbox, " - asks-pt*TrailingStop: ", (asks-pt*TrailingStop));
                     //Print(OrderSymbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", asks-pt*TrailingStop: ", (asks-pt*TrailingStop));
                     if(OrderStopLoss()<asks-pt*TrailingStop)
                     {
                        //Alert(OrderSymbol(), ", Modify Buy");
                        OrderModify(OrderTicket(),OrderOpenPrice(),asks-pt*TrailingStop,OrderTakeProfit(),0,Green);
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
                  orderbox = StringConcatenate(orderbox, " - OrderOpenPrice()-bids: ", (OrderOpenPrice()-bids));    
                  if((OrderOpenPrice()-bids)>(pt*InitialTrailingStop))
                    {
                     orderbox = StringConcatenate(orderbox, " - OrderStopLoss(): ", OrderStopLoss());
                     orderbox = StringConcatenate(orderbox, " - bids+pt*TrailingStop: ", (bids+pt*TrailingStop));
                     if((OrderStopLoss()>(bids+pt*TrailingStop)) || (OrderStopLoss()==0))
                       {
                        //Alert(OrderSymbol(), ", Modify Sell");
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

void FileAppend(string name,string txt)
{
   int handle = FileOpen(name,FILE_READ|FILE_WRITE);
	FileSeek(handle,0,SEEK_END);
	FileWrite(handle,txt);
	FileFlush(handle);
	FileClose(handle);
}