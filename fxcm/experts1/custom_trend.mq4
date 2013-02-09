//+------------------------------------------------------------------+
//|                                      custom_one_min_scalping.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"
#define MAGICMA  197406051

#include <stdlib.mqh>
#include <WinUser32.mqh>

extern double lots = 0.10;
extern double lots_step = 0.00;
extern int maxorders = 1;
extern int number = 0;

extern bool four_hour_strategy = true;
extern bool one_hour_strategy = true;
extern bool half_hour_strategy = true;
extern bool fifteen_min_strategy = true;
extern bool five_min_strategy = true;
extern bool one_min_strategy = false;

extern bool UseAlerts = true;
extern bool UseEmailAlerts = true;

extern bool createorders = true;
extern int custom_tp_fpips = 0;
extern int custom_sl_fpips = 0;

extern bool logs = false;
extern bool implogs = false;

int trend;
string demo;
string infobox;


//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----

   infobox = "\n\n";
   if(IsDemo()) demo = "Demo Account";
   else demo = "Live Account";

   infobox = StringConcatenate(infobox, "\n", "Account type: ", demo);
   infobox = StringConcatenate(infobox, "\n", "Number: ", number);
   Comment(infobox);
   //custom_start(number);
//----
   //custom_start(number);
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
   custom_start(number);
//----
   return(0);
  }
//+------------------------------------------------------------------+

int custom_start(int num)
{
   strategy_call(num);
}

int strategy_call(int num)
{
   double tp, sl;
   string message;
   infobox = "";
   infobox = StringConcatenate(infobox, "\n", "Account type: ", demo);
   infobox = StringConcatenate(infobox, "\n", "Number: ", number);
   int orders = 0;
   orders = CalculateCurrentOrders();
   if(orders > 0)
      CheckForClose();

   int result = 0;
   if (four_hour_strategy) {
      result = four_hour_strategy(num);
      message = TimeframeToString(PERIOD_H4);
      if (result == 1) {
         tp = Ask + (200 * Point);
         sl = Ask - (2000 * Point);
      } else if (result == -1) {
         tp = Bid - (200 * Point);
         sl = Bid + (2000 * Point);
      }
      CheckForOpen(result, message, orders, tp, sl);
   }


   if (one_hour_strategy) {
      result = one_hour_strategy(num);
      message = TimeframeToString(PERIOD_H1);
      if (result == 1) {
         tp = Ask + (150 * Point);
         sl = Ask - (2000 * Point);
      } else if (result == -1) {
         tp = Bid - (150 * Point);
         sl = Bid + (2000 * Point);
      }
      CheckForOpen(result, message, orders, tp, sl);
   }
   if (half_hour_strategy) {
      result = half_hour_strategy(num);
      message = TimeframeToString(PERIOD_M30);
      if (result == 1) {
         tp = Ask + (100 * Point);
         sl = Ask - (2000 * Point);
      } else if (result == -1) {
         tp = Bid - (100 * Point);
         sl = Bid + (2000 * Point);
      }
      CheckForOpen(result, message, orders, tp, sl);
   }
   if (fifteen_min_strategy) {
      result = fifteen_min_strategy(num);
      message = TimeframeToString(PERIOD_M15);
      if (result == 1) {
         tp = Ask + (60 * Point);
         sl = Ask - (2000 * Point);
      } else if (result == -1) {
         tp = Bid - (60 * Point);
         sl = Bid + (2000 * Point);
      }
      CheckForOpen(result, message, orders, tp, sl);
   }
   if (five_min_strategy) {
      result = five_min_strategy(num);
      message = TimeframeToString(PERIOD_M5);
      if (result == 1) {
         tp = Ask + (35 * Point);
         sl = Ask - (2000 * Point);
      } else if (result == -1) {
         tp = Bid - (35 * Point);
         sl = Bid + (2000 * Point);
      }
      CheckForOpen(result, message, orders, tp, sl);
   }
   if (one_min_strategy) {
      result = one_min_strategy(num);
      message = TimeframeToString(PERIOD_M1);
      if (result == 1) {
         tp = Ask + (20 * Point);
         sl = Ask - (2000 * Point);
      } else if (result == -1) {
         tp = Bid - (20 * Point);
         sl = Bid + (2000 * Point);
      }
      CheckForOpen(result, message, orders, tp, sl);
   }
   infobox = StringConcatenate(infobox, 
   "\nAsk: ", DoubleToStr(Ask, Digits),
   "\nBid: ", DoubleToStr(Bid, Digits));

   Comment(infobox);
   return(0);
}
int get_trend(double L_1, double L_100)
{
   int cur_trend = 0;
   if (L_100 > L_1) {
      cur_trend = -1;
   } else if (L_1 > L_100) {
      cur_trend = 1;
   }
   return (cur_trend);
}

int strategy_trend(int num, int Period_to_Call)
{
   double current, toplevel;
   current = calculate_strategy_fantailvma3(1, Period_to_Call, num);
   toplevel = calculate_strategy_fantailvma3(100, Period_to_Call, num);
   trend = get_trend(current, toplevel);
   return (trend);
}
int strategy(int num, int Period_to_Call, int precalctrend, int checkprecalctrend) 
{
   int result = 0;
   double current, past, pastcurrent, toplevel, middelevel;
   if (logs) log_message(StringConcatenate("period: ", TimeframeToString(Period_to_Call), ", precalculate trend strategy: ", precalctrend));
   if (logs) log_message(StringConcatenate("period to call: ", TimeframeToString(Period_to_Call)));
      current = calculate_strategy_fantailvma3(1, Period_to_Call, num);
   if (logs) log_message(StringConcatenate("Period: ", TimeframeToString(Period_to_Call), ", Current: ", current));
      middelevel = calculate_strategy_fantailvma3(26, Period_to_Call, num);
   if (logs) log_message(StringConcatenate("Period: ", TimeframeToString(Period_to_Call), ", middelevel: ", middelevel));
      toplevel = calculate_strategy_fantailvma3(100, Period_to_Call, num);
   if (logs) log_message(StringConcatenate("Period: ", TimeframeToString(Period_to_Call), ", toplevel: ", toplevel));
   if (checkprecalctrend == 0) {
      trend = get_trend(current, toplevel);
      if (logs) log_message(StringConcatenate("Period: ", TimeframeToString(Period_to_Call), ", trend: ", trend));
   } else {
      if (logs) log_message(StringConcatenate("Period: ", TimeframeToString(Period_to_Call), ", precalctrend: ", precalctrend));
      trend = precalctrend;
   }
   
   infobox = StringConcatenate(infobox, "\n", "TimeFrame: ", TimeframeToString(Period_to_Call)
      , ", Trend: ", trend
   );
   if (trend > 0) {
      //buy
      if (current < middelevel) {
         if (logs) log_message(StringConcatenate("Period: ", TimeframeToString(Period_to_Call), ", No Buy Condition, though trend is buy"));
         return (0);
      }
   } else if (trend < 0) {
      //sell
      if (current > middelevel) {
         if (logs) log_message(StringConcatenate("Period: ", TimeframeToString(Period_to_Call), ", No Sell Condition, though trend is sell"));
         return (0);
      }
   }
   for (int i = (num + 1); i <= (num + 2); i++) {
      past = calculate_strategy_fantailvma3(26, Period_to_Call, i);
      pastcurrent = calculate_strategy_fantailvma3(1, Period_to_Call, i);
      if (logs) log_message(StringConcatenate("Past: ", i, ", ", past));
      if (trend > 0) {
         //buy
         if (past > pastcurrent && current > middelevel) {
            if (implogs) Alert(StringConcatenate(Symbol(), ", period: ", TimeframeToString(Period_to_Call), ", Buy Condition Exists for bar: ", i));
            infobox = StringConcatenate(infobox, ", ", "Buy Condition Exists");
            result = 1;
            break;
         } else {
            if (implogs) log_message(StringConcatenate("Period: ", TimeframeToString(Period_to_Call), ", No Buy Condition for bar: ", i));
         }
      } else if (trend < 0) {
         //sell
         if (past < pastcurrent && current < middelevel) {
            if (implogs) Alert(StringConcatenate(Symbol(), ", period: ", TimeframeToString(Period_to_Call), ", Sell Condition Exists for bar: ", i));
            infobox = StringConcatenate(infobox, ", ", "Sell Condition Exists");
            result = -1;
            break;
         } else {
            if (implogs) log_message(StringConcatenate("Period: ", TimeframeToString(Period_to_Call), ", No Sell Condition for bar: ", i));
         }
      }
   }

   return (result);
}
int four_hour_strategy(int num)
{
   //PERIOD_H4
   int result = 0;
   int temp_trend1 = 0;
   int temp_trend2 = 0;
   int temp_trend3 = 0;
   int temp_trend4 = 0;
   temp_trend1 = strategy_trend(num, PERIOD_H4);
   temp_trend2 = strategy_trend(num, PERIOD_H1);
   temp_trend3 = strategy_trend(num, PERIOD_M30);
   temp_trend4 = strategy_trend(num, PERIOD_M15);
   if (temp_trend1 == temp_trend2 && temp_trend2 == temp_trend3 && temp_trend3 == temp_trend4) {
   
   } else {
      infobox = StringConcatenate(infobox, "\nPeriod: ", TimeframeToString(PERIOD_H4), ", Trend Not same in all position: ", temp_trend1, 
      ", ", temp_trend2, ", ", temp_trend3, ", ", temp_trend4);
      return (result);
   }
   result = strategy(num, PERIOD_H4, temp_trend1, 1);
   return (result);
   
}
int one_hour_strategy(int num)
{
   //PERIOD_H1
   int result = 0;
   int temp_trend1 = 0;
   int temp_trend2 = 0;
   int temp_trend3 = 0;
   int temp_trend4 = 0;
   temp_trend1 = strategy_trend(num, PERIOD_H4);
   temp_trend2 = strategy_trend(num, PERIOD_H1);
   temp_trend3 = strategy_trend(num, PERIOD_M30);
   temp_trend4 = strategy_trend(num, PERIOD_M15);
   if (temp_trend1 == temp_trend2 && temp_trend2 == temp_trend3 && temp_trend3 == temp_trend4) {
   
   } else {
      infobox = StringConcatenate(infobox, "\nPeriod: ", TimeframeToString(PERIOD_H1), ", Trend Not same in all position: ", temp_trend1, 
      ", ", temp_trend2, ", ", temp_trend3, ", ", temp_trend4);
      return (result);
   }
   result = strategy(num, PERIOD_H1, temp_trend2, 1);
   return (result);
}
int half_hour_strategy(int num)
{
   //PERIOD_M30
   int result = 0;
   int temp_trend1 = 0;
   int temp_trend2 = 0;
   int temp_trend3 = 0;
   int temp_trend4 = 0;
   temp_trend1 = strategy_trend(num, PERIOD_H4);
   temp_trend2 = strategy_trend(num, PERIOD_H1);
   temp_trend3 = strategy_trend(num, PERIOD_M30);
   temp_trend4 = strategy_trend(num, PERIOD_M15);
   if (temp_trend1 == temp_trend2 && temp_trend2 == temp_trend3 && temp_trend3 == temp_trend4) {
   
   } else {
      infobox = StringConcatenate(infobox, "\nPeriod: ", TimeframeToString(PERIOD_M30), ", Trend Not same in all position: ", temp_trend1, 
      ", ", temp_trend2, ", ", temp_trend3, ", ", temp_trend4);
      return (result);
   }
   result = strategy(num, PERIOD_M30, temp_trend3, 1);
   return (result);
   return(0);
}
int fifteen_min_strategy(int num)
{
   //PERIOD_M15
   int result = 0;
   int temp_trend1 = 0;
   int temp_trend2 = 0;
   int temp_trend3 = 0;
   int temp_trend4 = 0;
   temp_trend1 = strategy_trend(num, PERIOD_H4);
   temp_trend2 = strategy_trend(num, PERIOD_H1);
   temp_trend3 = strategy_trend(num, PERIOD_M30);
   temp_trend4 = strategy_trend(num, PERIOD_M15);
   if (temp_trend1 == temp_trend2 && temp_trend2 == temp_trend3 && temp_trend3 == temp_trend4) {
   
   } else {
      infobox = StringConcatenate(infobox, "\nPeriod: ", TimeframeToString(PERIOD_M15), ", Trend Not same in all position: ", temp_trend1, 
      ", ", temp_trend2, ", ", temp_trend3, ", ", temp_trend4);
      return (result);
   }
   result = strategy(num, PERIOD_M15, temp_trend4, 1);
   return (result);
   return(0);
}
int five_min_strategy(int num)
{
   //PERIOD_M5
   int result = 0;
   int temp_trend1 = 0;
   int temp_trend2 = 0;
   int temp_trend3 = 0;
   int temp_trend4 = 0;
   temp_trend1 = strategy_trend(num, PERIOD_H4);
   temp_trend2 = strategy_trend(num, PERIOD_H1);
   temp_trend3 = strategy_trend(num, PERIOD_M30);
   temp_trend4 = strategy_trend(num, PERIOD_M15);
   if (temp_trend1 == temp_trend2 && temp_trend2 == temp_trend3 && temp_trend3 == temp_trend4) {
   
   } else {
      infobox = StringConcatenate(infobox, "\nPeriod: ", TimeframeToString(PERIOD_M5), ", Trend Not same in all position: ", temp_trend1, 
      ", ", temp_trend2, ", ", temp_trend3, ", ", temp_trend4);
      return (result);
   }
   result = strategy(num, PERIOD_M5, 0, 0);
   return (result);
   return(0);
}
int one_min_strategy(int num)
{
   //PERIOD_M1
   int result = 0;
   int temp_trend1 = 0;
   int temp_trend2 = 0;
   int temp_trend3 = 0;
   int temp_trend4 = 0;
   temp_trend1 = strategy_trend(num, PERIOD_H4);
   temp_trend2 = strategy_trend(num, PERIOD_H1);
   temp_trend3 = strategy_trend(num, PERIOD_M30);
   temp_trend4 = strategy_trend(num, PERIOD_M15);
   if (temp_trend1 == temp_trend2 && temp_trend2 == temp_trend3 && temp_trend3 == temp_trend4) {
   
   } else {
      infobox = StringConcatenate(infobox, "\nPeriod: ", TimeframeToString(PERIOD_M1), ", Trend Not same in all position: ", temp_trend1, 
      ", ", temp_trend2, ", ", temp_trend3, ", ", temp_trend4);
      return (result);
   }
   int temp_trend = strategy_trend(num, PERIOD_M5);
   if (logs) log_message(StringConcatenate("period: ", TimeframeToString(PERIOD_M1), " - ", TimeframeToString(PERIOD_M5), ", precalculate trend: ", temp_trend));
   result = strategy(num, PERIOD_M1, temp_trend, 1);
   return (result);
   return(0);
}
double calculate_strategy_fantailvma3(int MA_Length, int Period_of_Time, int shift)
{
   int ADX_Length = 2;
   double Weighting = 2.0;
   //int MA_Length = 1;
   int MA_Mode = 1;
   double L_1;
   L_1 = iCustom(NULL, Period_of_Time, "FantailVMA3", ADX_Length, Weighting, MA_Length, MA_Mode, 0, shift);
   return (L_1);
}

void log_message(string message)
{
   Print(Symbol(), ", ", message);
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

int CheckForClose()
{
   //Print("Checking for close for symbol ", Symbol());
}

int CalculateCurrentMaxOrders()
  {
   int corders=0;
//----
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      //if(OrderMagicNumber()==MAGICMA)
        //{
         if(OrderType()==OP_BUY || OrderType()==OP_SELL)
            corders++;
        //}
     }
     if (logs) log_message(StringConcatenate("Total Orders: ", " is ", corders));
         return(corders);
}


int CalculateCurrentOrders()
  {
   int cnt=0;
//----
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol())// && OrderMagicNumber()==MAGICMA
        {
         cnt++;
        }
     }
     if (logs) log_message(StringConcatenate("Orders for symbol: ", Symbol(), " is ", cnt));
   return (cnt);
  }

int CheckForOpen(int type, string message, int orders, double tp, double sl)
{
   if (!createorders) {
      log_message(StringConcatenate(Symbol(), ", create orders disabled"));
      return (0);
   }
   if (type == 0) {
      if (logs) log_message(StringConcatenate(Symbol(), ", no orders processed as buy and sell condition does not exists for ", message));
      return (0);
   }
   int morders = CalculateCurrentMaxOrders();
   if (morders >= maxorders) {
      if (logs) log_message(StringConcatenate("Max Orders Reached for symbol ", Symbol()));
      return (0);
   }
   if (orders > 0) {
      if (logs) log_message(StringConcatenate("Order Already created for symbol ", Symbol()));
      return (0);
   }
   int ticket;
   int error;
   if (type == 1) {
      if (custom_tp_fpips > 0) {
         tp = Ask + (custom_tp_fpips * Point);
      }
      if (custom_sl_fpips > 0) {
         sl = Ask - (custom_sl_fpips * Point);
      }
      message = StringConcatenate("1.1 Custom Trend, ", message);
      ticket=OrderSend(Symbol(),OP_BUY,lots,Ask,3,sl,tp,message,255,0,CLR_NONE);
      if(ticket<1)
      {
         error=GetLastError();
         Alert("Error = ",ErrorDescription(error));
         return (0);
      }
      Alert("Buy order created for symbol: ", Symbol());
      lots = lots + lots_step;
      OrderPrint();
   } else if (type == -1) {
      if (custom_tp_fpips > 0) {
         tp = Bid - (custom_tp_fpips * Point);
      }
      if (custom_sl_fpips > 0) {
         sl = Bid + (custom_sl_fpips * Point);
      }
      message = StringConcatenate("1.1 Custom Trend, ", message);
      ticket=OrderSend(Symbol(),OP_SELL,lots,Bid,3,sl,tp,message,255,0,CLR_NONE);
      if(ticket<1)
      {
         error=GetLastError();
         Alert("Error = ",ErrorDescription(error));
         return (0);
      }
      Alert("Sell order created for symbol: ", Symbol());
      lots = lots + lots_step;
      OrderPrint();
   }
}

/*

int CheckForOpen(int type)
{
   int ticket;
   int error;
   string message = "";
   int orders = 0;
   orders = CalculateCurrentMaxOrders();
   if (orders >= maxorders) {
      Print("Max Orders Reached for symbol ", Symbol());
      return (0);
   }

  Print("Checking open condition for symbol ", Symbol());
   if (type == 0) {
      return (0);
   }

   double tp;
   double sl = 0;
   if (type == 1) {
      switch (Period()) {
         case PERIOD_M1:
            tp = Ask + (20 * Point);
            break;
         case PERIOD_M5: 
            tp = Ask + (50 * Point);
            break;
         case PERIOD_M15:
            tp = Ask + (100 * Point);
            break;
         case PERIOD_M30:
            tp = Ask + (150 * Point);
            break;
         case PERIOD_H1:
            tp = Ask + (200 * Point);
            break;
         case PERIOD_H4:
            tp = Ask + (250 * Point);
            break;
         case PERIOD_D1:
            tp = Ask + (300 * Point);
            break;
         case PERIOD_W1:
            tp = Ask + (350 * Point);
            break;
         case PERIOD_MN1:
            tp = Ask + (400 * Point);
            break;
      }
      if (custom_tp_fpips > 0) {
         tp = Ask + (custom_tp_fpips * Point);
      }
      if (custom_sl_fpips > 0) {
         sl = Ask - (custom_sl_fpips * Point);
      }
      message = StringConcatenate("1.1 Trend ", trend, ", ", TimeframeToString(Period()));
      ticket=OrderSend(Symbol(),OP_BUY,lots,Ask,3,sl,tp,message,255,0,CLR_NONE);
      if(ticket<1)
      {
         error=GetLastError();
         Alert("Error = ",ErrorDescription(error));
         Print("Result: Resetting vars 3");
         previous2 = 0;
         previous1 = 1;
         return;
      }
      SendAlertOrder(Ask, "Buy");
      previous1 = 0;
      previous2 = 0;
      OrderPrint();
   } else if (type == -1) {
      switch (Period()) {
         case PERIOD_M1:
            tp = Bid - (20 * Point);
            break;
         case PERIOD_M5: 
            tp = Bid - (50 * Point);
            break;
         case PERIOD_M15:
            tp = Bid - (100 * Point);
            break;
         case PERIOD_M30:
            tp = Bid - (150 * Point);
            break;
         case PERIOD_H1:
            tp = Bid - (200 * Point);
            break;
         case PERIOD_H4:
            tp = Bid - (250 * Point);
            break;
         case PERIOD_D1:
            tp = Bid - (300 * Point);
            break;
         case PERIOD_W1:
            tp = Bid - (350 * Point);
            break;
         case PERIOD_MN1:
            tp = Bid - (400 * Point);
            break;
      }
      if (custom_tp_fpips > 0) {
         tp = Bid - (custom_tp_fpips * Point);
      }
      if (custom_sl_fpips > 0) {
         sl = Bid + (custom_sl_fpips * Point);
      }
      message = StringConcatenate("1.1 Trend ", trend, ", ", TimeframeToString(Period()));
      ticket=OrderSend(Symbol(),OP_SELL,lots,Bid,3,sl,tp,message,255,0,CLR_NONE);
      if(ticket<1)
      {
         error=GetLastError();
         Alert("Error = ",ErrorDescription(error));
         Print("Result: Resetting vars 4");
         previous1 = 0;
         previous2 = 1;
         return;
      }
      SendAlertOrder(Bid, "Sell");
      previous1 = 0;
      previous2 = 0;
      OrderPrint();
   }
}


void SendAlert(string dir)
{
   string per = TimeframeToString(Period());
   if (UseAlerts)
   {
      Alert(dir + " Scalping on ", Symbol(), " @ ", per);
      PlaySound("alert.wav");
   }
   if (UseEmailAlerts)
      SendMail(Symbol() + " @ " + per + " - Scalping", dir + " Scalping on " + Symbol() + " @ " + per + " as of " + TimeToStr(TimeCurrent()));
}
void SendAlertOrder(double price, string type)
{
   string per = TimeframeToString(Period());
   string mes;
   mes = StringConcatenate(type, " Order Created for at ", price, ", ", Symbol(), " @ ", per, ", as of " + TimeToStr(TimeCurrent()));
   if (UseAlerts)
   {
      Alert(mes);
      PlaySound("alert.wav");
   }
   if (UseEmailAlerts)
      SendMail(type + " Order Created for symbol " + Symbol(),  mes);
}

*/