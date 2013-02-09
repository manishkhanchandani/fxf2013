//+------------------------------------------------------------------+
//|                                                 9_hugeprofit.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"
#define MAGICMA  1974060509

extern bool logs = true;
extern int maxorders=3;
extern double lots = 0.50;
extern double max_profit = 50.00;
extern bool useCreateOrder = false;
extern bool disable_stop_loss = true;
extern bool disable_take_profit = true;
extern bool UseAlerts = true;
extern bool UseEmailAlerts = true;
extern bool UsePrintAlerts = true;

string infobox;
string showinfobox;
double build = 1.0;
double stop_loss;
double take_profit;
double stop_loss_value_2,take_profit_value_2,stop_loss_value_3,take_profit_value_3,stop_loss_value_5,take_profit_value_5;
string demo;
int counter = 0;
double previous_reading = 0.0;
string current_trend = "";
int diff;
double diff_max;
double diff_min;
double base_level;
double base_level_diff;
int bearish = 0;
int bullish = 0;
double sl, tp;


//profit related
int loss;
double past_profit = 0;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----

   if (logs) Print("Period is: ", Period());
   if(IsDemo()) demo = "Demo Account";
   else demo = "Live Account";
   calculate_profit_loss();
   infobox = StringConcatenate("\n","\n",
      "Build = ",build,
      "\n",
      "Period = ",Period(),
      "\n",
      /*"Account Number = ",AccountNumber(),
      "\n",
      "Account name = ",AccountName(),
      "\n",
      "Account leverage = ",AccountLeverage(),
      "\n",
      "Account Type = ",demo,
      "\n",
      "Account company name = ",AccountCompany(),
      "\n",
      "Account currency = ",AccountCurrency(),
      "\n",
      "Account server = ",AccountServer(),
      "\n",*/
      "Take Profie = ",take_profit,
      "\n",
      "Stop loss = ",stop_loss);
   
   Comment(infobox);
   previous_reading = Ask;
   base_level = Ask;
   base_level_diff = Ask;
//----
   return(0);
  }

void custom_start()
{
   if (Period() != PERIOD_D1) {
      infobox = StringConcatenate("\n","\n", "This works only in day time period. Please change to day time period.");
      Comment(infobox);
      return (0);
   }

   if (High[1] > Ask) {
      diff_max = High[1] - Ask;
   } else {
      diff_max = Ask - High[1];
   }
   if (Low[1] > Ask) {
      diff_min = Low[1] - Ask;
   } else {
      diff_min = Ask - Low[1];
   }

   if (diff_max < diff_min) {
      diff = 1;
   } else if (diff_max > diff_min) {
      diff = -1;
   } else {
      diff = 0;
   }
 
   if (Ask > previous_reading) {
      counter++;
   }
   if (Ask < previous_reading) {
      counter--;
   }
 
   int result = 0;
   if (counter > 20) {
      result = 1;
      current_trend = "Bullish";
      counter = 0;
      bullish++;
      bearish = 0;
   } else if (counter < -20) {
      result = -1;
      current_trend = "Bearish";
      counter = 0;
      bearish++;
      bullish = 0;
   }

   base_level_diff = Ask - base_level;
   Comment(infobox,
      "\n",
      "Counter: ", counter,
      "\n",
      "Base Level: ", DoubleToStr(base_level,Digits),
      "\n",
      "New Level (Positive means buy, Negative means Sell): ", DoubleToStr(base_level_diff,Digits),
      "\n",
      "Previous Reading: ", DoubleToStr(previous_reading,Digits),
      "\n",
      "Current Ask Reading: ", DoubleToStr(Ask,Digits),
      "\n",
      "Current Bid Reading: ", DoubleToStr(Bid,Digits),
      "\n",
      "Todays High: ", DoubleToStr(High[0],Digits),
      "\n",
      "Todays Low: ", DoubleToStr(Low[0],Digits),
      "\n",
      "Yesterdays High: ", DoubleToStr(High[1],Digits),
      "\n",
      "Yesterdays Low: ", DoubleToStr(Low[1],Digits),
      "\n",
      "Day Before Yesterday High: ", DoubleToStr(High[2],Digits),
      "\n",
      "Day Before Yesterday Low: ", DoubleToStr(Low[2],Digits),
      "\n",
      "Current Trend: ", current_trend,
      "\n",
      "Diff Max: ", DoubleToStr(diff_max,Digits),
      "\n",
      "Diff Min: ", DoubleToStr(diff_min,Digits),
      "\n",
      "Diff: ", diff
   );
   previous_reading = Ask;
   
   int orders = 0;
   orders = CalculateCurrentMaxOrders();
   if (orders >= maxorders) {
      Print("Max Orders Reached.");
      return;
   }
   orders = CalculateCurrentOrders();
   if(orders==0) {
      createOrder(result);
   } else {
      CheckForClose();
   }
      
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
   custom_start();
//----
   return(0);
  }
//+------------------------------------------------------------------+

void calculate_profit_loss()
{
   stop_loss_value_2 = 3.00;
   stop_loss_value_3 = 0.300;
   stop_loss_value_5 = 0.00300;
   take_profit_value_2 = 0.90;
   take_profit_value_3 = 0.090;
   take_profit_value_5 = 0.00090;
   if (Digits == 3) {
         take_profit = take_profit_value_3;
         stop_loss = stop_loss_value_3;
   } else if (Digits == 2) {
         take_profit = take_profit_value_2;
         stop_loss = stop_loss_value_2;
   } else {
         take_profit = take_profit_value_5;
         stop_loss = stop_loss_value_5;
   }
}

int CalculateCurrentOrders()
  {
   int buys=0,sells=0;
//----
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA)
        {
         if(OrderType()==OP_BUY)  buys++;
         if(OrderType()==OP_SELL) sells++;
        }
     }
         if (logs) Print("Buy count: ", buys);
         if (logs) Print("Sell count: ", sells);
//---- return orders volume
   if(buys>0) return(buys);
   else       return(-sells);
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
         corders++;
        }
     }
         if (logs) Print("Max orders: ", corders);
         return(corders);
  }
  
  void createOrder(int result)
  {
      string message, r;
      if (result == 0) {
         return;
      }

      if (!useCreateOrder) {
         Print("order creation is disabled.");
         return;
      }
      string per = TimeframeToString(Period());
      
      if (result == 1) {
         //buy
         if (logs) Print("buy condition exists.");
         // creating order
         sl = 0;
         tp = 0;
         if (!disable_stop_loss) {
            sl = Ask - stop_loss;
         }

         if (!disable_take_profit) {
            tp = Ask + take_profit;
         }
         r = OrderSend(Symbol(), OP_BUY, lots, Ask, 3, sl, tp, "", MAGICMA, 0, Blue);
         //ending order
         Print("Result for buy: ", r);
         message = StringConcatenate("Order created for symbol: ", Symbol(), " with lot size: ", 0.01, ", sl: ", sl, ", tp: ", tp, ", with error: ", GetLastError());
         if (logs) Print(message);
         SendAlert(message);
      } else if (result == -1) {
         //sell
         if (logs) Print("sell condition exists.");
      
         // creating order
         sl = 0;
         tp = 0;
         if (!disable_stop_loss) {
            sl = Bid + stop_loss;
         }

         if (!disable_take_profit) {
            tp = Bid - take_profit;
         }
         r = OrderSend(Symbol(),OP_SELL,lots,Bid,3,sl,tp,"",MAGICMA,0,Red);
         //ending order
         Print("Result for sell: ", r);
         message = StringConcatenate("Order created for symbol: ", Symbol(), " with lot size: ", 0.01, ", sl: ", sl, ", tp: ", tp, ", with error: ", GetLastError());
         if (logs) Print(message);
         SendAlert(message);
      } else {
         //no sell and buy
         if (logs) Print("No sell or buy in createOrder.");
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
   }
}

void SendAlert(string dir)
{
   string per = TimeframeToString(Period());
   if (UseAlerts)
   {
      Alert(dir + " Ichimoku on ", Symbol(), " @ ", per);
      PlaySound("alert.wav");
   }
   if (UseEmailAlerts)
      SendMail(Symbol() + " @ " + per + " - " + dir + " Ichimoku", dir + " Pinbar on " + Symbol() + " @ " + per + " as of " + TimeToStr(TimeCurrent()));
      
   if (UsePrintAlerts)
      Print(Symbol() + " @ " + per + " - " + dir + " Ichimoku", dir + " Pinbar on " + Symbol() + " @ " + per + " as of " + TimeToStr(TimeCurrent()));
}

void CheckForClose()
  {
  int x = 0;
   for(int i=0;i<OrdersTotal();i++)
     {
      x = 0;
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
      Alert(OrderSymbol());
      Alert("Profit for the order ",OrderTicket(), " is with lots: ", OrderLots(), ": ", OrderProfit());
      if (OrderProfit() > 0 && OrderProfit() > max_profit) {
         if (OrderProfit() < past_profit) {
            loss++;
         } else {
            loss = 0;
         }
         past_profit = OrderProfit();
      } else {
         loss = 0;
      }

      if (loss > 3) {
         x = 1;
         loss = 0;
      }
      if (OrderProfit() > max_profit) {
         //x = 1;
      }
      //---- check order type 
      if(OrderType()==OP_BUY)
        {
         if(x == 1) OrderClose(OrderTicket(),OrderLots(),Bid,3,White);
         break;
        }
      if(OrderType()==OP_SELL)
        {
         if(x == 1) OrderClose(OrderTicket(),OrderLots(),Ask,3,White);
         break;
        }
     }
//----
  }