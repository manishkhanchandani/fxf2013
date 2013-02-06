//+------------------------------------------------------------------+
//|                                                       pack_1.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <3_signal_inc.mqh>
extern double lotsize = 0.10;

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
   infobox = "";
   render_avg_costing(Symbol(), 0, lotsize, false, false);
   int macd = macdRCurrent(Symbol(), Period());
   int heiken = heikenCurrent(Symbol(), Period());
   int macdchange = macdR(Symbol(), Period());
   int heikenchange = heiken(Symbol(), Period());
   double stoch = iStochastic(Symbol(), Period(),14,3,3,MODE_SMA,0,MODE_MAIN,1);
   string message = "s1 " + Period();
   if (heikenchange == 1 || heikenchange == -1) {
      message = message + " H";
   } else if (macdchange == 1 || macdchange == -1) {
      message = message + " M";
   }
   //double tenkan_sen_1=iIchimoku(Symbol(), Period(), 9, 26, 52, MODE_TENKANSEN, 0);
   
   //close condition
   if (heiken == 1 && macd == 1) {
      //create buy
      CheckForCloseALL(Symbol(), 0, 1);
      CheckForCloseWithoutProfit(Symbol(), Period(), magic, 1);
   } else if (heiken == -1 && macd == -1) {
      //create sell
      CheckForCloseALL(Symbol(), 0, -1);
      CheckForCloseWithoutProfit(Symbol(), Period(), magic, -1);
   }
   //open condition
   if ((heikenchange == 1 && macd == 1) || (heiken == 1 && macdchange == 1)) {
      if (createneworders) createorder(Symbol(), 1, lotsize, magic, message, 0, 0);
   } else if ((heikenchange == -1 && macd == -1) || (heiken == -1 && macdchange == -1)) {
      if (createneworders) createorder(Symbol(), -1, lotsize, magic, message, 0, 0);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+