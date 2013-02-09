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

string build = "EMA 1.1";
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
   current = calculate_strategy_ema(symbol, 1, Period_to_Call, num);
   toplevel = calculate_strategy_ema(symbol, 100, Period_to_Call, num);
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
   return (0);
   int result = 0;
   for(int i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)
         break;
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
      }
   }
}


int check_entry_point(string symbol, int Period_to_Call, int trend)
{
   int num = number;
   int num_past = number + 1;
   int result = 0;
   check_current(symbol, Period_to_Call, num);
   check_past(symbol, Period_to_Call, num_past);
   double macd = iMACD(symbol,Period_to_Call,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
   double macd1 = iMACD(symbol,Period_to_Call,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   double macd2 = iMACD(symbol,Period_to_Call,12,26,9,PRICE_CLOSE,MODE_MAIN,2);
   double macd3 = iMACD(symbol,Period_to_Call,12,26,9,PRICE_CLOSE,MODE_MAIN,3);
   double macd4 = iMACD(symbol,Period_to_Call,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
   double macd5 = iMACD(symbol,Period_to_Call,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
   string message = "";
   if (macd > 0) {
      message = StringConcatenate(message, "Positive");
   } else if (macd < 0) {
      message = StringConcatenate(message, "Negative");
   }
   if (macd > macd1) {
      message = StringConcatenate(message, ", Tending Upward");
   } else if (macd < macd1) {
      message = StringConcatenate(message, ", Tending Downward");
   }
   message = StringConcatenate(message, ", MACD Signal: ");
   if (macd4 > 0) {
      message = StringConcatenate(message, "Positive");
   } else if (macd4 < 0) {
      message = StringConcatenate(message, "Negative");
   }
   if (macd4 > macd5) {
      message = StringConcatenate(message, ", Tending Upward");
   } else if (macd4 < macd5) {
      message = StringConcatenate(message, ", Tending Downward");
   }
   infobox = StringConcatenate(infobox, ", MACD: ", message);
   /*
   double iac = iAC(symbol, Period_to_Call, num);
   double iac2 = iAC(symbol, Period_to_Call, num_past);
   infobox = StringConcatenate(infobox, "\nBill Williams Acc/Dec: ", DoubleToStr(iac, MarketInfo(symbol, MODE_DIGITS)), " / ", DoubleToStr(iac2, MarketInfo(symbol, MODE_DIGITS)));
   double iao=iAO(symbol, Period_to_Call, num);
   double iao2=iAO(symbol, Period_to_Call, num_past);
   infobox = StringConcatenate(infobox, "\nBill Williams Awesome oscillator: ", DoubleToStr(iao, MarketInfo(symbol, MODE_DIGITS)), " / ", DoubleToStr(iao2, MarketInfo(symbol, MODE_DIGITS)));
   double iad = iAD(symbol, Period_to_Call, num);
   double iad2 = iAD(symbol, Period_to_Call, num_past);
   infobox = StringConcatenate(infobox, "\nAccumulation/Distribution: ", DoubleToStr(iad, MarketInfo(symbol, MODE_DIGITS)), " / ", DoubleToStr(iad2, MarketInfo(symbol, MODE_DIGITS)));

*/

   if (trend_all != trend) {
      return (0);
   }
   if (trend == -1) {
      //sell conditions
      double high;
      if (current_1 < past_1 && (current_1 < current_25 && current_1 < current_50 && current_1 < current_100)
         && (past_1 > past_25 || past_1 > past_50 || past_1 > past_100) && macd < 0 && (macd1 > 0 || macd2 > 0 || macd3 > 0)) {
         custom_order_message = "Cross";
         inference = StringConcatenate(inference, symbol, ": Cross Sell => ", TimeframeToString(Period_to_Call), "\n");
         if (show_alerts) Alert(symbol, ": Cross Sell => ", TimeframeToString(Period_to_Call));
         infobox = StringConcatenate(infobox, ",", "Cross Sell\n");
         result = -1;
      } else if (macd < 0 && macd1 > 0) {
         custom_order_message = "MACD";
         inference = StringConcatenate(inference, symbol, ": MACD Sell => ", TimeframeToString(Period_to_Call), "\n");
         if (show_alerts) Alert(symbol, ": MACD Sell => ", TimeframeToString(Period_to_Call));
         infobox = StringConcatenate(infobox, ",", "MACD Sell\n");
         result = -1;
      }
   } else if (trend == 1) {
      //buy conditions
      //condition 1
      if (current_1 > past_1 && (current_1 > current_25 && current_1 > current_50 && current_1 > current_100)
         && (past_1 < past_25 || past_1 < past_50 || past_1 < past_100) && macd > 0 && (macd1 < 0 || macd2 < 0 || macd3 < 0)) {
         custom_order_message = "Cross";
         infobox = StringConcatenate(infobox, ",", "Coss Buy\n");
         inference = StringConcatenate(inference, symbol, ": Cross Buy => ", TimeframeToString(Period_to_Call), "\n");
         if (show_alerts) Alert(symbol, ": Cross Buy => ", TimeframeToString(Period_to_Call));
         result = 1;
      } else if (macd > 0 && macd1 < 0) {
         custom_order_message = "MACD";
         infobox = StringConcatenate(infobox, ",", "MACD Buy\n");
         inference = StringConcatenate(inference, symbol, ": MACD Buy => ", TimeframeToString(Period_to_Call), "\n");
         if (show_alerts) Alert(symbol, ": MACD Buy => ", TimeframeToString(Period_to_Call));
         result = 1;
      }
   } else {
      //infobox = StringConcatenate(infobox, ", ", "No Buy and Sell Condition.");
   }

   //if (Period_to_Call != PERIOD_M5) {
      //return (0);
   //}

   return (result);
}

int check_exit_point(string symbol, int Period_to_Call, int trend)
{
   return (0);
   int num = number;
   int num_past = number + 1;
   int result = 0;
   check_current(symbol, Period_to_Call, num);
   //check_past(symbol, Period_to_Call, num_past);
   //double macd = iMACD(symbol,Period_to_Call,12,26,9,PRICE_CLOSE,MODE_MAIN,num);
   //double macd_prev = iMACD(symbol,Period_to_Call,12,26,9,PRICE_CLOSE,MODE_MAIN,num_past);

   if (trend == -1) {
      //sell conditions
      if (current_1 > current_25 || current_1 > current_50 && current_1 > current_100) {
         result = 1;
      }
   } else if (trend == 1) {
      //buy conditions
      if (current_1 < current_25 || current_1 < current_50 && current_1 < current_100) {
         result = 1;
      }
   }
   return (result);
}



void check_current(string symbol, int Period_to_Call, int num)
{
   current_1 = calculate_strategy_ema(symbol, 1, Period_to_Call, num);
   current_25 = calculate_strategy_ema(symbol, 26, Period_to_Call, num);
   current_50 = calculate_strategy_ema(symbol, 100, Period_to_Call, num);
   current_100 = calculate_strategy_ema(symbol, 100, Period_to_Call, num);
   //Alert("Current: ", DoubleToStr(current_1, Digits), " - ", DoubleToStr(current_25, Digits), " - ", DoubleToStr(current_50, Digits)
   //, " - ", DoubleToStr(current_100, Digits));
}
void check_past(string symbol, int Period_to_Call, int num_past)
{
   past_1 = calculate_strategy_ema(symbol, 1, Period_to_Call, num_past);
   past_25 = calculate_strategy_ema(symbol, 25, Period_to_Call, num_past);
   past_50 = calculate_strategy_ema(symbol, 50, Period_to_Call, num_past);
   past_100 = calculate_strategy_ema(symbol, 100, Period_to_Call, num_past);
   //Alert("Past: ", DoubleToStr(past_1, Digits), " - ", DoubleToStr(past_25, Digits), " - ", DoubleToStr(past_50, Digits)
   //, " - ", DoubleToStr(past_100, Digits));
}

