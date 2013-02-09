//+------------------------------------------------------------------+
//|                                               m_strategy_vma.mq4 |
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

string build = "VMA 1.1";
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
   current = calculate_strategy_fantailvma3(symbol, 1, Period_to_Call, num);
   toplevel = calculate_strategy_fantailvma3(symbol, 100, Period_to_Call, num);
   trend = get_trend(current, toplevel);
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


void check_for_close()
{
   return (0);
   int result = 0;
   int orders = 0;
   for(int i=0;i<OrdersTotal();i++)
     {
      orders = 0;
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if (OrderLots() == 0.01) {
          orders = CalculateCurrentOrders(OrderSymbol());
          if (orders > 1) {
            continue;
          }
         if(OrderType()==OP_BUY)
           {
               // && OrderProfit() > 0
               //result = check_exit_point(OrderSymbol(), Period(), 1);
               //if(result == 1) OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),3,White);
           }
         if(OrderType()==OP_SELL)
           {
               // && OrderProfit() > 0
               //result = check_exit_point(OrderSymbol(), Period(), -1);
              // if(result == 1) OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3,White);
           }
        }
     }
}


int check_entry_point(string symbol, int Period_to_Call, int trend)
{
   int num = number;
   int num_past = number + 1;
   int result = 0;
   check_current(symbol, Period_to_Call, num);
   //infobox = StringConcatenate(infobox, "C1: ", DoubleToStr(current_1, MarketInfo(symbol, MODE_DIGITS))
   //, ", C26: ", DoubleToStr(current_26, MarketInfo(symbol, MODE_DIGITS)), ", C100: ", DoubleToStr(current_100, MarketInfo(symbol, MODE_DIGITS)));
   check_past(symbol, Period_to_Call, num_past);
   //infobox = StringConcatenate(infobox, ", ", "P1: ", DoubleToStr(past_1, MarketInfo(symbol, MODE_DIGITS))
   //, ", P26: ", DoubleToStr(past_26, MarketInfo(symbol, MODE_DIGITS)), ", P100: ", DoubleToStr(past_100, MarketInfo(symbol, MODE_DIGITS)));
   if (trend_all != trend) {
      return (0);
   }
   if (trend == -1) {
      //sell conditions
      //condition 1
      //Print(symbol, ", Sell: ", current_1, "/", past_1, " = ", current_1, "/", current_26, " = ", past_1, "/", current_26);
      if (current_1 < past_1 && current_1 < current_26 && past_1 >= current_26) {
         inference = StringConcatenate(inference, symbol, ": Sell => ", TimeframeToString(Period_to_Call), "\n");
         if (show_alerts) Alert(symbol, ": Sell => ", TimeframeToString(Period_to_Call));
         infobox = StringConcatenate(infobox, ",", "Sell\n");
         result = -1;
      } else {
         //infobox = StringConcatenate(infobox, ", ", "No Buy and Sell Condition.");
      }
   } else if (trend == 1) {
      //buy conditions
      //condition 1
      //Print(symbol, ", Buy: ", current_1, "/", past_1, " = ", current_1, "/", current_26, " = ", past_1, "/", current_26);
      if (current_1 > past_1 && current_1 > current_26 && past_1 <= current_26) {
         infobox = StringConcatenate(infobox, ",", "Buy\n");
         inference = StringConcatenate(inference, symbol, ": Buy => ", TimeframeToString(Period_to_Call), "\n");
         if (show_alerts) Alert(symbol, ": Buy => ", TimeframeToString(Period_to_Call));
         result = 1;
      } else {
         //infobox = StringConcatenate(infobox, ", ", "No Buy and Sell Condition.");
      }
   } else {
      //infobox = StringConcatenate(infobox, ", ", "No Buy and Sell Condition.");
   }
   return (result);
}
/*
int check_exit_point(string symbol, int Period_to_Call, int trend)
{
   int num = number;
   int num_past = number + 1;
   int result = 0;
   check_current(symbol, Period_to_Call, num);
   check_past(symbol, Period_to_Call, num_past);
   if (trend == -1) {
      //sell conditions
      if (current_1 > past_1) {
         result = 1;
      }
   } else if (trend == 1) {
      //buy conditions
      if (current_1 < past_1) {
         result = 1;
      }
   }
   return (result);
}
*/


void check_current(string symbol, int Period_to_Call, int num)
{
   current_1 = calculate_strategy_fantailvma3(symbol, 1, Period_to_Call, num);
   current_26 = calculate_strategy_fantailvma3(symbol, 26, Period_to_Call, num);
   current_100 = calculate_strategy_fantailvma3(symbol, 100, Period_to_Call, num);
   //Alert("Current: ", DoubleToStr(current_1, Digits), " - ", DoubleToStr(current_26, Digits), " - ", DoubleToStr(current_100, Digits));
}
void check_past(string symbol, int Period_to_Call, int num_past)
{
   past_1 = calculate_strategy_fantailvma3(symbol, 1, Period_to_Call, num_past);
   past_26 = calculate_strategy_fantailvma3(symbol, 26, Period_to_Call, num_past);
   past_100 = calculate_strategy_fantailvma3(symbol, 100, Period_to_Call, num_past);
   //Alert("Past: ", DoubleToStr(past_1, Digits), " - ", DoubleToStr(past_26, Digits), " - ", DoubleToStr(past_100, Digits));
}

