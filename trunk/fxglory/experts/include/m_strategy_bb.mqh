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

string build = "BB1";
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
}


int check_entry_point(string symbol, int Period_to_Call, int trend)
{
   int num = number;
   int result = 0;
   double L_1 = iCustom(symbol, Period_to_Call, "Squeeze_Break", 0, num);
   double L_2 = iCustom(symbol, Period_to_Call, "Squeeze_Break", 1, num);
   double L_3 = iCustom(symbol, Period_to_Call, "Squeeze_Break", 2, num);
      if (L_1 < (1*MarketInfo(symbol, MODE_POINT))) {
         if (L_3 < 0 && iOpen(symbol, Period_to_Call, num) > iClose(symbol, Period_to_Call, num)) { // && Low[i] <= iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_LOWER,i)
            //sell
            inference = StringConcatenate(inference, symbol, ": Sell => ", TimeframeToString(Period_to_Call), "\n");
            if (show_alerts) Alert(symbol, ": Sell => ", TimeframeToString(Period_to_Call));
         } else if (L_3 > 0 && iOpen(symbol, Period_to_Call, num) < iClose(symbol, Period_to_Call, num)) { // && High[i] >= iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_UPPER,i)
            //buy
            inference = StringConcatenate(inference, symbol, ": Buy => ", TimeframeToString(Period_to_Call), "\n");
            if (show_alerts) Alert(symbol, ": Buy => ", TimeframeToString(Period_to_Call));
         }
      }   
   return (result);
}