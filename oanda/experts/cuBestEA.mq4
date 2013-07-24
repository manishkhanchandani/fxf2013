//+------------------------------------------------------------------+
//|                                                     cuBestEA.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

#include <stdlib.mqh>
#include <WinUser32.mqh>
#include <strategies.mqh>
string symbol;
int gtotal;
int best = 0;
int best2 = 0;
int sel = 0;
int sel2 = 0;
extern int istrategy = 0;
extern int iperiod = 0;
extern int magic = 131;
extern double initialAmount = 0;
extern int percPerDay = 3;
double todaysPlan;
extern double fixedLots = 0.18;

#define ARRSIZE  31
#define PAIRSIZE 10

double stoploss[ARRSIZE];
int typeoforder[ARRSIZE];
double totalcost[ARRSIZE];
int totalorders[ARRSIZE];
double lotsavg[ARRSIZE];
double averagecostingprice[ARRSIZE];
double totalprofit[ARRSIZE];
double returncost[ARRSIZE];
int difference[ARRSIZE];

bool logs = true;
int opentime;
string infobox;
string inference;

int open[ARRSIZE];
int close[ARRSIZE];
int startProcess[ARRSIZE][2];
int stoch_process[ARRSIZE];

string aPair[ARRSIZE]   = {
                        "USDCHF","GBPUSD","EURUSD","USDJPY","USDCAD","AUDUSD",
                        "EURGBP","EURAUD","EURCHF","EURJPY","GBPCHF","CADJPY",
                        "GBPJPY","AUDNZD","AUDCAD","AUDCHF","AUDJPY","CHFJPY",
                        "EURNZD","EURCAD","CADCHF","NZDJPY","NZDUSD","GBPCAD",
                        "GBPNZD","GBPAUD","NZDCHF","NZDCAD","XAUJPY","XAUUSD","XAGUSD"
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
#define XAUJPY 28
#define XAUUSD 29
#define XAGUSD 30

// Currency
#define USD 0
#define EUR 1
#define GBP 2
#define CHF 3                                                                                      
#define CAD 4                                                                                      
#define AUD 5                                                                                      
#define JPY 6                                                                                      
#define NZD 7 
#define XAU 8
#define XAG 9

string aMajor[PAIRSIZE] = {"USD","EUR","GBP","CHF","CAD","AUD","JPY","NZD"};


int hour;
extern int gmtoffset = 3;
extern bool custom_hours = false;
extern int from_hour1 = 0;
extern int to_hour1 = 23;
extern int from_hour2 = 0;
extern int to_hour2 = 23;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
   symbol = Symbol();
   if (istrategy > 0 && iperiod > 0) {
      sel = iperiod;
      best = istrategy;
   } else {
      int periods[10] = {PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4};
      int max = -9999;
      int max2 = -9999;
      infobox = "";
      for (int j = 1; j <= 18; j++) {
         if (j == 16 || j == 18) continue;
         for (int i = 1; i < 6; i++) {
            double val = iCustom(symbol, periods[i], "cuSpan", j, 4, 0);
            //infobox = infobox + "\nSymbol: " + symbol + ", Period: " + periods[i] + ", Strategy: " + j + ", Val: " + val;
            if (val > max && val != EMPTY_VALUE) {
               max = val;
               sel = periods[i];
               best = j;
            }
         }
      }
      inference = "\nmax: " + max + ", sel: " + sel + ", best Strategy = " + best + ", Spread: " + MarketInfo(symbol, MODE_SPREAD);
   
      for (j = 1; j <= 18; j++) {
         if (j == 16 || j == 18) {} else continue;
         for (i = 1; i < 6; i++) {
            val = iCustom(symbol, periods[i], "cuSpan", j, 4, 0);
            //infobox = infobox + "\nSymbol: " + symbol + ", Period: " + periods[i] + ", Strategy: " + j + ", Val: " + val;
            if (val > max2 && val != EMPTY_VALUE) {
               max2 = val;
               sel2 = periods[i];
               best2 = j;
            }
         }
      }
      inference = inference + ", 16 or 18: max: " + max2 + ", sel: " + sel2 + ", best Strategy = " + best2;
   }
   Comment(inference, infobox);
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
   
   hour = Hour() - gmtoffset;
   if (hour < 0) {
      hour = 24 + hour;
   }
   bool trading_hours = true;
   if (custom_hours) {
      trading_hours = false;
      if ((hour >= from_hour1 && hour <= to_hour1) || (hour >= from_hour2 && hour <= to_hour2)) {
         trading_hours = true;
      }
   }
   infobox = "";
   int condition_open = 0;
   int condition_close = 0;
   double history = history(magic, Symbol());
   infobox = infobox + "\nMagic: " + magic
      + ", History: " + history;
   if (initialAmount == 0) initialAmount = AccountBalance();
   double total = initialAmount + history;
   double aim = (total * percPerDay/100);
   double lots = ((total / 100) * 0.5) / 100;
   if (lots < 0.01) lots = 0.01;
   lots = NormalizeDouble(lots, 2);
   if (custom_hours) {
   infobox = infobox + ", Trading Hours: " + trading_hours + " (Current Hour: " + hour 
      + " Allowed Hours: " + from_hour1 + " - " + to_hour1 + " And " + from_hour2 + " - " + to_hour2   +
      ", Day: " + Day() + ", Month: " + Month() + ")";
   }
   infobox = infobox + ", Total: " + total + ", Lots: " + DoubleToStr(lots, 2) 
      + ", Aim: " + DoubleToStr(aim, 2);
   fixedLots = NormalizeDouble(fixedLots, 2);
   if (fixedLots > 0) lots = fixedLots;
   infobox = infobox + ", fixedLots: " + fixedLots;
   double newlots = lots;
   int x; string symbol;
   //trailingstop(magic);
   //for (int m = 0; m < 5; m++) {
      int newperiod = PERIOD_M30;
      for (x = 0; x < ARRSIZE; x++) {
         symbol = aPair[x];
         bool buy = true;
         bool sell = true;
         int i = x;
         string current_currency1 = StringSubstr(symbol, 0, 3);
         string current_currency2 = StringSubstr(symbol, 3, 3);
         if (symbol != Symbol()) {
            continue;
         }
         int digit = MarketInfo(symbol, MODE_DIGITS);
         infobox = infobox + "\nSymbol: " + symbol + ", Digits: " + digit + ", Period: " + newperiod
          + ", Spread: " + DoubleToStr(MarketInfo(symbol, MODE_SPREAD), 0) + ", newlots: " + newlots;
         condition_open = 0;
         condition_close = 0;
         string message = magic;
         infobox = infobox + ", buy: " + buy + ", sell: " + sell;
         condition_open = condition_open(symbol, x);

         if (condition_open == 1) {
            closelogicwithoutprofit(symbol, magic, 1);
         }
         else if (condition_open == -1) {
            closelogicwithoutprofit(symbol, magic, -1);
         }

         if (condition_open == 1) {
            if (buy && trading_hours) create_order(symbol, 1, newlots, magic, message, 0, 0);
         }
         else if (condition_open == -1) {
            if (sell && trading_hours) create_order(symbol, -1, newlots, magic, message, 0, 0);
         }
      }
   //}
   infobox = infobox + "\n\nORDERS:\n"+magic;
   double gtotal;
   for(i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()==magic && OrderSymbol() == Symbol()) {
         gtotal = gtotal + OrderProfit();
         infobox = infobox + "\nSymbol: "+OrderSymbol()+" with profit: "+OrderProfit();
     }
   }
   infobox = infobox + "\nTotal: " + gtotal;
   Comment(inference, infobox);
   opentime = iTime(Symbol(), Period(), 0);
//----
   return(0);
  }
//+------------------------------------------------------------------+


int condition_open(string symbol, int mode)
{
   int check = 0;
   int strategy = best;
   infobox = infobox + ", Strategy: " + strategy + ", Period: " + sel;
   check = get_strategy_result(strategy, symbol, sel, 1, 0);
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
   int expiration = TimeCurrent()+(6*3600);
   if (type == 1) {
      ticket=OrderSend(symbol,OP_BUY,Lots,MarketInfo(symbol, MODE_ASK),3,0,0,message,magicnumber,0,Green);
      Sleep(sleeptime);
      if(ticket>0) {
         if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
            price = MarketInfo(symbol, MODE_ASK);
            if (stoploss > 0) {
               sl = price - (stoploss * pt);
               sl = NormalizeDouble(sl, digit);
            }
            if (takeprofit > 0) {
               tp = price + (takeprofit * pt);
               tp = NormalizeDouble(tp, digit);
            }
            OrderModify(OrderTicket(),OrderOpenPrice(),sl,tp,0,Green); 
            Sleep(sleeptime);
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
            Sleep(sleeptime);            
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

double history(int magicnum, string symbol)
{
   int cnt;
   int total = OrdersHistoryTotal();
   double gtotal = 0;
   for(cnt=0;cnt<total;cnt++)
   {
      OrderSelect(cnt, SELECT_BY_POS, MODE_HISTORY);
      if (OrderMagicNumber()==magicnum && OrderSymbol() == symbol) {
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