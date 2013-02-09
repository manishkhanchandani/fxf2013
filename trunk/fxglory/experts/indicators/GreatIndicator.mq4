//+------------------------------------------------------------------+
//|                                               GreatIndicator.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window


#include <stdlib.mqh>

#import "wininet.dll"

#define INTERNET_OPEN_TYPE_DIRECT       0
#define INTERNET_OPEN_TYPE_PRECONFIG    1
#define INTERNET_OPEN_TYPE_PROXY        3

// Had to cut the following two defines because of silly MQL4 identifier limits

#define _IGNORE_REDIRECT_TO_HTTP        0x00008000
#define _IGNORE_REDIRECT_TO_HTTPS       0x00004000

#define INTERNET_FLAG_KEEP_CONNECTION   0x00400000
#define INTERNET_FLAG_NO_AUTO_REDIRECT  0x00200000
#define INTERNET_FLAG_NO_COOKIES        0x00080000
#define INTERNET_FLAG_RELOAD            0x80000000
#define INTERNET_FLAG_NO_CACHE_WRITE    0x04000000
#define INTERNET_FLAG_DONT_CACHE        0x04000000
#define INTERNET_FLAG_PRAGMA_NOCACHE    0x00000100
#define INTERNET_FLAG_NO_UI             0x00000200

#define HTTP_ADDREQ_FLAG_ADD            0x20000000
#define HTTP_ADDREQ_FLAG_REPLACE        0x80000000

#define INTERNET_SERVICE_HTTP           3
#define INTERNET_DEFAULT_HTTP_PORT      80

#define ICU_ESCAPE                      0x80000000
#define ICU_USERNAME                    0x40000000
#define ICU_NO_ENCODE                   0x20000000
#define ICU_DECODE                      0x10000000
#define ICU_NO_META                     0x08000000
#define ICU_ENCODE_PERCENT              0x00001000
#define ICU_ENCODE_SPACES_ONLY          0x04000000
#define ICU_BROWSER_MODE                0x02000000

#define AGENT                           "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; Q312461)"
#define BUFSIZ                          128

#define REQUEST_FILE                    "_req.txt"

////////////// PROTOTYPES

bool InternetCanonicalizeUrlA(string lpszUrl, string lpszBuffer, int& lpdwBufferLength[], int dwFlags);

int InternetOpenA(string sAgent, int lAccessType, string sProxyName="", string sProxyBypass="", int lFlags=0);

int InternetOpenUrlA(int hInternetSession, string sUrl, string sHeaders="", int lHeadersLength=0, int lFlags=0,
   int lContext=0);

int InternetReadFile(int hFile, string sBuffer, int lNumBytesToRead, int& lNumberOfBytesRead[]);

int InternetCloseHandle(int hInet);

int InternetConnectA(int handle, string host, int port, string user, string pass, int service, int flags, int context);

bool HttpSendRequestA(int handle, string headers, int headersLen, int& optional[], int optionalLen);

bool HttpAddRequestHeadersA(int handle, string headers, int headersLen, int modifiers);

int HttpOpenRequestA(int hConnect, string lpszVerb, string lpszObjectName, string lpszVersion,
 string lpszReferer, string& lplpszAcceptTypes[], int dwFlags, int dwContext);

#import
bool HttpGET(string strUrl, string& strWebPage)
{
  int hSession = InternetOpenA(AGENT, INTERNET_OPEN_TYPE_DIRECT, "0", "0", 0);

  int hReq = InternetOpenUrlA(hSession, strUrl, "0", 0,
        INTERNET_FLAG_NO_CACHE_WRITE |
        INTERNET_FLAG_PRAGMA_NOCACHE |
        INTERNET_FLAG_RELOAD, 0);

  if (hReq == 0) {
    return(false);
  }

  int     lReturn[]  = {1};
  string  sBuffer    = "";

  while (TRUE) {
    if (InternetReadFile(hReq, sBuffer, BUFSIZ, lReturn) <= 0 || lReturn[0] == 0) {
      break;
    }
    strWebPage = StringConcatenate(strWebPage, StringSubstr(sBuffer, 0, lReturn[0]));
  }

  InternetCloseHandle(hReq);
  InternetCloseHandle(hSession);

  return (true);
}

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
string infobox;
int start = 0;
int end = ARRSIZE;
  
   double val, val2, val3, val4;
int stoch[28][10][5];
int periods[9] = {PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4, PERIOD_D1, 
         PERIOD_W1, PERIOD_MN1};
int auth;
extern string username = "nkhanchandani";
extern string password = "1234";
int opentime;
string product = "greatindicator";
string initbox;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   auth();
   initbox = "\n";
   initbox = initbox + "Username: " + username + ", Account: " + AccountNumber() + ", Product: " + product;
   Comment(initbox);
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

int auth()
{
   
   string response;
   HttpGET("http://wc5.org/forex/api/access.php?username="+username+"&password="+password+"&account="+AccountNumber()+"&product="+product, response);

   if (response == "Success") {
      auth = 1;
   } else {
      auth = 0;
   }
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();

   infobox = "\n";
   if (opentime != Time[0]) {
      auth();
      opentime = Time[0];
   }
   auth = 1;
   if (auth == 0) {
      infobox = infobox + "Unauthorised Username or password or account number.\n" +
      "Go to http://forexmastery.org/ and make sure you have assigned proper account number.\n " +
      "Or email us at greatindicator@forexmastery.org";
      Comment(infobox);
      return (0);
   }

   double high, low;
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
   double ask, bid, digits, point, spread;
   string symbol;
   int i, j;
   int pointsystem;
   for (i = start; i < end; i++) {
      index = i;
      symbol = aPair[i];
      //infobox = infobox + "\nSymbol: " + symbol;
      for (j = 4; j < 7; j++) {
         //getdirection(symbol, periods[j], i, j);
         //pointsystem = get_point_system(symbol, periods[j], 0);
         //infobox = infobox + ", " + pointsystem;
      }
      bid = MarketInfo(symbol, MODE_BID);
      ask = MarketInfo(symbol, MODE_ASK);
      point = MarketInfo(symbol, MODE_POINT);
      spread = MarketInfo(symbol, MODE_SPREAD);
      digits = MarketInfo(symbol, MODE_DIGITS);
      //infobox = infobox + ", " + bid + "/" + ask
      //+ "/" + DoubleToStr(spread, 0); 
      /*power*/
      //Calculating the points:
         high = -1;
         low = -1;
         for (z=0; z<4; z++) {
            if (high == -1) {
               high = iHigh(symbol, PERIOD_H4, z);
            }
            if (iHigh(symbol, PERIOD_H4, z) > high) {
               high = iHigh(symbol, PERIOD_H4, z);
            }
            if (low == -1) {
               low = iLow(symbol, PERIOD_H4, z);
            }
            if (iLow(symbol, PERIOD_H4, z) < low) {
               low = iLow(symbol, PERIOD_H4, z);
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
      /*powerend1*/
      /*
      infobox = infobox + " (" + stoch[i][4][1]+","+stoch[i][5][1]+","+stoch[i][6][1]+"," + stoch[i][4][2]+","+stoch[i][5][2]+","+stoch[i][6][2] + ","+stoch[i][4][3]+","+stoch[i][5][3]+","+stoch[i][6][3]+") ";
         if (
         stoch[i][4][0] == 1 || stoch[i][5][0] == 1 || stoch[i][6][0] == 1) {
            infobox = infobox + ", CLOSE SELL ("+stoch[i][4][0]+","+stoch[i][5][0]+","+stoch[i][6][0]+")";
         } else if (
         stoch[i][4][0] == -1 || stoch[i][5][0] == -1 || stoch[i][6][0] == -1) {
            infobox = infobox + ", CLOSE BUY ("+stoch[i][4][0]+","+stoch[i][5][0]+","+stoch[i][6][0]+")";
         } 
         
      if (
         (stoch[i][4][0] == 1 || stoch[i][5][0] == 1 || stoch[i][6][0] == 1)
         &&
         stoch[i][4][1] == 1
         &&
         stoch[i][5][1] == 1
         &&
         stoch[i][6][1] == 1
         //&&
         //stoch[i][4][3] < 40
         ) {
            infobox = infobox + ", OPEN BUY ("+stoch[i][4][0]+","+stoch[i][5][0]+","+stoch[i][6][0]+")";
         } else if (
         (stoch[i][4][0] == -1 || stoch[i][5][0] == -1 || stoch[i][6][0] == -1)
         &&
         stoch[i][4][2] == -1
         &&
         stoch[i][5][2] == -1
         &&
         stoch[i][6][2] == -1
         //&&
         //stoch[i][4][3] > 60
         ) {
            infobox = infobox + ", OPEN SELL ("+stoch[i][4][0]+","+stoch[i][5][0]+","+stoch[i][6][0]+")";
         } */
   }
   aMeter[USD] = NormalizeDouble((aLookup[USDJPY]+aLookup[USDCHF]+aLookup[USDCAD]+aStrength[EURUSD]+aStrength[GBPUSD]+aStrength[AUDUSD]+aStrength[NZDUSD])/7,1);
   aMeter[EUR] = NormalizeDouble((aLookup[EURUSD]+aLookup[EURJPY]+aLookup[EURGBP]+aLookup[EURCHF]+aLookup[EURAUD]+aLookup[EURCAD]+aLookup[EURNZD])/7,1);
   aMeter[GBP] = NormalizeDouble((aLookup[GBPUSD]+aLookup[GBPJPY]+aLookup[GBPCHF]+aStrength[EURGBP]+aLookup[GBPCAD]+aLookup[GBPAUD]+aLookup[GBPNZD])/7,1);
   aMeter[CHF] = NormalizeDouble((aStrength[USDCHF]+aStrength[EURCHF]+aStrength[GBPCHF]+aStrength[AUDCHF]+aLookup[CHFJPY]+aStrength[CADCHF]+aStrength[NZDCHF])/7,1);
   aMeter[CAD] = NormalizeDouble((aStrength[USDCAD]+aLookup[CADCHF]+aStrength[AUDCAD]+aLookup[CADJPY]+aStrength[EURCAD]+aStrength[GBPCAD]+aStrength[NZDCAD])/7,1);
   aMeter[AUD] = NormalizeDouble((aLookup[AUDUSD]+aStrength[EURAUD]+aLookup[AUDCHF]+aLookup[AUDCAD]+aStrength[GBPAUD]+aLookup[AUDNZD]+aLookup[AUDJPY])/7,1);
   aMeter[JPY] = NormalizeDouble((aStrength[USDJPY]+aStrength[EURJPY]+aStrength[GBPJPY]+aStrength[NZDJPY]+aStrength[AUDJPY]+aStrength[CHFJPY]+aStrength[CADJPY])/7,1);     
   aMeter[NZD] = NormalizeDouble((aLookup[NZDUSD]+aStrength[EURNZD]+aStrength[GBPNZD]+aStrength[AUDNZD]+aLookup[NZDCAD]+aLookup[NZDCHF]+aLookup[NZDJPY])/7,1);
   string strength = "\n\nUSD: " + aMeter[USD] + ", EUR: " + aMeter[EUR] + ", GBP: " + aMeter[GBP]
         + ", CHF: " + aMeter[CHF] + "\nCAD: " + aMeter[CAD] + ", AUD: " + aMeter[AUD]
          + ", JPY: " + aMeter[JPY] + ", NZD: " + aMeter[NZD];
   string topcur[8];
   string bottomcur[8];
   string curbox;
   curbox = curbox + "\n\nTop: ";
   int x, y;
   x = 0;
   y = 0;
   double top = 5.9;
   double bottom = 3.1;
   for (index = 0; index < 8; index++) {
      if (aMeter[index] > top) { 
         curbox = curbox + aMajor[index] + ", ";
         x++;
         topcur[x] = aMajor[index];
      }
   }
   curbox = curbox + " Bottom: ";
   for (index = 0; index < 8; index++) {
      if (aMeter[index] < bottom) { 
         curbox = curbox + aMajor[index] + ", ";
         y++;
         bottomcur[y] = aMajor[index];
         
      }
   }
   int k;
   j = 0;
   int l, m;
   l = 0;
   m = 0;
   string current_currency1, current_currency2;
   curbox = curbox + ", Analysis: " + x + ", " + y;
   string buyitems[28];
   string sellitems[28];
   int check;
   string curboxbuy = "\nUP: ";
   string curboxsell = "\nDown: ";
   for (j=1;j<=x;j++) {
      //infobox = infobox + "\nTop" + topcur[j];
      for (k=1;k<=y;k++) {
         //infobox = infobox + "\nBottom" + bottomcur[k];
         for (index = 0; index < ARRSIZE; index++) {
            RefreshRates();
            symbol = aPair[index];
            current_currency1 = StringSubstr(symbol, 0, 3);
            current_currency2 = StringSubstr(symbol, 3, 3);
            if (current_currency1 == topcur[j] && current_currency2 == bottomcur[k]) {
               curboxbuy = curboxbuy + symbol + ", ";
               infobox = infobox + "\nSymbol: " + symbol;
               for (x = 4; x < 7; x++) {
                  pointsystem = get_point_system(symbol, periods[x], 0);
                  infobox = infobox + ", " + TimeframeToString(periods[x]) + ": " + pointsystem;
               }
               infobox = infobox + ", " + bid + "/" + ask
               + "/" + DoubleToStr(spread, 0); 
            } else if (current_currency1 == bottomcur[k] && current_currency2 == topcur[j]) {
               curboxsell = curboxsell + symbol + ", ";
               
               infobox = infobox + "\nSymbol: " + symbol;
               for (x = 4; x < 7; x++) {
                  pointsystem = get_point_system(symbol, periods[x], 0);
                  infobox = infobox + ", " + TimeframeToString(periods[x]) + ": " + pointsystem;
               }
               infobox = infobox + ", " + bid + "/" + ask
               + "/" + DoubleToStr(spread, 0); 
            }
         }
      }
   }
   Comment(initbox, infobox, strength, curbox, curboxbuy, curboxsell);
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+


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
      case 0: return ("Any");
   }
}

int getdirection(string symbol, int period, int index, int mode)
{
      val = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_MAIN,0);
      val2 = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_SIGNAL,0);
      val3 = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_MAIN,1);
      val4 = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_SIGNAL,1);
      stoch[index][mode][0] = 0;
      stoch[index][mode][1] = 0;
      stoch[index][mode][2] = 0;
      stoch[index][mode][3] = val;
      stoch[index][mode][4] = val2;
      if (val > val2) {
         //infobox = infobox + ": C1";
         stoch[index][mode][1] = 1;
         if (val > 20 && val3 < 20) {
            //infobox = infobox + ", B1";
            stoch[index][mode][0] = 1;
         }
      } else if (val < val2) {
         //infobox = infobox + ", C0";
         stoch[index][mode][2] = -1;
         if (val < 80 && val3 > 80) {
            //infobox = infobox + ", B0";
            stoch[index][mode][0] = -1;
         }
      }
      
      infobox = infobox + "," + mode + ":" + stoch[index][mode][0] + stoch[index][mode][1] + stoch[index][mode][2]
      + "(" + stoch[index][mode][3] + "/" + stoch[index][mode][4]+")";
}


int iLookup(double ratio)                                                   // this function will return a grade value
  {                                                                         // based on its power.
   int    aTable[10]  = {0,3,10,25,40,50,60,75,90,97};                 // grade table for currency's power
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
  
  
double get_point_system(string symbol, int period, int mode)
{
   double points = 0;
   double pointsP = 0;
   double pointsM = 0;
   double totalpoints = 0;
   double increment = 1;
   double high = -1;
      double low = -1;
      double bid = MarketInfo(symbol, MODE_BID);
      double ask = MarketInfo(symbol, MODE_ASK);
      double pt = MarketInfo(symbol, MODE_POINT);
      double val, val2, val3, val4, val5, val6;
      string tmp;
      double h1,h2,h3,h4;
      int z;
      int number = get_number(period);
      for (z=mode; z<number; z++) {
         if (high == -1) {
            high = iHigh(symbol, period, z);
         }
         if (iHigh(symbol, period, z) > high) {
            high = iHigh(symbol, period, z);
         }
         if (low == -1) {
            low = iLow(symbol, period, z);
         }
         if (iLow(symbol, period, z) < low) {
            low = iLow(symbol, period, z);
         }
      }
      double aRange    = MathMax((high-low)/pt,1); 
      double aRatio    = (bid-low)/aRange/pt;
      double aLookup   = iLookup(aRatio*100); 
      double aStrength = 9-aLookup;
      totalpoints = totalpoints + increment;
      if (aLookup > aStrength) {
         points = points + increment;
         pointsP = pointsP + (increment * 1);
      } else if (aLookup < aStrength) {
         points = points - increment;
         pointsM = pointsM - (increment * 1);
      }
      //heiken
         h1 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,mode);
         h2 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,mode);
         h3 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,mode+1);
         h4 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,mode+1);
         totalpoints = totalpoints + increment;
         if (h1 < h2) {
            points = points + increment;
            pointsP = pointsP + (increment * 2);
         } else if (h1 > h2) {
            points = points - increment;
            pointsM = pointsM - (increment * 2);
         }
         
         val = iRSI(symbol, period,7,PRICE_CLOSE,mode);
         val2 = iRSI(symbol, period,7,PRICE_CLOSE,mode+1);
         totalpoints = totalpoints + increment;
         if (val > 70) {
            points = points + increment;
            pointsP = pointsP + (increment * 3);
         } else if (val < 30) {
            points = points - increment;
         pointsM = pointsM - (increment * 3);
         } 
         
         //macd
         val2 = iCustom(symbol, period, "MACD_Complete",1,mode);
         val3 = iCustom(symbol, period, "MACD_Complete",2,mode);
         val4 = iCustom(symbol, period, "MACD_Complete",1,mode+1);
         val5 = iCustom(symbol, period, "MACD_Complete",2,mode+1);
         totalpoints = totalpoints + increment;
         if (val2 > val3) {
            points = points + increment;
            pointsP = pointsP + (increment * 4);
         } else if (val2 < val3) {
            points = points - increment;
         pointsM = pointsM - (increment * 4);
         } 
         
         //ema
         val = iMA(symbol,period,17,0,MODE_EMA,PRICE_CLOSE,mode);
         val2 = iMA(symbol,period,43,0,MODE_EMA,PRICE_CLOSE,mode);
         totalpoints = totalpoints + increment;
         if (val > val2) {
            points = points + increment;
            pointsP = pointsP + (increment * 5);
         } else if (val < val2) {
            points = points - increment;
         pointsM = pointsM - (increment * 5);
         }
         
         //iStochastic
         val = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_MAIN,mode);
         val2 = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_SIGNAL,mode);
         totalpoints = totalpoints + increment;
         if (val > val2) {
            points = points + increment;
            pointsP = pointsP + (increment * 6);
         } else if (val < val2) {
            points = points - increment;
         pointsM = pointsM - (increment * 6);
         }
         //parabolic
         val = iSAR(symbol,period,0.02,0.2,mode);
         totalpoints = totalpoints + increment;
         if (val < iOpen(symbol, period, mode)) {
            points = points + increment;
            pointsP = pointsP + (increment * 7);
         } else if (val > iOpen(symbol, period, mode)) {
            points = points - increment;
         pointsM = pointsM - (increment * 7);
         }
         
         //ichimoku      
         val=iIchimoku(symbol,period, 9, 26, 52, MODE_TENKANSEN, mode);
         val2=iIchimoku(symbol,period, 9, 26, 52, MODE_KIJUNSEN, mode);
         totalpoints = totalpoints + increment;
         if (val > val2) {
            points = points + increment;
            pointsP = pointsP + (increment * 8);
         } else if (val < val2) {
            points = points - increment;
         pointsM = pointsM - (increment * 8);
         } 
         
         //adx
         val = iADX(symbol,period,14,PRICE_CLOSE,MODE_MAIN,mode);
         val2 = iADX(symbol,period,14,PRICE_CLOSE,MODE_PLUSDI,mode);
         val3 = iADX(symbol,period,14,PRICE_CLOSE,MODE_MINUSDI,mode);
         totalpoints = totalpoints + increment;
         if (val > 20 && val2 > val3) {
            points = points + increment;
            pointsP = pointsP + (increment * 9);
         } else if (val > 20 && val2 < val3) {
            points = points - increment;
         pointsM = pointsM - (increment * 9);
         }
    return (points);
}



int get_number(int P)
{
   switch(P)
   {
      case PERIOD_M1:  return(101);
      case PERIOD_M5:  return(76);
      case PERIOD_M15: return(51);
      case PERIOD_M30: return(25);
      case PERIOD_H1:  return(13);
      case PERIOD_H4:  return(4);
      case PERIOD_D1:  return(4);
      case PERIOD_W1:  return(4);
      case PERIOD_MN1: return(4);
      case 0: return (4);
   }
}

  