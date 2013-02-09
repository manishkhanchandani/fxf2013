//+------------------------------------------------------------------+
//|                                            11_ichimokuhelper.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"
#define MAGICMA  1974060511

extern double build = 1.2;
extern int master_number = 0;
extern int maxorders = 3;
extern double lots = 0.03;
extern bool disable_stop_loss = false;
extern bool disable_take_profit = false;
extern bool UseAlerts = true;
extern bool UseEmailAlerts = false;
extern bool UsePrintAlerts = true;
extern bool createorders = false;
extern bool logs = false;

double stop_loss;
double take_profit;
double buffer_order;
double sl;
double tp;
double tenkan_sen[100];
double kijun_sen[100];
double senkou_span_a[100];
double senkou_span_b[100];
double senkou_span_high[100];
double senkou_span_low[100];
double chinkou_span[100];
double chinkou_span_mode[100];
int max_number = 5;
string localbox;
string infobox;
string current_trend;
int counter, bearish, bullish;
double base_level, base_level_diff, previous_reading;
int alligator_previous_condition = 0;
int order_counter = 0;
string per;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   base_level = Ask;
   base_level_diff = Ask;
   per = TimeframeToString(Period());
   if (!(Period() == PERIOD_M30 || Period() == PERIOD_H1)) {
      Alert("Create orders will work only in 30 min and 1 hour time frame.");
      createorders = false;
   }
   //custom_start();
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
   if (logs) Print(", Ask: ", Ask, ", Bid: ", Bid);
   int i;
   infobox = "\n\n";
   infobox = StringConcatenate(infobox, "Number: ", master_number);
   int result;
   int tmpresult;
   int order_signal = 0;
   int order_signal_strength_buy = 0;
   int order_signal_strength_sell = 0;
   //switch (strategy) {
      //case  1: //ts_ks_cross
      //default:
         ichimoku(master_number);
         infobox = StringConcatenate(infobox, "\n", localbox);
         //ts_ks_cross
         tmpresult = ts_ks_cross(master_number);
         if (tmpresult != 0) {
            result = tmpresult;
         }
         infobox = StringConcatenate(infobox, "\n", localbox);
         //kijun_sen_cross
         tmpresult = kijun_sen_cross(master_number);
         if (tmpresult != 0) {
            result = tmpresult;
         }
         infobox = StringConcatenate(infobox, "\n", localbox);
         //kumo breakout
         tmpresult = kumo_breakout(master_number);
         if (tmpresult != 0) {
            result = tmpresult;
         }
         if (result != 0) {
            order_signal = result;
         }
         infobox = StringConcatenate(infobox, "\n", localbox);
         //Senkou Span Cross
         tmpresult = senkou_span_cross(master_number);
         //order creation checking
         if (tmpresult != 0) {
            if (tmpresult < 0) {
               order_signal_strength_sell++;
            } else if (tmpresult > 0) {
               order_signal_strength_buy++;
            }
         }
         infobox = StringConcatenate(infobox, "\n", localbox);
         if (chinkou_span_mode[master_number] != 0) {
            if (chinkou_span_mode[master_number] < 0) {
               order_signal_strength_sell++;
            } else if (chinkou_span_mode[master_number] > 0) {
               order_signal_strength_buy++;
            }
         }
         //Alligator
         tmpresult = alligator(master_number);
         if (tmpresult != 0) {
            if (tmpresult < 0) {
               order_signal_strength_sell++;
            } else if (tmpresult > 0) {
               order_signal_strength_buy++;
            }
         }
         if (alligator_previous_condition != tmpresult) {
            result = tmpresult;
         }
         infobox = StringConcatenate(infobox, "\n", localbox);
         if (result != 0) {
            //SendAlert(infobox);
         }
         getrecord();
         infobox = StringConcatenate(infobox, "\n\n", localbox);
         Comment(infobox);
         //break;
   //}

   if(Bars<100 || IsTradeAllowed()==false) {
      if (logs) Print("bars: ", Bars, ", Trade Allowed: ", IsTradeAllowed(),", so stopping the EA");
      return;
   }
   
   CheckForOpen(order_signal, order_signal_strength_buy, order_signal_strength_sell);
}


void getrecord()
{
   string demo;
   if(IsDemo()) demo = "Demo Account";
   else demo = "Live Account";
   /*if (Ask > previous_reading) {
      counter++;
   }
   if (Ask < previous_reading) {
      counter--;
   }
 
   if (counter > 20) {
      current_trend = "Bullish";
      counter = 0;
      bullish++;
      bearish = 0;
   } else if (counter < -20) {
      current_trend = "Bearish";
      counter = 0;
      bearish++;
      bullish = 0;
   }*/
   base_level_diff = Ask - base_level;
   localbox = StringConcatenate(
   "Account Type: ", demo, "\n",
   //"Counter: ", counter, "\n",
   //"Current Trend: ", current_trend, "\n",
   //"Bullish: ", bullish, "\n",
   //"Bearish: ", bearish, "\n",
   "Base Level: ", DoubleToStr(base_level,Digits), "\n",
   "New Level (Positive means buy, Negative means Sell): ", DoubleToStr(base_level_diff,Digits), "\n",
   "Current Ask Reading: ", DoubleToStr(Ask,Digits),
      "\n",
      "Current Bid Reading: ", DoubleToStr(Bid,Digits),
      "\n",
      "Current High: ", DoubleToStr(High[0],Digits),
      "\n",
      "Current Low: ", DoubleToStr(Low[0],Digits),
      "\n",
      "Previous High: ", DoubleToStr(High[1],Digits),
      "\n",
      "Previous Low: ", DoubleToStr(Low[1],Digits),
      "\n",
      "Previous Previous High: ", DoubleToStr(High[2],Digits),
      "\n",
      "Previous Previous Low: ", DoubleToStr(Low[2],Digits));
}

int chinkou_span_mode(int number, double cs)
{
   double high,low;
   high = High[number];
   low = Low[number];
   if (cs >= high){
      localbox = StringConcatenate("Symbol: ", Symbol(), ", (chinkou_span_mode) Chinkou Span is in Buy Mode. ");
      return (1);
   } else if (cs <= low){
      localbox = StringConcatenate("Symbol: ", Symbol(), ", (chinkou_span_mode) Chinkou Span is in Sell Mode. ");
      return (-1);
   } else {
      localbox = StringConcatenate("Symbol: ", Symbol(), ", (chinkou_span_mode) Chinkou Span is in Neutral Mode. ");
     return (0);
   }
}
//strategies
void ichimoku(int num)
{
   int Tenkan=9;
   int Kijun=26;
   int Senkou=52;
   
   for (int i = num; i <= (num + max_number); i++) {
      tenkan_sen[i] = iIchimoku(NULL, 0, Tenkan, Kijun, Senkou, MODE_TENKANSEN, i);
      kijun_sen[i] = iIchimoku(NULL, 0, Tenkan, Kijun, Senkou, MODE_KIJUNSEN, i);
      senkou_span_a[i] = iIchimoku(NULL, 0, Tenkan, Kijun, Senkou, MODE_SENKOUSPANA, i);
      senkou_span_b[i] = iIchimoku(NULL, 0, Tenkan, Kijun, Senkou, MODE_SENKOUSPANB, i);
      if (senkou_span_a[i] >= senkou_span_b[i]) {
         senkou_span_high[i] = senkou_span_a[i];
         senkou_span_low[i] = senkou_span_b[i];
      } else if(senkou_span_a[i] <= senkou_span_b[i]) {
         senkou_span_high[i] = senkou_span_b[i];
         senkou_span_low[i] = senkou_span_a[i];
      }
      chinkou_span[i] = iIchimoku(NULL, 0, Tenkan, Kijun, Senkou, MODE_CHINKOUSPAN, i+26);
      chinkou_span_mode[i] = chinkou_span_mode((i+26), chinkou_span[i]);
      //Alert(i, " - ", tenkan_sen[i], " - ", kijun_sen[i], " - ", senkou_span_a[i], " - ", senkou_span_b[i], " - ", chinkou_span[i], " - (", chinkou_span_mode[i], ")");
   }
   infobox = StringConcatenate(infobox, "\nTenkan Sen: ", DoubleToStr(tenkan_sen[num],Digits), ", Kijun Sen: ", DoubleToStr(kijun_sen[num],Digits), 
      ", Senkou A: ", DoubleToStr(senkou_span_a[num],Digits), ", Senkou B: ", DoubleToStr(senkou_span_b[num],Digits), ", Chinkou Span: ", DoubleToStr(chinkou_span[num],Digits), 
      ", Chinkou Mode: (", chinkou_span_mode[num], ")");
}


//Tenkan Sen/Kijun Sen Cross
int ts_ks_cross(int num)
{

   localbox = StringConcatenate("Symbol: ", Symbol(), ", (ts_ks_cross) No buy and sell condition found: ");
   int i;
   int result = 0;
   //strong buy condition
   if (tenkan_sen[num] > kijun_sen[num] && tenkan_sen[num] >= senkou_span_high[num] && kijun_sen[num] >= senkou_span_high[num]) {
      localbox = StringConcatenate("Symbol: ", Symbol(), ", (ts_ks_cross) strong buy condition search: ");
      for (i = num; i < max_number; i++) {
         if (tenkan_sen[i] < kijun_sen[i]) {
            //strong buy condition exists
            localbox = StringConcatenate(localbox, ", (ts_ks_cross) strong buy condition exists. ");
            result = 1;
            break;
         }
      }
   } else if (tenkan_sen[num] > kijun_sen[num] && ((tenkan_sen[num] <= senkou_span_high[num] && tenkan_sen[num] >= senkou_span_low[num]) || (kijun_sen[num] <= senkou_span_high[num] && kijun_sen[num] >= senkou_span_low[num]))) {  
      //neutral buy condition
      localbox = StringConcatenate("Symbol: ", Symbol(), ", (ts_ks_cross) neutral buy condition search: ");
      for (i = num; i < max_number; i++) {
         if (tenkan_sen[i] < kijun_sen[i]) {
            //neutral buy condition exists
            localbox = StringConcatenate(localbox, ", (ts_ks_cross) neutral buy condition exists. ");
            result = 2;
            break;
         }
      }
   }
   //weak buy condition
   else if (tenkan_sen[num] > kijun_sen[num] && tenkan_sen[num] <= senkou_span_low[num] && kijun_sen[num] <= senkou_span_low[num]) {
      localbox = StringConcatenate("Symbol: ", Symbol(), ", (ts_ks_cross) weak buy condition search: ");
      for (i = num; i < max_number; i++) {
         if (tenkan_sen[i] < kijun_sen[i]) {
            //neutral buy condition exists
            localbox = StringConcatenate(localbox, ", (ts_ks_cross) weak buy condition exists. ");
            result = 3;
            break;
         }
      }
   }
   //strong sell condition
   else if (tenkan_sen[num] < kijun_sen[num] && tenkan_sen[num] <= senkou_span_low[num] && kijun_sen[num] <= senkou_span_low[num]) {
      localbox = StringConcatenate("Symbol: ", Symbol(), ", (ts_ks_cross) strong sell condition search: ");
      for (i = num; i < max_number; i++) {
         if (tenkan_sen[i] > kijun_sen[i]) {
            //strong sell condition exists
            localbox = StringConcatenate(localbox, ", (ts_ks_cross) strong sell condition exists. ");
            result = -1;
            break;
         }
      }
   }
   //neutral sell condition
   else if (tenkan_sen[num] < kijun_sen[num] && ((tenkan_sen[num] <= senkou_span_high[num] && tenkan_sen[num] >= senkou_span_low[num]) || (kijun_sen[num] <= senkou_span_high[num] && kijun_sen[num] >= senkou_span_low[num]))) {
      localbox = StringConcatenate("Symbol: ", Symbol(), ", (ts_ks_cross) neutral sell condition search: ");
      for (i = num; i < max_number; i++) {
         if (tenkan_sen[i] > kijun_sen[i]) {
            //neutral sell condition exists
            localbox = StringConcatenate(localbox, ", (ts_ks_cross) neutral sell condition exists. ");
            result = -2;
            break;
         }
      }
   }
   //weak sell condition
   else if (tenkan_sen[num] < kijun_sen[num] && tenkan_sen[num] >= senkou_span_high[num] && kijun_sen[num] >= senkou_span_high[num]) {
      localbox = StringConcatenate("Symbol: ", Symbol(), ", (ts_ks_cross) weak sell condition search: ");
      for (i = num; i < max_number; i++) {
         if (tenkan_sen[i] > kijun_sen[i]) {
            //neutral sell condition exists
            localbox = StringConcatenate(localbox, ", (ts_ks_cross)s weak sell condition exists. ");
            result = -3;
            break;
         }
      }
   }
   return (result);
}


//Kijun Sen Cross
int kijun_sen_cross(int num)
{
   localbox = StringConcatenate("Symbol: ", Symbol(), ", (kijun_sen_cross) No buy and sell condition found");
   int i;
   int result = 0;
   //strong buy condition
   if (High[num] > kijun_sen[num] && Low[num] < kijun_sen[num] && kijun_sen[num] >= senkou_span_high[num] && Open[num] < Close[num]) {
      //strong buy condition exists
      localbox = StringConcatenate("Symbol: ", Symbol(), "(kijun_sen_cross) strong buy condition exists.");
      result = 1;
   }
   //neutral buy condition
   else if (High[num] > kijun_sen[num] && Low[num] < kijun_sen[num] && kijun_sen[num] <= senkou_span_high[num] && kijun_sen[num] >= senkou_span_low[num] && Open[num] < Close[num]) {
      //neutral buy condition exists
         localbox = StringConcatenate("Symbol: ", Symbol(), "(kijun_sen_cross) neutral buy condition exists.");
         result = 2;
   }
   //weak buy condition
   else if (High[num] > kijun_sen[num] && Low[num] < kijun_sen[num] && kijun_sen[num] <= senkou_span_low[num] && Open[num] < Close[num]) {
       //weak buy condition exists
         localbox = StringConcatenate("Symbol: ", Symbol(), "(kijun_sen_cross) weak buy condition exists.");
         result = 3;
   }
   //strong sell condition
   else if (High[num] > kijun_sen[num] && Low[num] < kijun_sen[num] && kijun_sen[num] <= senkou_span_low[num] && Open[num] > Close[num]) {
       //strong buy condition exists
         localbox = StringConcatenate("Symbol: ", Symbol(), "(kijun_sen_cross) strong sell condition exists.");
         result = -1;
   }
   //neutral sell condition
   else if (High[num] > kijun_sen[num] && Low[num] < kijun_sen[num] && kijun_sen[num] <= senkou_span_high[num] && kijun_sen[num] >= senkou_span_low[num] && Open[num] > Close[num]) {
      //neutral buy condition exists
         localbox = StringConcatenate("Symbol: ", Symbol(), "(kijun_sen_cross) neutral sell condition exists.");
         result = -1;
   }
   //weak buy condition
   else if (High[num] > kijun_sen[num] && Low[num] < kijun_sen[num] && kijun_sen[num] >= senkou_span_high[num] && Open[num] > Close[num]) {
      //weak buy condition exists
         localbox = StringConcatenate("Symbol: ", Symbol(), ", (kijun_sen_cross) weak sell condition exists.");
         result = -1;
   }
   return (result);
}

// Kumo Breakout
int kumo_breakout(int num)
{
   localbox = StringConcatenate("Symbol: ", Symbol(), ", (kumo_breakout) No buy and sell condition found");
   int result = 0;
   //strong buy condition
   if (Open[num] < senkou_span_high[num] && Close[num] > senkou_span_high[num]) {
      localbox = StringConcatenate("Symbol: ", Symbol(), ", (kumo_breakout) strong buy condition exists, search for other signals like choukou span to confirm.");
      result = 1;
   }
   //strong sell condition
   else if (Open[num] > senkou_span_low[num] && Close[num] < senkou_span_low[num]) {
      localbox = StringConcatenate("Symbol: ", Symbol(), ", (kumo_breakout) strong sell condition exists, search for other signals like choukou span to confirm.");
      result = -1;
   }
   return (result);
}



//Senkou Span Cross
int senkou_span_cross(int num)
{

   localbox = StringConcatenate("Symbol: ", Symbol(), ", (senkou_span_cross) No buy and sell condition found: ");
   int i;
   int result = 0;
   int prev = num + 26;
   //strong buy condition
   if (Close[prev] > senkou_span_high[num]) {
      localbox = StringConcatenate("Symbol: ", Symbol(), ", (senkou_span_cross) strong buy condition search: ");
      for (i = (num+1); i < max_number; i++) {
         if (senkou_span_a[i] < senkou_span_b[i] && senkou_span_a[num] > senkou_span_b[num]) {
            //strong buy condition exists
            localbox = StringConcatenate(localbox, ", (senkou_span_cross) strong buy condition exists. Check other conditions to confirm. i = ", i, 
            ", senkou_span_a[i] = ", senkou_span_a[i], ", senkou_span_b[i] = ", senkou_span_b[i], ", close at 26 place before: ", Close[prev]);
            result = 1;
            break;
         }
      }
   } 
   //neutral buy condition
   else if ((Close[prev] < senkou_span_high[num] && Close[prev] > senkou_span_low[num]) || (Open[prev] < senkou_span_high[num] && Open[prev] > senkou_span_low[num])) {  
      //neutral buy condition
      localbox = StringConcatenate("Symbol: ", Symbol(), ", (senkou_span_cross) neutral buy condition search: ");
      for (i = (num+1); i < max_number; i++) {
         if (senkou_span_a[i] < senkou_span_b[i] && senkou_span_a[num] > senkou_span_b[num]) {
            //neutral buy condition exists
            localbox = StringConcatenate(localbox, ", (senkou_span_cross) neutral buy condition exists. Check other conditions to confirm. i = ", i, 
            ", senkou_span_a[i] = ", senkou_span_a[i], ", senkou_span_b[i] = ", senkou_span_b[i], ", close at 26 place before: ", Close[prev]
            , ", Open at 26 place before: ", Open[prev]);
            result = 2;
            break;
         }
      }
   }
   //weak buy condition
   else if (Close[prev] < senkou_span_low[num]) {  
      localbox = StringConcatenate("Symbol: ", Symbol(), ", (senkou_span_cross) weak buy condition search: ");
      for (i = (num+1); i < max_number; i++) {
         if (senkou_span_a[i] < senkou_span_b[i] && senkou_span_a[num] > senkou_span_b[num]) {
            //neutral buy condition exists
            localbox = StringConcatenate(localbox, ", (senkou_span_cross) weak buy condition exists. Check other conditions to confirm. i = ", i, 
            ", senkou_span_a[i] = ", senkou_span_a[i], ", senkou_span_b[i] = ", senkou_span_b[i], ", close at 26 place before: ", Close[prev]);
            result = 3;
            break;
         }
      }
   }
   //strong sell condition
   else if (Close[prev] < senkou_span_low[num]) {
      localbox = StringConcatenate("Symbol: ", Symbol(), ", (senkou_span_cross) strong sell condition search: ");
      for (i = (num+1); i < max_number; i++) {
         if (senkou_span_a[i] > senkou_span_b[i] && senkou_span_a[num] < senkou_span_b[num]) {
            //strong sell condition exists
            localbox = StringConcatenate(localbox, ", (senkou_span_cross) strong sell condition exists. Check other conditions to confirm. i = ", i, 
            ", senkou_span_a[i] = ", senkou_span_a[i], ", senkou_span_b[i] = ", senkou_span_b[i], ", close at 26 place before: ", Close[prev]);
            result = -1;
            break;
         }
      }
   }
   //neutral sell condition
   else if ((Close[prev] < senkou_span_high[num] && Close[prev] > senkou_span_low[num]) || (Open[prev] < senkou_span_high[num] && Open[prev] > senkou_span_low[num])) {  
      localbox = StringConcatenate("Symbol: ", Symbol(), ", (senkou_span_cross) neutral sell condition search: ");
      for (i = (num+1); i < max_number; i++) {
         if (senkou_span_a[i] > senkou_span_b[i] && senkou_span_a[num] < senkou_span_b[num]) {
            //neutral sell condition exists
            localbox = StringConcatenate(localbox, ", (senkou_span_cross) neutral sell condition exists. Check other conditions to confirm. i = ", i, 
            ", senkou_span_a[i] = ", senkou_span_a[i], ", senkou_span_b[i] = ", senkou_span_b[i], ", close at 26 place before: ", Close[prev]
            , ", Open at 26 place before: ", Open[prev]);
            result = -2;
            break;
         }
      }
   }
   //weak sell condition
   else if (Close[prev] > senkou_span_high[num]) {
      localbox = StringConcatenate("Symbol: ", Symbol(), ", (senkou_span_cross) weak sell condition search: ");
      for (i = (num+1); i < max_number; i++) {
         if (senkou_span_a[i] > senkou_span_b[i] && senkou_span_a[num] < senkou_span_b[num]) {
            //neutral sell condition exists
            localbox = StringConcatenate(localbox, ", (senkou_span_cross)s weak sell condition exists. Check other conditions to confirm. i = ", i, 
            ", senkou_span_a[i] = ", senkou_span_a[i], ", senkou_span_b[i] = ", senkou_span_b[i], ", close at 26 place before: ", Close[prev]);
            result = -3;
            break;
         }
      }
   }
   return (result);
}

int alligator(int num)
{
   int result = 0;
   double jaw_val=iAlligator(NULL, 0, 13, 8, 8, 5, 5, 3, MODE_SMMA, PRICE_MEDIAN, MODE_GATORJAW, (num-2));
   double teeth_val=iAlligator(NULL, 0, 13, 8, 8, 5, 5, 3, MODE_SMMA, PRICE_MEDIAN, MODE_GATORTEETH, (num-2));
   double lips_val=iAlligator(NULL, 0, 13, 8, 8, 5, 5, 3, MODE_SMMA, PRICE_MEDIAN, MODE_GATORLIPS, (num-2));
   localbox = StringConcatenate("Symbol: ", Symbol(), ", jaw: ", DoubleToStr(jaw_val,Digits), ", teeth: ", DoubleToStr(teeth_val,Digits), ", lips: ", DoubleToStr(lips_val,Digits));
   
   //buy condition
   if (jaw_val < teeth_val && teeth_val < lips_val) {
      localbox = StringConcatenate(localbox, ", (alligator) Strong buy condition. Check other conditions to confirm. ");
      result = 1;
      if (alligator_previous_condition != result) {
         alligator_previous_condition = result;
      }
   }
   //sell condition
   else if (jaw_val > teeth_val && teeth_val > lips_val) {
      localbox = StringConcatenate(localbox, ", (alligator) Strong sell condition. Check other conditions to confirm. ");
      result = -1;
      if (alligator_previous_condition != result) {
         alligator_previous_condition = result;
      }
   }
   else {
      localbox = StringConcatenate(localbox, ", (alligator) No buy and sell condition.");
      result = 0;
   }
   
   return (result);
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

void SendAlert(string dir)
{
   //string per = TimeframeToString(Period());
   if (UseAlerts)
   {
      Alert(Symbol(), " @ ", per, " - ", TimeToStr(TimeCurrent()), " - ", dir);
      PlaySound("alert.wav");
   }
   if (UseEmailAlerts)
      SendMail(Symbol() + " @ " + per + " - " + dir + " Ichimoku", dir + " Pinbar on " + Symbol() + " @ " + per + " as of " + TimeToStr(TimeCurrent()));
      
   if (UsePrintAlerts)
      Print(Symbol() + " @ " + per + " - " + dir + " Ichimoku", dir + " Pinbar on " + Symbol() + " @ " + per + " as of " + TimeToStr(TimeCurrent()));
}


  int CalculateCurrentOrders()
  {
   int buys=0,sells=0;
//----
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA)
        {
         if(OrderType()==OP_BUY)  buys++;
         if(OrderType()==OP_SELL) sells++;
        }
     }
         if (logs) Print("Buy count: ", buys);
         if (logs) Print("Sell count: ", sells);
//---- return orders volume
   if(buys>0) return(buys);
   else       return(-sells);
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
         corders++;
        }
     }
         if (logs) Print("Max orders: ", corders);
         return(corders);
}

void calculatestoploss()
{
double stop_loss_value_2,take_profit_value_2,stop_loss_value_3,take_profit_value_3,stop_loss_value_5,take_profit_value_5;
   switch (Period()) {
      case PERIOD_M1:
      case PERIOD_M5: 
         stop_loss_value_2 = 3.00;
         stop_loss_value_3 = 0.300;
         stop_loss_value_5 = 0.00300;
         take_profit_value_2 = 0.20;
         take_profit_value_3 = 0.020;
         take_profit_value_5 = 0.00020;
         break;
      case PERIOD_M15:
      case PERIOD_M30:
      case PERIOD_H1:
      case PERIOD_H4:
         stop_loss_value_2 = 3.00;
         stop_loss_value_3 = 0.300;
         stop_loss_value_5 = 0.00300;
         take_profit_value_2 = 0.50;
         take_profit_value_3 = 0.050;
         take_profit_value_5 = 0.00050;
         break;
      case PERIOD_D1:
      case PERIOD_W1:
      case PERIOD_MN1:
         stop_loss_value_2 = 3.00;
         stop_loss_value_3 = 0.300;
         stop_loss_value_5 = 0.00300;
         take_profit_value_2 = 0.90;
         take_profit_value_3 = 0.090;
         take_profit_value_5 = 0.00090;
         break;
   }
   if (Digits == 3) {
         buffer_order = 0.015;
         take_profit = take_profit_value_3;
         stop_loss = stop_loss_value_3;
   } else if (Digits == 2) {
         buffer_order = 0.15;
         take_profit = take_profit_value_2;
         stop_loss = stop_loss_value_2;
   } else {
         buffer_order = 0.00015;
         take_profit = take_profit_value_5;
         stop_loss = stop_loss_value_5;
   }
   //if (logs) Print("take profit limit is: ", take_profit);
   //if (logs) Print("stop_loss limit is: ", stop_loss);
}

void CheckForClose()
 {
   string r;
      int orders = CalculateCurrentOrders();
      string message;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
      if ((lots - OrderLots()) > 0 && OrderLots() == 0.01) {
         
            if(OrderType()==OP_BUY) {
               if (orders > 1) { // we already have two orders
                  if (logs) Print("we have 2 orders so exiting");
                  return;
               }
               
               if (OrderProfit() > 0) {
                  message = StringConcatenate(per, ", ", DoubleToStr(OrderOpenPrice(), Digits), ", ", DoubleToStr((OrderOpenPrice()-buffer_order), Digits)
                  , ", ", DoubleToStr(Ask, Digits), ", ", OrderProfit());
                  r = OrderSend(Symbol(), OP_BUY, (lots - OrderLots()), Ask, 3, sl, tp, message, MAGICMA, 0, Blue);
                     //ending order
                  //Alert("More order for buy: ", r, ", order profit: ",OrderProfit());
               }
            } else if(OrderType()==OP_SELL) {
               if (orders < -1) { // we already have two orders
                  if (logs) Print("we have 2 orders so exiting");
                  return;
               }
              
               if (OrderProfit() > 0) {
                  message = StringConcatenate(per, ", ", DoubleToStr(OrderOpenPrice(), Digits), ", ", DoubleToStr((OrderOpenPrice()+buffer_order), Digits)
                  , ", ", DoubleToStr(Bid, Digits), ", ", OrderProfit());
                  r = OrderSend(Symbol(), OP_SELL, (lots - OrderLots()), Bid, 3, sl, tp, message, MAGICMA, 0, Red);
                     //ending order
                  //Alert("More order for sell: ", r, ", order profit: ",OrderProfit());
               }
            }
      }
   }
 }
 
 void CheckForOpen(int signal, int buy, int sell)
 {
   string r;
   int orders = 0;
   string message = StringConcatenate("Wait, Dont create any order for ", Symbol(), ", Signal ", signal, ", Buy: ", buy, ", Sell: ", sell, ", stop loss: ", stop_loss, ", take profit, "
         , take_profit);
   if (signal == 0) {
      //
   } else if (signal == 1) {
      if (buy > sell) {
         calculatestoploss();
         sl = 0;
         tp = 0;
         if (!disable_stop_loss) {
            sl = Ask - stop_loss;
         }

         if (!disable_take_profit) {
            tp = Ask + take_profit;
         }
         message = StringConcatenate("Buy Order should be opened for symbol: ", Symbol(), ", Signal ", signal, ", Buy: ", buy, ", Sell: ", sell, ", stop loss: "
         , stop_loss, " (", sl, "), take profit, "
         , take_profit, " (", tp, ")", ", Ask: ", Ask, ", Time: ", TimeToStr(TimeCurrent()));
         SendAlert(message);
         create_orders(1);//create orders
      }
   } else if (signal == -1) {
      if (buy < sell) {
         calculatestoploss();
         sl = 0;
         tp = 0;
         if (!disable_stop_loss) {
            sl = Bid + stop_loss;
         }

         if (!disable_take_profit) {
            tp = Bid - take_profit;
         }
         message = StringConcatenate("Sells Order should be opened for symbol: ", Symbol(), ", Signal ", signal, ", Buy: ", buy, ", Sell: ", sell, ", stop loss: "
         , stop_loss, " (", sl, "), take profit, "
         , take_profit, " (", tp, ")", ", Bid: ", Bid, ", Time: ", TimeToStr(TimeCurrent()));
         SendAlert(message);
         create_orders(-1);//create orders
      }
   }
   Comment(infobox, 
   "\n",
   "Signal: ", signal,
   "\n",
   "Buy Count: ", buy,
   "\n",
   "Sell Count: ", sell,
   "\n",
   "Message: ", message);
 }
 
 void create_orders(int type)
 {
   string r;
   int orders = 0;
   orders = CalculateCurrentOrders();
   if (logs) Print("orders: ", orders);
   if(orders==0) {
      if (createorders) { 
         if (type == 1) {//buy                    
                  orders = CalculateCurrentMaxOrders();
                  //Print("current orders: ", orders);
                  if (orders >= maxorders) {
                     Print(Symbol(), ", Max Orders Reached (buy).");
                  } else {
                     r = OrderSend(Symbol(), OP_BUY, 0.01, Ask, 3, sl, tp, per, MAGICMA, 0, Blue);
                     //ending order
                     Alert("Result for buy: ", r);
                     //WindowScreenShot("order_buy_"+r+".gif",640,480); 
                  }
         } else if (type == -1) {//sell                      
               orders = CalculateCurrentMaxOrders();
               //Print("current orders: ", orders);
               if (orders >= maxorders) {
                  Print(Symbol(), ", Max Orders Reached (sell).");
               } else {
                  r = OrderSend(Symbol(), OP_SELL, 0.01, Bid, 3, sl, tp, per, MAGICMA, 0, Red);
                  //ending order
                  Alert("Result for sell: ", r);
                  //WindowScreenShot("order_buy_"+r+".gif",640,480); 
               }
         }
      }
   } else {
      if (logs) Print(orders, " orders for ", Symbol(), ", so checking for close condition");
      CheckForClose();   
   }
 }