//+------------------------------------------------------------------+
//|                                                    cu_heiken.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <stdlib.mqh>
#include <WinUser32.mqh>
#define MAGICMA  16385
extern double Lots = 0.05;
int openTime;
int previous_condition;
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
      string infobox="";
      int condition[9];
      int period[4] = {PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1};
      for (int i = 0; i < 4; i++) {
         val2 = iCustom(NULL, period[i], "Heiken_Ashi_Smoothed",2,0);
         val3 = iCustom(NULL, period[i], "Heiken_Ashi_Smoothed",3,0);
         if (val2 < val3) {
            condition[i] = 1;
            if (period[i] == PERIOD_H1) {
               reverse_bid(1);
            }
         } else if (val2 > val3) {
            condition[i] = -1;
            if (period[i] == PERIOD_H1) {
               reverse_bid(-1);
            }
         } else {
            condition[i] = 0;
         }
      }
      if (
         condition[0] == 1
         && condition[1] == 1
         && condition[2] == 1
         && condition[3] == 1
         && previous_condition == -1
      ) {
         createorder(Symbol(), Period(), 1, TimeframeToString(period));
      } else if(
         condition[0] == -1
         && condition[1] == -1
         && condition[2] == -1
         && condition[3] == -1
         && previous_condition == 1
      ) {
         createorder(Symbol(), Period(), -1, TimeframeToString(period));
      }
      previous_condition = condition[0];
      int period = Period();
      int period2;
      switch(period)
      {
         case PERIOD_M1:  period2 = PERIOD_M5; break;
         case PERIOD_M5:  period2 = PERIOD_M15; break;
         case PERIOD_M15: period2 = PERIOD_M30; break;
         case PERIOD_M30: period2 = PERIOD_H1; break;
         case PERIOD_H1:  period2 = PERIOD_H4; break;
         case PERIOD_H4:  period2 = PERIOD_D1; break;
         case PERIOD_D1:  return (0); break;
         case PERIOD_W1:  return (0); break;
         case PERIOD_MN1: return (0); break;
      }
      infobox = StringConcatenate(infobox, "\n\nPeriod: ", TimeframeToString(period), ", Period 2: ", TimeframeToString(period2));
      double val2 = iCustom(NULL, period, "Heiken_Ashi_Smoothed",2,1);
      double val3 = iCustom(NULL, period, "Heiken_Ashi_Smoothed",3,1);
      double val4 = iCustom(NULL, period, "Heiken_Ashi_Smoothed",2,2);
      double val5 = iCustom(NULL, period, "Heiken_Ashi_Smoothed",3,2);
      
      //datetime some_time=StrToTime(TimeToStr(Time[1]));
      //int shift=iBarShift(NULL,PERIOD_M5,some_time);
      double val6 = iCustom(NULL, period2, "Heiken_Ashi_Smoothed",2,1);
      double val7 = iCustom(NULL, period2, "Heiken_Ashi_Smoothed",3,1);
      double val8 = iCustom(NULL, period2, "Heiken_Ashi_Smoothed",2,2);
      double val9 = iCustom(NULL, period2, "Heiken_Ashi_Smoothed",3,2);
      string name = "obj"+Time[0];
      if (val6 < val7) {
         infobox = StringConcatenate(infobox, "\n\nTrend: Buy");
      } else if (val6 > val7) {
         infobox = StringConcatenate(infobox, "\n\nTrend: Sell");
      }
      if (val2 < val3 && val4 > val5 && val6 < val7) {
         infobox = StringConcatenate(infobox, "\nEnter Buy");
         drawLabel(name, Bid, Green);
         //createorder(Symbol(), Period(), 1, TimeframeToString(period));
         if (openTime != Time[0]) {
            Alert(Symbol(), "Enter Buy");
            openTime = Time[0];
         }
      } else if (val2 > val3 && val4 < val5 && val6 > val7) {
         infobox = StringConcatenate(infobox, "\nEnter Sell");
         drawLabel(name, Bid, Green);
         //createorder(Symbol(), Period(), -1, TimeframeToString(period));
         if (openTime != Time[0]) {
            Alert(Symbol(), "Enter Sell");
            openTime = Time[0];
         }
      } 
      if (val2 > val3 && val4 < val5) {
         infobox = StringConcatenate(infobox, "\nExit Buy");
         drawLabel(name, Bid, Red);
         //reverse_bid(-1);
         if (openTime != Time[0]) {
            Alert(Symbol(), "Exit Buy");
            openTime = Time[0];
         }
      } else if (val2 < val3 && val4 > val5) {
         infobox = StringConcatenate(infobox, "\nExit Sell");
         drawLabel(name, Bid, Red);
         //reverse_bid(1);
         if (openTime != Time[0]) {
            Alert(Symbol(), "Exit Sell");
            openTime = Time[0];
         }
      } 
      Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+


void drawLabel(string name,double lvl,color Color)
{
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
   return (0);
   for(int cnt=0;cnt<OrdersTotal();cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol() == Symbol() && OrderMagicNumber()==MAGICMA && OrderProfit() > 0) {
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
   return (0);
   if (IsTradeAllowed()==false)
      return (0);
      
   int orders;
   orders = CalculateCurrentOrders(symbol);
   if (orders > 0)
   {
      Print("order already created for symbol: ", symbol);
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
       ticket=OrderSend(symbol,OP_BUY,Lots,asks,3,sl,tp,message,MAGICMA,0,Green);
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
       ticket=OrderSend(symbol,OP_SELL,Lots,bids,3,sl,tp,message,MAGICMA,0,Red);
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