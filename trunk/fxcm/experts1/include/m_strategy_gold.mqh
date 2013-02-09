//+------------------------------------------------------------------+
//|                                               m_strategy_vma.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

string build = "Gold 1.2";

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
/*

int strategy_trend(string symbol, int num, int Period_to_Call)
{
   int trend = 0;
   double range = gold_william_percent_range(symbol, Period_to_Call, num);
   if (range > -25) {
      trend = 1;
   } else if (range < -75) {
      trend = -1;
   }
   return (trend);
}
*/
void check_for_close()
{
   return (0);
}


int check_entry_point(string symbol, int Period_to_Call, int trend)
{
   int num = number;
   int result = 0;
   if (trend_all != trend) {
      return (0);
   }
   result = gold(symbol, Period_to_Call, num);
   if (trend == -1 && result == -1) {
      //sell conditions
      inference = StringConcatenate(inference, symbol, ": Gold Sell => ", TimeframeToString(Period_to_Call), "\n");
      if (show_alerts) Alert(symbol, ": Cross Sell => ", TimeframeToString(Period_to_Call));
      infobox = StringConcatenate(infobox, ",", "Gold Sell\n");
      return (result);
   } else if (trend == 1 && result == 1) {
      //buy conditions
      inference = StringConcatenate(inference, symbol, ": Gold Buy => ", TimeframeToString(Period_to_Call), "\n");
      if (show_alerts) Alert(symbol, ": Cross Buy => ", TimeframeToString(Period_to_Call));
      infobox = StringConcatenate(infobox, ",", "Gold Buy\n");
      return (result);
   }
   return (result);
}

int gold(string symbol, int timeframe, int shift)
{
   int result = 0;
   int result1 = 0;
   int result2 = 0;
   int result3 = 0;
   int number2 = number + 1;
   double sell = gold_sell_zone_fibs(symbol, timeframe, number);
   double sell2 = gold_sell_zone_fibs(symbol, timeframe, number2);
   double buy = gold_buy_zone_fibs(symbol, timeframe, number);
   double buy2 = gold_buy_zone_fibs(symbol, timeframe, number2);
   double down = gold_rsioma_down(symbol, timeframe, number);
   double up = gold_rsioma_up(symbol, timeframe, number);
   double range = gold_william_percent_range(symbol, timeframe, number);
   double range2 = gold_william_percent_range(symbol, timeframe, number2);
   if (MarketInfo(symbol, MODE_ASK) < sell) {
      result1 = -1;
   } else if (MarketInfo(symbol, MODE_BID) > buy) {
      result1 = 1;
   }
   if (down == EMPTY_VALUE && up > 0) {
      result2 = 1;
   } else if (up == EMPTY_VALUE && down < 0) {
      result2 = -1; 
   }
   if (range < 0 && range > -25) {
      result3 = 1;
   } else if (range < -75) {
      result3 = -1;
   }
   if (result1 == 1 && result2 == 1 && result3 == 1) {
      if (range2 < -25 || iClose(symbol, timeframe, number2) < buy2) {
         result = 1;
      }
   } else if (result1 == -1 && result2 == -1 && result3 == -1) {
      if (range2 > -75 || iOpen(symbol, timeframe, number2) > sell2) {
         result = -1;
      }
   }
   return (result);
}
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
   //Alert(symbol, " - ", TimeframeToString(timeframe), " - ", DoubleToStr(L_1, MarketInfo(symbol, MODE_DIGITS)), " - ", DoubleToStr(MarketInfo(symbol, MODE_ASK), MarketInfo(symbol, MODE_DIGITS)));
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
   //Alert(symbol, " - ", TimeframeToString(timeframe), " - ", DoubleToStr(L_1, MarketInfo(symbol, MODE_DIGITS)), " - ", DoubleToStr(MarketInfo(symbol, MODE_BID), MarketInfo(symbol, MODE_DIGITS)));
   return (L_1);
}

double gold_rsioma_down(string symbol, int timeframe, int shift)
{
   double L_1;
   L_1 = iCustom(symbol, timeframe, "RSIOMA_v3", 1, shift);
   //Alert(symbol, " - ", TimeframeToString(timeframe), " down2 - ", L_1);
   return (L_1);
}

double gold_rsioma_up(string symbol, int timeframe, int shift)
{
   double L_1;
   L_1 = iCustom(symbol, timeframe, "RSIOMA_v3", 2, shift);
   //Alert(symbol, " - ", TimeframeToString(timeframe), " up2 - ", L_1);
   return (L_1);
}


double gold_william_percent_range(string symbol, int timeframe, int shift)
{
   double L_1;
   L_1 = iCustom(symbol, timeframe, "WPR", 55, 0, shift);
   //Alert(symbol, " - ", TimeframeToString(timeframe), " Williams - ", L_1);
   return (L_1);
}