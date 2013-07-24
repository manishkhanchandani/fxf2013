//+------------------------------------------------------------------+
//|                                               customIchimoku.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <stdlib.mqh>
#include <WinUser32.mqh>
extern int magic = 129;
extern double initialAmount = 1000;
extern int percPerDay = 3;
extern int maximum_no_orders = 1;
extern int stop = 0;
double todaysPlan;

extern bool trailing = true;
extern int trailingstop = 150;
extern int mintrailingstop = 500;

bool closeonchangewithoutprofit = false;

bool logs = true;
int trend[28];
int trend2[28];
int opentime;
string infobox;
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



int difference[ARRSIZE];
double stoploss[ARRSIZE];


int typeoforder[ARRSIZE];
double totalcost[ARRSIZE];
int totalorders[ARRSIZE];
double lotsavg[ARRSIZE];
double averagecostingprice[ARRSIZE];
double totalprofit[ARRSIZE];
double returncost[ARRSIZE];
double lotsizeorder[ARRSIZE];

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
   //if (opentime != iTime(Symbol(), Period(), 0)){
   //todaysPlan=B4 + (B4 * (3/100))
   //buy logic
   infobox = "";
   int condition_open = 0;
   int condition_close = 0;
   double history = history(magic);
   infobox = infobox + "\nMagic: " + magic + ", Close without profit: " + closeonchangewithoutprofit 
      + ", History: " + history 
      + "\ntrailing: " + trailing + ", trailingstop: " + trailingstop + ", mintrailingstop: " + trailingstop;
   if (initialAmount == 0) initialAmount = AccountBalance();
   double total = initialAmount + history;
   if (total <= 0) {
      Comment("EA not working correctly.");
      return (0);
   }
   double aim = (total * percPerDay/100);
   double lots = ((total / 100) * 0.5) / 100;
   if (lots < 0.01) lots = 0.01;
   lots = NormalizeDouble(lots, 2);
   infobox = infobox + ", Total: " + total + ", Lots: " + DoubleToStr(lots, 2) 
      + ", Aim: " + DoubleToStr(aim, 2);
   
   int x; string symbol;
   //for (int m = 0; m < 5; m++) {
      int newmagic = magic;
      int newperiod = Period();
      for (x = 0; x < ARRSIZE; x++) {
         symbol = aPair[x];
         closeonchangewithoutprofit = true;
         bool buy = true;
         bool sell = true;
         condition_open = 0;
         condition_close = 0;
         string message = newmagic;
         condition_open = condition_open(symbol, newperiod, 1, x);
         condition_close = condition_close(symbol, newperiod, 1, x);
         infobox = infobox + ", buy: " + buy + ", sell: " + sell;
         
         if (condition_close == 1) {
            closelogic(symbol, newmagic, 1);
         }
         else if (condition_close == -1) {
            closelogic(symbol, newmagic, -1);
         }

         if (condition_open == 1) {
            if (closeonchangewithoutprofit) closelogicwithoutprofit(symbol, newmagic, 1);
            if (buy) create_order(symbol, 1, lots, newmagic, message, stop, 0);
         }
         else if (condition_open == -1) {
            if (closeonchangewithoutprofit) closelogicwithoutprofit(symbol, newmagic, -1);
            if (sell) create_order(symbol, -1, lots, newmagic, message, stop, 0);
         }
      }
   //}
   Comment(infobox);
   //opentime = iTime(Symbol(), Period(), 0);
   //}
//----
   return(0);
  }
//+------------------------------------------------------------------+

/*

   int val2 = iCustom(symbol, period, "cuCobraClose", 2, shift);
   if (val2 == 1) return (1);
   else if (val2 == -1) return (-1);
*/
int condition_open(string symbol, int period, int shift, int mode)
{
   int check = i_check(symbol, period, shift, mode);
   
   infobox = infobox + "\nSymbol: " + symbol + ", check: " + check;
   if (check == 1) {
      return (1);
   } else if (check == -1) {
      return (-1);
   }
   return (0);
}

int condition_close(string symbol, int period, int shift, int mode)
{
   int check = i_check(symbol, period, shift, mode);
   if (check == 1) {
      return (1);
   } else if (check == -1) {
      return (-1);
   }
   return (0);
}


int i_check(string symbol, int period, int shift, int mode)
{
   int val2 = tenkan(symbol, period, shift);
   if (val2 == 1) return (1);
   else if (val2 == -1) return (-1);

   return (0);
}


int tenkan(string symbol, int period, int shift)
{
   double tenkan_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_TENKANSEN, shift);
   double kijun_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, shift);
   double tenkan_sen_2=iIchimoku(symbol, period, 9, 26, 52, MODE_TENKANSEN, shift+1);
   double kijun_sen_2=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, shift+1);
         
   if (tenkan_sen_1 > kijun_sen_1 && tenkan_sen_2 <= kijun_sen_2) {
      return (1);
   } else if (tenkan_sen_1 < kijun_sen_1 && tenkan_sen_2 >= kijun_sen_2) {
      return (-1);
   }

   return (0);
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
   if (orders >= maximum_no_orders)
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
         create_order(symbol, type, Lots, magicnumber, message, stoploss, takeprofit);
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
         create_order(symbol, type, Lots, magicnumber, message, stoploss, takeprofit);
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
  

int get_average_costing(string symbol, int mode, int magicnumber)
{
   int cnt;
   double openprice;
   double lotsize;
   int x = 0;
   lotsavg[mode] = 0.0;
   totalcost[mode] = 0.0;
   typeoforder[mode] = 0;
   totalorders[mode] = 0;
   totalprofit[mode] = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol()==symbol
         && OrderMagicNumber() == magicnumber
      ) {
            averagecostingprice[mode] = OrderOpenPrice();
            lotsizeorder[mode] = OrderLots();

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
  //if (totalorders[mode] > 0)
      //infobox = infobox + StringConcatenate("\n", symbol, ", lotsavg[mode]: ", DoubleToStr(lotsavg[mode], 2), ", totalcost[mode]: ", totalcost[mode], ", typeoforder: ", typeoforder[mode], ", totalprofit[mode]: ", totalprofit[mode], ", returncost[mode]: ", returncost[mode]);
   
}


int closingonprofit(string symbol, int mode)
{
   if (totalorders[mode] == 0) {
      stoploss[mode] = 0;
      return (0);
   }

   int cnt;
   
      double ask = MarketInfo(symbol, MODE_ASK);
      double bid = MarketInfo(symbol, MODE_BID);
      double spread = MarketInfo(symbol, MODE_SPREAD);
      double point = MarketInfo(symbol, MODE_POINT);
      double digit = MarketInfo(symbol, MODE_DIGITS);
      
   
   int checkpoint = mintrailingstop;
   if(typeoforder[mode] == 1 && (bid-returncost[mode]) > point*checkpoint)
   {
      if(stoploss[mode] < (bid - point*trailingstop)) {
         stoploss[mode] = bid - point*trailingstop;
         change_stop_loss(symbol, stoploss[mode]);
      }
   } else if (typeoforder[mode] == -1 && (returncost[mode]-ask)>(point*checkpoint)) {
      if((stoploss[mode] > (ask + point*trailingstop)) || (stoploss[mode]==0)) {
         stoploss[mode] = ask + point*trailingstop;
         change_stop_loss(symbol, stoploss[mode]);
      }
   }   
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


int closelogic(string symbol, int magicnumber, int typeHere)
{
   int i;
   /*
   double totalProfit;
   for(i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==symbol && OrderMagicNumber()==magicnumber) {
         totalProfit = totalProfit + OrderProfit();
      }
   }
   if (totalProfit < 0) return (0);*/
   
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