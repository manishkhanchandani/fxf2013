//+------------------------------------------------------------------+
//|                                                     counting.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
   int i;
   double buy = 0;
   double sell = 0;
   for(i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderSymbol()==Symbol()) {
         if(OrderType()==OP_BUY)
           {
               buy = buy + OrderLots();
           }
         else if(OrderType()==OP_SELL)
           {
            sell = sell + OrderLots();
         
           }
     }
   }
   Comment("Buy: ", buy, ", Sell", sell);
//----
   return(0);
  }
//+------------------------------------------------------------------+