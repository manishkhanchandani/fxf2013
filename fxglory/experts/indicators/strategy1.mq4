//+------------------------------------------------------------------+
//|                                                    strategy1.mq4 |
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
//----
   Comment("Entering the market for BUY - if all the following conditions: \n",
            "1) Exponential Moving Average EMA (5) and EMA (8) crossed up. \n",
            "2) Indicator Dinapoli stochastic just crossed paths up (blue line crossed the red bottom-up) \n",
            "3) Indicator MomentumVT (10) is above its zero level. \n",
            "4) Indicator QQE arrow drawn up (possibly even a few bars earlier). \n",
            "5) bar is painted in white. \n",
            "Indicators required http://strategy4forex.com/strategies-based-on-forex-indicators/simple-indicators-forex-strategy.html \n",
            "1) Indicator - Heikin ashi \n",
            "2) Exponential Moving Average - EMA (5), close - the color blue \n",
            "2) Exponential Moving Average - EMA (8), open - the color green \n",
            "3) Indicator - Dinapoli stoch (8,3,3) \n",
            "4) Indicator - MomentumVT (10) \n",
            "5) Indicator - QQE Alert v3."
            );
//----
   return(0);
  }
//+------------------------------------------------------------------+