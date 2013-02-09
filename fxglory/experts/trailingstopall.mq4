//+------------------------------------------------------------------+
//|                                                 trailingstop.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

extern int TrailingStop = 100;

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
   double bids, asks, pt;
   int orders;
   string infobox;
   infobox = StringConcatenate(infobox, "Account #",AccountNumber(), " leverage is ", AccountLeverage(), ", TrailingStop #",TrailingStop);
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL  // check for opened position
         //&& OrderSymbol()==Symbol()
      )  // check for symbol
         {
         infobox = StringConcatenate(infobox, "\n");
         bids = MarketInfo(OrderSymbol(), MODE_BID);
         asks = MarketInfo(OrderSymbol(), MODE_ASK);
         pt = MarketInfo(OrderSymbol(), MODE_POINT);
         infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", Bid: ", bids, ", Ask: ", asks);
         infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", Order Profit: ", OrderProfit(), ", OrderOpenPrice: ", OrderOpenPrice(), ", OrderTicket: ", OrderTicket());
            if(OrderType()==OP_BUY) {
               if(TrailingStop>0 && OrderProfit() > 0)  
               {                 
                  infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", bids-OrderOpenPrice(): ", (bids-OrderOpenPrice()), " > pt*TrailingStop: ", (pt*TrailingStop));
                  if(bids-OrderOpenPrice()>pt*TrailingStop)
                  {
                     infobox = StringConcatenate(infobox, "\n", OrderSymbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), " < bids-pt*TrailingStop: ", (bids-pt*TrailingStop));
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
                  infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", OrderOpenPrice()-asks: ", (OrderOpenPrice()-asks), " > pt*TrailingStop: ", (pt*TrailingStop));
                  if((OrderOpenPrice()-asks)>(pt*TrailingStop))
                    {
                     infobox = StringConcatenate(infobox, "\n", OrderSymbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), " > asks+pt*TrailingStop: ", (asks+pt*TrailingStop));
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


