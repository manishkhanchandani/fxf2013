//+------------------------------------------------------------------+
//|                                              cu_time_blaster.mq4 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"


#include <stdlib.mqh>
#include <WinUser32.mqh>
#define MAGICMA  216
extern double Lots = 0.05;
extern int InitialTrailingStop = 150;
extern int TrailingStop = 150;
extern int stoploss = 0;
extern int takeprofit = 400;
extern int gmt_offset = 0;
extern string particular_symbol = "";
extern string particular_currency = "";
extern string do_not_use_symbol = "";
extern string do_not_use_currency = "";
extern bool create_order = true;
extern int pending_margin = 1000;
extern int maxorders = 1;
extern bool hedging = false;
extern bool markethours = false;
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
                        "USDCHF","GBPUSD","EURUSD","USDJPY","USDCAD","AUDUSD",
                        "EURGBP","EURAUD","EURCHF","EURJPY","GBPCHF","CADJPY",
                        "GBPJPY","AUDNZD","AUDCAD","AUDCHF","AUDJPY","CHFJPY",
                        "EURNZD","EURCAD","CADCHF","NZDJPY","NZDUSD","GBPCAD",
                        "GBPNZD","GBPAUD","NZDCHF","NZDCAD"
                        };
   string aMajor[PAIRSIZE] = {"USD","EUR","GBP","CHF","CAD","AUD","JPY","NZD"};
   string aOrder[ORDER]    = {"BUY ","SELL "};

   double aMeter[PAIRSIZE];

   string gSymbol[8][8];
double previousMeter[PAIRSIZE];
string infobox;          
int condition_type[8];  
int condition_opposite_currency[8];  
string condition_strength[8];     
string condition_symbol[8];  

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
   get_symbol();
   initGraph();
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
      cleanup_pending_orders();
      deletepending();
      hour = Hour() - gmt_offset;
      infobox="Hour: " + Hour() + ", hour new: " + hour + "\n";
      infobox = StringConcatenate(infobox, "Lots: ", Lots, ", InitialTrailingStop: ", InitialTrailingStop,
         ", TrailingStop: ", TrailingStop,
         ", stoploss: ", stoploss,
         ", takeprofit: ", takeprofit, 
         ", gmt_offset: ", gmt_offset, "\n",
         ", particular_symbol: ", particular_symbol,
         ", particular_currency: ", particular_currency,
         ", create_order: ", create_order, "\n",
         ", pending_margin: ", pending_margin,
         ", maxorders: ", maxorders,
         ", hedging: ", hedging,
         ", markethours: ", markethours, ", top: ", top, ", bottom: ", bottom, "\n");
      if (markethours) {
         if ((hour == 0 && Minute() > 15) || hour == 1 || hour == 7 || hour == 8 || hour == 13 || hour == 14) {
   
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
      return (0);
   }

   if (IsTradeAllowed()==false)
      return (0);

   if (!create_order)
      return (0);

   
   if (markethours) {
      if ((hour == 0 && Minute() > 15) || hour == 1 || hour == 7 || hour == 8 || hour == 13 || hour == 14) {
   
      } else {
         return (0);
      }
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
      price = asks + (50 * pt);
      if (stoploss > 0)
         sl = price - (stoploss * pt);
      if (takeprofit > 0)
         tp = price + (takeprofit * pt);
      ticket=OrderSend(symbol,OP_BUYSTOP,Lots,price,3,sl,tp,message+", Time Blaster2",MAGICMA,0,Green);
      //ticket=OrderSend(symbol,OP_BUY,Lots,asks,3,sl,tp,message+", Time Blaster",MAGICMA,0,Green);
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
      price = bids - (50 * pt);
      if (stoploss > 0)
         sl = price + (stoploss * pt);
      if (takeprofit > 0)
         tp = price - (takeprofit * pt);

       ticket=OrderSend(symbol,OP_SELLSTOP,Lots,price,3,sl,tp,message+", Time Blaster2",MAGICMA,0,Red);
       //ticket=OrderSend(symbol,OP_SELL,Lots,bids,3,sl,tp,message+", Time Blaster",MAGICMA,0,Red);
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

/*
int CalculateCurrentMaxOrders()
  {
   int corders=0;
//----
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderMagicNumber()==MAGICMA)
        {
         if(OrderType()==OP_BUY || OrderType()==OP_SELL || OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP)
            corders++;
        }
     }
         return(corders);
}*/
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
            if(OrderSymbol()==symbol && (OrderType() == OP_BUY || OrderType() == OP_BUYSTOP))// && OrderMagicNumber()==MAGICMA
              {
               cnt++;
              }
          } else if (type == OP_SELL) {
            if(OrderSymbol()==symbol && (OrderType() == OP_SELL || OrderType() == OP_SELLSTOP))// && OrderMagicNumber()==MAGICMA
              {
               cnt++;
              }
          }
        }
    } else {
      for(i=0;i<OrdersTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
         if(OrderSymbol()==symbol)// && OrderMagicNumber()==MAGICMA
           {
            cnt++;
           }
        }
    }
   return (cnt);
  }

void cleanup_pending_orders()
{
   double bids, asks, pt, digit;
   pendingorderbox = "";
   pendingorderbox = StringConcatenate(pendingorderbox, "\nCHECKING PENDING ORDERS:");
   int cnt, ticket, total;
   string deletemsg;
   total=OrdersTotal();
   bool result;
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP) {
         bids = MarketInfo(OrderSymbol(), MODE_BID);
         asks = MarketInfo(OrderSymbol(), MODE_ASK);
         pt = MarketInfo(OrderSymbol(), MODE_POINT);
         digit = MarketInfo(OrderSymbol(), MODE_DIGITS);
         deletemsg = "";
         if(OrderType()==OP_BUYSTOP) {
            if ((OrderOpenPrice() - asks)/pt > 100) {
               deletemsg = ", Delete Pending Buy Order";
               result=OrderDelete(OrderTicket());
               if(result!=TRUE) Print("LastError = ", GetLastError());
            }
            pendingorderbox = StringConcatenate(pendingorderbox, "\nSymbol: ", OrderSymbol(), ", Price: ", DoubleToStr(OrderOpenPrice(), digit)
               , ", (OrderOpenPrice() - bids)/pt: "
               , (OrderOpenPrice() - asks)/pt
               , deletemsg
            ); 
         } else if(OrderType()==OP_SELLSTOP) {
            if ((bids-OrderOpenPrice())/pt > 100) {
               deletemsg = ", Delete Pending Sell Order";
               result=OrderDelete(OrderTicket());
               if(result!=TRUE) Print("LastError = ", GetLastError());
            }
            pendingorderbox = StringConcatenate(pendingorderbox, "\nSymbol: ", OrderSymbol(), ", Price: ", DoubleToStr(OrderOpenPrice(), digit)
               , ", (asks-OrderOpenPrice())/pt: "
               , (bids-OrderOpenPrice())/pt
               , deletemsg
            ); 
         }
      }
   } 
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
      //aHigh[index] = iHigh(mySymbol, PERIOD_D1, 0);
      //aLow[index]      = iLow(mySymbol, PERIOD_D1, 0); 
      aBid[index]      = MarketInfo(mySymbol,MODE_BID);                 
      aAsk[index]      = MarketInfo(mySymbol,MODE_ASK);                 
      aRange[index]    = MathMax((aHigh[index]-aLow[index])/point,1);      // calculate range today  
      aRatio[index]    = (aBid[index]-aLow[index])/aRange[index]/point;     // calculate pair ratio
      aLookup[index]   = iLookup(aRatio[index]*100);                        // set a pair grade
      aStrength[index] = 9-aLookup[index];                                  // set a pair strengh
      setalert(mySymbol + ": ahigh: " + aHigh[index] + ", alow: " + aLow[index] + ", aBid: " + aBid[index]
          + ", aAsk: " + aAsk[index] + ", aRange: " + aRange[index] + ", aRatio: " + aRatio[index] + ", aLookup: " + aLookup[index]
          + ", aStrength: " + aStrength[index]
      );    
   }
   // calculate all currencies meter         
   /*wrong
   aMeter[USD] = NormalizeDouble((aLookup[USDJPY]+aLookup[USDCHF]+aLookup[USDCAD]+aStrength[EURUSD]+aStrength[GBPUSD]+aStrength[AUDUSD]+aStrength[NZDUSD])/7,1);
   aMeter[EUR] = NormalizeDouble((aLookup[EURUSD]+aLookup[EURJPY]+aLookup[EURGBP]+aLookup[EURCHF]+aLookup[EURAUD]+aLookup[EURCAD]+aLookup[EURNZD])/7,1);
   aMeter[GBP] = NormalizeDouble((aLookup[GBPUSD]+aLookup[GBPJPY]+aLookup[GBPCHF]+aStrength[EURGBP]+aStrength[GBPCAD]+aStrength[GBPAUD]+aStrength[GBPNZD])/7,1);
   aMeter[CHF] = NormalizeDouble((aStrength[USDCHF]+aStrength[EURCHF]+aStrength[GBPCHF]+aStrength[AUDCHF]+aStrength[CHFJPY]+aStrength[CADCHF]+aStrength[NZDCHF])/7,1);
   aMeter[CAD] = NormalizeDouble((aStrength[USDCAD]+aStrength[CADCHF]+aStrength[AUDCAD]+aStrength[CADJPY]+aStrength[EURCAD]+aStrength[GBPCAD]+aStrength[NZDCAD])/7,1);
   aMeter[AUD] = NormalizeDouble((aLookup[AUDUSD]+aStrength[EURAUD]+aStrength[AUDCHF]+aStrength[AUDCAD]+aStrength[GBPAUD]+aStrength[AUDNZD]+aStrength[AUDJPY])/7,1);
   aMeter[JPY] = NormalizeDouble((aStrength[USDJPY]+aStrength[EURJPY]+aStrength[GBPJPY]+aStrength[NZDJPY]+aStrength[AUDJPY]+aStrength[CHFJPY]+aStrength[CADJPY])/7,1);     
   aMeter[NZD] = NormalizeDouble((aLookup[NZDUSD]+aStrength[EURNZD]+aStrength[GBPNZD]+aStrength[AUDNZD]+aLookup[NZDCAD]+aLookup[NZDCHF]+aLookup[NZDJPY])/7,1);
   */
   aMeter[USD] = NormalizeDouble((aLookup[USDJPY]+aLookup[USDCHF]+aLookup[USDCAD]+aStrength[EURUSD]+aStrength[GBPUSD]+aStrength[AUDUSD]+aStrength[NZDUSD])/7,1);
   aMeter[EUR] = NormalizeDouble((aLookup[EURUSD]+aLookup[EURJPY]+aLookup[EURGBP]+aLookup[EURCHF]+aLookup[EURAUD]+aLookup[EURCAD]+aLookup[EURNZD])/7,1);
   aMeter[GBP] = NormalizeDouble((aLookup[GBPUSD]+aLookup[GBPJPY]+aLookup[GBPCHF]+aStrength[EURGBP]+aLookup[GBPCAD]+aLookup[GBPAUD]+aLookup[GBPNZD])/7,1);
   aMeter[CHF] = NormalizeDouble((aStrength[USDCHF]+aStrength[EURCHF]+aStrength[GBPCHF]+aStrength[AUDCHF]+aLookup[CHFJPY]+aStrength[CADCHF]+aStrength[NZDCHF])/7,1);
   aMeter[CAD] = NormalizeDouble((aStrength[USDCAD]+aLookup[CADCHF]+aStrength[AUDCAD]+aLookup[CADJPY]+aStrength[EURCAD]+aStrength[GBPCAD]+aStrength[NZDCAD])/7,1);
   aMeter[AUD] = NormalizeDouble((aLookup[AUDUSD]+aStrength[EURAUD]+aLookup[AUDCHF]+aLookup[AUDCAD]+aStrength[GBPAUD]+aLookup[AUDNZD]+aLookup[AUDJPY])/7,1);
   aMeter[JPY] = NormalizeDouble((aStrength[USDJPY]+aStrength[EURJPY]+aStrength[GBPJPY]+aStrength[NZDJPY]+aStrength[AUDJPY]+aStrength[CHFJPY]+aStrength[CADJPY])/7,1);     
   aMeter[NZD] = NormalizeDouble((aLookup[NZDUSD]+aStrength[EURNZD]+aStrength[GBPNZD]+aStrength[AUDNZD]+aLookup[NZDCAD]+aLookup[NZDCHF]+aLookup[NZDJPY])/7,1);
   
   //setalert("USD: " + aMeter[USD] + ", EUR: " + aMeter[EUR] + ", GBP: " + aMeter[GBP]
         //+ ", CHF: " + aMeter[CHF] + ", CAD: " + aMeter[CAD] + ", AUD: " + aMeter[AUD]
          //+ ", JPY: " + aMeter[JPY] + ", NZD: " + aMeter[NZD]
     //); 

   objectBlank();   
   paintUSD(aMeter[USD]);
   paintEUR(aMeter[EUR]);
   paintGBP(aMeter[GBP]);
   paintCHF(aMeter[CHF]);
   paintCAD(aMeter[CAD]);
   paintAUD(aMeter[AUD]);
   paintJPY(aMeter[JPY]);
   paintNZD(aMeter[NZD]);
   paintLine();

   double val, val2, val3;
   int x;
   for (x = 0; x < PAIRSIZE; x++) {
      calculate(x);
      infobox = infobox + "\nNumber: " + x +
         ", NumberCur: " + aMajor[x] +
         ", Type: " + condition_type[x] +
         ", opposite_currency: " + condition_opposite_currency[x] +
         ", strength: " + condition_strength[x] +
         ", symbol: " + condition_symbol[x];
      if (condition_type[x] != 0) {
         //val = iCCI(condition_symbol[x],PERIOD_M30,45,PRICE_CLOSE,0);
         //val2 = iCCI(condition_symbol[x],PERIOD_M30,45,PRICE_CLOSE,1);
         //infobox = infobox + ", CCI: "+ val +  ", CCI (1): " + val2;
         if (condition_type[x] == 1) {
            val3 = AccountFreeMarginCheck(condition_symbol[x], OP_BUY, Lots);
            infobox = infobox + ", Margin Remaining: " +val3;
         } else if (condition_type[x] == -1) {
            val3 = AccountFreeMarginCheck(condition_symbol[x], OP_SELL, Lots);
            infobox = infobox + ", Margin Remaining: " +val3;
         }
         /*if (val2 < val && val > 100) {
            infobox = infobox + ", Buy";
         } else if (val2 > val && val < -100) {
            infobox = infobox + ", Sell";
         } else {
            infobox = infobox + ", CCI Nil";
         }*/
         
         if (particular_symbol != "") {
            if (condition_symbol[x] != particular_symbol) {
               continue;
            }
         }
         if (particular_currency != "") {
            if (particular_currency != aMajor[x]) {
               continue;
            }
         }
         
         if (do_not_use_symbol != "") {
            if (condition_symbol[x] == do_not_use_symbol) {
               continue;
            }
         }
         if (do_not_use_currency != "") {
            if (do_not_use_currency == aMajor[x]) {
               continue;
            }
         }
         if (condition_type[x] == 1) {
            createorder(condition_symbol[x], Period(), 1, TimeframeToString(Period()));
            infobox = infobox + ", Create Buy Order";
         } else if (condition_type[x] == -1) {
            createorder(condition_symbol[x], Period(), -1, TimeframeToString(Period()));
            infobox = infobox + ", Create Sell Order";
         } else {
            infobox = infobox + ", Wait";
         }
      }
   }

   previousMeter[USD] = aMeter[USD];
   previousMeter[EUR] = aMeter[EUR];
   previousMeter[GBP] = aMeter[GBP];
   previousMeter[CHF] = aMeter[CHF];
   previousMeter[CAD] = aMeter[CAD];
   previousMeter[AUD] = aMeter[AUD];
   previousMeter[JPY] = aMeter[JPY];
   previousMeter[NZD] = aMeter[NZD];
   
   infobox = infobox + "\nUSD: " + aMeter[USD] + ", EUR: " + aMeter[EUR] + ", GBP: " + aMeter[GBP]
         + ", CHF: " + aMeter[CHF] + ", CAD: " + aMeter[CAD] + ", AUD: " + aMeter[AUD]
          + ", JPY: " + aMeter[JPY] + ", NZD: " + aMeter[NZD]+ "\nPrevious USD: " + previousMeter[USD] + ", EUR: " + previousMeter[EUR] + ", GBP: " + previousMeter[GBP]
         + ", CHF: " + previousMeter[CHF] + ", CAD: " + previousMeter[CAD] + ", AUD: " + previousMeter[AUD]
          + ", JPY: " + previousMeter[JPY] + ", NZD: " + previousMeter[NZD]; 
   return (0);
}
void setalert(string msg)
{
   Print(msg);
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


void initGraph()
  {
   ObjectsDeleteAll(0,OBJ_LABEL);

   objectCreate("usd_1",150,43);
   objectCreate("usd_2",150,35);
   objectCreate("usd_3",150,27);
   objectCreate("usd_4",150,19);
   objectCreate("usd_5",150,11);
   objectCreate("usd",152,12,"USD",7,"Arial Narrow",SkyBlue);
   objectCreate("usdp",154,21,DoubleToStr(9,1),8,"Arial Narrow",Silver);
   
   objectCreate("eur_1",130,43);
   objectCreate("eur_2",130,35);
   objectCreate("eur_3",130,27);
   objectCreate("eur_4",130,19);
   objectCreate("eur_5",130,11);
   objectCreate("eur",132,12,"EUR",7,"Arial Narrow",SkyBlue);
   objectCreate("eurp",134,21,DoubleToStr(9,1),8,"Arial Narrow",Silver);
   
   objectCreate("gbp_1",110,43);
   objectCreate("gbp_2",110,35);
   objectCreate("gbp_3",110,27);
   objectCreate("gbp_4",110,19);
   objectCreate("gbp_5",110,11);
   objectCreate("gbp",112,12,"GBP",7,"Arial Narrow",SkyBlue);
   objectCreate("gbpp",114,21,DoubleToStr(9,1),8,"Arial Narrow",Silver);
   
   objectCreate("chf_1",90,43);
   objectCreate("chf_2",90,35);
   objectCreate("chf_3",90,27);
   objectCreate("chf_4",90,19);
   objectCreate("chf_5",90,11);
   objectCreate("chf",92,12,"CHF",7,"Arial Narrow",SkyBlue);
   objectCreate("chfp",94,21,DoubleToStr(9,1),8,"Arial Narrow",Silver);

   objectCreate("cad_1",70,43);
   objectCreate("cad_2",70,35);   
   objectCreate("cad_3",70,27);
   objectCreate("cad_4",70,19);
   objectCreate("cad_5",70,11);
   objectCreate("cad",72,12,"CAD",7,"Arial Narrow",SkyBlue);
   objectCreate("cadp",74,21,DoubleToStr(9,1),8,"Arial Narrow",Silver);
   
   objectCreate("aud_1",50,43);
   objectCreate("aud_2",50,35);
   objectCreate("aud_3",50,27);
   objectCreate("aud_4",50,19);
   objectCreate("aud_5",50,11);
   objectCreate("aud",52,12,"AUD",7,"Arial Narrow",SkyBlue);
   objectCreate("audp",54,21,DoubleToStr(9,1),8,"Arial Narrow",Silver);

   objectCreate("jpy_1",30,43);
   objectCreate("jpy_2",30,35);
   objectCreate("jpy_3",30,27);
   objectCreate("jpy_4",30,19);
   objectCreate("jpy_5",30,11);
   objectCreate("jpy",33,12,"JPY",7,"Arial Narrow",SkyBlue);
   objectCreate("jpyp",34,21,DoubleToStr(9,1),8,"Arial Narrow",Silver);
   
   objectCreate("nzd_1",10,43);
   objectCreate("nzd_2",10,35);
   objectCreate("nzd_3",10,27);
   objectCreate("nzd_4",10,19);
   objectCreate("nzd_5",10,11);
   objectCreate("nzd",13,12,"NZD",7,"Arial Narrow",SkyBlue);
   objectCreate("nzdp",14,21,DoubleToStr(9,1),8,"Arial Narrow",Silver);

   objectCreate("line",10,6,"-----------------------------------",10,"Arial",DimGray);  
   objectCreate("line1",10,27,"-----------------------------------",10,"Arial",DimGray);  
   objectCreate("line2",10,69,"-----------------------------------",10,"Arial",DimGray);
   objectCreate("sign",11,1,"Manish Khanchandani",8,"Arial Narrow",DimGray);
   WindowRedraw();
  }
//+------------------------------------------------------------------+
void objectCreate(string name,int x,int y,string text="-",int size=42,
                  string font="Arial",color colour=CLR_NONE)
  {
   ObjectCreate(name,OBJ_LABEL,0,0,0);
   ObjectSet(name,OBJPROP_CORNER,3);
   ObjectSet(name,OBJPROP_COLOR,colour);
   ObjectSet(name,OBJPROP_XDISTANCE,x);
   ObjectSet(name,OBJPROP_YDISTANCE,y);
   ObjectSetText(name,text,size,font,colour);
  }

void objectBlank()
  {
   ObjectSet("usd_1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("usd_2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("usd_3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("usd_4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("usd_5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("usd",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("usdp",OBJPROP_COLOR,CLR_NONE);

   ObjectSet("eur_1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("eur_2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("eur_3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("eur_4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("eur_5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("eur",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("eurp",OBJPROP_COLOR,CLR_NONE);

   ObjectSet("gbp_1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("gbp_2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("gbp_3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("gbp_4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("gbp_5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("gbp",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("gbpp",OBJPROP_COLOR,CLR_NONE);

   ObjectSet("chf_1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("chf_2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("chf_3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("chf_4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("chf_5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("chf",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("chfp",OBJPROP_COLOR,CLR_NONE);

   ObjectSet("cad_1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("cad_2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("cad_3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("cad_4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("cad_5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("cad",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("cadp",OBJPROP_COLOR,CLR_NONE);

   ObjectSet("aud_1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("aud_2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("aud_3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("aud_4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("aud_5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("aud",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("audp",OBJPROP_COLOR,CLR_NONE);

   ObjectSet("jpy_1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("jpy_2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("jpy_3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("jpy_4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("jpy_5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("jpy",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("jpyp",OBJPROP_COLOR,CLR_NONE);
   
   ObjectSet("nzd_1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("nzd_2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("nzd_3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("nzd_4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("nzd_5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("nzd",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("nzdp",OBJPROP_COLOR,CLR_NONE);

   ObjectSet("line1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("line2",OBJPROP_COLOR,CLR_NONE); 
  }
  
void paintUSD(double value)
  {
   if (value > 0) ObjectSet("usd_5",OBJPROP_COLOR,Red);
   if (value > 2) ObjectSet("usd_4",OBJPROP_COLOR,Orange);
   if (value > 4) ObjectSet("usd_3",OBJPROP_COLOR,Gold);   
   if (value > 6) ObjectSet("usd_2",OBJPROP_COLOR,YellowGreen);
   if (value > 7) ObjectSet("usd_1",OBJPROP_COLOR,Lime);
   ObjectSet("usd",OBJPROP_COLOR,SkyBlue);
   ObjectSetText("usdp",DoubleToStr(value,1),8,"Arial Narrow",Silver);
  }

void paintEUR(double value)
  {
   if (value > 0) ObjectSet("eur_5",OBJPROP_COLOR,Red);
   if (value > 2) ObjectSet("eur_4",OBJPROP_COLOR,Orange);
   if (value > 4) ObjectSet("eur_3",OBJPROP_COLOR,Gold);   
   if (value > 6) ObjectSet("eur_2",OBJPROP_COLOR,YellowGreen);
   if (value > 7) ObjectSet("eur_1",OBJPROP_COLOR,Lime);
   ObjectSet("eur",OBJPROP_COLOR,SkyBlue);
   ObjectSetText("eurp",DoubleToStr(value,1),8,"Arial Narrow",Silver);
  }

void paintGBP(double value)
  {
   if (value > 0) ObjectSet("gbp_5",OBJPROP_COLOR,Red);
   if (value > 2) ObjectSet("gbp_4",OBJPROP_COLOR,Orange);
   if (value > 4) ObjectSet("gbp_3",OBJPROP_COLOR,Gold);   
   if (value > 6) ObjectSet("gbp_2",OBJPROP_COLOR,YellowGreen);
   if (value > 7) ObjectSet("gbp_1",OBJPROP_COLOR,Lime);
   ObjectSet("gbp",OBJPROP_COLOR,SkyBlue);
   ObjectSetText("gbpp",DoubleToStr(value,1),8,"Arial Narrow",Silver);
  }

void paintCHF(double value)
  {
   if (value > 0) ObjectSet("chf_5",OBJPROP_COLOR,Red);
   if (value > 2) ObjectSet("chf_4",OBJPROP_COLOR,Orange);
   if (value > 4) ObjectSet("chf_3",OBJPROP_COLOR,Gold);   
   if (value > 6) ObjectSet("chf_2",OBJPROP_COLOR,YellowGreen);
   if (value > 7) ObjectSet("chf_1",OBJPROP_COLOR,Lime);
   ObjectSet("chf",OBJPROP_COLOR,SkyBlue);
   ObjectSetText("chfp",DoubleToStr(value,1),8,"Arial Narrow",Silver);
  }

void paintCAD(double value)
  {
   if (value > 0) ObjectSet("cad_5",OBJPROP_COLOR,Red);
   if (value > 2) ObjectSet("cad_4",OBJPROP_COLOR,Orange);
   if (value > 4) ObjectSet("cad_3",OBJPROP_COLOR,Gold);   
   if (value > 6) ObjectSet("cad_2",OBJPROP_COLOR,YellowGreen);
   if (value > 7) ObjectSet("cad_1",OBJPROP_COLOR,Lime);
   ObjectSet("cad",OBJPROP_COLOR,SkyBlue);
   ObjectSetText("cadp",DoubleToStr(value,1),8,"Arial Narrow",Silver);
  }

void paintAUD(double value)
  {
   if (value > 0) ObjectSet("aud_5",OBJPROP_COLOR,Red);
   if (value > 2) ObjectSet("aud_4",OBJPROP_COLOR,Orange);
   if (value > 4) ObjectSet("aud_3",OBJPROP_COLOR,Gold);   
   if (value > 6) ObjectSet("aud_2",OBJPROP_COLOR,YellowGreen);
   if (value > 7) ObjectSet("aud_1",OBJPROP_COLOR,Lime);
   ObjectSet("aud",OBJPROP_COLOR,SkyBlue);
   ObjectSetText("audp",DoubleToStr(value,1),8,"Arial Narrow",Silver);
  }

void paintJPY(double value)
  {
   if (value > 0) ObjectSet("jpy_5",OBJPROP_COLOR,Red);
   if (value > 2) ObjectSet("jpy_4",OBJPROP_COLOR,Orange);
   if (value > 4) ObjectSet("jpy_3",OBJPROP_COLOR,Gold);   
   if (value > 6) ObjectSet("jpy_2",OBJPROP_COLOR,YellowGreen);
   if (value > 7) ObjectSet("jpy_1",OBJPROP_COLOR,Lime);
   ObjectSet("jpy",OBJPROP_COLOR,SkyBlue);
   ObjectSetText("jpyp",DoubleToStr(value,1),8,"Arial Narrow",Silver);
  }
  
void paintNZD(double value)
  {
   if (value > 0) ObjectSet("nzd_5",OBJPROP_COLOR,Red);
   if (value > 2) ObjectSet("nzd_4",OBJPROP_COLOR,Orange);
   if (value > 4) ObjectSet("nzd_3",OBJPROP_COLOR,Gold);   
   if (value > 6) ObjectSet("nzd_2",OBJPROP_COLOR,YellowGreen);
   if (value > 7) ObjectSet("nzd_1",OBJPROP_COLOR,Lime);
   ObjectSet("nzd",OBJPROP_COLOR,SkyBlue);
   ObjectSetText("nzdp",DoubleToStr(value,1),8,"Arial Narrow",Silver);
  }

void paintLine()
  {
   ObjectSet("line1",OBJPROP_COLOR,DimGray);
   ObjectSet("line2",OBJPROP_COLOR,DimGray);
  }


void calculate(int number)
  {
      int x;
      int tmpCur; 
      int type;
      string current_currency1, current_currency2;
      double tmp = -1;
      string symbol;
      string base_symbol = aMajor[number];
      if (aMeter[number] >= top) {
         for (x = 0; x < PAIRSIZE; x++) {
            if (x == number) continue;
            if (tmp == -1) {
               tmp = aMeter[x];
            }
            if (tmp >= aMeter[x] && aMeter[x] <= bottom && (previousMeter[number] < top || previousMeter[x] > bottom)) {
               tmp = aMeter[x];
               tmpCur = x;
               symbol = gSymbol[number][x];
               current_currency1 = StringSubstr(symbol, 0, 3);
               current_currency2 = StringSubstr(symbol, 3, 3);
               if (base_symbol == current_currency1) {
                  type = 1;
               } else {
                  type = -1;
               }
            }
         }
         condition_type[number] = type;
         condition_opposite_currency[number] = tmpCur;
         condition_strength[number] = aMeter[number] + "/" + tmp;
         condition_symbol[number] = symbol;
      } else if (aMeter[number] <= bottom) {
         for (x = 0; x < PAIRSIZE; x++) {
            if (x == number) continue;
            if (tmp == -1) {
               tmp = aMeter[x];
            }
            if (tmp <= aMeter[x] && aMeter[x] >=  top && (previousMeter[number] > bottom || previousMeter[x] < top)) {
               tmp = aMeter[x];
               tmpCur = x;
               symbol = gSymbol[number][x];
               current_currency1 = StringSubstr(symbol, 0, 3);
               current_currency2 = StringSubstr(symbol, 3, 3);
               if (base_symbol == current_currency1) {
                  type = -1;
               } else {
                  type = 1;
               }
            }
         }
         condition_type[number] = type;
         condition_opposite_currency[number] = tmpCur;
         condition_strength[number] = aMeter[number] + "/" + tmp;
         condition_symbol[number] = symbol;
      } else {
         condition_type[number] = 0;
         condition_opposite_currency[number] = 0;
         condition_strength[number] = "";
         condition_symbol[number] = "";
      }
  }
  
  
void get_symbol()
{

   gSymbol[0][1] = "EURUSD";
   gSymbol[0][2] = "GBPUSD";
   gSymbol[0][3] = "USDCHF";
   gSymbol[0][4] = "USDCAD";
   gSymbol[0][5] = "AUDUSD";
   gSymbol[0][6] = "USDJPY";
   gSymbol[0][7] = "NZDUSD";
   
   gSymbol[1][0] = "EURUSD";
   gSymbol[1][2] = "EURGBP";
   gSymbol[1][3] = "EURCHF";
   gSymbol[1][4] = "EURCAD";
   gSymbol[1][5] = "EURAUD";
   gSymbol[1][6] = "EURJPY";
   gSymbol[1][7] = "EURNZD";
   
   gSymbol[2][0] = "GBPUSD";
   gSymbol[2][1] = "EURGBP";
   gSymbol[2][3] = "GBPCHF";
   gSymbol[2][4] = "GBPCAD";
   gSymbol[2][5] = "GBPAUD";
   gSymbol[2][6] = "GBPJPY";
   gSymbol[2][7] = "GBPNZD";
   
   gSymbol[3][0] = "USDCHF";
   gSymbol[3][1] = "EURCHF";
   gSymbol[3][2] = "GBPCHF";
   gSymbol[3][4] = "CADCHF";
   gSymbol[3][5] = "AUDCHF";
   gSymbol[3][6] = "CHFJPY";
   gSymbol[3][7] = "NZDCHF";
   
   gSymbol[4][0] = "USDCAD";
   gSymbol[4][1] = "EURCAD";
   gSymbol[4][2] = "GBPCAD";
   gSymbol[4][3] = "CADCHF";
   gSymbol[4][5] = "AUDCAD";
   gSymbol[4][6] = "CADJPY";
   gSymbol[4][7] = "NZDCAD";
   
   gSymbol[5][0] = "AUDUSD";
   gSymbol[5][1] = "EURAUD";
   gSymbol[5][2] = "GBPAUD";
   gSymbol[5][3] = "AUDCHF";
   gSymbol[5][4] = "AUDCAD";
   gSymbol[5][6] = "AUDJPY";
   gSymbol[5][7] = "AUDNZD";
   
   gSymbol[6][0] = "USDJPY";
   gSymbol[6][1] = "EURJPY";
   gSymbol[6][2] = "GBPJPY";
   gSymbol[6][3] = "CHFJPY";
   gSymbol[6][4] = "CADJPY";
   gSymbol[6][5] = "AUDJPY";
   gSymbol[6][7] = "NZDJPY";
   
   gSymbol[7][0] = "NZDUSD";
   gSymbol[7][1] = "EURNZD";
   gSymbol[7][2] = "GBPNZD";
   gSymbol[7][3] = "NZDCHF";
   gSymbol[7][4] = "NZDCAD";
   gSymbol[7][5] = "AUDNZD";
   gSymbol[7][6] = "NZDJPY";
}


int deletepending()
  {   
   int orders = CalculateCurrentRealMaxOrders();
   if (orders < maxorders)
   {
       return (0);
   }
   bool   result;
   int    cmd,total;
//----
   total=OrdersTotal();
//----
   for(int i=0; i<total; i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
      if(OrderMagicNumber()!=MAGICMA) continue;
         cmd=OrderType();
         //---- pending orders only are considered
         if(cmd!=OP_BUY && cmd!=OP_SELL)
           {
            //---- print selected order
            OrderPrint();
            //---- delete first pending order
            result=OrderDelete(OrderTicket());
            if(result!=TRUE) Print("LastError = ", GetLastError());
           }
        }
      else { Print( "Error when order select ", GetLastError()); break; }
     }
//----
   return(0);
  }
  
  