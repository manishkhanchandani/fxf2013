//+------------------------------------------------------------------+
//|                                                     template.mq4 |
//|                                              Manish Khanchandani |
//|                                          http://www.mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://www.mkgalaxy.com"

#include <stdlib.mqh>
#include <WinUser32.mqh>

extern double Lots = 0.05;
extern int MAGICMA = 412;
extern int stoploss = 200;
extern int takeprofit = 5000;
extern int gmt_offset = 3;
extern bool create_order = true;
extern bool current_currency = false;
extern int pending_margin = 250;
extern int maxorders = 1;
extern int maxspread = 60;
extern bool UseAlerts = false;
extern bool UseEmailAlerts = false;
extern bool ignore_bad_currency = true;
extern bool reverse_mode = true;
extern int sleeptime = 3000;
extern string build = "1.4";
extern int InitialTrailingStop = 150;
extern int TrailingStop = 150;
extern bool good_currency = true;

double lot;
#define ARRSIZE  28
#define TABSIZE  10
string aPair[ARRSIZE]   = {
                        "USDCHF","GBPUSD","EURUSD","USDJPY","USDCAD","AUDUSD",
                        "EURGBP","EURAUD","EURJPY","GBPCHF","CADJPY",
                        "GBPJPY","AUDNZD","AUDCAD","AUDCHF","AUDJPY","CHFJPY",
                        "EURNZD","EURCAD","CADCHF","NZDJPY","NZDUSD","GBPCAD",
                        "GBPNZD","GBPAUD","NZDCHF","NZDCAD","EURCHF"
                        };
int hour;
string infobox;
string impbox;
string createbox;
int openTime;
string orderbox;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
      Comment("Starting Z... Please Wait! ");
      //Sleep(sleeptime);
   
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
//----
   return(0);
  }
//+------------------------------------------------------------------+

int custom_start()
{
   //strategy is defined here
   strategy();
      
}
int strategy()
{
   //strategy comes here
   //if (openTime != Time[0]) {
      trailing_stop();
      Sleep(sleeptime);
      string mySymbol;
      infobox = "";
      hour = Hour() - gmt_offset;
         if (hour < 0) {
            hour = hour + 24;
         }
      lot=NormalizeDouble(AccountFreeMargin()*0.3/1000.0,2);
      if (Lots == 0) Lots = lot;
      infobox="Hour: " + Hour() + ", hour new: " + hour + "\n";
      infobox = StringConcatenate(infobox, "Lots: ", Lots,
         ", stoploss: ", stoploss,
         ", takeprofit: ", takeprofit, 
         ", create_order: ", create_order,
         ", pending_margin: ", pending_margin,
         ", maxorders: ", maxorders,
         ", hour: ", hour,
         ", lot: ",lot, "\n");
      string filename = "heiken/" + Year() + "_" + Month() + "_" + Day()  + ".txt";
      FileDelete(filename);
      impbox = "\n";
      createbox = "\n";
      int index;
      double ask, bid, digits, point, spread;
      impbox = impbox + TimeToStr(TimeCurrent()) + "\n";
      double val2, val3, val4, val5;
      double val6, val7, val8, val9, val10, val11, val12, val13, val14, val15;
      double high, low;
      double aHigh[ARRSIZE];
      double aLow[ARRSIZE];
      double aHigh1[ARRSIZE];
      double aBid[ARRSIZE];
      double aAsk[ARRSIZE];
      double aRatio[ARRSIZE];
      double aRange[ARRSIZE];
      double aLookup[ARRSIZE];
      double aStrength[ARRSIZE];
      int z;
      int number = 4;
      int limit = ARRSIZE;
      
         if (current_currency) {
            aPair[0] = Symbol();
            limit = 1;
         }
      for (index = 0; index < limit; index++) {
         RefreshRates();
         mySymbol = aPair[index];
         if (ignore_bad_currency) {
            if (mySymbol == "CADCHF" || mySymbol == "EURGBP" || mySymbol == "EURCHF" || mySymbol == "AUDNZD" || mySymbol == "USDJPY"
             || mySymbol == "NZDJPY" || mySymbol == "GBPJPY"
            ) {
               continue;
            }
         }
         if (good_currency) {
            if (mySymbol == "AUDUSD" || mySymbol == "NZDCAD" || mySymbol == "NZDUSD" || mySymbol == "EURAUD" || mySymbol == "GBPAUD") {
               
            } else {
               continue;
            }
         }
         infobox = infobox + "\n" + mySymbol;
         bid = MarketInfo(mySymbol, MODE_BID);
         ask = MarketInfo(mySymbol, MODE_ASK);
         point = MarketInfo(mySymbol, MODE_POINT);
         spread = MarketInfo(mySymbol, MODE_SPREAD);
         digits = MarketInfo(mySymbol, MODE_DIGITS);
         //Calculating the points:
         /*
         high = -1;
         low = -1;
         for (z=0; z<number; z++) {
            if (high == -1) {
               high = iHigh(mySymbol, PERIOD_H4, z);
            }
            if (iHigh(mySymbol, PERIOD_H4, z) > high) {
               high = iHigh(mySymbol, PERIOD_H4, z);
            }
            if (low == -1) {
               low = iLow(mySymbol, PERIOD_H4, z);
            }
            if (iLow(mySymbol, PERIOD_H4, z) < low) {
               low = iLow(mySymbol, PERIOD_H4, z);
            }
         }
         aHigh[index] = high;
         aLow[index]      = low; 
         aBid[index]      = bid;                 
         aAsk[index]      = ask;                 
         aRange[index]    = MathMax((aHigh[index]-aLow[index])/point,1);      // calculate range today  
         aRatio[index]    = (aBid[index]-aLow[index])/aRange[index]/point;     // calculate pair ratio
         aLookup[index]   = iLookup(aRatio[index]*100);                        // set a pair grade
         aStrength[index] = 9-aLookup[index]; 
         */
         val2 = iCustom(mySymbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,0);
         val3 = iCustom(mySymbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,0);
         val4 = iCustom(mySymbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,1);
         val5 = iCustom(mySymbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,1);
         val8 = iCustom(mySymbol, PERIOD_M30, "Heiken_Ashi_Smoothed",2,0);
         val9 = iCustom(mySymbol, PERIOD_M30, "Heiken_Ashi_Smoothed",3,0);
         val10 = iCustom(mySymbol, PERIOD_M15, "Heiken_Ashi_Smoothed",2,0);
         val11 = iCustom(mySymbol, PERIOD_M15, "Heiken_Ashi_Smoothed",3,0);
         val12 = iCustom(mySymbol, PERIOD_M5, "Heiken_Ashi_Smoothed",2,0);
         val13 = iCustom(mySymbol, PERIOD_M5, "Heiken_Ashi_Smoothed",3,0);
         val14 = iCustom(mySymbol, PERIOD_M1, "Heiken_Ashi_Smoothed",2,0);
         val15 = iCustom(mySymbol, PERIOD_M1, "Heiken_Ashi_Smoothed",3,0);
         val6 = iCCI(mySymbol,PERIOD_M30,45,PRICE_CLOSE,0);
         val7 = iCCI(mySymbol,PERIOD_M30,45,PRICE_CLOSE,1);
         if (val2 < val3) {
            reverse_bid(1, mySymbol);
         } else if (val2 > val3) {
            reverse_bid(-1, mySymbol);         
         }
         if (
         //(val2 < val3 && val4 > val5) 
         //|| 
         (val6 > 100 && val6 > val7 && val2 < val3 && val8 < val9 && val10 < val11 && val12 < val13 && val14 < val15)) {// && aLookup[index] > aStrength[index]
            impbox = impbox + "\n" + mySymbol;
            impbox = impbox + ", BUY";
            //val6 = iStochastic(mySymbol,PERIOD_H1,14,3,3,MODE_SMA,0,MODE_MAIN,1);
            //val7 = iStochastic(mySymbol,PERIOD_H1,14,3,3,MODE_SMA,0,MODE_SIGNAL,1);
            impbox = impbox + ", Diff: " + (val2 - val3) + ", Diff2: " + (val8 - val9) + ", Diff3: " + (val10 - val11) + ", Diff4: " + (val12 - val13) + ", Diff5: " + (val14 - val15);
            impbox = impbox + ", CCI Current: " + val6 + ", CCI Past: " + val7;
            SendAlert("Bullish", mySymbol, PERIOD_H1);
            createorder(mySymbol, PERIOD_H1, 1, TimeframeToString(PERIOD_H1));
         } else if (
         //(val2 > val3 && val4 < val5) 
         //|| 
         (val6 < -100 && val6 < val7 && val2 > val3 && val8 > val9 && val10 > val11 && val12 > val13 && val14 > val15)) {// && aLookup[index] < aStrength[index]
            impbox = impbox + "\n" + mySymbol;
            impbox = impbox + ", SELL";
            //val6 = iStochastic(mySymbol,PERIOD_H1,14,3,3,MODE_SMA,0,MODE_MAIN,1);
            //val7 = iStochastic(mySymbol,PERIOD_H1,14,3,3,MODE_SMA,0,MODE_SIGNAL,1);
            impbox = impbox + ", Diff: " + (val2 - val3) + ", Diff2: " + (val8 - val9) + ", Diff3: " + (val10 - val11) + ", Diff4: " + (val12 - val13) + ", Diff5: " + (val14 - val15);
            impbox = impbox + ", CCI Current: " + val6 + ", CCI Past: " + val7;
            SendAlert("Bearish", mySymbol, PERIOD_H1);
            createorder(mySymbol, PERIOD_H1, -1, TimeframeToString(PERIOD_H1));
         }
         infobox = infobox + ", val6: "+ DoubleToStr(val6, digits)
          + ", val7: "+ DoubleToStr(val7, digits);
         infobox = infobox + ", Diff: " + (val2 - val3) + ", Diff2: " + (val8 - val9) 
            + ", Diff3: " + (val10 - val11) + ", Diff4: " + (val12 - val13) + ", Diff5: " + (val14 - val15);
         infobox = infobox + ", Bid: "+ DoubleToStr(bid, digits)
          + ", Ask: "+ DoubleToStr(ask, digits)
           + ", Spread: "+ spread;
         /*infobox = infobox + ", Lookup: "+ aLookup[index]
          + ", Strength: "+ aStrength[index]; + ", aHigh[index]: " + DoubleToStr(aHigh[index], digits)
          + ", aLow[index]: "+ DoubleToStr(aLow[index], digits) + ", aRange[index]: " + DoubleToStr(aRange[index], digits)
           + ", aRatio[index]: " + DoubleToStr(aRatio[index], digits);*/

            //val6 = iStochastic(mySymbol,PERIOD_H1,14,3,3,MODE_SMA,0,MODE_MAIN,1);
            //val7 = iStochastic(mySymbol,PERIOD_H1,14,3,3,MODE_SMA,0,MODE_SIGNAL,1);
            infobox = infobox + ", Diff: " + (val2 - val3);
            //infobox = infobox + ", iStochastic Main: " + DoubleToStr(val6, digits) + ", iStochastic Signal: " + DoubleToStr(val7, digits);
         if (val2 < val3) {
            infobox = infobox + ", Current Buy";
         } else if (val2 > val3) {
            infobox = infobox + ", Current Sell";
         }
      }
      Comment(orderbox, "\n", impbox, infobox, createbox);
      FileAppend(filename,impbox + infobox + createbox);
      openTime = Time[0];
   //}
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
void FileAppend(string name,string txt)
{
   int handle = FileOpen(name,FILE_READ|FILE_WRITE);
	FileSeek(handle,0,SEEK_END);
	FileWrite(handle,txt);
	FileFlush(handle);
	FileClose(handle);
}

void SendAlert(string dir, string symbol, int tp)
{
   string per = TimeframeToString(tp);
   if (UseAlerts)
   {
      Alert(dir + " Heiken on ", symbol, " @ ", per);
      PlaySound("alert.wav");
   }
   if (UseEmailAlerts)
      SendMail(symbol + " @ " + per + " - " + dir + " Heiken", dir + " Heiken on " + symbol + " @ " + per + " as of " + TimeToStr(TimeCurrent()));
}


int createorder(string symbol, int timeperiod, int type, string message)
{
   createbox = createbox + "\n" + symbol;
   if (IsTradeAllowed()==false) {
      createbox = createbox + " TRADING NOW ALLOWED";
      return (0);
   }


   if (!create_order) {
      createbox = createbox + " CREATE ORDER FALSE NO TRADING";
      return (0);
   }

   if (hour == 20 || hour == 21 || hour == 22 || hour == 23) {
      createbox = createbox + " Hour: " + hour + " NO TRADING";
      return (0);
   }

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
         createbox = createbox + " pending_margin: " + val3 + " NO TRADING";
         return (0);
      }
   } else if (type == -1) {
      ordertype = OP_SELL;
      val3 = AccountFreeMarginCheck(symbol, OP_SELL, Lots);
      if (val3 < pending_margin) {
         createbox = createbox + " pending_margin: " + val3 + " NO TRADING";
         return (0);
      }
   } else {
      return (0);
   }

   orders = CalculateCurrentOrders(symbol, ordertype);
   if (orders > 0)
   {
      createbox = createbox + " orders: " + orders + " NO TRADING";
      //Print("order already created for symbol: ", symbol);
       return (0);
   }
   
   orders = CalculateCurrentRealMaxOrders();
   if (orders >= maxorders)
   {
      createbox = createbox + " maxorders: " + maxorders + " NO TRADING";
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
   double new_stoploss, new_takeprofit;
   new_stoploss = stoploss;
   new_takeprofit = takeprofit;
   if (symbol == "GBPCHF" || symbol == "GBPJPY" || symbol == "GBPCAD" || symbol == "GBPAUD" || symbol == "GBPNZD") {
      if (stoploss > 0) {
         new_stoploss = stoploss + 150;
      }
      if (takeprofit > 0) {
         new_takeprofit = takeprofit + 300;
      }
   }
   if (type == 1) {
      price = asks;
      if (stoploss > 0) {
         sl = price - (new_stoploss * pt);
         sl = NormalizeDouble(sl, digit);
         }
      if (takeprofit > 0) {
         tp = price + (new_takeprofit * pt);
         tp = NormalizeDouble(tp, digit);
         }
      ticket=OrderSend(symbol,OP_BUY,Lots,asks,3,0,0,message+", Heiken Blaster "+build,MAGICMA,0,Green);
      if(ticket>0)
         {
         if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
            OrderModify(OrderTicket(),OrderOpenPrice(),sl,tp,0,Green);
          }
            impbox = impbox + ", Buy Order Created";
            SendAlert("Buy Order Created", symbol, PERIOD_H1);
         
         }
      else {
         Print(symbol, ", Error opening BUY order : ",ErrorDescription(GetLastError()), ", asks: ", asks);
         SendAlert("Could not create buy order", symbol, PERIOD_H1);
      Sleep(sleeptime);
         createorder(symbol, timeperiod, type, message);
      }
      Sleep(sleeptime);
         return(0); 
   } else if (type == -1) {
      price = bids;
      if (stoploss > 0) {
         sl = price + (new_stoploss * pt);
         sl = NormalizeDouble(sl, digit);
         }
      if (takeprofit > 0) {
         tp = price - (new_takeprofit * pt);
         tp = NormalizeDouble(tp, digit);
        }
       ticket=OrderSend(symbol,OP_SELL,Lots,bids,3,0,0,message+", Heiken Blaster "+build,MAGICMA,0,Red);
        if(ticket>0)
           {
         if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
            OrderModify(OrderTicket(),OrderOpenPrice(),sl,tp,0,Green);
          }
            impbox = impbox + ", Sell Order Created";
            SendAlert("Sell Order Created", symbol, PERIOD_H1);
           
           }
           else {
               Print(symbol, " Error opening Sell order : ",ErrorDescription(GetLastError()), ", price: ", bids); 
         SendAlert("Could not create sell order", symbol, PERIOD_H1);
      
      Sleep(sleeptime);
               createorder(symbol, timeperiod, type, message);
            } 
      
      Sleep(sleeptime);
             return(0); 
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
int CalculateCurrentOrders(string symbol, int ordertype)
  {
   int cnt=0;
   int i;
//----
  for(i=0;i<OrdersTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
         if(OrderSymbol()==symbol && OrderMagicNumber()==MAGICMA && ordertype == OrderType())
           {
            cnt++;
           }
        }
   return (cnt);
  }
  
  
int reverse_bid(int type, string symbol)
{
   if (!reverse_mode) {
      return (0);
   }
   for(int cnt=0;cnt<OrdersTotal();cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol() == symbol && OrderMagicNumber()==MAGICMA
       //&& OrderProfit() > 0
       ) {
         if(OrderType()==OP_BUY) {
            if (type == -1) {
            SendAlert("Closing buy order", OrderSymbol(), PERIOD_H1);
               OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(), MODE_BID),3,White);
      
      Sleep(sleeptime);
            }
         } else if (OrderType()==OP_SELL) {
            if (type == 1) {
            SendAlert("Closing sell order", OrderSymbol(), PERIOD_H1);
               OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(), MODE_ASK),3,White);
      
      Sleep(sleeptime);
            }         
         }
      }
   }
}

int trailing_stop()
{
   return (0);
   orderbox = "";
   orderbox = StringConcatenate(orderbox, "\nCHECKING ORDERS:");
   int cnt, ticket, total;
   total=OrdersTotal();
   double bids, asks, pt, digit;
   int orders;
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         // for more than two orders, return as we dont support trialing stop for more orders as of now
      if(OrderType()<=OP_SELL 
      && OrderMagicNumber()==MAGICMA
      )  // check for symbol
         {
         
         if (current_currency) {
            if (OrderSymbol() != Symbol()) {
               continue;
            }
         }
         orderbox = StringConcatenate(orderbox, "\n", OrderSymbol(), " (", OrderProfit(), ")");
         bids = MarketInfo(OrderSymbol(), MODE_BID);
         asks = MarketInfo(OrderSymbol(), MODE_ASK);
         pt = MarketInfo(OrderSymbol(), MODE_POINT);
         digit = MarketInfo(OrderSymbol(), MODE_DIGITS);
         bids = NormalizeDouble(bids, digit);
         asks = NormalizeDouble(asks, digit);
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
                        //return(0);
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
                        //return(0);
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
*/