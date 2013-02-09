//+------------------------------------------------------------------+
//|                                                    nw_master.mq4 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://www.mkgalaxy.com"

#include <stdlib.mqh>
#include <WinUser32.mqh>


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
int stoch[28][10][3];
int periods[9] = {PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4, PERIOD_D1, 
         PERIOD_W1, PERIOD_MN1};
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   start();
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
   infobox = "";
   string symbol;
   int i, j;
   for (i = start; i < end; i++) {
      symbol = aPair[i];
      infobox = infobox + "\nSymbol: " + symbol;
      for (j = 4; j < 7; j++) {
         getdirection(symbol, periods[j], i, j);
      }
      if (
         (stoch[i][4][0] == 1 || stoch[i][5][0] == 1 || stoch[i][6][0] == 1)
         &&
         stoch[i][4][1] == 1
         &&
         stoch[i][5][1] == 1
         &&
         stoch[i][6][1] == 1) {
            infobox = infobox + ", BUY";
         } else if (
         (stoch[i][4][0] == -1 || stoch[i][5][0] == -1 || stoch[i][6][0] == -1)
         &&
         stoch[i][4][2] == -1
         &&
         stoch[i][5][2] == -1
         &&
         stoch[i][6][2] == -1) {
            infobox = infobox + ", SELL";
         }  
   }
   /*
   infobox = infobox + "\nCLOSE CONDITION";
   
   for (i = start; i < end; i++) {
      symbol = aPair[i];
      do_close_orders(symbol);
   }
   infobox = infobox + "\nOPEN CONDITION";
   infobox = infobox + "\nSymbol: " + symbol;
   for (i = start; i < end; i++) {
      symbol = aPair[i];
      do_open_orders(symbol);
   }
   */
   Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+

int do_close_orders(string symbol)
{
   //infobox = infobox + "\nSymbol: " + symbol;
}

int do_open_orders(string symbol)
{
   //infobox = infobox + "\nSymbol: " + symbol;
}


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
      
      infobox = infobox + ", Time: " + TimeframeToString(period) + "," + stoch[index][mode][0] + "," + stoch[index][mode][1] + "," + stoch[index][mode][2];
}

