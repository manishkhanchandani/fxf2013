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

extern bool UseAlerts = true;
extern bool UseEmailAlerts = true;
extern int number = 1;
extern int maxorders = 7;
extern double lots = 0.10;

int previous1 = 1;
int previous2 = 1;
int signal = 0;
int counter = 0;
string trend;
string demo;

int LastBars = 0;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----

   if(IsDemo()) demo = "Demo Account";
   else demo = "Live Account";
   int NeedBarsCounted;
   NeedBarsCounted = Bars - LastBars;
   LastBars = Bars;
   double avg;
   double ima25, ima50, ima100, iadx;
   double ima25p, ima50p, ima100p;
   int counter = 0;
   for (int i = NeedBarsCounted; i >= 1; i--)
   {
      ima25 = iMA(NULL,0,25,0,MODE_EMA,PRICE_CLOSE,i);
      ima50 = iMA(NULL,0,50,0,MODE_EMA,PRICE_CLOSE,i);
      ima100 = iMA(NULL,0,100,0,MODE_EMA,PRICE_CLOSE,i);
      
      //check if red crosses blue
      if (ima25 < ima50 && ima25 < ima100) {
         signal = -1;
      } else if (ima25 > ima50 && ima25 > ima100) {
         signal = 1;
      } else {
         signal = 0;
      }
      //Print("signal: ", i, ", ", signal);
      if (High[i] < ima25 && High[i] < ima50 && High[i] < ima100 && Open[i] > Close[i]) {
         //sell position
         if (i <= 25)
            counter--;
      } else if (Low[i] > ima25 && Low[i] > ima50 && Low[i] > ima100 && Open[i] < Close[i]) {
         //buy position
         if (i <= 25)
            counter++;
      }      
      
      if (High[i] < ima25 && High[i] < ima50 && High[i] < ima100 && signal == -1 && previous1 == 0 && Open[i] > Close[i]) {
         //sell position
         previous2 = 0;
         previous1 = 1;
      } else if (Low[i] > ima25 && Low[i] > ima50 && Low[i] > ima100 && signal == 1 && previous2 == 0 && Open[i] < Close[i]) {
         //buy position
         previous1 = 0;
         previous2 = 1;
      }  else if (ima25 < ima50 && ima25 > ima100) {
         previous1 = 0;
         previous2 = 0;
      } else if (ima25 > ima50 && ima25 < ima100) {
         previous1 = 0;
         previous2 = 0;
      }
      
      
   }
//----
   
   if (counter > 0) trend = "Buy";
   else if (counter < 0) trend = "Sell";
   else trend = "Consolidated";
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

int custom_start(int i)
{   
   double ima25, ima50, ima100;
   string message;
   ima25 = iMA(NULL,0,25,0,MODE_EMA,PRICE_CLOSE,i);
   ima50 = iMA(NULL,0,50,0,MODE_EMA,PRICE_CLOSE,i);
   ima100 = iMA(NULL,0,100,0,MODE_EMA,PRICE_CLOSE,i);
   //check if red crosses blue
   if (ima25 < ima50 && ima25 < ima100) {
      signal = -1;
   } else if (ima25 > ima50 && ima25 > ima100) {
      signal = 1;
   } else {
      signal = 0;
   }

      if (High[i] < ima25 && High[i] < ima50 && High[i] < ima100 && Open[i] > Close[i]) {
         //sell position
         counter--;
      } else if (Low[i] > ima25 && Low[i] > ima50 && Low[i] > ima100 && Open[i] < Close[i]) {
         //buy position
         counter++;
      }      
   if (counter > 0) trend = "Buy";
   else if (counter < 0) trend = "Sell";
   else trend = "Consolidated";

   int result = 0;
   if (High[i] < ima25 && High[i] < ima50 && High[i] < ima100 && signal == -1 && previous1 == 0 && Open[i] > Close[i]) {
      Print("Result: Bearish");
      previous2 = 0;
      previous1 = 1;
      message = StringConcatenate("Down with trend ", trend, ", Account Number: ", AccountNumber(), ", is demo: ", demo, ", Company: ", AccountCompany());
      SendAlert(message);
      result = -1;
      counter = 0;
   } else if (Low[i] > ima25 && Low[i] > ima50 && Low[i] > ima100 && signal == 1 && previous2 == 0 && Open[i] < Close[i]) {
      Print("Result: Bullish");
      previous1 = 0;
      previous2 = 1;
      message = StringConcatenate("Up with trend ", trend, ", Account Number: ", AccountNumber(), ", is demo: ", demo, ", Company: ", AccountCompany());
      SendAlert(message);
      result = 1;
      counter = 0;
   } else if (ima25 < ima50 && ima25 > ima100) {
      Print("Result: Resetting vars 1");
      previous1 = 0;
      previous2 = 0;
   } else if (ima25 > ima50 && ima25 < ima100) {
      Print("Result: Resetting vars 2");
      previous1 = 0;
      previous2 = 0;
   }

   Comment("\nima25: ", DoubleToStr(ima25, Digits),
   "\nima50: ", DoubleToStr(ima50, Digits),
   "\nima100: ", DoubleToStr(ima100, Digits),
   "\nTrend: ", trend,
   "\nPrevious: ", previous1,
   "\nPrevious2: ", previous2,
   "\nCounter: ", counter,
   "\nAsk: ", DoubleToStr(Ask, Digits),
   "\nBid: ", DoubleToStr(Bid, Digits));
   int orders = 0;
   orders = CalculateCurrentOrders();
   if(orders==0) 
      CheckForOpen(result);
   else
      CheckForClose();
   return (0);
}

int CheckForClose()
{

     Print("Checking for close for symbol ", Symbol());
}

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
      tp = Ask + (300 * Point);
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
      tp = Bid - (300 * Point);
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
      previous1 = 0;
      previous2 = 0;
      OrderPrint();
   }
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
     Print("Total Orders: ", " is ", corders, " / ", maxorders);
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
     Print("Orders for symbol: ", Symbol(), " is ", cnt);
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