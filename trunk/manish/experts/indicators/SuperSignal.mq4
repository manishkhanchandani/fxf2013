

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Yellow

extern int TimeFrame = 0;
extern int SignalGap = 1;
int gi_84 = 24;
double g_ibuf_88[];
double g_ibuf_92[];
double g_bars_104;

int init() {
   string ls_4;
   SetIndexStyle(0, DRAW_ARROW, STYLE_SOLID);
   SetIndexStyle(1, DRAW_ARROW, STYLE_SOLID);
   SetIndexArrow(1, 233);
   SetIndexArrow(0, 234);
   SetIndexBuffer(0, g_ibuf_88);
   SetIndexBuffer(1, g_ibuf_92);
   switch (TimeFrame) {
   case 1:
      ls_4 = "Period_M1";
      break;
   case 5:
      ls_4 = "Period_M5";
      break;
   case 15:
      ls_4 = "Period_M15";
      break;
   case 30:
      ls_4 = "Period_M30";
      break;
   case 60:
      ls_4 = "Period_H1";
      break;
   case 240:
      ls_4 = "Period_H4";
      break;
   case 1440:
      ls_4 = "Period_D1";
      break;
   case 10080:
      ls_4 = "Period_W1";
      break;
   case 43200:
      ls_4 = "Period_MN1";
      break;
   default:
      ls_4 = "Current Timeframe";
   }
   IndicatorShortName("MTF_Super-Signals_v1 (" + ls_4 + ")");
   return (0);
}

int start() {
   int lia_0[];
   int l_highest_28;
   int l_lowest_32;
   int l_index_12 = 0;
   int li_16 = IndicatorCounted();
   ArrayCopySeries(lia_0, 5, Symbol(), TimeFrame);
   int li_8 = Bars - li_16;
   int li_4 = 0;
   l_index_12 = 0;
   if (li_4 < li_8) {
      if (Time[li_4] < lia_0[l_index_12]) l_index_12++;
      if (li_16 < 0) return (-1);
      if (li_16 > 0) li_16--;
      li_8 = Bars - 1;
      if (li_16 >= 1) li_8 = Bars - li_16 - 1;
      if (li_8 < 0) li_8 = 0;
      for (li_4 = li_8; li_4 >= 0; li_4--) {
         l_highest_28 = iHighest(NULL, 0, MODE_HIGH, gi_84, li_4 - gi_84 / 2);
         l_lowest_32 = iLowest(NULL, 0, MODE_LOW, gi_84, li_4 - gi_84 / 2);
         if (li_4 == l_highest_28) {
            g_ibuf_88[li_4] = High[l_highest_28] + SignalGap * Point;
            if (li_4 == 1 && Bars > g_bars_104) Alert("Super Signals going Down on ", Symbol(), " Period ", Period());
            g_bars_104 = Bars;
         }
         if (li_4 == l_lowest_32) {
            g_ibuf_92[li_4] = Low[l_lowest_32] - SignalGap * Point;
            if (li_4 == 1 && Bars > g_bars_104) Alert("Super Signals going Up on ", Symbol(), " Period ", Period());
            g_bars_104 = Bars;
         }
      }
      return (0);
   }
   return (0);
}