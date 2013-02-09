//+------------------------------------------------------------------+
//|                                                       m_vars.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#define MAGICMA  197401

string copyrightst = "By Manish Khanchandani\n\n";
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

string custom_order_message = "";
string demo;
string infobox;
string inference = "Inference: ";
int trend_all;
   double current_1, current_26, current_100, current_25, current_50;
   double past_1, past_26, past_100, past_50, past_25;
   int cur_period, pa_period;