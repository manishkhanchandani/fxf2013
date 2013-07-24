//+------------------------------------------------------------------+
//|                                               customIchimoku.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <3_signal_inc.mqh>
#include <strategies.mqh>
extern double initialAmount = 0;
extern int percPerDay = 3;
double todaysPlan;
extern double fixedLots = 0.01;
extern int maxorders = 1;

bool logs = true;



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
   double history = history_custom(magic);
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
      int newperiod = PERIOD_M30;
      for (x = 0; x < ARRSIZE; x++) {
         symbol = aPair[x];
         bool buy = true;
         bool sell = true;
         int i = x;
         string current_currency1 = StringSubstr(symbol, 0, 3);
         string current_currency2 = StringSubstr(symbol, 3, 3);
         if (current_currency2 == "JPY" || x == EURCHF || x == EURGBP || x == GBPCHF || x == NZDUSD) {
            continue;
         }
         int digit = MarketInfo(symbol, MODE_DIGITS);
         infobox = infobox + "\nSymbol: " + symbol + ", Digits: " + digit + ", Period: " + newperiod
          + ", Spread: " + DoubleToStr(MarketInfo(symbol, MODE_SPREAD), 0);
         condition_open = 0;
         condition_close = 0;
         string message = magic;
         condition_open = condition_open(symbol, newperiod, 1, x);
         //infobox = infobox + ", buy: " + buy + ", sell: " + sell;

         if (condition_open == 1) {
            closelogicwithprofit(symbol, magic, 1);
            if (buy) create_order_custom(symbol, 1, lots, magic, message, 0, 0);
         }
         else if (condition_open == -1) {
            closelogicwithprofit(symbol, magic, -1);
            if (sell) create_order_custom(symbol, -1, lots, magic, message, 0, 0);
         }
      }
   infobox = infobox + "\n\nORDERS:\n"+magic;
   double gtotal;
   for(i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()==magic) {
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
   mathmurry(symbol, mode, PERIOD_H1);
   infobox = infobox + ", Level: " + condition_level[mode] + ", Type: " + condition[mode];
   int check1 = get_strategy_result(15, symbol, period, shift, 0);
   if (condition[mode] == 1 && check1 == 1) {
      check = 1;
   } else if (condition[mode] == -1 && check1 == -1) {
      check = -1;
   }
   infobox = infobox + ", RESULT: " + check;
   return (check);
}


int create_order_custom(string symbol, int type, double Lots, int magicnumber, string message, int stoploss, int takeprofit)
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
   
   orders = CalculateCurrentOrders(symbol, magicnumber);
   if (orders > 0)
   {
      createbox = createbox + " previous orders: " + orders + " NO TRADING";
       return (0);
   }
   orders = CalculateMaxOrders(magicnumber);
   if (orders >= maxorders)
   {
      createbox = createbox + " max orders: " + maxorders + " NO TRADING";
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



double history_custom(int magicnum)
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




int closelogicwithprofit(string symbol, int magicnumber, int typeHere)
{
   int i;

   for(i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()==magicnumber && OrderSymbol()==symbol && OrderProfit() > 0) {
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