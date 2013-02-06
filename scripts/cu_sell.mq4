//+------------------------------------------------------------------+
//|                                                       cu_buy.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
   string symbol = Symbol();
   double Lots = 0.01;
   string message = "custom";
   int magicnumber = 1234;
   double bids = MarketInfo(symbol, MODE_BID);
   double asks = MarketInfo(symbol, MODE_ASK);
   double pt = MarketInfo(symbol, MODE_POINT);
   int digit = MarketInfo(symbol, MODE_DIGITS);
   bids = NormalizeDouble(bids, digit);
   asks = NormalizeDouble(asks, digit);
   int ticket=OrderSend(symbol,OP_SELL,Lots,bids,3,0,0,message,magicnumber,0,Red);
   if(ticket>0) {
      double sl = Bid + (300 * Point);
      //OrderModify(OrderTicket(),OrderOpenPrice(),sl,0,0,Green);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+