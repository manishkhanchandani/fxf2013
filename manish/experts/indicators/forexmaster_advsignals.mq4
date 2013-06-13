//+------------------------------------------------------------------+
//|                                       forexmaster_getallinfo.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

#property indicator_chart_window


extern string symbol_suffix = "";

#define ARRSIZE  44
#define TABSIZE  10
#define PAIRSIZE 10

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
#define XAUUSD 28
#define XAGUSD 29
#define XAGAUD 30
#define XAGCAD 31
#define XAGNZD 32
#define XAGJPY 33
#define XAGGBP 34
#define XAGEUR 35
#define XAGCHF 36

#define XAUAUD 37
#define XAUCAD 38
#define XAUNZD 39
#define XAUJPY 40
#define XAUGBP 41
#define XAUEUR 42
#define XAUCHF 43

// Currency
#define USD 0
#define EUR 1
#define GBP 2
#define CHF 3                                                                                      
#define CAD 4                                                                                      
#define AUD 5                                                                                      
#define JPY 6                                                                                      
#define NZD 7                                                                                      
#define XAU 8                                                                                     
#define XAG 9   

string aPair[ARRSIZE]   = {
                        "USDCHF","GBPUSD","EURUSD","USDJPY","USDCAD","AUDUSD",
                        "EURGBP","EURAUD","EURCHF","EURJPY","GBPCHF","CADJPY",
                        "GBPJPY","AUDNZD","AUDCAD","AUDCHF","AUDJPY","CHFJPY",
                        "EURNZD","EURCAD","CADCHF","NZDJPY","NZDUSD","GBPCAD",
                        "GBPNZD","GBPAUD","NZDCHF","NZDCAD","XAUUSD","XAGUSD",
                        "XAGAUD","XAGCAD","XAGNZD","XAGJPY","XAGGBP","XAGEUR",
                        "XAGCHF","XAUAUD","XAUCAD","XAUNZD","XAUJPY","XAUGBP",
                        "XAUEUR","XAUCHF"
                        };
string aMajor[PAIRSIZE] = {"USD","EUR","GBP","CHF","CAD","AUD","JPY","NZD","XAU","XAG"};
double aMeter[PAIRSIZE];
int opentime;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
      if (opentime != iTime(Symbol(), Period(), 0)) {
         int    counted_bars=IndicatorCounted();
         string htmlCurrencyChart;
         string impbox;
         string box = getallinfo();
         string signals = getsignals(impbox, htmlCurrencyChart);
         string info = "<b>Current Time:</b> " + TimeToStr(TimeCurrent()) + ", <b>Forex Company:</b> " + AccountCompany() 
            + "<table width='100%' border='1' cellspacing='0' cellpadding='5'><tr><td valign='top'>" 
            + box 
            + "</td>"
            + "<td valign='top'>" + htmlCurrencyChart + "</td>"
            + "</tr></table>";
            //+ "\n\n<b>Recent Signals</b>" + impbox 
            //+ "\n\n<hr>\n\n<b>Signals</b>" + signals;
   
         string filename = "signals/signals.txt";
         FileDelete(filename);
         FileAppend(filename, info);
         Comment(info);
         opentime = iTime(Symbol(), Period(), 0);
      }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

string getsignals(string & impbox, string & htmlCurrencyChart)
{
   int i, j, check;
   string symbol;
   string text = "";
   string tmp = "";
   string tmp2 = "";
   double close1, close2;
   int time1, time2;
   double pointsEarned;
   int fpips;
   int period;
   string periodtostr;
   int periods[3] = {PERIOD_M15, PERIOD_M30, PERIOD_H1};
   int ptotal[3], ptotal2[3], ptotal3[3], ptotal4[3], ptotal5[3], ptotal6[3];
   text = "";
   htmlCurrencyChart = "<p>Fpips Since last Signal, (in bracket is signal for buy or sell). Following session will get refreshed in every 5 minutes."
      //+ " <a href='http://forexmastery.org/fx/content/buy-expert-advisor-based-signals-displayed-first-page'>Buy Expert Advisor based on following signals.</a></p>"
      + " Get Expert Advisor Based on Following Signals (send email to admin@forexmastery.org to "
      + "recieve a free copy of EA)</p>"
      + "<table width='100%' border='1' cellspacing='0' cellpadding='5'>" 
      + "<tr>"
      + "<td valign='top'><strong>Symbol</strong></td>"
      + "<td valign='top'><strong>Period 15M</strong></td>"
      + "<td valign='top'><strong>Period 30M</strong></td>"
      + "<td valign='top'><strong>Period 1H</strong></td>"
      + "</tr>"
      ;
   int k;
   int g,h,o,a,b;
   string textColor;
      string tmpString = "";
      int xo = 0;
   for (i=0; i<ARRSIZE; i++) {
      RefreshRates();
      symbol = aPair[i]+symbol_suffix;
      string current_currency1 = StringSubstr(symbol, 0, 3);
      string current_currency2 = StringSubstr(symbol, 3, 3);
      if (current_currency1 == "USD") continue;
      if (current_currency2 == "JPY") {
         
         } else if (i == NZDUSD || i == AUDUSD) {} else
            continue;
      if (current_currency1 == "XAU" || current_currency1 == "XAG") continue;
      //if (i == XAUJPY || i == XAGJPY || i == XAUUSD || i == XAGUSD) {}
      //else 
      //if (current_currency1 == "XAU" || current_currency1 == "XAG") continue;
      /*if (i == USDCHF || i == EURUSD || i == USDCAD || i == EURGBP || i == EURCHF || i == GBPCHF
       || i == AUDNZD || i == AUDCAD  || i == NZDCAD || i == EURCAD || i == CADCHF || i == GBPCAD
       || i == USDJPY || i == GBPUSD
      ) continue;*/
      xo++;
      double pt = MarketInfo(symbol, MODE_POINT);
      int digit = MarketInfo(symbol, MODE_DIGITS);
      int spread = MarketInfo(symbol, MODE_SPREAD);
      htmlCurrencyChart = htmlCurrencyChart + "<tr>"
         + "<td valign='top'><strong>"+ (xo) + ". " + symbol 
         + "</strong><br>Spread: "+DoubleToStr(spread, 0)
         + "<br>Bid: "+DoubleToStr(MarketInfo(symbol, MODE_BID), digit)
         + "<br>Ask: "+DoubleToStr(MarketInfo(symbol, MODE_ASK), digit)
         + "<br>Digit: "+digit
         + "<br>Point: "+DoubleToStr(pt, digit)
         +"</td>";
      for (k = 0; k < 3; k++) {
         
         period = periods[k];
         int subtotal = 0;
         htmlCurrencyChart = htmlCurrencyChart + "<td valign='top'>";
         
         //start here
         close1 = 0; time1 = 0; close2 = 0; time2 = 0; pointsEarned = 0; fpips = 0;
         check = 0; textColor = "";
         for (j = 1; j < 500; j++) {
            check = get_check(symbol, period, j, k);
            
            if (check != 0) {
               close1 = iClose(symbol, period, j);
               time1 = iTime(symbol, period, j);
               close2 = iClose(symbol, period, 0);
               time2 = iTime(symbol, period, 0);
               if (check == 1) {
                  textColor = "#0033CC";
                  pointsEarned = close2 - close1;
               } else if (check == -1) {
                  textColor = "#999933";
                  pointsEarned = close1 - close2;
               }
               fpips = (pointsEarned / pt);
               ptotal[k] = ptotal[k] + fpips;
               subtotal = subtotal + fpips;
               break;
            }
         }
         htmlCurrencyChart = htmlCurrencyChart + "<font color='"+textColor+"'";
         if (j == 1) {
            htmlCurrencyChart = htmlCurrencyChart + " style='font-weight:bold'";
         }
         htmlCurrencyChart = htmlCurrencyChart + ">"+fpips
            + " " + parse(check);
         if (j == 1) {
            htmlCurrencyChart = htmlCurrencyChart + "<br>Changed Now";
         } else {
            htmlCurrencyChart = htmlCurrencyChart + "<br>" + TimeHour(time1) + ":" + TimeMinute(time1)
            + " to " + TimeHour(time2) + ":" + TimeMinute(time2) + " ("+ ((time2 - time1)/60) + " mins)";
         }
         htmlCurrencyChart = htmlCurrencyChart + "<br>" + DoubleToStr(close1, digit)
            + " to " + DoubleToStr(close2, digit);
         htmlCurrencyChart = htmlCurrencyChart + "</font>";
         //end here
 
         
         
         htmlCurrencyChart = htmlCurrencyChart + "<br><br><b>PAST DATA</b>";
         //start here
         close1 = 0; time1 = 0; close2 = 0; time2 = 0; pointsEarned = 0; fpips = 0;
         check = 0; textColor = "";
         for (g = j + 1; g < j + 500; g++) {
            check = get_check(symbol, period, g, k);
            
            if (check != 0) {
               close1 = iClose(symbol, period, g);
               time1 = iTime(symbol, period, g);
               close2 = iClose(symbol, period, j);
               time2 = iTime(symbol, period, j);
               if (check == 1) {
                  textColor = "#0033CC";
                  pointsEarned = close2 - close1;
               } else if (check == -1) {
                  textColor = "#999933";
                  pointsEarned = close1 - close2;
               }
               fpips = (pointsEarned / pt);
               ptotal2[k] = ptotal2[k] + fpips;
               subtotal = subtotal + fpips;
               break;
            }
         }
         htmlCurrencyChart = htmlCurrencyChart + "<br><br><font color='"+textColor+"'";
         htmlCurrencyChart = htmlCurrencyChart + ">"+fpips
            + " " + parse(check);
         htmlCurrencyChart = htmlCurrencyChart + "<br>" + TimeHour(time1) + ":" + TimeMinute(time1)
            + " to " + TimeHour(time2) + ":" + TimeMinute(time2) + " ("+ ((time2 - time1)/60) + " mins)";
         htmlCurrencyChart = htmlCurrencyChart + "<br>" + DoubleToStr(close1, digit)
            + " to " + DoubleToStr(close2, digit);
         htmlCurrencyChart = htmlCurrencyChart + "</font>";
         //end here
     
     

         
         //start here
         close1 = 0; time1 = 0; close2 = 0; time2 = 0; pointsEarned = 0; fpips = 0;
         check = 0; textColor = "";
         for (h = g + 1; h < g + 500; h++) {
            check = get_check(symbol, period, h, k);
            
            if (check != 0) {
               close1 = iClose(symbol, period, h);
               time1 = iTime(symbol, period, h);
               close2 = iClose(symbol, period, g);
               time2 = iTime(symbol, period, g);
               if (check == 1) {
                  textColor = "#0033CC";
                  pointsEarned = close2 - close1;
               } else if (check == -1) {
                  textColor = "#999933";
                  pointsEarned = close1 - close2;
               }
               fpips = (pointsEarned / pt);
               ptotal3[k] = ptotal3[k] + fpips;
               subtotal = subtotal + fpips;
               break;
            }
         }
         htmlCurrencyChart = htmlCurrencyChart + "<br><br><font color='"+textColor+"'";
         htmlCurrencyChart = htmlCurrencyChart + ">"+fpips
            + " " + parse(check);
         htmlCurrencyChart = htmlCurrencyChart + "<br>" + TimeHour(time1) + ":" + TimeMinute(time1)
            + " to " + TimeHour(time2) + ":" + TimeMinute(time2) + " ("+ ((time2 - time1)/60) + " mins)";
         htmlCurrencyChart = htmlCurrencyChart + "<br>" + DoubleToStr(close1, digit)
            + " to " + DoubleToStr(close2, digit);
         htmlCurrencyChart = htmlCurrencyChart + "</font>";
         //end here
        
        
         
         //start here
         close1 = 0; time1 = 0; close2 = 0; time2 = 0; pointsEarned = 0; fpips = 0;
         check = 0; textColor = "";
         for (o = h + 1; o < h + 500; o++) {
            check = get_check(symbol, period, o, k);
            
            if (check != 0) {
               close1 = iClose(symbol, period, o);
               time1 = iTime(symbol, period, o);
               close2 = iClose(symbol, period, h);
               time2 = iTime(symbol, period, h);
               if (check == 1) {
                  textColor = "#0033CC";
                  pointsEarned = close2 - close1;
               } else if (check == -1) {
                  textColor = "#999933";
                  pointsEarned = close1 - close2;
               }
               fpips = (pointsEarned / pt);
               ptotal4[k] = ptotal4[k] + fpips;
               subtotal = subtotal + fpips;
               break;
            }
         }
         htmlCurrencyChart = htmlCurrencyChart + "<br><br><font color='"+textColor+"'";
         htmlCurrencyChart = htmlCurrencyChart + ">"+fpips
            + " " + parse(check);
         htmlCurrencyChart = htmlCurrencyChart + "<br>" + TimeHour(time1) + ":" + TimeMinute(time1)
            + " to " + TimeHour(time2) + ":" + TimeMinute(time2) + " ("+ ((time2 - time1)/60) + " mins)";
         htmlCurrencyChart = htmlCurrencyChart + "<br>" + DoubleToStr(close1, digit)
            + " to " + DoubleToStr(close2, digit);
         htmlCurrencyChart = htmlCurrencyChart + "</font>";
         //end here
        
          //start here
         close1 = 0; time1 = 0; close2 = 0; time2 = 0; pointsEarned = 0; fpips = 0;
         check = 0; textColor = "";
         for (a = o + 1; a < o + 500; a++) {
            check = get_check(symbol, period, a, k);
            
            if (check != 0) {
               close1 = iClose(symbol, period, a);
               time1 = iTime(symbol, period, a);
               close2 = iClose(symbol, period, o);
               time2 = iTime(symbol, period, o);
               if (check == 1) {
                  textColor = "#0033CC";
                  pointsEarned = close2 - close1;
               } else if (check == -1) {
                  textColor = "#999933";
                  pointsEarned = close1 - close2;
               }
               fpips = (pointsEarned / pt);
               ptotal5[k] = ptotal5[k] + fpips;
               subtotal = subtotal + fpips;
               break;
            }
         }
         htmlCurrencyChart = htmlCurrencyChart + "<br><br><font color='"+textColor+"'";
         htmlCurrencyChart = htmlCurrencyChart + ">"+fpips
            + " " + parse(check);
         htmlCurrencyChart = htmlCurrencyChart + "<br>" + TimeHour(time1) + ":" + TimeMinute(time1)
            + " to " + TimeHour(time2) + ":" + TimeMinute(time2) + " ("+ ((time2 - time1)/60) + " mins)";
         htmlCurrencyChart = htmlCurrencyChart + "<br>" + DoubleToStr(close1, digit)
            + " to " + DoubleToStr(close2, digit);
         htmlCurrencyChart = htmlCurrencyChart + "</font>";
         //end here
        
        
               //start here
         close1 = 0; time1 = 0; close2 = 0; time2 = 0; pointsEarned = 0; fpips = 0;
         check = 0; textColor = "";
         for (b = a + 1; b < a + 500; b++) {
            check = get_check(symbol, period, b, k);
            
            if (check != 0) {
               close1 = iClose(symbol, period, b);
               time1 = iTime(symbol, period, b);
               close2 = iClose(symbol, period, a);
               time2 = iTime(symbol, period, a);
               if (check == 1) {
                  textColor = "#0033CC";
                  pointsEarned = close2 - close1;
               } else if (check == -1) {
                  textColor = "#999933";
                  pointsEarned = close1 - close2;
               }
               fpips = (pointsEarned / pt);
               ptotal6[k] = ptotal6[k] + fpips;
               subtotal = subtotal + fpips;
               break;
            }
         }
         htmlCurrencyChart = htmlCurrencyChart + "<br><br><font color='"+textColor+"'";
         htmlCurrencyChart = htmlCurrencyChart + ">"+fpips
            + " " + parse(check);
         htmlCurrencyChart = htmlCurrencyChart + "<br>" + TimeHour(time1) + ":" + TimeMinute(time1)
            + " to " + TimeHour(time2) + ":" + TimeMinute(time2) + " ("+ ((time2 - time1)/60) + " mins)";
         htmlCurrencyChart = htmlCurrencyChart + "<br>" + DoubleToStr(close1, digit)
            + " to " + DoubleToStr(close2, digit);
         htmlCurrencyChart = htmlCurrencyChart + "<br>Subtotal: " + subtotal;
         htmlCurrencyChart = htmlCurrencyChart + "</font>";
         //end here
        
         //start here
         close1 = 0; time1 = 0; close2 = 0; time2 = 0; pointsEarned = 0; fpips = 0;
         check = 0; textColor = "";
         for (j = 1; j < 500; j++) {
            check = get_strategy_result(5, symbol, period, j, 0);
            
            if (check != 0) {
               close1 = iClose(symbol, period, j);
               time1 = iTime(symbol, period, j);
               close2 = iClose(symbol, period, 0);
               time2 = iTime(symbol, period, 0);
               if (check == 1) {
                  textColor = "#0033CC";
                  pointsEarned = close2 - close1;
               } else if (check == -1) {
                  textColor = "#999933";
                  pointsEarned = close1 - close2;
               }
               fpips = (pointsEarned / pt);
               break;
            }
         }
         htmlCurrencyChart = htmlCurrencyChart + "<br>MACD CHANGE<br><font color='"+textColor+"'";
         if (j == 1) {
            htmlCurrencyChart = htmlCurrencyChart + " style='font-weight:bold'";
         }
         htmlCurrencyChart = htmlCurrencyChart + ">"+fpips
            + " " + parse(check);
         if (j == 1) {
            htmlCurrencyChart = htmlCurrencyChart + "<br>Changed Now";
         } else {
            htmlCurrencyChart = htmlCurrencyChart + "<br>" + TimeHour(time1) + ":" + TimeMinute(time1)
            + " to " + TimeHour(time2) + ":" + TimeMinute(time2) + " ("+ ((time2 - time1)/60) + " mins)";
         }
         htmlCurrencyChart = htmlCurrencyChart + "<br>" + DoubleToStr(close1, digit)
            + " to " + DoubleToStr(close2, digit);
         htmlCurrencyChart = htmlCurrencyChart + "</font>";
         //end here
        
         
         //start here
         close1 = 0; time1 = 0; close2 = 0; time2 = 0; pointsEarned = 0; fpips = 0;
         check = 0; textColor = "";
         for (j = 1; j < 500; j++) {
            check = get_strategy_result(6, symbol, period, j, 0);
            
            if (check != 0) {
               close1 = iClose(symbol, period, j);
               time1 = iTime(symbol, period, j);
               close2 = iClose(symbol, period, 0);
               time2 = iTime(symbol, period, 0);
               if (check == 1) {
                  textColor = "#0033CC";
                  pointsEarned = close2 - close1;
               } else if (check == -1) {
                  textColor = "#999933";
                  pointsEarned = close1 - close2;
               }
               fpips = (pointsEarned / pt);
               break;
            }
         }
         htmlCurrencyChart = htmlCurrencyChart + "<br>Fisher<br><font color='"+textColor+"'";
         if (j == 1) {
            htmlCurrencyChart = htmlCurrencyChart + " style='font-weight:bold'";
         }
         htmlCurrencyChart = htmlCurrencyChart + ">"+fpips
            + " " + parse(check);
         if (j == 1) {
            htmlCurrencyChart = htmlCurrencyChart + "<br>Changed Now";
         } else {
            htmlCurrencyChart = htmlCurrencyChart + "<br>" + TimeHour(time1) + ":" + TimeMinute(time1)
            + " to " + TimeHour(time2) + ":" + TimeMinute(time2) + " ("+ ((time2 - time1)/60) + " mins)";
         }
         htmlCurrencyChart = htmlCurrencyChart + "<br>" + DoubleToStr(close1, digit)
            + " to " + DoubleToStr(close2, digit);
         htmlCurrencyChart = htmlCurrencyChart + "</font>";
         //end here
        
         //start here
         close1 = 0; time1 = 0; close2 = 0; time2 = 0; pointsEarned = 0; fpips = 0;
         check = 0; textColor = "";
         for (j = 1; j < 500; j++) {
            check = get_strategy_result(2, symbol, period, j, 0);
            
            if (check != 0) {
               close1 = iClose(symbol, period, j);
               time1 = iTime(symbol, period, j);
               close2 = iClose(symbol, period, 0);
               time2 = iTime(symbol, period, 0);
               if (check == 1) {
                  textColor = "#0033CC";
                  pointsEarned = close2 - close1;
               } else if (check == -1) {
                  textColor = "#999933";
                  pointsEarned = close1 - close2;
               }
               fpips = (pointsEarned / pt);
               break;
            }
         }
         htmlCurrencyChart = htmlCurrencyChart + "<br>Tenkan<br><font color='"+textColor+"'";
         if (j == 1) {
            htmlCurrencyChart = htmlCurrencyChart + " style='font-weight:bold'";
         }
         htmlCurrencyChart = htmlCurrencyChart + ">"+fpips
            + " " + parse(check);
         if (j == 1) {
            htmlCurrencyChart = htmlCurrencyChart + "<br>Changed Now";
         } else {
            htmlCurrencyChart = htmlCurrencyChart + "<br>" + TimeHour(time1) + ":" + TimeMinute(time1)
            + " to " + TimeHour(time2) + ":" + TimeMinute(time2) + " ("+ ((time2 - time1)/60) + " mins)";
         }
         htmlCurrencyChart = htmlCurrencyChart + "<br>" + DoubleToStr(close1, digit)
            + " to " + DoubleToStr(close2, digit);
         htmlCurrencyChart = htmlCurrencyChart + "</font>";
         //end here
         
         
         //start here
         close1 = 0; time1 = 0; close2 = 0; time2 = 0; pointsEarned = 0; fpips = 0;
         check = 0; textColor = "";
         for (j = 1; j < 500; j++) {
            check = get_strategy_result(7, symbol, period, j, 0);
            
            if (check != 0) {
               close1 = iClose(symbol, period, j);
               time1 = iTime(symbol, period, j);
               close2 = iClose(symbol, period, 0);
               time2 = iTime(symbol, period, 0);
               if (check == 1) {
                  textColor = "#0033CC";
                  pointsEarned = close2 - close1;
               } else if (check == -1) {
                  textColor = "#999933";
                  pointsEarned = close1 - close2;
               }
               fpips = (pointsEarned / pt);
               break;
            }
         }
         htmlCurrencyChart = htmlCurrencyChart + "<br>Heiken<br><font color='"+textColor+"'";
         if (j == 1) {
            htmlCurrencyChart = htmlCurrencyChart + " style='font-weight:bold'";
         }
         htmlCurrencyChart = htmlCurrencyChart + ">"+fpips
            + " " + parse(check);
         if (j == 1) {
            htmlCurrencyChart = htmlCurrencyChart + "<br>Changed Now";
         } else {
            htmlCurrencyChart = htmlCurrencyChart + "<br>" + TimeHour(time1) + ":" + TimeMinute(time1)
            + " to " + TimeHour(time2) + ":" + TimeMinute(time2) + " ("+ ((time2 - time1)/60) + " mins)";
         }
         htmlCurrencyChart = htmlCurrencyChart + "<br>" + DoubleToStr(close1, digit)
            + " to " + DoubleToStr(close2, digit);
         htmlCurrencyChart = htmlCurrencyChart + "</font>";
         //end here
        
         htmlCurrencyChart = htmlCurrencyChart + "</td>";
      }
      htmlCurrencyChart = htmlCurrencyChart + "</tr>";
      
      //htmlCurrencyChart = tmpString;
   }




      htmlCurrencyChart = htmlCurrencyChart + "<tr><td>&nbsp;</td><td>&nbsp;</td>"
         + "<td>&nbsp;</td><td>&nbsp;</td></tr>";
      htmlCurrencyChart = htmlCurrencyChart + "<tr><td>Total Fpips:</td><td>"+ptotal[0]+"</td>"
         + "<td>"+ptotal[1]+"</td><td>"+ptotal[2]+"</td></tr>";
      htmlCurrencyChart = htmlCurrencyChart + "<tr><td>Total2 Fpips:</td><td>"+ptotal2[0]+"</td>"
         + "<td>"+ptotal2[1]+"</td><td>"+ptotal2[2]+"</td></tr>";
      htmlCurrencyChart = htmlCurrencyChart + "<tr><td>Total3 Fpips:</td><td>"+ptotal3[0]+"</td>"
         + "<td>"+ptotal3[1]+"</td><td>"+ptotal3[2]+"</td></tr>";
      htmlCurrencyChart = htmlCurrencyChart + "<tr><td>Total4 Fpips:</td><td>"+ptotal4[0]+"</td>"
         + "<td>"+ptotal4[1]+"</td><td>"+ptotal4[2]+"</td></tr>";
      htmlCurrencyChart = htmlCurrencyChart + "<tr><td>Total5 Fpips:</td><td>"+ptotal5[0]+"</td>"
         + "<td>"+ptotal5[1]+"</td><td>"+ptotal5[2]+"</td></tr>";
      htmlCurrencyChart = htmlCurrencyChart + "<tr><td>Total6 Fpips:</td><td>"+ptotal6[0]+"</td>"
         + "<td>"+ptotal6[1]+"</td><td>"+ptotal6[2]+"</td></tr>";
      htmlCurrencyChart = htmlCurrencyChart + "<tr><td>Total All Fpips:</td><td>"
      +(ptotal[0] + ptotal2[0] + ptotal3[0] + ptotal4[0]+ptotal5[0]+ptotal6[0])+"</td>"
         + "<td>"+(ptotal[1] + ptotal2[1] + ptotal3[1] + ptotal4[1]+ptotal5[1]+ptotal6[1])+"</td><td>"
         +(ptotal[2] + ptotal2[2] + ptotal3[2] + ptotal4[2]+ptotal5[2]+ptotal6[2])+"</td></tr>";
   htmlCurrencyChart = htmlCurrencyChart + "</table>";
   ptotal[0] = 0;
   ptotal[1] = 0;
   ptotal[2] = 0;
   ptotal2[0] = 0;
   ptotal2[1] = 0;
   ptotal2[2] = 0;
   ptotal3[0] = 0;
   ptotal3[1] = 0;
   ptotal3[2] = 0;
   ptotal4[0] = 0;
   ptotal4[1] = 0;
   ptotal4[2] = 0;
   ptotal5[0] = 0;
   ptotal5[1] = 0;
   ptotal5[2] = 0;
   ptotal6[0] = 0;
   ptotal6[1] = 0;
   ptotal6[2] = 0;
   return (text);
}



double getallinfoSingleShift(string symbol, int shift)
{
   double aLookupSingle, aStrengthSingle;
   double high, low, bid, ask, point, spread, digits;
      double aHigh;
      double aLow;
      double aBid;
      double aAsk;
      double aRatio;
      double aRange;
      int z;
         
         //infobox = infobox + "\n" + mySymbol;
         bid = MarketInfo(symbol, MODE_BID);
         ask = MarketInfo(symbol, MODE_ASK);
         point = MarketInfo(symbol, MODE_POINT);
         spread = MarketInfo(symbol, MODE_SPREAD);
         digits = MarketInfo(symbol, MODE_DIGITS);
         //Calculating the points:
         high = -1;
         low = -1;
         for (z=shift; z<shift+4; z++) {
            //infobox = infobox + "High " + z + ": " + iHigh(symbol, PERIOD_H4, z) + "\n";
            //infobox = infobox + "Low " + z + ": " + iLow(symbol, PERIOD_H4, z) + "\n";
            if (high == -1) {
               high = iHigh(symbol, PERIOD_H4, z);
            }
            if (iHigh(symbol, PERIOD_H4, z) > high) {
               high = iHigh(symbol, PERIOD_H4, z);
            }
            if (low == -1) {
               low = iLow(symbol, PERIOD_H4, z);
            }
            if (iLow(symbol, PERIOD_H4, z) < low) {
               low = iLow(symbol, PERIOD_H4, z);
            }
         }
            //infobox = infobox + "High F " + z + ": " + high + "\n";
            //infobox = infobox + "Low F " + z + ": " + low + "\n";
         aHigh = high;
         aLow      = low; 
         aBid      = bid;                 
         aAsk      = ask;                 
         aRange    = MathMax((aHigh-aLow)/point,1);      // calculate range today  
         aRatio    = (aBid-aLow)/aRange/point;     // calculate pair ratio
         aLookupSingle   = iLookup(aRatio*100);                        // set a pair grade
         aStrengthSingle = 9-aLookupSingle;
         
         //Print("aLookup: ", aLookupSingle);
         //Print("aStrength: ", aStrengthSingle);
         return (aLookupSingle);
        
}


int iLookup(double ratio)                                                   // this function will return a grade value
  {                                                                         // based on its power.
   int    aTable[TABSIZE]  = {0,3,10,25,40,50,60,75,90,97};                 // grade table for currency's power
   int   index;
   
   if      (ratio <= aTable[0]) index = 0;
   else if (ratio < aTable[1])  index = 0;
   else if (ratio < aTable[2])  index = 1;
   else if (ratio < aTable[3])  index = 2;
   else if (ratio < aTable[4])  index = 3;
   else if (ratio < aTable[5])  index = 4;
   else if (ratio < aTable[6])  index = 5;
   else if (ratio < aTable[7])  index = 6;
   else if (ratio < aTable[8])  index = 7;
   else if (ratio < aTable[9])  index = 8;
   else                         index = 9;
   return(index);                                                           // end of iLookup function
  }

int get_subtotal(string symbol, int period, int start, int times, int & openStrategy, int & closeStrategy)
{
   
}

/*
int process_each(string symbol, int period, int shift, int k, double pt, int digit, string & htmlCurrencyChart)
{
   string tmpString = "";
   //start here
   
   double close1, close2;
   int time1, time2;
   double pointsEarned;
   int fpips;
   int check = 0; 
   string textColor = "";
   for (int g = shift + 1; g < shift + 500; g++) {
      check = get_check(symbol, period, g, k);
      if (check != 0) {
         close1 = iClose(symbol, period, g);
         time1 = iTime(symbol, period, g);
         close2 = iClose(symbol, period, shift);
         time2 = iTime(symbol, period, shift);
         if (check == 1) {
            textColor = "#0033CC";
            pointsEarned = close2 - close1;
         } else if (check == -1) {
            textColor = "#999933";
            pointsEarned = close1 - close2;
         }
         fpips = (pointsEarned / pt);
         //tot = tot + fpips;
         //subtot = subtot + fpips;
         break;
      }
   }
   tmpString = tmpString + "<br><br><font color='"+textColor+"'";
   tmpString = tmpString + ">"+fpips
            + " " + parse(check);
   tmpString = tmpString + "<br>" + TimeHour(time1) + ":" + TimeMinute(time1)
            + " to " + TimeHour(time2) + ":" + TimeMinute(time2) + " ("+ ((time2 - time1)/60) + " mins)";
   tmpString = tmpString + "<br>" + DoubleToStr(close1, digit)
            + " to " + DoubleToStr(close2, digit);
   tmpString = tmpString + "</font>";
   htmlCurrencyChart = htmlCurrencyChart + tmpString;
   //end here
   return (fpips);
}*/
int get_strategy_result(int strategy, string symbol, int period, int shift, int current)
{
   int check = 0;
   int check1 = 0;
   int check2 = 0;
   int check3 = 0;
   int check4 = 0;
   switch (strategy)
   {
      case 1:
         //spanAB
         if (current == 1)
            check = spanABC(symbol, period, shift);
         else
            check = spanAB(symbol, period, shift);
         break;
      case 2:
         //tenkan
         if (current == 1)
            check = tenkanC(symbol, period, shift);
         else
            check = tenkan(symbol, period, shift);
         break;
      case 3:
         //kijun
         if (current == 1)
         check = kijunC(symbol, period, shift);
         else
         check = kijun(symbol, period, shift);
         break;
      case 4:
         //macdRshift
         if (current == 1)
         check = macdRshiftC(symbol, period, shift);
         else 
         check = macdRshift(symbol, period, shift);
         break;
      case 5:
         //macdRChange
         if (current == 1)
         check = macdRChangeC(symbol, period, shift);
         else
         check = macdRChange(symbol, period, shift);
         break;
      case 6:
         //fisher
         if (current == 1)
         check = fisherC(symbol, period, shift);
         else
         check = fisher(symbol, period, shift);
         break;
      case 7:
         //heiken
         if (current == 1)
         check = heikenC(symbol, period, shift);
         else
         check = heiken(symbol, period, shift);
         break;
      case 8:
         //stoch
         if (current == 1)
         check = stochC(symbol, period, shift);
         else
         check = stoch(symbol, period, shift);
         break;
      case 9:
         //rsi
         if (current == 1)
         check = rsiC(symbol, period, shift);
         else
         check = rsi(symbol, period, shift);
         break;
      case 10:
         //sar
         if (current == 1)
         check = sarC(symbol, period, shift);
         else
         check = sar(symbol, period, shift);
         break;
      case 11:
         //cci
         if (current == 1)
         check = cciC(symbol, period, shift);
         else
         check = cci(symbol, period, shift);
         break;
      case 12:
         //bbtrend
         if (current == 1)
         check = bbtrendC(symbol, period, shift);
         else
         check = bbtrend(symbol, period, shift);
         break;
   }
   return (check);
}

int get_check(string symbol, int period, int shift, int kperiod)
{
   int j = shift;
   int k = kperiod;
   int check = 0; 
   if (k == 0)
   check = get_strategy_result(1, symbol, period, shift, 0); 
   if (k == 1)
   check = get_strategy_result(1, symbol, period, shift, 0); 
   if (k == 2)
   check = get_strategy_result(6, symbol, period, shift, 0); 
   return (check);
            //check = tenkan(symbol, period, j);
            //check = kijun(symbol, period, j); //5956, 14286, 12676
            //check = macdRshift(symbol, period, j);// 5436, 5611, 17474
            //check = macdRChange(symbol, period, j); //18434, 16538, 9962
            //check = tenkan(symbol, period, j); //11359, 16702, 12213
            if (k == 0)
            check = spanAB(symbol, period, j); //17694, 13835, 8788
            if (k == 1)
            check = spanAB(symbol, period, j); //13198, 18626, 15574
            if (k == 2)
            check = fisher(symbol, period, j); //8288, 17110, 17339

            /*
            //5695, 13268, 12004
            int check1 = tenkan(symbol, period, j);
            int check2 = kijun(symbol, period, j);
            int check3 = tenkanC(symbol, period, j);
            int check4 = kijunC(symbol, period, j);
            if ((check1 == 1 && check4 == 1) || (check2 == 1 && check3 == 1)) check = 1;
            if ((check1 == -1 && check4 == -1) || (check2 == -1 && check3 == -1)) check = -1;
            */
         
            /*
            //4133, 5937, 11612
            int check1 = tenkan(symbol, period, j);
            int check2 = macdRshift(symbol, period, j);
            int check3 = tenkanC(symbol, period, j);
            int check4 = macdRshiftC(symbol, period, j);
            if ((check1 == 1 && check4 == 1) || (check2 == 1 && check3 == 1)) check = 1;
            if ((check1 == -1 && check4 == -1) || (check2 == -1 && check3 == -1)) check = -1;
            */
            
            /*
            //9895, 16144, 8646
            int check1 = tenkan(symbol, period, j);
            int check2 = macdRChange(symbol, period, j);
            int check3 = tenkanC(symbol, period, j);
            int check4 = macdRChangeC(symbol, period, j);
            if ((check1 == 1 && check4 == 1) || (check2 == 1 && check3 == 1)) check = 1;
            if ((check1 == -1 && check4 == -1) || (check2 == -1 && check3 == -1)) check = -1;
            */
            
            
            /*
            //8882, 13237, 7515
            int check1 = tenkan(symbol, period, j);
            int check2 = spanAB(symbol, period, j);
            int check3 = tenkanC(symbol, period, j);
            int check4 = spanABC(symbol, period, j);
            if ((check1 == 1 && check4 == 1) || (check2 == 1 && check3 == 1)) check = 1;
            if ((check1 == -1 && check4 == -1) || (check2 == -1 && check3 == -1)) check = -1;
            */
            
            /*
            //6722, 14461, 11985
            int check1 = tenkan(symbol, period, j);
            int check2 = heiken(symbol, period, j);
            int check3 = tenkanC(symbol, period, j);
            int check4 = heikenC(symbol, period, j);
            if ((check1 == 1 && check4 == 1) || (check2 == 1 && check3 == 1)) check = 1;
            if ((check1 == -1 && check4 == -1) || (check2 == -1 && check3 == -1)) check = -1;
            */
            
            
            /*
            //10017, 16407, 11723
            int check1 = tenkan(symbol, period, j);
            int check2 = fisher(symbol, period, j);
            int check3 = tenkanC(symbol, period, j);
            int check4 = fisherC(symbol, period, j);
            if ((check1 == 1 && check4 == 1) || (check2 == 1 && check3 == 1)) check = 1;
            if ((check1 == -1 && check4 == -1) || (check2 == -1 && check3 == -1)) check = -1;
            */
            
            
            /*
            //7440, 16253, 14648
            int check1 = heiken(symbol, period, j);
            int check2 = fisher(symbol, period, j);
            int check3 = heikenC(symbol, period, j);
            int check4 = fisherC(symbol, period, j);
            if ((check1 == 1 && check4 == 1) || (check2 == 1 && check3 == 1)) check = 1;
            if ((check1 == -1 && check4 == -1) || (check2 == -1 && check3 == -1)) check = -1;
            */
            
            
            /*
            //10931, 13410, 8134
            int check1 = spanAB(symbol, period, j);
            int check2 = fisher(symbol, period, j);
            int check3 = spanABC(symbol, period, j);
            int check4 = fisherC(symbol, period, j);
            if ((check1 == 1 && check4 == 1) || (check2 == 1 && check3 == 1)) check = 1;
            if ((check1 == -1 && check4 == -1) || (check2 == -1 && check3 == -1)) check = -1;
            */
   return (check);
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
string parse(int type)
{
   if (type == 1) return ("(B)");
   else if (type == -1) return ("(S)");
   return ("");
}

int stoch(string symbol, int period, int shift)
{
   double val2 = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_MAIN,shift);
   double val3 = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_SIGNAL,shift);
   double val6 = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_MAIN,shift+1);
   double val7 = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_SIGNAL,shift+1);
         
   if (val2 > val3 && val6 < val7 && val3 < 30) {
      return (1);
   } else if (val2 < val3 && val6 > val7 && val3 > 70) {
      return (-1);
   }

   return (0);
}

int stochC(string symbol, int period, int shift)
{
   double val2 = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_MAIN,shift);
   double val3 = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_SIGNAL,shift);
         
   if (val2 > val3) {
      return (1);
   } else if (val2 < val3) {
      return (-1);
   }

   return (0);
}

int bbtrend(string symbol, int period, int shift)
{
   double val3 = iCustom(symbol, period, "Bollinger Bands_Stop_v2 ", 20, 1, 1.0, 1, 1, 1000, false, 4, shift);
   double val4 = iCustom(symbol, period, "Bollinger Bands_Stop_v2 ", 20, 1, 1.0, 1, 1, 1000, false, 5, shift);
   int current = 0;
   if (val3 == EMPTY_VALUE) current = -1;
   else if (val4 == EMPTY_VALUE) current = 1;
   double val3a = iCustom(symbol, period, "Bollinger Bands_Stop_v2 ", 20, 1, 1.0, 1, 1, 1000, false, 4, shift+1);
   double val4a = iCustom(symbol, period, "Bollinger Bands_Stop_v2 ", 20, 1, 1.0, 1, 1, 1000, false, 5, shift+1);
   int past = 0;
   if (val3a == EMPTY_VALUE) past = -1;
   else if (val4a == EMPTY_VALUE) past = 1;
   if (past != 1 && current == 1) return (1);
   else if (past != -1 && current == -1) return (-1);
   return (0);
}
int bbtrendC(string symbol, int period, int shift)
{
   double val3 = iCustom(symbol, period, "Bollinger Bands_Stop_v2 ", 20, 1, 1.0, 1, 1, 1000, false, 4, shift);
   double val4 = iCustom(symbol, period, "Bollinger Bands_Stop_v2 ", 20, 1, 1.0, 1, 1, 1000, false, 5, shift);
   if (val3 == EMPTY_VALUE) return (-1);
   else if (val4 == EMPTY_VALUE) return (1);
   return (0);
}

int rsi(string symbol, int period, int shift)
{
   int val = iRSI(symbol,period,14,PRICE_CLOSE,shift);
   int val2 = iRSI(symbol,period,14,PRICE_CLOSE,shift+1);
   if (val > 30 && val2 < 30) return (1);
   else if (val < 70 && val2 > 70) return (-1);
   return (0);
}

int rsiC(string symbol, int period, int shift)
{
   int val = iRSI(symbol,period,14,PRICE_CLOSE,shift);
   if (val > 30 && val < 50) return (1);
   else if (val < 70 && val > 50) return (1);
   return (0);
}

int cci(string symbol, int period, int shift)
{
   int val = iCCI(symbol,period,14,PRICE_CLOSE,shift);
   int val2 = iCCI(symbol,period,14,PRICE_CLOSE,shift+1);
   if (val > -150 && val2 < -150) return (1);
   else if (val < 150 && val2 > 150) return (-1);
   return (0);
}

int cciC(string symbol, int period, int shift)
{
   int val = iCCI(symbol,period,14,PRICE_CLOSE,shift);
   if (val > -150 && val < -50) return (1);
   else if (val < 150 && val > 50) return (-1);
   return (0);
}

int sar(string symbol, int period, int shift)
{
   double val2 = iSAR(symbol,period,0.02,0.2,shift);
   double val3 = iSAR(symbol,period,0.02,0.2,shift+1);
         
   if (val2 < iOpen(symbol, period, shift) && val3 > iOpen(symbol, period, shift+1)) {
      return (1);
   } else if (val2 > iOpen(symbol, period, shift) && val3 < iOpen(symbol, period, shift+1)) {
      return (-1);
   }

   return (0);
}

int sarC(string symbol, int period, int shift)
{
   double val2 = iSAR(symbol,period,0.02,0.2,shift);
         
   if (val2 < iOpen(symbol, period, shift)) {
      return (1);
   } else if (val2 > iOpen(symbol, period, shift)) {
      return (-1);
   }

   return (0);
}

int tenkan(string symbol, int period, int shift)
{
   double tenkan_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_TENKANSEN, shift);
   double kijun_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, shift);
   double tenkan_sen_2=iIchimoku(symbol, period, 9, 26, 52, MODE_TENKANSEN, shift+1);
   double kijun_sen_2=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, shift+1);
         
   if (tenkan_sen_1 > kijun_sen_1 && tenkan_sen_2 <= kijun_sen_2) {// && tenkan_sen_1 < iClose(symbol, period, shift)
      return (1);
   } else if (tenkan_sen_1 < kijun_sen_1 && tenkan_sen_2 >= kijun_sen_2) {// && tenkan_sen_1 > iClose(symbol, period, shift)
      return (-1);
   }

   return (0);
}

int spanAB(string symbol, int period, int shift)
{
   double spanA_1 =iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANA, shift-26);
   double spanB_1=iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANB, shift-26);
   double spanA_2 =iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANA, shift-25);
   double spanB_2=iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANB, shift-25);
         
   if (spanA_1 > spanB_1 && spanA_2 <= spanB_2) {
      return (1);
   } else if (spanA_1 < spanB_1 && spanA_2 >= spanB_2) {
      return (-1);
   }

   return (0);
}

int kijun(string symbol, int period, int shift)
{
   double kijun_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, shift);
   double kijun_sen_2=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, shift+1);
         
   if (iOpen(symbol, period, shift) > kijun_sen_1 && iClose(symbol, period, shift) > kijun_sen_1
      && (iOpen(symbol, period, shift+1) <= kijun_sen_2 || iClose(symbol, period, shift+1) <= kijun_sen_2)
      ) {
      return (1);
   } else if (iOpen(symbol, period, shift) < kijun_sen_1 && iClose(symbol, period, shift) < kijun_sen_1
      && (iOpen(symbol, period, shift+1) >= kijun_sen_2 || iClose(symbol, period, shift+1) >= kijun_sen_2)
      ) {
      return (-1);
   }

   return (0);
}


int heiken(string symbol, int period, int shift)
{
   double val2 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,shift);
   double val3 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,shift);
   double val6 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,shift+1);
   double val7 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,shift+1);
         
   if (val2 < val3 && val6 > val7) {
      return (1);
   } else if (val2 > val3 && val6 < val7) {
      return (-1);
   }

   return (0);
}

int fisher(string symbol, int period, int shift)
{
   double val2 = iCustom(symbol, period, "Fisher_no_repainting", 30, 0, shift);
   double val3 = iCustom(symbol, period, "Fisher_no_repainting", 30, 0, shift+1);
   if (val2 > 0 && val3 < 0) {
      return (1);
   } else if (val2 < 0 && val3 > 0) {
      return (-1);
   }

   return (0);
}
int macdRshift(string symbol, int period, int shift)
{
      double MacdCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,shift);
      double MacdPrevious=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,shift+1);
      double SignalCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_SIGNAL,shift);
      double SignalPrevious=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_SIGNAL,shift+1);
         
   if (MacdCurrent > SignalCurrent && MacdPrevious < SignalPrevious) {
      return (1);
   } else if (MacdCurrent < SignalCurrent && MacdPrevious > SignalPrevious) {
      return (-1);
   }

   return (0);
}
int macdRChange(string symbol, int period, int shift)
{
      double MacdCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,shift);
      double MacdPrevious=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,shift+1);
         
   if (MacdCurrent > 0 && MacdPrevious < 0) {
      return (1);
   } else if (MacdCurrent < 0 && MacdPrevious > 0) {
      return (-1);
   }

   return (0);
}

//---------------------------
int tenkanC(string symbol, int period, int shift)
{
   double tenkan_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_TENKANSEN, shift);
   double kijun_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, shift);
         
   if (tenkan_sen_1 > kijun_sen_1) {
      return (1);
   } else if (tenkan_sen_1 < kijun_sen_1) {
      return (-1);
   }

   return (0);
}

int spanABC(string symbol, int period, int shift)
{
   double spanA_1 =iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANA, shift-26);
   double spanB_1=iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANB, shift-26);
         
   if (spanA_1 > spanB_1) {
      return (1);
   } else if (spanA_1 < spanB_1) {
      return (-1);
   }

   return (0);
}

int kijunC(string symbol, int period, int shift)
{
   double kijun_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, shift);
         
   if (iOpen(symbol, period, shift) > kijun_sen_1 && iClose(symbol, period, shift) > kijun_sen_1
      ) {
      return (1);
   } else if (iOpen(symbol, period, shift) < kijun_sen_1 && iClose(symbol, period, shift) < kijun_sen_1
      ) {
      return (-1);
   }

   return (0);
}


int heikenC(string symbol, int period, int shift)
{
   double val2 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,shift);
   double val3 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,shift);
         
   if (val2 < val3) {
      return (1);
   } else if (val2 > val3) {
      return (-1);
   }

   return (0);
}

int fisherC(string symbol, int period, int shift)
{
   double val2 = iCustom(symbol, period, "Fisher_no_repainting", 30, 0, shift);
   if (val2 > 0) {
      return (1);
   } else if (val2 < 0) {
      return (-1);
   }

   return (0);
}
int macdRshiftC(string symbol, int period, int shift)
{
      double MacdCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,shift);
      double SignalCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_SIGNAL,shift);
         
   if (MacdCurrent > SignalCurrent) {
      return (1);
   } else if (MacdCurrent < SignalCurrent) {
      return (-1);
   }

   return (0);
}
int macdRChangeC(string symbol, int period, int shift)
{
      double MacdCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,shift);
      double MacdPrevious=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,shift+1);
         
   if (MacdCurrent > 0) {
      return (1);
   } else if (MacdCurrent < 0) {
      return (-1);
   }

   return (0);
}



string getallinfo()
{
   string mySymbol;
   double high, low, bid, ask, point, spread, digits;
      double aHigh[ARRSIZE];
      double aLow[ARRSIZE];
      double aHigh1[ARRSIZE];
      double aBid[ARRSIZE];
      double aAsk[ARRSIZE];
      double aRatio[ARRSIZE];
      double aRange[ARRSIZE];
      double aLookup[ARRSIZE];
      double aStrength[ARRSIZE];
      int z;
         int index;
         //infobox = infobox + "\n\n";
         for (index=0; index<28; index++) {
            
         RefreshRates();
         mySymbol = aPair[index]+symbol_suffix;
         //infobox = infobox + "\n" + mySymbol;
         bid = MarketInfo(mySymbol, MODE_BID);
         ask = MarketInfo(mySymbol, MODE_ASK);
         point = MarketInfo(mySymbol, MODE_POINT);
         spread = MarketInfo(mySymbol, MODE_SPREAD);
         digits = MarketInfo(mySymbol, MODE_DIGITS);
         //Calculating the points:
         high = -1;
         low = -1;
         for (z=0; z<4; z++) {
            if (high == -1) {
               high = iHigh(mySymbol, PERIOD_H4, z);
            }
            if (iHigh(mySymbol, PERIOD_H4, z) > high) {
               high = iHigh(mySymbol, PERIOD_H4, z);
            }
            if (low == -1) {
               low = iLow(mySymbol, PERIOD_H4, z);
            }
            if (iLow(mySymbol, PERIOD_H4, z) < low) {
               low = iLow(mySymbol, PERIOD_H4, z);
            }
         }
         aHigh[index] = high;
         aLow[index]      = low; 
         aBid[index]      = bid;                 
         aAsk[index]      = ask;                 
         aRange[index]    = MathMax((aHigh[index]-aLow[index])/point,1);      // calculate range today  
         aRatio[index]    = (aBid[index]-aLow[index])/aRange[index]/point;     // calculate pair ratio
         aLookup[index]   = iLookup(aRatio[index]*100);                        // set a pair grade
         aStrength[index] = 9-aLookup[index];
         aBid[index]      = MarketInfo(mySymbol,MODE_BID);                 
         aAsk[index]      = MarketInfo(mySymbol,MODE_ASK);                 
         aRange[index]    = MathMax((aHigh[index]-aLow[index])/point,1);      // calculate range today  
         aRatio[index]    = (aBid[index]-aLow[index])/aRange[index]/point;     // calculate pair ratio
         aLookup[index]   = iLookup(aRatio[index]*100);                        // set a pair grade
         aStrength[index] = 9-aLookup[index];                                  // set a pair strengh
         }
         aMeter[USD] = NormalizeDouble((aLookup[USDJPY]+aLookup[USDCHF]+aLookup[USDCAD]+aStrength[EURUSD]+aStrength[GBPUSD]+aStrength[AUDUSD]+aStrength[NZDUSD])/7,1);
   aMeter[EUR] = NormalizeDouble((aLookup[EURUSD]+aLookup[EURJPY]+aLookup[EURGBP]+aLookup[EURCHF]+aLookup[EURAUD]+aLookup[EURCAD]+aLookup[EURNZD])/7,1);
   aMeter[GBP] = NormalizeDouble((aLookup[GBPUSD]+aLookup[GBPJPY]+aLookup[GBPCHF]+aStrength[EURGBP]+aLookup[GBPCAD]+aLookup[GBPAUD]+aLookup[GBPNZD])/7,1);
   aMeter[CHF] = NormalizeDouble((aStrength[USDCHF]+aStrength[EURCHF]+aStrength[GBPCHF]+aStrength[AUDCHF]+aLookup[CHFJPY]+aStrength[CADCHF]+aStrength[NZDCHF])/7,1);
   aMeter[CAD] = NormalizeDouble((aStrength[USDCAD]+aLookup[CADCHF]+aStrength[AUDCAD]+aLookup[CADJPY]+aStrength[EURCAD]+aStrength[GBPCAD]+aStrength[NZDCAD])/7,1);
   aMeter[AUD] = NormalizeDouble((aLookup[AUDUSD]+aStrength[EURAUD]+aLookup[AUDCHF]+aLookup[AUDCAD]+aStrength[GBPAUD]+aLookup[AUDNZD]+aLookup[AUDJPY])/7,1);
   aMeter[JPY] = NormalizeDouble((aStrength[USDJPY]+aStrength[EURJPY]+aStrength[GBPJPY]+aStrength[NZDJPY]+aStrength[AUDJPY]+aStrength[CHFJPY]+aStrength[CADJPY])/7,1);     
   aMeter[NZD] = NormalizeDouble((aLookup[NZDUSD]+aStrength[EURNZD]+aStrength[GBPNZD]+aStrength[AUDNZD]+aLookup[NZDCAD]+aLookup[NZDCHF]+aLookup[NZDJPY])/7,1);
   string strength = "\n<b>Currency Strength Meter:</b> \n\nUSD: " + DoubleToStr(aMeter[USD], 1) 
           + "\nEUR: " + DoubleToStr(aMeter[EUR], 1)  + "\nGBP: " + DoubleToStr(aMeter[GBP], 1) 
         + "\nCHF: " + DoubleToStr(aMeter[CHF], 1)  + "\nCAD: " + DoubleToStr(aMeter[CAD] , 1) 
         + "\nAUD: " + DoubleToStr(aMeter[AUD], 1) 
          + "\nJPY: " + DoubleToStr(aMeter[JPY], 1)  + "\nNZD: " + DoubleToStr(aMeter[NZD], 1) ;
   return (strength);
}



void FileAppend(string name,string txt)
{
   int handle = FileOpen(name, FILE_READ|FILE_WRITE);
	FileSeek(handle,0,SEEK_END);
	FileWrite(handle,txt);
	FileFlush(handle);
	FileClose(handle);
}




