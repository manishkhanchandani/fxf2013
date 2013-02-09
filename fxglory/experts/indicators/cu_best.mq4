//+------------------------------------------------------------------+
//|                                                      cu_best.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#define ARRSIZE  28 // number of pairs !!!
#define PAIRSIZE 8 // number of currencies 

#define USDCHF 0
#define GBPUSD 1
#define EURUSD 2
#define USDJPY 3
#define USDCAD 4
#define AUDUSD 5
#define EURGBP 6
#define EURAUD 7
#define EURCHF 8
#define EURJPY 9
#define GBPCHF 10
#define CADJPY 11
#define GBPJPY 12
#define AUDNZD 13
#define AUDCAD 14
#define AUDCHF 15
#define AUDJPY 16
#define CHFJPY 17
#define EURNZD 18
#define EURCAD 19
#define CADCHF 20
#define NZDJPY 21
#define NZDUSD 22
#define GBPCAD 23
#define GBPNZD 24
#define GBPAUD 25
#define NZDCHF 26
#define NZDCAD 27

// Currency
#define USD 0
#define EUR 1
#define GBP 2
#define CHF 3                                                                                      
#define CAD 4                                                                                      
#define AUD 5                                                                                      
#define JPY 6                                                                                      
#define NZD 7  
string aPair[ARRSIZE]   = {
                        "USDCHF","GBPUSD","EURUSD","USDJPY","USDCAD","AUDUSD",
                        "EURGBP","EURAUD","EURCHF","EURJPY","GBPCHF","CADJPY",
                        "GBPJPY","AUDNZD","AUDCAD","AUDCHF","AUDJPY","CHFJPY",
                        "EURNZD","EURCAD","CADCHF","NZDJPY","NZDUSD","GBPCAD",
                        "GBPNZD","GBPAUD","NZDCHF","NZDCAD"
                        };
string aMajor[PAIRSIZE] = {"USD","EUR","GBP","CHF","CAD","AUD","JPY","NZD"};
              
string infobox;            
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
   int index;
   infobox = "\n\n";
   string symbol;
   double zero, one, two, three, four, five;
   string one2, two2, three2, four2, five2;
   double pt;
   double high, low;
   for (index = 0; index < ARRSIZE; index++) {
      RefreshRates();
      symbol = aPair[index];
      pt = MarketInfo(symbol, MODE_POINT);
      zero = iHigh(symbol, PERIOD_D1, 0) - iLow(symbol, PERIOD_D1, 0);
      
      if (iHigh(symbol, PERIOD_D1, 0) > iHigh(symbol, PERIOD_D1, 1)) high = iHigh(symbol, PERIOD_D1, 0); else high = iHigh(symbol, PERIOD_D1, 1);
      if (iLow(symbol, PERIOD_D1, 0) < iLow(symbol, PERIOD_D1, 1)) low = iLow(symbol, PERIOD_D1, 0); else low = iLow(symbol, PERIOD_D1, 1);
      one = iHigh(symbol, PERIOD_D1, 1) - iLow(symbol, PERIOD_D1, 1);
      one2 = DoubleToStr((one/pt), 0) + "/" + DoubleToStr((high - low)/pt, 0);
      
      if (iHigh(symbol, PERIOD_D1, 2) > high) high = iHigh(symbol, PERIOD_D1, 2);
      if (iLow(symbol, PERIOD_D1, 2) < low) low = iLow(symbol, PERIOD_D1, 2);
      two = iHigh(symbol, PERIOD_D1, 2) - iLow(symbol, PERIOD_D1, 2);
      two2 = DoubleToStr((two/pt), 0) + "/" + DoubleToStr((high - low)/pt, 0);
      
      if (iHigh(symbol, PERIOD_D1, 3) > high) high = iHigh(symbol, PERIOD_D1, 3);
      if (iLow(symbol, PERIOD_D1, 3) < low) low = iLow(symbol, PERIOD_D1, 3);
      three = iHigh(symbol, PERIOD_D1, 3) - iLow(symbol, PERIOD_D1, 3);
      three2 = DoubleToStr((three/pt), 0) + "/" + DoubleToStr((high - low)/pt, 0);
      
      if (iHigh(symbol, PERIOD_D1, 4) > high) high = iHigh(symbol, PERIOD_D1, 4);
      if (iLow(symbol, PERIOD_D1, 4) < low) low = iLow(symbol, PERIOD_D1, 4);
      four = iHigh(symbol, PERIOD_D1, 4) - iLow(symbol, PERIOD_D1, 4);
      four2 = DoubleToStr((four/pt), 0) + "/" + DoubleToStr((high - low)/pt, 0);
      
      if (iHigh(symbol, PERIOD_D1, 5) > high) high = iHigh(symbol, PERIOD_D1, 5);
      if (iLow(symbol, PERIOD_D1, 5) < low) low = iLow(symbol, PERIOD_D1, 5);
      five = iHigh(symbol, PERIOD_D1, 5) - iLow(symbol, PERIOD_D1, 5);
      five2 = DoubleToStr((five/pt), 0) + "/" + DoubleToStr((high - low)/pt, 0);
      infobox = infobox + symbol + ": Spread: " + DoubleToStr(MarketInfo(symbol, MODE_SPREAD), 0)
      + ", zero: " + DoubleToStr((zero / pt), 0)
      + ", one: " + one2
      + ", two: " + two2
      + ", three: " + three2
      + ", four: " + four2
      + ", five: " + five2
      + ", high: " + DoubleToStr(high, MarketInfo(symbol, MODE_DIGITS))
      + ", low: " + DoubleToStr(low, MarketInfo(symbol, MODE_DIGITS))
      + "\n";
   }
   Comment(infobox);
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+