//+------------------------------------------------------------------+
//|                                                        cuWEB.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#include <3_signal_inc.mqh>
#include <strategies.mqh>

int pipsTotal = 0;
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
         infobox = "";
         getallinfo();
         infobox = infobox + "\n\n<b>INDICATOR BASED ON CURRENCY STRENGTH METER</b>\n";
         topdown();
         infobox = infobox + "\n\n<b>TOPS AND BOTTOMS</b>\n";
         topbottom();
         //infobox = infobox + "\n\n<b>Magic World</b>\n";
         //magicworld();
         //ichimoku();
         string filename = "signals/signals.txt";
         FileDelete(filename);
         FileAppend(filename, infobox);
         Comment(infobox);
         opentime = iTime(Symbol(), Period(), 0);
      }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

int topdown()
{
         for (int i=0; i<ARRSIZE; i++) {
            RefreshRates();
            string symbol = aPair[i];
            string box = "";
            double top = 5.9;
            double bottom = 2.5;
            int meter_direction;
            string current_currency1 = StringSubstr(symbol, 0, 3);
            string current_currency2 = StringSubstr(symbol, 3, 3);
            box = box + "\nSymbol: " + symbol;
            //box = box + ", Currency 1: " + current_currency1 + ", Currency 2: " + current_currency2;
            int m1 = 0;
            int m2 = 0;
            int m3 = 0;
            int m4 = 0;
            double tp = 0;
            double bt = 0;
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
               }
            }
            //box = box + ", m1: " + m1 + ", m2: " + m2 + ", tp: " + DoubleToStr(tp, 1) + ", bt: " + DoubleToStr(bt, 1);
   
            meter_direction = 0;
            if (m1 == 1 && m2 == -1) {
               meter_direction = 1;
            } else if (m1 == -1 && m2 == 1) {
               meter_direction = -1;
            }
            int spread = MarketInfo(symbol, MODE_SPREAD);
            box = box + ", Bid: " + DoubleToStr(MarketInfo(symbol, MODE_BID), MarketInfo(symbol, MODE_DIGITS)) 
               + ", Ask: " + DoubleToStr(MarketInfo(symbol, MODE_ASK), MarketInfo(symbol, MODE_DIGITS)) 
                + ", Spread: " + spread;
            box = box + ", Currency Direction: " + meter_direction;
            if (meter_direction != 0) {
               infobox = infobox + box;
            }
         }
}

int topbottom()
{
            string impbox = "";
            string textColor;
            int gtotal;
         for (int i=0; i<ARRSIZE; i++) {
            RefreshRates();
            string symbol = aPair[i];
            int meter_direction;
            string box = "";
            string current_currency1 = StringSubstr(symbol, 0, 3);
            string current_currency2 = StringSubstr(symbol, 3, 3);
            box = box + "\n\n<b>Symbol:</b> " + symbol;
            //box = box + ", Currency 1: " + current_currency1 + ", Currency 2: " + current_currency2;
            //if (current_currency2 == "JPY") continue;
            double highest = iHighest(symbol, PERIOD_D1, MODE_HIGH, 1000, 0);
            double high = iHigh(symbol, PERIOD_D1, highest);
            double lowest = iLowest(symbol, PERIOD_D1, MODE_LOW, 1000, 0);
            double low = iLow(symbol, PERIOD_D1, lowest);
            
            
            double highest2 = iHighest(symbol, PERIOD_D1, MODE_HIGH, WHOLE_ARRAY, 0);
            double high2 = iHigh(symbol, PERIOD_D1, highest2);
            double lowest2 = iLowest(symbol, PERIOD_D1, MODE_LOW, WHOLE_ARRAY, 0);
            double low2 = iLow(symbol, PERIOD_D1, lowest2);
            
            int top = ((high - MarketInfo(symbol, MODE_BID)) / MarketInfo(symbol, MODE_POINT));
            int bottom = ((MarketInfo(symbol, MODE_BID) - low) / MarketInfo(symbol, MODE_POINT));
            int total = ((high - low) / MarketInfo(symbol, MODE_POINT));
            int top2 = ((high2 - MarketInfo(symbol, MODE_BID)) / MarketInfo(symbol, MODE_POINT));
            int bottom2 = ((MarketInfo(symbol, MODE_BID) - low2) / MarketInfo(symbol, MODE_POINT));
            int total2 = ((high2 - low2) / MarketInfo(symbol, MODE_POINT));
            //if (total > 14000) continue;
            int diff = get_difference(symbol, i);
            int check;
            box = box + "\n1000 Days: high: " + DoubleToStr(high, MarketInfo(symbol, MODE_DIGITS)) 
               + ", low: " + DoubleToStr(low, MarketInfo(symbol, MODE_DIGITS)) 
                + ", highest: " + DoubleToStr(highest, 0) + ", lowest: " + DoubleToStr(lowest, 0)
                 + "\nTop: " + DoubleToStr(top, 0)
                 + ", Bottom: " + DoubleToStr(bottom, 0)
                 + ", Total: " + DoubleToStr(total, 0)
                 + ", Diff: " + diff
                 ;
            
            if (bottom < 2000) {
               if (check == 1) {
                  box = box + ", <b>BUY</b>";
               } else {
                  box = box + ", <b>BUY Chances</b>";
               }
            }
            if (top < 2000) {
               if (check == -1) {
                  box = box + ", <b>SELL</b>";
               } else {
                  box = box + ", <b>SELL Chances</b>";
               }
            }
            int spread = MarketInfo(symbol, MODE_SPREAD);
            box = box + ", Bid: " + DoubleToStr(MarketInfo(symbol, MODE_BID), MarketInfo(symbol, MODE_DIGITS)) 
             + ", ASK: " + DoubleToStr(MarketInfo(symbol, MODE_ASK), MarketInfo(symbol, MODE_DIGITS)) 
              + ", Spread: " + DoubleToStr(MarketInfo(symbol, MODE_SPREAD), 0) 
               ;
            
            box = box + "\n\nAll Days: high: " + DoubleToStr(high2, MarketInfo(symbol, MODE_DIGITS)) 
               + ", low: " + DoubleToStr(low2, MarketInfo(symbol, MODE_DIGITS)) 
                + ", highest: " + DoubleToStr(highest2, 0) + ", lowest: " + DoubleToStr(lowest2, 0)
                + "\nTop2: " + DoubleToStr(top2, 0)
                 + ", Bottom2: " + DoubleToStr(bottom2, 0)
                 + ", Total2 : " + DoubleToStr(total2, 0);
            if (bottom2 < 2000) {
               box = box + ", <b>Strong BUY Chances</b>";
            }
            if (top2 < 2000) {
               box = box + ", <b>Strong SELL Chances</b>";
            }
            int checkx = 0;
            checkx = get_strategy_result(26, symbol, PERIOD_M15, 1, 0);
            int checkx2 = get_strategy_result(26, symbol, PERIOD_M15, 1, 1);
            box = box + "\n<h3>Change: " + checkx
            + ", Current: " + checkx2
            + "</h3>"
            ;
            string sb="";
            int p;
            int do = 0;
            int strategy = 0;
            int cdiff = 0;
            int sma3;
            int ab;
            int main_total = 0;
            int bar;
            datetime startdate = D'2013.03.02 00:00';
            /*
            if (i == XAGUSD) { p = PERIOD_M15; strategy = 23; do = 1; }
            if (do == 1) {
               bar = getShift(symbol, p, startdate);
               box = box + "\n\nMain Period: " + p + ", Strategy: " + strategy + ", Start Date: " + TimeToStr(startdate);
               check = get_strategy_result(strategy, symbol, p, 0, 1);
               if (check == 1) {sb = "Buy";}
               else if (check == -1) {sb = "Sell";}
               box = box + "\nMA Current: " + sb;
               for (ab = 1; ab < bar; ab++) {
                  sma3 = get_strategy_result(strategy, symbol, p, ab, 0);
                  if (sma3 != 0) {
                     if (sma3 == 1) {
                        cdiff = (iClose(symbol, p, 0) - iClose(symbol, p, ab)) / MarketInfo(symbol, MODE_POINT);
                     } else if (sma3 == -1) {
                        cdiff = (iClose(symbol, p, ab) - iClose(symbol, p, 0)) / MarketInfo(symbol, MODE_POINT);
                     }
                     main_total = main_total + cdiff;
                     if (ab == 1) {
                        box = box + "<script language='javascript'>alert('" + symbol + " " + parse(sma3) + " Period: " + p + "');</script>";
                     }
                     box = box + "\nLast Change: " + parse(sma3) + " ("+iClose(symbol, p, ab)+") on bar: " + ab + " with pips: " 
                     + DoubleToStr(cdiff, 0);
                  }
               }
               box = box + "\nMain Total: " + main_total;
            }*/
            /*
            int gt[6];
            gt[0] = 0; gt[1] = 0; gt[2] = 0; gt[3] = 0; gt[4] = 0; gt[5] = 0;
            int p1s[6] = {PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4};
            for (int per=0; per < 6; per++) {
            p = p1s[per];
            box = box + "\n\nPeriod: " + p;
            check = get_strategy_result(23, symbol, p, 0, 1);
            if (check == 1) {sb = "Buy";}
            else if (check == -1) {sb = "Sell";}
            box = box + "\nMA Current: " + sb;
            cdiff = 0;
            for (ab = 1; ab < 2500; ab++) {
               sma3 = get_strategy_result(23, symbol, p, ab, 0);
               if (sma3 != 0) {
                  if (sma3 == 1) {
                     cdiff = (iClose(symbol, p, 0) - iClose(symbol, p, ab)) / MarketInfo(symbol, MODE_POINT);
                  } else if (sma3 == -1) {
                     cdiff = (iClose(symbol, p, ab) - iClose(symbol, p, 0)) / MarketInfo(symbol, MODE_POINT);
                  }
                  if (ab == 1) {
                     //box = box + "<script language='javascript'>alert('" + symbol + " " + parse(sma3) + " Period: " + p + "');</script>";
                  }
                  gt[per] = gt[per] + cdiff;
                  box = box + "\nLast Change: " + parse(sma3) + " ("+iClose(symbol, p, ab)+") on bar: " + ab + " with pips: " 
                  + DoubleToStr(cdiff, 0);// + " - Spread: " + MarketInfo(symbol, MODE_SPREAD) + " = " + (cdiff - (MarketInfo(symbol, MODE_SPREAD) * MarketInfo(symbol, MODE_POINT)));
                  break;
               }
            }
            
            }*/
            /*
            sb = "";
            check = get_strategy_result(23, symbol, PERIOD_M1, 1, 0);
            if (check == 1) sb = "Buy Now";
            else if (check == -1) sb = "Sell Now";
            box = box + "\nMA Change: " + sb;
            
            int semaphore1 = semaphoreShift(symbol, PERIOD_H1, 0);
            int snumber1 = semaphoreNumber;
            int semaphore2 = semaphoreShift(symbol, PERIOD_H1, snumber1+1);
            int snumber2 = semaphoreNumber;
            box = box + "\n\nSemaphore 1: " + parse(semaphore1) + " at " + snumber1 
            + " With High: " + iHigh(symbol, PERIOD_H1, snumber1) + " and Low: " + iLow(symbol, PERIOD_H1, snumber1);
            box = box + "\nSemaphore 2: " + parse(semaphore2) + " at " + snumber2 
            + " With High: " + iHigh(symbol, PERIOD_H1, snumber2) + " and Low: " + iLow(symbol, PERIOD_H1, snumber2);
            double highs, lows, diffs;
            double level_0, level_23, level_38, level_50, level_61;
            double tp1, tp2;
            string show;
            double pending_1;
            double pending_2;
            if (semaphore1 == 1) { // sell in this case
               highs = iHigh(symbol, PERIOD_H1, snumber2);
               lows = iLow(symbol, PERIOD_H1, snumber1);
               diffs = highs - lows;
               level_0 = lows + (diffs * 0.0);
               level_23 = lows + (diffs * 0.236);
               level_38 = lows + (diffs * 0.382);
               level_50 = lows + (diffs * 0.50);
               level_61 = lows + (diffs * 0.618);
               tp1 = lows - (diffs * 0.60);
               show = "Sell";
               pending_1 = (level_38 - MarketInfo(symbol, MODE_BID)) / MarketInfo(symbol, MODE_POINT);
               pending_2 = (level_23 - MarketInfo(symbol, MODE_BID)) / MarketInfo(symbol, MODE_POINT);
            } else if (semaphore1 == -1) { //buy in this case
               highs = iHigh(symbol, PERIOD_H1, snumber1);
               lows = iLow(symbol, PERIOD_H1, snumber2);
               diffs = highs - lows;
               level_0 = highs - (diffs * 0.0);
               level_23 = highs - (diffs * 0.236);
               level_38 = highs - (diffs * 0.382);
               level_50 = highs - (diffs * 0.50);
               level_61 = highs - (diffs * 0.618);
               tp1 = highs + (diffs * 0.60);
               show = "Buy";
               pending_1 = (MarketInfo(symbol, MODE_BID) - level_38) / MarketInfo(symbol, MODE_POINT);
               pending_2 = (MarketInfo(symbol, MODE_BID) - level_23) / MarketInfo(symbol, MODE_POINT);
            }
            int digits = MarketInfo(symbol, MODE_DIGITS);
            box = box + "\nHigh: " + highs + ", Low: " + lows + ", Diff: " + diffs + ", Forecast: " + show;
            box = box + "\nLevel 0: " + level_0 + ", Level 23: " + level_23 + ", level_38: " + level_38
               + ", Level 50: " + level_50
               + ", Level 61: " + level_61;
            box = box + "\n<b>" + show + " </b> at: " + level_38 
            + " (" + DoubleToStr(pending_1, 0) + ") or at: " 
            + level_23 + "(" + DoubleToStr(pending_2, 0) + ")";
            box = box + "\n<b>Take Profit Level 1: </b>" + tp1
            + " (" + DoubleToStr((MathAbs(tp1 - level_38)) / MarketInfo(symbol, MODE_POINT), 0) + ")";
            box = box + "\n<b>Stop Loss: </b>" + level_61
            + " (" + DoubleToStr((MathAbs(level_38 - level_61)) / MarketInfo(symbol, MODE_POINT), 0) + ")";
            */
            /*
            double MacdCurrent=iMACD(symbol,PERIOD_MN1,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
            double MacdPrevious=iMACD(symbol,PERIOD_MN1,12,26,9,PRICE_CLOSE,MODE_MAIN,2);
            double SignalCurrent=iMACD(symbol,PERIOD_MN1,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
            string macdtype = "No Signal";
            if (MacdCurrent > SignalCurrent && MacdCurrent > MacdPrevious) {
               macdtype = "Buy";
            } else if (MacdCurrent < SignalCurrent && MacdCurrent < MacdPrevious) {
               macdtype = "Sell";
            }*/
            /*
            check = get_strategy_result(4, symbol, PERIOD_D1, 0, 1);
            string st = "No Signal";
            if (check == 1) st = "Buy";
            else if(check == -1) st = "Sell";
            
            check = get_strategy_result(4, symbol, PERIOD_D1, 0, 1);
            string st2 = "No Signal";
            if (check == 1) st2 = "Buy";
            else if(check == -1) st2 = "Sell";
            check = get_strategy_result(4, symbol, PERIOD_W1, 0, 1);
            string st3 = "No Signal";
            if (check == 1) st3 = "Buy";
            else if(check == -1) st3 = "Sell";
            box = box + "\n\n<b>Long Term (monthly):</b> " + macdtype ;*//*+ ", <b>Week: </b>" 
            + st3 + ", <b>Day: </b>" + st2 + ", <b>4H Position: </b>" + st;*/
            /*
            check = get_strategy_result(19, symbol, PERIOD_M15, 1, 0);
            if (check != 0) {
               impbox = impbox + "\nSymbol: " + symbol + ", <b>Tenkan SMA20 Strategy Period 15: " + parse(check) + "</b>";
               //impbox = impbox + "<script language='javascript'>alert('" + symbol + " " + parse(check) + "');</script>";
            }
            check = get_strategy_result(19, symbol, PERIOD_M15, 0, 1);
            box = box + "\n\n<b>Tenkan SMA20 Strategy Current: " + parse(check) + "</b><hr>";
            if (check == 1) {
               box = "<font color='#0033CC'>" + box + "</font>";
            } else if (check == -1) {
               box = "<font color='#999933'>" + box + "</font>";
            }
            //box = box + internalProcess(symbol, PERIOD_M15, 19);
            //box = box + process_individual(symbol, i);
            
            check = get_lasttrendsemaphore(symbol, PERIOD_MN1, false);
            box = box + "\nSemaphore 1MN: " + check + ", last turn: " + semaphoreNumber;
            check = get_lasttrendsemaphore(symbol, PERIOD_W1, false);
            box = box + "\nSemaphore 1W: " + check + ", last turn: " + semaphoreNumber;
            check = get_lasttrendsemaphore(symbol, PERIOD_D1, false);
            box = box + "\nSemaphore 1D: " + check + ", last turn: " + semaphoreNumber;
            check = get_lasttrendsemaphore(symbol, PERIOD_H4, false);
            box = box + "\nSemaphore 4H: " + check + ", last turn: " + semaphoreNumber;*/
            /*int strategy = 5;
            int p = PERIOD_M15;
            int sma = get_strategy_result(strategy, symbol, p, 1, 0);
            int sma2 = get_strategy_result(strategy, symbol, p, 0, 1);
            box = box + "\nSMA " + strategy + ": " + parse(sma) + ", Current: " + parse(sma2);
            int cdiff = 0;
            for (int ab = 1; ab < 500; ab++) {
               int sma3 = get_strategy_result(strategy, symbol, p, ab, 0);
               if (sma3 != 0) {
                  if (sma3 == 1) {
                     cdiff = (iClose(symbol, PERIOD_M15, 0) - iClose(symbol, PERIOD_M15, ab)) / MarketInfo(symbol, MODE_POINT);
                  } else if (sma3 == -1) {
                     cdiff = (iClose(symbol, PERIOD_M15, ab) - iClose(symbol, PERIOD_M15, 0)) / MarketInfo(symbol, MODE_POINT);
                  }
                  gtotal = gtotal + cdiff;
                  box = box + ", Last Change: " + parse(sma3) + " on bar: " + ab + " with pips: " 
                  + DoubleToStr(cdiff, 0);
                  break;
               }
            }
            if (sma != 0) {
               //box = box + "<script language='javascript'>alert('" + symbol + " " + parse(sma) + "');</script>";
            }*/
            infobox = infobox + box;
         }
         infobox = "\n\n<hr>" + infobox + "\n";
         /*for (per = 0; per < 6; per++) {
         infobox = infobox + "\nGrand Total: Period: " + p1s[per] + ": " + gt[per];
         }*/
}
string process_individual(string symbol, int mode)
{
   string box = "";
   int check = 0;
   int check2 = 0;
   int k;
   double b1, b2;
   double fpips = 0;
   switch (mode)
   {
      case GBPUSD:
         box = box + internalProcess(symbol, PERIOD_D1, 1);
         break;
      case EURUSD:
         box = box + internalProcess(symbol, PERIOD_D1, 3);
         break;
      case AUDCAD:
         box = box + internalProcess(symbol, PERIOD_D1, 3);
         break;
      case USDCHF:
         box = box + internalProcess(symbol, PERIOD_D1, 2);
         break;
      case USDJPY:
         box = box + internalProcess(symbol, PERIOD_W1, 10);
         break;
      case USDCAD:
         box = box + internalProcess(symbol, PERIOD_W1, 2);
         break;
      case AUDUSD:
         box = box + internalProcess(symbol, PERIOD_H4, 10);
         break;
      case EURGBP:
         box = box + internalProcess(symbol, PERIOD_M15, 17);
         break;
      case EURAUD:
         box = box + internalProcess(symbol, PERIOD_W1, 11);
         break;
         /*
      case XAUJPY:
         box = box + internalProcess(symbol, PERIOD_H4, 7);
         break;
      case XAGJPY:
         box = box + internalProcess(symbol, PERIOD_H4, 3);
         break;
      case XAGUSD:
         box = box + internalProcess(symbol, PERIOD_D1, 11);
         break;
      case XAUUSD:
         box = box + internalProcess(symbol, PERIOD_MN1, 3);
         break;*/
   }
   return (box);
}

string internalProcess(string symbol, int period, int strategy)
{
   string box = "";
   int check = 0;
   int check2 = 0;
   int k;
   double b1, b2, b3;
   double fpips = 0;
   double fpips2 = 0;
   
         check = get_strategy_result(strategy, symbol, period, 1, 1);
         b1 = iClose(symbol, period, 0);
         for (k = 1; k < 1000; k++) {
            check2 = get_strategy_result(strategy, symbol, period, k, 0);
            if (check2 == 1) {
               b2 = iClose(symbol, period, k);
               fpips = (b1 - b2) / MarketInfo(symbol, MODE_POINT);
               break;
            } else if (check2 == -1) {
               b2 = iClose(symbol, period, k);
               fpips = (b2 - b1) / MarketInfo(symbol, MODE_POINT);
               break;
            }
         }
         box = box + "\n\n<b>Strategy: </b>" + get_strategy_name(strategy) + ", Type: " + parse(check) 
         + ", Pips Achieved: " + DoubleToStr(fpips, 0) + 
         ", End Bid: " + DoubleToStr(b1, MarketInfo(symbol, MODE_DIGITS)) + ", Start bid: " 
         + DoubleToStr(b2, MarketInfo(symbol, MODE_DIGITS)) + " at location: " + k + ", Period:  " + TimeframeToString(period);
         if (k == 1) {
            box = box + ", <b> " + parse(check) + " Now</b>";
         }
         int j;
         for (j = k+1; j < k+1000; j++) {
            check2 = get_strategy_result(strategy, symbol, period, j, 0);
            if (check2 == 1) {
               b3 = iClose(symbol, period, j);
               fpips2 = (b2 - b3) / MarketInfo(symbol, MODE_POINT);
               break;
            } else if (check2 == -1) {
               b3 = iClose(symbol, period, j);
               fpips2 = (b3 - b2) / MarketInfo(symbol, MODE_POINT);
               break;
            }
         }
         box = box + "\n<b>Past Record: </b>" + get_strategy_name(strategy) + ", Type: " + parse(check2) 
         + ", Pips Achieved: " + DoubleToStr(fpips2, 0) + 
         ", End Bid: " + DoubleToStr(b2, MarketInfo(symbol, MODE_DIGITS)) + ", Start bid: " 
         + DoubleToStr(b3, MarketInfo(symbol, MODE_DIGITS)) + " at location: " + j + ", Period: " + TimeframeToString(period);
   return (box);
}




int s[28][5];
int sm[28][5];
int checked[28][5];
int periods[5] = {PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4, PERIOD_D1};
int strategy;
int strategyPeriod;
int strategyMax;
int opentimeStrategy;
int opentimeStrategy2;
int counter;



int ichimoku()
{
   string box = "";
   string box1 = "";
   string box2 = "";
   infobox = infobox + "\n<b>Ichimoku</b>\n";
   for(int i=0;i<ARRSIZE;i++) {
      string symbol = aPair[i];
      infobox = infobox + "\n\n<b>Symbol: </b>" + symbol;
      for(int p = 0; p < 5; p++) {
         int period = periods[p];
         infobox = infobox + "\n<b>Period: </b>" + TimeframeToString(period);
         //get the trend
         double spanA = iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANA, 1);
         double spanB = iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANB, 1);
         double spanhigh, spanlow;
         if (spanA > spanB) {
            spanhigh = spanA;
            spanlow = spanB;
         } else {
            spanhigh = spanB;
            spanlow = spanA;
         }
         int trend = 0;
         int trend2 = 0;
         if (iClose(symbol, period, 1) > spanhigh) {
            trend = 1;
            infobox = infobox + ", <b>Trend: </b>Buy";
         } else if (iClose(symbol, period, 1) < spanlow) {
            trend = -1;
            infobox = infobox + ", <b>Trend: </b>Sell";
         } else {
            infobox = infobox + ", <b>Trend: </b>Consolidation";
         }
         if (iClose(symbol, period, 1) < spanhigh || iClose(symbol, period, 1) > spanlow) {
            box2 = box2 + "\nSymbol: " + symbol + ", Potential Symbol,  Period: " 
               + TimeframeToString(period);
         } 
         if (iClose(symbol, period, 1) > spanhigh && iClose(symbol, period, 2) < spanhigh) {
            trend2 = 1;
            infobox = infobox + ", <b>Trend Now Change To: </b>Buy";
            box = box + "\nSymbol: " + symbol + ", Trend Change To Buy,  Period: " 
               + TimeframeToString(period);
         } else if (iClose(symbol, period, 1) < spanlow && iClose(symbol, period, 2) > spanlow) {
            trend2 = -1;
            infobox = infobox + ", <b>Trend Now Change To: </b>Sell";
            box = box + "\nSymbol: " + symbol + ", Trend Change To Sell,  Period: " 
               + TimeframeToString(period);
         }
         
         double tenkan_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_TENKANSEN, 1);
         double kijun_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, 1);
         double tenkan_sen_2=iIchimoku(symbol, period, 9, 26, 52, MODE_TENKANSEN, 2);
         double kijun_sen_2=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, 2);
         infobox = infobox + "\n<b>Tenken-Kijun</b>";
         if (tenkan_sen_1 > kijun_sen_1) {
            //infobox = infobox + ", <b>Current Trend: </b>Buy";
            if (tenkan_sen_2 <= kijun_sen_2) {
               infobox = infobox + ", <b>Changed Now to Buy</b>";
               box1 = box1 + "\nSymbol: " + symbol + ", Tenkan Change To Buy,  Period: " 
               + TimeframeToString(period);
               if (trend == 1) {
                  infobox = infobox + ", Above Kumo so Great Power";
               } else if (trend == -1) {
                  infobox = infobox + ", Below Kumo so Less Power";
               } else {
                  infobox = infobox + ", In Kumo so Medium Power";
               }
            }
         } else if (tenkan_sen_1 < kijun_sen_1) {
            //infobox = infobox + ", <b>Current Trend: </b>Sell";
            if (tenkan_sen_2 >= kijun_sen_2) {
               infobox = infobox + ", <b>Changed Now to Sell</b>";
               box1 = box1 + "\nSymbol: " + symbol + ", Tenkan Change To Sell,  Period: " 
               + TimeframeToString(period);
               if (trend == 1) {
                  infobox = infobox + ", Above Kumo so Less Power";
               } else if (trend == -1) {
                  infobox = infobox + ", Below Kumo so Great Power";
               } else {
                  infobox = infobox + ", In Kumo so Medium Power";
               }
            }
         
         }
      }
   }
   infobox = box2 + "<hr>" + box + "<hr>" + box1 + infobox;
}

int magicworld()
{
   pipsTotal = 0;
   for(int i=0;i<ARRSIZE;i++) {
      string symbol = aPair[i];
      findingStrategy(symbol, i);
   }
   infobox = infobox + "\n<b>Total Pips in 20 Days</b>: " + pipsTotal + "\n";
}
int findingStrategy(string symbol, int mode)
{
   
   if (opentimeStrategy != iTime(Symbol(), PERIOD_D1, 0)) {
      s[mode][0] = 0;
      s[mode][1] = 0;
      s[mode][2] = 0;
      s[mode][3] = 0;
      s[mode][4] = 0;
      checked[mode][0] = 0;
      checked[mode][1] = 0;
      checked[mode][2] = 0;
      checked[mode][3] = 0;
      checked[mode][4] = 0;
      opentimeStrategy = iTime(Symbol(), PERIOD_D1, 0);
   }
   double val;
   int max;
   int period;
   int p;
   if (checked[mode][0] == 1 && checked[mode][1] == 1 && checked[mode][2] == 1 && checked[mode][3] == 1 && checked[mode][4] == 1) {
      int max2 = 0;
      for(p = 0; p < 5; p++) {
         period = periods[p];
         infobox = infobox + "\nStrategy For Period: " + period + " is " + s[mode][p] + " with max value: " + sm[mode][p];
         if (sm[mode][p] > max2) {
            max2 = sm[mode][p];
            strategy = s[mode][p];
            strategyPeriod = period;
            strategyMax = sm[mode][p];
         }
      }
      infobox = infobox + "\nSymbol: " + symbol + ", Main Strategy is For Period: " + strategyPeriod + " is " + strategy 
      + " (" + get_strategy_name(strategy) + ") "
      + " with max value: " + strategyMax;
      val = iCustom(symbol, strategyPeriod, "cuSpan", strategy, 20, 4, 0);
      if (val != EMPTY_VALUE) {
         infobox = infobox + "\n<b>Symbol</b>: " + symbol + ", Pips Since 20 Days: " + val;
         pipsTotal = pipsTotal + val;
      }
      val = iCustom(symbol, strategyPeriod, "cuSpan", strategy, 100, 4, 0);
      if (val != EMPTY_VALUE) {
         infobox = infobox + "\n<b>Symbol</b>: " + symbol + ", Pips Since 100 Days: " + val;
      }
      val = iCustom(symbol, strategyPeriod, "cuSpan", strategy, 200, 4, 0);
      if (val != EMPTY_VALUE) {
         infobox = infobox + "\n<b>Symbol</b>: " + symbol + ", Pips Since 200 Days: " + val;
      }
      int check = get_strategy_result(strategy, symbol, strategyPeriod, 1, 0);
      int check2 = get_strategy_result(strategy, symbol, strategyPeriod, 1, 1);
      infobox = infobox + "\n<b>Symbol</b>: " + symbol + ", Current: " + check2 + ", Changed: " + check + "\n";
   } else {
      if (counter % 5 == 0) {
         for(p = 0; p < 5; p++) {
            period = periods[p];
            if (s[mode][p] > 0) {
               //infobox = infobox + "\nStrategy For Period: " + period + " is " + s[p] + " with max value: " + sm[p];
            } else {
               checked[mode][p] = 1;
               max = 0;
               for (int j = 1; j <= 25; j++) {
                     val = iCustom(symbol, period, "cuSpan", j, 500, 4, 0);
                     if (val > max && val != EMPTY_VALUE) {
                        max = val;
                        sm[mode][p] = max;
                        s[mode][p] = j;
                        //Print("Checking for period " + period + " sp: " + s[mode][p] + ", checked: " + checked[mode][p]);
                     }
               }
               //break;
            }
         }
      }
   }
}

