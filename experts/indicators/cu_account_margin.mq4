//+------------------------------------------------------------------+
//|                                            cu_account_margin.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

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
   double Lots;
   string infobox;
   double val3, val4;
   Lots = 0.05;
   val3 = AccountFreeMarginCheck(Symbol(), OP_BUY, Lots);
   val4 = AccountFreeMarginCheck(Symbol(), OP_SELL, Lots);
   infobox = infobox + "\n" + "Account Marging After Lots: " + Lots + " for buy is " + val3 + " and for sell is " + DoubleToStr(val4, Digits);
   Lots = 0.10;
   val3 = AccountFreeMarginCheck(Symbol(), OP_BUY, Lots);
   val4 = AccountFreeMarginCheck(Symbol(), OP_SELL, Lots);
   infobox = infobox + "\n" + "Account Marging After Lots: " + Lots + " for buy is " + DoubleToStr(val3, Digits) + " and for sell is " + DoubleToStr(val4, Digits);
   Lots = 0.15;
   val3 = AccountFreeMarginCheck(Symbol(), OP_BUY, Lots);
   val4 = AccountFreeMarginCheck(Symbol(), OP_SELL, Lots);
   infobox = infobox + "\n" + "Account Marging After Lots: " + Lots + " for buy is " + DoubleToStr(val3, Digits) + " and for sell is " + DoubleToStr(val4, Digits);
   Lots = 0.20;
   val3 = AccountFreeMarginCheck(Symbol(), OP_BUY, Lots);
   val4 = AccountFreeMarginCheck(Symbol(), OP_SELL, Lots);
   infobox = infobox + "\n" + "Account Marging After Lots: " + Lots + " for buy is " + DoubleToStr(val3, Digits) + " and for sell is " + DoubleToStr(val4, Digits);
   Lots = 0.25;
   val3 = AccountFreeMarginCheck(Symbol(), OP_BUY, Lots);
   val4 = AccountFreeMarginCheck(Symbol(), OP_SELL, Lots);
   infobox = infobox + "\n" + "Account Marging After Lots: " + Lots + " for buy is " + DoubleToStr(val3, Digits) + " and for sell is " + DoubleToStr(val4, Digits);
   Lots = 0.30;
   val3 = AccountFreeMarginCheck(Symbol(), OP_BUY, Lots);
   val4 = AccountFreeMarginCheck(Symbol(), OP_SELL, Lots);
   infobox = infobox + "\n" + "Account Marging After Lots: " + Lots + " for buy is " + DoubleToStr(val3, Digits) + " and for sell is " + DoubleToStr(val4, Digits);
   Lots = 0.35;
   val3 = AccountFreeMarginCheck(Symbol(), OP_BUY, Lots);
   val4 = AccountFreeMarginCheck(Symbol(), OP_SELL, Lots);
   infobox = infobox + "\n" + "Account Marging After Lots: " + Lots + " for buy is " + DoubleToStr(val3, Digits) + " and for sell is " + DoubleToStr(val4, Digits);
   Comment(infobox);
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+