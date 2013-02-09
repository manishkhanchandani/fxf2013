//+------------------------------------------------------------------+
//|                                                       nzdfun.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"
#include <stdlib.mqh>
#include <WinUser32.mqh>

#define MAGICMA  16384

//Step 1: Initializing variables
extern double Lots = 1.0;
extern double custom_tp = 400;
extern double custom_sl = 200;

extern bool strategy_macd1 = false;
extern bool strategy_macd2 = false;
extern bool strategy_ichmuko = true;

extern bool UseAlerts = true;
extern bool UseEmailAlerts = true;
extern bool UsePrintAlerts = true;
extern int period_m1_tpsl = 30;
extern int period_m5_tpsl = 50;
extern int period_m15_tpsl = 60;
extern int period_m30_tpsl = 90;
extern int period_h1_tpsl = 150;
extern int period_h4_tpsl = 200;
extern int period_d1_tpsl = 300;
extern int maxorders = 1;
extern double TrailingStop = 30;

string infobox;
double stoploss[28];
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
   infobox = "";
   check_for_close();
   
   //A. checks: availability of funds on the account etc...
  if(AccountFreeMargin()<(1000*Lots))
  {
   Print("We have no money. Free Margin = ", AccountFreeMargin());
   return(0);  
  }

  strategy();
  Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+
int strategy()
{
   string symbol = Symbol();
   int timeperiod = Period();
   if (strategy_macd1) {
      strategy_macd1(symbol, timeperiod);
   }
   else if (strategy_macd2) {
      strategy_macd2(symbol, timeperiod);
   } else if (strategy_ichmuko) {
      strategy_ichmuko(symbol, timeperiod);   
   }
}
int check_for_close()
{
   return (0);
   if (OrdersTotal() > 0) {
      infobox = StringConcatenate(infobox, "\nChecking for closure");
      for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderMagicNumber()==MAGICMA)
        {
         infobox = StringConcatenate(infobox, "\nChecking for symbol: ", OrderSymbol(), ", order profit is: ", OrderProfit());
         infobox = StringConcatenate(infobox, "\nOrder StopLoss: ", OrderStopLoss());
         if(OrderType()==OP_BUY)   // long position is opened
            {
               if (MarketInfo(OrderSymbol(),MODE_BID) < stoploss[0] && stoploss[0] != 0) {
                  OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),3,Violet); 
               }
               infobox = StringConcatenate(infobox, "\nChecking for buy for symbol: ", OrderSymbol());
               if(TrailingStop>0)  
               {                 
                  infobox = StringConcatenate(infobox, "\nDifference in Prices: ", (MarketInfo(OrderSymbol(),MODE_BID)-OrderOpenPrice()));
                  infobox = StringConcatenate(infobox, "\nPoint x TrailingStop: ", (MarketInfo(OrderSymbol(),MODE_POINT)*TrailingStop));
                  if(MarketInfo(OrderSymbol(),MODE_BID)-OrderOpenPrice()>MarketInfo(OrderSymbol(),MODE_POINT)*TrailingStop)
                  {
                     infobox = StringConcatenate(infobox, "\nBid - Point x Trailing Stop: ", (MarketInfo(OrderSymbol(),MODE_BID)-MarketInfo(OrderSymbol(),MODE_POINT)*TrailingStop));
                     if(OrderStopLoss()<MarketInfo(OrderSymbol(),MODE_BID)-MarketInfo(OrderSymbol(),MODE_POINT)*TrailingStop)
                     {
                        stoploss[0] = MarketInfo(OrderSymbol(),MODE_BID)-MarketInfo(OrderSymbol(),MODE_POINT)*TrailingStop;
                        //OrderModify(OrderTicket(),OrderOpenPrice(),MarketInfo(OrderSymbol(),MODE_BID)-MarketInfo(OrderSymbol(),MODE_POINT)*TrailingStop,OrderTakeProfit(),0,Green);
                        //return(0);
                     }
                  }
               }//end if
            } else if (OrderType() == OP_SELL) {
               
               if (MarketInfo(OrderSymbol(),MODE_ASK) > stoploss[0] && stoploss[0] != 0) {
                  OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3,Violet);
               }
               infobox = StringConcatenate(infobox, "\nChecking for sell for symbol: ", OrderSymbol());
               if(TrailingStop>0)  
                 {                 
                  infobox = StringConcatenate(infobox, "\nDifference in Prices: ", (OrderOpenPrice()-MarketInfo(OrderSymbol(),MODE_ASK)));
                  infobox = StringConcatenate(infobox, "\nPoint x TrailingStop: ", (MarketInfo(OrderSymbol(),MODE_POINT)*TrailingStop));
                  if((OrderOpenPrice()-MarketInfo(OrderSymbol(),MODE_ASK))>(MarketInfo(OrderSymbol(),MODE_POINT)*TrailingStop))
                    {
                     infobox = StringConcatenate(infobox, "\nBid - Point x Trailing Stop: ", (MarketInfo(OrderSymbol(),MODE_ASK)+MarketInfo(OrderSymbol(),MODE_POINT)*TrailingStop));
                     if((OrderStopLoss()>(MarketInfo(OrderSymbol(),MODE_ASK)+MarketInfo(OrderSymbol(),MODE_POINT)*TrailingStop)) || (OrderStopLoss()==0))
                       {
                        stoploss[0] = MarketInfo(OrderSymbol(),MODE_ASK)+MarketInfo(OrderSymbol(),MODE_POINT)*TrailingStop;
                        //OrderModify(OrderTicket(),OrderOpenPrice(),MarketInfo(OrderSymbol(),MODE_ASK)+MarketInfo(OrderSymbol(),MODE_POINT)*TrailingStop,OrderTakeProfit(),0,Red);
                        //return(0);
                       }
                    }
                 }
            }
        }
     }
   }
}

int strategy_ichmuko(string symbol, int timeperiod)
{
   infobox = StringConcatenate(infobox, "\nStrategy: Ichimuko");
  int orders;
  orders = CalculateCurrentMaxOrders();
  if (orders >= maxorders)
  {
      return (0);
  }
  orders = CalculateCurrentOrders(symbol);
  if (orders > 0)
  {
      return (0);
  }
   double tenkan_sen = iIchimoku(symbol, timeperiod, 9, 26, 52, MODE_TENKANSEN, 1);
   double kijunsen = iIchimoku(symbol, timeperiod, 9, 26, 52, MODE_KIJUNSEN, 1);
   double senkouspana = iIchimoku(symbol, timeperiod, 9, 26, 52, MODE_SENKOUSPANA, 1);
   double senkouspanb = iIchimoku(symbol, timeperiod, 9, 26, 52, MODE_SENKOUSPANB, 1);
   double chinkouspan = iIchimoku(symbol, timeperiod, 9, 26, 52, MODE_CHINKOUSPAN, 27);
   
   double tenkan_sen1 = iIchimoku(symbol, timeperiod, 9, 26, 52, MODE_TENKANSEN, 2);
   double kijunsen1 = iIchimoku(symbol, timeperiod, 9, 26, 52, MODE_KIJUNSEN, 2);
   double senkouspana1 = iIchimoku(symbol, timeperiod, 9, 26, 52, MODE_SENKOUSPANA, 2);
   double senkouspanb1 = iIchimoku(symbol, timeperiod, 9, 26, 52, MODE_SENKOUSPANB, 2);
   double chinkouspan1 = iIchimoku(symbol, timeperiod, 9, 26, 52, MODE_CHINKOUSPAN, 28);

  string per = TimeframeToString(timeperiod);
  string message = StringConcatenate(message, per, ", Ichimuko");
   //buy condition
   if (tenkan_sen > kijunsen
      && chinkouspan > senkouspana
      && chinkouspan > senkouspanb
      && tenkan_sen > senkouspana
      && tenkan_sen > senkouspanb
      && tenkan_sen1 < kijunsen1) {
      createorder(symbol, timeperiod, 1, message);
   }
   //sell condition
   else if (tenkan_sen < kijunsen
      && chinkouspan < senkouspana
      && chinkouspan < senkouspanb
      && tenkan_sen < senkouspana
      && tenkan_sen < senkouspanb
      && tenkan_sen1 > kijunsen1) {
      createorder(symbol, timeperiod, -1, message);
   }
}

double MACDOpenLevel=3;
double MACDCloseLevel=2;
double MATrendPeriod=26;
//macd vars
double MacdCurrent, MacdPrevious, SignalCurrent;
double SignalPrevious, MaCurrent, MaPrevious;
int strategy_macd2(string symbol, int timeperiod)
{
   infobox = StringConcatenate(infobox, "\nStrategy: macd2");
   MacdCurrent=iMACD(symbol,timeperiod,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
   MacdPrevious=iMACD(symbol,timeperiod,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   SignalCurrent=iMACD(symbol,timeperiod,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
   SignalPrevious=iMACD(symbol,timeperiod,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
   //Ma20=iMA(symbol,timeperiod,20,0,MODE_SMA,PRICE_CLOSE,0);
   //Ma5=iMA(symbol,timeperiod,5,0,MODE_SMA,PRICE_CLOSE,0);

  int orders;
  orders = CalculateCurrentMaxOrders();
  if (orders >= maxorders)
  {
      return (0);
  }
  orders = CalculateCurrentOrders(symbol);
  if (orders > 0)
  {
      return (0);
  }
  string per = TimeframeToString(timeperiod);
  string message = StringConcatenate(message, per, ", S2");
   if (MacdCurrent < 0 && MacdCurrent > SignalCurrent && MacdPrevious < SignalPrevious) {
      createorder(symbol, timeperiod, 1, message);
   } else if (MacdCurrent < 0 && MacdCurrent > SignalCurrent && MacdPrevious < SignalPrevious) {
      createorder(symbol, timeperiod, -1, message);
   }
   
}

int strategy_macd1_check_for_close()
{
   if (OrdersTotal() > 0) {
      for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderMagicNumber()==MAGICMA)
        {
         if(OrderType()==OP_BUY)   // long position is opened
            {
               // should it be closed?
               if(MacdCurrent>0 && MacdCurrent<SignalCurrent && MacdPrevious>SignalPrevious &&
                  MacdCurrent>(MACDCloseLevel*MarketInfo(OrderSymbol(),MODE_POINT)))
                {
                 OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),3,Violet); // close position
                }//end if

            } else if (OrderType() == OP_SELL) {
            
               // should it be closed?
               if(MacdCurrent<0 && MacdCurrent>SignalCurrent &&
                  MacdPrevious<SignalPrevious && MathAbs(MacdCurrent)>(MACDCloseLevel*MarketInfo(OrderSymbol(),MODE_POINT)))
                 {
                  OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3,Violet); // close position
                  return(0); // exit
                 }
                             
            }
        }
     }
   }
}
int strategy_macd1(string symbol, int timeperiod)
{
   Comment("Strategy: macd1");
   // to simplify the coding and speed up access
   // data are put into internal variables
   MacdCurrent=iMACD(symbol,timeperiod,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
   MacdPrevious=iMACD(symbol,timeperiod,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   SignalCurrent=iMACD(symbol,timeperiod,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
   SignalPrevious=iMACD(symbol,timeperiod,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
   MaCurrent=iMA(symbol,timeperiod,MATrendPeriod,0,MODE_EMA,PRICE_CLOSE,0);
   MaPrevious=iMA(symbol,timeperiod,MATrendPeriod,0,MODE_EMA,PRICE_CLOSE,1);
   
   //Step 5: Control of the positions previously opened in the cycle
   // it is important to enter the market correctly, 
   // but it is more important to exit it correctly... 
   strategy_macd1_check_for_close();

  int orders;
  orders = CalculateCurrentMaxOrders();
  if (orders >= maxorders)
  {
      return (0);
  }
  orders = CalculateCurrentOrders(symbol);
  if (orders > 0)
  {
      return (0);
  }
  string per = TimeframeToString(timeperiod);
  string message = StringConcatenate(message, per, ", S1");
  //B. is it possible to take a long position (BUY)? 
  if(MacdCurrent<0 && MacdCurrent>SignalCurrent && MacdPrevious<SignalPrevious &&
      MathAbs(MacdCurrent)>(MACDOpenLevel*MarketInfo(symbol,MODE_POINT)) && MaCurrent>MaPrevious)
      {
         createorder(symbol, timeperiod, 1, message);
      }
  //C. is it possible to take a short position (SELL)? 
  if(MacdCurrent>0 && MacdCurrent<SignalCurrent && MacdPrevious>SignalPrevious && 
     MacdCurrent>(MACDOpenLevel*MarketInfo(symbol,MODE_POINT)) && MaCurrent<MaPrevious)
      {
         createorder(symbol, timeperiod, -1, message);
      }

   return (0);
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


double calculate_tp(string symbol, int P, int t)
{
   double tp;
   if (custom_tp > 0) {
      if (t == 1) {
         tp = MarketInfo(symbol,MODE_ASK) + (custom_tp * MarketInfo(symbol,MODE_POINT));
      }
      else if (t == -1) {
         tp = MarketInfo(symbol,MODE_BID) - (custom_tp * MarketInfo(symbol,MODE_POINT));
      }
   } else {
      switch(P)
      {
         case PERIOD_M1:
            if (t == 1) tp = MarketInfo(symbol,MODE_ASK) + (period_m1_tpsl * MarketInfo(symbol,MODE_POINT));
            else if (t == -1) tp = MarketInfo(symbol,MODE_BID) - (period_m1_tpsl * MarketInfo(symbol,MODE_POINT));
            break;
         case PERIOD_M5:  
            if (t == 1) tp = MarketInfo(symbol,MODE_ASK) + (period_m5_tpsl * MarketInfo(symbol,MODE_POINT));
            else if (t == -1) tp = MarketInfo(symbol,MODE_BID) - (period_m5_tpsl * MarketInfo(symbol,MODE_POINT));
            break;
         case PERIOD_M15: 
            if (t == 1) tp = MarketInfo(symbol,MODE_ASK) + (period_m15_tpsl * MarketInfo(symbol,MODE_POINT));
            else if (t == -1) tp = MarketInfo(symbol,MODE_BID) - (period_m15_tpsl * MarketInfo(symbol,MODE_POINT));
            break;
         case PERIOD_M30: 
            if (t == 1) tp = MarketInfo(symbol,MODE_ASK) + (period_m30_tpsl * MarketInfo(symbol,MODE_POINT));
            else if (t == -1) tp = MarketInfo(symbol,MODE_BID) - (period_m30_tpsl * MarketInfo(symbol,MODE_POINT));
            break;
         case PERIOD_H1:  
            if (t == 1) tp = MarketInfo(symbol,MODE_ASK) + (period_h1_tpsl * MarketInfo(symbol,MODE_POINT));
            else if (t == -1) tp = MarketInfo(symbol,MODE_BID) - (period_h1_tpsl * MarketInfo(symbol,MODE_POINT));
            break;
         case PERIOD_H4:  
            if (t == 1) tp = MarketInfo(symbol,MODE_ASK) + (period_h4_tpsl * MarketInfo(symbol,MODE_POINT));
            else if (t == -1) tp = MarketInfo(symbol,MODE_BID) - (period_h4_tpsl * MarketInfo(symbol,MODE_POINT));
            break;
         case PERIOD_D1: 
         case PERIOD_W1: 
         case PERIOD_MN1:
            if (t == 1) tp = MarketInfo(symbol,MODE_ASK) + (period_d1_tpsl * MarketInfo(symbol,MODE_POINT));
            else if (t == -1) tp = MarketInfo(symbol,MODE_BID) - (period_d1_tpsl * MarketInfo(symbol,MODE_POINT));
            break; 
      }   
   }
   

   return (tp);
}
double calculate_sl(string symbol, int P, int t)
{
   double sl; 
   if (custom_sl > 0) {
      if (t == 1) {
          sl = MarketInfo(symbol,MODE_ASK) - (custom_sl * MarketInfo(symbol,MODE_POINT));
      }
      else if (t == -1) {
         sl = MarketInfo(symbol,MODE_BID) + (custom_sl * MarketInfo(symbol,MODE_POINT));
      }
   } else {
      switch(P)
      {
         case PERIOD_M1:
            if (t == 1) sl = MarketInfo(symbol,MODE_ASK) - (period_m1_tpsl * MarketInfo(symbol,MODE_POINT));
            else if (t == -1) sl = MarketInfo(symbol,MODE_BID) + (period_m1_tpsl * MarketInfo(symbol,MODE_POINT));
            break;
         case PERIOD_M5:  
            if (t == 1) sl = MarketInfo(symbol,MODE_ASK) - (period_m5_tpsl * MarketInfo(symbol,MODE_POINT));
            else if (t == -1) sl = MarketInfo(symbol,MODE_BID) + (period_m5_tpsl * MarketInfo(symbol,MODE_POINT));
            break;
         case PERIOD_M15: 
            if (t == 1) sl = MarketInfo(symbol,MODE_ASK) - (period_m15_tpsl * MarketInfo(symbol,MODE_POINT));
            else if (t == -1) sl = MarketInfo(symbol,MODE_BID) + (period_m15_tpsl * MarketInfo(symbol,MODE_POINT));
            break;
         case PERIOD_M30: 
            if (t == 1) sl = MarketInfo(symbol,MODE_ASK) - (period_m30_tpsl * MarketInfo(symbol,MODE_POINT));
            else if (t == -1) sl = MarketInfo(symbol,MODE_BID) + (period_m30_tpsl * MarketInfo(symbol,MODE_POINT));
            break;
         case PERIOD_H1:  
            if (t == 1) sl = MarketInfo(symbol,MODE_ASK) - (period_h1_tpsl * MarketInfo(symbol,MODE_POINT));
            else if (t == -1) sl = MarketInfo(symbol,MODE_BID) + (period_h1_tpsl * MarketInfo(symbol,MODE_POINT));
            break;
         case PERIOD_H4:  
            if (t == 1) sl = MarketInfo(symbol,MODE_ASK) - (period_h4_tpsl * MarketInfo(symbol,MODE_POINT));
            else if (t == -1) sl = MarketInfo(symbol,MODE_BID) + (period_h4_tpsl * MarketInfo(symbol,MODE_POINT));
            break;
         case PERIOD_D1:  
         case PERIOD_W1: 
         case PERIOD_MN1: 
            if (t == 1) sl = MarketInfo(symbol,MODE_ASK) - (period_d1_tpsl * MarketInfo(symbol,MODE_POINT));
            else if (t == -1) sl = MarketInfo(symbol,MODE_BID) + (period_d1_tpsl * MarketInfo(symbol,MODE_POINT));
            break; 
      }   
   }
   return (sl);
}
/*
string TrendTostring(int t)
{
   switch (t)
   {
      case 1: return ("Buy");
      case -1: return ("Sell");
      case 0: return ("Consolidated");
   }
}*/

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
      if(OrderSymbol()==symbol && OrderMagicNumber()==MAGICMA)
        {
         cnt++;
        }
     }
   return (cnt);
  }
  
  
void SendAlert(string dir, string symbol, int timeperiod)
{
   string per = TimeframeToString(timeperiod);
   if (UseAlerts)
   {
      Alert(symbol, " @ ", per, " - ", TimeToStr(TimeCurrent()), " - ", dir);
      PlaySound("alert.wav");
   }
   if (UseEmailAlerts)
      SendMail(symbol + " @ " + per + " - " + dir, dir + " on " + symbol + " @ " + per + " as of " + TimeToStr(TimeCurrent()));
      
   if (UsePrintAlerts)
      Print(Symbol() + " @ " + per + " - " + dir, dir + " on " + symbol + " @ " + per + " as of " + TimeToStr(TimeCurrent()));
}


int createorder(string symbol, int timeperiod, int type, string message)
{
   int ticket;
   double tp = calculate_tp(symbol, timeperiod, type);
   double sl = calculate_sl(symbol, timeperiod, type);
   if (type == 1) {
       ticket=OrderSend(symbol,OP_BUY,Lots,MarketInfo(symbol,MODE_ASK),3,sl,tp,message,MAGICMA,0,Green);
      if(ticket>0)
         {
         stoploss[0] = 0;
          if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
            SendAlert(StringConcatenate("BUY order opened : ",OrderOpenPrice()), symbol, timeperiod);
          }
         }
      else {
         Print("Error opening BUY order : ",ErrorDescription(GetLastError())); 
         infobox = StringConcatenate(infobox, "Error: ", ErrorDescription(GetLastError()));
      }
         return(0); 
   } else if (type == -1) {
       ticket=OrderSend(Symbol(),OP_SELL,Lots,MarketInfo(symbol,MODE_BID),3,sl,tp,message,MAGICMA,0,Red);
        if(ticket>0)
           {
            stoploss[0] = 0;
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
               SendAlert(StringConcatenate("SELL order opened : ",OrderOpenPrice()), symbol, timeperiod);
            }
           }
           else {
               Print("Error opening Sell order : ",ErrorDescription(GetLastError())); 
               infobox = StringConcatenate(infobox, "Error: ", ErrorDescription(GetLastError()));
            } 
             return(0); 
   }
}