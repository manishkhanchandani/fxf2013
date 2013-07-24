//+------------------------------------------------------------------+
//|                                    ForexMasteryMillionDollar.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

#include <stdlib.mqh>
#include <WinUser32.mqh>
#include <http51.mqh>
#include <strategies.mqh>

extern string EA_Version = "1.4"; /*1.1 changes: settings shown*/
extern string label_0 = " === Account Information === ";
extern string username = "nkhanchandani";
extern double inital_amount = 0;
extern string label_1 = " === Order Information === ";
extern double lotsize = 0.0;
extern int max_orders = 28;
extern int maxspread = 150;
extern int stop_loss = 0;
extern int take_profit = 0;
extern int magic = 123;
extern int magic_0 = 124;
extern int magic_1 = 125;
extern string symbol_suffix = "";
extern string label_2 = " === Symbol Information === ";
extern string label_3 = "USE All for all symbols, else comma separated symbols to include those";
extern string includeSymbols = "All";
extern string label_4 = "USE comma separated symbols to include those";
extern string excludeSymbols = "";
extern bool logs = false;
string product = "MillionDollar";
int opentime, opentimeAuth, opentimeOrders, opentimeOrders2;
string infobox;
string inference;
string inference2;
string inference3;
double lots;
int counter = 0;
int checked = 0;

#define ARRSIZE  28
#define PAIRSIZE 8


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
   opentimeAuth = 0;
   opentime = 0;
   opentimeOrders = 0;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   opentimeAuth = 0;
   opentime = 0;
   opentimeOrders = 0;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   int k;
   string message;
   int check = 0;
   int check2 = 0;
   int current = 0;
   int strategy;
   int periods[5] = {PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4, PERIOD_D1};
   int period;
   int p;
   string symbol;
   int val;
   int gtotal = 0;
   int proceed = 0;
   string fnSt = "";
   int handle = 0;
   string str = "";
   string resultString[];
      if (opentime != iTime(Symbol(), PERIOD_M15, 0)) {
         opentime = iTime(Symbol(), PERIOD_M15, 0);
         infobox = "";
         infobox = infobox + intro();
         infobox = infobox + "\n\nAutomatic";
         infobox = infobox + condition_for_close(magic);
         for (int x = 0; x < ARRSIZE; x++) {
            symbol = aPair[x];
            message = magic + ", " + PERIOD_M15 + ", " + 26 + ", " + 1;
            int st = 26;
            check = get_strategy_result(st, symbol, PERIOD_M15, 1, 0);
            infobox = infobox + "\nSymbol: " + symbol + ", Best: " + st + "(" + get_strategy_name(st) 
                        + "), Change: " + check
                        + ", Period: " + TimeframeToString(PERIOD_M15)
                        + ", Message: " + message
                        + ", Spread: " + DoubleToStr(MarketInfo(symbol, MODE_SPREAD), 0)
                        ;
            if (check == 1) {
               create_order(symbol, 1, lots, magic, message, stop_loss, take_profit);
            } else if (check == -1) {
               create_order(symbol, -1, lots, magic, message, stop_loss, take_profit);
            }
         }
      }
      Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+

int converttotime(string timeframe)
{
   if (timeframe == "M1") return (1);
   else if (timeframe == "M5") return (5);
   else if (timeframe == "M15") return (15);
   else if (timeframe == "M30") return (30);
   else if (timeframe == "H1") return (60);
   else if (timeframe == "H4") return (240);
   else if (timeframe == "D1") return (1440);
   else return (0);
}

void FileAppend(string name,string txt)
{
   int handle = FileOpen(name,FILE_READ|FILE_WRITE);
	FileSeek(handle,0,SEEK_END);
	FileWrite(handle,txt);
	FileFlush(handle);
	FileClose(handle);
}


//+------------------------------------------------------------------+  
//+------------------------------------------------------------------+
// Helper function for parsing command strings, results resides in g_parsedString.
bool SplitString(string stringValue, string separatorSymbol, string& results[])
{
//	 Alert("--SplitString--");
//	 Alert(stringValue);

   if (StringFind(stringValue, separatorSymbol) < 0)
   {// No separators found, the entire string is the result.
      ArrayResize(results, 1);
      results[0] = stringValue;
   }
   else
   {   
      int separatorPos = 0;
      int newSeparatorPos = 0;
      int size = 0;

      while(newSeparatorPos > -1)
      {
         size = size + 1;
         newSeparatorPos = StringFind(stringValue, separatorSymbol, separatorPos);
         
         ArrayResize(results, size);
         if (newSeparatorPos > -1)
         {
            if (newSeparatorPos - separatorPos > 0)
            {  // Evade filling empty positions, since 0 size is considered by the StringSubstr as entire string to the end.
               results[size-1] = StringSubstr(stringValue, separatorPos, newSeparatorPos - separatorPos);
            }
         }
         else
         {  // Reached final element.
            results[size-1] = StringSubstr(stringValue, separatorPos, 0);
         }
         
         
         //Alert(results[size-1]);
         separatorPos = newSeparatorPos + 1;
      }
   }   
   
   if (ArraySize(results) > 0)
   {  // Results OK.
      return (true);
   }
   else
   {  // Results are WRONG.
      Print("ERROR - size of parsed string not expected.", true);
      return (false);
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

string condition_for_close(int magicNumber)
{
   string closebox;
   closebox = closebox + "\nCHECKING CLOSURES: " + magicNumber;
   int cnt=0;
   int i;
   int timePeriod;
   int st;
   for(i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderMagicNumber()==magicNumber) {
         cnt++;
         string result[3];
         SplitString(OrderComment(), ", ", result);
         int newMagic = StrToInteger(result[0]);
         timePeriod = StrToInteger(result[1]);
         st = StrToInteger(result[2]);
         if (newMagic != OrderMagicNumber()) continue;
         int check = 0;
         check = get_strategy_result(st, OrderSymbol(), timePeriod, 1, 0);
         int check2 = get_strategy_result(st, OrderSymbol(), timePeriod, 1, 1);
         closebox = closebox + "\nClosing Strategy: Strategy: " + st + ", symbol: " + OrderSymbol() + ", timePeriod: " + timePeriod + ", Check: " + check
         + ", magic: " + newMagic
          + ", Profit: " + OrderProfit()
          + ", check: " + check
          + ", chec2: " + check2
          ;
         string msg;
         if (check == 1 || check2 == 1) {
            closelogicwithoutprofit(OrderSymbol(), newMagic, 1);
         }
         else if (check == -1 || check2 == -1) {
            closelogicwithoutprofit(OrderSymbol(), newMagic, -1);
         }
      }
   }
      
   return (closebox);
}



string condition_for_close_single(int magicNumber, string symbol)
{
   string closebox;
   closebox = closebox + "\nCHECKING CLOSURES: " + magicNumber + " and symbol: " + symbol;
   int cnt=0;
   int i;
   int timePeriod;
   int st;
   for(i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderMagicNumber()==magicNumber && OrderSymbol() == symbol) {
         cnt++;
         string result[3];
         SplitString(OrderComment(), ", ", result);
         int newMagic = StrToInteger(result[0]);
         timePeriod = StrToInteger(result[1]);
         st = StrToInteger(result[2]);
         int shift = StrToInteger(result[3]);
         int current = 0;
         if (shift == 0) current = 1;
         if (newMagic != OrderMagicNumber()) continue;
         int check = 0;
         check = get_strategy_result(st, OrderSymbol(), timePeriod, shift, current);
         closebox = closebox + "\nClosing Strategy: Strategy: " + st + ", symbol: " + OrderSymbol() + ", timePeriod: " + timePeriod + ", Check: " + check
         + ", magic: " + newMagic + ", Shift: " + shift + ", Current: " + current
          + ", Profit: " + OrderProfit()
          ;
         string msg;
         if (check == 1) {
            closelogicwithoutprofit(OrderSymbol(), newMagic, 1);
         }
         else if (check == -1) {
            closelogicwithoutprofit(OrderSymbol(), newMagic, -1);
         }
      }
   }
      
   return (closebox);
}


bool checkIncludeSymbol(string symbol)
{
   if (includeSymbols == "All") {
      return (true);
   }

   if (includeSymbols == "") {
      return (false);
   }
   
   string results[];
   SplitString(includeSymbols, ",", results);
   bool proceed = false;
   for (int i=0; i < ArraySize(results); i++) {
      if (symbol == results[i]) {
         proceed = true;
      }
   }

   return (proceed);
}

bool checkExcludeSymbol(string symbol)
{
   if (excludeSymbols == "All") {
      return (false);
   }

   if (excludeSymbols == "") {
      return (true);
   }
   
   string results[];
   SplitString(excludeSymbols, ",", results);
   bool proceed = true;
   for (int i=0; i < ArraySize(results); i++) {
      if (symbol == results[i]) {
         proceed = false;
      }
   }

   return (proceed);
}

bool checkSymbol(string symbol)
{
   if (!checkIncludeSymbol(symbol)) {
      return (false);
   }
   if (!checkExcludeSymbol(symbol)) {
      return (false);
   }
   return (true);
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
   if (logs) Print("Creating order for symbol: ", symbol, " with magic: ", magicnumber);
   string createbox = symbol + ", " + magicnumber;
   //Step 1: check different conditions
   if (IsTradeAllowed()==false) {
      createbox = createbox + " TRADING NOW ALLOWED";
      if (logs) Print(createbox);
      return (0);
   }
   if (MarketInfo(symbol, MODE_SPREAD) >= maxspread) {
      createbox = createbox + " Spread is " + MarketInfo(symbol, MODE_SPREAD);
      if (logs) Print(createbox);
      return (0);
   }
   if (!checkSymbol(symbol)) {
      createbox = createbox + " Symbol Not Allowed.";
      if (logs) Print(createbox);
      return (0);
   }
   if (type == 1) {
      ordertype = OP_BUY;
   } else if (type == -1) {
      ordertype = OP_SELL;
   } else {
      return (0);
   }
   
   orders = CalculateCurrentOrdersv3(symbol, magicnumber);
   if (orders > 0)
   {
      createbox = createbox + " previous orders: " + orders + " NO TRADING";
      if (logs) Print(createbox);
       return (0);
   }
   orders = CalculateCurrent(symbol);
   if (orders > 0)
   {
      createbox = createbox + " previous symbol orders: " + orders + " NO TRADING";
      if (logs) Print(createbox);
       return (0);
   }
   orders = CalculateMaxOrders();
   if (orders >= max_orders)
   {
      createbox = createbox + " max orders: " + orders + " NO TRADING";
      if (logs) Print(createbox);
       return (0);
   }
   //Step 2: create order
   string msg;
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
            msg = "Symbol: " + symbol + ", Buy Order Created on "
                           + TimeToStr(TimeCurrent())
                           + ", At Price: " + MarketInfo(symbol, MODE_ASK);
            SendNotification(msg);
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
            msg = "Symbol: " + symbol + ", Sell Order Created on "
                           + TimeToStr(TimeCurrent())
                           + ", At Price: " + MarketInfo(symbol, MODE_ASK);
            SendNotification(msg);
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


int CalculateCurrentOrdersv3(string symbol, int magicnumber)
{
   int cnt=0;
   int i;
   for(i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==symbol && OrderMagicNumber() == magicnumber) {
         cnt++;
      }
   }
      
   return (cnt);
}


int CalculateCurrent(string symbol)
{
   int cnt=0;
   int i;
   for(i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==symbol) {
         cnt++;
      }
   }
      
   return (cnt);
}

int CalculateMaxOrders()
{
   int cnt=0;
   int i;
   for(i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderMagicNumber() == magic || OrderMagicNumber() == magic_0 || OrderMagicNumber() == magic_1) {
         cnt++;
      }
   }
      
   return (cnt);
}




int closelogicwithoutprofit(string symbol, int magicnumber, int typeHere)
{
   int i;
   string msg;
   for(i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()==magicnumber && OrderSymbol()==symbol) {
         if(OrderType()==OP_BUY && typeHere == -1)
           {
            Print(symbol, ", closing buy order");
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_BID),3,White);
            
            msg = "Symbol: " + OrderSymbol() + ", Buy Order Closed on "
                           + TimeToStr(TimeCurrent())
                           + ", At Profit: " + OrderProfit();
            SendNotification(msg);
           }
         if(OrderType()==OP_SELL && typeHere == 1)
           {
            Print(symbol, ", closing sell order");
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_ASK),3,White);
            
            msg = "Symbol: " + OrderSymbol() + ", Sell Order Closed on "
                           + TimeToStr(TimeCurrent())
                           + ", At Profit: " + OrderProfit();
            SendNotification(msg);
         
           }
     }
   }
   return (0);
}

double totalprofitResult(double lots, int fpips)
{
   if (fpips == EMPTY_VALUE) fpips = 0;
   return (lots * fpips);
}

string totalprofit(double lots, int fpips)
{
   return (DoubleToStr(totalprofitResult(lots, fpips), 2));
}







double weeklyprofit()
{
   int total = OrdersHistoryTotal();
   double gtotal = 0;
   int weekday=TimeDayOfWeek(TimeCurrent());
   int timeStart = TimeCurrent() - (60*60*24*weekday);
   Print("start: ", TimeToStr(timeStart));
   int newTime =StrToTime(TimeYear(timeStart)+"."+TimeMonth(timeStart)+"."+TimeDay(timeStart)+" 00:00");
   Print("newTime: ", TimeToStr(newTime));
   for(int cnt=0;cnt<total;cnt++)
   {
      OrderSelect(cnt, SELECT_BY_POS, MODE_HISTORY);
      if (OrderCloseTime() < newTime) continue;
      if (OrderType()==OP_BUY || OrderType()==OP_SELL) {
         gtotal = gtotal + OrderProfit();
      }
   }
   return (gtotal);
}

string intro()
{
   string box = "";
      box = box + "\nWelcome to MillionDollar Expert Advisor";
      box = box + "\nVersion: " + EA_Version;
      box = box + "\nLicensed To: " + username;
      double total = AccountBalance();
      if (inital_amount > 0) total = inital_amount;
      double d = 100 / max_orders;
      int percPerDay = 1;
      double aim = (total * percPerDay/100);
      lots = ((total / 100) * (d / 100)) / 100;
      if (lots < 0.01) lots = 0.01;
      if (lotsize > 0) lots = lotsize;
      lots = NormalizeDouble(lots, 2);
      double weeklytotal = weeklyprofit();
      box = box + "\nTotal Amount: " + total + ", Max Orders: " + max_orders + ", Max Spread: " + maxspread
         + ", Lots: " + lots
          + ", Magic: " + magic
          + ", Aim Per Day: " + aim
          + ", Aim Per Week: " + (aim * 5)
          + "\nWeek Profit: " + weeklytotal
          + ", Profit Remaining: " + ((aim * 5) - weeklytotal)
      ;
    return (box);
}