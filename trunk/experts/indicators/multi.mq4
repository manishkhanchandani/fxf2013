//+------------------------------------------------------------------+
//|                                         MultiPair Indicator.mq4 |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                   http://wallstreetfx.comze.com/ |
//+------------------------------------------------------------------+
#property copyright "Damien S"
#property link      "http://wallstreetfx.comze.com/"
 
#property indicator_separate_window
#property indicator_buffers 7
#property indicator_color1 OrangeRed
#property indicator_color2 Black
#property indicator_color3 Green
#property indicator_color4 Black
#property indicator_color5 Black
#property indicator_color6 Red
#property indicator_color7 Red
 
 
 
string Pair = "";
extern string Indicator= "CCI";
 
 
extern string setup_a=" Indicateur ? une seule period" ;
extern int period =14;
 
extern string setup_b= "Pour le MACD et OSMA";
extern int fast = 12;
extern int slow= 26;
extern int signal =9;
 
extern string setup_c="Pour le Stochastique";
extern int KPeriod=5;
extern int DPeriod=3;
extern int Slowing=3;
 
extern string setup_d="D?finition du style";
extern string Style = "LIGNE";
extern int Style_point= 159;
 
extern string setup_e="D?finition du style de prix et MA";
extern string price ="CLOSE";
extern string ma_style ="SMA";
 
 
double Id[];
double Id_2[];
double Id_3[];
double ext_1[];
double ext_2[];
double ext_3[];
double ext_4[];
 
int init()
{
   Pair = Symbol();
   IndicatorShortName("Multi indic("+Pair+","+Indicator+","+period+")");
   SetIndexStyle(0,DRAW_LINE,0,2);
   SetIndexBuffer(0,Id);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,Id_2);
   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexBuffer(2,Id_3);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,ext_1);
   SetIndexStyle(4,DRAW_LINE);
   SetIndexBuffer(4,ext_2);
   SetIndexStyle(5,DRAW_LINE);
   SetIndexBuffer(5,ext_3);
   SetIndexStyle(6,DRAW_LINE);
   SetIndexBuffer(6,ext_4);
   return(0);
}
 
void start()
{
   
 
   int counted_bars=IndicatorCounted();
 
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   double prix,mode;
   string ls_0 = "Multi ";
   int li_8 = WindowFind(ls_0);
   for(int i=0; i<limit; i++)
   {
   
                                                                 // D?finition du prix
     if (price == "CLOSE")                  prix= PRICE_CLOSE;
     if (price == "TYPICAL")                prix= PRICE_TYPICAL;
     if (price == "HIGH")                   prix= PRICE_HIGH;
     if (price == "LOW")                    prix= PRICE_LOW;
     if (price == "OPEN")                   prix= PRICE_OPEN;
     if (price == "MEDIAN")                 prix= PRICE_MEDIAN;
     if (price == "WEIGHTED")               prix= PRICE_WEIGHTED;
                                                                 // D?finition du style moving average
 
     if (ma_style == "SMA")                 mode= MODE_SMA;
     if (ma_style == "EMA")                 mode= MODE_EMA;
     if (ma_style == "LWMA")                mode= MODE_LWMA;
     if (ma_style == "SMOOT")               mode= MODE_SMMA;
 
                                                                 // Choix des indicateurs de 1 buffer
 
      if (Indicator == "CCI")    Id[i]     = iCCI(Pair,0,period,prix,i) ; 
      if (Indicator == "RSI")    Id[i]     = iRSI(Pair,0,period,prix,i);
      if (Indicator == "BULL")   Id[i]     = iBullsPower(Pair, 0, period,prix,i);
      if (Indicator == "BEAR")   Id[i]     = iBullsPower(Pair, 0, period,prix,i);
      if (Indicator == "OBV")    Id[i]     = iOBV(Pair, 0, prix, i);
      if (Indicator == "MOM")    Id[i]     = iMomentum(Pair,0,period,prix,i);
      if (Indicator == "STDEV")  Id[i]     = iStdDev(Pair,0,period,0,mode,prix,i);
      if (Indicator == "MFI")    Id[i]     = iMFI(Pair,0,period,i);
      if (Indicator == "ATR")    Id[i]     = iATR(Pair,0,period,i);
      if (Indicator == "FORCE")  Id[i]     = iForce(Pair, 0, period,mode,prix,i);
      if (Indicator == "AC")     Id[i]     = iAC(Pair, 0, i);
      if (Indicator == "AO")     Id[i]     = iAO(Pair, 0, i);
      if (Indicator == "OSMA")   Id[i]     = iOsMA(Pair,0,fast,slow,signal,prix,i);
      if (Indicator == "BB")     Id[i]     = iBullsPower(Pair, 0, period,prix,i);
      if (Indicator == "BB")     Id_2[i]   = iBearsPower(Pair, 0, period,prix,i);
 
 
 
                                                                // Choix des indicateur ? plusieurs buffers
 
 
 
      if (Indicator == "MACD") Id[i]       = iMACD(Pair,0,fast,slow,signal,prix,MODE_MAIN,i);
      if (Indicator == "MACD") Id_2[i]     = iMACD(Pair,0,fast,slow,signal,prix,MODE_SIGNAL,i);
      if (Indicator == "MACD") Id_3[i]     = iMACD(Pair,0,fast,slow,signal,prix,MODE_MAIN,i)- iMACD(Pair,0,fast,slow,signal,PRICE_CLOSE,MODE_SIGNAL,i);
      
      if (Indicator == "STO") Id[i]        = iStochastic(Pair,0,KPeriod,DPeriod,Slowing,mode,0,MODE_MAIN,i);
      if (Indicator == "STO") Id_2[i]      = iStochastic(Pair,0,KPeriod,DPeriod,Slowing,mode,0,MODE_SIGNAL,i);
      
      if (Indicator == "ADX") Id[i]        = iADX(Pair,0,period,prix,MODE_PLUSDI,i);
      if (Indicator == "ADX") Id_2[i]      = iADX(Pair,0,period,prix,MODE_MINUSDI,i);
 
      
                                                  // D?finition du nom et des periods ? afficher pour les cas "MACD","Sto" et "OSMA3
      
      if (Indicator == "MACD")    IndicatorShortName("Multi indic("+Pair+","+Indicator+","+fast+","+slow+","+signal+")");
      if (Indicator == "STO")     IndicatorShortName("Multi indic("+Pair+","+Indicator+","+KPeriod+","+DPeriod+","+Slowing+")");
      if (Indicator == "OSMA")    IndicatorShortName("Multi indic("+Pair+","+Indicator+","+fast+","+slow+","+signal+")");
 
      
      
      
                                                         // D?finition du style buffer
                                                         
                                                         
     
     if (Style == "LIGNE") SetIndexStyle(0,DRAW_LINE);
                           SetIndexBuffer(0,Id)  ;      
     if (Style == "HISTO") SetIndexStyle(0,DRAW_HISTOGRAM);
                           SetIndexBuffer(0,Id);
     if (Style == "POINT") SetIndexStyle(0,DRAW_ARROW);
                           SetIndexArrow(0,Style_point);
                           SetIndexBuffer(0,Id);
                                                     
                                                     //D?finition des zones extr?mes selon les indicateurs
                                                     
   if (Indicator == "CCI")  ext_1[i]     =  100;
   if (Indicator == "CCI")  ext_2[i]     =  -100;
   if (Indicator == "CCI")  ext_3[i]     =  200;
   if (Indicator == "CCI")  ext_4[i]     =  -200;
                            
   if (Indicator == "RSI")  ext_1[i]     =  70;
   if (Indicator == "RSI")  ext_2[i]     =  30;
   
   if (Indicator == "STO")  ext_1[i]     =  20;
   if (Indicator == "STO")  ext_2[i]     =  80;
                            
                                                     
                                                                              
                     
   }
}