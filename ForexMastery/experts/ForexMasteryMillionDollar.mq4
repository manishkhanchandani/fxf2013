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
string product = "MillionDollar";
int auth = 0;
int opentime, opentimeAuth, opentimeOrders;
int magic = 123;
string infobox;
double lots;


//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   start();
   return (0);
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
         + ", Lots: " + lots + "\n"
      ;
      signals();
      Comment(infobox);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+


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




int signals()
{
   int status[1]; 
   string url = "http://wc5.org/forex/api/signals.php?username="+username+"&account="+AccountNumber()+"&product="+product;
   Print(url);
   string res = httpGET(url, status);
   Print("HTTP:",status[0]," ", res);
   string signals[100];
   SplitString(res, "\n", signals);
   for (int i=0; i < ArraySize(signals)-1; i++) {
      Print(i,", ",signals[i]);
      string signals2[100];
      SplitString(signals[i], "|", signals2);
      string signal_type = signals2[0];
      string order_symbol = signals2[1];
      string order_type = signals2[2];
      string order_lots = signals2[3];
      double order_lots_dbl = StrToDouble(order_lots);
      string order_price = signals2[4];
      double order_price_dbl = StrToDouble(order_price);
      string order_stop_loss = signals2[5];
      int order_stop_loss_int = StrToInteger(order_stop_loss);
      string order_take_profit = signals2[6];
      int order_take_profit_int = StrToInteger(order_take_profit);
      string order_comments = signals2[7];
      string order_magic_number = signals2[8];
      int order_magic_number_int = StrToInteger(order_magic_number);
      string order_expiration = signals2[9];
      int order_expiration_int = StrToInteger(order_expiration);
      string order_ticket = signals2[10];
      int order_ticket_int = StrToInteger(order_ticket);
      Print("signal_type:",signal_type,
         ",order_symbol:",order_symbol,
         ",order_type:",order_type,
         ",order_lots:",order_lots_dbl,
         ",order_price:",order_price_dbl,
         ",order_stop_loss:",order_stop_loss_int,
         ",order_take_profit:",order_take_profit_int,
         ",order_comments:",order_comments,
         ",order_magic_number:",order_magic_number_int,
         ",order_expiration:",order_expiration_int,
         ",order_ticket:",order_ticket_int
      );
      process(signal_type, order_symbol, order_type, order_lots_dbl, order_price_dbl, order_stop_loss_int, 
         order_take_profit_int, order_comments, order_magic_number_int, order_expiration_int, order_ticket_int);
   }
}

int process(string signal_type, string order_symbol, string order_type, double order_lots, double order_price, int order_stop_loss, 
         int order_take_profit, string order_comments, int order_magic_number, int order_expiration, int order_ticket)
{
   string symbol = order_symbol+symbol_suffix;

   int digits = MarketInfo(symbol, MODE_DIGITS);
   double pt = MarketInfo(symbol, MODE_POINT);
   
   int current_order_type = -1;
   if (order_type == "Buy") current_order_type = OP_BUY;
   else if (order_type == "Sell") current_order_type = OP_SELL;
   else if (order_type == "SellStop") current_order_type = OP_SELLSTOP;
   else if (order_type == "BuyStop") current_order_type = OP_BUYSTOP;
   else if (order_type == "SellLimit") current_order_type = OP_SELLLIMIT;
   else if (order_type == "BuyLimit") current_order_type = OP_BUYLIMIT;

   double current_lots;
   order_lots = NormalizeDouble(order_lots, 2);
   if (order_lots > 0)
      current_lots = NormalizeDouble(order_lots, 2);
   else current_lots = lots;

   double current_order_price = 0;
   order_price = NormalizeDouble(order_price, digits);
   if (order_price > 0 && current_order_type > OP_SELL) current_order_price = order_price;

   int current_stop_loss = 0;
   if (order_stop_loss > 0) current_stop_loss = order_stop_loss;
   else if (stop_loss > 0) current_stop_loss = stop_loss;
   
   int current_take_profit = 0;
   if (order_take_profit > 0) current_take_profit = order_take_profit;
   else if (take_profit > 0) current_take_profit = take_profit;
   
   infobox = infobox + "\nSymbol: " + symbol + ", Signal: " + signal_type + ", Order Type: " + order_type
         + ", Order Type: " + current_order_type
         + ", Lots: " + DoubleToStr(current_lots, 2)
         + ", Order Price: " + current_order_price
         + ", Stop Loss: " + current_stop_loss
         + ", Take Profit: " + current_take_profit
         + ", Order Ticket: " + order_ticket
      ;
   int orders = 0;
   if (signal_type == "New") {
      if (current_order_type == -1) return (0);
      orders = CalculateMaxOrders(magic);
      create_order(symbol, current_order_type, current_lots, magic, magic, current_stop_loss, current_take_profit);
   } else if (signal_type == "Modify") {
      bool responce = OrderSelect(order_ticket, SELECT_BY_TICKET);
      symbol = OrderSymbol();
      pt = MarketInfo(symbol, MODE_POINT);
      double price;
      double sl = 0;
      double tp = 0;
      if (OrderType() == OP_BUY) {
         price = MarketInfo(symbol, MODE_ASK);
         if (current_stop_loss > 0) {
            sl = price - (current_stop_loss * pt);
            sl = NormalizeDouble(sl, digits);
         }
         if (current_take_profit > 0) {
            tp = price + (current_take_profit * pt);
            tp = NormalizeDouble(tp, digits);
         }
         OrderModify(OrderTicket(),OrderOpenPrice(),sl,tp,0,Green);
      } else if (OrderType() == OP_SELL) {
         price = MarketInfo(symbol, MODE_BID);
         if (current_stop_loss > 0) {
            sl = price + (current_stop_loss * pt);
            sl = NormalizeDouble(sl, digits);
         }
         if (current_take_profit > 0) {
            tp = price - (current_take_profit * pt);
            tp = NormalizeDouble(tp, digits);
         }
         OrderModify(OrderTicket(),OrderOpenPrice(),sl,tp,0,Red);
      }
         
      infobox = infobox + "\nOrder ticket: " + OrderTicket() + ", order open price: " + OrderOpenPrice()
      + ", price: " + price + ", pt: " + MarketInfo(symbol, MODE_POINT)
      + ", sl: " + current_stop_loss + ", tp: " + current_take_profit
      + ", sl: " + sl + ", tp: " + tp;
   } else if (signal_type == "Close") {
      close_order(symbol, current_order_type); //for op_buy close buy order, for op_sell close sell order and for others delete
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

   string createbox = createbox + "\n" + symbol;
   //Step 1: check different conditions
   if (IsTradeAllowed()==false) {
      createbox = createbox + " TRADING NOW ALLOWED";
      return (0);
   }
   
   
   if (type == OP_BUY) {
      ordertype = OP_BUY;
   } else if (type == OP_SELL) {
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
   orders = CalculateCurrent(symbol);
   if (orders > 0)
   {
      createbox = createbox + " previous symbol orders: " + orders + " NO TRADING";
       return (0);
   }
   orders = CalculateMaxOrders(magicnumber);
   if (orders >= max_orders) {
      createbox = createbox + " max orders: " + orders + " NO TRADING";
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
   if (type == OP_BUY) {
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
      }
      Sleep(sleeptime);
      return(0);
   } else if (type == OP_SELL) {
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
int CalculateMaxOrders(int magicnumber)//, int ordertype
{
   int cnt=0;
   int i;
   for(i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderMagicNumber()==magicnumber) {
         cnt++;
      }
   }
      
   return (cnt);
}



int close_order(string symbol, int order_type)
{
   int i;
   for(i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderMagicNumber()==magic) {
         if (OrderType() == order_type && OrderType() == OP_BUY) {
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_BID),3,Green);
         } else if (OrderType() == order_type && OrderType() == OP_SELL) {
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_ASK),3,Green);
         } else if (order_type == -1) {
            if (OrderType() == OP_BUY) {
               OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_BID),3,Green);
            } else if (OrderType() == OP_SELL) {
               OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_ASK),3,Green);
            }
         }
      }
   }
}

