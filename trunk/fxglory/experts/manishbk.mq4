//+------------------------------------------------------------------+
//|                                                       manish.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#define MAGICMA  2222

#include <stdlib.mqh>
#include <WinUser32.mqh>
string build = "1.1";
bool NZDUSD = true;
bool USDCHF = true;
bool GBPUSD = true;
bool EURUSD = true;
bool USDJPY = true;
bool USDCAD = true;
bool AUDUSD = true;
bool EURGBP = true;
bool EURAUD = true;
bool EURCHF = true;
bool EURJPY = true;
bool GBPJPY = true;
bool GBPCHF = true;
int auth;
int number = 0;
bool createorders = true;
int maxorders = 13;
string NZDUSD_currency = "NZDUSD";
string USDCHF_currency = "USDCHF";
string GBPUSD_currency = "GBPUSD";
string EURUSD_currency = "EURUSD";
string USDJPY_currency = "USDJPY";
string USDCAD_currency = "USDCAD";
string AUDUSD_currency = "AUDUSD";
string EURGBP_currency = "EURGBP";
string EURAUD_currency = "EURAUD";
string EURCHF_currency = "EURCHF";
string EURJPY_currency = "EURJPY";
string GBPJPY_currency = "GBPJPY";
string GBPCHF_currency = "GBPCHF";

int NZDUSD_number = 0;
int USDCHF_number = 1;
int GBPUSD_number = 2;
int EURUSD_number = 3;
int USDJPY_number = 4;
int USDCAD_number = 5;
int AUDUSD_number= 6;
int EURGBP_number = 7;
int EURAUD_number = 8;
int EURCHF_number = 9;
int EURJPY_number = 10;
int GBPJPY_number = 11;
int GBPCHF_number = 12;

string infobox;
int FastMa = 5;
int SlowMa = 35;
double trigger = 0.25;
int back_test = 5;

double price_max[13];
double price_min[13];
string price_message[13];
double price_constant[13];
double previousprice[13];

int period;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   auth = auth();
   if (auth == 0) {
      Alert("Authorization failed.");
      return (0);
   }

   custom_init();
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

void custom_init()
{
   period = PERIOD_M30;
   price_constant[0] = 100 * MarketInfo(NZDUSD_currency, MODE_POINT);
   price_max[0] = MarketInfo(NZDUSD_currency, MODE_BID) + price_constant[0];
   price_min[0] = MarketInfo(NZDUSD_currency, MODE_BID) - price_constant[0];
   
   price_constant[1] = 100 * MarketInfo(USDCHF_currency, MODE_POINT);
   price_max[1] = MarketInfo(USDCHF_currency, MODE_BID) + price_constant[1];
   price_min[1] = MarketInfo(USDCHF_currency, MODE_BID) - price_constant[1];
   
   price_constant[2] = 100 * MarketInfo(GBPUSD_currency, MODE_POINT);
   price_max[2] = MarketInfo(GBPUSD_currency, MODE_BID) + price_constant[2];
   price_min[2] = MarketInfo(GBPUSD_currency, MODE_BID) - price_constant[2];
   
   price_constant[3] = 100 * MarketInfo(EURUSD_currency, MODE_POINT);
   price_max[3] = MarketInfo(EURUSD_currency, MODE_BID) + price_constant[3];
   price_min[3] = MarketInfo(EURUSD_currency, MODE_BID) - price_constant[3];
   
   price_constant[4] = 100 * MarketInfo(USDJPY_currency, MODE_POINT);
   price_max[4] = MarketInfo(USDJPY_currency, MODE_BID) + price_constant[4];
   price_min[4] = MarketInfo(USDJPY_currency, MODE_BID) - price_constant[4];
   
   price_constant[5] = 100 * MarketInfo(USDCAD_currency, MODE_POINT);
   price_max[5] = MarketInfo(USDCAD_currency, MODE_BID) + price_constant[5];
   price_min[5] = MarketInfo(USDCAD_currency, MODE_BID) - price_constant[5];
   
   price_constant[6] = 100 * MarketInfo(AUDUSD_currency, MODE_POINT);
   price_max[6] = MarketInfo(AUDUSD_currency, MODE_BID) + price_constant[6];
   price_min[6] = MarketInfo(AUDUSD_currency, MODE_BID) - price_constant[6];
   
   price_constant[7] = 100 * MarketInfo(EURGBP_currency, MODE_POINT);
   price_max[7] = MarketInfo(EURGBP_currency, MODE_BID) + price_constant[7];
   price_min[7] = MarketInfo(EURGBP_currency, MODE_BID) - price_constant[7];
   
   price_constant[8] = 100 * MarketInfo(EURAUD_currency, MODE_POINT);
   price_max[8] = MarketInfo(EURAUD_currency, MODE_BID) + price_constant[8];
   price_min[8] = MarketInfo(EURAUD_currency, MODE_BID) - price_constant[8];
   
   price_constant[9] = 100 * MarketInfo(EURCHF_currency, MODE_POINT);
   price_max[9] = MarketInfo(EURCHF_currency, MODE_BID) + price_constant[9];
   price_min[9] = MarketInfo(EURCHF_currency, MODE_BID) - price_constant[9];
   
   price_constant[10] = 100 * MarketInfo(EURJPY_currency, MODE_POINT);
   price_max[10] = MarketInfo(EURJPY_currency, MODE_BID) + price_constant[10];
   price_min[10] = MarketInfo(EURJPY_currency, MODE_BID) - price_constant[10];
   
   price_constant[11] = 100 * MarketInfo(GBPJPY_currency, MODE_POINT);
   price_max[11] = MarketInfo(GBPJPY_currency, MODE_BID) + price_constant[11];
   price_min[11] = MarketInfo(GBPJPY_currency, MODE_BID) - price_constant[11];
   
   price_constant[12] = 100 * MarketInfo(GBPCHF_currency, MODE_POINT);
   price_max[12] = MarketInfo(GBPCHF_currency, MODE_BID) + price_constant[12];
   price_min[12] = MarketInfo(GBPCHF_currency, MODE_BID) - price_constant[12];
   
}

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   auth = auth();
   if (auth == 0) {
      Alert("Authorization failed.");
      return (0);
   }
   infobox = "";
   custom_start();
//----
   return(0);
  }
//+------------------------------------------------------------------+

int auth()
{
   //do some authorization like date time check, username etc.
   return (1);
}

void custom_start()
{
   //current(Symbol(), 0, 0);
  
   checkforclose();
   if (NZDUSD) {
      nzdusd();
   } 
   if (USDCHF) {
      usdchf();
   } 
   if (GBPUSD) {
      gbpusd();
   } 
   if (EURUSD) {
      eurusd();
   } 
   if (USDJPY) {
      usdjpy();
   } 
   if (USDCAD) {
      usdcad();
   } 
   if (AUDUSD) {
      audusd();
   } 
   if (EURGBP) {
      eurgbp();
   } 
   if (EURAUD) {
      euraud();
   }  
   if (EURCHF) {
      eurchf();
   } 
   if (EURJPY) {
      eurjpy();
   } 
   if (GBPJPY) {
      gbpjpy();
   } 
   if (GBPCHF) {
      gbpchf();
   } 

   Comment(infobox);
}


void nzdusd() {
   nzdusd_close();
   strategy(NZDUSD_currency, number, NZDUSD_number);
}
void nzdusd_close() {

}
void usdchf() {
   usdchf_close();
   strategy(USDCHF_currency, number, USDCHF_number);
}
void usdchf_close() {

}
void gbpusd() {
   gbpusd_close();
   strategy(GBPUSD_currency, number, GBPUSD_number);
}
void gbpusd_close() {

}
void eurusd() {
   eurusd_close();
   strategy(EURUSD_currency, number, EURUSD_number);
}
void eurusd_close() {

}
void usdjpy() {
   usdjpy_close();
   strategy(USDJPY_currency, number, USDJPY_number);
}
void usdjpy_close() {

}
void usdcad() {
   usdcad_close();
   strategy(USDCAD_currency, number, USDCAD_number);
}
void usdcad_close() {

}
void audusd() {
   audusd_close();
   strategy(AUDUSD_currency, number, AUDUSD_number);
}
void audusd_close() {

}
void eurgbp() {
   eurgbp_close();
   strategy(EURGBP_currency, number, EURGBP_number);
}
void eurgbp_close() {

}
void euraud() {
   euraud_close();
   strategy(EURAUD_currency, number, EURAUD_number);
}
void euraud_close() {

}
void eurchf() {
   eurchf_close();
   strategy(EURCHF_currency, number, EURCHF_number);
}
void eurchf_close() {

}
void eurjpy() {
   eurjpy_close();
   strategy(EURJPY_currency, number, EURJPY_number);
}
void eurjpy_close() {

}
void gbpjpy() {
   gbpjpy_close();
   strategy(GBPJPY_currency, number, GBPJPY_number);
}
void gbpjpy_close() {

}
void gbpchf() {
   gbpchf_close();
   strategy(GBPCHF_currency, number, GBPCHF_number);
}
void gbpchf_close() {

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
   }
}
string TrendtoString(int P)
{
   switch(P)
   {
      case 1:  return("Buy");
      case -1:  return("Sell");
      case 0: return("Consolidated");
   }
}

double lotsize()
{
   return (0.05);
   double a = (AccountFreeMargin() * 2) / 100; // 2 is riskfactor
   double b = a / 5;
   double c = b / 100;
   double d = NormalizeDouble(c, 2);
   return (d);
}
int current(string symbol, int shift, int cur_num)
{
   double iadx = iADX(symbol, PERIOD_H4, 14, PRICE_CLOSE, MODE_MAIN, shift);
   double iadxpdx = iADX(symbol, PERIOD_H4, 14, PRICE_CLOSE, MODE_PLUSDI, shift);
   double iadxmdx = iADX(symbol, PERIOD_H4, 14, PRICE_CLOSE, MODE_MINUSDI, shift);
   double iadx2 = iADX(symbol, period, 14, PRICE_CLOSE, MODE_MAIN, shift);
   double iadxpdx2 = iADX(symbol, period, 14, PRICE_CLOSE, MODE_PLUSDI, shift);
   double iadxmdx2 = iADX(symbol, period, 14, PRICE_CLOSE, MODE_MINUSDI, shift);
   int trend = 0;
   if (iadxpdx > iadxmdx && iadxpdx2 > iadxmdx2) {
      trend = 1;
   } else if (iadxpdx < iadxmdx && iadxpdx2 < iadxmdx2) {
      trend = -1;
   }
   double high = iHigh(symbol, period, shift+1);
   double low = iLow(symbol, period, shift+1);
   double totalmove = high - low;
   double diff = totalmove / MarketInfo(symbol, MODE_POINT);
   
   double highcur = iHigh(symbol, period, shift);
   double lowcur = iLow(symbol, period, shift);
   double totalmovecur = highcur - lowcur;
   double diffcur = totalmovecur / MarketInfo(symbol, MODE_POINT);
   
   double twentyfivepercent = totalmove / 4;
   double currentopen = iOpen(symbol, period, shift);
   double currentbuy = currentopen + twentyfivepercent;
   double currentsell = currentopen - twentyfivepercent;
   double spread = MarketInfo(symbol, MODE_SPREAD);
   int result = 0;
   if (MarketInfo(symbol, MODE_BID) > price_max[cur_num]) {
      price_max[cur_num] = MarketInfo(symbol, MODE_BID) + price_constant[cur_num];
      price_min[cur_num] = MarketInfo(symbol, MODE_BID) - price_constant[cur_num];
   } else if (MarketInfo(symbol, MODE_BID) < price_min[cur_num]) {
      price_min[cur_num] = MarketInfo(symbol, MODE_BID) - price_constant[cur_num];
      price_max[cur_num] = MarketInfo(symbol, MODE_BID) + price_constant[cur_num];
      
   }
   if (previousprice[cur_num] != currentopen) {
      price_message[cur_num] = "NA";
   }
   if (trend == 1 && spread < 80 && MarketInfo(symbol, MODE_BID) > currentbuy && previousprice[cur_num] != currentopen && diffcur > 30) {
      result = 1;
      previousprice[cur_num] = currentopen;
      price_message[cur_num] = "Buy";
      create_orders(symbol, result, TimeframeToString(period), 0, 0);
   } else if (trend == -1 && spread < 80 && MarketInfo(symbol, MODE_BID) < currentsell && previousprice[cur_num] != currentopen && diffcur > 30) {
      result = -1;
      previousprice[cur_num] = currentopen;
      price_message[cur_num] = "Sell";
      create_orders(symbol, result, TimeframeToString(period), 0, 0);
   }
   

   infobox = StringConcatenate(infobox, "Current Symbol: ", symbol, ":\n");
   infobox = StringConcatenate(infobox, "Ask: ", DoubleToStr(MarketInfo(symbol, MODE_ASK), MarketInfo(symbol, MODE_DIGITS))
      , ", Bid: ", DoubleToStr(MarketInfo(symbol, MODE_BID), MarketInfo(symbol, MODE_DIGITS)));
   infobox = StringConcatenate(infobox, ", price_max: ", DoubleToStr(price_max[cur_num], MarketInfo(symbol, MODE_DIGITS)));
   infobox = StringConcatenate(infobox, ", price_min: ", DoubleToStr(price_min[cur_num], MarketInfo(symbol, MODE_DIGITS)));
   infobox = StringConcatenate(infobox, ", trend: ", TrendtoString(trend), ", Current Bar: ", price_message[cur_num], ", diffcur: ", diffcur, ", iadx: ", iadx);
   infobox = StringConcatenate(infobox, "\n");
   infobox = StringConcatenate(infobox, "Spread: ", spread, ", currentopen: ", DoubleToStr(currentopen, MarketInfo(symbol, MODE_DIGITS))
   , ", current buy: ", DoubleToStr(currentbuy, MarketInfo(symbol, MODE_DIGITS))
   , ", current sell: ", DoubleToStr(currentsell, MarketInfo(symbol, MODE_DIGITS)));
   infobox = StringConcatenate(infobox, "\n");
   //previousprice[cur_num] = currentopen;
}

int strategy(string symbol, int shift, int cur_num)
{
   current(symbol, shift, cur_num);
   return (0);
   /*
   int ewo, ewotrend;
   ewo = ewo(symbol, PERIOD_M1, shift);
   ewotrend = ewotrend(symbol, PERIOD_M1, shift);
   infobox = StringConcatenate(infobox, TimeframeToString(PERIOD_M1), " - EWO: ", ewo, ", EwoTrend: ", ewotrend, ", ");
   ewo = ewo(symbol, PERIOD_M5, shift);
   ewotrend = ewotrend(symbol, PERIOD_M5, shift);
   infobox = StringConcatenate(infobox, TimeframeToString(PERIOD_M5), " - EWO: ", ewo, ", EwoTrend: ", ewotrend, ", ");
   ewo = ewo(symbol, PERIOD_M15, shift);
   ewotrend = ewotrend(symbol, PERIOD_M15, shift);
   infobox = StringConcatenate(infobox, TimeframeToString(PERIOD_M15), " - EWO: ", ewo, ", EwoTrend: ", ewotrend, ", ");
   ewo = ewo(symbol, PERIOD_M30, shift);
   ewotrend = ewotrend(symbol, PERIOD_M30, shift);
   infobox = StringConcatenate(infobox, TimeframeToString(PERIOD_M30), " - EWO: ", ewo, ", EwoTrend: ", ewotrend, ", ");
   infobox = StringConcatenate(infobox, "\n");
   ewo = ewo(symbol, PERIOD_H1, shift);
   ewotrend = ewotrend(symbol, PERIOD_H1, shift);
   infobox = StringConcatenate(infobox, TimeframeToString(PERIOD_H1), " - EWO: ", ewo, ", EwoTrend: ", ewotrend, ", ");
   ewo = ewo(symbol, PERIOD_H4, shift);
   ewotrend = ewotrend(symbol, PERIOD_H4, shift);
   infobox = StringConcatenate(infobox, TimeframeToString(PERIOD_H4), " - EWO: ", ewo, ", EwoTrend: ", ewotrend, ", ");
   ewo = ewo(symbol, PERIOD_D1, shift);
   ewotrend = ewotrend(symbol, PERIOD_D1, shift);
   infobox = StringConcatenate(infobox, TimeframeToString(PERIOD_D1), " - EWO: ", ewo, ", EwoTrend: ", ewotrend, "\n");
   */
}

int CalculateCurrentMaxOrders()
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


int CalculateCurrentOrders(string symbol)
  {
   int cnt=0;
//----
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==symbol) // && OrderMagicNumber()==MAGICMA
        {
         cnt++;
        }
     }
//---- return orders volume
   return (cnt);
  }


int create_orders(string symbol, int type, string mes, double tp, double sl)
{
   if (IsTradeAllowed()==false)
   {
      Print("Trade is not allowed, please enable trades.");
      return(0);  
    }

   if(AccountFreeMargin()<(1000*lotsize()))
   {
      Print("We have no money. Free Margin = ", AccountFreeMargin());
      return(0);  
    }
   if (!createorders) {
      Print(StringConcatenate(symbol, ", create orders disabled"));
      return (0);
   }
   if (type == 0) {
      Print(StringConcatenate(symbol, ", no orders processed as buy and sell condition does not exists for ", mes));
      return (0);
   }
   
   int morders = CalculateCurrentMaxOrders();
   if (morders >= maxorders) {
      Print(StringConcatenate(symbol, ", Max Orders Reached for symbol "));
      return (0);
   }
   int orders = CalculateCurrentOrders(symbol);
   if (orders > 0) {
      //Print(StringConcatenate("Order Already created for symbol ", symbol));
      return (0);
   }
   if (type == 1) {
      mes = StringConcatenate("MN, ", mes, ", B: ", build);
      order(symbol, OP_BUY, MarketInfo(symbol,MODE_ASK), mes, 0, 0);
      Alert("Buy order created for symbol: ", symbol);
   } else if (type == -1) {
      mes = StringConcatenate("MN, ", mes, ", B: ", build);
      order(symbol, OP_SELL, MarketInfo(symbol,MODE_BID), mes, 0, 0);
      Alert("Sell order created for symbol: ", symbol);
   }
}

int order(string symbol, int type, double amount, string mes, double tp, double sl)
{
   int error;
   int ticket=OrderSend(symbol,type,lotsize(),amount,3,sl,tp,mes,MAGICMA,0,CLR_NONE);
   if(ticket<1)
   {
      error=GetLastError();
      Alert("Error = ",ErrorDescription(error));
      Sleep(1000);
      order(symbol, type, amount, mes, tp, sl);
      return (0);
   }

   OrderPrint();
   return (ticket);
}

void checkforclose() {
   double diff, sl, amt;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      //if(OrderMagicNumber()!=MAGICMA) continue;


         if (OrderProfit() > 0) {
            if (OrderType()==OP_BUY) {
               diff = (MarketInfo(OrderSymbol(), MODE_BID) - OrderOpenPrice()) / MarketInfo(OrderSymbol(), MODE_POINT);
               if (diff > 200) {
                  sl = OrderStopLoss();
                  amt = MarketInfo(OrderSymbol(), MODE_BID)-(MarketInfo(OrderSymbol(), MODE_POINT)*(diff - 100));
                  if (sl == 0) {
                     sl = 1000 * MarketInfo(OrderSymbol(), MODE_POINT);
                  }
                  if (amt > sl) {
                     OrderModify(OrderTicket(),OrderOpenPrice(),amt,0,0,Blue);
                  }
               }
            } else if (OrderType()==OP_SELL) {
               diff = (OrderOpenPrice() - MarketInfo(OrderSymbol(), MODE_ASK)) / MarketInfo(OrderSymbol(), MODE_POINT);
               if (diff > 200) {
                  sl = OrderStopLoss();
                  amt = MarketInfo(OrderSymbol(), MODE_ASK) + (MarketInfo(OrderSymbol(), MODE_POINT)*(diff - 100));
                  if (sl == 0) {
                     sl = 1000 * MarketInfo(OrderSymbol(), MODE_POINT);
                  }
                  if (amt < sl) {
                     OrderModify(OrderTicket(),OrderOpenPrice(),amt,0,0,Blue);
                  }
               }
            }
         }
     }
}
   /*
int ewo(string symbol, int timeframe, int shift)
{
   double MA5 = iMA(symbol, timeframe, 5, 0, MODE_SMA, PRICE_MEDIAN, shift);
   double MA35 = iMA(symbol, timeframe, 35, 0, MODE_SMA, PRICE_MEDIAN, shift);
   double Buffer = MA5 - MA35;
   if(Buffer > 0)
      return (1);
   else if (Buffer < 0)
      return (-1);
   else
      return (0);
}

int ewotrend(string symbol, int timeframe, int shift)
{
   int trend = 0;
   double llv = iMA(symbol, timeframe, FastMa, 0, MODE_SMA, PRICE_MEDIAN, shift)-iMA(symbol, timeframe, SlowMa, 0, MODE_SMA, PRICE_MEDIAN, shift);
   double hhv=iMA(symbol, timeframe, FastMa, 0, MODE_SMA, PRICE_MEDIAN, shift)-iMA(symbol, timeframe, SlowMa, 0, MODE_SMA, PRICE_MEDIAN, shift);
   for(int i=shift;i<=shift+back_test ;i++)
   { 
      llv=MathMin(iMA(symbol, timeframe, FastMa, 0, MODE_SMA, PRICE_MEDIAN, i)-iMA(symbol, timeframe, SlowMa, 0, MODE_SMA, PRICE_MEDIAN, i),llv);
      hhv=MathMax(iMA(symbol, timeframe, FastMa, 0, MODE_SMA, PRICE_MEDIAN, i)-iMA(symbol, timeframe, SlowMa, 0, MODE_SMA, PRICE_MEDIAN, i),hhv);
   } 
   if((hhv == (iMA(symbol, timeframe, FastMa, 0, MODE_SMA, PRICE_MEDIAN, shift)-iMA(symbol, timeframe, SlowMa, 0, MODE_SMA, PRICE_MEDIAN, shift))&& trend == 0))
      trend=1;
   else if((llv == (iMA(symbol, timeframe, FastMa, 0, MODE_SMA, PRICE_MEDIAN, shift)-iMA(symbol, timeframe, SlowMa, 0, MODE_SMA, PRICE_MEDIAN, shift))&& trend == 0))
      trend=-1;
   else if((llv<0 && trend == -1 && (iMA(symbol, timeframe, FastMa, 0, MODE_SMA, PRICE_MEDIAN, shift)-iMA(symbol, timeframe, SlowMa, 0, MODE_SMA, PRICE_MEDIAN, shift))>-trigger*llv))
      trend=1;
   else if((hhv>0 && trend == 1 && (iMA(symbol, timeframe, FastMa, 0, MODE_SMA, PRICE_MEDIAN, shift)-iMA(symbol, timeframe, SlowMa, 0, MODE_SMA, PRICE_MEDIAN, shift))<-trigger*hhv))
      trend=-1;
   return (trend);
}
int ewn(string symbol, int timeframe, int shift)
{
   //initialization
   int MaxBars = 200;
   int RetracementBars = 100;
   int EWPeriod = 10;
   double EW1 = 0, EW2 = 0, EW3 = 0, EW4 = 0, EW5 = 0;
   double LastEW1 = 0, LastEW2 = 0, LastEW3 = 0, LastEW4 = 0, LastEW5 = 0;
   double EW0MARK = 0, EW1MARK = 0, EW2MARK = 0, EW3MARK = 0, EW4MARK = 0, EW5MARK = 0;
   double EW1MARKTIME = 0, EW2MARKTIME = 0, EW3MARKTIME = 0, EW4MARKTIME = 0, EW5MARKTIME = 0;
   double EW1MARKARROW = 0, EW2MARKARROW = 0, EW3MARKARROW = 0, EW4MARKARROW = 0, EW5MARKARROW = 0;
   double EW1MARKBAR = 0, EW2MARKBAR = 0, EW3MARKBAR = 0, EW4MARKBAR = 0, EW5MARKBAR = 0;
   double WaveAngle = 0;
   double MaxPriceBar = 0, MinPriceBar = 0;
   double MaxPrice = 0, MinPrice = 0;
   
   MaxPriceBar = Highest (MODE_CLOSE, MaxBars+1, MaxBars*2);
   MinPriceBar = Lowest (MODE_CLOSE, MaxBars+1, MaxBars*2);
   if (MaxPriceBar < MinPriceBar) WaveAngle = 1;
   else WaveAngle = 2;
   
   MaxPrice = iClose(symbol,timeframe,MaxPriceBar);
   MinPrice = iClose(symbol,timeframe,MinPriceBar);
}
*/

