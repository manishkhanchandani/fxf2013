//+------------------------------------------------------------------+
//|                                                 i_indicators.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"


int strategyMacdCrossing(string symbol, int period, 
   int fast_ema_period, int slow_ema_period, int signal_period, 
   int applied_price, int shift)
{
   double macd = iMACD(symbol, period, 
   fast_ema_period, slow_ema_period, signal_period, 
   applied_price, MODE_MAIN, shift);
   double macdSignal = iMACD(symbol, period, 
   fast_ema_period, slow_ema_period, signal_period, 
   applied_price, MODE_SIGNAL, shift);
   
   double macd2 = iMACD(symbol, period, 
   fast_ema_period, slow_ema_period, signal_period, 
   applied_price, MODE_MAIN, shift+1);
   double macdSignal2 = iMACD(symbol, period, 
   fast_ema_period, slow_ema_period, signal_period, 
   applied_price, MODE_SIGNAL, shift+1);

   if (macd > macdSignal && macd2 < macdSignal2) {
      return (1);
   } else if (macd < macdSignal && macd2 > macdSignal2) {
      return (-1);
   }

   return (0);
} 


int strategyMacdLineChange(string symbol, int period, 
   int fast_ema_period, int slow_ema_period, int signal_period, 
   int applied_price, int shift)
{
   double macd = iMACD(symbol, period, 
   fast_ema_period, slow_ema_period, signal_period, 
   applied_price, MODE_MAIN, shift);
   
   double macd2 = iMACD(symbol, period, 
   fast_ema_period, slow_ema_period, signal_period, 
   applied_price, MODE_MAIN, shift+1);

   if (macd > 0 && macd2 < 0) {
      return (1);
   } else if (macd < 0 && macd2 > 0) {
      return (-1);
   }

   return (0);
} 

int i_macd_cross(string symbol, int period, int shift, int fast_ema_period, int slow_ema_period, int signal_period, 
   int applied_price)
{
   double macd = iMACD(symbol, period, 
   fast_ema_period, slow_ema_period, signal_period, 
   applied_price, MODE_MAIN, shift);
   double macdSignal = iMACD(symbol, period, 
   fast_ema_period, slow_ema_period, signal_period, 
   applied_price, MODE_SIGNAL, shift);

   if (macd > macdSignal) {
      return (1);
   } else if (macd < macdSignal) {
      return (-1);
   }

   return (0);
}


int i_macd_change(string symbol, int period, int shift, int fast_ema_period, int slow_ema_period, int signal_period, 
   int applied_price)
{
   double macd = iMACD(symbol, period, 
   fast_ema_period, slow_ema_period, signal_period, 
   applied_price, MODE_MAIN, shift);

   if (macd > 0) {
      return (1);
   } else if (macd < 0) {
      return (-1);
   }

   return (0);
}


int i_heiken(string symbol, int period, int shift)
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


int i_tenkan_kijun(string symbol, int period, int shift, int tenkan_sen, int kijun_sen, int senkou_span_b)
{
   double tenkan_sen_1=iIchimoku(symbol, period, tenkan_sen, kijun_sen, senkou_span_b, MODE_TENKANSEN, shift);
   double kijun_sen_1=iIchimoku(symbol, period, tenkan_sen, kijun_sen, senkou_span_b, MODE_KIJUNSEN, shift);
         
   if (tenkan_sen_1 > kijun_sen_1) {
      return (1);
   } else if (tenkan_sen_1 < kijun_sen_1) {
      return (-1);
   }

   return (0);
}

int i_tenkan(string symbol, int period, int shift, int tenkan_sen, int kijun_sen, int senkou_span_b)
{
   double tenkan_sen_1=iIchimoku(symbol, period, tenkan_sen, kijun_sen, senkou_span_b, MODE_TENKANSEN, shift);
         
   if (tenkan_sen_1 < iClose(symbol, period, shift)) {
      return (1);
   } else if (tenkan_sen_1 > iClose(symbol, period, shift)) {
      return (-1);
   }

   return (0);
}
int i_kijun(string symbol, int period, int shift, int tenkan_sen, int kijun_sen, int senkou_span_b)
{
   double kijun_sen_1=iIchimoku(symbol, period, tenkan_sen, kijun_sen, senkou_span_b, MODE_KIJUNSEN, shift); 
         
   if (kijun_sen_1 < iClose(symbol, period, shift)) {
      return (1);
   } else if (kijun_sen_1 > iClose(symbol, period, shift)) {
      return (-1);
   }

   return (0);
}


int i_chinkouspan(string symbol, int period, int shift, int tenkan_sen, int kijun_sen, int senkou_span_b)
{
   double chinkouspan=iIchimoku(symbol, period, tenkan_sen, kijun_sen, senkou_span_b, MODE_CHINKOUSPAN, shift);
         
   if (chinkouspan > iHigh(symbol, period, 26)) {
      return (1);
   } else if (chinkouspan < iLow(symbol, period, 26)) {
      return (-1);
   }

   return (0);
}


int i_ichimoku(string symbol, int period, int shift, int tenkan_sen, int kijun_sen, int senkou_span_b)
{
   double tenkan_sen_1=iIchimoku(symbol, period, tenkan_sen, kijun_sen, senkou_span_b, MODE_TENKANSEN, shift);
   double kijun_sen_1=iIchimoku(symbol, period, tenkan_sen, kijun_sen, senkou_span_b, MODE_KIJUNSEN, shift);
   int chinkouspan=i_chinkouspan(symbol, period, shift, tenkan_sen, kijun_sen, senkou_span_b);
   double spanA=iIchimoku(symbol, period, tenkan_sen, kijun_sen, senkou_span_b, MODE_SENKOUSPANA, shift);
   double spanB=iIchimoku(symbol, period, tenkan_sen, kijun_sen, senkou_span_b, MODE_SENKOUSPANB, shift);
        
   if (tenkan_sen_1 > kijun_sen_1 && chinkouspan == 1 && iClose(symbol, period, shift) > spanA
      && iClose(symbol, period, shift) > spanB
   ) {
      return (1);
   } else if (tenkan_sen_1 < kijun_sen_1 && chinkouspan == -1 && iClose(symbol, period, shift) < spanA
      && iClose(symbol, period, shift) < spanB) {
      return (-1);
   }

   return (0);
}


   //method: MODE_SMA, MODE_EMA, MODE_SMMA, MODE_LWMA
   //price_field: Price field parameter. Can be one of this values: 0 - Low/High or 1 - Close/Close.
   //k=14, d=3, slowing=3, method: mode_sma, price_field: 0
int i_stoch_cross(string symbol, int period, int shift, int Kperiod, int Dperiod, int slowing, int method, int price_field)
{
   double val2 = iStochastic(symbol,period,Kperiod,Dperiod,slowing,method,price_field,MODE_MAIN,shift);
   double val3 = iStochastic(symbol,period,Kperiod,Dperiod,slowing,method,price_field,MODE_SIGNAL,shift);
         
   if (val2 > val3) {
      return (1);
   } else if (val2 < val3) {
      return (-1);
   }

   return (0);
}

int i_stoch_level(string symbol, int period, int shift, int Kperiod, int Dperiod, int slowing, int method, int price_field
   , int level_top, int level_bottom
)
{
   double val2 = iStochastic(symbol,period,Kperiod,Dperiod,slowing,method,price_field,MODE_MAIN,shift);
         
   if (val2 < level_bottom) {
      return (1);
   } else if (val2 > level_top) {
      return (-1);
   }

   return (0);
}


int i_sar(string symbol, int period, int shift)
{
   double val2 = iSAR(symbol, period, 0.02, 0.2, shift);
         
   if (val2 < iLow(symbol, period, shift)) {
      return (1);
   } else if (val2 > iHigh(symbol, period, shift)) {
      return (-1);
   }

   return (0);
}


int i_fisher(string symbol, int period, int shift)
{
   double val2 = iCustom(symbol, period, "Fisher_no_repainting", 30, 0, shift);
   if (val2 > 0) {
      return (1);
   } else if (val2 < 0) {
      return (-1);
   }

   return (0);
}


int i_bbtrend(string symbol, int period, int shift)
{
   double val3 = iCustom(symbol, period, "Bollinger Bands_Stop_v2 ", 20, 1, 1.0, 1, 1, 1000, false, 4, shift);
   double val4 = iCustom(symbol, period, "Bollinger Bands_Stop_v2 ", 20, 1, 1.0, 1, 1, 1000, false, 5, shift);
   if (val3 == EMPTY_VALUE) return (-1);
   else if (val4 == EMPTY_VALUE) return (1);
   return (0);
}

/*
PRICE_CLOSE 0 Close price. 
PRICE_OPEN 1 Open price. 
PRICE_HIGH 2 High price. 
PRICE_LOW 3 Low price. 
PRICE_MEDIAN 4 Median price, (high+low)/2. 
PRICE_TYPICAL 5 Typical price, (high+low+close)/3. 
PRICE_WEIGHTED 6 Weighted close price, (high+low+close+close)/4.

Kperiod = 14
*/
int i_rsi_level(string symbol, int period, int shift, int Kperiod, int price_field)
{
   double val2 = iRSI(symbol,period,Kperiod,price_field,shift);
         
   if (val2 < 30) {
      return (1);
   } else if (val2 > 70) {
      return (-1);
   }

   return (0);
}

int i_cci_level(string symbol, int period, int shift, int Kperiod, int price_field)
{
   double val2 = iCCI(symbol,period,Kperiod,price_field,shift);
         
   if (val2 < -150) {
      return (1);
   } else if (val2 > 150) {
      return (-1);
   }

   return (0);
}



double i_avgbody(string symbol, int period, int shift)
{
   double sum=0;
   int aver_period = 5;
   for(int i=shift; i<=aver_period; i++) {
      double open = iOpen(symbol, period, i);
      double close = iClose(symbol, period, i);
      sum = sum + MathAbs(open-close);
   }
   sum=sum/aver_period;
   return (sum);
}

double i_midpointHighLow(string symbol, int period, int shift)
{
   double high = iHigh(symbol, period, shift);
   double low = iLow(symbol, period, shift);
   double midpoint = (high + low) / 2;
   return (midpoint);
}
double i_midpointOpenClose(string symbol, int period, int shift)
{
   double open = iOpen(symbol, period, shift);
   double close = iClose(symbol, period, shift);
   double midpoint = (open + close) / 2;
   return (midpoint);
}

int i_entry_bar(string symbol, int period, int shift)
{
   double open = iOpen(symbol, period, shift);
   double close = iClose(symbol, period, shift);
   double high = iHigh(symbol, period, shift);
   double low = iLow(symbol, period, shift);
   double top, bottom;
   if (open > close) {
      top = open;
      bottom = close;
   } else {
      top = close;
      bottom = open;
   }
   double topwix, bottomwix;
   topwix = high - top;
   bottomwix = bottom - low;
   double body = MathAbs(open - close);
   double upper = iBands(symbol, period,20,2,0,PRICE_CLOSE,MODE_UPPER,shift);
   double lower = iBands(symbol, period,20,2,0,PRICE_CLOSE,MODE_LOWER,shift);
   
   if (low < lower && bottomwix > (2 * body) && bottomwix > topwix) {
      return (1);
   } else if (high > upper && topwix > (2 * body) && topwix > bottomwix) {
      return (-1);
   }
   return (0);
}


int bb(string symbol, int period, int shift)
{
   double bbh = iBands(symbol,period,20,2,0,PRICE_CLOSE,MODE_UPPER,shift);
   double bbl = iBands(symbol,period,20,2,0,PRICE_CLOSE,MODE_LOWER,shift);
   double high1 = iHigh(symbol, period, shift);
   double high2 = iHigh(symbol, period, shift+1);
   double high3 = iHigh(symbol, period, shift+2);
   double low1 = iLow(symbol, period, shift);
   double low2 = iLow(symbol, period, shift+1);
   double low3 = iLow(symbol, period, shift+2);
   
   if (high1 < high2 && high2 > high3
      && (high1 >= bbh || high2 >= bbh || high3 >= bbh)
      ) {
      return (-1);
   } else if (low1 > low2 && low2 < low3
      && (low1 < bbl || low2 < bbl || low3 < bbl)
      ) {
      return (1);
   }
   return (0);
}

int i_engulf(string symbol, int period, int shift)
{
   double high1 = iHigh(symbol, period, shift);
   double high2 = iHigh(symbol, period, shift+1);
   double low1 = iLow(symbol, period, shift);
   double low2 = iLow(symbol, period, shift+1);
   double ma = iMA(symbol, period,20,0,MODE_SMA,PRICE_CLOSE,shift);
   if (high1 < high2 && low1 > low2 && high2 < ma) {
      return (1);
   } else if (high1 < high2 && low1 > low2 && low2 > ma) {
      return (-1);
   }
   return (0);
}

