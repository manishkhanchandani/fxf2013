//+------------------------------------------------------------------+
//|                                                   cuTrailing.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

int openTime;
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
   if (openTime != iTime(Symbol(), PERIOD_M15, 0)) {
      string box = trailingstopMA(Symbol(), PERIOD_M15, 0, 1000);
      Comment(box);
      openTime = iTime(Symbol(), PERIOD_M15, 0);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+

string trailingstopMA(string symbol, int period, int shift, int p1)
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
         double ma = iMA(symbol,period,p1,0,MODE_SMA,PRICE_CLOSE,shift);
         double sl;
         if(OrderType()==OP_BUY) {
            sl = ma - (100 * Point);
         } else if(OrderType()==OP_SELL) {
            sl = ma + (100 * Point);
         }
         infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", bid: ", bid, ", ask: ", ask, ", ma: ", ma, ", sl: ", sl);
         infobox = StringConcatenate(infobox, "\n", OrderSymbol(), ", Ordder Profit: ", OrderProfit(), ", OrderOpenPrice: ", OrderOpenPrice());
         OrderModify(OrderTicket(),OrderOpenPrice(),sl,OrderTakeProfit(),0,Green);
         }
         
      }
      
   infobox = StringConcatenate("symbol: ",symbol,", period: ",period,", p1: ",p1,", shift: ",shift,"\n",infobox);

   return (infobox);
}