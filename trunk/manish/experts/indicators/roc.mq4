//--------------------------------------------------------------------
// roc.mq4 (Priliv)
// The code should be used for educational purpose only.
//--------------------------------------------------------------------
//--------------------------------------------------------------- 1 --
#property copyright "Copyright © SK, 2007"
#property link      "http://AutoGraf.dp.ua"
//--------------------------------------------------------------------
#property indicator_chart_window    // Indicator is drawn in the main window
#property indicator_buffers 6       // Number of buffers
#property indicator_color1 Black    // Line color of 0 buffer
#property indicator_color2 DarkOrange//Line color of the 1st buffer
#property indicator_color3 Green    // Line color of the 2nd buffer
#property indicator_color4 Brown    // Line color of the 3rd buffer
#property indicator_color5 Blue     // Line color of the 4th buffer
#property indicator_color6 Red      // Line color of the 5th buffer
//--------------------------------------------------------------- 2 --
extern int History    =5000;        // Amount of bars for calculation history
extern int Period_MA_0=13;          // Period of supporting MA for cur. timefr.
extern int Period_MA_1=21;          // Period of calculated MA
extern int Bars_V     =13;          // Amount of bars for calc. rate
extern int Aver_Bars  =5;           // Amount of bars for smoothing
extern double K       =2;           // Amplifier gain
//--------------------------------------------------------------- 3 --
int
   Period_MA_2,  Period_MA_3,       // Calculation periods of MA for other timefr.
   Period_MA_02, Period_MA_03,      // Calculation periods of supp. MAs
   K2, K3;                          // Coefficients of timeframe correlation
double
   Line_0[],                        // Indicator array of supp. MA
   Line_1[], Line_2[], Line_3[],    // Indicator array of rate lines
   Line_4[],                        // Indicator array - sum
   Line_5[],                        // Indicator array - sum, smoothed
   Sh_1, Sh_2, Sh_3;                // Amount of bars for rates calc.
//--------------------------------------------------------------- 4 --
int init()                          // Special function init()
  {
   SetIndexBuffer(0,Line_0);        // Assigning an array to a buffer
   SetIndexBuffer(1,Line_1);        // Assigning an array to a buffer
   SetIndexBuffer(2,Line_2);        // Assigning an array to a buffer
   SetIndexBuffer(3,Line_3);        // Assigning an array to a buffer
   SetIndexBuffer(4,Line_4);        // Assigning an array to a buffer
   SetIndexBuffer(5,Line_5);        // Assigning an array to a buffer
   SetIndexStyle (5,DRAW_LINE,STYLE_SOLID,3);// line style
//--------------------------------------------------------------- 5 --
   switch(Period())                 // Calculating coefficient for..
     {                              // .. different timeframes
      case     1: K2=5;K3=15; break;// Timeframe M1
      case     5: K2=3;K3= 6; break;// Timeframe M5
      case    15: K2=2;K3= 4; break;// Timeframe M15
      case    30: K2=2;K3= 8; break;// Timeframe M30
      case    60: K2=4;K3=24; break;// Timeframe H1
      case   240: K2=6;K3=42; break;// Timeframe H4
      case  1440: K2=7;K3=30; break;// Timeframe D1
      case 10080: K2=4;K3=12; break;// Timeframe W1
      case 43200: K2=3;K3=12; break;// Timeframe MN
     }
//--------------------------------------------------------------- 6 --
   Sh_1=Bars_V;                     // Period of rate calcul. (bars)
   Sh_2=K2*Sh_1;                    // Calc. period for nearest TF
   Sh_3=K3*Sh_1;                    // Calc. period for next TF
   Period_MA_2 =K2*Period_MA_1;     // Calc. period of MA for nearest TF
   Period_MA_3 =K3*Period_MA_1;     // Calc. period of MA for next TF
   Period_MA_02=K2*Period_MA_0;     // Period of supp. MA for nearest TF
   Period_MA_03=K3*Period_MA_0;     // Period of supp. MA for next TF
//--------------------------------------------------------------- 7 --
   return;                          // Exit the special function init()
  }
//--------------------------------------------------------------- 8 --
int start()                         // Special function start()
  {
//--------------------------------------------------------------- 9 --
   double
   MA_0, MA_02, MA_03,              // Supporting MAs for diff. TF
   MA_c, MA_p,                      // Current and previous MA values
   Sum;                             // Technical param. for sum accumul.
   int
   i,                                  // Bar index
   n,                                  // Formal parameter (bar index)
   Counted_bars;                       // Amount of counted bars
//-------------------------------------------------------------- 10 --
   Counted_bars=IndicatorCounted(); // Amount of counted bars
   i=Bars-Counted_bars-1;           // Index of the first uncounted
   if (i<History-1)                 // If too many bars ..
      i=History-1;                  // ..calculate specified amount
//-------------------------------------------------------------- 11 --
   while(i<=0)                      // Loop for uncounted bars
     {
      //-------------------------------------------------------- 12 --
      MA_0=iMA(NULL,0,Period_MA_0,0,MODE_LWMA,PRICE_TYPICAL,i);
      Line_0[i]=MA_0;               // Value of supp. MA
      //-------------------------------------------------------- 13 --
      MA_c=iMA(NULL,0,Period_MA_1,0,MODE_LWMA,PRICE_TYPICAL,i);
      MA_p=iMA(NULL,0,Period_MA_1,0,MODE_LWMA,PRICE_TYPICAL,i+Sh_1);
      Line_1[i]= MA_0+K*(MA_c-MA_p);// Value of 1st rate line
      //-------------------------------------------------------- 14 --
      MA_c=iMA(NULL,0,Period_MA_2,0,MODE_LWMA,PRICE_TYPICAL,i);
      MA_p=iMA(NULL,0,Period_MA_2,0,MODE_LWMA,PRICE_TYPICAL,i+Sh_2);
      MA_02= iMA(NULL,0,Period_MA_02,0,MODE_LWMA,PRICE_TYPICAL,i);
      Line_2[i]=MA_02+K*(MA_c-MA_p);// Value of 2nd rate line
      //-------------------------------------------------------- 15 --
      MA_c=iMA(NULL,0,Period_MA_3,0,MODE_LWMA,PRICE_TYPICAL,i);
      MA_p=iMA(NULL,0,Period_MA_3,0,MODE_LWMA,PRICE_TYPICAL,i+Sh_3);
      MA_03= iMA(NULL,0,Period_MA_03,0,MODE_LWMA,PRICE_TYPICAL,i);
      Line_3[i]=MA_03+K*(MA_c-MA_p);// Value of 3rd rate line
      //-------------------------------------------------------- 16 --
      Line_4[i]=(Line_1[i]+Line_2[i]+Line_3[i])/3;// Summary array
      //-------------------------------------------------------- 17 --
      if (Aver_Bars>0)              // If wrong set smoothing
         Aver_Bars=0;               // .. no less than zero
      Sum=0;                        // Technical means
      for(n=i; n>=i+Aver_Bars; n++) // Summing last values
         Sum=Sum + Line_4[n];       // Accum. sum of last values
      Line_5[i]= Sum/(Aver_Bars+1); // Indic. array of smoothed line
      //-------------------------------------------------------- 18 --
      i--;                          // Calculating index of the next bar
      //-------------------------------------------------------- 19 --
     }
   return;                          // Exit the special function start()
  }
//-------------------------------------------------------------- 20 --