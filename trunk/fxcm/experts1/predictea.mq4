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
extern double lots = 0.10;
extern int maxorders = 1;
extern int MAGICMA = 1234;
extern bool strategy_25 = false;
extern bool strategy_key_simplicity = true;
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
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   if (strategy_25) {
      PrevTime = Time[0];
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
   } else if (strategy_key_simplicity) {
      if (Period() != PERIOD_M1) {
         Comment("This strategy works in 1 minute only");
         return (0);
      }
      strategy_key_simplicity();
   }

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
   if (type == 1) {
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

//strategy 25 percent
void strategy_25()
{
   
   Comment("");
   if (Open[0] != OpenTime) {
      Print(Symbol(), ", New Time Start");
      message = "";
      result = 0;
      OpenTime = Open[0];
      Checkforclose_25();
   }
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
   if ((totalmove / Point) < 100) {
      message = "NA";
   } else if (
      diff_high > tenpercent && Bid < Open[0] && (Open[0] - Low[0]) > twentyfivepercent 
      && message == ""
   ) {
      if(Time[0] != PrevTime) {
        Alert(Symbol(), ", symbol, sell"); 
        PrevTime = Time[0];
        message = "Sell";
        result = -1;
        tp = Bid - (twentyfivepercent);
        sl = Bid + (twentyfivepercent * 2);
        create_orders(Symbol(), result, TimeframeToString(Period()), tp, sl); //tp = Bid - twentyfivepercent_cur, sl = Open[0] + twentyfivepercent_cur
      }
   } else if (
      diff_low > tenpercent && Bid > Open[0] && (High[0] - Open[0]) > twentyfivepercent
      && message == ""
      ) {
      if(Time[0] != PrevTime) {
        Alert(Symbol(), ", symbol, buy"); 
        PrevTime = Time[0];
        message = "Buy";
        result = 1;
        tp = Ask + (twentyfivepercent);
        sl = Ask - (twentyfivepercent * 2);
        create_orders(Symbol(), result, TimeframeToString(Period()), tp, sl);//tp = Ask + twentyfivepercent_cur, sl = Open[0] - twentyfivepercent_cur;
      }
   } 
   if (result == 1) {
      colors = "Green";
   } else if (result == -1) {
      colors = "Red";
   } else {
      colors = "Blue";
   }
   
   Comment("\n\nBest Used in Day Chart",
   "\nCurrent Ask Price: ", DoubleToStr(Ask, Digits),
   "\nCurrent Bid Price: ", DoubleToStr(Bid, Digits),
   "\nCurrent Open Price: ", DoubleToStr(Open[0], Digits),
   "\nPrevious High Price: ", DoubleToStr(high, Digits),
   "\nPrevious Low Price: ", DoubleToStr(low, Digits),
   "\nExpected Pips: ", DoubleToStr(twentyfivepercent, Digits),
   "\nPrevious Total Move: ", DoubleToStr(totalmove, Digits),
   "\n\nCurrent Buy Price Guess: ", DoubleToStr(Open[0] + twentyfivepercent, Digits),
   "\nCurrent Buy TP Guess: ", DoubleToStr(Open[0] + twentyfivepercent + twentyfivepercent, Digits),
   "\nCurrent Sell Price Guess: ", DoubleToStr(Open[0] - twentyfivepercent, Digits),
   "\nCurrent Sell TP Guess: ", DoubleToStr(Open[0] - (twentyfivepercent + twentyfivepercent), Digits),
   "\nTotal Move Points: ", (totalmove / Point),
   "\n\nStatus: ", message,
   "\n\n"
   

   );
}

void Checkforclose_25()
{
   int i;
   for(i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
      if(OrderType()==OP_BUY) {
         OrderClose(OrderTicket(),OrderLots(),Bid,3,White);
      } else if(OrderType()==OP_SELL) {
         OrderClose(OrderTicket(),OrderLots(),Ask,3,White);
      }
   }

   
}