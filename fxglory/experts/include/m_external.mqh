//+------------------------------------------------------------------+
//|                                                   m_external.mq4 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
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


extern bool current_currency_pair = false;
extern bool current_period = false;
extern bool createorders = false;
extern bool show_alerts = false;
extern double lots = 0.10;
extern double lots_step = 0.01;
extern double lots_max = 0.10;
extern int maxorders = 0;
extern bool time_one_min = true;
extern bool time_five_min = true;
extern bool time_fifteen_min = false;
extern bool time_half_hour = false;
extern bool time_one_hour = false;
extern bool time_four_hour = false;
extern bool time_one_day = false;
extern bool time_one_week = false;
extern bool time_one_month = false;

extern bool USDCHF = true;
extern bool GBPUSD = false;
extern bool EURUSD = true;
extern bool USDJPY = false;
extern bool USDCAD = true;
extern bool AUDUSD = true;
extern bool EURGBP = false;
extern bool EURAUD = false;
extern bool EURCHF = false;
extern bool EURJPY = true;
extern bool GBPCHF = false;
extern bool CADJPY = false;
extern bool GBPJPY = true;
extern bool AUDNZD = true;
extern bool AUDCAD = false;
extern bool AUDCHF = false;
extern bool AUDJPY = false;
extern bool CHFJPY = false;
extern bool EURNZD = true;
extern bool EURCAD = true;
extern bool CADCHF = false;
extern bool NZDJPY = false;
extern bool NZDUSD = true;
extern bool GBPCAD = true;
extern bool GBPNZD = true;
extern bool GBPAUD = true;
extern bool NZDCHF = true;
extern bool NZDCAD = true;


extern bool custom_lots = false;
extern double lots_USDCHF = 0.01;
extern double lots_GBPUSD = 0.01;
extern double lots_EURUSD = 0.01;
extern double lots_USDJPY = 0.01;
extern double lots_USDCAD = 0.01;
extern double lots_AUDUSD = 0.01;
extern double lots_EURGBP = 0.01;
extern double lots_EURAUD = 0.01;
extern double lots_EURCHF = 0.01;
extern double lots_EURJPY = 0.01;
extern double lots_GBPCHF = 0.01;
extern double lots_CADJPY = 0.01;
extern double lots_GBPJPY = 0.01;
extern double lots_AUDNZD = 0.01;
extern double lots_AUDCAD = 0.01;
extern double lots_AUDCHF = 0.01;
extern double lots_AUDJPY = 0.01;
extern double lots_CHFJPY = 0.01;
extern double lots_EURNZD = 0.01;
extern double lots_EURCAD = 0.01;
extern double lots_CADCHF = 0.01;
extern double lots_NZDJPY = 0.01;
extern double lots_NZDUSD = 0.01;
extern double lots_GBPCAD = 0.01;
extern double lots_GBPNZD = 0.01;
extern double lots_GBPAUD = 0.01;
extern double lots_NZDCHF = 0.01;
extern double lots_NZDCAD = 0.01;

extern int custom_tp = 50;
extern int custom_sl = 1000;

extern int number = 1;