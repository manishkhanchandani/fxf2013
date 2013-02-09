//+------------------------------------------------------------------+
//|                                            11_ichimokuhelper2.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"
#define MAGICMA  19740605112141

extern double build = 1.41;
extern int master_number = 1;
extern int maxorders = 30;
extern double lots = 1.00;
extern bool disable_stop_loss = false;
extern bool disable_take_profit = false;
extern bool UseAlerts = false;
extern bool UseEmailAlerts = false;
extern bool UsePrintAlerts = true;
extern bool createorders = false;
extern bool logs = false;
extern bool createsmallorder = false;
//strategies
extern bool kumo_breakout_strategy = false;
extern bool kijun_sen_cross_strategy = false;
extern bool ts_ks_cross_strategy = false;
extern bool rsi_strategy = false;
extern bool bollingerband_strategy = true;

string strategy;
double stop_loss;
double take_profit;
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
string per;

double max_profit;
double half_profit;
double running_profit = 0;
double orderlot;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   Print("Build ", build);
   base_level = Ask;
   base_level_diff = Ask;
   per = TimeframeToString(Period());
   //if (!(Period() == PERIOD_M30 || Period() == PERIOD_H1) && createorders == true) {
      //Alert("Create orders will work only in 30 min and 1 hour time frame.");
      //createorders = false;
  // }
   custom_start();
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
   calculatestoploss();
   infobox = "\n\n";
   infobox = StringConcatenate(infobox, "Number: ", master_number);
   int result;
   int tmpresult;
   int order_signal = 0;
   int order_signal_strength_buy = 0;
   int order_signal_strength_sell = 0;
         int result1 = 0;
         int result2 = 0;
         int result3 = 0;
         int result4 = 0;
         
         
         if (kumo_breakout_strategy == true || kijun_sen_cross_strategy == true || ts_ks_cross_strategy == true) {
            ichimoku(master_number);
            infobox = StringConcatenate(infobox, "\n", localbox);
            if (kumo_breakout_strategy == true) {
               //kumo breakout
               tmpresult = kumo_breakout(master_number);
               infobox = StringConcatenate(infobox, "\n", localbox);
               if (tmpresult != 0) {
                  result1 = tmpresult;
                  order_signal = result1;
                  result = result1;
                  strategy = "kumo_breakout";
               }
            } else if (kijun_sen_cross_strategy == true) {
               //kijun_sen_cross
               tmpresult = kijun_sen_cross(master_number);
               if (tmpresult != 0) {
                  result2 = tmpresult;
                  order_signal = result2;
                  result = result2;
                  strategy = "kijun_sen_cross";
               }
               infobox = StringConcatenate(infobox, "\n", localbox);
            
            } else if (ts_ks_cross_strategy == true) {
               //ts_ks_cross
               tmpresult = ts_ks_cross(master_number);
               if (tmpresult != 0) {
                  result3 = tmpresult;
                  order_signal = result3;
                  result = result3;
                  strategy = "ts_ks_cross";
               }
               infobox = StringConcatenate(infobox, "\n", localbox);
            }
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
         } else if (rsi_strategy == true) {
            //rsi
            tmpresult = rsi(master_number);
            infobox = StringConcatenate(infobox, "\n", localbox);
            if (tmpresult != 0) {
               result4 = tmpresult;
               order_signal = result4;
               result = result4;
               strategy = "rsi";
            }
         } else if (bollingerband_strategy == true) {
            //bollingerband_strategy
            tmpresult = bollingerbands(master_number);
            infobox = StringConcatenate(infobox, "\n", localbox);
            if (tmpresult != 0) {
               result = tmpresult;
               order_signal = result;
               strategy = "bollingerband";
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
         infobox = StringConcatenate(infobox, "\n", localbox);
         getrecord();
         infobox = StringConcatenate(infobox, "\n\n", localbox);
         Comment(infobox);

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
   int tmp = 0;
   //strong buy condition
   if (tenkan_sen[num] > kijun_sen[num] && tenkan_sen[num] >= senkou_span_high[num] && kijun_sen[num] >= senkou_span_high[num] && chinkou_span_mode[num] == 1) { // && chinkou_span_mode[num] == 1
      localbox = StringConcatenate("Symbol: ", Symbol(), ", (ts_ks_cross) search strong buy condition: ");
      for (i = num; i < max_number; i++) {
         if (tenkan_sen[i] < kijun_sen[i]) {
            //strong buy condition exists
            tmp = 1;
            break;
         }
      }
      if (tmp == 1) {
         for (i = num; i < max_number; i++) {
            if ((Open[i] < senkou_span_high[i]) && (Close[i] > senkou_span_high[i])) {
               localbox = StringConcatenate(localbox, ", (ts_ks_cross) strong buy condition exists.");
               result = 1;
               break;
            }
         }
      }
   } 
   /*
   else if (tenkan_sen[num] > kijun_sen[num] && ((tenkan_sen[num] <= senkou_span_high[num] && tenkan_sen[num] >= senkou_span_low[num]) || (kijun_sen[num] <= senkou_span_high[num] && kijun_sen[num] >= senkou_span_low[num]))) {  
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
   */
   //strong sell condition
   else if (tenkan_sen[num] < kijun_sen[num] && tenkan_sen[num] <= senkou_span_low[num] && kijun_sen[num] <= senkou_span_low[num] && chinkou_span_mode[num] == -1) { // && chinkou_span_mode[num] == -1
      localbox = StringConcatenate("Symbol: ", Symbol(), ", (ts_ks_cross) search strong sell condition: ");
      for (i = num; i < max_number; i++) {
         if (tenkan_sen[i] > kijun_sen[i]) {
            //strong sell condition exists
            localbox = StringConcatenate(localbox, ", (ts_ks_cross) strong sell condition exists. ");
            tmp = 1;
            break;
         }
      }
      if (tmp == 1) {
         for (i = num; i < max_number; i++) {
            if ((Open[i] > senkou_span_low[i]) && (Close[i] < senkou_span_low[i])) {
               localbox = StringConcatenate(localbox, ", (ts_ks_cross) strong buy condition exists.");
               result = -1;
               break;
            }
         }
      }
   }
   /*
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
   */
   return (result);
}


//Kijun Sen Cross
int kijun_sen_cross(int num)
{
   localbox = StringConcatenate("Symbol: ", Symbol(), ", (kijun_sen_cross) No buy and sell condition found");
   int i;
   int result = 0;
   //strong buy condition
   if (Close[num] > kijun_sen[num] && Open[num] < kijun_sen[num] && kijun_sen[num] >= senkou_span_high[num] && Open[num] < Close[num] && chinkou_span_mode[num] == 1) { // && chinkou_span_mode[num] == 1
      //strong buy condition exists
      localbox = StringConcatenate("Symbol: ", Symbol(), "(kijun_sen_cross) searching strong buy condition.");
      for (i = num; i < max_number; i++) {
         if ((Open[i] < senkou_span_high[i]) && (Close[i] > senkou_span_high[i])) {
            localbox = StringConcatenate(localbox, ", (kijun_sen_cross) strong buy condition exists.");
            result = 1;
            break;
         }
      }
   }
   /*
   //neutral buy condition
   else if (Close[num] > kijun_sen[num] && Open[num] < kijun_sen[num] && kijun_sen[num] <= senkou_span_high[num] && kijun_sen[num] >= senkou_span_low[num] && Open[num] < Close[num]) {
      //neutral buy condition exists
         localbox = StringConcatenate("Symbol: ", Symbol(), "(kijun_sen_cross) neutral buy condition exists.");
         result = 2;
   }
   //weak buy condition
   else if (Close[num] > kijun_sen[num] && Open[num] < kijun_sen[num] && kijun_sen[num] <= senkou_span_low[num] && Open[num] < Close[num]) {
       //weak buy condition exists
         localbox = StringConcatenate("Symbol: ", Symbol(), "(kijun_sen_cross) weak buy condition exists.");
         result = 3;
   }
   */
   //strong sell condition
   else if (Open[num] > kijun_sen[num] && Close[num] < kijun_sen[num] && kijun_sen[num] <= senkou_span_low[num] && Open[num] > Close[num] && chinkou_span_mode[num] == -1) { // && chinkou_span_mode[num] == -1
      localbox = StringConcatenate("Symbol: ", Symbol(), "(kijun_sen_cross) searching strong sell condition.");
      for (i = num; i < max_number; i++) {
         if ((Open[i] > senkou_span_low[i]) && (Close[i] < senkou_span_low[i])) {
            localbox = StringConcatenate(localbox, ", (kijun_sen_cross) strong sell condition exists.");
            result = -1;
            break;
         }
      }
   }
   /*
   //neutral sell condition
   else if (Open[num] > kijun_sen[num] && Close[num] < kijun_sen[num] && kijun_sen[num] <= senkou_span_high[num] && kijun_sen[num] >= senkou_span_low[num] && Open[num] > Close[num]) {
      //neutral buy condition exists
         localbox = StringConcatenate("Symbol: ", Symbol(), "(kijun_sen_cross) neutral sell condition exists.");
         result = -1;
   }
   //weak buy condition
   else if (Open[num] > kijun_sen[num] && Close[num] < kijun_sen[num] && kijun_sen[num] >= senkou_span_high[num] && Open[num] > Close[num]) {
      //weak buy condition exists
         localbox = StringConcatenate("Symbol: ", Symbol(), ", (kijun_sen_cross) weak sell condition exists.");
         result = -1;
   }
   */
   return (result);
}

// Kumo Breakout
int kumo_breakout(int num)
{
   localbox = StringConcatenate("Symbol: ", Symbol(), ", (kumo_breakout) No buy and sell condition found");
   int result = 0;
   //strong buy condition
   if (Open[num] < senkou_span_high[num] && Close[num] > senkou_span_high[num] && Open[num] > senkou_span_low[num] && kijun_sen[num] > senkou_span_high[num] && chinkou_span_mode[num] == 1) { // && chinkou_span_mode[num] == 1
      localbox = StringConcatenate("Symbol: ", Symbol(), ", (kumo_breakout) strong buy condition exists, search for other signals like choukou span to confirm.");
      result = 1;
   }
   //strong sell condition
   else if (Open[num] > senkou_span_low[num] && Close[num] < senkou_span_low[num] && Open[num] < senkou_span_high[num] && kijun_sen[num] < senkou_span_low[num] && chinkou_span_mode[num] == -1) { // && chinkou_span_mode[num] == -1
      localbox = StringConcatenate("Symbol: ", Symbol(), ", (kumo_breakout) strong sell condition exists, search for other signals like choukou span to confirm.");
      result = -1;
   }
   return (result);
}



int bollingerbands(int num)
{
   localbox = StringConcatenate("Symbol: ", Symbol(), ", period: ", TimeframeToString(Period()), ", Bollinger Band Study: No Buy and Sell Condition");
   double b1 = iBands(Symbol(),0,20,2,0,PRICE_CLOSE,MODE_UPPER,num);
   double b2 = iBands(Symbol(),0,20,2,0,PRICE_CLOSE,MODE_LOWER,num);
   double ma = double iMA(Symbol(), 0, 20, 0, MODE_SMA, PRICE_CLOSE, num);
   double low[3];
   double high[3];
   high[0] = High[(num)];
   high[1] = High[(num+1)];
   high[2] = High[(num+2)];
   low[0] = Low[(num)];
   low[1] = Low[(num+1)];
   low[2] = Low[(num+2)];
   //Alert("start: ", DoubleToStr(b1, Digits), ", ", DoubleToStr(ma, Digits), ", ", DoubleToStr(b2, Digits));
   //Alert("Low: ", DoubleToStr(low[0], Digits), ", ", DoubleToStr(low[1], Digits), ", ", DoubleToStr(low[2], Digits));
   //Alert("High: ", DoubleToStr(high[0], Digits), ", ", DoubleToStr(high[1], Digits), ", ", DoubleToStr(high[2], Digits));
   /*bollingerband = StringConcatenate(bollingerband, "start: upper: ", DoubleToStr(b1, Digits), ", ma: ", DoubleToStr(ma, Digits), ", lower: ", DoubleToStr(b2, Digits)
   , ", Low: ", DoubleToStr(low[0], Digits), ", ", DoubleToStr(low[1], Digits), ", ", DoubleToStr(low[2], Digits)
   , ", High: ", DoubleToStr(high[0], Digits), ", ", DoubleToStr(high[1], Digits), ", ", DoubleToStr(high[2], Digits)
   , "\nBollinger Band: "
   );*/
   int result = 0;
   if (low[0] > ma && low[1] > ma && low[2] > ma) { //search for sell
      //bollingerband = StringConcatenate(bollingerband, "searching sell condition. ");
      localbox = StringConcatenate("Symbol: ", Symbol(), ", period: ", TimeframeToString(Period()), "(bollingerband) searching strong sell condition. ");
      if (high[0] < high[1] && high[2] < high[1] && Open[(num-1)] > Close[(num-1)]) {
         //bollingerband = StringConcatenate(bollingerband, "sell condition exists. ");
         //Alert(symbol, ", period: ", TimeframeToString(timeframe), ", sell condition exists using bollingerband.");
         localbox = StringConcatenate(localbox, "sell condition exists. ");
         result = -1;
      }
   }
   else if (high[0] < ma && high[1] < ma && high[2] < ma) { //search for sell
      //bollingerband = StringConcatenate(bollingerband, "searching buy condition. ");
      localbox = StringConcatenate("Symbol: ", Symbol(), ", period: ", TimeframeToString(Period()), "(bollingerband) searching strong buy condition. ");
      if (low[0] > low[1] && low[2] > high[1] && Open[(num-1)] < Close[(num-1)]) {
         //bollingerband = StringConcatenate(bollingerband, "buy condition exists. ");
         //Alert(symbol, ", period: ", TimeframeToString(timeframe), ", buy condition exists using bollingerband.");
         localbox = StringConcatenate(localbox, "buy condition exists. ");
         result = 1;
      }
   }
   else {
      //bollingerband = StringConcatenate(bollingerband, "No Buy and Sell condition. ");
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
   }
   //sell condition
   else if (jaw_val > teeth_val && teeth_val > lips_val) {
      localbox = StringConcatenate(localbox, ", (alligator) Strong sell condition. Check other conditions to confirm. ");
      result = -1;
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
   orderlot = lots;
   if (createsmallorder) orderlot = 0.01;
   switch (Period()) {
      case PERIOD_M1:
         stop_loss_value_2 = 5.00;
         stop_loss_value_3 = 0.500;
         stop_loss_value_5 = 0.00500;
         take_profit_value_2 = 0.10;
         take_profit_value_3 = 0.010;
         take_profit_value_5 = 0.00010;
         max_profit = orderlot * 10;
         half_profit = max_profit / 2;
      case PERIOD_M5: 
         stop_loss_value_2 = 5.00;
         stop_loss_value_3 = 0.500;
         stop_loss_value_5 = 0.00500;
         take_profit_value_2 = 0.20;
         take_profit_value_3 = 0.020;
         take_profit_value_5 = 0.00020;
         max_profit = orderlot * 20;
         half_profit = max_profit / 2;
         break;
      case PERIOD_M15:
         stop_loss_value_2 = 5.00;
         stop_loss_value_3 = 0.500;
         stop_loss_value_5 = 0.00500;
         take_profit_value_2 = 0.50;
         take_profit_value_3 = 0.050;
         take_profit_value_5 = 0.00050;
         max_profit = orderlot * 50;
         half_profit = max_profit / 2;
         break;
      case PERIOD_M30:
         stop_loss_value_2 = 5.00;
         stop_loss_value_3 = 0.500;
         stop_loss_value_5 = 0.00500;
         take_profit_value_2 = 0.75;
         take_profit_value_3 = 0.075;
         take_profit_value_5 = 0.00075;
         max_profit = orderlot * 75;
         half_profit = max_profit / 2;
         break;
      case PERIOD_H1:
      case PERIOD_H4:
         stop_loss_value_2 = 5.00;
         stop_loss_value_3 = 0.500;
         stop_loss_value_5 = 0.00500;
         take_profit_value_2 = 1.00;
         take_profit_value_3 = 0.100;
         take_profit_value_5 = 0.00100;
         max_profit = orderlot * 100;
         half_profit = max_profit / 2;
         break;
      case PERIOD_D1:
         stop_loss_value_2 = 5.00;
         stop_loss_value_3 = 0.500;
         stop_loss_value_5 = 0.00500;
         take_profit_value_2 = 5.00;
         take_profit_value_3 = 0.500;
         take_profit_value_5 = 0.00500;
         max_profit = orderlot * 500;
         half_profit = max_profit / 2;
         break;
      case PERIOD_W1:
         stop_loss_value_2 = 5.00;
         stop_loss_value_3 = 0.500;
         stop_loss_value_5 = 0.00500;
         take_profit_value_2 = 7.50;
         take_profit_value_3 = 0.750;
         take_profit_value_5 = 0.00750;
         max_profit = orderlot * 750;
         half_profit = max_profit / 2;
         break;
      case PERIOD_MN1:
         stop_loss_value_2 = 5.00;
         stop_loss_value_3 = 0.500;
         stop_loss_value_5 = 0.00500;
         take_profit_value_2 = 9.99;
         take_profit_value_3 = 0.999;
         take_profit_value_5 = 0.00999;
         max_profit = orderlot * 999;
         half_profit = max_profit / 2;
         break;
   }
   if (Digits == 3) {
         take_profit = take_profit_value_3;
         stop_loss = stop_loss_value_3;
   } else if (Digits == 2) {
         take_profit = take_profit_value_2;
         stop_loss = stop_loss_value_2;
   } else {
         take_profit = take_profit_value_5;
         stop_loss = stop_loss_value_5;
   }
   
      
   //if (logs) Print("take profit limit is: ", take_profit);
   //if (logs) Print("stop_loss limit is: ", stop_loss);
}

void CheckForClose()
 {
 return (0);
   string r;
      int orders = CalculateCurrentOrders();
      string message;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
      
      
      if (OrderProfit() < running_profit && running_profit > 0) {
         Alert("Order profit is less than running profit so closing the order. ", OrderProfit(), ", running profit: ", running_profit);
         running_profit = 0;
         //close the order;
         if(OrderType()==OP_BUY) {
            OrderClose(OrderTicket(),OrderLots(),Bid,3,White);
         } else if(OrderType()==OP_SELL) {
            OrderClose(OrderTicket(),OrderLots(),Ask,3,White);
         }
      }

      if (OrderProfit() > half_profit) {
         running_profit = half_profit;
      }
      Print("order Profit: ", DoubleToStr(OrderProfit(), Digits), ", half_profit: ", DoubleToStr(half_profit, Digits)
      , ", running profit: ", DoubleToStr(running_profit, Digits)
      , ", max_profit: ", DoubleToStr(max_profit, Digits));
      // do if we need to create multiple orders
      if ((lots - OrderLots()) > 0 && OrderLots() == 0.01 && createsmallorder == true) {
         
            if(OrderType()==OP_BUY) {
               if (orders > 1) { // we already have two orders
                  if (logs) Print("we have 2 orders so exiting");
                  return;
               }
               
               if (OrderProfit() > 0) {
                  message = StringConcatenate(per, ", ", DoubleToStr(OrderOpenPrice(), Digits), ", "
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
                  message = StringConcatenate(per, ", ", DoubleToStr(OrderOpenPrice(), Digits), ", "
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
      create_orders(0);
   } else if (signal == 1) {
      //if (buy > sell) {
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
         create_orders(1);//create orders
         SendAlert(message);  
      //}
   } else if (signal == -1) {
      //if (buy < sell) {
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
         create_orders(-1);//create orders
         SendAlert(message);  
      //}
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
   string message = StringConcatenate(strategy, " B: ", build, ", per: ", per);


   if(orders==0) {
      if (createorders) {    
         if (type == 1) {//buy         
                  orders = CalculateCurrentMaxOrders();
                  if (orders >= maxorders) {
                     Print(Symbol(), ", Max Orders Reached (buy).");
                  } else {
                     r = OrderSend(Symbol(), OP_BUY, orderlot, Ask, 3, sl, tp, message, MAGICMA, 0, Blue);
                     Alert("Result for buy: ", r); 
                  }
         } else if (type == -1) {//sell    
               orders = CalculateCurrentMaxOrders();
               if (orders >= maxorders) {
                  Print(Symbol(), ", Max Orders Reached (sell).");
               } else {
                  r = OrderSend(Symbol(), OP_SELL, orderlot, Bid, 3, sl, tp, message, MAGICMA, 0, Red);
                  Alert("Result for sell: ", r);
               }
         }
      }
   } else {
      if (createorders) {  
         if (logs) Print(orders, " orders for ", Symbol(), ", so checking for close condition");
         CheckForClose();  
      } 
   }
 }
 
 
 
 int rsi(int num)
 {
   int result = 0;
   double rsi_result_1, rsi_result_2, rsi_result_3;
   rsi_result_1 = iRSI(NULL, 0, 14, PRICE_CLOSE, num);
   rsi_result_2 = iRSI(NULL, 0, 14, PRICE_CLOSE, (num + 1));
   rsi_result_3 = iRSI(NULL, 0, 14, PRICE_CLOSE, (num + 2));
   localbox = StringConcatenate("Symbol: ", Symbol(), ", RSI: No buy and sell condition.", rsi_result_1, " - ", rsi_result_2, " - ", rsi_result_3);
   //if (rsi_result_1 > 70 && rsi_result_2 < 70 && rsi_result_3 < 70) {
      //localbox = StringConcatenate("Symbol: ", Symbol(), ", Strong buy condition1. ", rsi_result_1, " - ", rsi_result_2, " - ", rsi_result_3);
      //result = 1;
   //} else
   if (rsi_result_1 < 70 && rsi_result_2 > 70 && rsi_result_3 > 70) {
      localbox = StringConcatenate("Symbol: ", Symbol(), ", Strong sell condition2. ", rsi_result_1, " - ", rsi_result_2, " - ", rsi_result_3);
      result = -1;
   } else if (rsi_result_1 > 30 && rsi_result_2 < 30 && rsi_result_3 < 30) {
      localbox = StringConcatenate("Symbol: ", Symbol(), ", Strong buy condition3. ", rsi_result_1, " - ", rsi_result_2, " - ", rsi_result_3);
      result = 1;
   } 
   //else if (rsi_result_1 < 30 && rsi_result_2 > 30 && rsi_result_3 > 30) {
     // localbox = StringConcatenate("Symbol: ", Symbol(), ", Strong sell condition4. ", rsi_result_1, " - ", rsi_result_2, " - ", rsi_result_3);
      //result = -1;
   //}
   return (result);
 }