//+------------------------------------------------------------------+
//|                                                    predictea.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <stdlib.mqh>
#include <WinUser32.mqh>
extern bool createorders = true;
extern double lots = 1.00;
extern int maxorders = 1;
extern int MAGICMA = 1234;
extern bool strategy_25 = false;
extern bool strategy_25_2 = true;
//extern bool strategy_key_simplicity = false;
double build = 1.2;
double PrevTime;
double OpenTime;
   int result = 0;
   string message;
   string colors;
   double range;

//some vars
double min = 0;
double max = 0;
double tp, sl;
double twentyfivepercent, tenpercent, hundredpips;
string prediction;
string message1;
double sl_price;
double prev_mom = 0;
double prev_mom2 = 0;
double prev_mom3 = 0;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   Print("Strategy started");
   if (strategy_25) {
      //PrevTime = Time[0];
   }
   
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
   custom_start();
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

void custom_start()
{
   //if (MarketInfo(Symbol(), MODE_SPREAD) > 10) {
      //Print(Symbol(), ", market spread is more than 10: ", MarketInfo(Symbol(), MODE_SPREAD));
      //return (0);
   //}

   if (strategy_25) {
      strategy_25();
   } else if (strategy_25_2) {
      strategy_25_2();
   }
   /* else if (strategy_key_simplicity) {
      if (Period() != PERIOD_M1) {
         Comment("This strategy works in 1 minute only");
         return (0);
      }
      strategy_key_simplicity();
   }*/

   return (0);
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
   }
}

int CalculateCurrentMaxOrders()
  {
   int corders=0;
//----
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderMagicNumber()==MAGICMA)
        {
         if(OrderType()==OP_BUY || OrderType()==OP_SELL)
            corders++;
        }
     }
         return(corders);
}


int CalculateCurrentOrders(string symbol)
  {
   int cnt=0;
//----
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==symbol && OrderMagicNumber()==MAGICMA)
        {
         cnt++;
        }
     }
   return (cnt);
  }
  
int create_orders(string symbol, int type, string mes, double tp, double sl)
{
   if (!createorders) {
      Print(StringConcatenate(symbol, ", create orders disabled"));
      return (0);
   }
   if (type == 0) {
      Print(StringConcatenate(symbol, ", no orders processed as buy and sell condition does not exists for ", mes));
      return (0);
   }
   
   int morders = CalculateCurrentMaxOrders();
   if (morders >= maxorders) {
      Print(StringConcatenate("Max Orders Reached for symbol ", symbol));
      return (0);
   }
   int orders = CalculateCurrentOrders(symbol);
   if (orders > 0) {
      Print(StringConcatenate("Order Already created for symbol ", symbol));
      return (0);
   }
   int ticket;
   int error;
   sl_price = 0;
   
   prev_mom = 0;
   prev_mom2 = 0;
   prev_mom3 = 0;

   if (type == 1) {
      sl_price = Bid - (1000 * Point);
      mes = StringConcatenate("Predict, ", mes, ", B: ", build);
      ticket=OrderSend(symbol,OP_BUY,lots,MarketInfo(symbol,MODE_ASK),3,sl,tp,mes,MAGICMA,0,CLR_NONE);
      if(ticket<1)
      {
         error=GetLastError();
         Alert("Error = ",ErrorDescription(error));
         return (0);
      }
      Alert("Buy order created for symbol: ", symbol);
      OrderPrint();
   } else if (type == -1) {
      sl_price = Ask + (1000 * Point);
      mes = StringConcatenate("Predict, ", mes, ", B: ", build);
      ticket=OrderSend(symbol,OP_SELL,lots,MarketInfo(symbol,MODE_BID),3,sl,tp,mes,MAGICMA,0,CLR_NONE);
      if(ticket<1)
      {
         error=GetLastError();
         Alert("Error = ",ErrorDescription(error));
         return (0);
      }
      Alert("Sell order created for symbol: ", symbol);
      OrderPrint();
   }
}


//strategy 25 percent
int strategy_25_result()
{
   if (Open[0] != OpenTime) {
      result = 0;
      Checkforclose_25();
   }
   double standard_diff10 = 10 * Point;
   //double standard_diff = totalmove / 10;
   double high, low, cur_high, cur_low, totalmove;
   high = High[1];
   low = Low[1];
   totalmove = high - low;
   twentyfivepercent = totalmove / (100/25);
   tenpercent = totalmove / 10;
   hundredpips = Point * 100;
   //cur_high = High[0];
   //cur_low = Low[0];
   //totalmove_cur = cur_high - cur_low;
   //twentyfivepercent_cur = totalmove_cur / 4;
   //double standard_diff = twentyfivepercent_cur;
   double diff_high = High[0] - Open[0];
   double diff_low = Open[0] - Low[0];
   //if ((totalmove / Point) < 100) {
      //result = 0;
   //} else 
   if (
      //diff_high > tenpercent && 
      Bid < Open[0] && 
      (Open[0] - Low[0]) > hundredpips
      && diff_high > 0
   ) {
      result = -1;
   } else if (
      //diff_low > tenpercent && 
      Bid > Open[0] && (High[0] - Open[0]) > hundredpips
      && diff_low > 0
      ) {
      result = 1;
   } 
   Comment("\n\nBest Used in Day Chart or 4 Hour Chart",
   "\nDiff High: ", DoubleToStr(diff_high, Digits),
   "\nDiff Low: ", DoubleToStr(diff_low, Digits),
   "\ndiff_high > tenpercent: ", (diff_high > tenpercent),
   "\nBid < Open[0] ", (Bid < Open[0]),
   "\n(Open[0] - Low[0]) > twentyfivepercent: ", ((Open[0] - Low[0]) > twentyfivepercent),
   "\n\ndiff_low > tenpercent: ", (diff_low > tenpercent),
   "\nBid > Open[0], ", (Bid > Open[0]),
   "\n(High[0] - Open[0]) > twentyfivepercent, ", ((High[0] - Open[0]) > twentyfivepercent),
   "\n\nResult: ", result,
   "\n\nCurrent Ask Price: ", DoubleToStr(Ask, Digits),
   "\nCurrent Bid Price: ", DoubleToStr(Bid, Digits),
   "\nCurrent Open Price: ", DoubleToStr(Open[0], Digits),
   "\nPrevious High Price: ", DoubleToStr(high, Digits),
   "\nPrevious Low Price: ", DoubleToStr(low, Digits),
   "\nExpected Pips: ", DoubleToStr(twentyfivepercent, Digits),
   "\nhundredpips: ", DoubleToStr(hundredpips, Digits),
   "\nPrevious Total Move: ", DoubleToStr(totalmove, Digits),
   "\n\nCurrent Buy Price Guess: ", DoubleToStr(Open[0] + hundredpips, Digits),
   "\nCurrent Buy TP Guess: ", DoubleToStr(Open[0] + twentyfivepercent + twentyfivepercent, Digits),
   "\nCurrent Sell Price Guess: ", DoubleToStr(Open[0] - hundredpips, Digits),
   "\nCurrent Sell TP Guess: ", DoubleToStr(Open[0] - (twentyfivepercent + twentyfivepercent), Digits),
   "\nTotal Move Points: ", (totalmove / Point),
   "\n", message1,
   "\n\n"
   

   );
   return (result);
}

int strategy_25_2_result(int trend, double mom)
{
   result = 0;
   double high, low, totalmove;
   high = High[0];
   low = Low[0];
   totalmove = high - low;
   if ((totalmove / Point) < 100) {
      result = 0;
   } else {
      result = trend;
   }
   Comment("\n\nBest Used in 1 min chart",
   "\nHigh: ", DoubleToStr(high, Digits),
   "\nLow: ", DoubleToStr(low, Digits),
   "\nTotal Move: ", DoubleToStr(totalmove, Digits),
   "\nmom: ", DoubleToStr(mom, Digits),
   "\nprev_mom: ", DoubleToStr(prev_mom, Digits),
   "\nprev_mom2: ", DoubleToStr(prev_mom2, Digits),
   "\nprev_mom3: ", DoubleToStr(prev_mom3, Digits),
   "\n\nResult: ", result,
   "\n\nCurrent Ask Price: ", DoubleToStr(Ask, Digits),
   "\nCurrent Bid Price: ", DoubleToStr(Bid, Digits),
   "\nCurrent Open Price: ", DoubleToStr(Open[0], Digits),
   "\nTotal Move Points: ", (totalmove / Point),
   "\ntrend: ", trend,
   "\n", message1,
   "\n\n"
   

   );
   return (result);
}
void strategy_25()
{
   
   Comment("");
   int res = strategy_25_result();
   if (Open[0] != OpenTime) {
      Print(Symbol(), ", New Time Start");
      OpenTime = Open[0];
      prediction = "";
   }
   /*
   double standard_diff10 = 10 * Point;
   //double standard_diff = totalmove / 10;
   string name = "predict_"+Time[0];
   string name2 = "predict2_"+Time[0];
   ObjectDelete(name);
   double high, low, cur_high, cur_low, totalmove, twentyfivepercent, totalmove_cur, twentyfivepercent_cur, tenpercent;
   high = High[1];
   low = Low[1];
   totalmove = high - low;
   twentyfivepercent = totalmove / (100/30);
   tenpercent = totalmove / 10;
   cur_high = High[0];
   cur_low = Low[0];
   totalmove_cur = cur_high - cur_low;
   twentyfivepercent_cur = totalmove_cur / 4;
   double standard_diff = twentyfivepercent_cur;
   double diff_high = High[0] - Open[0];
   double diff_low = Open[0] - Low[0];
   //Alert("Diff High: ", DoubleToStr(diff_high, Digits), ", Diff Low: ", DoubleToStr(diff_low, Digits));
   */
   if (res == 0) {      
   } else if (
      res == -1 && Time[0] != PrevTime
   ) {
      prediction = "Sell";
      PrevTime = Time[0];
      tp = 0; //Bid - (twentyfivepercent);
      sl = 0; //Bid + (twentyfivepercent * 2);
      create_orders(Symbol(), res, TimeframeToString(Period()), tp, sl);
   } else if (
      res == 1 && Time[0] != PrevTime
      ) {
      prediction = "Buy";
      PrevTime = Time[0];
      tp = 0; //Bid + (twentyfivepercent);
      sl = 0; //Bid - (twentyfivepercent * 2);
      create_orders(Symbol(), res, TimeframeToString(Period()), tp, sl);
      
   }   
   Checkforclose_25_2(res);
}


void strategy_25_2()
{
   
   int trend = 0;
   double mom = iMomentum(NULL,0,14,PRICE_CLOSE,0);
   if (mom > prev_mom && prev_mom > prev_mom2 && prev_mom2 > prev_mom3) {
      trend = 1;
   } else if (mom < prev_mom && prev_mom < prev_mom2 && prev_mom2 < prev_mom3) {
      trend = -1;
   } 
   if (prev_mom3 > 0) {
      prev_mom3 = prev_mom2;
   }
   if (prev_mom2 > 0) {
      prev_mom2 = prev_mom;
   }
   if (prev_mom > 0) {
      prev_mom = mom;
   }
   if (prev_mom == 0) prev_mom = mom;
   if (prev_mom2 == 0) prev_mom2 = mom;
   if (prev_mom3 == 0) prev_mom3 = mom;
   Comment("");
   prediction = "";
   int res = strategy_25_2_result(trend, mom);
   //if (Open[0] != OpenTime) {
      //Print(Symbol(), ", New Time Start");
      //OpenTime = Open[0];
      
   //}
   if (res == 0) {      
   } else if (
      res == -1
   ) {
      prediction = "Sell";
      PrevTime = Time[0];
      tp = 0; //Bid - (twentyfivepercent);
      sl = 0; //Bid + (twentyfivepercent * 2);
      create_orders(Symbol(), res, TimeframeToString(Period()), tp, sl);
   } else if (
      res == 1
      ) {
      prediction = "Buy";
      PrevTime = Time[0];
      tp = 0; //Bid + (twentyfivepercent);
      sl = 0; //Bid - (twentyfivepercent * 2);
      create_orders(Symbol(), res, TimeframeToString(Period()), tp, sl);
      
   }   
   Checkforclose_25_2a(res, trend);
}


void Checkforclose_25()
{
   return (0);
   int i;
   for(i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
      if(OrderType()==OP_BUY && OrderProfit() > 0) {
         OrderClose(OrderTicket(),OrderLots(),Bid,3,White);
      } else if(OrderType()==OP_SELL && OrderProfit() > 0) {
         OrderClose(OrderTicket(),OrderLots(),Ask,3,White);
      }
   }

   
}


void Checkforclose_25_2(int res)
{
   message1 = "";
   double diff, amt, diffamt, diff2, diff4;
   int i;
   for(i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
      message1 = StringConcatenate(message1, "OrderProfit(): ", OrderProfit());
      if(OrderType()==OP_BUY && Bid < sl_price && sl_price > 0) {
         OrderClose(OrderTicket(),OrderLots(),Bid,3,White);
         prev_mom = 0;
         prev_mom2 = 0;
         prev_mom3 = 0;
      } else if(OrderType()==OP_SELL && Ask > sl_price && sl_price > 0) {
         OrderClose(OrderTicket(),OrderLots(),Ask,3,White);
         prev_mom = 0;
         prev_mom2 = 0;
         prev_mom3 = 0;
      }
      if (OrderProfit() > 0) {
         if(OrderType()==OP_BUY) {
            diff = Bid - OrderOpenPrice();
            diff2 = diff/Point;
            diff4 = Bid - (100 * Point);
            if (sl_price == 0) {
               sl_price = Bid - (1000 * Point);
            }
            if (diff2 > 200 && amt > sl_price) {
               sl_price = Bid - (100 * Point);
            }
         } else if(OrderType()==OP_SELL) {
            diff = OrderOpenPrice() - Ask;
            diff2 = diff/Point;
            diff4 = Ask + (100 * Point);
            if (sl_price == 0) {
               sl_price = Ask + (1000 * Point);
            }
            if (diff2 > 200 && amt < sl_price) {
               sl_price = Ask + (100 * Point);
            }
         } 
         message1 = StringConcatenate(message1, "\ndiff: ", DoubleToStr(diff, Digits));
         message1 = StringConcatenate(message1, "\ndiff2: ", diff2);
         message1 = StringConcatenate(message1, "\nsl_price: ", DoubleToStr(sl_price, Digits));
      }
   }

   
}

void Checkforclose_25_2a(int res, int trend)
{
   message1 = "";
   double diff, amt, diffamt, diff2, diff4;
   int i;
   for(i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
      message1 = StringConcatenate(message1, "OrderProfit(): ", OrderProfit());
      if(OrderType()==OP_BUY && Bid < sl_price && sl_price > 0) {
         OrderClose(OrderTicket(),OrderLots(),Bid,3,White);
         prev_mom = 0;
         prev_mom2 = 0;
         prev_mom3 = 0;
      } else if(OrderType()==OP_SELL && Ask > sl_price && sl_price > 0) {
         OrderClose(OrderTicket(),OrderLots(),Ask,3,White);
         prev_mom = 0;
         prev_mom2 = 0;
         prev_mom3 = 0;
      }
      if (OrderProfit() > 0) {
         if(OrderType()==OP_BUY) {
            diff = Bid - OrderOpenPrice();
            diff2 = diff/Point;
            diff4 = Bid - (100 * Point);
            if (sl_price == 0) {
               sl_price = Bid - (1000 * Point);
            }
            if (diff2 > 200 && amt > sl_price) {
               sl_price = Bid - (100 * Point);
            }
            if (trend == -1) {
               OrderClose(OrderTicket(),OrderLots(),Bid,3,White);
               prev_mom = 0;
               prev_mom2 = 0;
               prev_mom3 = 0;
            }
         } else if(OrderType()==OP_SELL) {
            diff = OrderOpenPrice() - Ask;
            diff2 = diff/Point;
            diff4 = Ask + (100 * Point);
            if (sl_price == 0) {
               sl_price = Ask + (1000 * Point);
            }
            if (diff2 > 200 && amt < sl_price) {
               sl_price = Ask + (100 * Point);
            }
            if (trend == 1) {
               OrderClose(OrderTicket(),OrderLots(),Ask,3,White);
               prev_mom = 0;
               prev_mom2 = 0;
               prev_mom3 = 0;
            }
         } 
         message1 = StringConcatenate(message1, "\ndiff: ", DoubleToStr(diff, Digits));
         message1 = StringConcatenate(message1, "\ndiff2: ", diff2);
         message1 = StringConcatenate(message1, "\nsl_price: ", DoubleToStr(sl_price, Digits));
      }
   }

   
}
/*

//strategy_key_simplicity (Key Simplicity)
//http://forex-strategies-revealed.com/trading-strategy-keysimplicity
void strategy_key_simplicity()
{
   Comment("");
   double emaP5 = iMA(NULL,PERIOD_M5,700,0,MODE_EMA,PRICE_CLOSE,1);
   double ema2P5 = iMA(NULL,PERIOD_M5,110,0,MODE_EMA,PRICE_CLOSE,1);
   double ema = iMA(NULL,0,700,0,MODE_EMA,PRICE_CLOSE,1);
   double ema_1 = iMA(NULL,0,700,0,MODE_EMA,PRICE_CLOSE,2);
   double ema2 = iMA(NULL,0,110,0,MODE_EMA,PRICE_CLOSE,1);
   double ema2_1 = iMA(NULL,0,110,0,MODE_EMA,PRICE_CLOSE,2);
   string inference = "";
   if (emaP5 > ema2P5) {
      inference = "Sell";
   } else if (emaP5 < ema2P5) {
      inference = "Buy";
   }
   if (Low[2] < ema_1 && Low[1] > ema && ema2 > ema2_1 && emaP5 < ema2P5)
      {
         //buy
         if(Time[0] != PrevTime) {
           Alert(Symbol(), ", symbol, Buy"); 
           PrevTime = Time[0];
           message = "Buy";
           result = 1;
           tp = Ask + (90 * Point);
           sl = Ask - (1000 * Point);
           create_orders(Symbol(), result, TimeframeToString(Period()), tp, sl);
         }
      }
   else if (High[2] > ema_1 && High[1] < ema && ema2 < ema2_1 && emaP5 > ema2P5)
      {
         //sell
         if(Time[0] != PrevTime) {
           Alert(Symbol(), ", symbol, Sell"); 
           PrevTime = Time[0];
           message = "Sell";
           result = -1;
           tp = Bid - (90 * Point);
           sl = Bid + (1000 * Point);
           create_orders(Symbol(), result, TimeframeToString(Period()), tp, sl);
         }
      }
   Comment("\n\nPicking Tops and Bottoms",
   "\nhttp://forex-strategies-revealed.com/advanced/picking-tops-and-bottoms",
   "\nCurrent Ask Price: ", DoubleToStr(Ask, Digits),
   "\nCurrent Bid Price: ", DoubleToStr(Bid, Digits),
   "\nema: ", DoubleToStr(ema, Digits),
   "\nema_1: ", DoubleToStr(ema_1, Digits),
   "\nema2: ", DoubleToStr(ema2, Digits),
   "\nema2_1: ", DoubleToStr(ema2_1, Digits),
   "\nemaP5: ", DoubleToStr(emaP5, Digits),
   "\nema2P5: ", DoubleToStr(ema2P5, Digits),
   "\n\nStatus: ", message,
   "\nInference: ", inference,
   "\n\n");
}
*/