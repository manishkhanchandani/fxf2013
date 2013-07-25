/*
   Generated by EX4-TO-MQ4 decompiler V4.0.224.1 []
   Website: http://purebeam.biz
   E-mail : purebeam@gmail.com
*/
#property copyright "Copyright � 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 C'0x46,0x46,0x00'
#property indicator_color2 C'0x46,0x46,0x00'
#property indicator_color3 Crimson
#property indicator_color4 Green

double g_ibuf_76[];
double g_ibuf_80[];
double g_ibuf_84[];
double g_ibuf_88[];
extern bool Indicator_On? = TRUE;
int gi_96 = 0;

int init() {
   SetIndexStyle(0, DRAW_HISTOGRAM, STYLE_SOLID, 1, C'0x46,0x46,0x00');
   SetIndexBuffer(0, g_ibuf_76);
   SetIndexLabel(0, "HA_0");
   SetIndexStyle(1, DRAW_HISTOGRAM, STYLE_SOLID, 1, C'0x46,0x46,0x00');
   SetIndexBuffer(1, g_ibuf_80);
   SetIndexLabel(1, "HA_1");
   SetIndexStyle(2, DRAW_HISTOGRAM, STYLE_SOLID, 3, FireBrick);
   SetIndexBuffer(2, g_ibuf_84);
   SetIndexLabel(2, "HA_Open");
   SetIndexStyle(3, DRAW_HISTOGRAM, STYLE_SOLID, 3, Green);
   SetIndexBuffer(3, g_ibuf_88);
   SetIndexLabel(3, "HA_Close");
   SetIndexDrawBegin(0, 10);
   SetIndexDrawBegin(1, 10);
   SetIndexDrawBegin(2, 10);
   SetIndexDrawBegin(3, 10);
   SetIndexBuffer(0, g_ibuf_76);
   SetIndexBuffer(1, g_ibuf_80);
   SetIndexBuffer(2, g_ibuf_84);
   SetIndexBuffer(3, g_ibuf_88);
   return (0);
}

int deinit() {
   return (0);
}

int start() {
   double ld_0;
   double ld_8;
   double ld_16;
   double ld_24;
   if (Indicator_On? == FALSE) {
      deinit();
      return (0);
   }
   if (Bars <= 10) return (0);
   gi_96 = IndicatorCounted();
   if (gi_96 < 0) return (-1);
   if (gi_96 > 0) gi_96--;
   for (int li_32 = Bars - gi_96 - 1; li_32 >= 0; li_32--) {
      ld_0 = (g_ibuf_84[li_32 + 1] + (g_ibuf_88[li_32 + 1])) / 2.0;
      ld_24 = (Open[li_32] + High[li_32] + Low[li_32] + Close[li_32]) / 4.0;
      ld_8 = MathMax(High[li_32], MathMax(ld_0, ld_24));
      ld_16 = MathMin(Low[li_32], MathMin(ld_0, ld_24));
      if (ld_0 < ld_24) {
         g_ibuf_76[li_32] = ld_16;
         g_ibuf_80[li_32] = ld_8;
      } else {
         g_ibuf_76[li_32] = ld_8;
         g_ibuf_80[li_32] = ld_16;
      }
      g_ibuf_84[li_32] = ld_0;
      g_ibuf_88[li_32] = ld_24;
   }
   return (0);
}