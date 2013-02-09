//+------------------------------------------------------------------+
//|                                                   profitcalc.mq4 |
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


double max_profit;
double half_profit;
double running_profit = 0;

int profitcalc(double profit)
{
   int result = 0;
   if (profit < running_profit && running_profit > 0) {
      result = 1;
      running_profit = 0;
   }
   if (profit > half_profit) {
      running_profit = half_profit;
   }
   Print("order Profit: ", DoubleToStr(profit, Digits), ", half_profit: ", DoubleToStr(half_profit, Digits)
      , ", running profit: ", DoubleToStr(running_profit, Digits)
      , ", max_profit: ", DoubleToStr(max_profit, Digits));
   return (result);
}

void setinitialprofit(double orderlot)
{
   max_profit = orderlot * 100;
   half_profit = max_profit / 2;
}