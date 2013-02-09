//+------------------------------------------------------------------+
//|                                                 trailingstop.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

extern int TrailingStop = 150;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   Comment("Account #",AccountNumber(), " leverage is ", AccountLeverage(), ", TrailingStop #",TrailingStop);
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
   int cnt, ticket, total;
   total=OrdersTotal();
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL  // check for opened position
         && OrderSymbol()!="EURJPY"
      )  // check for symbol
         {
         Print(Symbol(), ", Bid: ", Bid, ", Ask: ", Ask);
         Print(Symbol(), ", Ordder Profit: ", OrderProfit(), ", OrderOpenPrice: ", OrderOpenPrice());
            if(OrderType()==OP_BUY) {
               if(TrailingStop>0 && OrderProfit() > 0)  
               {                 
                  Print(Symbol(), ", Bid-OrderOpenPrice(): ", (Bid-OrderOpenPrice()), ", Point*TrailingStop: ", (Point*TrailingStop));
                  if(Bid-OrderOpenPrice()>Point*TrailingStop)
                  {
                     Print(Symbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", Bid-Point*TrailingStop: ", (Bid-Point*TrailingStop));
                     if(OrderStopLoss()<Bid-Point*TrailingStop)
                     {
                        Print(Symbol(), ", Modify Buy");
                        //OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Point*TrailingStop,OrderTakeProfit(),0,Green);
                        return(0);
                     }
                  }
               }//end if
            } else if(OrderType()==OP_SELL) {
               // check for trailing stop
               if(TrailingStop>0 && OrderProfit() > 0)  
                 {                 
                  Print(Symbol(), ", OrderOpenPrice()-Ask: ", (OrderOpenPrice()-Ask), ", Point*TrailingStop: ", (Point*TrailingStop));
                  if((OrderOpenPrice()-Ask)>(Point*TrailingStop))
                    {
                     Print(Symbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", Ask+Point*TrailingStop: ", (Ask+Point*TrailingStop));
                     if((OrderStopLoss()>(Ask+Point*TrailingStop)) || (OrderStopLoss()==0))
                       {
                        Print(Symbol(), ", Modify Sell");
                        //OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Point*TrailingStop,OrderTakeProfit(),0,Red);
                        return(0);
                       }
                    }
                 }
            } 
         }
         
      }
//----
   return(0);
  }
//+------------------------------------------------------------------+