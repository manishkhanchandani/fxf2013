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
int openTime;
int openTime2;
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
   calculate_tksen();
   calculate_bb();
   calculate_mom();
   calculate_trend();
   calculate_pricezone();
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
   }
}

void create_heading()
{
   if (ObjectCreate("m1_0", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("m1_0", OBJPROP_CORNER, 1);
      ObjectSet("m1_0", OBJPROP_XDISTANCE, 340);
      ObjectSet("m1_0", OBJPROP_YDISTANCE, 40);
      ObjectSetText("m1_0", "M1", 10, "Verdana", White);
   }
   if (ObjectCreate("m5_0", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("m5_0", OBJPROP_CORNER, 1);
      ObjectSet("m5_0", OBJPROP_CORNER, 1);
      ObjectSet("m5_0", OBJPROP_XDISTANCE, 300);
      ObjectSet("m5_0", OBJPROP_YDISTANCE, 40);
      ObjectSetText("m5_0", "M5", 10, "Verdana", White);
   }
   if (ObjectCreate("m15_0", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("m15_0", OBJPROP_CORNER, 1);
      ObjectSet("m15_0", OBJPROP_XDISTANCE, 260);
      ObjectSet("m15_0", OBJPROP_YDISTANCE, 40);
      ObjectSetText("m15_0", "M15", 10, "Verdana", White);
   }
   if (ObjectCreate("m30_0", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("m30_0", OBJPROP_CORNER, 1);
      ObjectSet("m30_0", OBJPROP_XDISTANCE, 220);
      ObjectSet("m30_0", OBJPROP_YDISTANCE, 40);
      ObjectSetText("m30_0", "M30", 10, "Verdana", White);
   }
   if (ObjectCreate("h1_0", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("h1_0", OBJPROP_CORNER, 1);
      ObjectSet("h1_0", OBJPROP_XDISTANCE, 180);
      ObjectSet("h1_0", OBJPROP_YDISTANCE, 40);
      ObjectSetText("h1_0", "H1", 10, "Verdana", White);
   }
   if (ObjectCreate("h4_0", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("h4_0", OBJPROP_CORNER, 1);
      ObjectSet("h4_0", OBJPROP_XDISTANCE, 140);
      ObjectSet("h4_0", OBJPROP_YDISTANCE, 40);
      ObjectSetText("h4_0", "H4", 10, "Verdana", White);
   }
   if (ObjectCreate("d1_0", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("d1_0", OBJPROP_CORNER, 1);
      ObjectSet("d1_0", OBJPROP_XDISTANCE, 100);
      ObjectSet("d1_0", OBJPROP_YDISTANCE, 40);
      ObjectSetText("d1_0", "D", 10, "Verdana", White);
   }
   if (ObjectCreate("w1_0", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("w1_0", OBJPROP_CORNER, 1);
      ObjectSet("w1_0", OBJPROP_XDISTANCE, 60);
      ObjectSet("w1_0", OBJPROP_YDISTANCE, 40);
      ObjectSetText("w1_0", "W", 10, "Verdana", White);
   }
   if (ObjectCreate("mo1_0", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("mo1_0", OBJPROP_CORNER, 1);
      ObjectSet("mo1_0", OBJPROP_XDISTANCE, 20);
      ObjectSet("mo1_0", OBJPROP_YDISTANCE, 40);
      ObjectSetText("mo1_0", "Mo", 10, "Verdana", White);
   }
}

void create_side_items()
{
   if (ObjectCreate("suggestionlbl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("suggestionlbl", OBJPROP_CORNER, 1);
      ObjectSet("suggestionlbl", OBJPROP_XDISTANCE, 370);
      ObjectSet("suggestionlbl", OBJPROP_YDISTANCE, 20);
      ObjectSetText("suggestionlbl", "Suggestion", 10, "Verdana", White);
   }
   if (ObjectCreate("heikenlbl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("heikenlbl", OBJPROP_CORNER, 1);
      ObjectSet("heikenlbl", OBJPROP_XDISTANCE, 370);
      ObjectSet("heikenlbl", OBJPROP_YDISTANCE, 60);
      ObjectSetText("heikenlbl", "Heiken", 10, "Verdana", White);
   }
   if (ObjectCreate("macdlbl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("macdlbl", OBJPROP_CORNER, 1);
      ObjectSet("macdlbl", OBJPROP_XDISTANCE, 370);
      ObjectSet("macdlbl", OBJPROP_YDISTANCE, 80);
      ObjectSetText("macdlbl", "MACD", 10, "Verdana", White);
   }
   if (ObjectCreate("ccilbl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("ccilbl", OBJPROP_CORNER, 1);
      ObjectSet("ccilbl", OBJPROP_XDISTANCE, 370);
      ObjectSet("ccilbl", OBJPROP_YDISTANCE, 100);
      ObjectSetText("ccilbl", "CCI", 10, "Verdana", White);
   }
   if (ObjectCreate("rsilbl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("rsilbl", OBJPROP_CORNER, 1);
      ObjectSet("rsilbl", OBJPROP_XDISTANCE, 370);
      ObjectSet("rsilbl", OBJPROP_YDISTANCE, 120);
      ObjectSetText("rsilbl", "RSI", 10, "Verdana", White);
   }
   if (ObjectCreate("tksenlbl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("tksenlbl", OBJPROP_CORNER, 1);
      ObjectSet("tksenlbl", OBJPROP_XDISTANCE, 370);
      ObjectSet("tksenlbl", OBJPROP_YDISTANCE, 140);
      ObjectSetText("tksenlbl", "TikenSen", 10, "Verdana", White);
   }
   if (ObjectCreate("kumolbl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("kumolbl", OBJPROP_CORNER, 1);
      ObjectSet("kumolbl", OBJPROP_XDISTANCE, 370);
      ObjectSet("kumolbl", OBJPROP_YDISTANCE, 160);
      ObjectSetText("kumolbl", "Kumo", 10, "Verdana", White);
   }
   if (ObjectCreate("chinkobl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("chinkobl", OBJPROP_CORNER, 1);
      ObjectSet("chinkobl", OBJPROP_XDISTANCE, 370);
      ObjectSet("chinkobl", OBJPROP_YDISTANCE, 180);
      ObjectSetText("chinkobl", "Chinkospan", 10, "Verdana", White);
   }
   if (ObjectCreate("spanAblbl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("spanAblbl", OBJPROP_CORNER, 1);
      ObjectSet("spanAblbl", OBJPROP_XDISTANCE, 370);
      ObjectSet("spanAblbl", OBJPROP_YDISTANCE, 200);
      ObjectSetText("spanAblbl", "SpanAB", 10, "Verdana", White);
   }
   if (ObjectCreate("bblbl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("bblbl", OBJPROP_CORNER, 1);
      ObjectSet("bblbl", OBJPROP_XDISTANCE, 370);
      ObjectSet("bblbl", OBJPROP_YDISTANCE, 220);
      ObjectSetText("bblbl", "Bollinger", 10, "Verdana", White);
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
   int condition[9];
   string name;
   int base = 340;
   int x;
   int y = 60;
   for (int i = 0; i < 9; i++) {
      name = "heiken"+i;
      x = base - (i * 40);
      val2 = iCustom(NULL, period[i], "Heiken_Ashi_Smoothed",2,0);
      val3 = iCustom(NULL, period[i], "Heiken_Ashi_Smoothed",3,0);
      ObjectDelete(name);
      if (val2 < val3) {
         create_arrow(name, x, y, 1);
         condition[i] = 1;
      } else if (val2 > val3) {
         create_arrow(name, x, y, -1);
         condition[i] = -1;
      } else {
         create_arrow(name, x, y, 0);
         condition[i] = 0;
      }
   }
   name = "suggestion_text";
   if (
      condition[0] == 1
      && condition[1] == 1
      && condition[2] == 1
      && condition[3] == 1
      && condition[4] == 1
   ) {
      ObjectDelete("suggestion_text");
      create_label(name, 150, 20, "Buy Condition Exists", Blue);
      if (openTime != Time[0]) {
         Alert(Symbol(), ", Buy Condition");
         openTime = Time[0];
      }
   } else if(
      condition[0] == -1
      && condition[1] == -1
      && condition[2] == -1
      && condition[3] == -1
      && condition[4] == -1
   ) {
      ObjectDelete("suggestion_text");
      create_label(name, 150, 20, "Sell Condition Exists", Red);
      if (openTime2 != Time[0]) {
         Alert(Symbol(), ", Sell Condition");
         openTime2 = Time[0];
      }
   } else {
      ObjectDelete("suggestion_text");
      create_label(name, 150, 20, "Consolidation", Gold);
   }
}

void calculate_macd()
{
   string name;
   int base = 340;
   int x;
   int y = 80;
   for (int i = 0; i < 9; i++) {
      name = "macd"+i;
      x = base - (i * 40);
      val2 = iCustom(NULL, period[i], "MACD_Complete",1,0);
      val3 = iCustom(NULL, period[i], "MACD_Complete",2,0);
      ObjectDelete(name);
      if (val2 > val3) {
         create_arrow(name, x, y, 1);
      } else if (val2 < val3) {
         create_arrow(name, x, y, -1);
      } else {
         create_arrow(name, x, y, 0);
      }
   }
}
void calculate_cci()
{
   string name;
   int base = 340;
   int x;
   int y = 100;
   for (int i = 0; i < 9; i++) {
      name = "cci"+i;
      x = base - (i * 40);
      val = iCCI(NULL,period[i],45,PRICE_CLOSE,0);
      ObjectDelete(name);
      if (val > 100) {
         create_arrow(name, x, y, 1);
      } else if (val < -100) {
         create_arrow(name, x, y, -1);
      } else {
         create_arrow(name, x, y, 0);
      }
   }
}
void calculate_rsi()
{
   string name;
   int base = 340;
   int x;
   int y = 120;
   for (int i = 0; i < 9; i++) {
      name = "rsi"+i;
      x = base - (i * 40);
      val = iRSI(NULL,period[i],7,PRICE_CLOSE,0);
      ObjectDelete(name);
      if (val > 70) {
         create_arrow(name, x, y, 1);
      } else if (val < 30) {
         create_arrow(name, x, y, -1);
      } else {
         create_arrow(name, x, y, 0);
      }
   }
}
void calculate_tksen()
{
   double tenkan_sen_1, kijun_sen_1, spanA, spanB, spanHigh, spanLow, chinkouspan;
   string name;
   int base = 340;
   int x;
   int y = 140;
   int i;
   for (i = 0; i < 9; i++) {
      name = "tksen"+i;
      x = base - (i * 40);
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
   for (i = 0; i < 9; i++) {
      name = "kumo"+i;
      x = base - (i * 40);
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
   for (i = 0; i < 9; i++) {
      name = "chinko"+i;
      x = base - (i * 40);
      chinkouspan = iIchimoku(NULL,period[i], 9, 26, 52, MODE_CHINKOUSPAN, 0+26);
      ObjectDelete(name);
      if (chinkouspan > High[0+26]) {
         create_arrow(name, x, y, 1);
      } else if (chinkouspan < Low[0+26]) {
         create_arrow(name, x, y, -1);
      } else {
         create_arrow(name, x, y, 0);
      }
   }
   y = 200;
   for (i = 0; i < 9; i++) {
      name = "spanAB"+i;
      x = base - (i * 40);
      spanA = iIchimoku(NULL, period[i], 9, 26, 52, MODE_SENKOUSPANA, -26);
      spanB = iIchimoku(NULL, period[i], 9, 26, 52, MODE_SENKOUSPANB, -26);
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
   int base = 340;
   int x;
   int y = 220;
   for (int i = 0; i < 9; i++) {
      name = "bb"+i;
      x = base - (i * 40);
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
void calculate_mom()
{
   string name;
   int base = 340;
   int x;
   int y = 240;
   for (int i = 0; i < 9; i++) {
      name = "mom"+i;
      x = base - (i * 40);
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
   int base = 340;
   int x;
   int y = 260;
   for (int i = 0; i < 9; i++) {
      name = "rsi"+i;
      x = base - (i * 40);
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
   int base = 340;
   int x;
   int y = 280;
   for (int i = 0; i < 9; i++) {
      name = "rsi"+i;
      x = base - (i * 40);
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

