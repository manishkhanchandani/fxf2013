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
string symbols[28] = {"USDCHF", "GBPUSD", "EURUSD", "USDJPY", "USDCAD", "AUDUSD", "EURGBP", "EURAUD", "EURJPY", "GBPCHF", "CADJPY", "GBPJPY", 
               "AUDCAD", "AUDCHF", "AUDJPY", "CHFJPY", "EURNZD", "EURCAD", "CADCHF", "NZDJPY", "NZDUSD", "GBPCAD", "GBPNZD", 
               "GBPAUD", "NZDCHF", "NZDCAD", "AUDNZD", "EURCHF"};
int limit = 7;
int openTime;
int openTime2;
int condition_strategy[28][50][9]; //condition[strategy][timeperiod]

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
}


void delete_object()
{
   ObjectDelete("result");
   ObjectDelete("suggestion_text");
   ObjectDelete("suggestionlbl");
   ObjectDelete("m1_0");
   ObjectDelete("m5_0");
   ObjectDelete("m15_0");
   ObjectDelete("m30_0");
   ObjectDelete("h1_0");
   ObjectDelete("h4_0");
   ObjectDelete("d1_0");
   ObjectDelete("m1_1");
   ObjectDelete("m5_1");
   ObjectDelete("m15_1");
   ObjectDelete("m30_1");
   ObjectDelete("h1_1");
   ObjectDelete("h4_1");
   ObjectDelete("d1_1");
   ObjectDelete("heikenlbl");
   ObjectDelete("ccilbl");
   string name;
   for (int i = 0; i < 9; i++) {
      name = "heiken"+i;
      ObjectDelete(name);
      name = "cci"+i;
      ObjectDelete(name);
   }
   int c;
   for (c = 0; c < 28; c++) {
      name = symbols[c] + "_lbl";
      ObjectDelete(name);
   }
   for (c = 0; c < 28; c++) {
      for (i = 0; i < 9; i++) {
         name = "heiken"+i+c;
         ObjectDelete(name);
         name = "cci"+i+c;
         ObjectDelete(name);
      }
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
   if (ObjectCreate("result", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("result", OBJPROP_CORNER, 1);
      ObjectSet("result", OBJPROP_XDISTANCE, 40);
      ObjectSet("result", OBJPROP_YDISTANCE, 40);
      ObjectSetText("result", "Result", 10, "Verdana", White);
   }
   
   
   
   if (ObjectCreate("m1_1", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("m1_1", OBJPROP_CORNER, 1);
      ObjectSet("m1_1", OBJPROP_XDISTANCE, 620);
      ObjectSet("m1_1", OBJPROP_YDISTANCE, 40);
      ObjectSetText("m1_1", "M1", 10, "Verdana", White);
   }
   if (ObjectCreate("m5_1", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("m5_1", OBJPROP_CORNER, 1);
      ObjectSet("m5_1", OBJPROP_CORNER, 1);
      ObjectSet("m5_1", OBJPROP_XDISTANCE, 580);
      ObjectSet("m5_1", OBJPROP_YDISTANCE, 40);
      ObjectSetText("m5_1", "M5", 10, "Verdana", White);
   }
   if (ObjectCreate("m15_1", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("m15_1", OBJPROP_CORNER, 1);
      ObjectSet("m15_1", OBJPROP_XDISTANCE, 540);
      ObjectSet("m15_1", OBJPROP_YDISTANCE, 40);
      ObjectSetText("m15_1", "M15", 10, "Verdana", White);
   }
   if (ObjectCreate("m30_1", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("m30_1", OBJPROP_CORNER, 1);
      ObjectSet("m30_1", OBJPROP_XDISTANCE, 500);
      ObjectSet("m30_1", OBJPROP_YDISTANCE, 40);
      ObjectSetText("m30_1", "M30", 10, "Verdana", White);
   }
   if (ObjectCreate("h1_1", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("h1_1", OBJPROP_CORNER, 1);
      ObjectSet("h1_1", OBJPROP_XDISTANCE, 460);
      ObjectSet("h1_1", OBJPROP_YDISTANCE, 40);
      ObjectSetText("h1_1", "H1", 10, "Verdana", White);
   }
   if (ObjectCreate("h4_1", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("h4_1", OBJPROP_CORNER, 1);
      ObjectSet("h4_1", OBJPROP_XDISTANCE, 420);
      ObjectSet("h4_1", OBJPROP_YDISTANCE, 40);
      ObjectSetText("h4_1", "H4", 10, "Verdana", White);
   }
   if (ObjectCreate("d1_1", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("d1_1", OBJPROP_CORNER, 1);
      ObjectSet("d1_1", OBJPROP_XDISTANCE, 380);
      ObjectSet("d1_1", OBJPROP_YDISTANCE, 40);
      ObjectSetText("d1_1", "D", 10, "Verdana", White);
   }
}

void create_side_items()
{
   if (ObjectCreate("suggestionlbl", OBJ_LABEL, 0, 0, 0)) {
      ObjectSet("suggestionlbl", OBJPROP_CORNER, 1);
      ObjectSet("suggestionlbl", OBJPROP_XDISTANCE, 650);
      ObjectSet("suggestionlbl", OBJPROP_YDISTANCE, 20);
      ObjectSetText("suggestionlbl", "Suggestion", 10, "Verdana", White);
   }
   int c;
   string name;
   int tmp = 60;
   int tmpcnt = 20;
   int y;
   for (c = 0; c < 28; c++) {
      name = symbols[c] + "_lbl";
      y = tmp + (c * tmpcnt);
      if (ObjectCreate(name, OBJ_LABEL, 0, 0, 0)) {
         ObjectSet(name, OBJPROP_CORNER, 1);
         ObjectSet(name, OBJPROP_XDISTANCE, 650);
         ObjectSet(name, OBJPROP_YDISTANCE, y);
         ObjectSetText(name, (c+1) + ". " + symbols[c], 10, "Verdana", White);
      }
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
   return (0);
   //0
   int condition[9];
   int condition2[9];
   string name;
   int base;
   int x;
   int y = 60;
   string symbol;
   int c;
   for (c = 0; c < 28; c++) {
      symbol = symbols[c];
      for (int i = 0; i < limit; i++) {
         name = "heiken"+i+c;
         base = 620;
         x = base - (i * 40);
         val2 = iCustom(symbol, period[i], "Heiken_Ashi_Smoothed",2,0);
         val3 = iCustom(symbol, period[i], "Heiken_Ashi_Smoothed",3,0);
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
      
         name = "cci"+i+c;
         base = 340;
         x = base - (i * 40);
         val = iCCI(symbol,period[i],45,PRICE_CLOSE,0);
         ObjectDelete(name);
         if (val > 100) {
            create_arrow(name, x, y, 1);
            condition2[i] = 1;
         } else if (val < -100) {
            create_arrow(name, x, y, -1);
            condition2[i] = -1;
         } else {
            create_arrow(name, x, y, 0);
            condition2[i] = 0;
         }
      }
      
      base = 40;
      y = base + (c * 20);
      x = 40;
      if (
         condition[0] == 1
         && condition[1] == 1
         && condition[2] == 1
         && condition[3] == 1
         && condition[4] == 1
         && condition2[0] == 1
         && condition2[1] == 1
         && condition2[2] == 1
         && condition2[3] == 1
         && condition2[4] == 1
      ) {
         name = "result_" + symbol;
         ObjectDelete(name);
         create_arrow(name, x, y, 1);
      } else if(
         condition[0] == -1
         && condition[1] == -1
         && condition[2] == -1
         && condition[3] == -1
         && condition[4] == -1
         && condition2[0] == -1
         && condition2[1] == -1
         && condition2[2] == -1
         && condition2[3] == -1
         && condition2[4] == -1
      ) {
         name = "result_" + symbol;
         ObjectDelete(name);
         create_arrow(name, x, y, -1);
      } else {
         name = "result_" + symbol;
         ObjectDelete(name);
         create_arrow(name, x, y, 0);
      }
   }
}