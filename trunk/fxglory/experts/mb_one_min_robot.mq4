//+------------------------------------------------------------------+
//|                                             mb_one_min_robot.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"
#include <stdlib.mqh>
#include <WinUser32.mqh>

#define MAGICMA  197406051

extern bool createorders = false;
extern int maxorders = 0;
string build = "1.2";
string custom_order_message = "";
extern double lots = 0.50;
extern double lots_step = 0.01;
extern double lots_max = 0.50;
int number = 1;
int past_position = 0;
string infobox;
//order profit
double max_profit;
double half_profit;
double running_profit = 0;


int rsioma = 0;
int wpr = 0;
int local_trend = 0;
int global_trend = 0;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   custom_init();
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
   Comment(infobox);
   custom_start();
//----
   return(0);
  }
//+------------------------------------------------------------------+

void custom_start()
{
   return (0);
   infobox = StringConcatenate(infobox, "\n\nLocal Trend: ", local_trend, ", rsioma: ", rsioma, ", wpr: ", wpr, ", global: ", global_trend, "\n");
   int result = 0;
   int trend = 0;
   trend = get_trend(Symbol(), Period());
   if (trend == 1) {
      infobox = StringConcatenate(infobox, "\nTrend is buy.");
   } else if (trend == -1) {
      infobox = StringConcatenate(infobox, "\nTrend is sell.");
   }
   result = get_strategy_result(Symbol(), Period(), trend);
   infobox = StringConcatenate(infobox, "\n", "Past Position: ", past_position);
   if (result == 1) {
      infobox = StringConcatenate(infobox, "\n", "Buy condition for ", Symbol(), ", time: ", Period());
   } else if (result == -1) {
      infobox = StringConcatenate(infobox, "\n", "Buy condition for ", Symbol(), ", time: ", Period());
   }
   CheckForClose();
   Comment(infobox);
}


int get_trend(string symbol, int timeframe)
{
   int trend = 0;
   double sell = gold_sell_zone_fibs(symbol, timeframe, 0);
   double buy = gold_buy_zone_fibs(symbol, timeframe, 0);
   if (Bid < buy) {
      trend = -1;
   } else if (Ask > sell) { //Ask
      trend = 1;
   }
   return (trend);
}

int get_strategy_result(string symbol, int timeframe, int trend)
{
   int all_trend = all_trends(symbol, number);
   int l = get_trend(symbol, timeframe);
   int r,w,g;
   double down = gold_rsioma_down(symbol, timeframe, number);
   double up = gold_rsioma_up(symbol, timeframe, number);
   if (down == EMPTY_VALUE && up > 0) {
      r = 1;
   } else if (up == EMPTY_VALUE && down < 0) {
      r = -1; 
   }
   double range = gold_william_percent_range(symbol, timeframe, number);
   if (range < -75) {
      w = -1;
   } else if (range > -25) {
      w = 1;
   }
   if (l == 1 && r == 1 && w == 1 && global_trend != 1 && all_trend == 1) {
      g = 1;
      create_orders(1);
      global_trend = 1;
      Alert("buy", symbol);
      local_trend = l;
      rsioma = r;
      wpr = w;
      global_trend = g;
   } else if (l == -1 && r == -1 && w == -1 && global_trend != -1 && all_trend == -1) {
      g = -1;
      create_orders(-1);
      global_trend = -1;
      Alert("sell", symbol);
      local_trend = l;
      rsioma = r;
      wpr = w;
      global_trend = g;
   } else {
      g = 0;
   }

/*
   double current = calculate_strategy_ema(symbol, 9, timeframe, number);
   double past = calculate_strategy_ema(symbol, 9, timeframe, number + 1);
   double macd = iMACD(symbol,timeframe,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
   double macd1 = iMACD(symbol,timeframe,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
      if (iLow(symbol, timeframe, number) > current && iLow(symbol, timeframe, number + 1) < past && iHigh(symbol, timeframe, number + 1) > past
      && past_position != 1 && trend == 1 && macd >= macd1) {
         Alert("buy", symbol);
         create_orders(1);
         past_position = 1;
         return (1);
      } else if (iHigh(symbol, timeframe, number) < current && iLow(symbol, timeframe, number + 1) < past && iHigh(symbol, timeframe, number + 1) > past
      && past_position != -1 && trend == -1 && macd <= macd1) {
         Alert("sell", symbol);
         create_orders(-1);
         past_position = -1;
         return (-1);
      } else if (iLow(symbol, timeframe, number) > current) {
         past_position = 1;
         return (0);
      } else if (iHigh(symbol, timeframe, number) < current) {
         past_position = -1;
         return (0);
      } else {
         past_position = 0;
         return (0);
      }*/
}
void custom_init()
{
   //past_position = calculate_past_position(Symbol(), Period());
   
   local_trend = get_trend(Symbol(), Period());
   double down = gold_rsioma_down(Symbol(), Period(), number);
   double up = gold_rsioma_up(Symbol(), Period(), number);
   if (down == EMPTY_VALUE && up > 0) {
      rsioma = 1;
   } else if (up == EMPTY_VALUE && down < 0) {
      rsioma = -1; 
   }
   double range = gold_william_percent_range(Symbol(), Period(), number);
   if (range < -75) {
      wpr = -1;
   } else if (range > -25) {
      wpr = 1;
   }
   if (local_trend == 1 && rsioma == 1 && wpr == 1) {
      global_trend = 1;
   } else if (local_trend == -1 && rsioma == -1 && wpr == -1) {
      global_trend = -1;
   } else {
      global_trend = 0;
   }
}
/*
int calculate_past_position(string symbol, int timeframe)
{
   double current = calculate_strategy_ema(symbol, 9, timeframe, number);
   if (iLow(symbol, timeframe, number) > current) {
      return (1);
   } else if (iHigh(symbol, timeframe, number) < current) {
      return (-1);
   } else {
      return (0);
   }
}*/

  int CalculateCurrentOrders()
  {
   int buys=0,sells=0;
//----
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA)
        {
         if(OrderType()==OP_BUY)  buys++;
         if(OrderType()==OP_SELL) sells++;
        }
     }
//---- return orders volume
   if(buys>0) return(buys);
   else       return(-sells);
  }
int CalculateCurrentMaxOrders()
  {
   int corders=0;
//----
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderMagicNumber()==MAGICMA)
        {
         corders++;
        }
     }
         return(corders);
}


void CheckForClose()
 {
   return (0);
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;      

      if (OrderProfit() > half_profit) {
         running_profit = half_profit;
      }

      if (OrderProfit() < running_profit && running_profit > 0) {
         Alert("Order profit is less than running profit so closing the order. ", OrderProfit(), ", running profit: ", running_profit);
         running_profit = 0;
         //close the order;
         if(OrderType()==OP_BUY) {
            OrderClose(OrderTicket(),OrderLots(),Bid,3,White);
         } else if(OrderType()==OP_SELL) {
            OrderClose(OrderTicket(),OrderLots(),Ask,3,White);
         }
      }
   }
 }
/*
int check_for_open()
{

}

int check_for_close()
{

}

*/
double gold_sell_zone_fibs(string symbol, int timeframe, int shift)
{
   double L_1;
   int MAPeriod = 55;
   int       MAType=2;
   int fibo1 = 1;
   int fibo2 = 2;
   int fibo3 = 3;
   int fibo4 = 4;
   int fibo5 = 5;
   int fibo6 = 6;
   int fibo7 = 7;
   L_1 = iCustom(symbol, timeframe, "sell zone fibs", MAPeriod, MAType, fibo1, fibo2, fibo3, fibo4, fibo5, fibo6, fibo7, 0, shift);
   return (L_1);
}

double gold_buy_zone_fibs(string symbol, int timeframe, int shift)
{
   double L_1;
   int MAPeriod = 55;
   int       MAType=2;
   int fibo1 = 1;
   int fibo2 = 2;
   int fibo3 = 3;
   int fibo4 = 4;
   int fibo5 = 5;
   int fibo6 = 6;
   int fibo7 = 7;
   L_1 = iCustom(symbol, timeframe, "buy zone fibs", MAPeriod, MAType, fibo1, fibo2, fibo3, fibo4, fibo5, fibo6, fibo7, 0, shift);
   return (L_1);
}

/*
double calculate_strategy_ema(string symbol, int MA_Length, int Period_of_Time, int shift)
{
   double ema = iMA(symbol,Period_of_Time,MA_Length,0,MODE_EMA,PRICE_CLOSE,shift);
   return (ema);
}*/

double gold_rsioma_down(string symbol, int timeframe, int shift)
{
   double L_1;
   L_1 = iCustom(symbol, timeframe, "RSIOMA_v3", 1, shift);
   return (L_1);
}
double gold_rsioma_up(string symbol, int timeframe, int shift)
{
   double L_1;
   L_1 = iCustom(symbol, timeframe, "RSIOMA_v3", 2, shift);
   return (L_1);
}

double gold_william_percent_range(string symbol, int timeframe, int shift)
{
   double L_1;
   L_1 = iCustom(symbol, timeframe, "WPR", 55, 0, shift);
   return (L_1);
}

int create_orders(int type)
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
   int orders = CalculateCurrentOrders();
   if (orders > 0) {
      //if (logs) log_message(StringConcatenate("Order Already created for symbol ", Symbol()));
      return (0);
   }
   int ticket;
   int error;
   string message;
   max_profit = lots * 10;
   half_profit = max_profit / 2;
   double sl;
   double tp;
   if (type == 1) {
      sl = Ask - (1500 * Point);
      tp = Ask + (200 * Point);
   } else if (type == -1) {
      sl = Bid + (1500 * Point);
      tp = Bid - (200 * Point);
   }
   if (type == 1) {
      message = StringConcatenate("OneMinRobot, ", message, ", B: ", build, ", ", custom_order_message);
      ticket=OrderSend(Symbol(),OP_BUY,lots,Ask,3,sl,tp,message,MAGICMA,0,CLR_NONE);
      if(ticket<1)
      {
         error=GetLastError();
         Alert("Error = ",ErrorDescription(error));
         past_position = 0;
         return (0);
      }
      Alert("Buy order created for symbol: ", Symbol());
      lots = lots + lots_step;
      if (lots > lots_max) {
         lots = lots_max;
      }
      OrderPrint();
   } else if (type == -1) {
      message = StringConcatenate("OneMinRobot, ", message, ", B: ", build, ", ", custom_order_message);
      ticket=OrderSend(Symbol(),OP_SELL,lots,Bid,3,sl,tp,message,MAGICMA,0,CLR_NONE);
      if(ticket<1)
      {
         error=GetLastError();
         Alert("Error = ",ErrorDescription(error));
         past_position = 0;
         return (0);
      }
      Alert("Sell order created for symbol: ", Symbol());
      lots = lots + lots_step;
      if (lots > lots_max) {
         lots = lots_max;
      }
      OrderPrint();
   }
}




int all_trends(string symbol, int num)
{
   //int trend1 = 0;
   int trend2 = 0;
   int trend3 = 0;
   int trend4 = 0;
   int trend5 = 0;
   int trend6 = 0;
   //trend1 = strategy_trend(symbol, number, PERIOD_H4);
   trend2 = strategy_trend(symbol, number, PERIOD_H1);
   trend3 = strategy_trend(symbol, number, PERIOD_M30);
   trend4 = strategy_trend(symbol, number, PERIOD_M15);
   trend5 = strategy_trend(symbol, number, PERIOD_M5);
   //trend6 = strategy_trend(symbol, number, PERIOD_M1);
   if (trend2 == trend3 && trend3 == trend4 && trend4 == trend5) {//trend1 == trend2  &&  && trend5 == trend6
      return (trend2);
   } else {
      return (0);
   }
}

int all_get_trend(double L_1, double L_100)
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
   current = calculate_strategy_fantailvma3(symbol, 1, Period_to_Call, num);
   toplevel = calculate_strategy_fantailvma3(symbol, 100, Period_to_Call, num);
   trend = all_get_trend(current, toplevel);
   return (trend);
}
double calculate_strategy_fantailvma3(string symbol, int MA_Length, int Period_of_Time, int shift)
{
   int ADX_Length = 2;
   double Weighting = 2.0;
   //int MA_Length = 1;
   int MA_Mode = 1;
   double L_1;
   L_1 = iCustom(symbol, Period_of_Time, "FantailVMA3", ADX_Length, Weighting, MA_Length, MA_Mode, 0, shift);
   return (L_1);
}