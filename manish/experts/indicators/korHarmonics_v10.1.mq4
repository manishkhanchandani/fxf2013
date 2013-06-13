

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Black
#property indicator_color2 Black
#property indicator_color3 Black

#import "user32.dll"
   int GetWindowDC(int a0);
   int ReleaseDC(int a0, int a1);
   bool GetWindowRect(int a0, int& a1[]);
   int GetClientRect(int a0, int& a1[]);
#import "gdi32.dll"
   int GetPixel(int a0, int a1, int a2);
#import

string gsa_76[50000][2];
string gsa_80[50000][2];
string gsa_84[50000][2];
string gsa_88[50000][2];
double gda_92[];
double gda_96[];
double gda_100[];
int gi_104;
int gi_108;
int gi_112;
int gi_120 = 0;
double gd_124 = 0.0;
double gd_132 = 0.0;
double gd_140 = 0.0;
double gd_148 = 0.0;
int gi_156 = 50;
string gsa_160[30] = {"ABCD", "I ABCD", "I+T ABCD", "Gartley", "Butterfly", "Crab", "Bat", "Batman", "SHS", "I+SHS", "3Drives", "5-0", "Running Corr", "60_50Corr", "Camel Run", "Camel Break", "Camel Flat", "Camel Unreg", "Sepcial", "One2One"};
int gia_164[30];
extern string separator1 = "************************ Main Params ***";
extern int iextRefreshRate = 4;
extern int iextMaxBars = 5000;
extern int iextHL_MinSwing = 0;
int gi_188 = 150;
extern int iextMaxZZPointsUsed = 12;
extern bool bextShowHistoryPatterns = TRUE;
extern bool bextCheckMultiZigzags = TRUE;
extern double dextHL_MultiZZMinSwingRange = 0.3;
extern int iextHL_MultiZZMinSwingNum = 5;
extern string separator2 = "************************ Calculation deltas ***";
extern double dextMaxDeviation = 0.1;
extern double dextFiboDeviation = 0.03;
extern double dextMaxSHSPriceDeviation = 0.3;
extern double dextMaxSHSTimeDeviation = 0.3;
extern double dextMaxCorrDeviation = 0.1;
extern double dextMaxOne2OneDeviation = 0.1;
extern double dextMaxTriangleDeviation = 0.05;
extern string separator3 = "************************ What to draw ***";
extern bool bextDrawZZLine = FALSE;
extern bool bextDrawZZRelations = FALSE;
extern bool bextDrawZZPoints = FALSE;
extern bool bextDrawProjectionLines = TRUE;
extern bool bextDrawRelationLines = FALSE;
extern bool bextDrawPatternDim = FALSE;
extern bool bextDrawPatternDescr = TRUE;
extern bool bextDrawRectangle = TRUE;
extern int iextDescrFontSize = 14;
extern string separator4 = "******************** Patterns ON/OFF ***";
extern bool bextFibo = FALSE;
extern string FiboLevelsStr = "0.236; 0.382; 0.500; 0.618; 0.707; 0.786; 0.862; 1.00; 1.127; 1.382; 1.414; 1.618; 2.236; 2.618; 3.142; 3.618; 4.236; 5.00;";
double gda_344[30];
int gi_348;
extern bool bextABCD = TRUE;
extern bool bextI_ABCD = TRUE;
extern bool bextIT_ABCD = TRUE;
extern bool bextWXY = TRUE;
extern bool bextGartley = TRUE;
extern bool bextIdealGartleyOnly = TRUE;
extern bool bextButterfly = TRUE;
extern bool bextCrab = TRUE;
extern bool bextIdealCrabOnly = TRUE;
extern bool bextBat = TRUE;
extern bool bextIdealBatOnly = TRUE;
bool gi_396 = FALSE;
extern bool bextBatman = TRUE;
extern bool bextSHS = FALSE;
extern bool bextI_SHS = TRUE;
extern bool bext3Drives = TRUE;
extern bool bext5_0 = TRUE;
bool gi_420 = FALSE;
bool gi_424 = FALSE;
bool gi_428 = FALSE;
extern bool bextEmergingPatterns = FALSE;
extern double dextEmergingPatternPerc = 0.7;
bool gi_444 = FALSE;
bool gi_448 = FALSE;
bool gi_452 = FALSE;
bool gi_456 = FALSE;
bool gi_460 = FALSE;
extern bool bextContractingTriangle = TRUE;
bool gi_468 = FALSE;
bool gi_472 = FALSE;
extern bool bextDiagonalTriangle = TRUE;
bool gi_480 = FALSE;
double gd_484 = 100.0;
double gd_492 = 0.5;
double gd_500 = 100.0;
double gd_508 = 0.5;
double gda_516[8];
double gda_520[8];
int gi_524 = 255;
int gi_528 = 16711680;
int gi_532 = 65535;
int gi_536 = 16777215;
extern string separator5 = "*********************** Alerts ON/OFF ***";
extern bool bextMT4AlertON = FALSE;
extern bool bextMT4EmailON = FALSE;
extern bool bextAlertInvalidatedPatterns = FALSE;
extern string separator6 = "***************** Sound Alarms ON/OFF ***";
extern bool bextSoundAlertON = FALSE;
extern string sextInfoPatternSoundFile = "news.wav";
extern string separator7 = "***************** Save as GIF ON/OFF ***";
extern bool bextScreenshotPatternsON = FALSE;
extern string sextSaveImageDestinationDir = "korHarmonics/";
extern string separator8 = "***************** Signal Monitoring ON/OFF ***";
extern bool bextSigMonitonitoringON = FALSE;
extern string sextSigMonitoringDir = "korSigMon/";
extern string separator9 = "************************ Patterns colors ***";
extern color cextFiboDescColor = RoyalBlue;
extern color cextABCDBullishColor = RoyalBlue;
extern color cextABCDBearishColor = DeepPink;
extern color cextABCDDescColor = RoyalBlue;
extern color cextWXYColor = Pink;
extern color cextGartleyBullishColor = SeaGreen;
extern color cextGartleyBearishColor = C'0xDD,0x00,0x2D';
extern color cextGartleyDescColor = RoyalBlue;
extern color cextButterflyBullishColor = Green;
extern color cextButterflyBearishColor = Red;
extern color cextButterflyDescColor = RoyalBlue;
extern color cextCrabBullishColor = GreenYellow;
extern color cextCrabBearishColor = C'0xEC,0x51,0x78';
extern color cextCrabDescColor = RoyalBlue;
extern color cextBatBullishColor = DarkGreen;
extern color cextBatBearishColor = C'0x80,0x00,0x0A';
extern color cextBatDescColor = RoyalBlue;
extern color cextBatmanBullishColor = SteelBlue;
extern color cextBatmanBearishColor = SteelBlue;
extern color cextBatmanDescColor = RoyalBlue;
extern color cextSHSBullishColor = Pink;
extern color cextSHSBearishColor = Pink;
extern color cextSHSDescColor = Red;
extern color cext3Drives1BullishColor = C'0x00,0x00,0x64';
extern color cext3Drives2BullishColor = C'0x2F,0x00,0x51';
extern color cext3Drives1BearishColor = C'0x7D,0x00,0x00';
extern color cext3Drives2BearishColor = C'0x48,0x00,0x00';
extern color cext3DrivesDescColor = Red;
extern color cext5_0BullishColor = MediumSpringGreen;
extern color cext5_0BearishColor = Red;
extern color cext5_0DescColor = Red;
extern color cextCorrBullishColor = LimeGreen;
extern color cextCorrBearishColor = Salmon;
extern color cextCorrDescColor = Red;
extern color cextTriangleBullishColor = DimGray;
extern color cextTriangleBearishColor = MediumVioletRed;
extern color cextITriangleBullishColor = DarkSlateBlue;
extern color cextITriangleBearishColor = Crimson;
extern color cextNITriangleBullishColor = RoyalBlue;
extern color cextNITriangleBearishColor = Red;
extern color cextTriangleDescColor = LimeGreen;
extern color cextDiagonalColor = LimeGreen;
extern color cextDiagonalDescColor = LimeGreen;
extern color cextEmergingBullishColor = Yellow;
extern color cextEmergingBearishColor = DarkOrange;
extern color cextOne2OneBullishColor = Salmon;
extern color cextOne2OneCorrBullishColor = Red;
extern color cextOne2OneBearishColor = Salmon;
extern color cextOne2OneCorrBearishColor = Red;
extern color cextSOne2OneCorrBullishColor = Brown;
extern color cextSOne2OneCorrBearishColor = Brown;
int gi_832 = 16776960;
int gi_836 = 3937500;
extern color cextRectangleColor = Orange;
extern color cextPatternDimColor = Yellow;
int gi_848 = 3;
int gi_852 = 3;
int gi_856 = 3;
int gi_860 = 5;
int gi_864 = 1;
int gi_868 = 5;
int gi_872 = 3;
int gi_876 = 1;
int gi_880 = 4;
int gi_884 = 3;
extern string separator10 = "************************ ZZ lines colors ***";
extern color cextZZLineColor = DarkViolet;
extern color cextZZRelLineColor = Indigo;
extern string separator11 = "************************ Other Colors ***";
extern color extBackgroundColor = Black;
extern color extTextColor = Black;
extern color cextRelationLine = C'0x15,0x22,0x22';
extern string separator12 = "************************ MinSwing defaults file ***";
extern string sextMinSwingDefaultsFile = "korHarmonics/korHarmonics_MinSwingDefaults.txt";
int gia_940[100];
int gia_944[100];
int gia_948[90];
int gia_952[90];
string gsa_956[90][2] = {"No pattern", "No pattern",
   "ABCD Bullish", "ABCDBu",
   "ABCD Bearish", "ABCDBe",
   "I ABCD Bullish", "IABCDBu",
   "I ABCD Bearish", "IABCDBe",
   "I+T ABCD_Bullish", "ITABCDBu",
   "I+T ABCD_Bearish", "ITABCDBe",
   "SiXTB ABCD_Bullish", "SIXTBABCDBu",
   "SiXTB ABCD_Bearish", "SIXTBABCDBe",
   "Gartley Bullish", "GaBu",
   "Gartley Bearish", "GaBe",
   "Butterfly Bullish", "BuBu",
   "Butterfly Bearish", "BuBe",
   "Crab Bullish", "CrBu",
   "Crab Bearish", "CrBe",
   "Bat Bullish", "BaBu",
   "Bat Bearish", "BaBe",
   "Batman Bullish", "BnBu",
   "Batman Bearish", "BnBe",
   "SHS Bullish", "SHSBu",
   "SHS Bearish", "SHSBe",
   "I+SHS Bullish", "ISHSBu",
   "I+SHS Bearish", "ISHSBe",
   "3Drives Bullish", "3DBu",
   "3Drives Bearish", "3DBe",
   "5-0 Bullish", "50Bu",
   "5-0 Bearish", "50Be",
   "Running Corr Bullish", "RuCoBu",
   "Running Corr Bearish", "RuCoBe",
   "6050 Corr Bullish", "60CoBu",
   "6050 Corr Bearish", "60CoBe",
   "Corr1 Bullish", "Co1Bu",
   "Corr1 Bearish", "Co1Be",
   "Corr2 Bullish", "Co2Bu",
   "Corr2 Bearish", "Co2Be",
   "Corr3 Bullish", "Co3Bu",
   "Corr3 Bearish", "Co3Be",
   "VibrPrice+Time", "ViPT",
   "VibrPrice", "ViP",
   "VibrTime", "ViT",
   "Emerging Gartley Bullish", "EmGaBu",
   "Emerging Gartley Bearish", "EmGaBe",
   "Emerging Butterfly Bullish", "EmBuBu",
   "Emerging Butterfly Bearish", "EmBuBe",
   "Emerging Crab Bullish", "EmCrBu",
   "Emerging Crab Bearish", "EmCrBe",
   "Emerging Bat Bullish", "EmBaBu",
   "Emerging Bat Bearish", "EmBaBe",
   "Camel Run Bullish", "CaRuBu",
   "Camel Run Bearish", "CaRuBe",
   "Camel Break Bullish", "CaBrBu",
   "Camel Break Bearish", "CaBrBe",
   "Camel Flat Bullish", "CaFlBu",
   "Camel Flat Bearish", "CaFlBe",
   "Camel Unreg Bullish", "CaUnBu",
   "Camel Unreg Bearish", "CaUnBe",
   "korSpecial Bullish", "SpBu",
   "korSpecial Bearish", "SpBe",
   "One2One Bullish", "O2OBu",
   "One2One Bearish", "O2OBe",
   "Emerging One2One Bullish", "EmO2OBu",
   "Emerging One2One Bearish", "EmO2OBe",
   "Fibo", "Fibo",
   "Triangle Bullish", "TrBu",
   "Triangle Bearish", "TrBe",
   "DiaTriangle Bullish", "DiaTrBu",
   "DiaTriangle Bearish", "DiaTrBe",
   "EnhOne2One Bullish", "EO2OBu",
   "EnhOne2One Bearish", "EO2OBe",
   "Emerging EnhOne2One Bullish", "EmEO2OBu",
   "Emerging EnhOne2One Bearish", "EmEO2OBe",
   "I+Triangle", "ITrBu",
   "I+Triangle", "ITrBe",
   "NI+Triangle", "NITrBu",
   "NI+Triangle", "NITrBe",
   "WXY Bullish", "WXYBu",
   "WXY Bearish", "WXYBe",
   "S One2One Bullish", "SO2OBu",
   "S One2One Bearish", "SO2OBe",
   "Emerging S One2One Bullish", "EmSO2OBu",
   "Emerging S One2One Bearish", "EmSO2OBe"};
string gsa_960[300][11];
bool gi_964 = FALSE;
int gi_968;
int gt_972 = 0;
int gi_976 = 0;
int gi_980;
bool gi_984 = FALSE;
extern bool bextRelationAngleRotate = FALSE;

int HL_CleanArrays() {
   for (int li_0 = 0; li_0 <= 50000; li_0++) {
      gsa_76[li_0][0] = 0;
      gsa_76[li_0][1] = 0;
      gsa_80[li_0][0] = 0;
      gsa_80[li_0][1] = 0;
      gsa_84[li_0][0] = 0;
      gsa_84[li_0][1] = 0;
   }
   return (0);
}

void HL_Calculate(int ai_0, int ai_4, int ai_8, int ai_12) {
   double ld_40;
   double ld_48;
   int li_56 = -1;
   gi_120 = 0;
   gi_104 = 0;
   gi_108 = 0;
   gi_112 = 0;
   int li_60 = ai_0;
   int li_16 = li_60;
   double ld_24 = Low[li_60];
   int li_20 = li_60;
   double ld_32 = High[li_60];
   DrawPriceArrow(li_16, Time[li_16], ld_24, Lime, "Buy");
   DrawPriceArrow(li_20, Time[li_20], ld_32, Lime, "Sell");
   for (int li_64 = li_60; li_64 >= 0; li_64--) {
      ld_40 = Low[li_64];
      ld_48 = High[li_64];
      if (ld_48 - ld_24 > ai_12 * Point && li_56 == -1 || li_56 == 1) {
         gsa_80[gi_104][0] = TimeToStr(Time[li_16], TIME_DATE|TIME_SECONDS);
         gsa_80[gi_104][1] = DoubleToStr(ld_24, 4);
         gi_104++;
         gsa_84[gi_112][0] = TimeToStr(Time[li_16], TIME_DATE|TIME_SECONDS);
         gsa_84[gi_112][1] = DoubleToStr(ld_24, 4);
         gi_112++;
         ld_24 = ld_40;
         li_16 = li_64;
         ld_32 = ld_48;
         li_20 = li_64;
         if (li_56 == -1) gi_120 = 1;
         li_56 = 0;
      } else {
         if (ld_32 - ld_40 > ai_12 * Point && li_56 == -1 || li_56 == 0) {
            gsa_76[gi_108][0] = TimeToStr(Time[li_20], TIME_DATE|TIME_SECONDS);
            gsa_76[gi_108][1] = DoubleToStr(ld_32, 4);
            gi_108++;
            gsa_84[gi_112][0] = TimeToStr(Time[li_20], TIME_DATE|TIME_SECONDS);
            gsa_84[gi_112][1] = DoubleToStr(ld_32, 4);
            gi_112++;
            ld_32 = ld_48;
            li_20 = li_64;
            ld_24 = ld_40;
            li_16 = li_64;
            if (li_56 == -1) gi_120 = -1;
            li_56 = 1;
         }
      }
      if (ld_40 < ld_24) {
         ld_24 = ld_40;
         li_16 = li_64;
      }
      if (ld_48 > ld_32) {
         ld_32 = ld_48;
         li_20 = li_64;
      }
   }
   if (li_56 == 1) {
      gsa_84[gi_112][0] = TimeToStr(Time[li_16], TIME_DATE|TIME_SECONDS);
      gsa_84[gi_112][1] = DoubleToStr(ld_24, 4);
      gi_112++;
   } else {
      if (li_56 == 0) {
         gsa_84[gi_112][0] = TimeToStr(Time[li_20], TIME_DATE|TIME_SECONDS);
         gsa_84[gi_112][1] = DoubleToStr(ld_32, 4);
         gi_112++;
      }
   }
   if (ai_4 <= gi_112) {
   }
}

void DrawPriceArrow(int ai_0, int ai_4, double ad_8, color ai_16, string as_20) {
   string ls_28 = "ZZ_START_" + "arraw_" + as_20 + ai_0;
   ObjectDelete(ls_28);
   ObjectCreate(ls_28, OBJ_ARROW, 0, ai_4, ad_8);
   ObjectSet(ls_28, OBJPROP_WIDTH, 5);
   if (as_20 == "Buy") ObjectSet(ls_28, OBJPROP_ARROWCODE, SYMBOL_ARROWUP);
   else
      if (as_20 == "Sell") ObjectSet(ls_28, OBJPROP_ARROWCODE, SYMBOL_ARROWDOWN);
   ObjectSet(ls_28, OBJPROP_COLOR, ai_16);
}

void HL_InitZZLine(color ai_0) {
   SetIndexStyle(0, DRAW_SECTION, STYLE_SOLID, 1, ai_0);
   SetIndexLabel(0, "ZZLine");
   SetIndexBuffer(0, gda_92);
   SetIndexEmptyValue(0, 0.0);
}

void HL_InitZZRelLine(color ai_0) {
   SetIndexStyle(1, DRAW_SECTION, STYLE_DOT, 1, ai_0);
   SetIndexStyle(2, DRAW_SECTION, STYLE_DOT, 1, ai_0);
   SetIndexLabel(1, "ZZRelLine1");
   SetIndexLabel(2, "ZZRelLine2");
   SetIndexBuffer(1, gda_96);
   SetIndexBuffer(2, gda_100);
   SetIndexEmptyValue(1, 0.0);
   SetIndexEmptyValue(2, 0.0);
}

void HL_DrawZZline_ZigZag() {
   int li_4;
   ArrayInitialize(gda_92, 0.0);
   for (int li_0 = 0; li_0 < gi_112; li_0++) {
      li_4 = iBarShift(Symbol(), Period(), StrToTime(gsa_84[li_0][0]));
      gda_92[li_4] = StrToDouble(gsa_84[li_0][1]);
   }
}

void HL_DrawZZrelline_ZigZag() {
   int li_4;
   ArrayInitialize(gda_96, 0.0);
   ArrayInitialize(gda_100, 0.0);
   for (int li_0 = 0; li_0 < gi_112; li_0 += 2) {
      li_4 = iBarShift(Symbol(), Period(), StrToTime(gsa_84[li_0][0]));
      gda_96[li_4] = StrToDouble(gsa_84[li_0][1]);
   }
   for (li_0 = 1; li_0 < gi_112; li_0 += 2) {
      li_4 = iBarShift(Symbol(), Period(), StrToTime(gsa_84[li_0][0]));
      gda_100[li_4] = StrToDouble(gsa_84[li_0][1]);
   }
}

void HL_DrawZZRelationsDesc(int ai_0, double ad_4, color ai_12) {
   double ld_16;
   double ld_24;
   double ld_32;
   int li_40;
   int li_44;
   int li_48;
   int li_52;
   int li_56;
   int li_60;
   string ls_64;
   string ls_72;
   int li_80;
   double ld_84;
   string ls_96;
   for (int li_92 = gi_112 - 2 - ai_0; li_92 < gi_112 - 2; li_92++) {
      li_40 = StrToTime(gsa_84[li_92][0]);
      ld_16 = StrToDouble(gsa_84[li_92][1]);
      li_44 = StrToTime(gsa_84[li_92 + 1][0]);
      ld_24 = StrToDouble(gsa_84[li_92 + 1][1]);
      li_48 = StrToTime(gsa_84[li_92 + 2][0]);
      ld_32 = StrToDouble(gsa_84[li_92 + 2][1]);
      li_52 = iBarShift(Symbol(), Period(), li_40);
      li_56 = iBarShift(Symbol(), Period(), li_44);
      li_60 = iBarShift(Symbol(), Period(), li_48);
      li_80 = li_52 - li_60;
      if (ld_24 - ld_16 != 0.0) {
         ld_84 = (ld_24 - ld_32) / (ld_24 - ld_16);
         ls_96 = "";
         if (ld_84 >= (1 - ad_4) / 2.0 && ld_84 <= (ad_4 + 1.0) / 2.0) ls_96 = "38.2%";
         else {
            if (ld_84 >= (1 - ad_4) / 2.0 && ld_84 <= (ad_4 + 1.0) / 2.0) ls_96 = "50.0%";
            else {
               if (ld_84 >= 0.618 * (1 - ad_4) && ld_84 <= 0.618 * (ad_4 + 1.0)) ls_96 = "61.8%";
               else {
                  if (ld_84 >= 0.786 * (1 - ad_4) && ld_84 <= 0.786 * (ad_4 + 1.0)) ls_96 = "78.6%";
                  else {
                     if (ld_84 >= 0.886 * (1 - ad_4) && ld_84 <= 0.886 * (ad_4 + 1.0)) ls_96 = "88.6%";
                     else {
                        if (ld_84 >= 1.0 * (1 - ad_4) && ld_84 <= 1.0 * (ad_4 + 1.0)) ls_96 = "100.0%";
                        else {
                           if (ld_84 >= 1.27 * (1 - ad_4) && ld_84 <= 1.27 * (ad_4 + 1.0)) ls_96 = "127.2%";
                           else {
                              if (ld_84 >= 1.618 * (1 - ad_4) && ld_84 <= 1.618 * (ad_4 + 1.0)) ls_96 = "161.8%";
                              else {
                                 if (ld_84 >= 2.618 * (1 - ad_4) && ld_84 <= 2.618 * (ad_4 + 1.0)) ls_96 = "261.8%";
                                 else
                                    if (ld_84 >= 3.618 * (1 - ad_4) && ld_84 <= 3.618 * (ad_4 + 1.0)) ls_96 = "361.8%";
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
         ls_72 = "HAR_O_" + "pricetime_linedesc_" + TimeToStr(li_40, TIME_DATE|TIME_MINUTES);
         ObjectDelete(ls_72);
         ObjectCreate(ls_72, OBJ_TEXT, 0, li_40 + (li_48 - li_40) / 3, ld_16 + (ld_32 - ld_16) / 3.0, 0, 0);
         if (ls_96 != "") {
            ls_64 = ls_96 + " , " + li_80;
            ObjectSetText(ls_72, ls_64, 9, "Tahoma", ai_12);
         } else {
            ls_64 = DoubleToStr(100.0 * ld_84, 1) + "% , " + li_80;
            ObjectSetText(ls_72, ls_64, 7, "Tahoma", ai_12);
         }
      }
   }
}

void HL_DrawZZPoints(int ai_0) {
   string ls_8;
   string ls_16;
   for (int li_4 = 0; li_4 < gi_112; li_4++) {
      ls_16 = li_4;
      ls_8 = "ZZ_POINT_" + li_4 + "_" + gsa_84[li_4][0];
      ObjectDelete(ls_8);
      ObjectCreate(ls_8, OBJ_TEXT, 0, StrToTime(gsa_84[li_4][0]), StrToDouble(gsa_84[li_4][1]));
      ObjectSetText(ls_8, ls_16, 9, "Tahoma", Gray);
   }
}

string PeriodDesc(int ai_0) {
   switch (ai_0) {
   case 1:
      return ("M1");
   case 5:
      return ("M5");
   case 15:
      return ("M15");
   case 30:
      return ("M30");
   case 60:
      return ("H1");
   case 240:
      return ("H4");
   case 1440:
      return ("D1");
   case 10080:
      return ("W1");
   case 43200:
      return ("MN");
   }
   return ("Unknown Period");
}

int PeriodTimeDelta(int ai_0) {
   switch (ai_0) {
   case 1:
      return (0);
   case 5:
      return (0);
   case 15:
      return (10);
   case 30:
      return (20);
   case 60:
      return (30);
   case 240:
      return (40);
   case 1440:
      return (50);
   case 10080:
      return (60);
   case 43200:
      return (70);
   }
   return (0);
}

int InitInputFile(string as_0) {
   int li_8 = FileOpen(as_0, FILE_CSV|FILE_READ, ';');
   if (li_8 == -1 || FileSize(li_8) == 0) {
      Print("WARNING: File ", as_0, " not found, the last error is ", GetLastError());
      return (-1);
   }
   return (li_8);
}

int CloseFile(int ai_0) {
   if (ai_0 != -1) FileClose(ai_0);
   return (0);
}

void UpdateScale() {
   gd_124 = WindowPriceMax();
   gd_132 = WindowPriceMin();
   gd_140 = gd_124 - gd_132;
   gd_148 = gd_140 / Point;
}

void ShowIndicatorInfo(string as_0, string as_8, string as_16, color ai_24) {
   string ls_28 = as_0 + as_8;
   ObjectDelete(ls_28);
   ObjectCreate(ls_28, OBJ_LABEL, 0, 0, 0);
   ObjectSet(ls_28, OBJPROP_XDISTANCE, 4);
   ObjectSet(ls_28, OBJPROP_YDISTANCE, 12);
   ObjectSet(ls_28, OBJPROP_CORNER, 2);
   ObjectSetText(ls_28,"korHarmonics 6.7.8 - Www.ForexWinners.Net", 9, "Tahoma", ai_24);
}

string DateTimeReformat(string as_0) {
   string ls_8;
   string ls_16 = "";
   as_0 = " " + as_0;
   int li_24 = StringLen(as_0);
   for (int li_28 = 0; li_28 < li_24; li_28++) {
      ls_8 = StringSetChar(ls_8, 0, StringGetChar(as_0, li_28));
      if (ls_8 != ":" && ls_8 != " " && ls_8 != ".") ls_16 = ls_16 + ls_8;
   }
   return (ls_16);
}

int DropObjects(string as_0) {
   string ls_8;
   bool li_28;
   int li_32;
   int li_16 = ObjectsTotal();
   int li_24 = 0;
   for (int li_20 = 0; li_20 < li_16; li_20++) {
      ls_8 = ObjectName(li_24);
      if (StringFind(ls_8, as_0) >= 0) {
         li_28 = ObjectDelete(ls_8);
         if (li_28 == FALSE) {
            li_32 = GetLastError();
            Alert("ERROR,res:::::::::", li_32);
         }
      } else li_24++;
   }
   return (0);
}

int ParseInputString2Doubles(string as_0, double &ada_8[]) {
   int li_16;
   int li_20 = 0;
   int li_12 = 0;
   for (int li_24 = 0; li_24 < StringLen(as_0); li_24++) {
      if (StringGetChar(as_0, li_24) == ';') {
         li_16 = li_24;
         ada_8[li_20] = StrToDouble(StringSubstr(as_0, li_12, li_16 - li_12));
         li_20++;
         if (li_20 == 30) return (li_20);
         li_12 = li_24 + 1;
      }
   }
   return (li_20);
}

int WindowYPixels() {
   int lia_0[4];
   int li_4 = WindowHandle(Symbol(), Period());
   if (li_4 > 0) GetClientRect(li_4, lia_0);
   return (lia_0[3]);
}

void SIGMON_FoundPatterns_Reset() {
   for (int li_0 = 0; li_0 < 30; li_0++) gia_164[li_0] = 99;
}

void SIGMON_FoundPatterns_Set(int ai_0, int ai_4) {
   gia_164[ai_0] = ai_4;
}

void SIGMON_FoundPatterns_Save(string as_0) {
   string ls_12;
   int li_8 = FileOpen(as_0, FILE_CSV|FILE_WRITE, ';');
   if (li_8 >= 1) {
      FileWrite(li_8, "001;" + TimeCurrent());
      for (int li_20 = 0; li_20 < 30; li_20++) {
         ls_12 = li_20 + ";" + gia_164[li_20];
         FileWrite(li_8, ls_12);
      }
      if (li_8 != -1) FileClose(li_8);
   }
}

void SIGMON_FoundPatterns_FileDelete(string as_0) {
   FileDelete(as_0);
}

void init() {
   ShowIndicatorInfo("korHarmonics", " 6.7.8 ", "", extTextColor);
   if (iextHL_MinSwing == 0) {
      LoadMinSwingDefaults(sextMinSwingDefaultsFile);
      iextHL_MinSwing = DefaultMinSwing();
      if (iextHL_MinSwing == -1) {
         Alert("WARNING:", "korHarmonics", ":", Symbol(), ":", PeriodDesc(Period()), ":", "Default iextHL_MinSwing values are not defined for this instrument. Please specify in the txt configuration file. Exiting...");
         return;
      }
   }
   gda_516[0] = gd_484 / 8.0;
   gda_516[1] = gd_484 / 4.0;
   gda_516[2] = gd_484 / 3.0;
   gda_516[3] = gd_484 / 2.0;
   gda_516[4] = gd_484 / 1.5;
   gda_516[5] = 0.75 * gd_484;
   gda_516[6] = 0.875 * gd_484;
   gda_516[7] = 1.0 * gd_484;
   gda_520[0] = gd_500 / 8.0;
   gda_520[1] = gd_500 / 4.0;
   gda_520[2] = gd_500 / 3.0;
   gda_520[3] = gd_500 / 2.0;
   gda_520[4] = gd_500 / 1.5;
   gda_520[5] = 0.75 * gd_500;
   gda_520[6] = 0.875 * gd_500;
   gda_520[7] = 1.0 * gd_500;
   HL_InitZZLine(cextZZLineColor);
   HL_InitZZRelLine(cextZZRelLineColor);
   if (iextMaxBars > 50000) {
      Alert("ERROR:", "korHarmonics", ":", Symbol(), ":", PeriodDesc(Period()), ":", "Specified iextMaxBars number:", iextMaxBars, " in not supported, allowed:[0,", 50000, "] ...changing to max value...");
      iextMaxBars = 50000;
   }
   if (iextMaxZZPointsUsed < 6) {
      Alert("WARNING:", "korHarmonics", ":", Symbol(), ":", PeriodDesc(Period()), ":", "Setting iextMaxZZPointsUsed to minimum =", 6, " required for harmonic analysis.");
      iextMaxZZPointsUsed = 6;
   }
   HAR_FoundPatterns_Init();
   if (bextSigMonitonitoringON == TRUE) {
      SIGMON_FoundPatterns_Reset();
      SIGMON_FoundPatterns_Save(sextSigMonitoringDir + "korHarmonicsSig" + "_" + Symbol() + "_" + PeriodDesc(Period()) + ".csv");
   }
   HL_CleanArrays();
   if (dextHL_MultiZZMinSwingRange < 0.0) {
      dextHL_MultiZZMinSwingRange = 0.0;
      Alert("WARNING:", "korHarmonics", ":", Symbol(), ":", PeriodDesc(Period()), ":", "dextHL_MultiZZMinSwingRange should be in the [0,0.9] range. Will use 0.");
   } else {
      if (dextHL_MultiZZMinSwingRange > 0.9) {
         dextHL_MultiZZMinSwingRange = 0.9;
         Alert("WARNING:", "korHarmonics", ":", Symbol(), ":", PeriodDesc(Period()), ":", "dextHL_MultiZZMinSwingRange should be in the [0,0.9] range. Will use 0.9.");
      }
   }
   gi_980 = PeriodTimeDelta(Period());
   gi_348 = ParseInputString2Doubles(FiboLevelsStr, gda_344);
   gi_984 = TRUE;
}

void deinit() {
   Comment("");
   DropObjects("korHarmonics" + "6.7.8 ");
   DropObjects("ZZ_START_");
   DropObjects("ZZ_POINT_");
   DropObjects("ZZ_LINE_");
   DropObjects("HAR_O_");
   DropObjects("HAR_S_");
   if (bextSigMonitonitoringON == TRUE) SIGMON_FoundPatterns_FileDelete(sextSigMonitoringDir + "korHarmonicsSig" + "_" + Symbol() + "_" + PeriodDesc(Period()) + ".csv");
}

void start() {
   if (Time[0] > gt_972 || TimeCurrent() > gi_976 + iextRefreshRate) {
      gt_972 = Time[0];
      gi_976 = TimeCurrent();
      if (gi_984 == TRUE) {
         if (TimeCurrent() > StrToTime("2020.06.30 00:00")) Alert("INFO:", "korHarmonics", ":", Symbol(), ":", PeriodDesc(Period()), ":", "This version has expired, please contact kor4x@yahoo.com to obtain newer version.");
         else {
            UpdateScale();
            HL_CleanArrays();
            HL_Calculate(iextMaxBars, iextMaxZZPointsUsed, gi_188, iextHL_MinSwing);
            HAR_FoundPatterns_ShowSettings();
            if (iextMaxZZPointsUsed > gi_112 - 2) iextMaxZZPointsUsed = gi_112 - 2;
            HAR_FoundPatterns_Reset();
            DropObjects("ZZ_POINT_");
            DropObjects("ZZ_LINE_");
            DropObjects("HAR_O_");
            if (bextDrawZZLine) HL_DrawZZline_ZigZag();
            if (bextDrawZZPoints) HL_DrawZZPoints(extTextColor);
            if (bextShowHistoryPatterns) {
               if (bextDrawZZRelations) {
                  HL_DrawZZrelline_ZigZag();
                  HL_DrawZZRelationsDesc(gi_112 - 1, dextMaxDeviation, extTextColor);
               }
               if (bextCheckMultiZigzags) {
                  for (int li_0 = iextHL_MinSwing - dextHL_MultiZZMinSwingRange * iextHL_MinSwing; li_0 <= iextHL_MinSwing + dextHL_MultiZZMinSwingRange * iextHL_MinSwing; li_0 += iextHL_MinSwing / iextHL_MultiZZMinSwingNum) {
                     HL_Calculate(iextMaxBars, iextMaxZZPointsUsed, gi_188, li_0);
                     HAR_HarmonicPatternsAnalysis(gi_112);
                  }
               } else HAR_HarmonicPatternsAnalysis(gi_112);
            } else {
               if (bextDrawZZRelations) {
                  HL_DrawZZrelline_ZigZag();
                  HL_DrawZZRelationsDesc(iextMaxZZPointsUsed, dextMaxDeviation, extTextColor);
               }
               if (bextCheckMultiZigzags) {
                  for (li_0 = iextHL_MinSwing - dextHL_MultiZZMinSwingRange * iextHL_MinSwing; li_0 <= iextHL_MinSwing + dextHL_MultiZZMinSwingRange * iextHL_MinSwing; li_0 += iextHL_MinSwing / iextHL_MultiZZMinSwingNum) {
                     HL_Calculate(iextMaxBars, iextMaxZZPointsUsed, gi_188, li_0);
                     HAR_HarmonicPatternsAnalysis(iextMaxZZPointsUsed);
                  }
               } else HAR_HarmonicPatternsAnalysis(iextMaxZZPointsUsed);
            }
            if (HAR_FoundPatterns_IsChanged() == 1) {
               HAR_FoundPatterns_ShowPatterns();
               if (bextMT4AlertON && bextShowHistoryPatterns == FALSE) HAR_FoundPatterns_Alert(0);
               if (bextMT4EmailON && bextShowHistoryPatterns == FALSE) HAR_FoundPatterns_Alert(4);
               if (bextSoundAlertON) PlaySound(sextInfoPatternSoundFile);
               if (bextScreenshotPatternsON == TRUE && bextShowHistoryPatterns == FALSE) ScreenshotNewObjects();
               if (bextScreenshotPatternsON == TRUE && bextShowHistoryPatterns == FALSE) ScreenshotLostObjects();
               if (bextSigMonitonitoringON == TRUE) SIGMON_FoundPatterns_Save(sextSigMonitoringDir + "korHarmonicsSig" + "_" + Symbol() + "_" + PeriodDesc(Period()) + ".csv");
               HAR_FoundPatterns_StoreCurr();
            }
         }
      }
   }
}

void HAR_HarmonicPatternsAnalysis(int ai_0) {
   double ld_4;
   double ld_12;
   double ld_20;
   double ld_28;
   double ld_36;
   double ld_44;
   double ld_52;
   double ld_60;
   double ld_68;
   int li_108;
   int li_112;
   int li_116;
   int li_120;
   int li_124;
   int li_128;
   int li_132;
   int li_136;
   int li_140;
   int li_160;
   int li_168;
   int li_172;
   bool li_176;
   double ld_200;
   double ld_208;
   if (bextFibo) {
      if (bextShowHistoryPatterns == FALSE) li_172 = 5;
      else li_172 = ai_0;
      for (int li_164 = gi_112 - li_172; li_164 <= gi_112 - 3; li_164++) {
         li_112 = StrToTime(gsa_84[li_164][0]);
         ld_12 = StrToDouble(gsa_84[li_164][1]);
         li_116 = StrToTime(gsa_84[li_164 + 1][0]);
         ld_20 = StrToDouble(gsa_84[li_164 + 1][1]);
         li_120 = StrToTime(gsa_84[li_164 + 2][0]);
         ld_28 = StrToDouble(gsa_84[li_164 + 2][1]);
         li_160 = Is_Pattern_Fibo(li_112, ld_12, li_116, ld_20, li_120, ld_28, dextFiboDeviation);
         if (li_160 > 0) Draw_Pattern_Fibo(li_160, li_112, ld_12, li_116, ld_20, li_120, ld_28);
      }
   }
   if (bextABCD || bextI_ABCD || bextIT_ABCD || bextBatman || bextWXY) {
      if (bextShowHistoryPatterns == FALSE) li_168 = 4;
      else li_168 = ai_0;
      for (li_164 = gi_112 - li_168; li_164 <= gi_112 - 4; li_164++) {
         li_112 = StrToTime(gsa_84[li_164][0]);
         ld_12 = StrToDouble(gsa_84[li_164][1]);
         li_116 = StrToTime(gsa_84[li_164 + 1][0]);
         ld_20 = StrToDouble(gsa_84[li_164 + 1][1]);
         li_120 = StrToTime(gsa_84[li_164 + 2][0]);
         ld_28 = StrToDouble(gsa_84[li_164 + 2][1]);
         li_124 = StrToTime(gsa_84[li_164 + 3][0]);
         ld_36 = StrToDouble(gsa_84[li_164 + 3][1]);
         li_160 = Is_Pattern_ABCD(li_112, ld_12, li_116, ld_20, li_120, ld_28, li_124, ld_36, dextMaxDeviation);
         if (li_160 > 0) Draw_Pattern_ABCD(li_160, li_112, ld_12, li_116, ld_20, li_120, ld_28, li_124, ld_36);
         li_160 = Is_Pattern_Batman(li_112, ld_12, li_116, ld_20, li_120, ld_28, li_124, ld_36);
         if (li_160 > 0) Draw_Pattern_Batman(li_160, li_112, ld_12, li_116, ld_20, li_120, ld_28, li_124, ld_36);
         li_160 = Is_Pattern_WXY(li_112, ld_12, li_116, ld_20, li_120, ld_28, li_124, ld_36, dextMaxDeviation);
         if (li_160 > 0) Draw_Pattern_WXY(li_160, li_112, ld_12, li_116, ld_20, li_120, ld_28, li_124, ld_36);
      }
   }
   for (li_164 = gi_112 - ai_0; li_164 <= gi_112 - 5; li_164++) {
      li_112 = StrToTime(gsa_84[li_164][0]);
      ld_12 = StrToDouble(gsa_84[li_164][1]);
      li_116 = StrToTime(gsa_84[li_164 + 1][0]);
      ld_20 = StrToDouble(gsa_84[li_164 + 1][1]);
      li_120 = StrToTime(gsa_84[li_164 + 2][0]);
      ld_28 = StrToDouble(gsa_84[li_164 + 2][1]);
      li_124 = StrToTime(gsa_84[li_164 + 3][0]);
      ld_36 = StrToDouble(gsa_84[li_164 + 3][1]);
      li_128 = StrToTime(gsa_84[li_164 + 4][0]);
      ld_44 = StrToDouble(gsa_84[li_164 + 4][1]);
      if (li_164 != gi_112 - 5) li_176 = FALSE;
      else {
         if (bextEmergingPatterns) li_176 = TRUE;
         else li_176 = FALSE;
      }
      li_160 = Is_MultiDimPattern(li_112, ld_12, li_116, ld_20, li_120, ld_28, li_124, ld_36, li_128, ld_44, dextMaxDeviation, li_176);
      if (li_160 > 0) Draw_MultiDimPattern(li_160, li_112, ld_12, li_116, ld_20, li_120, ld_28, li_124, ld_36, li_128, ld_44, dextMaxDeviation);
   }
   for (li_164 = gi_112 - ai_0; li_164 <= gi_112 - 7; li_164++) {
      li_136 = StrToTime(gsa_84[li_164][0]);
      ld_60 = StrToDouble(gsa_84[li_164][1]);
      li_140 = StrToTime(gsa_84[li_164 + 1][0]);
      ld_68 = StrToDouble(gsa_84[li_164 + 1][1]);
      for (int li_180 = 0; li_180 <= 1; li_180++) {
         if (li_164 + 1 + 1 + li_180 * 2 < gi_112) {
            li_112 = StrToTime(gsa_84[li_164 + 1 + 1 + li_180 * 2][0]);
            ld_12 = StrToDouble(gsa_84[li_164 + 1 + 1 + li_180 * 2][1]);
            if (li_180 == 1) {
               ld_200 = StrToDouble(gsa_84[li_164 + 1 + 1][1]);
               ld_208 = StrToDouble(gsa_84[li_164 + 1 + 2][1]);
               if ((ld_68 < ld_200 && ld_68 < ld_208 && ld_12 > ld_200 && ld_12 > ld_208 && ld_200 > ld_208) || (ld_68 > ld_200 && ld_68 > ld_208 && ld_12 < ld_200 && ld_12 < ld_208 &&
                  ld_200 < ld_208) == FALSE) continue;
            }
            for (int li_184 = 0; li_184 <= 1; li_184++) {
               if (li_164 + 1 + (li_180 * 2 + 1) + 1 + li_184 * 2 < gi_112) {
                  li_116 = StrToTime(gsa_84[li_164 + 1 + (li_180 * 2 + 1) + 1 + li_184 * 2][0]);
                  ld_20 = StrToDouble(gsa_84[li_164 + 1 + (li_180 * 2 + 1) + 1 + li_184 * 2][1]);
                  if (li_184 == 1) {
                     ld_200 = StrToDouble(gsa_84[li_164 + 1 + (li_180 * 2 + 1) + 1][1]);
                     ld_208 = StrToDouble(gsa_84[li_164 + 1 + (li_180 * 2 + 1) + 2][1]);
                     if ((ld_20 < ld_200 && ld_20 < ld_208 && ld_12 > ld_200 && ld_12 > ld_208 && ld_200 < ld_208) || (ld_20 > ld_200 && ld_20 > ld_208 && ld_12 < ld_200 && ld_12 < ld_208 &&
                        ld_200 > ld_208) == FALSE) continue;
                  }
                  for (int li_188 = 0; li_188 <= 1; li_188++) {
                     if (li_164 + 1 + (li_180 * 2 + 1) + (li_184 * 2 + 1) + (li_188 * 2 + 1) < gi_112) {
                        li_120 = StrToTime(gsa_84[li_164 + 1 + (li_180 * 2 + 1) + (li_184 * 2 + 1) + (li_188 * 2 + 1)][0]);
                        ld_28 = StrToDouble(gsa_84[li_164 + 1 + (li_180 * 2 + 1) + (li_184 * 2 + 1) + (li_188 * 2 + 1)][1]);
                        if (li_188 == 1) {
                           ld_200 = StrToDouble(gsa_84[li_164 + 1 + (li_180 * 2 + 1) + (li_184 * 2 + 1) + 1][1]);
                           ld_208 = StrToDouble(gsa_84[li_164 + 1 + (li_180 * 2 + 1) + (li_184 * 2 + 1) + 2][1]);
                           if ((ld_28 < ld_200 && ld_28 < ld_208 && ld_20 > ld_200 && ld_20 > ld_208 && ld_200 < ld_208) || (ld_28 > ld_200 && ld_28 > ld_208 && ld_20 < ld_200 && ld_20 < ld_208 &&
                              ld_200 > ld_208) == FALSE) continue;
                        }
                        for (int li_192 = 0; li_192 <= 1; li_192++) {
                           if (li_164 + 1 + (li_180 * 2 + 1) + (li_184 * 2 + 1) + (li_188 * 2 + 1) + (li_192 * 2 + 1) < gi_112) {
                              li_124 = StrToTime(gsa_84[li_164 + 1 + (li_180 * 2 + 1) + (li_184 * 2 + 1) + (li_188 * 2 + 1) + (li_192 * 2 + 1)][0]);
                              ld_36 = StrToDouble(gsa_84[li_164 + 1 + (li_180 * 2 + 1) + (li_184 * 2 + 1) + (li_188 * 2 + 1) + (li_192 * 2 + 1)][1]);
                              if (li_192 == 1) {
                                 ld_200 = StrToDouble(gsa_84[li_164 + 1 + (li_180 * 2 + 1) + (li_184 * 2 + 1) + (li_188 * 2 + 1) + 1][1]);
                                 ld_208 = StrToDouble(gsa_84[li_164 + 1 + (li_180 * 2 + 1) + (li_184 * 2 + 1) + (li_188 * 2 + 1) + 2][1]);
                                 if ((ld_36 < ld_200 && ld_36 < ld_208 && ld_28 > ld_200 && ld_28 > ld_208 && ld_200 < ld_208) || (ld_36 > ld_200 && ld_36 > ld_208 && ld_28 < ld_200 && ld_28 < ld_208 &&
                                    ld_200 > ld_208) == FALSE) continue;
                              }
                              for (int li_196 = 0; li_196 <= 1; li_196++) {
                                 if (li_164 + 1 + (li_180 * 2 + 1) + (li_184 * 2 + 1) + (li_188 * 2 + 1) + (li_192 * 2 + 1) + (li_196 * 2 + 1) < gi_112) {
                                    li_128 = StrToTime(gsa_84[li_164 + 1 + (li_180 * 2 + 1) + (li_184 * 2 + 1) + (li_188 * 2 + 1) + (li_192 * 2 + 1) + (li_196 * 2 + 1)][0]);
                                    ld_44 = StrToDouble(gsa_84[li_164 + 1 + (li_180 * 2 + 1) + (li_184 * 2 + 1) + (li_188 * 2 + 1) + (li_192 * 2 + 1) + (li_196 * 2 + 1)][1]);
                                    if (li_196 == 1) {
                                       ld_200 = StrToDouble(gsa_84[li_164 + 1 + (li_180 * 2 + 1) + (li_184 * 2 + 1) + (li_188 * 2 + 1) + (li_192 * 2 + 1) + 1][1]);
                                       ld_208 = StrToDouble(gsa_84[li_164 + 1 + (li_180 * 2 + 1) + (li_184 * 2 + 1) + (li_188 * 2 + 1) + (li_192 * 2 + 1) + 2][1]);
                                       if ((ld_44 < ld_200 && ld_44 < ld_208 && ld_36 > ld_200 && ld_36 > ld_208 && ld_200 < ld_208) || (ld_44 > ld_200 && ld_44 > ld_208 && ld_36 < ld_200 && ld_36 < ld_208 &&
                                          ld_200 > ld_208) == FALSE) continue;
                                    }
                                    li_160 = Is_TriangleC1(li_136, ld_60, li_140, ld_68, li_112, ld_12, li_116, ld_20, li_120, ld_28, li_124, ld_36, li_128, ld_44, dextMaxTriangleDeviation);
                                    if (li_160 > 0) Draw_Triangle(li_160, li_112, ld_12, li_116, ld_20, li_120, ld_28, li_124, ld_36, li_128, ld_44);
                                    li_160 = Is_IConTriangle(li_136, ld_60, li_140, ld_68, li_112, ld_12, li_116, ld_20, li_120, ld_28, li_124, ld_36, li_128, ld_44, dextMaxTriangleDeviation);
                                    if (li_160 > 0) Draw_Triangle(li_160, li_112, ld_12, li_116, ld_20, li_120, ld_28, li_124, ld_36, li_128, ld_44);
                                    li_160 = Is_NIConTriangle(li_136, ld_60, li_140, ld_68, li_112, ld_12, li_116, ld_20, li_120, ld_28, li_124, ld_36, li_128, ld_44, dextMaxTriangleDeviation);
                                    if (li_160 > 0) Draw_Triangle(li_160, li_112, ld_12, li_116, ld_20, li_120, ld_28, li_124, ld_36, li_128, ld_44);
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
   }
   for (li_164 = gi_112 - ai_0; li_164 <= gi_112 - 6; li_164++) {
      li_108 = StrToTime(gsa_84[li_164][0]);
      ld_4 = StrToDouble(gsa_84[li_164][1]);
      li_112 = StrToTime(gsa_84[li_164 + 1][0]);
      ld_12 = StrToDouble(gsa_84[li_164 + 1][1]);
      li_116 = StrToTime(gsa_84[li_164 + 2][0]);
      ld_20 = StrToDouble(gsa_84[li_164 + 2][1]);
      li_120 = StrToTime(gsa_84[li_164 + 3][0]);
      ld_28 = StrToDouble(gsa_84[li_164 + 3][1]);
      li_124 = StrToTime(gsa_84[li_164 + 4][0]);
      ld_36 = StrToDouble(gsa_84[li_164 + 4][1]);
      li_128 = StrToTime(gsa_84[li_164 + 5][0]);
      ld_44 = StrToDouble(gsa_84[li_164 + 5][1]);
      li_160 = Is_DiaTriangle(li_108, ld_4, li_112, ld_12, li_116, ld_20, li_120, ld_28, li_124, ld_36, li_128, ld_44, dextMaxTriangleDeviation);
      if (li_160 > 0) Draw_DiaTriangle(li_160, li_108, ld_4, li_112, ld_12, li_116, ld_20, li_120, ld_28, li_124, ld_36, li_128, ld_44);
   }
   for (li_164 = gi_112 - ai_0; li_164 <= gi_112 - 6; li_164++) {
      li_112 = StrToTime(gsa_84[li_164][0]);
      ld_12 = StrToDouble(gsa_84[li_164][1]);
      li_116 = StrToTime(gsa_84[li_164 + 1][0]);
      ld_20 = StrToDouble(gsa_84[li_164 + 1][1]);
      li_120 = StrToTime(gsa_84[li_164 + 2][0]);
      ld_28 = StrToDouble(gsa_84[li_164 + 2][1]);
      li_124 = StrToTime(gsa_84[li_164 + 3][0]);
      ld_36 = StrToDouble(gsa_84[li_164 + 3][1]);
      li_128 = StrToTime(gsa_84[li_164 + 4][0]);
      ld_44 = StrToDouble(gsa_84[li_164 + 4][1]);
      li_132 = StrToTime(gsa_84[li_164 + 5][0]);
      ld_52 = StrToDouble(gsa_84[li_164 + 5][1]);
      li_160 = Is_SHSPattern(li_112, ld_12, li_116, ld_20, li_120, ld_28, li_124, ld_36, li_128, ld_44, li_132, ld_52, dextMaxSHSPriceDeviation, dextMaxSHSTimeDeviation);
      if (li_160 > 0) Draw_Pattern_SHS(li_160, li_112, ld_12, li_116, ld_20, li_120, ld_28, li_124, ld_36, li_128, ld_44, li_132, ld_52);
      li_160 = Is_3DrivesPattern(li_112, ld_12, li_116, ld_20, li_120, ld_28, li_124, ld_36, li_128, ld_44, li_132, ld_52, dextMaxDeviation);
      if (li_160 > 0) Draw_Pattern_3Drives(li_160, li_112, ld_12, li_116, ld_20, li_120, ld_28, li_124, ld_36, li_128, ld_44, li_132, ld_52);
      li_160 = Is_5_0Pattern(ld_12, ld_20, ld_28, ld_36, ld_44, ld_52, dextMaxDeviation);
      if (li_160 > 0) Draw_Pattern_5_0(li_160, li_112, ld_12, li_116, ld_20, li_120, ld_28, li_124, ld_36, li_128, ld_44, li_132, ld_52);
   }
   if (gi_444 || gi_448 || gi_452 || gi_456) {
      for (li_164 = gi_112 - ai_0; li_164 <= gi_112 - 5; li_164++) {
         li_112 = StrToTime(gsa_84[li_164][0]);
         ld_12 = StrToDouble(gsa_84[li_164][1]);
         li_116 = StrToTime(gsa_84[li_164 + 1][0]);
         ld_20 = StrToDouble(gsa_84[li_164 + 1][1]);
         li_120 = StrToTime(gsa_84[li_164 + 2][0]);
         ld_28 = StrToDouble(gsa_84[li_164 + 2][1]);
         li_124 = StrToTime(gsa_84[li_164 + 3][0]);
         ld_36 = StrToDouble(gsa_84[li_164 + 3][1]);
         li_128 = StrToTime(gsa_84[li_164 + 4][0]);
         ld_44 = StrToDouble(gsa_84[li_164 + 4][1]);
         if (li_164 != gi_112 - 5) li_176 = FALSE;
         else {
            if (bextEmergingPatterns) li_176 = TRUE;
            else li_176 = FALSE;
         }
         li_160 = Is_OmarPattern(ld_12, ld_20, ld_28, ld_36, ld_44, dextMaxCorrDeviation);
         if (li_160 > 0) Draw_OmarPattern(li_160, li_112, ld_12, li_116, ld_20, li_120, ld_28, li_124, ld_36, li_128, ld_44);
         li_160 = Is_EOne2OnePattern(ld_12, ld_20, ld_28, ld_36, ld_44, dextMaxOne2OneDeviation, li_176);
         if (li_160 > 0) Draw_EOne2OnePattern(li_160, li_112, ld_12, li_116, ld_20, li_120, ld_28, li_124, ld_36, li_128, ld_44);
      }
   }
   if (gi_480) {
      for (li_164 = gi_112 - ai_0; li_164 <= gi_112 - 2; li_164++) {
         li_112 = StrToTime(gsa_84[li_164][0]);
         ld_12 = StrToDouble(gsa_84[li_164][1]);
         li_116 = StrToTime(gsa_84[li_164 + 1][0]);
         ld_20 = StrToDouble(gsa_84[li_164 + 1][1]);
         li_160 = Is_VibrationPattern(li_112, ld_12, li_116, ld_20, gd_492, gd_508);
         if (li_160 > 0) Draw_VibrationPattern(li_160, li_112, ld_12, li_116, ld_20);
      }
   }
}

int Is_Pattern_ABCD(int ai_0, double ad_4, int ai_12, double ad_16, int ai_24, double ad_28, int ai_36, double ad_40, double ad_48) {
   if (ad_4 - ad_16 == 0.0) return (0);
   double ld_56 = (ad_28 - ad_16) / (ad_4 - ad_16);
   int li_64 = iBarShift(Symbol(), Period(), ai_0) - iBarShift(Symbol(), Period(), ai_24);
   int li_68 = iBarShift(Symbol(), Period(), ai_12) - iBarShift(Symbol(), Period(), ai_36);
   if (bextIT_ABCD && MathAbs(ad_40 - ad_28) >= MathAbs(ad_16 - ad_4) * (1.0 - ad_48) && MathAbs(ad_40 - ad_28) <= MathAbs(ad_16 - ad_4) * (ad_48 + 1.0) && ld_56 >= 0.618 * (1 - ad_48) &&
      ld_56 <= 0.786 * (ad_48 + 1.0) && (li_64 >= li_68 * (1.0 - ad_48) && li_64 <= li_68 * (ad_48 + 1.0))) {
      if (ad_4 > ad_16) {
         HAR_FoundPatterns_Increase(5);
         SIGMON_FoundPatterns_Set(2, 1);
         return (5);
      }
      if (ad_4 < ad_16) {
         HAR_FoundPatterns_Increase(6);
         SIGMON_FoundPatterns_Set(2, -1);
         return (6);
      }
   } else {
      if (bextI_ABCD && MathAbs(ad_40 - ad_28) > MathAbs(ad_16 - ad_4) * (1.0 - ad_48) && MathAbs(ad_40 - ad_28) < MathAbs(ad_16 - ad_4) * (ad_48 + 1.0) && ld_56 >= 0.618 * (1 - ad_48) &&
         ld_56 <= 0.786 * (ad_48 + 1.0)) {
         if (ad_4 > ad_16) {
            HAR_FoundPatterns_Increase(3);
            SIGMON_FoundPatterns_Set(1, 1);
            return (3);
         }
         if (ad_4 >= ad_16) return (0);
         HAR_FoundPatterns_Increase(4);
         SIGMON_FoundPatterns_Set(1, -1);
         return (4);
      }
      if (bextABCD && MathAbs(ad_40 - ad_28) > MathAbs(ad_16 - ad_4) * (1.0 - ad_48) && MathAbs(ad_40 - ad_28) < MathAbs(ad_16 - ad_4) * (ad_48 + 1.0)) {
         if (ad_4 > ad_16) {
            HAR_FoundPatterns_Increase(1);
            SIGMON_FoundPatterns_Set(0, 1);
            return (1);
         }
         if (ad_4 >= ad_16) return (0);
         HAR_FoundPatterns_Increase(2);
         SIGMON_FoundPatterns_Set(0, -1);
         return (2);
      }
      return (0);
   }
   return (0);
}

int Is_Pattern_WXY(int ai_0, double ad_4, int ai_12, double ad_16, int ai_24, double ad_28, int ai_36, double ad_40, double ad_48) {
   if (ad_4 - ad_16 == 0.0 || ad_28 - ad_16 == 0.0) return (0);
   double ld_56 = (ad_28 - ad_16) / (ad_4 - ad_16);
   double ld_64 = (ad_28 - ad_40) / (ad_28 - ad_16);
   int li_72 = iBarShift(Symbol(), Period(), ai_0) - iBarShift(Symbol(), Period(), ai_24);
   int li_76 = iBarShift(Symbol(), Period(), ai_12) - iBarShift(Symbol(), Period(), ai_36);
   if (bextWXY && (ld_56 >= (1 - ad_48) / 2.0 && ld_56 <= (ad_48 + 1.0) / 2.0 && ld_64 >= 1.618 * (1 - ad_48) && ld_64 <= 1.618 * (ad_48 + 1.0)) || (ld_56 >= 0.618 * (1 - ad_48) &&
      ld_56 <= 0.618 * (ad_48 + 1.0) && ld_64 >= 1.618 * (1 - ad_48) && ld_64 <= 1.618 * (ad_48 + 1.0)) || (ld_56 >= (1 - ad_48) / 2.0 && ld_56 <= (ad_48 + 1.0) / 2.0 && ld_64 >= 2.618 * (1 - ad_48) && ld_64 <= 2.618 * (ad_48 +
      1.0)) || (ld_56 >= 0.618 * (1 - ad_48) && ld_56 <= 0.618 * (ad_48 + 1.0) && ld_64 >= 2.618 * (1 - ad_48) && ld_64 <= 2.618 * (ad_48 + 1.0)) && (li_76 >= 1.0 * li_72 * (1.0 - ad_48) &&
      li_76 <= 1.0 * li_72 * (ad_48 + 1.0) || li_76 >= 1.618 * li_72 * (1.0 - ad_48) && li_76 <= 1.618 * li_76 * (ad_48 + 1.0))) {
      if (ad_4 > ad_16) {
         HAR_FoundPatterns_Increase(75);
         SIGMON_FoundPatterns_Set(26, 1);
         return (75);
      }
      if (ad_4 < ad_16) {
         HAR_FoundPatterns_Increase(76);
         SIGMON_FoundPatterns_Set(26, -1);
         return (76);
      }
   } else return (0);
   return (0);
}

int Is_Pattern_Batman(int ai_0, double ad_4, int ai_12, double ad_16, int ai_24, double ad_28, int ai_36, double ad_40) {
   if (ad_4 - ad_16 == 0.0 || ad_28 - ad_16 == 0.0) return (0);
   double ld_48 = (ad_28 - ad_16) / (ad_4 - ad_16);
   double ld_56 = (ad_28 - ad_40) / (ad_28 - ad_16);
   if (bextBatman && ld_48 >= 1.0 && ld_48 <= 1.27 && ld_56 >= 0.73 && ld_56 <= 1.27) {
      if (ad_4 > ad_16 && ad_28 >= ad_4 && ad_28 > ad_16 && ad_40 < ad_4 && ad_40 < ad_28) {
         HAR_FoundPatterns_Increase(17);
         SIGMON_FoundPatterns_Set(7, 1);
         return (17);
      }
      if (!(ad_4 < ad_16 && ad_28 <= ad_4 && ad_28 < ad_16 && ad_40 > ad_4 && ad_40 > ad_28)) return (0);
      HAR_FoundPatterns_Increase(18);
      SIGMON_FoundPatterns_Set(7, -1);
      return (18);
   }
   return (0);
}

int Is_MultiDimPattern(int ai_0, double ad_4, int ai_12, double ad_16, int ai_24, double ad_28, int ai_36, double ad_40, int ai_48, double ad_52, double ad_60, int ai_68) {
   if (ad_16 - ad_4 == 0.0 || ad_40 - ad_28 == 0.0 || ad_16 - ad_28 == 0.0) return (0);
   double ld_72 = (ad_16 - ad_28) / (ad_16 - ad_4);
   double ld_80 = (ad_16 - ad_52) / (ad_16 - ad_4);
   double ld_88 = (ad_40 - ad_52) / (ad_40 - ad_28);
   double ld_96 = (ad_40 - ad_28) / (ad_16 - ad_28);
   double ld_104 = MathAbs(ad_28 - ad_16);
   double ld_112 = MathAbs(ad_52 - ad_40);
   int li_120 = iBarShift(Symbol(), Period(), ai_12) - iBarShift(Symbol(), Period(), ai_48);
   int li_124 = iBarShift(Symbol(), Period(), ai_24) - iBarShift(Symbol(), Period(), ai_48);
   int li_128 = iBarShift(Symbol(), Period(), ai_0) - iBarShift(Symbol(), Period(), ai_24);
   int li_132 = iBarShift(Symbol(), Period(), ai_0) - iBarShift(Symbol(), Period(), ai_12);
   int li_136 = iBarShift(Symbol(), Period(), ai_12) - iBarShift(Symbol(), Period(), ai_24);
   int li_140 = iBarShift(Symbol(), Period(), ai_24) - iBarShift(Symbol(), Period(), ai_36);
   int li_144 = iBarShift(Symbol(), Period(), ai_36) - iBarShift(Symbol(), Period(), ai_48);
   if ((bextGartley && ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 + 1.0) && ld_80 >= 0.786 * (1 - ad_60) && ld_80 <= 0.786 * (ad_60 + 1.0) && ld_88 >= 1.272 * (1 - ad_60) &&
      ld_88 <= 1.618 * (ad_60 + 1.0) && ld_72 >= 0.618 * (1 - ad_60) && ld_72 <= 0.618 * (ad_60 + 1.0) && (ld_104 >= ld_112 * (1 - ad_60) && ld_104 <= ld_112 * (ad_60 +
      1.0)) && (li_120 >= 0.618 * li_132 * (1 - ad_60) && li_120 <= 1.618 * li_132 * (ad_60 + 1.0) && (li_132 > 1 && li_136 > 1 && li_140 > 1 && li_144 > 1))) || (bextGartley &&
      bextIdealGartleyOnly == FALSE && ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 + 1.0) && ld_80 >= 0.577 * (1 - ad_60) && ld_80 <= 0.786 * (ad_60 + 1.0) && ld_88 >= 1.127 * (1 - ad_60) && ld_88 <= 2.2236 * (ad_60 +
      1.0) && ld_72 >= (1 - ad_60) / 2.0 && ld_72 <= 0.618 * (ad_60 + 1.0) && (li_120 >= 0.618 * li_132 * (1 - ad_60) && li_120 <= 1.618 * li_132 * (ad_60 + 1.0) && (li_132 > 1 &&
      li_136 > 1 && li_140 > 1 && li_144 > 1)))) {
      if (ad_16 > ad_40 && ad_40 > ad_28 && ad_28 > ad_4 && ad_52 > ad_4) {
         HAR_FoundPatterns_Increase(9);
         SIGMON_FoundPatterns_Set(3, 1);
         return (9);
      }
      if (ad_16 < ad_40 && ad_40 < ad_28 && ad_28 < ad_4 && ad_52 < ad_4) {
         HAR_FoundPatterns_Increase(10);
         SIGMON_FoundPatterns_Set(3, -1);
         return (10);
      }
   } else {
      if (bextButterfly && ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 + 1.0) && ld_80 >= 1.27 * (1 - ad_60) && ld_80 <= 1.618 * (ad_60 + 1.0) && ld_88 >= 1.618 * (1 - ad_60) &&
         ld_88 <= 2.618 * (ad_60 + 1.0) && ld_72 >= 0.786 * (1 - ad_60) && ld_72 <= 0.786 * (ad_60 + 1.0) && (ld_112 >= 1.27 * ld_104 * (1 - ad_60) && ld_112 <= 1.618 * ld_104 * (ad_60 +
         1.0)) && (li_124 >= 0.618 * li_128 * (1 - ad_60) && li_124 <= 1.618 * li_128 * (ad_60 + 1.0) && (li_132 > 1 && li_136 > 1 && li_140 > 1 && li_144 > 1))) {
         if (ad_16 > ad_40 && ad_40 > ad_28 && ad_28 > ad_4 && ad_52 < ad_4) {
            HAR_FoundPatterns_Increase(11);
            SIGMON_FoundPatterns_Set(4, 1);
            return (11);
         }
         if (ad_16 < ad_40 && ad_40 < ad_28 && ad_28 < ad_4 && ad_52 > ad_4) {
            HAR_FoundPatterns_Increase(12);
            SIGMON_FoundPatterns_Set(4, -1);
            return (12);
         }
      }
      if ((bextCrab && ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 + 1.0) && ld_80 >= 1.618 * (1 - ad_60) && ld_80 <= 1.618 * (ad_60 + 1.0) && ld_88 >= 2.24 * (1 - ad_60) &&
         ld_88 <= 3.618 * (ad_60 + 1.0) && ld_72 >= (1 - ad_60) / 2.0 && ld_72 <= 0.618 * (ad_60 + 1.0) && (li_124 >= 0.618 * li_128 * (1 - ad_60) && li_124 <= 1.618 * li_128 * (ad_60 +
         1.0) && (li_132 > 1 && li_136 > 1 && li_140 > 1 && li_144 > 1))) || (bextCrab && bextIdealCrabOnly == FALSE && ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 +
         1.0) && ld_80 >= 1.618 * (1 - ad_60) && ld_80 <= 1.618 * (ad_60 + 1.0) && ld_88 >= 2.24 * (1 - ad_60) && ld_88 <= 3.618 * (ad_60 + 1.0) && ld_72 >= (1 - ad_60) / 2.0 &&
         ld_72 <= 0.886 * (ad_60 + 1.0) && (li_124 >= 0.618 * li_128 * (1 - ad_60) && li_124 <= 1.618 * li_128 * (ad_60 + 1.0) && (li_132 > 1 && li_136 > 1 && li_140 > 1 &&
         li_144 > 1)))) {
         if (ad_16 > ad_40 && ad_40 > ad_28 && ad_28 > ad_4 && ad_52 < ad_4) {
            HAR_FoundPatterns_Increase(13);
            SIGMON_FoundPatterns_Set(5, 1);
            return (13);
         }
         if (ad_16 < ad_40 && ad_40 < ad_28 && ad_28 < ad_4 && ad_52 > ad_4) {
            HAR_FoundPatterns_Increase(14);
            SIGMON_FoundPatterns_Set(5, -1);
            return (14);
         }
      }
      if ((bextBat && ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 + 1.0) && ld_80 >= 0.886 * (1 - ad_60) && ld_80 <= 0.886 * (ad_60 + 1.0) && ld_88 >= 1.618 * (1 - ad_60) &&
         ld_88 <= 2.618 * (ad_60 + 1.0) && ld_72 >= (1 - ad_60) / 2.0 && ld_72 <= (ad_60 + 1.0) / 2.0 && (ld_112 >= 1.27 * ld_104 * (1 - ad_60) && ld_112 <= 1.618 * ld_104 * (ad_60 +
         1.0)) && (li_120 >= 0.618 * li_132 * (1 - ad_60) && li_120 <= 1.618 * li_132 * (ad_60 + 1.0) && (li_132 > 1 && li_136 > 1 && li_140 > 1 && li_144 > 1))) || (bextBat &&
         bextIdealBatOnly == FALSE && ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 + 1.0) && ld_80 >= 0.886 * (1 - ad_60) && ld_80 <= 0.886 * (ad_60 + 1.0) && ld_88 >= 1.618 * (1 - ad_60) && ld_88 <= 2.618 * (ad_60 +
         1.0) && ld_72 >= (1 - ad_60) / 2.0 && ld_72 <= (ad_60 + 1.0) / 2.0 && (li_120 >= 0.618 * li_132 * (1 - ad_60) && li_120 <= 1.618 * li_132 * (ad_60 + 1.0) && (li_132 > 1 &&
         li_136 > 1 && li_140 > 1 && li_144 > 1)))) {
         if (ad_16 > ad_40 && ad_40 > ad_28 && ad_28 > ad_4 && ad_52 > ad_4) {
            HAR_FoundPatterns_Increase(15);
            SIGMON_FoundPatterns_Set(6, 1);
            return (15);
         }
         if (ad_16 < ad_40 && ad_40 < ad_28 && ad_28 < ad_4 && ad_52 < ad_4) {
            HAR_FoundPatterns_Increase(16);
            SIGMON_FoundPatterns_Set(6, -1);
            return (16);
         }
      }
   }
   if (gi_396 && ld_96 >= 0.618 * (1 - ad_60) && ld_96 <= 0.618 * (ad_60 + 1.0) && ld_80 >= 0.707 * (1 - ad_60) && ld_80 <= 0.707 * (ad_60 + 1.0) && ld_72 >= (1 - ad_60) / 2.0 &&
      ld_72 <= (ad_60 + 1.0) / 2.0 && (ld_104 >= ld_112 * (1 - ad_60) && ld_104 <= ld_112 * (ad_60 + 1.0))) {
      if (ad_16 > ad_40 && ad_40 > ad_28 && ad_28 > ad_4 && ad_52 > ad_4) {
         HAR_FoundPatterns_Increase(56);
         SIGMON_FoundPatterns_Set(18, 1);
         return (56);
      }
      if (ad_16 < ad_40 && ad_40 < ad_28 && ad_28 < ad_4 && ad_52 < ad_4) {
         HAR_FoundPatterns_Increase(57);
         SIGMON_FoundPatterns_Set(18, -1);
         return (57);
      }
   }
   if ((bextIdealGartleyOnly && ai_68 && ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 + 1.0) && ld_72 >= 0.618 * (1 - ad_60) && ld_72 <= 0.618 * (ad_60 + 1.0) &&
      ld_88 >= 1.27 * dextEmergingPatternPerc * (1 - ad_60) && ld_88 <= 1.618 * (ad_60 + 1.0) && (ld_80 >= 0.786 * dextEmergingPatternPerc * (1 - ad_60) && ld_80 < 0.786 * (ad_60 +
      1.0)) && (ld_112 >= dextEmergingPatternPerc * ld_104 * (1 - ad_60) && ld_112 <= ld_104 * (ad_60 + 1.0))) || (bextGartley && ai_68 && bextIdealGartleyOnly == FALSE &&
      ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 + 1.0) && ld_72 >= (1 - ad_60) / 2.0 && ld_72 <= 0.618 * (ad_60 + 1.0) && ld_88 >= 1.27 * dextEmergingPatternPerc * (1 - ad_60) && ld_88 <= 2.2236 * (ad_60 +
      1.0) && (ld_80 >= 0.577 * dextEmergingPatternPerc * (1 - ad_60) && ld_80 < 0.786 * (ad_60 + 1.0)) && (ld_112 >= dextEmergingPatternPerc * ld_104 * (1 - ad_60) && ld_112 <= ld_104 * (ad_60 +
      1.0)))) {
      if (ad_16 > ad_40 && ad_40 > ad_28 && ad_28 > ad_4 && ad_52 > ad_4 && ad_52 <= ad_28) {
         HAR_FoundPatterns_Increase(40);
         SIGMON_FoundPatterns_Set(3, 2);
         return (40);
      }
      if (ad_16 < ad_40 && ad_40 < ad_28 && ad_28 < ad_4 && ad_52 < ad_4 && ad_52 >= ad_28) {
         HAR_FoundPatterns_Increase(41);
         SIGMON_FoundPatterns_Set(3, -2);
         return (41);
      }
   }
   if (bextButterfly && ai_68 && ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 + 1.0) && ld_72 >= 0.786 * (1 - ad_60) && ld_72 <= 0.786 * (ad_60 + 1.0) && ld_88 >= 1.618 * dextEmergingPatternPerc * (1 - ad_60) &&
      ld_88 <= 2.618 * (ad_60 + 1.0) && (ld_80 >= 1.27 * dextEmergingPatternPerc * (1 - ad_60) && ld_80 < 1.618 * (ad_60 + 1.0)) && (ld_112 >= 1.27 * (dextEmergingPatternPerc * ld_104) * (1 - ad_60) &&
      ld_112 <= 1.618 * ld_104 * (ad_60 + 1.0))) {
      if (ad_16 > ad_40 && ad_40 > ad_28 && ad_28 > ad_4 && ad_52 < ad_4) {
         HAR_FoundPatterns_Increase(42);
         SIGMON_FoundPatterns_Set(4, 2);
         return (42);
      }
      if (ad_16 < ad_40 && ad_40 < ad_28 && ad_28 < ad_4 && ad_52 > ad_4) {
         HAR_FoundPatterns_Increase(43);
         SIGMON_FoundPatterns_Set(4, -2);
         return (43);
      }
   }
   if (bextCrab && ai_68 && ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 + 1.0) && ld_72 >= (1 - ad_60) / 2.0 && ld_72 <= 0.618 * (ad_60 + 1.0) && ld_88 >= 2.24 * dextEmergingPatternPerc * (1 - ad_60) &&
      ld_88 <= 3.618 * (ad_60 + 1.0) && (ld_80 >= 1.272 * dextEmergingPatternPerc * (1 - ad_60) && ld_80 < 1.618 * (ad_60 + 1.0))) {
      if (ad_16 > ad_40 && ad_40 > ad_28 && ad_28 > ad_4 && ad_52 < ad_4) {
         HAR_FoundPatterns_Increase(44);
         SIGMON_FoundPatterns_Set(5, 2);
         return (44);
      }
      if (ad_16 < ad_40 && ad_40 < ad_28 && ad_28 < ad_4 && ad_52 > ad_4) {
         HAR_FoundPatterns_Increase(45);
         SIGMON_FoundPatterns_Set(5, -2);
         return (45);
      }
   }
   if (bextBat && ai_68 && ld_96 >= (1 - ad_60) / 2.0 && ld_96 <= 0.886 * (ad_60 + 1.0) && ld_72 >= (1 - ad_60) / 2.0 && ld_72 <= (ad_60 + 1.0) / 2.0 && ld_88 >= 1.618 * dextEmergingPatternPerc * (1 - ad_60) &&
      ld_88 <= 2.618 * (ad_60 + 1.0) && (ld_80 >= 0.886 * dextEmergingPatternPerc * (1 - ad_60) && ld_80 < 0.886 * (ad_60 + 1.0)) && (ld_112 >= 1.27 * (dextEmergingPatternPerc * ld_104) * (1 - ad_60) &&
      ld_112 <= 1.618 * ld_104 * (ad_60 + 1.0))) {
      if (ad_16 > ad_40 && ad_40 > ad_28 && ad_28 > ad_4 && ad_52 > ad_4 && ad_52 < ad_28) {
         HAR_FoundPatterns_Increase(46);
         SIGMON_FoundPatterns_Set(6, 2);
         return (46);
      }
      if (ad_16 < ad_40 && ad_40 < ad_28 && ad_28 < ad_4 && ad_52 < ad_4 && ad_52 > ad_28) {
         HAR_FoundPatterns_Increase(47);
         SIGMON_FoundPatterns_Set(6, -2);
         return (47);
      }
   }
   return (0);
}

int Is_SHSPattern(int ai_0, double ad_4, int ai_12, double ad_16, int ai_24, double ad_28, int ai_36, double ad_40, int ai_48, double ad_52, int ai_60, double ad_64, double ad_72, double ad_80) {
   if (ad_28 - ad_40 == 0.0) return (0);
   double ld_88 = (ad_52 - ad_40) / (ad_28 - ad_40);
   double ld_96 = MathAbs(ad_28 - ad_16);
   double ld_104 = MathAbs(ad_64 - ad_52);
   double ld_112 = MathAbs(ad_40 - ad_28);
   double ld_120 = MathAbs(ad_40 - ad_52);
   int li_128 = iBarShift(Symbol(), Period(), ai_12) - iBarShift(Symbol(), Period(), ai_24);
   int li_132 = iBarShift(Symbol(), Period(), ai_48) - iBarShift(Symbol(), Period(), ai_60);
   int li_136 = iBarShift(Symbol(), Period(), ai_24) - iBarShift(Symbol(), Period(), ai_36);
   int li_140 = iBarShift(Symbol(), Period(), ai_36) - iBarShift(Symbol(), Period(), ai_48);
   if (bextI_SHS) {
      if (ad_4 > ad_16 && ad_4 > ad_28 && ad_16 < ad_28 && ad_16 > ad_40 && ad_28 > ad_40 && ad_40 < ad_52 && ad_40 < ad_64 && ad_52 > ad_64 && ld_96 > ld_104 * (1 - ad_72) &&
         ld_96 < ld_104 * (ad_72 + 1.0) && li_128 > li_132 * (1 - ad_80) && li_128 < li_132 * (ad_80 + 1.0) && ld_112 > ld_120 * (1 - ad_72) && ld_112 < ld_120 * (ad_72 + 1.0) && li_136 > li_140 * (1 - ad_80) && li_136 < li_140 * (ad_80 +
         1.0)) {
         HAR_FoundPatterns_Increase(21);
         SIGMON_FoundPatterns_Set(9, 1);
         return (21);
      }
      if (ad_4 < ad_16 && ad_4 < ad_28 && ad_16 > ad_28 && ad_16 < ad_40 && ad_28 < ad_40 && ad_40 > ad_52 && ad_40 > ad_64 && ad_52 < ad_64 && ld_96 > ld_104 * (1 - ad_72) &&
         ld_96 < ld_104 * (ad_72 + 1.0) && li_128 > li_132 * (1 - ad_80) && li_128 < li_132 * (ad_80 + 1.0) && ld_112 > ld_120 * (1 - ad_72) && ld_112 < ld_120 * (ad_72 + 1.0) && li_136 > li_140 * (1 - ad_80) && li_136 < li_140 * (ad_80 +
         1.0)) {
         HAR_FoundPatterns_Increase(22);
         SIGMON_FoundPatterns_Set(9, -1);
         return (22);
      }
   }
   if (bextSHS) {
      if (ad_4 > ad_16 && ad_4 > ad_28 && ad_16 < ad_28 && ad_16 > ad_40 && ad_28 > ad_40 && ad_40 < ad_52 && ad_40 < ad_64 && ad_52 > ad_64 && ld_96 > ld_104 * (1 - ad_72) &&
         ld_96 < ld_104 * (ad_72 + 1.0) && ld_112 > ld_120 * (1 - ad_72) && ld_112 < ld_120 * (ad_72 + 1.0)) {
         HAR_FoundPatterns_Increase(19);
         SIGMON_FoundPatterns_Set(8, 1);
         return (19);
      }
      if (ad_4 < ad_16 && ad_4 < ad_28 && ad_16 > ad_28 && ad_16 < ad_40 && ad_28 < ad_40 && ad_40 > ad_52 && ad_40 > ad_64 && ad_52 < ad_64 && ld_96 > ld_104 * (1 - ad_72) &&
         ld_96 < ld_104 * (ad_72 + 1.0) && ld_112 > ld_120 * (1 - ad_72) && ld_112 < ld_120 * (ad_72 + 1.0)) {
         HAR_FoundPatterns_Increase(20);
         SIGMON_FoundPatterns_Set(8, -1);
         return (20);
      }
   }
   return (0);
}

int Is_3DrivesPattern(int ai_0, double ad_4, int ai_12, double ad_16, int ai_24, double ad_28, int ai_36, double ad_40, int ai_48, double ad_52, int ai_60, double ad_64, double ad_72) {
   if (ad_16 - ad_28 == 0.0 || ad_40 - ad_52 == 0.0 || ad_16 - ad_4 == 0.0 || ad_40 - ad_28 == 0.0) return (0);
   double ld_80 = MathAbs((ad_40 - ad_28) / (ad_16 - ad_28));
   double ld_88 = MathAbs((ad_64 - ad_52) / (ad_40 - ad_52));
   double ld_96 = MathAbs((ad_16 - ad_28) / (ad_16 - ad_4));
   double ld_104 = MathAbs((ad_40 - ad_52) / (ad_40 - ad_28));
   double ld_112 = MathAbs(ad_28 - ad_16);
   double ld_120 = MathAbs(ad_40 - ad_52);
   int li_128 = iBarShift(Symbol(), Period(), ai_12) - iBarShift(Symbol(), Period(), ai_24);
   int li_132 = iBarShift(Symbol(), Period(), ai_36) - iBarShift(Symbol(), Period(), ai_48);
   int li_136 = iBarShift(Symbol(), Period(), ai_24) - iBarShift(Symbol(), Period(), ai_36);
   int li_140 = iBarShift(Symbol(), Period(), ai_48) - iBarShift(Symbol(), Period(), ai_60);
   if (bext3Drives) {
      if (ad_4 > ad_16 && ad_4 > ad_28 && ad_16 < ad_28 && ad_16 > ad_40 && ad_28 > ad_40 && ad_40 < ad_52 && ad_40 > ad_64 && ad_52 > ad_64 && (ld_80 >= 1.27 * (1 - ad_72) &&
         ld_80 <= 1.27 * (ad_72 + 1.0) && (ld_88 >= 1.27 * (1 - ad_72) && ld_88 <= 1.27 * (ad_72 + 1.0))) || (ld_80 >= 1.618 * (1 - ad_72) && ld_80 <= 1.618 * (ad_72 + 1.0) && (ld_88 >= 1.618 * (1 - ad_72) && ld_88 <= 1.618 * (ad_72 +
         1.0))) && ld_104 >= 0.618 * (1 - ad_72) && ld_104 <= 0.786 * (ad_72 + 1.0) && (li_128 >= 0.786 * li_132 * (1 - ad_72) && li_128 <= 1.272 * li_132 * (ad_72 + 1.0)) &&
         (li_136 >= 0.786 * li_140 * (1 - ad_72) && li_136 <= 1.272 * li_140 * (ad_72 + 1.0))) {
         HAR_FoundPatterns_Increase(23);
         SIGMON_FoundPatterns_Set(10, 1);
         return (23);
      }
      if (ad_4 < ad_16 && ad_4 < ad_28 && ad_16 > ad_28 && ad_16 < ad_40 && ad_28 < ad_40 && ad_40 > ad_52 && ad_40 < ad_64 && ad_52 < ad_64 && (ld_80 >= 1.27 * (1 - ad_72) &&
         ld_80 <= 1.27 * (ad_72 + 1.0) && (ld_88 >= 1.27 * (1 - ad_72) && ld_88 <= 1.27 * (ad_72 + 1.0))) || (ld_80 >= 1.618 * (1 - ad_72) && ld_80 <= 1.618 * (ad_72 + 1.0) && (ld_88 >= 1.618 * (1 - ad_72) && ld_88 <= 1.618 * (ad_72 +
         1.0))) && ld_104 >= 0.618 * (1 - ad_72) && ld_104 <= 0.786 * (ad_72 + 1.0) && (li_128 >= 0.786 * li_132 * (1 - ad_72) && li_128 <= 1.272 * li_132 * (ad_72 + 1.0)) &&
         (li_136 >= 0.786 * li_140 * (1 - ad_72) && li_136 <= 1.272 * li_140 * (ad_72 + 1.0))) {
         HAR_FoundPatterns_Increase(24);
         SIGMON_FoundPatterns_Set(10, -1);
         return (24);
      }
   }
   return (0);
}

int Is_5_0Pattern(double ad_0, double ad_8, double ad_16, double ad_24, double ad_32, double ad_40, double ad_48) {
   if (ad_8 - ad_16 == 0.0 || ad_16 - ad_24 == 0.0 || ad_24 - ad_32 == 0.0) return (0);
   double ld_56 = MathAbs((ad_24 - ad_16) / (ad_8 - ad_16));
   double ld_64 = MathAbs((ad_32 - ad_24) / (ad_16 - ad_24));
   double ld_72 = MathAbs((ad_40 - ad_32) / (ad_24 - ad_32));
   double ld_80 = MathAbs(ad_24 - ad_16);
   double ld_88 = MathAbs(ad_40 - ad_32);
   if (bext5_0) {
      if (ad_0 > ad_8 && ad_16 > ad_8 && ad_16 > ad_24 && ad_32 > ad_16 && ad_32 > ad_24 && ad_32 > ad_40 && (ld_56 >= 1.13 * (1 - ad_48) && ld_56 <= 1.618 * (ad_48 + 1.0)) &&
         (ld_64 >= 1.618 * (1 - ad_48) && ld_64 <= 2.24 * (ad_48 + 1.0)) && (ld_72 >= (1 - ad_48) / 2.0 && ld_72 <= (ad_48 + 1.0) / 2.0) && (ld_80 >= ld_88 * (1 - ad_48) &&
         ld_80 <= ld_88 * (ad_48 + 1.0))) {
         HAR_FoundPatterns_Increase(25);
         SIGMON_FoundPatterns_Set(11, 1);
         return (25);
      }
      if (ad_0 < ad_8 && ad_16 < ad_8 && ad_16 < ad_24 && ad_32 < ad_16 && ad_32 < ad_24 && ad_32 < ad_40 && (ld_56 >= 1.13 * (1 - ad_48) && ld_56 <= 1.618 * (ad_48 + 1.0)) &&
         (ld_64 >= 1.618 * (1 - ad_48) && ld_64 <= 2.24 * (ad_48 + 1.0)) && (ld_72 >= (1 - ad_48) / 2.0 && ld_72 <= (ad_48 + 1.0) / 2.0) && (ld_80 >= ld_88 * (1 - ad_48) &&
         ld_80 <= ld_88 * (ad_48 + 1.0))) {
         HAR_FoundPatterns_Increase(26);
         SIGMON_FoundPatterns_Set(11, -1);
         return (26);
      }
   }
   return (0);
}

int Is_TriangleC1(int ai_0, double ad_4, int ai_12, double ad_16, int ai_24, double ad_28, int ai_36, double ad_40, int ai_48, double ad_52, int ai_60, double ad_64, int ai_72, double ad_76, double ad_84) {
   if (ad_28 == ad_40 || ad_64 == ad_52 || ad_64 == ad_28 || ad_16 == ad_28 || ad_40 == ad_52) return (0);
   double ld_92 = MathAbs((ad_52 - ad_40) / (ad_28 - ad_40));
   double ld_100 = MathAbs((ad_64 - ad_76) / (ad_64 - ad_52));
   double ld_108 = MathAbs((ad_64 - ad_76) / (ad_64 - ad_28));
   double ld_116 = MathAbs((ad_40 - ad_28) / (ad_16 - ad_28));
   double ld_124 = MathAbs((ad_64 - ad_52) / (ad_40 - ad_52));
   double ld_132 = MathAbs(ad_16 - ad_28);
   double ld_140 = MathAbs(ad_40 - ad_28);
   double ld_148 = MathAbs(ad_52 - ad_40);
   double ld_156 = MathAbs(ad_64 - ad_52);
   double ld_164 = MathAbs(ad_76 - ad_64);
   int li_172 = iBarShift(Symbol(), Period(), ai_24) - iBarShift(Symbol(), Period(), ai_36);
   int li_176 = iBarShift(Symbol(), Period(), ai_36) - iBarShift(Symbol(), Period(), ai_48);
   int li_180 = iBarShift(Symbol(), Period(), ai_48) - iBarShift(Symbol(), Period(), ai_60);
   int li_184 = iBarShift(Symbol(), Period(), ai_60) - iBarShift(Symbol(), Period(), ai_72);
   if (bextContractingTriangle) {
      if (ad_4 < ad_16 && ad_4 < ad_28 && ad_16 > ad_28 && ad_28 < ad_40 && ad_40 > ad_52 && ad_52 < ad_64 && ad_64 > ad_76 && (ld_92 >= 0.5 && ld_92 <= 1.15 && ld_124 >= 0.5 &&
         ld_100 >= 0.5 && ld_124 <= 1.0 && ld_108 <= 1.0 && ld_100 <= 1.272 && ld_116 <= 1.382) && li_180 <= 4.03 * li_176 && li_184 <= 4.03 * li_176 && (ld_156 < 0.6 * ld_148 && li_176 < li_172 / 10.0 && li_180 < li_172 / 10.0 && li_184 < li_172 / 10.0) == 0) {
         HAR_FoundPatterns_Increase(63);
         SIGMON_FoundPatterns_Set(22, -1);
         return (63);
      }
      if (ad_4 > ad_16 && ad_4 > ad_28 && ad_16 < ad_28 && ad_28 > ad_40 && ad_40 < ad_52 && ad_52 > ad_64 && ad_64 < ad_76 && (ld_92 >= 0.5 && ld_92 <= 1.15 && ld_124 >= 0.5 &&
         ld_100 >= 0.5 && ld_124 <= 1.0 && ld_108 <= 1.0 && ld_100 <= 1.272 && ld_116 <= 1.382) && li_180 <= 4.03 * li_176 && li_184 <= 4.03 * li_176 && (ld_156 < 0.6 * ld_148 && li_176 < li_172 / 10.0 && li_180 < li_172 / 10.0 && li_184 < li_172 / 10.0) == 0) {
         HAR_FoundPatterns_Increase(64);
         SIGMON_FoundPatterns_Set(22, -1);
         return (64);
      }
   }
   return (0);
}

int Is_IConTriangle(int ai_0, double ad_4, int ai_12, double ad_16, int ai_24, double ad_28, int ai_36, double ad_40, int ai_48, double ad_52, int ai_60, double ad_64, int ai_72, double ad_76, double ad_84) {
   if (ad_28 == ad_40 || ad_64 == ad_52 || ad_64 == ad_28 || ad_16 == ad_28 || ad_40 == ad_52) return (0);
   double ld_92 = MathAbs((ad_52 - ad_40) / (ad_28 - ad_40));
   double ld_100 = MathAbs((ad_64 - ad_76) / (ad_64 - ad_52));
   double ld_108 = MathAbs((ad_64 - ad_76) / (ad_64 - ad_28));
   double ld_116 = MathAbs((ad_40 - ad_28) / (ad_16 - ad_28));
   double ld_124 = MathAbs((ad_64 - ad_52) / (ad_40 - ad_52));
   double ld_132 = MathAbs(ad_40 - ad_28);
   double ld_140 = MathAbs(ad_16 - ad_28);
   double ld_148 = MathAbs(ad_52 - ad_40);
   double ld_156 = MathAbs(ad_64 - ad_52);
   double ld_164 = MathAbs(ad_76 - ad_64);
   int li_172 = iBarShift(Symbol(), Period(), ai_24) - iBarShift(Symbol(), Period(), ai_36);
   int li_176 = iBarShift(Symbol(), Period(), ai_36) - iBarShift(Symbol(), Period(), ai_48);
   int li_180 = iBarShift(Symbol(), Period(), ai_48) - iBarShift(Symbol(), Period(), ai_60);
   int li_184 = iBarShift(Symbol(), Period(), ai_60) - iBarShift(Symbol(), Period(), ai_72);
   if (gi_468) {
      if (ad_4 < ad_16 && ad_16 > ad_28 && ad_28 < ad_40 && ad_40 > ad_52 && ad_52 < ad_64 && ad_64 > ad_76 && (ld_92 >= 0.5 && ld_92 <= 1.382 && ld_124 >= 0.5 && ld_124 <= 1.08 &&
         ld_100 >= 0.25 && ld_100 <= 1.1 && ld_116 <= 1.08 && ld_116 >= 0.49 && ld_140 > ld_148 || ld_140 > ld_156 || ld_140 > ld_164 || ld_132 > ld_148 || ld_132 > ld_156 ||
         ld_132 > ld_164) && li_180 <= 4.03 * li_176 && li_184 <= 4.03 * li_176 && (ld_156 < 0.6 * ld_148 && li_176 < li_172 / 10.0 && li_180 < li_172 / 10.0 && li_184 < li_172 / 10.0) == 0) {
         HAR_FoundPatterns_Increase(71);
         SIGMON_FoundPatterns_Set(24, -1);
         return (71);
      }
      if (ad_4 > ad_16 && ad_16 < ad_28 && ad_28 > ad_40 && ad_40 < ad_52 && ad_52 > ad_64 && ad_64 < ad_76 && (ld_92 >= 0.5 && ld_92 <= 1.382 && ld_124 >= 0.5 && ld_124 <= 1.08 &&
         ld_100 >= 0.25 && ld_100 <= 1.1 && ld_116 <= 1.08 && ld_116 >= 0.49 && ld_140 > ld_148 || ld_140 > ld_156 || ld_140 > ld_164 || ld_132 > ld_148 || ld_132 > ld_156 ||
         ld_132 > ld_164) && li_180 <= 4.03 * li_176 && li_184 <= 4.03 * li_176 && (ld_156 < 0.6 * ld_148 && li_176 < li_172 / 10.0 && li_180 < li_172 / 10.0 && li_184 < li_172 / 10.0) == 0) {
         HAR_FoundPatterns_Increase(72);
         SIGMON_FoundPatterns_Set(24, -1);
         return (72);
      }
   }
   return (0);
}

int Is_NIConTriangle(int ai_0, double ad_4, int ai_12, double ad_16, int ai_24, double ad_28, int ai_36, double ad_40, int ai_48, double ad_52, int ai_60, double ad_64, int ai_72, double ad_76, double ad_84) {
   if (ad_28 == ad_40 || ad_64 == ad_52 || ad_64 == ad_28 || ad_16 == ad_28 || ad_40 == ad_52) return (0);
   double ld_92 = MathAbs((ad_52 - ad_40) / (ad_28 - ad_40));
   double ld_100 = MathAbs((ad_64 - ad_76) / (ad_64 - ad_52));
   double ld_108 = MathAbs((ad_64 - ad_76) / (ad_64 - ad_28));
   double ld_116 = MathAbs((ad_40 - ad_28) / (ad_16 - ad_28));
   double ld_124 = MathAbs((ad_64 - ad_52) / (ad_40 - ad_52));
   double ld_132 = MathAbs(ad_40 - ad_28);
   double ld_140 = MathAbs(ad_16 - ad_28);
   double ld_148 = MathAbs(ad_52 - ad_40);
   double ld_156 = MathAbs(ad_64 - ad_52);
   double ld_164 = MathAbs(ad_76 - ad_64);
   int li_172 = iBarShift(Symbol(), Period(), ai_24) - iBarShift(Symbol(), Period(), ai_36);
   int li_176 = iBarShift(Symbol(), Period(), ai_36) - iBarShift(Symbol(), Period(), ai_48);
   int li_180 = iBarShift(Symbol(), Period(), ai_48) - iBarShift(Symbol(), Period(), ai_60);
   int li_184 = iBarShift(Symbol(), Period(), ai_60) - iBarShift(Symbol(), Period(), ai_72);
   if (gi_472) {
      if (ad_4 < ad_16 && ad_4 < ad_28 && ad_16 > ad_28 && ad_28 < ad_40 && ad_40 > ad_52 && ad_52 < ad_64 && ad_64 > ad_76 && (ld_92 >= 0.5 && ld_92 <= 1.382 && ld_124 >= 0.5 &&
         ld_124 <= 1.08 && ld_100 >= 0.25 && ld_100 <= 1.1 && ld_116 <= 1.08 && ld_116 >= 0.49 && ld_140 > ld_148 || ld_140 > ld_156 || ld_140 > ld_164 || ld_132 > ld_148 ||
         ld_132 > ld_156 || ld_132 > ld_164) && li_180 <= 4.03 * li_176 && li_184 <= 4.03 * li_176 && (ld_156 < 0.6 * ld_148 && li_176 < li_172 / 10.0 && li_180 < li_172 / 10.0 && li_184 < li_172 / 10.0) == 0) {
         HAR_FoundPatterns_Increase(73);
         SIGMON_FoundPatterns_Set(25, -1);
         return (73);
      }
      if (ad_4 > ad_16 && ad_4 > ad_28 && ad_16 < ad_28 && ad_28 > ad_40 && ad_40 < ad_52 && ad_52 > ad_64 && ad_64 < ad_76 && (ld_92 >= 0.5 && ld_92 <= 1.382 && ld_124 >= 0.5 &&
         ld_124 <= 1.08 && ld_100 >= 0.25 && ld_100 <= 1.1 && ld_116 <= 1.08 && ld_116 >= 0.49 && ld_140 > ld_148 || ld_140 > ld_156 || ld_140 > ld_164 || ld_132 > ld_148 ||
         ld_132 > ld_156 || ld_132 > ld_164) && li_180 <= 4.03 * li_176 && li_184 <= 4.03 * li_176 && (ld_156 < 0.6 * ld_148 && li_176 < li_172 / 10.0 && li_180 < li_172 / 10.0 && li_184 < li_172 / 10.0) == 0) {
         HAR_FoundPatterns_Increase(74);
         SIGMON_FoundPatterns_Set(25, -1);
         return (74);
      }
   }
   return (0);
}

int Is_DiaTriangle(int ai_0, double ad_4, int ai_12, double ad_16, int ai_24, double ad_28, int ai_36, double ad_40, int ai_48, double ad_52, int ai_60, double ad_64, double ad_72) {
   double ld_104;
   double ld_112;
   double ld_120;
   int li_80 = -1 * iBarShift(Symbol(), Period(), ai_0);
   int li_84 = -1 * iBarShift(Symbol(), Period(), ai_12);
   int li_88 = -1 * iBarShift(Symbol(), Period(), ai_24);
   int li_92 = -1 * iBarShift(Symbol(), Period(), ai_36);
   int li_96 = -1 * iBarShift(Symbol(), Period(), ai_48);
   int li_100 = -1 * iBarShift(Symbol(), Period(), ai_60);
   if (li_80 - li_88 == 0 || li_88 - li_96 == 0 || li_84 - li_92 == 0 || li_84 - li_100 == 0) return (0);
   if (bextDiagonalTriangle) {
      ld_120 = (ad_28 - ad_52) / (li_88 - li_96);
      ld_104 = (ad_16 - ad_40) / (li_84 - li_92);
      ld_112 = ad_16 - ld_104 * li_84;
      if (ad_4 > ad_16 && ad_4 > ad_28 && ad_4 > ad_40 && ad_16 < ad_28 && ad_16 > ad_40 && ad_28 > ad_40 && ad_28 > ad_52 && ad_40 < ad_52 && ad_40 > ad_64 && ad_52 > ad_64 &&
         ld_104 > ld_120 && ad_64 >= ld_104 * li_100 + ld_112 - 5.0 * Point && ad_64 <= ld_104 * li_100 + ld_112 + 5.0 * Point) {
         HAR_FoundPatterns_Increase(65);
         SIGMON_FoundPatterns_Set(22, -1);
         return (65);
      }
      if (ad_4 < ad_16 && ad_4 < ad_28 && ad_4 < ad_40 && ad_16 > ad_28 && ad_16 < ad_40 && ad_28 < ad_40 && ad_28 < ad_52 && ad_40 > ad_52 && ad_40 < ad_64 && ad_52 < ad_64 &&
         ld_104 < ld_120 && ad_64 >= ld_104 * li_100 + ld_112 - 5.0 * Point && ad_64 <= ld_104 * li_100 + ld_112 + 5.0 * Point) {
         HAR_FoundPatterns_Increase(66);
         SIGMON_FoundPatterns_Set(22, -1);
         return (66);
      }
      ld_104 = (ad_16 - ad_64) / (li_84 - li_100);
      ld_112 = ad_16 - ld_104 * li_84;
      ld_120 = (ad_28 - ad_52) / (li_88 - li_96);
      if (ad_4 > ad_16 && ad_4 > ad_28 && ad_4 > ad_40 && ad_16 < ad_28 && ad_16 > ad_40 && ad_28 > ad_40 && ad_28 > ad_52 && ad_40 < ad_52 && ad_40 > ad_64 && ad_52 > ad_64 &&
         ld_104 > ld_120 && ad_40 >= ld_104 * li_92 + ld_112 - 5.0 * Point && ad_40 <= ld_104 * li_92 + ld_112 + 5.0 * Point) {
         HAR_FoundPatterns_Increase(65);
         SIGMON_FoundPatterns_Set(22, -1);
         return (65);
      }
      if (ad_4 < ad_16 && ad_4 < ad_28 && ad_4 < ad_40 && ad_16 > ad_28 && ad_16 < ad_40 && ad_28 < ad_40 && ad_28 < ad_52 && ad_40 > ad_52 && ad_40 < ad_64 && ad_52 < ad_64 &&
         ld_104 < ld_120 && ad_40 >= ld_104 * li_92 + ld_112 - 5.0 * Point && ad_40 <= ld_104 * li_92 + ld_112 + 5.0 * Point) {
         HAR_FoundPatterns_Increase(66);
         SIGMON_FoundPatterns_Set(22, -1);
         return (66);
      }
   }
   return (0);
}

int Is_OmarPattern(double ad_0, double ad_8, double ad_16, double ad_24, double ad_32, double ad_40) {
   double ld_48 = MathAbs(ad_16 - ad_8);
   double ld_56 = MathAbs(ad_32 - ad_24);
   double ld_64 = MathAbs(ad_24 - ad_16);
   if (gi_444) {
      if (ad_0 < ad_8 && ad_0 < ad_16 && ad_0 < ad_24 && ad_0 < ad_32 && ad_8 > ad_16 && ad_8 < ad_24 && ad_16 < ad_24 && ad_16 < ad_32 && ad_24 > ad_32 && ad_32 < ad_8 &&
         (ld_56 >= 0.707 * ld_48 * (1 - ad_40) && ld_56 <= 0.707 * ld_48 * (ad_40 + 1.0)) || (ld_56 >= 0.786 * ld_48 * (1 - ad_40) && ld_56 <= 0.786 * ld_48 * (ad_40 + 1.0)) ||
         (ld_56 >= 0.886 * ld_48 * (1 - ad_40) && ld_56 <= 0.886 * ld_48 * (ad_40 + 1.0)) || (ld_56 >= 1.0 * ld_48 * (1 - ad_40) && ld_56 <= 1.0 * ld_48 * (ad_40 + 1.0)) && (ld_56 >= 0.707 * ld_64 * (1 - ad_40) && ld_56 <= 0.707 * ld_64 * (ad_40 +
         1.0)) || (ld_56 >= 0.786 * ld_64 * (1 - ad_40) && ld_56 <= 0.786 * ld_64 * (ad_40 + 1.0)) || (ld_56 >= 0.886 * ld_64 * (1 - ad_40) && ld_56 <= 0.886 * ld_64 * (ad_40 + 1.0)) &&
         ld_64 <= 1.618 * ld_48 * (ad_40 + 1.0)) {
         HAR_FoundPatterns_Increase(48);
         SIGMON_FoundPatterns_Set(14, 1);
         return (48);
      }
      if (ad_0 > ad_8 && ad_0 > ad_16 && ad_0 > ad_24 && ad_0 > ad_32 && ad_8 < ad_16 && ad_8 > ad_24 && ad_16 > ad_24 && ad_16 > ad_32 && ad_24 < ad_32 && ad_32 > ad_8 &&
         (ld_56 >= 0.707 * ld_48 * (1 - ad_40) && ld_56 <= 0.707 * ld_48 * (ad_40 + 1.0)) || (ld_56 >= 0.786 * ld_48 * (1 - ad_40) && ld_56 <= 0.786 * ld_48 * (ad_40 + 1.0)) ||
         (ld_56 >= 0.886 * ld_48 * (1 - ad_40) && ld_56 <= 0.886 * ld_48 * (ad_40 + 1.0)) || (ld_56 >= 1.0 * ld_48 * (1 - ad_40) && ld_56 <= 1.0 * ld_48 * (ad_40 + 1.0)) && (ld_56 >= 0.707 * ld_64 * (1 - ad_40) && ld_56 <= 0.707 * ld_64 * (ad_40 +
         1.0)) || (ld_56 >= 0.786 * ld_64 * (1 - ad_40) && ld_56 <= 0.786 * ld_64 * (ad_40 + 1.0)) || (ld_56 >= 0.886 * ld_64 * (1 - ad_40) && ld_56 <= 0.886 * ld_64 * (ad_40 + 1.0)) &&
         ld_64 <= 1.618 * ld_48 * (ad_40 + 1.0)) {
         HAR_FoundPatterns_Increase(49);
         SIGMON_FoundPatterns_Set(14, -1);
         return (49);
      }
      if (ad_0 < ad_8 && ad_0 < ad_16 && ad_0 < ad_24 && ad_0 < ad_32 && ad_8 > ad_16 && ad_8 > ad_24 && ad_16 < ad_24 && ad_16 > ad_32 && ad_24 > ad_32 && ad_32 < ad_8 &&
         (ld_64 >= 0.618 * ld_48 * (1 - ad_40) && ld_64 <= 0.618 * ld_48 * (ad_40 + 1.0)) || (ld_64 >= 0.707 * ld_48 * (1 - ad_40) && ld_64 <= 0.707 * ld_48 * (ad_40 + 1.0)) ||
         (ld_64 >= 0.786 * ld_48 * (1 - ad_40) && ld_64 <= 0.786 * ld_48 * (ad_40 + 1.0)) && (ld_56 >= 1.0 * ld_48 * (1 - ad_40) && ld_56 <= 1.0 * ld_48 * (ad_40 + 1.0)) ||
         (ld_56 >= 1.272 * ld_48 * (1 - ad_40) && ld_56 <= 1.272 * ld_48 * (ad_40 + 1.0)) || (ld_56 >= 1.414 * ld_48 * (1 - ad_40) && ld_56 <= 1.414 * ld_48 * (ad_40 + 1.0)) && (ld_56 >= 1.272 * ld_64 * (1 - ad_40) && ld_56 <= 1.272 * ld_64 * (ad_40 +
         1.0)) || (ld_56 >= 1.414 * ld_64 * (1 - ad_40) && ld_56 <= 1.414 * ld_64 * (ad_40 + 1.0)) || (ld_56 >= 1.618 * ld_64 * (1 - ad_40) && ld_56 <= 1.618 * ld_64 * (ad_40 + 1.0))) {
         HAR_FoundPatterns_Increase(50);
         SIGMON_FoundPatterns_Set(15, 1);
         return (50);
      }
      if (ad_0 > ad_8 && ad_0 > ad_16 && ad_0 > ad_24 && ad_0 > ad_32 && ad_8 < ad_16 && ad_8 < ad_24 && ad_16 > ad_24 && ad_16 < ad_32 && ad_24 < ad_32 && ad_32 > ad_8 &&
         (ld_64 >= 0.618 * ld_48 * (1 - ad_40) && ld_64 <= 0.618 * ld_48 * (ad_40 + 1.0)) || (ld_64 >= 0.707 * ld_48 * (1 - ad_40) && ld_64 <= 0.707 * ld_48 * (ad_40 + 1.0)) ||
         (ld_64 >= 0.786 * ld_48 * (1 - ad_40) && ld_64 <= 0.786 * ld_48 * (ad_40 + 1.0)) && (ld_56 >= 1.0 * ld_48 * (1 - ad_40) && ld_56 <= 1.0 * ld_48 * (ad_40 + 1.0)) ||
         (ld_56 >= 1.272 * ld_48 * (1 - ad_40) && ld_56 <= 1.272 * ld_48 * (ad_40 + 1.0)) || (ld_56 >= 1.414 * ld_48 * (1 - ad_40) && ld_56 <= 1.414 * ld_48 * (ad_40 + 1.0)) && (ld_56 >= 1.272 * ld_64 * (1 - ad_40) && ld_56 <= 1.272 * ld_64 * (ad_40 +
         1.0)) || (ld_56 >= 1.414 * ld_64 * (1 - ad_40) && ld_56 <= 1.414 * ld_64 * (ad_40 + 1.0)) || (ld_56 >= 1.618 * ld_64 * (1 - ad_40) && ld_56 <= 1.618 * ld_64 * (ad_40 + 1.0))) {
         HAR_FoundPatterns_Increase(51);
         SIGMON_FoundPatterns_Set(15, -1);
         return (51);
      }
      if (ad_0 < ad_8 && ad_0 < ad_16 && ad_0 < ad_24 && ad_0 < ad_32 && ad_8 > ad_16 && ad_8 > ad_24 && ad_16 < ad_24 && ad_16 < ad_32 && ad_24 > ad_32 && ad_32 < ad_8 &&
         (ld_64 >= 0.707 * ld_48 * (1 - ad_40) && ld_64 <= 0.707 * ld_48 * (ad_40 + 1.0)) || (ld_64 >= 0.786 * ld_48 * (1 - ad_40) && ld_64 <= 0.786 * ld_48 * (ad_40 + 1.0)) ||
         (ld_64 >= 0.886 * ld_48 * (1 - ad_40) && ld_64 <= 0.886 * ld_48 * (ad_40 + 1.0)) || (ld_64 >= 1.0 * ld_48 * (1 - ad_40) && ld_64 <= 1.0 * ld_48 * (ad_40 + 1.0)) && (ld_56 >= ld_48 / 2.0 * (1 - ad_40) && ld_56 <= ld_48 / 2.0 * (ad_40 +
         1.0)) || (ld_56 >= 0.618 * ld_48 * (1 - ad_40) && ld_56 <= 0.618 * ld_48 * (ad_40 + 1.0)) && (ld_56 >= 0.707 * ld_64 * (1 - ad_40) && ld_56 <= 0.707 * ld_64 * (ad_40 + 1.0)) ||
         (ld_56 >= 0.786 * ld_64 * (1 - ad_40) && ld_56 <= 0.786 * ld_64 * (ad_40 + 1.0)) || (ld_56 >= 0.886 * ld_64 * (1 - ad_40) && ld_56 <= 0.886 * ld_64 * (ad_40 + 1.0))) {
         HAR_FoundPatterns_Increase(52);
         SIGMON_FoundPatterns_Set(16, 1);
         return (52);
      }
      if (ad_0 > ad_8 && ad_0 > ad_16 && ad_0 > ad_24 && ad_0 > ad_32 && ad_8 < ad_16 && ad_8 < ad_24 && ad_16 > ad_24 && ad_16 > ad_32 && ad_24 < ad_32 && ad_32 > ad_8 &&
         (ld_64 >= 0.707 * ld_48 * (1 - ad_40) && ld_64 <= 0.707 * ld_48 * (ad_40 + 1.0)) || (ld_64 >= 0.786 * ld_48 * (1 - ad_40) && ld_64 <= 0.786 * ld_48 * (ad_40 + 1.0)) ||
         (ld_64 >= 0.886 * ld_48 * (1 - ad_40) && ld_64 <= 0.886 * ld_48 * (ad_40 + 1.0)) || (ld_64 >= 1.0 * ld_48 * (1 - ad_40) && ld_64 <= 1.0 * ld_48 * (ad_40 + 1.0)) && (ld_56 >= ld_48 / 2.0 * (1 - ad_40) && ld_56 <= ld_48 / 2.0 * (ad_40 +
         1.0)) || (ld_56 >= 0.618 * ld_48 * (1 - ad_40) && ld_56 <= 0.618 * ld_48 * (ad_40 + 1.0)) && (ld_56 >= 0.707 * ld_64 * (1 - ad_40) && ld_56 <= 0.707 * ld_64 * (ad_40 + 1.0)) ||
         (ld_56 >= 0.786 * ld_64 * (1 - ad_40) && ld_56 <= 0.786 * ld_64 * (ad_40 + 1.0)) || (ld_56 >= 0.886 * ld_64 * (1 - ad_40) && ld_56 <= 0.886 * ld_64 * (ad_40 + 1.0))) {
         HAR_FoundPatterns_Increase(53);
         SIGMON_FoundPatterns_Set(16, -1);
         return (53);
      }
      if (ad_0 < ad_8 && ad_0 < ad_16 && ad_0 < ad_24 && ad_0 < ad_32 && ad_8 > ad_16 && ad_8 < ad_24 && ad_16 < ad_24 && ad_16 > ad_32 && ad_24 > ad_32 && ad_32 < ad_8 &&
         (ld_56 >= 1.272 * ld_48 * (1 - ad_40) && ld_56 <= 1.272 * ld_48 * (ad_40 + 1.0)) || (ld_56 >= 1.414 * ld_48 * (1 - ad_40) && ld_56 <= 1.414 * ld_48 * (ad_40 + 1.0)) ||
         (ld_56 >= 1.618 * ld_48 * (1 - ad_40) && ld_64 <= 1.618 * ld_48 * (ad_40 + 1.0)) && (ld_56 >= 1.272 * ld_64 * (1 - ad_40) && ld_56 <= 1.272 * ld_64 * (ad_40 + 1.0)) ||
         (ld_56 >= 1.414 * ld_64 * (1 - ad_40) && ld_56 <= 1.414 * ld_64 * (ad_40 + 1.0)) && ld_64 <= 1.618 * ld_48 * (ad_40 + 1.0)) {
         HAR_FoundPatterns_Increase(54);
         SIGMON_FoundPatterns_Set(17, 1);
         return (54);
      }
      if (ad_0 > ad_8 && ad_0 > ad_16 && ad_0 > ad_24 && ad_0 > ad_32 && ad_8 < ad_16 && ad_8 > ad_24 && ad_16 > ad_24 && ad_16 < ad_32 && ad_24 < ad_32 && ad_32 > ad_8 &&
         (ld_56 >= 1.272 * ld_48 * (1 - ad_40) && ld_56 <= 1.272 * ld_48 * (ad_40 + 1.0)) || (ld_56 >= 1.414 * ld_48 * (1 - ad_40) && ld_56 <= 1.414 * ld_48 * (ad_40 + 1.0)) ||
         (ld_56 >= 1.618 * ld_48 * (1 - ad_40) && ld_64 <= 1.618 * ld_48 * (ad_40 + 1.0)) && (ld_56 >= 1.272 * ld_64 * (1 - ad_40) && ld_56 <= 1.272 * ld_64 * (ad_40 + 1.0)) ||
         (ld_56 >= 1.414 * ld_64 * (1 - ad_40) && ld_56 <= 1.414 * ld_64 * (ad_40 + 1.0)) && ld_64 <= 1.618 * ld_48 * (ad_40 + 1.0)) {
         HAR_FoundPatterns_Increase(55);
         SIGMON_FoundPatterns_Set(17, -1);
         return (55);
      }
   }
   return (0);
}

int Is_VibrationPattern(int ai_0, double ad_4, int ai_12, double ad_16, double ad_24, double ad_32) {
   bool li_60;
   bool li_64;
   double ld_68;
   double ld_76;
   double ld_48 = 10000.0 * MathAbs(ad_4 - ad_16);
   int li_56 = iBarShift(Symbol(), Period(), ai_0) - iBarShift(Symbol(), Period(), ai_12);
   for (int li_40 = 0; li_40 <= 7; li_40++) {
      for (int li_44 = 0; li_44 <= 7; li_44++) {
         li_60 = FALSE;
         li_64 = FALSE;
         ld_68 = gda_516[li_40];
         ld_76 = gda_520[li_44];
         if (ld_48 > ld_68 * (1 - ad_24) && ld_48 < ld_68 * (ad_24 + 1.0)) li_60 = TRUE;
         if (li_56 > ld_76 * (1 - ad_32) && li_56 < ld_76 * (ad_32 + 1.0)) li_64 = TRUE;
         if (li_60 && li_64) {
            HAR_FoundPatterns_Increase(37);
            return (37);
         }
      }
   }
   for (li_40 = 0; li_40 <= 7; li_40++) {
      for (li_44 = 0; li_44 <= 7; li_44++) {
         li_60 = FALSE;
         ld_68 = gda_516[li_40];
         if (ld_48 > ld_68 * (1 - ad_24) && ld_48 < ld_68 * (ad_24 + 1.0)) li_60 = TRUE;
         if (li_60) {
            HAR_FoundPatterns_Increase(38);
            return (38);
         }
      }
   }
   for (li_40 = 0; li_40 <= 7; li_40++) {
      for (li_44 = 0; li_44 <= 7; li_44++) {
         li_64 = FALSE;
         ld_76 = gda_520[li_44];
         if (li_56 > ld_76 * (1 - ad_32) && li_56 < ld_76 * (ad_32 + 1.0)) li_64 = TRUE;
         if (li_64) {
            HAR_FoundPatterns_Increase(39);
            return (39);
         }
      }
   }
   return (0);
}

int Is_Pattern_Fibo(int ai_0, double ad_4, int ai_12, double ad_16, int ai_24, double ad_28, double ad_36) {
   bool li_48 = FALSE;
   if (ad_4 - ad_16 == 0.0) return (0);
   double ld_52 = (ad_28 - ad_16) / (ad_4 - ad_16);
   if (bextFibo) {
      for (int li_44 = 0; li_44 < gi_348; li_44++)
         if (ld_52 >= gda_344[li_44] * (1.0 - ad_36) && ld_52 <= gda_344[li_44] * (ad_36 + 1.0)) li_48 = TRUE;
      if (li_48) {
         if (ad_4 < ad_16) {
            HAR_FoundPatterns_Increase(62);
            SIGMON_FoundPatterns_Set(21, 1);
            return (62);
         }
         if (ad_4 > ad_16) {
            HAR_FoundPatterns_Increase(62);
            SIGMON_FoundPatterns_Set(21, -1);
            return (62);
         }
      }
   }
   return (0);
}

int Draw_Pattern_ABCD(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32, int ai_40, double ad_44) {
   if (ad_8 - ad_20 == 0.0 || ad_32 - ad_20 == 0.0) return (0);
   string ls_52 = DoubleToStr((ad_32 - ad_20) / (ad_8 - ad_20), 3);
   string ls_60 = DoubleToStr((ad_32 - ad_44) / (ad_32 - ad_20), 3);
   if (ai_0 == 5) {
      DrawLine(ai_4, ad_8, ai_16, ad_20, cextABCDBullishColor, "AB", gsa_956[5][1], gi_860);
      DrawLine(ai_16, ad_20, ai_28, ad_32, cextABCDBullishColor, "BC", gsa_956[5][1], gi_860);
      DrawLine(ai_28, ad_32, ai_40, ad_44, cextABCDBullishColor, "CD", gsa_956[5][1], gi_860);
      DrawPoint("S", ai_4, ad_8, cextABCDDescColor, "A", gsa_956[5][1], iextDescrFontSize, 0);
      DrawPoint("L", ai_16, ad_20, cextABCDDescColor, "B", gsa_956[5][1], iextDescrFontSize, 0);
      DrawPoint("S", ai_28, ad_32, cextABCDDescColor, "C", gsa_956[5][1], iextDescrFontSize, 0);
      DrawPoint("L", ai_40, ad_44, cextABCDDescColor, "D", gsa_956[5][1], iextDescrFontSize, 0);
      CreatePatternIdentityObject(ai_4, ad_8, cextABCDDescColor, gsa_956[5][1], 5);
   } else {
      if (ai_0 == 6) {
         DrawLine(ai_4, ad_8, ai_16, ad_20, cextABCDBearishColor, "AB", gsa_956[6][1], gi_860);
         DrawLine(ai_16, ad_20, ai_28, ad_32, cextABCDBearishColor, "BC", gsa_956[6][1], gi_860);
         DrawLine(ai_28, ad_32, ai_40, ad_44, cextABCDBearishColor, "CD", gsa_956[6][1], gi_860);
         DrawPoint("L", ai_4, ad_8, cextABCDDescColor, "A", gsa_956[6][1], iextDescrFontSize, 0);
         DrawPoint("S", ai_16, ad_20, cextABCDDescColor, "B", gsa_956[6][1], iextDescrFontSize, 0);
         DrawPoint("L", ai_28, ad_32, cextABCDDescColor, "C", gsa_956[6][1], iextDescrFontSize, 0);
         DrawPoint("S", ai_40, ad_44, cextABCDDescColor, "D", gsa_956[6][1], iextDescrFontSize, 0);
         CreatePatternIdentityObject(ai_4, ad_8, cextABCDDescColor, gsa_956[6][1], 6);
      } else {
         if (ai_0 == 3) {
            DrawLine(ai_4, ad_8, ai_16, ad_20, cextABCDBullishColor, "AB", gsa_956[3][1], gi_860);
            DrawLine(ai_16, ad_20, ai_28, ad_32, cextABCDBullishColor, "BC", gsa_956[3][1], gi_860);
            DrawLine(ai_28, ad_32, ai_40, ad_44, cextABCDBullishColor, "CD", gsa_956[3][1], gi_860);
            DrawPoint("S", ai_4, ad_8, cextABCDDescColor, "A", gsa_956[3][1], iextDescrFontSize, 0);
            DrawPoint("L", ai_16, ad_20, cextABCDDescColor, "B", gsa_956[3][1], iextDescrFontSize, 0);
            DrawPoint("S", ai_28, ad_32, cextABCDDescColor, "C", gsa_956[3][1], iextDescrFontSize, 0);
            DrawPoint("L", ai_40, ad_44, cextABCDDescColor, "D", gsa_956[3][1], iextDescrFontSize, 0);
            CreatePatternIdentityObject(ai_4, ad_8, cextABCDDescColor, gsa_956[3][1], 3);
         } else {
            if (ai_0 == 4) {
               DrawLine(ai_4, ad_8, ai_16, ad_20, cextABCDBearishColor, "AB", gsa_956[4][1], gi_860);
               DrawLine(ai_16, ad_20, ai_28, ad_32, cextABCDBearishColor, "BC", gsa_956[4][1], gi_860);
               DrawLine(ai_28, ad_32, ai_40, ad_44, cextABCDBearishColor, "CD", gsa_956[4][1], gi_860);
               DrawPoint("L", ai_4, ad_8, cextABCDDescColor, "A", gsa_956[4][1], iextDescrFontSize, 0);
               DrawPoint("S", ai_16, ad_20, cextABCDDescColor, "B", gsa_956[4][1], iextDescrFontSize, 0);
               DrawPoint("L", ai_28, ad_32, cextABCDDescColor, "C", gsa_956[4][1], iextDescrFontSize, 0);
               DrawPoint("S", ai_40, ad_44, cextABCDDescColor, "D", gsa_956[4][1], iextDescrFontSize, 0);
               CreatePatternIdentityObject(ai_4, ad_8, cextABCDDescColor, gsa_956[4][1], 4);
            } else {
               if (ai_0 == 1) {
                  DrawLine(ai_4, ad_8, ai_16, ad_20, cextABCDBullishColor, "AB", gsa_956[1][1], gi_848);
                  DrawLine(ai_16, ad_20, ai_28, ad_32, cextABCDBullishColor, "BC", gsa_956[1][1], gi_848);
                  DrawLine(ai_28, ad_32, ai_40, ad_44, cextABCDBullishColor, "CD", gsa_956[1][1], gi_848);
                  CreatePatternIdentityObject(ai_4, ad_8, cextABCDDescColor, gsa_956[1][1], 1);
                  DrawRelationLine(ai_4, ad_8, ai_28, ad_32, ls_52, DarkSlateGray, "relAC", gsa_956[1][1]);
                  DrawRelationLine(ai_16, ad_20, ai_40, ad_44, ls_60, DarkSlateGray, "relBD", gsa_956[1][1]);
                  ProjectionLine(ai_40, ad_32 - (ad_8 - ad_20), Lime, "CD=AB", 0, 4, "CD=AB", gsa_956[1][1], gi_864);
                  ProjectionLine(ai_40, ad_32 - 1.272 * (ad_8 - ad_20), Lime, "CD=1272AB", 0, 4, "CD=1272AB", gsa_956[1][1], gi_864);
                  ProjectionLine(ai_40, ad_32 - 1.618 * (ad_8 - ad_20), Lime, "CD=1618AB", 0, 4, "CD=1618AB", gsa_956[1][1], gi_864);
               } else {
                  if (ai_0 == 2) {
                     DrawLine(ai_4, ad_8, ai_16, ad_20, cextABCDBearishColor, "AB", gsa_956[2][1], gi_848);
                     DrawLine(ai_16, ad_20, ai_28, ad_32, cextABCDBearishColor, "BC", gsa_956[2][1], gi_848);
                     DrawLine(ai_28, ad_32, ai_40, ad_44, cextABCDBearishColor, "CD", gsa_956[2][1], gi_848);
                     CreatePatternIdentityObject(ai_4, ad_8, cextABCDDescColor, gsa_956[2][1], 2);
                     DrawRelationLine(ai_4, ad_8, ai_28, ad_32, ls_52, DarkSlateGray, "relAC", gsa_956[2][1]);
                     DrawRelationLine(ai_16, ad_20, ai_40, ad_44, ls_60, DarkSlateGray, "relBD", gsa_956[2][1]);
                     if (bextDrawProjectionLines) {
                        ProjectionLine(ai_40, ad_32 - (ad_8 - ad_20), Red, "CD=AB", 0, 4, "CD=AB", gsa_956[2][1], gi_864);
                        ProjectionLine(ai_40, ad_32 - 1.272 * (ad_8 - ad_20), Red, "CD=1272AB", 0, 4, "CD=1272AB", gsa_956[2][1], gi_864);
                        ProjectionLine(ai_40, ad_32 - 1.618 * (ad_8 - ad_20), Red, "CD=1618AB", 0, 4, "CD=1618AB", gsa_956[2][1], gi_864);
                     }
                  }
               }
            }
         }
      }
   }
   return (0);
}

int Draw_Pattern_WXY(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32, int ai_40, double ad_44) {
   if (ad_8 - ad_20 == 0.0 || ad_32 - ad_20 == 0.0) return (0);
   string ls_52 = DoubleToStr((ad_32 - ad_20) / (ad_8 - ad_20), 3);
   string ls_60 = DoubleToStr((ad_32 - ad_44) / (ad_32 - ad_20), 3);
   if (ai_0 == 75) {
      DrawLine(ai_4, ad_8, ai_16, ad_20, cextWXYColor, "AB", gsa_956[75][1], gi_860);
      DrawLine(ai_16, ad_20, ai_28, ad_32, cextWXYColor, "BC", gsa_956[75][1], gi_860);
      DrawLine(ai_28, ad_32, ai_40, ad_44, cextWXYColor, "CD", gsa_956[75][1], gi_860);
      CreatePatternIdentityObject(ai_4, ad_8, cextWXYColor, gsa_956[75][1], 75);
   } else {
      if (ai_0 == 76) {
         DrawLine(ai_4, ad_8, ai_16, ad_20, cextWXYColor, "AB", gsa_956[76][1], gi_860);
         DrawLine(ai_16, ad_20, ai_28, ad_32, cextWXYColor, "BC", gsa_956[76][1], gi_860);
         DrawLine(ai_28, ad_32, ai_40, ad_44, cextWXYColor, "CD", gsa_956[76][1], gi_860);
         CreatePatternIdentityObject(ai_4, ad_8, cextWXYColor, gsa_956[76][1], 76);
      }
   }
   return (0);
}

int Draw_Pattern_Batman(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32, int ai_40, double ad_44) {
   if (ai_0 == 17) {
      DrawLine(ai_4, ad_8, ai_16, ad_20, cextBatmanBullishColor, "AB", gsa_956[17][1], gi_852);
      DrawLine(ai_16, ad_20, ai_28, ad_32, cextBatmanBullishColor, "BC", gsa_956[17][1], gi_852);
      DrawLine(ai_28, ad_32, ai_40, ad_44, cextBatmanBullishColor, "CD", gsa_956[17][1], gi_852);
      DrawPoint("S", ai_4, ad_8, cextBatmanDescColor, "A", gsa_956[17][1], iextDescrFontSize, 0);
      DrawPoint("L", ai_16, ad_20, cextBatmanDescColor, "B", gsa_956[17][1], iextDescrFontSize, 0);
      DrawPoint("S", ai_28, ad_32, cextBatmanDescColor, "C", gsa_956[17][1], iextDescrFontSize, 0);
      DrawPoint("L", ai_40, ad_44, cextBatmanDescColor, "D", gsa_956[17][1], iextDescrFontSize, 0);
      CreatePatternIdentityObject(ai_4, ad_8, cextBatmanDescColor, gsa_956[17][1], 17);
   } else {
      if (ai_0 == 18) {
         DrawLine(ai_4, ad_8, ai_16, ad_20, cextBatmanBearishColor, "AB", gsa_956[18][1], gi_852);
         DrawLine(ai_16, ad_20, ai_28, ad_32, cextBatmanBearishColor, "BC", gsa_956[18][1], gi_852);
         DrawLine(ai_28, ad_32, ai_40, ad_44, cextBatmanBearishColor, "CD", gsa_956[18][1], gi_852);
         DrawPoint("L", ai_4, ad_8, cextBatmanDescColor, "A", gsa_956[18][1], iextDescrFontSize, 0);
         DrawPoint("S", ai_16, ad_20, cextBatmanDescColor, "B", gsa_956[18][1], iextDescrFontSize, 0);
         DrawPoint("L", ai_28, ad_32, cextBatmanDescColor, "C", gsa_956[18][1], iextDescrFontSize, 0);
         DrawPoint("S", ai_40, ad_44, cextBatmanDescColor, "D", gsa_956[18][1], iextDescrFontSize, 0);
         CreatePatternIdentityObject(ai_4, ad_8, cextBatmanDescColor, gsa_956[18][1], 18);
      }
   }
   return (0);
}

void Draw_MultiDimPattern(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32, int ai_40, double ad_44, int ai_52, double ad_56, double ad_64) {
   string ls_72;
   if (ad_20 - ad_32 == 0.0 || ad_20 - ad_8 == 0.0 || ad_44 - ad_32 == 0.0) return;
   string ls_80 = DoubleToStr((ad_44 - ad_32) / (ad_20 - ad_32), 3);
   string ls_88 = DoubleToStr((ad_20 - ad_32) / (ad_20 - ad_8), 3);
   string ls_96 = DoubleToStr((ad_44 - ad_56) / (ad_44 - ad_32), 3);
   string ls_104 = DoubleToStr((ad_20 - ad_56) / (ad_20 - ad_8), 3);
   int li_112 = Time[iBarShift(Symbol(), Period(), ai_52)] - (Time[iBarShift(Symbol(), Period(), ai_52) + 5]);
   if (ai_0 == 9) {
      DrawTriangle(ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, cextGartleyBullishColor, "p1", gsa_956[9][1]);
      DrawTriangle(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, cextGartleyBullishColor, "p2", gsa_956[9][1]);
      CreatePatternIdentityObject(ai_4, ad_8, cextGartleyDescColor, gsa_956[9][1], 9);
      if (bextDrawProjectionLines) {
         ProjectionLine(ai_52, ad_20 - 0.618 * (ad_20 - ad_8), SlateGray, "AD=618XA", 0, 2, "AD=618XA", gsa_956[9][1], gi_864);
         ProjectionLine(ai_52, ad_20 - 0.786 * (ad_20 - ad_8), SlateGray, "AD=786XA", 0, 2, "AD=786XA", gsa_956[9][1], gi_864);
         ProjectionLine(ai_52, ad_44 - 1.127 * (ad_44 - ad_32), LightSeaGreen, "CD=1127BC", 0, 2, "CD=1127BC", gsa_956[9][1], gi_864);
         ProjectionLine(ai_52, ad_44 - 1.272 * (ad_44 - ad_32), LightSeaGreen, "CD=1272BC", 0, 2, "CD=1272BC", gsa_956[9][1], gi_864);
         ProjectionLine(ai_52, ad_44 - 1.618 * (ad_44 - ad_32), LightSeaGreen, "CD=1618BC", 0, 2, "CD=1618BC", gsa_956[9][1], gi_864);
         ProjectionLine(ai_52, ad_44 - 2.2236 * (ad_44 - ad_32), LightSeaGreen, "CD=2236BC", 0, 2, "CD=2236BC", gsa_956[9][1], gi_864);
         ProjectionLine(ai_52, ad_44 - (ad_20 - ad_32), MediumSeaGreen, "CD=AB", 0, 2, "CD=AB", gsa_956[9][1], gi_864);
      }
      if (bextDrawRelationLines) {
         DrawRelationLine(ai_16, ad_20, ai_40, ad_44, ls_80, DarkSlateGray, "relAC", gsa_956[9][1]);
         DrawRelationLine(ai_4, ad_8, ai_28, ad_32, ls_88, DarkSlateGray, "relXB", gsa_956[9][1]);
         DrawRelationLine(ai_28, ad_32, ai_52, ad_56, ls_96, DarkSlateGray, "relBD", gsa_956[9][1]);
         DrawRelationLine(ai_4, ad_8, ai_52, ad_56, ls_104, DarkSlateGray, "relXD", gsa_956[9][1]);
      }
      CalcRectangle(ai_40, ad_44, ai_52, ad_56, MathMin(ad_20 - 0.577 * (ad_20 - ad_8) * (1 - ad_64), ad_44 - 1.127 * (ad_44 - ad_32) * (1 - ad_64)), MathMax(ad_20 - 0.786 * (ad_20 - ad_8) * (ad_64 +
         1.0), ad_44 - 2.2236 * (ad_44 - ad_32) * (ad_64 + 1.0)), cextRectangleColor, "Rect", gsa_956[9][1]);
      DrawDimentions(1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
   } else {
      if (ai_0 == 10) {
         DrawTriangle(ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, cextGartleyBearishColor, "p1", gsa_956[10][1]);
         DrawTriangle(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, cextGartleyBearishColor, "p2", gsa_956[10][1]);
         CreatePatternIdentityObject(ai_4, ad_8, cextGartleyDescColor, gsa_956[10][1], 10);
         if (bextDrawProjectionLines) {
            ProjectionLine(ai_52, ad_20 - 0.618 * (ad_20 - ad_8), SlateGray, "AD=618XA", 0, 2, "AD=618XA", gsa_956[10][1], gi_864);
            ProjectionLine(ai_52, ad_20 - 0.786 * (ad_20 - ad_8), SlateGray, "AD=786XA", 0, 2, "AD=786XA", gsa_956[10][1], gi_864);
            ProjectionLine(ai_52, ad_44 - 1.272 * (ad_44 - ad_32), LightSeaGreen, "CD=1272BC", 0, 2, "CD=1272BC", gsa_956[10][1], gi_864);
            ProjectionLine(ai_52, ad_44 - 1.127 * (ad_44 - ad_32), LightSeaGreen, "CD=1127BC", 0, 2, "CD=1127BC", gsa_956[10][1], gi_864);
            ProjectionLine(ai_52, ad_44 - 1.618 * (ad_44 - ad_32), LightSeaGreen, "CD=1618BC", 0, 2, "CD=1618BC", gsa_956[10][1], gi_864);
            ProjectionLine(ai_52, ad_44 - 2.2236 * (ad_44 - ad_32), LightSeaGreen, "CD=2236BC", 0, 2, "CD=2236BC", gsa_956[10][1], gi_864);
            ProjectionLine(ai_52, ad_44 - (ad_20 - ad_32), MediumSeaGreen, "CD=AB", 0, 2, "CD=AB", gsa_956[10][1], gi_864);
         }
         if (bextDrawRelationLines) {
            DrawRelationLine(ai_16, ad_20, ai_40, ad_44, ls_80, DarkSlateGray, "relAC", gsa_956[10][1]);
            DrawRelationLine(ai_4, ad_8, ai_28, ad_32, ls_88, DarkSlateGray, "relXB", gsa_956[10][1]);
            DrawRelationLine(ai_28, ad_32, ai_52, ad_56, ls_96, DarkSlateGray, "relBD", gsa_956[10][1]);
            DrawRelationLine(ai_4, ad_8, ai_52, ad_56, ls_104, DarkSlateGray, "relXD", gsa_956[10][1]);
         }
         CalcRectangle(ai_40, ad_44, ai_52, ad_56, MathMax(ad_20 - 0.577 * (ad_20 - ad_8) * (1 - ad_64), ad_44 + 1.127 * (ad_32 - ad_44) * (1 - ad_64)), MathMin(ad_20 - 0.786 * (ad_20 - ad_8) * (ad_64 +
            1.0), ad_44 + 2.2236 * (ad_32 - ad_44) * (ad_64 + 1.0)), cextRectangleColor, "Rect", gsa_956[10][1]);
         DrawDimentions(-1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
      } else {
         if (ai_0 == 40) {
            DrawLine(ai_4, ad_8, ai_16, ad_20, cextEmergingBullishColor, "XA", gsa_956[40][1], gi_856);
            DrawLine(ai_16, ad_20, ai_28, ad_32, cextEmergingBullishColor, "AB", gsa_956[40][1], gi_856);
            DrawLine(ai_4, ad_8, ai_28, ad_32, cextEmergingBullishColor, "XB", gsa_956[40][1], gi_856);
            DrawLine(ai_28, ad_32, ai_40, ad_44, cextEmergingBullishColor, "BC", gsa_956[40][1], gi_856);
            DrawLine(ai_28, ad_32, Time[0], ad_44 + (ad_32 - ad_20), cextEmergingBullishColor, "BD", gsa_956[40][1], gi_856);
            DrawLine(ai_40, ad_44, Time[0], ad_44 + (ad_32 - ad_20), cextEmergingBullishColor, "CD", gsa_956[40][1], gi_856);
            CreatePatternIdentityObject(ai_4, ad_8, cextGartleyDescColor, gsa_956[40][1], 40);
            if (bextDrawProjectionLines) {
               ProjectionLine(ai_52, ad_20 - 0.786 * (ad_20 - ad_8), SlateGray, "AD=786XA", 0, 2, "AD=786XA", gsa_956[40][1], gi_864);
               ProjectionLine(ai_52, ad_44 - 1.618 * (ad_44 - ad_32), LightSeaGreen, "CD=1618BC", 0, 2, "CD=1618BC", gsa_956[40][1], gi_864);
               ProjectionLine(ai_52, ad_44 - 2.2236 * (ad_44 - ad_32), LightSeaGreen, "CD=2236BC", 0, 2, "CD=2236BC", gsa_956[40][1], gi_864);
               ProjectionLine(ai_52, ad_44 - (ad_20 - ad_32), MediumSeaGreen, "CD=AB", 0, 2, "CD=AB", gsa_956[40][1], gi_864);
            }
            if (bextDrawRelationLines) {
               DrawRelationLine(ai_16, ad_20, ai_40, ad_44, ls_80, DarkSlateGray, "relAC", gsa_956[9][1]);
               DrawRelationLine(ai_4, ad_8, ai_28, ad_32, ls_88, DarkSlateGray, "relXB", gsa_956[9][1]);
               DrawRelationLine(ai_28, ad_32, ai_52, ad_56, ls_96, DarkSlateGray, "relBD", gsa_956[9][1]);
               DrawRelationLine(ai_4, ad_8, ai_52, ad_56, ls_104, DarkSlateGray, "relXD", gsa_956[9][1]);
            }
         } else {
            if (ai_0 == 41) {
               DrawLine(ai_4, ad_8, ai_16, ad_20, cextEmergingBearishColor, "XA", gsa_956[41][1], gi_856);
               DrawLine(ai_16, ad_20, ai_28, ad_32, cextEmergingBearishColor, "AB", gsa_956[41][1], gi_856);
               DrawLine(ai_4, ad_8, ai_28, ad_32, cextEmergingBearishColor, "XB", gsa_956[41][1], gi_856);
               DrawLine(ai_28, ad_32, ai_40, ad_44, cextEmergingBearishColor, "BC", gsa_956[41][1], gi_856);
               DrawLine(ai_28, ad_32, Time[0], ad_44 + (ad_32 - ad_20), cextEmergingBearishColor, "BD", gsa_956[41][1], gi_856);
               DrawLine(ai_40, ad_44, Time[0], ad_44 + (ad_32 - ad_20), cextEmergingBearishColor, "CD", gsa_956[41][1], gi_856);
               CreatePatternIdentityObject(ai_4, ad_8, cextGartleyDescColor, gsa_956[41][1], 41);
               if (bextDrawProjectionLines) {
                  ProjectionLine(ai_52, ad_20 - 0.786 * (ad_20 - ad_8), SlateGray, "AD=786XA", 0, 2, "AD=786XA", gsa_956[41][1], gi_864);
                  ProjectionLine(ai_52, ad_44 - 1.618 * (ad_44 - ad_32), LightSeaGreen, "CD=1618BC", 0, 2, "CD=1618BC", gsa_956[41][1], gi_864);
                  ProjectionLine(ai_52, ad_44 - 2.2236 * (ad_44 - ad_32), LightSeaGreen, "CD=2236BC", 0, 2, "CD=2236BC", gsa_956[41][1], gi_864);
                  ProjectionLine(ai_52, ad_44 - (ad_20 - ad_32), MediumSeaGreen, "CD=AB", 0, 2, "CD=AB", gsa_956[41][1], gi_864);
               }
               if (bextDrawRelationLines) {
                  DrawRelationLine(ai_16, ad_20, ai_40, ad_44, ls_80, DarkSlateGray, "relAC", gsa_956[41][1]);
                  DrawRelationLine(ai_4, ad_8, ai_28, ad_32, ls_88, DarkSlateGray, "relXB", gsa_956[41][1]);
                  DrawRelationLine(ai_28, ad_32, ai_52, ad_56, ls_96, DarkSlateGray, "relBD", gsa_956[41][1]);
                  DrawRelationLine(ai_4, ad_8, ai_52, ad_56, ls_104, DarkSlateGray, "relXD", gsa_956[41][1]);
               }
            } else {
               if (ai_0 == 11) {
                  DrawTriangle(ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, cextButterflyBullishColor, "p1", gsa_956[11][1]);
                  DrawTriangle(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, cextButterflyBullishColor, "p2", gsa_956[11][1]);
                  CreatePatternIdentityObject(ai_4, ad_8, cextButterflyDescColor, gsa_956[11][1], 11);
                  if (bextDrawProjectionLines) {
                     ProjectionLine(ai_52, ad_20 - 1.27 * (ad_20 - ad_8), SlateGray, "AD=127XA", 0, 2, "AD=127XA", gsa_956[11][1], gi_864);
                     ProjectionLine(ai_52, ad_20 - 1.618 * (ad_20 - ad_8), SlateGray, "AD=1618XA", 0, 2, "AD=1618XA", gsa_956[11][1], gi_864);
                     ProjectionLine(ai_52, ad_44 - 1.618 * (ad_44 - ad_32), LightSeaGreen, "CD=1618BC", 0, 2, "CD=1618BC", gsa_956[11][1], gi_864);
                     ProjectionLine(ai_52, ad_44 - 2.618 * (ad_44 - ad_32), LightSeaGreen, "CD=2618BC", 0, 2, "CD=2618BC", gsa_956[11][1], gi_864);
                  }
                  if (bextDrawRelationLines) {
                     DrawRelationLine(ai_16, ad_20, ai_40, ad_44, ls_80, DarkSlateGray, "relAC", gsa_956[11][1]);
                     DrawRelationLine(ai_4, ad_8, ai_28, ad_32, ls_88, DarkSlateGray, "relXB", gsa_956[11][1]);
                     DrawRelationLine(ai_28, ad_32, ai_52, ad_56, ls_96, DarkSlateGray, "relBD", gsa_956[11][1]);
                     DrawRelationLine(ai_4, ad_8, ai_52, ad_56, ls_104, DarkSlateGray, "relXD", gsa_956[11][1]);
                  }
                  CalcRectangle(ai_40, ad_44, ai_52, ad_56, MathMin(ad_20 - 1.272 * (ad_20 - ad_8) * (1 - ad_64), ad_44 - 1.618 * (ad_44 - ad_32) * (1 - ad_64)), MathMax(ad_20 - 1.618 * (ad_20 - ad_8) * (ad_64 +
                     1.0), ad_44 - 2.618 * (ad_44 - ad_32) * (ad_64 + 1.0)), cextRectangleColor, "Rect", gsa_956[11][1]);
                  DrawDimentions(1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
               } else {
                  if (ai_0 == 12) {
                     DrawTriangle(ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, cextButterflyBearishColor, "p1", gsa_956[12][1]);
                     DrawTriangle(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, cextButterflyBearishColor, "p2", gsa_956[12][1]);
                     CreatePatternIdentityObject(ai_4, ad_8, cextButterflyDescColor, gsa_956[12][1], 12);
                     if (bextDrawProjectionLines) {
                        ProjectionLine(ai_52, ad_20 - 1.27 * (ad_20 - ad_8), SlateGray, "AD=127XA", 0, 2, "AD=127XA", gsa_956[12][1], gi_864);
                        ProjectionLine(ai_52, ad_20 - 1.618 * (ad_20 - ad_8), SlateGray, "AD=1618XA", 0, 2, "AD=1618XA", gsa_956[12][1], gi_864);
                        ProjectionLine(ai_52, ad_44 - 1.618 * (ad_44 - ad_32), LightSeaGreen, "CD=1618BC", 0, 2, "CD=1618BC", gsa_956[12][1], gi_864);
                        ProjectionLine(ai_52, ad_44 - 2.618 * (ad_44 - ad_32), LightSeaGreen, "CD=2618BC", 0, 2, "CD=2618BC", gsa_956[12][1], gi_864);
                     }
                     if (bextDrawRelationLines) {
                        DrawRelationLine(ai_16, ad_20, ai_40, ad_44, ls_80, DarkSlateGray, "relAC", gsa_956[12][1]);
                        DrawRelationLine(ai_4, ad_8, ai_28, ad_32, ls_88, DarkSlateGray, "relXB", gsa_956[12][1]);
                        DrawRelationLine(ai_28, ad_32, ai_52, ad_56, ls_96, DarkSlateGray, "relBD", gsa_956[12][1]);
                        DrawRelationLine(ai_4, ad_8, ai_52, ad_56, ls_104, DarkSlateGray, "relXD", gsa_956[12][1]);
                     }
                     CalcRectangle(ai_40, ad_44, ai_52, ad_56, MathMax(ad_20 - 1.272 * (ad_20 - ad_8) * (1 - ad_64), ad_44 - 1.618 * (ad_44 - ad_32) * (1 - ad_64)), MathMin(ad_20 - 1.618 * (ad_20 - ad_8) * (ad_64 +
                        1.0), ad_44 - 2.618 * (ad_44 - ad_32) * (ad_64 + 1.0)), cextRectangleColor, "Rect", gsa_956[12][1]);
                     DrawDimentions(-1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
                  } else {
                     if (ai_0 == 42) {
                        DrawLine(ai_4, ad_8, ai_16, ad_20, cextEmergingBullishColor, "XA", gsa_956[42][1], gi_856);
                        DrawLine(ai_16, ad_20, ai_28, ad_32, cextEmergingBullishColor, "AB", gsa_956[42][1], gi_856);
                        DrawLine(ai_4, ad_8, ai_28, ad_32, cextEmergingBullishColor, "XB", gsa_956[42][1], gi_856);
                        DrawLine(ai_28, ad_32, ai_40, ad_44, cextEmergingBullishColor, "BC", gsa_956[42][1], gi_856);
                        DrawLine(ai_28, ad_32, Time[0], ad_44 + 1.27 * (ad_8 - ad_20), cextEmergingBullishColor, "BD", gsa_956[42][1], gi_856);
                        DrawLine(ai_40, ad_44, Time[0], ad_44 + 1.27 * (ad_8 - ad_20), cextEmergingBullishColor, "CD", gsa_956[42][1], gi_856);
                        CreatePatternIdentityObject(ai_4, ad_8, cextButterflyDescColor, gsa_956[42][1], 42);
                        if (bextDrawProjectionLines) {
                           ProjectionLine(ai_52, ad_20 - 1.27 * (ad_20 - ad_8), SlateGray, "AD=127XA", 0, 2, "AD=127XA", gsa_956[42][1], gi_864);
                           ProjectionLine(ai_52, ad_20 - 1.618 * (ad_20 - ad_8), SlateGray, "AD=1618XA", 0, 2, "AD=1618XA", gsa_956[42][1], gi_864);
                           ProjectionLine(ai_52, ad_44 - 1.618 * (ad_44 - ad_32), LightSeaGreen, "CD=1618BC", 0, 2, "CD=1618BC", gsa_956[42][1], gi_864);
                           ProjectionLine(ai_52, ad_44 - 2.618 * (ad_44 - ad_32), LightSeaGreen, "CD=2618BC", 0, 2, "CD=2618BC", gsa_956[42][1], gi_864);
                        }
                        if (bextDrawRelationLines) {
                           DrawRelationLine(ai_16, ad_20, ai_40, ad_44, ls_80, DarkSlateGray, "relAC", gsa_956[42][1]);
                           DrawRelationLine(ai_4, ad_8, ai_28, ad_32, ls_88, DarkSlateGray, "relXB", gsa_956[42][1]);
                           DrawRelationLine(ai_28, ad_32, ai_52, ad_56, ls_96, DarkSlateGray, "relBD", gsa_956[42][1]);
                           DrawRelationLine(ai_4, ad_8, ai_52, ad_56, ls_104, DarkSlateGray, "relXD", gsa_956[42][1]);
                        }
                     } else {
                        if (ai_0 == 43) {
                           DrawLine(ai_4, ad_8, ai_16, ad_20, cextEmergingBearishColor, "XA", gsa_956[43][1], gi_856);
                           DrawLine(ai_16, ad_20, ai_28, ad_32, cextEmergingBearishColor, "AB", gsa_956[43][1], gi_856);
                           DrawLine(ai_4, ad_8, ai_28, ad_32, cextEmergingBearishColor, "XB", gsa_956[43][1], gi_856);
                           DrawLine(ai_28, ad_32, ai_40, ad_44, cextEmergingBearishColor, "BC", gsa_956[43][1], gi_856);
                           DrawLine(ai_28, ad_32, Time[0], ad_44 + 1.27 * (ad_8 - ad_20), cextEmergingBearishColor, "BD", gsa_956[43][1], gi_856);
                           DrawLine(ai_40, ad_44, Time[0], ad_44 + 1.27 * (ad_8 - ad_20), cextEmergingBearishColor, "CD", gsa_956[43][1], gi_856);
                           CreatePatternIdentityObject(ai_4, ad_8, cextButterflyDescColor, gsa_956[43][1], 43);
                           if (bextDrawProjectionLines) {
                              ProjectionLine(ai_52, ad_20 - 1.27 * (ad_20 - ad_8), SlateGray, "AD=127XA", 0, 2, "AD=127XA", gsa_956[43][1], gi_864);
                              ProjectionLine(ai_52, ad_20 - 1.618 * (ad_20 - ad_8), SlateGray, "AD=1618XA", 0, 2, "AD=1618XA", gsa_956[43][1], gi_864);
                              ProjectionLine(ai_52, ad_44 - 1.618 * (ad_44 - ad_32), LightSeaGreen, "CD=1618BC", 0, 2, "CD=1618BC", gsa_956[43][1], gi_864);
                              ProjectionLine(ai_52, ad_44 - 2.618 * (ad_44 - ad_32), LightSeaGreen, "CD=2618BC", 0, 2, "CD=2618BC", gsa_956[43][1], gi_864);
                           }
                           if (bextDrawRelationLines) {
                              DrawRelationLine(ai_16, ad_20, ai_40, ad_44, ls_80, DarkSlateGray, "relAC", gsa_956[43][1]);
                              DrawRelationLine(ai_4, ad_8, ai_28, ad_32, ls_88, DarkSlateGray, "relXB", gsa_956[43][1]);
                              DrawRelationLine(ai_28, ad_32, ai_52, ad_56, ls_96, DarkSlateGray, "relBD", gsa_956[43][1]);
                              DrawRelationLine(ai_4, ad_8, ai_52, ad_56, ls_104, DarkSlateGray, "relXD", gsa_956[43][1]);
                           }
                        } else {
                           if (ai_0 == 13) {
                              DrawTriangle(ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, cextCrabBullishColor, "p1", gsa_956[13][1]);
                              DrawTriangle(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, cextCrabBullishColor, "p2", gsa_956[13][1]);
                              CreatePatternIdentityObject(ai_4, ad_8, cextCrabDescColor, gsa_956[13][1], 13);
                              if (bextDrawProjectionLines) {
                                 ProjectionLine(ai_52, ad_20 - 1.618 * (ad_20 - ad_8), SlateGray, "AD=1618XA", 0, 2, "AD=1618XA", gsa_956[13][1], gi_864);
                                 ProjectionLine(ai_52, ad_44 - 2.24 * (ad_44 - ad_32), LightSeaGreen, "CD=2240BC", 0, 2, "CD=2240BC", gsa_956[13][1], gi_864);
                                 ProjectionLine(ai_52, ad_44 - 3.618 * (ad_44 - ad_32), LightSeaGreen, "CD=3618BC", 0, 2, "CD=3618BC", gsa_956[13][1], gi_864);
                              }
                              if (bextDrawRelationLines) {
                                 DrawRelationLine(ai_16, ad_20, ai_40, ad_44, ls_80, DarkSlateGray, "relAC", gsa_956[13][1]);
                                 DrawRelationLine(ai_4, ad_8, ai_28, ad_32, ls_88, DarkSlateGray, "relXB", gsa_956[13][1]);
                                 DrawRelationLine(ai_28, ad_32, ai_52, ad_56, ls_96, DarkSlateGray, "relBD", gsa_956[13][1]);
                                 DrawRelationLine(ai_4, ad_8, ai_52, ad_56, ls_104, DarkSlateGray, "relXD", gsa_956[13][1]);
                              }
                              CalcRectangle(ai_40, ad_44, ai_52, ad_56, MathMax(ad_20 - 1.618 * (ad_20 - ad_8) * (ad_64 + 1.0), ad_44 - 3.618 * (ad_44 - ad_32) * (ad_64 + 1.0)), MathMin(ad_20 - 1.618 * (ad_20 - ad_8) * (1 - ad_64), ad_44 - 2.24 * (ad_44 - ad_32) * (1 - ad_64)), cextRectangleColor, "Rect", gsa_956[13][1]);
                              DrawDimentions(1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
                           } else {
                              if (ai_0 == 14) {
                                 DrawTriangle(ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, cextCrabBearishColor, "p1", gsa_956[14][1]);
                                 DrawTriangle(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, cextCrabBearishColor, "p2", gsa_956[14][1]);
                                 CreatePatternIdentityObject(ai_4, ad_8, cextCrabDescColor, gsa_956[14][1], 14);
                                 if (bextDrawProjectionLines) {
                                    ProjectionLine(ai_52, ad_20 - 1.618 * (ad_20 - ad_8), SlateGray, "AD=1618XA", 0, 2, "AD=1618XA", gsa_956[14][1], gi_864);
                                    ProjectionLine(ai_52, ad_44 - 2.24 * (ad_44 - ad_32), LightSeaGreen, "CD=2240BC", 0, 2, "CD=2240BC", gsa_956[14][1], gi_864);
                                    ProjectionLine(ai_52, ad_44 - 3.618 * (ad_44 - ad_32), LightSeaGreen, "CD=3618BC", 0, 2, "CD=3618BC", gsa_956[14][1], gi_864);
                                 }
                                 if (bextDrawRelationLines) {
                                    DrawRelationLine(ai_16, ad_20, ai_40, ad_44, ls_80, DarkSlateGray, "relAC", gsa_956[14][1]);
                                    DrawRelationLine(ai_4, ad_8, ai_28, ad_32, ls_88, DarkSlateGray, "relXB", gsa_956[14][1]);
                                    DrawRelationLine(ai_28, ad_32, ai_52, ad_56, ls_96, DarkSlateGray, "relBD", gsa_956[14][1]);
                                    DrawRelationLine(ai_4, ad_8, ai_52, ad_56, ls_104, DarkSlateGray, "relXD", gsa_956[14][1]);
                                 }
                                 CalcRectangle(ai_40, ad_44, ai_52, ad_56, MathMin(ad_20 - 1.618 * (ad_20 - ad_8) * (ad_64 + 1.0), ad_44 - 3.618 * (ad_44 - ad_32) * (ad_64 + 1.0)), MathMax(ad_20 - 1.618 * (ad_20 - ad_8) * (1 - ad_64), ad_44 - 2.24 * (ad_44 - ad_32) * (1 - ad_64)), cextRectangleColor, "Rect", gsa_956[14][1]);
                                 DrawDimentions(-1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
                              } else {
                                 if (ai_0 == 44) {
                                    DrawLine(ai_4, ad_8, ai_16, ad_20, cextEmergingBullishColor, "XA", gsa_956[44][1], gi_856);
                                    DrawLine(ai_16, ad_20, ai_28, ad_32, cextEmergingBullishColor, "AB", gsa_956[44][1], gi_856);
                                    DrawLine(ai_4, ad_8, ai_28, ad_32, cextEmergingBullishColor, "XB", gsa_956[44][1], gi_856);
                                    DrawLine(ai_28, ad_32, ai_40, ad_44, cextEmergingBullishColor, "BC", gsa_956[44][1], gi_856);
                                    DrawLine(ai_28, ad_32, Time[0], ad_20 + 1.618 * (ad_8 - ad_20), cextEmergingBullishColor, "BD", gsa_956[44][1], gi_856);
                                    DrawLine(ai_40, ad_44, Time[0], ad_20 + 1.618 * (ad_8 - ad_20), cextEmergingBullishColor, "CD", gsa_956[44][1], gi_856);
                                    CreatePatternIdentityObject(ai_4, ad_8, cextCrabDescColor, gsa_956[44][1], 44);
                                    if (bextDrawProjectionLines) {
                                       ProjectionLine(ai_52, ad_20 - 1.618 * (ad_20 - ad_8), SlateGray, "AD=1618XA", 0, 2, "AD=1618XA", gsa_956[44][1], gi_864);
                                       ProjectionLine(ai_52, ad_44 - 2.24 * (ad_44 - ad_32), LightSeaGreen, "CD=2240BC", 0, 2, "CD=2240BC", gsa_956[44][1], gi_864);
                                       ProjectionLine(ai_52, ad_44 - 3.618 * (ad_44 - ad_32), LightSeaGreen, "CD=3618BC", 0, 2, "CD=3618BC", gsa_956[44][1], gi_864);
                                    }
                                    if (bextDrawRelationLines) {
                                       DrawRelationLine(ai_16, ad_20, ai_40, ad_44, ls_80, DarkSlateGray, "relAC", gsa_956[44][1]);
                                       DrawRelationLine(ai_4, ad_8, ai_28, ad_32, ls_88, DarkSlateGray, "relXB", gsa_956[44][1]);
                                       DrawRelationLine(ai_28, ad_32, ai_52, ad_56, ls_96, DarkSlateGray, "relBD", gsa_956[44][1]);
                                       DrawRelationLine(ai_4, ad_8, ai_52, ad_56, ls_104, DarkSlateGray, "relXD", gsa_956[44][1]);
                                    }
                                 } else {
                                    if (ai_0 == 45) {
                                       DrawLine(ai_4, ad_8, ai_16, ad_20, cextEmergingBearishColor, "XA", gsa_956[45][1], gi_856);
                                       DrawLine(ai_16, ad_20, ai_28, ad_32, cextEmergingBearishColor, "AB", gsa_956[45][1], gi_856);
                                       DrawLine(ai_4, ad_8, ai_28, ad_32, cextEmergingBearishColor, "XB", gsa_956[45][1], gi_856);
                                       DrawLine(ai_28, ad_32, ai_40, ad_44, cextEmergingBearishColor, "BC", gsa_956[45][1], gi_856);
                                       DrawLine(ai_28, ad_32, Time[0], ad_20 + 1.618 * (ad_8 - ad_20), cextEmergingBearishColor, "BD", gsa_956[45][1], gi_856);
                                       DrawLine(ai_40, ad_44, Time[0], ad_20 + 1.618 * (ad_8 - ad_20), cextEmergingBearishColor, "CD", gsa_956[45][1], gi_856);
                                       CreatePatternIdentityObject(ai_4, ad_8, cextCrabDescColor, gsa_956[45][1], 45);
                                       if (bextDrawProjectionLines) {
                                          ProjectionLine(ai_52, ad_20 - 1.618 * (ad_20 - ad_8), SlateGray, "AD=1618XA", 0, 2, "AD=1618XA", gsa_956[45][1], gi_864);
                                          ProjectionLine(ai_52, ad_44 - 2.24 * (ad_44 - ad_32), LightSeaGreen, "CD=2240BC", 0, 2, "CD=2240BC", gsa_956[45][1], gi_864);
                                          ProjectionLine(ai_52, ad_44 - 3.618 * (ad_44 - ad_32), LightSeaGreen, "CD=3618BC", 0, 2, "CD=3618BC", gsa_956[45][1], gi_864);
                                       }
                                       if (bextDrawRelationLines) {
                                          DrawRelationLine(ai_16, ad_20, ai_40, ad_44, ls_80, DarkSlateGray, "relAC", gsa_956[45][1]);
                                          DrawRelationLine(ai_4, ad_8, ai_28, ad_32, ls_88, DarkSlateGray, "relXB", gsa_956[45][1]);
                                          DrawRelationLine(ai_28, ad_32, ai_52, ad_56, ls_96, DarkSlateGray, "relBD", gsa_956[45][1]);
                                          DrawRelationLine(ai_4, ad_8, ai_52, ad_56, ls_104, DarkSlateGray, "relXD", gsa_956[45][1]);
                                       }
                                    } else {
                                       if (ai_0 == 15) {
                                          DrawTriangle(ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, cextBatBullishColor, "p1", gsa_956[15][1]);
                                          DrawTriangle(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, cextBatBullishColor, "p2", gsa_956[15][1]);
                                          CreatePatternIdentityObject(ai_4, ad_8, cextBatDescColor, gsa_956[15][1], 15);
                                          if (bextDrawProjectionLines) {
                                             ProjectionLine(ai_52, ad_20 - 0.886 * (ad_20 - ad_8), SlateGray, "AD=886XA", 0, 2, "AD=886XA", gsa_956[15][1], gi_864);
                                             ProjectionLine(ai_52, ad_44 - 1.618 * (ad_44 - ad_32), LightSeaGreen, "CD=1618BC", 0, 2, "CD=1618BC", gsa_956[15][1], gi_864);
                                             ProjectionLine(ai_52, ad_44 - 2.618 * (ad_44 - ad_32), LightSeaGreen, "CD=2618BC", 0, 2, "CD=2618BC", gsa_956[15][1], gi_864);
                                          }
                                          if (bextDrawRelationLines) {
                                             DrawRelationLine(ai_16, ad_20, ai_40, ad_44, ls_80, DarkSlateGray, "relAC", gsa_956[15][1]);
                                             DrawRelationLine(ai_4, ad_8, ai_28, ad_32, ls_88, DarkSlateGray, "relXB", gsa_956[15][1]);
                                             DrawRelationLine(ai_28, ad_32, ai_52, ad_56, ls_96, DarkSlateGray, "relBD", gsa_956[15][1]);
                                             DrawRelationLine(ai_4, ad_8, ai_52, ad_56, ls_104, DarkSlateGray, "relXD", gsa_956[15][1]);
                                          }
                                          CalcRectangle(ai_40, ad_44, ai_52, ad_56, MathMax(ad_20 - 0.886 * (ad_20 - ad_8) * (ad_64 + 1.0), ad_44 - 2.618 * (ad_44 - ad_32) * (ad_64 + 1.0)), MathMin(ad_20 - 0.886 * (ad_20 - ad_8) * (1 - ad_64), ad_44 - 1.618 * (ad_44 - ad_32) * (1 - ad_64)), cextRectangleColor, "Rect", gsa_956[15][1]);
                                          DrawDimentions(1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
                                       } else {
                                          if (ai_0 == 16) {
                                             DrawTriangle(ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, cextBatBearishColor, "p1", gsa_956[16][1]);
                                             DrawTriangle(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, cextBatBearishColor, "p2", gsa_956[16][1]);
                                             CreatePatternIdentityObject(ai_4, ad_8, cextBatDescColor, gsa_956[16][1], 16);
                                             if (bextDrawProjectionLines) {
                                                ProjectionLine(ai_52, ad_20 - 0.886 * (ad_20 - ad_8), SlateGray, "AD=886XA", 0, 2, "AD=886XA", gsa_956[16][1], gi_864);
                                                ProjectionLine(ai_52, ad_44 - 1.618 * (ad_44 - ad_32), LightSeaGreen, "CD=1618BC", 0, 2, "CD=1618BC", gsa_956[16][1], gi_864);
                                                ProjectionLine(ai_52, ad_44 - 2.618 * (ad_44 - ad_32), LightSeaGreen, "CD=2618BC", 0, 2, "CD=2618BC", gsa_956[16][1], gi_864);
                                             }
                                             if (bextDrawRelationLines) {
                                                DrawRelationLine(ai_16, ad_20, ai_40, ad_44, ls_80, DarkSlateGray, "relAC", gsa_956[16][1]);
                                                DrawRelationLine(ai_4, ad_8, ai_28, ad_32, ls_88, DarkSlateGray, "relXB", gsa_956[16][1]);
                                                DrawRelationLine(ai_28, ad_32, ai_52, ad_56, ls_96, DarkSlateGray, "relBD", gsa_956[16][1]);
                                                DrawRelationLine(ai_4, ad_8, ai_52, ad_56, ls_104, DarkSlateGray, "relXD", gsa_956[16][1]);
                                             }
                                             CalcRectangle(ai_40, ad_44, ai_52, ad_56, MathMax(ad_20 - 0.886 * (ad_20 - ad_8) * (ad_64 + 1.0), ad_44 - 2.618 * (ad_44 - ad_32) * (ad_64 + 1.0)), MathMin(ad_20 - 0.886 * (ad_20 - ad_8) * (1 - ad_64), ad_44 - 1.618 * (ad_44 - ad_32) * (1 - ad_64)), cextRectangleColor, "Rect", gsa_956[16][1]);
                                             DrawDimentions(-1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
                                          } else {
                                             if (ai_0 == 46) {
                                                DrawLine(ai_4, ad_8, ai_16, ad_20, cextEmergingBullishColor, "XA", gsa_956[46][1], gi_856);
                                                DrawLine(ai_16, ad_20, ai_28, ad_32, cextEmergingBullishColor, "AB", gsa_956[46][1], gi_856);
                                                DrawLine(ai_4, ad_8, ai_28, ad_32, cextEmergingBullishColor, "XB", gsa_956[46][1], gi_856);
                                                DrawLine(ai_28, ad_32, ai_40, ad_44, cextEmergingBullishColor, "BC", gsa_956[46][1], gi_856);
                                                DrawLine(ai_28, ad_32, Time[0], ad_20 + 0.886 * (ad_8 - ad_20), cextEmergingBullishColor, "BD", gsa_956[46][1], gi_856);
                                                DrawLine(ai_40, ad_44, Time[0], ad_20 + 0.886 * (ad_8 - ad_20), cextEmergingBullishColor, "CD", gsa_956[46][1], gi_856);
                                                CreatePatternIdentityObject(ai_4, ad_8, cextBatDescColor, gsa_956[46][1], 46);
                                                if (bextDrawProjectionLines) {
                                                   ProjectionLine(ai_52, ad_20 - 0.886 * (ad_20 - ad_8), SlateGray, "AD=886XA", 0, 2, "AD=886XA", gsa_956[46][1], gi_864);
                                                   ProjectionLine(ai_52, ad_44 - 1.618 * (ad_44 - ad_32), LightSeaGreen, "CD=1618BC", 0, 2, "CD=1618BC", gsa_956[46][1], gi_864);
                                                   ProjectionLine(ai_52, ad_44 - 2.618 * (ad_44 - ad_32), LightSeaGreen, "CD=2618BC", 0, 2, "CD=2618BC", gsa_956[46][1], gi_864);
                                                }
                                                if (bextDrawRelationLines) {
                                                   DrawRelationLine(ai_16, ad_20, ai_40, ad_44, ls_80, DarkSlateGray, "relAC", gsa_956[46][1]);
                                                   DrawRelationLine(ai_4, ad_8, ai_28, ad_32, ls_88, DarkSlateGray, "relXB", gsa_956[46][1]);
                                                   DrawRelationLine(ai_28, ad_32, ai_52, ad_56, ls_96, DarkSlateGray, "relBD", gsa_956[46][1]);
                                                   DrawRelationLine(ai_4, ad_8, ai_52, ad_56, ls_104, DarkSlateGray, "relXD", gsa_956[46][1]);
                                                }
                                             } else {
                                                if (ai_0 == 47) {
                                                   DrawLine(ai_4, ad_8, ai_16, ad_20, cextEmergingBearishColor, "XA", gsa_956[47][1], gi_856);
                                                   DrawLine(ai_16, ad_20, ai_28, ad_32, cextEmergingBearishColor, "AB", gsa_956[47][1], gi_856);
                                                   DrawLine(ai_4, ad_8, ai_28, ad_32, cextEmergingBearishColor, "XB", gsa_956[47][1], gi_856);
                                                   DrawLine(ai_28, ad_32, ai_40, ad_44, cextEmergingBearishColor, "BC", gsa_956[47][1], gi_856);
                                                   DrawLine(ai_28, ad_32, Time[0], ad_20 + 0.886 * (ad_8 - ad_20), cextEmergingBearishColor, "BD", gsa_956[47][1], gi_856);
                                                   DrawLine(ai_40, ad_44, Time[0], ad_20 + 0.886 * (ad_8 - ad_20), cextEmergingBearishColor, "CD", gsa_956[47][1], gi_856);
                                                   CreatePatternIdentityObject(ai_4, ad_8, cextBatDescColor, gsa_956[47][1], 47);
                                                   if (bextDrawProjectionLines) {
                                                      ProjectionLine(ai_52, ad_20 - 0.886 * (ad_20 - ad_8), SlateGray, "AD=886XA", 0, 2, "AD=886XA", gsa_956[47][1], gi_864);
                                                      ProjectionLine(ai_52, ad_44 - 1.618 * (ad_44 - ad_32), LightSeaGreen, "CD=1618BC", 0, 2, "CD=1618BC", gsa_956[47][1], gi_864);
                                                      ProjectionLine(ai_52, ad_44 - 2.618 * (ad_44 - ad_32), LightSeaGreen, "CD=2618BC", 0, 2, "CD=2618BC", gsa_956[47][1], gi_864);
                                                   }
                                                   if (bextDrawRelationLines) {
                                                      DrawRelationLine(ai_16, ad_20, ai_40, ad_44, ls_80, DarkSlateGray, "relAC", gsa_956[47][1]);
                                                      DrawRelationLine(ai_4, ad_8, ai_28, ad_32, ls_88, DarkSlateGray, "relXB", gsa_956[47][1]);
                                                      DrawRelationLine(ai_28, ad_32, ai_52, ad_56, ls_96, DarkSlateGray, "relBD", gsa_956[47][1]);
                                                      DrawRelationLine(ai_4, ad_8, ai_52, ad_56, ls_104, DarkSlateGray, "relXD", gsa_956[47][1]);
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
                     }
                  }
               }
            }
         }
      }
   }
   if (ai_0 == 56) {
      DrawTriangle(ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, cextGartleyBullishColor, "p1", gsa_956[56][1]);
      DrawTriangle(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, cextGartleyBullishColor, "p2", gsa_956[56][1]);
      CreatePatternIdentityObject(ai_4, ad_8, cextGartleyDescColor, gsa_956[56][1], 56);
      if (bextDrawRelationLines) {
         DrawRelationLine(ai_16, ad_20, ai_40, ad_44, ls_80, DarkSlateGray, "relAC", gsa_956[56][1]);
         DrawRelationLine(ai_4, ad_8, ai_28, ad_32, ls_88, DarkSlateGray, "relXB", gsa_956[56][1]);
         DrawRelationLine(ai_28, ad_32, ai_52, ad_56, ls_96, DarkSlateGray, "relBD", gsa_956[56][1]);
         DrawRelationLine(ai_4, ad_8, ai_52, ad_56, ls_104, DarkSlateGray, "relXD", gsa_956[56][1]);
      }
   } else {
      if (ai_0 == 57) {
         DrawTriangle(ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, cextGartleyBearishColor, "p1", gsa_956[57][1]);
         DrawTriangle(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, cextGartleyBearishColor, "p2", gsa_956[57][1]);
         CreatePatternIdentityObject(ai_4, ad_8, cextGartleyDescColor, gsa_956[57][1], 10);
         if (bextDrawRelationLines) {
            DrawRelationLine(ai_16, ad_20, ai_40, ad_44, ls_80, DarkSlateGray, "relAC", gsa_956[57][1]);
            DrawRelationLine(ai_4, ad_8, ai_28, ad_32, ls_88, DarkSlateGray, "relXB", gsa_956[57][1]);
            DrawRelationLine(ai_28, ad_32, ai_52, ad_56, ls_96, DarkSlateGray, "relBD", gsa_956[57][1]);
            DrawRelationLine(ai_4, ad_8, ai_52, ad_56, ls_104, DarkSlateGray, "relXD", gsa_956[57][1]);
         }
      }
   }
}

int Draw_Pattern_SHS(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32, int ai_40, double ad_44, int ai_52, double ad_56, int ai_64, double ad_68) {
   if (ai_0 == 19 || ai_0 == 21) {
      DrawLine(ai_4, ad_8, ai_16, ad_20, cextSHSBullishColor, "AB", gsa_956[19][1], gi_860);
      DrawLine(ai_16, ad_20, ai_28, ad_32, cextSHSBullishColor, "BC", gsa_956[19][1], gi_860);
      DrawLine(ai_28, ad_32, ai_40, ad_44, cextSHSBullishColor, "CD", gsa_956[19][1], gi_860);
      DrawLine(ai_40, ad_44, ai_52, ad_56, cextSHSBullishColor, "DE", gsa_956[19][1], gi_860);
      DrawLine(ai_52, ad_56, ai_64, ad_68, cextSHSBullishColor, "EF", gsa_956[19][1], gi_860);
      DrawPoint("L", ai_16, ad_20, cextSHSDescColor, "S", gsa_956[19][1], iextDescrFontSize, 0);
      if (ai_0 == 19) DrawPoint("L", ai_40, ad_44, cextSHSDescColor, "H", gsa_956[19][1], iextDescrFontSize, 0);
      else DrawPoint("L", ai_40, ad_44, cextSHSDescColor, "I+H", gsa_956[19][1], iextDescrFontSize, 0);
      DrawPoint("L", ai_64, ad_68, cextSHSDescColor, "S", gsa_956[19][1], iextDescrFontSize, 0);
      CreatePatternIdentityObject(ai_4, ad_8, cextSHSDescColor, gsa_956[19][1], 19);
   } else {
      if (ai_0 == 20 || ai_0 == 22) {
         DrawLine(ai_4, ad_8, ai_16, ad_20, cextSHSBearishColor, "AB", gsa_956[20][1], gi_860);
         DrawLine(ai_16, ad_20, ai_28, ad_32, cextSHSBearishColor, "BC", gsa_956[20][1], gi_860);
         DrawLine(ai_28, ad_32, ai_40, ad_44, cextSHSBearishColor, "CD", gsa_956[20][1], gi_860);
         DrawLine(ai_40, ad_44, ai_52, ad_56, cextSHSBearishColor, "DE", gsa_956[20][1], gi_860);
         DrawLine(ai_52, ad_56, ai_64, ad_68, cextSHSBearishColor, "EF", gsa_956[20][1], gi_860);
         DrawPoint("S", ai_16, ad_20, cextSHSDescColor, "S", gsa_956[20][1], iextDescrFontSize, 0);
         if (ai_0 == 20) DrawPoint("S", ai_40, ad_44, cextSHSDescColor, "H", gsa_956[20][1], iextDescrFontSize, 0);
         else DrawPoint("S", ai_40, ad_44, cextSHSDescColor, "I+H", gsa_956[20][1], iextDescrFontSize, 0);
         DrawPoint("S", ai_64, ad_68, cextSHSDescColor, "S", gsa_956[20][1], iextDescrFontSize, 0);
         CreatePatternIdentityObject(ai_4, ad_8, cextSHSDescColor, gsa_956[20][1], 20);
      }
   }
   return (0);
}

int Draw_Pattern_3Drives(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32, int ai_40, double ad_44, int ai_52, double ad_56, int ai_64, double ad_68) {
   if (ai_0 == 23) {
      DrawTriangle(ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, cext3Drives1BullishColor, "p1", gsa_956[23][1]);
      DrawTriangle(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, cext3Drives1BullishColor, "p2", gsa_956[23][1]);
      DrawTriangle(ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, cext3Drives2BullishColor, "p3", gsa_956[23][1]);
      DrawTriangle(ai_40, ad_44, ai_52, ad_56, ai_64, ad_68, cext3Drives2BullishColor, "p4", gsa_956[23][1]);
      CreatePatternIdentityObject(ai_4, ad_8, cext3DrivesDescColor, gsa_956[23][1], 23);
   } else {
      if (ai_0 == 24) {
         DrawTriangle(ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, cext3Drives1BearishColor, "p1", gsa_956[24][1]);
         DrawTriangle(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, cext3Drives1BearishColor, "p2", gsa_956[24][1]);
         DrawTriangle(ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, cext3Drives2BearishColor, "p3", gsa_956[24][1]);
         DrawTriangle(ai_40, ad_44, ai_52, ad_56, ai_64, ad_68, cext3Drives2BearishColor, "p4", gsa_956[24][1]);
         CreatePatternIdentityObject(ai_4, ad_8, cext3DrivesDescColor, gsa_956[24][1], 24);
      }
   }
   return (0);
}

int Draw_Pattern_5_0(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32, int ai_40, double ad_44, int ai_52, double ad_56, int ai_64, double ad_68) {
   if (ai_0 == 25) {
      DrawLine(ai_4, ad_8, ai_16, ad_20, cext5_0BullishColor, "OX", gsa_956[25][1], gi_860);
      DrawLine(ai_16, ad_20, ai_28, ad_32, cext5_0BullishColor, "XA", gsa_956[25][1], gi_860);
      DrawLine(ai_28, ad_32, ai_40, ad_44, cext5_0BullishColor, "AB", gsa_956[25][1], gi_860);
      DrawLine(ai_40, ad_44, ai_52, ad_56, cext5_0BullishColor, "BC", gsa_956[25][1], gi_860);
      DrawLine(ai_52, ad_56, ai_64, ad_68, cext5_0BullishColor, "CD", gsa_956[25][1], gi_860);
      DrawPoint("L", ai_40, ad_44, cext5_0DescColor, "5-0", gsa_956[25][1], iextDescrFontSize, 0);
      CreatePatternIdentityObject(ai_4, ad_8, cext5_0DescColor, gsa_956[25][1], 25);
   } else {
      if (ai_0 == 26) {
         DrawLine(ai_4, ad_8, ai_16, ad_20, cext5_0BearishColor, "OX", gsa_956[26][1], gi_860);
         DrawLine(ai_16, ad_20, ai_28, ad_32, cext5_0BearishColor, "XA", gsa_956[26][1], gi_860);
         DrawLine(ai_28, ad_32, ai_40, ad_44, cext5_0BearishColor, "AB", gsa_956[26][1], gi_860);
         DrawLine(ai_40, ad_44, ai_52, ad_56, cext5_0BearishColor, "BC", gsa_956[26][1], gi_860);
         DrawLine(ai_52, ad_56, ai_64, ad_68, cext5_0BearishColor, "CD", gsa_956[26][1], gi_860);
         DrawPoint("S", ai_40, ad_44, cext5_0DescColor, "5-0", gsa_956[25][1], iextDescrFontSize, 0);
         CreatePatternIdentityObject(ai_4, ad_8, cext5_0DescColor, gsa_956[26][1], 26);
      }
   }
   return (0);
}

int Draw_Triangle(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32, int ai_40, double ad_44, int ai_52, double ad_56) {
   int li_64 = -1 * iBarShift(Symbol(), Period(), ai_4);
   int li_68 = -1 * iBarShift(Symbol(), Period(), ai_16);
   int li_72 = -1 * iBarShift(Symbol(), Period(), ai_28);
   int li_76 = -1 * iBarShift(Symbol(), Period(), ai_40);
   int li_80 = -1 * iBarShift(Symbol(), Period(), ai_52);
   if (li_64 - li_72 == 0 || li_68 - li_76 == 0) return (0);
   double ld_84 = (ad_8 - ad_32) / (li_64 - li_72);
   double ld_92 = ad_8 - ld_84 * li_64;
   double ld_100 = ld_84 * li_76 + ld_92;
   double ld_108 = (ad_20 - ad_44) / (li_68 - li_76);
   double ld_116 = ad_20 - ld_108 * li_68;
   double ld_124 = ld_108 * li_80 + ld_116;
   double ld_132 = ld_108 * li_64 + ld_116;
   if (ai_0 == 63) {
      DrawLine(ai_4, ad_8, ai_52, ad_56, cextTriangleBullishColor, "AE", gsa_956[63][1], gi_872);
      DrawLine(ai_4, ld_132, ai_52, ld_124, cextTriangleBullishColor, "BD", gsa_956[63][1], gi_872);
      DrawLine(ai_4, ad_8, ai_16, ad_20, cextTriangleBullishColor, "AB", gsa_956[63][1], gi_876);
      DrawLine(ai_16, ad_20, ai_28, ad_32, cextTriangleBullishColor, "BC", gsa_956[63][1], gi_876);
      DrawLine(ai_28, ad_32, ai_40, ad_44, cextTriangleBullishColor, "CD", gsa_956[63][1], gi_876);
      DrawLine(ai_40, ad_44, ai_52, ad_56, cextTriangleBullishColor, "DE", gsa_956[63][1], gi_876);
      if (bextDrawPatternDescr) {
         DrawPoint("L", ai_4, ad_8, cextTriangleBullishColor, "a", gsa_956[63][1], iextDescrFontSize, 2);
         DrawPoint("S", ai_16, ad_20, cextTriangleBullishColor, "b", gsa_956[63][1], iextDescrFontSize, 2);
         DrawPoint("L", ai_28, ad_32, cextTriangleBullishColor, "c", gsa_956[63][1], iextDescrFontSize, 2);
         DrawPoint("S", ai_40, ad_44, cextTriangleBullishColor, "d", gsa_956[63][1], iextDescrFontSize, 2);
         DrawPoint("L", ai_52, ad_56, cextTriangleBullishColor, "e", gsa_956[63][1], iextDescrFontSize, 2);
      }
      CreatePatternIdentityObject(ai_52, ad_56, cext5_0DescColor, gsa_956[63][1], 63);
   } else {
      if (ai_0 == 64) {
         DrawLine(ai_4, ad_8, ai_52, ad_56, cextTriangleBearishColor, "AE", gsa_956[64][1], gi_872);
         DrawLine(ai_4, ld_132, ai_52, ld_124, cextTriangleBearishColor, "BD", gsa_956[64][1], gi_872);
         DrawLine(ai_4, ad_8, ai_16, ad_20, cextTriangleBearishColor, "AB", gsa_956[64][1], gi_876);
         DrawLine(ai_16, ad_20, ai_28, ad_32, cextTriangleBearishColor, "BC", gsa_956[64][1], gi_876);
         DrawLine(ai_28, ad_32, ai_40, ad_44, cextTriangleBearishColor, "CD", gsa_956[64][1], gi_876);
         DrawLine(ai_40, ad_44, ai_52, ad_56, cextTriangleBearishColor, "DE", gsa_956[64][1], gi_876);
         if (bextDrawPatternDescr) {
            DrawPoint("S", ai_4, ad_8, cextTriangleBearishColor, "a", gsa_956[64][1], iextDescrFontSize, 1);
            DrawPoint("L", ai_16, ad_20, cextTriangleBearishColor, "b", gsa_956[64][1], iextDescrFontSize, 1);
            DrawPoint("S", ai_28, ad_32, cextTriangleBearishColor, "c", gsa_956[64][1], iextDescrFontSize, 1);
            DrawPoint("L", ai_40, ad_44, cextTriangleBearishColor, "d", gsa_956[64][1], iextDescrFontSize, 1);
            DrawPoint("S", ai_52, ad_56, cextTriangleBearishColor, "e", gsa_956[64][1], iextDescrFontSize, 1);
         }
         CreatePatternIdentityObject(ai_52, ad_56, cext5_0DescColor, gsa_956[64][1], 64);
      } else {
         if (ai_0 == 71) {
            DrawLine(ai_4, ad_8, ai_52, ad_56, cextITriangleBullishColor, "AE", gsa_956[71][1], gi_872);
            DrawLine(ai_4, ld_132, ai_52, ld_124, cextITriangleBullishColor, "BD", gsa_956[71][1], gi_872);
            DrawLine(ai_4, ad_8, ai_16, ad_20, cextITriangleBullishColor, "AB", gsa_956[71][1], gi_876);
            DrawLine(ai_16, ad_20, ai_28, ad_32, cextITriangleBullishColor, "BC", gsa_956[71][1], gi_876);
            DrawLine(ai_28, ad_32, ai_40, ad_44, cextITriangleBullishColor, "CD", gsa_956[71][1], gi_876);
            DrawLine(ai_40, ad_44, ai_52, ad_56, cextITriangleBullishColor, "DE", gsa_956[71][1], gi_876);
            if (bextDrawPatternDescr) {
               DrawPoint("L", ai_4, ad_8, cextITriangleBullishColor, "a", gsa_956[71][1], iextDescrFontSize, 2);
               DrawPoint("S", ai_16, ad_20, cextITriangleBullishColor, "b", gsa_956[71][1], iextDescrFontSize, 2);
               DrawPoint("L", ai_28, ad_32, cextITriangleBullishColor, "c", gsa_956[71][1], iextDescrFontSize, 2);
               DrawPoint("S", ai_40, ad_44, cextITriangleBullishColor, "d", gsa_956[71][1], iextDescrFontSize, 2);
               DrawPoint("L", ai_52, ad_56, cextITriangleBullishColor, "e", gsa_956[71][1], iextDescrFontSize, 2);
            }
            CreatePatternIdentityObject(ai_52, ad_56, cext5_0DescColor, gsa_956[71][1], 71);
         } else {
            if (ai_0 == 72) {
               DrawLine(ai_4, ad_8, ai_52, ad_56, cextITriangleBearishColor, "AE", gsa_956[72][1], gi_872);
               DrawLine(ai_4, ld_132, ai_52, ld_124, cextITriangleBearishColor, "BD", gsa_956[72][1], gi_872);
               DrawLine(ai_4, ad_8, ai_16, ad_20, cextITriangleBearishColor, "AB", gsa_956[72][1], gi_876);
               DrawLine(ai_16, ad_20, ai_28, ad_32, cextITriangleBearishColor, "BC", gsa_956[72][1], gi_876);
               DrawLine(ai_28, ad_32, ai_40, ad_44, cextITriangleBearishColor, "CD", gsa_956[72][1], gi_876);
               DrawLine(ai_40, ad_44, ai_52, ad_56, cextITriangleBearishColor, "DE", gsa_956[72][1], gi_876);
               if (bextDrawPatternDescr) {
                  DrawPoint("S", ai_4, ad_8, cextITriangleBearishColor, "a", gsa_956[72][1], iextDescrFontSize, 1);
                  DrawPoint("L", ai_16, ad_20, cextITriangleBearishColor, "b", gsa_956[72][1], iextDescrFontSize, 1);
                  DrawPoint("S", ai_28, ad_32, cextITriangleBearishColor, "c", gsa_956[72][1], iextDescrFontSize, 1);
                  DrawPoint("L", ai_40, ad_44, cextITriangleBearishColor, "d", gsa_956[72][1], iextDescrFontSize, 1);
                  DrawPoint("S", ai_52, ad_56, cextITriangleBearishColor, "e", gsa_956[72][1], iextDescrFontSize, 1);
               }
               CreatePatternIdentityObject(ai_52, ad_56, cext5_0DescColor, gsa_956[72][1], 72);
            } else {
               if (ai_0 == 73) {
                  DrawLine(ai_4, ad_8, ai_52, ad_56, cextNITriangleBullishColor, "AE", gsa_956[73][1], gi_872);
                  DrawLine(ai_4, ld_132, ai_52, ld_124, cextNITriangleBullishColor, "BD", gsa_956[73][1], gi_872);
                  DrawLine(ai_4, ad_8, ai_16, ad_20, cextNITriangleBullishColor, "AB", gsa_956[73][1], gi_876);
                  DrawLine(ai_16, ad_20, ai_28, ad_32, cextNITriangleBullishColor, "BC", gsa_956[73][1], gi_876);
                  DrawLine(ai_28, ad_32, ai_40, ad_44, cextNITriangleBullishColor, "CD", gsa_956[73][1], gi_876);
                  DrawLine(ai_40, ad_44, ai_52, ad_56, cextNITriangleBullishColor, "DE", gsa_956[73][1], gi_876);
                  if (bextDrawPatternDescr) {
                     DrawPoint("L", ai_4, ad_8, cextNITriangleBullishColor, "a", gsa_956[73][1], iextDescrFontSize, 2);
                     DrawPoint("S", ai_16, ad_20, cextNITriangleBullishColor, "b", gsa_956[73][1], iextDescrFontSize, 2);
                     DrawPoint("L", ai_28, ad_32, cextNITriangleBullishColor, "c", gsa_956[73][1], iextDescrFontSize, 2);
                     DrawPoint("S", ai_40, ad_44, cextNITriangleBullishColor, "d", gsa_956[73][1], iextDescrFontSize, 2);
                     DrawPoint("L", ai_52, ad_56, cextNITriangleBullishColor, "e", gsa_956[73][1], iextDescrFontSize, 2);
                  }
                  CreatePatternIdentityObject(ai_52, ad_56, cext5_0DescColor, gsa_956[73][1], 73);
               } else {
                  if (ai_0 == 74) {
                     DrawLine(ai_4, ad_8, ai_52, ad_56, cextNITriangleBearishColor, "AE", gsa_956[74][1], gi_872);
                     DrawLine(ai_4, ld_132, ai_52, ld_124, cextNITriangleBearishColor, "BD", gsa_956[74][1], gi_872);
                     DrawLine(ai_4, ad_8, ai_16, ad_20, cextNITriangleBearishColor, "AB", gsa_956[74][1], gi_876);
                     DrawLine(ai_16, ad_20, ai_28, ad_32, cextNITriangleBearishColor, "BC", gsa_956[74][1], gi_876);
                     DrawLine(ai_28, ad_32, ai_40, ad_44, cextNITriangleBearishColor, "CD", gsa_956[74][1], gi_876);
                     DrawLine(ai_40, ad_44, ai_52, ad_56, cextNITriangleBearishColor, "DE", gsa_956[74][1], gi_876);
                     if (bextDrawPatternDescr) {
                        DrawPoint("S", ai_4, ad_8, cextNITriangleBearishColor, "a", gsa_956[74][1], iextDescrFontSize, 1);
                        DrawPoint("L", ai_16, ad_20, cextNITriangleBearishColor, "b", gsa_956[74][1], iextDescrFontSize, 1);
                        DrawPoint("S", ai_28, ad_32, cextNITriangleBearishColor, "c", gsa_956[74][1], iextDescrFontSize, 1);
                        DrawPoint("L", ai_40, ad_44, cextNITriangleBearishColor, "d", gsa_956[74][1], iextDescrFontSize, 1);
                        DrawPoint("S", ai_52, ad_56, cextNITriangleBearishColor, "e", gsa_956[74][1], iextDescrFontSize, 1);
                     }
                     CreatePatternIdentityObject(ai_52, ad_56, cext5_0DescColor, gsa_956[72][1], 74);
                  }
               }
            }
         }
      }
   }
   return (0);
}

int Draw_DiaTriangle(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32, int ai_40, double ad_44, int ai_52, double ad_56, int ai_64, double ad_68) {
   int li_84 = -1 * iBarShift(Symbol(), Period(), ai_28);
   int li_92 = -1 * iBarShift(Symbol(), Period(), ai_52);
   int li_96 = -1 * iBarShift(Symbol(), Period(), ai_64);
   if (li_84 - li_92 == 0) return (0);
   double ld_100 = (ad_32 - ad_56) / (li_84 - li_92);
   double ld_108 = ad_32 - ld_100 * li_84;
   double ld_116 = ld_100 * li_96 + ld_108;
   if (ai_0 == 65) {
      DrawLine(ai_16, ad_20, ai_64, ad_68, cextDiagonalColor, "AE", gsa_956[65][1], gi_872);
      DrawLine(ai_28, ad_32, ai_52, ad_56, cextDiagonalColor, "BD", gsa_956[65][1], gi_872);
      DrawLine(ai_52, ad_56, ai_64, ld_116, cextDiagonalColor, "DF", gsa_956[65][1], gi_872);
      if (bextDrawPatternDescr) {
         DrawPoint("L", ai_16, ad_20, cextDiagonalDescColor, "1", gsa_956[65][1], iextDescrFontSize, 0);
         DrawPoint("S", ai_28, ad_32, cextDiagonalDescColor, "2", gsa_956[65][1], iextDescrFontSize, 0);
         DrawPoint("L", ai_40, ad_44, cextDiagonalDescColor, "3", gsa_956[65][1], iextDescrFontSize, 0);
         DrawPoint("S", ai_52, ad_56, cextDiagonalDescColor, "4", gsa_956[65][1], iextDescrFontSize, 0);
         DrawPoint("L", ai_64, ad_68, cextDiagonalDescColor, "5", gsa_956[65][1], iextDescrFontSize, 0);
      }
      CreatePatternIdentityObject(ai_4, ad_8, cext5_0DescColor, gsa_956[65][1], 65);
   } else {
      if (ai_0 == 66) {
         DrawLine(ai_16, ad_20, ai_64, ad_68, cextDiagonalColor, "AE", gsa_956[66][1], gi_872);
         DrawLine(ai_28, ad_32, ai_52, ad_56, cextDiagonalColor, "BD", gsa_956[66][1], gi_872);
         DrawLine(ai_52, ad_56, ai_64, ld_116, cextDiagonalColor, "DF", gsa_956[66][1], gi_872);
         if (bextDrawPatternDescr) {
            DrawPoint("S", ai_16, ad_20, cextDiagonalDescColor, "1", gsa_956[66][1], iextDescrFontSize, 0);
            DrawPoint("L", ai_28, ad_32, cextDiagonalDescColor, "2", gsa_956[66][1], iextDescrFontSize, 0);
            DrawPoint("S", ai_40, ad_44, cextDiagonalDescColor, "3", gsa_956[66][1], iextDescrFontSize, 0);
            DrawPoint("L", ai_52, ad_56, cextDiagonalDescColor, "4", gsa_956[66][1], iextDescrFontSize, 0);
            DrawPoint("S", ai_64, ad_68, cextDiagonalDescColor, "5", gsa_956[66][1], iextDescrFontSize, 0);
         }
         CreatePatternIdentityObject(ai_4, ad_8, cext5_0DescColor, gsa_956[66][1], 66);
      }
   }
   return (0);
}

int Draw_OmarPattern(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32, int ai_40, double ad_44, int ai_52, double ad_56) {
   if (ai_0 == 48) {
      DrawLine(ai_4, ad_8, ai_16, ad_20, gi_832, "XA", gsa_956[48][1], gi_860);
      DrawLine(ai_16, ad_20, ai_28, ad_32, gi_832, "AB", gsa_956[48][1], gi_860);
      DrawLine(ai_28, ad_32, ai_40, ad_44, gi_832, "BC", gsa_956[48][1], gi_860);
      DrawLine(ai_40, ad_44, ai_52, ad_56, gi_832, "CD", gsa_956[48][1], gi_860);
      CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_956[48][1], 48);
      ProjectionLine(ai_52, ad_44, Blue, "E", 1, 2, "E", gsa_956[48][1], gi_864);
      ProjectionLine(ai_52, ad_44 + 1.0 * (ad_44 - ad_56), SeaGreen, "T1", 1, 2, "T1", gsa_956[48][1], gi_864);
      ProjectionLine(ai_52, ad_44 + 1.27 * (ad_44 - ad_56), SeaGreen, "T2", 1, 2, "T2", gsa_956[48][1], gi_864);
      ProjectionLine(ai_52, ad_44 + 1.414 * (ad_44 - ad_56), SeaGreen, "T3", 1, 2, "T3", gsa_956[48][1], gi_864);
      ProjectionLine(ai_52, ad_44 + 1.618 * (ad_44 - ad_56), SeaGreen, "T4", 1, 2, "T4", gsa_956[48][1], gi_864);
   } else {
      if (ai_0 == 49) {
         DrawLine(ai_4, ad_8, ai_16, ad_20, gi_836, "XA", gsa_956[49][1], gi_860);
         DrawLine(ai_16, ad_20, ai_28, ad_32, gi_836, "AB", gsa_956[49][1], gi_860);
         DrawLine(ai_28, ad_32, ai_40, ad_44, gi_836, "BC", gsa_956[49][1], gi_860);
         DrawLine(ai_40, ad_44, ai_52, ad_56, gi_836, "CD", gsa_956[49][1], gi_860);
         CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_956[49][1], 49);
         ProjectionLine(ai_52, ad_44, Blue, "E", 1, 2, "E", gsa_956[49][1], gi_864);
         ProjectionLine(ai_52, ad_44 + 1.0 * (ad_44 - ad_56), SeaGreen, "T1", 1, 2, "T1", gsa_956[49][1], gi_864);
         ProjectionLine(ai_52, ad_44 + 1.27 * (ad_44 - ad_56), SeaGreen, "T2", 1, 2, "T2", gsa_956[49][1], gi_864);
         ProjectionLine(ai_52, ad_44 + 1.414 * (ad_44 - ad_56), SeaGreen, "T3", 1, 2, "T3", gsa_956[49][1], gi_864);
         ProjectionLine(ai_52, ad_44 + 1.618 * (ad_44 - ad_56), SeaGreen, "T4", 1, 2, "T4", gsa_956[49][1], gi_864);
      } else {
         if (ai_0 == 50) {
            DrawLine(ai_4, ad_8, ai_16, ad_20, gi_832, "XA", gsa_956[50][1], gi_860);
            DrawLine(ai_16, ad_20, ai_28, ad_32, gi_832, "AB", gsa_956[50][1], gi_860);
            DrawLine(ai_28, ad_32, ai_40, ad_44, gi_832, "BC", gsa_956[50][1], gi_860);
            DrawLine(ai_40, ad_44, ai_52, ad_56, gi_832, "CD", gsa_956[50][1], gi_860);
            CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_956[50][1], 50);
            ProjectionLine(ai_52, ad_44, Blue, "E", 1, 2, "E", gsa_956[48][1], gi_864);
            ProjectionLine(ai_52, ad_44 + 0.786 * (ad_44 - ad_56), SeaGreen, "T1", 1, 2, "T1", gsa_956[50][1], gi_864);
            ProjectionLine(ai_52, ad_44 + 0.886 * (ad_44 - ad_56), SeaGreen, "T2", 1, 2, "T2", gsa_956[50][1], gi_864);
            ProjectionLine(ai_52, ad_44 + 1.0 * (ad_44 - ad_56), SeaGreen, "T3", 1, 2, "T3", gsa_956[50][1], gi_864);
         } else {
            if (ai_0 == 51) {
               DrawLine(ai_4, ad_8, ai_16, ad_20, gi_836, "XA", gsa_956[51][1], gi_860);
               DrawLine(ai_16, ad_20, ai_28, ad_32, gi_836, "AB", gsa_956[51][1], gi_860);
               DrawLine(ai_28, ad_32, ai_40, ad_44, gi_836, "BC", gsa_956[51][1], gi_860);
               DrawLine(ai_40, ad_44, ai_52, ad_56, gi_836, "CD", gsa_956[51][1], gi_860);
               CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_956[51][1], 51);
               ProjectionLine(ai_52, ad_44, Blue, "E", 1, 2, "E", gsa_956[51][1], gi_864);
               ProjectionLine(ai_52, ad_44 + 0.786 * (ad_44 - ad_56), SeaGreen, "T1", 1, 2, "T1", gsa_956[51][1], gi_864);
               ProjectionLine(ai_52, ad_44 + 0.886 * (ad_44 - ad_56), SeaGreen, "T2", 1, 2, "T2", gsa_956[51][1], gi_864);
               ProjectionLine(ai_52, ad_44 + 1.0 * (ad_44 - ad_56), SeaGreen, "T3", 1, 2, "T3", gsa_956[51][1], gi_864);
            } else {
               if (ai_0 == 52) {
                  DrawLine(ai_4, ad_8, ai_16, ad_20, gi_832, "XA", gsa_956[52][1], gi_860);
                  DrawLine(ai_16, ad_20, ai_28, ad_32, gi_832, "AB", gsa_956[52][1], gi_860);
                  DrawLine(ai_28, ad_32, ai_40, ad_44, gi_832, "BC", gsa_956[52][1], gi_860);
                  DrawLine(ai_40, ad_44, ai_52, ad_56, gi_832, "CD", gsa_956[52][1], gi_860);
                  CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_956[52][1], 52);
                  ProjectionLine(ai_52, ad_44, Blue, "E", 1, 2, "E", gsa_956[52][1], gi_864);
                  ProjectionLine(ai_52, ad_44 + 1.0 * (ad_44 - ad_56), SeaGreen, "T1", 1, 2, "T1", gsa_956[52][1], gi_864);
                  ProjectionLine(ai_52, ad_44 + 1.27 * (ad_44 - ad_56), SeaGreen, "T2", 1, 2, "T2", gsa_956[52][1], gi_864);
                  ProjectionLine(ai_52, ad_44 + 1.414 * (ad_44 - ad_56), SeaGreen, "T3", 1, 2, "T3", gsa_956[52][1], gi_864);
               } else {
                  if (ai_0 == 53) {
                     DrawLine(ai_4, ad_8, ai_16, ad_20, gi_836, "XA", gsa_956[53][1], gi_860);
                     DrawLine(ai_16, ad_20, ai_28, ad_32, gi_836, "AB", gsa_956[53][1], gi_860);
                     DrawLine(ai_28, ad_32, ai_40, ad_44, gi_836, "BC", gsa_956[53][1], gi_860);
                     DrawLine(ai_40, ad_44, ai_52, ad_56, gi_836, "CD", gsa_956[53][1], gi_860);
                     CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_956[53][1], 53);
                     ProjectionLine(ai_52, ad_44, Blue, "E", 1, 2, "E", gsa_956[53][1], gi_864);
                     ProjectionLine(ai_52, ad_44 + 1.0 * (ad_44 - ad_56), SeaGreen, "T1", 1, 2, "T1", gsa_956[53][1], gi_864);
                     ProjectionLine(ai_52, ad_44 + 1.27 * (ad_44 - ad_56), SeaGreen, "T2", 1, 2, "T2", gsa_956[53][1], gi_864);
                     ProjectionLine(ai_52, ad_44 + 1.414 * (ad_44 - ad_56), SeaGreen, "T3", 1, 2, "T3", gsa_956[53][1], gi_864);
                  } else {
                     if (ai_0 == 54) {
                        DrawLine(ai_4, ad_8, ai_16, ad_20, gi_832, "XA", gsa_956[54][1], gi_860);
                        DrawLine(ai_16, ad_20, ai_28, ad_32, gi_832, "AB", gsa_956[54][1], gi_860);
                        DrawLine(ai_28, ad_32, ai_40, ad_44, gi_832, "BC", gsa_956[54][1], gi_860);
                        DrawLine(ai_40, ad_44, ai_52, ad_56, gi_832, "CD", gsa_956[54][1], gi_860);
                        CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_956[54][1], 54);
                        ProjectionLine(ai_52, ad_44, Blue, "E", 1, 2, "E", gsa_956[54][1], gi_864);
                        ProjectionLine(ai_52, ad_44 + 0.707 * (ad_44 - ad_56), SeaGreen, "T1", 1, 2, "T1", gsa_956[54][1], gi_864);
                        ProjectionLine(ai_52, ad_44 + 0.786 * (ad_44 - ad_56), SeaGreen, "T1", 1, 2, "T1", gsa_956[54][1], gi_864);
                        ProjectionLine(ai_52, ad_44 + 0.886 * (ad_44 - ad_56), SeaGreen, "T2", 1, 2, "T2", gsa_956[54][1], gi_864);
                        ProjectionLine(ai_52, ad_44 + 1.0 * (ad_44 - ad_56), SeaGreen, "T3", 1, 2, "T3", gsa_956[54][1], gi_864);
                     } else {
                        if (ai_0 == 55) {
                           DrawLine(ai_4, ad_8, ai_16, ad_20, gi_836, "XA", gsa_956[55][1], gi_860);
                           DrawLine(ai_16, ad_20, ai_28, ad_32, gi_836, "AB", gsa_956[55][1], gi_860);
                           DrawLine(ai_28, ad_32, ai_40, ad_44, gi_836, "BC", gsa_956[55][1], gi_860);
                           DrawLine(ai_40, ad_44, ai_52, ad_56, gi_836, "CD", gsa_956[55][1], gi_860);
                           CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_956[55][1], 55);
                           ProjectionLine(ai_52, ad_44, Blue, "E", 1, 2, "E", gsa_956[55][1], gi_864);
                           ProjectionLine(ai_52, ad_44 + 0.707 * (ad_44 - ad_56), SeaGreen, "T1", 1, 2, "T1", gsa_956[55][1], gi_864);
                           ProjectionLine(ai_52, ad_44 + 0.786 * (ad_44 - ad_56), SeaGreen, "T1", 1, 2, "T1", gsa_956[55][1], gi_864);
                           ProjectionLine(ai_52, ad_44 + 0.886 * (ad_44 - ad_56), SeaGreen, "T2", 1, 2, "T2", gsa_956[55][1], gi_864);
                           ProjectionLine(ai_52, ad_44 + 1.0 * (ad_44 - ad_56), SeaGreen, "T3", 1, 2, "T3", gsa_956[55][1], gi_864);
                        }
                     }
                  }
               }
            }
         }
      }
   }
   return (0);
}

int Draw_VibrationPattern(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20) {
   string ls_28 = DoubleToStr(10000.0 * MathAbs(ad_8 - ad_20), 0);
   string ls_36 = iBarShift(Symbol(), Period(), ai_4) - iBarShift(Symbol(), Period(), ai_16);
   if (ai_0 == 37) {
      DrawLine(ai_4, ad_8, ai_16, ad_20, gi_524, "PT", gsa_956[37][1], gi_868);
      DrawPoint("S", ai_4, ad_8, gi_524, ls_28 + " ; " + ls_36, gsa_956[37][1], iextDescrFontSize, 0);
      CreatePatternIdentityObject(ai_4, ad_8, gi_536, gsa_956[37][1], 37);
   } else {
      if (ai_0 == 38) {
         DrawLine(ai_4, ad_8, ai_16, ad_20, gi_528, "P", gsa_956[38][1], gi_868);
         DrawPoint("S", ai_4, ad_8, gi_528, ls_28 + " ; " + ls_36, gsa_956[38][1], iextDescrFontSize, 0);
         CreatePatternIdentityObject(ai_4, ad_8, gi_536, gsa_956[38][1], 38);
      } else {
         if (ai_0 == 39) {
            DrawLine(ai_4, ad_8, ai_16, ad_20, gi_532, "T", gsa_956[39][1], gi_868);
            DrawPoint("S", ai_4, ad_8, gi_536, ls_28 + " ; " + ls_36, gsa_956[39][1], iextDescrFontSize, 0);
            CreatePatternIdentityObject(ai_4, ad_8, gi_536, gsa_956[39][1], 39);
         }
      }
   }
   return (0);
}

int Draw_Pattern_Fibo(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32) {
   if (ad_8 - ad_20 == 0.0) return (0);
   string ls_40 = DoubleToStr((ad_32 - ad_20) / (ad_8 - ad_20), 3);
   if (ai_0 == 62) {
      CreatePatternIdentityObject(ai_4, ad_8, cextFiboDescColor, gsa_956[62][1], 62);
      DrawRelationLine(ai_4, ad_8, ai_28, ad_32, ls_40, Chocolate, "relAC", gsa_956[62][1]);
   }
   return (0);
}

void DrawPoint(string as_0, int ai_8, double ad_12, color ai_20, string as_24, string as_32, int ai_40, int ai_44) {
   int li_56;
   string ls_48 = "HAR_O_" + "point_" + as_32 + "_" + as_24 + "_" + "_bars" + iBarShift(Symbol(), Period(), ai_8) + "_" + DateTimeReformat(TimeToStr(ai_8, TIME_DATE|TIME_MINUTES));
   ObjectDelete(ls_48);
   if (ai_44 == 1) li_56 = ai_8 + 3 * (Time[0] - Time[1]);
   else {
      if (ai_44 == 2) li_56 = ai_8 - 3 * (Time[0] - Time[1]);
      else
         if (ai_44 == 0) li_56 = ai_8;
   }
   if (as_0 == "S") ObjectCreate(ls_48, OBJ_TEXT, 0, li_56, ad_12 + LabelOffset(ai_40 + 8));
   else {
      if (as_0 == "L") ObjectCreate(ls_48, OBJ_TEXT, 0, li_56, ad_12);
      else Alert("PANIC: unknown DrawPoint point type:", as_0);
   }
   ObjectSetText(ls_48, as_24, ai_40, "Georgia", ai_20);
}

double LabelOffset(int ai_0) {
   double ld_4 = WindowPriceMax();
   double ld_12 = WindowPriceMin();
   if (ld_4 == 0.0 || ld_12 == 0.0) return (0);
   return (ai_0 * (ld_4 - ld_12) / WindowYPixels());
}

void DrawLine(int ai_0, double ad_4, int ai_12, double ad_16, color ai_24, string as_28, string as_36, int ai_44) {
   string ls_48 = "HAR_O_" + "line_" + as_36 + "_" + as_28 + "_bars" + iBarShift(Symbol(), Period(), ai_0) + "_" + iBarShift(Symbol(), Period(), ai_12) + "_" + DateTimeReformat(TimeToStr(ai_0, TIME_DATE|TIME_MINUTES));
   ObjectDelete(ls_48);
   ObjectCreate(ls_48, OBJ_TREND, 0, ai_0, ad_4, ai_12, ad_16);
   ObjectSet(ls_48, OBJPROP_COLOR, ai_24);
   ObjectSet(ls_48, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet(ls_48, OBJPROP_WIDTH, ai_44);
   ObjectSet(ls_48, OBJPROP_BACK, TRUE);
   ObjectSet(ls_48, OBJPROP_RAY, FALSE);
}

void ProjectionLine(int ai_0, double ad_4, color ai_12, string as_16, int ai_24, int ai_28, string as_32, string as_40, int ai_48) {
   int li_52 = Time[iBarShift(Symbol(), Period(), ai_0)] - (Time[iBarShift(Symbol(), Period(), ai_0) + ai_28]);
   string ls_56 = "HAR_O_" + "fibo_" + as_40 + "_" + as_32 + "_bars" + iBarShift(Symbol(), Period(), ai_0) + "_" + DateTimeReformat(TimeToStr(ai_0, TIME_DATE|TIME_MINUTES));
   ObjectDelete(ls_56);
   ObjectCreate(ls_56, OBJ_FIBO, 0, ai_0 - li_52, ad_4, ai_0 + li_52, ad_4);
   ObjectSet(ls_56, OBJPROP_STYLE, STYLE_DASH);
   ObjectSet(ls_56, OBJPROP_COLOR, ai_12);
   ObjectSet(ls_56, OBJPROP_LEVELCOLOR, ai_12);
   ObjectSet(ls_56, OBJPROP_WIDTH, 1);
   ObjectSet(ls_56, OBJPROP_FIBOLEVELS, 1);
   ObjectSet(ls_56, OBJPROP_LEVELWIDTH, 1);
   ObjectSet(ls_56, OBJPROP_FIRSTLEVEL, 0);
   ObjectSet(ls_56, OBJPROP_RAY, FALSE);
   ObjectSetFiboDescription(ls_56, 0, as_40 + " " + as_16 + "   @%$");
   ObjectSet(ls_56, OBJPROP_ANGLE, 30);
}

void SmartRetracementLines(int ai_0, double ad_4, int ai_12, double ad_16, int ai_24, double ad_28, color ai_36, string as_40, string as_48, int ai_56, int ai_60, string as_64, string as_72, int ai_80) {
   double ld_92;
   double ld_100;
   double ld_108;
   int li_120;
   string ls_124;
   double lda_84[] = {0.236, 0.382, 0.414, 0.5, 0.618, 0.707, 0.786, 0.886, 1.0, 1.27, 1.272, 1.414, 1.618, 2.0, 2.24, 2.618, 3.618};
   int li_88 = 17;
   if (ad_16 - ad_4 != 0.0) {
      ld_92 = (ad_16 - ad_28) / (ad_16 - ad_4);
      for (int li_116 = 0; li_116 < li_88; li_116++) {
         if (lda_84[li_116] < ld_92) {
            ld_100 = lda_84[li_116];
            ld_108 = lda_84[li_116 + 1];
         }
      }
      li_120 = Time[iBarShift(Symbol(), Period(), ai_0)] - (Time[iBarShift(Symbol(), Period(), ai_0) + ai_60]);
      ls_124 = "HAR_O_" + "ifibo_" + as_72 + "_" + as_64 + "_bars" + iBarShift(Symbol(), Period(), ai_0) + "_" + DateTimeReformat(TimeToStr(ai_0, TIME_DATE|TIME_MINUTES));
      ObjectDelete(ls_124);
      ObjectCreate(ls_124, OBJ_FIBO, 0, ai_0 + li_120, ad_4, ai_12, ad_16);
      ObjectSet(ls_124, OBJPROP_STYLE, STYLE_DOT);
      ObjectSet(ls_124, OBJPROP_COLOR, ai_36);
      ObjectSet(ls_124, OBJPROP_LEVELCOLOR, ai_36);
      ObjectSet(ls_124, OBJPROP_WIDTH, 1);
      ObjectSet(ls_124, OBJPROP_FIBOLEVELS, 2);
      ObjectSet(ls_124, OBJPROP_LEVELWIDTH, 1);
      ObjectSet(ls_124, OBJPROP_FIRSTLEVEL, ld_100);
      ObjectSet(ls_124, 211, ld_108);
      ObjectSet(ls_124, OBJPROP_RAY, FALSE);
      ObjectSetFiboDescription(ls_124, 0, as_40 + DoubleToStr(ld_100, 3) + as_48 + "   %$");
      ObjectSetFiboDescription(ls_124, 1, as_40 + DoubleToStr(ld_108, 3) + as_48 + "   %$");
      ObjectSet(ls_124, OBJPROP_ANGLE, 30);
   }
}

void DrawRelationLine(int ai_0, double ad_4, int ai_12, double ad_16, string as_24, color ai_32, string as_36, string as_44) {
   double ld_52 = dextMaxDeviation;
   double ld_60 = 1000;
   string ls_68 = "HAR_O_" + "relline_" + as_44 + "_" + as_36 + "_bars" + iBarShift(Symbol(), Period(), ai_0) + "_" + DateTimeReformat(TimeToStr(ai_0, TIME_DATE|TIME_MINUTES));
   ObjectDelete(ls_68);
   ObjectCreate(ls_68, OBJ_TREND, 0, ai_0, ad_4, ai_12, ad_16);
   ObjectSet(ls_68, OBJPROP_COLOR, ai_32);
   ObjectSet(ls_68, OBJPROP_STYLE, STYLE_DASHDOTDOT);
   ObjectSet(ls_68, OBJPROP_WIDTH, 1);
   ObjectSet(ls_68, OBJPROP_BACK, TRUE);
   ObjectSet(ls_68, OBJPROP_RAY, FALSE);
   ls_68 = "HAR_O_" + "linedesc_" + as_44 + "_" + as_36 + "_" + "_bars" + iBarShift(Symbol(), Period(), ai_0) + "_" + DateTimeReformat(TimeToStr(ai_0, TIME_DATE|TIME_MINUTES));
   ObjectDelete(ls_68);
   int li_76 = iBarShift(Symbol(), Period(), ai_0);
   int li_80 = iBarShift(Symbol(), Period(), ai_12);
   int li_84 = (li_76 + li_80) / 2;
   ObjectCreate(ls_68, OBJ_TEXT, 0, Time[li_84], MathAbs(ad_4 + ad_16) / 2.0);
   double ld_88 = StrToDouble(as_24);
   string ls_96 = "";
   for (int li_104 = 0; li_104 < gi_348; li_104++) {
      if (ld_88 >= gda_344[li_104] * (1.0 - ld_52) && ld_88 <= gda_344[li_104] * (ld_52 + 1.0) && MathAbs(ld_88 - gda_344[li_104]) < ld_60) {
         ls_96 = DoubleToStr(gda_344[li_104], 3);
         ld_60 = MathAbs(ld_88 - gda_344[li_104]);
      }
   }
   if (StringLen(ls_96) > 0) ObjectSetText(ls_68, as_24 + " ( " + ls_96 + " )", 8, "Tahoma", extTextColor);
   else ObjectSetText(ls_68, DoubleToStr(100.0 * StrToDouble(as_24), 1), 8, "Tahoma", DimGray);
   if (bextRelationAngleRotate) {
      ObjectSet(ls_68, OBJPROP_ANGLE, AngleEdit(ai_0, ad_4, ai_12, ad_16));
      return;
   }
   ObjectSet(ls_68, OBJPROP_ANGLE, 0);
}

double AngleEdit(int ai_0, double ad_4, int ai_12, double ad_16) {
   int li_52 = iBarShift(Symbol(), Period(), ai_0);
   int li_56 = iBarShift(Symbol(), Period(), ai_12);
   double ld_24 = WindowPriceMax();
   double ld_32 = WindowPriceMin();
   int li_48 = WindowBarsPerChart();
   if (ld_24 == 0.0 || ld_32 == 0.0 || li_48 == 0 || li_52 - li_56 == 0) return (0.0);
   double ld_40 = 57.3 * MathArctan((ad_16 - ad_4) * WindowYPixels() / (ld_24 - ld_32) / ((li_52 - li_56) * WindowYPixels() / li_48));
   return (ld_40);
}

void DrawTriangle(int ai_0, double ad_4, int ai_12, double ad_16, int ai_24, double ad_28, color ai_36, string as_40, string as_48) {
   string ls_56 = "HAR_O_" + "tria_" + as_48 + "_" + as_40 + "_" + iBarShift(Symbol(), Period(), ai_0) + "_" + iBarShift(Symbol(), Period(), ai_12) + "_" + iBarShift(Symbol(), Period(), ai_24) + "_" + DateTimeReformat(TimeToStr(ai_0, TIME_DATE|TIME_MINUTES));
   ObjectDelete(ls_56);
   ObjectCreate(ls_56, OBJ_TRIANGLE, 0, ai_0, ad_4, ai_12, ad_16, ai_24, ad_28);
   ObjectSet(ls_56, OBJPROP_COLOR, ai_36);
   ObjectSet(ls_56, OBJPROP_BACK, TRUE);
}

void CalcRectangle(int ai_0, double ad_4, int ai_12, double ad_16, double ad_24, double ad_32, color ai_40, string as_44, string as_52) {
   int li_60;
   int li_64;
   double ld_68;
   double ld_76;
   int li_84;
   int li_88;
   int li_92;
   int li_96;
   string ls_100;
   if (bextDrawRectangle != FALSE) {
      li_60 = iBarShift(Symbol(), Period(), ai_0);
      li_64 = iBarShift(Symbol(), Period(), ai_12);
      if (li_60 - li_64 != 0) {
         ld_68 = (ad_4 - ad_16) / (li_60 - li_64);
         ld_76 = ad_4 - ld_68 * li_60;
         if (ld_68 != 0.0) {
            li_84 = (ad_24 - ld_76) / ld_68;
            li_88 = (ad_32 - ld_76) / ld_68;
            if (li_84 > 0) li_92 = iTime(NULL, 0, li_84);
            else li_92 = Time[0] - 60 * (li_84 * Period());
            if (li_88 > 0) li_96 = iTime(NULL, 0, li_88);
            else li_96 = Time[0] - 60 * (li_88 * Period());
            ls_100 = "HAR_O_" + "rect_" + as_52 + "_" + as_44 + "_" + iBarShift(Symbol(), Period(), li_92) + "_" + iBarShift(Symbol(), Period(), li_96) + "_" + DateTimeReformat(TimeToStr(li_92, TIME_DATE|TIME_MINUTES));
            ObjectDelete(ls_100);
            ObjectCreate(ls_100, OBJ_RECTANGLE, 0, li_92, ad_24, li_96, ad_32);
            ObjectSet(ls_100, OBJPROP_COLOR, ai_40);
            ObjectSet(ls_100, OBJPROP_BACK, FALSE);
         }
      }
   }
}

void DrawDimentions(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32, int ai_40, double ad_44, int ai_52, double ad_56) {
   double ld_64;
   double ld_72;
   double ld_80;
   double ld_88;
   int li_96;
   int li_100;
   int li_104;
   int li_108;
   int li_112;
   double ld_116;
   string ls_124;
   if (bextDrawPatternDim != FALSE) {
      ld_64 = MathAbs(ad_8 - ad_20) / Point;
      ld_72 = MathAbs(ad_20 - ad_32) / Point;
      ld_80 = MathAbs(ad_32 - ad_44) / Point;
      ld_88 = MathAbs(ad_44 - ad_56) / Point;
      li_96 = iBarShift(Symbol(), Period(), ai_4) - iBarShift(Symbol(), Period(), ai_16);
      li_100 = iBarShift(Symbol(), Period(), ai_16) - iBarShift(Symbol(), Period(), ai_28);
      li_104 = iBarShift(Symbol(), Period(), ai_28) - iBarShift(Symbol(), Period(), ai_40);
      li_108 = iBarShift(Symbol(), Period(), ai_40) - iBarShift(Symbol(), Period(), ai_52);
      li_112 = 8;
      ld_116 = LabelOffset(li_112 + 7);
      if (ai_0 == 1) {
         ls_124 = "HAR_O_" + "pattern_dim_XA" + iBarShift(Symbol(), Period(), ai_4) + "_" + DateTimeReformat(TimeToStr(ai_4, TIME_DATE|TIME_MINUTES));
         ObjectDelete(ls_124);
         ObjectCreate(ls_124, OBJ_TEXT, 0, ai_16, ad_20 + ld_116);
         ObjectSetText(ls_124, DoubleToStr(ld_64, 0) + " (" + DoubleToStr(li_96, 0) + ")", li_112, "Tahoma", cextPatternDimColor);
         ls_124 = "HAR_O_" + "pattern_dim_AB" + iBarShift(Symbol(), Period(), ai_16) + "_" + DateTimeReformat(TimeToStr(ai_16, TIME_DATE|TIME_MINUTES));
         ObjectDelete(ls_124);
         ObjectCreate(ls_124, OBJ_TEXT, 0, ai_28, ad_32);
         ObjectSetText(ls_124, DoubleToStr(ld_72, 0) + " (" + DoubleToStr(li_100, 0) + ")", li_112, "Tahoma", cextPatternDimColor);
         ls_124 = "HAR_O_" + "pattern_dim_BC" + iBarShift(Symbol(), Period(), ai_16) + "_" + DateTimeReformat(TimeToStr(ai_16, TIME_DATE|TIME_MINUTES));
         ObjectDelete(ls_124);
         ObjectCreate(ls_124, OBJ_TEXT, 0, ai_40, ad_44 + ld_116);
         ObjectSetText(ls_124, DoubleToStr(ld_80, 0) + " (" + DoubleToStr(li_104, 0) + ")", li_112, "Tahoma", cextPatternDimColor);
         ls_124 = "HAR_O_" + "pattern_dim_CD" + iBarShift(Symbol(), Period(), ai_16) + "_" + DateTimeReformat(TimeToStr(ai_16, TIME_DATE|TIME_MINUTES));
         ObjectDelete(ls_124);
         ObjectCreate(ls_124, OBJ_TEXT, 0, ai_52, ad_56);
         ObjectSetText(ls_124, DoubleToStr(ld_88, 0) + " (" + DoubleToStr(li_108, 0) + ")", li_112, "Tahoma", cextPatternDimColor);
      } else {
         if (ai_0 == -1) {
            ls_124 = "HAR_O_" + "pattern_dim_XA" + iBarShift(Symbol(), Period(), ai_4) + "_" + DateTimeReformat(TimeToStr(ai_4, TIME_DATE|TIME_MINUTES));
            ObjectDelete(ls_124);
            ObjectCreate(ls_124, OBJ_TEXT, 0, ai_16, ad_20);
            ObjectSetText(ls_124, DoubleToStr(ld_64, 0) + " (" + DoubleToStr(li_96, 0) + ")", li_112, "Tahoma", cextPatternDimColor);
            ls_124 = "HAR_O_" + "pattern_dim_AB" + iBarShift(Symbol(), Period(), ai_16) + "_" + DateTimeReformat(TimeToStr(ai_16, TIME_DATE|TIME_MINUTES));
            ObjectDelete(ls_124);
            ObjectCreate(ls_124, OBJ_TEXT, 0, ai_28, ad_32 + ld_116);
            ObjectSetText(ls_124, DoubleToStr(ld_72, 0) + " (" + DoubleToStr(li_100, 0) + ")", li_112, "Tahoma", cextPatternDimColor);
            ls_124 = "HAR_O_" + "pattern_dim_BC" + iBarShift(Symbol(), Period(), ai_16) + "_" + DateTimeReformat(TimeToStr(ai_16, TIME_DATE|TIME_MINUTES));
            ObjectDelete(ls_124);
            ObjectCreate(ls_124, OBJ_TEXT, 0, ai_40, ad_44);
            ObjectSetText(ls_124, DoubleToStr(ld_80, 0) + " (" + DoubleToStr(li_104, 0) + ")", li_112, "Tahoma", cextPatternDimColor);
            ls_124 = "HAR_O_" + "pattern_dim_CD" + iBarShift(Symbol(), Period(), ai_16) + "_" + DateTimeReformat(TimeToStr(ai_16, TIME_DATE|TIME_MINUTES));
            ObjectDelete(ls_124);
            ObjectCreate(ls_124, OBJ_TEXT, 0, ai_52, ad_56 + ld_116);
            ObjectSetText(ls_124, DoubleToStr(ld_88, 0) + " (" + DoubleToStr(li_108, 0) + ")", li_112, "Tahoma", cextPatternDimColor);
         }
      }
   }
}

void DrawOne2OneDimentions(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32, int ai_40, double ad_44, int ai_52, double ad_56) {
   string ls_100;
   double ld_64 = MathAbs(ad_20 - ad_32) / Point;
   double ld_72 = MathAbs(ad_44 - ad_56) / Point;
   int li_80 = iBarShift(Symbol(), Period(), ai_16) - iBarShift(Symbol(), Period(), ai_28);
   int li_84 = iBarShift(Symbol(), Period(), ai_40) - iBarShift(Symbol(), Period(), ai_52);
   int li_88 = 12;
   double ld_92 = LabelOffset(li_88 + 12);
   if (bextDrawPatternDim != FALSE) {
      if (ai_0 == 1) {
         ls_100 = "HAR_O_" + "pattern_One2One_dim_DE" + iBarShift(Symbol(), Period(), ai_52) + "_" + DateTimeReformat(TimeToStr(ai_52, TIME_DATE|TIME_MINUTES));
         ObjectDelete(ls_100);
         ObjectCreate(ls_100, OBJ_TEXT, 0, ai_52, ad_56);
         ObjectSetText(ls_100, DoubleToStr(ld_72, 0) + " (" + DoubleToStr(li_84, 0) + ")", li_88, "Tahoma", cextPatternDimColor);
         ls_100 = "HAR_O_" + "pattern_One2One_dim_BC" + iBarShift(Symbol(), Period(), ai_28) + "_" + DateTimeReformat(TimeToStr(ai_28, TIME_DATE|TIME_MINUTES));
         ObjectDelete(ls_100);
         ObjectCreate(ls_100, OBJ_TEXT, 0, ai_28, ad_32);
         ObjectSetText(ls_100, DoubleToStr(ld_64, 0) + " (" + DoubleToStr(li_80, 0) + ")", li_88, "Tahoma", cextPatternDimColor);
      } else {
         if (ai_0 == -1) {
            ls_100 = "HAR_O_" + "pattern_One2One_dim_DE" + iBarShift(Symbol(), Period(), ai_52) + "_" + DateTimeReformat(TimeToStr(ai_52, TIME_DATE|TIME_MINUTES));
            ObjectDelete(ls_100);
            ObjectCreate(ls_100, OBJ_TEXT, 0, ai_52, ad_56 + ld_92);
            ObjectSetText(ls_100, DoubleToStr(ld_72, 0) + " (" + DoubleToStr(li_84, 0) + ")", li_88, "Tahoma", cextPatternDimColor);
            ls_100 = "HAR_O_" + "pattern_One2One_dim_BC" + iBarShift(Symbol(), Period(), ai_28) + "_" + DateTimeReformat(TimeToStr(ai_28, TIME_DATE|TIME_MINUTES));
            ObjectDelete(ls_100);
            ObjectCreate(ls_100, OBJ_TEXT, 0, ai_28, ad_32 + ld_92);
            ObjectSetText(ls_100, DoubleToStr(ld_64, 0) + " (" + DoubleToStr(li_80, 0) + ")", li_88, "Tahoma", cextPatternDimColor);
         }
      }
   }
}

void CreatePatternIdentityObject(int ai_0, double ad_4, color ai_12, string as_16, string as_24) {
   string ls_32 = "HAR_O_" + "pattern" + as_24 + "_" + as_16 + "_bars" + iBarShift(Symbol(), Period(), ai_0) + "_" + DateTimeReformat(TimeToStr(ai_0, TIME_DATE|TIME_MINUTES));
   ObjectDelete(ls_32);
   ObjectCreate(ls_32, OBJ_TEXT, 0, ai_0, ad_4);
   ObjectSetText(ls_32, ".", 2, "Georgia", ai_12);
   ObjectSet(ls_32, OBJPROP_COLOR, extBackgroundColor);
}

void ScreenshotNewObjects() {
   string ls_0;
   string ls_8;
   int li_28;
   int li_16 = ObjectsTotal();
   for (int li_20 = 0; li_20 < 90; li_20++) {
      if (gia_952[li_20] < gia_948[li_20]) {
         for (int li_24 = 0; li_24 < li_16; li_24++) {
            ls_0 = ObjectName(li_24);
            ls_8 = gsa_956[li_20][1];
            if (StringFind(ls_0, "HAR_O_" + "pattern") >= 0 && StringFind(ls_0, ls_8) >= 0) {
               li_28 = iBarShift(Symbol(), Period(), ObjectGet(ls_0, OBJPROP_TIME1));
               ls_0 = StringReplaceDoubleDots(ls_0);
               WindowScreenShot(sextSaveImageDestinationDir + Symbol() + "_" + PeriodDesc(Period()) + ls_0 + "_start" + ".gif", 1200, 600, 0, -1, -1);
            }
         }
      }
   }
}

void ScreenshotLostObjects() {
   string ls_0;
   string ls_8;
   int li_28;
   int li_16 = ObjectsTotal();
   for (int li_20 = 0; li_20 < 90; li_20++) {
      if (gia_952[li_20] > gia_948[li_20]) {
         for (int li_24 = 0; li_24 < li_16; li_24++) {
            ls_0 = ObjectName(li_24);
            ls_8 = gsa_956[li_20][1];
            if (StringFind(ls_0, "HAR_O_" + "pattern") >= 0 && StringFind(ls_0, ls_8) >= 0) {
               li_28 = iBarShift(Symbol(), Period(), ObjectGet(ls_0, OBJPROP_TIME1));
               ls_0 = StringReplaceDoubleDots(ls_0);
               WindowScreenShot(sextSaveImageDestinationDir + Symbol() + "_" + PeriodDesc(Period()) + ls_0 + "_stop" + ".gif", 1200, 600, 0, -1, -1);
            }
         }
      }
   }
}

string StringReplaceDoubleDots(string as_0) {
   int li_8 = StringFind(as_0, ":");
   if (li_8 != -1) as_0 = StringSetChar(as_0, li_8, '_');
   return (as_0);
}

bool IsIt(string as_0) {
   string ls_8 = Symbol();
   if (StringFind(ls_8, as_0) == -1) return (FALSE);
   return (TRUE);
}

int DefaultMinSwing() {
   int li_0 = 1;
   for (int li_4 = 0; li_4 < gi_968; li_4++) {
      if (gsa_960[li_4][0] == Symbol()) {
         if (StrToInteger(gsa_960[li_4][1]) < Digits) li_0 = 10;
         switch (Period()) {
         case PERIOD_M1:
            return (StrToInteger(gsa_960[li_4][2]) * li_0);
         case PERIOD_M5:
            return (StrToInteger(gsa_960[li_4][3]) * li_0);
         case PERIOD_M15:
            return (StrToInteger(gsa_960[li_4][4]) * li_0);
         case PERIOD_M30:
            return (StrToInteger(gsa_960[li_4][5]) * li_0);
         case PERIOD_H1:
            return (StrToInteger(gsa_960[li_4][6]) * li_0);
         case PERIOD_H4:
            return (StrToInteger(gsa_960[li_4][7]) * li_0);
         case PERIOD_D1:
            return (StrToInteger(gsa_960[li_4][8]) * li_0);
         case PERIOD_W1:
            return (StrToInteger(gsa_960[li_4][9]) * li_0);
         case PERIOD_MN1:
            return (StrToInteger(gsa_960[li_4][10]) * li_0);
         }
         Alert("PANIC:!!! cannot set iextHL_MinSwing for this period");
      }
   }
   string ls_12 = Symbol();
   if (IsIt("EURUSD") || IsIt("GBPUSD") || IsIt("EURCAD") || IsIt("EURCAD") || IsIt("EURAUD") || IsIt("GBPUSD") || IsIt("GBPCHF") || IsIt("GBPCAD") || IsIt("GBPAUD") ||
      IsIt("AUDCHF") || IsIt("AUDCAD") || IsIt("AUDNZD") || IsIt("AUDCHF") || IsIt("NZDCHF") || IsIt("USDCHF") || IsIt("USDCAD") || IsIt("AUDUSD") || IsIt("NZDUSD") || IsIt("CADCHF")) {
      if (Digits == 4) li_0 = 1;
      else {
         if (Digits == 5) li_0 = 10;
         else Alert("PANIC:!!! Unknown Digits number(not 4 or 5)");
      }
      switch (Period()) {
      case PERIOD_M1:
         return (20 * li_0);
      case PERIOD_M5:
         return (40 * li_0);
      case PERIOD_M15:
         return (70 * li_0);
      case PERIOD_M30:
         return (120 * li_0);
      case PERIOD_H1:
         return (160 * li_0);
      case PERIOD_H4:
         return (300 * li_0);
      case PERIOD_D1:
         return (550 * li_0);
      case PERIOD_W1:
         return (1250 * li_0);
      case PERIOD_MN1:
         return (2100 * li_0);
      }
      Alert("PANIC:!!! cannot set iextHL_MinSwing for this period");
   } else {
      if (IsIt("EURGBP") || IsIt("EURCHF")) {
         if (Digits == 4) li_0 = 1;
         else {
            if (Digits == 5) li_0 = 10;
            else Alert("PANIC:!!! Unknown Digits number(not 4 or 5)");
         }
         switch (Period()) {
         case PERIOD_M1:
            return (20 * li_0);
         case PERIOD_M5:
            return (30 * li_0);
         case PERIOD_M15:
            return (55 * li_0);
         case PERIOD_M30:
            return (80 * li_0);
         case PERIOD_H1:
            return (100 * li_0);
         case PERIOD_H4:
            return (150 * li_0);
         case PERIOD_D1:
            return (230 * li_0);
         case PERIOD_W1:
            return (700 * li_0);
         case PERIOD_MN1:
            return (1300 * li_0);
         }
         Alert("PANIC:!!! cannot set iextHL_MinSwing for this period");
      } else {
         if (IsIt("EURNZD") || IsIt("GBPNZD")) {
            if (Digits == 4) li_0 = 1;
            else {
               if (Digits == 5) li_0 = 10;
               else Alert("PANIC:!!! Unknown Digits number(not 4 or 5)");
            }
            switch (Period()) {
            case PERIOD_M1:
               return (20 * li_0);
            case PERIOD_M5:
               return (50 * li_0);
            case PERIOD_M15:
               return (90 * li_0);
            case PERIOD_M30:
               return (200 * li_0);
            case PERIOD_H1:
               return (250 * li_0);
            case PERIOD_H4:
               return (550 * li_0);
            case PERIOD_D1:
               return (1300 * li_0);
            case PERIOD_W1:
               return (2500 * li_0);
            case PERIOD_MN1:
               return (4000 * li_0);
            }
            Alert("PANIC:!!! cannot set iextHL_MinSwing for this period");
         } else {
            if (IsIt("GBPJPY")) {
               if (Digits == 2) li_0 = 1;
               else {
                  if (Digits == 3) li_0 = 10;
                  else Alert("PANIC:!!! Unknown Digits number(not 2 or 3)");
               }
               switch (Period()) {
               case PERIOD_M1:
                  return (20 * li_0);
               case PERIOD_M5:
                  return (50 * li_0);
               case PERIOD_M15:
                  return (90 * li_0);
               case PERIOD_M30:
                  return (200 * li_0);
               case PERIOD_H1:
                  return (250 * li_0);
               case PERIOD_H4:
                  return (550 * li_0);
               case PERIOD_D1:
                  return (1300 * li_0);
               case PERIOD_W1:
                  return (2500 * li_0);
               case PERIOD_MN1:
                  return (4000 * li_0);
               }
               Alert("PANIC:!!! cannot set iextHL_MinSwing for this period");
            } else {
               if (IsIt("USDJPY") || IsIt("EURJPY") || IsIt("CHFJPY") || IsIt("CADJPY") || IsIt("AUDJPY") || IsIt("NZDJPY")) {
                  if (Digits == 2) li_0 = 1;
                  else {
                     if (Digits == 3) li_0 = 10;
                     else Alert("PANIC:!!! Unknown Digits number(not 2 or 3)");
                  }
                  switch (Period()) {
                  case PERIOD_M1:
                     return (20 * li_0);
                  case PERIOD_M5:
                     return (40 * li_0);
                  case PERIOD_M15:
                     return (70 * li_0);
                  case PERIOD_M30:
                     return (120 * li_0);
                  case PERIOD_H1:
                     return (160 * li_0);
                  case PERIOD_H4:
                     return (300 * li_0);
                  case PERIOD_D1:
                     return (550 * li_0);
                  case PERIOD_W1:
                     return (1250 * li_0);
                  case PERIOD_MN1:
                     return (2100 * li_0);
                  }
                  Alert("PANIC:!!! cannot set iextHL_MinSwing for this period");
               } else {
                  if (IsIt("GOLD")) {
                     if (Digits == 2) li_0 = 1;
                     else {
                        if (Digits == 3) li_0 = 10;
                        else Alert("PANIC:!!! Unknown Digits number(not 2 or 3)");
                     }
                     switch (Period()) {
                     case PERIOD_M1:
                        return (200 * li_0);
                     case PERIOD_M5:
                        return (400 * li_0);
                     case PERIOD_M15:
                        return (700 * li_0);
                     case PERIOD_M30:
                        return (1400 * li_0);
                     case PERIOD_H1:
                        return (3000 * li_0);
                     case PERIOD_H4:
                        return (9000 * li_0);
                     case PERIOD_D1:
                        return (12000 * li_0);
                     case PERIOD_W1:
                        return (30000 * li_0);
                     case PERIOD_MN1:
                        return (30000 * li_0);
                     }
                     Alert("PANIC:!!! cannot set iextHL_MinSwing for this period");
                  } else {
                     if (IsIt("SILVER")) {
                        if (Digits == 3) li_0 = 1;
                        else {
                           if (Digits == 4) li_0 = 10;
                           else Alert("PANIC:!!! Unknown Digits number(not 2 or 3)");
                        }
                        switch (Period()) {
                        case PERIOD_M1:
                           return (60 * li_0);
                        case PERIOD_M5:
                           return (100 * li_0);
                        case PERIOD_M15:
                           return (300 * li_0);
                        case PERIOD_M30:
                           return (500 * li_0);
                        case PERIOD_H1:
                           return (750 * li_0);
                        case PERIOD_H4:
                           return (1000 * li_0);
                        case PERIOD_D1:
                           return (2000 * li_0);
                        case PERIOD_W1:
                           return (6000 * li_0);
                        case PERIOD_MN1:
                           return (9000 * li_0);
                        }
                        Alert("PANIC:!!! cannot set iextHL_MinSwing for this period");
                     } else {
                        if (IsIt("USDJPY") || IsIt("EURJPY") || IsIt("CHFJPY") || IsIt("CADJPY") || IsIt("AUDJPY") || IsIt("NZDJPY")) {
                           if (Digits == 2) li_0 = 1;
                           else {
                              if (Digits == 3) li_0 = 10;
                              else Alert("PANIC:!!! Unknown Digits number(not 2 or 3)");
                           }
                           switch (Period()) {
                           case PERIOD_M1:
                              return (20 * li_0);
                           case PERIOD_M5:
                              return (40 * li_0);
                           case PERIOD_M15:
                              return (70 * li_0);
                           case PERIOD_M30:
                              return (120 * li_0);
                           case PERIOD_H1:
                              return (160 * li_0);
                           case PERIOD_H4:
                              return (300 * li_0);
                           case PERIOD_D1:
                              return (550 * li_0);
                           case PERIOD_W1:
                              return (1250 * li_0);
                           case PERIOD_MN1:
                              return (2100 * li_0);
                           }
                           Alert("PANIC:!!! cannot set iextHL_MinSwing for this period");
                        } else {
                           if (Digits == 2 || Digits == 4) li_0 = 1;
                           else {
                              if (Digits == 3 || Digits == 5) li_0 = 10;
                              else return (-1);
                           }
                           switch (Period()) {
                           case PERIOD_M1:
                              return (20 * li_0);
                           case PERIOD_M5:
                              return (40 * li_0);
                           case PERIOD_M15:
                              return (70 * li_0);
                           case PERIOD_M30:
                              return (170 * li_0);
                           case PERIOD_H1:
                              return (200 * li_0);
                           case PERIOD_H4:
                              return (400 * li_0);
                           case PERIOD_D1:
                              return (650 * li_0);
                           case PERIOD_W1:
                              return (1200 * li_0);
                           case PERIOD_MN1:
                              return (2500 * li_0);
                           }
                           Alert("PANIC:!!! cannot set iextHL_MinSwing for this period");
                        }
                     }
                  }
               }
            }
         }
      }
   }
   return (-1);
}

void HAR_FoundPatterns_Init() {
   for (int li_0 = 0; li_0 < 90; li_0++) {
      gia_948[li_0] = 0;
      gia_952[li_0] = 0;
   }
}

void HAR_FoundPatterns_Reset() {
   for (int li_0 = 0; li_0 < 90; li_0++) gia_948[li_0] = 0;
}

void HAR_FoundPatterns_Increase(int ai_0) {
   gia_948[ai_0]++;
}

string HAR_FoundPatterns_ShowSettings() {
   string ls_40;
   int li_0 = 0;
   string ls_8 = "Bars:" + iextMaxBars + "  Swing:" + iextHL_MinSwing + "  ZZ:" + gi_112 + "  Used:" + iextMaxZZPointsUsed;
   if (bextShowHistoryPatterns) ls_8 = ls_8 + "  History: ON";
   else ls_8 = ls_8 + "  History: OFF";
   string ls_16 = "Dev:" + DoubleToStr(dextMaxDeviation, 1);
   if (bextCheckMultiZigzags == TRUE) {
      ls_16 = ls_16 + "  MultiZZ: ON";
      ls_16 = ls_16 + "  Range: (" + DoubleToStr(iextHL_MinSwing - dextHL_MultiZZMinSwingRange * iextHL_MinSwing, 0) + "," + DoubleToStr(iextHL_MinSwing + dextHL_MultiZZMinSwingRange * iextHL_MinSwing, 0) + ")";
      ls_16 = ls_16 + "  Step:" + (iextHL_MinSwing / iextHL_MultiZZMinSwingNum);
   } else ls_16 = ls_16 + "  MultiZZ: OFF";
   string ls_24 = "Found patterns:";
   string ls_32 = "Mon:";
   Comment(ls_8 + " " + ls_16, 
   "\n", "" + ls_24);
   return ("");
}

string HAR_FoundPatterns_ShowPatterns() {
   string ls_8;
   string ls_16;
   int li_0 = 0;
   for (int li_4 = 1; li_4 < 90; li_4++) {
      ls_16 = "HAR_S_" + "found_pattern_" + li_4;
      ObjectDelete(ls_16);
      if (gia_948[li_4] > 0) {
         ObjectCreate(ls_16, OBJ_LABEL, 0, 0, 0);
         ObjectSet(ls_16, OBJPROP_XDISTANCE, 7);
         ObjectSet(ls_16, OBJPROP_YDISTANCE, 12 * li_0 + 33);
         if (bextShowHistoryPatterns == FALSE) ls_8 = "-" + gsa_956[li_4][0];
         else ls_8 = "-" + gsa_956[li_4][0] + " x " + gia_948[li_4];
         if (StringFind(gsa_956[li_4][0], "Bullish") > -1) {
            if (StringFind(gsa_956[li_4][0], "Emerging") > -1) ObjectSetText(ls_16, ls_8, 10, "Tahoma", cextEmergingBullishColor);
            else ObjectSetText(ls_16, ls_8, 9, "Tahoma", LimeGreen);
         } else {
            if (StringFind(gsa_956[li_4][0], "Bearish") > -1) {
               if (StringFind(gsa_956[li_4][0], "Emerging") > -1) ObjectSetText(ls_16, ls_8, 10, "Tahoma", cextEmergingBearishColor);
               else ObjectSetText(ls_16, ls_8, 9, "Tahoma", Red);
            } else ObjectSetText(ls_16, ls_8, 9, "Tahoma", extTextColor);
         }
         li_0++;
      }
   }
   return ("");
}

void HAR_FoundPatterns_StoreCurr() {
   for (int li_0 = 0; li_0 < 90; li_0++) gia_952[li_0] = gia_948[li_0];
}

int HAR_FoundPatterns_IsChanged() {
   for (int li_0 = 0; li_0 < 90; li_0++)
      if (gia_952[li_0] != gia_948[li_0]) return (1);
   return (0);
}

int HAR_FoundPatterns_Alert(int ai_0) {
   string ls_32;
   string ls_8 = " ";
   string ls_16 = " ";
   int li_24 = 0;
   int li_28 = 0;
   for (int li_4 = 0; li_4 < 90; li_4++) {
      if (li_4 != 62) {
         if (gia_952[li_4] < gia_948[li_4]) {
            if (li_24 > 0) ls_8 = ls_8 + ",";
            ls_8 = ls_8 + gsa_956[li_4][0];
            li_24++;
         }
         if (gia_952[li_4] > gia_948[li_4] && bextAlertInvalidatedPatterns) {
            if (li_28 > 0) ls_16 = ls_16 + ",";
            ls_16 = ls_16 + gsa_956[li_4][0];
            li_28++;
         }
      }
   }
   if (li_24 == 0 && li_28 == 0) return (0);
   if (li_24 > 0) ls_32 = ls_8 + " found";
   if (li_24 > 0 && li_28 > 0) ls_32 = ls_32 + ", ";
   if (li_28 > 0) ls_32 = ls_32 + ls_16 + " invalidated";
   ls_32 = "INFO:" + "korHarmonics" + ":" + Symbol() + ":" + PeriodDesc(Period()) + ":" + ls_32;
   if (ai_0 == 0) Alert(ls_32);
   if (ai_0 == 4) SendMail(ls_32, ls_32);
   return (0);
}

int LoadMinSwingDefaults(string as_0) {
   string ls_8 = 0;
   gi_968 = 0;
   int li_16 = InitInputFile(as_0);
   if (li_16 < 1) return (1);
   while (!FileIsEnding(li_16)) {
      ls_8 = FileReadString(li_16);
      if (ls_8 != "") {
         if (ls_8 == "symbol") {
            FileReadString(li_16);
            FileReadString(li_16);
            FileReadString(li_16);
            FileReadString(li_16);
            FileReadString(li_16);
            FileReadString(li_16);
            FileReadString(li_16);
            FileReadString(li_16);
            FileReadString(li_16);
            FileReadString(li_16);
         } else {
            gsa_960[gi_968][0] = ls_8;
            gsa_960[gi_968][1] = FileReadString(li_16);
            gsa_960[gi_968][2] = FileReadString(li_16);
            gsa_960[gi_968][3] = FileReadString(li_16);
            gsa_960[gi_968][4] = FileReadString(li_16);
            gsa_960[gi_968][5] = FileReadString(li_16);
            gsa_960[gi_968][6] = FileReadString(li_16);
            gsa_960[gi_968][7] = FileReadString(li_16);
            gsa_960[gi_968][8] = FileReadString(li_16);
            gsa_960[gi_968][9] = FileReadString(li_16);
            gsa_960[gi_968][10] = FileReadString(li_16);
            gi_968++;
            if (gi_968 >= 300) {
               Alert("WARNING:", "korHarmonics", ":", Symbol(), ":", PeriodDesc(Period()), ":", "Too many MinSwingDefaults. Only first ", 300, " loaded.");
               return (0);
            }
         }
      }
   }
   CloseFile(li_16);
   return (0);
}

int Is_EOne2OnePattern(double ad_0, double ad_8, double ad_16, double ad_24, double ad_32, double ad_40, int ai_48) {
   double ld_52 = MathAbs(ad_8 - ad_16);
   double ld_60 = MathAbs(ad_24 - ad_32);
   if (ad_24 - ad_0 == 0.0) return (0);
   double ld_68 = (ad_24 - ad_32) / (ad_24 - ad_0);
   if (gi_452) {
      if (gi_452 && (ad_0 < ad_8 && ad_0 < ad_16 && ad_0 < ad_24 && ad_0 < ad_32 && ad_8 > ad_16 && ad_8 < ad_24 && ad_16 < ad_24 && ad_24 > ad_32) && ad_32 < ad_8 && (ld_60 >= ld_52 * (1 - ad_40) &&
         ld_60 <= ld_52 * (ad_40 + 1.0)) && (ld_68 >= (1 - ad_40) / 2.0 && ld_68 <= (ad_40 + 1.0) / 2.0) || (ld_68 >= (1 - ad_40) / 2.0 && ld_68 <= (ad_40 + 1.0) / 2.0) || (ld_68 >= 0.618 * (1 - ad_40) && ld_68 <= 0.618 * (ad_40 +
         1.0))) {
         HAR_FoundPatterns_Increase(67);
         SIGMON_FoundPatterns_Set(23, 1);
         return (67);
      }
      if (gi_452 && (ad_0 > ad_8 && ad_0 > ad_16 && ad_0 > ad_24 && ad_0 > ad_32 && ad_8 < ad_16 && ad_8 > ad_24 && ad_16 > ad_24 && ad_16 > ad_32 && ad_24 < ad_32) && ad_32 > ad_8 &&
         (ld_60 >= ld_52 * (1 - ad_40) && ld_60 <= ld_52 * (ad_40 + 1.0)) && (ld_68 >= (1 - ad_40) / 2.0 && ld_68 <= (ad_40 + 1.0) / 2.0) || (ld_68 >= (1 - ad_40) / 2.0 && ld_68 <= (ad_40 +
         1.0) / 2.0) || (ld_68 >= 0.618 * (1 - ad_40) && ld_68 <= 0.618 * (ad_40 + 1.0))) {
         HAR_FoundPatterns_Increase(68);
         SIGMON_FoundPatterns_Set(23, -1);
         return (68);
      }
      if (gi_448 && (ad_0 < ad_8 && ad_0 < ad_16 && ad_0 < ad_24 && ad_0 < ad_32 && ad_8 > ad_16 && ad_8 < ad_24 && ad_16 < ad_24 && ad_24 > ad_32) && ad_32 < ad_8 && (ld_60 >= ld_52 * (1 - ad_40) &&
         ld_60 <= ld_52 * (ad_40 + 1.0))) {
         HAR_FoundPatterns_Increase(58);
         SIGMON_FoundPatterns_Set(19, 1);
         return (58);
      }
      if (gi_448 && (ad_0 > ad_8 && ad_0 > ad_16 && ad_0 > ad_24 && ad_0 > ad_32 && ad_8 < ad_16 && ad_8 > ad_24 && ad_16 > ad_24 && ad_16 > ad_32 && ad_24 < ad_32) && ad_32 > ad_8 &&
         (ld_60 >= ld_52 * (1 - ad_40) && ld_60 <= ld_52 * (ad_40 + 1.0))) {
         HAR_FoundPatterns_Increase(59);
         SIGMON_FoundPatterns_Set(19, -1);
         return (59);
      }
      if (gi_456 && (ad_0 < ad_8 && ad_0 < ad_16 && ad_0 < ad_24 && ad_0 < ad_32 && ad_8 > ad_16 && ad_8 < ad_24 && ad_16 < ad_24 && ad_24 > ad_32) && (ld_60 >= ld_52 * (1 - ad_40) &&
         ld_60 <= ld_52 * (ad_40 + 1.0))) {
         HAR_FoundPatterns_Increase(77);
         SIGMON_FoundPatterns_Set(27, 1);
         return (77);
      }
      if (gi_456 && (ad_0 > ad_8 && ad_0 > ad_16 && ad_0 > ad_24 && ad_0 > ad_32 && ad_8 < ad_16 && ad_8 > ad_24 && ad_16 > ad_24 && ad_16 > ad_32 && ad_24 < ad_32) && (ld_60 >= ld_52 * (1 - ad_40) &&
         ld_60 <= ld_52 * (ad_40 + 1.0))) {
         HAR_FoundPatterns_Increase(78);
         SIGMON_FoundPatterns_Set(27, -1);
         return (78);
      }
      if (gi_448 || gi_452 && ai_48 && (ad_0 < ad_8 && ad_0 < ad_16 && ad_0 < ad_24 && ad_0 < ad_32 && ad_8 > ad_16 && ad_8 < ad_24 && ad_16 < ad_24 && ad_24 > ad_32) &&
         ad_32 < ad_8 && (ld_60 >= dextEmergingPatternPerc * ld_52 && ld_60 <= ld_52 * (1 - ad_40) && MathAbs(ad_24 - Low[0]) >= dextEmergingPatternPerc * ld_52 && MathAbs(ad_24 - Low[0]) <= ld_52 * (1 - ad_40))) {
         HAR_FoundPatterns_Increase(69);
         SIGMON_FoundPatterns_Set(23, 2);
         return (69);
      }
      if (gi_448 || gi_452 && ai_48 && (ad_0 > ad_8 && ad_0 > ad_16 && ad_0 > ad_24 && ad_0 > ad_32 && ad_8 < ad_16 && ad_8 > ad_24 && ad_16 > ad_24 && ad_16 > ad_32 && ad_24 < ad_32) &&
         ad_32 > ad_8 && (ld_60 >= dextEmergingPatternPerc * ld_52 && ld_60 <= ld_52 * (1 - ad_40) && MathAbs(ad_32 - High[0]) >= dextEmergingPatternPerc * ld_52 && MathAbs(ad_24 - High[0]) <= ld_52 * (1 - ad_40))) {
         HAR_FoundPatterns_Increase(70);
         SIGMON_FoundPatterns_Set(23, -2);
         return (70);
      }
      if (gi_456 && ai_48 && (ad_0 < ad_8 && ad_0 < ad_16 && ad_0 < ad_24 && ad_0 < ad_32 && ad_8 > ad_16 && ad_8 < ad_24 && ad_16 < ad_24 && ad_24 > ad_32) && (ld_60 >= dextEmergingPatternPerc * ld_52 &&
         ld_60 <= ld_52 * (1 - ad_40) && MathAbs(ad_24 - Low[0]) >= dextEmergingPatternPerc * ld_52 && MathAbs(ad_24 - Low[0]) <= ld_52 * (1 - ad_40))) {
         HAR_FoundPatterns_Increase(79);
         SIGMON_FoundPatterns_Set(27, 2);
         return (79);
      }
      if (gi_456 && ai_48 && (ad_0 > ad_8 && ad_0 > ad_16 && ad_0 > ad_24 && ad_0 > ad_32 && ad_8 < ad_16 && ad_8 > ad_24 && ad_16 > ad_24 && ad_16 > ad_32 && ad_24 < ad_32) &&
         (ld_60 >= dextEmergingPatternPerc * ld_52 && ld_60 <= ld_52 * (1 - ad_40) && MathAbs(ad_32 - High[0]) >= dextEmergingPatternPerc * ld_52 && MathAbs(ad_24 - High[0]) <= ld_52 * (1 - ad_40))) {
         HAR_FoundPatterns_Increase(80);
         SIGMON_FoundPatterns_Set(27, -2);
         return (80);
      }
   }
   return (0);
}

int Draw_EOne2OnePattern(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, int ai_28, double ad_32, int ai_40, double ad_44, int ai_52, double ad_56) {
   double ld_64;
   double ld_72;
   int li_80;
   int li_84;
   if (ad_44 - ad_8 == 0.0 || ad_44 - ad_32 == 0.0) return (0);
   string ls_88 = DoubleToStr((ad_44 - ad_56) / (ad_44 - ad_8), 3);
   string ls_96 = DoubleToStr((ad_44 - ad_56) / (ad_44 - ad_32), 3);
   if (ai_0 == 67 || ai_0 == 58) {
      DrawLine(ai_4, ad_8, ai_16, ad_20, cextOne2OneBullishColor, "SI", gsa_956[58][1], gi_880);
      DrawLine(ai_16, ad_20, ai_28, ad_32, cextOne2OneCorrBullishColor, "IX", gsa_956[58][1], gi_884);
      DrawLine(ai_28, ad_32, ai_40, ad_44, cextOne2OneBullishColor, "XT", gsa_956[58][1], gi_880);
      DrawLine(ai_40, ad_44, ai_52, ad_56, cextOne2OneCorrBullishColor, "TB", gsa_956[58][1], gi_884);
      CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_956[58][1], 58);
      DrawRelationLine(ai_4, ad_8, ai_52, ad_56, ls_88, DarkSlateGray, "relXD", gsa_956[58][1]);
      DrawRelationLine(ai_28, ad_32, ai_52, ad_56, ls_96, DarkSlateGray, "relBD", gsa_956[58][1]);
      if (gi_460) {
         SmartRetracementLines(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, Yellow, "TB=", "XT", 0, 5, "IX=TB", gsa_956[58][1], gi_864);
         SmartRetracementLines(ai_4, ad_8, ai_40, ad_44, ai_52, ad_56, Orange, "TB=", "ST", 0, 5, "IX=TB", gsa_956[58][1], gi_864);
      }
      ld_64 = MathAbs(ad_20 - ad_32) / Point;
      ld_72 = MathAbs(ad_44 - ad_56) / Point;
      li_80 = iBarShift(Symbol(), Period(), ai_16) - iBarShift(Symbol(), Period(), ai_28);
      li_84 = iBarShift(Symbol(), Period(), ai_40) - iBarShift(Symbol(), Period(), ai_52);
      if (ai_0 == 67) {
         DrawEntryBox(1, ai_40, ad_44 + (ad_32 - ad_20) * (1 - dextMaxOne2OneDeviation), ai_52 + 60 * (10 * Period()), ad_44 + (ad_32 - ad_20) * (dextMaxOne2OneDeviation +
            1.0), Green, LimeGreen, "121EB", gsa_956[59][1], DoubleToStr((ad_44 - ad_56) / Point - (ad_20 - ad_32) / Point, 0), "AB:" + DoubleToStr(ld_64, 0) + "," + li_80 + " CD:" +
            DoubleToStr(ld_72, 0) + "," + li_84, "E 121");
      } else {
         if (ai_0 == 58) {
            DrawEntryBox(1, ai_40, ad_44 + (ad_32 - ad_20) * (1 - dextMaxOne2OneDeviation), ai_52 + 60 * (10 * Period()), ad_44 + (ad_32 - ad_20) * (dextMaxOne2OneDeviation +
               1.0), Green, LimeGreen, "121EB", gsa_956[59][1], DoubleToStr((ad_44 - ad_56) / Point - (ad_20 - ad_32) / Point, 0), "AB:" + DoubleToStr(ld_64, 0) + "," + li_80 + " CD:" +
               DoubleToStr(ld_72, 0) + "," + li_84, "121");
         }
      }
   } else {
      if (ai_0 == 68 || ai_0 == 59) {
         DrawLine(ai_4, ad_8, ai_16, ad_20, cextOne2OneBearishColor, "SI", gsa_956[59][1], gi_880);
         DrawLine(ai_16, ad_20, ai_28, ad_32, cextOne2OneCorrBearishColor, "IX", gsa_956[59][1], gi_884);
         DrawLine(ai_28, ad_32, ai_40, ad_44, cextOne2OneBearishColor, "XT", gsa_956[59][1], gi_880);
         DrawLine(ai_40, ad_44, ai_52, ad_56, cextOne2OneCorrBearishColor, "TB", gsa_956[59][1], gi_884);
         CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_956[59][1], 59);
         DrawRelationLine(ai_4, ad_8, ai_52, ad_56, ls_88, DarkSlateGray, "relXD", gsa_956[58][1]);
         DrawRelationLine(ai_28, ad_32, ai_52, ad_56, ls_96, DarkSlateGray, "relBD", gsa_956[58][1]);
         if (gi_460) {
            SmartRetracementLines(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, Yellow, "TB=", "XT", 0, 5, "IX=TB", gsa_956[59][1], gi_864);
            SmartRetracementLines(ai_4, ad_8, ai_40, ad_44, ai_52, ad_56, Orange, "TB=", "ST", 0, 5, "IX=TB", gsa_956[59][1], gi_864);
         }
         ld_64 = MathAbs(ad_20 - ad_32) / Point;
         ld_72 = MathAbs(ad_44 - ad_56) / Point;
         li_80 = iBarShift(Symbol(), Period(), ai_16) - iBarShift(Symbol(), Period(), ai_28);
         li_84 = iBarShift(Symbol(), Period(), ai_40) - iBarShift(Symbol(), Period(), ai_52);
         if (ai_0 == 68) {
            DrawEntryBox(-1, ai_40, ad_44 + (ad_32 - ad_20) * (1 - dextMaxOne2OneDeviation), ai_52 + 60 * (10 * Period()), ad_44 + (ad_32 - ad_20) * (dextMaxOne2OneDeviation +
               1.0), C'0x77,0x0B,0x20', C'0xD6,0x14,0x3A', "121EB", gsa_956[59][1], DoubleToStr((ad_20 - ad_32) / Point - (ad_44 - ad_56) / Point, 0), "AB:" + DoubleToStr(ld_64, 0) +
               "," + li_80 + " CD:" + DoubleToStr(ld_72, 0) + "," + li_84, "E 121");
         } else {
            if (ai_0 == 59) {
               DrawEntryBox(-1, ai_40, ad_44 + (ad_32 - ad_20) * (1 - dextMaxOne2OneDeviation), ai_52 + 60 * (10 * Period()), ad_44 + (ad_32 - ad_20) * (dextMaxOne2OneDeviation +
                  1.0), C'0x77,0x0B,0x20', C'0xD6,0x14,0x3A', "121EB", gsa_956[59][1], DoubleToStr((ad_20 - ad_32) / Point - (ad_44 - ad_56) / Point, 0), "AB:" + DoubleToStr(ld_64, 0) +
                  "," + li_80 + " CD:" + DoubleToStr(ld_72, 0) + "," + li_84, "121");
            }
         }
      }
   }
   if (ai_0 == 77) {
      DrawLine(ai_4, ad_8, ai_16, ad_20, cextOne2OneBullishColor, "SI", gsa_956[58][1], gi_880);
      DrawLine(ai_16, ad_20, ai_28, ad_32, cextSOne2OneCorrBullishColor, "IX", gsa_956[58][1], gi_884);
      DrawLine(ai_28, ad_32, ai_40, ad_44, cextOne2OneBullishColor, "XT", gsa_956[58][1], gi_880);
      DrawLine(ai_40, ad_44, ai_52, ad_56, cextSOne2OneCorrBullishColor, "TB", gsa_956[58][1], gi_884);
      CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_956[58][1], 58);
      DrawRelationLine(ai_4, ad_8, ai_52, ad_56, ls_88, DarkSlateGray, "relXD", gsa_956[58][1]);
      DrawRelationLine(ai_28, ad_32, ai_52, ad_56, ls_96, DarkSlateGray, "relBD", gsa_956[58][1]);
      if (gi_460) {
         SmartRetracementLines(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, Yellow, "TB=", "XT", 0, 5, "IX=TB", gsa_956[58][1], gi_864);
         SmartRetracementLines(ai_4, ad_8, ai_40, ad_44, ai_52, ad_56, Orange, "TB=", "ST", 0, 5, "IX=TB", gsa_956[58][1], gi_864);
      }
      ld_64 = MathAbs(ad_20 - ad_32) / Point;
      ld_72 = MathAbs(ad_44 - ad_56) / Point;
      li_80 = iBarShift(Symbol(), Period(), ai_16) - iBarShift(Symbol(), Period(), ai_28);
      li_84 = iBarShift(Symbol(), Period(), ai_40) - iBarShift(Symbol(), Period(), ai_52);
      DrawEntryBox(1, ai_40, ad_44 + (ad_32 - ad_20) * (1 - dextMaxOne2OneDeviation), ai_52 + 60 * (10 * Period()), ad_44 + (ad_32 - ad_20) * (dextMaxOne2OneDeviation +
         1.0), Green, LimeGreen, "121EB", gsa_956[59][1], DoubleToStr((ad_44 - ad_56) / Point - (ad_20 - ad_32) / Point, 0), "AB:" + DoubleToStr(ld_64, 0) + "," + li_80 + " CD:" +
         DoubleToStr(ld_72, 0) + "," + li_84, "S 121");
   } else {
      if (ai_0 == 78) {
         DrawLine(ai_4, ad_8, ai_16, ad_20, cextOne2OneBearishColor, "SI", gsa_956[59][1], gi_880);
         DrawLine(ai_16, ad_20, ai_28, ad_32, cextSOne2OneCorrBearishColor, "IX", gsa_956[59][1], gi_884);
         DrawLine(ai_28, ad_32, ai_40, ad_44, cextOne2OneBearishColor, "XT", gsa_956[59][1], gi_880);
         DrawLine(ai_40, ad_44, ai_52, ad_56, cextSOne2OneCorrBearishColor, "TB", gsa_956[59][1], gi_884);
         CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_956[59][1], 59);
         DrawRelationLine(ai_4, ad_8, ai_52, ad_56, ls_88, DarkSlateGray, "relXD", gsa_956[58][1]);
         DrawRelationLine(ai_28, ad_32, ai_52, ad_56, ls_96, DarkSlateGray, "relBD", gsa_956[58][1]);
         if (gi_460) {
            SmartRetracementLines(ai_28, ad_32, ai_40, ad_44, ai_52, ad_56, Yellow, "TB=", "XT", 0, 5, "IX=TB", gsa_956[59][1], gi_864);
            SmartRetracementLines(ai_4, ad_8, ai_40, ad_44, ai_52, ad_56, Orange, "TB=", "ST", 0, 5, "IX=TB", gsa_956[59][1], gi_864);
         }
         ld_64 = MathAbs(ad_20 - ad_32) / Point;
         ld_72 = MathAbs(ad_44 - ad_56) / Point;
         li_80 = iBarShift(Symbol(), Period(), ai_16) - iBarShift(Symbol(), Period(), ai_28);
         li_84 = iBarShift(Symbol(), Period(), ai_40) - iBarShift(Symbol(), Period(), ai_52);
         DrawEntryBox(-1, ai_40, ad_44 + (ad_32 - ad_20) * (1 - dextMaxOne2OneDeviation), ai_52 + 60 * (10 * Period()), ad_44 + (ad_32 - ad_20) * (dextMaxOne2OneDeviation +
            1.0), C'0x77,0x0B,0x20', C'0xD6,0x14,0x3A', "121EB", gsa_956[59][1], DoubleToStr((ad_20 - ad_32) / Point - (ad_44 - ad_56) / Point, 0), "AB:" + DoubleToStr(ld_64, 0) +
            "," + li_80 + " CD:" + DoubleToStr(ld_72, 0) + "," + li_84, "S 121");
      } else {
         if (ai_0 == 69 || ai_0 == 79) {
            DrawLine(ai_4, ad_8, ai_16, ad_20, cextOne2OneBullishColor, "SI", gsa_956[60][1], gi_880);
            DrawLine(ai_16, ad_20, ai_28, ad_32, cextOne2OneCorrBullishColor, "IX", gsa_956[60][1], gi_884);
            DrawLine(ai_28, ad_32, ai_40, ad_44, cextOne2OneBullishColor, "XT", gsa_956[60][1], gi_880);
            DrawLine(ai_40, ad_44, Time[0], ad_44 - (ad_20 - ad_32), cextEmergingBullishColor, "TB", gsa_956[60][1], gi_884);
            CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_956[58][1], 58);
            ProjectionLine(ai_52, ad_44 - (ad_20 - ad_32), cextOne2OneCorrBullishColor, "IX=TB", 0, 4, "IX=TB", gsa_956[58][1], gi_864);
            if (gi_460) {
               SmartRetracementLines(ai_28, ad_32, ai_40, ad_44, ai_52, ad_44 - (ad_20 - ad_32), Yellow, "TB=", "XT", 0, 5, "IX=TB", gsa_956[58][1], gi_864);
               SmartRetracementLines(ai_4, ad_8, ai_40, ad_44, ai_52, ad_44 - (ad_20 - ad_32), Orange, "TB=", "ST", 0, 5, "IX=TB", gsa_956[58][1], gi_864);
            }
            DrawOne2OneDimentions(1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
         } else {
            if (ai_0 == 70 || ai_0 == 79) {
               DrawLine(ai_4, ad_8, ai_16, ad_20, cextOne2OneBearishColor, "SI", gsa_956[61][1], gi_880);
               DrawLine(ai_16, ad_20, ai_28, ad_32, cextOne2OneCorrBearishColor, "IX", gsa_956[61][1], gi_884);
               DrawLine(ai_28, ad_32, ai_40, ad_44, cextOne2OneBearishColor, "XT", gsa_956[61][1], gi_880);
               DrawLine(ai_40, ad_44, Time[0], ad_44 - (ad_20 - ad_32), cextEmergingBullishColor, "TB", gsa_956[61][1], gi_884);
               CreatePatternIdentityObject(ai_4, ad_8, cextCorrDescColor, gsa_956[61][1], 61);
               ProjectionLine(ai_52, ad_44 - (ad_20 - ad_32), cextOne2OneCorrBullishColor, "IX=TB", 0, 4, "IX=TB", gsa_956[61][1], gi_864);
               if (gi_460) {
                  SmartRetracementLines(ai_28, ad_32, ai_40, ad_44, ai_52, ad_44 - (ad_20 - ad_32), Yellow, "TB=", "XT", 0, 5, "IX=TB", gsa_956[61][1], gi_864);
                  SmartRetracementLines(ai_4, ad_8, ai_40, ad_44, ai_52, ad_44 - (ad_20 - ad_32), Orange, "TB=", "ST", 0, 5, "IX=TB", gsa_956[61][1], gi_864);
               }
               DrawOne2OneDimentions(-1, ai_4, ad_8, ai_16, ad_20, ai_28, ad_32, ai_40, ad_44, ai_52, ad_56);
            }
         }
      }
   }
   return (0);
}

void DrawEntryBox(int ai_0, int ai_4, double ad_8, int ai_16, double ad_20, color ai_28, color ai_32, string as_36, string as_44, string as_52, string as_60, string as_68) {
   string ls_76 = "HAR_O_" + "rect_" + as_44 + "_" + as_36 + "_" + DateTimeReformat(TimeToStr(ai_4, TIME_DATE|TIME_MINUTES));
   ObjectDelete(ls_76);
   ObjectCreate(ls_76, OBJ_RECTANGLE, 0, ai_4, ad_8, ai_16, ad_20);
   ObjectSet(ls_76, OBJPROP_COLOR, ai_28);
   ObjectSet(ls_76, OBJPROP_BACK, TRUE);
   ls_76 = "HAR_O_" + "121_desc_" + as_44 + "_" + as_36 + "_" + DateTimeReformat(TimeToStr(ai_4, TIME_DATE|TIME_MINUTES));
   int li_84 = 8;
   if (ai_0 == 1) ObjectCreate(ls_76, OBJ_TEXT, 0, ai_4 + (ai_16 - ai_4) / 2, MathMin(ad_8, ad_20));
   else
      if (ai_0 == -1) ObjectCreate(ls_76, OBJ_TEXT, 0, ai_4 + (ai_16 - ai_4) / 2, MathMax(ad_8, ad_20) + LabelOffset(li_84 + 8));
   ObjectSetText(ls_76, as_52 + "   " + as_60 + "   " + as_68, li_84, "Tahoma", ai_32);
   ls_76 = "HAR_O_" + "121_line_" + as_44 + "_" + as_36 + "_" + DateTimeReformat(TimeToStr(ai_4, TIME_DATE|TIME_MINUTES));
   ObjectCreate(ls_76, OBJ_TREND, 0, ai_4, (ad_8 + ad_20) / 2.0, ai_16, (ad_8 + ad_20) / 2.0);
   ObjectSet(ls_76, OBJPROP_COLOR, ai_32);
   ObjectSet(ls_76, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet(ls_76, OBJPROP_WIDTH, 1);
   ObjectSet(ls_76, OBJPROP_BACK, FALSE);
   ObjectSet(ls_76, OBJPROP_RAY, FALSE);
}