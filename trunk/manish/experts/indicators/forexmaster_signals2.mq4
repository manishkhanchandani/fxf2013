//+------------------------------------------------------------------+
//|                                         forexmaster_signals2.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

#property indicator_chart_window
extern string symbol_suffix = "";


#define ARRSIZE  28
#define TABSIZE  10
#define PAIRSIZE 8

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
double aMeter[PAIRSIZE];
int opentime;


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
      if (opentime != iTime(Symbol(), Period(), 0)) {
         int    counted_bars=IndicatorCounted();
         string box = getallinfo();
         string htmlCurrencyChart = getsignals();
         string info = "<b>Current Time:</b> " + TimeToStr(TimeCurrent()) + ", <b>Forex Company:</b> " + AccountCompany() 
            + "<table width='100%' border='1' cellspacing='0' cellpadding='5'><tr><td valign='top'>" 
            + box 
            + "</td>"
            + "<td valign='top'>" + htmlCurrencyChart + "</td>"
            + "</tr></table>";
         string filename = "signals/signals2.txt";
         FileDelete(filename);
         FileAppend(filename, info);
         Comment(info);
         Alert("Done");
         opentime = iTime(Symbol(), Period(), 0);
      }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+


string getallinfo()
{
   string mySymbol;
   double high, low, bid, ask, point, spread, digits;
      double aHigh[ARRSIZE];
      double aLow[ARRSIZE];
      double aHigh1[ARRSIZE];
      double aBid[ARRSIZE];
      double aAsk[ARRSIZE];
      double aRatio[ARRSIZE];
      double aRange[ARRSIZE];
      double aLookup[ARRSIZE];
      double aStrength[ARRSIZE];
      int z;
         int index;
         //infobox = infobox + "\n\n";
         for (index=0; index<28; index++) {
            
         RefreshRates();
         mySymbol = aPair[index]+symbol_suffix;
         //infobox = infobox + "\n" + mySymbol;
         bid = MarketInfo(mySymbol, MODE_BID);
         ask = MarketInfo(mySymbol, MODE_ASK);
         point = MarketInfo(mySymbol, MODE_POINT);
         spread = MarketInfo(mySymbol, MODE_SPREAD);
         digits = MarketInfo(mySymbol, MODE_DIGITS);
         //Calculating the points:
         high = -1;
         low = -1;
         for (z=0; z<4; z++) {
            if (high == -1) {
               high = iHigh(mySymbol, PERIOD_H4, z);
            }
            if (iHigh(mySymbol, PERIOD_H4, z) > high) {
               high = iHigh(mySymbol, PERIOD_H4, z);
            }
            if (low == -1) {
               low = iLow(mySymbol, PERIOD_H4, z);
            }
            if (iLow(mySymbol, PERIOD_H4, z) < low) {
               low = iLow(mySymbol, PERIOD_H4, z);
            }
         }
         aHigh[index] = high;
         aLow[index]      = low; 
         aBid[index]      = bid;                 
         aAsk[index]      = ask;                 
         aRange[index]    = MathMax((aHigh[index]-aLow[index])/point,1);      // calculate range today  
         aRatio[index]    = (aBid[index]-aLow[index])/aRange[index]/point;     // calculate pair ratio
         aLookup[index]   = iLookup(aRatio[index]*100);                        // set a pair grade
         aStrength[index] = 9-aLookup[index];
         aBid[index]      = MarketInfo(mySymbol,MODE_BID);                 
         aAsk[index]      = MarketInfo(mySymbol,MODE_ASK);                 
         aRange[index]    = MathMax((aHigh[index]-aLow[index])/point,1);      // calculate range today  
         aRatio[index]    = (aBid[index]-aLow[index])/aRange[index]/point;     // calculate pair ratio
         aLookup[index]   = iLookup(aRatio[index]*100);                        // set a pair grade
         aStrength[index] = 9-aLookup[index];                                  // set a pair strengh
         }
         aMeter[USD] = NormalizeDouble((aLookup[USDJPY]+aLookup[USDCHF]+aLookup[USDCAD]+aStrength[EURUSD]+aStrength[GBPUSD]+aStrength[AUDUSD]+aStrength[NZDUSD])/7,1);
   aMeter[EUR] = NormalizeDouble((aLookup[EURUSD]+aLookup[EURJPY]+aLookup[EURGBP]+aLookup[EURCHF]+aLookup[EURAUD]+aLookup[EURCAD]+aLookup[EURNZD])/7,1);
   aMeter[GBP] = NormalizeDouble((aLookup[GBPUSD]+aLookup[GBPJPY]+aLookup[GBPCHF]+aStrength[EURGBP]+aLookup[GBPCAD]+aLookup[GBPAUD]+aLookup[GBPNZD])/7,1);
   aMeter[CHF] = NormalizeDouble((aStrength[USDCHF]+aStrength[EURCHF]+aStrength[GBPCHF]+aStrength[AUDCHF]+aLookup[CHFJPY]+aStrength[CADCHF]+aStrength[NZDCHF])/7,1);
   aMeter[CAD] = NormalizeDouble((aStrength[USDCAD]+aLookup[CADCHF]+aStrength[AUDCAD]+aLookup[CADJPY]+aStrength[EURCAD]+aStrength[GBPCAD]+aStrength[NZDCAD])/7,1);
   aMeter[AUD] = NormalizeDouble((aLookup[AUDUSD]+aStrength[EURAUD]+aLookup[AUDCHF]+aLookup[AUDCAD]+aStrength[GBPAUD]+aLookup[AUDNZD]+aLookup[AUDJPY])/7,1);
   aMeter[JPY] = NormalizeDouble((aStrength[USDJPY]+aStrength[EURJPY]+aStrength[GBPJPY]+aStrength[NZDJPY]+aStrength[AUDJPY]+aStrength[CHFJPY]+aStrength[CADJPY])/7,1);     
   aMeter[NZD] = NormalizeDouble((aLookup[NZDUSD]+aStrength[EURNZD]+aStrength[GBPNZD]+aStrength[AUDNZD]+aLookup[NZDCAD]+aLookup[NZDCHF]+aLookup[NZDJPY])/7,1);
   string strength = "\n<b>Currency Strength Meter:</b> \n\nUSD: " + DoubleToStr(aMeter[USD], 1) 
           + "\nEUR: " + DoubleToStr(aMeter[EUR], 1)  + "\nGBP: " + DoubleToStr(aMeter[GBP], 1) 
         + "\nCHF: " + DoubleToStr(aMeter[CHF], 1)  + "\nCAD: " + DoubleToStr(aMeter[CAD] , 1) 
         + "\nAUD: " + DoubleToStr(aMeter[AUD], 1) 
          + "\nJPY: " + DoubleToStr(aMeter[JPY], 1)  + "\nNZD: " + DoubleToStr(aMeter[NZD], 1) ;
   return (strength);
}


string parse(int type)
{
   if (type == 1) return ("(B)");
   else if (type == -1) return ("(S)");
   return ("");
}



int iLookup(double ratio)                                                   // this function will return a grade value
  {                                                                         // based on its power.
   int    aTable[TABSIZE]  = {0,3,10,25,40,50,60,75,90,97};                 // grade table for currency's power
   int   index;
   
   if      (ratio <= aTable[0]) index = 0;
   else if (ratio < aTable[1])  index = 0;
   else if (ratio < aTable[2])  index = 1;
   else if (ratio < aTable[3])  index = 2;
   else if (ratio < aTable[4])  index = 3;
   else if (ratio < aTable[5])  index = 4;
   else if (ratio < aTable[6])  index = 5;
   else if (ratio < aTable[7])  index = 6;
   else if (ratio < aTable[8])  index = 7;
   else if (ratio < aTable[9])  index = 8;
   else                         index = 9;
   return(index);                                                           // end of iLookup function
  }

void FileAppend(string name,string txt)
{
   int handle = FileOpen(name, FILE_READ|FILE_WRITE);
	FileSeek(handle,0,SEEK_END);
	FileWrite(handle,txt);
	FileFlush(handle);
	FileClose(handle);
}

string getsignals()
{
   string htmlCurrencyChart;
   string symbol;
   int periods[3] = {PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1};
   htmlCurrencyChart = "<p>Fpips Since last Signal, (in bracket is signal for buy or sell).</p>";
   int xo = 0;
   string textColor = "";
   int currentpips = 0;
   for (int i=0; i<ARRSIZE; i++) {
      RefreshRates();
      symbol = aPair[i]+symbol_suffix;
      if (i != EURJPY) continue;
      string current_currency1 = StringSubstr(symbol, 0, 3);
      string current_currency2 = StringSubstr(symbol, 3, 3);
      double pt = MarketInfo(symbol, MODE_POINT);
      int digit = MarketInfo(symbol, MODE_DIGITS);
      int spread = MarketInfo(symbol, MODE_SPREAD);
      xo++;
      for (int s = 1; s <= 10; s++) {
         for (int k = 0; k < 5; k++) {
            int period = periods[k];
            currentpips = 0;
            for (int shift = 1; shift < 1000; shift++) {
               int val2 = iCustom(symbol, period, "cuSpan", s, 2, shift);
               int val3 = iCustom(symbol, period, "cuSpan", s, 3, shift);
               int val4 = iCustom(symbol, period, "cuSpan", s, 4, shift);
               if (val2 != EMPTY_VALUE) {
                  //htmlCurrencyChart = htmlCurrencyChart + "<br>Strategy: " + s + ", Symbol: " + symbol + ", Period: " + period 
                  //+ ", Type: " + val2 + ", Last Pips: " + val3 + ", Total Pips: " + val4;
                  htmlCurrencyChart = htmlCurrencyChart + "<br>Strategy: " + s + ", " + symbol + ", " + period 
                  + ", " + val2 + ", " + val3 + ", " + val4;
                  break;
               }
            }
         }
      }
   }
   return (htmlCurrencyChart);
}