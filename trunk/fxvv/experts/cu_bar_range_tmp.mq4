//+------------------------------------------------------------------+
//|                                                    cu_bar_range.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <stdlib.mqh>
#include <WinUser32.mqh>
#define MAGICMA  211
extern double Lots = 0.10;
extern int InitialTrailingStop = 50;
extern int TrailingStop = 50;
extern bool markethours = true;
extern int gmt_offset = 3;
int opentime, opentime2;
int curtime;
string infobox;
string orderbox;
int buy;
int sell;
int result, result2;
int newbar;
int hour;
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
      string filename = Symbol()+"/barrange_" + Year() + "_" + Month() + "_" + Day()  + ".txt";
      trailing_stop();
      double val, val2, val3;
      infobox="";
      infobox = StringConcatenate(infobox, "\n", "Current Time: ", TimeToStr(curtime), ", Current Bar Time: ", TimeToStr(Time[0])); 
      infobox = StringConcatenate(infobox, "\n", "Bid: ", DoubleToStr(Bid, Digits), ", Ask: ", DoubleToStr(Ask, Digits)); 
      hour = Hour() - gmt_offset;
      infobox="\nHour: " + Hour() + ", hour new: " + hour + "\n";
      checkorder();
      if (markethours) {
         if (hour == 0 || hour == 1 || hour == 7 || hour == 8 || hour == 13 || hour == 14) {
   
         } else {
            infobox = StringConcatenate(infobox, "Working hours are 0, 1, 7, 8, 13, 14\n", "\n");
         }
      }
      int period = PERIOD_H1;
      
      if (newbar != iTime(Symbol(), period, 0)) {
         newbar = iTime(Symbol(), period, 0);
         result = 0;
         buy = 0;
         sell = 0;
         result2 = 0;      
      }
   
      result = 0;
      result2 = 0;
      double high, low, currentopen, currentbuy, currentsell, twentyfivepercent, totalmove, tenpercent;
      high = iHigh(Symbol(), period, 1);
      low = iLow(Symbol(), period, 1);
      totalmove = high - low;
      twentyfivepercent = totalmove * 0.25;
      tenpercent = totalmove * 0.10;
      currentopen = iOpen(Symbol(), period, 0);
      currentbuy = currentopen + twentyfivepercent;
      currentsell = currentopen - twentyfivepercent;
      if (MarketInfo(Symbol(), MODE_BID) > (currentopen + tenpercent)) {
         buy = 1;
         if (sell == 1 && opentime != iTime(Symbol(), period, 0)) {
            result = 1;
            opentime = iTime(Symbol(), period, 0);
         }
      } else if (MarketInfo(Symbol(), MODE_BID) < (currentopen - tenpercent)) {
         sell = 1;
         if (buy == 1 && opentime != iTime(Symbol(), period, 0)) {
            result = -1;
            opentime = iTime(Symbol(), period, 0);
         }
      } 
      if (MarketInfo(Symbol(), MODE_BID) > (currentopen + twentyfivepercent) && opentime2 != iTime(Symbol(), period, 0)) {
         result2 = 1;
         opentime2 = iTime(Symbol(), period, 0);
      } else if (MarketInfo(Symbol(), MODE_BID) < (currentopen - twentyfivepercent) && opentime2 != iTime(Symbol(), period, 0)) {
         result2 = -1;
         opentime2 = iTime(Symbol(), period, 0);
      } 
      if (result == 1) {
         Lots = 1.00;
         createorder(Symbol(), period, 1, TimeframeToString(period));
      } else if (result == -1) {
         Lots = 1.00;
         createorder(Symbol(), period, -1, TimeframeToString(period));
      }
      if (result2 == 1) {
         Lots = 1.05;
         createorder(Symbol(), period, 1, TimeframeToString(period));
      } else if (result2 == -1) {
         Lots = 1.05;
         createorder(Symbol(), period, -1, TimeframeToString(period));
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
      
      if (markethours) {
         if (hour == 0 || hour == 1 || hour == 7 || hour == 8 || hour == 13 || hour == 14) {
   
         } else {
            return (0);
         }
      }
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
      tp = Ask + (500 * Point);
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
      tp = Bid - (500 * Point);
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