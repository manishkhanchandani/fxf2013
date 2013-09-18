//+------------------------------------------------------------------+
//|                                    ForexMasteryStrategyMaker.mq4 |
//|                                              Manish Khanchandani |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://forexmastery.org"


#include <stdlib.mqh>
#include <WinUser32.mqh>
#include <strategies.mqh>

extern string EA_Version = "1.0";
extern string label_0 = " === Account Information === ";
extern string username = "";
extern double inital_amount = 0;
extern string label_1 = " === Order Information === ";
extern double lotsize = 0.10;
extern int maxspread = 80;
extern int max_orders = 4;
extern int stop_loss = 500;
extern int take_profit = 0;
extern int magic = 20130917;
extern string label_3 = " === Strategy Information === ";
extern int strategy = 0;
extern int analysis_days = 20;
extern string suffix = "";
extern bool create_new_order = true;
extern bool forced = false;
extern bool logs = false;
string product = "StrategyMaster";
int opentime;
int opentime2;
int opentimeX;
string infobox;
string checkbox;
         int top1 = 0;
         int top2 = 0;
         int top3 = 0;
         int top4 = 0;
#define ARRSIZE  28

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

int best[ARRSIZE];
int bestv[ARRSIZE];
double lots;
int cstrategy;
int cperiod;
int cvalue;
string cbox;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   opentime = 0;
   opentime2 = 0;
   cstrategy = 0;
   cvalue = 0;
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
   opentime = 0;
   opentime2 = 0;
   cstrategy = 0;
   cvalue = 0;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   if (opentime != iTime(Symbol(), Period(), 0)) {
      opentime = iTime(Symbol(), Period(), 0);
      infobox = "";
      infobox = infobox + intro();
      bestStrategy();
      condition_for_close(magic);
      condition_for_open();
      infobox = infobox + "\n";
      double weeklypips = weeklyPips(magic);
      infobox = infobox + "\nWeekly Pips: " + weeklypips;
      Comment(infobox);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+

int condition_for_open()
{

   string message;
   string symbol;
   int check;
   int check2;
   if (max_orders >= 1) {
      cstrategy = best[top1];
      cperiod = Period();
      symbol = aPair[top1]+suffix;
   
      message = magic + ", " + cperiod + ", " + cstrategy + ", " + 1;
      check = get_strategy_result(cstrategy, symbol, cperiod, 1, 1);
      check2 = iCustom(symbol, cperiod, "cuSpanTime", cstrategy, 300, 2, 1);
      if (check2 == EMPTY_VALUE) check2 = 0;
      infobox = infobox + "\n\nTop 1, Symbol: " + symbol + ", Best: " + cstrategy + "(" + get_strategy_name(cstrategy) 
                              + "), Current: " + check
                              + ", Change: " + check2
                              + ", Period: " + TimeframeToString(cperiod)
                              + ", Message: " + message
                              + ", Spread: " + DoubleToStr(MarketInfo(symbol, MODE_SPREAD), 0)
                              ;
      if (check2 == 1 || (forced && check == 1)) {
         create_order(symbol, 1, lots, magic, message, stop_loss, take_profit);
      } else if (check2 == -1 || (forced && check == -1)) {
         create_order(symbol, -1, lots, magic, message, stop_loss, take_profit);
      }//end if
   }
   if (max_orders >= 2) {
      cstrategy = best[top2];
      cperiod = Period();
      symbol = aPair[top2]+suffix;
   
      message = magic + ", " + cperiod + ", " + cstrategy + ", " + 1;
      check = get_strategy_result(cstrategy, symbol, cperiod, 1, 1);
      check2 = iCustom(symbol, cperiod, "cuSpanTime", cstrategy, 300, 2, 1);
      if (check2 == EMPTY_VALUE) check2 = 0;
      infobox = infobox + "\n\nTop 2, Symbol: " + symbol + ", Best: " + cstrategy + "(" + get_strategy_name(cstrategy) 
                              + "), Current: " + check
                              + ", Change: " + check2
                              + ", Period: " + TimeframeToString(cperiod)
                              + ", Message: " + message
                              + ", Spread: " + DoubleToStr(MarketInfo(symbol, MODE_SPREAD), 0)
                              ;
      if (check2 == 1 || (forced && check == 1)) {
         create_order(symbol, 1, lots, magic, message, stop_loss, take_profit);
      } else if (check2 == -1 || (forced && check == -1)) {
         create_order(symbol, -1, lots, magic, message, stop_loss, take_profit);
      }//end if
   }
   if (max_orders >= 3) {
      cstrategy = best[top3];
      cperiod = Period();
      symbol = aPair[top3]+suffix;
   
      message = magic + ", " + cperiod + ", " + cstrategy + ", " + 1;
      check = get_strategy_result(cstrategy, symbol, cperiod, 1, 1);
      check2 = iCustom(symbol, cperiod, "cuSpanTime", cstrategy, 300, 2, 1);
      if (check2 == EMPTY_VALUE) check2 = 0;
      infobox = infobox + "\n\nTop 3, Symbol: " + symbol + ", Best: " + cstrategy + "(" + get_strategy_name(cstrategy) 
                              + "), Current: " + check
                              + ", Change: " + check2
                              + ", Period: " + TimeframeToString(cperiod)
                              + ", Message: " + message
                              + ", Spread: " + DoubleToStr(MarketInfo(symbol, MODE_SPREAD), 0)
                              ;
      if (check2 == 1 || (forced && check == 1)) {
         create_order(symbol, 1, lots, magic, message, stop_loss, take_profit);
      } else if (check2 == -1 || (forced && check == -1)) {
         create_order(symbol, -1, lots, magic, message, stop_loss, take_profit);
      }//end if
   }
   if (max_orders >= 4) {
      cstrategy = best[top4];
      cperiod = Period();
      symbol = aPair[top4]+suffix;
   
      message = magic + ", " + cperiod + ", " + cstrategy + ", " + 1;
      check = get_strategy_result(cstrategy, symbol, cperiod, 1, 1);
      check2 = iCustom(symbol, cperiod, "cuSpanTime", cstrategy, 300, 2, 1);
      if (check2 == EMPTY_VALUE) check2 = 0;
      infobox = infobox + "\n\nTop 4, Symbol: " + symbol + ", Best: " + cstrategy + "(" + get_strategy_name(cstrategy) 
                              + "), Current: " + check
                              + ", Change: " + check2
                              + ", Period: " + TimeframeToString(cperiod)
                              + ", Message: " + message
                              + ", Spread: " + DoubleToStr(MarketInfo(symbol, MODE_SPREAD), 0)
                              ;
      if (check2 == 1 || (forced && check == 1)) {
         create_order(symbol, 1, lots, magic, message, stop_loss, take_profit);
      } else if (check2 == -1 || (forced && check == -1)) {
         create_order(symbol, -1, lots, magic, message, stop_loss, take_profit);
      }//end if
   }
}

int condition_for_close(int magicNumber)
{
   
   infobox = infobox + "\n";
   infobox = infobox + "\nCHECKING CLOSURES: " + magicNumber;
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
         //if (OrderSymbol() == "USDJPY") st = 21;
         if (newMagic != OrderMagicNumber()) continue;
         int diff = 0;
         if (OrderType() == OP_BUY) {
            diff = (iClose(OrderSymbol(), timePeriod, 0) - OrderOpenPrice()) / MarketInfo(OrderSymbol(), MODE_POINT);
         } else if (OrderType() == OP_SELL) {
            diff = (OrderOpenPrice() - iClose(OrderSymbol(), timePeriod, 0)) / MarketInfo(OrderSymbol(), MODE_POINT);
         }
         int check = 0;
         check = get_strategy_result(st, OrderSymbol(), timePeriod, 1, 0);
         int check2 = get_strategy_result(st, OrderSymbol(), timePeriod, 1, 1);
         infobox = infobox + "\nClosing Strategy: Strategy: " + st + ", symbol: " + OrderSymbol() + ", timePeriod: " + timePeriod
         + ", magic: " + newMagic
          + ", Profit: " + OrderProfit()
          + ", check: " + check
          + ", chec2: " + check2
          + ", Pips Covered: " + diff
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
   infobox = infobox + "\n";
   return (0);
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
      box = box + "\nTotal Amount: " + total + ", Max Spread: " + maxspread
         + ", Lots: " + lots
          + ", Magic: " + magic
          + ", Aim Per Day: " + aim
          + ", Aim Per Week: " + (aim * 5)
          + "\nWeek Profit: " + weeklytotal
          + ", Profit Remaining: " + ((aim * 5) - weeklytotal)
          + ", Analysis Days: " + analysis_days
          + ", Forced: " + forced
      ;
    return (box);
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
   if (!create_new_order) {
      createbox = createbox + " Create new order disabled.";
      if (logs) Print(createbox);
      return (0);
   }
   if (MarketInfo(symbol, MODE_SPREAD) >= maxspread) {
      createbox = createbox + " Spread is " + MarketInfo(symbol, MODE_SPREAD);
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
      if(OrderMagicNumber() == magic) {
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



double weeklyPips(int magicnumber)
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
      if (OrderCloseTime() < newTime || OrderMagicNumber() != magicnumber) continue;
      if (OrderType()==OP_BUY || OrderType()==OP_SELL) {
         //infobox = infobox + "\nTicket: " + OrderTicket() + ", Close Price: " + OrderClosePrice()
            //+ ", Open Price: " + OrderOpenPrice()
           // + ", Type: " + OrderType()
           // + ", Profit: " + DoubleToStr(OrderProfit(), 2)
           // + ", Time: " + TimeToStr(OrderCloseTime())
           // + ", Open Time: " + TimeToStr(OrderOpenTime())
           // + ", Lots: " + DoubleToStr(OrderLots(), 2);
         if (OrderType()==OP_BUY) {
            gtotal = gtotal + (OrderClosePrice() - OrderOpenPrice());
            //infobox = infobox + ", Diff: " + DoubleToStr(((OrderClosePrice() - OrderOpenPrice()) / MarketInfo(symbol, MODE_POINT)), 0);
            //infobox = infobox + ", T: " + DoubleToStr(gtotal, 2);
         } else if (OrderType()==OP_SELL) {
            gtotal = gtotal + (OrderOpenPrice() - OrderClosePrice());
            //infobox = infobox  + ", Diff: " + DoubleToStr(((OrderOpenPrice() - OrderClosePrice()) / MarketInfo(symbol, MODE_POINT)), 0);
            //infobox = infobox + ", T: " + DoubleToStr(gtotal, 2);
         }
      }
   }
   //gtotal = gtotal / MarketInfo(symbol, MODE_POINT);
   //infobox = infobox + "\n";
   return (gtotal);
}

int bestStrategy()
{
   int i;
  if (opentimeX != iTime(Symbol(), PERIOD_MN1, 0)) {
      opentimeX = iTime(Symbol(), PERIOD_MN1, 0);
      int x;
      checkbox = "";
      for (x = 0; x < ARRSIZE; x++) {
         string symbol = aPair[x];
         int period = Period();
         string current_currency1 = StringSubstr(symbol, 0, 3);
         string current_currency2 = StringSubstr(symbol, 3, 3);
         int val;
         int max = -99999;
         int cstrategy = 0;
         int cperiod = 0;
         int cvalue = 0;
         checkbox = checkbox + "\nSymbol: " + symbol + ", Period: " + period;
         for (int j = 1; j <= 42; j++) {
            if (j == 31) continue;
            val = 0;
            checkbox = checkbox + "\nStrategy: " + j;
            int subval = 0;
            subval = iCustom(symbol, period, "cuSpanTimeClose", j, 20, 15, 4, 0); 
            if (subval == EMPTY_VALUE) subval = 0;
            val = val + subval;
            checkbox = checkbox + ", Subvalue1: " + subval;
            subval = iCustom(symbol, period, "cuSpanTimeClose", j, 15, 10, 4, 0); 
            if (subval == EMPTY_VALUE) subval = 0;
            val = val + subval;
            checkbox = checkbox + ", Subvalue2: " + subval;
            subval = iCustom(symbol, period, "cuSpanTimeClose", j, 10, 5, 4, 0); 
            if (subval == EMPTY_VALUE) subval = 0;
            val = val + subval;
            checkbox = checkbox + ", Subvalue3: " + subval;
            subval = iCustom(symbol, period, "cuSpanTimeClose", j, 5, 0, 4, 0); 
            if (subval == EMPTY_VALUE) subval = 0;
            val = val + subval;
            checkbox = checkbox + ", Subvalue4: " + subval;
            checkbox = checkbox + ", Value: " + val;
            if (val > max) {
               max = val;
               cstrategy = j;
               cperiod = period;
               cvalue = val;
               best[x] = j;
               bestv[x] = cvalue;
            }
         } 
         checkbox = checkbox + "\nSymbol: " + symbol + ", Best Strategy: " + cstrategy + " (" + get_strategy_name(cstrategy) + ")"
            + ", for period: " + period + " with value: " + cvalue + "\n";
      }
      
         max = -9999;
         for (i = 0; i < ARRSIZE; i++) {
            if (bestv[i] > max) {
               max = bestv[i];
               top1 = i;
            } 
         }
         i = top1;
         checkbox = checkbox + "\nSymbol: " + aPair[i] + ", Best Strategy: " + best[i] + " (" + get_strategy_name(best[i]) + ")"
            + ", for period: " + Period() + " with value: " + bestv[i] + "\n";
         max = -9999;
         for (i = 0; i < ARRSIZE; i++) {
            if (bestv[i] > max && i != top1) {
               max = bestv[i];
               top2 = i;
            }  
         }
         i = top2;
         checkbox = checkbox + "\n\nSymbol: " + aPair[i] + ", Best Strategy: " + best[i] + " (" + get_strategy_name(best[i]) + ")"
            + ", for period: " + Period() + " with value: " + bestv[i] + "\n";
         max = -9999;
         for (i = 0; i < ARRSIZE; i++) {
            if (bestv[i] > max && i != top1 && i != top2) {
               max = bestv[i];
               top3 = i;
            }  
         }
         i = top3;
         checkbox = checkbox + "\nSymbol: " + aPair[i] + ", Best Strategy: " + best[i] + " (" + get_strategy_name(best[i]) + ")"
            + ", for period: " + Period() + " with value: " + bestv[i] + "\n";
         max = -9999;
         for (i = 0; i < ARRSIZE; i++) {
            if (bestv[i] > max && i != top1 && i != top2 && i != top3) {
               max = bestv[i];
               top4 = i;
            } 
         }
         i = top4;
         checkbox = checkbox + "\nSymbol: " + aPair[i] + ", Best Strategy: " + best[i] + " (" + get_strategy_name(best[i]) + ")"
            + ", for period: " + Period() + " with value: " + bestv[i] + "\n";
      string fn = "ForexMasteryBestStrategy/period_"+period+".txt";
      FileDelete(fn);
      FileAppend(fn, checkbox);
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