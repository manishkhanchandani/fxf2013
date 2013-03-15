//+------------------------------------------------------------------+
//|                                                    inference.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window

extern bool showAlert = true;
string infobox;
int past_ima = 0;
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
   Comment("");

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   infobox = "";
   int    counted_bars=IndicatorCounted();
   infobox = StringConcatenate(infobox, "\n");
   double ima1 = calculate_strategy_ema(Symbol(), 1, Period(), 0);
   double ima26 = calculate_strategy_ema(Symbol(), 26, Period(), 0);
   double ima100 = calculate_strategy_ema(Symbol(), 100, Period(), 0);
   string ima = "iMA: Consolidated\n";
   if (ima1 < ima100 && ima26 < ima100) {
      ima = "iMA: Sell Trend\n";
      if (showAlert && past_ima != -1) {
         Alert(Symbol(), ", ", ima);
      }
      past_ima = -1;
   } else if (ima1 > ima100 && ima26 > ima100) {
      ima = "iMA: Buy Trend\n";
      if (showAlert && past_ima != 1) {
         Alert(Symbol(), ", ", ima);
      }
      past_ima = 1;
   } else {
      past_ima = 0;
   }
   infobox = StringConcatenate(infobox, "\n");
   infobox = StringConcatenate(infobox, ima);
   Comment(infobox);

//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+


double calculate_strategy_ema(string symbol, int MA_Length, int Period_of_Time, int shift)
{
   double ema = iMA(symbol,Period_of_Time,MA_Length,0,MODE_EMA,PRICE_CLOSE,shift);
   return (ema);
}