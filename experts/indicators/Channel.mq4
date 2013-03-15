

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 LightGray
#property indicator_color2 White
#property indicator_color3 LightGray

extern int TimeFrame = 0;
extern int Length = 21;
extern int MA_Type = 0;
extern int Shift = 0;
extern int Price = 0;
extern double TimesATR = 4.0;
double g_ibuf_104[];
double g_ibuf_108[];
double g_ibuf_112[];

int init() {
   SetIndexStyle(0, DRAW_LINE, STYLE_DOT);
   SetIndexBuffer(0, g_ibuf_104);
   SetIndexStyle(1, DRAW_LINE, STYLE_DOT);
   SetIndexBuffer(1, g_ibuf_108);
   SetIndexStyle(2, DRAW_LINE, STYLE_DOT);
   SetIndexBuffer(2, g_ibuf_112);
   SetIndexLabel(0, Length + " KChanUp");
   SetIndexLabel(1, Length + " KChanMid");
   SetIndexLabel(2, Length + " KChanLow");
   return (0);
}

int deinit() {
   return (0);
}

int start() {
   int li_0 = IndicatorCounted();
   int li_4 = Bars - li_0;
   int li_8 = 0;
   if (li_0 < 0) return (-1);
   if (li_0 > 0) li_0--;
   double l_ima_12 = 0;
   double l_iatr_20 = 0;
   iATR(NULL, TimeFrame, Length, li_8);
   for (li_8 = 0; li_8 < li_4; li_8++) {
      l_ima_12 = iMA(NULL, TimeFrame, Length, Shift, MA_Type, Price, li_8);
      l_iatr_20 = iATR(NULL, TimeFrame, Length, li_8);
      g_ibuf_104[li_8] = l_ima_12 + l_iatr_20 * TimesATR;
      g_ibuf_108[li_8] = l_ima_12;
      g_ibuf_112[li_8] = l_ima_12 - l_iatr_20 * TimesATR;
   }
   return (0);
}