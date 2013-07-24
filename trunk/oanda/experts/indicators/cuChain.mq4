//+------------------------------------------------------------------+
//|                                                      cuChain.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#include <strategies.mqh>

#define maxStrategy 30
int startBuy;
int startSell;
int startCurrentBuy;
int startCurrentSell;
int chainBuy[maxStrategy];
int chainSell[maxStrategy];
int chainCurrentBuy[maxStrategy];
int chainCurrentSell[maxStrategy];
int chainBuyOrder[maxStrategy];
int chainSellOrder[maxStrategy];
int chainCurrentBuyOrder[maxStrategy];
int chainCurrentSellOrder[maxStrategy];
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
   int    counted_bars=IndicatorCounted();
//----
   if (opentime != Time[0]) {
      string infobox = "";
      int j, check;
      for (j = 1; j <= 28; j++) {
         check = get_strategy_result(j, Symbol(), Period(), 1, 1);
         if (check == 1) {
            addStrategyCurrentBuy(j);
         } else if (check == -1) {
            addStrategyCurrentSell(j);
         }
      }
      infobox = infobox + "\nCurrent Buy ";
      for (j = 0; j < ArraySize(chainBuyOrder); j++) {
         if (chainBuyOrder[j] == 0) continue;
         infobox = infobox + " => " + get_strategy_name(chainBuyOrder[j]) + " (" + chainBuyOrder[j] + ")";
         if (j % 5 == 0) {
            infobox = infobox + "\n";
         }
      }
      infobox = infobox + "\n\nCurrent Sel ";
      for (j = 0; j < ArraySize(chainSellOrder); j++) {
         if (chainSellOrder[j] == 0) continue;
         infobox = infobox + " => " + get_strategy_name(chainSellOrder[j]) + " (" + chainSellOrder[j] + ")";
         if (j % 5 == 0) {
            infobox = infobox + "\n";
         }
      }
      startCurrentBuy = 0;
      startCurrentSell = 0;
      for (j = 0; j < 28; j++) {
         chainBuyOrder[j] = 0;
         chainSellOrder[j] = 0;
      }
      Comment(infobox);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+

int addStrategyCurrentBuy(int strategy)
{
   startCurrentBuy++;
   chainCurrentBuy[strategy] = strategy;
   chainBuyOrder[startCurrentBuy] = strategy;
}
int addStrategyCurrentSell(int strategy)
{
   startCurrentSell++;
   chainCurrentSell[strategy] = strategy;
   chainSellOrder[startCurrentSell] = strategy;
}