//+------------------------------------------------------------------+
//|                                                  cu_ichimoku.mq4 |
//|                        Copyright 2012, Manish khanchandani       |
//|                                        http://www.mkgalaxy.com   |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
string symbols2[28] = {"USDCHF", "GBPUSD", "EURUSD", "USDJPY", "USDCAD", "AUDUSD", "EURGBP", "EURAUD", "EURJPY", "GBPCHF", "CADJPY", "GBPJPY", 
               "AUDCAD", "AUDCHF", "AUDJPY", "CHFJPY", "EURNZD", "EURCAD", "CADCHF", "NZDJPY", "NZDUSD", "GBPCAD", "GBPNZD", 
               "GBPAUD", "NZDCHF", "NZDCAD", "AUDNZD", "EURCHF"};
string symbols[10] = {"NZDUSD", "GBPUSD", "AUDUSD", "EURUSD", "EURJPY", "USDCHF", "USDCAD", "CADCHF", "NZDJPY",  
               "GBPAUD"};
int limit = 10;
int symbolx = 10;
int teikenx = 100;
int heikenx = 180;
int macdx = 230;
int rsix = 270;
int imax = 310;
int stochx = 360;
int isarx = 420;
int strengthx = 470;
int ccix = 670;
int resultx = 720;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   ObjectDelete("currency");
   ObjectDelete("indicator");
   ObjectDelete("tekiensen");
   ObjectDelete("heiken");
   ObjectDelete("cci");
   ObjectDelete("macd");
   ObjectDelete("rsi");
   ObjectDelete("ima");
   ObjectDelete("stoch");
   ObjectDelete("isar");
   ObjectDelete("strength");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectDelete("currency");
   ObjectDelete("indicator");
   ObjectDelete("tekiensen");
   ObjectDelete("heiken");
   ObjectDelete("cci");
   ObjectDelete("macd");
   ObjectDelete("rsi");
   ObjectDelete("ima");
   ObjectDelete("stoch");
   ObjectDelete("isar");
   ObjectDelete("strength");
   ObjectDelete("lookup");
   string name;
   int c;
   for (c = 0; c < 28; c++) {
      name = symbols[c] + "_lbl";
      ObjectDelete(name);
      name = "ichimokutype1"+c;
      ObjectDelete(name);
      name = "heiken"+c;
      ObjectDelete(name);
      name = "cci"+c;
      ObjectDelete(name);
      name = "result"+c;
      ObjectDelete(name);
      name = "macd"+c;
      ObjectDelete(name);
      name = "rsi"+c;
      ObjectDelete(name);
      name = "ima"+c;
      ObjectDelete(name);
      name = "stoch"+c;
      ObjectDelete(name);
      name = "isar"+c;
      ObjectDelete(name);
      name = "strength"+c;
      ObjectDelete(name);
      name = "strength2"+c;
      ObjectDelete(name);
   }
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
   objectcreate("currency", symbolx, 20, "Currency", White);
   objectcreate("tekiensen", teikenx, 20, "Tekien Sen", White);
   objectcreate("heiken", heikenx, 20, "Heiken", White);
   objectcreate("macd", macdx, 20, "Macd", White);
   objectcreate("rsi", rsix, 20, "RSI", White);
   objectcreate("ima", imax, 20, "IMA", White);
   objectcreate("stoch", stochx, 20, "Stoch", White);
   objectcreate("isar", isarx, 20, "Isar", White);
   objectcreate("strength", strengthx, 20, "Strength", White);
   objectcreate("cci", ccix, 20, "CCI", White);
   ObjectDelete("lookup");
   int c;
   int x;
   int y;
   string name;
   string mes;
   double tenkan_sen_1, tenkan_sen_2;
   double val, val2, val3;
   double bid, ask, point, digits, spread;
   double open, close, high, low;
   double increment = 0.1;
   double totalpoints, points;
   double higher = -1;
      double lower = -1;
      double higher2, lower2, aRange, aRatio, aLookup, aStrength;
      int z;
      string name2;
   for (c = 0; c < limit; c++) {
      totalpoints = 0;
      points = 0;
      
      name = symbols[c] + "_lbl";
      x = symbolx;
      y = (c * 16) + 40;
      mes = (c+1) + ". " + symbols[c];
      ObjectDelete(name);
      objectcreate(name, x, y, mes, Green);
      bid = MarketInfo(symbols[c], MODE_BID);
      ask = MarketInfo(symbols[c], MODE_ASK);
      point = MarketInfo(symbols[c], MODE_POINT);
      digits = MarketInfo(symbols[c], MODE_DIGITS);
      spread = MarketInfo(symbols[c], MODE_SPREAD);
      open = iOpen(symbols[c], Period(), 0);
      close = iClose(symbols[c], Period(), 0);
      high = iHigh(symbols[c], Period(), 0);
      low = iLow(symbols[c], Period(), 0);
      tenkan_sen_1=iIchimoku(symbols[c], Period(), 9, 26, 52, MODE_TENKANSEN, 0);
      tenkan_sen_2=iIchimoku(symbols[c], Period(), 9, 26, 52, MODE_TENKANSEN, 1);
      x = teikenx + 30;
      name = "ichimokutype1"+c;
      totalpoints = totalpoints + increment;
      ObjectDelete(name);
      if (tenkan_sen_1 > tenkan_sen_2) {
         create_arrow(name, x, y, 1);
         points = points + increment;
      } else if (tenkan_sen_1 < tenkan_sen_2) {
         create_arrow(name, x, y, -1);
         points = points - increment;
      } else {
         create_arrow(name, x, y, 0);
      }
 
      val2 = iCustom(symbols[c], Period(), "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(symbols[c], Period(), "Heiken_Ashi_Smoothed",3,0);
      x = heikenx + 10;
      name = "heiken"+c;
      totalpoints = totalpoints + increment;
      ObjectDelete(name);
      if (val2 < val3) {
         create_arrow(name, x, y, 1);
         points = points + increment;
      } else if (val2 > val3) {
         create_arrow(name, x, y, -1);
         points = points - increment;
      } else {
         create_arrow(name, x, y, 0);
      }
      
         val2 = iCustom(symbols[c], Period(), "MACD_Complete",1,0);
         val3 = iCustom(symbols[c], Period(), "MACD_Complete",2,0);
      x = macdx + 10;
      name = "macd"+c;
      totalpoints = totalpoints + increment;
      ObjectDelete(name);
      if (val2 > val3) {
         create_arrow(name, x, y, 1);
         points = points + increment;
      } else if (val2 < val3) {
         create_arrow(name, x, y, -1);
         points = points - increment;
      } else {
         create_arrow(name, x, y, 0);
      }

        val = iRSI(symbols[c], Period(),7,PRICE_CLOSE,0);
      x = rsix + 10;
      name = "rsi"+c;
      totalpoints = totalpoints + increment;
      ObjectDelete(name);
      if (val > 70) {
         create_arrow(name, x, y, 1);
         points = points + increment;
      } else if (val < 30) {
         create_arrow(name, x, y, -1);
         points = points - increment;
      } else {
         create_arrow(name, x, y, 0);
      }
      
      
         val = iMA(symbols[c], Period(),17,0,MODE_EMA,PRICE_CLOSE,0);
         val2 = iMA(symbols[c], Period(),43,0,MODE_EMA,PRICE_CLOSE,0);
      x = imax + 10;
      name = "ima"+c;
      totalpoints = totalpoints + increment;
      ObjectDelete(name);
      if (val > val2) {
         create_arrow(name, x, y, 1);
         points = points + increment;
      } else if (val < val2) {
         create_arrow(name, x, y, -1);
         points = points - increment;
      } else {
         create_arrow(name, x, y, 0);
      }

         val = iStochastic(symbols[c], Period(),14,3,3,MODE_SMA,0,MODE_MAIN,0);
         val2 = iStochastic(symbols[c], Period(),14,3,3,MODE_SMA,0,MODE_SIGNAL,0);
      x = stochx + 10;
      name = "stoch"+c;
      totalpoints = totalpoints + increment;
      ObjectDelete(name);
      if (val > val2) {
         create_arrow(name, x, y, 1);
         points = points + increment;
      } else if (val < val2) {
         create_arrow(name, x, y, -1);
         points = points - increment;
      } else {
         create_arrow(name, x, y, 0);
      }
         val = iSAR(symbols[c], Period(),0.02,0.2,0);
         x = isarx + 10;
      name = "isar"+c;
      totalpoints = totalpoints + increment;
      ObjectDelete(name);
      if (val < iOpen(symbols[c], Period(), 0)) {
         create_arrow(name, x, y, 1);
         points = points + increment;
      } else if (val > iOpen(symbols[c], Period(), 0)) {
         create_arrow(name, x, y, -1);
         points = points - increment;
      } else {
         create_arrow(name, x, y, 0);
      }
         
      higher = -1;
      lower = -1;
      
      for (z=0; z<4; z++) {
         if (higher == -1) {
            higher = iHigh(symbols[c], PERIOD_H4, z);
         }
         if (iHigh(symbols[c], PERIOD_H4, z) > higher) {
            higher = iHigh(symbols[c], PERIOD_H4, z);
         }
         if (lower == -1) {
            lower = iLow(symbols[c], PERIOD_H4, z);
         }
         if (iLow(symbols[c], PERIOD_H4, z) < lower) {
            lower = iLow(symbols[c], PERIOD_H4, z);
         }
      }
      aRange    = MathMax((higher-low)/point,1); 
      aRatio    = (bid-lower)/aRange/point;
      aLookup   = iLookup(aRatio*100); 
      aStrength = 9-aLookup; 
      x = strengthx;
      name = "strength"+c;
      name2 = "strength2"+c;
      totalpoints = totalpoints + increment;
      ObjectDelete(name);
      ObjectDelete(name2);
      if (aLookup > aStrength) {
         create_arrow(name, x, y, 1);
         points = points + increment;
         mes = DoubleToStr(aLookup, 1) + "/" + DoubleToStr(aStrength, 1);
         objectcreate(name2, x+20, y, mes, Blue);
      } else if (aLookup < aStrength) {
         create_arrow(name, x, y, -1);
         mes = DoubleToStr(aLookup, 1) + "/" + DoubleToStr(aStrength, 1);
         objectcreate(name2, x+20, y, mes, Red);
         points = points - increment;
      } else {
         create_arrow(name, x, y, 0);
      }
      
      val = iCCI(symbols[c], Period(),45,PRICE_CLOSE,0);
      x = ccix + 10;
      name = "cci"+c;
      totalpoints = totalpoints + increment;
      ObjectDelete(name);
      if (val > 100) {
         create_arrow(name, x, y, 1);
         points = points + increment;
      } else if (val < -100) {
         create_arrow(name, x, y, -1);
         points = points - increment;
      } else {
         create_arrow(name, x, y, 0);
      }

      x = resultx;
      name = "result"+c;
      ObjectDelete(name);
      mes = DoubleToStr(points, 2) + "/" + DoubleToStr(totalpoints, 2) + "/" + symbols[c];
      if (points > 0) {
         objectcreate(name, x, y, mes, Blue);
      } else if (points < 0) {
         objectcreate(name, x, y, mes, Red);
      } else {
         objectcreate(name, x, y, mes, Green);
      }
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+


int iLookup(double ratio)                                                   // this function will return a grade value
  {                                                                         // based on its power.
   int    aTable[10]  = {0,3,10,25,40,50,60,75,90,97};                 // grade table for currency's power
   int   index;
   
   if      (ratio <= aTable[0]) index = 0;
   else if (ratio < aTable[1])  index = 0;
   else if (ratio < aTable[2])  index = 1;
   else if (ratio < aTable[3])  index = 2;
   else if (ratio < aTable[4])  index = 3;
   else if (ratio < aTable[5])  index = 4;
   else if (ratio < aTable[6])  index = 5;
   else if (ratio < aTable[7])  index = 6;
   else if (ratio < aTable[8])  index = 7;
   else if (ratio < aTable[9])  index = 8;
   else                         index = 9;
   return(index);                                                           // end of iLookup function
  }
  
  
int objectcreate(string name, int x, int y, string message, color colors)
{
   if (ObjectCreate(name, OBJ_LABEL, 0, 0, 0)) {
      ObjectSet(name, OBJPROP_CORNER, 0);
      ObjectSet(name, OBJPROP_XDISTANCE, x);
      ObjectSet(name, OBJPROP_YDISTANCE, y);
      ObjectSetText(name, message, 10, "Verdana", colors);
   }
}


void create_arrow(string name, int x, int y, int trend)
{
   if (ObjectCreate(name, OBJ_LABEL, 0, 0, 0)) {
      ObjectSet(name, OBJPROP_CORNER, 0);
      ObjectSet(name, OBJPROP_XDISTANCE, x);
      ObjectSet(name, OBJPROP_YDISTANCE, y);
      string text = "";
      color color_code;
      if (trend == 1) {
         text = CharToStr(233);
         color_code = Blue;
      } else if (trend == -1) {
         text = CharToStr(234);
         color_code = Red;
      } else {
         text = CharToStr(232);
         color_code = Gold;
      }
      
      ObjectSetText(name, text, 10, "Wingdings", color_code);
   }
}


