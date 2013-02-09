//+------------------------------------------------------------------+
//|                                               m_strategy_vma.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <megamillioninc.mqh>
string build = "Master 1.1";
int get_trend(double L_1, double L_100)
{
   int cur_trend = 0;
   if (L_100 > L_1) {
      cur_trend = -1;
   } else if (L_1 > L_100) {
      cur_trend = 1;
   }
   return (cur_trend);
}

int strategy_trend(string symbol, int num, int Period_to_Call)
{
   double current, toplevel;
   int trend = 0;
   current = calculate_strategy_ema(symbol, 50, Period_to_Call, num);
   toplevel = calculate_strategy_ema(symbol, 110, Period_to_Call, num);
   trend = get_trend(current, toplevel);
   return (trend);
}
double calculate_strategy_ema(string symbol, int MA_Length, int Period_of_Time, int shift)
{
   double ema = iMA(symbol,Period_of_Time,MA_Length,0,MODE_EMA,PRICE_CLOSE,shift);
   return (ema);
}


void check_for_close()
{
   for(int i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)
         break;
      if(OrderType()==OP_BUY || OrderType()==OP_SELL) {
         
         checkprofit(OrderProfit(), OrderLots(), OrderType(), OrderTicket());
      }
      /*
      if(OrderType()==OP_BUY && OrderProfit() > 0) {
         result = check_exit_point(OrderSymbol(), PERIOD_M5, 1);
         if(result == 1) { 
         OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),3,White);
         Alert("buy close for symbol: ", OrderSymbol()); 
         }
      } else if(OrderType()==OP_SELL && OrderProfit() > 0) {
         result = check_exit_point(OrderSymbol(), PERIOD_M5, -1);
         if(result == 1) 
         {
         OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3,White);
         Alert("sell close for symbol: ", OrderSymbol());
         }
      }*/
   }
}

void checkprofit(double orderprofit, double orderlot, double ordertype, int orderticket)
{
return (0);
double running_profit, half_profit, profit_1, profit_2;
      if (orderprofit < running_profit && running_profit > 0) {
         Alert("Order profit is less than running profit so closing the order. ", orderprofit, ", running profit: ", running_profit);
         running_profit = 0;
         profit_1 = 0;
         profit_2 = 0;
         //close the order;
         if(ordertype==OP_BUY) {
            OrderClose(orderticket,orderlot,Bid,3,White);
         } else if(ordertype==OP_SELL) {
            OrderClose(orderticket,orderlot,Ask,3,White);
         }
      }

      double tmp;
      //if (orderprofit >= profit_2) {
         //running_profit = profit_1;
      //}
      if (orderprofit > half_profit && profit_1 == 0) {
         profit_1 = orderprofit;
         tmp = orderprofit / 10;
         profit_2 = profit_1 + tmp;
      } else if (orderprofit > half_profit && profit_2 > 0 && orderprofit > profit_2) {
         profit_1 = orderprofit;
         tmp = orderprofit / 10;
         profit_2 = profit_1 + tmp;
         running_profit = profit_1 - tmp;
      }
}

int check_entry_point(string symbol, int Period_to_Call, int trend)
{
   int num = number;
   int num_past = number + 1;
   int result = 0;
   result = strategy(symbol, Period_to_Call, num);

   //if (trend_all != trend) {
      //return (0);
   //}
   if (result == -1) {
      inference = StringConcatenate(inference, symbol, ": Master Sell => ", TimeframeToString(Period_to_Call), "\n");
      if (show_alerts) Alert(symbol, ": Master Sell => ", TimeframeToString(Period_to_Call));
      infobox = StringConcatenate(infobox, ",", "Master Sell\n");
   } else if (trend == 1) {
      //buy conditions
      infobox = StringConcatenate(infobox, ",", "Master Buy\n");
      inference = StringConcatenate(inference, symbol, ": Master Buy => ", TimeframeToString(Period_to_Call), "\n");
      if (show_alerts) Alert(symbol, ": Master Buy => ", TimeframeToString(Period_to_Call));
   }

   return (result);
}


