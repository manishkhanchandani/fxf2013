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
extern int MAGICMA = 411;
extern int stoploss = 200;
extern int takeprofit = 5000;
extern int gmt_offset = 3;
extern bool create_order = true;
extern bool current_currency = true;
extern int pending_margin = 150;
extern int maxorders = 56;
extern int maxspread = 50;
extern bool UseAlerts = false;
extern bool UseEmailAlerts = false;
extern bool ignore_bad_currency = false;
extern bool reverse_mode = true;
extern int sleeptime = 3000;
extern string build = "1.1";

double lot;
#define ARRSIZE  28
#define TABSIZE  10
string aPair[ARRSIZE]   = {
                        "USDCHF_Nano","GBPUSD_Nano","EURUSD_Nano","USDJPY_Nano","USDCAD_Nano","AUDUSD_Nano",
                        "EURGBP_Nano","EURAUD_Nano","EURCHF_Nano","EURJPY_Nano","GBPCHF_Nano","CADJPY_Nano",
                        "GBPJPY_Nano","AUDNZD_Nano","AUDCAD_Nano","AUDCHF_Nano","AUDJPY_Nano","CHFJPY_Nano",
                        "EURNZD_Nano","EURCAD_Nano","CADCHF_Nano","NZDJPY_Nano","NZDUSD_Nano","GBPCAD_Nano",
                        "GBPNZD_Nano","GBPAUD_Nano","NZDCHF_Nano","NZDCAD_Nano"
                        };
int hour;
string infobox;
string impbox;
string createbox;
int openTime;
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
      double val6, val7;
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
      for (index = 0; index < ARRSIZE; index++) {
         RefreshRates();
         mySymbol = aPair[index];
         if (current_currency) {
            if (Symbol() != mySymbol) {
               continue;
            }
         }
         if (ignore_bad_currency) {
            if (mySymbol == "CADCHF" || mySymbol == "EURGBP" || mySymbol == "EURCHF" || mySymbol == "AUDNZD") {
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
         val2 = iCustom(mySymbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,0);
         val3 = iCustom(mySymbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,0);
         val4 = iCustom(mySymbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,1);
         val5 = iCustom(mySymbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,1);
         
         if (val2 < val3 && val4 > val5) {// && aLookup[index] > aStrength[index]
            impbox = impbox + "\n" + mySymbol;
            impbox = impbox + ", BUY";
            val6 = iStochastic(mySymbol,PERIOD_H1,14,3,3,MODE_SMA,0,MODE_MAIN,1);
            val7 = iStochastic(mySymbol,PERIOD_H1,14,3,3,MODE_SMA,0,MODE_SIGNAL,1);
            reverse_bid(1, mySymbol);
            impbox = impbox + ", Diff: " + (val2 - val3);
            impbox = impbox + ", iStochastic Main: " + val6 + ", iStochastic Signal: " + val7;
            SendAlert("Bullish", mySymbol, PERIOD_H1);
            createorder(mySymbol, PERIOD_H1, 1, TimeframeToString(PERIOD_H1));
         } else if (val2 > val3 && val4 < val5) {// && aLookup[index] < aStrength[index]
            impbox = impbox + "\n" + mySymbol;
            impbox = impbox + ", SELL";
            val6 = iStochastic(mySymbol,PERIOD_H1,14,3,3,MODE_SMA,0,MODE_MAIN,1);
            val7 = iStochastic(mySymbol,PERIOD_H1,14,3,3,MODE_SMA,0,MODE_SIGNAL,1);
               reverse_bid(-1, mySymbol);
            impbox = impbox + ", Diff: " + (val2 - val3);
            impbox = impbox + ", iStochastic Main: " + val6 + ", iStochastic Signal: " + val7;
            SendAlert("Bearish", mySymbol, PERIOD_H1);
            createorder(mySymbol, PERIOD_H1, -1, TimeframeToString(PERIOD_H1));
         }
         infobox = infobox + ", val2: "+ DoubleToStr(val2, digits)
          + ", val3: "+ DoubleToStr(val3, digits)
          + ", val4: "+ DoubleToStr(val4, digits)
          + ", val5: "+ DoubleToStr(val5, digits);
         infobox = infobox + ", Bid: "+ DoubleToStr(bid, digits)
          + ", Ask: "+ DoubleToStr(ask, digits)
           + ", Spread: "+ spread;
         infobox = infobox + ", Lookup: "+ aLookup[index]
          + ", Strength: "+ aStrength[index];/* + ", aHigh[index]: " + DoubleToStr(aHigh[index], digits)
          + ", aLow[index]: "+ DoubleToStr(aLow[index], digits) + ", aRange[index]: " + DoubleToStr(aRange[index], digits)
           + ", aRatio[index]: " + DoubleToStr(aRatio[index], digits);*/

            val6 = iStochastic(mySymbol,PERIOD_H1,14,3,3,MODE_SMA,0,MODE_MAIN,1);
            val7 = iStochastic(mySymbol,PERIOD_H1,14,3,3,MODE_SMA,0,MODE_SIGNAL,1);
            infobox = infobox + ", Diff: " + (val2 - val3);
            infobox = infobox + ", iStochastic Main: " + DoubleToStr(val6, digits) + ", iStochastic Signal: " + DoubleToStr(val7, digits);
         if (val2 < val3) {
            infobox = infobox + ", Current Buy";
         } else if (val2 > val3) {
            infobox = infobox + ", Current Sell";
         }
      }
      Comment(impbox, infobox, createbox);
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

   //if (hour == 20 || hour == 21 || hour == 22) {
      //createbox = createbox + " Hour: " + hour + " NO TRADING";
      //return (0);
   //}

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
       && OrderProfit() > 0
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

