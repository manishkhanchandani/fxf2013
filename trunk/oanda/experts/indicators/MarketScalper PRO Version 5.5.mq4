
#property copyright "©2010-12 Build-a-Signal Software, Marko Nikolic"
#property link      "http://mnikolic.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Black
#property indicator_color2 Black



extern string Indicator = "MarketScalper PRO Series";
extern int Trading_Style = 2;
extern bool Manual = FALSE;
extern int Range = 20;
extern int Sensitivity = 15;
extern bool Filter_Signals = TRUE;
extern string Serial_Number = "";
extern string Client_Number = "";
extern bool Display_Market_Bias = TRUE;
extern bool Display_Build_Info = TRUE;
bool gi_128 = FALSE;
int g_period_132 = 6;
double gd_136 = 0.0;
double gd_144 = 1.0;
bool gi_152 = FALSE;
int g_period_156 = 5;
int gi_160 = 25;
int gi_164 = 75;
int g_applied_price_168 = PRICE_LOW;
bool gi_172 = FALSE;
int g_period_176 = 13;
int gi_unused_180 = -15;
int gi_unused_184 = 15;
int g_applied_price_188 = PRICE_CLOSE;
bool gi_192 = FALSE;
int g_period_196 = 21;
int gi_200 = -98;
int gi_204 = -2;
bool gi_208 = FALSE;
int g_period_212 = 2;
int g_period_216 = 3;
int g_applied_price_220 = PRICE_CLOSE;
int g_applied_price_224 = PRICE_CLOSE;
int g_ma_method_228 = MODE_LWMA;
int g_ma_method_232 = MODE_LWMA;
int gi_236 = 0;
int gi_240 = 0;
extern bool Alert_On = TRUE;
extern bool Alert_PopUp_On = TRUE;
extern bool Send_Email = FALSE;
extern string SetEmail = "Set email in Tools>Opt.>Email";
extern int Arrow_Distance = 10;
extern int ArrowType = 0;
extern int ArrowSize = 2;
extern color BuyArrowColor = Yellow;
extern color SellArrowColor = Red;
extern int Buy_Sound = 1;
extern int Sell_Sound = 1;
extern int Dashboard_Corner = 1;
extern int CountBars = 3000;
extern string About = "Range scale is 0 and upwards";
extern string About2 = "Sensitivity scale is 0-100";
extern string EndNote = "====Refer to manual for help====";
extern string Copyright.Marko.Nikolic = "(c) 2009-12 | Marko Nikolic";
extern string Publisher.Build.a.Signal = "     Build-A-Signal Software";
double gd_340;
double gd_348;
double gd_356;
double gd_364;
bool gi_372 = FALSE;
double g_ibuf_376[];
double g_ibuf_380[];
double gda_unused_384[];
double gda_unused_388[];
int gi_392 = 0;
int gi_396 = 0;
int g_bars_400 = 0;

int init() {
   if (IsDllsAllowed() == FALSE) {
      Alert("MarketScalper PRO v5.5 needs to import external functions to work properly.");
      Alert("MarketScalper: You must check \"Allow DLL Imports\" under indicator\'s \"Common\" tab.");
   }
   SetIndexStyle(0, DRAW_ARROW, EMPTY, ArrowSize, BuyArrowColor);
   SetIndexArrow(0, 225);
   SetIndexBuffer(0, g_ibuf_376);
   SetIndexStyle(1, DRAW_ARROW, EMPTY, ArrowSize, SellArrowColor);
   SetIndexArrow(1, 226);
   SetIndexBuffer(1, g_ibuf_380);
   if (ArrowType == 0) {
      SetIndexArrow(0, 233);
      SetIndexArrow(1, 234);
   } else {
      if (ArrowType == 1) {
         SetIndexArrow(0, 225);
         SetIndexArrow(1, 226);
      } else {
         if (ArrowType == 2) {
            SetIndexArrow(0, SYMBOL_ARROWUP);
            SetIndexArrow(1, SYMBOL_ARROWDOWN);
         } else {
            if (ArrowType == 3) {
               SetIndexArrow(0, 221);
               SetIndexArrow(1, 222);
            } else {
               if (ArrowType == 4) {
                  SetIndexArrow(0, 217);
                  SetIndexArrow(1, 218);
               } else {
                  if (ArrowType == 5) {
                     SetIndexArrow(0, 228);
                     SetIndexArrow(1, 230);
                  } else {
                     if (ArrowType == 6) {
                        SetIndexArrow(0, 236);
                        SetIndexArrow(1, 238);
                     } else {
                        if (ArrowType == 7) {
                           SetIndexArrow(0, 246);
                           SetIndexArrow(1, 248);
                        } else {
                           if (ArrowType == 8) {
                              SetIndexArrow(0, SYMBOL_THUMBSUP);
                              SetIndexArrow(1, SYMBOL_THUMBSDOWN);
                           } else {
                              if (ArrowType == 9) {
                                 SetIndexArrow(0, 71);
                                 SetIndexArrow(1, 72);
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }
   gd_356 = 0;
   gd_364 = 0;
   IndicatorShortName("MarketScalper PRO Series");
   return (0);
}

int start() {
   int str2int_4;
   string ls_8;
   int li_16;
   int li_unused_20;
   int ind_counted_24;
   string ls_28;
   int shift_40;
   int str2time_44;
   int li_48;
   int li_52;
   double istochastic_56;
   double istochastic_64;
   double iosma_72;
   double iosma_80;
   double iosma_88;
   double iosma_96;
   int li_104;
   string text_108;
   string text_116;
   string text_124;
   string text_132;
   string ls_140;
   color color_148;
   int li_152;
   int li_156;
   string ls_160;
   color color_168;
   string ls_172;
   color color_180;
   bool li_184;
   bool li_188;
   bool li_192;
   int li_196;
   int li_200;
   int li_204;
   int li_208;
   int li_212;
   int li_216;
   int li_220;
   int li_224;
   int li_228;
   int li_232;
   int li_236;
   int period_240;
   int period_244;
   int slowing_248;
   double ld_252;
   double ld_260;
   int price_field_268;
   int ma_method_272;
   int li_276;
   int li_280;
   int li_284;
   int li_288;
   int li_292;
   int li_296;
   int li_300;
   int li_304;
   int li_308;
   int li_312;
   int li_316;
   int li_320;
   int li_324;
   int li_328;
   int li_332;
   string ls_336;
   double ld_344;
   string ls_unused_352;
   string ls_360;
   string ls_368;
   double istochastic_376;
   double istochastic_384;
   double istochastic_392;
   double ld_400;
   double ld_408;
   double ld_416;
   double ld_424;
   double idemarker_432;
   double idemarker_440;
   double idemarker_448;
   double idemarker_456;
   double idemarker_464;
   double idemarker_472;
   double idemarker_480;
   double idemarker_488;
   double idemarker_496;
   double ld_504;
   double ld_512;
   string ls_unused_520;
   string ls_unused_528;
   double ld_536;
   double ld_544;
   double ld_552;
   string ls_560;
   int str2time_568;
   bool li_572;
   int str2time_576;
   int li_580;
   int li_584;
   double lda_588[32];
   double ld_592;
   bool li_600;
   int li_604;
   int li_608;
   int li_612;
   int li_616;
   datetime lt_0 = D'01.01.2030 01:00';
   if (TimeCurrent() > lt_0) {
      ObjectCreate("MSPTitle", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("MSPTitle", "MarketScalper PRO v5.5", 10, "Arial Bold", DodgerBlue);
      ObjectSet("MSPTitle", OBJPROP_CORNER, Dashboard_Corner);
      ObjectSet("MSPTitle", OBJPROP_XDISTANCE, 5);
      ObjectSet("MSPTitle", OBJPROP_YDISTANCE, 3);
      return (0);
   }
   if (TimeCurrent() < lt_0) {
      ObjectCreate("CountBars_Limit_MSP", OBJ_VLINE, 0, Time[CountBars], 0);
      ObjectSet("CountBars_Limit_MSP", OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet("CountBars_Limit_MSP", OBJPROP_COLOR, LimeGreen);
      ObjectSet("CountBars_Limit_MSP", OBJPROP_WIDTH, 2);
      ObjectCreate("counttxt_MSP", OBJ_TEXT, 0, Time[CountBars], Open[CountBars]);
      ObjectSetText("counttxt_MSP", StringConcatenate("MarketScalper PRO history (CountBars) set to ", CountBars), 8, "Arial Bold", Black);
      ObjectCreate("countback_MSP", OBJ_TEXT, 0, Time[CountBars], Open[CountBars]);
      ObjectSetText("countback_MSP", "ggggggggggg", 20, "Webdings", LimeGreen);
      if (Dashboard_Corner == 2) Dashboard_Corner = 4;
      if (Dashboard_Corner != 1 && Dashboard_Corner != 4) Dashboard_Corner = 1;
      str2int_4 = StrToInteger(Client_Number);
      if (str2int_4 == 0) str2int_4 = 0;
      ls_8 = "2013.";
      if (g_bars_400 == Bars) return (0);
      g_bars_400 = Bars;
      li_unused_20 = 0;
      ind_counted_24 = IndicatorCounted();
      ls_28 = "10.05";
      li_16 = Bars - ind_counted_24;
      if (ind_counted_24 > 0) li_16++;
      else
         if (li_16 > 100) li_16 = CountBars;
      SetIndexDrawBegin(0, Bars - CountBars);
      SetIndexDrawBegin(1, Bars - CountBars);
      for (int li_36 = CountBars; li_36 > 0; li_36--) {
         str2time_44 = StrToTime(ls_8 + ls_28);
         li_48 = Uncompound(gi_152);
         shift_40 = iBarShift(NULL, 0, Time[li_36], FALSE);
         g_ibuf_376[li_36] = EMPTY_VALUE;
         g_ibuf_380[li_36] = EMPTY_VALUE;
         if (TimeCurrent() > str2time_44) return (0);
         if (TimeCurrent() < str2time_44) {
            li_52 = BiasStrength();
            if (Display_Market_Bias && li_52) {
               istochastic_56 = iStochastic(NULL, 0, xDMBK(), xDMBD(), xDMBS(), xDMBMA(), xDMBPF(), xDMBMO(), shift_40);
 //                             iStochastic(NULL, 0, 13, 13, 10, 0, 0, 1, shift_40);
               istochastic_64 = iStochastic(NULL, 0, DIR2() / 2, xDMBD() + 3, DIRSh1(), xDMBMA() + 1, xDMBPF() + 1, xDMBMO(), shift_40);
 //                             iStochastic(NULL, 0, 200, 16, 50, 1, 1, 1, shift_40);
               iosma_72 = iOsMA(NULL, 0, DIR1(), DIR2(), DIR3(), PRICE_CLOSE, 0);
               iosma_80 = iOsMA(NULL, 0, DIRh1(), DIRh2(), DIRh3(), PRICE_CLOSE, 0);
               iosma_88 = iOsMA(NULL, 0, DIRS1(), DIRS2(), DIRS3(), PRICE_CLOSE, 0);
               iosma_96 = iOsMA(NULL, 0, DIRSh1(), DIRSh2(), DIRSh3(), PRICE_CLOSE, 0);
               li_104 = MarketBias(istochastic_56, Serial_Number, str2int_4);
               text_108 = "__________________________________";
               text_116 = "_____________________________";
               text_124 = "---------------------------------------------";
               text_132 = "----------------------------";
               if (li_104 == 0) {
                  ls_140 = "NEUTRAL/TRENDING      ";
                  color_148 = LimeGreen;
               } else {
                  if (li_104 == 1) {
                     ls_140 = "SLIGHTLY OVERBOUGHT  ";
                     color_148 = Gold;
                  } else {
                     if (li_104 == 2) {
                        ls_140 = "OVERBOUGHT           ";
                        color_148 = LightCoral;
                     } else {
                        if (li_104 == 3) {
                           ls_140 = "EXRTREMELY OVERBOUGHT!";
                           color_148 = Red;
                        } else {
                           if (li_104 == 4) {
                              ls_140 = "SLIGHTLY OVERSOLD     ";
                              color_148 = Gold;
                           } else {
                              if (li_104 == 5) {
                                 ls_140 = "OVERSOLD             ";
                                 color_148 = LightCoral;
                              } else {
                                 if (li_104 == 6) {
                                    ls_140 = "EXTREMELY OVERSOLD!  ";
                                    color_148 = Red;
                                 } else ls_140 = "";
                              }
                           }
                        }
                     }
                  }
               }
               li_152 = ScalperTrendLT(iosma_72, iosma_80, Serial_Number, str2int_4);
               li_156 = ScalperTrendST(iosma_88, iosma_96, Serial_Number, str2int_4);
               if (li_152 == 0) {
                  ls_160 = "   BULLISH           ";
                  color_168 = LimeGreen;
                  ObjectCreate("MSPZULevel1", OBJ_LABEL, 0, 0, 0);
                  ObjectSetText("MSPZULevel1", CharToStr(108), 11, "Wingdings", color_168);
                  ObjectSet("MSPZULevel1", OBJPROP_CORNER, Dashboard_Corner);
                  ObjectSet("MSPZULevel1", OBJPROP_XDISTANCE, 48);
                  ObjectSet("MSPZULevel1", OBJPROP_YDISTANCE, 94);
                  ObjectCreate("MSPZULevel1outline", OBJ_LABEL, 0, 0, 0);
                  ObjectSetText("MSPZULevel1outline", CharToStr(161), 11, "Wingdings", C'0x4E,0x39,0x1F');
                  ObjectSet("MSPZULevel1outline", OBJPROP_CORNER, Dashboard_Corner);
                  ObjectSet("MSPZULevel1outline", OBJPROP_XDISTANCE, 47);
                  ObjectSet("MSPZULevel1outline", OBJPROP_YDISTANCE, 94);
                  ObjectCreate("MSPZULevel2", OBJ_LABEL, 0, 0, 0);
                  ObjectSetText("MSPZULevel2", CharToStr(108), 11, "Wingdings", color_168);
                  ObjectSet("MSPZULevel2", OBJPROP_CORNER, Dashboard_Corner);
                  ObjectSet("MSPZULevel2", OBJPROP_XDISTANCE, 36);
                  ObjectSet("MSPZULevel2", OBJPROP_YDISTANCE, 94);
                  ObjectCreate("MSPZULevel2outline", OBJ_LABEL, 0, 0, 0);
                  ObjectSetText("MSPZULevel2outline", CharToStr(161), 11, "Wingdings", C'0x4E,0x39,0x1F');
                  ObjectSet("MSPZULevel2outline", OBJPROP_CORNER, Dashboard_Corner);
                  ObjectSet("MSPZULevel2outline", OBJPROP_XDISTANCE, 35);
                  ObjectSet("MSPZULevel2outline", OBJPROP_YDISTANCE, 94);
                  ObjectCreate("MSPZULevel3", OBJ_LABEL, 0, 0, 0);
                  ObjectSetText("MSPZULevel3", CharToStr(108), 11, "Wingdings", color_168);
                  ObjectSet("MSPZULevel3", OBJPROP_CORNER, Dashboard_Corner);
                  ObjectSet("MSPZULevel3", OBJPROP_XDISTANCE, 24);
                  ObjectSet("MSPZULevel3", OBJPROP_YDISTANCE, 94);
                  ObjectCreate("MSPZULevel3outline", OBJ_LABEL, 0, 0, 0);
                  ObjectSetText("MSPZULevel3outline", CharToStr(161), 11, "Wingdings", C'0x4E,0x39,0x1F');
                  ObjectSet("MSPZULevel3outline", OBJPROP_CORNER, Dashboard_Corner);
                  ObjectSet("MSPZULevel3outline", OBJPROP_XDISTANCE, 23);
                  ObjectSet("MSPZULevel3outline", OBJPROP_YDISTANCE, 94);
                  ObjectCreate("MSPZULevel4", OBJ_LABEL, 0, 0, 0);
                  ObjectSetText("MSPZULevel4", CharToStr(108), 11, "Wingdings", color_168);
                  ObjectSet("MSPZULevel4", OBJPROP_CORNER, Dashboard_Corner);
                  ObjectSet("MSPZULevel4", OBJPROP_XDISTANCE, 12);
                  ObjectSet("MSPZULevel4", OBJPROP_YDISTANCE, 94);
                  ObjectCreate("MSPZULevel4outline", OBJ_LABEL, 0, 0, 0);
                  ObjectSetText("MSPZULevel4outline", CharToStr(161), 11, "Wingdings", C'0x4E,0x39,0x1F');
                  ObjectSet("MSPZULevel4outline", OBJPROP_CORNER, Dashboard_Corner);
                  ObjectSet("MSPZULevel4outline", OBJPROP_XDISTANCE, 11);
                  ObjectSet("MSPZULevel4outline", OBJPROP_YDISTANCE, 94);
               } else {
                  if (li_152 == 1) {
                     ObjectDelete("MSPZULevel4");
                     ObjectDelete("MSPZULevel4Outline");
                     ls_160 = "   WEAK BULLISH     ";
                     color_168 = LimeGreen;
                     ObjectCreate("MSPZULevel1", OBJ_LABEL, 0, 0, 0);
                     ObjectSetText("MSPZULevel1", CharToStr(108), 11, "Wingdings", color_168);
                     ObjectSet("MSPZULevel1", OBJPROP_CORNER, Dashboard_Corner);
                     ObjectSet("MSPZULevel1", OBJPROP_XDISTANCE, 49);
                     ObjectSet("MSPZULevel1", OBJPROP_YDISTANCE, 94);
                     ObjectCreate("MSPZULevel1outline", OBJ_LABEL, 0, 0, 0);
                     ObjectSetText("MSPZULevel1outline", CharToStr(161), 11, "Wingdings", C'0x4E,0x39,0x1F');
                     ObjectSet("MSPZULevel1outline", OBJPROP_CORNER, Dashboard_Corner);
                     ObjectSet("MSPZULevel1outline", OBJPROP_XDISTANCE, 48);
                     ObjectSet("MSPZULevel1outline", OBJPROP_YDISTANCE, 94);
                     ObjectCreate("MSPZULevel2", OBJ_LABEL, 0, 0, 0);
                     ObjectSetText("MSPZULevel2", CharToStr(108), 11, "Wingdings", color_168);
                     ObjectSet("MSPZULevel2", OBJPROP_CORNER, Dashboard_Corner);
                     ObjectSet("MSPZULevel2", OBJPROP_XDISTANCE, 37);
                     ObjectSet("MSPZULevel2", OBJPROP_YDISTANCE, 94);
                     ObjectCreate("MSPZULevel2outline", OBJ_LABEL, 0, 0, 0);
                     ObjectSetText("MSPZULevel2outline", CharToStr(161), 11, "Wingdings", C'0x4E,0x39,0x1F');
                     ObjectSet("MSPZULevel2outline", OBJPROP_CORNER, Dashboard_Corner);
                     ObjectSet("MSPZULevel2outline", OBJPROP_XDISTANCE, 36);
                     ObjectSet("MSPZULevel2outline", OBJPROP_YDISTANCE, 94);
                     ObjectCreate("MSPZULevel3", OBJ_LABEL, 0, 0, 0);
                     ObjectSetText("MSPZULevel3", CharToStr(108), 11, "Wingdings", color_168);
                     ObjectSet("MSPZULevel3", OBJPROP_CORNER, Dashboard_Corner);
                     ObjectSet("MSPZULevel3", OBJPROP_XDISTANCE, 25);
                     ObjectSet("MSPZULevel3", OBJPROP_YDISTANCE, 94);
                     ObjectCreate("MSPZULevel3outline", OBJ_LABEL, 0, 0, 0);
                     ObjectSetText("MSPZULevel3outline", CharToStr(161), 11, "Wingdings", C'0x4E,0x39,0x1F');
                     ObjectSet("MSPZULevel3outline", OBJPROP_CORNER, Dashboard_Corner);
                     ObjectSet("MSPZULevel3outline", OBJPROP_XDISTANCE, 24);
                     ObjectSet("MSPZULevel3outline", OBJPROP_YDISTANCE, 94);
                  } else {
                     if (li_152 == 2) {
                        ObjectDelete("MSPZULevel2");
                        ObjectDelete("MSPZULevel2Outline");
                        ObjectDelete("MSPZULevel3");
                        ObjectDelete("MSPZULevel3Outline");
                        ObjectDelete("MSPZULevel4");
                        ObjectDelete("MSPZULevel4Outline");
                        ls_160 = "   BEARISH           ";
                        color_168 = Red;
                        ObjectCreate("MSPZULevel1", OBJ_LABEL, 0, 0, 0);
                        ObjectSetText("MSPZULevel1", CharToStr(108), 11, "Wingdings", color_168);
                        ObjectSet("MSPZULevel1", OBJPROP_CORNER, Dashboard_Corner);
                        ObjectSet("MSPZULevel1", OBJPROP_XDISTANCE, 49);
                        ObjectSet("MSPZULevel1", OBJPROP_YDISTANCE, 94);
                        ObjectCreate("MSPZULevel1outline", OBJ_LABEL, 0, 0, 0);
                        ObjectSetText("MSPZULevel1outline", CharToStr(161), 11, "Wingdings", C'0x4E,0x39,0x1F');
                        ObjectSet("MSPZULevel1outline", OBJPROP_CORNER, Dashboard_Corner);
                        ObjectSet("MSPZULevel1outline", OBJPROP_XDISTANCE, 48);
                        ObjectSet("MSPZULevel1outline", OBJPROP_YDISTANCE, 94);
                     } else {
                        if (li_152 == 3) {
                           ObjectDelete("MSPZULevel3");
                           ObjectDelete("MSPZULevel3Outline");
                           ObjectDelete("MSPZULevel4");
                           ObjectDelete("MSPZULevel4Outline");
                           ls_160 = "   WEAK BEARISH     ";
                           color_168 = Red;
                           ObjectCreate("MSPZULevel1", OBJ_LABEL, 0, 0, 0);
                           ObjectSetText("MSPZULevel1", CharToStr(108), 11, "Wingdings", color_168);
                           ObjectSet("MSPZULevel1", OBJPROP_CORNER, Dashboard_Corner);
                           ObjectSet("MSPZULevel1", OBJPROP_XDISTANCE, 49);
                           ObjectSet("MSPZULevel1", OBJPROP_YDISTANCE, 94);
                           ObjectCreate("MSPZULevel1outline", OBJ_LABEL, 0, 0, 0);
                           ObjectSetText("MSPZULevel1outline", CharToStr(161), 11, "Wingdings", C'0x4E,0x39,0x1F');
                           ObjectSet("MSPZULevel1outline", OBJPROP_CORNER, Dashboard_Corner);
                           ObjectSet("MSPZULevel1outline", OBJPROP_XDISTANCE, 48);
                           ObjectSet("MSPZULevel1outline", OBJPROP_YDISTANCE, 94);
                           ObjectCreate("MSPZULevel2", OBJ_LABEL, 0, 0, 0);
                           ObjectSetText("MSPZULevel2", CharToStr(108), 11, "Wingdings", color_168);
                           ObjectSet("MSPZULevel2", OBJPROP_CORNER, Dashboard_Corner);
                           ObjectSet("MSPZULevel2", OBJPROP_XDISTANCE, 37);
                           ObjectSet("MSPZULevel2", OBJPROP_YDISTANCE, 94);
                           ObjectCreate("MSPZULevel2outline", OBJ_LABEL, 0, 0, 0);
                           ObjectSetText("MSPZULevel2outline", CharToStr(161), 11, "Wingdings", C'0x4E,0x39,0x1F');
                           ObjectSet("MSPZULevel2outline", OBJPROP_CORNER, Dashboard_Corner);
                           ObjectSet("MSPZULevel2outline", OBJPROP_XDISTANCE, 36);
                           ObjectSet("MSPZULevel2outline", OBJPROP_YDISTANCE, 94);
                        }
                     }
                  }
               }
               if (li_156 == 0) {
                  ObjectDelete("MSPZILevel4");
                  ObjectDelete("MSPZILevel4Outline");
                  ls_172 = "   WEAK BULLISH     ";
                  color_180 = LimeGreen;
                  ObjectCreate("MSPZILevel1", OBJ_LABEL, 0, 0, 0);
                  ObjectSetText("MSPZILevel1", CharToStr(108), 11, "Wingdings", color_180);
                  ObjectSet("MSPZILevel1", OBJPROP_CORNER, Dashboard_Corner);
                  ObjectSet("MSPZILevel1", OBJPROP_XDISTANCE, 48);
                  ObjectSet("MSPZILevel1", OBJPROP_YDISTANCE, 76);
                  ObjectCreate("MSPZILevel1outline", OBJ_LABEL, 0, 0, 0);
                  ObjectSetText("MSPZILevel1outline", CharToStr(161), 11, "Wingdings", C'0x4E,0x39,0x1F');
                  ObjectSet("MSPZILevel1outline", OBJPROP_CORNER, Dashboard_Corner);
                  ObjectSet("MSPZILevel1outline", OBJPROP_XDISTANCE, 47);
                  ObjectSet("MSPZILevel1outline", OBJPROP_YDISTANCE, 76);
                  ObjectCreate("MSPZILevel2", OBJ_LABEL, 0, 0, 0);
                  ObjectSetText("MSPZILevel2", CharToStr(108), 11, "Wingdings", color_180);
                  ObjectSet("MSPZILevel2", OBJPROP_CORNER, Dashboard_Corner);
                  ObjectSet("MSPZILevel2", OBJPROP_XDISTANCE, 36);
                  ObjectSet("MSPZILevel2", OBJPROP_YDISTANCE, 76);
                  ObjectCreate("MSPZILevel2outline", OBJ_LABEL, 0, 0, 0);
                  ObjectSetText("MSPZILevel2outline", CharToStr(161), 11, "Wingdings", C'0x4E,0x39,0x1F');
                  ObjectSet("MSPZILevel2outline", OBJPROP_CORNER, Dashboard_Corner);
                  ObjectSet("MSPZILevel2outline", OBJPROP_XDISTANCE, 35);
                  ObjectSet("MSPZILevel2outline", OBJPROP_YDISTANCE, 76);
                  ObjectCreate("MSPZILevel3", OBJ_LABEL, 0, 0, 0);
                  ObjectSetText("MSPZILevel3", CharToStr(108), 11, "Wingdings", color_180);
                  ObjectSet("MSPZILevel3", OBJPROP_CORNER, Dashboard_Corner);
                  ObjectSet("MSPZILevel3", OBJPROP_XDISTANCE, 24);
                  ObjectSet("MSPZILevel3", OBJPROP_YDISTANCE, 76);
                  ObjectCreate("MSPZILevel3outline", OBJ_LABEL, 0, 0, 0);
                  ObjectSetText("MSPZILevel3outline", CharToStr(161), 11, "Wingdings", C'0x4E,0x39,0x1F');
                  ObjectSet("MSPZILevel3outline", OBJPROP_CORNER, Dashboard_Corner);
                  ObjectSet("MSPZILevel3outline", OBJPROP_XDISTANCE, 23);
                  ObjectSet("MSPZILevel3outline", OBJPROP_YDISTANCE, 76);
               } else {
                  if (li_156 == 1) {
                     ls_172 = "   BULLISH           ";
                     color_180 = LimeGreen;
                     ObjectCreate("MSPZILevel1", OBJ_LABEL, 0, 0, 0);
                     ObjectSetText("MSPZILevel1", CharToStr(108), 11, "Wingdings", color_180);
                     ObjectSet("MSPZILevel1", OBJPROP_CORNER, Dashboard_Corner);
                     ObjectSet("MSPZILevel1", OBJPROP_XDISTANCE, 48);
                     ObjectSet("MSPZILevel1", OBJPROP_YDISTANCE, 76);
                     ObjectCreate("MSPZILevel1outline", OBJ_LABEL, 0, 0, 0);
                     ObjectSetText("MSPZILevel1outline", CharToStr(161), 11, "Wingdings", C'0x4E,0x39,0x1F');
                     ObjectSet("MSPZILevel1outline", OBJPROP_CORNER, Dashboard_Corner);
                     ObjectSet("MSPZILevel1outline", OBJPROP_XDISTANCE, 47);
                     ObjectSet("MSPZILevel1outline", OBJPROP_YDISTANCE, 76);
                     ObjectCreate("MSPZILevel2", OBJ_LABEL, 0, 0, 0);
                     ObjectSetText("MSPZILevel2", CharToStr(108), 11, "Wingdings", color_180);
                     ObjectSet("MSPZILevel2", OBJPROP_CORNER, Dashboard_Corner);
                     ObjectSet("MSPZILevel2", OBJPROP_XDISTANCE, 36);
                     ObjectSet("MSPZILevel2", OBJPROP_YDISTANCE, 76);
                     ObjectCreate("MSPZILevel2outline", OBJ_LABEL, 0, 0, 0);
                     ObjectSetText("MSPZILevel2outline", CharToStr(161), 11, "Wingdings", C'0x4E,0x39,0x1F');
                     ObjectSet("MSPZILevel2outline", OBJPROP_CORNER, Dashboard_Corner);
                     ObjectSet("MSPZILevel2outline", OBJPROP_XDISTANCE, 35);
                     ObjectSet("MSPZILevel2outline", OBJPROP_YDISTANCE, 76);
                     ObjectCreate("MSPZILevel3", OBJ_LABEL, 0, 0, 0);
                     ObjectSetText("MSPZILevel3", CharToStr(108), 11, "Wingdings", color_180);
                     ObjectSet("MSPZILevel3", OBJPROP_CORNER, Dashboard_Corner);
                     ObjectSet("MSPZILevel3", OBJPROP_XDISTANCE, 24);
                     ObjectSet("MSPZILevel3", OBJPROP_YDISTANCE, 76);
                     ObjectCreate("MSPZILevel3outline", OBJ_LABEL, 0, 0, 0);
                     ObjectSetText("MSPZILevel3outline", CharToStr(161), 11, "Wingdings", C'0x4E,0x39,0x1F');
                     ObjectSet("MSPZILevel3outline", OBJPROP_CORNER, Dashboard_Corner);
                     ObjectSet("MSPZILevel3outline", OBJPROP_XDISTANCE, 23);
                     ObjectSet("MSPZILevel3outline", OBJPROP_YDISTANCE, 76);
                     ObjectCreate("MSPZILevel4", OBJ_LABEL, 0, 0, 0);
                     ObjectSetText("MSPZILevel4", CharToStr(108), 11, "Wingdings", color_180);
                     ObjectSet("MSPZILevel4", OBJPROP_CORNER, Dashboard_Corner);
                     ObjectSet("MSPZILevel4", OBJPROP_XDISTANCE, 12);
                     ObjectSet("MSPZILevel4", OBJPROP_YDISTANCE, 76);
                     ObjectCreate("MSPZILevel4outline", OBJ_LABEL, 0, 0, 0);
                     ObjectSetText("MSPZILevel4outline", CharToStr(161), 11, "Wingdings", C'0x4E,0x39,0x1F');
                     ObjectSet("MSPZILevel4outline", OBJPROP_CORNER, Dashboard_Corner);
                     ObjectSet("MSPZILevel4outline", OBJPROP_XDISTANCE, 11);
                     ObjectSet("MSPZILevel4outline", OBJPROP_YDISTANCE, 76);
                  } else {
                     if (li_156 == 2) {
                        ObjectDelete("MSPZILevel3");
                        ObjectDelete("MSPZILevel3Outline");
                        ObjectDelete("MSPZILevel4");
                        ObjectDelete("MSPZILevel4Outline");
                        ls_172 = "   WEAK BEARISH     ";
                        color_180 = Red;
                        ObjectCreate("MSPZILevel1", OBJ_LABEL, 0, 0, 0);
                        ObjectSetText("MSPZILevel1", CharToStr(108), 11, "Wingdings", color_180);
                        ObjectSet("MSPZILevel1", OBJPROP_CORNER, Dashboard_Corner);
                        ObjectSet("MSPZILevel1", OBJPROP_XDISTANCE, 48);
                        ObjectSet("MSPZILevel1", OBJPROP_YDISTANCE, 76);
                        ObjectCreate("MSPZILevel1outline", OBJ_LABEL, 0, 0, 0);
                        ObjectSetText("MSPZILevel1outline", CharToStr(161), 11, "Wingdings", C'0x4E,0x39,0x1F');
                        ObjectSet("MSPZILevel1outline", OBJPROP_CORNER, Dashboard_Corner);
                        ObjectSet("MSPZILevel1outline", OBJPROP_XDISTANCE, 47);
                        ObjectSet("MSPZILevel1outline", OBJPROP_YDISTANCE, 76);
                        ObjectCreate("MSPZILevel2", OBJ_LABEL, 0, 0, 0);
                        ObjectSetText("MSPZILevel2", CharToStr(108), 11, "Wingdings", color_180);
                        ObjectSet("MSPZILevel2", OBJPROP_CORNER, Dashboard_Corner);
                        ObjectSet("MSPZILevel2", OBJPROP_XDISTANCE, 36);
                        ObjectSet("MSPZILevel2", OBJPROP_YDISTANCE, 76);
                        ObjectCreate("MSPZILevel2outline", OBJ_LABEL, 0, 0, 0);
                        ObjectSetText("MSPZILevel2outline", CharToStr(161), 11, "Wingdings", C'0x4E,0x39,0x1F');
                        ObjectSet("MSPZILevel2outline", OBJPROP_CORNER, Dashboard_Corner);
                        ObjectSet("MSPZILevel2outline", OBJPROP_XDISTANCE, 35);
                        ObjectSet("MSPZILevel2outline", OBJPROP_YDISTANCE, 76);
                     } else {
                        if (li_156 == 3) {
                           ObjectDelete("MSPZILevel2");
                           ObjectDelete("MSPZILevel2Outline");
                           ObjectDelete("MSPZILevel3");
                           ObjectDelete("MSPZILevel3Outline");
                           ObjectDelete("MSPZILevel4");
                           ObjectDelete("MSPZILevel4Outline");
                           ls_172 = "   BEARISH           ";
                           color_180 = Red;
                           ObjectCreate("MSPZILevel1", OBJ_LABEL, 0, 0, 0);
                           ObjectSetText("MSPZILevel1", CharToStr(108), 11, "Wingdings", color_180);
                           ObjectSet("MSPZILevel1", OBJPROP_CORNER, Dashboard_Corner);
                           ObjectSet("MSPZILevel1", OBJPROP_XDISTANCE, 48);
                           ObjectSet("MSPZILevel1", OBJPROP_YDISTANCE, 76);
                           ObjectCreate("MSPZILevel1outline", OBJ_LABEL, 0, 0, 0);
                           ObjectSetText("MSPZILevel1outline", CharToStr(161), 11, "Wingdings", C'0x4E,0x39,0x1F');
                           ObjectSet("MSPZILevel1outline", OBJPROP_CORNER, Dashboard_Corner);
                           ObjectSet("MSPZILevel1outline", OBJPROP_XDISTANCE, 47);
                           ObjectSet("MSPZILevel1outline", OBJPROP_YDISTANCE, 76);
                        }
                     }
                  }
               }
            }
            if (Manual) li_184 = TRUE;
            else li_184 = FALSE;
            li_188 = FALSE;
            li_192 = TRUE;
            li_196 = 2;
            li_200 = 3;
            li_204 = 4;
            li_208 = 5;
            li_212 = 6;
            li_216 = 7;
            li_220 = 8;
            li_224 = 9;
            li_228 = 10;
            li_232 = 11;
            li_236 = 12;
            period_240 = PeriodK(Trading_Style, li_184, Range, Sensitivity);
            period_244 = PeriodD(Trading_Style, li_184, Range, Sensitivity);
            slowing_248 = PeriodS(Trading_Style, li_184, Range, Sensitivity);
            ld_252 = UpStoch(Trading_Style, li_184, Range, Sensitivity);
            ld_260 = DwStoch(Trading_Style, li_184, Range, Sensitivity);
            price_field_268 = PfStoch(Trading_Style, li_184);
            ma_method_272 = MaStoch(Trading_Style, li_184);
            li_276 = MdStoch(Trading_Style, li_184);
            li_280 = MdStochP(Trading_Style, li_184);
            li_284 = ShStoch(li_188, Trading_Style, li_184);
            li_288 = ShStoch(li_192, Trading_Style, li_184);
            li_292 = ShStoch(li_196, Trading_Style, li_184);
            li_296 = ShStoch(li_200, Trading_Style, li_184);
            li_300 = ShStoch(li_204, Trading_Style, li_184);
            li_304 = ShStoch(li_208, Trading_Style, li_184);
            li_308 = ShStoch(li_212, Trading_Style, li_184);
            li_312 = ShStoch(li_216, Trading_Style, li_184);
            li_316 = ShStoch(li_220, Trading_Style, li_184);
            li_320 = ShStoch(li_224, Trading_Style, li_184);
            li_324 = ShStoch(li_228, Trading_Style, li_184);
            li_328 = ShStoch(li_232, Trading_Style, li_184);
            li_332 = ShStoch(li_236, Trading_Style, li_184);
            ls_336 = ".04";
            if (gi_152) {
               ld_344 = iRSI(NULL, 0, g_period_156, g_applied_price_168, shift_40);
               ls_unused_352 = "RSI  ";
            } else {
               ld_344 = li_48;
               gi_160 = li_48;
               gi_164 = li_48;
            }
            ls_360 = "13";
            ls_368 = ".17";
            if (Manual) {
               istochastic_376 = iStochastic(NULL, 0, period_240, period_244, slowing_248, ma_method_272, price_field_268, li_276, shift_40);
               istochastic_384 = iStochastic(NULL, 0, period_240, period_244, slowing_248, ma_method_272, price_field_268, MODE_MAIN, shift_40);
               istochastic_392 = iStochastic(NULL, 0, period_240, period_244, slowing_248, ma_method_272, price_field_268, MODE_SIGNAL, shift_40);
               ld_400 = iStochastic(NULL, 0, period_240, period_244, slowing_248, ma_method_272, price_field_268, li_276, shift_40 + li_288);
               ld_408 = iStochastic(NULL, 0, period_240, period_244, slowing_248, ma_method_272, price_field_268, li_276, shift_40 + li_292);
               ld_416 = iStochastic(NULL, 0, period_240, period_244, slowing_248, ma_method_272, price_field_268, li_276, shift_40 + li_296);
               ld_424 = iStochastic(NULL, 0, period_240, period_244, slowing_248, ma_method_272, price_field_268, li_276, shift_40 + li_300);
            } else {
               istochastic_376 = iStochastic(NULL, 0, period_240, period_244, slowing_248, ma_method_272, price_field_268, li_276, shift_40);
               istochastic_384 = iStochastic(NULL, 0, period_240, period_244, slowing_248, ma_method_272, price_field_268, MODE_MAIN, shift_40);
               istochastic_392 = iStochastic(NULL, 0, period_240, period_244, slowing_248, ma_method_272, price_field_268, MODE_SIGNAL, shift_40);
               ld_400 = iDeMarker(NULL, 0, period_240, shift_40 + li_284);
               ld_408 = iDeMarker(NULL, 0, period_240, shift_40 + li_288);
               ld_416 = iDeMarker(NULL, 0, period_240, shift_40 + li_292);
               ld_424 = iDeMarker(NULL, 0, period_240, shift_40 + li_296);
               idemarker_432 = iDeMarker(NULL, 0, period_240, shift_40 + li_300);
               idemarker_440 = iDeMarker(NULL, 0, period_240, shift_40 + li_304);
               idemarker_448 = iDeMarker(NULL, 0, period_240, shift_40 + li_308);
               idemarker_456 = iDeMarker(NULL, 0, period_240, shift_40 + li_312);
               idemarker_464 = iDeMarker(NULL, 0, period_240, shift_40 + li_316);
               idemarker_472 = iDeMarker(NULL, 0, period_240, shift_40 + li_320);
               idemarker_480 = iDeMarker(NULL, 0, period_240, shift_40 + li_324);
               idemarker_488 = iDeMarker(NULL, 0, period_240, shift_40 + li_328);
               idemarker_496 = iDeMarker(NULL, 0, period_240, shift_40 + li_332);
            }
            if (gi_172) ld_504 = iCCI(NULL, 0, g_period_176, g_applied_price_188, shift_40);
            else {
               ld_504 = li_48;
               gi_unused_180 = li_48;
               gi_unused_184 = li_48;
            }
            if (gi_192) {
               ld_512 = iWPR(NULL, 0, g_period_196, shift_40);
               ls_unused_520 = "WPR";
            } else {
               ld_512 = li_48;
               gi_200 = li_48;
               gi_204 = li_48;
            }
            if (gi_208) {
               ls_unused_528 = "2MA  ";
               ld_536 = iMA(NULL, 0, g_period_212, gi_236, g_ma_method_228, g_applied_price_220, shift_40);
               ld_544 = iMA(NULL, 0, g_period_216, gi_240, g_ma_method_232, g_applied_price_224, shift_40);
            } else {
               ld_536 = li_48;
               ld_544 = li_48;
            }
            if (gi_128) ld_552 = iDeMarker(NULL, 0, g_period_132, shift_40);
            else {
               ld_552 = li_48;
               gd_136 = li_48;
               gd_144 = li_48;
            }
            ls_560 = "20";
         }
         ObjectCreate("TitleTextMSP", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("TitleTextMSP", TBType(Serial_Number, str2int_4, gi_396), 10, "Arial Bold", Red);
         ObjectSet("TitleTextMSP", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("TitleTextMSP", OBJPROP_XDISTANCE, 5);
         ObjectSet("TitleTextMSP", OBJPROP_YDISTANCE, 3);
         if (Display_Build_Info) {
            ObjectCreate("BuildTextMSP", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("BuildTextMSP", MSPBuild(Serial_Number, str2int_4, gi_396), 8, "Arial", Red);
            ObjectSet("BuildTextMSP", OBJPROP_CORNER, 2);
            ObjectSet("BuildTextMSP", OBJPROP_XDISTANCE, 5);
            ObjectSet("BuildTextMSP", OBJPROP_YDISTANCE, 15);
         } else
            if (!Display_Build_Info) ObjectDelete("BuildTextMSP");
         str2time_568 = StrToTime(ls_560 + ls_360 + ls_336 + ls_368);
         li_572 = SetMSPMode();
         if (li_572) {
            if (!Manual && Trading_Style == 0 || Trading_Style == 1) {
               ObjectCreate("MSPMode", OBJ_LABEL, 0, 0, 0);
               ObjectSet("MSPMode", OBJPROP_CORNER, Dashboard_Corner);
               ObjectSet("MSPMode", OBJPROP_XDISTANCE, 5);
               ObjectSet("MSPMode", OBJPROP_YDISTANCE, 20);
               if (Filter_Signals) ObjectSetText("MSPMode", "MODE: HIGH PROBABILITY (Filtered)", 8, "Arial", DodgerBlue);
               else ObjectSetText("MSPMode", "MODE: HIGH PROBABILITY", 8, "Arial", DodgerBlue);
            }
            if (!Manual && Trading_Style == 2) {
               ObjectCreate("MSPMode", OBJ_LABEL, 0, 0, 0);
               ObjectSet("MSPMode", OBJPROP_CORNER, Dashboard_Corner);
               ObjectSet("MSPMode", OBJPROP_XDISTANCE, 5);
               ObjectSet("MSPMode", OBJPROP_YDISTANCE, 20);
               if (Filter_Signals) ObjectSetText("MSPMode", "MODE: BALANCED (Filtered)", 8, "Arial", Yellow);
               else ObjectSetText("MSPMode", "MODE: BALANCED", 8, "Arial", Yellow);
            }
            if (!Manual && Trading_Style == 3) {
               ObjectCreate("MSPMode", OBJ_LABEL, 0, 0, 0);
               ObjectSet("MSPMode", OBJPROP_CORNER, Dashboard_Corner);
               ObjectSet("MSPMode", OBJPROP_XDISTANCE, 5);
               ObjectSet("MSPMode", OBJPROP_YDISTANCE, 20);
               if (Filter_Signals) ObjectSetText("MSPMode", "MODE: AGGRESSIVE (Filtered)", 8, "Arial", Red);
               else ObjectSetText("MSPMode", "MODE: AGGRESSIVE", 8, "Arial", Red);
            }
            str2time_576 = StrToTime(ls_560 + ls_360 + ls_336 + ls_368);
            if (Manual && Trading_Style > 0) {
               ObjectCreate("MSPMode", OBJ_LABEL, 0, 0, 0);
               ObjectSet("MSPMode", OBJPROP_CORNER, Dashboard_Corner);
               ObjectSet("MSPMode", OBJPROP_XDISTANCE, 5);
               ObjectSet("MSPMode", OBJPROP_YDISTANCE, 20);
               if (Filter_Signals) ObjectSetText("MSPMode", "MANUAL MODE  |  RANGE: " + Range + "  SENSITIVITY: " + Sensitivity + " (Filtered)", 8, "Arial", Yellow);
               else ObjectSetText("MSPMode", "MANUAL MODE  |  RANGE: " + Range + "  SENSITIVITY: " + Sensitivity, 8, "Arial", Yellow);
            }
         }
         li_580 = CalcBias(istochastic_56, Serial_Number, str2int_4);
         ObjectCreate("MSPBias", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPBias", DoubleToStr(li_580, 0), 11, "Arial Bold", color_148);
         ObjectSet("MSPBias", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPBias", OBJPROP_XDISTANCE, 11);
         ObjectSet("MSPBias", OBJPROP_YDISTANCE, 52);
         ObjectCreate("MSPBiasFrame", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPBiasFrame", text_108, 8, "Arial", color_148);
         ObjectSet("MSPBiasFrame", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPBiasFrame", OBJPROP_XDISTANCE, 6);
         ObjectSet("MSPBiasFrame", OBJPROP_YDISTANCE, 37);
         ObjectCreate("MSPBiasFrame2", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPBiasFrame2", text_108, 8, "Arial", color_148);
         ObjectSet("MSPBiasFrame2", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPBiasFrame2", OBJPROP_XDISTANCE, 6);
         ObjectSet("MSPBiasFrame2", OBJPROP_YDISTANCE, 36);
         ObjectCreate("MSPBiasFrame3", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPBiasFrame3", text_108, 8, "Arial", color_148);
         ObjectSet("MSPBiasFrame3", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPBiasFrame3", OBJPROP_XDISTANCE, 6);
         ObjectSet("MSPBiasFrame3", OBJPROP_YDISTANCE, 35);
         ObjectCreate("MSPBiasFrameBottom", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPBiasFrameBottom", text_108, 8, "Arial", color_148);
         ObjectSet("MSPBiasFrameBottom", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPBiasFrameBottom", OBJPROP_XDISTANCE, 9);
         ObjectSet("MSPBiasFrameBottom", OBJPROP_YDISTANCE, 61);
         ObjectCreate("MSPTrendFrame", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPTrendFrame", text_124, 8, "Arial", color_148);
         ObjectSet("MSPTrendFrame", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPTrendFrame", OBJPROP_XDISTANCE, 30);
         ObjectSet("MSPTrendFrame", OBJPROP_YDISTANCE, 84);
         ObjectCreate("MSPTrendFrameBrown", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPTrendFrameBrown", text_132, 5, "Arial", C'0x4E,0x39,0x1F');
         ObjectSet("MSPTrendFrameBrown", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPTrendFrameBrown", OBJPROP_XDISTANCE, 6);
         ObjectSet("MSPTrendFrameBrown", OBJPROP_YDISTANCE, 88);
         ObjectCreate("MSPTrendFrameBottom", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPTrendFrameBottom", text_116, 8, "Arial", color_148);
         ObjectSet("MSPTrendFrameBottom", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPTrendFrameBottom", OBJPROP_XDISTANCE, 30);
         ObjectSet("MSPTrendFrameBottom", OBJPROP_YDISTANCE, 96);
         ObjectCreate("MSPTrendFrameBottom2", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPTrendFrameBottom2", text_116, 8, "Arial", color_148);
         ObjectSet("MSPTrendFrameBottom2", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPTrendFrameBottom2", OBJPROP_XDISTANCE, 30);
         ObjectSet("MSPTrendFrameBottom2", OBJPROP_YDISTANCE, 97);
         ObjectCreate("MSPTrendFrameBottom3", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPTrendFrameBottom3", text_116, 8, "Arial", color_148);
         ObjectSet("MSPTrendFrameBottom3", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPTrendFrameBottom3", OBJPROP_XDISTANCE, 30);
         ObjectSet("MSPTrendFrameBottom3", OBJPROP_YDISTANCE, 98);
         ObjectCreate("MSPBiasTxt", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPBiasTxt", " " + ls_140, 8, "Arial Bold", color_148);
         ObjectSet("MSPBiasTxt", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPBiasTxt", OBJPROP_XDISTANCE, 40);
         ObjectSet("MSPBiasTxt", OBJPROP_YDISTANCE, 54);
         ObjectCreate("MSPBiasBox", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPBiasBox", CharToStr(168), 28, "Wingdings", color_148);
         ObjectSet("MSPBiasBox", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPBiasBox", OBJPROP_XDISTANCE, 3);
         ObjectSet("MSPBiasBox", OBJPROP_YDISTANCE, 41);
         ObjectCreate("MSPBiasBoxL", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPBiasBoxL", CharToStr(168), 28, "Wingdings", color_148);
         ObjectSet("MSPBiasBoxL", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPBiasBoxL", OBJPROP_XDISTANCE, 185);
         ObjectSet("MSPBiasBoxL", OBJPROP_YDISTANCE, 41);
         ObjectCreate("MSPBiasBoxLTxt", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPBiasBoxLTxt", "B", 12, "Arial Bold", color_148);
         ObjectSet("MSPBiasBoxLTxt", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPBiasBoxLTxt", OBJPROP_XDISTANCE, 195);
         ObjectSet("MSPBiasBoxLTxt", OBJPROP_YDISTANCE, 52);
         ObjectCreate("MSPSnapShotPaint", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPSnapShotPaint", CharToStr(110), 34, "Wingdings", color_148);
         ObjectSet("MSPSnapShotPaint", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPSnapShotPaint", OBJPROP_XDISTANCE, 185);
         ObjectSet("MSPSnapShotPaint", OBJPROP_YDISTANCE, 62);
         ObjectCreate("MSPSnapShotPaint2", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPSnapShotPaint2", CharToStr(110), 34, "Wingdings", color_148);
         ObjectSet("MSPSnapShotPaint2", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPSnapShotPaint2", OBJPROP_XDISTANCE, 185);
         ObjectSet("MSPSnapShotPaint2", OBJPROP_YDISTANCE, 74);
         ObjectCreate("MSPSnapShotPaint3", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPSnapShotPaint3", CharToStr(110), 34, "Wingdings", color_148);
         ObjectSet("MSPSnapShotPaint3", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPSnapShotPaint3", OBJPROP_XDISTANCE, 2);
         ObjectSet("MSPSnapShotPaint3", OBJPROP_YDISTANCE, 62);
         ObjectCreate("MSPSnapShotPaint4", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPSnapShotPaint4", CharToStr(110), 34, "Wingdings", color_148);
         ObjectSet("MSPSnapShotPaint4", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPSnapShotPaint4", OBJPROP_XDISTANCE, 2);
         ObjectSet("MSPSnapShotPaint4", OBJPROP_YDISTANCE, 74);
         ObjectCreate("MSPSnapShotPaint5", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPSnapShotPaint5", CharToStr(110), 48, "Wingdings", color_148);
         ObjectSet("MSPSnapShotPaint5", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPSnapShotPaint5", OBJPROP_XDISTANCE, 2);
         ObjectSet("MSPSnapShotPaint5", OBJPROP_YDISTANCE, 58);
         ObjectCreate("MSPSnapShotPaint3L", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPSnapShotPaint3L", CharToStr(110), 34, "Wingdings", color_148);
         ObjectSet("MSPSnapShotPaint3L", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPSnapShotPaint3L", OBJPROP_XDISTANCE, 32);
         ObjectSet("MSPSnapShotPaint3L", OBJPROP_YDISTANCE, 62);
         ObjectCreate("MSPSnapShotPaint4L", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPSnapShotPaint4L", CharToStr(110), 34, "Wingdings", color_148);
         ObjectSet("MSPSnapShotPaint4L", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPSnapShotPaint4L", OBJPROP_XDISTANCE, 32);
         ObjectSet("MSPSnapShotPaint4L", OBJPROP_YDISTANCE, 74);
         ObjectCreate("MSPSnapShotZIDot", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPSnapShotZIDot", CharToStr(108), 11, "Wingdings", C'0x4E,0x39,0x1F');
         ObjectSet("MSPSnapShotZIDot", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPSnapShotZIDot", OBJPROP_XDISTANCE, 48);
         ObjectSet("MSPSnapShotZIDot", OBJPROP_YDISTANCE, 76);
         ObjectCreate("MSPSnapShotZIDot2", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPSnapShotZIDot2", CharToStr(108), 11, "Wingdings", C'0x4E,0x39,0x1F');
         ObjectSet("MSPSnapShotZIDot2", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPSnapShotZIDot2", OBJPROP_XDISTANCE, 36);
         ObjectSet("MSPSnapShotZIDot2", OBJPROP_YDISTANCE, 76);
         ObjectCreate("MSPSnapShotZIDot3", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPSnapShotZIDot3", CharToStr(108), 11, "Wingdings", C'0x4E,0x39,0x1F');
         ObjectSet("MSPSnapShotZIDot3", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPSnapShotZIDot3", OBJPROP_XDISTANCE, 24);
         ObjectSet("MSPSnapShotZIDot3", OBJPROP_YDISTANCE, 76);
         ObjectCreate("MSPSnapShotZIDot4", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPSnapShotZIDot4", CharToStr(108), 11, "Wingdings", C'0x4E,0x39,0x1F');
         ObjectSet("MSPSnapShotZIDot4", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPSnapShotZIDot4", OBJPROP_XDISTANCE, 12);
         ObjectSet("MSPSnapShotZIDot4", OBJPROP_YDISTANCE, 76);
         ObjectCreate("MSPSnapShotZUDot", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPSnapShotZUDot", CharToStr(108), 11, "Wingdings", C'0x4E,0x39,0x1F');
         ObjectSet("MSPSnapShotZUDot", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPSnapShotZUDot", OBJPROP_XDISTANCE, 48);
         ObjectSet("MSPSnapShotZUDot", OBJPROP_YDISTANCE, 94);
         ObjectCreate("MSPSnapShotZUDot2", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPSnapShotZUDot2", CharToStr(108), 11, "Wingdings", C'0x4E,0x39,0x1F');
         ObjectSet("MSPSnapShotZUDot2", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPSnapShotZUDot2", OBJPROP_XDISTANCE, 36);
         ObjectSet("MSPSnapShotZUDot2", OBJPROP_YDISTANCE, 94);
         ObjectCreate("MSPSnapShotZUDot3", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPSnapShotZUDot3", CharToStr(108), 11, "Wingdings", C'0x4E,0x39,0x1F');
         ObjectSet("MSPSnapShotZUDot3", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPSnapShotZUDot3", OBJPROP_XDISTANCE, 24);
         ObjectSet("MSPSnapShotZUDot3", OBJPROP_YDISTANCE, 94);
         ObjectCreate("MSPSnapShotZUDot4", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPSnapShotZUDot4", CharToStr(108), 11, "Wingdings", C'0x4E,0x39,0x1F');
         ObjectSet("MSPSnapShotZUDot4", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPSnapShotZUDot4", OBJPROP_XDISTANCE, 12);
         ObjectSet("MSPSnapShotZUDot4", OBJPROP_YDISTANCE, 94);
         ObjectCreate("MSPTrendBoxLI", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPTrendBoxLI", CharToStr(110), 20, "Wingdings", C'0x4E,0x39,0x1F');
         ObjectSet("MSPTrendBoxLI", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPTrendBoxLI", OBJPROP_XDISTANCE, 192);
         ObjectSet("MSPTrendBoxLI", OBJPROP_YDISTANCE, 69);
         ObjectCreate("MSPTrendBoxLITxt", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPTrendBoxLITxt", "I", 9, "Arial Bold", color_180);
         ObjectSet("MSPTrendBoxLITxt", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPTrendBoxLITxt", OBJPROP_XDISTANCE, 200);
         ObjectSet("MSPTrendBoxLITxt", OBJPROP_YDISTANCE, 75);
         ObjectCreate("MSPTrendBoxLU", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPTrendBoxLU", CharToStr(110), 20, "Wingdings", C'0x4E,0x39,0x1F');
         ObjectSet("MSPTrendBoxLU", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPTrendBoxLU", OBJPROP_XDISTANCE, 192);
         ObjectSet("MSPTrendBoxLU", OBJPROP_YDISTANCE, 86);
         ObjectCreate("MSPTrendBoxLUTxt", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPTrendBoxLUTxt", "U", 9, "Arial Bold", color_168);
         ObjectSet("MSPTrendBoxLUTxt", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPTrendBoxLUTxt", OBJPROP_XDISTANCE, 198);
         ObjectSet("MSPTrendBoxLUTxt", OBJPROP_YDISTANCE, 93);
         ObjectCreate("MSPTrendIm", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPTrendIm", " " + ls_172, 8, "Arial Bold", color_180);
         ObjectSet("MSPTrendIm", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPTrendIm", OBJPROP_XDISTANCE, 55);
         ObjectSet("MSPTrendIm", OBJPROP_YDISTANCE, 76);
         ObjectCreate("MSPTrendUn", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("MSPTrendUn", " " + ls_160, 8, "Arial Bold", color_168);
         ObjectSet("MSPTrendUn", OBJPROP_CORNER, Dashboard_Corner);
         ObjectSet("MSPTrendUn", OBJPROP_XDISTANCE, 55);
         ObjectSet("MSPTrendUn", OBJPROP_YDISTANCE, 94);
         if ((!Display_Market_Bias) || !li_52) {
            ObjectDelete("MSPBias");
            ObjectDelete("MSPBiasFrame");
            ObjectDelete("MSPBiasFrameBottom");
            ObjectDelete("MSPTrendFrame");
            ObjectDelete("MSPTrendFrameBrown");
            ObjectDelete("MSPTrendFrameBottom");
            ObjectDelete("MSPBiasBoxL");
            ObjectDelete("MSPBiasBoxLTxt");
            ObjectDelete("MSPTrendBoxINum");
            ObjectDelete("MSPTrendINum");
            ObjectDelete("MSPTrendUNum");
            ObjectDelete("MSPTrendBoxUNum");
            ObjectDelete("MSPTrendBoxLI");
            ObjectDelete("MSPTrendBoxLITxt");
            ObjectDelete("MSPTrendBoxLU");
            ObjectDelete("MSPTrendBoxLUTxt");
            ObjectDelete("MSPBiasTxt");
            ObjectDelete("MSPBiasBox");
            ObjectDelete("MSPTrendTitle");
            ObjectDelete("MSPTrendLine");
            ObjectDelete("MSPTrendIm");
            ObjectDelete("MSPTrendUn");
            ObjectDelete("MSPSnapShotPaint");
            ObjectDelete("MSPSnapShotPaint2");
            ObjectDelete("MSPSnapShotPaint3");
            ObjectDelete("MSPSnapShotPaint4");
            ObjectDelete("MSPSnapShotPaint3L");
            ObjectDelete("MSPSnapShotPaint4L");
            ObjectDelete("MSPSnapShotPaint5");
            ObjectDelete("MSPBiasFrame2");
            ObjectDelete("MSPBiasFrame3");
            ObjectDelete("MSPTrendFrameBottom2");
            ObjectDelete("MSPTrendFrameBottom3");
            ObjectDelete("MSPSnapShotZIDot");
            ObjectDelete("MSPSnapShotZIDot2");
            ObjectDelete("MSPSnapShotZIDot3");
            ObjectDelete("MSPSnapShotZIDot4");
            ObjectDelete("MSPSnapShotZUDot");
            ObjectDelete("MSPSnapShotZUDot2");
            ObjectDelete("MSPSnapShotZUDot3");
            ObjectDelete("MSPSnapShotZUDot4");
            ObjectDelete("MSPZULevel1");
            ObjectDelete("MSPZULevel1Outline");
            ObjectDelete("MSPZULevel2");
            ObjectDelete("MSPZULevel2Outline");
            ObjectDelete("MSPZULevel3");
            ObjectDelete("MSPZULevel3Outline");
            ObjectDelete("MSPZULevel4");
            ObjectDelete("MSPZULevel4Outline");
            ObjectDelete("MSPZILevel1");
            ObjectDelete("MSPZILevel1Outline");
            ObjectDelete("MSPZILevel2");
            ObjectDelete("MSPZILevel2Outline");
            ObjectDelete("MSPZILevel3");
            ObjectDelete("MSPZILevel3Outline");
            ObjectDelete("MSPZILevel4");
            ObjectDelete("MSPZILevel4Outline");
         }
         if (TimeCurrent() > str2time_576) return (0);
         if (TimeCurrent() < str2time_576) {
            li_584 = Denominator(Trading_Style);
            if (Manual) ld_592 = 1;
            else ld_592 = 0;
            lda_588[0] = ld_344;
            lda_588[1] = gi_160;
            lda_588[2] = gi_164;
            lda_588[3] = ld_504;
            lda_588[4] = istochastic_384;
            lda_588[5] = istochastic_392;
            lda_588[6] = istochastic_376;
            lda_588[7] = ld_400;
            lda_588[8] = ld_408;
            lda_588[9] = ld_416;
            lda_588[10] = ld_424;
            lda_588[11] = idemarker_432;
            lda_588[12] = idemarker_440;
            lda_588[13] = idemarker_448;
            lda_588[14] = idemarker_456;
            lda_588[15] = idemarker_464;
            lda_588[16] = idemarker_472;
            lda_588[17] = idemarker_480;
            lda_588[18] = idemarker_488;
            lda_588[19] = idemarker_496;
            lda_588[20] = istochastic_384;
            lda_588[21] = istochastic_392;
            if (Manual) lda_588[22] = ld_252;
            else lda_588[22] = ld_252 / li_584;
            if (Manual) lda_588[23] = ld_260;
            else lda_588[23] = ld_260 / li_584;
            lda_588[24] = ld_512;
            lda_588[25] = gi_200;
            lda_588[26] = gi_204;
            lda_588[27] = ld_552;
            lda_588[28] = gd_136;
            lda_588[29] = gd_144;
            lda_588[30] = istochastic_64;
            lda_588[31] = ld_592;
            if (Filter_Signals) li_600 = TRUE;
            else li_600 = FALSE;
            li_604 = ProcessSignal(lda_588, Serial_Number, str2int_4, li_600);
            if (li_604 == 1) {
               gd_340 = 1;
               gd_348 = 0;
               g_ibuf_376[li_36] = Low[li_36] - Arrow_Distance * Point;
            } else {
               if (li_604 == 0) {
                  gd_340 = 0;
                  gd_348 = 1;
                  g_ibuf_380[li_36] = High[li_36] + Arrow_Distance * Point;
               }
            }
         }
         if (gi_372) {
            li_608 = Trig(gd_356, gd_364, gd_340, gd_348, Serial_Number, str2int_4);
            li_612 = TrigBuy(li_608);
            li_616 = TrigSell(li_608);
            if (li_608 == 0) {
               gd_356 = li_612;
               gd_364 = li_616;
            }
            if (li_608 == 1) {
               gd_364 = li_616;
               gd_356 = li_612;
            }
            if (li_608 == 2 || li_608 == 3) {
               gd_356 = li_612;
               gd_364 = li_616;
            }
         }
      }
      if (!(Alert_On)) return (0);
      f0_0();
      return (0);
   }
   return (0);
}

void f0_0() {
   string str_concat_24;
   string dbl2str_0 = DoubleToStr(g_ibuf_376[1], 2);
   string dbl2str_8 = DoubleToStr(g_ibuf_380[1], 2);
   string ls_16 = "MS PRO";
   if (Period() == PERIOD_M1) str_concat_24 = "M1";
   else {
      if (Period() == PERIOD_M5) str_concat_24 = "M5";
      else {
         if (Period() == PERIOD_M15) str_concat_24 = "M15";
         else {
            if (Period() == PERIOD_M30) str_concat_24 = "M30";
            else {
               if (Period() == PERIOD_H1) str_concat_24 = "H1";
               else {
                  if (Period() == PERIOD_H4) str_concat_24 = "H4";
                  else {
                     if (Period() == PERIOD_D1) str_concat_24 = "D1";
                     else {
                        if (Period() == PERIOD_W1) str_concat_24 = "W1";
                        else {
                           if (Period() == PERIOD_MN1) str_concat_24 = "MN";
                           else str_concat_24 = StringConcatenate("M", Period());
                        }
                     }
                  }
               }
            }
         }
      }
   }
   if (g_ibuf_376[1] != -10000.0 && ProcessBuy(dbl2str_0) && gi_392 != Time[0]) {
      if (Alert_PopUp_On) Alert(ls_16 + ": BUY | " + Symbol() + " " + str_concat_24 + " | ", TimeToStr(TimeLocal(), TIME_SECONDS), " | " + DoubleToStr(Ask, 4));
      PlaySound(ProcessBuySound(Buy_Sound));
      gi_392 = Time[0];
      if (Send_Email) {
         SendMail(ls_16 + " Alert! ", Symbol() + " " + str_concat_24 + " - BUY  signal issued at " + TimeToStr(TimeLocal(), TIME_SECONDS) + " on " + TimeToStr(TimeCurrent(),
            TIME_DATE) + " (Last price: " + DoubleToStr(Ask, 4) + ")" + "\r\n \r\n Delivered via MarketScalper PRO");
      }
   }
   if (g_ibuf_380[1] != -10000.0 && ProcessSell(dbl2str_8) && gi_392 != Time[0]) {
      if (Alert_PopUp_On) Alert(ls_16 + ": SELL | " + Symbol() + " " + str_concat_24 + " | ", TimeToStr(TimeLocal(), TIME_SECONDS), " | " + DoubleToStr(Ask, 4));
      PlaySound(ProcessSellSound(Sell_Sound));
      gi_392 = Time[0];
      if (Send_Email) {
         SendMail(ls_16 + " Alert! ", Symbol() + " " + str_concat_24 + " - SELL signal issued at " + TimeToStr(TimeLocal(), TIME_SECONDS) + " on " + TimeToStr(TimeCurrent(),
            TIME_DATE) + " (Last price: " + DoubleToStr(Ask, 4) + ")" + "\r\n \r\n Delivered via MarketScalper PRO");
      }
   }
}

void deinit() {
   ObjectDelete("MSPTitle");
   ObjectDelete("TitleTextMSP");
   ObjectDelete("BuildTextMSP");
   ObjectDelete("CountBars_Limit_MSP");
   ObjectDelete("counttxt_MSP");
   ObjectDelete("countback_MSP");
   ObjectDelete("MSPMode");
   ObjectDelete("MSPBias");
   ObjectDelete("MSPBiasFrame");
   ObjectDelete("MSPBiasFrameBottom");
   ObjectDelete("MSPTrendFrame");
   ObjectDelete("MSPTrendFrameBrown");
   ObjectDelete("MSPTrendFrameBottom");
   ObjectDelete("MSPBiasBoxL");
   ObjectDelete("MSPBiasBoxLTxt");
   ObjectDelete("MSPTrendBoxINum");
   ObjectDelete("MSPTrendINum");
   ObjectDelete("MSPTrendUNum");
   ObjectDelete("MSPTrendBoxUNum");
   ObjectDelete("MSPTrendBoxLI");
   ObjectDelete("MSPTrendBoxLITxt");
   ObjectDelete("MSPTrendBoxLU");
   ObjectDelete("MSPTrendBoxLUTxt");
   ObjectDelete("MSPBiasTxt");
   ObjectDelete("MSPBiasBox");
   ObjectDelete("MSPTrendTitle");
   ObjectDelete("MSPTrendLine");
   ObjectDelete("MSPTrendIm");
   ObjectDelete("MSPTrendUn");
   ObjectDelete("MSPSnapShotPaint");
   ObjectDelete("MSPSnapShotPaint2");
   ObjectDelete("MSPSnapShotPaint3");
   ObjectDelete("MSPSnapShotPaint4");
   ObjectDelete("MSPSnapShotPaint5");
   ObjectDelete("MSPSnapShotPaint3L");
   ObjectDelete("MSPSnapShotPaint4L");
   ObjectDelete("MSPBiasFrame2");
   ObjectDelete("MSPBiasFrame3");
   ObjectDelete("MSPTrendFrameBottom2");
   ObjectDelete("MSPTrendFrameBottom3");
   ObjectDelete("MSPSnapShotZIDot");
   ObjectDelete("MSPSnapShotZIDot2");
   ObjectDelete("MSPSnapShotZIDot3");
   ObjectDelete("MSPSnapShotZIDot4");
   ObjectDelete("MSPSnapShotZUDot");
   ObjectDelete("MSPSnapShotZUDot2");
   ObjectDelete("MSPSnapShotZUDot3");
   ObjectDelete("MSPSnapShotZUDot4");
   ObjectDelete("MSPZULevel1");
   ObjectDelete("MSPZULevel1Outline");
   ObjectDelete("MSPZULevel2");
   ObjectDelete("MSPZULevel2Outline");
   ObjectDelete("MSPZULevel3");
   ObjectDelete("MSPZULevel3Outline");
   ObjectDelete("MSPZULevel4");
   ObjectDelete("MSPZULevel4Outline");
   ObjectDelete("MSPZILevel1");
   ObjectDelete("MSPZILevel1Outline");
   ObjectDelete("MSPZILevel2");
   ObjectDelete("MSPZILevel2Outline");
   ObjectDelete("MSPZILevel3");
   ObjectDelete("MSPZILevel3Outline");
   ObjectDelete("MSPZILevel4");
   ObjectDelete("MSPZILevel4Outline");
   ObjectDelete("MSPTrendLine");
   ObjectDelete("MSPTrendTitle");
   ObjectDelete("TitleTextm");
   ObjectDelete("LoadedIndm");
   ObjectDelete("LoadedInd2m");
   ObjectDelete("LoadedInd3m");
   ObjectDelete("LoadedInd4m");
   ObjectDelete("LoadedInd5m");
   ObjectDelete("LoadedInd6m");
   ObjectDelete("LoadedInd7m");
   ObjectDelete("LoadedInd8m");
   ObjectDelete("LoadedInd9m");
   ObjectDelete("LoadedInd91m");
   ObjectDelete("LoadedInd10m");
   ObjectDelete("LoadedInd11m");
   ObjectDelete("InvLic");
}
 ///////////////////////////DLL FUNCNTIONS///////////////////////////////////////////////////////////

string TBType(string a0, int a1, int a2) {return ("MarketScalper PRO v5.5"); }
string MSPBuild(string a0, int a1, int a2) {return ("MarketScalper PRO v5.5, build 5600 (Mar 24, 2012)"); }
bool SetMSPMode() {return ; }
int PeriodK(int a0, int a1, int a2, int a3) {
    if (( a0 == 1 ) && ( !a1 )) return (8);
    if (( a0 == 2 ) && ( !a1 )) return (12);
    if (( a0 == 3 ) && ( !a1 )) return (10);
    if ( a1 != 1 ) return (10);
    return (a2);
}
int PeriodD(int a0, int a1, int a2, int a3) {
    if (( a0 == 1 ) && ( !a1 )) return (8); 
    if (( a0 == 2 ) && ( !a1 )) return (6);
    if (( a0 == 3 ) && ( !a1 )) return (1);
    if ( a1 == 1 ) return (a2 / 3);
    return (10);
}
int PeriodS(int a0, int a1, int a2, int a3) {
    if (( a0 == 1 ) && ( !a1 )) return (1);
    if (( a0 == 2 ) && ( !a1 )) return (a0);
    if (( a0 == 3 ) && ( !a1 )) return (1);
    if ( a1 == 1 ) return (1);
    return (10);
}
int UpStoch(int a0, int a1, int a2, int a3) {
    if (( a0 == 1 ) && ( !a1 )) return (28);
    if (( a0 == 2 ) && ( !a1 )) return (30);
    if (( a0 == 3 ) && ( !a1 )) return (40);
    if ( a1 == 1 ) return (a3);
    return (10);
}
int DwStoch(int a0, int a1, int a2, int a3) {
    if (( a0 == 1 ) && ( !a1 )) return (72);
    if (( a0 == 2 ) && ( !a1 )) return (70);
    if (( a0 == 3 ) && ( !a1 )) return (60);
    if ( a1 == 1 ) return (100-a3);
    return (10);
}
int PfStoch(int a0, int a1) {
    if (a0 == 1 || a0 != 2 || a1 ) return (0);
    return (a0);
}
int MaStoch(int a0, int a1) {
    if (( a0 == 1 ) && ( !a1 )) return (0);
    if (( a0 == 2 ) && ( !a1 )) return (3);
    if (( a0 == 3 ) && ( !a1 )) return (0);
    if ( a1 == 1 ) return (2);
    return (10);
}
int MdStoch(int a0, int a1) {
    if (( a0 == 1 ) && ( !a1 )) return (0);
    if (( a0 == 2 ) && ( !a1 )) return (1);
    if (( a0 == 3 ) && ( !a1 )) return (1);
    if ( a1 == 1 ) return (1);
    return (10);
}
int MdStochP(int a0, int a1) {
    if (( a0 == 1 ) && ( !a1 )) return (0);
    if (( a0 == 2 ) && ( !a1 )) return (1);
    if (( a0 == 3 ) && ( !a1 )) return (0);
    if ( a1 == 1 ) return (0);
    return (10);
}   
int ShStoch(int a0, int a1, int a2) {
      int result = a0;
      if ( a0 && a0 != 1 && a0 != 2 && a0 != 3 && a0 != 4 && a0 != 5 && 
      a0 != 6 && a0 != 7 && a0 != 8 && a0 != 9 && a0 != 10 && a0 != 11)
      if (a0 != 12 ) result = 10000;
      else result = 12;
      return (result);
}
int ProcessSignal(double& a0[], string a1, int a2, int a3) {
         if ( 1.0 == (a0[31]) )
    {
    if (a3 !=1) int v4 = 100;
               else v4 = 60;
    if (a3 !=1) int v8 = 100;
               else v8 = 60;
      if ( (a0[5]) < (a0[4]) && (a0[22]) <= (a0[6]) && (a0[22]) > (a0[7]) && (a0[9]) < (a0[8])
        && (a0[22]) > (a0[8]) && (a0[22]) > (a0[9]) && (a0[22]) > (a0[10]) && v8 >= (a0[30]) )
        return (1);
      if ( (a0[5]) > (a0[4]) && (a0[23]) >= (a0[6]) && (a0[23]) < (a0[7]) && (a0[9]) > (a0[8]) 
        && (a0[23]) < (a0[8]) && (a0[23]) < (a0[9]) && (a0[23]) < (a0[10]) )
      {
        double v6 = (100 - v4);
        if ( v6 <= (a0[30]) )
        return (0);
        return (3);
      }
    }
    else
    {
        if (a3 !=1) int v7 = 100;
                    else v7 = 40;
        if (a3 !=1) int v9 = 100;
                    else v9 = 40;
      if ( (a0[22]) <= (a0[7]) && (a0[22]) > (a0[8]) && (a0[22]) > (a0[9]) && (a0[22]) > (a0[10]) && (a0[22]) > (a0[11]) 
        && (a0[22]) > (a0[12]) && (a0[22]) > (a0[13]) && (a0[22]) > (a0[14]) && (a0[22]) > (a0[15]) && (a0[22]) > (a0[16]) 
        && (a0[22]) > (a0[17]) && (a0[22]) > (a0[18]) && (a0[22]) > (a0[19]) && v9 >= (a0[30]) )
        return (1);
      if ( (a0[23]) >= (a0[7]) && (a0[23]) < (a0[8]) && (a0[23]) < (a0[9]) && (a0[23]) < (a0[10]) && (a0[23]) < (a0[11]) 
        && (a0[23]) < (a0[12]) && (a0[23]) < (a0[13]) && (a0[23]) < (a0[14]) && (a0[23]) < (a0[15]) && (a0[23]) < (a0[16]) 
        && (a0[23]) < (a0[17]) && (a0[23]) < (a0[18]) && (a0[23]) < (a0[19]) )
      {
        v6 = (100 - v7);
        if ( v6 <= (a0[30]) )
        return (0);
        return (3);
      }
    }
    return (3);
}
int Trig(int a0, int a1, int a2, int a3, string a4, int a5) {
  int result;
  if ( a2 != 1 || a3 ){ return (0); }
  if ( a3 != 1 || a2 ){ return (1); }
  return (10);
}
int TrigBuy(int a0) {
    return (1);
}
int TrigSell(int a0) {
    return (0);
}  
int Uncompound(bool a0) { return (0);}
string ProcessBuySound(int a0) {
  string result;
  switch ( a0 )
  {
    case 0:result = "buy.wav";break;
    case 1:result = "alert.wav";break;
    case 2:result = "alert2.wav";break;
    case 3:result = "connect.wav";break;
    case 4:result = "disconnect.wav";break;
    case 5:result = "email.wav";break;
    case 6:result = "expert.wav";break;
    case 7:result = "news.wav";break;
    case 8:result = "ok.wav";break;
    case 9:result = "stops.wav";break;
    case 10:result = "tick.wav";break;
    case 11:result = "timeout.wav";break;
    case 12:result = "wait.wav";break;
    default:result = "alert.wav";break;
  }
  return (result);
}
string ProcessSellSound(int a0) {
  string result;
  switch ( a0 )
  {
    case 0:result = "sell.wav";break;
    case 1:result = "alert.wav";break;
    case 2:result = "alert2.wav";break;
    case 3:result = "connect.wav";break;
    case 4:result = "disconnect.wav";break;
    case 5:result = "email.wav";break;
    case 6:result = "expert.wav";break;
    case 7:result = "news.wav";break;
    case 8:result = "ok.wav";break;
    case 9:result = "stops.wav";break;
    case 10:result = "tick.wav";break;
    case 11:result = "timeout.wav";break;
    case 12:result = "wait.wav";break;
    default:result = "alert.wav";break;
  }
  return (result);
}
bool ProcessBuy(string a0) {
     if (StringLen(a0) != StringLen("2147483647.00")) return (1); 
     if (StringLen(a0) == StringLen("2147483647.00")) return (0); 
}
bool ProcessSell(string a0){
     if (StringLen(a0) != StringLen("2147483647.00")) return (1); 
     if (StringLen(a0) == StringLen("2147483647.00")) return (0); 
}
int ScalperTrendLT(double a0, double a1, string a2, int a3) {
    if (a0 >= 0.0 && a1 > 0.0) return (0);
    if (a0 >= 0.0 && a1 < 0.0) return (1);
    if (a0 < 0.0 && a1 < 0.0) return (2);
    if (a0 < 0.0 && a1 > 0.0) return (3);
}     
int ScalperTrendST(double a0, double a1, string a2, int a3) {
    if (a0 >= 0.0 && a1 < 0.0) return (0);
    if (a0 >= 0.0 && a1 > 0.0) return (1);
    if (a0 < 0.0 && a1 > 0.0) return (2);
    if (a0 < 0.0 && a1 < 0.0) return (3);
}
int MarketBias(double a0, string a1, int a2) {
    if (a0 > 99.0 && a0 <= 100.0) return(3);
    if (a0 < 1.0 && a0 >= 0.0) return(6);
    if (a0 <= 68.0 && a0 >= 32.0) return(0);
    if (a0 > 68.0 && a0 <= 75.0) return(1);
    if (a0 > 75.0 && a0 <= 83.0) return(2);
    if (a0 > 83.0) return(3);
    if (a0 < 32.0 && a0 >= 25.0) return(4);
    if (a0 < 25.0 && a0 >= 17.0) return(5);
    if (a0 < 17.0 ) return(6);
}
int CalcBias(double a0, string a1, int a2) {return (a0); }
int Denominator(int a0) {return (100); }
int xDMBK() {return(13); }
int xDMBD() {return(13); }
int xDMBS() {return(10); }
int xDMBMA() {return(0); }
int xDMBPF() {return(0); }
int xDMBMO() {return(1); }
int DIR1() {return(75); }
int DIR2() {return(400); }
int DIR3() {return(125); }
int DIRh1() {return(50); }
int DIRh2() {return(75); }
int DIRh3() {return(400); }
int DIRS1() {return(35); }
int DIRS2() {return(250); }
int DIRS3() {return(75); }
int DIRSh1() {return(5); }
int DIRSh2() {return(75); }
int DIRSh3() {return(400); }
bool BiasStrength() {return ; }



