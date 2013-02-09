//+------------------------------------------------------------------+
//|                                                     ticktick.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

double start_price = 0.0;
double max_price = 0.0;
double min_price = 0.0;
double buy_count_price = 0.0;
double sell_count_price = 0.0;
double current_price = 0.0;
double loss, gain, rsi;
string message = "Calculating....";
int buy_tick = 0;
int sell_tick = 0;
//int mode = 0;
//int previous_mode = 0;
//string history;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   start_price = Bid;
   max_price = Bid;
   min_price = Bid;
   current_price = Bid;
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
   string infobox;
   /*if (Bid > start_price) {
      mode = 1;
   } else if (start_price > Bid) {
      mode = -1;
   }
   
   if (previous_mode != mode) {
      reset();
   }*/

   if (Bid > current_price) {
      buy_tick++;
      buy_count_price = buy_count_price + (Bid - current_price);
   }
   if (Bid < current_price) {
      sell_tick++;
      sell_count_price = sell_count_price + (current_price - Bid);
   }
   if (Bid > max_price) {
      max_price = Bid;
   }
   if (Bid < min_price) {
      min_price = Bid;
   }
   current_price = Bid;
   gain = buy_count_price / buy_tick;
   loss = sell_count_price / sell_tick;
   rsi = 100 - (100 * (loss / (gain + loss)));
   if (sell_tick > 5 || buy_tick > 5) {
      if (rsi > 70) {
         message = "Possible Sell Condition.";
         Alert(Symbol(), ": ", TimeToStr(TimeCurrent()), " - ", message);
      } else if (rsi < 30) {
         message = "Possible Buy Condition.";
         Alert(Symbol(), ": ", TimeToStr(TimeCurrent()), " - ", message);
      } else {
         message = "Consolidated";
      }
   }
   Comment("\n\nAsk: ", DoubleToStr(Ask, Digits),
   "\nBid: ", DoubleToStr(Bid, Digits),
   "\nStart Price: ", DoubleToStr(start_price, Digits),
   "\nCurrent Price: ", DoubleToStr(current_price, Digits),
   "\nBuy Count Price: ", DoubleToStr(buy_count_price, Digits),
   "\nSell Count Price: ", DoubleToStr(sell_count_price, Digits),
   "\nBuy Tick Count: ", buy_tick,
   "\nSell Tick Count: ", sell_tick,
   "\nMax Price: ", DoubleToStr(max_price, Digits),
   "\nMin Price: ", DoubleToStr(min_price, Digits),
   "\nGain: ", DoubleToStr(gain, Digits),
   "\nLoss: ", DoubleToStr(loss, Digits),
   "\nRSI: ", DoubleToStr(rsi, Digits),
   "\nMessage: ", message//,
   //"\nCurrent Mode: ", mode,
   //"\nPrevious Mode: ", previous_mode,
   //"\n\n", history
   );
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
/*
void reset()
{
   if (previous_mode != 0) {
      string message = StringConcatenate("Ask: ", DoubleToStr(Ask, Digits),
      ", Bid: ", DoubleToStr(Bid, Digits),
      ", Start Price: ", DoubleToStr(start_price, Digits),
      ", Current Price: ", DoubleToStr(current_price, Digits),
      ", Buy Count Price: ", DoubleToStr(buy_count_price, Digits),
      ", Sell Count Price: ", DoubleToStr(sell_count_price, Digits),
      ", Buy Tick Count: ", buy_tick,
      ", Sell Tick Count: ", sell_tick,
      ", Max Price: ", DoubleToStr(max_price, Digits),
      ", Min Price: ", DoubleToStr(min_price, Digits),
      ", Current Mode: ", mode,
      ", Previous Mode: ", previous_mode,
      "\n");
      history = StringConcatenate(message, history);
   }
   previous_mode = mode;

   max_price = Bid;
   min_price = Bid;
   buy_count_price = 0.0;
   sell_count_price = 0.0;
   current_price = Bid;
   buy_tick = 0;
   sell_tick = 0;
}*/

