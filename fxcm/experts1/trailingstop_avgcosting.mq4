//+------------------------------------------------------------------+
//|                                                 trailingstop.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

string infobox;
//extern double Lots = 0.05;
extern int TrailingStop = 50;
extern int initTrailingStop = 100;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   /*infobox = "";
   avg_costing(Symbol());
   infobox = StringConcatenate("Account #",AccountNumber(), "\nSpread: ", MarketInfo(Symbol(), MODE_SPREAD), "\n"
            , "Account Leverage: ", AccountLeverage()
            , ", Account free margin = ",AccountFreeMargin()
            ,", Lotsize: ", MarketInfo(Symbol(), MODE_LOTSIZE)
   , infobox);
   Comment(infobox);*/
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
   avg_costing(Symbol());
   infobox = StringConcatenate("Account #",AccountNumber(), "\nSpread: ", MarketInfo(Symbol(), MODE_SPREAD), "\n"
            , "Account Leverage: ", AccountLeverage()
            , ", Account free margin = ",AccountFreeMargin()
            ,", Lotsize: ", MarketInfo(Symbol(), MODE_LOTSIZE)
   , infobox);
   Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+


int avg_costing(string symbol)
{
   int cnt, ticket, total;
   total=OrdersTotal();
   double bids, asks, pt;
   int digit;
               bids = MarketInfo(symbol, MODE_BID);
               asks = MarketInfo(symbol, MODE_ASK);
               pt = MarketInfo(symbol, MODE_POINT);
               digit = MarketInfo(symbol, MODE_DIGITS);
   int orders;
   infobox = StringConcatenate(infobox, "\nAverage Costing For Symbol: ", symbol, "\n");
   double num;
   double openprice;
   double lotsize;
   double lotsavg = 0.0;
   double totalcost = 0.0;
   int type = 0;
   int x = 0;
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol()==symbol)  // check for symbol
         {
            x++;
            num = 500 * pt;
            openprice = OrderOpenPrice();
            lotsize = OrderLots();
            lotsavg = lotsavg + lotsize;
            totalcost = totalcost + (lotsize * openprice);
            if(OrderType()==OP_BUY) {
               type = 1;            
            } else if(OrderType()==OP_SELL) {
               type = -1;            
            }
            infobox = StringConcatenate(infobox, "Type: ", type);
            infobox = StringConcatenate(infobox, " - Openprice: ", DoubleToStr(openprice, digit));
            infobox = StringConcatenate(infobox, " - Order Profit: ", OrderProfit());
            infobox = StringConcatenate(infobox, "\n");
         }
     }
     if (x == 0) {
      infobox = StringConcatenate(infobox, "No Orders Found");
      return (0);
     }
     double cost = 0.0;
     cost = totalcost / lotsavg;
     infobox = StringConcatenate(infobox, "Current Average: ", DoubleToStr(cost, digit));
     infobox = StringConcatenate(infobox, " - ");
     infobox = StringConcatenate(infobox, "Totalcost: ", totalcost);
     infobox = StringConcatenate(infobox, " - ");
     infobox = StringConcatenate(infobox, "Lots: ", lotsavg);
     infobox = StringConcatenate(infobox, "\n");
     trailingstop(cost);
     /*for (int j=1;j<11;j++) {
         lotsize = Lots * j;
         cost = (totalcost + (lotsize * openprice)) / (lotsavg + lotsize);
         infobox = StringConcatenate(infobox, "Lots: ", lotsize, ", total lots: ", (lotsavg + lotsize));
         infobox = StringConcatenate(infobox, " - Avg: ", DoubleToStr(cost, digit));
         infobox = StringConcatenate(infobox, "\n");
    }*/
}

int trailingstop(double price)
{
   infobox = StringConcatenate(infobox, "\n");
   int cnt, ticket, total;
   total=OrdersTotal();
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL  // check for opened position
         && OrderSymbol()==Symbol()
      )  // check for symbol
         {
         infobox = StringConcatenate(infobox, "\n", Symbol(), ", Bid: ", Bid, ", Ask: ", Ask, ", Price: ", DoubleToStr(price, Digits));
         infobox = StringConcatenate(infobox, "\n", Symbol(), ", initTrailingStop: ", initTrailingStop, ", TrailingStop: ", TrailingStop);
         infobox = StringConcatenate(infobox, "\n", Symbol(), ", Order Profit: ", OrderProfit(), ", OrderOpenPrice: ", OrderOpenPrice());
            if(OrderType()==OP_BUY) {
               if(TrailingStop>0 && OrderProfit() > 0)  
               {                 
                  infobox = StringConcatenate(infobox, "\n", Symbol(), ", Bid-price: ", (Bid-price), ", Point*initTrailingStop: ", (Point*initTrailingStop));
                  if(Bid-price>Point*initTrailingStop)
                  {
                     infobox = StringConcatenate(infobox, "\n", Symbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", Bid-Point*TrailingStop: ", (Bid-Point*TrailingStop));
                     if(OrderStopLoss()<Bid-Point*TrailingStop)
                     {
                        infobox = StringConcatenate(infobox, "\n", Symbol(), ", Modify Buy");
                        OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Point*TrailingStop,OrderTakeProfit(),0,Green);
                        return(0);
                     }
                  }
               }//end if
            } else if(OrderType()==OP_SELL) {
               // check for trailing stop
               if(TrailingStop>0 && OrderProfit() > 0)  
                 {                 
                  infobox = StringConcatenate(infobox, "\n", Symbol(), ", price-Ask: ", (price-Ask), ", Point*initTrailingStop: ", (Point*initTrailingStop));
                  if((price-Ask)>(Point*initTrailingStop))
                    {
                     infobox = StringConcatenate(infobox, "\n", Symbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", Ask+Point*TrailingStop: ", (Ask+Point*TrailingStop));
                     if((OrderStopLoss()>(Ask+Point*TrailingStop)) || (OrderStopLoss()==0))
                       {
                        infobox = StringConcatenate(infobox, "\n", Symbol(), ", Modify Sell");
                        OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Point*TrailingStop,OrderTakeProfit(),0,Red);
                        return(0);
                       }
                    }
                 }
            } 
         }
         
      }
   return (0);
}