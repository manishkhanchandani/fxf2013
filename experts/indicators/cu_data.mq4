//+------------------------------------------------------------------+
//|                                                      cu_data.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window

double val, val2, val3, val4, val5, val6, val7, val8, val9, val10;
int period[9] = {PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4, PERIOD_D1, PERIOD_W1, PERIOD_MN1};
int limit = 7;
int openTime;
int openTime2;
int openTime3;
int condition_strategy[50][9]; //condition[strategy][timeperiod]

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   delete_object();
   create_heading();
   create_side_items();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   delete_object();
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
   custom_start();
//----
   return(0);
  }
//+------------------------------------------------------------------+


void custom_start()
{
   calculate_heiken();
   calculate_macd();
   calculate_cci();
   calculate_rsi();
   //calculate_tksen();
   calculate_ema_17_43();
   calculate_bb();
   //macdrev();
   //calculate_mom();
   //calculate_trend();
   //calculate_pricezone();
   //history();
   
   string name = "suggestion_text";
   
      val2 = iCustom(NULL, PERIOD_H1, "Heiken_Ashi_Smoothed",2,1);
      val3 = iCustom(NULL, PERIOD_H1, "Heiken_Ashi_Smoothed",3,1);
      val4 = iCustom(NULL, PERIOD_H1, "Heiken_Ashi_Smoothed",2,2);
      val5 = iCustom(NULL, PERIOD_H1, "Heiken_Ashi_Smoothed",3,2);
      if (val2 < val3 && val4 > val5) {
         ObjectDelete("suggestion_text");
         create_label(name, 100, 20, "Buy Condition Exists", Blue);
      } else if (val2 > val3 && val4 < val5) {
         ObjectDelete("suggestion_text");
         create_label(name, 100, 20, "Sell Condition Exists", Red);
      } else {
         ObjectDelete("suggestion_text");
         create_label(name, 100, 20, "Consolidation", Gold);
      }
      /*
   if (
      condition_strategy[1][0] == 1
      && condition_strategy[1][1] == 1
      && condition_strategy[1][2] == 1
      && condition_strategy[1][3] == 1
      && condition_strategy[1][4] == 1
      && condition_strategy[3][0] == 1
      && condition_strategy[3][1] == 1
      && condition_strategy[3][2] == 1
      && condition_strategy[3][3] == 1
      && condition_strategy[3][4] == 1
      && condition_strategy[5][0] == 1
      && condition_strategy[5][1] == 1
      && condition_strategy[5][2] == 1
      && condition_strategy[5][3] == 1
      && condition_strategy[5][4] == 1
   ) {
      ObjectDelete("suggestion_text");
      create_label(name, 100, 20, "Buy Condition Exists", Blue);
      if (openTime != Time[0]) {
         Alert(Symbol(), ", Buy Condition");
         openTime = Time[0];
      }
   } else if(
      condition_strategy[1][0] == -1
      && condition_strategy[1][1] == -1
      && condition_strategy[1][2] == -1
      && condition_strategy[1][3] == -1
      && condition_strategy[1][4] == -1
      && condition_strategy[3][0] == -1
      && condition_strategy[3][1] == -1
      && condition_strategy[3][2] == -1
      && condition_strategy[3][3] == -1
      && condition_strategy[3][4] == -1
      && condition_strategy[5][0] == -1
      && condition_strategy[5][1] == -1
      && condition_strategy[5][2] == -1
      && condition_strategy[5][3] == -1
      && condition_strategy[5][4] == -1
   ) {
      ObjectDelete("suggestion_text");
      create_label(name, 100, 20, "Sell Condition Exists", Red);
      if (openTime2 != Time[0]) {
         Alert(Symbol(), ", Sell Condition");
         openTime2 = Time[0];
      }
   } else {
      ObjectDelete("suggestion_text");
      create_label(name, 100, 20, "Consolidation", Gold);
   }*/
}


void delete_object()
{
   ObjectDelete("suggestion_text");
   ObjectDelete("suggestionlbl");
   ObjectDelete("m1_0");
   ObjectDelete("m5_0");
   ObjectDelete("m15_0");
   ObjectDelete("m30_0");
   ObjectDelete("h1_0");
   ObjectDelete("h4_0");
   ObjectDelete("d1_0");
   ObjectDelete("w1_0");
   ObjectDelete("mo1_0");
   ObjectDelete("heikenlbl");
   ObjectDelete("macdlbl");
   ObjectDelete("ccilbl");
   ObjectDelete("rsilbl");
   ObjectDelete("tksenlbl");
   ObjectDelete("kumolbl");
   ObjectDelete("chinkobl");
   ObjectDelete("spanAblbl");
   ObjectDelete("bblbl");
   ObjectDelete("momlbl");
   ObjectDelete("trendlbl");
   ObjectDelete("pricezonelbl");
   ObjectDelete("emalbl");
   string name;
   for (int i = 0; i < 9; i++) {
      name = "heiken"+i;
      ObjectDelete(name);
      name = "macd"+i;
      ObjectDelete(name);
      name = "cci"+i;
      ObjectDelete(name);
      name = "rsi"+i;
      ObjectDelete(name);
      name = "tksen"+i;
      ObjectDelete(name);
      name = "kumo"+i;
      ObjectDelete(name);
      name = "chinko"+i;
      ObjectDelete(name);
      name = "spanAB"+i;
      ObjectDelete(name);
      name = "bb"+i;
      ObjectDelete(name);
      name = "mom"+i;
      ObjectDelete(name);
      name = "trend"+i;
      ObjectDelete(name);
      name = "pricezone"+i;
      ObjectDelete(name);
      name = "ema_17_43"+i;
      ObjectDelete(name);
   }
   ObjectDelete("historylbl");
   ObjectDelete("history_day_0");
   ObjectDelete("history_day_0a");
   ObjectDelete("history_day_1");
   ObjectDelete("history_day_1a");
   ObjectDelete("history_day_2");
   ObjectDelete("history_day_2a");
   ObjectDelete("history_day_3");
   ObjectDelete("history_day_3a");
   ObjectDelete("macdrevlbl");
   ObjectDelete("macdrev_0");
}

void create_heading()
{
   if (ObjectCreate("m1_0", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("m1_0", OBJPROP_CORNER, 1);
      ObjectSet("m1_0", OBJPROP_XDISTANCE, 200);
      ObjectSet("m1_0", OBJPROP_YDISTANCE, 40);
      ObjectSetText("m1_0", "M1", 10, "Verdana", Blue);
   }
   if (ObjectCreate("m5_0", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("m5_0", OBJPROP_CORNER, 1);
      ObjectSet("m5_0", OBJPROP_CORNER, 1);
      ObjectSet("m5_0", OBJPROP_XDISTANCE, 170);
      ObjectSet("m5_0", OBJPROP_YDISTANCE, 40);
      ObjectSetText("m5_0", "M5", 10, "Verdana", Blue);
   }
   if (ObjectCreate("m15_0", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("m15_0", OBJPROP_CORNER, 1);
      ObjectSet("m15_0", OBJPROP_XDISTANCE, 140);
      ObjectSet("m15_0", OBJPROP_YDISTANCE, 40);
      ObjectSetText("m15_0", "M15", 10, "Verdana", Blue);
   }
   if (ObjectCreate("m30_0", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("m30_0", OBJPROP_CORNER, 1);
      ObjectSet("m30_0", OBJPROP_XDISTANCE, 110);
      ObjectSet("m30_0", OBJPROP_YDISTANCE, 40);
      ObjectSetText("m30_0", "M30", 10, "Verdana", Blue);
   }
   if (ObjectCreate("h1_0", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("h1_0", OBJPROP_CORNER, 1);
      ObjectSet("h1_0", OBJPROP_XDISTANCE, 80);
      ObjectSet("h1_0", OBJPROP_YDISTANCE, 40);
      ObjectSetText("h1_0", "H1", 10, "Verdana", Blue);
   }
   if (ObjectCreate("h4_0", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("h4_0", OBJPROP_CORNER, 1);
      ObjectSet("h4_0", OBJPROP_XDISTANCE, 50);
      ObjectSet("h4_0", OBJPROP_YDISTANCE, 40);
      ObjectSetText("h4_0", "H4", 10, "Verdana", Blue);
   }
   if (ObjectCreate("d1_0", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("d1_0", OBJPROP_CORNER, 1);
      ObjectSet("d1_0", OBJPROP_XDISTANCE, 20);
      ObjectSet("d1_0", OBJPROP_YDISTANCE, 40);
      ObjectSetText("d1_0", "D", 10, "Verdana", Blue);
   }
   /*
   if (ObjectCreate("w1_0", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("w1_0", OBJPROP_CORNER, 1);
      ObjectSet("w1_0", OBJPROP_XDISTANCE, 60);
      ObjectSet("w1_0", OBJPROP_YDISTANCE, 40);
      ObjectSetText("w1_0", "W", 10, "Verdana", Blue);
   }
   if (ObjectCreate("mo1_0", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("mo1_0", OBJPROP_CORNER, 1);
      ObjectSet("mo1_0", OBJPROP_XDISTANCE, 20);
      ObjectSet("mo1_0", OBJPROP_YDISTANCE, 40);
      ObjectSetText("mo1_0", "Mo", 10, "Verdana", Blue);
   }*/
}

void create_side_items()
{
   if (ObjectCreate("suggestionlbl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("suggestionlbl", OBJPROP_CORNER, 1);
      ObjectSet("suggestionlbl", OBJPROP_XDISTANCE, 220);
      ObjectSet("suggestionlbl", OBJPROP_YDISTANCE, 20);
      ObjectSetText("suggestionlbl", "S", 10, "Verdana", Blue);
   }
   if (ObjectCreate("heikenlbl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("heikenlbl", OBJPROP_CORNER, 1);
      ObjectSet("heikenlbl", OBJPROP_XDISTANCE, 220);
      ObjectSet("heikenlbl", OBJPROP_YDISTANCE, 60);
      ObjectSetText("heikenlbl", "H", 10, "Verdana", Blue); //Heiken
   }
   if (ObjectCreate("macdlbl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("macdlbl", OBJPROP_CORNER, 1);
      ObjectSet("macdlbl", OBJPROP_XDISTANCE, 220);
      ObjectSet("macdlbl", OBJPROP_YDISTANCE, 80);
      ObjectSetText("macdlbl", "M", 10, "Verdana", Blue); //MACD
   }
   if (ObjectCreate("ccilbl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("ccilbl", OBJPROP_CORNER, 1);
      ObjectSet("ccilbl", OBJPROP_XDISTANCE, 220);
      ObjectSet("ccilbl", OBJPROP_YDISTANCE, 100);
      ObjectSetText("ccilbl", "C", 10, "Verdana", Blue); //CCI
   }
   if (ObjectCreate("rsilbl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("rsilbl", OBJPROP_CORNER, 1);
      ObjectSet("rsilbl", OBJPROP_XDISTANCE, 220);
      ObjectSet("rsilbl", OBJPROP_YDISTANCE, 120);
      ObjectSetText("rsilbl", "R", 10, "Verdana", Blue); //RSI
   }
   /*if (ObjectCreate("tksenlbl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("tksenlbl", OBJPROP_CORNER, 1);
      ObjectSet("tksenlbl", OBJPROP_XDISTANCE, 220);
      ObjectSet("tksenlbl", OBJPROP_YDISTANCE, 140);
      ObjectSetText("tksenlbl", "T", 10, "Verdana", Blue); //TikenSen
   }
   if (ObjectCreate("kumolbl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("kumolbl", OBJPROP_CORNER, 1);
      ObjectSet("kumolbl", OBJPROP_XDISTANCE, 220);
      ObjectSet("kumolbl", OBJPROP_YDISTANCE, 160);
      ObjectSetText("kumolbl", "K", 10, "Verdana", Blue); //Kumo
   }
   if (ObjectCreate("chinkobl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("chinkobl", OBJPROP_CORNER, 1);
      ObjectSet("chinkobl", OBJPROP_XDISTANCE, 220);
      ObjectSet("chinkobl", OBJPROP_YDISTANCE, 180);
      ObjectSetText("chinkobl", "C", 10, "Verdana", Blue); //Chinkospan
   }
   if (ObjectCreate("spanAblbl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("spanAblbl", OBJPROP_CORNER, 1);
      ObjectSet("spanAblbl", OBJPROP_XDISTANCE, 220);
      ObjectSet("spanAblbl", OBJPROP_YDISTANCE, 200);
      ObjectSetText("spanAblbl", "S", 10, "Verdana", Blue); //SpanAB
   }*/
   if (ObjectCreate("emalbl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("emalbl", OBJPROP_CORNER, 1);
      ObjectSet("emalbl", OBJPROP_XDISTANCE, 220);
      ObjectSet("emalbl", OBJPROP_YDISTANCE, 140);
      ObjectSetText("emalbl", "E", 10, "Verdana", Blue); //EMA 17/43
   }
   if (ObjectCreate("bblbl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("bblbl", OBJPROP_CORNER, 1);
      ObjectSet("bblbl", OBJPROP_XDISTANCE, 220);
      ObjectSet("bblbl", OBJPROP_YDISTANCE, 160);
      ObjectSetText("bblbl", "B", 10, "Verdana", Blue); //Bollinger
   }
   /*
   if (ObjectCreate("macdrevlbl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("macdrevlbl", OBJPROP_CORNER, 1);
      ObjectSet("macdrevlbl", OBJPROP_XDISTANCE, 370);
      ObjectSet("macdrevlbl", OBJPROP_YDISTANCE, 220);
      ObjectSetText("macdrevlbl", "MACD Reversal", 10, "Verdana", White);
   }
   if (ObjectCreate("momlbl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("momlbl", OBJPROP_CORNER, 1);
      ObjectSet("momlbl", OBJPROP_XDISTANCE, 370);
      ObjectSet("momlbl", OBJPROP_YDISTANCE, 240);
      ObjectSetText("momlbl", "Momentum Indicator", 10, "Verdana", White);
   }
   if (ObjectCreate("trendlbl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("trendlbl", OBJPROP_CORNER, 1);
      ObjectSet("trendlbl", OBJPROP_XDISTANCE, 370);
      ObjectSet("trendlbl", OBJPROP_YDISTANCE, 260);
      ObjectSetText("trendlbl", "Trend Forecast", 10, "Verdana", White);
   }
   if (ObjectCreate("pricezonelbl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("pricezonelbl", OBJPROP_CORNER, 1);
      ObjectSet("pricezonelbl", OBJPROP_XDISTANCE, 370);
      ObjectSet("pricezonelbl", OBJPROP_YDISTANCE, 280);
      ObjectSetText("pricezonelbl", "Price Zone", 10, "Verdana", White);
   }
   */
}

void create_label(string name, int x, int y, string text, color textcolor)
{
   if (ObjectCreate(name, OBJ_LABEL, 0, 0, 0)) {
      ObjectSet(name, OBJPROP_CORNER, 1);
      ObjectSet(name, OBJPROP_XDISTANCE, x);
      ObjectSet(name, OBJPROP_YDISTANCE, y);
      ObjectSetText(name, text, 10, "Verdana", textcolor);
   }
}
void create_label_v2(string name, int x, int y, string text, color textcolor, int corner)
{
   if (ObjectCreate(name, OBJ_LABEL, 0, 0, 0)) {
      ObjectSet(name, OBJPROP_CORNER, corner);
      ObjectSet(name, OBJPROP_XDISTANCE, x);
      ObjectSet(name, OBJPROP_YDISTANCE, y);
      ObjectSetText(name, text, 10, "Verdana", textcolor);
   }
}
void create_arrow(string name, int x, int y, int trend)
{
   if (ObjectCreate(name, OBJ_LABEL, 0, 0, 0)) {
      ObjectSet(name, OBJPROP_CORNER, 1);
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
void calculate_heiken()
{
   //0
   string name;
   int base = 200;
   int x;
   int y = 60;
   for (int i = 0; i < limit; i++) {
      name = "heiken"+i;
      x = base - (i * 30);
      val2 = iCustom(NULL, period[i], "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(NULL, period[i], "Heiken_Ashi_Smoothed",3,0);
      ObjectDelete(name);
      if (val2 < val3) {
         create_arrow(name, x, y, 1);
      } else if (val2 > val3) {
         create_arrow(name, x, y, -1);
      } else {
         create_arrow(name, x, y, 0);
      }
   }
}

void calculate_macd()
{
   //1
   int condition[9];
   string name;
   int base = 200;
   int x;
   int y = 80;
   for (int i = 0; i < limit; i++) {
      name = "macd"+i;
      x = base - (i * 30);
      val2 = iCustom(NULL, period[i], "MACD_Complete",1,0);
      val3 = iCustom(NULL, period[i], "MACD_Complete",2,0);
      ObjectDelete(name);
      if (val2 > val3 && val2 > 0) {
         create_arrow(name, x, y, 1);
         condition_strategy[1][i] = 1;
      } else if (val2 < val3 && val2 < 0) {
         create_arrow(name, x, y, -1);
         condition_strategy[1][i] = -1;
      } else {
         create_arrow(name, x, y, 0);
         condition_strategy[1][i] = 0;
      }
   }
   /*
   val4 = iCustom(NULL, PERIOD_H1, "MACD_Complete",1,1);
   val5 = iCustom(NULL, PERIOD_H1, "MACD_Complete",2,1);
   if (condition[4] == 1 && val4 < val5 && openTime3 != Time[0]) {
      Alert(Symbol(), " MACD Buy Condition Exists");
      openTime3 = Time[0];
   } else if (condition[4] == -1 && val4 > val5 && openTime3 != Time[0]) {
      Alert(Symbol(), " MACD Sell Condition Exists");
      openTime3 = Time[0];
   }
   */
}
void calculate_cci()
{
   //2
   string name;
   int base = 200;
   int x;
   int y = 100;
   for (int i = 0; i < limit; i++) {
      name = "cci"+i;
      x = base - (i * 30);
      val = iCCI(NULL,period[i],45,PRICE_CLOSE,0);
      ObjectDelete(name);
      if (val > 100) {
         create_arrow(name, x, y, 1);
         condition_strategy[2][i] = 1;
      } else if (val < -100) {
         create_arrow(name, x, y, -1);
         condition_strategy[2][i] = -1;
      } else {
         create_arrow(name, x, y, 0);
         condition_strategy[2][i] = 0;
      }
   }
}
void calculate_rsi()
{
   string name;
   int base = 200;
   int x;
   int y = 120;
   for (int i = 0; i < limit; i++) {
      name = "rsi"+i;
      x = base - (i * 30);
      val = iRSI(NULL,period[i],7,PRICE_CLOSE,0);
      ObjectDelete(name);
      if (val > 70) {
         create_arrow(name, x, y, 1);
         condition_strategy[3][i] = 1;
      } else if (val < 30) {
         create_arrow(name, x, y, -1);
         condition_strategy[3][i] = -1;
      } else {
         create_arrow(name, x, y, 0);
         condition_strategy[3][i] = 0;
      }
   }
}
void calculate_tksen()
{
   double tenkan_sen_1, kijun_sen_1, spanA, spanB, spanHigh, spanLow, chinkouspan;
   string name;
   int base = 200;
   int x;
   int y = 140;
   int i;
   for (i = 0; i < limit; i++) {
      name = "tksen"+i;
      x = base - (i * 30);
      tenkan_sen_1=iIchimoku(NULL,period[i], 9, 26, 52, MODE_TENKANSEN, 0);
      kijun_sen_1=iIchimoku(NULL,period[i], 9, 26, 52, MODE_KIJUNSEN, 0);
      ObjectDelete(name);
      if (tenkan_sen_1 > kijun_sen_1) {
         create_arrow(name, x, y, 1);
      } else if (tenkan_sen_1 < kijun_sen_1) {
         create_arrow(name, x, y, -1);
      } else {
         create_arrow(name, x, y, 0);
      }
   }
   y = 160;
   for (i = 0; i < limit; i++) {
      name = "kumo"+i;
      x = base - (i * 30);
      spanA = iIchimoku(NULL,period[i], 9, 26, 52, MODE_SENKOUSPANA, 0);
      spanB = iIchimoku(NULL,period[i], 9, 26, 52, MODE_SENKOUSPANB, 0);
      if (spanA > spanB) {
         spanHigh = spanA;
         spanLow = spanB;
      } else {
         spanHigh = spanB;
         spanLow = spanA;
      }
      ObjectDelete(name);
      if (Bid > spanHigh) {
         create_arrow(name, x, y, 1);
      } else if (Bid < spanLow) {
         create_arrow(name, x, y, -1);
      } else {
         create_arrow(name, x, y, 0);
      }
   }
   y = 180;
   for (i = 0; i < limit; i++) {
      name = "chinko"+i;
      x = base - (i * 30);
      chinkouspan = iIchimoku(NULL,period[i], 9, 26, 52, MODE_CHINKOUSPAN, 0+26);
      ObjectDelete(name);
      if (chinkouspan > iHigh(Symbol(), period[i], 0+26)) {
         create_arrow(name, x, y, 1);
      } else if (chinkouspan < iLow(Symbol(), period[i], 0+26)) {
         create_arrow(name, x, y, -1);
      } else {
         create_arrow(name, x, y, 0);
      }
   }
   y = 200;
   for (i = 0; i < limit; i++) {
      name = "spanAB"+i;
      x = base - (i * 30);
      spanA = iIchimoku(NULL, period[i], 9, 26, 52, MODE_SENKOUSPANA, -26);
      spanB = iIchimoku(NULL, period[i], 9, 26, 52, MODE_SENKOUSPANB, -26);
      ObjectDelete(name);
      if (spanA > spanB) {
         create_arrow(name, x, y, 1);
      } else if (spanA < spanB) {
         create_arrow(name, x, y, -1);
      } else {
         create_arrow(name, x, y, 0);
      }
   }
}


void calculate_bb()
{
   string name;
   int base = 200;
   int x;
   int y = 160;
   for (int i = 0; i < limit; i++) {
      name = "bb"+i;
      x = base - (i * 30);
      val = iBands(NULL,period[i],12,2,0,PRICE_CLOSE,MODE_LOWER,0);
      val2 = iBands(NULL,period[i],12,2,0,PRICE_CLOSE,MODE_UPPER,0);
      if (Close[0] > val2) {
         create_arrow(name, x, y, 1);
         condition_strategy[4][i] = 1;
      } else if (Close[0] < val) {
         create_arrow(name, x, y, -1);
         condition_strategy[4][i] = -1;
      } else {
         create_arrow(name, x, y, 0);
         condition_strategy[4][i] = 0;
      }
   }
}
void calculate_mom()
{
   string name;
   int base = 200;
   int x;
   int y = 240;
   for (int i = 0; i < 9; i++) {
      name = "mom"+i;
      x = base - (i * 30);
      /*val = iRSI(NULL,period[i],7,PRICE_CLOSE,0);
      if (val > 70) {
         create_arrow(name, x, y, 1);
      } else if (val < 30) {
         create_arrow(name, x, y, -1);
      } else {
         create_arrow(name, x, y, 0);
      }*/
   }
}
void calculate_trend()
{
   string name;
   int base = 200;
   int x;
   int y = 260;
   for (int i = 0; i < 9; i++) {
      name = "rsi"+i;
      x = base - (i * 30);
      /*val = iRSI(NULL,period[i],7,PRICE_CLOSE,0);
      if (val > 70) {
         create_arrow(name, x, y, 1);
      } else if (val < 30) {
         create_arrow(name, x, y, -1);
      } else {
         create_arrow(name, x, y, 0);
      }*/
   }
}

void calculate_pricezone()
{
   string name;
   int base = 200;
   int x;
   int y = 280;
   for (int i = 0; i < 9; i++) {
      name = "rsi"+i;
      x = base - (i * 30);
      /*val = iRSI(NULL,period[i],7,PRICE_CLOSE,0);
      if (val > 70) {
         create_arrow(name, x, y, 1);
      } else if (val < 30) {
         create_arrow(name, x, y, -1);
      } else {
         create_arrow(name, x, y, 0);
      }*/
   }
}


int morning_star(int number, string symbol, int timeperiod)
{
   int i,j,k;
   i = number + 1;
   j = number + 2;
   k = number + 3;
   double avgbody = avgbody(iOpen(symbol, timeperiod, i), iClose(symbol, timeperiod, i));
}
int morning_doji()
{

}
double avgbody(double open, double close)
{
   double bd;
   if (open > close) {
      bd = open - close;
   } else {
      bd = close - open;
   }
   return (bd);
}

void history()
{
   return (0);
   string text;
   create_label_v2("historylbl", 20, 20, "HISTORY", White, 0);
   text = "Day 0: High: "+DoubleToStr(iHigh(Symbol(), PERIOD_D1, 0), Digits)+", Low: "+DoubleToStr(iLow(Symbol(), PERIOD_D1, 0), Digits)+", Diff: "+MathAbs(iHigh(Symbol(), PERIOD_D1, 0)-iLow(Symbol(), PERIOD_D1, 0));
   create_label_v2("history_day_0", 20, 40, text, White, 0);
   text = "Day 0: Open: "+DoubleToStr(iOpen(Symbol(), PERIOD_D1, 0), Digits)+", Close: "+DoubleToStr(iClose(Symbol(), PERIOD_D1, 0), Digits)+", Diff: "+MathAbs(iOpen(Symbol(), PERIOD_D1, 0)-iClose(Symbol(), PERIOD_D1, 0));
   create_label_v2("history_day_0a", 20, 60, text, White, 0);
   text = "Day 1: High: "+DoubleToStr(iHigh(Symbol(), PERIOD_D1, 1), Digits)+", Low: "+DoubleToStr(iLow(Symbol(), PERIOD_D1, 1), Digits)+", Diff: "+MathAbs(iHigh(Symbol(), PERIOD_D1, 1)-iLow(Symbol(), PERIOD_D1, 1));
   create_label_v2("history_day_1", 20, 80, text, White, 0);
   text = "Day 1: Open: "+DoubleToStr(iOpen(Symbol(), PERIOD_D1, 1), Digits)+", Close: "+DoubleToStr(iClose(Symbol(), PERIOD_D1, 1), Digits)+", Diff: "+MathAbs(iOpen(Symbol(), PERIOD_D1, 1)-iClose(Symbol(), PERIOD_D1, 1));
   create_label_v2("history_day_1a", 20, 100, text, White, 0);
   text = "Day 2: High: "+DoubleToStr(iHigh(Symbol(), PERIOD_D1, 2), Digits)+", Low: "+DoubleToStr(iLow(Symbol(), PERIOD_D1, 2), Digits)+", Diff: "+MathAbs(iHigh(Symbol(), PERIOD_D1, 2)-iLow(Symbol(), PERIOD_D1, 2));
   create_label_v2("history_day_2", 20, 120, text, White, 0);
   text = "Day 2: Open: "+DoubleToStr(iOpen(Symbol(), PERIOD_D1, 2), Digits)+", Close: "+DoubleToStr(iClose(Symbol(), PERIOD_D1, 2), Digits)+", Diff: "+MathAbs(iOpen(Symbol(), PERIOD_D1, 2)-iClose(Symbol(), PERIOD_D1, 2));
   create_label_v2("history_day_2a", 20, 140, text, White, 0);
   text = "Day 3: High: "+DoubleToStr(iHigh(Symbol(), PERIOD_D1, 3), Digits)+", Low: "+DoubleToStr(iLow(Symbol(), PERIOD_D1, 3), Digits)+", Diff: "+MathAbs(iHigh(Symbol(), PERIOD_D1, 3)-iLow(Symbol(), PERIOD_D1, 3));
   create_label_v2("history_day_3", 20, 160, text, White, 0);
   text = "Day 3: Open: "+DoubleToStr(iOpen(Symbol(), PERIOD_D1, 3), Digits)+", Close: "+DoubleToStr(iClose(Symbol(), PERIOD_D1, 3), Digits)+", Diff: "+MathAbs(iOpen(Symbol(), PERIOD_D1, 3)-iClose(Symbol(), PERIOD_D1, 3));
   create_label_v2("history_day_3a", 20, 180, text, White, 0);
}

void range()
{
   double val2, val3, val4, val5;
   val2 =ObjectGet("mml_txt10", OBJPROP_PRICE1);
   val3 =ObjectGet("mml_txt2", OBJPROP_PRICE1);
   int tmp = 0;
   int j;
   int i = 0;
   for (j = i; j <= 200; j++) {
      if (Close[j] < val3) {
         tmp = 1;
         break;
      } else if (Close[j] > val2) {
         tmp = -1;
         break;
      }
   }
   /*
   if (tmp == 0) {
      val4 =ObjectGet("mml_txt9", OBJPROP_PRICE1);
      val5 =ObjectGet("mml_txt3", OBJPROP_PRICE1);
      for (j = i; j <= 200; j++) {
         if (Close[j] < val5) {
            tmp = 1;
            break;
         } else if (Close[j] > val4) {
            tmp = -1;
            break;
         }
      }
   }*/
   string text;
   string name = "range_0";
   if (tmp == 1) {
      create_arrow(name, 340, 220, 1);
   } else if (tmp == -1) {
      create_arrow(name, 340, 220, -1);
   } else {
      create_arrow(name, 340, 220, 0);
   }
}

void macdrev()
{
   //macdrev_0
   //val2 = iCustom(NULL, period[i], "MACD_Complete",1,0);
   int l1 = 0;
   double l1val;
   int l2 = 0;
   double l2val;
   l1 = iLowest(Symbol(), PERIOD_M15, MODE_LOW, 64, 0);
   l1val = Low[l1];
   l2 = iLowest(Symbol(), PERIOD_M15, MODE_LOW, 64, l1+1);
   l2val = Low[l2];
   Comment("MACD REversal, l1: ", l1, ", l1val: ", DoubleToStr(l1val, Digits), ", l2: ", l2, ", l2val: ", DoubleToStr(l2val, Digits));
}

void calculate_ema_17_43()
{
   string name;
   int base = 200;
   int x;
   int y = 140;
   for (int i = 0; i < limit; i++) {
      name = "ema_17_43"+i;
      x = base - (i * 30);
      val = iMA(NULL,period[i],17,0,MODE_EMA,PRICE_CLOSE,0);
      val2 = iMA(NULL,period[i],43,0,MODE_EMA,PRICE_CLOSE,0);
      ObjectDelete(name);
      if (val > val2) {
         create_arrow(name, x, y, 1);
         condition_strategy[5][i] = 1;
      } else if (val < val2) {
         create_arrow(name, x, y, -1);
         condition_strategy[5][i] = -1;
      } else {
         create_arrow(name, x, y, 0);
         condition_strategy[5][i] = 0;
      }
   }
}