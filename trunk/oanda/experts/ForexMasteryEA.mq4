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

extern string EA_Version = "1.1"; /*1.1 changes: settings shown*/
extern string label_0 = " === Account Information === ";
extern string username = "nkhanchandani";
extern string label_1 = " === Order Information === ";
extern double lotsize = 0;
extern string symbol_suffix = "";
extern int max_orders = 4;
extern int maxspread = 100;
extern int stop_loss = 0;
extern int take_profit = 0;
extern int noofdays = 1000;
extern int magic = 123;
string product = "MillionDollar";
int auth = 0;
int opentime, opentimeAuth, opentimeOrders;
string infobox;
double lots;

int c_strategy[5];
int c_max[5];
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
   if (opentimeAuth != iTime(Symbol(), PERIOD_D1, 0)) {
      auth();
      opentimeAuth = iTime(Symbol(), PERIOD_D1, 0);
   }
   
   if (auth == 0) {
      infobox = "";
      authfailuremessage();
      Comment(infobox);
      return (0);
   }
   
   
   if (opentime != iTime(Symbol(), PERIOD_M5, 0)) {
      opentime = iTime(Symbol(), PERIOD_M5, 0);
      infobox = "";
      infobox = infobox + "\nWelcome to MillionDollar Expert Advisor";
      infobox = infobox + "\nVersion: " + EA_Version;
      infobox = infobox + "\nLicensed To: " + username;
      double total = AccountBalance();
      double d = 100 / max_orders;
      int percPerDay = 1;
      double aim = (total * percPerDay/100);
      lots = ((total / 100) * (d / 100)) / 100;
      if (lots < 0.01) lots = 0.01;
      if (lotsize > 0) lots = lotsize;
      lots = NormalizeDouble(lots, 2);
      infobox = infobox + "\nMax Orders: " + max_orders + ", Max Spread: " + maxspread
         + ", Lots: " + lots + ", No of Days: " + noofdays + "\n"
      ;
         string symbol = Symbol();
      
      int periods[5] = {PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4, PERIOD_D1};
      
      int final_strategy = 0;
      int final_max = 0;
      int final_period = 0;
      int p, period;
      if (opentimeOrders != iTime(Symbol(), PERIOD_W1, 0)) {
         opentimeOrders = iTime(Symbol(), PERIOD_W1, 0);
            for  (p = 0; p < 5; p++) {
               period = periods[p];
               int best = 0;
               int max = -9999999;
               for (int j = 1; j <= 27; j++) {
                  if (j == 4 || j == 24 || j == 25) continue;
                  double val = iCustom(symbol, period, "cuSpanTime", j, noofdays, 4, 0);
                  if (val > max && val != EMPTY_VALUE) {
                     max = val;
                     best = j;
                  }
               }
               c_strategy[p] = best;
               c_max[p] = max;
            }
         }
         max = -9999999;
         for (p = 0; p < 5; p++) {
               period = periods[p];
               infobox = infobox + "\nSymbol: " + symbol + ", Best: " + c_strategy[p] + "(" + get_strategy_name(c_strategy[p]) 
                  + ") with value: " + c_max[p]
                  + ", Period: " + TimeframeToString(period)
                  ;
               if (c_max[p] > max) {
                  final_strategy = c_strategy[p];
                  final_max = c_max[p];
                  final_period = period;
                  max = c_max[p];
               }
         }
         int check = get_strategy_result(final_strategy, symbol, final_period, 1, 0);
         infobox = infobox + "\n\nSymbol: " + symbol + ", Best: " + final_strategy + "(" + get_strategy_name(final_strategy) 
                  + ") with value: " + final_max + ", Change: " + check
                  + ", Period: " + TimeframeToString(final_period)
                  ;
      condition_for_close(symbol);
      string message = magic + ", " + final_period + ", " + final_strategy;
      if (check == 1) {
         create_order(symbol, 1, lots, magic, message, 0, 0);
      } else if (check == -1) {
         create_order(symbol, -1, lots, magic, message, 0, 0);
      }
      string fn = "forexmasteryEA_"+symbol+".txt";
      FileDelete(fn);
      FileAppend(fn, infobox);
      Comment(infobox);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+

void FileAppend(string name,string txt)
{
   int handle = FileOpen(name,FILE_READ|FILE_WRITE);
	FileSeek(handle,0,SEEK_END);
	FileWrite(handle,txt);
	FileFlush(handle);
	FileClose(handle);
}


int auth()
{
   int status[1];
   string response;
   string url = "http://wc5.org/forex/api/accessMillionDollar.php?username="+username+"&account="+AccountNumber()+"&product="+product;
   Print(url);
   response = httpGET(url, status);
   Print(response);
   if (response == "Success") {
      auth = 1;
   } else {
      auth = 0;
   }
}



int authfailuremessage()
{
   if (auth == 0) {
      infobox = infobox + "\n\nUnauthorised Email or Account Number.\n" +
      "Go to http://forexmastery.org/ and make sure you have assigned proper account number.\n" +
      "Or email us at milliondollar@forexmastery.org";
   }

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


int condition_for_open(string symbol, int mode, int strategy, int strategyPeriod, int magicNumber)
{
   int check = 0;
   check = get_strategy_result(strategy, symbol, strategyPeriod, 1, 0);
   int check1 = 0;
   check1 = get_strategy_result(strategy, symbol, strategyPeriod, 1, 1);
   string message = magicNumber + ", " + strategyPeriod + ", " + strategy;
   infobox = infobox + "\nSymbol: " + symbol + ", Strategy: " + strategy + ", Period: " + strategyPeriod;
   infobox = infobox + ", RESULT: " + check + ", CURRENT: " + check1 + ", Spread: " + MarketInfo(symbol, MODE_SPREAD);
   if (check == 1) {
      create_order(symbol, 1, lotsize, magicNumber, message, 0, 0);
   } else if (check == -1) {
      create_order(symbol, -1, lotsize, magicNumber, message, 0, 0);
   }

   return (check);
}

int condition_for_close(string symbol)
{
   infobox = infobox + "\nCHECKING CLOSURES:";
   int cnt=0;
   int i;
   int timePeriod;
   int st;
   for(i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==symbol) {
         cnt++;
         string result[3];
         SplitString(OrderComment(), ", ", result);
         int newMagic = StrToInteger(result[0]);
         timePeriod = StrToInteger(result[1]);
         st = StrToInteger(result[2]);
         //Alert(OrderSymbol(), " with order comments: ", OrderComment(), ", timeperiod: ", timePeriod,
          //  ", st: ", st);
         if (newMagic != OrderMagicNumber()) continue;
         int check = 0;
         check = get_strategy_result(st, symbol, timePeriod, 1, 0);
         infobox = infobox + "\nClosing Strategy: Strategy: " + st + ", symbol: " + symbol + ", timePeriod: " + timePeriod + ", Check: " + check
         + ", magic: " + newMagic;
         if (check == 1) {
            closelogicwithoutprofit(symbol, newMagic, 1);
         }
         else if (check == -1) {
            closelogicwithoutprofit(symbol, newMagic, -1);
         }
      }
   }
      
   return (cnt);
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
   
   orders = CalculateCurrentOrdersv3(symbol, magicnumber);
   if (orders > 0)
   {
      createbox = createbox + " previous orders: " + orders + " NO TRADING";
       return (0);
   }
   orders = CalculateCurrent(symbol);
   if (orders > 0)
   {
      createbox = createbox + " previous symbol orders: " + orders + " NO TRADING";
       return (0);
   }
   orders = CalculateMaxOrders(magicnumber);
   if (orders >= max_orders)
   {
      createbox = createbox + " max orders: " + orders + " NO TRADING";
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

int CalculateMaxOrders(int magicnumber)
{
   int cnt=0;
   int i;
   for(i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderMagicNumber() == magicnumber) {
         cnt++;
      }
   }
      
   return (cnt);
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
            Print(symbol, ", closing buy order");
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_BID),3,White);
           }
         if(OrderType()==OP_SELL && typeHere == 1)
           {
            Print(symbol, ", closing sell order");
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_ASK),3,White);
         
           }
     }
   }
   return (0);
}

