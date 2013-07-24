//+------------------------------------------------------------------+
//|                                                   cuTrailing.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

extern int TrailingStop = 150;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
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
   string box = trailingstopFollow(Symbol());
   Comment(box);
//----
   return(0);
  }
//+------------------------------------------------------------------+

string trailingstopFollow(string symbol)
{
   string infobox = "";
   double bid, ask, point;
   int cnt, ticket, total;
   total=OrdersTotal();
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL && OrderSymbol() == symbol
      ) 
         {
         bid = MarketInfo(OrderSymbol(), MODE_BID);
         ask = MarketInfo(OrderSymbol(), MODE_ASK);
         point = MarketInfo(OrderSymbol(), MODE_POINT);
         infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", bid: ", bid, ", ask: ", ask);
         infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", Ordder Profit: ", OrderProfit(), ", OrderOpenPrice: ", OrderOpenPrice());
            if(OrderType()==OP_BUY) {
               if(TrailingStop>0)  
               {                 
                     infobox = StringConcatenate(infobox, "\n", OrderSymbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", bid-point*TrailingStop: ", (bid-point*TrailingStop));
                     if(OrderStopLoss()<bid-point*TrailingStop)
                     {
                        infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", Modify Buy");
                        OrderModify(OrderTicket(),OrderOpenPrice(),bid-point*TrailingStop,OrderTakeProfit(),0,Green);
                     }
               }//end if
            } else if(OrderType()==OP_SELL) {
               // check for trailing stop
               if(TrailingStop>0)  
                 {               
                     infobox = StringConcatenate(infobox, "\n", OrderSymbol(), "Checking modification: OrderStopLoss(): ", (OrderStopLoss()), ", ask+point*TrailingStop: ", (ask+point*TrailingStop));
                     
                     if((OrderStopLoss()>(ask+point*TrailingStop)) || (OrderStopLoss()==0))
                       {
                        infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", Modify Sell");
                        OrderModify(OrderTicket(),OrderOpenPrice(),ask+point*TrailingStop,OrderTakeProfit(),0,Red);
                       }
                 }
            } 
         }
         
      }
      
   infobox = StringConcatenate("TrailingStop: ",TrailingStop,"\n",infobox);

   return (infobox);
}