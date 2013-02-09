//+------------------------------------------------------------------+
//|                                                     m_common.mq4 |
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
      if (custom_lots) lots = lots_USDCHF;
      currency_USDCHF = "USDCHF";
   }

   if (GBPUSD) {
         if (custom_lots) lots = lots_GBPUSD;
      currency_GBPUSD = "GBPUSD";
   }
   
   if (EURUSD) {
         if (custom_lots) lots = lots_EURUSD;
      currency_EURUSD = "EURUSD";
   }
   
   if (USDJPY) {
         if (custom_lots) lots = lots_USDJPY;
      currency_USDJPY = "USDJPY";
   }
   
   if (USDCAD) {
         if (custom_lots) lots = lots_USDCAD;
      currency_USDCAD = "USDCAD";
   }

   if (AUDUSD) {
         if (custom_lots) lots = lots_AUDUSD;
      currency_AUDUSD = "AUDUSD";
   }
   
   if (EURGBP) {
         if (custom_lots) lots = lots_EURGBP;
      currency_EURGBP = "EURGBP";
   }
   
   if (EURAUD) {
         if (custom_lots) lots = lots_EURAUD;
      currency_EURAUD = "EURAUD";
   }
   
   if (EURCHF) {
      if (custom_lots) lots = lots_EURCHF;
      currency_EURCHF = "EURCHF";
   }
   
   if (EURJPY) {
      if (custom_lots) lots = lots_EURJPY;
      currency_EURJPY = "EURJPY";
   }
   
   if (GBPCHF) {
      if (custom_lots) lots = lots_GBPCHF;
      currency_GBPCHF = "GBPCHF";
   }
   
   if (CADJPY) {
      if (custom_lots) lots = lots_CADJPY;
      currency_CADJPY = "CADJPY";
   }
   
   if (GBPJPY) {
      if (custom_lots) lots = lots_GBPJPY;
      currency_GBPJPY = "GBPJPY";
   }
   
   if (AUDNZD) {
      if (custom_lots) lots = lots_AUDNZD;
      currency_AUDNZD = "AUDNZD";
   }
   
   if (AUDCAD) {
      if (custom_lots) lots = lots_AUDCAD;
      currency_AUDCAD = "AUDCAD";
   }
   
   if (AUDCHF) {
      if (custom_lots) lots = lots_AUDCHF;
      currency_AUDCHF = "AUDCHF";
   }
   
   if (AUDJPY) {
      if (custom_lots) lots = lots_AUDJPY;
      currency_AUDJPY = "AUDJPY";
   }
   
   if (CHFJPY) {
      if (custom_lots) lots = lots_CHFJPY;
      currency_CHFJPY = "CHFJPY";
   }
   
   if (EURNZD) {
      if (custom_lots) lots = lots_EURNZD;
      currency_EURNZD = "EURNZD";
   }
   
   if (EURCAD) {
      if (custom_lots) lots = lots_EURCAD;
      currency_EURCAD = "EURCAD";
   }
   
   if (CADCHF) {
      if (custom_lots) lots = lots_CADCHF;
      currency_CADCHF = "CADCHF";
   }
   
   if (NZDJPY) {
      if (custom_lots) lots = lots_NZDJPY;
      currency_NZDJPY = "NZDJPY";
   }
   
   if (NZDUSD) {
      if (custom_lots) lots = lots_NZDUSD;
      currency_NZDUSD = "NZDUSD";
   }
   
   if (GBPCAD) {
      if (custom_lots) lots = lots_GBPCAD;
      currency_GBPCAD = "GBPCAD";
   }
   
   if (GBPNZD) {
      if (custom_lots) lots = lots_GBPNZD;
      currency_GBPNZD = "GBPNZD";
   }
   
   if (GBPAUD) {
      if (custom_lots) lots = lots_GBPAUD;
      currency_GBPAUD = "GBPAUD";
   }
   
   if (NZDCHF) {
      if (custom_lots) lots = lots_NZDCHF;
      currency_NZDCHF = "NZDCHF";
   }
   if (NZDCAD) {
      if (custom_lots) lots = lots_NZDCAD;
      currency_NZDCAD = "NZDCAD";
   }
}


void check_for_open()
{
   if (current_currency_pair == true) {
      infobox = "//-------------Taking Current Currency Pair-------------//\n";
      trade(Symbol());
   } else {
      if (currency_USDCHF == "USDCHF") {
         trade(currency_USDCHF);
      }
      if (currency_GBPUSD == "GBPUSD") {
         trade(currency_GBPUSD);
      }
      if (currency_EURUSD == "EURUSD") {
         trade(currency_EURUSD);
      }
      if (currency_USDJPY == "USDJPY") {
         trade(currency_USDJPY);
      }
      if (currency_USDCAD == "USDCAD") {
         trade(currency_USDCAD);
      }
      if (currency_AUDUSD == "AUDUSD") {
         trade(currency_AUDUSD);
      }
      if (currency_EURGBP == "EURGBP") {
         trade(currency_EURGBP);
      }
      if (currency_EURAUD == "EURAUD") {
         trade(currency_EURAUD);
      }
      if (currency_EURCHF == "EURCHF") {
         trade(currency_EURCHF);
      }
      if (currency_EURJPY == "EURJPY") {
         trade(currency_EURJPY);
      }
      if (currency_GBPCHF == "GBPCHF") {
         trade(currency_GBPCHF);
      }
      if (currency_CADJPY == "CADJPY") {
         trade(currency_CADJPY);
      }
      if (currency_GBPJPY == "GBPJPY") {
         trade(currency_GBPJPY);
      }
      if (currency_AUDNZD == "AUDNZD") {
         trade(currency_AUDNZD);
      }
      if (currency_AUDCAD == "AUDCAD") {
         trade(currency_AUDCAD);
      }
      if (currency_AUDCHF == "AUDCHF") {
         trade(currency_AUDCHF);
      }
      if (currency_AUDJPY == "AUDJPY") {
         trade(currency_AUDJPY);
      }
      if (currency_CHFJPY == "CHFJPY") {
         trade(currency_CHFJPY);
      }
      if (currency_EURNZD == "EURNZD") {
         trade(currency_EURNZD);
      }
      if (currency_EURCAD == "EURCAD") {
         trade(currency_EURCAD);
      }
      if (currency_CADCHF == "CADCHF") {
         trade(currency_CADCHF);
      }
      if (currency_NZDJPY == "NZDJPY") {
         trade(currency_NZDJPY);
      }
      if (currency_NZDUSD == "NZDUSD") {
         trade(currency_NZDUSD);
      }
      if (currency_GBPCAD == "GBPCAD") {
         trade(currency_GBPCAD);
      }
      if (currency_GBPNZD == "GBPNZD") {
         trade(currency_GBPNZD);
      }
      if (currency_GBPAUD == "GBPAUD") {
         trade(currency_GBPAUD);
      }
      if (currency_NZDCHF == "NZDCHF") {
         trade(currency_NZDCHF);
      }
      if (currency_NZDCAD == "NZDCAD") {
         trade(currency_NZDCAD);
      }
   }
   
   Comment(copyrightst, "Ask: ", DoubleToStr(Ask, Digits), ", Bid: ", DoubleToStr(Bid, Digits), "\n", inference, "\n", infobox);
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
   if (t == 1) {
      if (custom_tp > 0) {
         tp = MarketInfo(symbol,MODE_ASK) + (custom_tp * MarketInfo(symbol,MODE_POINT));
      } else {
         return (0);
      }      
   }
   else if (t == -1) {
      if (custom_tp > 0) {
         tp = MarketInfo(symbol,MODE_BID) - (custom_tp * MarketInfo(symbol,MODE_POINT));
      } else {
         return (0);
      }      
   }
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
   if (t == 1) {
      if (custom_sl > 0) {
         sl = MarketInfo(symbol,MODE_ASK) - (custom_sl * MarketInfo(symbol,MODE_POINT));
      } else {
         return (0);
      }      
   }
   else if (t == -1) {
      if (custom_sl > 0) {
         sl = MarketInfo(symbol,MODE_BID) + (custom_sl * MarketInfo(symbol,MODE_POINT));
      } else {
         return (0);
      }      
   }
 
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
      if(OrderMagicNumber()==MAGICMA)
        {
         if(OrderType()==OP_BUY || OrderType()==OP_SELL)
            corders++;
        }
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
      if(OrderSymbol()==symbol && OrderMagicNumber()==MAGICMA)
        {
         cnt++;
        }
     }
   return (cnt);
  }
  
  
void trade(string symbol)
{
   //Get Trend Inf
   int result = 0;
   int result2 = 0;
   double tp;
   string message = "";
   infobox = StringConcatenate(infobox, "\nCurrency: ", symbol, "\n");
   trend_all = all_trends(symbol, number);
   infobox = StringConcatenate(infobox, "Complete Trend: ", TrendTostring(trend_all));
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

int all_trends(string symbol, int num)
{
   int trend1 = 0;
   int trend2 = 0;
   int trend3 = 0;
   int trend4 = 0;
   int trend5 = 0;
   int trend6 = 0;
   trend1 = strategy_trend(symbol, number, PERIOD_H4);
   trend2 = strategy_trend(symbol, number, PERIOD_H1);
   trend3 = strategy_trend(symbol, number, PERIOD_M30);
   trend4 = strategy_trend(symbol, number, PERIOD_M15);
   trend5 = strategy_trend(symbol, number, PERIOD_M5);
   trend6 = strategy_trend(symbol, number, PERIOD_M1);
   if (trend1 == trend2  && trend2 == trend3 && trend3 == trend4 && trend4 == trend5 && trend5 == trend6) {
      return (trend1);
   } else {
      return (0);
   }
}

void custom_start()
{
   infobox = "";
   inference = "Inference:\n";
   check_for_close();
   check_for_open();
}


int trade_process(string symbol, int cur, int pa)
{
   infobox = StringConcatenate(infobox, "\n\n", TimeframeToString(cur), "/", TimeframeToString(pa));
   int trend = trend_trade(symbol, pa);
   if (cur > PERIOD_H4) {

   } else if (cur != PERIOD_M1) {
      trend = trend_all;
   }
   //if (cur > PERIOD_H4) {
      //infobox = StringConcatenate(infobox, "\n");
   //}
   //check entry point
   int result = check_entry_point(symbol, cur, trend);
   return (result);
}
int trend_trade(string symbol, int Period_to_Call)
{
   int trend;
   trend = strategy_trend(symbol, number, Period_to_Call);
   infobox = StringConcatenate(infobox, ",", "Trend: ", TrendTostring(trend));
   return (trend);
}

void custom_init()
{
   infobox = "Authenticating......";
   Comment(copyrightst, infobox);
   auth();
   //----CONVERSOIN
   conversion();
   infobox = "Starting the Robot......";
   Comment(copyrightst, infobox);
}