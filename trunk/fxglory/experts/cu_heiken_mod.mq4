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
extern double minimum_lot = 0.05;
extern int MAGICMA = 412;
extern int stoploss = 500;
extern int takeprofit = 5000;
extern int gmt_offset = 2;
extern bool create_order = true;
extern int pending_margin = 100;
extern int maxorders = 2;
extern int maxspread = 60;
extern bool UseAlerts = false;
extern bool UseEmailAlerts = false;
extern bool reverse_mode = true;
extern int sleeptime = 1000;
extern string build = "2.1";
extern int InitialTrailingStop = 150;
extern int TrailingStop = 150;

extern bool stop_order_on_loss = true;
extern double max_loss_per_day = -25;

extern bool current_symbol = false;
extern bool ignore_particular_currency = false;
extern string ignore_currency = ""; //e.g. GB
extern bool ignore_particular_symbol = false;
extern string ignore_symbol = ""; //e.g. USDJPY
extern bool only_particular_currency = false;
extern string only_currency = ""; //e.g. GB
extern bool only_particular_symbol = false;
extern string only_symbol = ""; //e.g. USDJPY

int timeperiod;
double gtotal;
double lot;
#define ARRSIZE  28
#define TABSIZE  10
#define PAIRSIZE 8

#define USDCHF 0
#define GBPUSD 1
#define EURUSD 2
#define USDJPY 3
#define USDCAD 4
#define AUDUSD 5
#define EURGBP 6
#define EURAUD 7
#define EURCHF 8
#define EURJPY 9
#define GBPCHF 10
#define CADJPY 11
#define GBPJPY 12
#define AUDNZD 13
#define AUDCAD 14
#define AUDCHF 15
#define AUDJPY 16
#define CHFJPY 17
#define EURNZD 18
#define EURCAD 19
#define CADCHF 20
#define NZDJPY 21
#define NZDUSD 22
#define GBPCAD 23
#define GBPNZD 24
#define GBPAUD 25
#define NZDCHF 26
#define NZDCAD 27

// Currency
#define USD 0
#define EUR 1
#define GBP 2
#define CHF 3                                                                                      
#define CAD 4                                                                                      
#define AUD 5                                                                                      
#define JPY 6                                                                                      
#define NZD 7   

string aPair[ARRSIZE]   = {
                        "USDCHF","GBPUSD","EURUSD","USDJPY","USDCAD","AUDUSD",
                        "EURGBP","EURAUD","EURCHF","EURJPY","GBPCHF","CADJPY",
                        "GBPJPY","AUDNZD","AUDCAD","AUDCHF","AUDJPY","CHFJPY",
                        "EURNZD","EURCAD","CADCHF","NZDJPY","NZDUSD","GBPCAD",
                        "GBPNZD","GBPAUD","NZDCHF","NZDCAD"
                        };
string aMajor[PAIRSIZE] = {"USD","EUR","GBP","CHF","CAD","AUD","JPY","NZD"};
double aMeter[PAIRSIZE];
string gSymbol[8][8];
string curUSD[7] = {"USDCHF","GBPUSD","EURUSD","USDJPY","USDCAD","AUDUSD","NZDUSD"};
string curEUR[7] = {"EURUSD","EURGBP","EURAUD","EURCHF","EURJPY","EURNZD","EURCAD"};
string curGBP[7] = {"GBPUSD","GBPCHF","GBPJPY","GBPCAD","GBPNZD","GBPAUD","EURGBP"};
string curCAD[7] = {"USDCAD","AUDCAD","CADCHF","EURCAD","NZDCAD","GBPCAD","CADJPY"};
string curCHF[7] = {"USDCHF","EURCHF","GBPCHF","AUDCHF","CHFJPY","CADCHF","NZDCHF"};
string curJPY[7] = {"USDJPY","EURJPY","GBPJPY","NZDJPY","AUDJPY","CHFJPY","CADJPY"};
string curAUD[7] = {"AUDUSD","EURAUD","GBPAUD","AUDCHF","AUDCAD","AUDNZD","AUDJPY"};
string curNZD[7] = {"NZDUSD","NZDCAD","NZDCHF","EURNZD","NZDJPY","AUDNZD","GBPNZD"};
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
      string mySymbol;
      infobox = "";
      string filename = "heikenmod/" + Year() + "_" + Month() + "_" + Day()  + ".txt";
      //FileDelete(filename);
      impbox = "\n";
      createbox = "\n";
      trailing_stop();
      Sleep(1000);
      int historycheck = history();
      hour = Hour() - gmt_offset;
         if (hour < 0) {
            hour = hour + 24;
         }
      lot=NormalizeDouble(200*0.3/1000.0,2);
      if (lot < minimum_lot) lot = minimum_lot;
      infobox= infobox + "\nSuggested Lot: " + DoubleToStr(lot, 2);
      if (Lots == 0) Lots = lot;
      infobox= infobox + "\nHour: " + Hour() + ", hour new: " + hour;
      infobox = StringConcatenate(infobox, "\nLots: ", Lots,
         ", stoploss: ", stoploss,
         ", takeprofit: ", takeprofit, 
         ", create_order: ", create_order,
         ", pending_margin: ", pending_margin,
         ", maxorders: ", maxorders,
         ", hour: ", hour,
         ", lot: ",lot, "\n");
      int index;
      double ask, bid, digits, point, spread;
      impbox = impbox + TimeToStr(TimeCurrent()) + "\n";
      double val2, val3, val4, val5;
      double val6, val7, val8, val9, val8a, val9a, val10, val11, val10a, val11a, val12, val13, val12a, val13a, val14, val15, val14a, val15a;
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
      
      for (index = 0; index < limit; index++) {
         RefreshRates();
         mySymbol = aPair[index];
         //infobox = infobox + "\n" + mySymbol;
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
         aBid[index]      = MarketInfo(mySymbol,MODE_BID);                 
         aAsk[index]      = MarketInfo(mySymbol,MODE_ASK);                 
         aRange[index]    = MathMax((aHigh[index]-aLow[index])/point,1);      // calculate range today  
         aRatio[index]    = (aBid[index]-aLow[index])/aRange[index]/point;     // calculate pair ratio
         aLookup[index]   = iLookup(aRatio[index]*100);                        // set a pair grade
         aStrength[index] = 9-aLookup[index];                                  // set a pair strengh
         //infobox = infobox + ": ahigh: " + aHigh[index] + ", alow: " + aLow[index] + ", aBid: " + aBid[index]
            // + ", aAsk: " + aAsk[index] + ", aRange: " + aRange[index] + ", aRatio: " + aRatio[index] + ", aLookup: " + aLookup[index]
            // + ", aStrength: " + aStrength[index];     
      }
      
   aMeter[USD] = NormalizeDouble((aLookup[USDJPY]+aLookup[USDCHF]+aLookup[USDCAD]+aStrength[EURUSD]+aStrength[GBPUSD]+aStrength[AUDUSD]+aStrength[NZDUSD])/7,1);
   aMeter[EUR] = NormalizeDouble((aLookup[EURUSD]+aLookup[EURJPY]+aLookup[EURGBP]+aLookup[EURCHF]+aLookup[EURAUD]+aLookup[EURCAD]+aLookup[EURNZD])/7,1);
   aMeter[GBP] = NormalizeDouble((aLookup[GBPUSD]+aLookup[GBPJPY]+aLookup[GBPCHF]+aStrength[EURGBP]+aLookup[GBPCAD]+aLookup[GBPAUD]+aLookup[GBPNZD])/7,1);
   aMeter[CHF] = NormalizeDouble((aStrength[USDCHF]+aStrength[EURCHF]+aStrength[GBPCHF]+aStrength[AUDCHF]+aLookup[CHFJPY]+aStrength[CADCHF]+aStrength[NZDCHF])/7,1);
   aMeter[CAD] = NormalizeDouble((aStrength[USDCAD]+aLookup[CADCHF]+aStrength[AUDCAD]+aLookup[CADJPY]+aStrength[EURCAD]+aStrength[GBPCAD]+aStrength[NZDCAD])/7,1);
   aMeter[AUD] = NormalizeDouble((aLookup[AUDUSD]+aStrength[EURAUD]+aLookup[AUDCHF]+aLookup[AUDCAD]+aStrength[GBPAUD]+aLookup[AUDNZD]+aLookup[AUDJPY])/7,1);
   aMeter[JPY] = NormalizeDouble((aStrength[USDJPY]+aStrength[EURJPY]+aStrength[GBPJPY]+aStrength[NZDJPY]+aStrength[AUDJPY]+aStrength[CHFJPY]+aStrength[CADJPY])/7,1);     
   aMeter[NZD] = NormalizeDouble((aLookup[NZDUSD]+aStrength[EURNZD]+aStrength[GBPNZD]+aStrength[AUDNZD]+aLookup[NZDCAD]+aLookup[NZDCHF]+aLookup[NZDJPY])/7,1);
   infobox = infobox + "\nUSD: " + aMeter[USD] + ", EUR: " + aMeter[EUR] + ", GBP: " + aMeter[GBP]
         + ", CHF: " + aMeter[CHF] + ", CAD: " + aMeter[CAD] + ", AUD: " + aMeter[AUD]
          + ", JPY: " + aMeter[JPY] + ", NZD: " + aMeter[NZD]; 
   double top = 6;
   double bottom = 3;
   string topcur[8];
   string bottomcur[8];
   infobox = infobox + "\n\nTop: ";
   int x, y;
   x = 0;
   y = 0;
   for (index = 0; index < 8; index++) {
      if (aMeter[index] > top) { 
         infobox = infobox + ", " + aMajor[index];
         x++;
         topcur[x] = aMajor[index];
      }
   }
   infobox = infobox + "\n\nBottom: ";
   for (index = 0; index < 8; index++) {
      if (aMeter[index] < bottom) { 
         infobox = infobox + ", " + aMajor[index];
         y++;
         bottomcur[y] = aMajor[index];
      }
   }
   int j, k;
   int l, m;
   l = 0;
   m = 0;
   string current_currency1, current_currency2, symbol;
   infobox = infobox + "\n\nAnalysis: " + x + ", " + y;
   string buyitems[28];
   string sellitems[28];
   int check;
   for (j=1;j<=x;j++) {
      //infobox = infobox + "\nTop" + topcur[j];
      for (k=1;k<=y;k++) {
         //infobox = infobox + "\nBottom" + bottomcur[k];
         for (index = 0; index < ARRSIZE; index++) {
            RefreshRates();
            symbol = aPair[index];
            current_currency1 = StringSubstr(symbol, 0, 3);
            current_currency2 = StringSubstr(symbol, 3, 3);
            if (current_currency1 == topcur[j] && current_currency2 == bottomcur[k]) {
               infobox = infobox + "\nBuy: " + symbol + ", Spread: " + MarketInfo(symbol, MODE_SPREAD);
               check = lookupcurrency(symbol);
               if (check == 1) {
                  reverse_bid(1, symbol);
                  infobox = infobox + "\nCreate Buy Order: " + symbol;
                  SendAlert("Bullish", symbol, PERIOD_H1);
                  createorder(symbol, timeperiod, 1, TimeframeToString(timeperiod)); 
                  FileAppend(filename, orderbox + "\n" + impbox + infobox + createbox);
               }
            } else if (current_currency1 == bottomcur[k] && current_currency2 == topcur[j]) {
               infobox = infobox + "\nSell: " + symbol + ", Spread: " + MarketInfo(symbol, MODE_SPREAD);
               check = lookupcurrency(symbol);
               if (check == -1) {
                  reverse_bid(-1, symbol);
                  infobox = infobox + "\nCreate Sell Order: " + symbol;
                  SendAlert("Bearish", symbol, PERIOD_H1);
                  createorder(symbol, timeperiod, -1, TimeframeToString(timeperiod));     
                  FileAppend(filename, orderbox + "\n" + impbox + infobox + createbox);
               }
            }
         }
      }
   }
      Comment(orderbox, "\n", impbox, infobox, createbox);   
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

   if (stop_order_on_loss && gtotal <  max_loss_per_day) {
      createbox = createbox + " History has more loss for today NO TRADING";
      return (0);
   }

   if (current_symbol) {
      if (Symbol() != symbol) {
         createbox = createbox + " Current Symbol is Different NO TRADING";
         return (0);
      }
   }
   string current_currency1, current_currency2;
   if (ignore_particular_currency) {
      current_currency1 = StringSubstr(symbol, 0, 3);
      current_currency2 = StringSubstr(symbol, 3, 3);
      if (current_currency1 == ignore_currency || current_currency2 == ignore_currency) {
         createbox = createbox + " Currency contains ignore currency NO TRADING";
         return (0);
      }
   }
   if (ignore_particular_symbol) {
      if (ignore_symbol == symbol) {
         createbox = createbox + " Symbol contains ignore symbol NO TRADING";
         return (0);
      }
   }
   if (only_particular_currency) {
      current_currency1 = StringSubstr(symbol, 0, 3);
      current_currency2 = StringSubstr(symbol, 3, 3);
      if (current_currency1 == only_currency || current_currency2 == only_currency) {
      
      } else {
         createbox = createbox + " Currency does not contains only currency NO TRADING";
         return (0);
      }
   }
   if (only_particular_symbol) {
      if (only_symbol == symbol) {
      
      } else {
         createbox = createbox + " Symbol does not contains only symbol NO TRADING";
         return (0);
      }
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

   orders = CalculateCurrentOrders(symbol);//, ordertype
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
   /*if (symbol == "GBPCHF" || symbol == "GBPJPY" || symbol == "GBPCAD" || symbol == "GBPAUD" || symbol == "GBPNZD") {
      if (stoploss > 0) {
         new_stoploss = stoploss + 150;
      }
      if (takeprofit > 0) {
         new_takeprofit = takeprofit + 300;
      }
   }*/
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
            data(symbol, "Buy");
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
            data(symbol, "Sell");
           
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
int CalculateCurrentOrders(string symbol)//, int ordertype
  {
   int cnt=0;
   int i;
//----
  for(i=0;i<OrdersTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
         if(OrderSymbol()==symbol && OrderMagicNumber()==MAGICMA)// && ordertype == OrderType()
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
/*
int reverse_bid_positive(int type, string symbol)
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
}*/
int trailing_stop()
{
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
               //&& OrderProfit() > 0
               )  
               {                 
                  orderbox = StringConcatenate(orderbox, " - pt*InitialTrailingStop: ", (pt*InitialTrailingStop));
                  orderbox = StringConcatenate(orderbox, " - bids-OrderOpenPrice(): ", (bids-OrderOpenPrice()));
                  //if(bids-OrderOpenPrice()>pt*InitialTrailingStop)
                  //{
                     orderbox = StringConcatenate(orderbox, " - OrderStopLoss(): ", OrderStopLoss());
                     orderbox = StringConcatenate(orderbox, " - bids-pt*TrailingStop: ", (bids-pt*TrailingStop));
                     //Print(OrderSymbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", bids-pt*TrailingStop: ", (bids-pt*TrailingStop));
                     if(OrderStopLoss()<bids-pt*TrailingStop)
                     {
                        //Alert(OrderSymbol(), ", Modify Buy");
                        OrderModify(OrderTicket(),OrderOpenPrice(),bids-pt*TrailingStop,OrderTakeProfit(),0,Green);
                        //return(0);
                     }
                  //}
               }//end if
            } else if(OrderType()==OP_SELL) {
               // check for trailing stop
               if(InitialTrailingStop>0 
               //&& OrderProfit() > 0
               )  
                 {             
                  orderbox = StringConcatenate(orderbox, " - pt*InitialTrailingStop: ", (pt*InitialTrailingStop));
                  orderbox = StringConcatenate(orderbox, " - OrderOpenPrice()-asks: ", (OrderOpenPrice()-asks));    
                  //if((OrderOpenPrice()-asks)>(pt*InitialTrailingStop))
                    //{
                     orderbox = StringConcatenate(orderbox, " - OrderStopLoss(): ", OrderStopLoss());
                     orderbox = StringConcatenate(orderbox, " - asks+pt*TrailingStop: ", (asks+pt*TrailingStop));
                     if((OrderStopLoss()>(asks+pt*TrailingStop)) || (OrderStopLoss()==0))
                       {
                        //Alert(OrderSymbol(), ", Modify Sell");
                        OrderModify(OrderTicket(),OrderOpenPrice(),asks+pt*TrailingStop,OrderTakeProfit(),0,Red);
                        //return(0);
                       }
                    //}
                 }
            } 
         }
      }
//----
   return(0);
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

int lookupcurrency(string mySymbol)
{
      double val2, val3, val4, val5;
      double val6, val7, val8, val9, val8a, val9a, val10, val11, val10a, val11a, val12, val13, val12a, val13a, val14, val15, val14a, val15a;
         val2 = iCustom(mySymbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,0);
         val3 = iCustom(mySymbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,0);
         val4 = iCustom(mySymbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,1);
         val5 = iCustom(mySymbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,1);
         val8 = iCustom(mySymbol, PERIOD_M30, "Heiken_Ashi_Smoothed",2,0);
         val9 = iCustom(mySymbol, PERIOD_M30, "Heiken_Ashi_Smoothed",3,0);
         val8a = iCustom(mySymbol, PERIOD_M30, "Heiken_Ashi_Smoothed",2,1);
         val9a = iCustom(mySymbol, PERIOD_M30, "Heiken_Ashi_Smoothed",3,1);
         val10 = iCustom(mySymbol, PERIOD_M15, "Heiken_Ashi_Smoothed",2,0);
         val11 = iCustom(mySymbol, PERIOD_M15, "Heiken_Ashi_Smoothed",3,0);
         val10a = iCustom(mySymbol, PERIOD_M15, "Heiken_Ashi_Smoothed",2,1);
         val11a = iCustom(mySymbol, PERIOD_M15, "Heiken_Ashi_Smoothed",3,1);
         val12 = iCustom(mySymbol, PERIOD_M5, "Heiken_Ashi_Smoothed",2,0);
         val13 = iCustom(mySymbol, PERIOD_M5, "Heiken_Ashi_Smoothed",3,0);
         val12a = iCustom(mySymbol, PERIOD_M5, "Heiken_Ashi_Smoothed",2,1);
         val13a = iCustom(mySymbol, PERIOD_M5, "Heiken_Ashi_Smoothed",3,1);
         val14 = iCustom(mySymbol, PERIOD_M1, "Heiken_Ashi_Smoothed",2,0);
         val15 = iCustom(mySymbol, PERIOD_M1, "Heiken_Ashi_Smoothed",3,0);
         val14a = iCustom(mySymbol, PERIOD_M1, "Heiken_Ashi_Smoothed",2,1);
         val15a = iCustom(mySymbol, PERIOD_M1, "Heiken_Ashi_Smoothed",3,1);
     if (
         (val2 < val3 && val8 < val9 && val10 < val11 && val12 < val13 && val14 < val15)
         &&
         (val4 > val5 || val8a > val9a || val10a > val11a || val12a > val13a || val14a > val15a)
         ) {
         if (val4 > val5) timeperiod = PERIOD_H1;
         if (val8a > val9a) timeperiod = PERIOD_M30;
         if (val10a > val11a) timeperiod = PERIOD_M15;
         if (val12a > val13a) timeperiod = PERIOD_M5;
         if (val14a > val15a) timeperiod = PERIOD_M1;
            return (1);
         } else if (
         (val2 > val3 && val8 > val9 && val10 > val11 && val12 > val13 && val14 > val15)
         &&
         (val4 < val5 || val8a < val9a || val10a < val11a || val12a < val13a || val14a < val15a)
         ) {
         if (val4 < val5) timeperiod = PERIOD_H1;
         if (val8a < val9a) timeperiod = PERIOD_M30;
         if (val10a < val11a) timeperiod = PERIOD_M15;
         if (val12a < val13a) timeperiod = PERIOD_M5;
         if (val14a < val15a) timeperiod = PERIOD_M1;
            return (-1);
         }
         return (0);
}

int data(string symbol, string type)
{
   int period[9] = {PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4, PERIOD_D1, PERIOD_W1, PERIOD_MN1};
   infobox = infobox + "\nData Center For Symbol: " + symbol + " for condition: " + type + "\n";
   //MACD
   int i;
   int limit = 9;
   double digit = MarketInfo(symbol, MODE_DIGITS);
   double val, val2, val3;
   for (i = 0; i < limit; i++) {
      val2 = iCustom(symbol, period[i], "MACD_Complete",1,0);
      val3 = iCustom(symbol, period[i], "MACD_Complete",2,0);
      infobox = infobox + "\nMACD (" + TimeframeToString(period[i]) + "): Val2: " + DoubleToStr(val2, digit) + ",  Val3: " + DoubleToStr(val3, digit);
      if (val2 > val3) {
         infobox = infobox + " - BUY";
      } else if (val2 < val3 && val2 < 0) {
         infobox = infobox + " - SELL";
      } else {
         infobox = infobox + " - CONSOLIDATE";
      }
   }
   for (i = 0; i < limit; i++) {
      val2 = iCCI(symbol,period[i],45,PRICE_CLOSE,0);
      infobox = infobox + "\nCCI (" + TimeframeToString(period[i]) + "): Val2(45): " + DoubleToStr(val2, digit);
      if (val2 > 100) {
         infobox = infobox + " - BUY";
      } else if (val2 < -100) {
         infobox = infobox + " - SELL";
      } else {
         infobox = infobox + " - CONSOLIDATE";
      }
   }
   for (i = 0; i < limit; i++) {
      val2 = iRSI(symbol,period[i],7,PRICE_CLOSE,0);
      infobox = infobox + "\nRSI (" + TimeframeToString(period[i]) + "): Val2(7): " + DoubleToStr(val2, digit);
      if (val2 > 70) {
         infobox = infobox + " - BUY";
      } else if (val2 < 30) {
         infobox = infobox + " - SELL";
      } else {
         infobox = infobox + " - CONSOLIDATE";
      }
   }
   for (i = 0; i < limit; i++) {      
      val = iMA(symbol,period[i],17,0,MODE_EMA,PRICE_CLOSE,0);
      val2 = iMA(symbol,period[i],43,0,MODE_EMA,PRICE_CLOSE,0);
      infobox = infobox + "\nEMA (" + TimeframeToString(period[i]) + "): val(17): " + DoubleToStr(val, digit) + ",  val2(43): " + DoubleToStr(val2, digit);
      if (val > val2) {
         infobox = infobox + " - BUY";
      } else if (val < val2) {
         infobox = infobox + " - SELL";
      } else {
         infobox = infobox + " - CONSOLIDATE";
      }
   }
   for (i = 0; i < limit; i++) {      
      val = iStochastic(symbol,period[i],14,3,3,MODE_SMA,0,MODE_MAIN,0);
      val2 = iStochastic(symbol,period[i],14,3,3,MODE_SMA,0,MODE_SIGNAL,0);
      infobox = infobox + "\nStochastic (" + TimeframeToString(period[i]) + "): val: " + DoubleToStr(val, digit) + ",  val2: " + DoubleToStr(val2, digit);
      if (val > val2) {
         infobox = infobox + " - BUY";
      } else if (val < val2) {
         infobox = infobox + " - SELL";
      } else {
         infobox = infobox + " - CONSOLIDATE";
      }
   }
   for (i = 0; i < limit; i++) {      
      val = iSAR(symbol,period[i],0.02,0.2,0);
      infobox = infobox + "\nParabolic SAR (" + TimeframeToString(period[i]) + "): val: " + DoubleToStr(val, digit);
      if (val < iOpen(symbol, period[i], 0)) {
         infobox = infobox + " - BUY";
      } else if (val > iOpen(symbol, period[i], 0)) {
         infobox = infobox + " - SELL";
      } else {
         infobox = infobox + " - CONSOLIDATE";
      }
   }
   double tenkan_sen_1, kijun_sen_1, chinkouspan, spanA, spanB;
   infobox = infobox + "\nICHIMOKU";
   for (i = 0; i < limit; i++) {      
      tenkan_sen_1=iIchimoku(symbol,period[i], 9, 26, 52, MODE_TENKANSEN, 0);
      kijun_sen_1=iIchimoku(symbol,period[i], 9, 26, 52, MODE_KIJUNSEN, 0);
      infobox = infobox + "\nTenkan Crossing (" + TimeframeToString(period[i]) + "): tenkan_sen_1: " + DoubleToStr(tenkan_sen_1, digit) + ",  kijun_sen_1: " + DoubleToStr(kijun_sen_1, digit);
      if (tenkan_sen_1 > kijun_sen_1) {
         infobox = infobox + " - BUY";
      } else if (tenkan_sen_1 < kijun_sen_1) {
         infobox = infobox + " - SELL";
      } else {
         infobox = infobox + " - CONSOLIDATE";
      }
   }
   for (i = 0; i < limit; i++) {  
      spanA = iIchimoku(symbol,period[i], 9, 26, 52, MODE_SENKOUSPANA, -25);
      spanB = iIchimoku(symbol,period[i], 9, 26, 52, MODE_SENKOUSPANB, -25);
      infobox = infobox + "\nSpan Crossing (26 Future) (" + TimeframeToString(period[i]) + "): spanA: " + DoubleToStr(spanA, digit) + ",  spanB: " + DoubleToStr(spanB, digit);
      if (spanA > spanB) {
         infobox = infobox + " - BUY";
      } else if (spanA < spanB) {
         infobox = infobox + " - SELL";
      } else {
         infobox = infobox + " - CONSOLIDATE";
      }
   }
   for (i = 0; i < limit; i++) {  
      chinkouspan = iIchimoku(symbol,period[i], 9, 26, 52, MODE_CHINKOUSPAN, 0+26);
      infobox = infobox + "\nSpan Crossing (26 Future) (" + TimeframeToString(period[i]) + "): chinkouspan: " + DoubleToStr(chinkouspan, digit);
      if (chinkouspan > iHigh(symbol, period[i], 0+26)) {
         infobox = infobox + " - BUY";
      } else if (chinkouspan < iLow(symbol, period[i], 0+26)) {
         infobox = infobox + " - SELL";
      } else {
         infobox = infobox + " - CONSOLIDATE";
      }
   }
}

int history()
{
   int cnt;
   int total = OrdersHistoryTotal();
   gtotal = 0;
   for(cnt=0;cnt<total;cnt++)
   {
      OrderSelect(cnt, SELECT_BY_POS, MODE_HISTORY);
      if (OrderMagicNumber()==MAGICMA 
         && TimeDay(OrderCloseTime()) == Day() 
         && TimeMonth(OrderCloseTime()) == Month()
         && TimeYear(OrderCloseTime()) == Year()      
      ) {
         gtotal += OrderProfit();
         //Print("Cnt: ", cnt, ", ticket: ", OrderTicket(), ", Order Profit: ", OrderProfit(), ", currency: ", OrderSymbol());
         //Print("close day: ", TimeDay(OrderCloseTime()), ", close month: ", TimeMonth(OrderCloseTime()), ", close year: ", TimeYear(OrderCloseTime())
            //, ", current day: ", Day(), ", current month: ", Month(), ", current year: ", Year()
         //);
      }
   }
   infobox = infobox + "\nTotal Profit/Loss For Today: " + DoubleToStr(gtotal, 2) + ", max loss for today: " + DoubleToStr(max_loss_per_day, 2);
   //Print("Total: ", gtotal);
   if (gtotal <  max_loss_per_day) {
      return (0);
   }
   return (1);
}

