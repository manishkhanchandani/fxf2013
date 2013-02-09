//+------------------------------------------------------------------+
//|                                                    5_master1.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#define MAGICMA  20050611

extern bool UseAlerts = true;
extern bool UseEmailAlerts = false;
extern double Lots               = 0.1;
extern double MaximumRisk        = 0.02;
extern double DecreaseFactor     = 3;
double open = 0;
double close = 0;
double high = 0;
double low = 0;
string trend = "";
string trend_yesterday = "";
string trend_yesterday_type = "";
double start = 0;
double end = 0;
double diff = 0;
int buycount = 0;
int sellcount = 0;
string r = "";

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   open = Bid;
   high = Bid;
   low = Bid;
   if (Digits == 3)
      diff = 0.025;
   else
      diff = 0.00025;
   start = Bid + diff;
   end = Bid - diff;
      Print("bid - open", DoubleToStr((Bid - Open[1]), Digits));
      Print("bid - close", DoubleToStr((Bid - Close[1]), Digits));
      if ((Bid - Open[1]) > (Bid - Close[1])) {
         trend_yesterday = "Open";
      } else {
         trend_yesterday = "Close";
      }  
   if (Open[1] >= Close[1]) {
      trend_yesterday_type = "Sell";
   } else if (Close[1] >= Open[1]) {
      trend_yesterday_type = "Buy";
   }
   
   if (trend_yesterday_type == "Sell" && trend_yesterday == "Open") {
      Print("Sell - Open");
      
   } else if (trend_yesterday_type == "Sell" && trend_yesterday == "Close") {
      Print("Sell - Close");
   } else if (trend_yesterday_type == "Buy" && trend_yesterday == "Open") {
      Print("Buy - Open");
   } else if (trend_yesterday_type == "Buy" && trend_yesterday == "Close") {
      Print("Buy - Close");
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
   if (Bid < low)
      low = Bid;
   if (Bid > high)
      high = Bid;
   if (Bid > start) {
      start = Bid + diff;
      end = Bid - diff;
      trend = "Buy";
      buycount++;
   } else if (Bid < end) {
      start = Bid + diff;
      end = Bid - diff;
      trend = "Sell";
      sellcount++;
   }
   if (trend == "Buy") {
      createbuyorder(LotsOptimized());
   } else if (trend == "Sell") {
      createsellorder(LotsOptimized());
   }
   Comment("\n\n\nCustom Open Price: ", DoubleToStr(open, Digits), "\nCustom High Price: ", DoubleToStr(high, Digits), "\nCustom Low Price: ", DoubleToStr(low, Digits)
   , "\n\nOpen Price: ", DoubleToStr(Open[1], Digits)
   , "\nHigh Price: ", DoubleToStr(High[1], Digits)
   , "\nLow Price: ", DoubleToStr(Low[1], Digits)
   , "\nClose Price: ", DoubleToStr(Close[1], Digits)
   , "\nDiff: ", DoubleToStr(diff, Digits)
   , "\nCurrent Bid: ", DoubleToStr(Bid, Digits)
   , "\nStart: ", DoubleToStr(start, Digits)
   , "\nEnd: ", DoubleToStr(end, Digits)
   , "\nTrend: ", trend
   , "\nBuycount: ", buycount
   , "\nSellcount: ", sellcount
   );
//----
   return(0);
  }

void createbuyorder(double amount)
{
   int buys=0;
   for(int i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol())
        {
         if(OrderType()==OP_BUY)  buys++;
         //if(OrderType()==OP_SELL) sells++;
        }
   
   }
   if (buys == 0) {
      r = OrderSend(Symbol(), OP_BUY, amount, Ask, 3, 0, 0, "", MAGICMA, 0, Blue);
      Print("Result for buy: ", r);
      Print("error: ", GetLastError());
   }
}
void createsellorder(double amount)
{
   int sells=0;
   for(int i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol())
        {
         if(OrderType()==OP_SELL) sells++;
        }
   
   }
   if (sells == 0) {
      r = OrderSend(Symbol(),OP_SELL,amount,Bid,3,0,0,"",MAGICMA,0,Red);
      Print("Result for sell: ", r);
      Print("error: ", GetLastError());
   }
}

double LotsOptimized()
  {
   double lot=Lots;
   int    orders=HistoryTotal();     // history orders total
   int    losses=0;                  // number of losses orders without a break
//---- select lot size
   lot=NormalizeDouble(AccountFreeMargin()*MaximumRisk/1000.0,1);
//---- calcuulate number of losses orders without a break
   if(DecreaseFactor>0)
     {
      for(int i=orders-1;i>=0;i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
         if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL) continue;
         //----
         if(OrderProfit()>0) break;
         if(OrderProfit()<0) losses++;
        }
      if(losses>1) lot=NormalizeDouble(lot-lot*losses/DecreaseFactor,1);
     }
//---- return lot size
   if(lot<0.1) lot=0.1;
   return(lot);
  }
//+------------------------------------------------------------------+