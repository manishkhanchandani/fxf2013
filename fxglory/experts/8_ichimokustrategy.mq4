//+------------------------------------------------------------------+
//|                                           8_ichimokustrategy.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"
#define MAGICMA  1974060507

extern int Tenkan=9;
extern int Kijun=26;
extern int Senkou=52;
extern int maxorders=3;
extern double lots = 0.02; //use this if you want to make custom lot size, make this greater than 0.0
extern double custom_account_balance = 0.0; //use this if you want to make account margin custom to your needs, make this greater than 0.0
extern bool useCreateOrder = true;//this will create or disable the order creation
extern bool UseAlerts = false;
extern bool UseEmailAlerts = true;
extern bool UsePrintAlerts = true;
extern bool logs = false;
extern bool implogs = true;
extern bool disable_stop_loss = true;
extern bool disable_take_profit = false;
extern bool bid_neutral_weak_also = false;
//strategies
extern bool old_strategy = false; //old_strategy
extern bool old_modified_strategy = true; //old_modified_strategy
extern bool ideal_ichimoku_strategy = false; //Ideal Ichimoku Strategy
extern bool tenkan_senlykijwl_strategy = false; //Tenkan SenlKijwl Sen Cross Strategy
extern bool kijun_sen_cross_strategy = false; //Kijun Sen Cross Strategy
extern bool kumo_cloud_breakout_strategy = false; //Kumo Cloud Breakout Strategy
extern bool future_senkou_strategy = false; //Future Senkou Crossover Strategy



double stop_loss;
double take_profit;
int a_begin;
double Tenkan_Buffer;
double Kijun_Buffer;
double SpanA_Buffer;
double SpanB_Buffer;
double Chinkou_Buffer;
double SpanA2_Buffer;
double SpanB2_Buffer;
int number = 0;
string infobox;
string showinfobox;
double sl;
double tp;
double build = 1.8;
double comment;
double connectionTenkan;
int connectionTenkanNumber;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   if (logs) Print("Custom Initializing build: ", build);
   a_begin=Kijun; if(a_begin<Tenkan) a_begin=Tenkan;
   if (logs) Print("Period is: ", Period());
   double stop_loss_value_2,take_profit_value_2,stop_loss_value_3,take_profit_value_3,stop_loss_value_5,take_profit_value_5;
   switch (Period()) {
      case PERIOD_M1:
      case PERIOD_M5: 
         stop_loss_value_2 = 3.00;
         stop_loss_value_3 = 0.300;
         stop_loss_value_5 = 0.00300;
         take_profit_value_2 = 0.30;
         take_profit_value_3 = 0.030;
         take_profit_value_5 = 0.00030;
         break;
      case PERIOD_M15:
      case PERIOD_M30:
      case PERIOD_H1:
      case PERIOD_H4:
         stop_loss_value_2 = 3.00;
         stop_loss_value_3 = 0.300;
         stop_loss_value_5 = 0.00300;
         take_profit_value_2 = 0.60;
         take_profit_value_3 = 0.060;
         take_profit_value_5 = 0.00060;
         break;
      case PERIOD_D1:
      case PERIOD_W1:
      case PERIOD_MN1:
         stop_loss_value_2 = 3.00;
         stop_loss_value_3 = 0.300;
         stop_loss_value_5 = 0.00300;
         take_profit_value_2 = 0.90;
         take_profit_value_3 = 0.090;
         take_profit_value_5 = 0.00090;
         break;
   }
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
   if (logs) Print("take profit limit is: ", take_profit);
   if (logs) Print("stop_loss limit is: ", stop_loss);
   string demo;
   if(IsDemo()) demo = "Demo Account";
   else demo = "Live Account";
   if (logs) Print("account is: ", demo);
   infobox = StringConcatenate("\n","\n",
      "Build = ",build,
      "\n",
      "Account Number = ",AccountNumber(),
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
      "\n",
      "Take Profie = ",take_profit,
      "\n",
      "Stop loss = ",stop_loss);
   
   if (logs) Print("Showing Comment Box");
   Comment(infobox);
   if (logs) Print("Initializing Ended");
   //custom_start();//remove this when trade starts
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
   custom_start();   
//----
   return(0);
  }
//+------------------------------------------------------------------+

void custom_start()
{
   if (logs) Print("Starting the Robot");
   showinfobox = StringConcatenate(
      "\n","\n",
      "Bid Price: ", DoubleToStr(Bid,Digits),
      "\n",
      "Ask Price: ", DoubleToStr(Ask,Digits),
      "\n","\n",
      "Account balance = ",AccountBalance(),
      "\n",
      "Account equity = ",AccountEquity(),
      "\n",
      "Account credit = ",AccountCredit(),
      "\n",
      "Account free margin = ",AccountFreeMargin(),
      "\n",
      "Account margin = ",AccountMargin(),
      "\n",
      "Account profit = ",AccountProfit(),
      "\n",
      "Optimized Lot Size = ", DoubleToStr(LotsOptimized(),Digits),
      "\n");
   Comment(infobox, showinfobox);
   if (logs) Print("Checking Bars and if trade is allowed");
   if(Bars<100 || IsTradeAllowed()==false) {
      if (logs) Print("bars: ", Bars, ", Trade Allowed: ", IsTradeAllowed(),", so stopping the EA");
      return;
   }
   // some hard calculations...
   int start=GetTickCount();
   int orders = 0;
   int result = 0;
   
   orders = CalculateCurrentMaxOrders();
   if (logs) Print("current orders: ", orders);
   if (orders >= maxorders) {
      Print("Max Orders Reached.");
      return;
   }
   orders = CalculateCurrentOrders();
   if (logs) Print("orders: ", orders);

   string strategytext;
   if(orders==0) {
      //calculate the necessary variables
      ichimoku(number);
      //strategies
      if (old_strategy) {
         strategytext = "old_strategy";
         if (logs) Print("strategy: ", strategytext);
         result = old_strategy();
      } if (old_modified_strategy) {
         strategytext = "old_modified_strategy";
         if (logs) Print("strategy: ", strategytext);
         result = old_modified_strategy();
      } else if (ideal_ichimoku_strategy) {
         strategytext = "ideal_ichimoku_strategy";
         if (logs) Print("strategy: ", strategytext);
         result = ideal_ichimoku_strategy();
      } else if (tenkan_senlykijwl_strategy) {
         strategytext = "tenkan_senlykijwl_strategy";
         if (logs) Print("strategy: ", strategytext);
         result = tenkan_senlykijwl_strategy();
      } else if (kijun_sen_cross_strategy) {
         strategytext = "kijun_sen_cross_strategy";
         if (logs) Print("strategy: ", strategytext);
   
      } else if (kumo_cloud_breakout_strategy) {
         strategytext = "kumo_cloud_breakout_strategy";
         if (logs) Print("strategy: ", strategytext);
   
      } else if (future_senkou_strategy) {
         strategytext = "future_senkou_strategy";
         if (logs) Print("strategy: ", strategytext);
   
      } else {
         if (logs) Print("No strategy defined");
         return;  
      }
      if (logs) Print("Zero orders for ", Symbol(), ", so checking for open condition");
      createOrder(result);
   } else {
      if (logs) Print(orders, " orders for ", Symbol(), ", so checking for close condition");
      CheckForClose();
   }

   // some hard calculations...
   if (logs) Print("Calculation time is ", GetTickCount()-start, " milliseconds.");
}

//+------------------------------------------------------------------+
//| expert calculate ichimoku function                                            |
//+------------------------------------------------------------------+
int ichimoku(int i)
  {
//----
   int    k;
   double high,low,price;
   //get Tenkan
   Tenkan_Buffer = tenkanget(i);
   //get Kijun
   Kijun_Buffer = kijunget(i);
   //get chinkou
   Chinkou_Buffer = chinkouget(i);
   SpanA_Buffer = senkouspanaget(i);
   SpanB_Buffer = senkouspanbget(i);
   //spanA should be always greater for our calculation
   if (SpanA_Buffer < SpanB_Buffer) {
      double tmp = SpanA_Buffer;
      SpanA_Buffer = SpanB_Buffer;
      SpanB_Buffer = tmp;
   }
   if (logs) Print("Summary: Number: ", number, ", Tenkan_Buffer: ", Tenkan_Buffer, 
   ". Kijun_Buffer: ", Kijun_Buffer, ". Chinkou_Buffer: ", Chinkou_Buffer, 
   ". SpanA_Buffer: ", SpanA_Buffer, ". SpanB_Buffer: ", SpanB_Buffer);
      
//----
   return(0);
  }
 
 
 double tenkanget(int i)
 {
 double high,low,price;
 int k;
   high=High[i]; low=Low[i]; k=i-1+Tenkan;
      while(k>=i)
        {
         price=High[k];
         if(high<price) high=price;
         price=Low[k];
         if(low>price)  low=price;
         k--;
        }
         double tmp =(high+low)/2;
         if (logs) Print("Tenkan_Buffer: ", i, " - ", tmp);
         return (tmp);
 }
 
 
 double kijunget(int i)
 {
 double high,low,price;
 int k;
   high=High[i]; low=Low[i]; k=i-1+Kijun;
      while(k>=i)
        {
         price=High[k];
         if(high<price) high=price;
         price=Low[k];
         if(low>price)  low=price;
         k--;
        }
         double tmp =(high+low)/2;
         if (logs) Print("Kijun_Buffer: ", i, " - ", tmp);
         return (tmp);
 }
 
 
 int chinkouget(int i)
 {
 double high,low;
 int j;
      j = (i + 26);
    high = High[j];
     low = Low[j];
   double tmp = Close[i];
   int tmp1;
     if (tmp >= high){
      tmp1 = 1;
      } else if (tmp <= low){
      tmp1 = -1;
     } else {
     tmp1 = 0;
     }
      if (logs) Print("Chinkou_Buffer1: ", i, " = ", tmp1);
      return (tmp1);
 }
 
 //come back later to test this
 double senkouspanaget(int i)
 {
   double price;
   double k;
   double t;
   int j;
   j = i + Kijun - 1;
   t = tenkanget(j); 
   k = kijunget(j); 
   price=(k+t)/2;
   if (logs) Print("senko span A: ", price);
   return (price);
 }
 double senkouspanbget(int i)
 {
   double price;
   double high,low;
   int j,k;
   j = i + Kijun - 1;
   high=High[j]; low=Low[j]; k=j+Senkou;
   while(k>=j)
   {
      price=High[k];
      if(high<price) high=price;
      price=Low[k];
      if(low>price)  low=price;
      k--;
   }
   price=(high+low)/2;
   if (logs) Print("senko span B: ", price);
   return (price);
 }
 
 double LotsOptimized()
 {
   double lot=lots;
   if (lots > 0) {
      if (logs) Print("Lot size is: ", lots);
      return (lots);
   } else if (custom_account_balance > 0) {
      lot=NormalizeDouble((custom_account_balance/5.0)/1000, 2);
      if (logs) Print("Lot size is: ", lot);
      return (lot);
   } else {
      lot=NormalizeDouble((AccountFreeMargin()/5.0)/1000, 2);
      if (logs) Print("Lot size is: ", lot);
      return (lot);
   }
 }
 
 void CheckForClose()
 {
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()!=MAGICMA) continue;
      //---- check order type 
      //Print("order type: ", OrderType());
      if(OrderType()==OP_BUY)
        {
        //put condition and then close
         //OrderClose(OrderTicket(),OrderLots(),Bid,3,White);
        }
      if(OrderType()==OP_SELL)
        {
        //put condition and then close
         //if(Open[1]<ma && Close[1]>ma) OrderClose(OrderTicket(),OrderLots(),Ask,3,White);
        }
     }
 }
 
 void createOrder(int result)
  {
      string message, r;
      if (result == 0) {
         return;
      }

      if (!useCreateOrder) {
         if (logs) Print("order creation is disabled.");
         return;
      }
      string per = TimeframeToString(Period());
      
      Alert("low: ",Low[1],", high: ",High[1], ", connectionTenkan: ",connectionTenkan, ", symbol: ", Symbol(), ", time: ", per);
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
         r = OrderSend(Symbol(), OP_BUY, LotsOptimized(), Ask, 3, sl, tp, "", MAGICMA, 0, Blue);
         //ending order
         Print("Result for buy: ", r);
         message = StringConcatenate("Order created for symbol: ", Symbol(), " with lot size: ", LotsOptimized(), ", sl: ", sl, ", tp: ", tp, ", with error: ", GetLastError());
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
         r = OrderSend(Symbol(),OP_SELL,LotsOptimized(),Bid,3,sl,tp,"",MAGICMA,0,Red);
         //ending order
         Print("Result for sell: ", r);
         message = StringConcatenate("Order created for symbol: ", Symbol(), " with lot size: ", LotsOptimized(), ", sl: ", sl, ", tp: ", tp, ", with error: ", GetLastError());
         if (logs) Print(message);
         SendAlert(message);
      } else {
         //no sell and buy
         if (logs) Print("No sell or buy in createOrder.");
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
int connection(int i)
{
   double price;
   double k;
   double t;
   int j;
   int a = i + 1; //int a = i + 5;
   int b = i + 1;
   if (logs) Print("connection: a is ", a, ", b is ", b);
   for (j=b; j<=a; j++) {
      t = tenkanget(j);
      k = kijunget(j);
      if (logs) Print("Connection for id: ", j, " is t = ", NormalizeDouble(t, 4), " and k = ", NormalizeDouble(k, 4));
      if (NormalizeDouble(t, 4) == NormalizeDouble(k, 4)) {
         /*// now check if past 5 reading should not have connection
         for (int x=j+1; x<(j+1+5); x++) {
            t = tenkanget(x);
            k = kijunget(x);
            if (NormalizeDouble(t, 4) == NormalizeDouble(k, 4)) {
               if (implogs) Print("Connection not found for: ", x);
               return (0);
            }
         }*/
         if (logs) Print("Connection match found for j: ", j);
         connectionTenkan = t;
         connectionTenkanNumber = j;
         if (logs) Print("connectionTenkan: ", connectionTenkan, ", connectionTenkanNumber: ", connectionTenkanNumber);
         return (1);
      }  
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

//+------------------------------------------------------------------+

//new functions
/*
void analysis() {
   if (logs) Print("Starting Analysis");
   string analysisResults[10];
   //A. Price vs. Kumo Cloud
   analysisResults[0] = "";
   if (Ask >= SpanA_Buffer)
      analysisResults[0] = "Bullish";
   else if (Ask <= SpanB_Buffer)
      analysisResults[0] = "Bearish";
   else if (Ask <= SpanA_Buffer && Ask >= SpanB_Buffer)
      analysisResults[0] = "Consolidation";
   
   //C.Tenkan Sen/Kijun Sen
   analysisResults[1] = "";
   if (Tenkan_Buffer > Kijun_Buffer)
      analysisResults[1] = "Bullish";
   else if (Tenkan_Buffer < Kijun_Buffer)
      analysisResults[1] = "Bearish";
   else if (Tenkan_Buffer == Kijun_Buffer)
      analysisResults[1] = "Neutral";
 
   //difference between kijun and Ask
   double diff_kijun_ask;
   if (Kijun_Buffer >= Ask) {
      diff_kijun_ask = Kijun_Buffer - Ask;
   } else if (Kijun_Buffer < Ask) {
      diff_kijun_ask = Ask - Kijun_Buffer;
   }
   analysisResults[2] = diff_kijun_ask;
   //difference between Tenkan and Ask
   double diff_tenkan_ask;
   if (Tenkan_Buffer >= Ask) {
      diff_tenkan_ask = Tenkan_Buffer - Ask;
   } else if (Tenkan_Buffer < Ask) {
      diff_tenkan_ask = Ask - Tenkan_Buffer;
   }
   analysisResults[3] = diff_tenkan_ask;

   //Are they in the Kumo Cloud?
   analysisResults[4] = "";
   if (Tenkan_Buffer > SpanB_Buffer && Tenkan_Buffer < SpanA_Buffer)
      analysisResults[4] = "Consolidation"; //Consolidation -> Tenkan Sen in Kuma Cloud (weak)
   else if (Kijun_Buffer > SpanB_Buffer && Kijun_Buffer < SpanA_Buffer)
      analysisResults[4] = "Consolidation"; //Consolidation -> Kijun Sen in Kumo Cloud (weak)
   else
      analysisResults[4] = "No Consolidation"; //No Consolidation (strong)
  
   for (int i=0; i<5; i++) {
      Print(i, ": ", analysisResults[i]);   
   }
}*/
int old_strategy()
 {
      int conn;
      string message,r;
      if (logs) Print("Summary: Number: ", number, ", Tenkan_Buffer: ", Tenkan_Buffer, 
   ". Kijun_Buffer: ", Kijun_Buffer, ". Chinkou_Buffer: ", Chinkou_Buffer, 
   ". SpanA_Buffer: ", SpanA_Buffer, ". SpanB_Buffer: ", SpanB_Buffer);
      
      //check if lines are crossed:
      if (logs) Print("Cross checking");
      conn = connection(number);
      if (logs) Print("Connection result: ", conn);
      if (conn == 1) {
         message = StringConcatenate("Cross Connection happened on Time Frame", TimeframeToString(Period()), 
         " for symbol: ", Symbol(),
         ", Summary: Number: ", number, ", Tenkan_Buffer: ", Tenkan_Buffer, 
   ". Kijun_Buffer: ", Kijun_Buffer, ". Chinkou_Buffer: ", Chinkou_Buffer, 
   ". SpanA_Buffer: ", SpanA_Buffer, ". SpanB_Buffer: ", SpanB_Buffer);
         if (logs) Print(message);
         SendAlert(message);
      }
   
      //STRONG CONDITION FOR BUY
      //Open Condition for buy, A. Tenkan_Buffer > Kijun_Buffer && B. Tenkan_Buffer == Kijun_Buffer in previous 5 readings && 
      //C.Chinkou_Buffer = 1 && D. Tenkan_Buffer > SpanA_Buffer
      if (Tenkan_Buffer > Kijun_Buffer && Chinkou_Buffer == 1 && Tenkan_Buffer > SpanA_Buffer) {
         if (logs) Print("Condition 1");
         conn = connection(number);
         if (logs) Print("Connection result: ", conn);
         if (conn == 1) {
            message = StringConcatenate("{*Strong*} Buy condition exists on Time Frame", TimeframeToString(Period()), 
         " for symbol: ", Symbol(),
         ", A. Tenkan_Buffer > Kijun_Buffer && B. Tenkan_Buffer == Kijun_Buffer in previous 5 readings && C.Chinkou_Buffer = 1 && D. Tenkan_Buffer > SpanA_Buffer, Summary: Number: ", number, ", Tenkan_Buffer: ", Tenkan_Buffer, 
            ". Kijun_Buffer: ", Kijun_Buffer, ". Chinkou_Buffer: ", Chinkou_Buffer, 
            ". SpanA_Buffer: ", SpanA_Buffer, ". SpanB_Buffer: ", SpanB_Buffer);
            if (logs) Print(message);
            SendAlert(message);
            return (1);
         }
      }
      //STRONG CONDITION FOR SELL
      //Open Condition for sell, A. Tenkan_Buffer < Kijun_Buffer && B. Tenkan_Buffer == Kijun_Buffer in previous 5 readings && 
      //C.Chinkou_Buffer = -1 && D. Tenkan_Buffer < SpanB_Buffer
      else if (Tenkan_Buffer < Kijun_Buffer && Chinkou_Buffer == -1 && Tenkan_Buffer < SpanB_Buffer) {
         if (logs) Print("Condition 2");
         conn = connection(number);
         if (logs) Print("Connection result: ", conn);
         if (conn == 1) {
            message = StringConcatenate("{*Strong*} Sell condition exists on Time Frame", TimeframeToString(Period()), 
         " for symbol: ", Symbol(),
         ", A. Tenkan_Buffer < Kijun_Buffer && B. Tenkan_Buffer == Kijun_Buffer in previous 5 readings && //C.Chinkou_Buffer = -1 && D. Tenkan_Buffer < SpanB_Buffer, Summary: Number: ", number, ", Tenkan_Buffer: ", Tenkan_Buffer, 
   ". Kijun_Buffer: ", Kijun_Buffer, ". Chinkou_Buffer: ", Chinkou_Buffer, 
   ". SpanA_Buffer: ", SpanA_Buffer, ". SpanB_Buffer: ", SpanB_Buffer);
            if (logs) Print(message);
            SendAlert(message);
            return (-1);
         }
      } 
      //NEUTRAL CONDITION FOR BUY
      //Open Condition for buy, A. Tenkan_Buffer > Kijun_Buffer && B. Tenkan_Buffer == Kijun_Buffer in previous 5 readings && 
      //C.Chinkou_Buffer = 1 && D. Tenkan_Buffer > SpanB_Buffer && D. Tenkan_Buffer < SpanA_Buffer
      else if(Tenkan_Buffer > Kijun_Buffer && Chinkou_Buffer == 1 && Tenkan_Buffer > SpanB_Buffer && Tenkan_Buffer < SpanA_Buffer) {
         if (logs) Print("Condition 3");
         if (logs) Print("Connection result: ", conn);
         if (conn == 1) {
            message = StringConcatenate("{*Neutral*} Buy condition exists on Time Frame", TimeframeToString(Period()), 
         " for symbol: ", Symbol(),
         ", A. Tenkan_Buffer > Kijun_Buffer && B. Tenkan_Buffer == Kijun_Buffer in previous 5 readings && C.Chinkou_Buffer = 1 && D. Tenkan_Buffer > SpanB_Buffer && D. Tenkan_Buffer < SpanA_Buffer, Summary: Number: ", number, ", Tenkan_Buffer: ", Tenkan_Buffer, 
            ". Kijun_Buffer: ", Kijun_Buffer, ". Chinkou_Buffer: ", Chinkou_Buffer, 
            ". SpanA_Buffer: ", SpanA_Buffer, ". SpanB_Buffer: ", SpanB_Buffer);
            if (logs) Print(message);
            SendAlert(message);
            if (bid_neutral_weak_also) {
               return (1);
            }

            return (0);
         }
      }
      //Neutral CONDITION FOR SELL
      //Open Condition for sell, A. Tenkan_Buffer < Kijun_Buffer && B. Tenkan_Buffer == Kijun_Buffer in previous 5 readings && 
      //C.Chinkou_Buffer = -1 && D. Tenkan_Buffer > SpanB_Buffer && D. Tenkan_Buffer < SpanA_Buffer
      else if (Tenkan_Buffer < Kijun_Buffer && Chinkou_Buffer == -1 && Tenkan_Buffer > SpanB_Buffer && Tenkan_Buffer < SpanA_Buffer) {
         if (logs) Print("Condition 4");
         conn = connection(number);
         if (logs) Print("Connection result: ", conn);
         if (conn == 1) {
            message = StringConcatenate("{*Neutral*} Sell condition exists on Time Frame", TimeframeToString(Period()), 
         " for symbol: ", Symbol(),
         ", A. Tenkan_Buffer < Kijun_Buffer && B. Tenkan_Buffer == Kijun_Buffer in previous 5 readings && C.Chinkou_Buffer = -1 && D. Tenkan_Buffer > SpanB_Buffer && D. Tenkan_Buffer < SpanA_Buffer, Summary: Number: ", number, ", Tenkan_Buffer: ", Tenkan_Buffer, 
   ". Kijun_Buffer: ", Kijun_Buffer, ". Chinkou_Buffer: ", Chinkou_Buffer, 
   ". SpanA_Buffer: ", SpanA_Buffer, ". SpanB_Buffer: ", SpanB_Buffer);
            if (logs) Print(message);
            SendAlert(message);
            if (bid_neutral_weak_also) {
               return (-1);
            }
            return (0);
         }
      }
      //Weak condition for buy
      else if(Tenkan_Buffer > Kijun_Buffer && Chinkou_Buffer == 1 && Tenkan_Buffer < SpanB_Buffer) {
         if (logs) Print("Condition 5");
         conn = connection(number);
         if (logs) Print("Connection result: ", conn);
         if (conn == 1) {
            message = StringConcatenate("{*Weak*} buy condition exists on Time Frame", TimeframeToString(Period()), 
         " for symbol: ", Symbol(),
         ", Tenkan_Buffer > Kijun_Buffer && Chinkou_Buffer == 1 && Tenkan_Buffer < SpanB_Buffer, Summary: Number: ", number, ", Tenkan_Buffer: ", Tenkan_Buffer, 
   ". Kijun_Buffer: ", Kijun_Buffer, ". Chinkou_Buffer: ", Chinkou_Buffer, 
   ". SpanA_Buffer: ", SpanA_Buffer, ". SpanB_Buffer: ", SpanB_Buffer);
            if (logs) Print(message);
            SendAlert(message);
            if (bid_neutral_weak_also) {
               return (1);
            }
            return (0);
         }
      }
      //Weak condition for sell
      else if(Tenkan_Buffer < Kijun_Buffer && Chinkou_Buffer == -1 && Tenkan_Buffer > SpanA_Buffer) {
         if (logs) Print("Condition 6");
         conn = connection(number);
         if (logs) Print("Connection result: ", conn);
         if (conn == 1) {
            message = StringConcatenate("{*Weak*} sell condition exists on Time Frame", TimeframeToString(Period()), 
         " for symbol: ", Symbol(),
         ", Tenkan_Buffer < Kijun_Buffer && Chinkou_Buffer == -1 && Tenkan_Buffer > SpanA_Buffer, Summary: Number: ", number, ", Tenkan_Buffer: ", Tenkan_Buffer, 
   ". Kijun_Buffer: ", Kijun_Buffer, ". Chinkou_Buffer: ", Chinkou_Buffer, 
   ". SpanA_Buffer: ", SpanA_Buffer, ". SpanB_Buffer: ", SpanB_Buffer);
            if (logs) Print(message);
            SendAlert(message);
            if (bid_neutral_weak_also) {
               return (-1);
            }
            return (0);
         }
      
      }
      else {
         if (logs) Print("Condition Else");
         if (logs) Print("No buy and sell condition exists");
         return (0);
      }

      return (0);
 }

int old_modified_strategy()
{
      int conn;
      string message,r;
      
      //check if lines are crossed:
      if (logs) Print("Cross checking");
      conn = connection(number);
      if (logs) Print("Connection result: ", conn);
      if (conn == 1) {
         message = StringConcatenate("Cross Connection happened on Time Frame", TimeframeToString(Period()), 
         " for symbol: ", Symbol(),
         ", Summary: Number: ", number, ", Tenkan_Buffer: ", Tenkan_Buffer, 
   ". Kijun_Buffer: ", Kijun_Buffer, ". Chinkou_Buffer: ", Chinkou_Buffer, 
   ". SpanA_Buffer: ", SpanA_Buffer, ". SpanB_Buffer: ", SpanB_Buffer);
         if (logs) Print(message);
         //buy condition
         if (Tenkan_Buffer > Kijun_Buffer && connectionTenkan <= Low[connectionTenkanNumber] 
            && Open[connectionTenkanNumber] < Close[connectionTenkanNumber]
            && Tenkan_Buffer > connectionTenkan
            ) {
             if (implogs) Print("sell condition exists on Time Frame", TimeframeToString(Period()), 
         " for symbol: ", Symbol(), ", Summary: Number: ", number, ", Tenkan_Buffer: ", Tenkan_Buffer, 
   ". Kijun_Buffer: ", Kijun_Buffer, ". Chinkou_Buffer: ", Chinkou_Buffer, 
   ". SpanA_Buffer: ", SpanA_Buffer, ". SpanB_Buffer: ", SpanB_Buffer);
            return (1);
         }
         //sell condition
         else if (Tenkan_Buffer < Kijun_Buffer && connectionTenkan >= High[connectionTenkanNumber] 
            && Open[connectionTenkanNumber] > Close[connectionTenkanNumber]
            && Tenkan_Buffer < connectionTenkan
            ) {
            if (implogs) Print("sell condition exists on Time Frame", TimeframeToString(Period()), 
         " for symbol: ", Symbol(), ", Summary: Number: ", number, ", Tenkan_Buffer: ", Tenkan_Buffer, 
   ". Kijun_Buffer: ", Kijun_Buffer, ". Chinkou_Buffer: ", Chinkou_Buffer, 
   ". SpanA_Buffer: ", SpanA_Buffer, ". SpanB_Buffer: ", SpanB_Buffer);
            return (-1);
         }
         //wait
         else {
            if (implogs) Print("no buy and sell condition, please wait on Time Frame: ", TimeframeToString(Period()), 
         " for symbol: ", Symbol());
         }
      } else {
           if (logs) Print("consolidation, please wait on Time Frame:", TimeframeToString(Period()), 
         " for symbol: ", Symbol());
      }
}

int ideal_ichimoku_strategy()
{
   int conn;
   string message;
   //buy condition
   /*
      • Price above the Kuma Cloud.
      • Tenkan Sen greater Ulan the Kijun Sen.
      • Chikou Span is greater than the price from 26 periods ago.
      • Future Senkou A is greater than the Future Senkou B. (not yet implemented)
      • Price is not far from K.iun Sen and Tenkan Sen.  (not yet implemented)
      • Tenkan Sen, Kijun Sen, and Chikou Span should not be in a Ulick Kuma Cloud.
   */
   if (Ask > SpanA_Buffer && Tenkan_Buffer > Kijun_Buffer && Close[26] > Ask && Tenkan_Buffer > SpanA_Buffer && Kijun_Buffer > SpanA_Buffer && Close[26] > SpanA_Buffer) {
      if (logs) Print("Condition 1");
      conn = connection(number);
      if (logs) Print("Connection result: ", conn);
      if (conn == 1) {
         message = StringConcatenate("Ask > SpanA_Buffer && Tenkan_Buffer > Kijun_Buffer && Chinkou_Buffer == 1 && Tenkan_Buffer > SpanA_Buffer", 
         "Summary: Number: ", number, ", Tenkan_Buffer: ", Tenkan_Buffer, 
         ". Kijun_Buffer: ", Kijun_Buffer, ". Chinkou_Buffer: ", Chinkou_Buffer, 
         ". SpanA_Buffer: ", SpanA_Buffer, ". SpanB_Buffer: ", SpanB_Buffer);
         if (logs) Print(message);
         SendAlert(message);
         return (1);
      }
   }
   //sell condition
   /*
      • Price below the Kuma Cloud.
      • Tenkan Sen less than the Kijun Sen.
      • Chikou Span is less than the price from 26 periods ago.
      • Future Senkou A is less than the Future Senkou B.
      • Price is not far from Kijun Sen and Tenkan Sen.
      • Tenkan Sen, Kijun Sen, and Chikou Span should not be in a thick Kumo Cloud.
   */
   if (Bid < SpanB_Buffer && Tenkan_Buffer < Kijun_Buffer && Chinkou_Buffer == -1 && Tenkan_Buffer < SpanB_Buffer) {
      if (logs) Print("Condition 2");
      conn = connection(number);
      if (logs) Print("Connection result: ", conn);
      if (conn == 1) {
         message = StringConcatenate("Bid < SpanB_Buffer && Tenkan_Buffer < Kijun_Buffer && Chinkou_Buffer == -1 && Tenkan_Buffer < SpanB_Buffer", 
         "Summary: Number: ", number, ", Tenkan_Buffer: ", Tenkan_Buffer, 
         ". Kijun_Buffer: ", Kijun_Buffer, ". Chinkou_Buffer: ", Chinkou_Buffer, 
         ". SpanA_Buffer: ", SpanA_Buffer, ". SpanB_Buffer: ", SpanB_Buffer);
         if (logs) Print(message);
         SendAlert(message);
         return (-1);
      }
   }
  
   if (logs) Print("No more buy and sell condition");
   return (0);
}

int tenkan_senlykijwl_strategy()
{
   int conn;
   string message;
   //buy condition
   /*
      • Price is above the Kuma Cloud or it can be a certain distance below a
nonUlick Kuma Cloud. For currencies, I use a value of 50 pips below
the Kuma Cloud as long as the cloud is a thin cloud. I want a thin cloud
because I am assuming that price is goi ng to go right through the cloud
to the upside.
• Tenkan Sen is crossing above the Kijun Sen.
• Chikou San is in "open space. ..
• Price, Tenkan Sen, Kijllll Sen, and Chikou should not be in the Kuma
Cloud. If they are, it should be a thick cloud.
• Optional: F'uture Senkou A is greater than or equal to the F'uture
Senkou B.
• Optional: F'uture Kuma Cloud is not thick.
   */
   if (Ask > SpanA_Buffer && Tenkan_Buffer > Kijun_Buffer && Chinkou_Buffer == 1 && Tenkan_Buffer > SpanA_Buffer) {
      if (logs) Print("Condition 1");
      conn = connection(number);
      if (logs) Print("Connection result: ", conn);
      if (conn == 1) {
         message = StringConcatenate("Ask > SpanA_Buffer && Tenkan_Buffer > Kijun_Buffer && Chinkou_Buffer == 1 && Tenkan_Buffer > SpanA_Buffer", 
         "Summary: Number: ", number, ", Tenkan_Buffer: ", Tenkan_Buffer, 
         ". Kijun_Buffer: ", Kijun_Buffer, ". Chinkou_Buffer: ", Chinkou_Buffer, 
         ". SpanA_Buffer: ", SpanA_Buffer, ". SpanB_Buffer: ", SpanB_Buffer);
         if (logs) Print(message);
         SendAlert(message);
         return (1);
      }
   }
   //sell condition
   /*
     • Price is below the Kuma Cloud or it can be a certain distance below a
nonUlick Kumo Cloud. For currencies, I use a value of 50 pips above
the Kuma Cloud as long as the cloud is a thin cloud. I want a thin cloud
because I am assuming that price is going to go right through the cloud
to the downside.
• Tenkan Sen is crossing below the Kijun Sen.
• Chikou San is in "open space.'"
• Price, Tenkan Sen, Kijun Sen, and Chikou should not be in the Kumo
Cloud. If they are, it should be a thick cloud.
• Optional: Future Senkou A is less than or equal to the Future Senkou B.
• Optional: Future Kumo Cloud is not thick.
   */
   if (Bid < SpanB_Buffer && Tenkan_Buffer < Kijun_Buffer && Chinkou_Buffer == -1 && Tenkan_Buffer < SpanB_Buffer) {
      if (logs) Print("Condition 2");
      conn = connection(number);
      if (logs) Print("Connection result: ", conn);
      if (conn == 1) {
         message = StringConcatenate("Bid < SpanB_Buffer && Tenkan_Buffer < Kijun_Buffer && Chinkou_Buffer == -1 && Tenkan_Buffer < SpanB_Buffer", 
         "Summary: Number: ", number, ", Tenkan_Buffer: ", Tenkan_Buffer, 
         ". Kijun_Buffer: ", Kijun_Buffer, ". Chinkou_Buffer: ", Chinkou_Buffer, 
         ". SpanA_Buffer: ", SpanA_Buffer, ". SpanB_Buffer: ", SpanB_Buffer);
         if (logs) Print(message);
         SendAlert(message);
         return (-1);
      }
   }
  
   if (logs) Print("No more buy and sell condition");
   return (0);
}