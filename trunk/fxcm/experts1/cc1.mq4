//+------------------------------------------------------------------+
//|                                                    cc1.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <stdlib.mqh>
#include <WinUser32.mqh>
#define MAGICMA  211
extern double Lots = 0.02;
extern int InitialTrailingStop = 150;
extern int TrailingStop = 150;
extern int stoploss = 0;
extern int takeprofit = 0;
extern bool customTrend = false;
extern bool customTrendBuy = false;
extern bool customTrendSell = false;
extern bool create_order = true;

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
//----
      string filename = Symbol()+"/cc1b_" + Year() + "_" + Month() + "_" + Day()  + ".txt";
      trailing_stop();
      double val, val2, val3;
      infobox="";
      infobox = StringConcatenate(infobox, "\n", "Lots: ", Lots, ", Hour: ", Hour(), ", Day: ", Day(), ", Current Time: ", TimeToStr(curtime), ", Current Bar Time: ", TimeToStr(Time[0]), ", create_order: ", create_order); 
      infobox = StringConcatenate(infobox, "\n", "Bid: ", DoubleToStr(Bid, Digits), ", Ask: ", DoubleToStr(Ask, Digits)); 
      infobox = StringConcatenate(infobox, "\n", "customTrend: ", customTrend, ", customTrendBuy: ", customTrendBuy, ", customTrendSell: ", customTrendSell);
      checkorder();
      int condition[9];
      int condition2[9];
      int condition3[9];
      int condition4[9];
      double adx;
      int period[5] = {PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4, PERIOD_D1};
      for (int i = 0; i < 7; i++) {
         val = iCCI(NULL,period[i],45,PRICE_CLOSE,0);
         if (val > 100) {
            condition2[i] = 1;
         } else if (val < -100) {
            condition2[i] = -1;
         } else {
            condition2[i] = 0;
         }
         //val2 = iCustom(NULL, period[i], "Heiken_Ashi_Smoothed",2,0);
         //val3 = iCustom(NULL, period[i], "Heiken_Ashi_Smoothed",3,0);
         //if (val2 < val3) {
            //condition[i] = 1;
         //} else if (val2 > val3) {
            //condition[i] = -1;
         //} else {
            //condition[i] = 0;
         //}
         
         //val2 = iCustom(NULL, period[i], "MACD_Complete",1,0);
         //val3 = iCustom(NULL, period[i], "MACD_Complete",2,0);
         //if (val2 > val3) {
            //condition3[i] = 1;
         //} else if (val2 < val3) {
            //condition3[i] = -1;
         //} else {
            //condition3[i] = 0;
         //}
         //val = iRSI(NULL,period[i],7,PRICE_CLOSE,0);
         //if (val > 70) {
            //condition4[i] = 1;
         //} else if (val < 30) {
            //condition4[i] = -1;
         //} else {
            //condition4[i] = 0;
         //}
         //adx = iADX(NULL,period[i],14,PRICE_TYPICAL,MODE_MAIN,0);
         infobox = StringConcatenate(infobox, "\n", "Period: ", TimeframeToString(period[i]), ", CCI: ", condition2[i], ", Heiken: ", condition[i],
         ", MACD: ", condition3[i],
         ", RSI: ", condition4[i],
         ", ADX: ", DoubleToStr(adx, Digits)
         );
      }
      string name = "obj"+Time[0];
      bool buy = true;
      bool sell = true;
      if (customTrend && !customTrendBuy) {
         buy = false;
      }
      if (customTrend && !customTrendSell) {
         sell = false;
      }
      if (
         condition2[0] == 1
         && condition2[1] == 1
         && condition2[2] == 1
         && condition2[3] == 1
         && condition2[4] == 1
         //&& condition3[0] == 1
         //&& condition3[1] == 1
         //&& condition3[2] == 1
         //&& condition3[3] == 1
         //&& condition3[4] == 1
         && buy
      ) {
         reverse_bid(1);
         FileAppend(filename, "Buy: " + TimeToStr(TimeCurrent()) + ", Bid: " + Bid + ", Ask: " + Ask + ", Spread: " + MarketInfo(Symbol(), MODE_SPREAD));
         FileAppend(filename, "");
         FileAppend(filename, "Create Buy order for symbol: " + Symbol());
         FileAppend(filename, 
            "C:" + condition2[0] + "," + condition2[1] + "," + condition2[2] + "," + condition2[3] + "," + condition2[4] + "," + condition2[5] + "," + condition2[6] +
            ",H:" + condition[0] + "," + condition[1] + "," + condition[2] + "," + condition[3] + "," + condition[4] + "," + condition[5] + "," + condition[6] +
            ",M:" + condition3[0] + "," + condition3[1] + "," + condition3[2] + "," + condition3[3] + "," + condition3[4] + "," + condition3[5] + "," + condition3[6] +
            ",R:" + condition4[0] + "," + condition4[1] + "," + condition4[2] + "," + condition4[3] + "," + condition4[4] + "," + condition4[5] + "," + condition4[6]);
         FileAppend(filename, "");
         createorder(Symbol(), Period(), 1, TimeframeToString(Period()));
      } else if(
         condition2[0] == -1
         && condition2[1] == -1
         && condition2[2] == -1
         && condition2[3] == -1
         && condition2[4] == -1
         //&& condition3[0] == -1
         //&& condition3[1] == -1
         //&& condition3[2] == -1
         //&& condition3[3] == -1
         //&& condition3[4] == -1
         && sell
      ) {
         reverse_bid(-1);
         FileAppend(filename, "");
         FileAppend(filename, "Sell: " + TimeToStr(TimeCurrent()) + ", Bid: " + Bid + ", Ask: " + Ask + ", Spread: " + MarketInfo(Symbol(), MODE_SPREAD));
         FileAppend(filename, 
            "C:" + condition2[0] + "," + condition2[1] + "," + condition2[2] + "," + condition2[3] + "," + condition2[4] + "," + condition2[5] + "," + condition2[6] +
            ",H:" + condition[0] + "," + condition[1] + "," + condition[2] + "," + condition[3] + "," + condition[4] + "," + condition[5] + "," + condition[6] +
            ",M:" + condition3[0] + "," + condition3[1] + "," + condition3[2] + "," + condition3[3] + "," + condition3[4] + "," + condition3[5] + "," + condition3[6] +
            ",R:" + condition4[0] + "," + condition4[1] + "," + condition4[2] + "," + condition4[3] + "," + condition4[4] + "," + condition4[5] + "," + condition4[6]);
         FileAppend(filename, "");
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
       && OrderProfit() > 0
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

// wrong Time
//5, 12

//right Time
//
int createorder(string symbol, int timeperiod, int type, string message)
{
   if (curtime == Time[0]) {
      return (0);
   }

   if (IsTradeAllowed()==false)
      return (0);
      
   if (!create_order) {
      Print(Symbol(), ", create order is false");
       return (0);
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
      if (stoploss > 0)
         sl = Ask - (stoploss * Point);
      //else
         //sl = Ask - (200 * Point);
      if (takeprofit > 0)
         tp = Ask + (takeprofit * Point);
      //else
         //tp = Ask + (500 * Point);
      ticket=OrderSend(symbol,OP_BUY,Lots,asks,3,sl,tp,message+", 1.4",MAGICMA,0,Green);
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
      if (stoploss > 0)
         sl = Bid + (stoploss * Point);
      //else
         //sl = Bid + (200 * Point);
      if (takeprofit > 0)
         tp = Bid - (takeprofit * Point);
      //else
         //tp = Bid - (500 * Point);

       ticket=OrderSend(symbol,OP_SELL,Lots,bids,3,sl,tp,message+", 1.4",MAGICMA,0,Red);
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


void create_label(string name, string text)
{
   if (ObjectCreate(name, OBJ_LABEL, 0, Time[0], Bid)) {
      ObjectSetText(name, text, 10, "Verdana", White);
   }
}