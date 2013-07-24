//+------------------------------------------------------------------+
//|                                              MillionDollarv3.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

#include <stdlib.mqh>
#include <WinUser32.mqh>
#include <strategies.mqh>
int counter = 0;

extern double initialAmount = 0;
extern int percPerDay = 3;
double todaysPlan;
extern double fixedLots = 0.05;

double lotsize;
int magic = 123;
int s[5];
int sm[5];
int checked[5];
string infobox = "";
int periods[5] = {PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4, PERIOD_D1};
int strategy;
int strategyPeriod;
int strategyMax;
int opentimeStrategy;

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
   counter++;
   if (opentimeStrategy != iTime(Symbol(), PERIOD_W1, 0)) {
      s[0] = 0;
      s[1] = 0;
      s[2] = 0;
      s[3] = 0;
      checked[0] = 0;
      checked[1] = 0;
      checked[2] = 0;
      checked[3] = 0;
      opentimeStrategy = iTime(Symbol(), PERIOD_W1, 0);
   }
   infobox = "";
   //FINDING LOT SIZE
   finding_lots();
   //FINDING THE STRATEGY
   findingStrategy(Symbol());
   //open condition
   condition_for_open(Symbol());
   //close condition
   condition_for_close(Symbol());
   Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+

int findingStrategy(string symbol)
{
   
   double val;
   int max;
   int period;
   int p;
   if (checked[0] == 1 && checked[1] == 1 && checked[2] == 1 && checked[3] == 1) {
      int max2 = 0;
      for(p = 0; p < 4; p++) {
         period = periods[p];
         infobox = infobox + "\nStrategy For Period: " + period + " is " + s[p] + " with max value: " + sm[p];
         if (sm[p] > max2) {
            max2 = sm[p];
            strategy = s[p];
            strategyPeriod = period;
            strategyMax = sm[p];
         }
      }
      infobox = infobox + "\n\nMain Strategy is For Period: " + strategyPeriod + " is " + strategy 
      + " (" + get_strategy_name(strategy) + ") "
      + " with max value: " + strategyMax;
   } else {
      if (counter % 5 == 0) {
         for(p = 0; p < 4; p++) {
            period = periods[p];
            if (s[p] > 0) {
               //infobox = infobox + "\nStrategy For Period: " + period + " is " + s[p] + " with max value: " + sm[p];
            } else {
               checked[p] = 1;
               max = 0;
               for (int j = 1; j <= 25; j++) {
                     val = iCustom(symbol, period, "cuSpan", j, 4, 0);
                     if (val > max && val != EMPTY_VALUE) {
                        max = val;
                        sm[p] = max;
                        s[p] = j;
                        Print("Checking for period " + period + " sp: " + s[p] + ", checked: " + checked[p]);
                     }
               }
               break;
            }
         }
      }
   }
}


int finding_lots()
{
   if (initialAmount == 0) initialAmount = AccountBalance();
   double total = initialAmount;
   double aim = (total * percPerDay/100);
   lotsize = ((total / 100) * 0.5) / 100;
   if (lotsize < 0.01) lotsize = 0.01;
   lotsize = NormalizeDouble(lotsize, 2);
   fixedLots = NormalizeDouble(fixedLots, 2);
   if (fixedLots > 0) lotsize = fixedLots;
   infobox = infobox + "\nTotal: " + total + ", Lots: " + DoubleToStr(lotsize, 2) 
      + ", Aim: " + DoubleToStr(aim, 2);
   infobox = infobox + ", fixedLots: " + fixedLots;
}

int condition_for_open(string symbol)
{
   int check = 0;
   check = get_strategy_result(strategy, symbol, strategyPeriod, 1, 0);
   int check1 = 0;
   check1 = get_strategy_result(strategy, symbol, strategyPeriod, 1, 1);
   string message = magic + ", " + strategyPeriod + ", " + strategy;
   infobox = infobox + "\n\nSymbol: " + symbol + ", Strategy: " + strategy + ", Period: " + strategyPeriod
   + ", s0: " + s[0]
   + ", s1: " + s[1]
   + ", s2: " + s[2]
   + ", s3: " + s[3];
   infobox = infobox + ", RESULT: " + check + ", CURRENT: " + check1 + ", Spread: " + MarketInfo(symbol, MODE_SPREAD);
   if (check == 1) {
      create_order(symbol, 1, lotsize, magic, message, 0, 0);
   } else if (check == -1) {
      create_order(symbol, -1, lotsize, magic, message, 0, 0);
   }

   return (check);
}

int condition_for_close(string symbol)
{
   int cnt=0;
   int i;
   int timePeriod;
   int st;
   for(i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==symbol && OrderMagicNumber() == magic) {
         cnt++;
         string result[3];
         SplitString(OrderComment(), ", ", result);
         timePeriod = StrToInteger(result[1]);
         st = StrToInteger(result[2]);
         //Alert(OrderSymbol(), " with order comments: ", OrderComment(), ", timeperiod: ", timePeriod,
          //  ", st: ", st);
         
         int check = 0;
         check = get_strategy_result(st, symbol, timePeriod, 1, 0);
         infobox = infobox + "\nClosing Strategy: Strategy: " + st + ", symbol: " + symbol + ", timePeriod: " + timePeriod + ", Check: " + check;
         if (check == 1) {
            closelogicwithoutprofit(symbol, magic, 1);
         }
         else if (check == -1) {
            closelogicwithoutprofit(symbol, magic, -1);
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
   
   orders = CalculateCurrentOrders(symbol);
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


int CalculateCurrentOrders(string symbol)
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


double historySymbol(int magicnum, string symbol)
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


