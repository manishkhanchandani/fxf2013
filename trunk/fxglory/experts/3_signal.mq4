//+------------------------------------------------------------------+
//|                                                     3_signal.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <3_signal_inc.mqh>

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
   hour = Hour() - gmtoffset;
   infobox = "\nTime: " + TimeToStr(TimeCurrent()) + " and Hour is: " + hour + ", Server Hour: " + Hour() + 
   ", createneworders: " + createneworders + ", build: " + build + ", lots: " + lots + ", Max orders: " + max_orders + "\n";
   orderbox = "\n";
   createbox = "\n";
   historybox = "\n";
   string symbol;
   int period = PERIOD_M15;
   int magic_a;
   int x;
   /*
   for (x = 0; x < ARRSIZE; x++){
      symbol = aPair[x];
      magic_a = 21;
      history(symbol, x, magic_a);
      gotrend_heiken(symbol, x, PERIOD_M5, 0.08, magic_a);
   }
   for ( x = 0; x < ARRSIZE; x++){
      symbol = aPair[x];
      magic_a = 22;
      history(symbol, x, magic_a);
      gotrend_heiken(symbol, x, PERIOD_M15, 0.09, magic_a);
   }
   for (x = 0; x < ARRSIZE; x++){
      symbol = aPair[x];
      magic_a = 23;
      history(symbol, x, magic_a);
      gotrend_heiken(symbol, x, PERIOD_M30, 0.10, magic_a);
   }
   for ( x = 0; x < ARRSIZE; x++){
      symbol = aPair[x];
      magic_a = 24;
      history(symbol, x, magic_a);
      gotrend_heiken(symbol, x, PERIOD_H1, 0.11, magic_a);
   }
   for ( x = 0; x < ARRSIZE; x++){
      symbol = aPair[x];
      magic_a = 25;
      history(symbol, x, magic_a);
      gotrend_heiken(symbol, x, PERIOD_H4, 0.12, magic_a);
   }
   for ( x = 0; x < ARRSIZE; x++){
      symbol = aPair[x];
      magic_a = 26;
      history(symbol, x, magic_a);
      gotrend_heiken(symbol, x, PERIOD_D1, 0.13, magic_a);
   }*/
   
   getallinfo();
   for (x = 0; x < ARRSIZE; x++) {
      symbol = aPair[x];
      history(symbol, x, magic);
      //render_avg_costing(symbol, x, lots);
      getallinfoorders(symbol, x, PERIOD_H4, lots, magic);
   }
   Comment(orderbox, infobox, createbox, historybox);
   if (filesave && opentime != Time[0]) {
      FileAppend("signals3/signal_" + Year() + "_" + Month() + "_" + Day() + "_" + Hour()  + ".txt", orderbox+infobox+createbox+historybox);
      opentime = Time[0];
      SendMail("EA Message as of " + TimeToStr(TimeCurrent()), orderbox+infobox+createbox+historybox);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+



int gotrend_heiken(string symbol, int x, int period, double lotsize, int magicnumber)
{
   double val2, val3, val4, val5;
   int condition_heiken, condition_heiken2, condition_heiken3;
   int h1;
   int h2, h3;
      //render_avg_costing(symbol, x, lotsize_gotrend);
      
   
   
      val2 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,0);
      condition_heiken = 0;
      if (val2 < val3) {
         condition_heiken = 1;
      } else if (val2 > val3) {
         condition_heiken = -1;
      }
      val2 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",3,0);
      condition_heiken2 = 0;
      if (val2 < val3) {
         condition_heiken2 = 1;
      } else if (val2 > val3) {
         condition_heiken2 = -1;
      }
      val2 = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",3,0);
      condition_heiken3 = 0;
      if (val2 < val3) {
         condition_heiken3 = 1;
      } else if (val2 > val3) {
         condition_heiken3 = -1;
      }
    
      infobox = infobox + "\nSymbol: " + symbol + ", val2: " + val2
               + ", val3: " + val3 + ", condition: " + condition_heiken
                + ", condition2: " + condition_heiken2 + ", condition3: " + condition_heiken3
               + ", Bid: " + MarketInfo(symbol, MODE_BID) + ", Period: " + TimeframeToString(period);
               
      if (
         condition_heiken == 1
         ) {
         CheckForClose(aPair[x], x, magicnumber, 1);
      } else if (
         condition_heiken == -1
         ) {
         CheckForClose(aPair[x], x, magicnumber, -1);
      }
      
      if (condition_heiken == 1 && condition_heiken2 == 1 
       && condition_heiken3 == 1) {
         if (createneworders) {
            createorder(aPair[x], 1, lotsize, magicnumber, "Heiken " + magicnumber + " " + build + TimeframeToString(period), 
               0, 0);
         }
      } else if (condition_heiken == -1 && condition_heiken2 == -1 
       && condition_heiken3 == -1) {
         if (createneworders) {
            createorder(aPair[x], -1, lotsize, magicnumber, "Heiken " + magicnumber + " " + build + TimeframeToString(period), 
               0, 0);
         }
      }
}



int getallinfoorders(string symbol, int x, int period, double lotsize, int magicnumber)
{
   if (x == EURJPY 
   //|| x == CHFJPY || x == AUDJPY || x == NZDJPY || x == CADJPY
      || x == EURUSD 
      || x == AUDUSD 
      || x == NZDUSD 
      //|| x == AUDCAD || x == NZDCAD
      || x == USDCHF) {
      
      } else {
         return (0);
      }
   double top = 5.9;
   double bottom = 2.1;
   double middlebottom = 4;
   double middletop = 4.5;
   int meter_direction;
   string current_currency1 = StringSubstr(symbol, 0, 3);
   string current_currency2 = StringSubstr(symbol, 3, 3);
   //meter_direction
   /*string strength = "\nCurrent Meter: USD: " + aMeter[USD] + ", EUR: " + aMeter[EUR] + "\nGBP: " + aMeter[GBP]
         + ", CHF: " + aMeter[CHF] + "\nCAD: " + aMeter[CAD] + ", AUD: " + aMeter[AUD]
          + "\nJPY: " + aMeter[JPY] + ", NZD: " + aMeter[NZD];
   infobox = infobox + strength;*/
   infobox = infobox + "\nCurrency 1: " + current_currency1 + ", Currency 2: " + current_currency2;
   int m1 = 0;
   int m2 = 0;
   int m3 = 0;
   int m4 = 0;
   double tp, bt;
   for (int z=0; z < PAIRSIZE; z++) {
      if (current_currency1 == aMajor[z] && aMeter[z] > top) {
         m1 = 1;
         tp = aMeter[z];
      } else if (current_currency1 == aMajor[z] && aMeter[z] < bottom) {
         m1 = -1;
         bt = aMeter[z];
      } else if (current_currency2 == aMajor[z] && aMeter[z] > top) {
         m2 = 1;
         tp = aMeter[z];
      } else if (current_currency2 == aMajor[z] && aMeter[z] < bottom) {
         m2 = -1;
         bt = aMeter[z];
      } else if (current_currency1 == aMajor[z] && aMeter[z] <= middletop && aMeter[z] >= middlebottom) {
         m3 = 1;
      } else if (current_currency2 == aMajor[z] && aMeter[z] <= middletop && aMeter[z] >= middlebottom) {
         m4 = 1;
      }
   }
   infobox = infobox + "\nm1: " + m1 + ", m2: " + m2 + ", m3: " + m3 + ", m4: " + m4;
   meter_direction = 0;
   if (m3 == 1 || m4 == 1) {
      //CloseOrder(symbol, x, magicnumber);
   }
   double val2, val3;
   int condition_heiken2, condition_heiken3, condition_heiken4;
      val2 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_M1, "Heiken_Ashi_Smoothed",3,0);
      condition_heiken2 = 0;
      if (val2 < val3) {
         condition_heiken2 = 1;
      } else if (val2 > val3) {
         condition_heiken2 = -1;
      }
      val2 = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_M5, "Heiken_Ashi_Smoothed",3,0);
      condition_heiken3 = 0;
      if (val2 < val3) {
         condition_heiken3 = 1;
      } else if (val2 > val3) {
         condition_heiken3 = -1;
      }
      val2 = iCustom(symbol, PERIOD_M15, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_M15, "Heiken_Ashi_Smoothed",3,0);
      condition_heiken4 = 0;
      if (val2 < val3) {
         condition_heiken4 = 1;
      } else if (val2 > val3) {
         condition_heiken4 = -1;
      }
   int orders;
   if (m1 == 1 || m2 == -1) {
      //close sell Order Order
      CheckForClose(symbol, x, magicnumber, 1);
   } else if (m1 == -1 || m2 == 1) {
      //close buy orders
      CheckForClose(symbol, x, magicnumber, -1);
   }
   if (m1 == 1 && m2 == -1 && condition_heiken2 == 1 && condition_heiken3 == 1 && condition_heiken4 == 1) { // buy
      CheckForClose(symbol, x, magicnumber, 1);
      meter_direction = 1;
         if (createneworders) {
            orders = CalculateMaxOrders(magicnumber);
            if (orders < max_orders) {
               createorder(aPair[x], 1, lotsize, magicnumber, "Info " + magicnumber + " " + build + TimeframeToString(period) + " " 
               + DoubleToStr(tp, 1) + "/" + DoubleToStr(bt, 1), 
               0, 0);
            }
         }
   } else if (m1 == -1 && m2 == 1 && condition_heiken2 == -1 && condition_heiken3 == -1 && condition_heiken4 == -1) { //sell
      CheckForClose(symbol, x, magicnumber, -1);
      meter_direction = -1;
         if (createneworders) {
            orders = CalculateMaxOrders(magicnumber);
            if (orders < max_orders) {
               createorder(aPair[x], -1, lotsize, magicnumber, "Info " + magicnumber + " " + build + TimeframeToString(period) + " " 
               + DoubleToStr(bt, 1) + "/" + DoubleToStr(tp, 1),  
               0, 0);
            }
         }
   }
   infobox = infobox + "\nmeter_direction: " + meter_direction;
      
}