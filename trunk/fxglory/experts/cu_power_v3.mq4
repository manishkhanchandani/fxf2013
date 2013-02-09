//+------------------------------------------------------------------+
//|                                                  cu_power_v3.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <stdlib.mqh>
#include <WinUser32.mqh>

extern int forcetype = 0; //1 for buy, 2 for sell, 0 for buy or sell
extern double Lots = 0.10;
extern int custom_differnce = 0;
extern int maxspread = 70;
extern double pending_margin = 0;
extern int sleeptime = 1000;
extern string build = "5.2";
extern double top = 5.9;
extern double bottom = 3.1;
extern bool create_new_orders = true;
extern bool create_avg_orders = true;
extern int gmt_offset = 3;
extern bool close_on_reverse_condition = false;
extern bool close_on_trailing = true;
extern int force_create_order = 0;
int hour;
int tickcount;
string build_logic;

extern int trailingstop = 150;
extern int mintrailingstop = 400;
extern int mintrailingstopavgcosting = 401;
double stoploss = 0;

extern int direction = 0;
string infobox, initbox, createbox;
extern int magic = 1230;
extern int magic1 = 1231;
extern int magic2 = 1232;
extern int magic3 = 1233;
extern int magic4 = 1234;
double returncost;
double totalcost;
double lotsavg;
int type;
double totalprofit;
int difference;
double averagecostingprice;
int totalorders;
int opentime;
//point for each currency started
#define ARRSIZE  28
#define USD 0
#define EUR 1
#define GBP 2
#define CHF 3                                                                                      
#define CAD 4                                                                                      
#define AUD 5                                                                                      
#define JPY 6                                                                                      
#define NZD 7

#define PAIRSIZE 8

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
string aPair[ARRSIZE]   = {
                        "USDCHF","GBPUSD","EURUSD","USDJPY","USDCAD","AUDUSD",
                        "EURGBP","EURAUD","EURCHF","EURJPY","GBPCHF","CADJPY",
                        "GBPJPY","AUDNZD","AUDCAD","AUDCHF","AUDJPY","CHFJPY",
                        "EURNZD","EURCAD","CADCHF","NZDJPY","NZDUSD","GBPCAD",
                        "GBPNZD","GBPAUD","NZDCHF","NZDCAD"
                        };
string aMajor[PAIRSIZE] = {"USD","EUR","GBP","CHF","CAD","AUD","JPY","NZD"};
double aMeter[PAIRSIZE];
//point for each currency ended

int meter_direction;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   tickcount = 0;
   initbox = "\n";
   initbox = initbox + "Lots: " + Lots + ", Custom_differnce: " + custom_differnce + ", Build: " + build +
   ",close_on_reverse_condition: " + close_on_reverse_condition + ", close_on_trailing: " + close_on_trailing
   + "\nforcetype: " + forcetype + ", create_new_orders: " + create_new_orders
   + ", create_avg_orders: " + create_avg_orders
   + ", magic: " + magic + ", " + magic1 + ", " + magic2 + ", " + magic3
   + ", " + magic4;
   Comment(initbox);
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
   infobox = "\n";
   hour = Hour() - gmt_offset;
   if (hour < 0) {
      hour = hour + 24;
   }
   string symbol = Symbol();
   double diff1, diff2, diff3, diff4, diff5, diff;
   double point = MarketInfo(symbol, MODE_POINT);
   double digit = MarketInfo(symbol, MODE_DIGITS);
   //custom differnce if 0
   if (custom_differnce == 0) {
      diff1 = iHigh(symbol, PERIOD_D1, 1) - iLow(symbol, PERIOD_D1, 1);
      diff2 = iHigh(symbol, PERIOD_D1, 2) - iLow(symbol, PERIOD_D1, 2);
      diff3 = iHigh(symbol, PERIOD_D1, 3) - iLow(symbol, PERIOD_D1, 3);
      diff4 = iHigh(symbol, PERIOD_D1, 4) - iLow(symbol, PERIOD_D1, 4);
      diff5 = iHigh(symbol, PERIOD_D1, 5) - iLow(symbol, PERIOD_D1, 5);
      diff = (diff1 + diff2 + diff3 + diff4 + diff5) / 5;
      difference = diff / point;
      infobox = infobox + "\nDiff: " + diff + ", custom_differnce: " + difference + 
      ", Hour: " + Hour() + ", hour new: " + hour + ", Minute: " + Minute() + ", Day: " + Day();
   } else {
      difference = custom_differnce;
   }
   get_average_costing(symbol);
   closingonprofit(symbol);
   create_average_costing(symbol);
  
     infobox = StringConcatenate(infobox, "\n");
     infobox = StringConcatenate(infobox, "Type: ", type);
     infobox = StringConcatenate(infobox, ", Current Average: ", DoubleToStr(returncost, digit));
     infobox = StringConcatenate(infobox, ", ");
     infobox = StringConcatenate(infobox, "Totalcost: ", totalcost);
     infobox = StringConcatenate(infobox, ", ");
     infobox = StringConcatenate(infobox, "Lots: ", lotsavg, ", Time: ", TimeToStr(TimeCurrent()), ", Spread: ", MarketInfo(symbol, MODE_SPREAD));
     infobox = StringConcatenate(infobox, "\n");
   
   getallinfo(symbol);
   
   //getpoints(symbol, PERIOD_M1);
   //getpoints(symbol, PERIOD_M5);
   //getpoints(symbol, PERIOD_M15);
   //getpoints(symbol, PERIOD_M30);
   getpoints(symbol, PERIOD_H1);
   //getpoints(symbol, PERIOD_H4);
   //getpoints(symbol, PERIOD_D1);
   
   //if (totalorders == 0) {
   //if (opentime != Time[0]) {
      tickcount = tickcount + 1;
      string current_currency1 = StringSubstr(symbol, 0, 3);
      string current_currency2 = StringSubstr(symbol, 3, 3);
      infobox = infobox + "\nChecking Conditions: current_currency1: " + current_currency1 + ", current_currency2: " + current_currency2 + ", tickcount: " + tickcount;
      bool condition_buy, condition_sell;
      int check;
         //initial condition
         if (force_create_order == 1) {
            createorder(symbol, PERIOD_H1, 1, TimeframeToString(PERIOD_H1) + " Level 0 Force", magic, 0);
         } else if (force_create_order == -1) {
            createorder(symbol, PERIOD_H1, -1, TimeframeToString(PERIOD_H1) + " Level 0 Force", magic, 0);
         }
         check = lookupcurrency(symbol);
      
         if (check == 1 && close_on_reverse_condition) {
            reverse_bid_positive(1, symbol);
         } else if (check == -1 && close_on_reverse_condition) {
            reverse_bid_positive(-1, symbol);
         }
         if (check == 1 && create_new_orders && (forcetype == 0 || forcetype == 1)) {
            createorder(symbol, PERIOD_H1, 1, TimeframeToString(PERIOD_H1) + " Level 0", magic, 0);
         } else if (check == -1 && create_new_orders && (forcetype == 0 || forcetype == 2)) {
            createorder(symbol, PERIOD_H1, -1, TimeframeToString(PERIOD_H1) + " Level 0", magic, 0);
         }
      opentime = Time[0];
      Comment(initbox + infobox);
   //}
   //}
//----
   return(0);
  }
//+------------------------------------------------------------------+

int reverse_bid_positive(int type, string symbol)
{
   for(int cnt=0;cnt<OrdersTotal();cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol() == symbol && OrderMagicNumber()==magic
       && totalprofit > 0
       ) {
         if(OrderType()==OP_BUY) {
            if (type == -1) {
               Alert("Closing buy order", OrderSymbol(), PERIOD_H1);
               closeallorders(symbol);
            }
         } else if (OrderType()==OP_SELL) {
            if (type == 1) {
               Alert("Closing sell order", OrderSymbol(), PERIOD_H1);
               closeallorders(symbol);
            }         
         }
      }
   }
}
int create_average_costing(string symbol)
{
   double bid, ask, point;
   bid = MarketInfo(symbol, MODE_BID);
   ask = MarketInfo(symbol, MODE_ASK);
   point = MarketInfo(symbol, MODE_POINT);
   int diff;
   if (totalprofit < 0) {
      diff = MathAbs(bid - averagecostingprice) / point;
      infobox = infobox + "\nTotal Profit: " + totalprofit + 
         " - Total Average: " + averagecostingprice + " - Current Diff: " + diff + 
         " - Custom Diff: " + difference + " - Type: " + type;
   
      if (diff > (difference * 1) && diff < (difference * 2) && create_avg_orders) {
         infobox = infobox + " - D1:" + (difference * 1);
         createorder(symbol, PERIOD_M15, type, TimeframeToString(PERIOD_M15) + " Level 1", magic1, 1);
      } 
      if (diff > (difference * 2) && diff < (difference * 3) && create_avg_orders) {
         infobox = infobox + " - D2:" + (difference * 2);
         createorder(symbol, PERIOD_M15, type, TimeframeToString(PERIOD_M15) + " Level 2", magic2, 1);
      } 
      if (diff > (difference * 3) && diff < (difference * 4) && create_avg_orders) {
         infobox = infobox + " - D3:" + (difference * 3);
         createorder(symbol, PERIOD_M15, type, TimeframeToString(PERIOD_M15) + " Level 3", magic3, 1);
      } 
      if (diff > (difference * 4) && create_avg_orders) {
         infobox = infobox + " - D4:" + (difference * 4);
         createorder(symbol, PERIOD_M15, type, TimeframeToString(PERIOD_M15) + " Level 4", magic4, 1);
      }
      //Print(symbol, " - ", totalprofit, " - ", returncost, " - ", diff, " - ", difference, " - ", type);
   }
}

int get_average_costing(string symbol)
{
   int cnt;
   double openprice;
   double lotsize;
   lotsavg = 0.0;
   totalcost = 0.0;
   type = 0;
   int x = 0;
   totalorders = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol()==symbol
         && (OrderMagicNumber() == magic || OrderMagicNumber() == magic1 || OrderMagicNumber() == magic2 || OrderMagicNumber() == magic3 || OrderMagicNumber() == magic4)
      ) {
         if (OrderMagicNumber() == magic) {
            averagecostingprice = OrderOpenPrice();
         }
         x++;
         totalorders++;
         openprice = OrderOpenPrice();
         lotsize = OrderLots();
         lotsavg = lotsavg + lotsize;
         totalcost = totalcost + (lotsize * openprice);
         if(OrderType()==OP_BUY) {
            type = 1;            
         } else if(OrderType()==OP_SELL) {
            type = -1;            
         }
      }
   }
   
   if (x == 0) {
      // no previous orders
   } else {
     double cost = 0.0;
     cost = totalcost / lotsavg;
     returncost = cost;
  }
}

int closingonprofit(string symbol)
{
   int cnt;
   totalprofit = 0;
   for(cnt=0;cnt<OrdersTotal();cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol()==symbol
         && (OrderMagicNumber() == magic || OrderMagicNumber() == magic1 || OrderMagicNumber() == magic2 || OrderMagicNumber() == magic3 || OrderMagicNumber() == magic4)
      ) {
         totalprofit += OrderProfit();
      }
   }
   
   infobox = infobox + "\nTotal Profit: " + totalprofit + 
   ", totalorders: " + totalorders;
   
   if (!close_on_trailing) {
      return (0);
   }

   //new addition, if does not work then we can commit this.
   infobox = infobox + "\nAverage Cost: " + returncost + 
   ", trailingstop: " + trailingstop + ", mintrailingstop: " + mintrailingstop + 
   ", mintrailingstopavgcosting: " + mintrailingstopavgcosting;
   double bid, ask, point;
   bid = MarketInfo(symbol, MODE_BID);
   ask = MarketInfo(symbol, MODE_ASK);
   point = MarketInfo(symbol, MODE_POINT);
   
   int checkpoint = mintrailingstop;
   if (totalorders > 1) {
      checkpoint = mintrailingstopavgcosting;
   }
   infobox = infobox + "\nstoploss: " + stoploss + ", checkpoint: " + checkpoint;
   if(type == 1 && (bid-returncost) > point*checkpoint)
   {
      if(stoploss < (bid - point*trailingstop)) {
         stoploss = bid - point*trailingstop;
         infobox = infobox + "\nstoploss: " + stoploss;
         change_stop_loss(symbol, stoploss);
      }
   } else if (type == -1 && (returncost-ask)>(point*checkpoint)) {
      if((stoploss > (ask + point*trailingstop)) || (stoploss==0)) {
         stoploss = ask + point*trailingstop;
         infobox = infobox + "\nstoploss: " + stoploss;
         change_stop_loss(symbol, stoploss);
      }
   }
}

int closeallorders(string symbol)
{
      for(int cnt=0;cnt<OrdersTotal();cnt++) {
         OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if(OrderType()<=OP_SELL && OrderSymbol()==symbol
            && (OrderMagicNumber() == magic || OrderMagicNumber() == magic1 || OrderMagicNumber() == magic2 || OrderMagicNumber() == magic3 || OrderMagicNumber() == magic4)
      
         ) {
            if(OrderType()==OP_BUY) {
               OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_BID),3,White);
               Sleep(sleeptime);
            } else if(OrderType()==OP_SELL) {
               OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_ASK),3,White);
               Sleep(sleeptime);
            }
         }
      }
}

int change_stop_loss(string symbol, double sl)
{
      for(int cnt=0;cnt<OrdersTotal();cnt++) {
         OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if(OrderType()<=OP_SELL && OrderSymbol()==symbol
            && (OrderMagicNumber() == magic || OrderMagicNumber() == magic1 || OrderMagicNumber() == magic2 || OrderMagicNumber() == magic3 || OrderMagicNumber() == magic4)
      
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
int createorder(string symbol, int timeperiod, int type, string message, int magicnumber, int ignorespread)
{
   createbox = "\n" + symbol;
   if (IsTradeAllowed()==false) {
      createbox = createbox + " TRADING NOW ALLOWED";
      return (0);
   }
  
   if (MarketInfo(symbol, MODE_SPREAD) > maxspread && ignorespread == 0) {
      return (0);
   }
   int orders;
   int ordertype;
   double price;
   double val3;
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
      createbox = createbox + " orders: " + orders + " NO TRADING";
      //Print("order already created for symbol: ", symbol);
       return (0);
   }
   

   double bids, asks, pt, digit;
   bids = MarketInfo(symbol, MODE_BID);
   asks = MarketInfo(symbol, MODE_ASK);
   pt = MarketInfo(symbol, MODE_POINT);
   digit = MarketInfo(symbol, MODE_DIGITS);
   bids = NormalizeDouble(bids, digit);
   asks = NormalizeDouble(asks, digit);
   int ticket;
   double tp, sl;
   tp = 0;
   sl = 0;
   if (type == 1) {
      ticket=OrderSend(symbol,OP_BUY,Lots,asks,3,0,0,message+", Power 3 "+build,magicnumber,0,Green);
      if(ticket>0)
         {
         if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
            stoploss = 0;
          }
         }
      else {
         Print(symbol, ", Error opening BUY order : ",ErrorDescription(GetLastError()), ", asks: ", asks);
         Sleep(sleeptime);
         createorder(symbol, timeperiod, type, message, magicnumber, ignorespread);
      }
      Sleep(sleeptime);
      return(0); 
   } else if (type == -1) {
       ticket=OrderSend(symbol,OP_SELL,Lots,bids,3,0,0,message+", Power 3 "+build,magicnumber,0,Red);
        if(ticket>0)
           {
         if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
            stoploss = 0;
          }
           
           }
           else {
               Print(symbol, " Error opening Sell order : ",ErrorDescription(GetLastError()), ", price: ", bids);       
               Sleep(sleeptime);
               createorder(symbol, timeperiod, type, message, magicnumber, ignorespread);
            } 
      
         Sleep(sleeptime);
         return(0); 
   }
}


int CalculateCurrentOrders(string symbol, int magicnumber)//, int ordertype
  {
   int cnt=0;
   int i;
//----
  for(i=0;i<OrdersTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
         if(OrderSymbol()==symbol && OrderMagicNumber()==magicnumber)// && ordertype == OrderType()
           {
            cnt++;
           }
        }
   return (cnt);
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


int lookupcurrency(string symbol)
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
      double range_top[100];
      double range_bottom[100];
      double range_top2[100];
      double range_bottom2[100];
      double high, low;
      bool condition_top, condition_bottom;
         int g;
         int h=0;
         int k=0;
         int l=0;
         int long = 0;
         int short = 0;
         int first = 0;
         for (g=0; g<240; g++) {
            //checking range
            high = iHigh(symbol, PERIOD_H1, g);
            low = iLow(symbol, PERIOD_H1, g);

            //checking semafor
            ZZ_1=iCustom(symbol,PERIOD_H1,"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,5,g);
            ZZ_2=iCustom(symbol,PERIOD_H1,"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,4,g);
            condition_top = ZZ_1 > ZZ_2;
            condition_bottom = ZZ_1 < ZZ_2;
            if (condition_top) {
               if (first == 0) {
                  first = 1;
               } else {
                  range_top[h] = ZZ_1;
                  h++;
                  l++;
               }
            } else if (condition_bottom) {
               if (first == 0) {
                  first = 1;
               } else {
                  range_bottom[k] = ZZ_2;
                  k++;
                  l++;
               }
            }
         }
         infobox = infobox + "\n\nCALCULATION:\nTop Range: ";
         for (g=0; g<h; g++){
               infobox = infobox + range_top[g];
               if (
                  MarketInfo(symbol, MODE_BID) < (range_top[g] + (100 * MarketInfo(symbol, MODE_POINT)))
                  &&
                  MarketInfo(symbol, MODE_BID) > (range_top[g] - (100 * MarketInfo(symbol, MODE_POINT)))
               ) {
                  infobox = infobox + " (Position Near Top " + DoubleToStr(((MarketInfo(symbol, MODE_BID) - range_top[g]) /  MarketInfo(symbol, MODE_POINT)), 0) + ")";
               }
               infobox = infobox + ", ";
               if (MarketInfo(symbol, MODE_BID) > (range_top[g] - (100 * MarketInfo(symbol, MODE_POINT)))) {
                  short = 1;//already at top, go for short
               }
         }
         infobox = infobox + "\nBottom Range: ";
         for (g=0; g<k; g++){
               infobox = infobox + range_bottom[g];
               if (
                  MarketInfo(symbol, MODE_BID) < (range_bottom[g] + (100 * MarketInfo(symbol, MODE_POINT)))
                  &&
                  MarketInfo(symbol, MODE_BID) > (range_bottom[g] - (100 * MarketInfo(symbol, MODE_POINT)))
               ) {
                  infobox = infobox + " (Position Near Bottom " + DoubleToStr(((MarketInfo(symbol, MODE_BID) - range_bottom[g]) /  MarketInfo(symbol, MODE_POINT)), 0) + ")";
               }
               infobox = infobox + ", ";
               if (MarketInfo(symbol, MODE_BID) < (range_bottom[g] + (100 * MarketInfo(symbol, MODE_POINT)))) {
                  long = 1;//already at bottom, go for long
               }
         }
         if (long == 1) {
            direction = 1;
         } else if (short == 1) {
            direction = -1;
         }
         infobox = infobox + "\nGo For Short: " + short + ", Go for Long: " + long + ", Direction: " + direction + " (direction is not taken into account currently)";
         double vh11, vh12, vh13, vh14;
         double vm301, vm302, vm303, vm304;
         double vm151, vm152, vm153, vm154;
         double vm51, vm52, vm53, vm54;
         double vm11, vm12, vm13, vm14;
         vh11 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,0);
         vh12 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,0);
         vh13 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,1);
         vh14 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,1);
         vm301 = iCustom(symbol, PERIOD_M30, "Heiken_Ashi_Smoothed",2,0);
         vm302 = iCustom(symbol, PERIOD_M30, "Heiken_Ashi_Smoothed",3,0);
         vm303 = iCustom(symbol, PERIOD_M30, "Heiken_Ashi_Smoothed",2,1);
         vm304 = iCustom(symbol, PERIOD_M30, "Heiken_Ashi_Smoothed",3,1);
         vm151 = iCustom(symbol, PERIOD_M15, "Heiken_Ashi_Smoothed",2,0);
         vm152 = iCustom(symbol, PERIOD_M15, "Heiken_Ashi_Smoothed",3,0);
         vm153 = iCustom(symbol, PERIOD_M15, "Heiken_Ashi_Smoothed",2,1);
         vm154 = iCustom(symbol, PERIOD_M15, "Heiken_Ashi_Smoothed",3,1);
         vm51 = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",2,0);
         vm52 = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",3,0);
         vm53 = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",2,1);
         vm54 = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",3,1);
         vm11 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",2,0);
         vm12 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",3,0);
         vm13 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",2,1);
         vm14 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",3,1);
         bool condition_buy, condition_sell;
         condition_buy = (
                     (
                        (vh11 < vh12 && vh13 > vh14)
                        ||
                        (vm301 < vm302 && vm303 > vm304)
                        ||
                        (vm151 < vm152 && vm153 > vm154)
                     ) &&
                     (
                        vh11 < vh12
                        &&
                        vm301 < vm302
                        &&
                        vm151 < vm152
                        &&
                        vm51 < vm52
                        &&
                        vm11 < vm12
                     )
                     );
         condition_sell = (
                     (
                        (vh11 > vh12 && vh13 < vh14)
                        ||
                        (vm301 > vm302 && vm303 < vm304)
                        ||
                        (vm151 > vm152 && vm153 < vm154)
                     ) &&
                     (
                        vh11 > vh12
                        &&
                        vm301 > vm302
                        &&
                        vm151 > vm152
                        &&
                        vm51 > vm52
                        &&
                        vm11 > vm12
                     )
                     );
         infobox = infobox + "\nCondition  buy: " + condition_buy + ", Condition Sell: " + condition_sell;
         infobox = infobox + "\n";
         infobox = infobox + "Heiken";
         build_logic = "";
         build_logic = build_logic + "H";
         if (condition_buy) {
            //Alert(symbol, " Buy", TimeToStr(TimeCurrent()));
            infobox = infobox + ": H1: Buy";
            build_logic = build_logic + ":1";
         } else if (condition_sell) {
            //Alert(symbol, " Sell ", TimeToStr(TimeCurrent()));
            infobox = infobox + ": H1: Sell";
            build_logic = build_logic + ":2";
         } else {
            build_logic = build_logic + ":0";
         }
         infobox = infobox + "\nmeter_direction: " + meter_direction + ", direction: " + direction + ", " + build_logic;
         if (condition_buy)  {
            return (1);
         } else if (condition_sell) {
            return (-1);
         }
         return (0);
}


int getallinfo(string symbol)
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
            //infobox = infobox + aPair[index] + ": " + DoubleToStr(((iHigh(aPair[index], PERIOD_D1, 0) - iLow(aPair[index], PERIOD_D1, 0)) / MarketInfo(aPair[index], MODE_POINT)), 0) + ", ";
            //if (index % 7 == 0 && index > 0) infobox = infobox + "\n";
            
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
   string current_currency1 = StringSubstr(symbol, 0, 3);
   string current_currency2 = StringSubstr(symbol, 3, 3);
   //meter_direction
   infobox = infobox + "\nCurrency 1: " + current_currency1 + ", Currency 2: " + current_currency2;
   int m1 = 0;
   int m2 = 0;
   for (int x=0; x < PAIRSIZE; x++) {
      if (current_currency1 == aMajor[x] && aMeter[x] > top) {
         m1 = 1;
      } else if (current_currency1 == aMajor[x] && aMeter[x] < bottom) {
         m1 = -1;
      } else if (current_currency2 == aMajor[x] && aMeter[x] > top) {
         m2 = 1;
      } else if (current_currency2 == aMajor[x] && aMeter[x] < bottom) {
         m2 = -1;
      }
   }
   infobox = infobox + "\nm1: " + m1 + ", m2: " + m2;
   meter_direction = 0;
   if (m1 == 1 && m2 == -1) { // buy
      meter_direction = 1;
   } else if (m1 == -1 && m2 == 1) { //sell
      meter_direction = -1;
   }
   infobox = infobox + "\nmeter_direction: " + meter_direction;
}

int iLookup(double ratio)                                                   // this function will return a grade value
  {                                                                         // based on its power.
   int    aTable[10]  = {0,3,10,25,40,50,60,75,90,97};                 // grade table for currency's power
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

double getpoints(string symbol, int period)
{
   double val, val2, val3, val4, val5, val6;
      string tmp;
      int pinbar, engulf;
      double h1,h2,h3,h4;
      double totalpoints = 0;
      bool detail = true;
      double increment = 0.1;
   infobox = infobox + "\nTimeFrame: " + TimeframeToString(period);
   double points = 0;
         totalpoints = 0;
         //heiken
         h1 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,1);
         h2 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,1);
         h3 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,2);
         h4 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,2);
         totalpoints = totalpoints + increment;
         if (h1 < h2) {
            points = points + increment;
            if (detail) infobox = infobox + " H1";
         } else if (h1 > h2) {
            points = points - increment;
            if (detail) infobox = infobox + " H0";
         }
         if (h1 < h2 && h3 > h4) {
            //Alert(symbol, ", ", TimeframeToString(period), ", Heiken change to Buy");
         } else if (h1 > h2 && h3 < h4) {
            //Alert(symbol, ", ", TimeframeToString(period), ", Heiken change to Sell");
         }
         //iRSI
         val = iRSI(symbol, period,7,PRICE_CLOSE,1);
         val2 = iRSI(symbol, period,7,PRICE_CLOSE,2);
         totalpoints = totalpoints + increment;
         if (val > 70) {
            points = points + increment;
            if (detail) infobox = infobox + " R1";
         } else if (val < 30) {
            points = points - increment;
            if (detail) infobox = infobox + " R0";
         } 
         if (val > 70 && val2 < 70) {
            //Alert(symbol, ", ", TimeframeToString(period), ", RSI change to Buy");
         } else if (val < 30 && val2 > 30) {
            //Alert(symbol, ", ", TimeframeToString(period), ", RSI change to Sell");
         } 
         //macd
         val2 = iCustom(symbol, period, "MACD_Complete",1,1);
         val3 = iCustom(symbol, period, "MACD_Complete",2,1);
         val4 = iCustom(symbol, period, "MACD_Complete",1,2);
         val5 = iCustom(symbol, period, "MACD_Complete",2,2);
         totalpoints = totalpoints + increment;
         if (val2 > val3) {
            points = points + increment;
            if (detail) infobox = infobox + " M1";
         } else if (val2 < val3) {
            points = points - increment;
            if (detail) infobox = infobox + " M0";
         } 
         if (val2 > val3 && val4 < val5) {
            //Alert(symbol, ", ", TimeframeToString(period), ", MACD change to Buy");
         } else if (val2 < val3 && val4 > val5) {
            //Alert(symbol, ", ", TimeframeToString(period), ", MACD change to Sell");
         } 
         //cci
         val = iCCI(symbol, period,45,PRICE_CLOSE,1);
         totalpoints = totalpoints + increment;
         if (val > 100) {
            points = points + increment;
            if (detail) infobox = infobox + " C1";
         } else if (val < -100) {
            points = points - increment;
            if (detail) infobox = infobox + " C0";
         } 
         //ema
         val = iMA(symbol,period,17,0,MODE_EMA,PRICE_CLOSE,1);
         val2 = iMA(symbol,period,43,0,MODE_EMA,PRICE_CLOSE,1);
         totalpoints = totalpoints + increment;
         if (val > val2) {
            points = points + increment;
            if (detail) infobox = infobox + " E1";
         } else if (val < val2) {
            points = points - increment;
            if (detail) infobox = infobox + " E0";
         }
         //iStochastic
         val = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_MAIN,1);
         val2 = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_SIGNAL,1);
         totalpoints = totalpoints + increment;
         if (val > val2) {
            points = points + increment;
            if (detail) infobox = infobox + " S1";
         } else if (val < val2) {
            points = points - increment;
            if (detail) infobox = infobox + " S0";
         }
         //parabolic
         val = iSAR(symbol,period,0.02,0.2,1);
         totalpoints = totalpoints + increment;
         if (val < iOpen(symbol, period, 1)) {
            points = points + increment;
            if (detail) infobox = infobox + " PS1";
         } else if (val > iOpen(symbol, period, 1)) {
            points = points - increment;
            if (detail) infobox = infobox + " PS0";
         }
         
         //ichimoku      
         val=iIchimoku(symbol,period, 9, 26, 52, MODE_TENKANSEN, 1);
         val2=iIchimoku(symbol,period, 9, 26, 52, MODE_KIJUNSEN, 1);
         totalpoints = totalpoints + increment;
         if (val > val2) {
            points = points + increment;
            if (detail) infobox = infobox + " TK1";
         } else if (val < val2) {
            points = points - increment;
            if (detail) infobox = infobox + " TK0";
         } 
         //span
         val = iIchimoku(symbol,period, 9, 26, 52, MODE_SENKOUSPANA, -25);
         val2 = iIchimoku(symbol,period, 9, 26, 52, MODE_SENKOUSPANB, -25);
         totalpoints = totalpoints + increment;
         if (val > val2) {
            points = points + increment;
            if (detail) infobox = infobox + " SP1";
         } else if (val < val2) {
            points = points - increment;
            if (detail) infobox = infobox + " SP0";
         } 
         //chickospan
         val = iIchimoku(symbol,period, 9, 26, 52, MODE_CHINKOUSPAN, 1+26);
         totalpoints = totalpoints + increment;
         if (val > iHigh(symbol, period, 0+26)) {
            points = points + increment;
            if (detail) infobox = infobox + " CO1";
         } else if (val < iLow(symbol, period, 0+26)) {
            points = points - increment;
            if (detail) infobox = infobox + " CO0";
         }
         //adx
         val = iADX(symbol,period,14,PRICE_CLOSE,MODE_MAIN,1);
         val2 = iADX(symbol,period,14,PRICE_CLOSE,MODE_PLUSDI,1);
         val3 = iADX(symbol,period,14,PRICE_CLOSE,MODE_MINUSDI,1);
         totalpoints = totalpoints + increment;
         if (val > 20 && val2 > val3) {
            points = points + increment;
            if (detail) infobox = infobox + " AD1";
         } else if (val > 20 && val2 < val3) {
            points = points - increment;
            if (detail) infobox = infobox + " AD0";
         }
         
         infobox = infobox + ", Points: " + DoubleToStr(points, 1) + "/" + DoubleToStr(totalpoints, 1);
}