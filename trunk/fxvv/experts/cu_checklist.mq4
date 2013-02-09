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
extern double Lots = 0.10;
extern int InitialTrailingStop = 50;
extern int TrailingStop = 50;
int openTime[7];
int openTime2[7];
int curtime;
string infobox;
string orderbox;
string impbox;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   curtime = Time[0];
   custom_start();
   Comment(impbox, "\n", orderbox, "\n", infobox);
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
   custom_start();
   Comment(impbox, "\n", orderbox, "\n", infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+

void custom_start()
{
   
      string filename = Symbol()+"/checklist_" + Year() + "_" + Month() + "_" + Day()  + ".txt";
      trailing_stop();
      double val, val2, val3;
      infobox="";
      impbox = "";
      //infobox = StringConcatenate(infobox, "\n", "Current Time: ", TimeToStr(curtime), ", Current Bar Time: ", TimeToStr(Time[0])); 
      infobox = StringConcatenate(infobox, "\n", "Spread: ", MarketInfo(Symbol(), MODE_SPREAD)); 
      infobox = StringConcatenate(infobox, "\n", "Bid: ", DoubleToStr(Bid, Digits), ", Ask: ", DoubleToStr(Ask, Digits));
      int r1 = (iHigh(Symbol(), PERIOD_D1, 1) - iLow(Symbol(), PERIOD_D1, 1)) / Point;
      int r2 = (iHigh(Symbol(), PERIOD_D1, 2) - iLow(Symbol(), PERIOD_D1, 2)) / Point;
      int r3 = (iHigh(Symbol(), PERIOD_D1, 3) - iLow(Symbol(), PERIOD_D1, 3)) / Point;
      double r = (r1 + r2 + r3)/3;
      infobox = StringConcatenate(infobox, "\n", "Avg Range: ", r);
      infobox = StringConcatenate(infobox, ", ", "Range 1: ", r1); 
      infobox = StringConcatenate(infobox, ", ", "Range 2: ", r2);
      infobox = StringConcatenate(infobox, ", ", "Range 3: ", r3);   
      checkorder();
      int periods[7] = {PERIOD_H4, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_D1};
      int limit = 1;
      int period, period2;
      int division;
      int indecision, indecision1;
      double close1, close2;
      int result;
      for (int index = 0; index < limit; index++) {
         period = periods[index];
         switch (period) {
            case PERIOD_M5:
               period2 = PERIOD_M1;
               division = 5;
               break;
            case PERIOD_M15:
               period2 = PERIOD_M5;
               division = 3;
               break;
            case PERIOD_M30:
               period2 = PERIOD_M5;
               division = 6;
               break;
            case PERIOD_H1:
               period2 = PERIOD_M15;
               division = 4;
               break;
            case PERIOD_H4:
               period2 = PERIOD_H1;
               division = 4;
               break;
            case PERIOD_D1:
               period2 = PERIOD_H4;
               division = 6;
               break;
            case PERIOD_W1:
               period2 = PERIOD_D1;
               division = 5;
               break;
            case PERIOD_MN1:
            case PERIOD_M1:
               infobox = StringConcatenate(infobox, "\n", "Current Period is not allowed");
               return (0);
               break;
         }
         infobox = StringConcatenate(infobox, "\n\n", "Period: ", TimeframeToString(period), ", Period2: ", TimeframeToString(period2));
         
         result = 0;
         close1 = iClose(Symbol(), period2, 1);
         close2 = iClose(Symbol(), period2, division);
         infobox = StringConcatenate(infobox, "\n", "close1: ", DoubleToStr(close1, Digits), ", close2: ", DoubleToStr(close2, Digits));
         if (close2 < close1) { //means pas was lesser and current is greater so sell
            infobox = StringConcatenate(infobox, "\n", "Buy Signal");
            result = 1;
         } else if (close2 > close1) { //means pas was greater and current is lesser so sell
            infobox = StringConcatenate(infobox, "\n", "Sell Signal");
            result = -1;
         }
         if (openTime[index] != iTime(Symbol(), period, 0)) {
            openTime[index] = iTime(Symbol(), period, 0);
         }
         //strategy 1: engulfed
         val = iHigh(Symbol(), period, 1) - iLow(Symbol(), period, 1);
         val2 = iHigh(Symbol(), period, 2) - iLow(Symbol(), period, 2);
         indecision = is_indecision_candle(2, period, Symbol());
         if (val2 > val 
            && indecision == 0 
            && iHigh(Symbol(), period, 1) < iHigh(Symbol(), period, 2) 
            && iLow(Symbol(), period, 1) > iLow(Symbol(), period, 2)
           ) {
            if (openTime[index] != iTime(Symbol(), period, 0)) {
               openTime[index] = iTime(Symbol(), period, 0);
               Alert(Symbol(), ", Strategy 1 says: ", ResultToString(result), " for period: ", TimeframeToString(period));
            }
            impbox = StringConcatenate(impbox, "\n", Symbol(), ", Strategy 1 says: ", ResultToString(result), " for period: ", TimeframeToString(period));
            infobox = StringConcatenate(infobox, "\n", "Valid Sign To Enter Using Strategy 1: ", (val2 - val), " and ", indecision, " and result: ", ResultToString(result));
         }
         //strategy 2
         
         //strategy 3
         indecision1 = is_indecision_candle(1, period, Symbol());
         if (indecision1 == 1) {
            if (openTime2[index] != iTime(Symbol(), period, 0)) {
               openTime2[index] = iTime(Symbol(), period, 0);
               Alert(Symbol(), ", Strategy 3 says: (Indecision Candle) - Result ", ResultToString(result), " for period: ", TimeframeToString(period));
            }
            impbox = StringConcatenate(impbox, "\n", Symbol(), ", Strategy 3 says: (Indecision Candle) - Result ", ResultToString(result), " for period: ", TimeframeToString(period));
            infobox = StringConcatenate(infobox, "\n", "Valid Sign To Enter Using Strategy 3: Indecision Candle ", indecision1, " and result: ", ResultToString(result));
         }
      }
      
}
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

string ResultToString(int result)
{
   switch (result) {
      case 1:
         return ("Buy");
         break;
      case -1:
         return ("Sell");
         break;
      case 0:
         return ("");
         break;
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


int createorder(string symbol, int timeperiod, int type, string message, double tp, double sl)
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
   //double tp, sl;
   //tp = 0;
   //sl = 0;
   if (type == 1) {
      //sl = Ask - (200 * Point);
      //tp = 0; //Ask + (500 * Point);
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
      //sl = Bid + (200 * Point);
      //tp = 0; //Bid - (500 * Point);
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

void FileAppend(string name,string txt)
{
   int handle = FileOpen(name,FILE_READ|FILE_WRITE);
	FileSeek(handle,0,SEEK_END);
	FileWrite(handle,txt);
	FileFlush(handle);
	FileClose(handle);
}

int is_indecision_candle(int i, int period, string symbol)
{
   double top, bottom;
   double high = iHigh(symbol, period, i);
   double low = iLow(symbol, period, i);
   double open = iOpen(symbol, period, i);
   double close = iClose(symbol, period, i);
   double body = MathAbs(open - close);
   int result = 0;
   if (open > close) {
      top = high - open;
      bottom = close - low;
      result = 1;
    } else {
      top = high - close;
      bottom = open - low;
      result = -1;
    }
   double totalmove = high - low;
   if (body < (totalmove * 0.30) && (top > (totalmove * 0.50) || bottom > (totalmove * 0.50))) {
      return (1);
   }

   return (0);
}