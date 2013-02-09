//+------------------------------------------------------------------+
//|                                                masterblaster.mq4 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#include <stdlib.mqh>
#include <WinUser32.mqh>

extern bool current_currency_pair = false;
extern bool current_period = false;
extern bool createorders = true;
extern bool show_alerts = false;
extern double lots = 0.01;
extern double lots_step = 0.01;
extern double lots_max = 0.25;
extern int maxorders = 100;
extern bool time_one_min = false;
extern bool time_five_min = false;
extern bool time_fifteen_min = true;
extern bool time_half_hour = true;
extern bool time_one_hour = true;
extern bool time_four_hour = true;
extern bool time_one_day = false;
extern bool time_one_week = false;
extern bool time_one_month = false;
extern bool USDCHF = true;
extern bool GBPUSD = true;
extern bool EURUSD = true;
extern bool USDJPY = true;
extern bool USDCAD = true;
extern bool AUDUSD = true;
extern bool EURGBP = true;
extern bool EURAUD = true;
extern bool EURCHF = true;
extern bool EURJPY = true;
extern bool GBPCHF = true;
extern bool CADJPY = true;
extern bool GBPJPY = true;
extern bool AUDNZD = true;
extern bool AUDCAD = true;
extern bool AUDCHF = true;
extern bool AUDJPY = true;
extern bool CHFJPY = true;
extern bool EURNZD = true;
extern bool EURCAD = true;
extern bool CADCHF = true;
extern bool NZDJPY = true;
extern bool NZDUSD = true;
extern bool GBPCAD = true;
extern bool GBPNZD = true;
extern bool GBPAUD = true;
extern bool NZDCHF = true;
extern bool NZDCAD = true;


extern double lots_USDCHF = 0.01;
extern double lots_GBPUSD = 0.01;
extern double lots_EURUSD = 0.01;
extern double lots_USDJPY = 0.01;
extern double lots_USDCAD = 0.01;
extern double lots_AUDUSD = 0.01;
extern double lots_EURGBP = 0.01;
extern double lots_EURAUD = 0.01;
extern double lots_EURCHF = 0.01;
extern double lots_EURJPY = 0.01;
extern double lots_GBPCHF = 0.01;
extern double lots_CADJPY = 0.01;
extern double lots_GBPJPY = 0.01;
extern double lots_AUDNZD = 0.01;
extern double lots_AUDCAD = 0.01;
extern double lots_AUDCHF = 0.01;
extern double lots_AUDJPY = 0.01;
extern double lots_CHFJPY = 0.01;
extern double lots_EURNZD = 0.01;
extern double lots_EURCAD = 0.01;
extern double lots_CADCHF = 0.01;
extern double lots_NZDJPY = 0.01;
extern double lots_NZDUSD = 0.01;
extern double lots_GBPCAD = 0.01;
extern double lots_GBPNZD = 0.01;
extern double lots_GBPAUD = 0.01;
extern double lots_NZDCHF = 0.01;
extern double lots_NZDCAD = 0.01;


extern int number = 1;
string copyrightst = "By Manish Khanchandani\n\n";
string currency_USDCHF;
string currency_GBPUSD;
string currency_EURUSD;
string currency_USDJPY;
string currency_USDCAD;
string currency_AUDUSD;
string currency_EURGBP;
string currency_EURAUD;
string currency_EURCHF;
string currency_EURJPY;
string currency_GBPCHF;
string currency_CADJPY;
string currency_GBPJPY;
string currency_AUDNZD;
string currency_AUDCAD;
string currency_AUDCHF;
string currency_AUDJPY;
string currency_CHFJPY;
string currency_EURNZD;
string currency_EURCAD;
string currency_CADCHF;
string currency_NZDJPY;
string currency_NZDUSD;
string currency_GBPCAD;
string currency_GBPNZD;
string currency_GBPAUD;
string currency_NZDCHF;
string currency_NZDCAD;

double build = 1.2;
string demo;
string infobox;
string inference = "Inference: ";
int trend_all;
   double current_1, current_26, current_100;
   double past_1, past_26, past_100;
   int cur_period, pa_period;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   //----AUTHENTICATION
   infobox = "Authenticating......";
   Comment(copyrightst, infobox);
   auth();
   //----CONVERSOIN
   conversion();
   infobox = "Starting the Robot......";
   Comment(copyrightst, infobox);
   //----START
   //custom_start();
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
   custom_start();
//----
   return(0);
  }
//+------------------------------------------------------------------+

void custom_start()
{
   infobox = "";
   inference = "Inference:\n";
   check_for_close();
   check_for_open();
}

//-----AUTHENTICATION
void auth()
{

}

void conversion()
{
   if (current_currency_pair) {
      return;
   }

   if (USDCHF) {
      currency_USDCHF = "USDCHF";
   }

   if (GBPUSD) {
      currency_GBPUSD = "GBPUSD";
   }
   
   if (EURUSD) {
      currency_EURUSD = "EURUSD";
   }
   
   if (USDJPY) {
      currency_USDJPY = "USDJPY";
   }
   
   if (USDCAD) {
      currency_USDCAD = "USDCAD";
   }

   if (AUDUSD) {
      currency_AUDUSD = "AUDUSD";
   }
   
   if (EURGBP) {
      currency_EURGBP = "EURGBP";
   }
   
   if (EURAUD) {
      currency_EURAUD = "EURAUD";
   }
   
   if (EURCHF) {
      currency_EURCHF = "EURCHF";
   }
   
   if (EURJPY) {
      currency_EURJPY = "EURJPY";
   }
   
   if (GBPCHF) {
      currency_GBPCHF = "GBPCHF";
   }
   
   if (CADJPY) {
      currency_CADJPY = "CADJPY";
   }
   
   if (GBPJPY) {
      currency_GBPJPY = "GBPJPY";
   }
   
   if (AUDNZD) {
      currency_AUDNZD = "AUDNZD";
   }
   
   if (AUDCAD) {
      currency_AUDCAD = "AUDCAD";
   }
   
   if (AUDCHF) {
      currency_AUDCHF = "AUDCHF";
   }
   
   if (AUDJPY) {
      currency_AUDJPY = "AUDJPY";
   }
   
   if (CHFJPY) {
      currency_CHFJPY = "CHFJPY";
   }
   
   if (EURNZD) {
      currency_EURNZD = "EURNZD";
   }
   
   if (EURCAD) {
      currency_EURCAD = "EURCAD";
   }
   
   if (CADCHF) {
      currency_CADCHF = "CADCHF";
   }
   
   if (NZDJPY) {
      currency_NZDJPY = "NZDJPY";
   }
   
   if (NZDUSD) {
      currency_NZDUSD = "NZDUSD";
   }
   
   if (GBPCAD) {
      currency_GBPCAD = "GBPCAD";
   }
   
   if (GBPNZD) {
      currency_GBPNZD = "GBPNZD";
   }
   
   if (GBPAUD) {
      currency_GBPAUD = "GBPAUD";
   }
   
   if (NZDCHF) {
      currency_NZDCHF = "NZDCHF";
   }
   if (NZDCAD) {
      currency_NZDCAD = "NZDCAD";
   }
}

void check_for_close()
{
   return (0);
   int result = 0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      //---- check order type 
      if(OrderType()==OP_BUY && OrderProfit() > 0)
        {
            result = check_exit_point(OrderSymbol(), Period(), 1);
            if(result == 1) OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),3,White);
        }
      if(OrderType()==OP_SELL && OrderProfit() > 0)
        {
            result = check_exit_point(OrderSymbol(), Period(), -1);
            if(result == 1) OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3,White);
        }
     }
}

void check_for_open()
{
   if (current_currency_pair == true) {
      infobox = "Taking Current Currency Pair\n";
      trade(Symbol());
   } else {
      if (currency_USDCHF == "USDCHF") {
         lots = lots_USDCHF;
         trade(currency_USDCHF);
      }
      if (currency_GBPUSD == "GBPUSD") {
         lots = lots_GBPUSD;
         trade(currency_GBPUSD);
      }
      if (currency_EURUSD == "EURUSD") {
         lots = lots_EURUSD;
         trade(currency_EURUSD);
      }
      if (currency_USDJPY == "USDJPY") {
         lots = lots_USDJPY;
         trade(currency_USDJPY);
      }
      if (currency_USDCAD == "USDCAD") {
         lots = lots_USDCAD;
         trade(currency_USDCAD);
      }
      if (currency_AUDUSD == "AUDUSD") {
         lots = lots_AUDUSD;
         trade(currency_AUDUSD);
      }
      if (currency_EURGBP == "EURGBP") {
         lots = lots_EURGBP;
         trade(currency_EURGBP);
      }
      if (currency_EURAUD == "EURAUD") {
         lots = lots_EURAUD;
         trade(currency_EURAUD);
      }
      if (currency_EURCHF == "EURCHF") {
         lots = lots_EURCHF;
         trade(currency_EURCHF);
      }
      if (currency_EURJPY == "EURJPY") {
         lots = lots_EURJPY;
         trade(currency_EURJPY);
      }
      if (currency_GBPCHF == "GBPCHF") {
         lots = lots_GBPCHF;
         trade(currency_GBPCHF);
      }
      if (currency_CADJPY == "CADJPY") {
         lots = lots_CADJPY;
         trade(currency_CADJPY);
      }
      if (currency_GBPJPY == "GBPJPY") {
         lots = lots_GBPJPY;
         trade(currency_GBPJPY);
      }
      if (currency_AUDNZD == "AUDNZD") {
         lots = lots_AUDNZD;
         trade(currency_AUDNZD);
      }
      if (currency_AUDCAD == "AUDCAD") {
         lots = lots_AUDCAD;
         trade(currency_AUDCAD);
      }
      if (currency_AUDCHF == "AUDCHF") {
         lots = lots_AUDCHF;
         trade(currency_AUDCHF);
      }
      if (currency_AUDJPY == "AUDJPY") {
         lots = lots_AUDJPY;
         trade(currency_AUDJPY);
      }
      if (currency_CHFJPY == "CHFJPY") {
         lots = lots_CHFJPY;
         trade(currency_CHFJPY);
      }
      if (currency_EURNZD == "EURNZD") {
         lots = lots_EURNZD;
         trade(currency_EURNZD);
      }
      if (currency_EURCAD == "EURCAD") {
         lots = lots_EURCAD;
         trade(currency_EURCAD);
      }
      if (currency_CADCHF == "CADCHF") {
         lots = lots_CADCHF;
         trade(currency_CADCHF);
      }
      if (currency_NZDJPY == "NZDJPY") {
         lots = lots_NZDJPY;
         trade(currency_NZDJPY);
      }
      if (currency_NZDUSD == "NZDUSD") {
         lots = lots_NZDUSD;
         trade(currency_NZDUSD);
      }
      if (currency_GBPCAD == "GBPCAD") {
         lots = lots_GBPCAD;
         trade(currency_GBPCAD);
      }
      if (currency_GBPNZD == "GBPNZD") {
         lots = lots_GBPNZD;
         trade(currency_GBPNZD);
      }
      if (currency_GBPAUD == "GBPAUD") {
         lots = lots_GBPAUD;
         trade(currency_GBPAUD);
      }
      if (currency_NZDCHF == "NZDCHF") {
         lots = lots_NZDCHF;
         trade(currency_NZDCHF);
      }
      if (currency_NZDCAD == "NZDCAD") {
         lots = lots_NZDCAD;
         trade(currency_NZDCAD);
      }
   }
   
   Comment(copyrightst, "Ask: ", DoubleToStr(Ask, Digits), ", Bid: ", DoubleToStr(Bid, Digits), "\n", inference, "\n", infobox);
}
void trade(string symbol)
{
   //Get Trend Inf
   int result = 0;
   int result2 = 0;
   double tp;
   string message = "";
   infobox = StringConcatenate(infobox, "\nCurrency: ", symbol);
   trend_all = all_trends(symbol, number);
   infobox = StringConcatenate(infobox, ", ", "Complete Trend: ", TrendTostring(trend_all));
   if (current_period) {
      if (Period() == PERIOD_M1) {
         result = trade_process(symbol, PERIOD_M1, PERIOD_M1);
         message = TimeframeToString(PERIOD_M1);
      } else {
         result = trade_process(symbol, Period(), Period());
         message = TimeframeToString(Period());
      }
      if (result != 0) {
         result2 = result;
         tp = calculate_tp(symbol, Period(), result2);
      }
   } else {
      if (time_one_min) {
         result = trade_process(symbol, PERIOD_M1, PERIOD_M1);
         if (result != 0) {
            result2 = result;
            tp = calculate_tp(symbol, PERIOD_M1, result2);
            message = TimeframeToString(PERIOD_M1);
         }
      }
      if (time_five_min) {
         result = trade_process(symbol, PERIOD_M5, PERIOD_M5);
         if (result != 0) {
            result2 = result;
            tp = calculate_tp(symbol, PERIOD_M5, result2);
            message = TimeframeToString(PERIOD_M5);
         }
      }
      if (time_fifteen_min) {
         result = trade_process(symbol, PERIOD_M15, PERIOD_M15);
         if (result != 0) {
            result2 = result;
            tp = calculate_tp(symbol, PERIOD_M15, result2);
            message = TimeframeToString(PERIOD_M15);
         }
      }
      if (time_half_hour) {
         result = trade_process(symbol, PERIOD_M30, PERIOD_M30);
         if (result != 0) {
            result2 = result;
            tp = calculate_tp(symbol, PERIOD_M30, result2);
            message = TimeframeToString(PERIOD_M30);
         }
      }
      if (time_one_hour) {
         result = trade_process(symbol, PERIOD_H1, PERIOD_H1);
         if (result != 0) {
            result2 = result;
            tp = calculate_tp(symbol, PERIOD_H1, result2);
            message = TimeframeToString(PERIOD_H1);
         }
      }
      if (time_four_hour) {
         result = trade_process(symbol, PERIOD_H4, PERIOD_H4);
         if (result != 0) {
            result2 = result;
            tp = calculate_tp(symbol, PERIOD_H4, result2);
            message = TimeframeToString(PERIOD_H4);
         }
      }
      if (time_one_day) {
         result = trade_process(symbol, PERIOD_D1, PERIOD_D1);
         //if (result != 0) result2 = result;
      }
      if (time_one_week) {
         result = trade_process(symbol, PERIOD_W1, PERIOD_W1);
         //if (result != 0) result2 = result;
      }
      if (time_one_month) {
         result = trade_process(symbol, PERIOD_MN1, PERIOD_MN1);
         //if (result != 0) result2 = result;
      }
   }

   if (result2 != 0) {
      //create order;
      double sl = calculate_sl(symbol, result2);
      infobox = StringConcatenate(infobox, "\n", TrendTostring(result2));
      create_orders(symbol, result2, message, tp, sl);
   }
}
int trade_process(string symbol, int cur, int pa)
{
   infobox = StringConcatenate(infobox, " --- ", TimeframeToString(cur), "/", TimeframeToString(pa));
   int trend = trend_trade(symbol, pa);
   if (trend_all != trend) {
      return (0);
   }
   if (cur > PERIOD_H4) {

   } else if (cur != PERIOD_M1) {
      trend = trend_all;
   }
   if (cur > PERIOD_H4) {
      infobox = StringConcatenate(infobox, "\n");
   }
   //check entry point
   int result = check_entry_point(symbol, cur, trend);
   return (result);
}
int trend_trade(string symbol, int Period_to_Call)
{
   int trend;
   trend = strategy_trend(symbol, number, Period_to_Call);
   infobox = StringConcatenate(infobox, ",", "T: ", TrendTostring(trend));
   return (trend);
}
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
int all_trends(string symbol, int num)
{
   int trend1 = 0;
   int trend2 = 0;
   int trend3 = 0;
   int trend4 = 0;
   trend1 = strategy_trend(symbol, number, PERIOD_H4);
   trend2 = strategy_trend(symbol, number, PERIOD_H1);
   trend3 = strategy_trend(symbol, number, PERIOD_M30);
   trend4 = strategy_trend(symbol, number, PERIOD_M15);
   if (trend1 == trend2  && trend2 == trend3 && trend3 == trend4) {
      return (trend1);
   } else {
      return (0);
   }
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

string TimeframeToString(int P)
{
   switch(P)
   {
      case PERIOD_M1:  return("M1");
      case PERIOD_M5:  return("M5");
      case PERIOD_M15: return("M15");
      case PERIOD_M30: return("M30");
      case PERIOD_H1:  return("H1");
      case PERIOD_H4:  return("H4");
      case PERIOD_D1:  return("D1");
      case PERIOD_W1:  return("W1");
      case PERIOD_MN1: return("MN1");
   }
}
double calculate_tp(string symbol, int P, int t)
{
   double tp;
   if (t == 1) tp = MarketInfo(symbol,MODE_ASK) + (150 * MarketInfo(symbol,MODE_POINT));
   else if (t == -1) tp = MarketInfo(symbol,MODE_BID) - (150 * MarketInfo(symbol,MODE_POINT));
   return (tp);
   switch(P)
   {
      case PERIOD_M1:
         if (t == 1) tp = MarketInfo(symbol,MODE_ASK) + (20 * MarketInfo(symbol,MODE_POINT));
         else if (t == -1) tp = MarketInfo(symbol,MODE_BID) - (20 * MarketInfo(symbol,MODE_POINT));
         break;
      case PERIOD_M5:  
         if (t == 1) tp = MarketInfo(symbol,MODE_ASK) + (40 * MarketInfo(symbol,MODE_POINT));
         else if (t == -1) tp = MarketInfo(symbol,MODE_BID) - (40 * MarketInfo(symbol,MODE_POINT));
         break;
      case PERIOD_M15: 
         if (t == 1) tp = MarketInfo(symbol,MODE_ASK) + (60 * MarketInfo(symbol,MODE_POINT));
         else if (t == -1) tp = MarketInfo(symbol,MODE_BID) - (60 * MarketInfo(symbol,MODE_POINT));
         break;
      case PERIOD_M30: 
         if (t == 1) tp = MarketInfo(symbol,MODE_ASK) + (100 * MarketInfo(symbol,MODE_POINT));
         else if (t == -1) tp = MarketInfo(symbol,MODE_BID) - (100 * MarketInfo(symbol,MODE_POINT));
         break;
      case PERIOD_H1:  
         if (t == 1) tp = MarketInfo(symbol,MODE_ASK) + (150 * MarketInfo(symbol,MODE_POINT));
         else if (t == -1) tp = MarketInfo(symbol,MODE_BID) - (150 * MarketInfo(symbol,MODE_POINT));
         break;
      case PERIOD_H4:  
         if (t == 1) tp = MarketInfo(symbol,MODE_ASK) + (200 * MarketInfo(symbol,MODE_POINT));
         else if (t == -1) tp = MarketInfo(symbol,MODE_BID) - (200 * MarketInfo(symbol,MODE_POINT));
         break;
      case PERIOD_D1:  
         if (t == 1) tp = MarketInfo(symbol,MODE_ASK) + (500 * MarketInfo(symbol,MODE_POINT));
         else if (t == -1) tp = MarketInfo(symbol,MODE_BID) - (500 * MarketInfo(symbol,MODE_POINT));
         break;
      case PERIOD_W1:  
         if (t == 1) tp = MarketInfo(symbol,MODE_ASK) + (1000 * MarketInfo(symbol,MODE_POINT));
         else if (t == -1) tp = MarketInfo(symbol,MODE_BID) - (1000 * MarketInfo(symbol,MODE_POINT));
         break;
      case PERIOD_MN1: 
         if (t == 1) tp = MarketInfo(symbol,MODE_ASK) + (2000 * MarketInfo(symbol,MODE_POINT));
         else if (t == -1) tp = MarketInfo(symbol,MODE_BID) - (2000 * MarketInfo(symbol,MODE_POINT));
         break;
   }

   return (tp);
}
double calculate_sl(string symbol, int t)
{
   double sl;
   if (t == 1) sl = MarketInfo(symbol,MODE_ASK) - (1000 * MarketInfo(symbol,MODE_POINT));
   else if (t == -1) sl = MarketInfo(symbol,MODE_BID) + (1000 * MarketInfo(symbol,MODE_POINT));
 
   return (sl);
}
string TrendTostring(int t)
{
   switch (t)
   {
      case 1: return ("Buy");
      case -1: return ("Sell");
      case 0: return ("Consolidated");
   }
}

int CalculateCurrentMaxOrders()
  {
   int corders=0;
//----
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      //if(OrderMagicNumber()==MAGICMA)
        //{
         if(OrderType()==OP_BUY || OrderType()==OP_SELL)
            corders++;
        //}
     }
         return(corders);
}


int CalculateCurrentOrders(string symbol)
  {
   int cnt=0;
//----
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==symbol)// && OrderMagicNumber()==MAGICMA
        {
         cnt++;
        }
     }
   return (cnt);
  }

int create_orders(string symbol, int type, string message, double tp, double sl)
{
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
      message = StringConcatenate("MasterBlast, ", message, ", B: ", build);
      ticket=OrderSend(symbol,OP_BUY,lots,MarketInfo(symbol,MODE_ASK),3,sl,tp,message,255,0,CLR_NONE);
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
      message = StringConcatenate("MasterBlast, ", message, ", B: ", build);
      ticket=OrderSend(symbol,OP_SELL,lots,MarketInfo(symbol,MODE_BID),3,sl,tp,message,255,0,CLR_NONE);
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
/*
void usdchf()
{
   int trend;
   trend = strategy_trend(currency_usdchf, number, PERIOD_M5);
   infobox = StringConcatenate(infobox, ", ", "Trend: ", trend);
}

void eurusd()
{
   int trend;
   trend = strategy_trend(currency_eurusd, number, PERIOD_M5);
   infobox = StringConcatenate(infobox, ", ", "Trend: ", trend);
}
void audusd()
{
   int trend;
   trend = strategy_trend(currency_audusd, number, PERIOD_M5);
   infobox = StringConcatenate(infobox, ", ", "Trend: ", trend);
}*/
/*
double bid   =MarketInfo("EURUSD",MODE_BID);
   double ask   =MarketInfo("EURUSD",MODE_ASK);
   double point =MarketInfo("EURUSD",MODE_POINT);
   int    digits=MarketInfo("EURUSD",MODE_DIGITS);
   int    spread=MarketInfo("EURUSD",MODE_SPREAD);


double vma(string symbol, int MA_Length, int Period_of_Time, int shift)
{
   int ADX_Length = 2;
   double Weighting = 2.0;
   int MA_Mode = 1;
   double L_1;
   
   if (ADX_Length<2)ADX_Length=2;
   if (ADX_Length>8)ADX_Length=8;
   if (Weighting<1)Weighting=1;
   if (Weighting>8)Weighting=8;
   
   double Hi  = MarketInfo("EURUSD", MODE_HIGH);
   double Hi1 = High[i+1];
   double Lo  = Low[i];
   double Lo1 = Low[i+1];
   double Close1= Close[i+1];   
   return (L_1);
}
*/