//+------------------------------------------------------------------+
//|                                                     10_final.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"
#define MAGICMA  1974060509

extern bool logs = true;
extern double max_amount = 4000.00;
extern bool UseAlerts = false;
extern bool UseEmailAlerts = false;
extern bool UsePrintAlerts = true;
string infobox;
//string showinfobox;
double usable_amount;
int calc_percentage = 40;
string demo;
double stop_loss;
double take_profit;
double stop_loss_value_2,take_profit_value_2,stop_loss_value_3,take_profit_value_3,stop_loss_value_5,take_profit_value_5;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   if(IsDemo()) demo = "Demo Account";
   else demo = "Live Account";
   calculate_profit_loss();
   usable_amount = max_amount * calc_percentage / 100;
   double Lots = NormalizeDouble((usable_amount / 20) / 100, 2);
   double account_margin_used_buy = AccountFreeMarginCheck(Symbol(), OP_BUY, Lots);
   double account_margin_used_sell = AccountFreeMarginCheck(Symbol(), OP_SELL, Lots);
   infobox = StringConcatenate("\n\n",
      "Symbol = ",Symbol(),
      "\n",
      "Period = ",Period(),
      "\n",
      "demo = ",demo,
      "\n",
      "max_amount: ", DoubleToStr(max_amount,Digits),
      ", usable: ", DoubleToStr(usable_amount,Digits),
      "\n",
      "Account Margin: ", DoubleToStr(AccountFreeMargin(),Digits),
      "\n",
      "Proposed Lots: ", DoubleToStr(Lots,Digits),
      "\n",
      "Account Margin Used Buy: ", DoubleToStr(account_margin_used_buy,Digits),
      ", Account Margin Used Sell: ", DoubleToStr(account_margin_used_sell,Digits),
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
      "Day Before Yesterday Low: ", DoubleToStr(Low[2],Digits)
   );
   Comment(infobox);
   SendAlert(infobox);
   int orders = 0;
   orders = CalculateCurrentOrders();
   if(orders==0) {
      
   } else {
      
   }
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
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

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
      if(OrderSymbol()==Symbol())
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