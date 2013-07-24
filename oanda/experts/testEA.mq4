//+------------------------------------------------------------------+
//|                                                       EAmacd.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <3_signal_inc.mqh>
#include <strategies.mqh>
int opentime1;
extern double initialAmount = 0;
extern int percPerDay = 3;
double todaysPlan;

int middleman_strategy(string symbol)
{
   if (symbol == "EURJPY") return (3);
}
int middleman_period(string symbol)
{
   if (symbol == "EURJPY") return (PERIOD_M15);
}

int conditionClose(int i, string symbol)
{
   int condition = 0;
   int period = middleman_period(symbol);
   int strategy = middleman_strategy(symbol);
   condition = get_strategy_result(strategy, symbol, period, i, 0);
   infobox = infobox + ", condition: " + condition;
   return(condition);
}

int conditionOpen(int i, string symbol)
{  
   int condition = 0;
   int period = middleman_period(symbol);
   int strategy = middleman_strategy(symbol);
   condition = get_strategy_result(strategy, symbol, period, i, 0);
   infobox = infobox + ", condition: " + condition;
   return(condition);
}
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   start();
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
  
double s_history(int magicnum)
{
   int cnt;
   int total = OrdersHistoryTotal();
   double gtotal = 0;
   for(cnt=0;cnt<total;cnt++)
   {
      OrderSelect(cnt, SELECT_BY_POS, MODE_HISTORY);
      if (OrderMagicNumber()==magicnum) {
         gtotal += OrderProfit();
      }
   }
   return (gtotal);
}

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   if (opentime1 != iTime(Symbol(), Period(), 0)) {
   string symbol = Symbol();
   infobox = "";
   
   double history = s_history(magic);
   if (initialAmount == 0) initialAmount = AccountBalance();
   double total = initialAmount + history;
   double aim = (total * percPerDay/100);
   double lots = ((total / 100) * 0.5) / 100;
   if (lots < 0.01) lots = 0.01;
   lots = NormalizeDouble(lots, 2);
   infobox = infobox + "\nSymbol: " + symbol;
         infobox = infobox + ", Bid: " +
         MarketInfo(symbol, MODE_BID) + 
         ", Ask: " + MarketInfo(symbol, MODE_ASK) +
         ", Spread: " + MarketInfo(symbol, MODE_SPREAD);
            int i = 1;
            int x = 0;
            int action = 3;
            int close = conditionClose(i, symbol);
            if (close == -1) {
              CheckForCloseWithoutProfit(symbol, 1, magic, -1);
            } else if (close == 1) {
              CheckForCloseWithoutProfit(symbol, 1, magic, 1);
            }
            // check for open
            bool buy, sell;
            buy = true;
            sell = true;
            int open = conditionOpen(i, symbol);
            if (open == 1 && createneworders) {
               createorder(symbol, 1, lots, magic, "EA", 0, 0);
            } else if (open == -1 && createneworders) {
               createorder(symbol, -1, lots, magic, "EA", 0, 0);
            }
           double gtotal = openPositionTotal(symbol);
           infobox = StringConcatenate(infobox, "\nProfit for Open Position For Symbol: " + symbol +
   " is: " + DoubleToStr(gtotal, 2)); 
           Comment(infobox);
           opentime1 = iTime(Symbol(), Period(), 0);
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+


