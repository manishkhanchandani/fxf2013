//+------------------------------------------------------------------+
//|                                                     3_signal.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <3_signal_inc.mqh>
extern bool new_strategy = true;
string rssbox;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   //start();
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
   rssbox = "";
   rssbox = rssbox + "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?>\n";
   rssbox = rssbox + "<rss version=\"0.91\">\n";
   rssbox = rssbox + "<channel>\n";
   rssbox = rssbox + "<title>ForexMastery.org::Signals</title>\n";
   rssbox = rssbox + "<link>http://www.forexmastery.org</link>\n";
   rssbox = rssbox + "<description>Forex - By Forexmastery.org</description>\n";
   rssbox = rssbox + "<language>en-us</language>\n";

   lotcalc();
   hour = Hour() - gmtoffset;
   infobox = "\nTime: " + TimeToStr(TimeCurrent()) + " and Hour is: " + hour + ", Server Hour: " + Hour() + 
   ", minutes: " + Minute() + ", createneworders: " + createneworders + ", build: " + build + ", lots: " + lots + ", Max orders: " + max_orders + "\n";
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
   if (new_strategy) {
      new_strategy();
   } else {
      for (x = 0; x < ARRSIZE; x++) {
         symbol = aPair[x];
         if (current_currency) {
            if (symbol != Symbol()) {
               continue;
            }
         }
         history2(symbol);
         openPositionTotal(symbol);
         getallinfoorders(symbol, x, PERIOD_H4, lots, magic);
      }
   }
   Comment(orderbox, infobox, createbox, historybox);
   
   rssbox = rssbox + "\n";
   rssbox = rssbox + "</channel>\n";
   rssbox = rssbox + "</rss>";
   if (filesave && opentime != Time[0]) {
      FileAppend("signals3/signal_" + Year() + "_" + Month() + "_" + Day() + "_" + Hour()  + ".txt", orderbox+infobox+createbox+historybox);
      opentime = Time[0];
      SendMail("EA Message as of " + TimeToStr(TimeCurrent()), orderbox+infobox+createbox+historybox);
      FileDelete("rss/rss.txt");
      FileAppend("rss/rss.txt", rssbox);
      
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
      /*if (x == USDJPY || x == CHFJPY || x == AUDJPY || x == NZDJPY || x == CADJPY || x == GBPJPY) {
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
      }*/

         buyorder = true;
         sellorder = true;
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
         condition_buy = (semaphore == 1 && semaphoreNumber < 15);
         condition_sell = (semaphore == -1 && semaphoreNumber < 15);
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
         condition_buy = (semaphore == 1 && semaphoreNumber < 15);
         condition_sell = (semaphore == -1 && semaphoreNumber < 15);
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
         condition_buy = (semaphore == 1 && semaphoreNumber < 15 && 
            (
               heiken(symbol, PERIOD_M15) == 1 ||
               heiken(symbol, PERIOD_M30) == 1 ||
               heiken(symbol, PERIOD_H1) == 1
            )
         );
         condition_sell = (semaphore == -1 && semaphoreNumber < 15  && 
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
         condition_buy = (semaphore == 1 && semaphoreNumber < 15 && 
            (
               macd(symbol, PERIOD_M15) == 1 ||
               macd(symbol, PERIOD_M30) == 1 ||
               macd(symbol, PERIOD_H1) == 1
            )
         );
         condition_sell = (semaphore == -1 && semaphoreNumber < 15  && 
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
         condition_buy = (semaphore == 1 && semaphoreNumber < 15 && 
            (
               tenkan(symbol, PERIOD_M15) == 1 ||
               tenkan(symbol, PERIOD_M30) == 1 ||
               tenkan(symbol, PERIOD_H1) == 1
            )
         );
         condition_sell = (semaphore == -1 && semaphoreNumber < 15  && 
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
         condition_buy = (semaphore == 1 && semaphoreNumber < 15 && 
            (
               stoch(symbol, PERIOD_M15) == 1 ||
               stoch(symbol, PERIOD_M30) == 1 ||
               stoch(symbol, PERIOD_H1) == 1
            )
         );
         condition_sell = (semaphore == -1  && semaphoreNumber < 15 && 
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
         condition_buy = (semaphore == 1 && semaphoreNumber < 15 && 
            (
               sar(symbol, PERIOD_M15) == 1 ||
               sar(symbol, PERIOD_M30) == 1 ||
               sar(symbol, PERIOD_H1) == 1
            )
         );
         condition_sell = (semaphore == -1 && semaphoreNumber < 15  && 
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
      case 9://semaphore 4 hour close with profit
         render_avg_costing(symbol, x, lots, true, true);
         semaphore = get_lasttrendsemaphore(x, PERIOD_H4, false);
         infobox = infobox + "\nLast Semaphore: " + semaphore + "(" + semaphoreNumber + ")";
         int check1 = heikenCurrent(symbol, PERIOD_M1);
         int check5 = heikenCurrent(symbol, PERIOD_M5);
         int check15 = heikenCurrent(symbol, PERIOD_M15);
         int check30 = heiken(symbol, PERIOD_M30);
         int checkh1 = heiken(symbol, PERIOD_H1);
         int checkh4 = heiken(symbol, PERIOD_H4);
         condition_buy = (semaphore == 1 && 
            (
               check1 == 1 &&
               check5 == 1 &&
               check15 == 1 &&
               (check30 == 1 ||
               checkh1 == 1 ||
               checkh4 == 1)
            )
         );
         condition_sell = (semaphore == -1 &&
            (
               
               check1 == -1 &&
               check5 == -1 &&
               check15 == -1 &&
               (check30 == -1 ||
               checkh1 == -1 ||
               checkh4 == -1)
            )
            );
         message = "S " + strategy + ", " + build
               + ", " + semaphore + ", " + semaphoreNumber;
         if (checkh1 == 1) {
            CheckForCloseALL(symbol, x, 1);
         } else if (checkh1 == -1) {
            CheckForCloseALL(symbol, x, -1);
         }
         break;
      case 10://avg costing and trailing
         render_avg_costing(symbol, x, lots, true, true);
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
      case USDJPY:
      case EURJPY:
      case GBPJPY:
      case CADJPY:
      case AUDJPY:
      case NZDJPY:
      case CHFJPY:
      case EURUSD:
      case NZDUSD:
      case AUDUSD:
         strategy = 9;
         break;
 
      default:
         strategy = 10;
         break;
   }
   return (strategy);
   switch(x) {
      
      case USDCHF:
         strategy = 1;
         break;
      case USDJPY:
      case USDCAD:
      case AUDUSD:
      case EURGBP:
         strategy = 2;
         break;
      case EURCHF:
         strategy = 5;
         break;
      case EURJPY:
         strategy = 2;
         break;
      case GBPCHF:
         strategy = 5;
         break;
      case AUDNZD:
      case AUDCAD:
         strategy = 6;
         break;
      case EURNZD:
      case EURAUD:
      case AUDCHF:
      case NZDUSD:
      case GBPJPY:
      case CADJPY:
      case AUDJPY:
         strategy = 9;
         break;
      case CHFJPY:
      case EURCAD:
      case CADCHF:
      case NZDJPY:
      case GBPUSD:
      case EURUSD:
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

string showResult(int input)
{
   if (input == 1) {
      return ("Buy");
   } else if (input == -1) {
      return ("Sell");
   }
   return ("Consolidate");
}
int checkforopen(string symbol, int mode)
{

   infobox = infobox + "\nSymbol: " + symbol;
   int check1 = heikenCurrent(symbol, PERIOD_M1);
   int check5 = heikenCurrent(symbol, PERIOD_M5);
   int check15 = heikenCurrent(symbol, PERIOD_M15);
   int check30 = heikenCurrent(symbol, PERIOD_M30);
   int checkh1 = heikenCurrent(symbol, PERIOD_H1);
   bool condition_buy, condition_sell;
   condition_buy = ( 
               check1 == 1 &&
               check5 == 1 &&
               check15 == 1 &&
               check30 == 1 &&
               checkh1 == 1
         );
         condition_sell = (
               check1 == -1 &&
               check5 == -1 &&
               check15 == -1 &&
               check30 == -1 &&
               checkh1 == -1
            );
   infobox = infobox + "|" + check1 + ","+check5 + ","+check15 + ","+check30 + ","+checkh1;
   if (condition_buy) return (1);
   else if (condition_sell) return (-1);
}
int checkforopen2(string symbol, int mode)
{
   rssbox = rssbox + "<h3>CHANGE CONDITION</h3>";

   string current_currency1 = StringSubstr(symbol, 0, 3);
   string current_currency2 = StringSubstr(symbol, 3, 3);
   infobox = infobox + ", Currency 1: " + current_currency1 + ", Currency 2: " + current_currency2;
   int code1, code2;
   double strength1, strength2;
         for (int z=0; z < PAIRSIZE; z++) {
            if (current_currency1 == aMajor[z]) {
               code1 = z;
               strength1 = aMeter[z];
            } else if (current_currency2 == aMajor[z]) {
               code2 = z;
               strength2 = aMeter[z];
            }
         }
   double diffStrength = MathAbs(strength1 - strength2);
   infobox = infobox + ", code1: " + code1 + ", strength1: " + strength1;
   infobox = infobox + ", code2: " + code2 + ", strength2: " + strength2;
   infobox = infobox + ", diffStrength: " + diffStrength;
   
   
   int check15 = heiken(symbol, PERIOD_M15);
   int check30 = heiken(symbol, PERIOD_M30);
   int checkh1 = heiken(symbol, PERIOD_H1);
   int checkh4 = heiken(symbol, PERIOD_H4);
   bool condition_buy, condition_sell;
   condition_buy = ( 
            (strength1 > strength2)
            && diffStrength >= 2
            &&
               (check15 == 1 ||
               check30 == 1 ||
               checkh1 == 1 ||
               checkh4 == 1)
         );
         condition_sell = (
               (strength1 < strength2)
            && diffStrength >= 2
            &&
               (check15 == -1 ||
               check30 == -1 ||
               checkh1 == -1 ||
               checkh4 == -1)
            );
   infobox = infobox + "|" + check15 + ","+check30 + ","+checkh1 + ","+checkh4;
   
   if (condition_buy) {
      infobox = infobox + ", Buy";
      return (1);
   }
   else if (condition_sell) {
      infobox = infobox + ", Sell";
      return (-1);
   }
}

int new_strategy()
{
   if (pair_eurgbpusd) {
      processNewStrategy("EURUSD", "GBPUSD", EURUSD, GBPUSD);
   }
   if (pair_euraudnzd) {
      processNewStrategy("EURAUD", "EURNZD", EURAUD, EURNZD);
   }
   if (pair_gbpaudnzd) {
      processNewStrategy("GBPAUD", "GBPNZD", GBPAUD, GBPNZD);
   } 
   if (pair_nzdaudusd) {
      processNewStrategy("AUDUSD", "NZDUSD", AUDUSD, NZDUSD);
   }
   if (pair_audnzdcad) {
      processNewStrategy("AUDCAD", "NZDCAD", AUDCAD, NZDCAD);
   }
   if (pair_audnzdchf) {
      processNewStrategy("AUDCHF", "NZDCHF", AUDCHF, NZDCHF);
   }
   if (pair_eurgbpjpy) {
      processNewStrategy("EURJPY", "GBPJPY", EURJPY, GBPJPY);
   }
   if (pair_chfcadjpy) {
      processNewStrategy("CHFJPY", "CADJPY", CHFJPY, CADJPY);
   }
   if (pair_audnzdjpy) {
      processNewStrategy("AUDJPY", "NZDJPY", AUDJPY, NZDJPY);
   }
   if (pair_usdcadchf) {
      processNewStrategy("USDCAD", "USDCHF", USDCAD, USDCHF);
   }
   int x;
   string symbol;
   for (x = 0; x < ARRSIZE; x++) {
      symbol = aPair[x];
      render_avg_costing(symbol, x, lots, true, true);
   }
}
/*

<item>
 <title>Attack Update</title>
 <link>http://www.downes.ca</link>
 <description>
 OK, here's where we stand. I have no email into
or out of downes.ca - this means that if you are sending me
email to stephen@downes.ca it will fail. It also means that
newsletter mailouts are failing (at least, I think they're
failing...). Additionally, all scheduled processes have
terminated, which means that Edu_RSS will be updated
manually. I have no tech support until at least tomorrow,
so it looks like we'll be limping along like this for a
bit. Again, please note, email sent to me at downes.ca is
not reaching me. By Stephen Downes, Stephen's Web, July
22, 2003
 </description>
 </item>
 */

int processNewStrategy(string cur1, string cur2, int cur1Mode, int cur2Mode)
{
   int buy1, sell1, buy2, sell2;
   bool condition_buy1, condition_sell1;
   bool condition_buy2, condition_sell2;
   bool condition_buy3, condition_sell3;
   bool condition_buy4, condition_sell4;
   int open1, open2, open3, open4;
   
   string message = "";
   message = "Strategy New" + ", " + build;
   buy1 = CalculateOrdersTypeSymbol(cur1, magic, OP_BUY);
   buy2 = CalculateOrdersTypeSymbol(cur2, magic, OP_BUY);
   sell1 = CalculateOrdersTypeSymbol(cur1, magic, OP_SELL);
   sell2 = CalculateOrdersTypeSymbol(cur2, magic, OP_SELL);
   //currency 1
   open1 = checkforopen(cur1, cur1Mode);
   if (open1 == 1) condition_buy1 = true;
   else if (open1 == -1) condition_sell1 = true;
   /*if (closeonloss) {
      if (condition_buy1) {
         CheckForCloseWithoutProfit(cur1, cur1Mode, magic, 1);
      } else if (condition_sell1) {
         CheckForCloseWithoutProfit(cur1, cur1Mode, magic, -1);
      }
   }*/
   if (condition_buy1) {
      CheckForCloseALL(cur1, cur1Mode, 1);
   } else if (condition_sell1) {
      CheckForCloseALL(cur1, cur1Mode, -1);
   }
   open2 = checkforopen2(cur1, cur1Mode);
   if (open2 == 1) condition_buy2 = true;
   else if (open2 == -1) condition_sell2 = true;
   
   //create currency 1 Order
   if (condition_buy1 && condition_buy2 && buy1 == 0 && buy2 == 0) {
      if (createneworders) {
         createorder(cur1, 1, lots, magic, message, 0, 0);
      }
   } else if (condition_sell1 && condition_sell2 && sell1 == 0 && sell2 == 0) {
      if (createneworders) {
         createorder(cur1, -1, lots, magic, message, 0, 0);
      }
   }
   
   buy1 = CalculateOrdersTypeSymbol(cur1, magic, OP_BUY);
   buy2 = CalculateOrdersTypeSymbol(cur2, magic, OP_BUY);
   sell1 = CalculateOrdersTypeSymbol(cur1, magic, OP_SELL);
   sell2 = CalculateOrdersTypeSymbol(cur2, magic, OP_SELL);
   //currency 2
   open3 = checkforopen(cur2, cur2Mode);
   if (open3 == 1) condition_buy3 = true;
   else if (open3 == -1) condition_sell3 = true;
   /*if (closeonloss) {
      if (condition_buy3) {
         CheckForCloseWithoutProfit(cur2, cur2Mode, magic, 1);
      } else if (condition_sell3) {
         CheckForCloseWithoutProfit(cur2, cur2Mode, magic, -1);
      }
   }*/
   if (condition_buy3) {
      CheckForCloseALL(cur2, cur2Mode, 1);
   } else if (condition_sell3) {
      CheckForCloseALL(cur2, cur2Mode, -1);
   }
   open4 = checkforopen2(cur2, cur2Mode);
   if (open4 == 1) condition_buy4 = true;
   else if (open4 == -1) condition_sell4 = true;

   //create currency 2 Order
   if (condition_buy3 && condition_buy4 && buy1 == 0 && buy2 == 0) {
      if (createneworders) {
         createorder(cur2, 1, lots, magic, message, 0, 0);
      }
   } else if (condition_sell3 && condition_sell4 && sell1 == 0 && sell2 == 0) {
      if (createneworders) {
         createorder(cur2, -1, lots, magic, message, 0, 0);
      }
   }

   return (0);
}


int processParticularCur(string cur, int curMode)
{
   return (0);
   //processParticularCur("GBP", GBP);
   string CurPairs[8][8];
   CurPairs[EUR][USD] = "EURUSD";
   CurPairs[EUR][GBP] = "EURGBP";
   CurPairs[EUR][NZD] = "EURNZD";
   CurPairs[EUR][AUD] = "EURAUD";
   CurPairs[EUR][CHF] = "EURCHF";
   CurPairs[EUR][CAD] = "EURCAD";
   CurPairs[EUR][JPY] = "EURJPY";
   CurPairs[EUR][EUR] = "";
   
   CurPairs[GBP][USD] = "GBPUSD";
   CurPairs[GBP][EUR] = "EURGBP";
   CurPairs[GBP][NZD] = "GBPNZD";
   CurPairs[GBP][AUD] = "GBPAUD";
   CurPairs[GBP][CHF] = "GBPCHF";
   CurPairs[GBP][CAD] = "GBPCAD";
   CurPairs[GBP][JPY] = "GBPJPY";
   CurPairs[GBP][GBP] = "";
   string symbol;
   for (int i = 0; i < 8; i++ ){
      if (CurPairs[curMode][i] == "") continue;
      symbol = CurPairs[curMode][i];
      infobox = StringConcatenate(infobox, "\nCur: ", CurPairs[curMode][i]);
      int code1, code2;
      double strength1, strength2;
      int z;
      string current_currency1 = StringSubstr(symbol, 0, 3);
      string current_currency2 = StringSubstr(symbol, 3, 3);
      infobox = infobox + ", Currency 1: " + current_currency1 + ", Currency 2: " + current_currency2;
            for ( z=0; z < PAIRSIZE; z++) {
               if (current_currency1 == aMajor[z]) {
                  code1 = z;
                  strength1 = aMeter[z];
               } else if (current_currency2 == aMajor[z]) {
                  code2 = z;
                  strength2 = aMeter[z];
               }
            }
      double diffStrength = MathAbs(strength1 - strength2);
      infobox = infobox + ", code1: " + code1 + ", strength1: " + strength1;
      infobox = infobox + ", code2: " + code2 + ", strength2: " + strength2;
      infobox = infobox + ", diffStrength: " + diffStrength;
   }
   return (0);
}