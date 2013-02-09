//+------------------------------------------------------------------+
//|                                                 trailingstop.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

extern int TrailingStop = 50;
extern int initTrailingStop = 100;

string infobox;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   //Comment("Account #",AccountNumber(), " leverage is ", AccountLeverage(), ", TrailingStop #",TrailingStop);
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
   infobox = "\n";
   int cnt, ticket, total;
   total=OrdersTotal();
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL  // check for opened position
         && OrderSymbol()==Symbol()
      )  // check for symbol
         {
         infobox = StringConcatenate(infobox, "\n", Symbol(), ", Bid: ", Bid, ", Ask: ", Ask);
         infobox = StringConcatenate(infobox, "\n", Symbol(), ", initTrailingStop: ", initTrailingStop, ", TrailingStop: ", TrailingStop);
         infobox = StringConcatenate(infobox, "\n", Symbol(), ", Ordder Profit: ", OrderProfit(), ", OrderOpenPrice: ", OrderOpenPrice());
            if(OrderType()==OP_BUY) {
               if(TrailingStop>0 && OrderProfit() > 0)  
               {                 
                  infobox = StringConcatenate(infobox, "\n", Symbol(), ", Bid-OrderOpenPrice(): ", (Bid-OrderOpenPrice()), ", Point*initTrailingStop: ", (Point*initTrailingStop));
                  if(Bid-OrderOpenPrice()>Point*initTrailingStop)
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
                  infobox = StringConcatenate(infobox, "\n", Symbol(), ", OrderOpenPrice()-Ask: ", (OrderOpenPrice()-Ask), ", Point*initTrailingStop: ", (Point*initTrailingStop));
                  if((OrderOpenPrice()-Ask)>(Point*initTrailingStop))
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
      Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+