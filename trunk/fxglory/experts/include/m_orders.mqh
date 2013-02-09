//+------------------------------------------------------------------+
//|                                                     m_orders.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2005

//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);

// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import

//+------------------------------------------------------------------+
//| EX4 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex4"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

int create_orders(string symbol, int type, string message, double tp, double sl)
{
   //lots = 0.50;
   //if (!IsDemo()) {
      //Alert("Orders are not created in live account");
      //return (0);  
   //}
   if (!createorders) {
      //log_message(StringConcatenate(Symbol(), ", create orders disabled"));
      return (0);
   }
   if (type == 0) {
      //if (logs) log_message(StringConcatenate(Symbol(), ", no orders processed as buy and sell condition does not exists for ", message));
      return (0);
   }
   
   int morders = CalculateCurrentMaxOrders();
   if (morders >= maxorders) {
      //if (logs) log_message(StringConcatenate("Max Orders Reached for symbol ", Symbol()));
      return (0);
   }
   int orders = CalculateCurrentOrders(symbol);
   if (orders > 0) {
      //if (logs) log_message(StringConcatenate("Order Already created for symbol ", Symbol()));
      return (0);
   }
   int ticket;
   int error;
   if (type == 1) {
      message = StringConcatenate("MasterBlast, ", message, ", B: ", build, ", ", custom_order_message);
      ticket=OrderSend(symbol,OP_BUY,lots,MarketInfo(symbol,MODE_ASK),3,sl,tp,message,MAGICMA,0,CLR_NONE);
      if(ticket<1)
      {
         error=GetLastError();
         Alert("Error = ",ErrorDescription(error));
         return (0);
      }
      Alert("Buy order created for symbol: ", symbol);
      lots = lots + lots_step;
      if (lots > lots_max) {
         lots = lots_max;
      }
      OrderPrint();
   } else if (type == -1) {
      message = StringConcatenate("MasterBlast, ", message, ", B: ", build, ", ", custom_order_message);
      ticket=OrderSend(symbol,OP_SELL,lots,MarketInfo(symbol,MODE_BID),3,sl,tp,message,MAGICMA,0,CLR_NONE);
      if(ticket<1)
      {
         error=GetLastError();
         Alert("Error = ",ErrorDescription(error));
         return (0);
      }
      Alert("Sell order created for symbol: ", symbol);
      lots = lots + lots_step;
      if (lots > lots_max) {
         lots = lots_max;
      }
      OrderPrint();
   }
}