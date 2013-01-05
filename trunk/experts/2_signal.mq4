//+------------------------------------------------------------------+
//|                                                     1_signal.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <stdlib.mqh>
#include <WinUser32.mqh>

extern int InitialTrailingStop = 150;
extern int TrailingStop = 150;

extern int trailingstop = 250;
extern int mintrailingstop = 500;
extern int mintrailingstopavgcosting = 500;
extern int gmtoffset = 2;
extern bool strategy_jpy = false;
extern bool strategy_nzdaud = false;
extern bool strategy_eurgbpchf = false;
extern bool strategy_audnzdcad = false;
extern bool strategy_gotrend = true;
extern bool gotrendonlyimpcur = true;
extern bool createneworders = true;

extern int magic = 1230;
extern double lotsize_jpy = 0.25;
extern double lotsize_nzdaud = 0.25;
extern double lotsize_eurgbpchf = 0.25;
extern double lotsize_audnzdcad = 0.25;
extern double lotsize_eurgbpaud = 0.25;
extern double lotsize_gotrend = 0.10;

extern bool UseAlerts = true;
extern bool UseEmailAlerts = true;
extern bool filesave = true;

#define ARRSIZE  28
#define TABSIZE  10
#define PAIRSIZE 8

int checking[ARRSIZE][10];
bool checkingb[ARRSIZE][10];
double checkingd[ARRSIZE][10];

double grade[ARRSIZE][30];
double condition[ARRSIZE];
int totalpoints = 8;
string build = "Build 1.5: ";
int hour;
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

extern bool create_avg_orders = true;
int difference[ARRSIZE];

extern int magic1 = 1231;
extern int magic2 = 1232;
extern int magic3 = 1233;
extern int magic4 = 1234;

double stoploss[ARRSIZE];


int typeoforder[ARRSIZE];
double totalcost[ARRSIZE];
int totalorders[ARRSIZE];
double lotsavg[ARRSIZE];
double averagecostingprice[ARRSIZE];
double totalprofit[ARRSIZE];
double returncost[ARRSIZE];

int trend_direction[ARRSIZE];
int main_direction[ARRSIZE];

string infobox, orderbox, createbox, historybox;
int opentime;
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
   hour = Hour() - gmtoffset;
   infobox = "\nTime: " + TimeToStr(TimeCurrent()) + " and Hour is: " + hour + ", Server Hour: " + Hour() + "\n";
   orderbox = "\n";
   createbox = "\n";
   historybox = "\n";
   //trailingstop();
   strategy_jpy();
   strategy_usd();
   stratagy_audnzdcad();
   strategy_gotrend();
   Comment(orderbox, infobox, createbox, historybox);
   if (filesave && opentime != Time[0]) {
      FileAppend("signals/signal2_" + Year() + "_" + Month() + "_" + Day() + "_" + Hour()  + ".txt", orderbox+infobox+createbox+historybox);
      opentime = Time[0];
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+


int trailingstop()
{
   double bid, ask, point;
   int cnt, ticket, total;
   total=OrdersTotal();
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL
      ) 
         {
         bid = MarketInfo(OrderSymbol(), MODE_BID);
         ask = MarketInfo(OrderSymbol(), MODE_ASK);
         point = MarketInfo(OrderSymbol(), MODE_POINT);
         //orderbox = StringConcatenate(infobox, "\n", OrderSymbol(), ", bid: ", bid, ", ask: ", ask);
         //orderbox = StringConcatenate(infobox, "\n", OrderSymbol(), ", Ordder Profit: ", OrderProfit(), ", OrderOpenPrice: ", OrderOpenPrice());
            if(OrderType()==OP_BUY) {
               if(InitialTrailingStop>0 && TrailingStop>0 && OrderProfit() > 0)  
               {                 
                  //orderbox = StringConcatenate(orderbox, "\n", OrderSymbol(), ", bid-OrderOpenPrice(): ", (bid-OrderOpenPrice()), ", point*InitialTrailingStop: ", (point*InitialTrailingStop));
                  if(bid-OrderOpenPrice()>point*InitialTrailingStop)
                  {
                     //orderbox = StringConcatenate(orderbox, "\n", OrderSymbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", bid-point*TrailingStop: ", (bid-point*TrailingStop));
                     if(OrderStopLoss()<bid-point*TrailingStop)
                     {
                        //orderbox = StringConcatenate(orderbox, "\n", OrderSymbol(), ", Modify Buy");
                        OrderModify(OrderTicket(),OrderOpenPrice(),bid-point*TrailingStop,OrderTakeProfit(),0,Green);
                     }
                  }
               }//end if
            } else if(OrderType()==OP_SELL) {
               // check for trailing stop
               if(InitialTrailingStop>0 && TrailingStop>0 && OrderProfit() > 0)  
                 {                 
                  //orderbox = StringConcatenate(orderbox, "\n", OrderSymbol(), ", OrderOpenPrice()-ask: ", (OrderOpenPrice()-ask), ", point*InitialTrailingStop: ", (point*InitialTrailingStop));
                  if((OrderOpenPrice()-ask)>(point*InitialTrailingStop))
                    {
                     //orderbox = StringConcatenate(orderbox, "\n", OrderSymbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", ask+point*TrailingStop: ", (ask+point*TrailingStop));
                     if((OrderStopLoss()>(ask+point*TrailingStop)) || (OrderStopLoss()==0))
                       {
                        //orderbox = StringConcatenate(orderbox, "\n", OrderSymbol(), ", Modify Sell");
                        OrderModify(OrderTicket(),OrderOpenPrice(),ask+point*TrailingStop,OrderTakeProfit(),0,Red);
                       }
                    }
                 }
            } 
         }
         
      }
      
   //orderbox = StringConcatenate("InitialTrailingStop: ",InitialTrailingStop
   //, ", TrailingStop: ",TrailingStop,"\n",orderbox);

   return (0);
}

int createorder(string symbol, int type, double Lots, int magicnumber, string message, int stoploss, int takeprofit)
{
   int maxspread = 80;
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
   
   if (type == 1) {
      ticket=OrderSend(symbol,OP_BUY,Lots,asks,3,0,0,message,magicnumber,0,Green);
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
            SendAlert("Bullish", symbol, Period());
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
            SendAlert("Bearish", symbol, Period());
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

/*
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
*/

void FileAppend(string name,string txt)
{
   int handle = FileOpen(name,FILE_READ|FILE_WRITE);
	FileSeek(handle,0,SEEK_END);
	FileWrite(handle,txt);
	FileFlush(handle);
	FileClose(handle);
}

int direction_point(string symbol, int period, int mode)
{
   int points_buy = 0;
   int points_sell = 0;
   bool decision_buy = 0;
   bool decision_sell = 0;
   double bids, asks, pt, digit;
   bids = MarketInfo(symbol, MODE_BID);
   asks = MarketInfo(symbol, MODE_ASK);
   pt = MarketInfo(symbol, MODE_POINT);
   digit = MarketInfo(symbol, MODE_DIGITS);

   //take the heiken
   double val2, val3, val4, val5;
   val2 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,0);
   val3 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,0);
   val4 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,1);
   val5 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,1);
   double val6, val7, val8, val9, val8a, val9a, val10, val11, val10a, 
   val11a, val12, val13, val12a, val13a, val14, val15, val14a, val15a;
         
   val8 = iCustom(symbol, PERIOD_M30, "Heiken_Ashi_Smoothed",2,0);
   val9 = iCustom(symbol, PERIOD_M30, "Heiken_Ashi_Smoothed",3,0);
   val8a = iCustom(symbol, PERIOD_M30, "Heiken_Ashi_Smoothed",2,1);
   val9a = iCustom(symbol, PERIOD_M30, "Heiken_Ashi_Smoothed",3,1);
   val10 = iCustom(symbol, PERIOD_M15, "Heiken_Ashi_Smoothed",2,0);
   val11 = iCustom(symbol, PERIOD_M15, "Heiken_Ashi_Smoothed",3,0);
   val10a = iCustom(symbol, PERIOD_M15, "Heiken_Ashi_Smoothed",2,1);
   val11a = iCustom(symbol, PERIOD_M15, "Heiken_Ashi_Smoothed",3,1);
   val12 = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",2,0);
   val13 = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",3,0);
   val12a = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",2,1);
   val13a = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",3,1);
   val14 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",2,0);
   val15 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",3,0);
   val14a = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",2,1);
   val15a = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",3,1);

   string info;
   if (val2 < val3) {
      points_buy = points_buy + 1;
      info = info + "H1H Buy, ";
   } else if (val2 > val3) {
      points_sell = points_sell + 1;
      info = info + "H1H Sell, ";
   }
   
   if (val8 < val9) {
      points_buy = points_buy + 1;
      info = info + "H30M Buy, ";
   } else if (val8 > val9) {
      points_sell = points_sell + 1;
      info = info + "H30M Sell, ";
   }
   
   if (val10 < val11) {
      points_buy = points_buy + 1;
      info = info + "H15M Buy, ";
   } else if (val10 > val11) {
      points_sell = points_sell + 1;
      info = info + "H15M Sell, ";
   }
   
   if (val12 < val13) {
      points_buy = points_buy + 1;
      info = info + "H5M Buy, ";
   } else if (val12 > val13) {
      points_sell = points_sell + 1;
      info = info + "H5M Sell, ";
   }
   
   if (val14 < val15) {
      points_buy = points_buy + 1;
      info = info + "H1M Buy, ";
   } else if (val14 > val15) {
      points_sell = points_sell + 1;
      info = info + "H1M Sell, ";
   }

   double tenkan_sen_1, tenkan_sen_2;
   tenkan_sen_1=iIchimoku(symbol,period, 9, 26, 52, MODE_TENKANSEN, 0);
   tenkan_sen_2=iIchimoku(symbol,period, 9, 26, 52, MODE_TENKANSEN, 1);
   
   if (tenkan_sen_1 < bids) {
      points_buy = points_buy + 1;
      info = info + "T1H Buy, ";
   } else if (tenkan_sen_1 > bids) {
      points_sell = points_sell + 1;
      info = info + "T1H Sell, ";
   }

   double macd2, macd3, macd4, macd5;
   macd2 = iCustom(symbol, period, "MACD_Complete",1,0);
   macd3 = iCustom(symbol, period, "MACD_Complete",2,0);
   macd4 = iCustom(symbol, period, "MACD_Complete",1,1);
   macd5 = iCustom(symbol, period, "MACD_Complete",2,1);
   if (macd2 > macd3) {
      points_buy = points_buy + 1;
      info = info + "M1H Buy, ";
   } else if (macd2 < macd3) {
      points_sell = points_sell + 1;
      info = info + "M1H Sell, ";
   }

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
      int x;
      /*
      int semaphore1 = 0;
      int semaphore2 = 0;
      int semaphore3 = 0;
      int semaphore4 = 0;
      int semaphore5 = 0;
      int semaphorecnt = 0;
      bool condition_buy1, condition_sell1;
      for (x = 0; x < 240; x++){
         ZZ_1=iCustom(symbol,PERIOD_H4,"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,5,x);
         ZZ_2=iCustom(symbol,PERIOD_H4,"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,4,x);
         condition_sell1 = ZZ_1 > ZZ_2;
         condition_buy1 = ZZ_1 < ZZ_2;
         if (condition_buy1 || condition_sell1) {
            if (semaphore1 == 0) {
               semaphore1 = x - 0;
            } else if (semaphore2 == 0) {
               semaphore2 = x - semaphore1;
            } else if (semaphore3 == 0) {
               semaphore3 = x - semaphore2;
            } else if (semaphore4 == 0) {
               semaphore4 = x - semaphore3;
            } else if (semaphore5 == 0) {
               semaphore5 = x - semaphore4;
               break;
            }
         }
      }
      semaphorecnt = (semaphore1 + semaphore2 + semaphore3 + semaphore4 + semaphore5) / 5;
      infobox = infobox + "\nSymbol: " + symbol + ", SemaphoreCNT: " + semaphorecnt;
      int semaphorefinalcnt = 0;
      semaphorefinalcnt = semaphorecnt / 2;
      infobox = infobox + "\nSymbol: " + symbol + ", SemaphoreFinalCNT: " + semaphorefinalcnt;
      */
      bool condition_buy, condition_sell, condition_sm_buy, condition_sm_sell;
      int semaphoreID = -1;
      for (x = 0; x < 240; x++){
         ZZ_1=iCustom(symbol,PERIOD_H4,"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,5,x);
         ZZ_2=iCustom(symbol,PERIOD_H4,"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,4,x);
         condition_sell = ZZ_1 > ZZ_2;
         condition_buy = ZZ_1 < ZZ_2;
         if (condition_buy || condition_sell) {
            if (condition_buy) {
               condition_sm_buy = condition_buy;
            } else if (condition_sell) {
               condition_sm_sell = condition_sell;
            }
            semaphoreID = x;
            break;
         }
      }
      infobox = infobox + "\nSemaphore: " + symbol + ", buy: " + condition_sm_buy + ", Sell: " + condition_sm_sell
         + ", id: " + semaphoreID;
   decision_buy = (
                  condition_sm_buy
                  &&
                  semaphoreID < 10
                  &&
                  (
                     (val2 < val3 && val4 > val5) 
                     || 
                     (val8 < val9 && val8a > val9a) 
                     || 
                     (val10 < val11 && val10a > val11a) 
                     || 
                     (tenkan_sen_1 < bids && tenkan_sen_2 > iLow(symbol, period, 1))
                     || 
                     (macd2 > macd3 && macd4 < macd5)
                  )
                  );
   decision_sell = (
                  condition_sm_sell
                  &&
                  semaphoreID < 10
                  &&
                  (
                     (val2 > val3 && val4 < val5)
                     || 
                     (val8 > val9 && val8a < val9a) 
                     || 
                     (val10 > val11 && val10a < val11a) 
                     || 
                     (tenkan_sen_1 > bids && tenkan_sen_2 < iHigh(symbol, period, 1))
                     || 
                     (macd2 < macd3 && macd4 > macd5)
                  )
                  );
     
   //Calculating the points:
   double high = -1;
   double low = -1;
   for (int z=0; z<4; z++) {
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
   double aRange    = MathMax((high-low)/pt,1);  
   double aRatio    = (bids-low)/aRange/pt;
   double aLookup   = iLookup(aRatio*100);
   double aStrength = 9-aLookup;
   if (aLookup > aStrength) {
      points_buy = points_buy + 1;
      info = info + "R1H Buy, ";
   } else if (aLookup < aStrength) {
      points_sell = points_sell + 1;
      info = info + "R1H Sell, ";
   }

   checking[mode][0] = points_buy; //buy points
   checking[mode][1] = points_sell; //sell points
   checkingb[mode][0] = decision_buy; //decision_buy
   checkingb[mode][1] = decision_sell; //decision_sell
   checkingd[mode][0] = aLookup; //aLookup
   checkingd[mode][1] = aStrength; //aStrength
   infobox = infobox + "\nSymbol: " + symbol + ", Points Buy: " + checking[mode][0]
         + ", Points Sell: " + checking[mode][1]
         + ", Decision Buy: " + checkingb[mode][0]
         + ", Decision Sell: " + checkingb[mode][1]
         + ", Lookup: " + checkingd[mode][0]
         + ", aStrength: " + checkingd[mode][1]
         + "\nInfo: " + info;
    
   return (0);
   
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

int stratagy_audnzdcad()
{
   if (strategy_audnzdcad) {
      create_audnzdcad_orders(AUDCAD, NZDCAD);
      create_audnzdcad_orders(NZDCAD, AUDCAD);
   }
}

int strategy_jpy()
{
   int i, j, k, l, m;
   int cnt;
   
   if (strategy_jpy) {
      direction_point(aPair[9], PERIOD_H1, EURJPY);
      mathmurry(aPair[9], EURJPY);
      direction_point(aPair[11], PERIOD_H1, CADJPY);
      mathmurry(aPair[11], CADJPY);
      direction_point(aPair[12], PERIOD_H1, GBPJPY);
      mathmurry(aPair[12], GBPJPY);
      direction_point(aPair[17], PERIOD_H1, CHFJPY);
      mathmurry(aPair[17], CHFJPY);
      direction_point(aPair[21], PERIOD_H1, NZDJPY);
      mathmurry(aPair[21], NZDJPY);
      
      create_jpy_orders(9, 11, 12, 17, 21);
      create_jpy_orders(11, 9, 12, 17, 21);
      create_jpy_orders(12, 11, 9, 17, 21);
      create_jpy_orders(17, 11, 12, 9, 21);
      create_jpy_orders(21, 11, 12, 17, 9);
      
   }
}

int create_jpy_orders(int i, int j, int k, int l, int m)
{
      //start average costing
      render_avg_costing(aPair[i], i, lotsize_jpy);
      //average costing ends

      int cnt = 0;
      int orders, orders2, orders3, orders4;
      if (checking[i][0] == totalpoints && checkingb[i][0]) {
         //condition for buy, check if we have buy for gbp, if yes, then dont do anything, else buy aud
         orders = CalculateOrdersTypeSymbol(aPair[j], magic, OP_BUY);
         orders2 = CalculateOrdersTypeSymbol(aPair[k], magic, OP_BUY);
         orders3 = CalculateOrdersTypeSymbol(aPair[l], magic, OP_BUY);
         orders4 = CalculateOrdersTypeSymbol(aPair[m], magic, OP_BUY);
         cnt = orders + orders2 + orders3 + orders4;
         if (cnt < 2) {
            createorder(aPair[i], 1, lotsize_jpy, magic, build + checking[i][0] + ", " + checkingb[i][0], 
               0, 0);
         }
      } else if (checking[i][1] == totalpoints && checkingb[i][1]) {
         orders = CalculateOrdersTypeSymbol(aPair[j], magic, OP_SELL);
         orders2 = CalculateOrdersTypeSymbol(aPair[k], magic, OP_SELL);
         orders3 = CalculateOrdersTypeSymbol(aPair[l], magic, OP_SELL);
         orders4 = CalculateOrdersTypeSymbol(aPair[m], magic, OP_SELL);
         cnt = orders + orders2 + orders3 + orders4;
         if (cnt < 2) {
            createorder(aPair[i], -1, lotsize_jpy, magic, build + checking[i][1] + ", " + checkingb[i][1], 
               0, 0);
         }
      }
}

int render_avg_costing(string symbol, int i, double lots)
{
   difference[i] = get_difference(symbol, i);
   get_average_costing(symbol, i);
   create_average_costing(symbol, i, lots);
   closingonprofit(symbol, i);
}

int strategy_usd()
{
   int orders = 0;
   int orders2 = 0;
   int i, j, k;
   if (strategy_eurgbpchf) {
      //start average costing
      render_avg_costing(aPair[EURUSD], EURUSD, lotsize_eurgbpchf);
      //average costing ends
      int h1 = get_heiken(EURUSD);
      //start average costing
      render_avg_costing(aPair[USDCHF], USDCHF, lotsize_eurgbpchf);
      //average costing ends
      int h2 = get_heiken(USDCHF);
      //start average costing
      render_avg_costing(aPair[GBPUSD], GBPUSD, lotsize_eurgbpchf);
      //average costing ends
      int h3 = get_heiken(GBPUSD);
      
      i = 2;
      j = 0;
      k = 1;
      
      if (h1 == 1) {
         //condition for buy, check if we have buy for gbp, if yes, then dont do anything, else buy aud
         orders = CalculateOrdersTypeSymbol(aPair[j], magic, OP_SELL);
         orders2 = CalculateOrdersTypeSymbol(aPair[k], magic, OP_BUY);
         if (orders == 0 && orders2 == 0) {
            //create order for EURUSD - lotsize_eurgbpchf
            createorder(aPair[i], 1, lotsize_eurgbpchf, magic, build + h1, 
               0, 0);
         }
      } else if (h1 == -1) {
         orders = CalculateOrdersTypeSymbol(aPair[j], magic, OP_BUY);
         orders2 = CalculateOrdersTypeSymbol(aPair[k], magic, OP_SELL);
         if (orders == 0 && orders2 == 0) {
            createorder(aPair[i], -1, lotsize_eurgbpchf, magic, build + h1, 
               0, 0);
         }
      }
      i = 0;
      j = 2;
      k = 1;
      if (h2 == 1) {
         //condition for buy, check if we have buy for gbp, if yes, then dont do anything, else buy aud
         orders = CalculateOrdersTypeSymbol(aPair[j], magic, OP_SELL);
         orders2 = CalculateOrdersTypeSymbol(aPair[k], magic, OP_SELL);
         if (orders == 0 && orders2 == 0) {
            //create order for EURUSD - lotsize_eurgbpchf
            createorder(aPair[i], 1, lotsize_eurgbpchf, magic, build + h2, 
               0, 0);
         }
      } else if (h2 == -1) {
         orders = CalculateOrdersTypeSymbol(aPair[j], magic, OP_BUY);
         orders2 = CalculateOrdersTypeSymbol(aPair[k], magic, OP_BUY);
         if (orders == 0 && orders2 == 0) {
            createorder(aPair[i], -1, lotsize_eurgbpchf, magic, build + h2, 
               0, 0);
         }
      }
      
      i = 1;
      j = 0;
      k = 2;
      if (h3 == 1) {
         //condition for buy, check if we have buy for gbp, if yes, then dont do anything, else buy aud
         orders = CalculateOrdersTypeSymbol(aPair[j], magic, OP_SELL);
         orders2 = CalculateOrdersTypeSymbol(aPair[k], magic, OP_BUY);
         if (orders == 0 && orders2 == 0) {
            //create order for EURUSD - lotsize_eurgbpchf
            createorder(aPair[i], 1, lotsize_eurgbpchf, magic, build + h3, 
               0, 0);
         }
      } else if (h3 == -1) {
         orders = CalculateOrdersTypeSymbol(aPair[j], magic, OP_BUY);
         orders2 = CalculateOrdersTypeSymbol(aPair[k], magic, OP_SELL);
         if (orders == 0 && orders2 == 0) {
            createorder(aPair[i], -1, lotsize_eurgbpchf, magic, build + h3, 
               0, 0);
         }
      }
   }
   if (strategy_nzdaud) {
      direction_point(aPair[5], PERIOD_H1, AUDUSD);
      mathmurry(aPair[5], AUDUSD);
      direction_point(aPair[22], PERIOD_H1, NZDUSD);
      mathmurry(aPair[22], NZDUSD);
      i = 5;
      j = 22;
      //start average costing
      render_avg_costing(aPair[i], i, lotsize_nzdaud);
      //average costing ends
      
      if (checking[5][0] == 8 && checkingb[5][0]) {
         //condition for buy, check if we have buy for nzd, if yes, then dont do anything, else buy aud
         orders = CalculateOrdersTypeSymbol(aPair[22], magic, OP_BUY);
         if (orders == 0) {
            //create order for AUDUSD - lotsize_nzdaud
            createorder(aPair[5], 1, lotsize_nzdaud, magic, build + checking[5][0] + ", " + checkingb[5][0], 
               0, 0);
         }
      } else if (checking[5][1] == 8 && checkingb[5][1]) {
         //condition for buy, check if we have buy for nzd, if yes, then dont do anything, else buy aud
         orders = CalculateOrdersTypeSymbol(aPair[22], magic, OP_SELL);
         if (orders == 0) {
            //create order for AUDUSD - lotsize_nzdaud
            createorder(aPair[5], -1, lotsize_nzdaud, magic, build + checking[5][1] + ", " + checkingb[5][1], 
               0, 0);
         }
      }
      
      i = 22;
      j = 5;
      //start average costing
      render_avg_costing(aPair[i], i, lotsize_nzdaud);
      //average costing ends
      if (checking[22][0] == 8 && checkingb[22][0]) {
         //condition for buy, check if we have buy for aud, if yes, then dont do anything, else buy aud
         orders = CalculateOrdersTypeSymbol(aPair[5], magic, OP_BUY);
         if (orders == 0) {
            //create order for AUDUSD - lotsize_nzdaud
            createorder(aPair[22], 1, lotsize_nzdaud, magic, build + checking[22][0] + ", " + checkingb[22][0], 
               0, 0);
         }
      } else if (checking[22][1] == 8 && checkingb[22][1]) {
         //condition for buy, check if we have buy for nzd, if yes, then dont do anything, else buy aud
         orders = CalculateOrdersTypeSymbol(aPair[5], magic, OP_SELL);
         if (orders == 0) {
            //create order for NZDUSD - lotsize_nzdaud
            createorder(aPair[22], -1, lotsize_nzdaud, magic, build + checking[22][1] + ", " + checkingb[22][1], 
               0, 0);
         }
      }
      //buy or sell any one of audusd, if aud is buy and condition goes negative then sell nzd
   }
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

int mathmurry(string symbol, int mode)
{
   double bids, asks, pt, digit;
   bids = MarketInfo(symbol, MODE_BID);
   asks = MarketInfo(symbol, MODE_ASK);
   pt = MarketInfo(symbol, MODE_POINT);
   digit = MarketInfo(symbol, MODE_DIGITS);

   if(MMPeriod>0)
      NewPeriod   = P*MathCeil(MMPeriod/Period());
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
   
   bn_v1 = Lowest(symbol, Period(),MODE_LOW,NewPeriod+StepBack,StepBack);
   bn_v2 = Highest(symbol, Period(),MODE_HIGH,NewPeriod+StepBack,StepBack);
   v1 = iLow(symbol, Period(), bn_v1);
   v2 = iHigh(symbol, Period(), bn_v2);
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
   //infobox = StringConcatenate(infobox, " - ", DoubleToStr(((grade[mode][12] - grade[mode][0])/MarketInfo(symbol, MODE_POINT)), 0));
   infobox = StringConcatenate(infobox, ", Level: ", currentlevel);
   if (currentlevel >= 10) {
      condition[mode] = -1;
   } else if (currentlevel <= 2) {
      condition[mode] = 1;
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


int create_average_costing(string symbol, int mode, double lots)
{
   if (totalorders[mode] == 0)
      return (0);

   double bid = MarketInfo(symbol, MODE_BID);
   double point = MarketInfo(symbol, MODE_POINT);
   int diff;
   if (totalprofit[mode] < 0) {
      diff = MathAbs(bid - averagecostingprice[mode]) / point;
      infobox = infobox + "\nTotal Profit: " + totalprofit[mode] + 
         " - Total Average: " + averagecostingprice[mode] + " - Current Diff: " + diff + 
         " - Custom Diff: " + difference[mode] + " - typeoforder: " + typeoforder[mode];

      if (diff > (difference[mode] * 1) && diff < (difference[mode] * 2) && create_avg_orders) {
         infobox = infobox + " - D1:" + (difference[mode] * 1);
         createorder(symbol, typeoforder[mode], lots, magic1, "Build 1.2: Level 1", 0, 0);
      } 
      if (diff > (difference[mode] * 2) && diff < (difference[mode] * 3) && create_avg_orders) {
         infobox = infobox + " - D2:" + (difference[mode] * 2);
         createorder(symbol, typeoforder[mode], lots, magic2, "Build 1.2: Level 2", 0, 0);
      } 
      if (diff > (difference[mode] * 3) && diff < (difference[mode] * 4) && create_avg_orders) {
         infobox = infobox + " - D3:" + (difference[mode] * 3);
         createorder(symbol, typeoforder[mode], lots, magic3, "Build 1.2: Level 3", 0, 0);
      } 
      if (diff > (difference[mode] * 4) && create_avg_orders) {
         infobox = infobox + " - D4:" + (difference[mode] * 4);
         createorder(symbol, typeoforder[mode], lots, magic4, "Build 1.2: Level 4", 0, 0);
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
   for(cnt=0;cnt<OrdersTotal();cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol()==symbol
         && (OrderMagicNumber() == magic || OrderMagicNumber() == magic1 || OrderMagicNumber() == magic2 || OrderMagicNumber() == magic3 || OrderMagicNumber() == magic4)
      ) {
         //Print(symbol, ", ", OrderMagicNumber());
         if (OrderMagicNumber() == magic) {
            averagecostingprice[mode] = OrderOpenPrice();
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
      infobox = infobox + StringConcatenate(symbol, "\nlotsavg[mode]: ", DoubleToStr(lotsavg[mode], 2), ", totalcost[mode]: ", totalcost[mode], ", typeoforder: ", typeoforder[mode], ", totalprofit[mode]: ", totalprofit[mode], ", returncost[mode]: ", returncost[mode]);
   
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
   ", mintrailingstopavgcosting: " + mintrailingstopavgcosting;
   
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

int create_audnzdcad_orders(int i, int j)
{
      //start average costing
      render_avg_costing(aPair[i], i, lotsize_audnzdcad);
      //average costing ends
      int semaphore = get_semaphore(i);
      int cnt = 0;
      int orders, orders2, orders3, orders4;
      if (semaphore == 1) {
         //condition for buy, check if we have buy for gbp, if yes, then dont do anything, else buy aud
         orders = CalculateOrdersTypeSymbol(aPair[j], magic, OP_BUY);
         cnt = orders;
         if (cnt < 1) {
            createorder(aPair[i], 1, lotsize_audnzdcad, magic, build + semaphore, 
               0, 0);
         }
      } else if (semaphore == -1) {
         orders = CalculateOrdersTypeSymbol(aPair[j], magic, OP_SELL);
         cnt = orders;
         if (cnt < 1) {
            createorder(aPair[i], -1, lotsize_audnzdcad, magic, build + semaphore, 
               0, 0);
         }
      }
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


int get_heiken(int i)
{
   
      bool condition_buy, condition_sell;
      
      string symbol = aPair[i];
      
   //take the heiken
   double val2, val3, val4, val5;
   val2 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",2,1);
   val3 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",3,1);
   val4 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",2,2);
   val5 = iCustom(symbol, PERIOD_H4, "Heiken_Ashi_Smoothed",3,2);
   double val6, val7, val8, val9, val8a, val9a, val10, val11, val10a, 
   val11a, val12, val13, val12a, val13a, val14, val15, val14a, val15a;
         
   val6 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,0);
   val7 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,0);
   val8 = iCustom(symbol, PERIOD_M30, "Heiken_Ashi_Smoothed",2,0);
   val9 = iCustom(symbol, PERIOD_M30, "Heiken_Ashi_Smoothed",3,0);
   val10 = iCustom(symbol, PERIOD_M15, "Heiken_Ashi_Smoothed",2,0);
   val11 = iCustom(symbol, PERIOD_M15, "Heiken_Ashi_Smoothed",3,0);
   val12 = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",2,0);
   val13 = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",3,0);
   val14 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",2,0);
   val15 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",3,0);

   
   double tenkan_sen_1, tenkan_sen_2;
   tenkan_sen_1=iIchimoku(symbol,PERIOD_H4, 9, 26, 52, MODE_TENKANSEN, 0);
   tenkan_sen_2=iIchimoku(symbol,PERIOD_H4, 9, 26, 52, MODE_TENKANSEN, 1);
   
      condition_buy = (
            val2 < val3
            &&
            val4 > val5
            &&
            val6 < val7
            &&
            val8 < val9
            &&
            val10 < val11
            &&
            val12 < val13
            &&
            val14 < val15
            && 
            tenkan_sen_2 < iLow(symbol, PERIOD_H4, 1)
         );
      condition_sell = (
            val2 > val3
            &&
            val4 < val5
            &&
            val6 > val7
            &&
            val8 > val9
            &&
            val10 > val11
            &&
            val12 > val13
            &&
            val14 > val15
            && 
            tenkan_sen_2 > iHigh(symbol, PERIOD_H4, 1)
         );
      infobox = infobox + "\n" + symbol + ", Heiken: " + " Buy: " + condition_buy + ", Sell: " + condition_sell;
         
      if (condition_buy) {
         return (1);
      } else if (condition_sell) {
         return (-1);
      } else {
         return (0);
      }
}

int go_trend(int i)
{

   bool condition_buy, condition_sell;
   string symbol = aPair[i];
      
   //take the heiken
   double val2, val3, val4, val5;
   val2 = iCustom(symbol, PERIOD_M15, "Heiken_Ashi_Smoothed",2,1);
   val3 = iCustom(symbol, PERIOD_M15, "Heiken_Ashi_Smoothed",3,1);
   val4 = iCustom(symbol, PERIOD_M15, "Heiken_Ashi_Smoothed",2,2);
   val5 = iCustom(symbol, PERIOD_M15, "Heiken_Ashi_Smoothed",3,2);
   
      
      int semaphore = get_trendsemaphore(i, PERIOD_M15, 1);
      if (semaphore == 1) {
         trend_direction[i] = 1;
      } else if (semaphore == -1) {
         trend_direction[i] = -1;
      }
      condition_buy = (
            val2 < val3
            &&
            val4 > val5
            &&
            trend_direction[i] == 1
         );
      condition_sell = (
            val2 > val3
            &&
            val4 < val5
            &&
            trend_direction[i] == -1
         );
      infobox = infobox + ", Heiken: " + " Buy: " + (val2 < val3
            &&
            val4 > val5) + ", Sell: " + (val2 > val3
            &&
            val4 < val5)
            + ", current Buy: " + (val2 < val3) + ", current Sell: " + (val2 > val3)
         + ", trend direction: " + trend_direction[i]
      ;
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


int get_lasttrendsemaphore(int i, int period)
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
      for (int z=0; z < 240; z++) {
      
         ZZ_1=iCustom(symbol,period,"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,5,z);
         ZZ_2=iCustom(symbol,period,"3_Level_ZZ_Semafor",Period1,Period2,Period3,Dev_Step_1,Dev_Step_2,Dev_Step_3,Symbol_1_Kod,Symbol_2_Kod,Symbol_3_Kod,4,z);
         condition_sell = ZZ_1 > ZZ_2;
         condition_buy = ZZ_1 < ZZ_2;
         
         if (condition_buy) {
            return (1);
         } else if (condition_sell) {
            return (-1);
         }
     }
     return (0);
}

int strategy_gotrend()
{
   if (!strategy_gotrend) {
      return (0);
   }
   string symbol;
   int period = PERIOD_M15;
   for (int x = 0; x < ARRSIZE; x++){
      /*if (x == EURUSD || x == EURJPY || x == GBPAUD || x == EURAUD || x == EURNZD) {
      
      } else {
         if (gotrendonlyimpcur)
            continue;
      }*/
      symbol = aPair[x];
      history(symbol, x, magic);
      if (x == GBPUSD) {
         gotrend_easy(symbol, x, PERIOD_M1);
      } else if (x == USDCHF) {
         gotrend_easy(symbol, x, PERIOD_M5);
      } else if (x == EURUSD) {
         gotrend_heiken(symbol, x, PERIOD_M15);
      } else if (x == EURJPY) {
         gotrend_heiken(symbol, x, PERIOD_M15);
      } else if (x == GBPAUD) {
         gotrend_simple(symbol, x, PERIOD_H1);
      } else if (x == EURNZD) {
         gotrend_simple(symbol, x, PERIOD_H4);
      } else if (x == AUDUSD) {
         gotrend_easy_advanced(symbol, x, PERIOD_M1);
      } else if (x == USDCAD) {
         gotrend_easy_advanced(symbol, x, PERIOD_M5);
      } else if (x == AUDCAD) {
         gotrend_advanced(symbol, x, PERIOD_M15);
      } else if (x == NZDCAD) {
         gotrend_advanced(symbol, x, PERIOD_M30);
      } else if (x == GBPJPY) {
         gotrend_advanced(symbol, x, PERIOD_H1);
      } else if (x == CHFJPY) {
         gotrend_simple(symbol, x, PERIOD_D1);
      } else if (x == CADJPY) {
         gotrend_simple(symbol, x, PERIOD_D1);
      } else if (x == NZDJPY) {
         gotrend_simple(symbol, x, PERIOD_H4);
      } else if (x == AUDJPY) {
         gotrend_simple(symbol, x, PERIOD_H4);
      }  else if (x == USDJPY) {
         gotrend_simple(symbol, x, PERIOD_H4);
      }
   }
}

int gotrend_easy(string symbol, int x, int period)
{
   int semaphore;
   double val2, val3, val4, val5;
   int condition_heiken, condition_heiken2, condition_heiken3;
   int h1;
   int h2, h3;
      //render_avg_costing(symbol, x, lotsize_gotrend);
      semaphore = get_lasttrendsemaphore(x, period);
      if (semaphore == 1) {
         trend_direction[x] = 1;
      } else if (semaphore == -1) {
         trend_direction[x] = -1;
      }
   
   
      val2 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,0);
      condition_heiken = 0;
      if (val2 < val3) {
         condition_heiken = 1;
      } else if (val2 > val3) {
         condition_heiken = -1;
      }
      val2 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",3,0);
      condition_heiken2 = 0;
      if (val2 < val3) {
         condition_heiken2 = 1;
      } else if (val2 > val3) {
         condition_heiken2 = -1;
      }
      
      double tenkan_sen_1;//, tenkan_sen_2;
      tenkan_sen_1=iIchimoku(symbol,period, 9, 26, 52, MODE_TENKANSEN, 0);
      //tenkan_sen_2=iIchimoku(symbol,PERIOD_M15, 9, 26, 52, MODE_TENKANSEN, 1);
   
      infobox = infobox + "\nSymbol: " + symbol + ", val2: " + val2
               + ", val3: " + val3 + ", condition: " + condition_heiken
                + ", condition2: " + condition_heiken2
               + ", trend direction: " + trend_direction[x] + ", Teikensen: " + tenkan_sen_1
               + ", Bid: " + MarketInfo(symbol, MODE_BID) + ", Period: " + TimeframeToString(period);
               
      if (
         (trend_direction[x] == 0 && condition_heiken == 1)
         ||
         (trend_direction[x] == 1 && condition_heiken == 1)
         ) {
         CheckForClose(aPair[x], x, magic, 1);
         Sleep(1000);
      } else if (
         (trend_direction[x] == 0 && condition_heiken == -1)
         ||
         (trend_direction[x] == -1 && condition_heiken == -1)
         ) {
         CheckForClose(aPair[x], x, magic, -1);
         Sleep(1000);
      }
      
      if (trend_direction[x] == 1 && condition_heiken == 1 && condition_heiken2 == 1 
       && tenkan_sen_1 < MarketInfo(symbol, MODE_BID)) {
         if (createneworders) {
            createorder(aPair[x], 1, lotsize_gotrend, magic, "Easy Simple " + build + TimeframeToString(period), 
               0, 0);
         }
      } else if (trend_direction[x] == -1 && condition_heiken == -1 && condition_heiken2 == -1 
       && tenkan_sen_1 > MarketInfo(symbol, MODE_BID)) {
         if (createneworders) {
            createorder(aPair[x], -1, lotsize_gotrend, magic, "Easy Simple " + build + TimeframeToString(period), 
               0, 0);
         }
      }
}

int gotrend_simple(string symbol, int x, int period)
{
   int semaphore;
   double val2, val3, val4, val5;
   int condition_heiken, condition_heiken2, condition_heiken3;
   int h1;
   int h2, h3;
      //render_avg_costing(symbol, x, lotsize_gotrend);
      semaphore = get_lasttrendsemaphore(x, period);
      if (semaphore == 1) {
         trend_direction[x] = 1;
      } else if (semaphore == -1) {
         trend_direction[x] = -1;
      }
   
   
      val2 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,0);
      condition_heiken = 0;
      if (val2 < val3) {
         condition_heiken = 1;
      } else if (val2 > val3) {
         condition_heiken = -1;
      }
      val2 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",3,0);
      condition_heiken2 = 0;
      if (val2 < val3) {
         condition_heiken2 = 1;
      } else if (val2 > val3) {
         condition_heiken2 = -1;
      }
      val2 = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",3,0);
      condition_heiken3 = 0;
      if (val2 < val3) {
         condition_heiken3 = 1;
      } else if (val2 > val3) {
         condition_heiken3 = -1;
      }
      
      double tenkan_sen_1;//, tenkan_sen_2;
      tenkan_sen_1=iIchimoku(symbol,period, 9, 26, 52, MODE_TENKANSEN, 0);
      //tenkan_sen_2=iIchimoku(symbol,PERIOD_M15, 9, 26, 52, MODE_TENKANSEN, 1);
   
      infobox = infobox + "\nSymbol: " + symbol + ", val2: " + val2
               + ", val3: " + val3 + ", condition: " + condition_heiken
                + ", condition2: " + condition_heiken2 + ", condition3: " + condition_heiken3
               + ", trend direction: " + trend_direction[x] + ", Teikensen: " + tenkan_sen_1
               + ", Bid: " + MarketInfo(symbol, MODE_BID) + ", Period: " + TimeframeToString(period);
               
      if (
         (trend_direction[x] == 0 && condition_heiken == 1)
         ||
         (trend_direction[x] == 1 && condition_heiken == 1)
         ) {
         CheckForClose(aPair[x], x, magic, 1);
         Sleep(1000);
      } else if (
         (trend_direction[x] == 0 && condition_heiken == -1)
         ||
         (trend_direction[x] == -1 && condition_heiken == -1)
         ) {
         CheckForClose(aPair[x], x, magic, -1);
         Sleep(1000);
      }
      
      if (trend_direction[x] == 1 && condition_heiken == 1 && condition_heiken2 == 1 
       && condition_heiken3 == 1 && tenkan_sen_1 < MarketInfo(symbol, MODE_BID)) {
         if (createneworders) {
            createorder(aPair[x], 1, lotsize_gotrend, magic, "Simple " + build + TimeframeToString(period), 
               0, 0);
         }
      } else if (trend_direction[x] == -1 && condition_heiken == -1 && condition_heiken2 == -1 
       && condition_heiken3 == -1  && tenkan_sen_1 > MarketInfo(symbol, MODE_BID)) {
         if (createneworders) {
            createorder(aPair[x], -1, lotsize_gotrend, magic, "Simple " + build + TimeframeToString(period), 
               0, 0);
         }
      }
}


int gotrend_easy_advanced(string symbol, int x, int period)
{
   int semaphore;
   double val2, val3, val4, val5;
   int condition_heiken, condition_heiken2, condition_heiken3;
   int h1;
   int h2, h3;
      //render_avg_costing(symbol, x, lotsize_gotrend);
      semaphore = get_lasttrendsemaphore(x, PERIOD_H4);
      if (semaphore == 1) {
         main_direction[x] = 1;
      } else if (semaphore == -1) {
         main_direction[x] = -1;
      }
      semaphore = get_lasttrendsemaphore(x, period);
      if (semaphore == 1) {
         trend_direction[x] = 1;
      } else if (semaphore == -1) {
         trend_direction[x] = -1;
      }
   
   
      val2 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,0);
      condition_heiken = 0;
      if (val2 < val3) {
         condition_heiken = 1;
      } else if (val2 > val3) {
         condition_heiken = -1;
      }
      val2 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",3,0);
      condition_heiken2 = 0;
      if (val2 < val3) {
         condition_heiken2 = 1;
      } else if (val2 > val3) {
         condition_heiken2 = -1;
      }
      
      double tenkan_sen_1;//, tenkan_sen_2;
      tenkan_sen_1=iIchimoku(symbol,period, 9, 26, 52, MODE_TENKANSEN, 0);
      //tenkan_sen_2=iIchimoku(symbol,PERIOD_M15, 9, 26, 52, MODE_TENKANSEN, 1);
   
      infobox = infobox + "\nSymbol: " + symbol + ", val2: " + val2
               + ", val3: " + val3 + ", condition: " + condition_heiken
                + ", condition2: " + condition_heiken2
               + ", trend direction: " + trend_direction[x] + ", Teikensen: " + tenkan_sen_1
               + ", Bid: " + MarketInfo(symbol, MODE_BID) + ", Period: " + TimeframeToString(period);
               
      if (
         (trend_direction[x] == 0 && condition_heiken == 1)
         ||
         (trend_direction[x] == 1 && condition_heiken == 1)
         ) {
         CheckForClose(aPair[x], x, magic, 1);
         Sleep(1000);
      } else if (
         (trend_direction[x] == 0 && condition_heiken == -1)
         ||
         (trend_direction[x] == -1 && condition_heiken == -1)
         ) {
         CheckForClose(aPair[x], x, magic, -1);
         Sleep(1000);
      }
      
      if (main_direction[x] == 1 && trend_direction[x] == 1 && condition_heiken == 1 && condition_heiken2 == 1 
       && tenkan_sen_1 < MarketInfo(symbol, MODE_BID)) {
         if (createneworders) {
            createorder(aPair[x], 1, lotsize_gotrend, magic, "Easy Advanced " + build + TimeframeToString(period), 
               0, 0);
         }
      } else if (main_direction[x] == -1 && trend_direction[x] == -1 && condition_heiken == -1 && condition_heiken2 == -1 
       && tenkan_sen_1 > MarketInfo(symbol, MODE_BID)) {
         if (createneworders) {
            createorder(aPair[x], -1, lotsize_gotrend, magic, "Easy Advanced " + build + TimeframeToString(period), 
               0, 0);
         }
      }
}

int gotrend_advanced(string symbol, int x, int period)
{
   int semaphore;
   double val2, val3, val4, val5;
   int condition_heiken, condition_heiken2, condition_heiken3;
   int h1;
   int h2, h3;
      //render_avg_costing(symbol, x, lotsize_gotrend);
      semaphore = get_lasttrendsemaphore(x, PERIOD_H4);
      if (semaphore == 1) {
         main_direction[x] = 1;
      } else if (semaphore == -1) {
         main_direction[x] = -1;
      }
      semaphore = get_lasttrendsemaphore(x, period);
      if (semaphore == 1) {
         trend_direction[x] = 1;
      } else if (semaphore == -1) {
         trend_direction[x] = -1;
      }
   
   
      val2 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,0);
      condition_heiken = 0;
      if (val2 < val3) {
         condition_heiken = 1;
      } else if (val2 > val3) {
         condition_heiken = -1;
      }
      val2 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",3,0);
      condition_heiken2 = 0;
      if (val2 < val3) {
         condition_heiken2 = 1;
      } else if (val2 > val3) {
         condition_heiken2 = -1;
      }
      val2 = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",3,0);
      condition_heiken3 = 0;
      if (val2 < val3) {
         condition_heiken3 = 1;
      } else if (val2 > val3) {
         condition_heiken3 = -1;
      }
      
      double tenkan_sen_1;//, tenkan_sen_2;
      tenkan_sen_1=iIchimoku(symbol,period, 9, 26, 52, MODE_TENKANSEN, 0);
      //tenkan_sen_2=iIchimoku(symbol,PERIOD_M15, 9, 26, 52, MODE_TENKANSEN, 1);
   
      infobox = infobox + "\nSymbol: " + symbol + ", val2: " + val2
               + ", val3: " + val3 + ", condition: " + condition_heiken
                + ", condition2: " + condition_heiken2 + ", condition3: " + condition_heiken3
               + ", trend direction: " + trend_direction[x] + ", Teikensen: " + tenkan_sen_1
               + ", Bid: " + MarketInfo(symbol, MODE_BID) + ", Period: " + TimeframeToString(period);
               
      if (
         (trend_direction[x] == 0 && condition_heiken == 1)
         ||
         (trend_direction[x] == 1 && condition_heiken == 1)
         ) {
         CheckForClose(aPair[x], x, magic, 1);
         Sleep(1000);
      } else if (
         (trend_direction[x] == 0 && condition_heiken == -1)
         ||
         (trend_direction[x] == -1 && condition_heiken == -1)
         ) {
         CheckForClose(aPair[x], x, magic, -1);
         Sleep(1000);
      }
      
      if (main_direction[x] == 1 && trend_direction[x] == 1 && condition_heiken == 1 && condition_heiken2 == 1 
       && condition_heiken3 == 1 && tenkan_sen_1 < MarketInfo(symbol, MODE_BID)) {
         if (createneworders) {
            createorder(aPair[x], 1, lotsize_gotrend, magic, "Advanced " + build + TimeframeToString(period), 
               0, 0);
         }
      } else if (main_direction[x] == -1 && trend_direction[x] == -1 && condition_heiken == -1 && condition_heiken2 == -1 
       && condition_heiken3 == -1  && tenkan_sen_1 > MarketInfo(symbol, MODE_BID)) {
         if (createneworders) {
            createorder(aPair[x], -1, lotsize_gotrend, magic, "Advanced " + build + TimeframeToString(period), 
               0, 0);
         }
      }
}



int history(string symbol, int i, int magicnum)
{
   int cnt;
   int total = OrdersHistoryTotal();
   double gtotal = 0;
   for(cnt=0;cnt<total;cnt++)
   {
      OrderSelect(cnt, SELECT_BY_POS, MODE_HISTORY);
      if (OrderMagicNumber()==magicnum && OrderSymbol() == symbol
         && TimeDay(OrderCloseTime()) > 9 
         && TimeMonth(OrderCloseTime()) == 12
         && TimeYear(OrderCloseTime()) == Year()) {
         gtotal += OrderProfit();
         //Print("Cnt: ", cnt, ", ticket: ", OrderTicket(), ", Order Profit: ", OrderProfit(), ", currency: ", OrderSymbol());
         //Print("close day: ", TimeDay(OrderCloseTime()), ", close month: ", TimeMonth(OrderCloseTime()), ", close year: ", TimeYear(OrderCloseTime())
            //, ", current day: ", Day(), ", current month: ", Month(), ", current year: ", Year()
         //);
      }
   }
   historybox = historybox + "\nTotal Profit/Loss For Symbol: " + symbol + " is: " + DoubleToStr(gtotal, 2);
   return (0);
}



int gotrend_heiken(string symbol, int x, int period)
{
   int semaphore;
   double val2, val3, val4, val5;
   int condition_heiken, condition_heiken2, condition_heiken3;
   int h1;
   int h2, h3;
      //render_avg_costing(symbol, x, lotsize_gotrend);
      
   
   
      val2 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,0);
      condition_heiken = 0;
      if (val2 < val3) {
         condition_heiken = 1;
      } else if (val2 > val3) {
         condition_heiken = -1;
      }
      val2 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",3,0);
      condition_heiken2 = 0;
      if (val2 < val3) {
         condition_heiken2 = 1;
      } else if (val2 > val3) {
         condition_heiken2 = -1;
      }
      val2 = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",3,0);
      condition_heiken3 = 0;
      if (val2 < val3) {
         condition_heiken3 = 1;
      } else if (val2 > val3) {
         condition_heiken3 = -1;
      }
    
      infobox = infobox + "\nSymbol: " + symbol + ", val2: " + val2
               + ", val3: " + val3 + ", condition: " + condition_heiken
                + ", condition2: " + condition_heiken2 + ", condition3: " + condition_heiken3
               + ", Bid: " + MarketInfo(symbol, MODE_BID) + ", Period: " + TimeframeToString(period);
               
      if (
         condition_heiken == 1
         ) {
         CheckForClose(aPair[x], x, magic, 1);
         Sleep(1000);
      } else if (
         condition_heiken == -1
         ) {
         CheckForClose(aPair[x], x, magic, -1);
         Sleep(1000);
      }
      
      if (condition_heiken == 1 && condition_heiken2 == 1 
       && condition_heiken3 == 1) {
         if (createneworders) {
            createorder(aPair[x], 1, lotsize_gotrend, magic, "Simple Heiken " + build + TimeframeToString(period), 
               0, 0);
         }
      } else if (condition_heiken == -1 && condition_heiken2 == -1 
       && condition_heiken3 == -1) {
         if (createneworders) {
            createorder(aPair[x], -1, lotsize_gotrend, magic, "Simple Heiken " + build + TimeframeToString(period), 
               0, 0);
         }
      }
}


