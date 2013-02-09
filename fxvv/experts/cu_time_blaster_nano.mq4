//+------------------------------------------------------------------+
//|                                              cu_time_blaster.mq4 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"


#include <stdlib.mqh>
#include <WinUser32.mqh>
#define MAGICMA  225
extern double Lots = 0.05;
extern int InitialTrailingStop = 150;
extern int TrailingStop = 150;
extern int stoploss = 300;
extern int takeprofit = 0;
extern int gmt_offset = 1;
extern bool current_symbol = false;
extern bool create_order = false;
extern int pending_margin = 100;
extern int maxorders = 1;
extern bool hedging = false;
extern bool markethours = false;
extern int maxspread = 70;
extern double top = 6;
extern double bottom = 2.9;
#define ARRSIZE  28 // number of pairs !!!
#define PAIRSIZE 8 // number of currencies 
#define TABSIZE  10 // scale of currency's 
#define ORDER    2 // available type of order 


// Added to make code easier to understand
// Currency pair
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
                        "USDCHF_Nano","GBPUSD_Nano","EURUSD_Nano","USDJPY_Nano","USDCAD_Nano","AUDUSD_Nano",
                        "EURGBP_Nano","EURAUD_Nano","EURCHF_Nano","EURJPY_Nano","GBPCHF_Nano","CADJPY_Nano",
                        "GBPJPY_Nano","AUDNZD_Nano","AUDCAD_Nano","AUDCHF_Nano","AUDJPY_Nano","CHFJPY_Nano",
                        "EURNZD_Nano","EURCAD_Nano","CADCHF_Nano","NZDJPY_Nano","NZDUSD_Nano","GBPCAD_Nano",
                        "GBPNZD_Nano","GBPAUD_Nano","NZDCHF_Nano","NZDCAD_Nano"
                        };
   string aMajor[PAIRSIZE] = {"USD","EUR","GBP","CHF","CAD","AUD","JPY","NZD"};
   string aOrder[ORDER]    = {"BUY ","SELL "};

   double aMeter[PAIRSIZE];

string infobox;       

int hour;
int openTime;
int curtime;
string orderbox;
string pendingorderbox;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   curtime = Time[0];
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
      trailing_stop();
      hour = Hour() - gmt_offset;
      if (hour < 0) {
         hour = hour + 24;
      }
      infobox="Hour: " + Hour() + ", hour new: " + hour + "\n";
      infobox = StringConcatenate(infobox, "Lots: ", Lots, ", InitialTrailingStop: ", InitialTrailingStop,
         ", TrailingStop: ", TrailingStop,
         ", stoploss: ", stoploss,
         ", takeprofit: ", takeprofit, 
         ", gmt_offset: ", gmt_offset, "\n",
         ", create_order: ", create_order, "\n",
         ", pending_margin: ", pending_margin,
         ", maxorders: ", maxorders,
         ", hedging: ", hedging,
         ", markethours: ", markethours, ", top: ", top, ", bottom: ", bottom, "\n");
      if (markethours) {
         if (hour == 0 || hour == 1 || hour == 7 || hour == 8 || hour == 13 || hour == 14) {
   
         } else {
            infobox = StringConcatenate(infobox, "Working hours are 0, 1, 7, 8, 13, 14\n", "\n");
         }
      }
      strength();
      Comment(orderbox, "\n", pendingorderbox, "\n", infobox);
      return (0);
//----
   return(0);
  }
//+------------------------------------------------------------------+


int createorder(string symbol, int timeperiod, int type, string message)
{
   if (curtime == Time[0]) {
      //return (0);
   }

   if (IsTradeAllowed()==false)
      return (0);

   if (!create_order)
      return (0);

   
   if (markethours) {
      if (hour == 0 || hour == 1 || hour == 7 || hour == 8 || hour == 13 || hour == 14) {
   
      } else {
         return (0);
      }
   }
   
   if (MarketInfo(symbol, MODE_SPREAD) > maxspread) {
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
         return (0);
      }
   } else if (type == -1) {
      ordertype = OP_SELL;
      val3 = AccountFreeMarginCheck(symbol, OP_SELL, Lots);
      if (val3 < pending_margin) {
         return (0);
      }
   } else {
      return (0);
   }

   orders = CalculateCurrentOrders(symbol, ordertype, hedging);
   if (orders > 0)
   {
      //Print("order already created for symbol: ", symbol);
       return (0);
   }
   
   orders = CalculateCurrentRealMaxOrders();
   if (orders >= maxorders)
   {
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
      price = asks;
      if (stoploss > 0)
         sl = price - (stoploss * pt);
      if (takeprofit > 0)
         tp = price + (takeprofit * pt);
      //ticket=OrderSend(symbol,OP_BUYSTOP,Lots,price,3,sl,tp,message+", Time Blaster2",MAGICMA,0,Green);
      ticket=OrderSend(symbol,OP_BUY,Lots,asks,3,sl,tp,message+", Time Blaster",MAGICMA,0,Green);
      if(ticket>0)
         {
          if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
            //SendAlert(StringConcatenate("BUY order opened : ",OrderOpenPrice()), symbol, timeperiod);
          }
         }
      else {
         Print(symbol, ", Error opening BUY order : ",ErrorDescription(GetLastError()), ", asks: ", asks);
      }
         return(0); 
   } else if (type == -1) {
      price = bids;
      if (stoploss > 0)
         sl = price + (stoploss * pt);
      if (takeprofit > 0)
         tp = price - (takeprofit * pt);

       //ticket=OrderSend(symbol,OP_SELLSTOP,Lots,price,3,sl,tp,message+", Time Blaster2",MAGICMA,0,Red);
       ticket=OrderSend(symbol,OP_SELL,Lots,bids,3,sl,tp,message+", Time Blaster",MAGICMA,0,Red);
        if(ticket>0)
           {
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
               //SendAlert(StringConcatenate("SELL order opened : ",OrderOpenPrice()), symbol, timeperiod);
            }
           }
           else {
               Print(symbol, " Error opening Sell order : ",ErrorDescription(GetLastError()), ", price: ", bids); 
            } 
             return(0); 
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

int CalculateCurrentRealMaxOrders()
  {
   int corders=0;
//----
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderMagicNumber()==MAGICMA)
        {
         if(OrderType()==OP_BUY || OrderType()==OP_SELL)
            corders++;
        }
     }
         return(corders);
}
int CalculateCurrentOrders(string symbol, int type, bool hg)
  {
   int cnt=0;
   int i;
//----
   if (hg) {
      for(i=0;i<OrdersTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
         if (type == OP_BUY) {
            if(OrderSymbol()==symbol && (OrderType() == OP_BUY || OrderType() == OP_BUYSTOP) && OrderMagicNumber()==MAGICMA)
              {
               cnt++;
              }
          } else if (type == OP_SELL) {
            if(OrderSymbol()==symbol && (OrderType() == OP_SELL || OrderType() == OP_SELLSTOP) && OrderMagicNumber()==MAGICMA)
              {
               cnt++;
              }
          }
        }
    } else {
      for(i=0;i<OrdersTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
         if(OrderSymbol()==symbol && OrderMagicNumber()==MAGICMA)
           {
            cnt++;
           }
        }
    }
   return (cnt);
  }

int trailing_stop()
{
   //return (0);
   orderbox = "";
   orderbox = StringConcatenate(orderbox, "\nCHECKING ORDERS:");
   int cnt, ticket, total;
   total=OrdersTotal();
   double bids, asks, pt, digit;
   int orders;
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         // for more than two orders, return as we dont support trialing stop for more orders as of now
      if(OrderType()<=OP_SELL 
      && OrderMagicNumber()==MAGICMA
      )  // check for symbol
         {
         orderbox = StringConcatenate(orderbox, "\n", OrderSymbol(), " (", OrderProfit(), ")");
         bids = MarketInfo(OrderSymbol(), MODE_BID);
         asks = MarketInfo(OrderSymbol(), MODE_ASK);
         pt = MarketInfo(OrderSymbol(), MODE_POINT);
         digit = MarketInfo(OrderSymbol(), MODE_DIGITS);
         bids = NormalizeDouble(bids, digit);
         asks = NormalizeDouble(asks, digit);
         orderbox = StringConcatenate(orderbox, " - ordertype: ", OrderType());
            if(OrderType()==OP_BUY) {
               if(InitialTrailingStop>0 
               && OrderProfit() > 0
               )  
               {                 
                  orderbox = StringConcatenate(orderbox, " - pt*InitialTrailingStop: ", (pt*InitialTrailingStop));
                  orderbox = StringConcatenate(orderbox, " - bids-OrderOpenPrice(): ", (bids-OrderOpenPrice()));
                  if(bids-OrderOpenPrice()>pt*InitialTrailingStop)
                  {
                     orderbox = StringConcatenate(orderbox, " - OrderStopLoss(): ", OrderStopLoss());
                     orderbox = StringConcatenate(orderbox, " - bids-pt*TrailingStop: ", (bids-pt*TrailingStop));
                     //Print(OrderSymbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", bids-pt*TrailingStop: ", (bids-pt*TrailingStop));
                     if(OrderStopLoss()<bids-pt*TrailingStop)
                     {
                        //Alert(OrderSymbol(), ", Modify Buy");
                        OrderModify(OrderTicket(),OrderOpenPrice(),bids-pt*TrailingStop,OrderTakeProfit(),0,Green);
                        //return(0);
                     }
                  }
               }//end if
            } else if(OrderType()==OP_SELL) {
               // check for trailing stop
               if(InitialTrailingStop>0 
               && OrderProfit() > 0
               )  
                 {             
                  orderbox = StringConcatenate(orderbox, " - pt*InitialTrailingStop: ", (pt*InitialTrailingStop));
                  orderbox = StringConcatenate(orderbox, " - OrderOpenPrice()-asks: ", (OrderOpenPrice()-asks));    
                  if((OrderOpenPrice()-asks)>(pt*InitialTrailingStop))
                    {
                     orderbox = StringConcatenate(orderbox, " - OrderStopLoss(): ", OrderStopLoss());
                     orderbox = StringConcatenate(orderbox, " - asks+pt*TrailingStop: ", (asks+pt*TrailingStop));
                     if((OrderStopLoss()>(asks+pt*TrailingStop)) || (OrderStopLoss()==0))
                       {
                        //Alert(OrderSymbol(), ", Modify Sell");
                        OrderModify(OrderTicket(),OrderOpenPrice(),asks+pt*TrailingStop,OrderTakeProfit(),0,Red);
                        //return(0);
                       }
                    }
                 }
            } 
         }
      }
//----
   return(0);
}


int strength()
{
   double aHigh[ARRSIZE];
   double aLow[ARRSIZE];
   double aBid[ARRSIZE];
   double aAsk[ARRSIZE];
   double aRatio[ARRSIZE];
   double aRange[ARRSIZE];
   double aLookup[ARRSIZE];
   double aStrength[ARRSIZE];
   double point;
   int    index;
   string mySymbol;
      int number = 3;
   double high, low;
   double val, val1, val2, val3, val4, val5, val6, val7, val8, val9, val10, val11, val12, val13;
   int z;
   for (index = 0; index < ARRSIZE; index++) {
      RefreshRates();
      //setalert("index: " + index);
      mySymbol = aPair[index];
      //setalert("mySymbol: " + mySymbol);
      point = MarketInfo(mySymbol, MODE_POINT);
      //setalert("point: " + point);
         high = -1;
         low = -1;
         for (z=0; z<number; z++) {
            if (high == -1) {
               high = iHigh(mySymbol, PERIOD_H4, 0);
            }
            if (iHigh(mySymbol, PERIOD_H4, 0) > high) {
               high = iHigh(mySymbol, PERIOD_H4, 0);
            }
            if (low == -1) {
               low = iLow(mySymbol, PERIOD_H4, 0);
            }
            if (iLow(mySymbol, PERIOD_H4, 0) < low) {
               low = iLow(mySymbol, PERIOD_H4, 0);
            }
            
         }
        aHigh[index] = high;
      aLow[index]      = low; 
      aBid[index]      = MarketInfo(mySymbol,MODE_BID);                 
      aAsk[index]      = MarketInfo(mySymbol,MODE_ASK);                 
      aRange[index]    = MathMax((aHigh[index]-aLow[index])/point,1);      // calculate range today  
      aRatio[index]    = (aBid[index]-aLow[index])/aRange[index]/point;     // calculate pair ratio
      aLookup[index]   = iLookup(aRatio[index]*100);                        // set a pair grade
      aStrength[index] = 9-aLookup[index];
      
      if (current_symbol) {
         if (Symbol() != mySymbol) {
            continue;
         }
      }
       infobox = infobox + "\n" + mySymbol + ": aBid: " + DoubleToStr(aBid[index], MarketInfo(mySymbol, MODE_DIGITS))
            + ", aAsk: " + DoubleToStr(aAsk[index], MarketInfo(mySymbol, MODE_DIGITS))
            + ", Spread: " + MarketInfo(mySymbol, MODE_SPREAD) + ", aLookup: " + aLookup[index] + ", aStrength: " + aStrength[index];
      if (aLookup[index] >= top && aStrength[index] <= bottom) {
         //buy
         val = iCustom(mySymbol, PERIOD_M1, "Heiken_Ashi_Smoothed",2,0);
         val1 = iCustom(mySymbol, PERIOD_M1, "Heiken_Ashi_Smoothed",3,0); 
         val2 = iCustom(mySymbol, PERIOD_M5, "Heiken_Ashi_Smoothed",2,0);
         val3 = iCustom(mySymbol, PERIOD_M5, "Heiken_Ashi_Smoothed",3,0); 
         val4 = iCustom(mySymbol, PERIOD_M15, "Heiken_Ashi_Smoothed",2,0);
         val5 = iCustom(mySymbol, PERIOD_M15, "Heiken_Ashi_Smoothed",3,0); 
         val6 = iCustom(mySymbol, PERIOD_M30, "Heiken_Ashi_Smoothed",2,0);
         val7 = iCustom(mySymbol, PERIOD_M30, "Heiken_Ashi_Smoothed",3,0); 
         val8 = iCustom(mySymbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,0);
         val9 = iCustom(mySymbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,0); 
         val10 = iCustom(mySymbol, PERIOD_H4, "Heiken_Ashi_Smoothed",2,0); 
         val11 = iCustom(mySymbol, PERIOD_H4, "Heiken_Ashi_Smoothed",3,0); 
         infobox = infobox + " - Buy: " + (val < val1) + "," + (val2 < val3) + "," + (val4 < val5) + "," + (val6 < val7) + "," + (val8 < val9) + "," + (val10 < val11);
         infobox = infobox + " - Sell: " + (val > val1) + "," + (val2 > val3) + "," + (val4 > val5) + "," + (val6 > val7) + "," + (val8 > val9) + "," + (val10 > val11);
         infobox = infobox + " - Values: " + val + "," + val1 + "," + val2 + "," + val3 + "," + val4 + "," + val5 + "," + val6 + "," + val7 + "," + val8 + "," + val9 + "," + val10 + "," + val11;
         if (val < val1 && val2 < val3 && val4 < val5 && val6 < val7 && val8 < val9 && val10 < val11) {
            createorder(mySymbol, Period(), 1, TimeframeToString(Period()));
            infobox = infobox + ", Create Buy Order";
         }
      } else if (aLookup[index] <= bottom && aStrength[index] >= top) {
         //sell
         val = iCustom(mySymbol, PERIOD_M1, "Heiken_Ashi_Smoothed",2,0);
         val1 = iCustom(mySymbol, PERIOD_M1, "Heiken_Ashi_Smoothed",3,0); 
         val2 = iCustom(mySymbol, PERIOD_M5, "Heiken_Ashi_Smoothed",2,0);
         val3 = iCustom(mySymbol, PERIOD_M5, "Heiken_Ashi_Smoothed",3,0); 
         val4 = iCustom(mySymbol, PERIOD_M15, "Heiken_Ashi_Smoothed",2,0);
         val5 = iCustom(mySymbol, PERIOD_M15, "Heiken_Ashi_Smoothed",3,0); 
         val6 = iCustom(mySymbol, PERIOD_M30, "Heiken_Ashi_Smoothed",2,0);
         val7 = iCustom(mySymbol, PERIOD_M30, "Heiken_Ashi_Smoothed",3,0); 
         val8 = iCustom(mySymbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,0);
         val9 = iCustom(mySymbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,0); 
         val10 = iCustom(mySymbol, PERIOD_H4, "Heiken_Ashi_Smoothed",2,0); 
         val11 = iCustom(mySymbol, PERIOD_H4, "Heiken_Ashi_Smoothed",3,0); 
         infobox = infobox + " - Sell: " + (val > val1) + "," + (val2 > val3) + "," + (val4 > val5) + "," + (val6 > val7) + "," + (val8 > val9) + "," + (val10 > val11);
         infobox = infobox + " - Buy: " + (val < val1) + "," + (val2 < val3) + "," + (val4 < val5) + "," + (val6 < val7) + "," + (val8 < val9) + "," + (val10 < val11);
         infobox = infobox + " - Values: " + val + "," + val1 + "," + val2 + "," + val3 + "," + val4 + "," + val5 + "," + val6 + "," + val7 + "," + val8 + "," + val9 + "," + val10 + "," + val11;
         if (val > val1 && val2 > val3 && val4 > val5 && val6 > val7 && val8 > val9 && val10 > val11) {
            createorder(mySymbol, Period(), -1, TimeframeToString(Period()));
            infobox = infobox + ", Create Sell Order";
         }
      }
   }
   // calculate all currencies meter         
   aMeter[USD] = NormalizeDouble((aLookup[USDJPY]+aLookup[USDCHF]+aLookup[USDCAD]+aStrength[EURUSD]+aStrength[GBPUSD]+aStrength[AUDUSD]+aStrength[NZDUSD])/7,1);
   aMeter[EUR] = NormalizeDouble((aLookup[EURUSD]+aLookup[EURJPY]+aLookup[EURGBP]+aLookup[EURCHF]+aLookup[EURAUD]+aLookup[EURCAD]+aLookup[EURNZD])/7,1);
   aMeter[GBP] = NormalizeDouble((aLookup[GBPUSD]+aLookup[GBPJPY]+aLookup[GBPCHF]+aStrength[EURGBP]+aLookup[GBPCAD]+aLookup[GBPAUD]+aLookup[GBPNZD])/7,1);
   aMeter[CHF] = NormalizeDouble((aStrength[USDCHF]+aStrength[EURCHF]+aStrength[GBPCHF]+aStrength[AUDCHF]+aLookup[CHFJPY]+aStrength[CADCHF]+aStrength[NZDCHF])/7,1);
   aMeter[CAD] = NormalizeDouble((aStrength[USDCAD]+aLookup[CADCHF]+aStrength[AUDCAD]+aLookup[CADJPY]+aStrength[EURCAD]+aStrength[GBPCAD]+aStrength[NZDCAD])/7,1);
   aMeter[AUD] = NormalizeDouble((aLookup[AUDUSD]+aStrength[EURAUD]+aLookup[AUDCHF]+aLookup[AUDCAD]+aStrength[GBPAUD]+aLookup[AUDNZD]+aLookup[AUDJPY])/7,1);
   aMeter[JPY] = NormalizeDouble((aStrength[USDJPY]+aStrength[EURJPY]+aStrength[GBPJPY]+aStrength[NZDJPY]+aStrength[AUDJPY]+aStrength[CHFJPY]+aStrength[CADJPY])/7,1);     
   aMeter[NZD] = NormalizeDouble((aLookup[NZDUSD]+aStrength[EURNZD]+aStrength[GBPNZD]+aStrength[AUDNZD]+aLookup[NZDCAD]+aLookup[NZDCHF]+aLookup[NZDJPY])/7,1);
   infobox = infobox + "\n" + "Current: USD: " + aMeter[USD] + ", EUR: " + aMeter[EUR] + ", GBP: " + aMeter[GBP]
         + ", CHF: " + aMeter[CHF] + ", CAD: " + aMeter[CAD] + ", AUD: " + aMeter[AUD]
          + ", JPY: " + aMeter[JPY] + ", NZD: " + aMeter[NZD] + "\n";
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


  