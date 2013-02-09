//+------------------------------------------------------------------+
//|                                                   cu_history.mq4 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"


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
double gtotal[ARRSIZE];
string infobox;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   custom_start();
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
   custom_start();
//----
   return(0);
  }
//+------------------------------------------------------------------+

int custom_start()
{
   string mySymbol;
   double total;
   infobox = "";
   double grandtotal;
   for (int index = 0; index < ARRSIZE; index++) {
      mySymbol = aPair[index];
      total = history(mySymbol, index);
      grandtotal += total;
      infobox = infobox + "\n" + mySymbol + ": " + total + ", Spread: " + MarketInfo(mySymbol, MODE_SPREAD);
   }
   infobox = infobox + "\nGrand Total: " + grandtotal;
   Comment(infobox);
}


double history(string symbol, int index)
{
   int cnt;
   int total = OrdersHistoryTotal();
   gtotal[index] = 0;
   for(cnt=0;cnt<total;cnt++)
   {
      OrderSelect(cnt, SELECT_BY_POS, MODE_HISTORY);
      if (OrderSymbol() == symbol    
      ) {
         gtotal[index] += OrderProfit();
      }
   }
   return (gtotal[index]);
}

