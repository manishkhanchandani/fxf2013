//+------------------------------------------------------------------+
//|                                                   dailyrange.mq4 |
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
   double high = High[1];
   double low = Low[1];
   double open = Open[0];
   double close = Close[0];
   double limit = (high - low) / 4;
   double buyprice = open + limit;
   double sellprice = open - limit;
   double currentbuytp = buyprice + limit;
   double currentselltp = sellprice - limit;
   Comment("\n\nLimit: ", DoubleToStr(limit, Digits)
   , "\nOpen: ", DoubleToStr(open, Digits), ", Close: ", DoubleToStr(close, Digits)
   , ", High: ", DoubleToStr(high, Digits), ", Low: ", DoubleToStr(low, Digits)
   , "\nBuyPrice: ", DoubleToStr(buyprice, Digits), ", Sell Price: ", DoubleToStr(sellprice, Digits)
   , "\nBuy Take Profit: ", DoubleToStr(currentbuytp, Digits), ", Sell Take Profit: ", DoubleToStr(currentselltp, Digits));
   
//----
   return(0);
  }
//+------------------------------------------------------------------+