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
extern double initialAmount = 0;
extern int percPerDay = 3;
double todaysPlan;
extern double fixedLots = 0;
extern double fixedLots2 = 0.01;
extern double fixedLots3 = 0.01;
extern bool forced = false;
extern bool currentSymbol = true;

#define ARRSIZE  31
#define PAIRSIZE 10

int trailingstop = 250;
int mintrailingstop = 500;
int mintrailingstopavgcosting = 500;

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
extern bool custom_hours = true;
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
   //if (opentime != iTime(Symbol(), Period(), 0)){
   //todaysPlan=B4 + (B4 * (3/100))
   //buy logic
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
   double history = history(magic);
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
         if (currentSymbol && symbol != Symbol()) {
            continue;
         } else if (current_currency2 != "JPY") continue;
         int digit = MarketInfo(symbol, MODE_DIGITS);
         infobox = infobox + "\nSymbol: " + symbol + ", Digits: " + digit + ", Period: " + newperiod
          + ", Spread: " + DoubleToStr(MarketInfo(symbol, MODE_SPREAD), 0) + ", newlots: " + newlots;
         condition_open = 0;
         condition_close = 0;
         string message = magic;
         infobox = infobox + ", buy: " + buy + ", sell: " + sell;
         string strat = "env";
         if (strat == "heiken") {
            render_trailing_stop(symbol, x);
            condition_open = condition_open(symbol, x);

            if (close[x] == 1) {
               closelogicwithoutprofit(symbol, magic, 1);
            }
            else if (close[x] == -1) {
               closelogicwithoutprofit(symbol, magic, -1);
            }

            if (open[x] == 1) {
               if (buy && trading_hours) create_order(symbol, 1, newlots, magic, message, 500, 0);
            }
            else if (open[x] == -1) {
               if (sell && trading_hours) create_order(symbol, -1, newlots, magic, message, 500, 0);
            }
         } else if (strat == "env") {
            condition_open = condition_open_env(symbol, x);

            if (condition_open == 1) {
               if (buy && trading_hours) create_order(symbol, 1, newlots, magic, message, 0, 300);
            }
            else if (condition_open == -1) {
               if (sell && trading_hours) create_order(symbol, -1, newlots, magic, message, 0, 300);
            }
         
         } else if (strat == "stoch") {
            condition_open = condition_open_stoch(symbol, x);

            if (close[x] == 1) {
               closelogicwithoutprofit(symbol, magic, 1);
            }
            else if (close[x] == -1) {
               closelogicwithoutprofit(symbol, magic, -1);
            }

            if (open[x] == 1) {
               if (buy && trading_hours) create_order(symbol, 1, newlots, magic, message, 500, 0);
            }
            else if (open[x] == -1) {
               if (sell && trading_hours) create_order(symbol, -1, newlots, magic, message, 500, 0);
            }
         }
      }
   //}
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
   //}//end if
//----
   return(0);
  }
//+------------------------------------------------------------------+

int condition_open(string symbol, int mode)
{
   int check = 0;
   int check1 = 0;
   int check5 = 0;
   int check15 = 0;
   int check30 = 0;
   int check60 = 0;
   int strategy = 7;
   open[mode] = 0;
   close[mode] = 0;
   infobox = infobox + ", Strategy: " + strategy;
   check1 = get_strategy_result(strategy, symbol, PERIOD_M1, 0, 1);
   check5 = get_strategy_result(strategy, symbol, PERIOD_M5, 0, 1);
   check15 = get_strategy_result(strategy, symbol, PERIOD_M15, 0, 1);
   check30 = get_strategy_result(strategy, symbol, PERIOD_M30, 0, 1);
   check60 = get_strategy_result(strategy, symbol, PERIOD_H1, 0, 1);
   double enu = iEnvelopes(symbol,PERIOD_H1, 14, MODE_SMA, 0, PRICE_CLOSE, 0.5, MODE_UPPER, 0);
   double enl = iEnvelopes(symbol,PERIOD_H1, 14, MODE_SMA, 0, PRICE_CLOSE, 0.5, MODE_LOWER, 0);
   infobox = infobox + ", buyC: " + (MarketInfo(symbol, MODE_BID) < enu) + ", sellC: " + (MarketInfo(symbol, MODE_BID) > enl);
   if (check1 == 1 && check5 == 1 && check15 == 1 && check30 == 1 && check60 == 1) {
      close[mode] = 1;
      if (MarketInfo(symbol, MODE_BID) < enu) {
         check = 1;
         open[mode] = 1;
      }
   } else if (check1 == -1 && check5 == -1 && check15 == -1 && check30 == -1 && check60 == -1) {
      close[mode] = -1;
      if (MarketInfo(symbol, MODE_BID) > enl) {
         check = -1;
         open[mode] = -1;
      }
   }
   infobox = infobox + ", RESULT: " + check + "("+check1+","+check5+","+check15+","+check30+","+check60+")";
   return (check);
}


int condition_open_env(string symbol, int mode)
{
   int check = 0;
   int check1 = 0;
   double enu = iEnvelopes(symbol,PERIOD_H1, 14, MODE_SMA, 0, PRICE_CLOSE, 0.5, MODE_UPPER, 0);
   double enl = iEnvelopes(symbol,PERIOD_H1, 14, MODE_SMA, 0, PRICE_CLOSE, 0.5, MODE_LOWER, 0);
   double enu2 = iEnvelopes(symbol,PERIOD_H1, 14, MODE_SMA, 0, PRICE_CLOSE, 0.2, MODE_UPPER, 0);
   double enl2 = iEnvelopes(symbol,PERIOD_H1, 14, MODE_SMA, 0, PRICE_CLOSE, 0.2, MODE_LOWER, 0);
   if (MarketInfo(symbol, MODE_BID) > enu) {
      startProcess[mode][0] = 1; //sell chances
   }
   if (MarketInfo(symbol, MODE_BID) < enl) {
      startProcess[mode][1] = 1; // buy chances
   } 
   if (MarketInfo(symbol, MODE_BID) < enu2) {
      startProcess[mode][0] = 0; //sell changes complete
   }
   if (MarketInfo(symbol, MODE_BID) > enl2) {
      startProcess[mode][1] = 0; //buy chances complete
   } 
   check1 = get_strategy_result(7, symbol, PERIOD_M5, 0, 1);
   if (startProcess[mode][0] == 1) {
      //sell
      if (check1 == -1) {
         check = -1;
      }
   } else if (startProcess[mode][1] == 1) {
      //buy
      if (check1 == 1) {
         check = 1;
      }
   }
   infobox = infobox + ", RESULT: " + check + " (" + check1 + "), Sell Chances: " + startProcess[mode][0] +
      " Buy Chances: " + startProcess[mode][1];
   return (check);
}

int condition_open_stoch(string symbol, int mode)
{
   //stoch_process
   int check = 0;
   int check60 = 0;
   int strategy = 7;
   open[mode] = 0;
   close[mode] = 0;
   infobox = infobox + ", Strategy: " + strategy;
   check60 = get_strategy_result(strategy, symbol, PERIOD_H1, 0, 1);
   double stoch = iStochastic(symbol,PERIOD_H1,14,3,3,MODE_SMA,0,MODE_MAIN,1);
   if (stoch < 20) {
      stoch_process[mode] = 1;
   } else if (stoch > 80) {
      stoch_process[mode] = -1;
   }
   infobox = infobox + ", stoch_process[mode]: " + stoch_process[mode] + ", stoch: " + stoch;
   if (check60 == 1) {
      if (stoch_process[mode] == 1) {
         check = 1;
         open[mode] = 1;
         close[mode] = 1;
      }
   } else if (check60 == -1) {
      if (stoch_process[mode] == -1) {
         close[mode] = -1;
         check = -1;
         open[mode] = -1;
      }
   }
   infobox = infobox + ", RESULT: " + check + "("+check60+")";
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


string trailingstop(int magicnumber)
{
   int InitialTrailingStop = 300;
   int TrailingStop = 150;
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


int render_trailing_stop(string symbol, int i)
{
   get_average_costing(symbol, i);
   if (totalorders[i] == 0) {
      stoploss[i] = 0;
      return (0);
   }
   closingonprofit(symbol, i);
   return (0);
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
      
   infobox = infobox + "\nTotal Profit: " + totalprofit[mode] + 
   ", totalorders: " + totalorders[mode];
   
   //new addition, if does not work then we can commit this.
   infobox = infobox + "\nAverage Cost: " + returncost[mode] + 
   ", trailingstop: " + trailingstop + ", mintrailingstop: " + mintrailingstop + 
   ", mintrailingstopavgcosting: " + mintrailingstopavgcosting + ", averagecostingprice: " + averagecostingprice[mode];
   
   int checkpoint = mintrailingstop;
   if (totalorders[mode] > 1) {
      checkpoint = mintrailingstopavgcosting;
   }
   infobox = infobox + "\nstoploss: " + stoploss[mode] + ", checkpoint: " + checkpoint +
      ", (bid-returncost[mode])(buy): " + (bid-returncost[mode]) + ", returncost[mode]-ask(sell): " + (returncost[mode]-ask) +
      ", (point*checkpoint): " + (point*checkpoint) 
   ;
   if(typeoforder[mode] == 1 && (bid-returncost[mode]) > point*checkpoint)
   {
      if(stoploss[mode] < (bid - point*trailingstop)) {
         stoploss[mode] = bid - point*trailingstop;
         infobox = infobox + "\nstoploss: " + stoploss[mode];
         change_stop_loss(symbol, stoploss[mode]);
      }
   } else if (typeoforder[mode] == -1 && (returncost[mode]-ask)>(point*checkpoint)) {
      if((stoploss[mode] > (ask + point*trailingstop)) || (stoploss[mode]==0)) {
         stoploss[mode] = ask + point*trailingstop;
         infobox = infobox + "\nstoploss: " + stoploss[mode];
         change_stop_loss(symbol, stoploss[mode]);
      }
   }
   infobox = infobox + "\n----------------------------------";   
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

int get_average_costing(string symbol, int mode)
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
   double tmp = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol()==symbol
         && (OrderMagicNumber() == magic)
      ) {
         //Print(symbol, ", ", OrderMagicNumber());
         if (tmp == 0) {
            averagecostingprice[mode] = OrderOpenPrice();
            tmp = 1;
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
}


