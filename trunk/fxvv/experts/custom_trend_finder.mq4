//+------------------------------------------------------------------+
//|                                          custom_trend_finder.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"


//--- input parameters
extern int InpPeriod1=20;  // Period1
extern int InpPeriod2=100; // Period2

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
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
   int max=MathMax(InpPeriod1,InpPeriod2);
   Comment(max);
//----
   return(0);
  }
//+------------------------------------------------------------------+