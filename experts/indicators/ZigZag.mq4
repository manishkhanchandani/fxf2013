

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red

extern int ExtDepth = 12;
extern int ExtDeviation = 5;
extern int ExtBackstep = 3;
double g_ibuf_88[];
double g_ibuf_92[];
double g_ibuf_96[];
int gi_100 = 3;
bool gi_104 = FALSE;

int init() {
   IndicatorBuffers(3);
   SetIndexStyle(0, DRAW_SECTION);
   SetIndexBuffer(0, g_ibuf_88);
   SetIndexBuffer(1, g_ibuf_92);
   SetIndexBuffer(2, g_ibuf_96);
   SetIndexEmptyValue(0, 0.0);
   IndicatorShortName("ZigZag(" + ExtDepth + "," + ExtDeviation + "," + ExtBackstep + ")");
   return (0);
}

int start() {
   int li_0;
   int li_8;
   int li_12;
   int li_16;
   int li_28;
   int li_32;
   double ld_36;
   double ld_44;
   double ld_52;
   double ld_60;
   double ld_68;
   double ld_76;
   int l_ind_counted_4 = IndicatorCounted();
   if (l_ind_counted_4 == 0 && gi_104) {
      ArrayInitialize(g_ibuf_88, 0.0);
      ArrayInitialize(g_ibuf_92, 0.0);
      ArrayInitialize(g_ibuf_96, 0.0);
   }
   if (l_ind_counted_4 == 0) {
      li_8 = Bars - ExtDepth;
      gi_104 = TRUE;
   }
   if (l_ind_counted_4 > 0) {
      while (li_12 < gi_100 && li_0 < 100) {
         ld_44 = g_ibuf_88[li_0];
         if (ld_44 != 0.0) li_12++;
         li_0++;
      }
      li_0--;
      li_8 = li_0;
      if (g_ibuf_96[li_0] != 0.0) {
         ld_52 = g_ibuf_96[li_0];
         li_16 = 1;
      } else {
         ld_60 = g_ibuf_92[li_0];
         li_16 = -1;
      }
      for (li_0 = li_8 - 1; li_0 >= 0; li_0--) {
         g_ibuf_88[li_0] = 0.0;
         g_ibuf_96[li_0] = 0.0;
         g_ibuf_92[li_0] = 0.0;
      }
   }
   for (int li_20 = li_8; li_20 >= 0; li_20--) {
      ld_36 = Low[iLowest(NULL, 0, MODE_LOW, ExtDepth, li_20)];
      if (ld_36 == ld_76) ld_36 = 0.0;
      else {
         ld_76 = ld_36;
         if (Low[li_20] - ld_36 > ExtDeviation * Point) ld_36 = 0.0;
         else {
            for (int li_24 = 1; li_24 <= ExtBackstep; li_24++) {
               ld_44 = g_ibuf_96[li_20 + li_24];
               if (ld_44 != 0.0 && ld_44 > ld_36) g_ibuf_96[li_20 + li_24] = 0.0;
            }
         }
      }
      if (Low[li_20] == ld_36) g_ibuf_96[li_20] = ld_36;
      else g_ibuf_96[li_20] = 0.0;
      ld_36 = High[iHighest(NULL, 0, MODE_HIGH, ExtDepth, li_20)];
      if (ld_36 == ld_68) ld_36 = 0.0;
      else {
         ld_68 = ld_36;
         if (ld_36 - High[li_20] > ExtDeviation * Point) ld_36 = 0.0;
         else {
            for (li_24 = 1; li_24 <= ExtBackstep; li_24++) {
               ld_44 = g_ibuf_92[li_20 + li_24];
               if (ld_44 != 0.0 && ld_44 < ld_36) g_ibuf_92[li_20 + li_24] = 0.0;
            }
         }
      }
      if (High[li_20] == ld_36) g_ibuf_92[li_20] = ld_36;
      else g_ibuf_92[li_20] = 0.0;
   }
   if (li_16 == 0) {
      ld_76 = 0;
      ld_68 = 0;
   } else {
      ld_76 = ld_52;
      ld_68 = ld_60;
   }
   for (li_20 = li_8; li_20 >= 0; li_20--) {
      ld_44 = 0.0;
      switch (li_16) {
      case 0:
         if (ld_76 == 0.0 && ld_68 == 0.0) {
            if (g_ibuf_92[li_20] != 0.0) {
               ld_68 = High[li_20];
               li_28 = li_20;
               li_16 = -1;
               g_ibuf_88[li_20] = ld_68;
               ld_44 = 1;
            }
            if (g_ibuf_96[li_20] != 0.0) {
               ld_76 = Low[li_20];
               li_32 = li_20;
               li_16 = 1;
               g_ibuf_88[li_20] = ld_76;
               ld_44 = 1;
            }
         }
         break;
      case 1:
         if (g_ibuf_96[li_20] != 0.0 && g_ibuf_96[li_20] < ld_76 && g_ibuf_92[li_20] == 0.0) {
            g_ibuf_88[li_32] = 0.0;
            li_32 = li_20;
            ld_76 = g_ibuf_96[li_20];
            g_ibuf_88[li_20] = ld_76;
            ld_44 = 1;
         }
         if (g_ibuf_92[li_20] != 0.0 && g_ibuf_96[li_20] == 0.0) {
            ld_68 = g_ibuf_92[li_20];
            li_28 = li_20;
            g_ibuf_88[li_20] = ld_68;
            li_16 = -1;
            ld_44 = 1;
         }
         break;
      case -1:
         if (g_ibuf_92[li_20] != 0.0 && g_ibuf_92[li_20] > ld_68 && g_ibuf_96[li_20] == 0.0) {
            g_ibuf_88[li_28] = 0.0;
            li_28 = li_20;
            ld_68 = g_ibuf_92[li_20];
            g_ibuf_88[li_20] = ld_68;
         }
         if (g_ibuf_96[li_20] != 0.0 && g_ibuf_92[li_20] == 0.0) {
            ld_76 = g_ibuf_96[li_20];
            li_32 = li_20;
            g_ibuf_88[li_20] = ld_76;
            li_16 = 1;
         }
         break;
      default:
         return/*(WARN)*/;
      }
   }
   return (0);
}