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
   for ( x = 0; x < ARRSIZE; x++){
      symbol = aPair[x];
      magic_a = 24;
      history(symbol, x, magic_a);
      gotrend_heiken(symbol, x, PERIOD_H1, 0.11, magic_a);
   }*/
   
   getallinfo();
   for (x = 0; x < ARRSIZE; x++) {
      symbol = aPair[x];
      if (current_currency) {
         if (symbol != Symbol()) {
            continue;
         }
      }
      //history(symbol, x, magic);
      history2(symbol);
      openPositionTotal(symbol);
      render_avg_costing(symbol, x, lots, true, true);
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
   int buy, sell, buy2, sell2;
   bool buyorder = false;
   bool sellorder = false;
   if (current_currency) {
      buyorder = true;
      sellorder = true;
      if (symbol == Symbol()) {
      
      } else {
         return (0);
      }
   } else {
      if (x == USDJPY || x == CHFJPY || x == AUDJPY || x == NZDJPY || x == CADJPY || x == GBPJPY) {
         buy += CalculateOrdersTypeSymbol("USDJPY", magicnumber, OP_BUY);
         buy += CalculateOrdersTypeSymbol("CHFJPY", magicnumber, OP_BUY);
         buy += CalculateOrdersTypeSymbol("AUDJPY", magicnumber, OP_BUY);
         buy += CalculateOrdersTypeSymbol("NZDJPY", magicnumber, OP_BUY);
         buy += CalculateOrdersTypeSymbol("CADJPY", magicnumber, OP_BUY);
         buy += CalculateOrdersTypeSymbol("GBPJPY", magicnumber, OP_BUY);
      
         sell += CalculateOrdersTypeSymbol("USDJPY", magicnumber, OP_SELL);
         sell += CalculateOrdersTypeSymbol("CHFJPY", magicnumber, OP_SELL);
         sell += CalculateOrdersTypeSymbol("AUDJPY", magicnumber, OP_SELL);
         sell += CalculateOrdersTypeSymbol("NZDJPY", magicnumber, OP_SELL);
         sell += CalculateOrdersTypeSymbol("CADJPY", magicnumber, OP_SELL);
         sell += CalculateOrdersTypeSymbol("GBPJPY", magicnumber, OP_SELL);
      
         if (buy < 3) {
            buyorder = true;
         } 
         if (sell < 3) {
            sellorder = true;
         }
      } else if (x == EURUSD || x == USDCHF) {
         buy = CalculateOrdersTypeSymbol("EURUSD", magicnumber, OP_BUY);
         buy2 = CalculateOrdersTypeSymbol("USDCHF", magicnumber, OP_BUY);
         sell = CalculateOrdersTypeSymbol("EURUSD", magicnumber, OP_SELL);
         sell2 = CalculateOrdersTypeSymbol("USDCHF", magicnumber, OP_SELL);
         buyorder = true;
         sellorder = true;
         if (buy > 0 && x == USDCHF) {
            buyorder = true;
         } else if (sell > 0 && x == USDCHF) {
            sellorder = true;
         } else if (buy2 > 0 && x == EURUSD) {
            buyorder = true;
         } else if (sell2 > 0 && x == EURUSD) {
            sellorder = true;
         }
      } else if (x == AUDUSD || x == NZDUSD) {
         buy += CalculateOrdersTypeSymbol("AUDUSD", magicnumber, OP_BUY);
         buy += CalculateOrdersTypeSymbol("NZDUSD", magicnumber, OP_BUY);
      
         sell += CalculateOrdersTypeSymbol("AUDUSD", magicnumber, OP_SELL);
         sell += CalculateOrdersTypeSymbol("NZDUSD", magicnumber, OP_SELL);
         if (buy < 1) {
            buyorder = true;
         } 
         if (sell < 1) {
            sellorder = true;
         }
      } else if (x == AUDCAD || x == NZDCAD) {
         buy += CalculateOrdersTypeSymbol("AUDCAD", magicnumber, OP_BUY);
         buy += CalculateOrdersTypeSymbol("NZDCAD", magicnumber, OP_BUY);
      
         sell += CalculateOrdersTypeSymbol("AUDCAD", magicnumber, OP_SELL);
         sell += CalculateOrdersTypeSymbol("NZDCAD", magicnumber, OP_SELL);
         if (buy < 1) {
            buyorder = true;
         } 
         if (sell < 1) {
            sellorder = true;
         }
      } else {
         buyorder = true;
         sellorder = true;
      }
   }

   double top = 6;
   double bottom = 3;
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
   int semaphore;
   double val2, val3, val4, val5, val6, val7, val8, val9;
   int condition_heiken2, condition_heiken3, condition_heiken4, condition_heiken5, condition_heiken6;
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
      val4 = iCustom(symbol, PERIOD_M15, "Heiken_Ashi_Smoothed",2,1);
      val5 = iCustom(symbol, PERIOD_M15, "Heiken_Ashi_Smoothed",3,1);
      condition_heiken4 = 0;
      if (val2 < val3) {
         condition_heiken4 = 1;
      } else if (val2 > val3) {
         condition_heiken4 = -1;
      }
      val2 = iCustom(symbol, PERIOD_M30, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_M30, "Heiken_Ashi_Smoothed",3,0);
      val6 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,1);
      val7 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,1);
      condition_heiken5 = 0;
      if (val2 < val3) {
         condition_heiken5 = 1;
      } else if (val2 > val3) {
         condition_heiken5 = -1;
      }
      val2 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,0);
      val8 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",2,1);
      val9 = iCustom(symbol, PERIOD_H1, "Heiken_Ashi_Smoothed",3,1);
      condition_heiken6 = 0;
      if (val2 < val3) {
         condition_heiken6 = 1;
      } else if (val2 > val3) {
         condition_heiken6 = -1;
      }

   int orders;
   /*if (m1 == 1 || m2 == -1) {
      //close sell Order Order
      CheckForClose(symbol, x, magicnumber, 1);
   } else if (m1 == -1 || m2 == 1) {
      //close buy orders
      CheckForClose(symbol, x, magicnumber, -1);
   }*/
   if (m1 == 1 && m2 == -1 
   && condition_heiken2 == 1 && condition_heiken3 == 1 && condition_heiken4 == 1
   && condition_heiken5 == 1 && condition_heiken6 == 1
   //&& (val4 > val5 || val6 > val7 || val8 > val9)
   ) { // buy
      //CheckForClose(symbol, x, magicnumber, 1);
      meter_direction = 1;
         if (createneworders && buyorder) {
            //orders = CalculateMaxOrders(magicnumber);
            //if (orders < max_orders && buyorder) { && buyorder
               createorder(aPair[x], 1, lotsize, magicnumber, "Info " + magicnumber + " " + build + TimeframeToString(period) + " " 
               + DoubleToStr(tp, 1) + "/" + DoubleToStr(bt, 1), 
               0, 0);
            //}
         }
   } else if (m1 == -1 && m2 == 1 
   && condition_heiken2 == -1 && condition_heiken3 == -1 && condition_heiken4 == -1
   && condition_heiken5 == -1 && condition_heiken6 == -1
   //&& (val4 < val5 || val6 < val7 || val8 < val9)
   ) { //sell
      //CheckForClose(symbol, x, magicnumber, -1);
      meter_direction = -1;
         if (createneworders && sellorder) {
            //orders = CalculateMaxOrders(magicnumber);
            //if (orders < max_orders && sellorder) {
               createorder(aPair[x], -1, lotsize, magicnumber, "Info " + magicnumber + " " + build + TimeframeToString(period) + " " 
               + DoubleToStr(bt, 1) + "/" + DoubleToStr(tp, 1), 
               0, 0);
            //}
         }
   }
   infobox = infobox + "\nmeter_direction: " + meter_direction;
      
}