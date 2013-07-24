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
extern int magic2 = 132;
extern double lots = 0.01;
extern double lots_addon = 0.05;
extern int max_orders = 1;

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
   infobox = "";
   //string box = trailingstop();
   //infobox = infobox + box;
   int condition_open = 0;
   int condition_close = 0;
   infobox = infobox + "\nMagic: " + magic;
   lots = NormalizeDouble(lots, 2);
   infobox = infobox + ", Lots: " + DoubleToStr(lots, 2);
   int x; string symbol;
      int newmagic = magic;
      for (x = 0; x < ARRSIZE; x++) {
         symbol = aPair[x];
         if (symbol != Symbol()) continue;
         bool buy = true;
         bool sell = true;
         int i = x;
         string current_currency1 = StringSubstr(symbol, 0, 3);
         string current_currency2 = StringSubstr(symbol, 3, 3);
         int digit = MarketInfo(symbol, MODE_DIGITS);
         infobox = infobox + "\nSymbol: " + symbol + ", Digits: " + digit
          + ", Spread: " + DoubleToStr(MarketInfo(symbol, MODE_SPREAD), 0);
         infobox = infobox + ", buy: " + buy + ", sell: " + sell;
         condition_open = 0;
         condition_close = 0;
         string message = newmagic;
         condition_open = condition_open(symbol, 1);

         if (condition_open == 1) {
            closelogic(symbol, magic, 1);
            closelogic(symbol, magic2, 1);
            if (buy) create_order(symbol, 1, lots, magic, message, 0, 0);
         }
         else if (condition_open == -1) {
            closelogic(symbol, magic, -1);
            closelogic(symbol, magic2, -1);
            if (sell) create_order(symbol, -1, lots, magic, message, 0, 0);
         }
         
         condition_open = condition_open_addon(symbol, 1);
         if (condition_open == 1) {
            if (buy) create_order(symbol, 1, lots_addon, magic2, message, 0, 0);
         }
         else if (condition_open == -1) {
            if (sell) create_order(symbol, -1, lots_addon, magic2, message, 0, 0);
         }
      }
   infobox = infobox + "\n\nORDERS:\n";
   double gtotal;
   for(i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()==magic || OrderMagicNumber()==magic2) {
         gtotal = gtotal + OrderProfit();
         infobox = infobox + "\nSymbol: "+OrderSymbol()+" with profit: "+OrderProfit() + " of type: " + parse(OrderType()) + ", magic: " + OrderMagicNumber();
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

int middleman_strategy(string symbol)
{
   if (symbol == "AUDUSD") return (11);
   if (symbol == "EURAUD") return (11);
   if (symbol == "EURJPY") return (1);
   return (1);
}
int middleman_period(string symbol)
{
   return (PERIOD_M30);
}

string parse(int type)
{
   if (type == OP_BUY) return ("Buy");
   if (type == OP_SELL) return ("Sell");
}

int condition_open(string symbol, int shift)
{
   int condition = 0;
   int period = middleman_period(symbol);
   int strategy = middleman_strategy(symbol);
   condition = get_strategy_result(strategy, symbol, period, shift, 0);
   infobox = infobox + ", condition: " + condition + ", period: " + period + ", strategy: " + strategy;
   return (condition);
}

int condition_open_addon(string symbol, int shift)
{
   int check = CalculateCurrentOrderPips(symbol, magic, magic2);
   if (check == 0) return (0);
   int condition = 0;
   int period = middleman_period(symbol);
   int strategy = middleman_strategy(symbol);
   condition = get_strategy_result(strategy, symbol, period, shift, 1);
   infobox = infobox + ", condition2: " + condition + ", period2: " + period + ", strategy2: " + strategy;
   return (condition);
}

int create_order(string symbol, int type, double Lots, int magicnumber, string message, int stoploss, int takeprofit)
{
   int pending_margin = 1;
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
   
   orders = CalculateCurrentOrders(symbol, magicnumber, ordertype);
   if (orders >= max_orders)
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


int CalculateCurrentOrders(string symbol, int magicnumber, int ordertype)
{
   int cnt=0;
   int i;
   for(i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==symbol && OrderMagicNumber()==magicnumber 
         //&& OrderType() == ordertype
      ) {
         cnt++;
      }
   }
      
   return (cnt);
}


int CalculateCurrentOrderPips(string symbol, int magicnumber, int magicnumber2)
{
   int cnt=0;
   int cnt2 = 0;
   int pips = 0;
   int i;
   for(i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==symbol && OrderMagicNumber()==magicnumber) {
         cnt++;
         if (OrderType() == OP_BUY) {
            pips = (MarketInfo(symbol, MODE_BID)-OrderOpenPrice()) / MarketInfo(symbol, MODE_POINT);
         } else if (OrderType() == OP_SELL) {
            pips = (OrderOpenPrice()-MarketInfo(symbol, MODE_ASK)) / MarketInfo(symbol, MODE_POINT);
         }
      }
   }
   for(i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==symbol && OrderMagicNumber()==magicnumber2) {
         cnt2++;
      }
   }
   infobox = infobox + ", pips: " + pips;
   if (cnt > 0 && cnt2 == 0 && pips > 50) {
      return (1);
   }
      
   return (0);
}


int closelogicGroup(string symbol, int magicnumber, int typeHere)
{
   int i;
   double gtotal_buy = 0;
   double gtotal_sell = 0;

   for(i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()==magicnumber && OrderSymbol()==symbol) {
         if(OrderType()==OP_BUY)
           {
            gtotal_buy = gtotal_buy + OrderProfit();
           }
         if(OrderType()==OP_SELL)
           {
            gtotal_sell = gtotal_sell + OrderProfit();
         
           }
     }
   }

   for(i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()==magicnumber && OrderSymbol()==symbol) {
         if(OrderType()==OP_BUY && typeHere == -1 && gtotal_buy > 0)
           {
            if (logs) Print(symbol, ", closing buy order");
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_BID),3,White);
           }
         if(OrderType()==OP_SELL && typeHere == 1 && gtotal_sell > 0)
           {
            if (logs) Print(symbol, ", closing sell order");
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_ASK),3,White);
         
           }
     }
   }
   return (0);
}


int closelogic(string symbol, int magicnumber, int typeHere)
{
   int i;

   for(i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()==magicnumber && OrderSymbol()==symbol
      // && OrderProfit() > 0
      ) {
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


string trailingstop()
{
   double bid, ask, point;
   int cnt, ticket, total;
   total=OrdersTotal();
   string lowbox;
   int TrailingStop = 150;
   int InitialTrailingStop = 300;
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL
      ) 
         {
         bid = MarketInfo(OrderSymbol(), MODE_BID);
         ask = MarketInfo(OrderSymbol(), MODE_ASK);
         point = MarketInfo(OrderSymbol(), MODE_POINT);
         lowbox = StringConcatenate(lowbox, "\n", OrderSymbol(), ", bid: ", bid, ", ask: ", ask);
         lowbox = StringConcatenate(lowbox, "\n", OrderSymbol(), ", Ordder Profit: ", OrderProfit(), ", OrderOpenPrice: ", OrderOpenPrice());
            if(OrderType()==OP_BUY) {
               if(InitialTrailingStop>0 && TrailingStop>0 && OrderProfit() > 0)  
               {                 
                  lowbox = StringConcatenate(lowbox, "\n", OrderSymbol(), ", bid-OrderOpenPrice(): ", (bid-OrderOpenPrice()), ", point*InitialTrailingStop: ", (point*InitialTrailingStop));
                  if(bid-OrderOpenPrice()>point*InitialTrailingStop)
                  {
                     lowbox = StringConcatenate(lowbox, "\n", OrderSymbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", bid-point*TrailingStop: ", (bid-point*TrailingStop));
                     if(OrderStopLoss()<bid-point*TrailingStop)
                     {
                        lowbox = StringConcatenate(lowbox, "\n", OrderSymbol(), ", Modify Buy");
                        OrderModify(OrderTicket(),OrderOpenPrice(),bid-point*TrailingStop,OrderTakeProfit(),0,Green);
                     }
                  }
               }//end if
            } else if(OrderType()==OP_SELL) {
               // check for trailing stop
               if(InitialTrailingStop>0 && TrailingStop>0 && OrderProfit() > 0)  
                 {                 
                  lowbox = StringConcatenate(lowbox, "\n", OrderSymbol(), ", OrderOpenPrice()-ask: ", (OrderOpenPrice()-ask), ", point*InitialTrailingStop: ", (point*InitialTrailingStop));
                  if((OrderOpenPrice()-ask)>(point*InitialTrailingStop))
                    {
                     lowbox = StringConcatenate(lowbox, "\n", OrderSymbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", ask+point*TrailingStop: ", (ask+point*TrailingStop));
                     if((OrderStopLoss()>(ask+point*TrailingStop)) || (OrderStopLoss()==0))
                       {
                        lowbox = StringConcatenate(lowbox, "\n", OrderSymbol(), ", Modify Sell");
                        OrderModify(OrderTicket(),OrderOpenPrice(),ask+point*TrailingStop,OrderTakeProfit(),0,Red);
                       }
                    }
                 }
            } 
         }
         
      }
      
   lowbox = StringConcatenate("InitialTrailingStop: ",InitialTrailingStop
   , ", TrailingStop: ",TrailingStop,"\n",lowbox);

   return (lowbox);
}