//+------------------------------------------------------------------+
//|                                                 trailingstop.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

extern int TrailingStop = 100;
extern int initTrailingStop = 150;

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
   double bids, asks, pt;
   total=OrdersTotal();
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL  // check for opened position
      )  // check for symbol
         {
         bids = MarketInfo(OrderSymbol(), MODE_BID);
         asks = MarketInfo(OrderSymbol(), MODE_ASK);
         pt = MarketInfo(OrderSymbol(), MODE_POINT);
         infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", Bid: ", bids, ", Ask: ", asks);
         infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", initTrailingStop: ", initTrailingStop, ", TrailingStop: ", TrailingStop);
         infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", Ordder Profit: ", OrderProfit(), ", OrderOpenPrice: ", OrderOpenPrice());
            if(OrderType()==OP_BUY) {
               if(TrailingStop>0 && OrderProfit() > 0)  
               {                 
                  infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", bids-OrderOpenPrice(): ", (bids-OrderOpenPrice()), ", pt*initTrailingStop: ", (pt*initTrailingStop));
                  if(bids-OrderOpenPrice()>pt*initTrailingStop)
                  {
                     infobox = StringConcatenate(infobox, "\n", OrderSymbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", bids-Point*TrailingStop: ", (bids-pt*TrailingStop));
                     if(OrderStopLoss()<bids-pt*TrailingStop)
                     {
                        infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", Modify Buy");
                        OrderModify(OrderTicket(),OrderOpenPrice(),bids-pt*TrailingStop,OrderTakeProfit(),0,Green);
                        return(0);
                     }
                  }
               }//end if
            } else if(OrderType()==OP_SELL) {
               // check for trailing stop
               if(TrailingStop>0 && OrderProfit() > 0)  
                 {                 
                  infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", OrderOpenPrice()-asks: ", (OrderOpenPrice()-asks), ", pt*initTrailingStop: ", (pt*initTrailingStop));
                  if((OrderOpenPrice()-asks)>(pt*initTrailingStop))
                    {
                     infobox = StringConcatenate(infobox, "\n", OrderSymbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", asks+pt*TrailingStop: ", (asks+pt*TrailingStop));
                     if((OrderStopLoss()>(asks+pt*TrailingStop)) || (OrderStopLoss()==0))
                       {
                        infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", Modify Sell");
                        OrderModify(OrderTicket(),OrderOpenPrice(),asks+pt*TrailingStop,OrderTakeProfit(),0,Red);
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