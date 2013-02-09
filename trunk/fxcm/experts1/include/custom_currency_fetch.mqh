//+------------------------------------------------------------------+
//|                                        custom_currency_fetch.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"


extern bool current_currency_pair = false;
extern bool current_period = false;
extern int gmtoffset = 0;
int hour;
extern bool markethours = false;
extern bool reverse_bid_if_profit = true;
extern bool reverse_bid_force = false;
string build = "1.11";
extern bool USDCHF = false;
extern bool GBPUSD = true;
extern bool EURUSD = false;
extern bool USDJPY = true;
extern bool USDCAD = true;
extern bool AUDUSD = false;
extern bool EURGBP = true;
extern bool EURAUD = true;
extern bool EURCHF = false;
extern bool EURJPY = false;
extern bool GBPCHF = true;
extern bool CADJPY = true;
extern bool GBPJPY = true;
extern bool AUDNZD = true;
extern bool AUDCAD = true;
extern bool AUDCHF = true;
extern bool AUDJPY = true;
extern bool CHFJPY = true;
extern bool EURNZD = true;
extern bool EURCAD = true;
extern bool CADCHF = true;
extern bool NZDJPY = true;
extern bool NZDUSD = false;
extern bool GBPCAD = true;
extern bool GBPNZD = true;
extern bool GBPAUD = true;
extern bool NZDCHF = true;
extern bool NZDCAD = true;



extern bool custom_lots = false;
extern double lots_USDCHF = 0.03;
extern double lots_GBPUSD = 0.03;
extern double lots_EURUSD = 0.03;
extern double lots_USDJPY = 0.03;
extern double lots_USDCAD = 0.03;
extern double lots_AUDUSD = 0.03;
extern double lots_EURGBP = 0.03;
extern double lots_EURAUD = 0.03;
extern double lots_EURCHF = 0.03;
extern double lots_EURJPY = 0.03;
extern double lots_GBPCHF = 0.03;
extern double lots_CADJPY = 0.03;
extern double lots_GBPJPY = 0.03;
extern double lots_AUDNZD = 0.03;
extern double lots_AUDCAD = 0.03;
extern double lots_AUDCHF = 0.03;
extern double lots_AUDJPY = 0.03;
extern double lots_CHFJPY = 0.03;
extern double lots_EURNZD = 0.03;
extern double lots_EURCAD = 0.03;
extern double lots_CADCHF = 0.03;
extern double lots_NZDJPY = 0.03;
extern double lots_NZDUSD = 0.03;
extern double lots_GBPCAD = 0.03;
extern double lots_GBPNZD = 0.03;
extern double lots_GBPAUD = 0.03;
extern double lots_NZDCHF = 0.03;
extern double lots_NZDCAD = 0.03;


string currency_USDCHF;
string currency_GBPUSD;
string currency_EURUSD;
string currency_USDJPY;
string currency_USDCAD;
string currency_AUDUSD;
string currency_EURGBP;
string currency_EURAUD;
string currency_EURCHF;
string currency_EURJPY;
string currency_GBPCHF;
string currency_CADJPY;
string currency_GBPJPY;
string currency_AUDNZD;
string currency_AUDCAD;
string currency_AUDCHF;
string currency_AUDJPY;
string currency_CHFJPY;
string currency_EURNZD;
string currency_EURCAD;
string currency_CADCHF;
string currency_NZDJPY;
string currency_NZDUSD;
string currency_GBPCAD;
string currency_GBPNZD;
string currency_GBPAUD;
string currency_NZDCHF;
string currency_NZDCAD;


int number_USDCHF = 1;
int number_GBPUSD = 2;
int number_EURUSD = 3;
int number_USDJPY = 4;
int number_USDCAD = 5;
int number_AUDUSD = 6;
int number_EURGBP = 7;
int number_EURAUD = 8;
int number_EURCHF = 9;
int number_EURJPY = 10;
int number_GBPCHF = 11;
int number_CADJPY = 12;
int number_GBPJPY = 13;
int number_AUDNZD = 14;
int number_AUDCAD = 15;
int number_AUDCHF = 16;
int number_AUDJPY = 17;
int number_CHFJPY = 18;
int number_EURNZD = 19;
int number_EURCAD = 20;
int number_CADCHF = 21;
int number_NZDJPY = 22;
int number_NZDUSD = 23;
int number_GBPCAD = 24;
int number_GBPNZD = 25;
int number_GBPAUD = 26;
int number_NZDCHF = 27;
int number_NZDCAD = 28;

string infobox;
string importantbox;
string importantbox_exit;
string messages[30];
int opentime[30];
#include <custom_order_management.mqh>
void conversion()
{
   RefreshRates();
   if (current_currency_pair) {
      return;
   }

   if (USDCHF) {
      currency_USDCHF = "USDCHF";
   }

   if (GBPUSD) {
      currency_GBPUSD = "GBPUSD";
   }
   
   if (EURUSD) {
      currency_EURUSD = "EURUSD";
   }
   
   if (USDJPY) {
      currency_USDJPY = "USDJPY";
   }
   
   if (USDCAD) {
      currency_USDCAD = "USDCAD";
   }

   if (AUDUSD) {
      currency_AUDUSD = "AUDUSD";
   }
   
   if (EURGBP) {
      currency_EURGBP = "EURGBP";
   }
   
   if (EURAUD) {
      currency_EURAUD = "EURAUD";
   }
   
   if (EURCHF) {
      currency_EURCHF = "EURCHF";
   }
   
   if (EURJPY) {
      currency_EURJPY = "EURJPY";
   }
   
   if (GBPCHF) {
      currency_GBPCHF = "GBPCHF";
   }
   
   if (CADJPY) {
      currency_CADJPY = "CADJPY";
   }
   
   if (GBPJPY) {
      currency_GBPJPY = "GBPJPY";
   }
   
   if (AUDNZD) {
      currency_AUDNZD = "AUDNZD";
   }
   
   if (AUDCAD) {
      currency_AUDCAD = "AUDCAD";
   }
   
   if (AUDCHF) {
      currency_AUDCHF = "AUDCHF";
   }
   
   if (AUDJPY) {
      currency_AUDJPY = "AUDJPY";
   }
   
   if (CHFJPY) {
      currency_CHFJPY = "CHFJPY";
   }
   
   if (EURNZD) {
      currency_EURNZD = "EURNZD";
   }
   
   if (EURCAD) {
      currency_EURCAD = "EURCAD";
   }
   
   if (CADCHF) {
      currency_CADCHF = "CADCHF";
   }
   
   if (NZDJPY) {
      currency_NZDJPY = "NZDJPY";
   }
   
   if (NZDUSD) {
      currency_NZDUSD = "NZDUSD";
   }
   
   if (GBPCAD) {
      currency_GBPCAD = "GBPCAD";
   }
   
   if (GBPNZD) {
      currency_GBPNZD = "GBPNZD";
   }
   
   if (GBPAUD) {
      currency_GBPAUD = "GBPAUD";
   }
   
   if (NZDCHF) {
      currency_NZDCHF = "NZDCHF";
   }
   if (NZDCAD) {
      currency_NZDCAD = "NZDCAD";
   }
}
void check_for_open()
{
   if (current_currency_pair == true) {
      infobox = StringConcatenate(infobox, "\n//-------------Taking Current Currency Pair-------------//\n");
      trade(Symbol(), 0);
   } else {
      if (currency_USDCHF == "USDCHF") {
         trade(currency_USDCHF, number_USDCHF);
      }
      if (currency_GBPUSD == "GBPUSD") {
         trade(currency_GBPUSD, number_GBPUSD);
      }
      if (currency_EURUSD == "EURUSD") {
         trade(currency_EURUSD, number_EURUSD);
      }
      if (currency_USDJPY == "USDJPY") {
         trade(currency_USDJPY, number_USDJPY);
      }
      if (currency_USDCAD == "USDCAD") {
         trade(currency_USDCAD, number_USDCAD);
      }
      if (currency_AUDUSD == "AUDUSD") {
         trade(currency_AUDUSD, number_AUDUSD);
      }
      if (currency_EURGBP == "EURGBP") {
         trade(currency_EURGBP, number_EURGBP);
      }
      if (currency_EURAUD == "EURAUD") {
         trade(currency_EURAUD, number_EURAUD);
      }
      if (currency_EURCHF == "EURCHF") {
         trade(currency_EURCHF, number_EURCHF);
      }
      if (currency_EURJPY == "EURJPY") {
         trade(currency_EURJPY, number_EURJPY);
      }
      if (currency_GBPCHF == "GBPCHF") {
         trade(currency_GBPCHF, number_GBPCHF);
      }
      if (currency_CADJPY == "CADJPY") {
         trade(currency_CADJPY, number_CADJPY);
      }
      if (currency_GBPJPY == "GBPJPY") {
         trade(currency_GBPJPY, number_GBPJPY);
      }
      if (currency_AUDNZD == "AUDNZD") {
         trade(currency_AUDNZD, number_AUDNZD);
      }
      if (currency_AUDCAD == "AUDCAD") {
         trade(currency_AUDCAD, number_AUDCAD);
      }
      if (currency_AUDCHF == "AUDCHF") {
         trade(currency_AUDCHF, number_AUDCHF);
      }
      if (currency_AUDJPY == "AUDJPY") {
         trade(currency_AUDJPY, number_AUDJPY);
      }
      if (currency_CHFJPY == "CHFJPY") {
         trade(currency_CHFJPY, number_CHFJPY);
      }
      if (currency_EURNZD == "EURNZD") {
         trade(currency_EURNZD, number_EURNZD);
      }
      if (currency_EURCAD == "EURCAD") {
         trade(currency_EURCAD, number_EURCAD);
      }
      if (currency_CADCHF == "CADCHF") {
         trade(currency_CADCHF, number_CADCHF);
      }
      if (currency_NZDJPY == "NZDJPY") {
         trade(currency_NZDJPY, number_NZDJPY);
      }
      if (currency_NZDUSD == "NZDUSD") {
         trade(currency_NZDUSD, number_NZDUSD);
      }
      if (currency_GBPCAD == "GBPCAD") {
         trade(currency_GBPCAD, number_GBPCAD);
      }
      if (currency_GBPNZD == "GBPNZD") {
         trade(currency_GBPNZD, number_GBPNZD);
      }
      if (currency_GBPAUD == "GBPAUD") {
         trade(currency_GBPAUD, number_GBPAUD);
      }
      if (currency_NZDCHF == "NZDCHF") {
         trade(currency_NZDCHF, number_NZDCHF);
      }
      if (currency_NZDCAD == "NZDCAD") {
         trade(currency_NZDCAD, number_NZDCAD);
      }
   }
   Comment(orderbox, importantbox, "\n\n", importantbox_exit, infobox);
}


void trade(string symbol, int number)
{
   infobox = StringConcatenate(infobox, "\n", symbol);
   strategy(symbol, number);
}


void custom_start()
{
   auth();
   infobox = "";
   orderbox = "";
   infobox = StringConcatenate(infobox, "\nTime: ", timestr(TimeCurrent()), "(",TimeDayOfWeek(TimeCurrent()),")");
   importantbox = "\nCURRENT POSITIONS\n";
   hour = Hour() - gmtoffset;
   infobox = StringConcatenate(infobox, "\nBuild: ", build);
   infobox = StringConcatenate(infobox, "\nDay: ", DayOfWeek(), ", Hour: ", hour, ", gmtoffset: ", gmtoffset, ", maxorders: ", maxorders, ", lots: ", Lots);
   trailing_stop(InitTrailingStop, TrailingStop);
   check_for_open();
}


int auth()
{
   return (1);
}

void custom_init()
{
   auth();
   conversion();
   //custom_start();
}


void FileAppend(string name,string txt)
{
   int handle = FileOpen(name,FILE_READ|FILE_WRITE);
	FileSeek(handle,0,SEEK_END);
	FileWrite(handle,txt);
	FileFlush(handle);
	FileClose(handle);
}