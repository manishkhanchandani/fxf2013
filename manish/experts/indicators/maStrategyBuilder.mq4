//+------------------------------------------------------------------+
//|                                            maStrategyBuilder.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Yellow
#property indicator_color2 Red
#include <3_signal_inc.mqh>
#include <i_indicators.mqh>
double CrossUp[];
double CrossDown[];
   int strategies[1000];
   int ordernumber = 0;
   string symbol;
   int period;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   symbol = Symbol();
   period = Period();
   ordernumber = 0;
   SetIndexStyle(0, DRAW_ARROW, EMPTY,2);
   SetIndexArrow(0, 233);
   SetIndexBuffer(0, CrossUp);
   SetIndexStyle(1, DRAW_ARROW, EMPTY,2);
   SetIndexArrow(1, 234);
   SetIndexBuffer(1, CrossDown);
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
   ordernumber = 0;
   FileDelete("strategybuilder.csv");
   int    counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   int fast_ema_period, slow_ema_period, signal_period;
   infobox = "\n";
   int price[7] = {PRICE_CLOSE, PRICE_OPEN, PRICE_HIGH, PRICE_LOW, PRICE_MEDIAN, PRICE_TYPICAL, PRICE_WEIGHTED};
   //string header = "\nOrder Number, Symbol, Time, Type, Size, Price, S/L, T/P, Closing Time, Closing Price, Swap, Profit";
   single_strategies_trailingstop();
   FileAppend("strategybuilder.csv", infobox);
   Comment(infobox);
   return (0);
  }
//+------------------------------------------------------------------+

int single_strategies_trailingstop()
{
   int fast_ema_period, slow_ema_period, signal_period;
   fast_ema_period = 12;
   slow_ema_period = 26;
   signal_period = 9;
   //string header = "\nOrder Number, Symbol, Time, Type, Size, Price, S/L, T/P, Closing Time, Closing Price, Swap, Profit";
   int ordertype = 0;
   double lotsize= 0.10;
   int cnt = 0;
   int cntBuy = 0;
   int cntSell = 0;
   int counter;
   double Range, AvgRange;
   int highest = iHighest(symbol,period,MODE_HIGH,WHOLE_ARRAY,0);
   int lowest = iLowest(symbol, period, MODE_LOW,WHOLE_ARRAY,0);
   double high = iHigh(symbol, period, highest);
   double low = iLow(symbol, period, lowest);
   double startprice, totalprofit, profit;
   infobox = infobox + "\nHigh: " + high + ", Low: " + low + ", Diff: " + DoubleToStr((high - low) / Point, 0);
   for(int i = Bars-2; i >= 0; i--) {
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      strategies[0] = strategyMacdCrossing(symbol, period, 
         fast_ema_period, slow_ema_period, signal_period, 
         PRICE_CLOSE, i+1);
      if (strategies[0] != 0) {
         if (ordertype != 0) {
            if (ordertype == 1) {
               profit = (iOpen(symbol, period, i) - startprice) / Point;
               if (profit >= 50) {
                  totalprofit = totalprofit + profit;
                  infobox = infobox + "\nOrder Type: " + ordertype;
                  infobox = infobox + "\nOrder Price: " + startprice;
                  infobox = infobox + "\nCurrent Price: " + iOpen(symbol, period, i);
                  infobox = infobox + "\nTotal Profit: " + profit;
                  startprice = 0;
                  ordertype = 0;
               }
            } else if (ordertype == -1) {
               profit = (startprice - iOpen(symbol, period, i)) / Point;
               if (profit >= 50) {
                  totalprofit = totalprofit + profit;
                  infobox = infobox + "\nOrder Type: " + ordertype;
                  infobox = infobox + "\nOrder Price: " + startprice;
                  infobox = infobox + "\nCurrent Price: " + iOpen(symbol, period, i);
                  infobox = infobox + "\nTotal Profit: " + profit;
                  startprice = 0;
                  ordertype = 0;
               }
            }
            /*if (ordertype == 1) {
               totalprofit = totalprofit + ((iOpen(symbol, period, i) - startprice) / Point);
               infobox = infobox + "\nTotal Profit: " + ((iOpen(symbol, period, i) - startprice) / Point);
               startprice = 0;
            } else if (ordertype == -1) {
               totalprofit = totalprofit + ((startprice - iOpen(symbol, period, i)) / Point);
               infobox = infobox + "\nTotal Profit: " + ((startprice - iOpen(symbol, period, i)) / Point);
               startprice = 0;
            }  */
            
         }
         if (ordertype == 0) {
            ordertype = strategies[0];
            if (strategies[0] == 1) {
               startprice = iOpen(symbol, period, i);
               startprice = startprice + (30 * Point);
            } else if (strategies[0] == -1) { 
               startprice = iOpen(symbol, period, i);
               startprice = startprice - (30 * Point);
            } 
         }
         cnt++;
         if (strategies[0] == 1) cntBuy++;
         if (strategies[0] == -1) cntSell++;
         if (strategies[0] == 1) {
            CrossUp[i] = Low[i] - Range*0.5;
         }
         else if (strategies[0] == -1) {
             CrossDown[i] = High[i] + Range*0.5;
         }
      }
         /*
      if (ordertype != 0) {
         infobox = infobox + "\n" + ordernumber + ", " + symbol + ", " + TimeToStr(iTime(symbol, period, i)) + 
            ", " + strategies[0] + ", " + lotsize + ", " + iOpen(symbol, period, i) + ", S/L, T/P, Closing Time, Closing Price, Swap, Profit";
         return (0);
      }
      if (strategies[0] != 0) {
         if (ordertype == 0) {
            ordertype = strategies[0]; 
            ordernumber++;
            infobox = infobox + "\n" + ordernumber + ", " + symbol + ", " + TimeToStr(iTime(symbol, period, i)) + 
            ", " + strategies[0] + ", " + lotsize + ", " + iOpen(symbol, period, i) + ", S/L, T/P, Closing Time, Closing Price, Swap, Profit";
            //return (0);
         }
      }*/
   }
   infobox = infobox + "\nMACD Cross: Cnt: " + cnt + ", BuyCnt: " + cntBuy + ", SellCnt: " + cntSell + ", Total Profit: "
      + totalprofit;
   return (0);
   strategies[1] = strategyMacdLineChange(symbol, period, 
         fast_ema_period, slow_ema_period, signal_period, 
         PRICE_CLOSE, i);
}

