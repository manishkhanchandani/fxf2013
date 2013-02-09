//+------------------------------------------------------------------+
//|                                                  cu_power_v3.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <stdlib.mqh>
#include <WinUser32.mqh>

extern double Lots = 0.01;
extern int custom_differnce = 0;
extern double profit = 5;
extern int maxspread = 50;
extern double pending_margin = 0;
extern int sleeptime = 1000;
extern string build = "2.3";

string infobox, initbox, createbox;
int magic = 1230;
int magic1 = 1231;
int magic2 = 1232;
int magic3 = 1233;
int magic4 = 1234;
double returncost;
double totalcost;
double lotsavg;
int type;
double totalprofit;
int difference;
double averagecostingprice;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   initbox = "\n";
   initbox = initbox + "Lots: " + Lots + ", Custom_differnce: " + custom_differnce;
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
      infobox = infobox + "\nDiff: " + diff + ", custom_differnce: " + difference;
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
   bool condition_buy, condition_sell;
   int check = lookupcurrency(symbol);
   //initial condition
   if (check == 1) {
      createorder(symbol, PERIOD_M15, 1, TimeframeToString(PERIOD_M15), magic, 0);
   } else if (check == -1) {
      createorder(symbol, PERIOD_M15, -1, TimeframeToString(PERIOD_M15), magic, 0);
   }
   
   Comment(initbox + infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+

int create_average_costing(string symbol)
{
   double bid, ask, point;
   bid = MarketInfo(symbol, MODE_BID);
   ask = MarketInfo(symbol, MODE_ASK);
   point = MarketInfo(symbol, MODE_POINT);
   int diff;
   if (totalprofit < 0) {
      diff = MathAbs(bid - averagecostingprice) / point;
      infobox = infobox + "\nTotal Profit: " + totalprofit + " - Total Average: " + averagecostingprice + " - Current Diff: " + diff + " - Custom Diff: " + difference + " - Type: " + type;
   
      if (diff > (difference * 1)) {
         infobox = infobox + " - D1:" + (difference * 1);
         createorder(symbol, PERIOD_M15, type, TimeframeToString(PERIOD_M15), magic1, 1);
      } 
      if (diff > (difference * 2)) {
         infobox = infobox + " - D2:" + (difference * 2);
         createorder(symbol, PERIOD_M15, type, TimeframeToString(PERIOD_M15), magic2, 1);
      } 
      if (diff > (difference * 3)) {
         infobox = infobox + " - D3:" + (difference * 3);
         createorder(symbol, PERIOD_M15, type, TimeframeToString(PERIOD_M15), magic3, 1);
      } 
      if (diff > (difference * 4)) {
         infobox = infobox + " - D4:" + (difference * 4);
         createorder(symbol, PERIOD_M15, type, TimeframeToString(PERIOD_M15), magic4, 1);
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
   for(cnt=0;cnt<OrdersTotal();cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol()==symbol
         && (OrderMagicNumber() == magic || OrderMagicNumber() == magic2 || OrderMagicNumber() == magic3 || OrderMagicNumber() == magic4)
      ) {
         if (OrderMagicNumber() == magic) {
            averagecostingprice = OrderOpenPrice();
         }
         x++;
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
      ) {
         totalprofit += OrderProfit();
      }
   }
   infobox = infobox + "\nTotal Profit: " + totalprofit + ", required profit: " + profit;
   if (totalprofit > profit) {
      for(cnt=0;cnt<OrdersTotal();cnt++) {
         OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if(OrderType()<=OP_SELL && OrderSymbol()==symbol
         ) {
            if(OrderType()==OP_BUY) {
               OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_BID),3,White);
            } else if(OrderType()==OP_SELL) {
               OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_ASK),3,White);
            }
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
         double val, val2, val3, val4, val5, val6, val7, cci, cci2, cci3, cci4;
         double h1,h2,h3,h4,h5,h6;
         h1 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",2,0);
         h2 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",3,0);
         h3 = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",2,0);
         h4 = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",3,0);
         h5 = iCustom(symbol, PERIOD_M15, "Heiken_Ashi_Smoothed",2,0);
         h6 = iCustom(symbol, PERIOD_M15, "Heiken_Ashi_Smoothed",3,0);
         cci = iCCI(symbol, PERIOD_M1,45,PRICE_TYPICAL,0);
         cci2 = iCCI(symbol, PERIOD_M5,45,PRICE_TYPICAL,0);
         cci3 = iCCI(symbol, PERIOD_M15,45,PRICE_TYPICAL,0);
         cci4 = iCCI(symbol, PERIOD_M30,45,PRICE_TYPICAL,0);
         val2 = iCustom(symbol, PERIOD_M1, "MACD_Complete",1,0);
         val3 = iCustom(symbol, PERIOD_M1, "MACD_Complete",2,0);
         val4 = iCustom(symbol, PERIOD_M5, "MACD_Complete",1,0);
         val5 = iCustom(symbol, PERIOD_M5, "MACD_Complete",2,0);
         val6 = iCustom(symbol, PERIOD_M15, "MACD_Complete",1,0);
         val7 = iCustom(symbol, PERIOD_M15, "MACD_Complete",2,0);
         bool condition_buy, condition_sell;
         condition_buy = (h1 < h2 && h3 < h4 && h5 < h6 && cci > 100 && cci2 > 100 && cci3 > 100 && cci4 > 100 && val2 > val3 && val4 > val5 && val6 > val7);
         condition_sell = (h1 > h2 && h3 > h4 && h5 > h6 && cci < -100 && cci2 < -100 && cci3 < -100 && cci4 < -100 && val2 < val3 && val4 < val5 && val6 < val7);
         infobox = infobox + "\nCondition  buy: " + condition_buy + ", Condition Sell: " + condition_sell;
         infobox = infobox + "\n";
         infobox = infobox + "Heiken";
         if (h1 < h2) {
            infobox = infobox + ": M1: Buy";
         } else if (h1 > h2) {
            infobox = infobox + ": M1: Sell";
         }
         if (h3 < h4) {
            infobox = infobox + ": M5: Buy";
         } else if (h3 > h4) {
            infobox = infobox + ": M5: Sell";
         }
         if (h5 < h6) {
            infobox = infobox + ": M15: Buy";
         } else if (h5 > h6) {
            infobox = infobox + ": M15: Sell";
         }
         infobox = infobox + "\n";
         infobox = infobox + "MACD";
         if (val2 > val3) {
            infobox = infobox + ": M1: Buy";
         } else if (val2 < val3) {
            infobox = infobox + ": M1: Sell";
         }
         if (val4 > val5) {
            infobox = infobox + ": M5: Buy";
         } else if (val4 < val5) {
            infobox = infobox + ": M5: Sell";
         }
         if (val6 > val7) {
            infobox = infobox + ": M15: Buy";
         } else if (val6 < val7) {
            infobox = infobox + ": M15: Sell";
         }
         infobox = infobox + "\n";
         infobox = infobox + "CCI";
         if (cci > 100) {
            infobox = infobox + ": M1: Buy";
         } else if (cci < -100) {
            infobox = infobox + ": M1: Sell";
         } else {
            infobox = infobox + ": M1: Consolidate";
         }
         if (cci2 > 100) {
            infobox = infobox + ": M5: Buy";
         } else if (cci2 < -100) {
            infobox = infobox + ": M5: Sell";
         } else {
            infobox = infobox + ": M5: Consolidate";
         }
         if (cci3 > 100) {
            infobox = infobox + ": M15: Buy";
         } else if (cci3 < -100) {
            infobox = infobox + ": M15: Sell";
         } else {
            infobox = infobox + ": M15: Consolidate";
         }
         if (cci4 > 100) {
            infobox = infobox + ": M30: Buy";
         } else if (cci4 < -100) {
            infobox = infobox + ": M30: Sell";
         } else {
            infobox = infobox + ": M30: Consolidate";
         }
         if (condition_buy)  {
            return (1);
         } else if (condition_sell) {
            return (-1);
         }
         return (0);
}