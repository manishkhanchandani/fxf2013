//+------------------------------------------------------------------+
//|                                                 trailingstop.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   Comment("Account #",AccountNumber(), " leverage is ", AccountLeverage());
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
   string infobox = "Heikin test Account #" + AccountNumber() + " leverage is " + AccountLeverage() + ", Spread: " + MarketInfo(Symbol(), MODE_SPREAD) + "\n";
   int cnt, ticket, total;
   total=OrdersTotal();
   double val2, val3;
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL  // check for opened position
         && OrderSymbol()==Symbol()
      )  // check for symbol
         {
         infobox = StringConcatenate(infobox, "\n");
         infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", Bid: ", DoubleToStr(Bid, Digits), ", Ask: ", DoubleToStr(Ask, Digits));
         infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", Ordder Profit: ", OrderProfit(), ", OrderOpenPrice: ", OrderOpenPrice());
         val2 = iCustom(OrderSymbol(), PERIOD_M30, "Heiken_Ashi_Smoothed",2,0);
         val3 = iCustom(OrderSymbol(), PERIOD_M30, "Heiken_Ashi_Smoothed",3,0);
         infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", val2: ", DoubleToStr(val2, Digits), ", val3: ", DoubleToStr(val3, Digits), " | Val2 should be less for buy and greater for sell");
         if (val2 < val3) {
            infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", Current Trend: Buy");         
         } else if (val2 > val3) {
            infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", Current Trend: Sell");         
         }
         if (OrderProfit() > 0) {
               if(OrderType()==OP_BUY && val2 > val3) { //heiken is sell so close the order
               Alert("close buy");
                  //OrderClose(OrderTicket(),OrderLots(),Bid,3,White);
               } else if(OrderType()==OP_SELL && val2 < val3) { //heiken is buy so close the order
               Alert("close sell");
                  //OrderClose(OrderTicket(),OrderLots(),Ask,3,White);
               } 
            }
         }         
      }
      Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+