//+------------------------------------------------------------------+
//|                                                 3_signal_inc.mq4 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"



#include <stdlib.mqh>
#include <WinUser32.mqh>

int InitialTrailingStop = 150;
int TrailingStop = 100;

int trailingstop = 150;
int mintrailingstop = 500;
int mintrailingstopavgcosting = 500;
int gmtoffset = 10;
bool createneworders = true;
bool closeonloss = false;

int magic = 0;
int overall_max_orders = -1;
double lots = 0.10;
bool UseAlerts = true;
bool UseEmailAlerts = true;
bool filesave = false;

#define ARRSIZE  28
#define TABSIZE  10
#define PAIRSIZE 8
string broker;
string acctype;
int checking[ARRSIZE][10];
bool checkingb[ARRSIZE][10];
double checkingd[ARRSIZE][10];

double grade[ARRSIZE][30];
double condition[ARRSIZE];
int condition_level[ARRSIZE];
int totalpoints = 8;
string build = "Build 1.7: ";
int hour;
string TimeFrame;

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



//average costing

bool create_avg_orders = true;
int difference[ARRSIZE];

int magic1 = 1231;
int magic2 = 1232;
int magic3 = 1233;
int magic4 = 1235;
int magic5 = 1236;
int magic6 = 1237;
int magic7 = 1238;
int magic8 = 1239;
int magic9 = 1240;

double stoploss[ARRSIZE];
int typeoforder[ARRSIZE];
double totalcost[ARRSIZE];
int totalorders[ARRSIZE];
double lotsavg[ARRSIZE];
double averagecostingprice[ARRSIZE];
double totalprofit[ARRSIZE];
double returncost[ARRSIZE];
double lotsizeorder[ARRSIZE];

int trend_direction[ARRSIZE];
int main_direction[ARRSIZE];

string infobox, orderbox, createbox, historybox;
int opentime;



string trailingstop()
{
   double bid, ask, point;
   int cnt, ticket, total;
   total=OrdersTotal();
   string lowbox;
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
string trailingstopIchimoku(string symbol, int period)
{
   double bid, ask, point;
   int cnt, ticket, total;
   total=OrdersTotal();
   string lowbox;
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol() == symbol
      ) 
         {
            bid = MarketInfo(OrderSymbol(), MODE_BID);
            ask = MarketInfo(OrderSymbol(), MODE_ASK);
            point = MarketInfo(OrderSymbol(), MODE_POINT);
            lowbox = StringConcatenate(lowbox, "\n", OrderSymbol(), ", bid: ", bid, ", ask: ", ask);
            lowbox = StringConcatenate(lowbox, "\n", OrderSymbol(), ", Ordder Profit: ", OrderProfit(), 
            ", OrderOpenPrice: ", OrderOpenPrice());
               int tenkan = tenkan(OrderSymbol(), period, 1);
               lowbox = StringConcatenate(lowbox, "\ntenkan: ", tenkan);
               if (tenkan == 1 && OrderType() == OP_SELL) {
                  //close all sell orders
                  lowbox = lowbox + ", close sell orders";
               } else if (tenkan == -1 && OrderType() == OP_BUY) {
                  //close all buy orders
                  lowbox = lowbox + ", close buy orders";
               }
         }
         
      }
      

   return (lowbox);
}

string followstoploss(int magicnumber, int stoploss)
{
   double bid, ask, point;
   int cnt, ticket, total;
   total=OrdersTotal();
   string lowbox;
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderMagicNumber() == magicnumber
      ) 
         {
         bid = MarketInfo(OrderSymbol(), MODE_BID);
         ask = MarketInfo(OrderSymbol(), MODE_ASK);
         point = MarketInfo(OrderSymbol(), MODE_POINT);
         lowbox = StringConcatenate(lowbox, "\n", OrderSymbol(), ", bid: ", bid, ", ask: ", ask);
         lowbox = StringConcatenate(lowbox, "\n", OrderSymbol(), ", Ordder Profit: ", OrderProfit(), ", OrderOpenPrice: ", OrderOpenPrice());
            if(OrderType()==OP_BUY) {
               if(stoploss > 0)  
               {                 
                  lowbox = StringConcatenate(lowbox, "\n", OrderSymbol(), ", bid-OrderOpenPrice(): ", (bid-OrderOpenPrice()), ", point*InitialTrailingStop: ", (point*InitialTrailingStop));
                  if(bid-OrderOpenPrice()>point*stoploss)
                  {
                     lowbox = StringConcatenate(lowbox, "\n", OrderSymbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", bid-point*TrailingStop: ", (bid-point*TrailingStop));
                     if(OrderStopLoss()<bid-point*stoploss)
                     {
                        lowbox = StringConcatenate(lowbox, "\n", OrderSymbol(), ", Modify Buy");
                        OrderModify(OrderTicket(),OrderOpenPrice(),bid-point*stoploss,OrderTakeProfit(),0,Green);
                     }
                  }
               }//end if
            } else if(OrderType()==OP_SELL) {
               // check for trailing stop
               if(stoploss > 0)  
                 {                 
                  lowbox = StringConcatenate(lowbox, "\n", OrderSymbol(), ", OrderOpenPrice()-ask: ", (OrderOpenPrice()-ask), ", point*InitialTrailingStop: ", (point*InitialTrailingStop));
                  if((OrderOpenPrice()-ask)>(point*stoploss))
                    {
                     lowbox = StringConcatenate(lowbox, "\n", OrderSymbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", ask+point*TrailingStop: ", (ask+point*TrailingStop));
                     if((OrderStopLoss()>(ask+point*stoploss)) || (OrderStopLoss()==0))
                       {
                        lowbox = StringConcatenate(lowbox, "\n", OrderSymbol(), ", Modify Sell");
                        OrderModify(OrderTicket(),OrderOpenPrice(),ask+point*stoploss,OrderTakeProfit(),0,Red);
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
int trailingstopSingle(string symbol)
{
   double bid, ask, point;
   int cnt, ticket, total;
   total=OrdersTotal();
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol() == symbol
      ) 
         {
         bid = MarketInfo(OrderSymbol(), MODE_BID);
         ask = MarketInfo(OrderSymbol(), MODE_ASK);
         point = MarketInfo(OrderSymbol(), MODE_POINT);
         infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", bid: ", bid, ", ask: ", ask);
         infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", Ordder Profit: ", OrderProfit(), ", OrderOpenPrice: ", OrderOpenPrice());
            if(OrderType()==OP_BUY) {
               if(InitialTrailingStop>0 && TrailingStop>0 && OrderProfit() > 0)  
               {                 
                  infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", bid-OrderOpenPrice(): ", (bid-OrderOpenPrice()), ", point*InitialTrailingStop: ", (point*InitialTrailingStop));
                  if(bid-OrderOpenPrice()>point*InitialTrailingStop)
                  {
                     orderbox = StringConcatenate(infobox, "\n", OrderSymbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", bid-point*TrailingStop: ", (bid-point*TrailingStop));
                     if(OrderStopLoss()<bid-point*TrailingStop)
                     {
                        infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", Modify Buy");
                        OrderModify(OrderTicket(),OrderOpenPrice(),bid-point*TrailingStop,OrderTakeProfit(),0,Green);
                     }
                  }
               }//end if
            } else if(OrderType()==OP_SELL) {
               // check for trailing stop
               if(InitialTrailingStop>0 && TrailingStop>0 && OrderProfit() > 0)  
                 {                 
                  infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", OrderOpenPrice()-ask: ", (OrderOpenPrice()-ask), ", point*InitialTrailingStop: ", (point*InitialTrailingStop));
                  if((OrderOpenPrice()-ask)>(point*InitialTrailingStop))
                    {
                     infobox = StringConcatenate(infobox, "\n", OrderSymbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", ask+point*TrailingStop: ", (ask+point*TrailingStop));
                     if((OrderStopLoss()>(ask+point*TrailingStop)) || (OrderStopLoss()==0))
                       {
                        infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", Modify Sell");
                        OrderModify(OrderTicket(),OrderOpenPrice(),ask+point*TrailingStop,OrderTakeProfit(),0,Red);
                       }
                    }
                 }
            } 
         }
         
      }
      
   infobox = StringConcatenate("InitialTrailingStop: ",InitialTrailingStop
   , ", TrailingStop: ",TrailingStop,"\n",infobox);

   return (0);
}


int trailingstopSelf(string symbol)
{
   double bid, ask, point;
   int cnt, ticket, total;
   total=OrdersTotal();
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol() == symbol
      ) 
         {
         bid = MarketInfo(OrderSymbol(), MODE_BID);
         ask = MarketInfo(OrderSymbol(), MODE_ASK);
         point = MarketInfo(OrderSymbol(), MODE_POINT);
         infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", bid: ", bid, ", ask: ", ask);
         infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", Ordder Profit: ", OrderProfit(), ", OrderOpenPrice: ", OrderOpenPrice());
            if(OrderType()==OP_BUY) {
               if(TrailingStop>0)  
               {
                     orderbox = StringConcatenate(infobox, "\n", OrderSymbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", bid-point*TrailingStop: ", (bid-point*TrailingStop));
                     if(OrderStopLoss()<bid-point*TrailingStop)
                     {
                        infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", Modify Buy");
                        OrderModify(OrderTicket(),OrderOpenPrice(),bid-point*TrailingStop,OrderTakeProfit(),0,Green);
                     }
               }//end if
            } else if(OrderType()==OP_SELL) {
               // check for trailing stop
               if(TrailingStop>0)  
                 {           
                     infobox = StringConcatenate(infobox, "\n", OrderSymbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", ask+point*TrailingStop: ", (ask+point*TrailingStop));
                     if((OrderStopLoss()>(ask+point*TrailingStop)) || (OrderStopLoss()==0))
                       {
                        infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", Modify Sell");
                        OrderModify(OrderTicket(),OrderOpenPrice(),ask+point*TrailingStop,OrderTakeProfit(),0,Red);
                       }
                 }
            } 
         }
         
      }
      
   infobox = StringConcatenate("Symbol: ", symbol, ", TrailingStop: ",TrailingStop,"\n",infobox);

   return (0);
}

int createorder(string symbol, int type, double Lots, int magicnumber, string message, int stoploss, int takeprofit)
{

   int maxspread = 100;
   int ignorespread = 0;
   int orders;
   int ordertype;
   double price;
   double val3;
   double pending_margin = 50;
   int sleeptime = 1000;
   double bids, asks, pt, digit;
   int ticket;
   double tp, sl;
   tp = 0;
   sl = 0;

   createbox = createbox + "\n" + symbol;
   //Step 1: check different conditions
   if (IsTradeAllowed()==false) {
      createbox = createbox + " TRADING NOW ALLOWED";
      return (0);
   }

   if (MarketInfo(symbol, MODE_SPREAD) > maxspread && ignorespread == 0) {
      //return (0);
   }
   
   
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

   orders = CalculateCurrentOrders(symbol, magicnumber);//, ordertype
   if (orders > 0)
   {
      createbox = createbox + " previous orders: " + orders + " NO TRADING";
       return (0);
   }

   orders = CalculateMaxOrders(magic);
   if (orders >= overall_max_orders && overall_max_orders > 0) {
      createbox = createbox + " overallmax orders: " + orders + " NO TRADING";
      Print(" overallmax orders: " + orders + " NO TRADING");
      return (0);
   }
   
   //Step 2: create order
   bids = MarketInfo(symbol, MODE_BID);
   asks = MarketInfo(symbol, MODE_ASK);
   pt = MarketInfo(symbol, MODE_POINT);
   digit = MarketInfo(symbol, MODE_DIGITS);
   bids = NormalizeDouble(bids, digit);
   asks = NormalizeDouble(asks, digit);
   
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
            SendAlert("Bullish, " + message + ", Broker: " + AccountCompany() + ", AccType Demo: " + IsDemo(), symbol, Period());
         }
      } else {
         Print(symbol, ", Error opening BUY order : ",ErrorDescription(GetLastError()), ", asks: ", asks, ", lots: ", Lots);
         Sleep(sleeptime);
         createorder(symbol, type, Lots, magicnumber, message, stoploss, takeprofit);
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
            SendAlert("Bearish, " + message + ", Broker: " + AccountCompany() + ", AccType Demo: " + IsDemo(), symbol, Period());
         }
      } else {
         Print(symbol, ", Error opening SELL order : ",ErrorDescription(GetLastError()), ", bids: ", bids, ", lots: ", Lots);
         Sleep(sleeptime);
         createorder(symbol, type, Lots, magicnumber, message, stoploss, takeprofit);
      }
      Sleep(sleeptime);
      return(0);
   }
}



/*
int CalculateCurrentOrdersType(int magicnumber, int ordertype)
{
   int cnt=0;
   int i;
   for(i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderMagicNumber()==magicnumber && OrderType() == ordertype) {
         cnt++;
      }
   }
      
   return (cnt);
}
*/
   
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
int CalculateOrdersTypeSymbol(string symbol, int magicnumber, int ordertype)
{
   int cnt=0;
   int i;
   for(i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==symbol && OrderMagicNumber()==magicnumber && OrderType() == ordertype) {
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
      if(OrderMagicNumber()==magicnumber) {
         cnt++;
      }
   }
      
   return (cnt);
}


void FileAppend(string name,string txt)
{
   int handle = FileOpen(name,FILE_READ|FILE_WRITE);
	FileSeek(handle,0,SEEK_END);
	FileWrite(handle,txt);
	FileFlush(handle);
	FileClose(handle);
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



string render_avg_costing(string symbol, int i, double lots, bool trailingFun=true, bool avg_costing=true)
{
   string box = "";
   difference[i] = get_difference(symbol, i);
   box = box + "\nSymbol: " + symbol + ", Difference: " + difference[i];
   box = box + get_average_costing(symbol, i);
   if (totalorders[i] == 0) {
      return (0);
   }
   
   box = box + ", trailingFun: "+trailingFun+", avg_costing: " + avg_costing;
   if (avg_costing) {
      //box = box + "\nAvg Costing";
      box = box + create_average_costing(symbol, i, lots);
   }
   if (trailingFun) {
      //box = box + ", Trailing Fun: ";
      box = box + closingonprofit(symbol, i);
   }
   return (box);
}


int change_stop_loss(string symbol, double sl)
{
   int sleeptime = 1000;
      for(int cnt=0;cnt<OrdersTotal();cnt++) {
         OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if(OrderType()<=OP_SELL && OrderSymbol()==symbol
         ) {
            if(OrderType()==OP_BUY) {
               OrderModify(OrderTicket(),OrderOpenPrice(),sl,OrderTakeProfit(),0,Green);
               Sleep(sleeptime);
            } else if(OrderType()==OP_SELL) {
               OrderModify(OrderTicket(),OrderOpenPrice(),sl,OrderTakeProfit(),0,Red);
               Sleep(sleeptime);
            }
         }
      }
}


string create_average_costing(string symbol, int mode, double lotsAvail)
{
   string box = "";
   if (totalorders[mode] == 0)
      return (0);

   if (lotsizeorder[mode] > 0) {
      lotsAvail = lotsizeorder[mode];
   }
   double bid = MarketInfo(symbol, MODE_BID);
   double point = MarketInfo(symbol, MODE_POINT);
   int diff;
   if (totalprofit[mode] < 0) {
      diff = MathAbs(bid - averagecostingprice[mode]) / point;
      box = box + "\nTotal Profit: " + totalprofit[mode] + 
         " - Total Average: " + averagecostingprice[mode] + " - Total Orders: " + totalorders[mode] + " - Current Diff: " + diff + 
         " - Custom Diff: " + difference[mode] + " - typeoforder: " + typeoforder[mode];

      if (diff > (difference[mode] * 1) && diff < (difference[mode] * 2) && create_avg_orders) {
         box = box + " - D1:" + (difference[mode] * 1);
         createorder(symbol, typeoforder[mode], lotsAvail, magic1, "Build 1.2: Level 1", 0, 0);
      } 
      if (diff > (difference[mode] * 2) && diff < (difference[mode] * 3) && create_avg_orders) {
         box = box + " - D2:" + (difference[mode] * 2);
         createorder(symbol, typeoforder[mode], lotsAvail, magic2, "Build 1.2: Level 2", 0, 0);
      } 
      if (diff > (difference[mode] * 3) && diff < (difference[mode] * 4) && create_avg_orders) {
         box = box + " - D3:" + (difference[mode] * 3);
         createorder(symbol, typeoforder[mode], lotsAvail, magic3, "Build 1.2: Level 3", 0, 0);
      } 
      if (diff > (difference[mode] * 4) && create_avg_orders) {
         box = box + " - D4:" + (difference[mode] * 4);
         createorder(symbol, typeoforder[mode], lotsAvail, magic4, "Build 1.2: Level 4", 0, 0);
      }
   }
   return (box);
}
string get_average_costing(string symbol, int mode)
{
   string box;
   int cnt;
   double openprice;
   double lotsize;
   int x = 0;
   lotsavg[mode] = 0.0;
   totalcost[mode] = 0.0;
   typeoforder[mode] = 0;
   totalorders[mode] = 0;
   totalprofit[mode] = 0;
   averagecostingprice[mode] = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol()==symbol
         && (OrderMagicNumber() == magic || OrderMagicNumber() == magic1 
         || OrderMagicNumber() == magic2 || OrderMagicNumber() == magic3 || OrderMagicNumber() == magic4)
      ) {
         //Print(symbol, ", ", OrderMagicNumber());
         if (OrderMagicNumber() == magic && averagecostingprice[mode] == 0) {
            averagecostingprice[mode] = OrderOpenPrice();
            lotsizeorder[mode] = OrderLots();
         }

         x++;
         totalprofit[mode] += OrderProfit();
         totalorders[mode]++;
         openprice = OrderOpenPrice();
         lotsize = OrderLots();
         lotsavg[mode] = lotsavg[mode] + lotsize;
         totalcost[mode] = totalcost[mode] + (lotsize * openprice);
         if(OrderType()==OP_BUY) {
            typeoforder[mode] = 1;            
         } else if(OrderType()==OP_SELL) {
            typeoforder[mode] = -1;            
         }
      }
   }

   returncost[mode] = 0;
   if (x == 0) {
      // no previous orders
   } else {
     double cost = 0.0;
     cost = totalcost[mode] / lotsavg[mode];
     returncost[mode] = cost;
  }
  if (totalorders[mode] > 0)
      box = box + StringConcatenate("\n", ", lotsavg[mode]: ", DoubleToStr(lotsavg[mode], 2), ", totalcost[mode]: ", totalcost[mode], ", typeoforder: ", typeoforder[mode], ", totalprofit[mode]: ", totalprofit[mode], ", returncost[mode]: ", returncost[mode]);
   
   return (box);
}




int get_difference(string symbol, int mode)
{
   double point = MarketInfo(symbol, MODE_POINT);
   double diff1, diff2, diff3, diff4, diff5, diff;
   diff1 = iHigh(symbol, PERIOD_D1, 1) - iLow(symbol, PERIOD_D1, 1);
   diff2 = iHigh(symbol, PERIOD_D1, 2) - iLow(symbol, PERIOD_D1, 2);
   diff3 = iHigh(symbol, PERIOD_D1, 3) - iLow(symbol, PERIOD_D1, 3);
   diff4 = iHigh(symbol, PERIOD_D1, 4) - iLow(symbol, PERIOD_D1, 4);
   diff5 = iHigh(symbol, PERIOD_D1, 5) - iLow(symbol, PERIOD_D1, 5);
   diff = (diff1 + diff2 + diff3 + diff4 + diff5) / 5;
   return (diff / point);
}


//murry MathS

int P = 64;
int MMPeriod = 1440;
int StepBack = 0;

color  mml_clr_m_2_8 = White;       // [-2]/8
color  mml_clr_m_1_8 = White;       // [-1]/8
color  mml_clr_0_8   = Aqua;        //  [0]/8
color  mml_clr_1_8   = Yellow;      //  [1]/8
color  mml_clr_2_8   = Red;         //  [2]/8
color  mml_clr_3_8   = Green;       //  [3]/8
color  mml_clr_4_8   = Blue;        //  [4]/8
color  mml_clr_5_8   = Green;       //  [5]/8
color  mml_clr_6_8   = Red;         //  [6]/8
color  mml_clr_7_8   = Yellow;      //  [7]/8
color  mml_clr_8_8   = Aqua;        //  [8]/8
color  mml_clr_p_1_8 = White;       // [+1]/8
color  mml_clr_p_2_8 = White;       // [+2]/8

int    mml_wdth_m_2_8 = 2;        // [-2]/8
int    mml_wdth_m_1_8 = 1;       // [-1]/8
int    mml_wdth_0_8   = 1;        //  [0]/8
int    mml_wdth_1_8   = 1;      //  [1]/8
int    mml_wdth_2_8   = 1;         //  [2]/8
int    mml_wdth_3_8   = 1;       //  [3]/8
int    mml_wdth_4_8   = 1;        //  [4]/8
int    mml_wdth_5_8   = 1;       //  [5]/8
int    mml_wdth_6_8   = 1;         //  [6]/8
int    mml_wdth_7_8   = 1;      //  [7]/8
int    mml_wdth_8_8   = 1;        //  [8]/8
int    mml_wdth_p_1_8 = 1;       // [+1]/8
int    mml_wdth_p_2_8 = 2;       // [+2]/8

color  MarkColor   = Blue;
int    MarkNumber  = 217;


double  dmml = 0,
        dvtl = 0,
        sum  = 0,
        v1 = 0,
        v2 = 0,
        mn = 0,
        mx = 0,
        x1 = 0,
        x2 = 0,
        x3 = 0,
        x4 = 0,
        x5 = 0,
        x6 = 0,
        y1 = 0,
        y2 = 0,
        y3 = 0,
        y4 = 0,
        y5 = 0,
        y6 = 0,
        octave = 0,
        fractal = 0,
        range   = 0,
        finalH  = 0,
        finalL  = 0,
        mml[13];

string  ln_txt[13],        
        buff_str = "";
        
int     
        bn_v1   = 0,
        bn_v2   = 0,
        OctLinesCnt = 13,
        mml_thk = 8,
        mml_clr[13],
        mml_wdth[13],
        mml_shft = 35,
        nTime = 0,
        CurPeriod = 0,
        nDigits = 0,
        i = 0;
int NewPeriod=0;

int mathmurry(string symbol, int mode, int period)
{
   double bids, asks, pt, digit;
   bids = MarketInfo(symbol, MODE_BID);
   asks = MarketInfo(symbol, MODE_ASK);
   pt = MarketInfo(symbol, MODE_POINT);
   digit = MarketInfo(symbol, MODE_DIGITS);

   if(MMPeriod>0)
      NewPeriod   = P*MathCeil(MMPeriod/period);
   else NewPeriod = P;
   
   ln_txt[0]  = "[-2/8]P";// "extremely overshoot [-2/8]";// [-2/8]
   ln_txt[1]  = "[-1/8]P";// "overshoot [-1/8]";// [-1/8]
   ln_txt[2]  = "[0/8]P";// "Ultimate Support - extremely oversold [0/8]";// [0/8]
   ln_txt[3]  = "[1/8]P";// "Weak, Stall and Reverse - [1/8]";// [1/8]
   ln_txt[4]  = "[2/8]P";// "Pivot, Reverse - major [2/8]";// [2/8]
   ln_txt[5]  = "[3/8]P";// "Bottom of Trading Range - [3/8], if 10-12 bars then 40% Time. BUY Premium Zone";//[3/8]
   ln_txt[6]  = "[4/8]P";// "Major Support/Resistance Pivotal Point [4/8]- Best New BUY or SELL level";// [4/8]
   ln_txt[7]  = "[5/8]P";// "Top of Trading Range - [5/8], if 10-12 bars then 40% Time. SELL Premium Zone";//[5/8]
   ln_txt[8]  = "[6/8]P";// "Pivot, Reverse - major [6/8]";// [6/8]
   ln_txt[9]  = "[7/8]P";// "Weak, Stall and Reverse - [7/8]";// [7/8]
   ln_txt[10] = "[8/8]P";// "Ultimate Resistance - extremely overbought [8/8]";// [8/8]
   ln_txt[11] = "[+1/8]P";// "overshoot [+1/8]";// [+1/8]
   ln_txt[12] = "[+2/8]P";// "extremely overshoot [+2/8]";// [+2/8]
   string leveldetails[13] = {"extremely overshoot [-2/8]P", "overshoot [-1/8]P", 
      "Ultimate Support - extremely oversold [0/8]P", "Weak, Stall and Reverse - [1/8]P", 
      "Pivot, Reverse - major [2/8]P", "Bottom of Trading Range - [3/8]P", "Major Support/Resistance Pivotal Point [4/8]P",
      "Top of Trading Range - [5/8]P", "Pivot, Reverse - major [6/8]P", "Weak, Stall and Reverse - [7/8]P", 
      "Ultimate Resistance - extremely overbought [8/8]P", "overshoot [+1/8]P", "extremely overshoot [+2/8]P"};
   //mml_shft = 3;
   mml_thk  = 3;


   mml_clr[0]  = mml_clr_m_2_8;   mml_wdth[0] = mml_wdth_m_2_8; // [-2]/8
   mml_clr[1]  = mml_clr_m_1_8;   mml_wdth[1] = mml_wdth_m_1_8; // [-1]/8
   mml_clr[2]  = mml_clr_0_8;     mml_wdth[2] = mml_wdth_0_8;   //  [0]/8
   mml_clr[3]  = mml_clr_1_8;     mml_wdth[3] = mml_wdth_1_8;   //  [1]/8
   mml_clr[4]  = mml_clr_2_8;     mml_wdth[4] = mml_wdth_2_8;   //  [2]/8
   mml_clr[5]  = mml_clr_3_8;     mml_wdth[5] = mml_wdth_3_8;   //  [3]/8
   mml_clr[6]  = mml_clr_4_8;     mml_wdth[6] = mml_wdth_4_8;   //  [4]/8
   mml_clr[7]  = mml_clr_5_8;     mml_wdth[7] = mml_wdth_5_8;   //  [5]/8
   mml_clr[8]  = mml_clr_6_8;     mml_wdth[8] = mml_wdth_6_8;   //  [6]/8
   mml_clr[9]  = mml_clr_7_8;     mml_wdth[9] = mml_wdth_7_8;   //  [7]/8
   mml_clr[10] = mml_clr_8_8;     mml_wdth[10]= mml_wdth_8_8;   //  [8]/8
   mml_clr[11] = mml_clr_p_1_8;   mml_wdth[11]= mml_wdth_p_1_8; // [+1]/8
   mml_clr[12] = mml_clr_p_2_8;   mml_wdth[12]= mml_wdth_p_2_8; // [+2]/8
   
   bn_v1 = Lowest(symbol, period,MODE_LOW,NewPeriod+StepBack,StepBack);
   bn_v2 = Highest(symbol, period,MODE_HIGH,NewPeriod+StepBack,StepBack);
   v1 = iLow(symbol, period, bn_v1);
   v2 = iHigh(symbol, period, bn_v2);
   if( v2<=250000 && v2>25000 )
   fractal=100000;
   else
     if( v2<=25000 && v2>2500 )
     fractal=10000;
     else
       if( v2<=2500 && v2>250 )
       fractal=1000;
       else
         if( v2<=250 && v2>25 )
         fractal=100;
         else
           if( v2<=25 && v2>12.5 )
           fractal=12.5;
           else
             if( v2<=12.5 && v2>6.25)
             fractal=12.5;
             else
               if( v2<=6.25 && v2>3.125 )
               fractal=6.25;
               else
                 if( v2<=3.125 && v2>1.5625 )
                 fractal=3.125;
                 else
                   if( v2<=1.5625 && v2>0.390625 )
                   fractal=1.5625;
                   else
                     if( v2<=0.390625 && v2>0)
                     fractal=0.1953125;
      
   range=(v2-v1);
   sum=MathFloor(MathLog(fractal/range)/MathLog(2));
   octave=fractal*(MathPow(0.5,sum));
   mn=MathFloor(v1/octave)*octave;
   if( (mn+octave)>v2 )
   mx=mn+octave; 
   else
     mx=mn+(2*octave);
     
   
// calculating xx
//x2
    if( (v1>=(3*(mx-mn)/16+mn)) && (v2<=(9*(mx-mn)/16+mn)) )
    x2=mn+(mx-mn)/2; 
    else x2=0;
//x1
    if( (v1>=(mn-(mx-mn)/8))&& (v2<=(5*(mx-mn)/8+mn)) && (x2==0) )
    x1=mn+(mx-mn)/2; 
    else x1=0;

//x4
    if( (v1>=(mn+7*(mx-mn)/16))&& (v2<=(13*(mx-mn)/16+mn)) )
    x4=mn+3*(mx-mn)/4; 
    else x4=0;

//x5
    if( (v1>=(mn+3*(mx-mn)/8))&& (v2<=(9*(mx-mn)/8+mn))&& (x4==0) )
    x5=mx; 
    else  x5=0;

//x3
    if( (v1>=(mn+(mx-mn)/8))&& (v2<=(7*(mx-mn)/8+mn))&& (x1==0) && (x2==0) && (x4==0) && (x5==0) )
    x3=mn+3*(mx-mn)/4; 
    else x3=0;

//x6
    if( (x1+x2+x3+x4+x5) ==0 )
    x6=mx; 
    else x6=0;

     finalH = x1+x2+x3+x4+x5+x6;
// calculating yy
//y1
    if( x1>0 )
    y1=mn; 
    else y1=0;

//y2
    if( x2>0 )
    y2=mn+(mx-mn)/4; 
    else y2=0;

//y3
    if( x3>0 )
    y3=mn+(mx-mn)/4; 
    else y3=0;

//y4
    if( x4>0 )
    y4=mn+(mx-mn)/2; 
    else y4=0;

//y5
    if( x5>0 )
    y5=mn+(mx-mn)/2; 
    else y5=0;

//y6
    if( (finalH>0) && ((y1+y2+y3+y4+y5)==0) )
    y6=mn; 
    else y6=0;

    finalL = y1+y2+y3+y4+y5+y6;

    for( i=0; i<OctLinesCnt; i++) {
         mml[i] = 0;
         }
         
   dmml = (finalH-finalL)/8;

   mml[0] =(finalL-dmml*2); //-2/8
   grade[mode][0] = mml[0];

   infobox = StringConcatenate(infobox, "\n", symbol);
   //infobox = StringConcatenate(infobox, ", 0: ", DoubleToStr(grade[mode][0], MarketInfo(symbol, MODE_DIGITS)));
   for( i=1; i<OctLinesCnt; i++) {
        mml[i] = mml[i-1] + dmml;
        grade[mode][i] = mml[i];
        //infobox = StringConcatenate(infobox, ", ", i, ": ", DoubleToStr(grade[mode][i], MarketInfo(symbol, MODE_DIGITS)));
        }
   int currentlevel = -1;
   if (bids < grade[mode][0]) {
      currentlevel = 0;
   } else if (bids > grade[mode][12]) {
      currentlevel = 13;
   } else {
      for ( i=0; i<OctLinesCnt-1; i++) {
         if (bids > grade[mode][i] && bids < grade[mode][i + 1]) {
            currentlevel = i+1;
         }
      }
   }
   condition_level[mode] = currentlevel;
   //infobox = StringConcatenate(infobox, " - ", DoubleToStr(((grade[mode][12] - grade[mode][0])/MarketInfo(symbol, MODE_POINT)), 0));
   infobox = StringConcatenate(infobox, ", Level: ", currentlevel);
   infobox = infobox + ", " + leveldetails[currentlevel];
   if (currentlevel >= 10) {
      condition[mode] = -1;
   } else if (currentlevel <= 2) {
      condition[mode] = 1;
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



void SendAlert(string dir, string symbol, int period)
{
   string per = TimeframeToString(period);
   if (UseAlerts)
   {
      Alert(dir + " on ", symbol, " @ ", per);
      PlaySound("alert.wav");
   }
   if (UseEmailAlerts)
      SendMail(symbol + " @ " + per + " - " + dir + " ", dir + " on " + symbol + " @ " + per + " as of " + TimeToStr(TimeCurrent()));
}


string closingonprofit(string symbol, int mode)
{
   string box = "";
   if (totalorders[mode] == 0) {
      stoploss[mode] = 0;
      return (box);
   }

   int cnt;
   
      double ask = MarketInfo(symbol, MODE_ASK);
      double bid = MarketInfo(symbol, MODE_BID);
      double spread = MarketInfo(symbol, MODE_SPREAD);
      double point = MarketInfo(symbol, MODE_POINT);
      double digit = MarketInfo(symbol, MODE_DIGITS);
      
   box = box + "\nTotal Profit: " + totalprofit[mode] + 
   ", totalorders: " + totalorders[mode];
   
   //new addition, if does not work then we can commit this.
   box = infobox + "\nAverage Cost: " + returncost[mode] + 
   ", trailingstop: " + trailingstop + ", mintrailingstop: " + mintrailingstop + 
   ", mintrailingstopavgcosting: " + mintrailingstopavgcosting;
   
   int checkpoint = mintrailingstop;
   if (totalorders[mode] > 1) {
      checkpoint = mintrailingstopavgcosting;
   }
   box = box + "\nstoploss: " + stoploss[mode] + ", checkpoint: " + checkpoint +
      ", (bid-returncost[mode])(buy): " + (bid-returncost[mode]) + ", returncost[mode]-ask(sell): " + (returncost[mode]-ask) +
      ", (point*checkpoint): " + (point*checkpoint) 
   ;
   if(typeoforder[mode] == 1 && (bid-returncost[mode]) > point*checkpoint)
   {
      if(stoploss[mode] < (bid - point*trailingstop)) {
         stoploss[mode] = bid - point*trailingstop;
         box = box + "\nstoploss: " + stoploss[mode];
         change_stop_loss(symbol, stoploss[mode]);
      }
   } else if (typeoforder[mode] == -1 && (returncost[mode]-ask)>(point*checkpoint)) {
      if((stoploss[mode] > (ask + point*trailingstop)) || (stoploss[mode]==0)) {
         stoploss[mode] = ask + point*trailingstop;
         box = box + "\nstoploss: " + stoploss[mode];
         change_stop_loss(symbol, stoploss[mode]);
      }
   }
   box = box + "\n----------------------------------";   
   return (box);
}



int get_semaphore(int i)
{
   
      //semafor
      double ZZ_1, ZZ_2;
      double Period1            = 5;
      double Period2            = 13;
      double Period3            = 34;
      string Dev_Step_1         ="1,3";
      string Dev_Step_2         ="8,5";
      string Dev_Step_3         ="21,12";
      int Symbol_1_Kod          =140;
      int Symbol_2_Kod          =141;
      int Symbol_3_Kod          =142;
      bool condition_buy, condition_sell;
      
      string symbol = aPair[i];
      ZZ_1=iCustom(symbol,PERIOD_H4,"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,5,3);
      ZZ_2=iCustom(symbol,PERIOD_H4,"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,4,3);
      condition_sell = ZZ_1 > ZZ_2;
      condition_buy = ZZ_1 < ZZ_2;
      infobox = infobox + "\n" + symbol + ", Semaphore: " + ZZ_1 + "/" + ZZ_2 + " Buy: " + condition_buy + ", Sell: " + condition_sell;
         
      if (condition_buy) {
         return (1);
      } else if (condition_sell) {
         return (-1);
      } else {
         return (0);
      }
}

void CheckForClose(string symbol, int mode, int magicnumber, int typeHere)
  {
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()==magicnumber && OrderSymbol()==symbol && OrderProfit() > 0) {
         if(OrderType()==OP_BUY && typeHere == -1)
           {
            Alert(symbol, ", closing buy order");
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_BID),3,White);
           }
         if(OrderType()==OP_SELL && typeHere == 1)
           {
            Alert(symbol, ", closing sell order");
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_ASK),3,White);
         
           }
     }
   }
//----
  }
  
int getordertype(string symbol)
{
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderSymbol()==symbol) {
         if(OrderType()==OP_BUY)
           {
            return (1);
           }
         if(OrderType()==OP_SELL)
           {
            return (-1);
         
           }
     }
   }
   return (0);
}
void CheckForCloseALL(string symbol, int mode, int typeHere)
  {
   if (totalprofit[mode] <= 0) {
      return (0);
   }
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderSymbol()==symbol && (OrderMagicNumber() == magic || OrderMagicNumber() == magic1 
         || OrderMagicNumber() == magic2 || OrderMagicNumber() == magic3 || OrderMagicNumber() == magic4)) {
         if(OrderType()==OP_BUY && typeHere == -1)
           {
            Alert(symbol, ", closing all buy order");
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_BID),3,White);
           }
         if(OrderType()==OP_SELL && typeHere == 1)
           {
            Alert(symbol, ", closing all sell order");
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_ASK),3,White);
         
           }
     }
   }
//----
  }
  
void CloseOrder(string symbol, int mode, int magicnumber)
  {
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()==magicnumber && OrderSymbol()==symbol && OrderProfit() > 0) {
         if(OrderType()==OP_BUY)
           {
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_BID),3,White);
           }
         if(OrderType()==OP_SELL)
           {
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_ASK),3,White);
         
           }
     }
   }
//----
  }  
int get_trendsemaphore(int i, int period, int shift)
{
   
      //semafor
      double ZZ_1, ZZ_2;
      double Period1            = 5;
      double Period2            = 13;
      double Period3            = 34;
      string Dev_Step_1         ="1,3";
      string Dev_Step_2         ="8,5";
      string Dev_Step_3         ="21,12";
      int Symbol_1_Kod          =140;
      int Symbol_2_Kod          =141;
      int Symbol_3_Kod          =142;
      bool condition_buy, condition_sell;
      
      string symbol = aPair[i];
      ZZ_1=iCustom(symbol,period,"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,5,shift);
      ZZ_2=iCustom(symbol,period,"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,4,shift);
      condition_sell = ZZ_1 > ZZ_2;
      condition_buy = ZZ_1 < ZZ_2;
      infobox = infobox + "\n" + symbol + ", Semaphore: " + ZZ_1 + "/" + ZZ_2 + " Buy: " + condition_buy + ", Sell: " + condition_sell;
         
      if (condition_buy) {
         return (1);
      } else if (condition_sell) {
         return (-1);
      } else {
         return (0);
      }
}

int semaphoreNumber = 0;
int get_lasttrendsemaphore(string symbol, int period, bool show=true)
{

      semaphoreNumber = 0;
      //semafor
      double ZZ_1, ZZ_2;
      double Period1            = 5;
      double Period2            = 13;
      double Period3            = 34;
      string Dev_Step_1         ="1,3";
      string Dev_Step_2         ="8,5";
      string Dev_Step_3         ="21,12";
      int Symbol_1_Kod          =140;
      int Symbol_2_Kod          =141;
      int Symbol_3_Kod          =142;
      bool condition_buy, condition_sell;
      
      //string symbol = aPair[i];
      for (int z=0; z < 240; z++) {
      
         ZZ_1=iCustom(symbol,period,"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,5,z);
         ZZ_2=iCustom(symbol,period,"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,4,z);
         condition_sell = ZZ_1 > ZZ_2;
         condition_buy = ZZ_1 < ZZ_2;
         
         if (condition_buy) {
         
            if (show) infobox = infobox + "\nSemaphore Number: " + z;
            semaphoreNumber = z;
            return (1);
         } else if (condition_sell) {
            if (show) infobox = infobox + "\nSemaphore Number: " + z;
            semaphoreNumber = z;
            return (-1);
         }
     }
     return (0);
}

int semaphore(string symbol, int period, int shift)
{

      semaphoreNumber = 0;
      //semafor
      double ZZ_1, ZZ_2;
      double Period1            = 5;
      double Period2            = 13;
      double Period3            = 34;
      string Dev_Step_1         ="1,3";
      string Dev_Step_2         ="8,5";
      string Dev_Step_3         ="21,12";
      int Symbol_1_Kod          =140;
      int Symbol_2_Kod          =141;
      int Symbol_3_Kod          =142;
      bool condition_buy, condition_sell;
      
      
         ZZ_1=iCustom(symbol,period,"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,5,shift);
         ZZ_2=iCustom(symbol,period,"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,4,shift);
         condition_sell = ZZ_1 > ZZ_2;
         condition_buy = ZZ_1 < ZZ_2;
         
         if (condition_buy) {
            return (1);
         } else if (condition_sell) {
            return (-1);
         }
     return (0);
}

int semaphoreShift(string symbol, int period, int shift)
{

      semaphoreNumber = 0;
      //semafor
      double ZZ_1, ZZ_2;
      double Period1            = 5;
      double Period2            = 13;
      double Period3            = 34;
      string Dev_Step_1         ="1,3";
      string Dev_Step_2         ="8,5";
      string Dev_Step_3         ="21,12";
      int Symbol_1_Kod          =140;
      int Symbol_2_Kod          =141;
      int Symbol_3_Kod          =142;
      bool condition_buy, condition_sell;
      
      for (int z=shift; z < shift+240; z++) {
      
         ZZ_1=iCustom(symbol,period,"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,5,z);
         ZZ_2=iCustom(symbol,period,"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,4,z);
         condition_sell = ZZ_1 > ZZ_2;
         condition_buy = ZZ_1 < ZZ_2;
         
         if (condition_buy) {
            semaphoreNumber = z;
            return (1);
         } else if (condition_sell) {
            semaphoreNumber = z;
            return (-1);
         }
     }
     return (0);
}

double history(string symbol, int i, int magicnum)
{
   int cnt;
   int total = OrdersHistoryTotal();
   double gtotal = 0;
   for(cnt=0;cnt<total;cnt++)
   {
      OrderSelect(cnt, SELECT_BY_POS, MODE_HISTORY);
      if (OrderMagicNumber()==magicnum && OrderSymbol() == symbol) {
         gtotal += OrderProfit();
         //Print("Cnt: ", cnt, ", ticket: ", OrderTicket(), ", Order Profit: ", OrderProfit(), ", currency: ", OrderSymbol());
         //Print("close day: ", TimeDay(OrderCloseTime()), ", close month: ", TimeMonth(OrderCloseTime()), ", close year: ", TimeYear(OrderCloseTime())
            //, ", current day: ", Day(), ", current month: ", Month(), ", current year: ", Year()
         //);
      }
   }
   historybox = historybox + "\nTotal Profit/Loss For Symbol: " + symbol + " and magic: " + magicnum +
   " is: " + DoubleToStr(gtotal, 2);
   return (gtotal);
}


int getallinfo()
{
   string mySymbol;
   double high, low, bid, ask, point, spread, digits;
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
         int index;
         //infobox = infobox + "\n\n";
         for (index=0; index<ARRSIZE; index++) {
            
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
         for (z=0; z<4; z++) {
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
         }
         aMeter[USD] = NormalizeDouble((aLookup[USDJPY]+aLookup[USDCHF]+aLookup[USDCAD]+aStrength[EURUSD]+aStrength[GBPUSD]+aStrength[AUDUSD]+aStrength[NZDUSD])/7,1);
   aMeter[EUR] = NormalizeDouble((aLookup[EURUSD]+aLookup[EURJPY]+aLookup[EURGBP]+aLookup[EURCHF]+aLookup[EURAUD]+aLookup[EURCAD]+aLookup[EURNZD])/7,1);
   aMeter[GBP] = NormalizeDouble((aLookup[GBPUSD]+aLookup[GBPJPY]+aLookup[GBPCHF]+aStrength[EURGBP]+aLookup[GBPCAD]+aLookup[GBPAUD]+aLookup[GBPNZD])/7,1);
   aMeter[CHF] = NormalizeDouble((aStrength[USDCHF]+aStrength[EURCHF]+aStrength[GBPCHF]+aStrength[AUDCHF]+aLookup[CHFJPY]+aStrength[CADCHF]+aStrength[NZDCHF])/7,1);
   aMeter[CAD] = NormalizeDouble((aStrength[USDCAD]+aLookup[CADCHF]+aStrength[AUDCAD]+aLookup[CADJPY]+aStrength[EURCAD]+aStrength[GBPCAD]+aStrength[NZDCAD])/7,1);
   aMeter[AUD] = NormalizeDouble((aLookup[AUDUSD]+aStrength[EURAUD]+aLookup[AUDCHF]+aLookup[AUDCAD]+aStrength[GBPAUD]+aLookup[AUDNZD]+aLookup[AUDJPY])/7,1);
   aMeter[JPY] = NormalizeDouble((aStrength[USDJPY]+aStrength[EURJPY]+aStrength[GBPJPY]+aStrength[NZDJPY]+aStrength[AUDJPY]+aStrength[CHFJPY]+aStrength[CADJPY])/7,1);     
   aMeter[NZD] = NormalizeDouble((aLookup[NZDUSD]+aStrength[EURNZD]+aStrength[GBPNZD]+aStrength[AUDNZD]+aLookup[NZDCAD]+aLookup[NZDCHF]+aLookup[NZDJPY])/7,1);
   string strength = "\nCurrent Meter: USD: " + aMeter[USD] + ", EUR: " + aMeter[EUR] + "\nGBP: " + aMeter[GBP]
         + ", CHF: " + aMeter[CHF] + "\nCAD: " + aMeter[CAD] + ", AUD: " + aMeter[AUD]
          + "\nJPY: " + aMeter[JPY] + ", NZD: " + aMeter[NZD];
   infobox = infobox + strength;
}



string getallinfoshift(int period, int shift)
{
   string mySymbol;
   double high, low, bid, ask, point, spread, digits;
   int maxloop = 4;
   switch(period)
   {
      case PERIOD_M1:  maxloop = 256; break;
      case PERIOD_M5:  maxloop = 128; break;
      case PERIOD_M15: maxloop = 64; break;
      case PERIOD_M30: maxloop = 32; break;
      case PERIOD_H1:  maxloop = 16; break;
      case PERIOD_H4:  maxloop = 4; break;
      case PERIOD_D1:  maxloop = 4; break;
      case PERIOD_W1:  maxloop = 4; break;
      case PERIOD_MN1: maxloop = 4; break;
      default: maxloop = 4; break;
   }
      double aHigh[ARRSIZE];
      double aLow[ARRSIZE];
      double aHigh1[ARRSIZE];
      double aBid[ARRSIZE];
      double aAsk[ARRSIZE];
      double aClose[ARRSIZE];
      double aRatio[ARRSIZE];
      double aRange[ARRSIZE];
      double aLookup[ARRSIZE];
      double aStrength[ARRSIZE];
      int z;
         int index;
         //infobox = infobox + "\n\n";
         for (index=0; index<ARRSIZE; index++) {
            
         RefreshRates();
         mySymbol = aPair[index];
         //infobox = infobox + "\n" + mySymbol;
         /*bid = MarketInfo(mySymbol, MODE_BID);
         ask = MarketInfo(mySymbol, MODE_ASK);*/
         point = MarketInfo(mySymbol, MODE_POINT);
         spread = MarketInfo(mySymbol, MODE_SPREAD);
         digits = MarketInfo(mySymbol, MODE_DIGITS);
         //Calculating the points:
         high = -1;
         low = -1;
         for (z=shift; z<shift+maxloop; z++) {
            if (high == -1) {
               high = iHigh(mySymbol, period, z);
            }
            if (iHigh(mySymbol, period, z) > high) {
               high = iHigh(mySymbol, period, z);
            }
            if (low == -1) {
               low = iLow(mySymbol, period, z);
            }
            if (iLow(mySymbol, period, z) < low) {
               low = iLow(mySymbol, period, z);
            }
         }
         aHigh[index] = high;
         aLow[index]      = low; 
         aClose[index] = iClose(mySymbol, period, shift); 
         //aBid[index]      = bid;                 
         //aAsk[index]      = ask;        
         //aBid[index]      = MarketInfo(mySymbol,MODE_BID);                 
         //aAsk[index]      = MarketInfo(mySymbol,MODE_ASK);         
         aRange[index]    = MathMax((aHigh[index]-aLow[index])/point,1);      // calculate range today  
         aRatio[index]    = (aClose[index]-aLow[index])/aRange[index]/point;     // calculate pair ratio
         aLookup[index]   = iLookup(aRatio[index]*100);                        // set a pair grade
         aStrength[index] = 9-aLookup[index];                
         }
         aMeter[USD] = NormalizeDouble((aLookup[USDJPY]+aLookup[USDCHF]+aLookup[USDCAD]+aStrength[EURUSD]+aStrength[GBPUSD]+aStrength[AUDUSD]+aStrength[NZDUSD])/7,1);
   aMeter[EUR] = NormalizeDouble((aLookup[EURUSD]+aLookup[EURJPY]+aLookup[EURGBP]+aLookup[EURCHF]+aLookup[EURAUD]+aLookup[EURCAD]+aLookup[EURNZD])/7,1);
   aMeter[GBP] = NormalizeDouble((aLookup[GBPUSD]+aLookup[GBPJPY]+aLookup[GBPCHF]+aStrength[EURGBP]+aLookup[GBPCAD]+aLookup[GBPAUD]+aLookup[GBPNZD])/7,1);
   aMeter[CHF] = NormalizeDouble((aStrength[USDCHF]+aStrength[EURCHF]+aStrength[GBPCHF]+aStrength[AUDCHF]+aLookup[CHFJPY]+aStrength[CADCHF]+aStrength[NZDCHF])/7,1);
   aMeter[CAD] = NormalizeDouble((aStrength[USDCAD]+aLookup[CADCHF]+aStrength[AUDCAD]+aLookup[CADJPY]+aStrength[EURCAD]+aStrength[GBPCAD]+aStrength[NZDCAD])/7,1);
   aMeter[AUD] = NormalizeDouble((aLookup[AUDUSD]+aStrength[EURAUD]+aLookup[AUDCHF]+aLookup[AUDCAD]+aStrength[GBPAUD]+aLookup[AUDNZD]+aLookup[AUDJPY])/7,1);
   aMeter[JPY] = NormalizeDouble((aStrength[USDJPY]+aStrength[EURJPY]+aStrength[GBPJPY]+aStrength[NZDJPY]+aStrength[AUDJPY]+aStrength[CHFJPY]+aStrength[CADJPY])/7,1);     
   aMeter[NZD] = NormalizeDouble((aLookup[NZDUSD]+aStrength[EURNZD]+aStrength[GBPNZD]+aStrength[AUDNZD]+aLookup[NZDCAD]+aLookup[NZDCHF]+aLookup[NZDJPY])/7,1);
   string strength = "\nCurrent Meter: USD: " + aMeter[USD] + ", EUR: " + aMeter[EUR] + "\nGBP: " + aMeter[GBP]
         + ", CHF: " + aMeter[CHF] + "\nCAD: " + aMeter[CAD] + ", AUD: " + aMeter[AUD]
          + "\nJPY: " + aMeter[JPY] + ", NZD: " + aMeter[NZD];
   //infobox = infobox + strength;
   return (strength);
}



double getoneinfo(string mySymbol)
{
   double high, low, bid, ask, point, spread, digits;
      double aHigh;
      double aLow;
      double aHigh1;
      double aBid;
      double aAsk;
      double aRatio;
      double aRange;
      double aLookup;
      double aStrength;
      int z;
         bid = MarketInfo(mySymbol, MODE_BID);
         ask = MarketInfo(mySymbol, MODE_ASK);
         point = MarketInfo(mySymbol, MODE_POINT);
         spread = MarketInfo(mySymbol, MODE_SPREAD);
         digits = MarketInfo(mySymbol, MODE_DIGITS);
         //Calculating the points:
         high = -1;
         low = -1;
         for (z=0; z<4; z++) {
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
         aHigh = high;
         aLow      = low; 
         aBid      = bid;                 
         aAsk      = ask;                 
         aRange    = MathMax((aHigh-aLow)/point,1);      // calculate range today  
         aRatio    = (aBid-aLow)/aRange/point;     // calculate pair ratio
         double aLookup1   = iLookup(aRatio*100);                        // set a pair grade
         double aStrength1 = 9-aLookup1;
         return (aLookup1);
         
}

double openPositionTotal(string symbol)
{

   double gtotal = 0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderSymbol()==symbol) {
         gtotal += OrderProfit();
         //infobox = infobox + "\nSymbol: " + OrderSymbol() + ", Magic Number: " + OrderMagicNumber() + ", Profit: " + OrderProfit();
      }
     }
     //infobox = StringConcatenate(infobox, "Profit for Open Position For Symbol: " + symbol +
   //" is: " + DoubleToStr(gtotal, 2) + "\n");
   return (gtotal);
}
double history2(string symbol)
{
   int cnt;
   int total = OrdersHistoryTotal();
   double gtotal = 0;
   for(cnt=0;cnt<total;cnt++)
   {
      OrderSelect(cnt, SELECT_BY_POS, MODE_HISTORY);
      if (OrderSymbol() == symbol 
         //&& TimeDay(OrderCloseTime()) == Day()
         //&& TimeMonth(OrderCloseTime()) == Month() && TimeYear(OrderCloseTime()) == Year()
      ) {
         gtotal += OrderProfit();
         //Print("Cnt: ", cnt, ", ticket: ", OrderTicket(), ", Order Profit: ", OrderProfit(), ", currency: ", OrderSymbol());
         //Print("close day: ", TimeDay(OrderCloseTime()), ", close month: ", TimeMonth(OrderCloseTime()), ", close year: ", TimeYear(OrderCloseTime())
            //, ", current day: ", Day(), ", current month: ", Month(), ", current year: ", Year()
         //);
      }
   }
   infobox = StringConcatenate(infobox, "\nProfit for Close Positions For Symbol: " + symbol +
   " is: " + DoubleToStr(gtotal, 2) + "\n");
   return (gtotal);
}

double aLookupSingle;
double aStrengthSingle;
int getallinfoSingle(string symbol)
{
   double high, low, bid, ask, point, spread, digits;
      double aHigh;
      double aLow;
      double aBid;
      double aAsk;
      double aRatio;
      double aRange;
      int z;
         
         //infobox = infobox + "\n" + mySymbol;
         bid = MarketInfo(symbol, MODE_BID);
         ask = MarketInfo(symbol, MODE_ASK);
         point = MarketInfo(symbol, MODE_POINT);
         spread = MarketInfo(symbol, MODE_SPREAD);
         digits = MarketInfo(symbol, MODE_DIGITS);
         //Calculating the points:
         high = -1;
         low = -1;
         for (z=0; z<4; z++) {
            //infobox = infobox + "High " + z + ": " + iHigh(symbol, PERIOD_H4, z) + "\n";
            //infobox = infobox + "Low " + z + ": " + iLow(symbol, PERIOD_H4, z) + "\n";
            if (high == -1) {
               high = iHigh(symbol, PERIOD_H4, z);
            }
            if (iHigh(symbol, PERIOD_H4, z) > high) {
               high = iHigh(symbol, PERIOD_H4, z);
            }
            if (low == -1) {
               low = iLow(symbol, PERIOD_H4, z);
            }
            if (iLow(symbol, PERIOD_H4, z) < low) {
               low = iLow(symbol, PERIOD_H4, z);
            }
         }
            //infobox = infobox + "High F " + z + ": " + high + "\n";
            //infobox = infobox + "Low F " + z + ": " + low + "\n";
         aHigh = high;
         aLow      = low; 
         aBid      = bid;                 
         aAsk      = ask;                 
         aRange    = MathMax((aHigh-aLow)/point,1);      // calculate range today  
         aRatio    = (aBid-aLow)/aRange/point;     // calculate pair ratio
         aLookupSingle   = iLookup(aRatio*100);                        // set a pair grade
         aStrengthSingle = 9-aLookupSingle;
         
         //Print("aLookup: ", aLookupSingle);
         //Print("aStrength: ", aStrengthSingle);
         
        
}


void CheckForCloseWithoutProfit(string symbol, int mode, int magicnumber, int typeHere)
  {
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()==magicnumber && OrderSymbol()==symbol) {
         if(OrderType()==OP_BUY && typeHere == -1)
           {
            Alert(symbol, ", closing buy order");
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_BID),3,White);
           }
         if(OrderType()==OP_SELL && typeHere == 1)
           {
            Alert(symbol, ", closing sell order");
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_ASK),3,White);
         
           }
     }
   }
//----
  }

void CloseAllWithoutProfit(string symbol, int typeHere)
  {
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderSymbol()==symbol) {
         if(OrderType()==OP_BUY && typeHere == -1)
           {
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_BID),3,White);
           }
         if(OrderType()==OP_SELL && typeHere == 1)
           {
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_ASK),3,White);
           }
     }
   }
//----
  }  
  
void CloseAllWithProfit(string symbol, int typeHere)
  {
  double profit = 0;
  int i;
   for( i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderSymbol()==symbol) {
        profit = profit + OrderProfit();
     }
   }
   if (profit > 0) {
      for( i=0;i<OrdersTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
         if(OrderSymbol()==symbol) {
            if(OrderType()==OP_BUY && typeHere == -1)
              {
               OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_BID),3,White);
              }
            if(OrderType()==OP_SELL && typeHere == 1)
              {
               OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_ASK),3,White);
              }
        }
      }
   }
//----
  }  
int heiken(string symbol, int period)
{
   double val2 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,1);
   double val3 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,1);
   double val6 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,2);
   double val7 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,2);
         
   if (val2 < val3 && val6 > val7) {
      TimeFrame = TimeframeToString(period);
      return (1);
   } else if (val2 > val3 && val6 < val7) {
      TimeFrame = TimeframeToString(period);
      return (-1);
   }

   return (0);
}

int heikenCurrent(string symbol, int period)
{
   double val2 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,1);
   double val3 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,1);
         
   if (val2 < val3) {
      return (1);
   } else if (val2 > val3) {
      return (-1);
   }

   return (0);
}

int heikenshift(string symbol, int period, int shift)
{
   double val2 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,shift);
   double val3 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,shift);
   double val6 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,shift+1);
   double val7 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,shift+1);
         
   if (val2 < val3 && val6 > val7) {
      TimeFrame = TimeframeToString(period);
      return (1);
   } else if (val2 > val3 && val6 < val7) {
      TimeFrame = TimeframeToString(period);
      return (-1);
   }

   return (0);
}

int heikenCurrentshift(string symbol, int period, int shift)
{
   double val2 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,shift);
   double val3 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,shift);
         
   if (val2 < val3) {
      return (1);
   } else if (val2 > val3) {
      return (-1);
   }

   return (0);
}


int macd(string symbol, int period)
{
   double val2 = iCustom(symbol, period, "MACD_Complete",1,1);
   double val3 = iCustom(symbol, period, "MACD_Complete",2,1);
   double val6 = iCustom(symbol, period, "MACD_Complete",1,2);
   double val7 = iCustom(symbol, period, "MACD_Complete",2,2);
         
   if (val2 > val3 && val6 < val7) {
      TimeFrame = TimeframeToString(period);
      return (1);
   } else if (val2 < val3 && val6 > val7) {
      TimeFrame = TimeframeToString(period);
      return (-1);
   }

   return (0);
}

int macdCurrent(string symbol, int period)
{
   double val2 = iCustom(symbol, period, "MACD_Complete",1,1);
   double val3 = iCustom(symbol, period, "MACD_Complete",2,1);
         
   if (val2 > val3) {
      return (1);
   } else if (val2 < val3) {
      return (-1);
   }

   return (0);
}


int macdR(string symbol, int period)
{
      double MacdCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
      double MacdPrevious=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,2);
      double SignalCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
      double SignalPrevious=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_SIGNAL,2);
         
   if (MacdCurrent > SignalCurrent && MacdPrevious < SignalPrevious) {
      TimeFrame = TimeframeToString(period);
      return (1);
   } else if (MacdCurrent < SignalCurrent && MacdPrevious > SignalPrevious) {
      TimeFrame = TimeframeToString(period);
      return (-1);
   }

   return (0);
}

int macdRCurrent(string symbol, int period)
{
      double MacdCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
      double SignalCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
         
   if (MacdCurrent > SignalCurrent) {
      TimeFrame = TimeframeToString(period);
      return (1);
   } else if (MacdCurrent < SignalCurrent) {
      TimeFrame = TimeframeToString(period);
      return (-1);
   }

   return (0);
}

int macdRshift(string symbol, int period, int shift)
{
      double MacdCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,shift);
      double MacdPrevious=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,shift+1);
      double SignalCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_SIGNAL,shift);
      double SignalPrevious=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_SIGNAL,shift+1);
         
   if (MacdCurrent > SignalCurrent && MacdPrevious < SignalPrevious) {
      TimeFrame = TimeframeToString(period);
      return (1);
   } else if (MacdCurrent < SignalCurrent && MacdPrevious > SignalPrevious) {
      TimeFrame = TimeframeToString(period);
      return (-1);
   }

   return (0);
}

int macdRCurrentshift(string symbol, int period, int shift)
{
      double MacdCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,shift);
      double SignalCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_SIGNAL,shift);
         
   if (MacdCurrent > SignalCurrent) {
      TimeFrame = TimeframeToString(period);
      return (1);
   } else if (MacdCurrent < SignalCurrent) {
      TimeFrame = TimeframeToString(period);
      return (-1);
   }

   return (0);
}


int macdRCurrentZero(string symbol, int period)
{
      double MacdCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
      double SignalCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
         
   if (MacdCurrent > SignalCurrent) {
      TimeFrame = TimeframeToString(period);
      return (1);
   } else if (MacdCurrent < SignalCurrent) {
      TimeFrame = TimeframeToString(period);
      return (-1);
   }

   return (0);
}
double macdDiffernce(string symbol, int period)
{
      double MacdCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
      double SignalCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
      return (MacdCurrent - SignalCurrent);
}


int macdCount(string symbol, int period)
{
   double Macd=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   bool buy = false;
   bool sell = false;
   if (Macd > 0)
      buy = true;
   if (Macd < 0)
      sell = true;
   int cnt = 0;
   for (int i = 1; i <= 200; i++) {
      double MacdCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,i);
      double SignalCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_SIGNAL,i);
      double MacdPrevious=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,i+1);
      double SignalPrevious=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_SIGNAL,i+1);
      if (buy && MacdCurrent > 0) {
      
      } else if (sell && MacdCurrent < 0) {
      
      } else {
         break;
      }
      if (MacdCurrent > SignalCurrent && MacdPrevious < SignalPrevious) {
         cnt++;
      } else if (MacdCurrent < SignalCurrent && MacdPrevious > SignalPrevious) {
         cnt++;
      }
   }
   return (cnt);
}

int tenkan(string symbol, int period, int shift)
{
   double tenkan_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_TENKANSEN, shift);
   double kijun_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, shift);
   double tenkan_sen_2=iIchimoku(symbol, period, 9, 26, 52, MODE_TENKANSEN, shift+1);
   double kijun_sen_2=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, shift+1);
         
   if (tenkan_sen_1 > kijun_sen_1 && tenkan_sen_2 <= kijun_sen_2) {
      TimeFrame = TimeframeToString(period);
      return (1);
   } else if (tenkan_sen_1 < kijun_sen_1 && tenkan_sen_2 >= kijun_sen_2) {
      TimeFrame = TimeframeToString(period);
      return (-1);
   }

   return (0);
}


int kijun(string symbol, int period, int shift)
{
   double kijun_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, shift);
   double kijun_sen_2=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, shift+1);
         
   if (iOpen(symbol, period, shift) > kijun_sen_1 && iClose(symbol, period, shift) > kijun_sen_1
      && (iOpen(symbol, period, shift+1) <= kijun_sen_2 || iClose(symbol, period, shift+1) <= kijun_sen_2)
      ) {
      TimeFrame = TimeframeToString(period);
      return (1);
   } else if (iOpen(symbol, period, shift) < kijun_sen_1 && iClose(symbol, period, shift) < kijun_sen_1
      && (iOpen(symbol, period, shift+1) >= kijun_sen_2 || iClose(symbol, period, shift+1) >= kijun_sen_2)
      ) {
      TimeFrame = TimeframeToString(period);
      return (-1);
   }

   return (0);
}

int spanAB(string symbol, int period, int shift)
{
   double spanA_1 =iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANA, shift-26);
   double spanB_1=iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANB, shift-26);
   double spanA_2 =iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANA, shift-25);
   double spanB_2=iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANB, shift-25);
         
   if (spanA_1 > spanB_1 && spanA_2 <= spanB_2) {
      return (1);
   } else if (spanA_1 < spanB_1 && spanA_2 >= spanB_2) {
      return (-1);
   }

   return (0);
}

int chikou(string symbol, int period, int shift)
{
   double ch1 =iIchimoku(symbol, period, 9, 26, 52, MODE_CHINKOUSPAN, shift+26);
   double ch2 =iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANA, shift+27);
         
   if (ch1 > iOpen(symbol, period, shift+26) && ch1 > iClose(symbol, period, shift+26)
      && (ch1 < iOpen(symbol, period, shift+26) || ch1 < iClose(symbol, period, shift+26))
      ) {
      return (1);
   } else if (ch1 < iOpen(symbol, period, shift+26) && ch1 < iClose(symbol, period, shift+26)
      && (ch1 > iOpen(symbol, period, shift+26) || ch1 > iClose(symbol, period, shift+26))) {
      return (-1);
   }

   return (0);
}
int tenkanCurrent(string symbol, int period, int shift)
{
   double tenkan_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_TENKANSEN, shift);
   double kijun_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, shift);
         
   if (tenkan_sen_1 > kijun_sen_1) {
      return (1);
   } else if (tenkan_sen_1 < kijun_sen_1) {
      return (-1);
   }

   return (0);
}



int stoch(string symbol, int period)
{
   double val2 = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_MAIN,0);
   double val3 = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_SIGNAL,0);
   double val6 = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_MAIN,1);
   double val7 = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_SIGNAL,1);
         
   if (val2 > val3 && val6 < val7 && val3 < 30) {
      TimeFrame = TimeframeToString(period);
      return (1);
   } else if (val2 < val3 && val6 > val7 && val3 > 70) {
      TimeFrame = TimeframeToString(period);
      return (-1);
   }

   return (0);
}

int stochCurrent(string symbol, int period)
{
   double val2 = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_MAIN,0);
   double val3 = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_SIGNAL,0);
         
   if (val2 > val3) {
      return (1);
   } else if (val2 < val3) {
      return (-1);
   }

   return (0);
}


int sar(string symbol, int period)
{
   double val2 = iSAR(symbol,period,0.02,0.2,0);
   double val3 = iSAR(symbol,period,0.02,0.2,1);
         
   if (val2 < iOpen(symbol, period, 0) && val3 > iOpen(symbol, period, 1)) {
      TimeFrame = TimeframeToString(period);
      return (1);
   } else if (val2 > iOpen(symbol, period, 0) && val3 < iOpen(symbol, period, 1)) {
      TimeFrame = TimeframeToString(period);
      return (-1);
   }

   return (0);
}

int lotcalc()
{
   double lotnew;
   lotnew = lots;
   if (lots == 0) {
      lotnew = NormalizeDouble((AccountBalance() / 10000)/4, 2);
      if (lotnew < 0.01) lotnew = 0.01;
      lots = lotnew;
   }
}

int bbreversal(string symbol, int period, int shift)
{
   double bbh = iBands(symbol,period,20,2,0,PRICE_CLOSE,MODE_UPPER,shift);
   double bbl = iBands(symbol,period,20,2,0,PRICE_CLOSE,MODE_LOWER,shift);
   double high1 = iHigh(symbol, period, shift);
   double high2 = iHigh(symbol, period, shift+1);
   double high3 = iHigh(symbol, period, shift+2);
   double low1 = iLow(symbol, period, shift);
   double low2 = iLow(symbol, period, shift+1);
   double low3 = iLow(symbol, period, shift+2);
   
   if (high1 < high2 && high2 > high3) {
      return (-1);
   } else if (low1 > low2 && low2 < low3) {
      return (1);
   }

   return (0);
}

int macd_divergence(string symbol, int period)
{
   double MacdCurrent = iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   infobox = infobox + "  MacdCurrent: " + MacdCurrent + "\n";
      double Macd, Macd2;
      int macdchange = macdR(symbol, period);
      if (MacdCurrent > 0) { //sell position
         // checking high and Low
         int highest = iHighest(symbol,period,MODE_HIGH,50,1);
         double high = iHigh(symbol, period, highest);
         infobox = infobox + "Highest: " + highest + ", High: " + high;
         int highest2 = iHighest(symbol,period,MODE_HIGH,50,highest+5);
         double high2 = iHigh(symbol, period, highest2);
         infobox = infobox + ", highest2: " + highest2 + ", High2: " + high2;
         //macd calculation
         Macd = iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,highest);
         Macd2 = iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,highest2);

         infobox = infobox + ", Macd: " + Macd + ", Macd2: " + Macd2;
         infobox = infobox + "\n";
         if (Macd > 0 && Macd < Macd2 && macdchange == -1) {
            infobox = infobox + "Possible Sell Condition";
            return (-1);
         } 
      } else if (MacdCurrent < 0) { //buy position
         // checking high and Low
         int lowest = iLowest(symbol,period,MODE_LOW,50,1);
         double low = iLow(symbol, period, lowest);
         infobox = infobox + ", Lowest: " + lowest + ", low: " + low;
         int lowest2 = iLowest(symbol,period,MODE_LOW,50,lowest+5);
         double low2 = iLow(symbol, period, lowest2);
         infobox = infobox + ", Lowest2: " + lowest2 + ", low2: " + low2;

   
         //macd calculation
         Macd = iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,lowest);
         Macd2 = iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,lowest2);
         infobox = infobox + ", Macd: " + Macd + ", Macd2: " + Macd2;
         infobox = infobox + "\n";
         if (Macd < 0 && Macd > Macd2 && macdchange == 1) {
            infobox = infobox + "Possible Buy Condition";
            return (1);
         } 
      }
      return (0);
}






int get_per_unit_cost()
{
   for(int cnt=0;cnt<OrdersTotal();cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      infobox = infobox + "\nSymbol: " + OrderSymbol() + ", Loss/Profit: " + OrderProfit()
      + ", Lots: " + OrderLots() * 100 + ", Per unit loss/profit: " + OrderProfit() /(OrderLots() * 100)
      ;
   }

}

double ppf_r3;
double ppf_r2;
double ppf_r1;
double ppf_p;
double ppf_s1;
double ppf_s2;
double ppf_s3;
double ppf_high;
double ppf_low;
double ppf_close;
int pivot_point_fib(double high, double low, double close)
{
   ppf_p = (high + low + close) / 3;
   ppf_r3 = ppf_p + (1.000 * (high - low));
   ppf_r2 = ppf_p + (0.618 * (high - low));
   ppf_r1 = ppf_p + (0.382 * (high - low));
   ppf_s1 = ppf_p - (0.382 * (high - low));
   ppf_s2 = ppf_p - (0.618 * (high - low));
   ppf_s3 = ppf_p - (1.000 * (high - low));
   return (0);
}
int get_ppf(string symbol, int mode, int period)
{
   int highest = iHighest(symbol,period,MODE_HIGH,200,1);
   double high = iHigh(symbol, period, highest);
   ppf_high = high;
   int lowest = iLowest(symbol,period,MODE_LOW,200,1);
   double low = iLow(symbol, period, lowest);
   ppf_low = low;
   double close = iClose(symbol, period, 1);
   ppf_close = close;
   pivot_point_fib(high, low, close);
}

int checkforclose(int period)
{
   for(int cnt=0;cnt<OrdersTotal();cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      
      if (OrderProfit() > 0) { 
         
         int macd2 = macdRCurrent(OrderSymbol(), period);
         int heiken2 = heikenCurrent(OrderSymbol(), period);
         infobox = infobox + "\nSymbol: " + OrderSymbol() + ", Profit: " + OrderProfit()
         + ", macd2: " + macd2 + ", heiken2: " + heiken2;
         if (heiken2 == 1 && macd2 == 1) {
            // close all sell Order
            if(OrderType()==OP_SELL) {
               Alert("Close Sell order for " + OrderSymbol());
               OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(), MODE_ASK),3,White);
            }
         } else if (heiken2 == -1 && macd2 == -1) {
            // close all buy Order
            if(OrderType()==OP_BUY) {
               Alert("Close Buy order for " + OrderSymbol());
               OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(), MODE_BID),3,White);
            }
         }
      } 
   }

}

int create_label(string name, int window, 
datetime time1, double price1, int corner, int x, int y, string text, color colors)
{
   ObjectDelete(name);
   if (ObjectCreate(name, OBJ_LABEL, window, time1, price1)) {
      if (corner > 0)
         ObjectSet(name, OBJPROP_CORNER, corner);
      if (x >= 0)
         ObjectSet(name, OBJPROP_XDISTANCE, x);
      if (y >= 0)
         ObjectSet(name, OBJPROP_YDISTANCE, y);
      ObjectSetText(name, text, 10, "Verdana", colors);
   }
}


void create_arrow(string name, int x, int y, int trend, int corner)
{
   if (ObjectCreate(name, OBJ_LABEL, 0, 0, 0)) {
      ObjectSet(name, OBJPROP_CORNER, corner);
      ObjectSet(name, OBJPROP_XDISTANCE, x);
      ObjectSet(name, OBJPROP_YDISTANCE, y);
      string text = "";
      color color_code;
      if (trend == 1) {
         text = CharToStr(233);
         color_code = Blue;
      } else if (trend == -1) {
         text = CharToStr(234);
         color_code = Red;
      } else {
         text = CharToStr(232);
         color_code = Gold;
      }
      
      ObjectSetText(name, text, 10, "Wingdings", color_code);
   }
}

void create_arrow_custom(string name, int time, double price, int code, color color_code)
{
   if (ObjectCreate(name, OBJ_ARROW, 0, time, price)) {
     ObjectSet(name, OBJPROP_ARROWCODE, code);
     ObjectSet(name, OBJPROP_COLOR, color_code);
   }
}
void TextToPrint(string TextName, string LabelText, int FontSize, string FontName, color TextColor, datetime Time0, double Price0)
  {
    if(StringLen(LabelText)<1) return(0);
    ObjectCreate(TextName, OBJ_TEXT, 0, Time0, Price0);
    ObjectSetText(TextName, LabelText, FontSize, FontName, TextColor);
    
  }

void hline(string name, double price, color TextColor)
{
   ObjectCreate(name, OBJ_HLINE, 0, 0, price);
   ObjectSet(name, OBJPROP_COLOR, TextColor);
}

void vline(string name, int time, color TextColor)
{
   ObjectCreate(name, OBJ_VLINE, 0, time, 0);
   ObjectSet(name, OBJPROP_COLOR, TextColor);
}

void SetTrendlineObject(string name, datetime T1, double P1, datetime T2, double P2, color colour, int LineWidth)
{
   if(ObjectFind(name) == -1)
   {
     ObjectCreate(name, OBJ_TREND, 0, T1, P1, T2, P2);
     ObjectSet(name, OBJPROP_COLOR, colour);
     ObjectSet(name, OBJPROP_BACK, false);
     ObjectSet(name, OBJPROP_WIDTH, LineWidth);  
   }
}

void dellinefollower()
{
   string vname = "vertical";
   string hname = "horizontal";
   string name = "text";
   string current = "current";
   ObjectDelete(current);
   ObjectDelete(vname);
   ObjectDelete(hname);
   ObjectDelete(name);
   string upperName = "trendline";
   ObjectDelete(upperName);
   hname = "hname2";
   vname = "vname2";
   ObjectDelete(hname);
   ObjectDelete(vname);
}

void dellinefollowerAll()
{
   string name;
   for (int i = 0; i < 500; i++) {
      name = "vertical_"+i;
      if(ObjectFind(name) != -1) {
         ObjectDelete(name);
      }
      name = "horizontal_"+i;
      if(ObjectFind(name) != -1) {
         ObjectDelete(name);
      }
      name = "text_"+i;
      if(ObjectFind(name) != -1) {
         ObjectDelete(name);
      }
      name = "current_"+i;
      if(ObjectFind(name) != -1) {
         ObjectDelete(name);
      }
   }
}
int linefollowerAll(int condition, string symbol, int time1, double close1, int time2, double close2, int shift)
{
   string vname = "vertical_"+shift;
   string hname = "horizontal_" + shift;
   string name = "text_"+shift;
   string current = "current_"+shift;
   double pt = MarketInfo(symbol, MODE_POINT);
   int digit = MarketInfo(symbol, MODE_DIGITS);
   double price;
   double pointsEarned = 0;
   int fpips = 0;
   color lcolor;
   if (condition == 1) {
      lcolor = Blue;
      hline(hname, close1, Blue);
      vline(vname, time1, Blue);
      TextToPrint(name, DoubleToStr(price, digit), 12, "Verdana", Yellow, time1, close1);
      price = close1;
      pointsEarned = close2 - price;
      fpips = (pointsEarned / pt);
      TextToPrint(current, DoubleToStr(close2, digit) 
            + "("+(fpips) +")", 12, "Verdana", Yellow, time2, close2);
   } else if (condition == -1) {
      lcolor = Red;
      hline(hname, close1, Red);
      vline(vname, time1, Red);
      price = close1;
      pointsEarned = price - close2;
      fpips = (pointsEarned / pt);
      TextToPrint(name, DoubleToStr(price, digit), 12, "Verdana", Yellow, time1, close1);
      TextToPrint(current, DoubleToStr(close2, digit) 
            + "("+(fpips) +")", 12, "Verdana", Yellow, time2, close2);
   }

   /*
   string upperName = "trendline";
   ObjectDelete(upperName);
   SetTrendlineObject(upperName, time1, close1, time2, close2, lcolor, 2);
   hname = "hname2";
   vname = "vname2";
   ObjectDelete(hname);
   ObjectDelete(vname);
   hline(hname, close2, Yellow);
   vline(vname, time2, Yellow);
   */
   return (fpips);
}
int linefollower(int condition, string symbol, int time1, double close1, int time2, double close2)
{
   string vname = "vertical";
   string hname = "horizontal";
   string name = "text";
   string current = "current";
   ObjectDelete(current);
   ObjectDelete(vname);
   ObjectDelete(hname);
   ObjectDelete(name);
   double pt = MarketInfo(symbol, MODE_POINT);
   int digit = MarketInfo(symbol, MODE_DIGITS);
   double price;
   double pointsEarned = 0;
   int fpips = 0;
   color lcolor;
   if (condition == 1) {
      lcolor = Yellow;
      hline(hname, close1, Blue);
      vline(vname, time1, Blue);
      TextToPrint(name, DoubleToStr(price, digit), 12, "Verdana", Yellow, time1, close1);
      price = close1;
      pointsEarned = close2 - price;
      fpips = (pointsEarned / pt);
      TextToPrint(current, DoubleToStr(close2, digit) 
            + "("+(fpips) +")", 12, "Verdana", Yellow, time2, close2);
   } else if (condition == -1) {
      lcolor = White;
      hline(hname, close1, Red);
      vline(vname, time1, Red);
      price = close1;
      pointsEarned = price - close2;
      fpips = (pointsEarned / pt);
      TextToPrint(name, DoubleToStr(price, digit), 12, "Verdana", Yellow, time1, close1);
      TextToPrint(current, DoubleToStr(close2, digit) 
            + "("+(fpips) +")", 12, "Verdana", Yellow, time2, close2);
   }

   string upperName = "trendline";
   ObjectDelete(upperName);
   SetTrendlineObject(upperName, time1, close1, time2, close2, lcolor, 2);
   hname = "hname2";
   vname = "vname2";
   ObjectDelete(hname);
   ObjectDelete(vname);
   hline(hname, close2, Yellow);
   vline(vname, time2, Yellow);
   return (fpips);
}
 
int getShift(string symbol, int period, datetime sometime)
{
  //datetime some_time=D'2004.03.21 12:00';
  int      shift=iBarShift(symbol, period, sometime);
  //infobox = infobox + StringConcatenate("\nshift of bar with open time ",TimeToStr(sometime)," is ",shift);
  return (shift);
}

int getPoints(string symbol, int type, double price1, double price2)
{
   double pts = MarketInfo(symbol, MODE_POINT);
   double diffprice;
   if (type == 1) {
      diffprice = price2 - price1;
   } else if (type == -1) {
      diffprice = price1 - price2;
   }

   int result = diffprice / pts;
   return (result);
}


double fisher(string symbol, int period, int shift)
{
   double val2 = iCustom(symbol, period, "Fisher_no_repainting", 30, 0, shift);
   return (val2);
}

int fisherDiff(string symbol, int period, int shift)
{
   double val2 = iCustom(symbol, period, "Fisher_no_repainting", 30, 0, shift);
   double val3 = iCustom(symbol, period, "Fisher_no_repainting", 30, 0, shift+1);
   if (val2 > 0 && val3 < 0) {
      return (1);
   } else if (val2 < 0 && val3 > 0) {
      return (-1);
   }

   return (0);
}

int fisherCurrent(string symbol, int period, int shift)
{
   double val2 = iCustom(symbol, period, "Fisher_no_repainting", 30, 0, shift);
   if (val2 > 0) {
      return (1);
   } else if (val2 < 0) {
      return (-1);
   }

   return (0);
}

int bbtrend(string symbol, int period, int shift)
{
   double val3 = iCustom(symbol, period, "Bollinger Bands_Stop_v2 ", 20, 1, 1.0, 1, 1, 1000, false, 4, shift);
   double val4 = iCustom(symbol, period, "Bollinger Bands_Stop_v2 ", 20, 1, 1.0, 1, 1, 1000, false, 5, shift);
   if (val3 == EMPTY_VALUE) return (-1);
   else if (val4 == EMPTY_VALUE) return (1);
   return (0);
}

int maxindicatorBuy = 0;
int maxindicatorSell = 0;
int maxindicator(string symbol, int period, int i)
{
      bool LongEntryCondition;
      bool ShortEntryCondition;
      int buy = 0;
      int sell = 0;
      string text;
      //1
      int macd = macdRCurrentshift(symbol, period, i);
      if(macd == 1) {
         buy++;
      } else if(macd == -1) {
         sell++;
      }
      //2
      double tenkan_sen=iIchimoku(symbol,period, 9, 26, 52, MODE_TENKANSEN, i);
      double kijunsen_sen=iIchimoku(symbol,period, 9, 26, 52, MODE_KIJUNSEN, i);
      if(kijunsen_sen < iClose(symbol, period, i)) {
         buy++;
      } else if(kijunsen_sen > iClose(symbol, period, i)) {
         sell++;
      }
      if (i == 1)
      infobox = infobox + ", I: " + i + ", MACD: " + macd + ", Kijun: " + kijunsen_sen + ", Close: " + 
         iClose(symbol, period, i);
      //3
      /*if (iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_MAIN,i) > 20 && 
         //iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_MAIN,i) < 80 &&
         iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_MAIN,i)>iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_SIGNAL,i)) {
         buy++;
      } else if (iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_MAIN,i) < 80 &&
         //iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_MAIN,i) > 30 &&
         iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_MAIN,i)<iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_SIGNAL,i)) {
         sell++;
      }
      //4
      if(iRSI(symbol,period,9,PRICE_CLOSE,i) > 30) {
         buy++;
      } else if(iRSI(symbol,period,9,PRICE_CLOSE,i) < 70) {
         sell++;
      }*/
      
      LongEntryCondition = (buy == 2);
      ShortEntryCondition = (sell == 2);
      maxindicatorBuy = buy; 
      maxindicatorSell = sell;
      if (LongEntryCondition) { return (1); }
      if (ShortEntryCondition) { return (-1); }
}

int highlowstrategy(string symbol, int period, int i)
{

   int pMT4_STOCH_SIGNAL_1 = 21; 
   int pMT4_STOCH_SIGNAL_2 = 3; 
   int pMT4_STOCH_SIGNAL_3 = 3; 
   int pMT4_STOCH_4 = 5; 
   int pMT4_STOCH_5 = 3; 
   int pMT4_STOCH_6 = 3; 
   int pMT4_STOCH_SIGNAL_7 = 21; 
   int pMT4_STOCH_SIGNAL_8 = 3; 
   int pMT4_STOCH_SIGNAL_9 = 3; 
   int pMT4_STOCH_10 = 5; 
   int pMT4_STOCH_11 = 3; 
   int pMT4_STOCH_12 = 3; 
   // LONG: ((StochSignal(21, 3, 3) Crosses Above Stoch(5, 3, 3)) And ((High(16) < Low(14)) Or (Open(6) > High(11))))
      
   bool LongEntryCondition = ((
      (iStochastic(symbol, period, pMT4_STOCH_SIGNAL_1, pMT4_STOCH_SIGNAL_2, pMT4_STOCH_SIGNAL_3, MODE_SMA, 0, MODE_SIGNAL, i + 1) < iStochastic(symbol, period, pMT4_STOCH_4, pMT4_STOCH_5, pMT4_STOCH_6, MODE_SMA, 0, MODE_MAIN, i + 1)) 
      && (iStochastic(symbol, period, pMT4_STOCH_SIGNAL_1, pMT4_STOCH_SIGNAL_2, pMT4_STOCH_SIGNAL_3, MODE_SMA, 0, MODE_SIGNAL, i) > iStochastic(symbol, period, pMT4_STOCH_4, pMT4_STOCH_5, pMT4_STOCH_6, MODE_SMA, 0, MODE_MAIN, i))) 
      && ((iHigh(symbol, period, i-1+16) < iLow(symbol, period, i-1+14)) 
      || (iOpen(symbol, period, i-1+6) > iHigh(symbol, period, i-1+11))));
      
   // SHORT: ((StochSignal(21, 3, 3) Crosses Below Stoch(5, 3, 3)) And ((Low(16) > High(14)) Or (Open(6) < Low(11))))
   bool ShortEntryCondition = ((
      (iStochastic(symbol, period, pMT4_STOCH_SIGNAL_7, pMT4_STOCH_SIGNAL_8, pMT4_STOCH_SIGNAL_9, MODE_SMA, 0, MODE_SIGNAL, i + 1) > iStochastic(symbol, period, pMT4_STOCH_10, pMT4_STOCH_11, pMT4_STOCH_12, MODE_SMA, 0, MODE_MAIN, i + 1)) 
      && (iStochastic(symbol, period, pMT4_STOCH_SIGNAL_7, pMT4_STOCH_SIGNAL_8, pMT4_STOCH_SIGNAL_9, MODE_SMA, 0, MODE_SIGNAL, i) < iStochastic(symbol, period, pMT4_STOCH_10, pMT4_STOCH_11, pMT4_STOCH_12, MODE_SMA, 0, MODE_MAIN, i))) 
      && ((iLow(symbol, period, i-1+16) > iHigh(symbol, period, i-1+14)) 
      || (iOpen(symbol, period, i-1+6) < iLow(symbol, period, i-1+11))));
   if (LongEntryCondition) return (1);
   if (ShortEntryCondition) return (-1);
}



int stochstrategy1entry(string symbol, int period, int i)
{
   int buy, sell;
   double sm = iStochastic(symbol,period,14,7,7,MODE_SMA,0,MODE_MAIN,i);
   double ss = iStochastic(symbol,period,14,7,7,MODE_SMA,0,MODE_SIGNAL,i);
   if (sm > ss) {
      buy++;
   } else if (sm < ss) {
      sell++;
   }
   bool LongEntryCondition = (buy == 2);
   bool ShortEntryCondition = (sell == 2);
      if (LongEntryCondition) { return (1); }
      if (ShortEntryCondition) { return (-1); } 
}

double historyall(int magicnum)
{
   int cnt;
   int total = OrdersHistoryTotal();
   double gtotal = 0;
   for(cnt=0;cnt<total;cnt++)
   {
      OrderSelect(cnt, SELECT_BY_POS, MODE_HISTORY);
      if (OrderMagicNumber()==magicnum) {
         gtotal = gtotal + OrderProfit();
      }
   }
   //historybox = historybox + "\nTotal Profit/Loss For Symbol: " + symbol + " and magic: " + magicnum +
   //" is: " + DoubleToStr(gtotal, 2);
   return (gtotal);
}

int historyProfitCnt(int magicnum, string symbol)
{
   int cnt, count;
   int total = OrdersHistoryTotal();
   double gtotal = 0;
   for(cnt=0;cnt<total;cnt++)
   {
      OrderSelect(cnt, SELECT_BY_POS, MODE_HISTORY);
      if (OrderMagicNumber()==magicnum && OrderSymbol() == symbol) {
         if (OrderProfit() >= 0) {
            count++;
         } else if (OrderProfit() < 0) {
            count--;
         }
      }
   }
   return (count);
}


int historyProfit(int magicnum, string symbol)
{
   int cnt, count;
   int total = OrdersHistoryTotal();
   double gtotal = 0;
   for(cnt=0;cnt<total;cnt++)
   {
      OrderSelect(cnt, SELECT_BY_POS, MODE_HISTORY);
      if (OrderMagicNumber()==magicnum && OrderSymbol() == symbol) {
         gtotal = gtotal + OrderProfit();
      }
   }
   return (gtotal);
}


int buysellstrategy(string symbol, int period, int i)
{
   int    T3Period  = 14;
   int    T3Price   = PRICE_CLOSE;
   double b         = 0.618;
   int Snake_HalfCycle=5; // Snake_HalfCycle = 4...10 or other
   int DeltaForSell = 0;
   int DeltaForBuy = 0;
      double pwma5 = iCustom(symbol,period,"Snake",Snake_HalfCycle,0,i+1);
      double cwma5 = iCustom(symbol,period,"Snake",Snake_HalfCycle,0,i);
      
      double pwma50 = iCustom(symbol,period,"T3_clean",T3Period,T3Price,b,0,i+1);
      double cwma50 = iCustom(symbol,period,"T3_clean",T3Period,T3Price,b,0,i);
      if( cwma5 > (cwma50 +(DeltaForBuy*MarketInfo(symbol, MODE_POINT))) && pwma5 <= pwma50)
      {
         //buy
         return (1);
      } else if( pwma5 >= pwma50 && cwma5 < (cwma50 - (DeltaForSell*MarketInfo(symbol, MODE_POINT))))
      {
         //sell
         return (-1);
      }
      return (0);
}



double avgbody(string symbol, int period, int shift)
{
   double sum=0;
   int aver_period = 5;
   for(int i=shift; i<=aver_period; i++) {
      double open = iOpen(symbol, period, i);
      double close = iClose(symbol, period, i);
      sum = sum + MathAbs(open-close);
   }
   sum=sum/aver_period;
   return (sum);
}

double midpointHighLow(string symbol, int period, int shift)
{
   double high = iHigh(symbol, period, shift);
   double low = iLow(symbol, period, shift);
   double midpoint = (high + low) / 2;
   return (midpoint);
}
double midpointOpenClose(string symbol, int period, int shift)
{
   double open = iOpen(symbol, period, shift);
   double close = iClose(symbol, period, shift);
   double midpoint = (open + close) / 2;
   return (midpoint);
}
bool three_black_crows(string symbol, int period, int shift)
{
   double AvgBody = avgbody(symbol, period, shift);
   if((iOpen(symbol, period, shift+2)-iClose(symbol, period, shift+2)>AvgBody) && // (long black)
      (iOpen(symbol, period, shift+1)-iClose(symbol, period, shift+1)>AvgBody) &&
      (iOpen(symbol, period, shift)-iClose(symbol, period, shift)>AvgBody) && 
      (midpointHighLow(symbol, period, shift+1)<midpointHighLow(symbol, period, shift+2))     && // (lower midpoints)
      (midpointHighLow(symbol, period, shift)<midpointHighLow(symbol, period, shift+1)))       
      return(true);

   return (false);
}

bool evening_star(string symbol, int period, int shift)
{
   double AvgBody = avgbody(symbol, period, shift);
   if((iClose(symbol, period, shift+2)-iOpen(symbol, period, shift+2)>AvgBody)             && // bullish candle with body higher than average body 
      (MathAbs(iClose(symbol, period, shift+1)-iOpen(symbol, period, shift+1))<AvgBody*0.5) && // second candle has a small body (less than half of the average)
      (iClose(symbol, period, shift+1)>iClose(symbol, period, shift+2))                       && // close of the second candle is higher than close of the first
      (iOpen(symbol, period, shift+1)>iOpen(symbol, period, shift+2))                         && // open of the second candle is higher than open of the first
      (iClose(symbol, period, shift)<midpointOpenClose(symbol, period, shift+2)))                  // close of the last completed candle is lower than center of the first 
      return(true);
//---
   return(false);
}

bool evening_doji(string symbol, int period, int shift)
{
   double AvgBody1 = avgbody(symbol, period, shift);
   double AvgBody2 = avgbody(symbol, period, shift+1);
   if((iClose(symbol, period, shift+2)-iOpen(symbol, period, shift+2)>AvgBody1) && // bullish candle with body higher than average 
      (AvgBody2<AvgBody1*0.1)   && // second candle has a very small body (doji) 
      (iClose(symbol, period, shift+1)>iClose(symbol, period, shift+2))           && // close of the second candle is higher than close of the first
      (iOpen(symbol, period, shift+1)>iOpen(symbol, period, shift+2))             && // opend of the second candle is higher than open of the first
      (iOpen(symbol, period, shift)<iClose(symbol, period, shift+1))            && // down gap at the last completed candle
      (iClose(symbol, period, shift)<iClose(symbol, period, shift+1)))             // close of the last completed candle is lower than close of the second 
      return(true);
//---
   return(false);
}

bool bearish_meeting_lines(string symbol, int period, int shift)
{
   double AvgBody1 = avgbody(symbol, period, shift);
//--- Bearish Meeting Lines
   if((iClose(symbol, period, shift+1)-iOpen(symbol, period, shift+1)>AvgBody1)             && // long white
     ((iOpen(symbol, period, shift)-iClose(symbol, period, shift))>AvgBody1)            && // long black
      (MathAbs(iClose(symbol, period, shift)-iClose(symbol, period, shift+1))<0.1*AvgBody1))  // doji close
      return(true);
//---
   return(false);
}

//PRICE ACTION
/*
avg body
//--- Calculate the average body size of previous candlesticks
   double sum=0;
   for(int i=1; i<=aver_period; i++)
      sum=sum+MathAbs(rt[i].open-rt[i].close);
   sum=sum/aver_period;
   
   
   http://www.mql5.com/en/articles/101
http://www.mql5.com/en/code/experts/page8
http://www.mql5.com/en/code/313
1.1. Morning Star

This pattern indicates the reversal of downtrend, it consists of three candles (Fig. 1). After a long black candle there is a candle (the color isn't important) with a small body, which lies outside the body of the black candle. The small body of a candle means that strengths of the bulls and bears are equal and market is ready to change the trend.

The third candle of the pattern is the bullish candle, it's body isn't overlapped with the body of the second candle, and close price lies inside the body of the first (bearish) candle. The resulting candle of the model is also plotted at Figure 1.

For the case if the second candle is doji-like-candle, the model is named "Morning Doji Star".

1.2. Evening Star

This pattern indicates the reversal of uptrend, it consists of three candles (Fig. 2). After a long white candles there is a candle (the color isn't important) with a small body, which lies outside the body of the white candle. The small body of a candle means that strengths of the bulls and bears are equal and market is ready to change the trend.

The third candle of the pattern is the bearish candle, it's body isn't overlapped with the body of the second candle, and close price lies inside the body of the first (bullish) candle. The resulting candle of the model is also plotted at Figure 2.

For the case if the second candle is doji-like-candle, the model is named "Evening Doji Star".

//+------------------------------------------------------------------+
//| Check formation of the "Evening Star" pattern                    |
//+------------------------------------------------------------------+
bool CCandlePattern::CheckPatternEveningStar()
  {
//--- Evening Star
   if((Close(3)-Open(3)>AvgBody(1))             && // bullish candle with body higher than average body 
      (MathAbs(Close(2)-Open(2))<AvgBody(1)*0.5) && // second candle has a small body (less than half of the average)
      (Close(2)>Close(3))                       && // close of the second candle is higher than close of the first
      (Open(2)>Open(3))                         && // open of the second candle is higher than open of the first
      (Close(1)<MidOpenClose(3)))                  // close of the last completed candle is lower than center of the first 
      return(true);
//---
   return(false);
  }

//+------------------------------------------------------------------+
//| Check formation of the "Evening Doji Star" pattern               |
//+------------------------------------------------------------------+
bool CCandlePattern::CheckPatternEveningDoji()
  {
//--- Evening Doji Star
   if((Close(3)-Open(3)>AvgBody(1)) && // bullish candle with body higher than average 
      (AvgBody(2)<AvgBody(1)*0.1)   && // second candle has a very small body (doji) 
      (Close(2)>Close(3))           && // close of the second candle is higher than close of the first
      (Open(2)>Open(3))             && // opend of the second candle is higher than open of the first
      (Open(1)<Close(2))            && // down gap at the last completed candle
      (Close(1)<Close(2)))             // close of the last completed candle is lower than close of the second 
      return(true);
//---
   return(false);
  }

//+------------------------------------------------------------------+
//| Check formation of the "Morning Star" pattern                    |
//+------------------------------------------------------------------+
bool CCandlePattern::CheckPatternMorningStar()
  {
//--- Morning Star
   if((Open(3)-Close(3)>AvgBody(1))             && // bearish candle, its body greater than average candle body
      (MathAbs(Close(2)-Open(2))<AvgBody(1)*0.5) && // second candle has small body (lower than half of the average body)
      (Close(2)<Close(3))                       && // close of the second candle is lower than close of the first 
      (Open(2)<Open(3))                         && // open of the second canlde is lower than open of the first
      (Close(1)>MidOpenClose(3)))                  // close of the last completed candle is higher than center of the first 
      return(true);
//---
   return(false);
  }
//+------------------------------------------------------------------+
//| Check formation of the "Morning Doji Star" pattern               |
//+------------------------------------------------------------------+
bool CCandlePattern::CheckPatternMorningDoji()
  {
//--- Morning Doji Star
   if((Open(3)-Close(3)>AvgBody(1)) && // bearish candle with body greater than average candle body 
      (AvgBody(2)<AvgBody(1)*0.1)   && // the second candle has a very small body (doji) 
      (Close(2)<Close(3))           && // close of the second candle is lower than close of the first 
      (Open(2)<Open(3))             && // open of the second candle is lower than open of the first
      (Open(1)>Close(2))            && // up gap at the last completed candle
      (Close(1)>Close(2)))             // close of the last completed candle is higher than close of the second
      return(true);
//---
   return(false);
  }
  
  
1.1. Bullish Meeting Lines

The pattern consist of two candlesticks (bearish and bullish) with equal (or very close) close prices. The body of two candlesticks must be greater than average body length.

The "Bullish Meeting Lines" pattern indicates the reversal of a downward trend.
//+--------------------------------------------------------------------+
//| Checks formation of "Bullish Meeting Lines" candlestick pattern    |            
//+--------------------------------------------------------------------+
bool CCandlePattern::CheckPatternBullishMeetingLines()
  {
//--- Bullish Meeting Lines
   if((Open(2)-Close(2)>AvgBody(1))              && // long black
     ((Close(1)-Open(1))>AvgBody(1))             && // long white
      (MathAbs(Close(1)-Close(2))<0.1*AvgBody(1)))   // doji close
      return(true);
//---
   return(false);
  }


//+--------------------------------------------------------------------+
//| Checks formation of "Bearish Meeting Lines" candlestick pattern    |
//+--------------------------------------------------------------------+
bool CCandlePattern::CheckPatternBearishMeetingLines()
  {
//--- Bearish Meeting Lines
   if((Close(2)-Open(2)>AvgBody(1))             && // long white
     ((Open(1)-Close(1))>AvgBody(1))            && // long black
      (MathAbs(Close(1)-Close(2))<0.1*AvgBody(1)))  // doji close
      return(true);
//---
   return(false);
  }

1. "Hammer" and "Hanging Man" reversal candlestick patterns


1.1. Hammer

The "Hammer" is a candlestick with a small body and long lower wick, formed after downward price movement. The "Hammer" pattern indicates the end of a bearish trend.

The color of a candlestick body isn't important, but bullish hammer indicates higher bullish potential. The body of the "Hammer" pattern often formed near the mininum of the previous candle. The longer lower wick and shorter upper wick leads to higher potential of the reversal pattern.


//+------------------------------------------------------------------+
//| Checks formation of "Hammer" candlestick pattern                 |
//+------------------------------------------------------------------+
bool CCandlePattern::CheckPatternHammer()
  {
//--- Hammer
   if((MidPoint(1)<CloseAvg(2))                                 && // down trend
      (MathMin(Open(1),Close(1))>(High(1)-(High(1)-Low(1))/3.0)) && // body in upper 1/3
      (Close(1)<Close(2)) && (Open(1)<Open(2)))                    // body gap
      return(true);
//---
   return(false);
  }
  

1.2. Hanging Man

The "Hanging Man" is a candlestick with a small body and long lower wick, formed after upward price movement. The "Hanging Man" pattern indicates the end of a bullish trend.

The color of a candlestick body isn't important, but bearish candle indicates higher bearish potential. The body of the "Hanging Man" pattern often formed near the maxinum of the previous candle. The longer lower wick and shorter upper wick leads to higher potential of the reversal pattern.



//+------------------------------------------------------------------+
//| Checks formation of "Hanging Man" candlestick pattern            |
//+------------------------------------------------------------------+
bool CCandlePattern::CheckPatternHangingMan()
  {
//--- Hanging man
   if((MidPoint(1)>CloseAvg(2))                                && // up trend
      (MathMin(Open(1),Close(1)>(High(1)-(High(1)-Low(1))/3.0)) && // body in upper 1/3
      (Close(1)>Close(2)) && (Open(1)>Open(2))))                  // body gap
      return(true);
//---
   return(false);
  }


1. "Bullish Harami and "Bearish Harami" reversal candlestick patterns
1.1. Bullish Harami

The Bullish Harami reversal pattern forms in downward trend when large candlestick is followed by a smaller candlestick whose body is located within the vertical range of the larger body. This pattern indicates that the falling trend (downtrend) may be reversing, it signals that it's a good time to enter into a long position. The second candlestick is opened with a gap up.

The smaller the second (white) candlestick, the more likely the reversal.
//+------------------------------------------------------------------+
//| Checks formation of "Bullish Harami" candlestick pattern         |
//+------------------------------------------------------------------+
bool CCandlePattern::CheckPatternBullishHarami()
  {
//--- Bullish Harami
   if((Close(1)>Open(1))              && // the last completed bar is bullish (white day)
     ((Open(2)-Close(2))>AvgBody(1))  && // the previous candle is bearish, its body is greater than average (long black)
     ((Close(1)<Open(2))              && // close price of the bullish candle is lower than open price of the bearish candle 
      (Open(1)>Close(2)))             && // open price of the bullish candle is higher than close price of the bearish candle
      (MidPoint(2)<CloseAvg(2)))         // down trend
      return(true);
//---
   return(false);
  }
1.2. Bearish Harami

The Bearish Harami reversal pattern forms in upward trend when large candlestick is followed by a smaller candlestick whose body is located within the vertical range of the larger body. This pattern indicates that the rising trend (uptrend) may be reversing, it signals that it's a good time to enter into a short position. The second candlestick is opened with a gap down.

The smaller the second (black) candlestick, the more likely the reversal.

//+------------------------------------------------------------------+
//| Checks formation of "Bearish Harami" candlestick pattern         |
//+------------------------------------------------------------------+
bool CCandlePattern::CheckPatternBearishHarami()
  {
//--- Bearish Harami
   if((Close(1)<Open(1))              && // last completed bar is bearish (black day)
     ((Close(2)-Open(2))>AvgBody(1))  && // the previous candle is bullish, its body is greater than average (long white)
     ((Close(1)>Open(2))              && // close price of the bearish candle is higher than open price of the bullish candle 
      (Open(1)<Close(2)))             && // open price of the bearish candle is lower than close price of the bullish candle
      (MidPoint(2)>CloseAvg(2)))         // up trend
      return(true);
//---
   return(false);
  }

1. "Bullish Engulfing" and "Bearish Engulfing"
1.1. Bullish Engulfing

"Bullish Engulfing" reversal pattern forms in downtrend when a small black candlestick if followed by a large white candlestick that completely eclipses ("engulfs") the candlestick of the previous day. The shadows (tails) of the small candlestick are short, which enables the body of the large candlestick to cover the entire candlestick from the previous day.

//+------------------------------------------------------------------+
//| Checks formation of "Bullish Engulfing" candlestick pattern      |
//+------------------------------------------------------------------+
bool CCandlePattern::CheckPatternBullishEngulfing()
  {
//--- Bullish Engulfing
   if((Open(2)>Close(2))             &&  // previous candle is bearish
      (Close(1)-Open(1)>AvgBody(1))  &&  // body of the bullish candle is higher than average value of the body 
      (Close(1)>Open(2))             &&  // close price of the bullish candle is higher than open price of the bearish candle
      (MidOpenClose(2)<CloseAvg(2))  &&  // downtrend
      (Open(1)<Close(2)))                // open price of the bullish candle is lower than close price of the bearish
      return(true);
//---
   return(false);
  }
  

1.2. Bearish Engulfing

"Bearish Engulfing" reversal pattern forms in uptrend when a small white candlestick if followed by a large black candlestick that completely eclipses ("engulfs") the candlestick of the previous day. The shadows (tails) of the small candlestick are short, which enables the body of the large candlestick to cover the entire candlestick from the previous day.

//+------------------------------------------------------------------+
//| Checks formation of "Bearish Engulfing" candlestick pattern      |
//+------------------------------------------------------------------+
bool CCandlePattern::CheckPatternBearishEngulfing()
  {
//--- Bearish Engulfing
   if((Open(2)<Close(2))            &&  // previous candle is bearish
      (Open(1)-Close(1)>AvgBody(1)) &&  // body of the candle is higher than average value of the body
      (Close(1)<Open(2))            &&  // close price of the bearish candle is lower than open price of the bullish candle
      (MidOpenClose(2)>CloseAvg(2)) &&  // uptrend
      (Open(1)>Close(2)))               // Open price of the bearish candle is higher than close price of the bullish candle
      return(true);
//---
   return(false);
  }
  
  
http://www.mql5.com/en/code/300
1. "Dark Cloud Cover" and "Piercing Line" reversal candlestick patterns
1.1. Dark Cloud Cover

It's a bearish candlestick reversal that occurs at the end of uptrend. A long white candlestick is formed on the first day and a gap up is created on the second day. However, the second day closes below the midpoint of the first day.

//+------------------------------------------------------------------+
//| Checks formation of "Dark Cloud Cover" candlestick pattern       |
//+------------------------------------------------------------------+
bool CCandlePattern::CheckPatternDarkCloudCover()
  {
//--- Dark Cloud Cover 
   if((Close(2)-Open(2)>AvgBody(1))  && // (long white)
      (Close(1)<Close(2))            && // 
      (Close(1)>Open(2))             && // (close within previous body)
      (MidOpenClose(2)>CloseAvg(1))  && // (uptrend)
      (Open(1)>High(2)))                // (open at new high)
      return(true);
//---
   return(false);
  }
1.2. Piercing Line

The gap down on the second day perpetuates the downtrend. However, the second day's close is above the midpoint of the first day's body. This suggests to the bears that a bottom could be forming. This price action is not nearly as discernable using bar charts as it is with candlestick charts. The more penetration of the close on the second day to the first day's body, the more probable the reversal signal will succeed.

//+------------------------------------------------------------------+
//| Checks formation of "Piercing Line" candlestick pattern          |
//+------------------------------------------------------------------+
bool CCandlePattern::CheckPatternPiercingLine()
  {
//--- Piercing Line
   if((Close(1)-Open(1)>AvgBody(1)) && // (long white)
      (Open(2)-Close(2)>AvgBody(1)) && // (long black)
      (Close(1)>Close(2))           && //  
      (Close(1)<Open(2))            && // (close inside previous body) 
      (MidOpenClose(2)<CloseAvg(2)) && // (downtrend)
      (Open(1)<Low(2)))                // (open lower than previous Low) 
      return(true);
//---
   return(false);
  }
  
  
  http://www.mql5.com/en/code/288
1. "3 Black Crows" and 3 "White Soldiers" reversal candlestick patterns
1.1. 3 Black Crows

A bearish candlestick pattern that is used to predict the reversal of the current uptrend. This pattern consists of three consecutive long-bodied candlesticks that have closed lower than the previous day with each session's open occurring within the body of the previous candle.

//+------------------------------------------------------------------+
//| Checks formation of "3 Black Crows" candlestick pattern          |
//+------------------------------------------------------------------+
bool CCandlePattern::CheckPatternThreeBlackCrows()
  {
//--- 3 Black Crows 
   if((Open(3)-Close(3)>AvgBody(1)) && // (long black)
      (Open(2)-Close(2)>AvgBody(1)) &&
      (Open(1)-Close(1)>AvgBody(1)) && 
      (MidPoint(2)<MidPoint(3))     && // (lower midpoints)
      (MidPoint(1)<MidPoint(2)))       
      return(true);
//---
   return(false);
  }
1.2. 3 White Soldiers candlestick pattern

A bullish candlestick pattern that is used to predict the reversal of the current downtrend. This pattern consists of three consecutive long-bodied candlesticks that have closed higher than the previous day, with each session's open occurring within the body of the previous candle. 

The pattern is valid as long as the candle of day two opens in the upper half of day one's range. By the end of day two, it should close near its high, leaving a very small or non-existent upper shadow. The same pattern is then repeated on day three.

//+------------------------------------------------------------------+
//| Checks formation of "3 White Soldiers" candlestick pattern       |
//+------------------------------------------------------------------+
bool CCandlePattern::CheckPatternThreeWhiteSoldiers()
  {
   //--- 3 White Soldiers
   if((Close(3)-Open(3)>AvgBody(1)) && // long white
      (Close(2)-Open(2)>AvgBody(1)) &&
      (Close(1)-Open(1)>AvgBody(1)) &&
      (MidPoint(2)>MidPoint(3))     && // higher midpoints
      (MidPoint(1)>MidPoint(2)))
      return(true);
//---
   return(false);
  }


*/


int calculatePoints(string symbol, int period, int from, int to)
{
   int gtotal = 0;
   int lastChange;
   int lastChangeType;
   double lastChangeClose;
   int fpips = 0;
   for(int i = from; i >= to; i--) {
      int spanAB = spanAB(symbol, period, i);
      if (spanAB == 1) {
         if (lastChange > 0) {
            if (lastChangeType == -1) {
               fpips = (lastChangeClose - iClose(symbol, period, i)) / MarketInfo(symbol, MODE_POINT);
               gtotal = gtotal + fpips;
            }
         }
         lastChange = i;
         lastChangeClose = iClose(symbol, period, i);
         lastChangeType = 1;
      } else if (spanAB == -1) {
         if (lastChange > 0) {
            if (lastChangeType == 1) {
               fpips = (iClose(symbol, period, i) - lastChangeClose) / MarketInfo(symbol, MODE_POINT);
               gtotal = gtotal + fpips;
            }
         }
         lastChange = i;
         lastChangeClose = iClose(symbol, period, i);
         lastChangeType = -1;
      }
   }
   return (gtotal);
}


