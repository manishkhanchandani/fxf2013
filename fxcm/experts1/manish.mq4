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
string build = "1.4";
double lots = 0.50;
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

double price_max[13];
double price_min[13];
string price_message[13];
double price_constant[13];
double previousprice[13];
double momentum[13];
double momentum_close[13];
double tp_price[13];
double sl_price[13];

int period, period_high;
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
   period = PERIOD_M15;
   period_high = PERIOD_M30;
   /*
   price_constant[0] = 100 * MarketInfo(NZDUSD_currency, MODE_POINT);
   price_max[0] = MarketInfo(NZDUSD_currency, MODE_BID) + price_constant[0];
   price_min[0] = MarketInfo(NZDUSD_currency, MODE_BID) - price_constant[0];
   previousprice[0] = iOpen(NZDUSD_currency, period, number);
   
   price_constant[1] = 100 * MarketInfo(USDCHF_currency, MODE_POINT);
   price_max[1] = MarketInfo(USDCHF_currency, MODE_BID) + price_constant[1];
   price_min[1] = MarketInfo(USDCHF_currency, MODE_BID) - price_constant[1];
   previousprice[1] = iOpen(USDCHF_currency, period, number);
   
   price_constant[2] = 100 * MarketInfo(GBPUSD_currency, MODE_POINT);
   price_max[2] = MarketInfo(GBPUSD_currency, MODE_BID) + price_constant[2];
   price_min[2] = MarketInfo(GBPUSD_currency, MODE_BID) - price_constant[2];
   previousprice[2] = iOpen(GBPUSD_currency, period, number);
   
   price_constant[3] = 100 * MarketInfo(EURUSD_currency, MODE_POINT);
   price_max[3] = MarketInfo(EURUSD_currency, MODE_BID) + price_constant[3];
   price_min[3] = MarketInfo(EURUSD_currency, MODE_BID) - price_constant[3];
   previousprice[3] = iOpen(EURUSD_currency, period, number);
   
   price_constant[4] = 100 * MarketInfo(USDJPY_currency, MODE_POINT);
   price_max[4] = MarketInfo(USDJPY_currency, MODE_BID) + price_constant[4];
   price_min[4] = MarketInfo(USDJPY_currency, MODE_BID) - price_constant[4];
   previousprice[4] = iOpen(USDJPY_currency, period, number);
   
   price_constant[5] = 100 * MarketInfo(USDCAD_currency, MODE_POINT);
   price_max[5] = MarketInfo(USDCAD_currency, MODE_BID) + price_constant[5];
   price_min[5] = MarketInfo(USDCAD_currency, MODE_BID) - price_constant[5];
   previousprice[5] = iOpen(USDCAD_currency, period, number);
   
   price_constant[6] = 100 * MarketInfo(AUDUSD_currency, MODE_POINT);
   price_max[6] = MarketInfo(AUDUSD_currency, MODE_BID) + price_constant[6];
   price_min[6] = MarketInfo(AUDUSD_currency, MODE_BID) - price_constant[6];
   previousprice[6] = iOpen(AUDUSD_currency, period, number);
   
   price_constant[7] = 100 * MarketInfo(EURGBP_currency, MODE_POINT);
   price_max[7] = MarketInfo(EURGBP_currency, MODE_BID) + price_constant[7];
   price_min[7] = MarketInfo(EURGBP_currency, MODE_BID) - price_constant[7];
   previousprice[7] = iOpen(EURGBP_currency, period, number);
   
   price_constant[8] = 100 * MarketInfo(EURAUD_currency, MODE_POINT);
   price_max[8] = MarketInfo(EURAUD_currency, MODE_BID) + price_constant[8];
   price_min[8] = MarketInfo(EURAUD_currency, MODE_BID) - price_constant[8];
   previousprice[8] = iOpen(EURAUD_currency, period, number);
   
   price_constant[9] = 100 * MarketInfo(EURCHF_currency, MODE_POINT);
   price_max[9] = MarketInfo(EURCHF_currency, MODE_BID) + price_constant[9];
   price_min[9] = MarketInfo(EURCHF_currency, MODE_BID) - price_constant[9];
   previousprice[9] = iOpen(EURCHF_currency, period, number);
   
   price_constant[10] = 100 * MarketInfo(EURJPY_currency, MODE_POINT);
   price_max[10] = MarketInfo(EURJPY_currency, MODE_BID) + price_constant[10];
   price_min[10] = MarketInfo(EURJPY_currency, MODE_BID) - price_constant[10];
   previousprice[10] = iOpen(EURJPY_currency, period, number);
   
   price_constant[11] = 100 * MarketInfo(GBPJPY_currency, MODE_POINT);
   price_max[11] = MarketInfo(GBPJPY_currency, MODE_BID) + price_constant[11];
   price_min[11] = MarketInfo(GBPJPY_currency, MODE_BID) - price_constant[11];
   previousprice[11] = iOpen(GBPJPY_currency, period, number);
   
   price_constant[12] = 100 * MarketInfo(GBPCHF_currency, MODE_POINT);
   price_max[12] = MarketInfo(GBPCHF_currency, MODE_BID) + price_constant[12];
   price_min[12] = MarketInfo(GBPCHF_currency, MODE_BID) - price_constant[12];
   previousprice[12] = iOpen(GBPCHF_currency, period, number);*/
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
  
   //checkforclose();
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
   checkforclose(NZDUSD_currency, NZDUSD_number);
}
void usdchf() {
   usdchf_close();
   strategy(USDCHF_currency, number, USDCHF_number);
}
void usdchf_close() {
   checkforclose(USDCHF_currency, USDCHF_number);
}
void gbpusd() {
   gbpusd_close();
   strategy(GBPUSD_currency, number, GBPUSD_number);
}
void gbpusd_close() {
   checkforclose(GBPUSD_currency, GBPUSD_number);
}
void eurusd() {
   eurusd_close();
   strategy(EURUSD_currency, number, EURUSD_number);
}
void eurusd_close() {
   checkforclose(EURUSD_currency, EURUSD_number);
}
void usdjpy() {
   usdjpy_close();
   strategy(USDJPY_currency, number, USDJPY_number);
}
void usdjpy_close() {
   checkforclose(USDJPY_currency, USDJPY_number);
}
void usdcad() {
   usdcad_close();
   strategy(USDCAD_currency, number, USDCAD_number);
}
void usdcad_close() {
   checkforclose(USDCAD_currency, USDCAD_number);
}
void audusd() {
   audusd_close();
   strategy(AUDUSD_currency, number, AUDUSD_number);
}
void audusd_close() {
   checkforclose(AUDUSD_currency, AUDUSD_number);
}
void eurgbp() {
   eurgbp_close();
   strategy(EURGBP_currency, number, EURGBP_number);
}
void eurgbp_close() {
   checkforclose(EURGBP_currency, EURGBP_number);
}
void euraud() {
   euraud_close();
   strategy(EURAUD_currency, number, EURAUD_number);
}
void euraud_close() {
   checkforclose(EURAUD_currency, EURAUD_number);
}
void eurchf() {
   eurchf_close();
   strategy(EURCHF_currency, number, EURCHF_number);
}
void eurchf_close() {
   checkforclose(EURCHF_currency, EURCHF_number);
}
void eurjpy() {
   eurjpy_close();
   strategy(EURJPY_currency, number, EURJPY_number);
}
void eurjpy_close() {
   checkforclose(EURJPY_currency, EURJPY_number);
}
void gbpjpy() {
   gbpjpy_close();
   strategy(GBPJPY_currency, number, GBPJPY_number);
}
void gbpjpy_close() {
   checkforclose(GBPJPY_currency, GBPJPY_number);
}
void gbpchf() {
   gbpchf_close();
   strategy(GBPCHF_currency, number, GBPCHF_number);
}
void gbpchf_close() {
   checkforclose(GBPCHF_currency, GBPCHF_number);
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
   return (lots);
   double a = (AccountFreeMargin() * 2) / 100; // 2 is riskfactor
   double b = a / 5;
   double c = b / 100;
   double d = NormalizeDouble(c, 2);
   return (d);
}
double calculate_strategy_ema(string symbol, int MA_Length, int Period_of_Time, int shift)
{
   double ema = iMA(symbol,Period_of_Time,MA_Length,0,MODE_EMA,PRICE_CLOSE,shift);
   return (ema);
}
int current(string symbol, int shift, int cur_num)
{

   /*double iadx = iADX(symbol, PERIOD_H1, 14, PRICE_CLOSE, MODE_MAIN, shift);
   double iadxpdx = iADX(symbol, PERIOD_H1, 14, PRICE_CLOSE, MODE_PLUSDI, shift);
   double iadxmdx = iADX(symbol, PERIOD_H1, 14, PRICE_CLOSE, MODE_MINUSDI, shift);
   double iadx2 = iADX(symbol, period, 14, PRICE_CLOSE, MODE_MAIN, shift);
   double iadxpdx2 = iADX(symbol, period, 14, PRICE_CLOSE, MODE_PLUSDI, shift);
   double iadxmdx2 = iADX(symbol, period, 14, PRICE_CLOSE, MODE_MINUSDI, shift);*/

   double current = calculate_strategy_ema(symbol, 25, period_high, shift);
   double toplevel = calculate_strategy_ema(symbol, 50, period_high, shift);
   double current2 = calculate_strategy_ema(symbol, 25, period, shift);
   double toplevel2 = calculate_strategy_ema(symbol, 50, period, shift);
   double mom = iMomentum(symbol,period,14,PRICE_CLOSE,shift);
    
   int trend = 0;
   if (current > toplevel && current2 > toplevel2) {
      trend = 1;
   } else if (current < toplevel && current2 < toplevel2) {
      trend = -1;
   }
   /*
   double high = iHigh(symbol, period, shift+1);
   double low = iLow(symbol, period, shift+1);
   double totalmove = high - low;
   double diff = totalmove / MarketInfo(symbol, MODE_POINT);
   */
   double highcur = iHigh(symbol, period, shift);
   double lowcur = iLow(symbol, period, shift);
   double totalmovecur = highcur - lowcur;
   double diffcur = totalmovecur / MarketInfo(symbol, MODE_POINT);
   
   double currentopen = iOpen(symbol, period, shift);
   //double twentyfivepercent = totalmove / 4;
   //double currentbuy = currentopen + twentyfivepercent;
   //double currentsell = currentopen - twentyfivepercent;
   double spread = MarketInfo(symbol, MODE_SPREAD);
   int result = 0;
   /*if (MarketInfo(symbol, MODE_BID) > price_max[cur_num]) {
      price_max[cur_num] = MarketInfo(symbol, MODE_BID) + price_constant[cur_num];
      price_min[cur_num] = MarketInfo(symbol, MODE_BID) - price_constant[cur_num];
   } else if (MarketInfo(symbol, MODE_BID) < price_min[cur_num]) {
      price_min[cur_num] = MarketInfo(symbol, MODE_BID) - price_constant[cur_num];
      price_max[cur_num] = MarketInfo(symbol, MODE_BID) + price_constant[cur_num];
      
   }*/
   if (previousprice[cur_num] != currentopen) {
      price_message[cur_num] = "NA";
   }
   if (trend == 1 && spread < 80 && previousprice[cur_num] != currentopen && diffcur > 30 && mom > momentum[cur_num]
      && MarketInfo(symbol, MODE_BID) == iHigh(symbol, period, shift)) {
      result = 1;
      previousprice[cur_num] = currentopen;
      price_message[cur_num] = "Buy";
      create_orders(symbol, result, TimeframeToString(period), 0, 0, cur_num);
   } else if (trend == -1 && spread < 80 && previousprice[cur_num] != currentopen && diffcur > 30 && mom < momentum[cur_num]
      && MarketInfo(symbol, MODE_BID) == iLow(symbol, period, shift)) {
      result = -1;
      previousprice[cur_num] = currentopen;
      price_message[cur_num] = "Sell";
      create_orders(symbol, result, TimeframeToString(period), 0, 0, cur_num);
   }
   

   infobox = StringConcatenate(infobox, "Current Symbol: ", symbol, ":\n");
   infobox = StringConcatenate(infobox, "Ask: ", DoubleToStr(MarketInfo(symbol, MODE_ASK), MarketInfo(symbol, MODE_DIGITS))
      , ", Bid: ", DoubleToStr(MarketInfo(symbol, MODE_BID), MarketInfo(symbol, MODE_DIGITS))
      , ", SL: ", DoubleToStr(sl_price[cur_num], MarketInfo(symbol, MODE_DIGITS))
      );
   infobox = StringConcatenate(infobox, ", price_max: ", DoubleToStr(price_max[cur_num], MarketInfo(symbol, MODE_DIGITS)));
   infobox = StringConcatenate(infobox, ", price_min: ", DoubleToStr(price_min[cur_num], MarketInfo(symbol, MODE_DIGITS)));
   infobox = StringConcatenate(infobox, ", trend: ", TrendtoString(trend), ", Current Bar: ", price_message[cur_num], ", diffcur: ", diffcur);
   infobox = StringConcatenate(infobox, "\n");
   infobox = StringConcatenate(infobox, "Spread: ", spread, ", momentum: ", DoubleToStr(mom, MarketInfo(symbol, MODE_DIGITS))
   , ", past momentum: ", DoubleToStr(momentum[cur_num], MarketInfo(symbol, MODE_DIGITS))
   , ", current: ", DoubleToStr(current, MarketInfo(symbol, MODE_DIGITS)), ", toplevel: ", DoubleToStr(toplevel, MarketInfo(symbol, MODE_DIGITS)));
   infobox = StringConcatenate(infobox, "\n");
   //previousprice[cur_num] = currentopen;
   //post
   momentum[cur_num] = iMomentum(symbol,period,14,PRICE_CLOSE,shift);
}

int strategy(string symbol, int shift, int cur_num)
{
   current(symbol, shift, cur_num);
   return (0);
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


int create_orders(string symbol, int type, string mes, double tp, double sl, int cur_num)
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
      order(symbol, OP_BUY, mes, 0, 0, cur_num);
      Alert("Buy order created for symbol: ", symbol);
   } else if (type == -1) {
      mes = StringConcatenate("MN, ", mes, ", B: ", build);
      order(symbol, OP_SELL, mes, 0, 0, cur_num);
      Alert("Sell order created for symbol: ", symbol);
   }
}

int order(string symbol, int type, string mes, double tp, double sl, int cur_num)
{
   int error;
   double amount;
   sl_price[cur_num] = 0;
   tp_price[cur_num] = 0;
   if (type == OP_BUY) {
      amount = MarketInfo(symbol,MODE_ASK);
      tp = amount + 500*MarketInfo(symbol,MODE_POINT);
      sl = amount - 1000*MarketInfo(symbol,MODE_POINT);
      }
   else if (type == OP_SELL) {
      amount = MarketInfo(symbol,MODE_BID);
      tp = amount - 500*MarketInfo(symbol,MODE_POINT);
      sl = amount + 1000*MarketInfo(symbol,MODE_POINT);
      
      }
   int ticket=OrderSend(symbol,type,lotsize(),amount,3,sl,tp,mes,MAGICMA,0,CLR_NONE);
   if(ticket<1)
   {
      error=GetLastError();
      Alert("Error = ",ErrorDescription(error), ", amt: ", amount, ", symbol: ", symbol);
      Sleep(1000);
      order(symbol, type, mes, tp, sl, cur_num);
      return (0);
   }

   OrderPrint();
   return (ticket);
}

void checkforclose(string symbol, int cur_num) {
   double diff, sl, amt;
   int shift = 0;
   int trend, result;
   double current, toplevel, current2, toplevel2, mom, highcur, lowcur, totalmovecur, diffcur, currentopen, spread;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=symbol) continue;


         if (OrderProfit() > 0) {
            if (OrderType()==OP_BUY) {
               if (sl_price[cur_num] > 0 && MarketInfo(OrderSymbol(), MODE_BID) < sl_price[cur_num]) {
                  sl_price[cur_num] = 0;
                  Alert("Close position for symbol: ", OrderSymbol());
                  //OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(), MODE_BID),3,White);
                  //return (0);
               }
               diff = (MarketInfo(OrderSymbol(), MODE_BID) - OrderOpenPrice()) / MarketInfo(OrderSymbol(), MODE_POINT);
               amt = MarketInfo(OrderSymbol(), MODE_BID)-(MarketInfo(OrderSymbol(), MODE_POINT)*(diff - 100));
               if (sl_price[cur_num] == 0) {
                   sl_price[cur_num] = MarketInfo(OrderSymbol(), MODE_BID) - 1000 * MarketInfo(OrderSymbol(), MODE_POINT);
               }
               if (diff > 200 && amt > sl_price[cur_num]) {
                  sl_price[cur_num] = amt;
                  /*sl = OrderStopLoss();
                  amt = MarketInfo(OrderSymbol(), MODE_BID)-(MarketInfo(OrderSymbol(), MODE_POINT)*(diff - 100));
                  if (sl == 0) {
                     sl = 1000 * MarketInfo(OrderSymbol(), MODE_POINT);
                  }
                  Print(OrderSymbol(), " has sl of ", DoubleToStr(sl, MarketInfo(OrderSymbol(), MODE_DIGITS)), ", amt: ", DoubleToStr(amt, MarketInfo(OrderSymbol(), MODE_DIGITS)));
                  
                  if (amt > sl) {
                     OrderModify(OrderTicket(),OrderOpenPrice(),amt,OrderTakeProfit(),0,Blue);
                  }*/
               }
            } else if (OrderType()==OP_SELL) {
               if (sl_price[cur_num] > 0 && MarketInfo(OrderSymbol(), MODE_ASK) > sl_price[cur_num]) {
                  sl_price[cur_num] = 0;
                  Alert("Close position for symbol: ", OrderSymbol());
                  //OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(), MODE_ASK),3,White);
                  //return (0);
               }
               diff = (OrderOpenPrice() - MarketInfo(OrderSymbol(), MODE_ASK)) / MarketInfo(OrderSymbol(), MODE_POINT);
               amt = MarketInfo(OrderSymbol(), MODE_ASK) + (MarketInfo(OrderSymbol(), MODE_POINT)*(diff - 100));
               if (sl_price[cur_num] == 0) {
                   sl_price[cur_num] = MarketInfo(OrderSymbol(), MODE_ASK) + 1000 * MarketInfo(OrderSymbol(), MODE_POINT);
               }
               if (diff > 200 && amt < sl_price[cur_num]) {
                  sl_price[cur_num] = amt;
                  /*sl = OrderStopLoss();
                  amt = MarketInfo(OrderSymbol(), MODE_ASK) + (MarketInfo(OrderSymbol(), MODE_POINT)*(diff - 100));
                  if (sl == 0) {
                     sl = 1000 * MarketInfo(OrderSymbol(), MODE_POINT);
                  }
                  Print(OrderSymbol(), " has sl of ", DoubleToStr(sl, MarketInfo(OrderSymbol(), MODE_DIGITS)), ", amt: ", DoubleToStr(amt, MarketInfo(OrderSymbol(), MODE_DIGITS)));
                  if (amt < sl) {
                     OrderModify(OrderTicket(),OrderOpenPrice(),amt,OrderTakeProfit(),0,Blue);
                  }*/
               }
            }
         } else if (OrderProfit() < 0) {
            spread = MarketInfo(symbol, MODE_SPREAD);
            current = calculate_strategy_ema(symbol, 25, period_high, shift);
            toplevel = calculate_strategy_ema(symbol, 50, period_high, shift);
            current2 = calculate_strategy_ema(symbol, 25, period, shift);
            toplevel2 = calculate_strategy_ema(symbol, 50, period, shift);
            mom = iMomentum(symbol,period,14,PRICE_CLOSE,shift);
    
            trend = 0;
            if (current > toplevel && current2 > toplevel2) {
               trend = 1;
            } else if (current < toplevel && current2 < toplevel2) {
               trend = -1;
            }
            highcur = iHigh(symbol, period, shift);
            lowcur = iLow(symbol, period, shift);
            totalmovecur = highcur - lowcur;
            diffcur = totalmovecur / MarketInfo(symbol, MODE_POINT);
   
            currentopen = iOpen(symbol, period, shift);
              // Print(OrderSymbol(), " has loss of ", OrderProfit());
               //Print(OrderSymbol(), " = ", OrderOpenPrice());
               //Print(OrderSymbol(), " = ", MarketInfo(OrderSymbol(), MODE_BID) - OrderOpenPrice());
            if (OrderType()==OP_BUY) {
               if (trend == -1 && spread < 80 && diffcur > 30 && mom < momentum_close[cur_num]
                  && MarketInfo(symbol, MODE_BID) == iLow(symbol, period, shift)) {
                  result = -1;
                  OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(), MODE_BID),3,White);
                  create_orders(symbol, result, TimeframeToString(period), 0, 0, cur_num);
               }
            } else if (OrderType()==OP_SELL) {
               if (trend == 1 && spread < 80 && diffcur > 30 && mom > momentum[cur_num]
               && MarketInfo(symbol, MODE_BID) == iHigh(symbol, period, shift)) {
                  result = 1;
                  OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(), MODE_ASK),3,White);
                  create_orders(symbol, result, TimeframeToString(period), 0, 0, cur_num);
               } 
            }            
            momentum_close[cur_num] = iMomentum(symbol,period,14,PRICE_CLOSE,shift);
         }
     }
}