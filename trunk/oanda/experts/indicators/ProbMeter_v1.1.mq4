
#property indicator_chart_window

extern string Box_setting = "Where do you want the box?";
extern bool Show.Values.Only = FALSE;
extern int X_box = 0;
extern int Y_box = 0;
extern string MACD_settings = "=== Your 1st indicator settings ===";
extern int Fast_EMA = 5;
extern int Slow_EMA = 13;
extern int MACD_SMA = 1;
extern string Stoch_settings = "=== Your 2nd indicator settings ===";
extern int K_period = 20;
extern int D_period = 2;
extern int Slowing = 2;
extern string Colors_settings = "=== Your Colors settings ===";
extern color colorsymbol = CadetBlue;
extern color colortext = Silver;
extern color colorline = DimGray;
extern color colorvalues = Black;
extern string Alert_setting = "Pop up or/and email alert";
extern bool SignalAlert = FALSE;
extern bool SendAlertEmail = FALSE;
extern int Alert_Trigger = 75;
int gi_192 = 0;
string gs_196 = "";
double gd_204;
string gs_unused_212 = "=== Moving Average Settings ===";
int g_period_220 = 20;
int g_period_224 = 50;
int g_period_228 = 100;
int g_ma_method_232 = MODE_EMA;
int g_applied_price_236 = PRICE_CLOSE;
string gs_unused_240 = "=== CCI Settings ===";
int g_period_248 = 14;
int g_applied_price_252 = PRICE_CLOSE;
string gs_unused_256 = "=== MACD Settings ===";
int g_period_264 = 12;
int g_period_268 = 26;
int g_period_272 = 9;
string gs_unused_276 = "=== ADX Settings ===";
int g_period_284 = 14;
int g_applied_price_288 = PRICE_CLOSE;
string gs_unused_292 = "=== BULLS Settings ===";
int g_period_300 = 13;
int g_applied_price_304 = PRICE_CLOSE;
string gs_unused_308 = "=== BEARS Settings ===";
int g_period_316 = 13;
int g_applied_price_320 = PRICE_CLOSE;
string gs_unused_324 = "=== STOCHASTIC Settings ===";
int g_period_332 = 5;
int g_period_336 = 3;
int g_slowing_340 = 3;
string gs_unused_344 = "=== RSI Settings ===";
int g_period_352 = 14;
string gs_unused_356 = "=== FORCE INDEX Settings ===";
int g_period_364 = 14;
int g_ma_method_368 = MODE_SMA;
int g_applied_price_372 = PRICE_CLOSE;
string gs_unused_376 = "=== MOMENTUM INDEX Settings ===";
int g_period_384 = 14;
int g_applied_price_388 = PRICE_CLOSE;
string gs_unused_392 = "=== DeMARKER Settings ===";
int g_period_400 = 14;
string gsa_404[19] = {"EURUSD", "GBPUSD", "AUDUSD", "USDJPY", "USDCHF", "USDCAD", "EURJPY", "EURGBP", "EURCHF", "EURAUD", "GBPJPY", "GBPCHF", "AUDJPY", "NZDUSD", "NZDJPY", "AUDNZD", "CHFJPY", "EURCAD", "AUDCAD"};
string gsa_408[8] = {"USD", "EUR", "GBP", "CHF", "CAD", "AUD", "JPY", "NZD"};
string g_text_412;
int gi_420;
string g_text_424;
int gi_432;
double gd_436;
color g_color_444;
color g_color_448;
color g_color_452;
color g_color_456;
color g_color_460;
color g_color_464;
int gi_468;
int gi_472;
int gi_476;
string gs_unused_480;

int init() {
   return (0);
}

int deinit() {
   string l_name_0;
   ObjectDelete("_symbol_");
   ObjectDelete("_line1");
   ObjectDelete("trend_logo_1");
   ObjectDelete("trend_logo_2");
   ObjectDelete("trend_comment_");
   ObjectDelete("prop_value");
   ObjectDelete("_line2");
   ObjectDelete("multi_logo");
   ObjectDelete("multi_logo2");
   ObjectDelete("multi_score");
   ObjectDelete("multi_comment");
   ObjectDelete("ind_logo");
   ObjectDelete("ind_logo2");
   ObjectDelete("ind_score");
   ObjectDelete("ind_comment");
   ObjectDelete("cur_logo");
   ObjectDelete("cur_logo2");
   ObjectDelete("cur_score");
   ObjectDelete("cur_comment");
   ObjectDelete("sn_logo");
   ObjectDelete("sn_logo2");
   ObjectDelete("sn_score");
   ObjectDelete("sn_comment");
   ObjectDelete("fis_logo");
   ObjectDelete("fis_logo2");
   ObjectDelete("fis_score");
   ObjectDelete("fis_comment");
   ObjectDelete("_line3");
   ObjectDelete("_line4");
   ObjectDelete("_line5");
   ObjectDelete("_line6");
   ObjectDelete("copyright");
   int l_objs_total_8 = ObjectsTotal();
   for (int li_12 = l_objs_total_8 - 1; li_12 >= 0; li_12--) {
      l_name_0 = ObjectName(li_12);
      if (StringFind(l_name_0, "back_") == 0) ObjectDelete(l_name_0);
   }
   DelUnauthorized();
   return (0);
}

int start() {
   double ld_0;
   double ld_8;
   double ld_16;
   double ld_24;
   double ld_32;
   double ld_40;
   double ld_48;
   double ld_64;
   double ld_72;
   double ld_80;
   double ld_88;
   double ld_96;
   double ld_104;
   double ld_112;
   double ld_128;
   double ld_136;
   double ld_144;
   double ld_152;
   double ld_160;
   double ld_168;
   double ld_176;
   double ld_192;
   double ld_200;
   double ld_208;
   double ld_216;
   double ld_224;
   double ld_232;
   double ld_240;
   double ld_256;
   double ld_264;
   double ld_272;
   double ld_280;
   double ld_288;
   double ld_296;
   double ld_304;
   double ld_320;
   double ld_328;
   double ld_336;
   double ld_344;
   double ld_352;
   double ld_360;
   double ld_368;
   double ld_384;
   double ld_392;
   double ld_400;
   double ld_408;
   double ld_416;
   double ld_424;
   double ld_432;
   double ld_448;
   double ld_456;
   double ld_464;
   double ld_472;
   double ld_480;
   double ld_488;
   double ld_496;
   double ld_512;
   double ld_520;
   double ld_528;
   double ld_536;
   double ld_544;
   double ld_552;
   double ld_560;
   double ld_576;
   double ld_584;
   double ld_592;
   double ld_600;
   double ld_608;
   double ld_616;
   double ld_624;
   double ld_640;
   double ld_648;
   double ld_656;
   double ld_664;
   double ld_672;
   double ld_680;
   double ld_688;
   double ld_704;
   double ld_712;
   double ld_720;
   double ld_728;
   double ld_736;
   double ld_744;
   double ld_752;
   double ld_768;
   double ld_776;
   double ld_784;
   double ld_792;
   double ld_800;
   double ld_808;
   double ld_816;
   double ld_832;
   double ld_840;
   double ld_848;
   double ld_856;
   double ld_864;
   double ld_872;
   double ld_880;
   double ld_896;
   double ld_904;
   double ld_912;
   double ld_920;
   double ld_928;
   double ld_936;
   double ld_944;
   double ld_960;
   double ld_968;
   double ld_976;
   double ld_984;
   double ld_992;
   double ld_1000;
   double ld_1008;
   double ld_1024;
   double ld_1032;
   double ld_1040;
   double ld_1048;
   double ld_1056;
   double ld_1064;
   double ld_1072;
   double ld_1088;
   double ld_1096;
   double ld_1104;
   double ld_1112;
   double ld_1120;
   double ld_1128;
   double ld_1136;
   double ld_1152;
   double ld_1160;
   double ld_1168;
   double ld_1176;
   double ld_1184;
   double ld_1192;
   double ld_1200;
   double ld_1216;
   double ld_1224;
   double ld_1232;
   double ld_1240;
   double ld_1248;
   double ld_1256;
   double ld_1264;
   double ld_1280;
   double ld_1288;
   double ld_1296;
   double ld_1304;
   double ld_1312;
   double ld_1320;
   double ld_1328;
   double ld_1408;
   double ld_1416;
   double ld_1424;
   double ld_1432;
   double ld_1440;
   double ld_1448;
   double ld_1456;
   double ld_1472;
   double ld_1480;
   double ld_1488;
   double ld_1496;
   double ld_1504;
   double ld_1512;
   double ld_1520;
   double ld_1536;
   double ld_1544;
   double ld_1552;
   double ld_1560;
   double ld_1568;
   double ld_1576;
   double ld_1584;
   double ld_1600;
   double ld_1608;
   double ld_1616;
   double ld_1624;
   double ld_1632;
   double ld_1640;
   double ld_1648;
   double ld_1664;
   double ld_1672;
   double ld_1680;
   double ld_1688;
   double ld_1696;
   double ld_1704;
   double ld_1712;
   double l_ima_1792;
   double l_ima_1800;
   double l_ima_1808;
   double l_ima_1816;
   double l_ima_1824;
   double l_ima_1832;
   double l_ima_1840;
   double l_ima_1848;
   double l_ima_1856;
   double l_ima_1864;
   double l_ima_1872;
   double l_ima_1880;
   double l_ima_1888;
   double l_ima_1896;
   double l_ima_1904;
   double l_ima_1912;
   double l_ima_1920;
   double l_ima_1928;
   double l_ima_1936;
   double l_ima_1944;
   double l_ima_1952;
   double l_ima_1960;
   double l_ima_1968;
   double l_ima_1976;
   double l_ima_1984;
   double l_ima_1992;
   double l_ima_2000;
   double l_ima_2008;
   double l_ima_2016;
   double l_ima_2024;
   double l_ima_2032;
   double l_ima_2040;
   double l_ima_2048;
   double l_ima_2056;
   double l_ima_2064;
   double l_ima_2072;
   double l_ima_2080;
   double l_ima_2088;
   double l_ima_2096;
   double l_ima_2104;
   double l_ima_2112;
   double l_ima_2120;
   double l_icci_2128;
   double l_icci_2136;
   double l_icci_2144;
   double l_icci_2152;
   double l_icci_2160;
   double l_icci_2168;
   double l_icci_2176;
   double l_imacd_2184;
   double l_imacd_2192;
   double l_imacd_2200;
   double l_imacd_2208;
   double l_imacd_2216;
   double l_imacd_2224;
   double l_imacd_2232;
   double l_imacd_2240;
   double l_imacd_2248;
   double l_imacd_2256;
   double l_imacd_2264;
   double l_imacd_2272;
   double l_imacd_2280;
   double l_imacd_2288;
   double l_iadx_2296;
   double l_iadx_2304;
   double l_iadx_2312;
   double l_iadx_2320;
   double l_iadx_2328;
   double l_iadx_2336;
   double l_iadx_2344;
   double l_iadx_2352;
   double l_iadx_2360;
   double l_iadx_2368;
   double l_iadx_2376;
   double l_iadx_2384;
   double l_iadx_2392;
   double l_iadx_2400;
   double l_ibullspower_2408;
   double l_ibullspower_2416;
   double l_ibullspower_2424;
   double l_ibullspower_2432;
   double l_ibullspower_2440;
   double l_ibullspower_2448;
   double l_ibullspower_2456;
   double l_ibearspower_2464;
   double l_ibearspower_2472;
   double l_ibearspower_2480;
   double l_ibearspower_2488;
   double l_ibearspower_2496;
   double l_ibearspower_2504;
   double l_ibearspower_2512;
   double l_istochastic_2520;
   double l_istochastic_2528;
   double l_istochastic_2536;
   double l_istochastic_2544;
   double l_istochastic_2552;
   double l_istochastic_2560;
   double l_istochastic_2568;
   double l_istochastic_2576;
   double l_istochastic_2584;
   double l_istochastic_2592;
   double l_istochastic_2600;
   double l_istochastic_2608;
   double l_istochastic_2616;
   double l_istochastic_2624;
   double l_irsi_2632;
   double l_irsi_2640;
   double l_irsi_2648;
   double l_irsi_2656;
   double l_irsi_2664;
   double l_irsi_2672;
   double l_irsi_2680;
   double l_iforce_2688;
   double l_iforce_2696;
   double l_iforce_2704;
   double l_iforce_2712;
   double l_iforce_2720;
   double l_iforce_2728;
   double l_iforce_2736;
   double l_imomentum_2744;
   double l_imomentum_2752;
   double l_imomentum_2760;
   double l_imomentum_2768;
   double l_imomentum_2776;
   double l_imomentum_2784;
   double l_imomentum_2792;
   double l_idemarker_2800;
   double l_idemarker_2808;
   double l_idemarker_2816;
   double l_idemarker_2824;
   double l_idemarker_2832;
   double l_idemarker_2840;
   double l_idemarker_2848;
   double l_idemarker_2856;
   double l_idemarker_2864;
   double l_idemarker_2872;
   double l_idemarker_2880;
   double l_idemarker_2888;
   double l_idemarker_2896;
   double l_idemarker_2904;
   double ld_2912;
   double ld_2920;
   double ld_2928;
   double ld_2936;
   double ld_2944;
   double ld_2952;
   double ld_2960;
   double ld_2968;
   double ld_2976;
   double ld_2984;
   double ld_2992;
   double ld_3000;
   double ld_3008;
   double ld_3016;
   double ld_3024;
   double ld_3032;
   double ld_3040;
   double ld_3048;
   string l_symbol_3056;
   string l_dbl2str_3064;
   string ls_unused_3072;
   string l_dbl2str_3080;
   string l_dbl2str_3088;
   string l_dbl2str_3096;
   string l_dbl2str_3104;
   double ld_3112;
   double lda_3120[8];
   double lda_3124[19];
   double lda_3128[19];
   double lda_3132[19];
   double lda_3136[19];
   double lda_3140[19];
   double lda_3144[19];
   double lda_3148[19];
   double lda_3152[19];
   double lda_3156[19];
   double ld_3160;
   double ld_3168;
   string ls_unused_3176;
   string ls_unused_3184;
   string ls_unused_3192;
   double ld_3200;
   int li_3212;
   string l_symbol_3216;
   string ls_3224;
   string ls_unused_3232;
   string ls_unused_3240;
   string ls_3248;
   double ld_3256;
   double ld_3264;
   double l_imacd_3272;
   double l_imacd_3280;
   double l_istochastic_3288;
   double l_istochastic_3296;
   int li_3304;
   double ld_3308;
   string l_text_3316;
   color l_color_3324;
   color l_color_3328;
   color l_color_3332;
   string l_text_3336;
   int li_3344;
   DelUnauthorized();
   
      l_ima_1792 = iMA(NULL, PERIOD_M1, g_period_220, 0, g_ma_method_232, g_applied_price_236, 0);
      l_ima_1800 = iMA(NULL, PERIOD_M1, g_period_220, 0, g_ma_method_232, g_applied_price_236, 1);
      if (l_ima_1792 > l_ima_1800) {
         ld_0 = 1;
         ld_512 = 0;
      }
      if (l_ima_1792 < l_ima_1800) {
         ld_0 = 0;
         ld_512 = 1;
      }
      l_ima_1808 = iMA(NULL, PERIOD_M5, g_period_220, 0, g_ma_method_232, g_applied_price_236, 0);
      l_ima_1816 = iMA(NULL, PERIOD_M5, g_period_220, 0, g_ma_method_232, g_applied_price_236, 1);
      if (l_ima_1808 > l_ima_1816) {
         ld_8 = 1;
         ld_520 = 0;
      }
      if (l_ima_1808 < l_ima_1816) {
         ld_8 = 0;
         ld_520 = 1;
      }
      l_ima_1824 = iMA(NULL, PERIOD_M15, g_period_220, 0, g_ma_method_232, g_applied_price_236, 0);
      l_ima_1832 = iMA(NULL, PERIOD_M15, g_period_220, 0, g_ma_method_232, g_applied_price_236, 1);
      if (l_ima_1824 > l_ima_1832) {
         ld_16 = 1;
         ld_528 = 0;
      }
      if (l_ima_1824 < l_ima_1832) {
         ld_16 = 0;
         ld_528 = 1;
      }
      l_ima_1840 = iMA(NULL, PERIOD_M30, g_period_220, 0, g_ma_method_232, g_applied_price_236, 0);
      l_ima_1848 = iMA(NULL, PERIOD_M30, g_period_220, 0, g_ma_method_232, g_applied_price_236, 1);
      if (l_ima_1840 > l_ima_1848) {
         ld_24 = 1;
         ld_536 = 0;
      }
      if (l_ima_1840 < l_ima_1848) {
         ld_24 = 0;
         ld_536 = 1;
      }
      l_ima_1856 = iMA(NULL, PERIOD_H1, g_period_220, 0, g_ma_method_232, g_applied_price_236, 0);
      l_ima_1864 = iMA(NULL, PERIOD_H1, g_period_220, 0, g_ma_method_232, g_applied_price_236, 1);
      if (l_ima_1856 > l_ima_1864) {
         ld_32 = 1;
         ld_544 = 0;
      }
      if (l_ima_1856 < l_ima_1864) {
         ld_32 = 0;
         ld_544 = 1;
      }
      l_ima_1872 = iMA(NULL, PERIOD_H4, g_period_220, 0, g_ma_method_232, g_applied_price_236, 0);
      l_ima_1880 = iMA(NULL, PERIOD_H4, g_period_220, 0, g_ma_method_232, g_applied_price_236, 1);
      if (l_ima_1872 > l_ima_1880) {
         ld_40 = 1;
         ld_552 = 0;
      }
      if (l_ima_1872 < l_ima_1880) {
         ld_40 = 0;
         ld_552 = 1;
      }
      l_ima_1888 = iMA(NULL, PERIOD_D1, g_period_220, 0, g_ma_method_232, g_applied_price_236, 0);
      l_ima_1896 = iMA(NULL, PERIOD_D1, g_period_220, 0, g_ma_method_232, g_applied_price_236, 1);
      if (l_ima_1888 > l_ima_1896) {
         ld_48 = 1;
         ld_560 = 0;
      }
      if (l_ima_1888 < l_ima_1896) {
         ld_48 = 0;
         ld_560 = 1;
      }
      l_ima_1904 = iMA(NULL, PERIOD_M1, g_period_224, 0, g_ma_method_232, g_applied_price_236, 0);
      l_ima_1912 = iMA(NULL, PERIOD_M1, g_period_224, 0, g_ma_method_232, g_applied_price_236, 1);
      if (l_ima_1904 > l_ima_1912) {
         ld_64 = 1;
         ld_576 = 0;
      }
      if (l_ima_1904 < l_ima_1912) {
         ld_64 = 0;
         ld_576 = 1;
      }
      l_ima_1920 = iMA(NULL, PERIOD_M5, g_period_224, 0, g_ma_method_232, g_applied_price_236, 0);
      l_ima_1928 = iMA(NULL, PERIOD_M5, g_period_224, 0, g_ma_method_232, g_applied_price_236, 1);
      if (l_ima_1920 > l_ima_1928) {
         ld_72 = 1;
         ld_584 = 0;
      }
      if (l_ima_1920 < l_ima_1928) {
         ld_72 = 0;
         ld_584 = 1;
      }
      l_ima_1936 = iMA(NULL, PERIOD_M15, g_period_224, 0, g_ma_method_232, g_applied_price_236, 0);
      l_ima_1944 = iMA(NULL, PERIOD_M15, g_period_224, 0, g_ma_method_232, g_applied_price_236, 1);
      if (l_ima_1936 > l_ima_1944) {
         ld_80 = 1;
         ld_592 = 0;
      }
      if (l_ima_1936 < l_ima_1944) {
         ld_80 = 0;
         ld_592 = 1;
      }
      l_ima_1952 = iMA(NULL, PERIOD_M30, g_period_224, 0, g_ma_method_232, g_applied_price_236, 0);
      l_ima_1960 = iMA(NULL, PERIOD_M30, g_period_224, 0, g_ma_method_232, g_applied_price_236, 1);
      if (l_ima_1952 > l_ima_1960) {
         ld_88 = 1;
         ld_600 = 0;
      }
      if (l_ima_1952 < l_ima_1960) {
         ld_88 = 0;
         ld_600 = 1;
      }
      l_ima_1968 = iMA(NULL, PERIOD_H1, g_period_224, 0, g_ma_method_232, g_applied_price_236, 0);
      l_ima_1976 = iMA(NULL, PERIOD_H1, g_period_224, 0, g_ma_method_232, g_applied_price_236, 1);
      if (l_ima_1968 > l_ima_1976) {
         ld_96 = 1;
         ld_608 = 0;
      }
      if (l_ima_1968 < l_ima_1976) {
         ld_96 = 0;
         ld_608 = 1;
      }
      l_ima_1984 = iMA(NULL, PERIOD_H4, g_period_224, 0, g_ma_method_232, g_applied_price_236, 0);
      l_ima_1992 = iMA(NULL, PERIOD_H4, g_period_224, 0, g_ma_method_232, g_applied_price_236, 1);
      if (l_ima_1984 > l_ima_1992) {
         ld_104 = 1;
         ld_616 = 0;
      }
      if (l_ima_1984 < l_ima_1992) {
         ld_104 = 0;
         ld_616 = 1;
      }
      l_ima_2000 = iMA(NULL, PERIOD_D1, g_period_224, 0, g_ma_method_232, g_applied_price_236, 0);
      l_ima_2008 = iMA(NULL, PERIOD_D1, g_period_224, 0, g_ma_method_232, g_applied_price_236, 1);
      if (l_ima_2000 > l_ima_2008) {
         ld_112 = 1;
         ld_624 = 0;
      }
      if (l_ima_2000 < l_ima_2008) {
         ld_112 = 0;
         ld_624 = 1;
      }
      l_ima_2016 = iMA(NULL, PERIOD_M1, g_period_228, 0, g_ma_method_232, g_applied_price_236, 0);
      l_ima_2024 = iMA(NULL, PERIOD_M1, g_period_228, 0, g_ma_method_232, g_applied_price_236, 1);
      if (l_ima_2016 > l_ima_2024) {
         ld_128 = 1;
         ld_640 = 0;
      }
      if (l_ima_2016 < l_ima_2024) {
         ld_128 = 0;
         ld_640 = 1;
      }
      l_ima_2032 = iMA(NULL, PERIOD_M5, g_period_228, 0, g_ma_method_232, g_applied_price_236, 0);
      l_ima_2040 = iMA(NULL, PERIOD_M5, g_period_228, 0, g_ma_method_232, g_applied_price_236, 1);
      if (l_ima_2032 > l_ima_2040) {
         ld_136 = 1;
         ld_648 = 0;
      }
      if (l_ima_2032 < l_ima_2040) {
         ld_136 = 0;
         ld_648 = 1;
      }
      l_ima_2048 = iMA(NULL, PERIOD_M15, g_period_228, 0, g_ma_method_232, g_applied_price_236, 0);
      l_ima_2056 = iMA(NULL, PERIOD_M15, g_period_228, 0, g_ma_method_232, g_applied_price_236, 1);
      if (l_ima_2048 > l_ima_2056) {
         ld_144 = 1;
         ld_656 = 0;
      }
      if (l_ima_2048 < l_ima_2056) {
         ld_144 = 0;
         ld_656 = 1;
      }
      l_ima_2064 = iMA(NULL, PERIOD_M30, g_period_228, 0, g_ma_method_232, g_applied_price_236, 0);
      l_ima_2072 = iMA(NULL, PERIOD_M30, g_period_228, 0, g_ma_method_232, g_applied_price_236, 1);
      if (l_ima_2064 > l_ima_2072) {
         ld_152 = 1;
         ld_664 = 0;
      }
      if (l_ima_2064 < l_ima_2072) {
         ld_152 = 0;
         ld_664 = 1;
      }
      l_ima_2080 = iMA(NULL, PERIOD_H1, g_period_228, 0, g_ma_method_232, g_applied_price_236, 0);
      l_ima_2088 = iMA(NULL, PERIOD_H1, g_period_228, 0, g_ma_method_232, g_applied_price_236, 1);
      if (l_ima_2080 > l_ima_2088) {
         ld_160 = 1;
         ld_672 = 0;
      }
      if (l_ima_2080 < l_ima_2088) {
         ld_160 = 0;
         ld_672 = 1;
      }
      l_ima_2096 = iMA(NULL, PERIOD_H4, g_period_228, 0, g_ma_method_232, g_applied_price_236, 0);
      l_ima_2104 = iMA(NULL, PERIOD_H4, g_period_228, 0, g_ma_method_232, g_applied_price_236, 1);
      if (l_ima_2096 > l_ima_2104) {
         ld_168 = 1;
         ld_680 = 0;
      }
      if (l_ima_2096 < l_ima_2104) {
         ld_168 = 0;
         ld_680 = 1;
      }
      l_ima_2112 = iMA(NULL, PERIOD_D1, g_period_228, 0, g_ma_method_232, g_applied_price_236, 0);
      l_ima_2120 = iMA(NULL, PERIOD_D1, g_period_228, 0, g_ma_method_232, g_applied_price_236, 1);
      if (l_ima_2112 > l_ima_2120) {
         ld_176 = 1;
         ld_688 = 0;
      }
      if (l_ima_2112 < l_ima_2120) {
         ld_176 = 0;
         ld_688 = 1;
      }
      l_icci_2128 = iCCI(NULL, PERIOD_M1, g_period_248, g_applied_price_252, 0);
      if (l_icci_2128 > 0.0) {
         ld_192 = 1;
         ld_704 = 0;
      }
      if (l_icci_2128 < 0.0) {
         ld_192 = 0;
         ld_704 = 1;
      }
      l_icci_2136 = iCCI(NULL, PERIOD_M5, g_period_248, g_applied_price_252, 0);
      if (l_icci_2136 > 0.0) {
         ld_200 = 1;
         ld_712 = 0;
      }
      if (l_icci_2136 < 0.0) {
         ld_200 = 0;
         ld_712 = 1;
      }
      l_icci_2144 = iCCI(NULL, PERIOD_M15, g_period_248, g_applied_price_252, 0);
      if (l_icci_2144 > 0.0) {
         ld_208 = 1;
         ld_720 = 0;
      }
      if (l_icci_2144 < 0.0) {
         ld_208 = 0;
         ld_720 = 1;
      }
      l_icci_2152 = iCCI(NULL, PERIOD_M30, g_period_248, g_applied_price_252, 0);
      if (l_icci_2152 > 0.0) {
         ld_216 = 1;
         ld_728 = 0;
      }
      if (l_icci_2152 < 0.0) {
         ld_216 = 0;
         ld_728 = 1;
      }
      l_icci_2160 = iCCI(NULL, PERIOD_H1, g_period_248, g_applied_price_252, 0);
      if (l_icci_2160 > 0.0) {
         ld_224 = 1;
         ld_736 = 0;
      }
      if (l_icci_2160 < 0.0) {
         ld_224 = 0;
         ld_736 = 1;
      }
      l_icci_2168 = iCCI(NULL, PERIOD_H4, g_period_248, g_applied_price_252, 0);
      if (l_icci_2168 > 0.0) {
         ld_232 = 1;
         ld_744 = 0;
      }
      if (l_icci_2168 < 0.0) {
         ld_232 = 0;
         ld_744 = 1;
      }
      l_icci_2176 = iCCI(NULL, PERIOD_D1, g_period_248, g_applied_price_252, 0);
      if (l_icci_2176 > 0.0) {
         ld_240 = 1;
         ld_752 = 0;
      }
      if (l_icci_2176 < 0.0) {
         ld_240 = 0;
         ld_752 = 1;
      }
      l_imacd_2184 = iMACD(NULL, PERIOD_M1, g_period_264, g_period_268, g_period_272, PRICE_CLOSE, MODE_MAIN, 0);
      l_imacd_2192 = iMACD(NULL, PERIOD_M1, g_period_264, g_period_268, g_period_272, PRICE_CLOSE, MODE_SIGNAL, 0);
      if (l_imacd_2184 > l_imacd_2192) {
         ld_256 = 1;
         ld_768 = 0;
      }
      if (l_imacd_2184 < l_imacd_2192) {
         ld_256 = 0;
         ld_768 = 1;
      }
      l_imacd_2200 = iMACD(NULL, PERIOD_M5, g_period_264, g_period_268, g_period_272, PRICE_CLOSE, MODE_MAIN, 0);
      l_imacd_2208 = iMACD(NULL, PERIOD_M5, g_period_264, g_period_268, g_period_272, PRICE_CLOSE, MODE_SIGNAL, 0);
      if (l_imacd_2200 > l_imacd_2208) {
         ld_264 = 1;
         ld_776 = 0;
      }
      if (l_imacd_2200 < l_imacd_2208) {
         ld_264 = 0;
         ld_776 = 1;
      }
      l_imacd_2216 = iMACD(NULL, PERIOD_M15, g_period_264, g_period_268, g_period_272, PRICE_CLOSE, MODE_MAIN, 0);
      l_imacd_2224 = iMACD(NULL, PERIOD_M15, g_period_264, g_period_268, g_period_272, PRICE_CLOSE, MODE_SIGNAL, 0);
      if (l_imacd_2216 > l_imacd_2224) {
         ld_272 = 1;
         ld_784 = 0;
      }
      if (l_imacd_2216 < l_imacd_2224) {
         ld_272 = 0;
         ld_784 = 1;
      }
      l_imacd_2232 = iMACD(NULL, PERIOD_M30, g_period_264, g_period_268, g_period_272, PRICE_CLOSE, MODE_MAIN, 0);
      l_imacd_2240 = iMACD(NULL, PERIOD_M30, g_period_264, g_period_268, g_period_272, PRICE_CLOSE, MODE_SIGNAL, 0);
      if (l_imacd_2232 > l_imacd_2240) {
         ld_280 = 1;
         ld_792 = 0;
      }
      if (l_imacd_2232 < l_imacd_2240) {
         ld_280 = 0;
         ld_792 = 1;
      }
      l_imacd_2248 = iMACD(NULL, PERIOD_H1, g_period_264, g_period_268, g_period_272, PRICE_CLOSE, MODE_MAIN, 0);
      l_imacd_2256 = iMACD(NULL, PERIOD_H1, g_period_264, g_period_268, g_period_272, PRICE_CLOSE, MODE_SIGNAL, 0);
      if (l_imacd_2248 > l_imacd_2256) {
         ld_288 = 1;
         ld_800 = 0;
      }
      if (l_imacd_2248 < l_imacd_2256) {
         ld_288 = 0;
         ld_800 = 1;
      }
      l_imacd_2264 = iMACD(NULL, PERIOD_H4, g_period_264, g_period_268, g_period_272, PRICE_CLOSE, MODE_MAIN, 0);
      l_imacd_2272 = iMACD(NULL, PERIOD_H4, g_period_264, g_period_268, g_period_272, PRICE_CLOSE, MODE_SIGNAL, 0);
      if (l_imacd_2264 > l_imacd_2272) {
         ld_296 = 1;
         ld_808 = 0;
      }
      if (l_imacd_2264 < l_imacd_2272) {
         ld_296 = 0;
         ld_808 = 1;
      }
      l_imacd_2280 = iMACD(NULL, PERIOD_D1, g_period_264, g_period_268, g_period_272, PRICE_CLOSE, MODE_MAIN, 0);
      l_imacd_2288 = iMACD(NULL, PERIOD_D1, g_period_264, g_period_268, g_period_272, PRICE_CLOSE, MODE_SIGNAL, 0);
      if (l_imacd_2280 > l_imacd_2288) {
         ld_304 = 1;
         ld_816 = 0;
      }
      if (l_imacd_2280 < l_imacd_2288) {
         ld_304 = 0;
         ld_816 = 1;
      }
      l_iadx_2296 = iADX(NULL, PERIOD_M1, g_period_284, g_applied_price_288, MODE_PLUSDI, 0);
      l_iadx_2304 = iADX(NULL, PERIOD_M1, g_period_284, g_applied_price_288, MODE_MINUSDI, 0);
      if (l_iadx_2296 > l_iadx_2304) {
         ld_320 = 1;
         ld_832 = 0;
      }
      if (l_iadx_2296 < l_iadx_2304) {
         ld_320 = 0;
         ld_832 = 1;
      }
      l_iadx_2312 = iADX(NULL, PERIOD_M5, g_period_284, g_applied_price_288, MODE_PLUSDI, 0);
      l_iadx_2320 = iADX(NULL, PERIOD_M5, g_period_284, g_applied_price_288, MODE_MINUSDI, 0);
      if (l_iadx_2312 > l_iadx_2320) {
         ld_328 = 1;
         ld_840 = 0;
      }
      if (l_iadx_2312 < l_iadx_2320) {
         ld_328 = 0;
         ld_840 = 1;
      }
      l_iadx_2328 = iADX(NULL, PERIOD_M15, g_period_284, g_applied_price_288, MODE_PLUSDI, 0);
      l_iadx_2336 = iADX(NULL, PERIOD_M15, g_period_284, g_applied_price_288, MODE_MINUSDI, 0);
      if (l_iadx_2328 > l_iadx_2336) {
         ld_336 = 1;
         ld_848 = 0;
      }
      if (l_iadx_2328 < l_iadx_2336) {
         ld_336 = 0;
         ld_848 = 1;
      }
      l_iadx_2344 = iADX(NULL, PERIOD_M30, g_period_284, g_applied_price_288, MODE_PLUSDI, 0);
      l_iadx_2352 = iADX(NULL, PERIOD_M30, g_period_284, g_applied_price_288, MODE_MINUSDI, 0);
      if (l_iadx_2344 > l_iadx_2352) {
         ld_344 = 1;
         ld_856 = 0;
      }
      if (l_iadx_2344 < l_iadx_2352) {
         ld_344 = 0;
         ld_856 = 1;
      }
      l_iadx_2360 = iADX(NULL, PERIOD_H1, g_period_284, g_applied_price_288, MODE_PLUSDI, 0);
      l_iadx_2368 = iADX(NULL, PERIOD_H1, g_period_284, g_applied_price_288, MODE_MINUSDI, 0);
      if (l_iadx_2360 > l_iadx_2368) {
         ld_352 = 1;
         ld_864 = 0;
      }
      if (l_iadx_2360 < l_iadx_2368) {
         ld_352 = 0;
         ld_864 = 1;
      }
      l_iadx_2376 = iADX(NULL, PERIOD_H4, g_period_284, g_applied_price_288, MODE_PLUSDI, 0);
      l_iadx_2384 = iADX(NULL, PERIOD_H4, g_period_284, g_applied_price_288, MODE_MINUSDI, 0);
      if (l_iadx_2376 > l_iadx_2384) {
         ld_360 = 1;
         ld_872 = 0;
      }
      if (l_iadx_2376 < l_iadx_2384) {
         ld_360 = 0;
         ld_872 = 1;
      }
      l_iadx_2392 = iADX(NULL, PERIOD_D1, g_period_284, g_applied_price_288, MODE_PLUSDI, 0);
      l_iadx_2400 = iADX(NULL, PERIOD_D1, g_period_284, g_applied_price_288, MODE_MINUSDI, 0);
      if (l_iadx_2392 > l_iadx_2400) {
         ld_368 = 1;
         ld_880 = 0;
      }
      if (l_iadx_2392 < l_iadx_2400) {
         ld_368 = 0;
         ld_880 = 1;
      }
      l_ibullspower_2408 = iBullsPower(NULL, PERIOD_M1, g_period_300, g_applied_price_304, 0);
      if (l_ibullspower_2408 > 0.0) {
         ld_384 = 1;
         ld_896 = 0;
      }
      if (l_ibullspower_2408 < 0.0) {
         ld_384 = 0;
         ld_896 = 1;
      }
      l_ibullspower_2416 = iBullsPower(NULL, PERIOD_M5, g_period_300, g_applied_price_304, 0);
      if (l_ibullspower_2416 > 0.0) {
         ld_392 = 1;
         ld_904 = 0;
      }
      if (l_ibullspower_2416 < 0.0) {
         ld_392 = 0;
         ld_904 = 1;
      }
      l_ibullspower_2424 = iBullsPower(NULL, PERIOD_M15, g_period_300, g_applied_price_304, 0);
      if (l_ibullspower_2424 > 0.0) {
         ld_400 = 1;
         ld_912 = 0;
      }
      if (l_ibullspower_2424 < 0.0) {
         ld_400 = 0;
         ld_912 = 1;
      }
      l_ibullspower_2432 = iBullsPower(NULL, PERIOD_M30, g_period_300, g_applied_price_304, 0);
      if (l_ibullspower_2432 > 0.0) {
         ld_408 = 1;
         ld_920 = 0;
      }
      if (l_ibullspower_2432 < 0.0) {
         ld_408 = 0;
         ld_920 = 1;
      }
      l_ibullspower_2440 = iBullsPower(NULL, PERIOD_H1, g_period_300, g_applied_price_304, 0);
      if (l_ibullspower_2440 > 0.0) {
         ld_416 = 1;
         ld_928 = 0;
      }
      if (l_ibullspower_2440 < 0.0) {
         ld_416 = 0;
         ld_928 = 1;
      }
      l_ibullspower_2448 = iBullsPower(NULL, PERIOD_H4, g_period_300, g_applied_price_304, 0);
      if (l_ibullspower_2448 > 0.0) {
         ld_424 = 1;
         ld_936 = 0;
      }
      if (l_ibullspower_2448 < 0.0) {
         ld_424 = 0;
         ld_936 = 1;
      }
      l_ibullspower_2456 = iBullsPower(NULL, PERIOD_D1, g_period_300, g_applied_price_304, 0);
      if (l_ibullspower_2456 > 0.0) {
         ld_432 = 1;
         ld_944 = 0;
      }
      if (l_ibullspower_2456 < 0.0) {
         ld_432 = 0;
         ld_944 = 1;
      }
      l_ibearspower_2464 = iBearsPower(NULL, PERIOD_M1, g_period_316, g_applied_price_320, 0);
      if (l_ibearspower_2464 > 0.0) {
         ld_448 = 1;
         ld_960 = 0;
      }
      if (l_ibearspower_2464 < 0.0) {
         ld_448 = 0;
         ld_960 = 1;
      }
      l_ibearspower_2472 = iBearsPower(NULL, PERIOD_M5, g_period_316, g_applied_price_320, 0);
      if (l_ibearspower_2472 > 0.0) {
         ld_456 = 1;
         ld_968 = 0;
      }
      if (l_ibearspower_2472 < 0.0) {
         ld_456 = 0;
         ld_968 = 1;
      }
      l_ibearspower_2480 = iBearsPower(NULL, PERIOD_M15, g_period_316, g_applied_price_320, 0);
      if (l_ibearspower_2480 > 0.0) {
         ld_464 = 1;
         ld_976 = 0;
      }
      if (l_ibearspower_2480 < 0.0) {
         ld_464 = 0;
         ld_976 = 1;
      }
      l_ibearspower_2488 = iBearsPower(NULL, PERIOD_M30, g_period_316, g_applied_price_320, 0);
      if (l_ibearspower_2488 > 0.0) {
         ld_472 = 1;
         ld_984 = 0;
      }
      if (l_ibearspower_2488 < 0.0) {
         ld_472 = 0;
         ld_984 = 1;
      }
      l_ibearspower_2496 = iBearsPower(NULL, PERIOD_H1, g_period_316, g_applied_price_320, 0);
      if (l_ibearspower_2496 > 0.0) {
         ld_480 = 1;
         ld_992 = 0;
      }
      if (l_ibearspower_2496 < 0.0) {
         ld_480 = 0;
         ld_992 = 1;
      }
      l_ibearspower_2504 = iBearsPower(NULL, PERIOD_H4, g_period_316, g_applied_price_320, 0);
      if (l_ibearspower_2504 > 0.0) {
         ld_488 = 1;
         ld_1000 = 0;
      }
      if (l_ibearspower_2504 < 0.0) {
         ld_488 = 0;
         ld_1000 = 1;
      }
      l_ibearspower_2512 = iBearsPower(NULL, PERIOD_D1, g_period_316, g_applied_price_320, 0);
      if (l_ibearspower_2512 > 0.0) {
         ld_496 = 1;
         ld_1008 = 0;
      }
      if (l_ibearspower_2512 < 0.0) {
         ld_496 = 0;
         ld_1008 = 1;
      }
      l_istochastic_2520 = iStochastic(NULL, PERIOD_M1, g_period_332, g_period_336, g_slowing_340, MODE_SMA, 1, MODE_MAIN, 0);
      l_istochastic_2528 = iStochastic(NULL, PERIOD_M1, g_period_332, g_period_336, g_slowing_340, MODE_SMA, 1, MODE_SIGNAL, 0);
      if (l_istochastic_2520 >= l_istochastic_2528) {
         ld_1024 = 1;
         ld_1408 = 0;
      }
      if (l_istochastic_2520 < l_istochastic_2528) {
         ld_1024 = 0;
         ld_1408 = 1;
      }
      l_istochastic_2536 = iStochastic(NULL, PERIOD_M5, g_period_332, g_period_336, g_slowing_340, MODE_SMA, 1, MODE_MAIN, 0);
      l_istochastic_2544 = iStochastic(NULL, PERIOD_M5, g_period_332, g_period_336, g_slowing_340, MODE_SMA, 1, MODE_SIGNAL, 0);
      if (l_istochastic_2536 >= l_istochastic_2544) {
         ld_1032 = 1;
         ld_1416 = 0;
      }
      if (l_istochastic_2536 < l_istochastic_2544) {
         ld_1032 = 0;
         ld_1416 = 1;
      }
      l_istochastic_2552 = iStochastic(NULL, PERIOD_M15, g_period_332, g_period_336, g_slowing_340, MODE_SMA, 1, MODE_MAIN, 0);
      l_istochastic_2560 = iStochastic(NULL, PERIOD_M15, g_period_332, g_period_336, g_slowing_340, MODE_SMA, 1, MODE_SIGNAL, 0);
      if (l_istochastic_2552 >= l_istochastic_2560) {
         ld_1040 = 1;
         ld_1424 = 0;
      }
      if (l_istochastic_2552 < l_istochastic_2560) {
         ld_1040 = 0;
         ld_1424 = 1;
      }
      l_istochastic_2568 = iStochastic(NULL, PERIOD_M30, g_period_332, g_period_336, g_slowing_340, MODE_SMA, 1, MODE_MAIN, 0);
      l_istochastic_2576 = iStochastic(NULL, PERIOD_M30, g_period_332, g_period_336, g_slowing_340, MODE_SMA, 1, MODE_SIGNAL, 0);
      if (l_istochastic_2568 >= l_istochastic_2576) {
         ld_1048 = 1;
         ld_1432 = 0;
      }
      if (l_istochastic_2568 < l_istochastic_2576) {
         ld_1048 = 0;
         ld_1432 = 1;
      }
      l_istochastic_2584 = iStochastic(NULL, PERIOD_H1, g_period_332, g_period_336, g_slowing_340, MODE_SMA, 1, MODE_MAIN, 0);
      l_istochastic_2592 = iStochastic(NULL, PERIOD_H1, g_period_332, g_period_336, g_slowing_340, MODE_SMA, 1, MODE_SIGNAL, 0);
      if (l_istochastic_2584 >= l_istochastic_2592) {
         ld_1056 = 1;
         ld_1440 = 0;
      }
      if (l_istochastic_2584 < l_istochastic_2592) {
         ld_1056 = 0;
         ld_1440 = 1;
      }
      l_istochastic_2600 = iStochastic(NULL, PERIOD_H4, g_period_332, g_period_336, g_slowing_340, MODE_SMA, 1, MODE_MAIN, 0);
      l_istochastic_2608 = iStochastic(NULL, PERIOD_H4, g_period_332, g_period_336, g_slowing_340, MODE_SMA, 1, MODE_SIGNAL, 0);
      if (l_istochastic_2600 >= l_istochastic_2608) {
         ld_1064 = 1;
         ld_1448 = 0;
      }
      if (l_istochastic_2600 < l_istochastic_2608) {
         ld_1064 = 0;
         ld_1448 = 1;
      }
      l_istochastic_2616 = iStochastic(NULL, PERIOD_D1, g_period_332, g_period_336, g_slowing_340, MODE_SMA, 1, MODE_MAIN, 0);
      l_istochastic_2624 = iStochastic(NULL, PERIOD_D1, g_period_332, g_period_336, g_slowing_340, MODE_SMA, 1, MODE_SIGNAL, 0);
      if (l_istochastic_2616 >= l_istochastic_2624) {
         ld_1072 = 1;
         ld_1456 = 0;
      }
      if (l_istochastic_2616 < l_istochastic_2624) {
         ld_1072 = 0;
         ld_1456 = 1;
      }
      l_irsi_2632 = iRSI(NULL, PERIOD_M1, g_period_352, PRICE_CLOSE, 0);
      if (l_irsi_2632 >= 50.0) {
         ld_1088 = 1;
         ld_1472 = 0;
      }
      if (l_irsi_2632 < 50.0) {
         ld_1088 = 0;
         ld_1472 = 1;
      }
      l_irsi_2640 = iRSI(NULL, PERIOD_M5, g_period_352, PRICE_CLOSE, 0);
      if (l_irsi_2640 >= 50.0) {
         ld_1096 = 1;
         ld_1480 = 0;
      }
      if (l_irsi_2640 < 50.0) {
         ld_1096 = 0;
         ld_1480 = 1;
      }
      l_irsi_2648 = iRSI(NULL, PERIOD_M15, g_period_352, PRICE_CLOSE, 0);
      if (l_irsi_2648 >= 50.0) {
         ld_1104 = 1;
         ld_1488 = 0;
      }
      if (l_irsi_2648 < 50.0) {
         ld_1104 = 0;
         ld_1488 = 1;
      }
      l_irsi_2656 = iRSI(NULL, PERIOD_M30, g_period_352, PRICE_CLOSE, 0);
      if (l_irsi_2656 >= 50.0) {
         ld_1112 = 1;
         ld_1496 = 0;
      }
      if (l_irsi_2656 < 50.0) {
         ld_1112 = 0;
         ld_1496 = 1;
      }
      l_irsi_2664 = iRSI(NULL, PERIOD_H1, g_period_352, PRICE_CLOSE, 0);
      if (l_irsi_2664 >= 50.0) {
         ld_1120 = 1;
         ld_1504 = 0;
      }
      if (l_irsi_2664 < 50.0) {
         ld_1120 = 0;
         ld_1504 = 1;
      }
      l_irsi_2672 = iRSI(NULL, PERIOD_H4, g_period_352, PRICE_CLOSE, 0);
      if (l_irsi_2672 >= 50.0) {
         ld_1128 = 1;
         ld_1512 = 0;
      }
      if (l_irsi_2672 < 50.0) {
         ld_1128 = 0;
         ld_1512 = 1;
      }
      l_irsi_2680 = iRSI(NULL, PERIOD_D1, g_period_352, PRICE_CLOSE, 0);
      if (l_irsi_2680 >= 50.0) {
         ld_1136 = 1;
         ld_1520 = 0;
      }
      if (l_irsi_2680 < 50.0) {
         ld_1136 = 0;
         ld_1520 = 1;
      }
      l_iforce_2688 = iForce(NULL, PERIOD_M1, g_period_364, g_ma_method_368, g_applied_price_372, 0);
      if (l_iforce_2688 >= 0.0) {
         ld_1152 = 1;
         ld_1536 = 0;
      }
      if (l_iforce_2688 < 0.0) {
         ld_1152 = 0;
         ld_1536 = 1;
      }
      l_iforce_2696 = iForce(NULL, PERIOD_M5, g_period_364, g_ma_method_368, g_applied_price_372, 0);
      if (l_iforce_2696 >= 0.0) {
         ld_1160 = 1;
         ld_1544 = 0;
      }
      if (l_iforce_2696 < 0.0) {
         ld_1160 = 0;
         ld_1544 = 1;
      }
      l_iforce_2704 = iForce(NULL, PERIOD_M15, g_period_364, g_ma_method_368, g_applied_price_372, 0);
      if (l_iforce_2704 >= 0.0) {
         ld_1168 = 1;
         ld_1552 = 0;
      }
      if (l_iforce_2704 < 0.0) {
         ld_1168 = 0;
         ld_1552 = 1;
      }
      l_iforce_2712 = iForce(NULL, PERIOD_M30, g_period_364, g_ma_method_368, g_applied_price_372, 0);
      if (l_iforce_2712 >= 0.0) {
         ld_1176 = 1;
         ld_1560 = 0;
      }
      if (l_iforce_2712 < 0.0) {
         ld_1176 = 0;
         ld_1560 = 1;
      }
      l_iforce_2720 = iForce(NULL, PERIOD_H1, g_period_364, g_ma_method_368, g_applied_price_372, 0);
      if (l_iforce_2720 >= 0.0) {
         ld_1184 = 1;
         ld_1568 = 0;
      }
      if (l_iforce_2720 < 0.0) {
         ld_1184 = 0;
         ld_1568 = 1;
      }
      l_iforce_2728 = iForce(NULL, PERIOD_H4, g_period_364, g_ma_method_368, g_applied_price_372, 0);
      if (l_iforce_2728 >= 0.0) {
         ld_1192 = 1;
         ld_1576 = 0;
      }
      if (l_iforce_2728 < 0.0) {
         ld_1192 = 0;
         ld_1576 = 1;
      }
      l_iforce_2736 = iForce(NULL, PERIOD_D1, g_period_364, g_ma_method_368, g_applied_price_372, 0);
      if (l_iforce_2736 >= 0.0) {
         ld_1200 = 1;
         ld_1584 = 0;
      }
      if (l_iforce_2736 < 0.0) {
         ld_1200 = 0;
         ld_1584 = 1;
      }
      l_imomentum_2744 = iMomentum(NULL, PERIOD_M1, g_period_384, g_applied_price_388, 0);
      if (l_imomentum_2744 >= 100.0) {
         ld_1216 = 1;
         ld_1600 = 0;
      }
      if (l_imomentum_2744 < 100.0) {
         ld_1216 = 0;
         ld_1600 = 1;
      }
      l_imomentum_2752 = iMomentum(NULL, PERIOD_M5, g_period_384, g_applied_price_388, 0);
      if (l_imomentum_2752 >= 100.0) {
         ld_1224 = 1;
         ld_1608 = 0;
      }
      if (l_imomentum_2752 < 100.0) {
         ld_1224 = 0;
         ld_1608 = 1;
      }
      l_imomentum_2760 = iMomentum(NULL, PERIOD_M15, g_period_384, g_applied_price_388, 0);
      if (l_imomentum_2760 >= 100.0) {
         ld_1232 = 1;
         ld_1616 = 0;
      }
      if (l_imomentum_2760 < 100.0) {
         ld_1232 = 0;
         ld_1616 = 1;
      }
      l_imomentum_2768 = iMomentum(NULL, PERIOD_M30, g_period_384, g_applied_price_388, 0);
      if (l_imomentum_2768 >= 100.0) {
         ld_1240 = 1;
         ld_1624 = 0;
      }
      if (l_imomentum_2768 < 100.0) {
         ld_1240 = 0;
         ld_1624 = 1;
      }
      l_imomentum_2776 = iMomentum(NULL, PERIOD_H1, g_period_384, g_applied_price_388, 0);
      if (l_imomentum_2776 >= 100.0) {
         ld_1248 = 1;
         ld_1632 = 0;
      }
      if (l_imomentum_2776 < 100.0) {
         ld_1248 = 0;
         ld_1632 = 1;
      }
      l_imomentum_2784 = iMomentum(NULL, PERIOD_H4, g_period_384, g_applied_price_388, 0);
      if (l_imomentum_2784 >= 100.0) {
         ld_1256 = 1;
         ld_1640 = 0;
      }
      if (l_imomentum_2784 < 100.0) {
         ld_1256 = 0;
         ld_1640 = 1;
      }
      l_imomentum_2792 = iMomentum(NULL, PERIOD_D1, g_period_384, g_applied_price_388, 0);
      if (l_imomentum_2792 >= 100.0) {
         ld_1264 = 1;
         ld_1648 = 0;
      }
      if (l_imomentum_2792 < 100.0) {
         ld_1264 = 0;
         ld_1648 = 1;
      }
      l_idemarker_2800 = iDeMarker(NULL, PERIOD_M1, g_period_400, 0);
      l_idemarker_2808 = iDeMarker(NULL, PERIOD_M1, g_period_400, 1);
      if (l_idemarker_2800 >= l_idemarker_2808) {
         ld_1280 = 1;
         ld_1664 = 0;
      }
      if (l_idemarker_2800 < l_idemarker_2808) {
         ld_1280 = 0;
         ld_1664 = 1;
      }
      l_idemarker_2816 = iDeMarker(NULL, PERIOD_M5, g_period_400, 0);
      l_idemarker_2824 = iDeMarker(NULL, PERIOD_M5, g_period_400, 1);
      if (l_idemarker_2816 >= l_idemarker_2824) {
         ld_1288 = 1;
         ld_1672 = 0;
      }
      if (l_idemarker_2816 < l_idemarker_2824) {
         ld_1288 = 0;
         ld_1672 = 1;
      }
      l_idemarker_2832 = iDeMarker(NULL, PERIOD_M15, g_period_400, 0);
      l_idemarker_2840 = iDeMarker(NULL, PERIOD_M15, g_period_400, 1);
      if (l_idemarker_2832 >= l_idemarker_2840) {
         ld_1296 = 1;
         ld_1680 = 0;
      }
      if (l_idemarker_2832 < l_idemarker_2840) {
         ld_1296 = 0;
         ld_1680 = 1;
      }
      l_idemarker_2848 = iDeMarker(NULL, PERIOD_M30, g_period_400, 0);
      l_idemarker_2856 = iDeMarker(NULL, PERIOD_M30, g_period_400, 1);
      if (l_idemarker_2848 >= l_idemarker_2856) {
         ld_1304 = 1;
         ld_1688 = 0;
      }
      if (l_idemarker_2848 < l_idemarker_2856) {
         ld_1304 = 0;
         ld_1688 = 1;
      }
      l_idemarker_2864 = iDeMarker(NULL, PERIOD_H1, g_period_400, 0);
      l_idemarker_2872 = iDeMarker(NULL, PERIOD_H1, g_period_400, 1);
      if (l_idemarker_2864 >= l_idemarker_2872) {
         ld_1312 = 1;
         ld_1696 = 0;
      }
      if (l_idemarker_2864 < l_idemarker_2872) {
         ld_1312 = 0;
         ld_1696 = 1;
      }
      l_idemarker_2880 = iDeMarker(NULL, PERIOD_H4, g_period_400, 0);
      l_idemarker_2888 = iDeMarker(NULL, PERIOD_H4, g_period_400, 1);
      if (l_idemarker_2880 >= l_idemarker_2888) {
         ld_1320 = 1;
         ld_1704 = 0;
      }
      if (l_idemarker_2880 < l_idemarker_2888) {
         ld_1320 = 0;
         ld_1704 = 1;
      }
      l_idemarker_2896 = iDeMarker(NULL, PERIOD_D1, g_period_400, 0);
      l_idemarker_2904 = iDeMarker(NULL, PERIOD_D1, g_period_400, 1);
      if (l_idemarker_2896 >= l_idemarker_2904) {
         ld_1328 = 1;
         ld_1712 = 0;
      }
      if (l_idemarker_2896 < l_idemarker_2904) {
         ld_1328 = 0;
         ld_1712 = 1;
      }
      ld_2912 = ld_0 + ld_64 + ld_128 + ld_192 + ld_256 + ld_320 + ld_384 + ld_448 + ld_1024 + ld_1088 + ld_1152 + ld_1216 + ld_1280;
      ld_2920 = ld_8 + ld_72 + ld_136 + ld_200 + ld_264 + ld_328 + ld_392 + ld_456 + ld_1032 + ld_1096 + ld_1160 + ld_1224 + ld_1288;
      ld_2928 = ld_16 + ld_80 + ld_144 + ld_208 + ld_272 + ld_336 + ld_400 + ld_464 + ld_1040 + ld_1104 + ld_1168 + ld_1232 + ld_1296;
      ld_2936 = ld_24 + ld_88 + ld_152 + ld_216 + ld_280 + ld_344 + ld_408 + ld_472 + ld_1048 + ld_1112 + ld_1176 + ld_1240 + ld_1304;
      ld_2944 = ld_32 + ld_96 + ld_160 + ld_224 + ld_288 + ld_352 + ld_416 + ld_480 + ld_1056 + ld_1120 + ld_1184 + ld_1248 + ld_1312;
      ld_2952 = ld_40 + ld_104 + ld_168 + ld_232 + ld_296 + ld_360 + ld_424 + ld_488 + ld_1064 + ld_1128 + ld_1192 + ld_1256 + ld_1320;
      ld_2960 = ld_48 + ld_112 + ld_176 + ld_240 + ld_304 + ld_368 + ld_432 + ld_496 + ld_1072 + ld_1136 + ld_1200 + ld_1264 + ld_1328;
      ld_2968 = ld_2912 + ld_2920 + ld_2928 + ld_2936 + ld_2944 + ld_2952 + ld_2960;
      ld_2976 = ld_512 + ld_576 + ld_640 + ld_704 + ld_768 + ld_832 + ld_896 + ld_960 + ld_1408 + ld_1472 + ld_1536 + ld_1600 + ld_1664;
      ld_2984 = ld_520 + ld_584 + ld_648 + ld_712 + ld_776 + ld_840 + ld_904 + ld_968 + ld_1416 + ld_1480 + ld_1544 + ld_1608 + ld_1672;
      ld_2992 = ld_528 + ld_592 + ld_656 + ld_720 + ld_784 + ld_848 + ld_912 + ld_976 + ld_1424 + ld_1488 + ld_1552 + ld_1616 + ld_1680;
      ld_3000 = ld_536 + ld_600 + ld_664 + ld_728 + ld_792 + ld_856 + ld_920 + ld_984 + ld_1432 + ld_1496 + ld_1560 + ld_1624 + ld_1688;
      ld_3008 = ld_544 + ld_608 + ld_672 + ld_736 + ld_800 + ld_864 + ld_928 + ld_992 + ld_1440 + ld_1504 + ld_1568 + ld_1632 + ld_1696;
      ld_3016 = ld_552 + ld_616 + ld_680 + ld_744 + ld_808 + ld_872 + ld_936 + ld_1000 + ld_1448 + ld_1512 + ld_1576 + ld_1640 + ld_1704;
      ld_3024 = ld_560 + ld_624 + ld_688 + ld_752 + ld_816 + ld_880 + ld_944 + ld_1008 + ld_1456 + ld_1520 + ld_1584 + ld_1648 + ld_1712;
      ld_3032 = ld_2976 + ld_2984 + ld_2992 + ld_3000 + ld_3008 + ld_3016 + ld_3024;
      ld_3040 = NormalizeDouble(100.0 * (ld_2968 / 91.0), 0);
      ld_3048 = NormalizeDouble(100.0 * (ld_3032 / 91.0), 0);
      if (ld_3040 < 70.0 || ld_3048 < 70.0) gi_468 = 0;
      if (ld_3040 >= 70.0) gi_468 = 1;
      if (ld_3040 >= 75.0) gi_468 = 2;
      if (ld_3040 >= 85.0) gi_468 = 3;
      if (ld_3048 >= 70.0) gi_468 = -1;
      if (ld_3048 >= 75.0) gi_468 = -2;
      if (ld_3048 >= 85.0) gi_468 = -3;
      if (ld_3040 >= 50.0) {
         gd_436 = ld_3040;
         g_color_444 = Lime;
      } else {
         gd_436 = ld_3048;
         g_color_444 = Red;
      }
      l_symbol_3056 = Symbol();
      l_dbl2str_3064 = DoubleToStr(iHigh(l_symbol_3056, PERIOD_H1, iHighest(l_symbol_3056, PERIOD_H1, MODE_HIGH, 24, 0)), Digits);
      ls_unused_3072 = DoubleToStr(MarketInfo(l_symbol_3056, MODE_ASK), Digits);
      l_dbl2str_3080 = DoubleToStr(MarketInfo(l_symbol_3056, MODE_BID), Digits);
      l_dbl2str_3088 = DoubleToStr(iLow(l_symbol_3056, PERIOD_H1, iLowest(l_symbol_3056, PERIOD_H1, MODE_LOW, 24, 0)), Digits);
      l_dbl2str_3096 = DoubleToStr((StrToDouble(l_dbl2str_3064) - StrToDouble(l_dbl2str_3088)) / Point, 0);
      l_dbl2str_3104 = DoubleToStr(100.0 * ((StrToDouble(l_dbl2str_3080) - StrToDouble(l_dbl2str_3088)) / StrToDouble(l_dbl2str_3096)) / Point,
         2);
      ld_3112 = Lookup(StrToDouble(l_dbl2str_3104));
      if (ld_3112 < 6.0 && ld_3112 > 3.0) gi_472 = 0;
      if (ld_3112 >= 6.0) gi_472 = 1;
      if (ld_3112 >= 7.0) gi_472 = 2;
      if (ld_3112 >= 8.0) gi_472 = 3;
      if (ld_3112 <= 3.0) gi_472 = -1;
      if (ld_3112 <= 2.0) gi_472 = -2;
      if (ld_3112 <= 1.0) gi_472 = -3;
      if (ld_3112 <= 2.0) g_color_448 = Red;
      if (ld_3112 > 2.0 && ld_3112 < 5.0) g_color_448 = DarkOrange;
      if (ld_3112 >= 5.0 && ld_3112 < 7.0) g_color_448 = Yellow;
      if (ld_3112 >= 7.0) g_color_448 = Lime;
      for (int l_index_3208 = 0; l_index_3208 < 19; l_index_3208++) {
         RefreshRates();
         l_symbol_3216 = gsa_404[l_index_3208];
         ls_3224 = StringSubstr(Symbol(), 6, 1);
         if (StringFind(AccountCompany(), "Interbank") == 0 && ls_3224 == "m") l_symbol_3216 = l_symbol_3216 + "m";
         ld_3200 = GetPoint(l_symbol_3216);
         lda_3124[l_index_3208] = iHigh(l_symbol_3216, PERIOD_H1, iHighest(l_symbol_3216, PERIOD_H1, MODE_HIGH, 24, 0));
         lda_3128[l_index_3208] = iLow(l_symbol_3216, PERIOD_H1, iLowest(l_symbol_3216, PERIOD_H1, MODE_LOW, 24, 0));
         lda_3132[l_index_3208] = MarketInfo(l_symbol_3216, MODE_BID);
         lda_3136[l_index_3208] = MarketInfo(l_symbol_3216, MODE_ASK);
         lda_3140[l_index_3208] = MarketInfo(l_symbol_3216, MODE_DIGITS);
         lda_3148[l_index_3208] = MathMax((lda_3124[l_index_3208] - lda_3128[l_index_3208]) / ld_3200, 1);
         lda_3144[l_index_3208] = (lda_3132[l_index_3208] - lda_3128[l_index_3208]) / lda_3148[l_index_3208] / ld_3200;
         lda_3152[l_index_3208] = iLookup(100.0 * lda_3144[l_index_3208]);
         lda_3156[l_index_3208] = 9 - lda_3152[l_index_3208];
      }
      lda_3120[0] = NormalizeDouble((lda_3152[3] + lda_3152[4] + lda_3152[5] + lda_3156[0] + lda_3156[1] + lda_3156[2] + lda_3156[13]) / 7.0,
         1);
      lda_3120[1] = NormalizeDouble((lda_3152[17] + lda_3152[0] + lda_3152[6] + lda_3152[7] + lda_3152[8] + lda_3152[9]) / 6.0, 1);
      lda_3120[2] = NormalizeDouble((lda_3152[1] + lda_3152[10] + lda_3152[11] + lda_3156[7]) / 4.0, 1);
      lda_3120[3] = NormalizeDouble((lda_3152[16] + lda_3156[4] + lda_3156[8] + lda_3156[11]) / 4.0, 1);
      lda_3120[4] = NormalizeDouble((lda_3156[18] + lda_3156[5] + lda_3156[17]) / 3.0, 1);
      lda_3120[5] = NormalizeDouble(0.2 * (lda_3152[2] + lda_3152[15] + lda_3152[18] + lda_3152[12] + lda_3156[9]), 1);
      lda_3120[6] = NormalizeDouble((lda_3156[3] + lda_3156[6] + lda_3156[10] + lda_3156[12] + lda_3156[14] + lda_3156[16]) / 6.0, 1);
      lda_3120[7] = NormalizeDouble((lda_3152[13] + lda_3152[14] + lda_3156[15]) / 3.0, 1);
      ls_unused_3232 = StringSubstr(Symbol(), 0, 3);
      ls_unused_3240 = StringSubstr(Symbol(), 3, 3);
      ls_3248 = StringSubstr(Symbol(), 0, 6);
      if (ls_3248 == "EURUSD") {
         li_3212 = 0;
         ld_3160 = lda_3120[1];
         ld_3168 = lda_3120[0];
      }
      if (ls_3248 == "GBPUSD") {
         li_3212 = 1;
         ld_3160 = lda_3120[2];
         ld_3168 = lda_3120[0];
      }
      if (ls_3248 == "AUDUSD") {
         li_3212 = 2;
         ld_3160 = lda_3120[5];
         ld_3168 = lda_3120[0];
      }
      if (ls_3248 == "USDJPY") {
         li_3212 = 3;
         ld_3160 = lda_3120[0];
         ld_3168 = lda_3120[6];
      }
      if (ls_3248 == "USDCHF") {
         li_3212 = 4;
         ld_3160 = lda_3120[0];
         ld_3168 = lda_3120[3];
      }
      if (ls_3248 == "USDCAD") {
         li_3212 = 5;
         ld_3160 = lda_3120[0];
         ld_3168 = lda_3120[4];
      }
      if (ls_3248 == "EURJPY") {
         li_3212 = 6;
         ld_3160 = lda_3120[1];
         ld_3168 = lda_3120[6];
      }
      if (ls_3248 == "EURGBP") {
         li_3212 = 7;
         ld_3160 = lda_3120[1];
         ld_3168 = lda_3120[2];
      }
      if (ls_3248 == "EURCHF") {
         li_3212 = 8;
         ld_3160 = lda_3120[1];
         ld_3168 = lda_3120[3];
      }
      if (ls_3248 == "EURAUD") {
         li_3212 = 9;
         ld_3160 = lda_3120[1];
         ld_3168 = lda_3120[5];
      }
      if (ls_3248 == "GBPJPY") {
         li_3212 = 10;
         ld_3160 = lda_3120[2];
         ld_3168 = lda_3120[6];
      }
      if (ls_3248 == "GBPCHF") {
         li_3212 = 11;
         ld_3160 = lda_3120[2];
         ld_3168 = lda_3120[3];
      }
      if (ls_3248 == "AUDJPY") {
         li_3212 = 12;
         ld_3160 = lda_3120[5];
         ld_3168 = lda_3120[6];
      }
      if (ls_3248 == "NZDUSD") {
         li_3212 = 13;
         ld_3160 = lda_3120[7];
         ld_3168 = lda_3120[0];
      }
      if (ls_3248 == "NZDJPY") {
         li_3212 = 14;
         ld_3160 = lda_3120[7];
         ld_3168 = lda_3120[6];
      }
      if (ls_3248 == "AUDNZD") {
         li_3212 = 15;
         ld_3160 = lda_3120[5];
         ld_3168 = lda_3120[7];
      }
      if (ls_3248 == "CHFJPY") {
         li_3212 = 16;
         ld_3160 = lda_3120[3];
         ld_3168 = lda_3120[6];
      }
      if (ls_3248 == "EURCAD") {
         li_3212 = 17;
         ld_3160 = lda_3120[1];
         ld_3168 = lda_3120[4];
      }
      if (ls_3248 == "AUDCAD") {
         li_3212 = 18;
         ld_3160 = lda_3120[5];
         ld_3168 = lda_3120[4];
      }
      ld_3256 = lda_3140[li_3212];
      ls_unused_3176 = DoubleToStr(lda_3124[li_3212], ld_3256);
      ls_unused_3184 = DoubleToStr(lda_3128[li_3212], ld_3256);
      ls_unused_3192 = DoubleToStr(lda_3148[li_3212], 0);
      ld_3264 = MathAbs(ld_3160 - ld_3168);
      if (ld_3264 < 3.0) gi_476 = 0;
      if (ld_3264 >= 3.0 && ld_3160 > ld_3168) gi_476 = 1;
      if (ld_3264 >= 5.0 && ld_3160 > ld_3168) gi_476 = 2;
      if (ld_3264 >= 7.0 && ld_3160 > ld_3168) gi_476 = 3;
      if (ld_3264 >= 3.0 && ld_3160 < ld_3168) gi_476 = -1;
      if (ld_3264 >= 5.0 && ld_3160 < ld_3168) gi_476 = -2;
      if (ld_3264 >= 7.0 && ld_3160 < ld_3168) gi_476 = -3;
      if (ld_3160 <= 2.5) g_color_452 = Red;
      if (ld_3160 > 2.5 && ld_3160 < 4.5) g_color_452 = DarkOrange;
      if (ld_3160 >= 4.5 && ld_3160 < 6.5) g_color_452 = Yellow;
      if (ld_3160 >= 6.5) g_color_452 = Lime;
      if (ld_3168 <= 2.5) g_color_456 = Red;
      if (ld_3168 > 2.5 && ld_3168 < 4.5) g_color_456 = DarkOrange;
      if (ld_3168 >= 4.5 && ld_3168 < 6.5) g_color_456 = Yellow;
      if (ld_3168 >= 6.5) g_color_456 = Lime;
      l_imacd_3272 = iMACD(Symbol(), 0, Fast_EMA, Slow_EMA, MACD_SMA, PRICE_CLOSE, MODE_SIGNAL, 0);
      l_imacd_3280 = iMACD(Symbol(), 0, Fast_EMA, Slow_EMA, MACD_SMA, PRICE_CLOSE, MODE_SIGNAL, 1);
      if (l_imacd_3272 >= 0.0 && l_imacd_3272 > l_imacd_3280) {
         gi_420 = 1;
         g_text_412 = "ì";
         g_color_460 = Lime;
      } else {
         if (l_imacd_3272 < 0.0 && l_imacd_3272 < l_imacd_3280) {
            gi_420 = -1;
            g_text_412 = "î";
            g_color_460 = Red;
         } else {
            gi_420 = 0;
            g_text_412 = "h";
            g_color_460 = DarkOrange;
         }
      }
      l_istochastic_3288 = iStochastic(Symbol(), 0, K_period, D_period, Slowing, MODE_SMA, 0, MODE_SIGNAL, 0);
      l_istochastic_3296 = iStochastic(Symbol(), 0, K_period, D_period, Slowing, MODE_SMA, 0, MODE_SIGNAL, 1);
      if (l_istochastic_3288 < 75.0 && l_istochastic_3288 < l_istochastic_3296) {
         gi_432 = -1;
         g_text_424 = "î";
         g_color_464 = Red;
      } else {
         if (l_istochastic_3288 > 25.0 && l_istochastic_3288 > l_istochastic_3296) {
            gi_432 = 1;
            g_text_424 = "ì";
            g_color_464 = Lime;
         } else {
            gi_432 = 0;
            g_text_424 = "h";
            g_color_464 = DarkOrange;
         }
      }
      li_3304 = gi_468 + gi_472 + gi_476 + gi_420 + gi_432;
      ld_3308 = 100.0 * (MathAbs(li_3304) / 11.0);
      if (li_3304 > 0) gs_unused_480 = "BUY";
      if (li_3304 < 0) gs_unused_480 = "SELL";
      l_text_3336 = StringSubstr(Symbol(), 0, 6);
      if (ld_3308 >= 0.0 && ld_3308 < 50.0 && li_3304 >= 0) {
         l_text_3316 = "Probability:   LONG ";
         l_color_3328 = Maroon;
         l_color_3332 = Green;
         l_color_3324 = Green;
      }
      if (ld_3308 >= 50.0 && ld_3308 < 75.0 && li_3304 >= 0) {
         l_text_3316 = "Probability:   LONG ";
         l_color_3328 = Green;
         l_color_3332 = Lime;
         l_color_3324 = Green;
      }
      if (ld_3308 >= 75.0 && ld_3308 < 90.0 && li_3304 >= 0) {
         l_text_3316 = "Probability:   LONG ";
         l_color_3328 = MediumSeaGreen;
         l_color_3332 = Lime;
         l_color_3324 = MediumSeaGreen;
      }
      if (ld_3308 >= 90.0 && li_3304 >= 0) {
         l_text_3316 = "Probability:   LONG ";
         l_color_3328 = Lime;
         l_color_3332 = Lime;
         l_color_3324 = Lime;
      }
      if (ld_3308 >= 0.0 && ld_3308 < 50.0 && li_3304 < 0) {
         l_text_3316 = "Probability:   SHORT ";
         l_color_3328 = Green;
         l_color_3332 = Maroon;
         l_color_3324 = Maroon;
      }
      if (ld_3308 >= 50.0 && ld_3308 < 75.0 && li_3304 < 0) {
         l_text_3316 = "Probability:   SHORT ";
         l_color_3328 = Maroon;
         l_color_3332 = Red;
         l_color_3324 = Maroon;
      }
      if (ld_3308 >= 75.0 && ld_3308 < 90.0 && li_3304 < 0) {
         l_text_3316 = "Probability:   SHORT ";
         l_color_3328 = Chocolate;
         l_color_3332 = Red;
         l_color_3324 = Chocolate;
      }
      if (ld_3308 >= 90.0 && li_3304 < 0) {
         l_text_3316 = "Probability:   SHORT ";
         l_color_3328 = Red;
         l_color_3332 = Red;
         l_color_3324 = Red;
      }
      gd_204 = Period();
      if (gd_204 == 1.0) gs_196 = "M1";
      if (gd_204 == 5.0) gs_196 = "M5";
      if (gd_204 == 15.0) gs_196 = "M15";
      if (gd_204 == 30.0) gs_196 = "M30";
      if (gd_204 == 60.0) gs_196 = "H1";
      if (gd_204 == 240.0) gs_196 = "H4";
      if (gd_204 == 1440.0) gs_196 = "D1";
      if (gd_204 == 10080.0) gs_196 = "W1";
      if (gd_204 == 43200.0) gs_196 = "MN";
      if (ld_3308 >= Alert_Trigger && li_3304 > 0 && gi_192 != Time[0]) {
         if (SignalAlert) Alert("Probability Strong UP Trend - ", Symbol(), " ", gs_196, " at ", TimeToStr(TimeCurrent(), TIME_SECONDS));
         if (SendAlertEmail) SendMail("Probability signal", "Probability Strong UP Trend - " + Symbol() + " " + gs_196 + " at " + TimeToStr(TimeCurrent(), TIME_SECONDS) + " (server time)");
         gi_192 = Time[0];
      }
      if (ld_3308 >= Alert_Trigger && li_3304 < 0 && gi_192 != Time[0]) {
         if (SignalAlert) Alert("Probability Strong DOWN Trend - ", Symbol(), " ", gs_196, " at ", TimeToStr(TimeCurrent(), TIME_SECONDS));
         if (SendAlertEmail) SendMail("Probability signal", "Probability Strong DOWN Trend - " + Symbol() + " " + gs_196 + " at " + TimeToStr(TimeCurrent(), TIME_SECONDS) + " (server time)");
         gi_192 = Time[0];
      }
      if (!Show.Values.Only) {
         ObjectCreate("_symbol_", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("_symbol_", l_text_3336, 7, "Arial Black", colorsymbol);
         ObjectSet("_symbol_", OBJPROP_CORNER, 3);
         ObjectSet("_symbol_", OBJPROP_XDISTANCE, X_box + 13);
         ObjectSet("_symbol_", OBJPROP_YDISTANCE, Y_box + 124);
         ObjectCreate("_line1", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("_line1", "----------------------------------------------", 9, "Arial", colorline);
         ObjectSet("_line1", OBJPROP_CORNER, 3);
         ObjectSet("_line1", OBJPROP_XDISTANCE, X_box + 10);
         ObjectSet("_line1", OBJPROP_YDISTANCE, Y_box + 117);
         ObjectCreate("trend_logo_1", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("trend_logo_1", ".:", 14, "Arial Black", l_color_3328);
         ObjectSet("trend_logo_1", OBJPROP_CORNER, 3);
         ObjectSet("trend_logo_1", OBJPROP_XDISTANCE, X_box + 177);
         ObjectSet("trend_logo_1", OBJPROP_YDISTANCE, Y_box + 102);
         ObjectCreate("trend_logo_2", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("trend_logo_2", ":.", 14, "Arial Black", l_color_3332);
         ObjectSet("trend_logo_2", OBJPROP_CORNER, 3);
         ObjectSet("trend_logo_2", OBJPROP_XDISTANCE, X_box + 166);
         ObjectSet("trend_logo_2", OBJPROP_YDISTANCE, Y_box + 102);
         ObjectCreate("trend_comment_", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("trend_comment_", l_text_3316, 7, "Verdana", colortext);
         ObjectSet("trend_comment_", OBJPROP_CORNER, 3);
         ObjectSet("trend_comment_", OBJPROP_XDISTANCE, X_box + 46);
         ObjectSet("trend_comment_", OBJPROP_YDISTANCE, Y_box + 107);
         ObjectCreate("prop_value", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("prop_value", " " + DoubleToStr(ld_3308, 0) + "%", 9, "Arial Black", l_color_3324);
         ObjectSet("prop_value", OBJPROP_CORNER, 3);
         ObjectSet("prop_value", OBJPROP_XDISTANCE, X_box + 13);
         ObjectSet("prop_value", OBJPROP_YDISTANCE, Y_box + 104);
         ObjectCreate("_line2", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("_line2", "----------------------------------------------", 9, "Arial", colorline);
         ObjectSet("_line2", OBJPROP_CORNER, 3);
         ObjectSet("_line2", OBJPROP_XDISTANCE, X_box + 10);
         ObjectSet("_line2", OBJPROP_YDISTANCE, Y_box + 96);
         ObjectCreate("multi_logo", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("multi_logo", "-", 42, "Arial Black", g_color_444);
         ObjectSet("multi_logo", OBJPROP_CORNER, 3);
         ObjectSet("multi_logo", OBJPROP_XDISTANCE, X_box + 163);
         ObjectSet("multi_logo", OBJPROP_YDISTANCE, Y_box + 61);
         ObjectCreate("multi_logo2", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("multi_logo2", "-", 42, "Arial Black", g_color_444);
         ObjectSet("multi_logo2", OBJPROP_CORNER, 3);
         ObjectSet("multi_logo2", OBJPROP_XDISTANCE, X_box + 173);
         ObjectSet("multi_logo2", OBJPROP_YDISTANCE, Y_box + 61);
         ObjectCreate("multi_score", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("multi_score", DoubleToStr(gd_436, 0), 7, "Verdana", colorvalues);
         ObjectSet("multi_score", OBJPROP_CORNER, 3);
         ObjectSet("multi_score", OBJPROP_XDISTANCE, X_box + 171);
         ObjectSet("multi_score", OBJPROP_YDISTANCE, Y_box + 87);
         ObjectCreate("multi_comment", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("multi_comment", "Multi-Info+", 7, "Verdana", colortext);
         ObjectSet("multi_comment", OBJPROP_CORNER, 3);
         ObjectSet("multi_comment", OBJPROP_XDISTANCE, X_box + 13);
         ObjectSet("multi_comment", OBJPROP_YDISTANCE, Y_box + 87);
         ObjectCreate("ind_logo", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("ind_logo", "-", 42, "Arial Black", g_color_448);
         ObjectSet("ind_logo", OBJPROP_CORNER, 3);
         ObjectSet("ind_logo", OBJPROP_XDISTANCE, X_box + 163);
         ObjectSet("ind_logo", OBJPROP_YDISTANCE, Y_box + 46);
         ObjectCreate("ind_logo2", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("ind_logo2", "-", 42, "Arial Black", g_color_448);
         ObjectSet("ind_logo2", OBJPROP_CORNER, 3);
         ObjectSet("ind_logo2", OBJPROP_XDISTANCE, X_box + 173);
         ObjectSet("ind_logo2", OBJPROP_YDISTANCE, Y_box + 46);
         ObjectCreate("ind_score", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("ind_score", DoubleToStr(ld_3112, 0), 7, "Verdana", colorvalues);
         ObjectSet("ind_score", OBJPROP_CORNER, 3);
         ObjectSet("ind_score", OBJPROP_XDISTANCE, X_box + 175);
         ObjectSet("ind_score", OBJPROP_YDISTANCE, Y_box + 72);
         ObjectCreate("ind_comment", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("ind_comment", "Indice Strength", 7, "Verdana", colortext);
         ObjectSet("ind_comment", OBJPROP_CORNER, 3);
         ObjectSet("ind_comment", OBJPROP_XDISTANCE, X_box + 13);
         ObjectSet("ind_comment", OBJPROP_YDISTANCE, Y_box + 72);
         ObjectCreate("cur_logo", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("cur_logo", "-", 42, "Arial Black", g_color_456);
         ObjectSet("cur_logo", OBJPROP_CORNER, 3);
         ObjectSet("cur_logo", OBJPROP_XDISTANCE, X_box + 163);
         ObjectSet("cur_logo", OBJPROP_YDISTANCE, Y_box + 31);
         ObjectCreate("cur_logo2", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("cur_logo2", "-", 42, "Arial Black", g_color_452);
         ObjectSet("cur_logo2", OBJPROP_CORNER, 3);
         ObjectSet("cur_logo2", OBJPROP_XDISTANCE, X_box + 173);
         ObjectSet("cur_logo2", OBJPROP_YDISTANCE, Y_box + 31);
         ObjectCreate("cur_score", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("cur_score", DoubleToStr(MathRound(ld_3160), 0) + " - " + DoubleToStr(MathRound(ld_3168), 0), 7, "Verdana", colorvalues);
         ObjectSet("cur_score", OBJPROP_CORNER, 3);
         ObjectSet("cur_score", OBJPROP_XDISTANCE, X_box + 166);
         ObjectSet("cur_score", OBJPROP_YDISTANCE, Y_box + 57);
         ObjectCreate("cur_comment", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("cur_comment", "Currency Pair Range", 7, "Verdana", colortext);
         ObjectSet("cur_comment", OBJPROP_CORNER, 3);
         ObjectSet("cur_comment", OBJPROP_XDISTANCE, X_box + 13);
         ObjectSet("cur_comment", OBJPROP_YDISTANCE, Y_box + 57);
         ObjectCreate("sn_logo", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("sn_logo", "-", 42, "Arial Black", g_color_460);
         ObjectSet("sn_logo", OBJPROP_CORNER, 3);
         ObjectSet("sn_logo", OBJPROP_XDISTANCE, X_box + 163);
         ObjectSet("sn_logo", OBJPROP_YDISTANCE, Y_box + 16);
         ObjectCreate("sn_logo2", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("sn_logo2", "-", 42, "Arial Black", g_color_460);
         ObjectSet("sn_logo2", OBJPROP_CORNER, 3);
         ObjectSet("sn_logo2", OBJPROP_XDISTANCE, X_box + 173);
         ObjectSet("sn_logo2", OBJPROP_YDISTANCE, Y_box + 16);
         ObjectCreate("sn_score", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("sn_score", g_text_412, 7, "Wingdings", colorvalues);
         ObjectSet("sn_score", OBJPROP_CORNER, 3);
         ObjectSet("sn_score", OBJPROP_XDISTANCE, X_box + 173);
         ObjectSet("sn_score", OBJPROP_YDISTANCE, Y_box + 42);
         ObjectCreate("sn_comment", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("sn_comment", "MACD Indicator", 7, "Verdana", colortext);
         ObjectSet("sn_comment", OBJPROP_CORNER, 3);
         ObjectSet("sn_comment", OBJPROP_XDISTANCE, X_box + 13);
         ObjectSet("sn_comment", OBJPROP_YDISTANCE, Y_box + 42);
         ObjectCreate("fis_logo", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("fis_logo", "-", 42, "Arial Black", g_color_464);
         ObjectSet("fis_logo", OBJPROP_CORNER, 3);
         ObjectSet("fis_logo", OBJPROP_XDISTANCE, X_box + 163);
         ObjectSet("fis_logo", OBJPROP_YDISTANCE, Y_box + 1);
         ObjectCreate("fis_logo2", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("fis_logo2", "-", 42, "Arial Black", g_color_464);
         ObjectSet("fis_logo2", OBJPROP_CORNER, 3);
         ObjectSet("fis_logo2", OBJPROP_XDISTANCE, X_box + 173);
         ObjectSet("fis_logo2", OBJPROP_YDISTANCE, Y_box + 1);
         ObjectCreate("fis_score", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("fis_score", g_text_424, 7, "Wingdings", colorvalues);
         ObjectSet("fis_score", OBJPROP_CORNER, 3);
         ObjectSet("fis_score", OBJPROP_XDISTANCE, X_box + 173);
         ObjectSet("fis_score", OBJPROP_YDISTANCE, Y_box + 28);
         ObjectCreate("fis_comment", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("fis_comment", "Stochastic Indicator", 7, "Verdana", colortext);
         ObjectSet("fis_comment", OBJPROP_CORNER, 3);
         ObjectSet("fis_comment", OBJPROP_XDISTANCE, X_box + 13);
         ObjectSet("fis_comment", OBJPROP_YDISTANCE, Y_box + 27);
         ObjectCreate("_line3", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("_line3", "----------------------------------------------", 9, "Arial", colorline);
         ObjectSet("_line3", OBJPROP_CORNER, 3);
         ObjectSet("_line3", OBJPROP_XDISTANCE, X_box + 10);
         ObjectSet("_line3", OBJPROP_YDISTANCE, Y_box + 17);
         ObjectCreate("copyright", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("copyright", "»»»  Probability Meter © Copyright FerruFx  «««", 8, "Arial Narrow", colorline);
         ObjectSet("copyright", OBJPROP_CORNER, 3);
         ObjectSet("copyright", OBJPROP_XDISTANCE, X_box + 12);
         ObjectSet("copyright", OBJPROP_YDISTANCE, Y_box + 11);
      } else {
         ObjectCreate("_symbol_", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("_symbol_", l_text_3336, 7, "Arial Black", colorsymbol);
         ObjectSet("_symbol_", OBJPROP_CORNER, 3);
         ObjectSet("_symbol_", OBJPROP_XDISTANCE, X_box + 19);
         ObjectSet("_symbol_", OBJPROP_YDISTANCE, Y_box + 150);
         ObjectCreate("_line1", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("_line1", "-----------------------------------", 9, "Arial", colorline);
         ObjectSet("_line1", OBJPROP_CORNER, 3);
         ObjectSet("_line1", OBJPROP_ANGLE, 90);
         ObjectSet("_line1", OBJPROP_XDISTANCE, X_box + 60);
         ObjectSet("_line1", OBJPROP_YDISTANCE, Y_box + 149);
         ObjectCreate("trend_logo_1", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("trend_logo_1", ".:", 14, "Arial Black", l_color_3328);
         ObjectSet("trend_logo_1", OBJPROP_CORNER, 3);
         ObjectSet("trend_logo_1", OBJPROP_XDISTANCE, X_box + 39);
         ObjectSet("trend_logo_1", OBJPROP_YDISTANCE, Y_box + 130);
         ObjectCreate("trend_logo_2", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("trend_logo_2", ":.", 14, "Arial Black", l_color_3332);
         ObjectSet("trend_logo_2", OBJPROP_CORNER, 3);
         ObjectSet("trend_logo_2", OBJPROP_XDISTANCE, X_box + 28);
         ObjectSet("trend_logo_2", OBJPROP_YDISTANCE, Y_box + 130);
         ObjectCreate("_line6", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("_line6", "------------", 9, "Arial", colorline);
         ObjectSet("_line6", OBJPROP_CORNER, 3);
         ObjectSet("_line6", OBJPROP_XDISTANCE, X_box + 16);
         ObjectSet("_line6", OBJPROP_YDISTANCE, Y_box + 125);
         if (ld_3308 > 99.0) li_3344 = 0;
         else {
            if (ld_3308 > 9.9) li_3344 = 2;
            else li_3344 = 7;
         }
         ObjectCreate("prop_value", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("prop_value", " " + DoubleToStr(ld_3308, 0) + "%", 12, "Arial Black", l_color_3324);
         ObjectSet("prop_value", OBJPROP_CORNER, 3);
         ObjectSet("prop_value", OBJPROP_XDISTANCE, li_3344 + 18 + X_box);
         ObjectSet("prop_value", OBJPROP_YDISTANCE, Y_box + 110);
         ObjectCreate("_line2", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("_line2", "-----------------------------------", 9, "Arial", colorline);
         ObjectSet("_line2", OBJPROP_CORNER, 3);
         ObjectSet("_line2", OBJPROP_ANGLE, 90);
         ObjectSet("_line2", OBJPROP_XDISTANCE, X_box + 7);
         ObjectSet("_line2", OBJPROP_YDISTANCE, Y_box + 149);
         DrawBackBoxes("multi_logo1", X_box + 15, Y_box + 81, g_color_444);
         DrawBackBoxes("multi_logo2", X_box + 38, Y_box + 81, g_color_444);
         ObjectCreate("multi_score", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("multi_score", DoubleToStr(gd_436, 0), 14, "Arial Black", colorvalues);
         ObjectSet("multi_score", OBJPROP_CORNER, 3);
         ObjectSet("multi_score", OBJPROP_XDISTANCE, X_box + 28);
         ObjectSet("multi_score", OBJPROP_YDISTANCE, Y_box + 86);
         DrawBackBoxes("ind_logo1", X_box + 15, Y_box + 61, g_color_448);
         DrawBackBoxes("ind_logo2", X_box + 38, Y_box + 61, g_color_448);
         ObjectCreate("ind_score", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("ind_score", DoubleToStr(ld_3112, 0), 14, "Arial Black", colorvalues);
         ObjectSet("ind_score", OBJPROP_CORNER, 3);
         ObjectSet("ind_score", OBJPROP_XDISTANCE, X_box + 34);
         ObjectSet("ind_score", OBJPROP_YDISTANCE, Y_box + 66);
         DrawBackBoxes("cur_logo1", X_box + 15, Y_box + 41, g_color_456);
         DrawBackBoxes("cur_logo2", X_box + 38, Y_box + 41, g_color_452);
         ObjectCreate("cur_score", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("cur_score", DoubleToStr(MathRound(ld_3160), 0) + " - " + DoubleToStr(MathRound(ld_3168), 0), 14, "Arial Black", colorvalues);
         ObjectSet("cur_score", OBJPROP_CORNER, 3);
         ObjectSet("cur_score", OBJPROP_XDISTANCE, X_box + 18);
         ObjectSet("cur_score", OBJPROP_YDISTANCE, Y_box + 46);
         DrawBackBoxes("sn_logo1", X_box + 15, Y_box + 21, g_color_460);
         DrawBackBoxes("sn_logo2", X_box + 38, Y_box + 21, g_color_460);
         ObjectCreate("sn_score", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("sn_score", g_text_412, 14, "Wingdings", colorvalues);
         ObjectSet("sn_score", OBJPROP_CORNER, 3);
         ObjectSet("sn_score", OBJPROP_XDISTANCE, X_box + 30);
         ObjectSet("sn_score", OBJPROP_YDISTANCE, Y_box + 28);
         DrawBackBoxes("fis_logo1", X_box + 15, Y_box + 1, g_color_464);
         DrawBackBoxes("fis_logo2", X_box + 38, Y_box + 1, g_color_464);
         ObjectCreate("fis_score", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("fis_score", g_text_424, 14, "Wingdings", colorvalues);
         ObjectSet("fis_score", OBJPROP_CORNER, 3);
         ObjectSet("fis_score", OBJPROP_XDISTANCE, X_box + 30);
         ObjectSet("fis_score", OBJPROP_YDISTANCE, Y_box + 8);
         ObjectCreate("_line3", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("_line3", "------------", 9, "Arial", colorline);
         ObjectSet("_line3", OBJPROP_CORNER, 3);
         ObjectSet("_line3", OBJPROP_XDISTANCE, X_box + 16);
         ObjectSet("_line3", OBJPROP_YDISTANCE, Y_box + 143);
         ObjectCreate("_line4", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("_line4", "------------", 9, "Arial", colorline);
         ObjectSet("_line4", OBJPROP_CORNER, 3);
         ObjectSet("_line4", OBJPROP_XDISTANCE, X_box + 16);
         ObjectSet("_line4", OBJPROP_YDISTANCE, Y_box + 103);
         ObjectCreate("_line5", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("_line5", "------------", 9, "Arial", colorline);
         ObjectSet("_line5", OBJPROP_CORNER, 3);
         ObjectSet("_line5", OBJPROP_XDISTANCE, X_box + 16);
         ObjectSet("_line5", OBJPROP_YDISTANCE, Y_box + 1);
         ObjectCreate("copyright", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("copyright", "Probability Meter©Copyright FerruFx", 8, "Arial Narrow", colorline);
         ObjectSet("copyright", OBJPROP_CORNER, 3);
         ObjectSet("copyright", OBJPROP_ANGLE, 90);
         ObjectSet("copyright", OBJPROP_XDISTANCE, X_box + 1);
         ObjectSet("copyright", OBJPROP_YDISTANCE, Y_box + 148);
      }
   return (0);
   }

int Lookup(double ad_0) {
   int li_ret_12;
   int lia_8[10] = {0, 3, 10, 25, 40, 50, 60, 75, 90, 97};
   if (ad_0 <= lia_8[0]) li_ret_12 = 0;
   else {
      if (ad_0 < lia_8[1]) li_ret_12 = 0;
      else {
         if (ad_0 < lia_8[2]) li_ret_12 = 1;
         else {
            if (ad_0 < lia_8[3]) li_ret_12 = 2;
            else {
               if (ad_0 < lia_8[4]) li_ret_12 = 3;
               else {
                  if (ad_0 < lia_8[5]) li_ret_12 = 4;
                  else {
                     if (ad_0 < lia_8[6]) li_ret_12 = 5;
                     else {
                        if (ad_0 < lia_8[7]) li_ret_12 = 6;
                        else {
                           if (ad_0 < lia_8[8]) li_ret_12 = 7;
                           else {
                              if (ad_0 < lia_8[9]) li_ret_12 = 8;
                              else li_ret_12 = 9;
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }
   return (li_ret_12);
}

double GetPoint(string as_0) {
   double ld_ret_8 = 0.0001;
   double ld_ret_16 = 0.01;
   string ls_24 = StringSubstr(as_0, 0, 6);
   if (ls_24 == "USDJPY") return (ld_ret_16);
   if (ls_24 == "EURJPY") return (ld_ret_16);
   if (ls_24 == "GBPJPY") return (ld_ret_16);
   if (ls_24 == "AUDJPY") return (ld_ret_16);
   if (ls_24 == "NZDJPY") return (ld_ret_16);
   if (ls_24 == "CHFJPY") return (ld_ret_16);
   return (ld_ret_8);
}

int iLookup(double ad_0) {
   int li_ret_12;
   int lia_8[10] = {0, 3, 10, 25, 40, 50, 60, 75, 90, 97};
   if (ad_0 <= lia_8[0]) li_ret_12 = 0;
   else {
      if (ad_0 < lia_8[1]) li_ret_12 = 0;
      else {
         if (ad_0 < lia_8[2]) li_ret_12 = 1;
         else {
            if (ad_0 < lia_8[3]) li_ret_12 = 2;
            else {
               if (ad_0 < lia_8[4]) li_ret_12 = 3;
               else {
                  if (ad_0 < lia_8[5]) li_ret_12 = 4;
                  else {
                     if (ad_0 < lia_8[6]) li_ret_12 = 5;
                     else {
                        if (ad_0 < lia_8[7]) li_ret_12 = 6;
                        else {
                           if (ad_0 < lia_8[8]) li_ret_12 = 7;
                           else {
                              if (ad_0 < lia_8[9]) li_ret_12 = 8;
                              else li_ret_12 = 9;
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }
   return (li_ret_12);
}

int DelUnauthorized() {
   ObjectDelete("_Alert1");
   ObjectDelete("_Alert2");
   ObjectDelete("_Alert3");
   ObjectDelete("_Alert4");
   return (0);
}

void DrawBackBoxes(string as_0, int a_x_8, int ai_12, color a_color_16) {
   string l_name_24;
   for (int l_count_20 = 0; l_count_20 < 6; l_count_20++) {
      l_name_24 = "back_" + as_0 + l_count_20;
      if (ObjectFind(l_name_24) == -1) ObjectCreate(l_name_24, OBJ_LABEL, 0, 0, 0);
      ObjectSet(l_name_24, OBJPROP_CORNER, 3);
      ObjectSet(l_name_24, OBJPROP_XDISTANCE, a_x_8);
      ObjectSet(l_name_24, OBJPROP_YDISTANCE, ai_12 + 3 * l_count_20);
      ObjectSetText(l_name_24, "_", 40, "Arial Black", a_color_16);
   }
}