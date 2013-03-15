
#property copyright "Lowphat © 2006"
#property link      "mystikvgv@yahoo.com (mail only)"

#property indicator_separate_window

extern string MoneyManagementSetting = "==MoneyManagementSettings==";
extern double Risk = 10.0;
double gd_92;
double gd_100;
int gi_108;
int gi_unused_112;
int gi_unused_116;
int g_leverage_120;

double PointCost() {
   double ld_ret_0;
   double ld_8 = MarketInfo(Symbol(), MODE_LOTSIZE) * MarketInfo(Symbol(), MODE_POINT);
   string ls_16 = StringSubstr(Symbol(), 3, 3);
   string l_symbol_24 = "USD" + ls_16;
   string l_symbol_32 = ls_16 + "USD";
   if (ls_16 == "USD") ld_ret_0 = ld_8;
   else {
      if (MarketInfo(l_symbol_24, MODE_BID) != 0.0) ld_ret_0 = ld_8 * (1 / MarketInfo(l_symbol_24, MODE_BID));
      else ld_ret_0 = ld_8 * MarketInfo(l_symbol_32, MODE_ASK);
   }
   return (ld_ret_0);
}

int init() {
   IndicatorShortName("Stat Monitor (" + Symbol() + ")");
   return (0);
}

int deinit() {
   return (0);
}

int start() {
   gi_108 = MarketInfo(Symbol(), MODE_SPREAD);
   gi_unused_112 = MarketInfo(Symbol(), MODE_TICKVALUE);
   gd_92 = NormalizeDouble(MarketInfo(Symbol(), MODE_SWAPLONG), 2);
   gd_100 = NormalizeDouble(MarketInfo(Symbol(), MODE_SWAPSHORT), 2);
   gi_unused_116 = Volume[0];
   g_leverage_120 = AccountLeverage();
   ObjectCreate("Stat Monitor1", OBJ_LABEL, WindowFind("Stat Monitor (" + Symbol() + ")"), 0, 0);
   ObjectSetText("Stat Monitor1", "Spread:", 9, "Arial Bold", CadetBlue);
   ObjectSet("Stat Monitor1", OBJPROP_CORNER, 0);
   ObjectSet("Stat Monitor1", OBJPROP_XDISTANCE, 110);
   ObjectSet("Stat Monitor1", OBJPROP_YDISTANCE, 2);
   ObjectCreate("Stat Monitor2", OBJ_LABEL, WindowFind("Stat Monitor (" + Symbol() + ")"), 0, 0);
   ObjectSetText("Stat Monitor2", DoubleToStr(gi_108, 0), 9, "Arial Bold", Lime);
   ObjectSet("Stat Monitor2", OBJPROP_CORNER, 0);
   ObjectSet("Stat Monitor2", OBJPROP_XDISTANCE, 160);
   ObjectSet("Stat Monitor2", OBJPROP_YDISTANCE, 2);
   ObjectCreate("Stat Monitor3", OBJ_LABEL, WindowFind("Stat Monitor (" + Symbol() + ")"), 0, 0);
   ObjectSetText("Stat Monitor3", "1 Lot :", 9, "Arial Bold", CadetBlue);
   ObjectSet("Stat Monitor3", OBJPROP_CORNER, 0);
   ObjectSet("Stat Monitor3", OBJPROP_XDISTANCE, 180);
   ObjectSet("Stat Monitor3", OBJPROP_YDISTANCE, 2);
   ObjectCreate("Stat Monitor4", OBJ_LABEL, WindowFind("Stat Monitor (" + Symbol() + ")"), 0, 0);
   ObjectSetText("Stat Monitor4", DoubleToStr(PointCost(), 2) + " USD", 9, "Arial Bold", Lime);
   ObjectSet("Stat Monitor4", OBJPROP_CORNER, 0);
   ObjectSet("Stat Monitor4", OBJPROP_XDISTANCE, 220);
   ObjectSet("Stat Monitor4", OBJPROP_YDISTANCE, 2);
   ObjectCreate("Stat Monitor5", OBJ_LABEL, WindowFind("Stat Monitor (" + Symbol() + ")"), 0, 0);
   ObjectSetText("Stat Monitor5", "Buy Swap:", 9, "Arial Bold", CadetBlue);
   ObjectSet("Stat Monitor5", OBJPROP_CORNER, 0);
   ObjectSet("Stat Monitor5", OBJPROP_XDISTANCE, 290);
   ObjectSet("Stat Monitor5", OBJPROP_YDISTANCE, 2);
   ObjectCreate("Stat Monitor6", OBJ_LABEL, WindowFind("Stat Monitor (" + Symbol() + ")"), 0, 0);
   if (gd_92 > 0.0) ObjectSetText("Stat Monitor6", DoubleToStr(gd_92, 2), 9, "Arial Bold", Lime);
   else ObjectSetText("Stat Monitor6", DoubleToStr(gd_92, 2), 9, "Arial Bold", Red);
   ObjectSet("Stat Monitor6", OBJPROP_CORNER, 0);
   ObjectSet("Stat Monitor6", OBJPROP_XDISTANCE, 360);
   ObjectSet("Stat Monitor6", OBJPROP_YDISTANCE, 2);
   ObjectCreate("Stat Monitor7", OBJ_LABEL, WindowFind("Stat Monitor (" + Symbol() + ")"), 0, 0);
   ObjectSetText("Stat Monitor7", "Sell Swap:", 9, "Arial Bold", CadetBlue);
   ObjectSet("Stat Monitor7", OBJPROP_CORNER, 0);
   ObjectSet("Stat Monitor7", OBJPROP_XDISTANCE, 400);
   ObjectSet("Stat Monitor7", OBJPROP_YDISTANCE, 2);
   ObjectCreate("Stat Monitor8", OBJ_LABEL, WindowFind("Stat Monitor (" + Symbol() + ")"), 0, 0);
   if (gd_100 > 0.0) ObjectSetText("Stat Monitor8", DoubleToStr(gd_100, 2), 9, "Arial Bold", Lime);
   else ObjectSetText("Stat Monitor8", DoubleToStr(gd_100, 2), 9, "Arial Bold", Red);
   ObjectSet("Stat Monitor8", OBJPROP_CORNER, 0);
   ObjectSet("Stat Monitor8", OBJPROP_XDISTANCE, 470);
   ObjectSet("Stat Monitor8", OBJPROP_YDISTANCE, 2);
   ObjectCreate("Stat Monitor9", OBJ_LABEL, WindowFind("Stat Monitor (" + Symbol() + ")"), 0, 0);
   ObjectSetText("Stat Monitor9", "Leverage: ", 9, "Arial Bold", CadetBlue);
   ObjectSet("Stat Monitor9", OBJPROP_CORNER, 0);
   ObjectSet("Stat Monitor9", OBJPROP_XDISTANCE, 510);
   ObjectSet("Stat Monitor9", OBJPROP_YDISTANCE, 2);
   ObjectCreate("Stat Monitor10", OBJ_LABEL, WindowFind("Stat Monitor (" + Symbol() + ")"), 0, 0);
   ObjectSetText("Stat Monitor10", "1: ", 9, "Arial Bold", Lime);
   ObjectSet("Stat Monitor10", OBJPROP_CORNER, 0);
   ObjectSet("Stat Monitor10", OBJPROP_XDISTANCE, 570);
   ObjectSet("Stat Monitor10", OBJPROP_YDISTANCE, 2);
   ObjectCreate("Stat Monitor11", OBJ_LABEL, WindowFind("Stat Monitor (" + Symbol() + ")"), 0, 0);
   ObjectSetText("Stat Monitor11", DoubleToStr(g_leverage_120, 0), 9, "Arial Bold", Lime);
   ObjectSet("Stat Monitor11", OBJPROP_CORNER, 0);
   ObjectSet("Stat Monitor11", OBJPROP_XDISTANCE, 580);
   ObjectSet("Stat Monitor11", OBJPROP_YDISTANCE, 2);
   return (0);
}