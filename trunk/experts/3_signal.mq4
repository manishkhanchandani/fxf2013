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


int getallinfoorders(string symbol, int x, int period, double lotsize, int magicnumber)
{
   int buy, sell, buy2, sell2;
   bool buyorder = false;
   bool sellorder = false;
   int strategy;
   strategy = get_strategy(x);
   infobox = infobox + "\nS: " + strategy + "\n";
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

   bool condition_buy = false;
   bool condition_sell = false;
         double val2, val3, val4, val5, val6, val7, val8, val9;
         int condition_heiken2, condition_heiken3, condition_heiken4, condition_heiken5, condition_heiken6;
   string message;
   int semaphore;
   switch(strategy) {
      case 1:
         render_avg_costing(symbol, x, lots, true, true);
         double top = 6;
         double bottom = 3;
         double middlebottom = 4;
         double middletop = 4.5;
         int meter_direction;
         string current_currency1 = StringSubstr(symbol, 0, 3);
         string current_currency2 = StringSubstr(symbol, 3, 3);
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
         if (m1 == 1 && m2 == -1) {
            meter_direction = 1;
         } else if (m1 == -1 && m2 == 1) {
            meter_direction = -1;
         }
         infobox = infobox + "\nmeter_direction: " + meter_direction;
         if (m3 == 1 || m4 == 1) {
            //CloseOrder(symbol, x, magicnumber);
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
         val6 = iCustom(symbol, PERIOD_M30, "Heiken_Ashi_Smoothed",2,1);
         val7 = iCustom(symbol, PERIOD_M30, "Heiken_Ashi_Smoothed",3,1);
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
         
         /*if (m1 == 1 || m2 == -1) {
            //close sell Order Order
            CheckForClose(symbol, x, magicnumber, 1);
         } else if (m1 == -1 || m2 == 1) {
            //close buy orders
            CheckForClose(symbol, x, magicnumber, -1);
         }*/
         if (val8 > val9 || val8 < val9) {
            TimeFrame = TimeframeToString(PERIOD_H1);
         } else if (val6 > val7 || val6 < val7) {
            TimeFrame = TimeframeToString(PERIOD_M30);
         }
 
         condition_buy = (m1 == 1 && m2 == -1 
            && condition_heiken2 == 1 && condition_heiken3 == 1 && condition_heiken4 == 1
            && condition_heiken5 == 1 && condition_heiken6 == 1
            && (val8 > val9 || val6 > val7)
            );
         condition_sell = (m1 == -1 && m2 == 1 
            && condition_heiken2 == -1 && condition_heiken3 == -1 && condition_heiken4 == -1
            && condition_heiken5 == -1 && condition_heiken6 == -1
            && (val8 < val9 || val6 < val7)
            );
         if (condition_buy) message = "S " + strategy + ", " + build + ", " 
               + DoubleToStr(tp, 1) + "/" + DoubleToStr(bt, 1) + ","+TimeFrame;
         else if (condition_sell) message = "S " + strategy + ", " + build + ", " 
               + DoubleToStr(bt, 1) + "/" + DoubleToStr(tp, 1) + ","+TimeFrame;
         break;
      case 2://semaphore close with profit
         render_avg_costing(symbol, x, lots, false, true);
         semaphore = get_lasttrendsemaphore(x, PERIOD_H1, false);
         infobox = infobox + "\nLast Semaphore: " + semaphore + "(" + semaphoreNumber + ")";
         condition_buy = (semaphore == 1 && semaphoreNumber == 3);
         condition_sell = (semaphore == -1 && semaphoreNumber == 3);
         message = "S " + strategy + ", " + build
               + ", " + semaphore + ", " + semaphoreNumber;
         if (condition_buy) {
            CheckForCloseALL(symbol, x, 1);
         } else if (condition_sell) {
            CheckForCloseALL(symbol, x, -1);
         }
         break;
      case 3://semaphore close without profit
         render_avg_costing(symbol, x, lots, false, false);
         semaphore = get_lasttrendsemaphore(x, PERIOD_H1, false);
         infobox = infobox + "\nLast Semaphore: " + semaphore + "(" + semaphoreNumber + ")";
         condition_buy = (semaphore == 1);
         condition_sell = (semaphore == -1);
         message = "S " + strategy + ", " + build 
               + ", " + semaphore + ", " + semaphoreNumber;
         if (condition_buy) {
            CheckForCloseWithoutProfit(symbol, x, magic, 1);
         } else if (condition_sell) {
            CheckForCloseWithoutProfit(symbol, x, magic, -1);
         }
         break;
      case 4://semaphore with heiken
         render_avg_costing(symbol, x, lots, false, true);
         semaphore = get_lasttrendsemaphore(x, PERIOD_H1, false);
         infobox = infobox + "\nLast Semaphore: " + semaphore + "(" + semaphoreNumber + ")";
         condition_buy = (semaphore == 1 && 
            (
               heiken(symbol, PERIOD_M15) == 1 ||
               heiken(symbol, PERIOD_M30) == 1 ||
               heiken(symbol, PERIOD_H1) == 1
            )
         );
         condition_sell = (semaphore == -1  && 
            (
               heiken(symbol, PERIOD_M15) == -1 ||
               heiken(symbol, PERIOD_M30) == -1 ||
               heiken(symbol, PERIOD_H1) == -1
            )
            );
         message = "S " + strategy + ", " + build + ", " + TimeFrame
               + ", " + semaphore + ", " + semaphoreNumber;
         if (condition_buy) {
            CheckForCloseALL(symbol, x, 1);
         } else if (condition_sell) {
            CheckForCloseALL(symbol, x, -1);
         }
         break;
      case 5://semaphore with macd
         render_avg_costing(symbol, x, lots, false, true);
         semaphore = get_lasttrendsemaphore(x, PERIOD_H1, false);
         infobox = infobox + "\nLast Semaphore: " + semaphore + "(" + semaphoreNumber + ")";
         condition_buy = (semaphore == 1 && 
            (
               macd(symbol, PERIOD_M15) == 1 ||
               macd(symbol, PERIOD_M30) == 1 ||
               macd(symbol, PERIOD_H1) == 1
            )
         );
         condition_sell = (semaphore == -1  && 
            (
               macd(symbol, PERIOD_M15) == -1 ||
               macd(symbol, PERIOD_M30) == -1 ||
               macd(symbol, PERIOD_H1) == -1
            )
            );
         message = "S " + strategy + ", " + build + ", " + TimeFrame 
               + ", " + semaphore + ", " + semaphoreNumber;
         if (condition_buy) {
            CheckForCloseALL(symbol, x, 1);
         } else if (condition_sell) {
            CheckForCloseALL(symbol, x, -1);
         }
         break;
      case 6://semaphore with tenkan
         render_avg_costing(symbol, x, lots, false, true);
         semaphore = get_lasttrendsemaphore(x, PERIOD_H1, false);
         infobox = infobox + "\nLast Semaphore: " + semaphore + "(" + semaphoreNumber + ")";
         condition_buy = (semaphore == 1 && 
            (
               tenkan(symbol, PERIOD_M15) == 1 ||
               tenkan(symbol, PERIOD_M30) == 1 ||
               tenkan(symbol, PERIOD_H1) == 1
            )
         );
         condition_sell = (semaphore == -1  && 
            (
               tenkan(symbol, PERIOD_M15) == -1 ||
               tenkan(symbol, PERIOD_M30) == -1 ||
               tenkan(symbol, PERIOD_H1) == -1
            )
            );
         message = "S " + strategy + ", " + build + ", "  + TimeFrame
               + ", " + semaphore + ", " + semaphoreNumber;
         if (condition_buy) {
            CheckForCloseALL(symbol, x, 1);
         } else if (condition_sell) {
            CheckForCloseALL(symbol, x, -1);
         }
         break;
      case 7://semaphore with stoch
         render_avg_costing(symbol, x, lots, false, true);
         semaphore = get_lasttrendsemaphore(x, PERIOD_H1, false);
         infobox = infobox + "\nLast Semaphore: " + semaphore + "(" + semaphoreNumber + ")";
         condition_buy = (semaphore == 1 && 
            (
               stoch(symbol, PERIOD_M15) == 1 ||
               stoch(symbol, PERIOD_M30) == 1 ||
               stoch(symbol, PERIOD_H1) == 1
            )
         );
         condition_sell = (semaphore == -1  && 
            (
               stoch(symbol, PERIOD_M15) == -1 ||
               stoch(symbol, PERIOD_M30) == -1 ||
               stoch(symbol, PERIOD_H1) == -1
            )
            );
         message = "S " + strategy + ", " + build + ", "  + TimeFrame
               + ", " + semaphore + ", " + semaphoreNumber;
         if (condition_buy) {
            CheckForCloseALL(symbol, x, 1);
         } else if (condition_sell) {
            CheckForCloseALL(symbol, x, -1);
         }
         break;
      case 8://semaphore with parabolic sar
         render_avg_costing(symbol, x, lots, false, true);
         semaphore = get_lasttrendsemaphore(x, PERIOD_H1, false);
         infobox = infobox + "\nLast Semaphore: " + semaphore + "(" + semaphoreNumber + ")";
         condition_buy = (semaphore == 1 && 
            (
               sar(symbol, PERIOD_M15) == 1 ||
               sar(symbol, PERIOD_M30) == 1 ||
               sar(symbol, PERIOD_H1) == 1
            )
         );
         condition_sell = (semaphore == -1  && 
            (
               sar(symbol, PERIOD_M15) == -1 ||
               sar(symbol, PERIOD_M30) == -1 ||
               sar(symbol, PERIOD_H1) == -1
            )
            );
         message = "S " + strategy + ", " + build + ", "  + TimeFrame
               + ", " + semaphore + ", " + semaphoreNumber;
         if (condition_buy) {
            CheckForCloseALL(symbol, x, 1);
         } else if (condition_sell) {
            CheckForCloseALL(symbol, x, -1);
         }
         break;
   }


   if (condition_buy) { // buy
         if (createneworders && buyorder) {
               createorder(aPair[x], 1, lotsize, magicnumber, message, 0, 0);
         }
   } else if (condition_sell) { //sell
         if (createneworders && sellorder) {
               createorder(aPair[x], -1, lotsize, magicnumber, message, 0, 0);
         }
   }
      
}


int get_strategy(int x)
{
   int strategy;
   switch(x) {
      
      case USDCHF:
      case GBPUSD:
      case EURUSD:
         strategy = 1;
         break;
      case USDJPY:
      case USDCAD:
      case AUDUSD:
      case EURGBP:
         strategy = 2;
         break;
      case EURAUD:
      case EURCHF:
         strategy = 5;
         break;
      case EURJPY:
         strategy = 3;
         break;
      case GBPCHF:
      case CADJPY:
         strategy = 5;
         break;
      case GBPJPY:
      case AUDNZD:
      case AUDCAD:
      case AUDCHF:
         strategy = 6;
         break;
      case AUDJPY:
      case CHFJPY:
      case EURNZD:
      case EURCAD:
      case CADCHF:
      case NZDJPY:
      case NZDUSD:
         strategy = 4;
         break;
      case GBPCAD:
      case GBPNZD:
      case GBPAUD:
         strategy = 7;
         break;
      case NZDCHF:
      case NZDCAD:
         strategy = 8;
         break;
      default:
         strategy = 4;
         break;
   }

   return (strategy);
}


