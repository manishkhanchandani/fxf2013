//+------------------------------------------------------------------+
//|                                                 trailingstop.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"
string infobox;
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
   infobox = "";
   infobox = StringConcatenate(infobox, "Account #",AccountNumber(), " leverage is ", AccountLeverage());
   infobox = StringConcatenate(infobox, "\n");
   int cnt, ticket, total;
   total=OrdersTotal();
   double val6, val7, val8, val9;
   for(cnt=0;cnt<total;cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL  // check for opened position
         && OrderSymbol()==Symbol()
      )  // check for symbol
         {
         infobox = StringConcatenate(infobox, Symbol(), ", Bid: ", Bid, ", Ask: ", Ask);
         infobox = StringConcatenate(infobox, "\n");
         infobox = StringConcatenate(infobox, Symbol(), ", Ordder Profit: ", OrderProfit(), ", OrderOpenPrice: ", OrderOpenPrice());
         infobox = StringConcatenate(infobox, "\n");
         
         //int shift=iBarShift(NULL,PERIOD_M5,some_time);
         val6 = iCustom(OrderSymbol(), Period(), "Heiken_Ashi_Smoothed",2,1);
         val7 = iCustom(OrderSymbol(), Period(), "Heiken_Ashi_Smoothed",3,1);
         val8 = iCustom(OrderSymbol(), Period(), "Heiken_Ashi_Smoothed",2,2);
         val9 = iCustom(OrderSymbol(), Period(), "Heiken_Ashi_Smoothed",3,2);
            if(OrderType()==OP_BUY) {
               infobox = StringConcatenate(infobox, "Buy Condition 1: ", (val6 > val7));
               infobox = StringConcatenate(infobox, "\n");
               infobox = StringConcatenate(infobox, "Buy Condition 2: ", (val8 < val9));
               infobox = StringConcatenate(infobox, "\n");
               if (val6 > val7 && val8 < val9 && OrderProfit() > 0) {
                  infobox = StringConcatenate(infobox, "Closing Buy Order.");
                  infobox = StringConcatenate(infobox, "\n");
                  OrderClose(OrderTicket(),OrderLots(),Bid,3,White);
                  return(0);
               }
            } else if(OrderType()==OP_SELL) {
               infobox = StringConcatenate(infobox, "Sell Condition 1: ", (val6 < val7));
               infobox = StringConcatenate(infobox, "\n");
               infobox = StringConcatenate(infobox, "Sell Condition 2: ", (val8 > val9));
               infobox = StringConcatenate(infobox, "\n");
               if (val6 < val7 && val8 > val9 && OrderProfit() > 0) {
                  infobox = StringConcatenate(infobox, "Closing Sell Order.");
                  infobox = StringConcatenate(infobox, "\n");
                  OrderClose(OrderTicket(),OrderLots(),Ask,3,White);
                  return(0);
               }
            } 
         }
         Comment(infobox);
      }
//----
   return(0);
  }
//+------------------------------------------------------------------+