//+------------------------------------------------------------------+
//|                         FerruFx_Multi_info+_light_chart_v1.1.mq4 |
//|                                        Copyright © 2007, FerruFx |
//|                                                                  |
//+------------------------------------------------------------------+

// Version "Light": only the results are displayed

// Version "Light" v1.1: you can choose which indicators and TF you want to calculate the trend

#property indicator_chart_window

#property indicator_minimum 0
#property indicator_maximum 1

//---- Positionning the boxs
extern string    Trade_info_box            = "=== Trade Info Box ===";
extern bool      box_trade_analysis    =    true;
extern int       X_trade_analysis      =      10;
extern int       Y_analysis            =      20;

extern string    Trend_box             = "=== Trend Box ===";
extern bool      box_trend             =    true;
extern int       X_trend               =     170;
extern int       Y_trend               =      20;

extern string    Pivots_box            = "=== Pivots Box ===";
extern bool      box_pivots            =    true;
extern int       X_pivots              =      17;
extern int       Y_pivots              =     200;

extern string    Range_box             = "=== Range Box ===";
extern bool      box_range             =    true;
extern int       X_range               =     150;
extern int       Y_range               =     200;

//---- Open trade info parameters
extern string    Trade_info            = "=== Trade Info ===";
extern bool      AccountMini           =     true;  // If false, account is standard
extern double    LeverageToTrade       =      5.0;  // Leverage which you want to trade per position (e.g. you have a 200:1 account and you want to trade 10:1 of this leverage, just put 10)
extern double    PipValue              =    0.832;  // Pip Value

//---- Level to change the strength "weak" to "strong"
extern double TrendStrongLevel = 75.00;

//---- Indicators to calculate the trend
extern string    Trend_calculation     = "=== Trend calculation and display ===";
extern bool      display_fast_MA       =     true;
extern bool      display_medium_MA     =     true;
extern bool      display_slow_MA       =     true;
extern bool      display_CCI           =     true;
extern bool      display_MACD          =     true;
extern bool      display_ADX           =     true;
extern bool      display_BULLS         =     true;
extern bool      display_BEARS         =     true;
extern bool      display_STOCH         =     true;
extern bool      display_RSI           =     true;
extern bool      display_FORCE         =     true;
extern bool      display_MOMENTUM      =     true;
extern bool      display_DeMARKER      =     true;
extern bool      display_WAE           =     true;

//---- Timeframes to display and calculate the trend
extern string    TF_calculation        = "=== If display false, set coef to 0 ===";
extern string    Coefs_TF              = "3 TF true, SUM of their coef must be 3";
extern bool      display_M1            =     true;
extern double    coef_m1               =      1.0;
extern bool      display_M5            =     true;
extern double    coef_m5               =      1.0;
extern bool      display_M15           =     true;
extern double    coef_m15              =      1.0;
extern bool      display_M30           =     true;
extern double    coef_m30              =      1.0;
extern bool      display_H1            =     true;
extern double    coef_H1               =      1.0;
extern bool      display_H4            =     true;
extern double    coef_H4               =      1.0;
extern bool      display_D1            =     true;
extern double    coef_D1               =      1.0;

//---- Indicators parameters
extern string    Shift_Settings_test_only        = "=== Format: 2007.05.07 00:00 ===";
extern datetime  look_time_shift       = D'2007.05.07 00:00';  // Shift for test if "test" is true
extern double    shift_indicators      =                   0;  // Shift for indicators if "test" is false
extern bool      test                  =               false;

string    MA_Settings           = "=== Moving Average Settings ===";
int       FastMAPeriod          =           20;  // Fast Moving Average period
int       MediumMAPeriod        =           50;  // Medium Moving Average period
int       SlowMAPeriod          =          100;  // Slow Moving Average period
int       MAMethod              =     MODE_EMA;  // Moving Average method
int       MAPrice               =  PRICE_CLOSE;  // Moving Average price

string    CCI_Settings          = "=== CCI Settings ===";
int       CCIPeriod             =           14;  // Commodity Channel Index  period
int       CCIPrice              =  PRICE_CLOSE;  // CCI price

string    MACD_Settings         = "=== MACD Settings ===";
int       MACDFast              =           12;  // MACD fast EMA period
int       MACDSlow              =           26;  // MACD slow EMA period
int       MACDSignal            =            9;  // MACD signal SMA period

string    ADX_Settings          = "=== ADX Settings ===";
int       ADXPeriod             =           14;  // Average Directional movement  period
int       ADXPrice              =  PRICE_CLOSE;  // ADX price

string    BULLS_Settings        = "=== BULLS Settings ===";
int       BULLSPeriod           =           13;  // Bulls Power  period
int       BULLSPrice            =  PRICE_CLOSE;  // Bulls Power price

string    BEARS_Settings        = "=== BEARS Settings ===";
int       BEARSPeriod           =           13;  // Bears Power  period
int       BEARSPrice            =  PRICE_CLOSE;  // Bears Power price

string    STOCHASTIC_Settings   = "=== STOCHASTIC Settings ===";
int       STOKPeriod            =            5;  // Stochastic %K  period
int       STODPeriod            =            3;  // Stochastic %D  period
int       STOSlowing            =            3;  // Stochastic slowing

string    RSI_Settings          = "=== RSI Settings ===";
int       RSIPeriod             =           14;  // RSI  period

string    FORCE_Settings        = "=== FORCE INDEX Settings ===";
int       FIPeriod              =           14;  // Force Index period
int       FIMethod              =     MODE_SMA;  // Force Index method
int       FIPrice               =  PRICE_CLOSE;  // Force Index price

string    MOMENTUM_Settings     = "=== MOMENTUM INDEX Settings ===";
int       MOMPeriod             =           14;  // Momentum period
int       MOMPrice              =  PRICE_CLOSE;  // Momentum price

string    DeMARKER_Settings     = "=== DeMARKER Settings ===";
int       DEMPeriod             =           14;  // DeMarker  period



int TimeZone=0;
bool pivots = true;
bool alert = true;

double yesterday_high=0;
double yesterday_open=0;
double yesterday_low=0;
double yesterday_close=0;
double today_open=0;
double today_high=0;
double today_low=0;

double rates_h1[2][6];
double rates_d1[2][6];



//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {



//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----


   ObjectDelete("timeframe");
   ObjectDelete("line1");
   ObjectDelete("stoploss");
   ObjectDelete("Stop");
   ObjectDelete("pipstostop");
   ObjectDelete("PipsStop");
   ObjectDelete("line2");
   ObjectDelete("pipsprofit");
   ObjectDelete("pips_profit");
   ObjectDelete("percentbalance");
   ObjectDelete("percent_profit");
   ObjectDelete("line3");
   ObjectDelete("maxlot1");
   ObjectDelete("maxlot2");
   ObjectDelete("line4");
   ObjectDelete("pivots");
   ObjectDelete("line5");
   ObjectDelete("R3_Label");
   ObjectDelete("R3_Value");
   ObjectDelete("R2_Label");
   ObjectDelete("R2_Value");
   ObjectDelete("R1_Label");
   ObjectDelete("R1_Value");
   ObjectDelete("Pivot_Label");
   ObjectDelete("Pivot_Value");
   ObjectDelete("S1_Label");
   ObjectDelete("S1_Value");
   ObjectDelete("S2_Label");
   ObjectDelete("S2_Value");
   ObjectDelete("S3_Label");
   ObjectDelete("S3_Value");
   ObjectDelete("daily_range");
   ObjectDelete("line6");
   ObjectDelete("today");
   ObjectDelete("today_range");
   ObjectDelete("yesterday");
   ObjectDelete("yesterday_range");
   ObjectDelete("5_days");
   ObjectDelete("5_days_range");
   ObjectDelete("10_days");
   ObjectDelete("10_days_range");
   ObjectDelete("20_days");
   ObjectDelete("20_days_range");
   ObjectDelete("50_days");
   ObjectDelete("50_days_range");
   ObjectDelete("line7");
   ObjectDelete("Average");
   ObjectDelete("Average_range");
   ObjectDelete("line8");
   
   ObjectDelete("Trend_UP");
   ObjectDelete("line9");
   ObjectDelete("Trend_UP_text");
   ObjectDelete("Trend_UP_value");
   ObjectDelete("Trend_DOWN_text");
   ObjectDelete("Trend_DOWN_value");
   ObjectDelete("line10");
   ObjectDelete("line12");
   ObjectDelete("Trend");
   ObjectDelete("Trend_comment");
   ObjectDelete("line13");
   ObjectDelete("line11");
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
  
double UP_1, UP_2, UP_3, UP_4, UP_5, UP_6, UP_7, UP_8, UP_9, UP_10;
double UP_11, UP_12, UP_13, UP_14, UP_15, UP_16, UP_17, UP_18, UP_19, UP_20;
double UP_21, UP_22, UP_23, UP_24, UP_25, UP_26, UP_27, UP_28, UP_29, UP_30;
double UP_31, UP_32, UP_33, UP_34, UP_35, UP_36, UP_37, UP_38, UP_39, UP_40;
double UP_41, UP_42, UP_43, UP_44, UP_45, UP_46, UP_47, UP_48, UP_49, UP_50;
double UP_51, UP_52, UP_53, UP_54, UP_55, UP_56, UP_57, UP_58, UP_59, UP_60;
double UP_61, UP_62, UP_63, UP_64;

double DOWN_1, DOWN_2, DOWN_3, DOWN_4, DOWN_5, DOWN_6, DOWN_7, DOWN_8, DOWN_9, DOWN_10;
double DOWN_11, DOWN_12, DOWN_13, DOWN_14, DOWN_15, DOWN_16, DOWN_17, DOWN_18, DOWN_19, DOWN_20;
double DOWN_21, DOWN_22, DOWN_23, DOWN_24, DOWN_25, DOWN_26, DOWN_27, DOWN_28, DOWN_29, DOWN_30;
double DOWN_31, DOWN_32, DOWN_33, DOWN_34, DOWN_35, DOWN_36, DOWN_37, DOWN_38, DOWN_39, DOWN_40;
double DOWN_41, DOWN_42, DOWN_43, DOWN_44, DOWN_45, DOWN_46, DOWN_47, DOWN_48, DOWN_49, DOWN_50;
double DOWN_51, DOWN_52, DOWN_53, DOWN_54, DOWN_55, DOWN_56, DOWN_57, DOWN_58, DOWN_59, DOWN_60;
double DOWN_61, DOWN_62, DOWN_63, DOWN_64;

double UP_65, UP_66, UP_67, UP_68, UP_69, UP_70;
double UP_71, UP_72, UP_73, UP_74, UP_75, UP_76, UP_77, UP_78, UP_79, UP_80;
double UP_81, UP_82, UP_83, UP_84, UP_85, UP_86, UP_87, UP_88, UP_89, UP_90;
double UP_91, UP_92, UP_93, UP_94, UP_95, UP_96, UP_97, UP_98, UP_99, UP_100;
double UP_101, UP_102, UP_103, UP_104, UP_105, UP_106, UP_107, UP_108, UP_109, UP_110;
double UP_111, UP_112;

double DOWN_65, DOWN_66, DOWN_67, DOWN_68, DOWN_69, DOWN_70;
double DOWN_71, DOWN_72, DOWN_73, DOWN_74, DOWN_75, DOWN_76, DOWN_77, DOWN_78, DOWN_79, DOWN_80;
double DOWN_81, DOWN_82, DOWN_83, DOWN_84, DOWN_85, DOWN_86, DOWN_87, DOWN_88, DOWN_89, DOWN_90;
double DOWN_91, DOWN_92, DOWN_93, DOWN_94, DOWN_95, DOWN_96, DOWN_97, DOWN_98, DOWN_99, DOWN_100;
double DOWN_101, DOWN_102, DOWN_103, DOWN_104, DOWN_105, DOWN_106, DOWN_107, DOWN_108, DOWN_109, DOWN_110;
double DOWN_111, DOWN_112;
  
double count_m1, count_m5, count_m15, count_m30, count_h1, count_h4, count_d1;

  if ( display_M1 == true) { count_m1 = 1; }
  if ( display_M5 == true) { count_m5 = 1; }
  if ( display_M15 == true) { count_m15 = 1; }
  if ( display_M30 == true) { count_m30 = 1; }
  if ( display_H1 == true) { count_h1 = 1; }
  if ( display_H4 == true) { count_h4 = 1; }
  if ( display_D1 == true) { count_d1 = 1; }
  
  double count_tf = count_m1 + count_m5 + count_m15 + count_m30 + count_h1 + count_h4 + count_d1;
  double coef = coef_m1 + coef_m5 + coef_m15 + coef_m30 + coef_H1 + coef_H4 + coef_D1;
  if( coef != count_tf ) { Alert("The sum of the coefs must be ",  count_tf,". Your setting is ", coef,"!!!"); }
  
  
  int j,total=OrdersTotal();
   for(j=0;j<total;j++)
   {
    OrderSelect(j, SELECT_BY_POS, MODE_TRADES);
   }
   
   color color_common_line = White;
   color color_common_text = White;
   color color_connection;
   
   if( box_trade_analysis == true )
   {
   
//---- Timeframe and symbol

   string Timeframe = "";
   color color_timeframe=SkyBlue;
   
   double time_frame=Period();
   string symbol=Symbol();
   
   if(time_frame==1) { Timeframe = "M1"; }
   if(time_frame==5) { Timeframe = "M5"; }
   if(time_frame==15) { Timeframe = "M15"; }
   if(time_frame==30) { Timeframe = "M30"; }
   if(time_frame==60) { Timeframe = "H1"; }
   if(time_frame==240) { Timeframe = "H4"; }
   if(time_frame==1440) { Timeframe = "D1"; }
   if(time_frame==10080) { Timeframe = "W1"; }
   if(time_frame==43200) { Timeframe = "MN"; }
   
   int Corner_timeframe, Xdist_timeframe, Ydist_timeframe;
   int Corner_line, Xdist_line;
   int Ydist_line1, Ydist_line2, Ydist_line3, Ydist_line4;
   int Corner_text, Xdist_text;
   int Corner_value, Xdist_value;
   int Xdist_stoploss, Ydist_stoploss, Ydist_stop;
   int Xdist_pipstostop, Ydist_pipstostop, Ydist_pipsstop;
   int Xdist_pipsprofit, Ydist_pipsprofit, Ydist_pips_profit;
   int Xdist_percentbalance, Ydist_percentbalance, Ydist_percent_profit;
   int Xdist_maxlot1, Ydist_maxlot1, Ydist_maxlot2;
    
    Corner_timeframe = 0; Xdist_timeframe = 10 + X_trade_analysis; Ydist_timeframe = 15 + (Y_analysis-15);
    Corner_line = 0; Xdist_line = 2 + X_trade_analysis;
    Ydist_line1 = 27 + (Y_analysis-15); Ydist_line2 = 77 + (Y_analysis-15); Ydist_line3 = 117 + (Y_analysis-15); Ydist_line4= 140 + (Y_analysis-15);
    Corner_text = 0; Xdist_text = 3 + X_trade_analysis;
    Corner_value = 0; Xdist_value = 92 + X_trade_analysis;
    Ydist_stoploss = 43 + (Y_analysis-15); Ydist_stop = 43 + (Y_analysis-15);
    Ydist_pipstostop = 62 + (Y_analysis-15); Ydist_pipsstop = 62 + (Y_analysis-15);
    Ydist_pipsprofit = 88 + (Y_analysis-15); Ydist_pips_profit = 88 + (Y_analysis-15);
    Ydist_percentbalance = 106 + (Y_analysis-15); Ydist_percent_profit = 106 + (Y_analysis-15);
    Ydist_maxlot1 = 129 + (Y_analysis-15); Ydist_maxlot2 = 129 + (Y_analysis-15);
    
   ObjectCreate("timeframe", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("timeframe","+  "+symbol+"  "+Timeframe+"  +",9, "Verdana", color_timeframe);
   ObjectSet("timeframe", OBJPROP_CORNER, Corner_timeframe);
   ObjectSet("timeframe", OBJPROP_XDISTANCE, Xdist_timeframe);
   ObjectSet("timeframe", OBJPROP_YDISTANCE, Ydist_timeframe);
   
   ObjectCreate("line1", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("line1","--------------------------",7, "Verdana", color_common_line);
   ObjectSet("line1", OBJPROP_CORNER, Corner_line);
   ObjectSet("line1", OBJPROP_XDISTANCE, Xdist_line);
   ObjectSet("line1", OBJPROP_YDISTANCE, Ydist_line1);
   
// Stop Loss
   
   ObjectCreate("stoploss", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("stoploss","Stop Loss",7, "Verdana", color_common_text);
   ObjectSet("stoploss", OBJPROP_CORNER, Corner_text);
   ObjectSet("stoploss", OBJPROP_XDISTANCE, Xdist_text);
   ObjectSet("stoploss", OBJPROP_YDISTANCE, Ydist_stoploss);
   
   string Stop_Loss = "";
   color color_stop;
   
   if(OrderStopLoss() > 0) { Stop_Loss = DoubleToStr(OrderStopLoss(),2); color_stop = Orange; }
   if(total == 0 || OrderStopLoss() == 0) { Stop_Loss = "-------"; color_stop = Red; }
   
   ObjectCreate("Stop", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Stop",Stop_Loss,7, "Verdana", color_stop);
   ObjectSet("Stop", OBJPROP_CORNER, Corner_value);
   ObjectSet("Stop", OBJPROP_XDISTANCE, Xdist_value);
   ObjectSet("Stop", OBJPROP_YDISTANCE, Ydist_stop);
   
//---- Pips to reach the Stop Loss
   
   ObjectCreate("pipstostop", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("pipstostop","Pips to Stop",7, "Verdana", color_common_text);
   ObjectSet("pipstostop", OBJPROP_CORNER, Corner_text);
   ObjectSet("pipstostop", OBJPROP_XDISTANCE, Xdist_text);
   ObjectSet("pipstostop", OBJPROP_YDISTANCE, Ydist_pipstostop);
   
   string Pips_To_Stop = "";
   color color_pips_stop;
     
   if(OrderStopLoss() > 0 && OrderType()==OP_BUY) { Pips_To_Stop = DoubleToStr((Bid - OrderStopLoss())*100,0)+" pips"; color_pips_stop = Orange; }
   if(OrderStopLoss() > 0 && OrderType()==OP_SELL) { Pips_To_Stop = DoubleToStr((OrderStopLoss() - Ask)*100,0)+" pips"; color_pips_stop = Orange; }
   if(total == 0 || OrderStopLoss() == 0) { Pips_To_Stop = "-------"; color_pips_stop = Red; }
   
   ObjectCreate("PipsStop", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("PipsStop",Pips_To_Stop,7, "Verdana", color_pips_stop);
   ObjectSet("PipsStop", OBJPROP_CORNER, Corner_value);
   ObjectSet("PipsStop", OBJPROP_XDISTANCE, Xdist_value);
   ObjectSet("PipsStop", OBJPROP_YDISTANCE, Ydist_pipsstop);
   
   ObjectCreate("line2", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("line2","--------------------------",7, "Verdana", color_common_line);
   ObjectSet("line2", OBJPROP_CORNER, Corner_line);
   ObjectSet("line2", OBJPROP_XDISTANCE, Xdist_line);
   ObjectSet("line2", OBJPROP_YDISTANCE, Ydist_line2);
   
//---- Pips Profit

   ObjectCreate("pipsprofit", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("pipsprofit","Pips Profit",7, "Verdana", color_common_text);
   ObjectSet("pipsprofit", OBJPROP_CORNER, Corner_text);
   ObjectSet("pipsprofit", OBJPROP_XDISTANCE, Xdist_text);
   ObjectSet("pipsprofit", OBJPROP_YDISTANCE, Ydist_pipsprofit);

   string pips_profit = "";
   color color_pipsprofit;
   
   if(total == 0) { pips_profit = "-------"; color_pipsprofit = Red; }
   else
   {
    pips_profit = DoubleToStr((OrderProfit() / (OrderLots()*PipValue)),0) + " pips";
    if(StrToDouble(pips_profit) >= 0) { color_pipsprofit = Lime; }
    else {color_pipsprofit = Red; }
   }
   
   ObjectCreate("pips_profit", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("pips_profit",pips_profit,7, "Verdana", color_pipsprofit);
   ObjectSet("pips_profit", OBJPROP_CORNER, Corner_value);
   ObjectSet("pips_profit", OBJPROP_XDISTANCE, Xdist_value);
   ObjectSet("pips_profit", OBJPROP_YDISTANCE, Ydist_pips_profit);   
     
//---- Percent of balance

   ObjectCreate("percentbalance", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("percentbalance","% of Balance",7, "Verdana", color_common_text);
   ObjectSet("percentbalance", OBJPROP_CORNER, Corner_text);
   ObjectSet("percentbalance", OBJPROP_XDISTANCE, Xdist_text);
   ObjectSet("percentbalance", OBJPROP_YDISTANCE, Ydist_percentbalance);
   
   string percent_profit = "";
   color color_percentprofit;
   
   if(total == 0) { percent_profit = "-------"; color_percentprofit = Red; }
   else
   {
    percent_profit = DoubleToStr((((OrderProfit()-OrderSwap()) / AccountBalance())*100),2) + " %";
    if(StrToDouble(percent_profit) >= 0) { color_percentprofit = Lime; }
    else {color_percentprofit = Red; }
   }
   
   ObjectCreate("percent_profit", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("percent_profit",percent_profit,7, "Verdana", color_percentprofit);
   ObjectSet("percent_profit", OBJPROP_CORNER, Corner_value);
   ObjectSet("percent_profit", OBJPROP_XDISTANCE, Xdist_value);
   ObjectSet("percent_profit", OBJPROP_YDISTANCE, Ydist_percent_profit);
   
   ObjectCreate("line3", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("line3","--------------------------",7, "Verdana", color_common_line);
   ObjectSet("line3", OBJPROP_CORNER, Corner_line);
   ObjectSet("line3", OBJPROP_XDISTANCE, Xdist_line);
   ObjectSet("line3", OBJPROP_YDISTANCE, Ydist_line3);  
   
//---- Maximum Lot to trade

   ObjectCreate("maxlot1", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("maxlot1","Max lot to trade",7, "Verdana", color_common_text);
   ObjectSet("maxlot1", OBJPROP_CORNER, Corner_text);
   ObjectSet("maxlot1", OBJPROP_XDISTANCE, Xdist_text);
   ObjectSet("maxlot1", OBJPROP_YDISTANCE, Ydist_maxlot1);
   
   string MaxLot = "";
   color color_maxlot = Orange;
   
   if(total>0)
   {
    if(AccountMini == true)
    {
     MaxLot = DoubleToStr((((AccountBalance()/10000)*LeverageToTrade)-OrderLots()),2);
    }
    else
    {
     MaxLot = DoubleToStr((((AccountBalance()/100000)*LeverageToTrade)-OrderLots()),2);
    }
   }
   else
   {
    if(AccountMini == true)
    {
     MaxLot = DoubleToStr((((AccountBalance()/10000)*LeverageToTrade)),2);
    }
    else
    {
     MaxLot = DoubleToStr((((AccountBalance()/100000)*LeverageToTrade)),2);
    }
   }
   
   ObjectCreate("maxlot2", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("maxlot2",MaxLot,7, "Verdana", color_maxlot);
   ObjectSet("maxlot2", OBJPROP_CORNER, Corner_value);
   ObjectSet("maxlot2", OBJPROP_XDISTANCE, Xdist_value);
   ObjectSet("maxlot2", OBJPROP_YDISTANCE, Ydist_maxlot2);
   
   ObjectCreate("line4", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("line4","--------------------------",7, "Verdana", color_common_line);
   ObjectSet("line4", OBJPROP_CORNER, Corner_line);
   ObjectSet("line4", OBJPROP_XDISTANCE, Xdist_line);
   ObjectSet("line4", OBJPROP_YDISTANCE, Ydist_line4);
   
  }   // if( box_trade_analysis == true )
  
   
// Shift calculation for indicators (tests only)

   double shift_1, shift_5, shift_15, shift_30, shift_60, shift_240, shift_1440, shift_10080;
   
   if( test == true )
   {
    shift_1=iBarShift(NULL,PERIOD_M1,look_time_shift,false);
    shift_5=iBarShift(NULL,PERIOD_M5,look_time_shift,false);
    shift_15=iBarShift(NULL,PERIOD_M15,look_time_shift,false);
    shift_30=iBarShift(NULL,PERIOD_M30,look_time_shift,false);
    shift_60=iBarShift(NULL,PERIOD_H1,look_time_shift,false);
    shift_240=iBarShift(NULL,PERIOD_H4,look_time_shift,false);
    shift_1440=iBarShift(NULL,PERIOD_D1,look_time_shift,false);
    shift_10080=iBarShift(NULL,PERIOD_W1,look_time_shift,false);
   }
   else
   {
    shift_1=shift_indicators;
    shift_5=shift_indicators;
    shift_15=shift_indicators;
    shift_30=shift_indicators;
    shift_60=shift_indicators;
    shift_240=shift_indicators;
    shift_1440=shift_indicators;
    shift_10080=shift_indicators;
   }
   
// Indicator (Moving Average)

   // FAST
   
   if( display_fast_MA == true )
   {
   if( display_M1 == true )
   {
   double FastMA_1_1 = iMA(NULL,PERIOD_M1,FastMAPeriod,0,MAMethod,MAPrice,shift_1);
   double FastMA_2_1 = iMA(NULL,PERIOD_M1,FastMAPeriod,0,MAMethod,MAPrice,shift_1+1);
   if ((FastMA_1_1 > FastMA_2_1)) { UP_1 = 1; DOWN_1 = 0; }
   if ((FastMA_1_1 < FastMA_2_1)) { UP_1 = 0; DOWN_1 = 1; }
   }
  
   if( display_M5 == true )
   {   
   double FastMA_1_5 = iMA(NULL,PERIOD_M5,FastMAPeriod,0,MAMethod,MAPrice,shift_5);
   double FastMA_2_5 = iMA(NULL,PERIOD_M5,FastMAPeriod,0,MAMethod,MAPrice,shift_5+1);
   if ((FastMA_1_5 > FastMA_2_5)) { UP_2 = 1; DOWN_2 = 0; }
   if ((FastMA_1_5 < FastMA_2_5)) { UP_2 = 0; DOWN_2 = 1; }
   }
   
   if( display_M15 == true )
   {   
   double FastMA_1_15 = iMA(NULL,PERIOD_M15,FastMAPeriod,0,MAMethod,MAPrice,shift_15);
   double FastMA_2_15 = iMA(NULL,PERIOD_M15,FastMAPeriod,0,MAMethod,MAPrice,shift_15+1);
   if ((FastMA_1_15 > FastMA_2_15)) { UP_3 = 1; DOWN_3 = 0; }
   if ((FastMA_1_15 < FastMA_2_15)) { UP_3 = 0; DOWN_3 = 1; }
   }
   
   if( display_M30 == true )
   {   
   double FastMA_1_30 = iMA(NULL,PERIOD_M30,FastMAPeriod,0,MAMethod,MAPrice,shift_30);
   double FastMA_2_30 = iMA(NULL,PERIOD_M30,FastMAPeriod,0,MAMethod,MAPrice,shift_30+1);
   if ((FastMA_1_30 > FastMA_2_30)) { UP_4 = 1; DOWN_4 = 0; }
   if ((FastMA_1_30 < FastMA_2_30)) { UP_4 = 0; DOWN_4 = 1; }
   }
   
   if( display_H1 == true )
   {  
   double FastMA_1_60 = iMA(NULL,PERIOD_H1,FastMAPeriod,0,MAMethod,MAPrice,shift_60);
   double FastMA_2_60 = iMA(NULL,PERIOD_H1,FastMAPeriod,0,MAMethod,MAPrice,shift_60+1);
   if ((FastMA_1_60 > FastMA_2_60)) { UP_5 = 1; DOWN_5 = 0; }
   if ((FastMA_1_60 < FastMA_2_60)) { UP_5 = 0; DOWN_5 = 1; }
   }
   
   if( display_H4 == true )
   {
   double FastMA_1_240 = iMA(NULL,PERIOD_H4,FastMAPeriod,0,MAMethod,MAPrice,shift_240);
   double FastMA_2_240 = iMA(NULL,PERIOD_H4,FastMAPeriod,0,MAMethod,MAPrice,shift_240+1);
   if ((FastMA_1_240 > FastMA_2_240)) { UP_6 = 1; DOWN_6 = 0; }
   if ((FastMA_1_240 < FastMA_2_240)) { UP_6 = 0; DOWN_6 = 1; }
   }
   
   if( display_D1 == true )
   {
   double FastMA_1_1440 = iMA(NULL,PERIOD_D1,FastMAPeriod,0,MAMethod,MAPrice,shift_1440);
   double FastMA_2_1440 = iMA(NULL,PERIOD_D1,FastMAPeriod,0,MAMethod,MAPrice,shift_1440+1);
   if ((FastMA_1_1440 > FastMA_2_1440)) { UP_7 = 1; DOWN_7 = 0; }
   if ((FastMA_1_1440 < FastMA_2_1440)) { UP_7 = 0; DOWN_7 = 1; }
   }
   }
   
   // MEDIUM
   
   if( display_medium_MA == true )
   {
   if( display_M1 == true )
   {
   double MediumMA_1_1 = iMA(NULL,PERIOD_M1,MediumMAPeriod,0,MAMethod,MAPrice,shift_1);
   double MediumMA_2_1 = iMA(NULL,PERIOD_M1,MediumMAPeriod,0,MAMethod,MAPrice,shift_1+1);
   if ((MediumMA_1_1 > MediumMA_2_1)) { UP_9 = 1; DOWN_9 = 0; }
   if ((MediumMA_1_1 < MediumMA_2_1)) { UP_9 = 0; DOWN_9 = 1; }
   }
   
   if( display_M5 == true )
   {
   double MediumMA_1_5 = iMA(NULL,PERIOD_M5,MediumMAPeriod,0,MAMethod,MAPrice,shift_5);
   double MediumMA_2_5 = iMA(NULL,PERIOD_M5,MediumMAPeriod,0,MAMethod,MAPrice,shift_5+1);
   if ((MediumMA_1_5 > MediumMA_2_5)) { UP_10 = 1; DOWN_10 = 0; }
   if ((MediumMA_1_5 < MediumMA_2_5)) { UP_10 = 0; DOWN_10 = 1; }
   }
   
   if( display_M15 == true )
   {
   double MediumMA_1_15 = iMA(NULL,PERIOD_M15,MediumMAPeriod,0,MAMethod,MAPrice,shift_15);
   double MediumMA_2_15 = iMA(NULL,PERIOD_M15,MediumMAPeriod,0,MAMethod,MAPrice,shift_15+1);
   if ((MediumMA_1_15 > MediumMA_2_15)) { UP_11 = 1; DOWN_11 = 0; }
   if ((MediumMA_1_15 < MediumMA_2_15)) { UP_11 = 0; DOWN_11 = 1; }
   }
   
   if( display_M30 == true )
   {
   double MediumMA_1_30 = iMA(NULL,PERIOD_M30,MediumMAPeriod,0,MAMethod,MAPrice,shift_30);
   double MediumMA_2_30 = iMA(NULL,PERIOD_M30,MediumMAPeriod,0,MAMethod,MAPrice,shift_30+1);
   if ((MediumMA_1_30 > MediumMA_2_30)) { UP_12 = 1; DOWN_12 = 0; }
   if ((MediumMA_1_30 < MediumMA_2_30)) { UP_12 = 0; DOWN_12 = 1; }
   }
   
   if( display_H1 == true )
   {
   double MediumMA_1_60 = iMA(NULL,PERIOD_H1,MediumMAPeriod,0,MAMethod,MAPrice,shift_60);
   double MediumMA_2_60 = iMA(NULL,PERIOD_H1,MediumMAPeriod,0,MAMethod,MAPrice,shift_60+1);
   if ((MediumMA_1_60 > MediumMA_2_60)) { UP_13 = 1; DOWN_13 = 0; }
   if ((MediumMA_1_60 < MediumMA_2_60)) { UP_13 = 0; DOWN_13 = 1; }
   }
   
   if( display_H4 == true )
   {
   double MediumMA_1_240 = iMA(NULL,PERIOD_H4,MediumMAPeriod,0,MAMethod,MAPrice,shift_240);
   double MediumMA_2_240 = iMA(NULL,PERIOD_H4,MediumMAPeriod,0,MAMethod,MAPrice,shift_240+1);
   if ((MediumMA_1_240 > MediumMA_2_240)) { UP_14 = 1; DOWN_14 = 0; }
   if ((MediumMA_1_240 < MediumMA_2_240)) { UP_14 = 0; DOWN_14 = 1; }
   }
   
   if( display_D1 == true )
   {
   double MediumMA_1_1440 = iMA(NULL,PERIOD_D1,MediumMAPeriod,0,MAMethod,MAPrice,shift_1440);
   double MediumMA_2_1440 = iMA(NULL,PERIOD_D1,MediumMAPeriod,0,MAMethod,MAPrice,shift_1440+1);
   if ((MediumMA_1_1440 > MediumMA_2_1440)) { UP_15 = 1; DOWN_15 = 0; }
   if ((MediumMA_1_1440 < MediumMA_2_1440)) { UP_15 = 0; DOWN_15 = 1; }
   }
   }
   
   // SLOW
   
   if( display_slow_MA == true )
   {
   if( display_M1 == true )
   {
   double SlowMA_1_1 = iMA(NULL,PERIOD_M1,SlowMAPeriod,0,MAMethod,MAPrice,shift_1);
   double SlowMA_2_1 = iMA(NULL,PERIOD_M1,SlowMAPeriod,0,MAMethod,MAPrice,shift_1+1);
   if ((SlowMA_1_1 > SlowMA_2_1)) { UP_17 = 1; DOWN_17 = 0; }
   if ((SlowMA_1_1 < SlowMA_2_1)) { UP_17 = 0; DOWN_17 = 1; }
   }
   
   if( display_M5 == true )
   {
   double SlowMA_1_5 = iMA(NULL,PERIOD_M5,SlowMAPeriod,0,MAMethod,MAPrice,shift_5);
   double SlowMA_2_5 = iMA(NULL,PERIOD_M5,SlowMAPeriod,0,MAMethod,MAPrice,shift_5+1);
   if ((SlowMA_1_5 > SlowMA_2_5)) { UP_18 = 1; DOWN_18 = 0; }
   if ((SlowMA_1_5 < SlowMA_2_5)) { UP_18 = 0; DOWN_18 = 1; }
   }
   
   if( display_M15 == true )
   {
   double SlowMA_1_15 = iMA(NULL,PERIOD_M15,SlowMAPeriod,0,MAMethod,MAPrice,shift_15);
   double SlowMA_2_15 = iMA(NULL,PERIOD_M15,SlowMAPeriod,0,MAMethod,MAPrice,shift_15+1);
   if ((SlowMA_1_15 > SlowMA_2_15)) { UP_19 = 1; DOWN_19 = 0; }
   if ((SlowMA_1_15 < SlowMA_2_15)) { UP_19 = 0; DOWN_19 = 1; }
   }
   
   if( display_M30 == true )
   {
   double SlowMA_1_30 = iMA(NULL,PERIOD_M30,SlowMAPeriod,0,MAMethod,MAPrice,shift_30);
   double SlowMA_2_30 = iMA(NULL,PERIOD_M30,SlowMAPeriod,0,MAMethod,MAPrice,shift_30+1);
   if ((SlowMA_1_30 > SlowMA_2_30)) { UP_20 = 1; DOWN_20 = 0; }
   if ((SlowMA_1_30 < SlowMA_2_30)) { UP_20 = 0; DOWN_20 = 1; }
   }
   
   if( display_H1 == true )
   {
   double SlowMA_1_60 = iMA(NULL,PERIOD_H1,SlowMAPeriod,0,MAMethod,MAPrice,shift_60);
   double SlowMA_2_60 = iMA(NULL,PERIOD_H1,SlowMAPeriod,0,MAMethod,MAPrice,shift_60+1);
   if ((SlowMA_1_60 > SlowMA_2_60)) { UP_21 = 1; DOWN_21 = 0; }
   if ((SlowMA_1_60 < SlowMA_2_60)) { UP_21 = 0; DOWN_21 = 1; }
   }
   
   if( display_H4 == true )
   {
   double SlowMA_1_240 = iMA(NULL,PERIOD_H4,SlowMAPeriod,0,MAMethod,MAPrice,shift_240);
   double SlowMA_2_240 = iMA(NULL,PERIOD_H4,SlowMAPeriod,0,MAMethod,MAPrice,shift_240+1);
   if ((SlowMA_1_240 > SlowMA_2_240)) { UP_22 = 1; DOWN_22 = 0; }
   if ((SlowMA_1_240 < SlowMA_2_240)) { UP_22 = 0; DOWN_22 = 1; }
   }
   
   if( display_D1 == true )
   {
   double SlowMA_1_1440 = iMA(NULL,PERIOD_D1,SlowMAPeriod,0,MAMethod,MAPrice,shift_1440);
   double SlowMA_2_1440 = iMA(NULL,PERIOD_D1,SlowMAPeriod,0,MAMethod,MAPrice,shift_1440+1);
   if ((SlowMA_1_1440 > SlowMA_2_1440)) { UP_23 = 1; DOWN_23 = 0; }
   if ((SlowMA_1_1440 < SlowMA_2_1440)) { UP_23 = 0; DOWN_23 = 1; }
   }
   }
   
// Indicator (CCI)
   
   if( display_CCI == true )
   {
   if( display_M1 == true )
   {
   double CCI_1=iCCI(NULL,PERIOD_M1,CCIPeriod,CCIPrice,shift_1);
   if ((CCI_1 > 0)) { UP_25 = 1; DOWN_25 = 0; }
   if ((CCI_1 < 0)) { UP_25 = 0; DOWN_25 = 1; }
   }
   
   if( display_M5 == true )
   {
   double CCI_5=iCCI(NULL,PERIOD_M5,CCIPeriod,CCIPrice,shift_5);
   if ((CCI_5 > 0)) { UP_26 = 1; DOWN_26 = 0; }
   if ((CCI_5 < 0)) { UP_26 = 0; DOWN_26 = 1; }
   }
   
   if( display_M15 == true )
   {
   double CCI_15=iCCI(NULL,PERIOD_M15,CCIPeriod,CCIPrice,shift_15);
   if ((CCI_15 > 0)) { UP_27 = 1; DOWN_27 = 0; }
   if ((CCI_15 < 0)) { UP_27 = 0; DOWN_27 = 1; }
   }
   
   if( display_M30 == true )
   {
   double CCI_30=iCCI(NULL,PERIOD_M30,CCIPeriod,CCIPrice,shift_30);
   if ((CCI_30 > 0)) { UP_28 = 1; DOWN_28 = 0; }
   if ((CCI_30 < 0)) { UP_28 = 0; DOWN_28 = 1; }
   }
   
   if( display_H1 == true )
   {
   double CCI_60=iCCI(NULL,PERIOD_H1,CCIPeriod,CCIPrice,shift_60);
   if ((CCI_60 > 0)) { UP_29 = 1; DOWN_29 = 0; }
   if ((CCI_60 < 0)) { UP_29 = 0; DOWN_29 = 1; }
   }
   
   if( display_H4 == true )
   {
   double CCI_240=iCCI(NULL,PERIOD_H4,CCIPeriod,CCIPrice,shift_240);
   if ((CCI_240 > 0)) { UP_30 = 1; DOWN_30 = 0; }
   if ((CCI_240 < 0)) { UP_30 = 0; DOWN_30 = 1; }
   }
   
   if( display_D1 == true )
   {
   double CCI_1440=iCCI(NULL,PERIOD_D1,CCIPeriod,CCIPrice,shift_1440);
   if ((CCI_1440 > 0)) { UP_31 = 1; DOWN_31 = 0; }
   if ((CCI_1440 < 0)) { UP_31 = 0; DOWN_31 = 1; }
   }
   }
   
// Indicator (MACD)
   
   if( display_MACD == true )
   {
   if( display_M1 == true )
   {
   double MACD_m_1=iMACD(NULL,PERIOD_M1,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_MAIN,shift_1);
   double MACD_s_1=iMACD(NULL,PERIOD_M1,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_SIGNAL,shift_1);
   if ((MACD_m_1 > MACD_s_1)) { UP_33 = 1; DOWN_33 = 0; }
   if ((MACD_m_1 < MACD_s_1)) { UP_33 = 0; DOWN_33 = 1; }
   }
   
   if( display_M5 == true )
   {
   double MACD_m_5=iMACD(NULL,PERIOD_M5,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_MAIN,shift_5);
   double MACD_s_5=iMACD(NULL,PERIOD_M5,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_SIGNAL,shift_5);
   if ((MACD_m_5 > MACD_s_5)) { UP_34 = 1; DOWN_34 = 0; }
   if ((MACD_m_5 < MACD_s_5)) { UP_34 = 0; DOWN_34 = 1; }
   }
   
   if( display_M15 == true )
   {
   double MACD_m_15=iMACD(NULL,PERIOD_M15,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_MAIN,shift_15);
   double MACD_s_15=iMACD(NULL,PERIOD_M15,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_SIGNAL,shift_15);
   if ((MACD_m_15 > MACD_s_15)) { UP_35 = 1; DOWN_35 = 0; }
   if ((MACD_m_15 < MACD_s_15)) { UP_35 = 0; DOWN_35 = 1; }
   }
   
   if( display_M30 == true )
   {
   double MACD_m_30=iMACD(NULL,PERIOD_M30,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_MAIN,shift_30);
   double MACD_s_30=iMACD(NULL,PERIOD_M30,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_SIGNAL,shift_30);
   if ((MACD_m_30 > MACD_s_30)) { UP_36 = 1; DOWN_36 = 0; }
   if ((MACD_m_30 < MACD_s_30)) { UP_36 = 0; DOWN_36 = 1; }
   }
   
   if( display_H1 == true )
   {
   double MACD_m_60=iMACD(NULL,PERIOD_H1,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_MAIN,shift_60);
   double MACD_s_60=iMACD(NULL,PERIOD_H1,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_SIGNAL,shift_60);
   if ((MACD_m_60 > MACD_s_60)) { UP_37 = 1; DOWN_37 = 0; }
   if ((MACD_m_60 < MACD_s_60)) { UP_37 = 0; DOWN_37 = 1; }
   }
   
   if( display_H4 == true )
   {
   double MACD_m_240=iMACD(NULL,PERIOD_H4,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_MAIN,shift_240);
   double MACD_s_240=iMACD(NULL,PERIOD_H4,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_SIGNAL,shift_240);
   if ((MACD_m_240 > MACD_s_240)) { UP_38 = 1; DOWN_38 = 0; }
   if ((MACD_m_240 < MACD_s_240)) { UP_38 = 0; DOWN_38 = 1; }
   }
   
   if( display_D1 == true )
   {
   double MACD_m_1440=iMACD(NULL,PERIOD_D1,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_MAIN,shift_1440);
   double MACD_s_1440=iMACD(NULL,PERIOD_D1,MACDFast,MACDSlow,MACDSignal,PRICE_CLOSE,MODE_SIGNAL,shift_1440);
   if ((MACD_m_1440 > MACD_s_1440)) { UP_39 = 1; DOWN_39 = 0; }
   if ((MACD_m_1440 < MACD_s_1440)) { UP_39 = 0; DOWN_39 = 1; }
   }
   }
   
// Indicator (ADX)
   
   if( display_ADX == true )
   {
   if( display_M1 == true )
   {
   double ADX_plus_1=iADX(NULL,PERIOD_M1,ADXPeriod,ADXPrice,MODE_PLUSDI,shift_1);
   double ADX_minus_1=iADX(NULL,PERIOD_M1,ADXPeriod,ADXPrice,MODE_MINUSDI,shift_1);
   if ((ADX_plus_1 > ADX_minus_1)) { UP_41 = 1; DOWN_41 = 0; }
   if ((ADX_plus_1 < ADX_minus_1)) { UP_41 = 0; DOWN_41 = 1; }
   }
   
   if( display_M5 == true )
   {
   double ADX_plus_5=iADX(NULL,PERIOD_M5,ADXPeriod,ADXPrice,MODE_PLUSDI,shift_5);
   double ADX_minus_5=iADX(NULL,PERIOD_M5,ADXPeriod,ADXPrice,MODE_MINUSDI,shift_5);
   if ((ADX_plus_5 > ADX_minus_5)) { UP_42 = 1; DOWN_42 = 0; }
   if ((ADX_plus_5 < ADX_minus_5)) { UP_42 = 0; DOWN_42 = 1; }
   }
   
   if( display_M15 == true )
   {
   double ADX_plus_15=iADX(NULL,PERIOD_M15,ADXPeriod,ADXPrice,MODE_PLUSDI,shift_15);
   double ADX_minus_15=iADX(NULL,PERIOD_M15,ADXPeriod,ADXPrice,MODE_MINUSDI,shift_15);
   if ((ADX_plus_15 > ADX_minus_15)) { UP_43 = 1; DOWN_43 = 0; }
   if ((ADX_plus_15 < ADX_minus_15)) { UP_43 = 0; DOWN_43 = 1; }
   }
   
   if( display_M30 == true )
   {
   double ADX_plus_30=iADX(NULL,PERIOD_M30,ADXPeriod,ADXPrice,MODE_PLUSDI,shift_30);
   double ADX_minus_30=iADX(NULL,PERIOD_M30,ADXPeriod,ADXPrice,MODE_MINUSDI,shift_30);
   if ((ADX_plus_30 > ADX_minus_30)) { UP_44 = 1; DOWN_44 = 0; }
   if ((ADX_plus_30 < ADX_minus_30)) { UP_44 = 0; DOWN_44 = 1; }
   }
   
   if( display_H1 == true )
   {
   double ADX_plus_60=iADX(NULL,PERIOD_H1,ADXPeriod,ADXPrice,MODE_PLUSDI,shift_60);
   double ADX_minus_60=iADX(NULL,PERIOD_H1,ADXPeriod,ADXPrice,MODE_MINUSDI,shift_60);
   if ((ADX_plus_60 > ADX_minus_60)) { UP_45 = 1; DOWN_45 = 0; }
   if ((ADX_plus_60 < ADX_minus_60)) { UP_45 = 0; DOWN_45 = 1; }
   }
   
   if( display_H4 == true )
   {
   double ADX_plus_240=iADX(NULL,PERIOD_H4,ADXPeriod,ADXPrice,MODE_PLUSDI,shift_240);
   double ADX_minus_240=iADX(NULL,PERIOD_H4,ADXPeriod,ADXPrice,MODE_MINUSDI,shift_240);
   if ((ADX_plus_240 > ADX_minus_240)) { UP_46 = 1; DOWN_46 = 0; }
   if ((ADX_plus_240 < ADX_minus_240)) { UP_46 = 0; DOWN_46 = 1; }
   }
   
   if( display_D1 == true )
   {
   double ADX_plus_1440=iADX(NULL,PERIOD_D1,ADXPeriod,ADXPrice,MODE_PLUSDI,shift_1440);
   double ADX_minus_1440=iADX(NULL,PERIOD_D1,ADXPeriod,ADXPrice,MODE_MINUSDI,shift_1440);
   if ((ADX_plus_1440 > ADX_minus_1440)) { UP_47 = 1; DOWN_47 = 0; }
   if ((ADX_plus_1440 < ADX_minus_1440)) { UP_47 = 0; DOWN_47 = 1; }
   }
   }
   
// Indicator (BULLS)
   
   if( display_BULLS == true )
   {
   if( display_M1 == true )
   {
   double bulls_1=iBullsPower(NULL,PERIOD_M1,BULLSPeriod,BULLSPrice,shift_1);
   if ((bulls_1 > 0)) { UP_49 = 1; DOWN_49 = 0; }
   if ((bulls_1 < 0)) { UP_49 = 0; DOWN_49 = 1; }
   }
   
   if( display_M5 == true )
   {
   double bulls_5=iBullsPower(NULL,PERIOD_M5,BULLSPeriod,BULLSPrice,shift_5);
   if ((bulls_5 > 0)) { UP_50 = 1; DOWN_50 = 0; }
   if ((bulls_5 < 0)) { UP_50 = 0; DOWN_50 = 1; }
   }
   
   if( display_M15 == true )
   {
   double bulls_15=iBullsPower(NULL,PERIOD_M15,BULLSPeriod,BULLSPrice,shift_15);
   if ((bulls_15 > 0)) { UP_51 = 1; DOWN_51 = 0; }
   if ((bulls_15 < 0)) { UP_51 = 0; DOWN_51 = 1; }
   }
   
   if( display_M30 == true )
   {
   double bulls_30=iBullsPower(NULL,PERIOD_M30,BULLSPeriod,BULLSPrice,shift_30);
   if ((bulls_30 > 0)) { UP_52 = 1; DOWN_52 = 0; }
   if ((bulls_30 < 0)) { UP_52 = 0; DOWN_52 = 1; }
   }
   
   if( display_H1 == true )
   {
   double bulls_60=iBullsPower(NULL,PERIOD_H1,BULLSPeriod,BULLSPrice,shift_60);
   if ((bulls_60 > 0)) { UP_53 = 1; DOWN_53 = 0; }
   if ((bulls_60 < 0)) { UP_53 = 0; DOWN_53 = 1; }
   }
   
   if( display_H4 == true )
   {
   double bulls_240=iBullsPower(NULL,PERIOD_H4,BULLSPeriod,BULLSPrice,shift_240);
   if ((bulls_240 > 0)) { UP_54 = 1; DOWN_54 = 0; }
   if ((bulls_240 < 0)) { UP_54 = 0; DOWN_54 = 1; }
   }
   
   if( display_D1 == true )
   {
   double bulls_1440=iBullsPower(NULL,PERIOD_D1,BULLSPeriod,BULLSPrice,shift_1440);
   if ((bulls_1440 > 0)) { UP_55 = 1; DOWN_55 = 0; }
   if ((bulls_1440 < 0)) { UP_55 = 0; DOWN_55 = 1; }
   }
   }
   
// Indicator (BEARS)
   
   if( display_BEARS == true )
   {
   if( display_M1 == true )
   {
   double bears_1=iBearsPower(NULL,PERIOD_M1,BEARSPeriod,BEARSPrice,shift_1);
   if ((bears_1 > 0)) { UP_57 = 1; DOWN_57 = 0; }
   if ((bears_1 < 0)) { UP_57 = 0; DOWN_57 = 1; }
   }
   
   if( display_M5 == true )
   {
   double bears_5=iBearsPower(NULL,PERIOD_M5,BEARSPeriod,BEARSPrice,shift_5);
   if ((bears_5 > 0)) { UP_58 = 1; DOWN_58 = 0; }
   if ((bears_5 < 0)) { UP_58 = 0; DOWN_58 = 1; }
   }
   
   if( display_M15 == true )
   {
   double bears_15=iBearsPower(NULL,PERIOD_M15,BEARSPeriod,BEARSPrice,shift_15);
   if ((bears_15 > 0)) { UP_59 = 1; DOWN_59 = 0; }
   if ((bears_15 < 0)) { UP_59 = 0; DOWN_59 = 1; }
   }
   
   if( display_M30 == true )
   {
   double bears_30=iBearsPower(NULL,PERIOD_M30,BEARSPeriod,BEARSPrice,shift_30);
   if ((bears_30 > 0)) { UP_60 = 1; DOWN_60 = 0; }
   if ((bears_30 < 0)) { UP_60 = 0; DOWN_60 = 1; }
   }
   
   if( display_H1 == true )
   {
   double bears_60=iBearsPower(NULL,PERIOD_H1,BEARSPeriod,BEARSPrice,shift_60);
   if ((bears_60 > 0)) { UP_61 = 1; DOWN_61 = 0; }
   if ((bears_60 < 0)) { UP_61 = 0; DOWN_61 = 1; }
   }
   
   if( display_H4 == true )
   {
   double bears_240=iBearsPower(NULL,PERIOD_H4,BEARSPeriod,BEARSPrice,shift_240);
   if ((bears_240 > 0)) { UP_62 = 1; DOWN_62 = 0; }
   if ((bears_240 < 0)) { UP_62 = 0; DOWN_62 = 1; }
   }
   
   if( display_D1 == true )
   {
   double bears_1440=iBearsPower(NULL,PERIOD_D1,BEARSPeriod,BEARSPrice,shift_1440);
   if ((bears_1440 > 0)) { UP_63 = 1; DOWN_63 = 0; }
   if ((bears_1440 < 0)) { UP_63 = 0; DOWN_63 = 1; }
   }
   }
   
// Indicator (STOCH)

   if( display_STOCH == true )
   {
   if( display_M1 == true )
   {
   double stoch_m_1=iStochastic(NULL,PERIOD_M1,STOKPeriod,STODPeriod,STOSlowing,MODE_SMA,1,MODE_MAIN,shift_1);
   double stoch_s_1=iStochastic(NULL,PERIOD_M1,STOKPeriod,STODPeriod,STOSlowing,MODE_SMA,1,MODE_SIGNAL,shift_1);
   if (stoch_m_1 >= stoch_s_1) { UP_65 = 1; DOWN_65 = 0; }
   if (stoch_m_1 < stoch_s_1) { UP_65 = 0; DOWN_65 = 1; }
   }
   
   if( display_M5 == true )
   {
   double stoch_m_5=iStochastic(NULL,PERIOD_M5,STOKPeriod,STODPeriod,STOSlowing,MODE_SMA,1,MODE_MAIN,shift_5);
   double stoch_s_5=iStochastic(NULL,PERIOD_M5,STOKPeriod,STODPeriod,STOSlowing,MODE_SMA,1,MODE_SIGNAL,shift_5);
   if (stoch_m_5 >= stoch_s_5) { UP_66 = 1; DOWN_66 = 0; }
   if (stoch_m_5 < stoch_s_5) { UP_66 = 0; DOWN_66 = 1; }
   }
   
   if( display_M15 == true )
   {
   double stoch_m_15=iStochastic(NULL,PERIOD_M15,STOKPeriod,STODPeriod,STOSlowing,MODE_SMA,1,MODE_MAIN,shift_15);
   double stoch_s_15=iStochastic(NULL,PERIOD_M15,STOKPeriod,STODPeriod,STOSlowing,MODE_SMA,1,MODE_SIGNAL,shift_15);
   if (stoch_m_15 >= stoch_s_15) { UP_67 = 1; DOWN_67 = 0; }
   if (stoch_m_15 < stoch_s_15) { UP_67 = 0; DOWN_67 = 1; }
   }
   
   if( display_M30 == true )
   {
   double stoch_m_30=iStochastic(NULL,PERIOD_M30,STOKPeriod,STODPeriod,STOSlowing,MODE_SMA,1,MODE_MAIN,shift_30);
   double stoch_s_30=iStochastic(NULL,PERIOD_M30,STOKPeriod,STODPeriod,STOSlowing,MODE_SMA,1,MODE_SIGNAL,shift_30);
   if (stoch_m_30 >= stoch_s_30) { UP_68 = 1; DOWN_68 = 0; }
   if (stoch_m_30 < stoch_s_30) { UP_68 = 0; DOWN_68 = 1; }
   }
   
   if( display_H1 == true )
   {
   double stoch_m_60=iStochastic(NULL,PERIOD_H1,STOKPeriod,STODPeriod,STOSlowing,MODE_SMA,1,MODE_MAIN,shift_60);
   double stoch_s_60=iStochastic(NULL,PERIOD_H1,STOKPeriod,STODPeriod,STOSlowing,MODE_SMA,1,MODE_SIGNAL,shift_60);
   if (stoch_m_60 >= stoch_s_60) { UP_69 = 1; DOWN_69 = 0; }
   if (stoch_m_60 < stoch_s_60) { UP_69 = 0; DOWN_69 = 1; }
   }
   
   if( display_H4 == true )
   {
   double stoch_m_240=iStochastic(NULL,PERIOD_H4,STOKPeriod,STODPeriod,STOSlowing,MODE_SMA,1,MODE_MAIN,shift_240);
   double stoch_s_240=iStochastic(NULL,PERIOD_H4,STOKPeriod,STODPeriod,STOSlowing,MODE_SMA,1,MODE_SIGNAL,shift_240);
   if (stoch_m_240 >= stoch_s_240) { UP_70 = 1; DOWN_70 = 0; }
   if (stoch_m_240 < stoch_s_240) { UP_70 = 0; DOWN_70 = 1; }
   }
   
   if( display_D1 == true )
   {
   double stoch_m_1440=iStochastic(NULL,PERIOD_D1,STOKPeriod,STODPeriod,STOSlowing,MODE_SMA,1,MODE_MAIN,shift_1440);
   double stoch_s_1440=iStochastic(NULL,PERIOD_D1,STOKPeriod,STODPeriod,STOSlowing,MODE_SMA,1,MODE_SIGNAL,shift_1440);
   if (stoch_m_1440 >= stoch_s_1440) { UP_71 = 1; DOWN_71 = 0; }
   if (stoch_m_1440 < stoch_s_1440) { UP_71 = 0; DOWN_71 = 1; }
   }
   }
   
// Indicator (RSI)
   
   if( display_RSI == true )
   {
   if( display_M1 == true )
   {
   double rsi_1=iRSI(NULL,PERIOD_M1,RSIPeriod,PRICE_CLOSE,shift_1);
   if (rsi_1 >= 50) { UP_73 = 1; DOWN_73 = 0; }
   if (rsi_1 < 50) { UP_73 = 0; DOWN_73 = 1; }
   }
   
   if( display_M5 == true )
   {
   double rsi_5=iRSI(NULL,PERIOD_M5,RSIPeriod,PRICE_CLOSE,shift_5);
   if (rsi_5 >= 50) { UP_74 = 1; DOWN_74 = 0; }
   if (rsi_5 < 50) { UP_74 = 0; DOWN_74 = 1; }
   }
   
   if( display_M15 == true )
   {
   double rsi_15=iRSI(NULL,PERIOD_M15,RSIPeriod,PRICE_CLOSE,shift_15);
   if (rsi_15 >= 50) { UP_75 = 1; DOWN_75 = 0; }
   if (rsi_15 < 50) { UP_75 = 0; DOWN_75 = 1; }
   }
   
   if( display_M30 == true )
   {
   double rsi_30=iRSI(NULL,PERIOD_M30,RSIPeriod,PRICE_CLOSE,shift_30);
   if (rsi_30 >= 50) { UP_76 = 1; DOWN_76 = 0; }
   if (rsi_30 < 50) { UP_76 = 0; DOWN_76 = 1; }
   }
   
   if( display_H1 == true )
   {
   double rsi_60=iRSI(NULL,PERIOD_H1,RSIPeriod,PRICE_CLOSE,shift_60);
   if (rsi_60 >= 50) { UP_77 = 1; DOWN_77 = 0; }
   if (rsi_60 < 50) { UP_77 = 0; DOWN_77 = 1; }
   }
   
   if( display_H4 == true )
   {
   double rsi_240=iRSI(NULL,PERIOD_H4,RSIPeriod,PRICE_CLOSE,shift_240);
   if (rsi_240 >= 50) { UP_78 = 1; DOWN_78 = 0; }
   if (rsi_240 < 50) { UP_78 = 0; DOWN_78 = 1; }
   }
   
   if( display_D1 == true )
   {
   double rsi_1440=iRSI(NULL,PERIOD_D1,RSIPeriod,PRICE_CLOSE,shift_1440);
   if (rsi_1440 >= 50) { UP_79 = 1; DOWN_79 = 0; }
   if (rsi_1440 < 50) { UP_79 = 0; DOWN_79 = 1; }
   }
   }
   
// Indicator (FORCE INDEX)
   
   if( display_FORCE == true )
   {
   if( display_M1 == true )
   {
   double fi_1=iForce(NULL,PERIOD_M1,FIPeriod,FIMethod,FIPrice,shift_1);
   if (fi_1 >= 0) { UP_81 = 1; DOWN_81 = 0; }
   if (fi_1 < 0) { UP_81 = 0; DOWN_81 = 1; }
   }
   
   if( display_M5 == true )
   {
   double fi_5=iForce(NULL,PERIOD_M5,FIPeriod,FIMethod,FIPrice,shift_5);
   if (fi_5 >= 0) { UP_82 = 1; DOWN_82 = 0; }
   if (fi_5 < 0) { UP_82 = 0; DOWN_82 = 1; }
   }
   
   if( display_M15 == true )
   {
   double fi_15=iForce(NULL,PERIOD_M15,FIPeriod,FIMethod,FIPrice,shift_15);
   if (fi_15 >= 0) { UP_83 = 1; DOWN_83 = 0; }
   if (fi_15 < 0) { UP_83 = 0; DOWN_83 = 1; }
   }
   
   if( display_M30 == true )
   {
   double fi_30=iForce(NULL,PERIOD_M30,FIPeriod,FIMethod,FIPrice,shift_30);
   if (fi_30 >= 0) { UP_84 = 1; DOWN_84 = 0; }
   if (fi_30 < 0) { UP_84 = 0; DOWN_84 = 1; }
   }
   
   if( display_H1 == true )
   {
   double fi_60=iForce(NULL,PERIOD_H1,FIPeriod,FIMethod,FIPrice,shift_60);
   if (fi_60 >= 0) { UP_85 = 1; DOWN_85 = 0; }
   if (fi_60 < 0) { UP_85 = 0; DOWN_85 = 1; }
   }
   
   if( display_H4 == true )
   {
   double fi_240=iForce(NULL,PERIOD_H4,FIPeriod,FIMethod,FIPrice,shift_240);
   if (fi_240 >= 0) { UP_86 = 1; DOWN_86 = 0; }
   if (fi_240 < 0) { UP_86 = 0; DOWN_86 = 1; }
   }
   
   if( display_D1 == true )
   {
   double fi_1440=iForce(NULL,PERIOD_D1,FIPeriod,FIMethod,FIPrice,shift_1440);
   if (fi_1440 >= 0) { UP_87 = 1; DOWN_87 = 0; }
   if (fi_1440 < 0) { UP_87 = 0; DOWN_87 = 1; }
   }
   }
   
// Indicator (MOMENTUM)
   
   if( display_MOMENTUM == true )
   {
   if( display_M1 == true )
   {
   double momentum_1=iMomentum(NULL,PERIOD_M1,MOMPeriod,MOMPrice,shift_1);
   if (momentum_1 >= 100) { UP_89 = 1; DOWN_89 = 0; }
   if (momentum_1 < 100) { UP_89 = 0; DOWN_89 = 1; }
   }
   
   if( display_M5 == true )
   {
   double momentum_5=iMomentum(NULL,PERIOD_M5,MOMPeriod,MOMPrice,shift_5);
   if (momentum_5 >= 100) { UP_90 = 1; DOWN_90 = 0; }
   if (momentum_5 < 100) { UP_90 = 0; DOWN_90 = 1; }
   }
   
   if( display_M15 == true )
   {
   double momentum_15=iMomentum(NULL,PERIOD_M15,MOMPeriod,MOMPrice,shift_15);
   if (momentum_15 >= 100) { UP_91 = 1; DOWN_91 = 0; }
   if (momentum_15 < 100) { UP_91 = 0; DOWN_91 = 1; }
   }
   
   if( display_M30 == true )
   {
   double momentum_30=iMomentum(NULL,PERIOD_M30,MOMPeriod,MOMPrice,shift_30);
   if (momentum_30 >= 100) { UP_92 = 1; DOWN_92 = 0; }
   if (momentum_30 < 100) { UP_92 = 0; DOWN_92 = 1; }
   }
   
   if( display_H1 == true )
   {
   double momentum_60=iMomentum(NULL,PERIOD_H1,MOMPeriod,MOMPrice,shift_60);
   if (momentum_60 >= 100) { UP_93 = 1; DOWN_93 = 0; }
   if (momentum_60 < 100) { UP_93 = 0; DOWN_93 = 1; }
   }
   
   if( display_H4 == true )
   {
   double momentum_240=iMomentum(NULL,PERIOD_H4,MOMPeriod,MOMPrice,shift_240);
   if (momentum_240 >= 100) { UP_94 = 1; DOWN_94 = 0; }
   if (momentum_240 < 100) { UP_94 = 0; DOWN_94 = 1; }
   }
   
   if( display_D1 == true )
   {
   double momentum_1440=iMomentum(NULL,PERIOD_D1,MOMPeriod,MOMPrice,shift_1440);
   if (momentum_1440 >= 100) { UP_95 = 1; DOWN_95 = 0; }
   if (momentum_1440 < 100) { UP_95 = 0; DOWN_95 = 1; }
   }
   }
   
// Indicator (DE MARKER)
   
   
   if( display_DeMARKER == true )
   {
   if( display_M1 == true )
   {
   double demarker_1_0=iDeMarker(NULL,PERIOD_M1,DEMPeriod,shift_1);
   double demarker_1_1=iDeMarker(NULL,PERIOD_M1,DEMPeriod,shift_1+1);
   if (demarker_1_0 >= demarker_1_1) { UP_97 = 1; DOWN_97 = 0; }
   if (demarker_1_0 < demarker_1_1) { UP_97 = 0; DOWN_97 = 1; }
   }
   
   if( display_M5 == true )
   {
   double demarker_5_0=iDeMarker(NULL,PERIOD_M5,DEMPeriod,shift_5);
   double demarker_5_1=iDeMarker(NULL,PERIOD_M5,DEMPeriod,shift_5+1);
   if (demarker_5_0 >= demarker_5_1) { UP_98 = 1; DOWN_98 = 0; }
   if (demarker_5_0 < demarker_5_1) { UP_98 = 0; DOWN_98 = 1; }
   }
   
   if( display_M15 == true )
   {
   double demarker_15_0=iDeMarker(NULL,PERIOD_M15,DEMPeriod,shift_15);
   double demarker_15_1=iDeMarker(NULL,PERIOD_M15,DEMPeriod,shift_15+1);
   if (demarker_15_0 >= demarker_15_1) { UP_99 = 1; DOWN_99 = 0; }
   if (demarker_15_0 < demarker_15_1) { UP_99 = 0; DOWN_99 = 1; }
   }
   
   if( display_M30 == true )
   {
   double demarker_30_0=iDeMarker(NULL,PERIOD_M30,DEMPeriod,shift_30);
   double demarker_30_1=iDeMarker(NULL,PERIOD_M30,DEMPeriod,shift_30+1);
   if (demarker_30_0 >= demarker_30_1) { UP_100 = 1; DOWN_100 = 0; }
   if (demarker_30_0 < demarker_30_1) { UP_100 = 0; DOWN_100 = 1; }
   }
   
   if( display_H1 == true )
   {
   double demarker_60_0=iDeMarker(NULL,PERIOD_H1,DEMPeriod,shift_60);
   double demarker_60_1=iDeMarker(NULL,PERIOD_H1,DEMPeriod,shift_60+1);
   if (demarker_60_0 >= demarker_60_1) { UP_101 = 1; DOWN_101 = 0; }
   if (demarker_60_0 < demarker_60_1) { UP_101 = 0; DOWN_101 = 1; }
   }
   
   if( display_H4 == true )
   {
   double demarker_240_0=iDeMarker(NULL,PERIOD_H4,DEMPeriod,shift_240);
   double demarker_240_1=iDeMarker(NULL,PERIOD_H4,DEMPeriod,shift_240+1);
   if (demarker_240_0 >= demarker_240_1) { UP_102 = 1; DOWN_102 = 0; }
   if (demarker_240_0 < demarker_240_1) { UP_102 = 0; DOWN_102 = 1; }
   }
   
   if( display_D1 == true )
   {
   double demarker_1440_0=iDeMarker(NULL,PERIOD_D1,DEMPeriod,shift_1440);
   double demarker_1440_1=iDeMarker(NULL,PERIOD_D1,DEMPeriod,shift_1440+1);
   if (demarker_1440_0 >= demarker_1440_1) { UP_103 = 1; DOWN_103 = 0; }
   if (demarker_1440_0 < demarker_1440_1) { UP_103 = 0; DOWN_103 = 1; }
   }
   }
   
// Indicator (Waddah Attar Explosion)
   
   if( display_WAE == true )
   {
   if( display_M1 == true )
   {
   double wae_histo_up_1_0 = iCustom(NULL,PERIOD_M1,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,0,shift_1);
   double wae_histo_up_1_1 = iCustom(NULL,PERIOD_M1,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,0,shift_1+1);
   double wae_histo_down_1_0 = iCustom(NULL,PERIOD_M1,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,1,shift_1);
   double wae_histo_down_1_1 = iCustom(NULL,PERIOD_M1,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,1,shift_1+1);
   if (wae_histo_up_1_0 > wae_histo_up_1_1 || wae_histo_down_1_0 < wae_histo_down_1_1) { UP_105 = 1; DOWN_105 = 0; }
   if (wae_histo_up_1_0 < wae_histo_up_1_1 || wae_histo_down_1_0 > wae_histo_down_1_1) { UP_105 = 0; DOWN_105 = 1; }
   }
   
   if( display_M5 == true )
   {
   double wae_histo_up_5_0 = iCustom(NULL,PERIOD_M5,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,0,shift_5);
   double wae_histo_up_5_1 = iCustom(NULL,PERIOD_M5,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,0,shift_5+1);
   double wae_histo_down_5_0 = iCustom(NULL,PERIOD_M5,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,1,shift_5);
   double wae_histo_down_5_1 = iCustom(NULL,PERIOD_M5,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,1,shift_5+1);
   if (wae_histo_up_5_0 > wae_histo_up_5_1 || wae_histo_down_5_0 < wae_histo_down_5_1) { UP_106 = 1; DOWN_106 = 0; }
   if (wae_histo_up_5_0 < wae_histo_up_5_1 || wae_histo_down_5_0 > wae_histo_down_5_1) { UP_106 = 0; DOWN_106 = 1; }
   }
   
   if( display_M15 == true )
   {
   double wae_histo_up_15_0 = iCustom(NULL,PERIOD_M15,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,0,shift_15);
   double wae_histo_up_15_1 = iCustom(NULL,PERIOD_M15,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,0,shift_15+1);
   double wae_histo_down_15_0 = iCustom(NULL,PERIOD_M15,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,1,shift_15);
   double wae_histo_down_15_1 = iCustom(NULL,PERIOD_M15,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,1,shift_15+1);
   if (wae_histo_up_15_0 > wae_histo_up_15_1 || wae_histo_down_15_0 < wae_histo_down_15_1) { UP_107 = 1; DOWN_107 = 0; }
   if (wae_histo_up_15_0 < wae_histo_up_15_1 || wae_histo_down_15_0 > wae_histo_down_15_1) { UP_107 = 0; DOWN_107 = 1; }
   }
   
   if( display_M30 == true )
   {
   double wae_histo_up_30_0 = iCustom(NULL,PERIOD_M30,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,0,shift_30);
   double wae_histo_up_30_1 = iCustom(NULL,PERIOD_M30,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,0,shift_30+1);
   double wae_histo_down_30_0 = iCustom(NULL,PERIOD_M30,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,1,shift_30);
   double wae_histo_down_30_1 = iCustom(NULL,PERIOD_M30,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,1,shift_30+1);
   if (wae_histo_up_30_0 > wae_histo_up_30_1 || wae_histo_down_30_0 < wae_histo_down_30_1) { UP_108 = 1; DOWN_108 = 0; }
   if (wae_histo_up_30_0 < wae_histo_up_30_1 || wae_histo_down_30_0 > wae_histo_down_30_1) { UP_108 = 0; DOWN_108 = 1; }
   }
   
   if( display_H1 == true )
   {
   double wae_histo_up_60_0 = iCustom(NULL,PERIOD_H1,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,0,shift_60);
   double wae_histo_up_60_1 = iCustom(NULL,PERIOD_H1,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,0,shift_60+1);
   double wae_histo_down_60_0 = iCustom(NULL,PERIOD_H1,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,1,shift_60);
   double wae_histo_down_60_1 = iCustom(NULL,PERIOD_H1,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,1,shift_60+1);
   if (wae_histo_up_60_0 > wae_histo_up_60_1 || wae_histo_down_60_0 < wae_histo_down_60_1) { UP_109 = 1; DOWN_109 = 0; }
   if (wae_histo_up_60_0 < wae_histo_up_60_1 || wae_histo_down_60_0 > wae_histo_down_60_1) { UP_109 = 0; DOWN_109 = 1; }
   }
   
   if( display_H4 == true )
   {
   double wae_histo_up_240_0 = iCustom(NULL,PERIOD_H4,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,0,shift_240);
   double wae_histo_up_240_1 = iCustom(NULL,PERIOD_H4,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,0,shift_240+1);
   double wae_histo_down_240_0 = iCustom(NULL,PERIOD_H4,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,1,shift_240);
   double wae_histo_down_240_1 = iCustom(NULL,PERIOD_H4,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,1,shift_240+1);
   if (wae_histo_up_240_0 > wae_histo_up_240_1 || wae_histo_down_240_0 < wae_histo_down_240_1) { UP_110 = 1; DOWN_110 = 0; }
   if (wae_histo_up_240_0 < wae_histo_up_240_1 || wae_histo_down_240_0 > wae_histo_down_240_1) { UP_110 = 0; DOWN_110 = 1; }
   }
   
   if( display_D1 == true )
   {
   double wae_histo_up_1440_0 = iCustom(NULL,PERIOD_D1,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,0,shift_1440);
   double wae_histo_up_1440_1 = iCustom(NULL,PERIOD_D1,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,0,shift_1440+1);
   double wae_histo_down_1440_0 = iCustom(NULL,PERIOD_D1,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,1,shift_1440);
   double wae_histo_down_1440_1 = iCustom(NULL,PERIOD_D1,"Waddah_Attar_Explosion",150,30,15,15,false,1,true,true,true,true,1,shift_1440+1);
   if (wae_histo_up_1440_0 > wae_histo_up_1440_1 || wae_histo_down_1440_0 < wae_histo_down_1440_1) { UP_111 = 1; DOWN_111 = 0; }
   if (wae_histo_up_1440_0 < wae_histo_up_1440_1 || wae_histo_down_1440_0 > wae_histo_down_1440_1) { UP_111 = 0; DOWN_111 = 1; }
   }
   }

//---- Count Indicators

   double Indy_count = UP_1 + UP_9 + UP_17 + UP_25 + UP_33 + UP_41 + UP_49 + UP_57 + UP_65 + UP_73 + UP_81 + UP_89 + UP_97 + UP_105
                     + UP_2 + UP_10 + UP_18 + UP_26 + UP_34 + UP_42 + UP_50 + UP_58 + UP_66 + UP_74 + UP_82 + UP_90 + UP_98 + UP_106
                     + UP_3 + UP_11 + UP_19 + UP_27 + UP_35 + UP_43 + UP_51 + UP_59 + UP_67 + UP_75 + UP_83 + UP_91 + UP_99 + UP_107
                     + UP_4 + UP_12 + UP_20 + UP_28 + UP_36 + UP_44 + UP_52 + UP_60 + UP_68 + UP_76 + UP_84 + UP_92 + UP_100 + UP_108
                     + UP_5 + UP_13 + UP_21 + UP_29 + UP_37 + UP_45 + UP_53 + UP_61 + UP_69 + UP_77 + UP_85 + UP_93 + UP_101 + UP_109
                     + UP_6 + UP_14 + UP_22 + UP_30 + UP_38 + UP_46 + UP_54 + UP_62 + UP_70 + UP_78 + UP_86 + UP_94 + UP_102 + UP_110
                     + UP_7 + UP_15 + UP_23 + UP_31 + UP_39 + UP_47 + UP_55 + UP_63 + UP_71 + UP_79 + UP_87 + UP_95 + UP_103 + UP_111
                     + DOWN_1 + DOWN_9 + DOWN_17 + DOWN_25 + DOWN_33 + DOWN_41 + DOWN_49 + DOWN_57 + DOWN_65 + DOWN_73 + DOWN_81 + DOWN_89 + DOWN_97 + DOWN_105
                     + DOWN_2 + DOWN_10 + DOWN_18 + DOWN_26 + DOWN_34 + DOWN_42 + DOWN_50 + DOWN_58 + DOWN_66 + DOWN_74 + DOWN_82 + DOWN_90 + DOWN_98 + DOWN_106
                     + DOWN_3 + DOWN_11 + DOWN_19 + DOWN_27 + DOWN_35 + DOWN_43 + DOWN_51 + DOWN_59 + DOWN_67 + DOWN_75 + DOWN_83 + DOWN_91 + DOWN_99 + DOWN_107
                     + DOWN_4 + DOWN_12 + DOWN_20 + DOWN_28 + DOWN_36 + DOWN_44 + DOWN_52 + DOWN_60 + DOWN_68 + DOWN_76 + DOWN_84 + DOWN_92 + DOWN_100 + DOWN_108
                     + DOWN_5 + DOWN_13 + DOWN_21 + DOWN_29 + DOWN_37 + DOWN_45 + DOWN_53 + DOWN_61 + DOWN_69 + DOWN_77 + DOWN_85 + DOWN_93 + DOWN_101 + DOWN_109
                     + DOWN_6 + DOWN_14 + DOWN_22 + DOWN_30 + DOWN_38 + DOWN_46 + DOWN_54 + DOWN_62 + DOWN_70 + DOWN_78 + DOWN_86 + DOWN_94 + DOWN_102 + DOWN_110
                     + DOWN_7 + DOWN_15 + DOWN_23 + DOWN_31 + DOWN_39 + DOWN_47 + DOWN_55 + DOWN_63 + DOWN_71 + DOWN_79 + DOWN_87 + DOWN_95 + DOWN_103 + DOWN_111;
                       
//---- Calculation of the trend. Let's give TFs more "force"
   
   double UP_m1 = (UP_1 + UP_9 + UP_17 + UP_25 + UP_33 + UP_41 + UP_49 + UP_57 + UP_65 + UP_73 + UP_81 + UP_89 + UP_97 + UP_105) * coef_m1;
   double UP_m5 = (UP_2 + UP_10 + UP_18 + UP_26 + UP_34 + UP_42 + UP_50 + UP_58 + UP_66 + UP_74 + UP_82 + UP_90 + UP_98 + UP_106) * coef_m5;
   double UP_m15 = (UP_3 + UP_11 + UP_19 + UP_27 + UP_35 + UP_43 + UP_51 + UP_59 + UP_67 + UP_75 + UP_83 + UP_91 + UP_99 + UP_107) * coef_m15;
   double UP_m30 = (UP_4 + UP_12 + UP_20 + UP_28 + UP_36 + UP_44 + UP_52 + UP_60 + UP_68 + UP_76 + UP_84 + UP_92 + UP_100 + UP_108) * coef_m30;
   double UP_H1 = (UP_5 + UP_13 + UP_21 + UP_29 + UP_37 + UP_45 + UP_53 + UP_61 + UP_69 + UP_77 + UP_85 + UP_93 + UP_101 + UP_109) * coef_H1;
   double UP_H4 = (UP_6 + UP_14 + UP_22 + UP_30 + UP_38 + UP_46 + UP_54 + UP_62 + UP_70 + UP_78 + UP_86 + UP_94 + UP_102 + UP_110) * coef_H4;
   double UP_D1 = (UP_7 + UP_15 + UP_23 + UP_31 + UP_39 + UP_47 + UP_55 + UP_63 + UP_71 + UP_79 + UP_87 + UP_95 + UP_103 + UP_111) * coef_D1;
   
   double TrendUP = UP_m1 + UP_m5 + UP_m15 + UP_m30 + UP_H1 + UP_H4 + UP_D1;
   
   double DOWN_m1 = (DOWN_1 + DOWN_9 + DOWN_17 + DOWN_25 + DOWN_33 + DOWN_41 + DOWN_49 + DOWN_57 + DOWN_65 + DOWN_73 + DOWN_81 + DOWN_89 + DOWN_97 + DOWN_105) * coef_m1;
   double DOWN_m5 = (DOWN_2 + DOWN_10 + DOWN_18 + DOWN_26 + DOWN_34 + DOWN_42 + DOWN_50 + DOWN_58 + DOWN_66 + DOWN_74 + DOWN_82 + DOWN_90 + DOWN_98 + DOWN_106) * coef_m5;
   double DOWN_m15 = (DOWN_3 + DOWN_11 + DOWN_19 + DOWN_27 + DOWN_35 + DOWN_43 + DOWN_51 + DOWN_59 + DOWN_67 + DOWN_75 + DOWN_83 + DOWN_91 + DOWN_99 + DOWN_107) * coef_m15;
   double DOWN_m30 = (DOWN_4 + DOWN_12 + DOWN_20 + DOWN_28 + DOWN_36 + DOWN_44 + DOWN_52 + DOWN_60 + DOWN_68 + DOWN_76 + DOWN_84 + DOWN_92 + DOWN_100 + DOWN_108) * coef_m30;
   double DOWN_H1 = (DOWN_5 + DOWN_13 + DOWN_21 + DOWN_29 + DOWN_37 + DOWN_45 + DOWN_53 + DOWN_61 + DOWN_69 + DOWN_77 + DOWN_85 + DOWN_93 + DOWN_101 + DOWN_109) * coef_H1;
   double DOWN_H4 = (DOWN_6 + DOWN_14 + DOWN_22 + DOWN_30 + DOWN_38 + DOWN_46 + DOWN_54 + DOWN_62 + DOWN_70 + DOWN_78 + DOWN_86 + DOWN_94 + DOWN_102 + DOWN_110) * coef_H4;
   double DOWN_D1 = (DOWN_7 + DOWN_15 + DOWN_23 + DOWN_31 + DOWN_39 + DOWN_47 + DOWN_55 + DOWN_63 + DOWN_71 + DOWN_79 + DOWN_87 + DOWN_95 + DOWN_103 + DOWN_111) * coef_D1;
   
   double TrendDOWN = DOWN_m1 + DOWN_m5 + DOWN_m15 + DOWN_m30 + DOWN_H1 + DOWN_H4 + DOWN_D1;
   
   string Trend_UP = DoubleToStr(((TrendUP/Indy_count)*100),0);
   string Trend_DOWN = DoubleToStr((100 - StrToDouble(Trend_UP)),0);
                                  
   // UPBuffer[0] = Trend_UP;
   // DOWNBuffer[0] = Trend_DOWN;
   
//---- Result of the trend

   if( box_trend == true )
   {
   
   ObjectCreate("Trend_UP", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Trend_UP","+   Trend   +",9, "Verdana", DarkOrange);
   ObjectSet("Trend_UP", OBJPROP_CORNER, 0);
   ObjectSet("Trend_UP", OBJPROP_XDISTANCE, 908+X_trend-900);
   ObjectSet("Trend_UP", OBJPROP_YDISTANCE, 1+Y_trend);
   
   ObjectCreate("line9", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("line9","----------------",8, "Verdana", DarkOrange);
   ObjectSet("line9", OBJPROP_CORNER, 0);
   ObjectSet("line9", OBJPROP_XDISTANCE, 907+X_trend-900);
   ObjectSet("line9", OBJPROP_YDISTANCE, 12+Y_trend);
   
   ObjectCreate("Trend_UP_text", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Trend_UP_text","UP",9, "Verdana", Lime);
   ObjectSet("Trend_UP_text", OBJPROP_CORNER, 0);
   ObjectSet("Trend_UP_text", OBJPROP_XDISTANCE, 909+X_trend-900);
   ObjectSet("Trend_UP_text", OBJPROP_YDISTANCE, 26+Y_trend);
   
   ObjectCreate("Trend_UP_value", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Trend_UP_value",Trend_UP+"%",9, "Verdana", PeachPuff);
   ObjectSet("Trend_UP_value", OBJPROP_CORNER, 0);
   ObjectSet("Trend_UP_value", OBJPROP_XDISTANCE, 955+X_trend-900);
   ObjectSet("Trend_UP_value", OBJPROP_YDISTANCE, 26+Y_trend);
   
   ObjectCreate("Trend_DOWN_text", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Trend_DOWN_text","DOWN",9, "Verdana", Red);
   ObjectSet("Trend_DOWN_text", OBJPROP_CORNER, 0);
   ObjectSet("Trend_DOWN_text", OBJPROP_XDISTANCE, 909+X_trend-900);
   ObjectSet("Trend_DOWN_text", OBJPROP_YDISTANCE, 46+Y_trend);
   
   ObjectCreate("Trend_DOWN_value", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Trend_DOWN_value",Trend_DOWN+"%",9, "Verdana", PeachPuff);
   ObjectSet("Trend_DOWN_value", OBJPROP_CORNER, 0);
   ObjectSet("Trend_DOWN_value", OBJPROP_XDISTANCE, 955+X_trend-900);
   ObjectSet("Trend_DOWN_value", OBJPROP_YDISTANCE, 46+Y_trend);
   
   string trend;
   string comment;
   color coltrend;
   color colcomment;
   double xt, xc;
   
   if(StrToDouble(Trend_UP) >= TrendStrongLevel) { trend = "UP"; coltrend = Lime; xt = 935; comment = "[strong]"; xc = 921; colcomment = Lime; /* if (alert == true) { Alert(TimeToStr(TimeCurrent(),TIME_SECONDS)," Trend UP > "TrendStrongLevel"% on ",Symbol()," ", Bid); PlaySound("tick.wav"); } */ }
   else if(StrToDouble(Trend_UP) < TrendStrongLevel && StrToDouble(Trend_UP) >= 50) { trend = "UP"; coltrend = Lime; xt = 935; comment = "[weak]"; xc = 924; colcomment = Orange; }
   else if(StrToDouble(Trend_DOWN) >= TrendStrongLevel) { trend = "DOWN"; coltrend = Red; xt = 918; comment = "[strong]"; xc = 921; colcomment = Red; /* if (alert == true) { Alert(TimeToStr(TimeCurrent(),TIME_SECONDS)," Trend DOWN > "TrendStrongLevel"% on ",Symbol()," ", Bid); PlaySound("tick.wav"); } */ }
   else if(StrToDouble(Trend_DOWN) < TrendStrongLevel && StrToDouble(Trend_DOWN) > 50) { trend = "DOWN"; coltrend = Red; xt = 918; comment = "[weak]"; xc = 924; colcomment = Orange; }
   
   ObjectCreate("line10", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("line10","----------------",8, "Verdana", coltrend);
   ObjectSet("line10", OBJPROP_CORNER, 0);
   ObjectSet("line10", OBJPROP_XDISTANCE, 907+X_trend-900);
   ObjectSet("line10", OBJPROP_YDISTANCE, 61+Y_trend);
   
   ObjectCreate("line12", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("line12","----------------",8, "Verdana", coltrend);
   ObjectSet("line12", OBJPROP_CORNER, 0);
   ObjectSet("line12", OBJPROP_XDISTANCE, 907+X_trend-900);
   ObjectSet("line12", OBJPROP_YDISTANCE, 64+Y_trend);
   
   ObjectCreate("Trend", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Trend",trend,18, "Impact", coltrend);
   ObjectSet("Trend", OBJPROP_CORNER, 0);
   ObjectSet("Trend", OBJPROP_XDISTANCE, xt+X_trend-900);
   ObjectSet("Trend", OBJPROP_YDISTANCE, 76+Y_trend);
   
   ObjectCreate("Trend_comment", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Trend_comment",comment,10, "Verdana", colcomment);
   ObjectSet("Trend_comment", OBJPROP_CORNER, 0);
   ObjectSet("Trend_comment", OBJPROP_XDISTANCE, xc+X_trend-900);
   ObjectSet("Trend_comment", OBJPROP_YDISTANCE, 106+Y_trend);
   
   ObjectCreate("line13", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("line13","----------------",8, "Verdana", coltrend);
   ObjectSet("line13", OBJPROP_CORNER, 0);
   ObjectSet("line13", OBJPROP_XDISTANCE, 907+X_trend-900);
   ObjectSet("line13", OBJPROP_YDISTANCE, 123+Y_trend);
   
   ObjectCreate("line11", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("line11","----------------",8, "Verdana", coltrend);
   ObjectSet("line11", OBJPROP_CORNER, 0);
   ObjectSet("line11", OBJPROP_XDISTANCE, 907+X_trend-900);
   ObjectSet("line11", OBJPROP_YDISTANCE, 126+Y_trend);
   
   }   // if( box_trend == true )
   
   
// DAILY PIVOTS AND RANGE
   
//---- Get new daily prices

   ArrayCopyRates(rates_d1, Symbol(), PERIOD_D1);
   
//---- modifs ibfx
   int offset = 0;
   if(DayOfWeek()==1) offset=1;
//----

   double day50_high = rates_d1[50+offset][3];
   double day50_low = rates_d1[50+offset][2]; 
   double day49_high = rates_d1[49+offset][3];
   double day49_low = rates_d1[49+offset][2]; 
   double day48_high = rates_d1[48+offset][3];
   double day48_low = rates_d1[48+offset][2]; 
   double day47_high = rates_d1[47+offset][3];
   double day47_low = rates_d1[47+offset][2]; 
   double day46_high = rates_d1[46+offset][3];
   double day46_low = rates_d1[46+offset][2]; 
   double day45_high = rates_d1[45+offset][3];
   double day45_low = rates_d1[45+offset][2]; 
   double day44_high = rates_d1[44+offset][3];
   double day44_low = rates_d1[44+offset][2]; 
   double day43_high = rates_d1[43+offset][3];
   double day43_low = rates_d1[43+offset][2]; 
   double day42_high = rates_d1[42+offset][3];
   double day42_low = rates_d1[42+offset][2]; 
   double day41_high = rates_d1[41+offset][3];
   double day41_low = rates_d1[41+offset][2]; 
   double day40_high = rates_d1[40+offset][3];
   double day40_low = rates_d1[40+offset][2]; 
   double day39_high = rates_d1[39+offset][3];
   double day39_low = rates_d1[39+offset][2]; 
   double day38_high = rates_d1[38+offset][3];
   double day38_low = rates_d1[38+offset][2]; 
   double day37_high = rates_d1[37+offset][3];
   double day37_low = rates_d1[37+offset][2]; 
   double day36_high = rates_d1[36+offset][3];
   double day36_low = rates_d1[36+offset][2]; 
   double day35_high = rates_d1[35+offset][3];
   double day35_low = rates_d1[35+offset][2]; 
   double day34_high = rates_d1[34+offset][3];
   double day34_low = rates_d1[34+offset][2]; 
   double day33_high = rates_d1[33+offset][3];
   double day33_low = rates_d1[33+offset][2]; 
   double day32_high = rates_d1[32+offset][3];
   double day32_low = rates_d1[32+offset][2]; 
   double day31_high = rates_d1[31+offset][3];
   double day31_low = rates_d1[31+offset][2]; 
   double day30_high = rates_d1[30+offset][3];
   double day30_low = rates_d1[30+offset][2]; 
   double day29_high = rates_d1[29+offset][3];
   double day29_low = rates_d1[29+offset][2]; 
   double day28_high = rates_d1[28+offset][3];
   double day28_low = rates_d1[28+offset][2]; 
   double day27_high = rates_d1[27+offset][3];
   double day27_low = rates_d1[27+offset][2]; 
   double day26_high = rates_d1[26+offset][3];
   double day26_low = rates_d1[26+offset][2]; 
   double day25_high = rates_d1[25+offset][3];
   double day25_low = rates_d1[25+offset][2]; 
   double day24_high = rates_d1[24+offset][3];
   double day24_low = rates_d1[24+offset][2]; 
   double day23_high = rates_d1[23+offset][3];
   double day23_low = rates_d1[23+offset][2]; 
   double day22_high = rates_d1[22+offset][3];
   double day22_low = rates_d1[22+offset][2]; 
   double day21_high = rates_d1[21+offset][3];
   double day21_low = rates_d1[21+offset][2]; 
   double day20_high = rates_d1[20+offset][3];
   double day20_low = rates_d1[20+offset][2]; 
   double day19_high = rates_d1[19+offset][3];
   double day19_low = rates_d1[19+offset][2]; 
   double day18_high = rates_d1[18+offset][3];
   double day18_low = rates_d1[18+offset][2]; 
   double day17_high = rates_d1[17+offset][3];
   double day17_low = rates_d1[17+offset][2]; 
   double day16_high = rates_d1[16+offset][3];
   double day16_low = rates_d1[16+offset][2]; 
   double day15_high = rates_d1[15+offset][3];
   double day15_low = rates_d1[15+offset][2]; 
   double day14_high = rates_d1[14+offset][3];
   double day14_low = rates_d1[14+offset][2]; 
   double day13_high = rates_d1[13+offset][3];
   double day13_low = rates_d1[13+offset][2]; 
   double day12_high = rates_d1[12+offset][3];
   double day12_low = rates_d1[12+offset][2]; 
   double day11_high = rates_d1[11+offset][3];
   double day11_low = rates_d1[11+offset][2]; 
   double day10_high = rates_d1[10+offset][3];
   double day10_low = rates_d1[10+offset][2]; 
   double day9_high = rates_d1[9+offset][3];
   double day9_low = rates_d1[9+offset][2];
   double day8_high = rates_d1[8+offset][3];
   double day8_low = rates_d1[8+offset][2]; 
   double day7_high = rates_d1[7+offset][3];
   double day7_low = rates_d1[7+offset][2]; 
   double day6_high = rates_d1[6+offset][3];
   double day6_low = rates_d1[6+offset][2]; 
   double day5_high = rates_d1[5+offset][3];
   double day5_low = rates_d1[5+offset][2]; 
   double day4_high = rates_d1[4+offset][3];
   double day4_low = rates_d1[4+offset][2]; 
   double day3_high = rates_d1[3+offset][3];
   double day3_low = rates_d1[3+offset][2]; 
   double day2_high = rates_d1[2+offset][3];
   double day2_low = rates_d1[2+offset][2]; 
   double yesterday_high = rates_d1[1+offset][3];
   double yesterday_low = rates_d1[1+offset][2];
   double yesterday_close = rates_d1[1+offset][4];
   double day_high = rates_d1[0][3];
   double day_low = rates_d1[0][2];
   
/*
   int i=0;

   ArrayCopyRates(rates_h1, Symbol(), PERIOD_H1);
   for (i=0;i<=25;i++)
   {
    if (TimeMinute(rates_h1[i][0])==0 && (TimeHour(rates_h1[i][0])-TimeZone)==0)
    {
     yesterday_close = rates_h1[i+1][4];      
     yesterday_open = rates_h1[i+24][1];
     today_open = rates_h1[i][1];      
     break;
    }
   }
*/

//---- Calculate Pivots et range

   double D = (day_high - day_low);
   double Q = (yesterday_high - yesterday_low);
   double Q2 = (day2_high - day2_low);
   double Q3 = (day3_high - day3_low);
   double Q4 = (day4_high - day4_low);
   double Q5 = (day5_high - day5_low);
   double Q6 = (day6_high - day6_low);
   double Q7 = (day7_high - day7_low);
   double Q8 = (day8_high - day8_low);
   double Q9 = (day9_high - day9_low);
   double Q10 = (day10_high - day10_low);
   double Q11 = (day11_high - day11_low);
   double Q12 = (day12_high - day12_low);
   double Q13 = (day13_high - day13_low);
   double Q14 = (day14_high - day14_low);
   double Q15 = (day15_high - day15_low);
   double Q16 = (day16_high - day16_low);
   double Q17 = (day17_high - day17_low);
   double Q18 = (day18_high - day18_low);
   double Q19 = (day19_high - day19_low);
   double Q20 = (day20_high - day20_low);
   double Q21 = (day21_high - day21_low);
   double Q22 = (day22_high - day22_low);
   double Q23 = (day23_high - day23_low);
   double Q24 = (day24_high - day24_low);
   double Q25 = (day25_high - day25_low);
   double Q26 = (day26_high - day26_low);
   double Q27 = (day27_high - day27_low);
   double Q28 = (day28_high - day28_low);
   double Q29 = (day29_high - day29_low);
   double Q30 = (day30_high - day30_low);
   double Q31 = (day31_high - day31_low);
   double Q32 = (day32_high - day32_low);
   double Q33 = (day33_high - day33_low);
   double Q34 = (day34_high - day34_low);
   double Q35 = (day35_high - day35_low);
   double Q36 = (day36_high - day36_low);
   double Q37 = (day37_high - day37_low);
   double Q38 = (day38_high - day38_low);
   double Q39 = (day39_high - day39_low);
   double Q40 = (day40_high - day40_low);
   double Q41 = (day41_high - day41_low);
   double Q42 = (day42_high - day42_low);
   double Q43 = (day43_high - day43_low);
   double Q44 = (day44_high - day44_low);
   double Q45 = (day45_high - day45_low);
   double Q46 = (day46_high - day46_low);
   double Q47 = (day47_high - day47_low);
   double Q48 = (day48_high - day48_low);
   double Q49 = (day49_high - day49_low);
   double Q50 = (day50_high - day50_low);
   double P = (yesterday_high + yesterday_low + yesterday_close) / 3;
   double R1 = (2*P)-yesterday_low;
   double S1 = (2*P)-yesterday_high;
   double R2 = P+(R1 - S1);
   double S2 = P-(R1 - S1);
	double R3 = (2*P)+(yesterday_high-(2*yesterday_low));
	double S3 = (2*P)-((2* yesterday_high)-yesterday_low);
	
	
	
	
	
	int Precision, dig;
{
   if( StringFind( Symbol(), "JPY", 0) != -1 ) { Precision = 100; dig = 2;}
   else                                        { Precision = 10000; dig = 4; }
} 
	double D0 = D * Precision;
	double Q0 = Q * Precision;
	double Q5_av = ((Q + Q2 + Q3 + Q4 + Q5) / 5) * Precision;
	double Q10_av = ((Q + Q2 + Q3 + Q4 + Q5 + Q6 + Q7 + Q8 + Q9 + Q10) / 10) * Precision;
	double Q20_av = ((Q + Q2 + Q3 + Q4 + Q5 + Q6 + Q7 + Q8 + Q9
	                 + Q10 + Q11 + Q12 + Q13 + Q14 + Q15 + Q16 + Q17 + Q18 + Q19 + Q20) / 20) * Precision;
	/*
	double Q30_av = ((Q + Q2 + Q3 + Q4 + Q5 + Q6 + Q7 + Q8 + Q9
	                 + Q10 + Q11 + Q12 + Q13 + Q14 + Q15 + Q16 + Q17 + Q18 + Q19
	                 + Q20 + Q21 + Q22 + Q23 + Q24 + Q25 + Q26 + Q27 + Q28 + Q29 + Q30) / 30) * Precision;
	double Q40_av = ((Q + Q2 + Q3 + Q4 + Q5 + Q6 + Q7 + Q8 + Q9
	                 + Q10 + Q11 + Q12 + Q13 + Q14 + Q15 + Q16 + Q17 + Q18 + Q19
	                 + Q20 + Q21 + Q22 + Q23 + Q24 + Q25 + Q26 + Q27 + Q28 + Q29
	                 + Q30 + Q31 + Q32 + Q33 + Q34 + Q35 + Q36 + Q37 + Q38 + Q39 + Q40) / 40) * Precision;
	*/
	double Q50_av = ((Q + Q2 + Q3 + Q4 + Q5 + Q6 + Q7 + Q8 + Q9
	                 + Q10 + Q11 + Q12 + Q13 + Q14 + Q15 + Q16 + Q17 + Q18 + Q19
	                 + Q20 + Q21 + Q22 + Q23 + Q24 + Q25 + Q26 + Q27 + Q28 + Q29
	                 + Q30 + Q31 + Q32 + Q33 + Q34 + Q35 + Q36 + Q37 + Q38 + Q39
	                 + Q40 + Q41 + Q42 + Q43 + Q44 + Q45 + Q46 + Q47 + Q48 + Q49 + Q50) / 50) * Precision;
	
	double average_range = (Q0 + Q5_av + Q10_av + Q20_av + Q50_av) / 5;
	
	
//---- Set Pivots labels

   if( box_pivots == true )
   {
   int Ydist_line5;
   int Corner_pivots, Xdist_pivots, Ydist_pivots;
   int Ydist_R3, Ydist_R2, Ydist_R1, Ydist_PV, Ydist_S1, Ydist_S2, Ydist_S3;
   color color_pivots_1=PaleVioletRed;
   
    Corner_line = 0; Corner_text = 0; Corner_value = 0;
    Xdist_line = 1010+(X_pivots-1000); Xdist_text = 1013+(X_pivots-1000); Xdist_value = 1050+(X_pivots-1000);
    Ydist_line5 = 16+(Y_pivots-5);
    Corner_pivots = 0; Xdist_pivots = 1010+(X_pivots-1000); Ydist_pivots = 5+(Y_pivots-5);
    Ydist_R3 = 30+(Y_pivots-5); Ydist_R2 = 45+(Y_pivots-5); Ydist_R1 = 60+(Y_pivots-5); Ydist_PV = 75+(Y_pivots-5); Ydist_S1 = 90+(Y_pivots-5); Ydist_S2 = 105+(Y_pivots-5); Ydist_S3 = 120+(Y_pivots-5);
   

   ObjectCreate("pivots", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("pivots","+Daily Pivots+",9, "Verdana", color_pivots_1);
   ObjectSet("pivots", OBJPROP_CORNER, Corner_pivots);
   ObjectSet("pivots", OBJPROP_XDISTANCE, Xdist_pivots);
   ObjectSet("pivots", OBJPROP_YDISTANCE, Ydist_pivots);
   
   ObjectCreate("line5", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("line5","------------------",7, "Verdana", color_pivots_1);
   ObjectSet("line5", OBJPROP_CORNER, Corner_line);
   ObjectSet("line5", OBJPROP_XDISTANCE, Xdist_line);
   ObjectSet("line5", OBJPROP_YDISTANCE, Ydist_line5);
   
   ObjectCreate("R3_Label", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("R3_Label","R3",9, "Verdana", Gainsboro);
   ObjectSet("R3_Label", OBJPROP_CORNER, Corner_text);
   ObjectSet("R3_Label", OBJPROP_XDISTANCE, Xdist_text);
   ObjectSet("R3_Label", OBJPROP_YDISTANCE, Ydist_R3);
   
   ObjectCreate("R3_Value", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("R3_Value"," "+DoubleToStr(R3,dig),9, "Verdana", Gainsboro);
   ObjectSet("R3_Value", OBJPROP_CORNER, Corner_value);
   ObjectSet("R3_Value", OBJPROP_XDISTANCE, Xdist_value);
   ObjectSet("R3_Value", OBJPROP_YDISTANCE, Ydist_R3);
   
   ObjectCreate("R2_Label", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("R2_Label","R2",9, "Verdana", Silver);
   ObjectSet("R2_Label", OBJPROP_CORNER, Corner_text);
   ObjectSet("R2_Label", OBJPROP_XDISTANCE, Xdist_text);
   ObjectSet("R2_Label", OBJPROP_YDISTANCE, Ydist_R2);
   
   ObjectCreate("R2_Value", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("R2_Value"," "+DoubleToStr(R2,dig),9, "Verdana", Silver);
   ObjectSet("R2_Value", OBJPROP_CORNER, Corner_value);
   ObjectSet("R2_Value", OBJPROP_XDISTANCE, Xdist_value);
   ObjectSet("R2_Value", OBJPROP_YDISTANCE, Ydist_R2);
   
   ObjectCreate("R1_Label", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("R1_Label","R1",9, "Verdana", DarkGray);
   ObjectSet("R1_Label", OBJPROP_CORNER, Corner_text);
   ObjectSet("R1_Label", OBJPROP_XDISTANCE, Xdist_text);
   ObjectSet("R1_Label", OBJPROP_YDISTANCE, Ydist_R1);
   
   ObjectCreate("R1_Value", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("R1_Value"," "+DoubleToStr(R1,dig),9, "Verdana", DarkGray);
   ObjectSet("R1_Value", OBJPROP_CORNER, Corner_value);
   ObjectSet("R1_Value", OBJPROP_XDISTANCE, Xdist_value);
   ObjectSet("R1_Value", OBJPROP_YDISTANCE, Ydist_R1);
   
   ObjectCreate("Pivot_Label", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Pivot_Label","PV",9, "Verdana", Gray);
   ObjectSet("Pivot_Label", OBJPROP_CORNER, Corner_text);
   ObjectSet("Pivot_Label", OBJPROP_XDISTANCE, Xdist_text);
   ObjectSet("Pivot_Label", OBJPROP_YDISTANCE, Ydist_PV);
   
   ObjectCreate("Pivot_Value", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Pivot_Value"," "+DoubleToStr(P,dig),9, "Verdana", Gray);
   ObjectSet("Pivot_Value", OBJPROP_CORNER, Corner_value);
   ObjectSet("Pivot_Value", OBJPROP_XDISTANCE, Xdist_value);
   ObjectSet("Pivot_Value", OBJPROP_YDISTANCE, Ydist_PV);
   
   ObjectCreate("S1_Label", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("S1_Label","S1",9, "Verdana", DarkGray);
   ObjectSet("S1_Label", OBJPROP_CORNER, Corner_text);
   ObjectSet("S1_Label", OBJPROP_XDISTANCE, Xdist_text);
   ObjectSet("S1_Label", OBJPROP_YDISTANCE, Ydist_S1);
   
   ObjectCreate("S1_Value", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("S1_Value"," "+DoubleToStr(S1,dig),9, "Verdana", DarkGray);
   ObjectSet("S1_Value", OBJPROP_CORNER, Corner_value);
   ObjectSet("S1_Value", OBJPROP_XDISTANCE, Xdist_value);
   ObjectSet("S1_Value", OBJPROP_YDISTANCE, Ydist_S1);
   
   ObjectCreate("S2_Label", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("S2_Label","S2",9, "Verdana", Silver);
   ObjectSet("S2_Label", OBJPROP_CORNER, Corner_text);
   ObjectSet("S2_Label", OBJPROP_XDISTANCE, Xdist_text);
   ObjectSet("S2_Label", OBJPROP_YDISTANCE, Ydist_S2);
   
   ObjectCreate("S2_Value", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("S2_Value"," "+DoubleToStr(S2,dig),9, "Verdana", Silver);
   ObjectSet("S2_Value", OBJPROP_CORNER, Corner_value);
   ObjectSet("S2_Value", OBJPROP_XDISTANCE, Xdist_value);
   ObjectSet("S2_Value", OBJPROP_YDISTANCE, Ydist_S2);
   
   ObjectCreate("S3_Label", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("S3_Label","S3",9, "Verdana", Gainsboro);
   ObjectSet("S3_Label", OBJPROP_CORNER, Corner_text);
   ObjectSet("S3_Label", OBJPROP_XDISTANCE, Xdist_text);
   ObjectSet("S3_Label", OBJPROP_YDISTANCE, Ydist_S3);
   
   ObjectCreate("S3_Value", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("S3_Value"," "+DoubleToStr(S3,dig),9, "Verdana", Gainsboro);
   ObjectSet("S3_Value", OBJPROP_CORNER, Corner_value);
   ObjectSet("S3_Value", OBJPROP_XDISTANCE, Xdist_value);
   ObjectSet("S3_Value", OBJPROP_YDISTANCE, Ydist_S3);
   
   }   // if( box_pivots == true )
   
   
   
// DAILY RANGE

   if( box_range == true )
   {

   int Ydist_line6, Ydist_line7, Ydist_line8;
   int Corner_range, Xdist_range, Ydist_range;
   int Ydist_today, Ydist_yesterday, Ydist_5, Ydist_10, Ydist_20, Ydist_50;
   int Ydist_average;
  
    Corner_line = 0; Corner_text = 0; Corner_value = 0;
    Xdist_line = 1121+(X_range-1115); Xdist_text = 1124+(X_range-1115); Xdist_value = 1185+(X_range-1115);
    Ydist_line6 = 16+(Y_range-5); Ydist_line7 = 112+(Y_range-5); Ydist_line8 = 127+(Y_range-5);
    Corner_range = 0; Xdist_range = 1120+(X_range-1115); Ydist_range = 5+(Y_range-5);
    Ydist_today = 28+(Y_range-5); Ydist_yesterday = 42+(Y_range-5); Ydist_5 = 57+(Y_range-5); Ydist_10 = 72+(Y_range-5); Ydist_20 = 87+(Y_range-5); Ydist_50 = 102+(Y_range-5); Ydist_average = 118+(Y_range-5);
  
   ObjectCreate("daily_range", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("daily_range","+Daily Range+",9, "Verdana", MediumTurquoise);
   ObjectSet("daily_range", OBJPROP_CORNER, Corner_range);
   ObjectSet("daily_range", OBJPROP_XDISTANCE, Xdist_range);
   ObjectSet("daily_range", OBJPROP_YDISTANCE, Ydist_range);
   
   ObjectCreate("line6", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("line6","------------------",8, "Verdana", MediumTurquoise);
   ObjectSet("line6", OBJPROP_CORNER, Corner_line);
   ObjectSet("line6", OBJPROP_XDISTANCE, Xdist_line);
   ObjectSet("line6", OBJPROP_YDISTANCE, Ydist_line6);
   
   ObjectCreate("today", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("today","Today",9, "Verdana", WhiteSmoke);
   ObjectSet("today", OBJPROP_CORNER, Corner_text);
   ObjectSet("today", OBJPROP_XDISTANCE, Xdist_text);
   ObjectSet("today", OBJPROP_YDISTANCE, Ydist_today);
   
   ObjectCreate("today_range", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("today_range",DoubleToStr(D0,0),9, "Verdana", WhiteSmoke);
   ObjectSet("today_range", OBJPROP_CORNER, Corner_value);
   ObjectSet("today_range", OBJPROP_XDISTANCE, Xdist_value);
   ObjectSet("today_range", OBJPROP_YDISTANCE, Ydist_today);
   
   ObjectCreate("yesterday", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("yesterday","1 Day",9, "Verdana", Gainsboro);
   ObjectSet("yesterday", OBJPROP_CORNER, Corner_text);
   ObjectSet("yesterday", OBJPROP_XDISTANCE, Xdist_text);
   ObjectSet("yesterday", OBJPROP_YDISTANCE, Ydist_yesterday);
   
   ObjectCreate("yesterday_range", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("yesterday_range",DoubleToStr(Q0,0),9, "Verdana", Gainsboro);
   ObjectSet("yesterday_range", OBJPROP_CORNER, Corner_value);
   ObjectSet("yesterday_range", OBJPROP_XDISTANCE, Xdist_value);
   ObjectSet("yesterday_range", OBJPROP_YDISTANCE, Ydist_yesterday);
   
   ObjectCreate("5_days", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("5_days","5 Days",9, "Verdana", LightGray);
   ObjectSet("5_days", OBJPROP_CORNER, Corner_text);
   ObjectSet("5_days", OBJPROP_XDISTANCE, Xdist_text);
   ObjectSet("5_days", OBJPROP_YDISTANCE, Ydist_5);
   
   ObjectCreate("5_days_range", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("5_days_range",DoubleToStr(Q5_av,0),9, "Verdana", LightGray);
   ObjectSet("5_days_range", OBJPROP_CORNER, Corner_value);
   ObjectSet("5_days_range", OBJPROP_XDISTANCE, Xdist_value);
   ObjectSet("5_days_range", OBJPROP_YDISTANCE, Ydist_5);
   
   ObjectCreate("10_days", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("10_days","10 Days",9, "Verdana", Silver);
   ObjectSet("10_days", OBJPROP_CORNER, Corner_text);
   ObjectSet("10_days", OBJPROP_XDISTANCE, Xdist_text);
   ObjectSet("10_days", OBJPROP_YDISTANCE, Ydist_10);
   
   ObjectCreate("10_days_range", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("10_days_range",DoubleToStr(Q10_av,0),9, "Verdana", Silver);
   ObjectSet("10_days_range", OBJPROP_CORNER, Corner_value);
   ObjectSet("10_days_range", OBJPROP_XDISTANCE, Xdist_value);
   ObjectSet("10_days_range", OBJPROP_YDISTANCE, Ydist_10);
   
   ObjectCreate("20_days", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("20_days","20 Days",9, "Verdana", DarkGray);
   ObjectSet("20_days", OBJPROP_CORNER, Corner_text);
   ObjectSet("20_days", OBJPROP_XDISTANCE, Xdist_text);
   ObjectSet("20_days", OBJPROP_YDISTANCE, Ydist_20);
   
   ObjectCreate("20_days_range", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("20_days_range",DoubleToStr(Q20_av,0),9, "Verdana", DarkGray);
   ObjectSet("20_days_range", OBJPROP_CORNER, Corner_value);
   ObjectSet("20_days_range", OBJPROP_XDISTANCE, Xdist_value);
   ObjectSet("20_days_range", OBJPROP_YDISTANCE, Ydist_20);
   
   ObjectCreate("50_days", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("50_days","50 Days",9, "Verdana", Gray);
   ObjectSet("50_days", OBJPROP_CORNER, Corner_text);
   ObjectSet("50_days", OBJPROP_XDISTANCE, Xdist_text);
   ObjectSet("50_days", OBJPROP_YDISTANCE, Ydist_50);
   
   ObjectCreate("50_days_range", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("50_days_range",DoubleToStr(Q50_av,0),9, "Verdana", Gray);
   ObjectSet("50_days_range", OBJPROP_CORNER, Corner_value);
   ObjectSet("50_days_range", OBJPROP_XDISTANCE, Xdist_value);
   ObjectSet("50_days_range", OBJPROP_YDISTANCE, Ydist_50);
   
   ObjectCreate("line7", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("line7","------------------",8, "Verdana", PeachPuff);
   ObjectSet("line7", OBJPROP_CORNER, Corner_line);
   ObjectSet("line7", OBJPROP_XDISTANCE, Xdist_line);
   ObjectSet("line7", OBJPROP_YDISTANCE, Ydist_line7);
   
   ObjectCreate("Average", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Average","Average",9, "Verdana", Coral);
   ObjectSet("Average", OBJPROP_CORNER, Corner_text);
   ObjectSet("Average", OBJPROP_XDISTANCE, Xdist_text);
   ObjectSet("Average", OBJPROP_YDISTANCE, Ydist_average);
   
   ObjectCreate("Average_range", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Average_range",DoubleToStr(average_range,0),9, "Verdana", SandyBrown);
   ObjectSet("Average_range", OBJPROP_CORNER, Corner_value);
   ObjectSet("Average_range", OBJPROP_XDISTANCE, Xdist_value);
   ObjectSet("Average_range", OBJPROP_YDISTANCE, Ydist_average);
   
   ObjectCreate("line8", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("line8","------------------",8, "Verdana", PeachPuff);
   ObjectSet("line8", OBJPROP_CORNER, Corner_line);
   ObjectSet("line8", OBJPROP_XDISTANCE, Xdist_line);
   ObjectSet("line8", OBJPROP_YDISTANCE, Ydist_line8);
   
   }   // if( box_range == true )
   
      
   return(0);
  }