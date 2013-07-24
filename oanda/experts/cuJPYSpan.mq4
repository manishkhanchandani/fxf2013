//+------------------------------------------------------------------+
//|                                               customIchimoku.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <stdlib.mqh>
#include <WinUser32.mqh>
#include <strategies.mqh>
extern int magic = 131;
extern double initialAmount = 0;
extern int percPerDay = 3;
double todaysPlan;
extern double fixedLots = 0.05;
extern bool forced = false;

bool logs = true;
int opentime;
string infobox;
#define ARRSIZE  28
#define PAIRSIZE 10

string aPair[ARRSIZE]   = {
                        "USDCHF","GBPUSD","EURUSD","USDJPY","USDCAD","AUDUSD",
                        "EURGBP","EURAUD","EURCHF","EURJPY","GBPCHF","CADJPY",
                        "GBPJPY","AUDNZD","AUDCAD","AUDCHF","AUDJPY","CHFJPY",
                        "EURNZD","EURCAD","CADCHF","NZDJPY","NZDUSD","GBPCAD",
                        "GBPNZD","GBPAUD","NZDCHF","NZDCAD"
                        };

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

string aMajor[PAIRSIZE] = {"USD","EUR","GBP","CHF","CAD","AUD","JPY","NZD"};



//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   //start();
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
   if (opentime != iTime(Symbol(), Period(), 0)){
   //todaysPlan=B4 + (B4 * (3/100))
   //buy logic
   infobox = "";
   int condition_open = 0;
   int condition_close = 0;
   double history = history(magic);
   infobox = infobox + "\nMagic: " + magic
      + ", History: " + history;
   if (initialAmount == 0) initialAmount = AccountBalance();
   double total = initialAmount + history;
   if (total <= 0) {
      //Comment("EA not working correctly.");
      //return (0);
   }
   double aim = (total * percPerDay/100);
   double lots = ((total / 100) * 0.5) / 100;
   if (lots < 0.01) lots = 0.01;
   lots = NormalizeDouble(lots, 2);
   infobox = infobox + ", Total: " + total + ", Lots: " + DoubleToStr(lots, 2) 
      + ", Aim: " + DoubleToStr(aim, 2);
   fixedLots = NormalizeDouble(fixedLots, 2);
   if (fixedLots > 0) lots = fixedLots;
   infobox = infobox + ", fixedLots: " + fixedLots;
   int x; string symbol;
   //for (int m = 0; m < 5; m++) {
      int newmagic = magic;
      int newperiod = PERIOD_M30;
      for (x = 0; x < ARRSIZE; x++) {
         symbol = aPair[x];
         bool buy = true;
         bool sell = true;
         int i = x;
         string current_currency1 = StringSubstr(symbol, 0, 3);
         string current_currency2 = StringSubstr(symbol, 3, 3);
         if (
         x == EURJPY 
         || 
         x == CHFJPY) {
         
         } else continue;
         int digit = MarketInfo(symbol, MODE_DIGITS);
         infobox = infobox + "\nSymbol: " + symbol + ", Digits: " + digit + ", Period: " + newperiod
          + ", Spread: " + DoubleToStr(MarketInfo(symbol, MODE_SPREAD), 0);
         condition_open = 0;
         condition_close = 0;
         string message = newmagic;
         condition_open = condition_open(symbol, newperiod, 1, x);
         condition_close = condition_close(symbol, newperiod, 1, x);
         infobox = infobox + ", buy: " + buy + ", sell: " + sell;

         if (condition_close == 1) {
            closelogicwithoutprofit(symbol, newmagic, 1);
         }
         else if (condition_open == -1) {
            closelogicwithoutprofit(symbol, newmagic, -1);
         }

         if (condition_open == 1) {
            if (buy) create_order(symbol, 1, lots, newmagic, message, 0, 0);
         }
         else if (condition_open == -1) {
            if (sell) create_order(symbol, -1, lots, newmagic, message, 0, 0);
         }
      }
   //}
   infobox = infobox + "\n\nORDERS:\n"+newmagic;
   double gtotal;
   for(i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()==newmagic) {
         gtotal = gtotal + OrderProfit();
         infobox = infobox + "\nSymbol: "+OrderSymbol()+" with profit: "+OrderProfit();
     }
   }
   infobox = infobox + "\nTotal: " + gtotal;
   Comment(infobox);
   opentime = iTime(Symbol(), Period(), 0);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+


int condition_open(string symbol, int period, int shift, int mode)
{
   int check = 0;
   int strategy = 0;
   if (symbol == "EURJPY") strategy = 1;
   else strategy = 1;
   infobox = infobox + ", Strategy: " + strategy;
   check = get_strategy_result(strategy, symbol, period, shift, 0);
   infobox = infobox + ", RESULT: " + check;
   return (check);
}


int condition_close(string symbol, int period, int shift, int mode)
{
   int check = 0;
   int strategy = 0;
   if (symbol == "EURJPY") strategy = 1;
   else strategy = 1;
   infobox = infobox + ", Strategy: " + strategy;
   check = get_strategy_result(strategy, symbol, period, shift, 1);
   infobox = infobox + ", RESULT: " + check;
   return (check);
}

int create_order(string symbol, int type, double Lots, int magicnumber, string message, int stoploss, int takeprofit)
{
   int orders;
   int ordertype;
   double price;
   double val3;
   int sleeptime = 1000;
   double bids, asks, pt, digit;
   int ticket;
   double tp, sl;
   tp = 0;
   sl = 0;

   string createbox = createbox + "\n" + symbol;
   //Step 1: check different conditions
   if (IsTradeAllowed()==false) {
      createbox = createbox + " TRADING NOW ALLOWED";
      return (0);
   }
   
   
   if (type == 1) {
      ordertype = OP_BUY;
   } else if (type == -1) {
      ordertype = OP_SELL;
   } else {
      return (0);
   }
   
   orders = CalculateCurrentOrders(symbol, magicnumber);//, ordertype
   if (orders > 0)
   {
      createbox = createbox + " previous orders: " + orders + " NO TRADING";
       return (0);
   }
   //Step 2: create order
   bids = MarketInfo(symbol, MODE_BID);
   asks = MarketInfo(symbol, MODE_ASK);
   pt = MarketInfo(symbol, MODE_POINT);
   digit = MarketInfo(symbol, MODE_DIGITS);
   bids = NormalizeDouble(bids, digit);
   asks = NormalizeDouble(asks, digit);
   int s;
   if (type == 1) {
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
         }
      } else {
         Print(symbol, ", Error opening BUY order : ",ErrorDescription(GetLastError()), ", asks: ", asks, ", lots: ", Lots);
         Sleep(sleeptime);
         //create_order(symbol, type, Lots, magicnumber, message, stoploss, takeprofit);
      }
      Sleep(sleeptime);
      return(0);
   } else if (type == -1) {
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
            
         }
      } else {
         Print(symbol, ", Error opening SELL order : ",ErrorDescription(GetLastError()), ", bids: ", bids, ", lots: ", Lots);
         Sleep(sleeptime);
         //create_order(symbol, type, Lots, magicnumber, message, stoploss, takeprofit);
      }
      Sleep(sleeptime);
      return(0);
   }
}


int CalculateCurrentOrders(string symbol, int magicnumber)//, int ordertype
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

double history(int magicnum)
{
   int cnt;
   int total = OrdersHistoryTotal();
   double gtotal = 0;
   for(cnt=0;cnt<total;cnt++)
   {
      OrderSelect(cnt, SELECT_BY_POS, MODE_HISTORY);
      if (OrderMagicNumber()==magicnum) {
         gtotal += OrderProfit();
      }
   }
   return (gtotal);
}




int closelogicwithoutprofit(string symbol, int magicnumber, int typeHere)
{
   int i;

   for(i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()==magicnumber && OrderSymbol()==symbol) {
         if(OrderType()==OP_BUY && typeHere == -1)
           {
            if (logs) Print(symbol, ", closing buy order");
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_BID),3,White);
           }
         if(OrderType()==OP_SELL && typeHere == 1)
           {
            if (logs) Print(symbol, ", closing sell order");
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_ASK),3,White);
         
           }
     }
   }
   return (0);
}