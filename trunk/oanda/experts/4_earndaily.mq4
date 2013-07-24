//+------------------------------------------------------------------+
//|                                                  4_earndaily.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"


#include <stdlib.mqh>
#include <WinUser32.mqh>

extern int InitialTrailingStop = 150;
extern int TrailingStop = 150;
extern double lotsize = 0.05;
extern bool UseAlerts = false;
extern bool UseEmailAlerts = false;
int magic = 1234;
string infobox;
string mysymbol;
double aLookup;
double aStrength;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   mysymbol = Symbol();
   start();
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
int inc = 0;
int start()
  {
//----
   infobox = "\nSpread: " + MarketInfo(mysymbol, MODE_SPREAD) + "\n";
   double history = history(mysymbol);
   double openPositionTotal = openPositionTotal(mysymbol);
   double todaysprofit = history + openPositionTotal;
   //trailingstop();
   getallinfo(mysymbol);
   inc++;
   infobox = infobox + "Lookup: " + aLookup + ", Strength: " + aStrength + ", inc: " + inc;
   double val2, val3;
   int condition_heiken2, condition_heiken3, condition_heiken4;
      val2 = iCustom(mysymbol, PERIOD_H4, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(mysymbol, PERIOD_H4, "Heiken_Ashi_Smoothed",3,0);
      condition_heiken2 = 0;
      if (val2 < val3) {
         condition_heiken2 = 1;
      } else if (val2 > val3) {
         condition_heiken2 = -1;
      }
      val2 = iCustom(mysymbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(mysymbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,0);
      condition_heiken3 = 0;
      if (val2 < val3) {
         condition_heiken3 = 1;
      } else if (val2 > val3) {
         condition_heiken3 = -1;
      }
   if (aLookup >= 7) {
      //close all sell positions even if minus
      if (condition_heiken3 == 1) {
         CheckForClose(mysymbol, magic, 1);
      }
      if (condition_heiken2 == 1) {
         createorder(mysymbol, 1, lotsize, magic, magic, 
               0, 0);
      }
      
   } else if (aLookup >= 6.5) {
      //close all if positive
      //CheckForCloseifPositive(mysymbol, magic, 1);
   } else if (aLookup <= 2) {
      //close all if positive
      if (condition_heiken3 == -1) {
         CheckForClose(mysymbol, magic, -1);
      }
      if (condition_heiken2 == -1) {
         createorder(mysymbol, -1, lotsize, magic, magic, 
               0, 0);
      }
   } else if (aLookup <= 2.5) {
      //close all if positive
      //CheckForCloseifPositive(mysymbol, magic, -1);
   }
   //deletePipsMagic(mysymbol, magic);
   //int orders = totalOrdersMagic(mysymbol, magic);
   //if (orders > 0) {
      // if order is created then delete all pending orders
     // deletePendingOrders(mysymbol);
   //}
      Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+

int CloseAllPositions(string symbol)
{

   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderSymbol()==symbol) {
         if(OrderType()==OP_BUY)
           {
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_BID),3,White);
            Sleep(1000);
           }
         if(OrderType()==OP_SELL)
           {
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_ASK),3,White);
            Sleep(1000);
         
           }
        }
     }
}

int deletePendingOrders(string symbol)
{
for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderSymbol()==symbol) {
         if(OrderType()==OP_BUY || OrderType()==OP_SELL)
           {
           }
         else
           {
            OrderDelete(OrderTicket());
            Sleep(1000);
         
           }
        }
     }
}

int totalOrdersType(string symbol, int type)
{
   int cnt=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderSymbol()==symbol) {
         if(OrderType()==type)
           {
            cnt++;
           }
        }
     }
     return (cnt);
}

int totalOrdersTypeMagic(string symbol, int type, int magicnum)
{
   int cnt=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderSymbol()==symbol && OrderType()==type && OrderMagicNumber() == magicnum) {
         
            cnt++;
        }
     }
     return (cnt);
}
int totalPipsTypeMagic(string symbol, int type, int magicnum)
{
   int pips;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderSymbol()==symbol && OrderMagicNumber() == magicnum) {
         
            if (type == OP_BUY) {
               pips = (MarketInfo(symbol, MODE_BID)-OrderOpenPrice()) / MarketInfo(symbol, MODE_POINT);
            } else if (type == OP_SELL) {
               pips = (OrderOpenPrice()-MarketInfo(symbol, MODE_ASK)) / MarketInfo(symbol, MODE_POINT);
            }
        }
     }
     return (pips);
}

int deletePipsMagic(string symbol, int magicnum)
{
   int pips;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderSymbol()==symbol && OrderMagicNumber() == magicnum) {
         
            if (OrderType() == OP_BUYSTOP) {
               pips = (MarketInfo(symbol, MODE_BID)-OrderOpenPrice()) / MarketInfo(symbol, MODE_POINT);
            } else if (OrderType() == OP_SELLSTOP) {
               pips = (OrderOpenPrice()-MarketInfo(symbol, MODE_ASK)) / MarketInfo(symbol, MODE_POINT);
            }
            infobox = infobox + "\nPips: " + pips + "\n";
            if (pips < -250) {
               Print(symbol, ", deleting type: ", OrderType(), " ticket ", OrderTicket(), ", with pips: ", pips);
               OrderDelete(OrderTicket());
            }
        }
     }
     return (pips);
}

int totalOrders(string symbol)
{
   int cnt=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderSymbol()==symbol) {
        
            cnt++;
        }
     }
     return (cnt);
}
int totalOrdersMagic(string symbol, int magicnum)
{
   int cnt=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderSymbol()==symbol && OrderMagicNumber() == magicnum && (OrderType()==OP_BUY || OrderType()==OP_SELL)) {
        
            cnt++;
        }
     }
     return (cnt);
}
double openPositionTotal(string symbol)
{

   double gtotal = 0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderSymbol()==symbol) {
         gtotal += OrderProfit();
      }
     }
     infobox = StringConcatenate(infobox, "Profit for Open Position For Symbol: " + symbol +
   " is: " + DoubleToStr(gtotal, 2) + "\n");
   return (gtotal);
}
double history(string symbol)
{
   int cnt;
   int total = OrdersHistoryTotal();
   double gtotal = 0;
   for(cnt=0;cnt<total;cnt++)
   {
      OrderSelect(cnt, SELECT_BY_POS, MODE_HISTORY);
      if (OrderSymbol() == symbol 
         //&& TimeDay(OrderCloseTime()) == Day()
         //&& TimeMonth(OrderCloseTime()) == Month() && TimeYear(OrderCloseTime()) == Year()
      ) {
         gtotal += OrderProfit();
         //Print("Cnt: ", cnt, ", ticket: ", OrderTicket(), ", Order Profit: ", OrderProfit(), ", currency: ", OrderSymbol());
         //Print("close day: ", TimeDay(OrderCloseTime()), ", close month: ", TimeMonth(OrderCloseTime()), ", close year: ", TimeYear(OrderCloseTime())
            //, ", current day: ", Day(), ", current month: ", Month(), ", current year: ", Year()
         //);
      }
   }
   infobox = StringConcatenate(infobox, "Profit for Close Positions For Symbol: " + symbol +
   " is: " + DoubleToStr(gtotal, 2) + "\n");
   return (gtotal);
}


int createorder(string symbol, int type, double Lots, int magicnumber, string message, int stoploss, int takeprofit)
{
   //Print("Symbol: ", symbol, ", type: ", type, ", Lots: ", Lots, 
     // ", magicnumber: ", magicnumber, ", message: ", message, ", stoploss: ", stoploss,
      //", takeprofit: ", takeprofit);
   int maxspread = 80;
   int ignorespread = 0;
   int orders;
   int ordertype;
   double price;
   double val3;
   double pending_margin = 50;
   int sleeptime = 1000;
   double bids, asks, pt, digit;
   int ticket;
   double tp, sl;
   tp = 0;
   sl = 0;

   infobox = infobox + "\n" + symbol + " Order Creation\n";
   //Step 1: check different conditions
   if (IsTradeAllowed()==false) {
      infobox = infobox + " TRADING NOW ALLOWED";
      return (0);
   }

   if (MarketInfo(symbol, MODE_SPREAD) > maxspread && ignorespread == 0) {
      return (0);
   }
   
   
   if (type == 1) {
      ordertype = OP_BUY;
      val3 = AccountFreeMarginCheck(symbol, OP_BUY, Lots);
      if (val3 < pending_margin) {
         infobox = infobox + " pending_margin: " + val3 + " NO TRADING";
         return (0);
      }
   } else if (type == -1) {
      ordertype = OP_SELL;
      val3 = AccountFreeMarginCheck(symbol, OP_SELL, Lots);
      if (val3 < pending_margin) {
         infobox = infobox + " pending_margin: " + val3 + " NO TRADING";
         return (0);
      }
   } else {
      return (0);
   }

   orders = CalculateCurrentOrders(symbol, magicnumber);
   if (orders > 0)
   {
      infobox = infobox + " previous orders: " + orders + " NO TRADING";
       return (0);
   }

   //Step 2: create order
   bids = MarketInfo(symbol, MODE_BID);
   asks = MarketInfo(symbol, MODE_ASK);
   pt = MarketInfo(symbol, MODE_POINT);
   digit = MarketInfo(symbol, MODE_DIGITS);
   bids = NormalizeDouble(bids, digit);
   asks = NormalizeDouble(asks, digit);

   if (type == 1) {
      //price = asks + (150 * pt);
      //ticket=OrderSend(symbol,OP_BUYSTOP,Lots,price,3,0,0,message,magicnumber,0,Green);
      ticket=OrderSend(symbol,OP_BUY,Lots,asks,3,0,0,message,magicnumber,0,Green);
      Sleep(sleeptime);
      if(ticket>0) {
         if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
            price = asks;
            if (stoploss > 0) {
               sl = price - (stoploss * pt);
               sl = NormalizeDouble(sl, digit);
            }
            if (takeprofit > 0) {
               tp = price + (takeprofit * pt);
               tp = NormalizeDouble(tp, digit);
            }
            OrderModify(OrderTicket(),OrderOpenPrice(),sl,tp,0,Green);
            Print(symbol, ", Error modifying BUY order : ",ErrorDescription(GetLastError()), ", asks: ", asks, ", lots: ", Lots, ", magicnumber: "+magicnumber);
         
            SendAlert("Bullish", symbol, Period());
         }
      } else {
         Print(symbol, ", Error opening BUY order : ",ErrorDescription(GetLastError()), ", asks: ", asks, ", lots: ", Lots, ", magicnumber: "+magicnumber);
         Sleep(sleeptime);
         createorder(symbol, type, Lots, magicnumber, message, stoploss, takeprofit);
      }
      Sleep(sleeptime);
      return(0);
   } else if (type == -1) {
      //price = bids - (150 * pt);
       //ticket=OrderSend(symbol,OP_SELLSTOP,Lots,price,3,0,0,message,magicnumber,0,Red);
       ticket=OrderSend(symbol,OP_SELL,Lots,bids,3,0,0,message,magicnumber,0,Red);
      Sleep(sleeptime);
      if(ticket>0) {
         if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
            price = bids;
            if (stoploss > 0) {
               sl = price + (stoploss * pt);
               sl = NormalizeDouble(sl, digit);
            }
            if (takeprofit > 0) {
               tp = price - (takeprofit * pt);
               tp = NormalizeDouble(tp, digit);
            }
            OrderModify(OrderTicket(),OrderOpenPrice(),sl,tp,0,Green);
            Print(symbol, ", Error modifying SELL order : ",ErrorDescription(GetLastError()), ", bids: ", bids, ", lots: ", Lots, ", magicnumber: "+magicnumber);
         
            SendAlert("Bearish", symbol, Period());
         }
      } else {
         Print(symbol, ", Error opening SELL order : ",ErrorDescription(GetLastError()), ", bids: ", bids, ", lots: ", Lots, ", magicnumber: "+magicnumber);
         Sleep(sleeptime);
         createorder(symbol, type, Lots, magicnumber, message, stoploss, takeprofit);
      }
      Sleep(sleeptime);
      return(0);
   }
}

void CheckForClose(string symbol, int magicnumber, int typeHere)
  {
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()==magicnumber && OrderSymbol()==symbol) {
         if(OrderType()==OP_BUY && typeHere == -1)
           {
            Alert(symbol, ", closing buy order");
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_BID),3,White);
           }
         if(OrderType()==OP_SELL && typeHere == 1)
           {
            Alert(symbol, ", closing sell order");
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_ASK),3,White);
         
           }
     }
   }
//----
  }
  
void CheckForCloseifPositive(string symbol, int magicnumber, int typeHere)
  {
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()==magicnumber && OrderSymbol()==symbol && OrderProfit() > 0) {
         if(OrderType()==OP_BUY && typeHere == -1)
           {
            Alert(symbol, ", closing buy order");
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_BID),3,White);
           }
         if(OrderType()==OP_SELL && typeHere == 1)
           {
            Alert(symbol, ", closing sell order");
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_ASK),3,White);
         
           }
     }
   }
//----
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



void SendAlert(string dir, string symbol, int period)
{
   string per = TimeframeToString(period);
   if (UseAlerts)
   {
      Alert(dir + " on ", symbol, " @ ", per);
      PlaySound("alert.wav");
   }
   if (UseEmailAlerts)
      SendMail(symbol + " @ " + per + " - " + dir + " ", dir + " on " + symbol + " @ " + per + " as of " + TimeToStr(TimeCurrent()));
}



int CalculateCurrentOrders(string symbol, int magicnumber)
{
   int cnt=0;
   int i;
   for(i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==symbol && OrderMagicNumber()==magicnumber) {
         cnt++;
      }
   }
      
   return (cnt);
}

#define TABSIZE  10

int iLookup(double ratio)                                                   // this function will return a grade value
  {                                                                         // based on its power.
   int    aTable[TABSIZE]  = {0,3,10,25,40,50,60,75,90,97};                 // grade table for currency's power
   int   index;
   
   if      (ratio <= aTable[0]) index = 0;
   else if (ratio < aTable[1])  index = 0;
   else if (ratio < aTable[2])  index = 1;
   else if (ratio < aTable[3])  index = 2;
   else if (ratio < aTable[4])  index = 3;
   else if (ratio < aTable[5])  index = 4;
   else if (ratio < aTable[6])  index = 5;
   else if (ratio < aTable[7])  index = 6;
   else if (ratio < aTable[8])  index = 7;
   else if (ratio < aTable[9])  index = 8;
   else                         index = 9;
   return(index);                                                           // end of iLookup function
  }


int getallinfo(string symbol)
{
   double high, low, bid, ask, point, spread, digits;
      double aHigh;
      double aLow;
      double aBid;
      double aAsk;
      double aRatio;
      double aRange;
      int z;
         
         //infobox = infobox + "\n" + mySymbol;
         bid = MarketInfo(symbol, MODE_BID);
         ask = MarketInfo(symbol, MODE_ASK);
         point = MarketInfo(symbol, MODE_POINT);
         spread = MarketInfo(symbol, MODE_SPREAD);
         digits = MarketInfo(symbol, MODE_DIGITS);
         //Calculating the points:
         high = -1;
         low = -1;
         for (z=0; z<4; z++) {
            infobox = infobox + "High " + z + ": " + iHigh(symbol, PERIOD_H4, z) + "\n";
            infobox = infobox + "Low " + z + ": " + iLow(symbol, PERIOD_H4, z) + "\n";
            if (high == -1) {
               high = iHigh(symbol, PERIOD_H4, z);
            }
            if (iHigh(symbol, PERIOD_H4, z) > high) {
               high = iHigh(symbol, PERIOD_H4, z);
            }
            if (low == -1) {
               low = iLow(symbol, PERIOD_H4, z);
            }
            if (iLow(symbol, PERIOD_H4, z) < low) {
               low = iLow(symbol, PERIOD_H4, z);
            }
         }
            infobox = infobox + "High F " + z + ": " + high + "\n";
            infobox = infobox + "Low F " + z + ": " + low + "\n";
         aHigh = high;
         aLow      = low; 
         aBid      = bid;                 
         aAsk      = ask;                 
         aRange    = MathMax((aHigh-aLow)/point,1);      // calculate range today  
         aRatio    = (aBid-aLow)/aRange/point;     // calculate pair ratio
         aLookup   = iLookup(aRatio*100);                        // set a pair grade
         aStrength = 9-aLookup;
         //Print("aLookup: ", aLookup);
         //Print("aStrength: ", aStrength);
         
        
}



int trailingstop()
{
   double bid, ask, point;
   int cnt, ticket, total;
   total=OrdersTotal();
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL
      ) 
         {
         bid = MarketInfo(OrderSymbol(), MODE_BID);
         ask = MarketInfo(OrderSymbol(), MODE_ASK);
         point = MarketInfo(OrderSymbol(), MODE_POINT);
         //orderbox = StringConcatenate(infobox, "\n", OrderSymbol(), ", bid: ", bid, ", ask: ", ask);
         //orderbox = StringConcatenate(infobox, "\n", OrderSymbol(), ", Ordder Profit: ", OrderProfit(), ", OrderOpenPrice: ", OrderOpenPrice());
            if(OrderType()==OP_BUY) {
               if(InitialTrailingStop>0 && TrailingStop>0 && OrderProfit() > 0)  
               {                 
                  //orderbox = StringConcatenate(orderbox, "\n", OrderSymbol(), ", bid-OrderOpenPrice(): ", (bid-OrderOpenPrice()), ", point*InitialTrailingStop: ", (point*InitialTrailingStop));
                  if(bid-OrderOpenPrice()>point*InitialTrailingStop)
                  {
                     //orderbox = StringConcatenate(orderbox, "\n", OrderSymbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", bid-point*TrailingStop: ", (bid-point*TrailingStop));
                     if(OrderStopLoss()<bid-point*TrailingStop)
                     {
                        //orderbox = StringConcatenate(orderbox, "\n", OrderSymbol(), ", Modify Buy");
                        OrderModify(OrderTicket(),OrderOpenPrice(),bid-point*TrailingStop,OrderTakeProfit(),0,Green);
                     }
                  }
               }//end if
            } else if(OrderType()==OP_SELL) {
               // check for trailing stop
               if(InitialTrailingStop>0 && TrailingStop>0 && OrderProfit() > 0)  
                 {                 
                  //orderbox = StringConcatenate(orderbox, "\n", OrderSymbol(), ", OrderOpenPrice()-ask: ", (OrderOpenPrice()-ask), ", point*InitialTrailingStop: ", (point*InitialTrailingStop));
                  if((OrderOpenPrice()-ask)>(point*InitialTrailingStop))
                    {
                     //orderbox = StringConcatenate(orderbox, "\n", OrderSymbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", ask+point*TrailingStop: ", (ask+point*TrailingStop));
                     if((OrderStopLoss()>(ask+point*TrailingStop)) || (OrderStopLoss()==0))
                       {
                        //orderbox = StringConcatenate(orderbox, "\n", OrderSymbol(), ", Modify Sell");
                        OrderModify(OrderTicket(),OrderOpenPrice(),ask+point*TrailingStop,OrderTakeProfit(),0,Red);
                       }
                    }
                 }
            } 
         }
         
      }
      
   //orderbox = StringConcatenate("InitialTrailingStop: ",InitialTrailingStop
   //, ", TrailingStop: ",TrailingStop,"\n",orderbox);

   return (0);
}

