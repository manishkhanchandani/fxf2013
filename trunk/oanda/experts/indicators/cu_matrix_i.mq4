//+------------------------------------------------------------------+
//|                                                  cu_matrix_i.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window


//----------Variables for displaying values of flags----------
datetime timeident; //Current time for creation of unique names of "text" objects
int i; //For a loop
string ident; //Unique names of "text" objects 
string info;
int f[50]; //Array of 50 elements (for prospect, up to 50 indicators)
string fs[50];
//----------Variables of technical indicators----------

//1. Acceleration/Deceleration � AC
extern int piac=0; //Indicator period

//2. Accumulation/Distribution - A/D
extern int piad=0; //Indicator period
extern int piad2=0; //Price period

//3. Alligator & Fractals
extern int piall=0; //Indicator period
extern int piall2=0; //Price period
extern int pifr=0; //Period of fractals

extern int jaw_period=13;
extern int jaw_shift=8;
extern int teeth_period=8;
extern int teeth_shift=5;
extern int lips_period=5;
extern int lips_shift=3;

//4. Gator Oscillator
// Part of variables from "3. Alligator & Fractals" is used
extern int piga=0; //Indicator period

//5. Average Directional Movement Index - ADX
extern int piadx=0; //Indicator period
extern int piadu=14; //Period of averaging for index calculation
extern double minadx=20; //Minimal threshold value of ADX

//6. Average True Range - ATR
extern int piatr=0; //Indicator period
extern int piatru=14; //Period of averaging for indicator calculation
extern double minatr=0.0002; //Minimal threshold value of ATR

//7. Awesome Oscillator
extern int piao=0; //Indicator period

//8. Bears Power
extern int pibear=0; //Indicator period
extern int pibearu=13; //Period of averaging for indicator calculation

//9. Bollinger Bands
extern int piband=0; //Indicator period
extern int pibandu=20; //Period of averaging for indicator calculation
extern int ibandotkl=2; //Deviation from the main line
extern int piband2=0; //Price period

//10. Bulls Power
extern int pibull=0; //Indicator period
extern int pibullu=13; //Period of averaging for indicator calculation

//11. Commodity Channel Index
extern int picci=0; //Indicator period
extern int picciu=14; //Period of averaging for indicator calculation

//12. DeMarker
extern int pidem=0; //Indicator period
extern int pidemu=14; //Period of averaging for indicator calculation

//13. Envelopes
extern int pienv=0; //Indicator period
extern int pienvu=14; //Period of averaging for indicator calculation
extern int ienvshift=0; //Indicator shift relative to a chart 
extern double ienvotkl=0.07; //Deviation from the main line in percent
extern int pienv2=0; //Price period

//14. Force Index
extern int piforce=0; //Indicator period
extern int piforceu=2; //Period of averaging for indicator calculation

//15,16,17. Ichimoku Kinko Hyo
extern int pich=0; //Indicator period
extern int ptenkan=9; //Tenkan-Sen Period
extern int pkijun=26; //Kijun-Sen Period
extern int psenkou=52; //Senkou Span B Period
extern int pich2=0; //Price period

//18. Money Flow Index - MFI
extern int pimfi=0; //Indicator period
extern int barsimfi=14; //Period (amount of bars) for indicator calculation

//19. Moving Average
extern int pima=0; //Indicator period
extern int pimau=14; //Period of averaging for indicator calculation

//20,21,22,23. MACD and Moving Average of Oscillator (histogram MACD)
extern int pimacd=0; //Indicator period
extern int fastpimacd=12; //Averaging period for calculation of a quick MA
extern int slowpimacd=26; //Averaging period for calculation of a slow MA
extern int signalpimacd=9; //Averaging period for calculation of a signal line

//24. Parabolic SAR
extern int pisar=0; //Indicator period
extern double isarstep=0.02; //Stop level increment
extern double isarstop=0.2; //Maximal stop level
extern int pisar2=0; //Price period

//25. RSI
extern int pirsi=0; //Indicator period
extern int pirsiu=14; //Period of averaging for indicator calculation
 
//26. RVI
extern int pirvi=0; //Indicator period
extern int pirviu=10; //Period of averaging for indicator calculation

//27. Standard Deviation
extern int pistd=0; //Indicator period
extern int pistdu=20; //Period of averaging for indicator calculation

//28, 29. Stochastic Oscillator
extern int pisto=0; //Indicator period
extern int pistok=5; //Period(amount of bars) for the calculation of %K line
extern int pistod=3; //Averaging period for the calculation of %D line
extern int istslow=3; //Value of slowdown

//30. Williams Percent Range
extern int piwpr=0; //Indicator period
extern int piwprbar=14; //Period (amount of bars) for indicator calculation
int f5=0; //5. Average Directional Movement Index - ADX
int f19=0; //19. Moving Average
int f26=0; //26. RVI
int f29=0; //29. Stochastic Oscillator (2)

extern bool VoiceAlert = true;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
Comment("");
ObjectsDeleteAll();
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
Comment("");
ObjectsDeleteAll();             
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int limit, counter;
   double Range, AvgRange;
   int    counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;

   limit=Bars-counted_bars;
   for(i = 500; i >= 1; i--) {counter=i;
      run(i);
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

int run(int shift)
{
   int num = shift;
   int num1 = shift + 1;
   int num2 = shift + 2;
   int num3 = shift + 3;
   int num4 = shift + 4;
//----------Variables of flag significant pointwise----------
//These flags can turn into zero
int f1=0; //1. Acceleration/Deceleration � AC
fs[1] = "1. Acceleration/Deceleration � AC";
int f2=0; //2. Accumulation/Distribution - A/D
fs[2] = "2. Accumulation/Distribution - A/D";
int f3=0; //3. Alligator & Fractals
fs[3] = "3. Alligator & Fractals";
int f4=0; //4. Gator Oscillator
fs[4] = "4. Gator Oscillator";
int f6=0; //6. Average True Range - ATR
fs[6] = "6. Average True Range - ATR";
int f7=0; //7. Awesome Oscillator
fs[7] = "7. Awesome Oscillator";
int f8=0; //8. Bears Power
fs[8] = "8. Bears Power";
int f9=0; //9. Bollinger Bands
fs[9] = "9. Bollinger Bands";
int f10=0; //10. Bulls Power
fs[10] = "10. Bulls Power";
int f11=0; //11. Commodity Channel Index
fs[11] = "11. Commodity Channel Index";
int f12=0; //12. DeMarker
fs[12] = "12. DeMarker";
int f13=0; //13. Envelopes
fs[13] = "13. Envelopes";
int f14=0; //14. Force Index
fs[14] = "14. Force Index";
int f15=0; //15. Ichimoku Kinko Hyo (1)
fs[15] = "15. Ichimoku Kinko Hyo (1)";
int f16=0; //16. Ichimoku Kinko Hyo (2)
fs[16] = "16. Ichimoku Kinko Hyo (2)";
int f17=0; //17. Ichimoku Kinko Hyo (3)
fs[17] = "17. Ichimoku Kinko Hyo (3)";
int f18=0; //18. Money Flow Index - MFI
fs[18] = "18. Money Flow Index - MFI";
int f20=0; //20. MACD (1)
fs[20] = "20. MACD (1)";
int f21=0; //21. MACD (2)
fs[21] = "21. MACD (2)";
int f22=0; //22. Moving Average of Oscillator (MACD histogram) (1)
fs[22] = "22. Moving Average of Oscillator (MACD histogram) (1)";
int f23=0; //23. Moving Average of Oscillator (MACD histogram) (2)
fs[23] = "23. Moving Average of Oscillator (MACD histogram) (2)";
int f24=0; //24. Parabolic SAR
fs[24] = "24. Parabolic SAR";
int f25=0; //25. RSI
fs[25] = "25. RSI";
int f27=0; //27. Standard Deviation
fs[27] = "27. Standard Deviation";
int f28=0; //28. Stochastic Oscillator (1)
fs[28] = "28. Stochastic Oscillator (1)";
int f30=0; //30. Williams Percent Range
fs[30] = "30. Williams Percent Range";

fs[5] = "5. Average Directional Movement Index - ADX";
fs[19] = "19. Moving Average";
fs[26] = "26. RVI";
fs[29] = "29. Stochastic Oscillator (2)";


//----
int err=0; //Checking errors
int order=0;
int flag=0; //The main flag of the strategic block

   
//----------Strategic block----------//

//1. Acceleration/Deceleration � AC
//Buy: if the indicator is above zero and 2 consecutive columns are green or if the indicator is below zero and 3 consecutive columns are green
//Sell: if the indicator is below zero and 2 consecutive columns are red or if the indicator is above zero and 3 consecutive columns are red
if ((iAC(NULL,piac,num)>=0&&iAC(NULL,piac,num)>iAC(NULL,piac,num1)&&iAC(NULL,piac,num1)>iAC(NULL,piac,num2))||(iAC(NULL,piac,num)<=0&&iAC(NULL,piac,num)>iAC(NULL,piac,num1)&&iAC(NULL,piac,num1)>iAC(NULL,piac,num2)&&iAC(NULL,piac,num2)>iAC(NULL,piac,num3)))
{f1=1;}
if ((iAC(NULL,piac,num)<=0&&iAC(NULL,piac,num)<iAC(NULL,piac,num1)&&iAC(NULL,piac,num1)<iAC(NULL,piac,num2))||(iAC(NULL,piac,num)>=0&&iAC(NULL,piac,num)<iAC(NULL,piac,num1)&&iAC(NULL,piac,num1)<iAC(NULL,piac,num2)&&iAC(NULL,piac,num2)<iAC(NULL,piac,num3)))
{f1=-1;}


//2. Accumulation/Distribution - A/D
//Main principle - convergence/divergence
//Buy: indicator growth at downtrend
//Sell: indicator fall at uptrend
if (iAD(NULL,piad,num)>=iAD(NULL,piad,num1)&&iClose(NULL,piad2,num)<=iClose(NULL,piad2,num1))
{f2=1;}
if (iAD(NULL,piad,num)<=iAD(NULL,piad,num1)&&iClose(NULL,piad2,num)>=iClose(NULL,piad2,num1))
{f2=-1;}

//3. Alligator & Fractals
//Buy: all 3 Alligator lines grow/ don't fall/ (3 periods in succession) and fractal (upper line) is above teeth
//Sell: all 3 Alligator lines fall/don't grow/ (3 periods in succession) and fractal (lower line) is below teeth
//Fracal shift=2 because of the indicator nature
if (iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORLIPS,num2)<=iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORLIPS,num1)&&iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORLIPS,num1)<=iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORLIPS,num)&&iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORJAW,num2)<=iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORJAW,num1)&&iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORJAW,num1)<=iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORJAW,num)&&iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORTEETH,num2)<=iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORTEETH,num1)&&iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORTEETH,num1)<=iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORTEETH,num)&&iFractals(NULL,pifr,MODE_UPPER,num2)>=iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORTEETH,num))
{f3=1;}
if (iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORLIPS,num2)>=iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORLIPS,num1)&&iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORLIPS,num1)>=iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORLIPS,num)&&iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORJAW,num2)>=iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORJAW,num1)&&iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORJAW,num1)>=iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORJAW,num)&&iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORTEETH,num2)>=iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORTEETH,num1)&&iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORTEETH,num1)>=iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORTEETH,num)&&iFractals(NULL,pifr,MODE_LOWER,num2)<=iAlligator(NULL,piall,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORTEETH,num))
{f3=-1;}

//4. Gator Oscillator
//Doesn't give independent signals. Is used for Alligator correction.
//Principle: trend must be strengthened. Together with this Gator Oscillator goes up.
//Lower part of diagram is taken for calculations. Growth is checked on 4 periods.
//The flag is 1 of trend is strengthened, 0 - no strengthening, -1 - never.
//Uses part of Alligator's variables
if (iGator(NULL,piga,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_LOWER,num3)>iGator(NULL,piga,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_LOWER,num2)&&iGator(NULL,piga,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_LOWER,num2)>iGator(NULL,piga,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_LOWER,num1)&&iGator(NULL,piga,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_LOWER,num1)>iGator(NULL,piga,jaw_period,jaw_shift,teeth_period,teeth_shift,lips_period,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_LOWER,num))
{f4=1;}

//Joining flags 3 and 4
if (f3==1&&f4==1)
{f4=1;}
if (f3==-1&&f4==1)
{f4=-1;}
f3=0; //Flag 3 is not used any more


//5. Average Directional Movement Index - ADX
//Buy: +DI line is above -DI line, ADX is more than a certain value and grows (i.e. trend strengthens)
//Sell: -DI line is above +DI line, ADX is more than a certain value and grows (i.e. trend strengthens)
if (iADX(NULL,piadx,piadu,PRICE_CLOSE,MODE_MINUSDI,num)<iADX(NULL,piadx,piadu,PRICE_CLOSE,MODE_PLUSDI,num)&&iADX(NULL,piadx,piadu,PRICE_CLOSE,MODE_MAIN,num)>=minadx&&iADX(NULL,piadx,piadu,PRICE_CLOSE,MODE_MAIN,num)>iADX(NULL,piadx,piadu,PRICE_CLOSE,MODE_MAIN,num1))
{f5=1;}
if (iADX(NULL,piadx,piadu,PRICE_CLOSE,MODE_MINUSDI,num)>iADX(NULL,piadx,piadu,PRICE_CLOSE,MODE_PLUSDI,num)&&iADX(NULL,piadx,piadu,PRICE_CLOSE,MODE_MAIN,num)>=minadx&&iADX(NULL,piadx,piadu,PRICE_CLOSE,MODE_MAIN,num)>iADX(NULL,piadx,piadu,PRICE_CLOSE,MODE_MAIN,num1))
{f5=-1;}

//6. Average True Range - ATR
//Doesn't give independent signals. Is used to define volatility (trend strength).
//principle: trend must be strengthened. Together with that ATR grows.
//Because of the chart form it is inconvenient to analyze rise/fall. Only exceeding of threshold value is checked.
//Flag is 1 when ATR is above threshold value (i.e. there is a trend), 0 - when ATR is below threshold value, -1 - never.
if (iATR(NULL,piatr,piatru,num)>=minatr)
{f6=1;}

//7. Awesome Oscillator
//Buy: 1. Signal "saucer" (3 positive columns, medium column is smaller than 2 others); 2. Changing from negative values to positive.
//Sell: 1. Signal "saucer" (3 negative columns, medium column is larger than 2 others); 2. Changing from positive values to negative.
if ((iAO(NULL,piao,num2)>0&&iAO(NULL,piao,num1)>0&&iAO(NULL,piao,num)>0&&iAO(NULL,piao,num1)<iAO(NULL,piao,num2)&&iAO(NULL,piao,num1)<iAO(NULL,piao,num))||(iAO(NULL,piao,num1)<0&&iAO(NULL,piao,num)>num))
{f7=1;}
if ((iAO(NULL,piao,num2)<0&&iAO(NULL,piao,num1)<0&&iAO(NULL,piao,num)<0&&iAO(NULL,piao,num1)>iAO(NULL,piao,num2)&&iAO(NULL,piao,num1)>iAO(NULL,piao,num))||(iAO(NULL,piao,num1)>0&&iAO(NULL,piao,num)<num))
{f7=-1;}

//8. Bears Power
//Is used only together with a trend indicator. Gives only Buy signals.
//Flag is 1, if the indicator is negative and grows, 0 - in all other cases, -1 - never.
if (iBearsPower(NULL,pibear,pibearu,PRICE_CLOSE,num2)<0&&iBearsPower(NULL,pibear,pibearu,PRICE_CLOSE,num1)<0&&iBearsPower(NULL,pibear,pibearu,PRICE_CLOSE,num)<0&&iBearsPower(NULL,pibear,pibearu,PRICE_CLOSE,num2)<iBearsPower(NULL,pibear,pibearu,PRICE_CLOSE,num1)&&iBearsPower(NULL,pibear,pibearu,PRICE_CLOSE,num1)<iBearsPower(NULL,pibear,pibearu,PRICE_CLOSE,num))
{f8=1;}

//9. Bollinger Bands
//Buy: price crossed lower line upwards (returned to it from below)
//Sell: price crossed upper line downwards (returned to it from above)
if (iBands(NULL,piband,pibandu,ibandotkl,0,PRICE_CLOSE,MODE_LOWER,num1)>iClose(NULL,piband2,num1)&&iBands(NULL,piband,pibandu,ibandotkl,0,PRICE_CLOSE,MODE_LOWER,num)<=iClose(NULL,piband2,num))
{f9=1;}
if (iBands(NULL,piband,pibandu,ibandotkl,0,PRICE_CLOSE,MODE_UPPER,num1)<iClose(NULL,piband2,num1)&&iBands(NULL,piband,pibandu,ibandotkl,0,PRICE_CLOSE,MODE_UPPER,num)>=iClose(NULL,piband2,num))
{f9=-1;}

//10. Bulls Power
//Is used only together with a trend indicator. Gives only Sell signals.
//Flag is -1, if the indicator is positive and falls, 0 - in all other cases, 1 - never.
if (iBullsPower(NULL,pibull,pibullu,PRICE_CLOSE,num2)>0&&iBullsPower(NULL,pibull,pibullu,PRICE_CLOSE,num1)>0&&iBullsPower(NULL,pibull,pibullu,PRICE_CLOSE,num)>0&&iBullsPower(NULL,pibull,pibullu,PRICE_CLOSE,num2)>iBullsPower(NULL,pibull,pibullu,PRICE_CLOSE,num1)&&iBullsPower(NULL,pibull,pibullu,PRICE_CLOSE,num1)>iBullsPower(NULL,pibull,pibullu,PRICE_CLOSE,num))
{f10=-1;}
f10=0; //Now we don't use

//11. Commodity Channel Index
//Buy: 1. indicator crosses +100 from below upwards. 2. Crossing -100 from below upwards. 3.
//Sell: 1. indicator crosses -100 from above downwards. 2. Crossing +100 downwards. 3.
if ((iCCI(NULL,picci,picciu,PRICE_TYPICAL,num1)<100&&iCCI(NULL,picci,picciu,PRICE_TYPICAL,num)>=100)||(iCCI(NULL,picci,picciu,PRICE_TYPICAL,num1)<-100&&iCCI(NULL,picci,picciu,PRICE_TYPICAL,num)>=-100))
{f11=1;}
if ((iCCI(NULL,picci,picciu,PRICE_TYPICAL,num1)>-100&&iCCI(NULL,picci,picciu,PRICE_TYPICAL,num)<=-100)||(iCCI(NULL,picci,picciu,PRICE_TYPICAL,num1)>100&&iCCI(NULL,picci,picciu,PRICE_TYPICAL,num)<=100))
{f11=-1;}

//12. DeMarker
//Buy: 1. Crossing 0.3 level bottom-up.
//Sell: 1. Crossing 0.7 level downwards.
if(iDeMarker(NULL,pidem,pidemu,num1)<0.3&&iDeMarker(NULL,pidem,pidemu,num)>=0.3)
{f12=1;}
if(iDeMarker(NULL,pidem,pidemu,num1)>0.7&&iDeMarker(NULL,pidem,pidemu,num)<=0.7)
{f12=-1;}

//13. Envelopes
//Buy: price crossed lower line upwards (returned to it from below)
//Sell: price crossed upper line downwards (returned to it from above)
if(iEnvelopes(NULL,pienv,pienvu,MODE_SMA,ienvshift,PRICE_CLOSE,ienvotkl,MODE_LOWER,num1)>iClose(NULL,pienv2,num1)&&iEnvelopes(NULL,pienv,pienvu,MODE_SMA,ienvshift,PRICE_CLOSE,ienvotkl,MODE_LOWER,num)<=iClose(NULL,pienv2,num))
{f13=1;}
if(iEnvelopes(NULL,pienv,pienvu,MODE_SMA,ienvshift,PRICE_CLOSE,ienvotkl,MODE_UPPER,num1)<iClose(NULL,pienv2,num1)&&iEnvelopes(NULL,pienv,pienvu,MODE_SMA,ienvshift,PRICE_CLOSE,ienvotkl,MODE_UPPER,num)>=iClose(NULL,pienv2,num))
{f13=-1;}

//14. Force Index
//To use the indicator it should be correlated with another trend indicator
//Flag 14 is 1, when FI recommends to buy (i.e. FI<0)
//Flag 14 is -1, when FI recommends to sell (i.e. FI>0)
if (iForce(NULL,piforce,piforceu,MODE_SMA,PRICE_CLOSE,num)<0)
{f14=1;}
if (iForce(NULL,piforce,piforceu,MODE_SMA,PRICE_CLOSE,num)>0)
{f14=-1;}

//15. Ichimoku Kinko Hyo (1)
//Buy: Price crosses Senkou Span-B upwards; price is outside Senkou Span cloud
//Sell: Price crosses Senkou Span-B downwards; price is outside Senkou Span cloud
if (iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,num1)>iClose(NULL,pich2,num1)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,num)<=iClose(NULL,pich2,num)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANA,num)<iClose(NULL,pich2,num))
{f15=1;}
if (iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,num1)<iClose(NULL,pich2,num1)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,num)>=iClose(NULL,pich2,num)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANA,num)>iClose(NULL,pich2,num))
{f15=-1;}

//16. Ichimoku Kinko Hyo (2)
//Buy: Tenkan-sen crosses Kijun-sen upwards
//Sell: Tenkan-sen crosses Kijun-sen downwards
//VERSION EXISTS, IN THIS CASE PRICE MUSTN'T BE IN THE CLOUD!
if (iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_TENKANSEN,num1)<iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_KIJUNSEN,num1)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_TENKANSEN,num)>=iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_KIJUNSEN,num))
{f16=1;}
if (iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_TENKANSEN,num1)>iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_KIJUNSEN,num1)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_TENKANSEN,num)<=iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_KIJUNSEN,num))
{f16=-1;}

//17. Ichimoku Kinko Hyo (3)
//Buy: Chinkou Span crosses chart upwards; price is ib the cloud
//Sell: Chinkou Span crosses chart downwards; price is ib the cloud
if ((iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_CHINKOUSPAN,pkijun+num1)<iClose(NULL,pich2,pkijun+num1)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_CHINKOUSPAN,pkijun+num)>=iClose(NULL,pich2,pkijun+num))&&((iClose(NULL,pich2,num)>iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANA,num)&&iClose(NULL,pich2,num)<iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,num))||(iClose(NULL,pich2,num)<iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANA,num)&&iClose(NULL,pich2,num)>iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,num))))
{f17=1;}
if ((iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_CHINKOUSPAN,pkijun+num1)>iClose(NULL,pich2,pkijun+num1)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_CHINKOUSPAN,pkijun+num)<=iClose(NULL,pich2,pkijun+num))&&((iClose(NULL,pich2,num)>iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANA,num)&&iClose(NULL,pich2,num)<iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,num))||(iClose(NULL,pich2,num)<iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANA,num)&&iClose(NULL,pich2,num)>iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,num))))
{f17=-1;}

//18. Money Flow Index - MFI
//Buy: Crossing 20 upwards
//Sell: Crossing 20 downwards
if(iMFI(NULL,pimfi,barsimfi,num1)<20&&iMFI(NULL,pimfi,barsimfi,num)>=20)
{f18=1;}
if(iMFI(NULL,pimfi,barsimfi,num1)>80&&iMFI(NULL,pimfi,barsimfi,num)<=80)
{f18=-1;}

//19. Moving Average
//Buy: MA grows
//Sell: MA falls
if (iMA(NULL,pima,pimau,0,MODE_EMA,PRICE_CLOSE,num2)<iMA(NULL,pima,pimau,0,MODE_EMA,PRICE_CLOSE,num1)&&iMA(NULL,pima,pimau,0,MODE_EMA,PRICE_CLOSE,num1)<iMA(NULL,pima,pimau,0,MODE_EMA,PRICE_CLOSE,num))
{f19=1;}
if (iMA(NULL,pima,pimau,0,MODE_EMA,PRICE_CLOSE,num2)>iMA(NULL,pima,pimau,0,MODE_EMA,PRICE_CLOSE,num1)&&iMA(NULL,pima,pimau,0,MODE_EMA,PRICE_CLOSE,num1)>iMA(NULL,pima,pimau,0,MODE_EMA,PRICE_CLOSE,num))
{f19=-1;}

//20. MACD (1)
//VERSION EXISTS, THAT THE SIGNAL TO BUY IS TRUE ONLY IF MACD<0, SIGNAL TO SELL - IF MACD>0
//Buy: MACD rises above the signal line
//Sell: MACD falls below the signal line
if(iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,MODE_MAIN,num1)<iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,MODE_SIGNAL,num1)&&iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,MODE_MAIN,num)>=iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,MODE_SIGNAL,num))
{f20=1;}
if(iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,MODE_MAIN,num1)>iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,MODE_SIGNAL,num1)&&iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,MODE_MAIN,num)<=iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,MODE_SIGNAL,num))
{f20=-1;}

//21. MACD (2)
//Buy: crossing 0 upwards
//Sell: crossing 0 downwards
if(iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,MODE_MAIN,num1)<0&&iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,MODE_MAIN,num)>=0)
{f21=1;}
if(iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,MODE_MAIN,num1)>0&&iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,MODE_MAIN,num)<=0)
{f21=-1;}


//22. Moving Average of Oscillator (MACD histogram) (1)
//Buy: histogram is below zero and changes falling direction into rising (5 columns are taken)
//Sell: histogram is above zero and changes its rising direction into falling (5 columns are taken)
if(iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num4)<0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num3)<0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num2)<0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num1)<0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num)<0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num4)>=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num3)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num3)>=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num2)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num2)<=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num1)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num1)<=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num))
{f22=1;}
if(iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num4)>0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num3)>0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num2)>0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num1)>0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num)>0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num4)<=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num3)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num3)<=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num2)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num2)>=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num1)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num1)>=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num))
{f22=-1;}

//23. Moving Average of Oscillator (MACD histogram) (2)
//To use the indicator it should be correlated with another trend indicator 
//Flag 23 is 1, when MACD histogram recommends to buy (i.e. histogram is sloping upwards)
//Flag 23 is -1, when MACD histogram recommends to sell (i.e. histogram is sloping downwards)
//3 columns are taken for calculation
if(iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num2)<=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num1)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num1)<=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num))
{f23=1;}
if(iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num2)>=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num1)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num1)>=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,num))
{f23=-1;}

//24. Parabolic SAR
//Buy: Parabolic SAR crosses price downwards
//Sell: Parabolic SAR crosses price upwards
if(iSAR(NULL,pisar,isarstep,isarstop,num1)>iClose(NULL,pisar2,num1)&&iSAR(NULL,pisar,isarstep,isarstop,num)<=iClose(NULL,pisar2,num))
{f24=1;}
if(iSAR(NULL,pisar,isarstep,isarstop,num1)<iClose(NULL,pisar2,num1)&&iSAR(NULL,pisar,isarstep,isarstop,num)>=iClose(NULL,pisar2,num))
{f24=-1;}

//25. RSI
//Buy: crossing 30 upwards
//Sell: crossing 70 downwards
//TO FIGHT FALSE SIGNALS RECOMMENDED TO USE 2 PEAKS...
if(iRSI(NULL,pirsi,pirsiu,PRICE_CLOSE,num1)<30&&iRSI(NULL,pirsi,pirsiu,PRICE_CLOSE,num)>=30)
{f25=1;}
if(iRSI(NULL,pirsi,pirsiu,PRICE_CLOSE,num1)>70&&iRSI(NULL,pirsi,pirsiu,PRICE_CLOSE,num)<=70)
{f25=-1;}

//26. RVI
//RECOMMENDED TO USE WITH A TREND INDICATOR 
//Buy: main line (green) crosses signal (red) upwards
//Sell: main line (green) crosses signal (red) downwards
if(iRVI(NULL,pirvi,pirviu,MODE_MAIN,num1)<iRVI(NULL,pirvi,pirviu,MODE_SIGNAL,num1)&&iRVI(NULL,pirvi,pirviu,MODE_MAIN,num)>=iRVI(NULL,pirvi,pirviu,MODE_SIGNAL,num))
{f26=1;}
if(iRVI(NULL,pirvi,pirviu,MODE_MAIN,num1)>iRVI(NULL,pirvi,pirviu,MODE_SIGNAL,num1)&&iRVI(NULL,pirvi,pirviu,MODE_MAIN,num)<=iRVI(NULL,pirvi,pirviu,MODE_SIGNAL,num))
{f26=-1;}

//27. Standard Deviation
//Doesn't give independent signals. Is used to define volatility (trend strength).
//Principle: the trend must be strengthened. Together with this Standard Deviation goes up.
//Growth on 3 consecutive bars is analyzed
//Flag is 1 when Standard Deviation rises, 0 - when no growth, -1 - never.
if (iStdDev(NULL,pistd,pistdu,0,MODE_SMA,PRICE_CLOSE,num2)<=iStdDev(NULL,pistd,pistdu,0,MODE_SMA,PRICE_CLOSE,num1)&&iStdDev(NULL,pistd,pistdu,0,MODE_SMA,PRICE_CLOSE,num1)<=iStdDev(NULL,pistd,pistdu,0,MODE_SMA,PRICE_CLOSE,num))
{f27=1;}

//28. Stochastic Oscillator (1)
//Buy: main lline rises above 20 after it fell below this point
//Sell: main line falls lower than 80 after it rose above this point
if(iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,MODE_MAIN,num1)<20&&iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,MODE_MAIN,num)>=20)
{f28=1;}
if(iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,MODE_MAIN,num1)>80&&iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,MODE_MAIN,num)<=80)
{f28=-1;}

//29. Stochastic Oscillator (2)
//Buy: main line goes above the signal line
//Sell: signal line goes above the main line
if(iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,MODE_MAIN,num1)<iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,MODE_SIGNAL,num1)&&iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,MODE_MAIN,num)>=iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,MODE_SIGNAL,num))
{f29=1;}
if(iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,MODE_MAIN,num1)>iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,MODE_SIGNAL,num1)&&iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,MODE_MAIN,num)<=iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,MODE_SIGNAL,num))
{f29=-1;}


//30. Williams Percent Range
//Buy: crossing -80 upwards
//Sell: crossing -20 downwards
if (iWPR(NULL,piwpr,piwprbar,num1)<-80&&iWPR(NULL,piwpr,piwprbar,num)>=-80)
{f30=1;}
if (iWPR(NULL,piwpr,piwprbar,num1)>-20&&iWPR(NULL,piwpr,piwprbar,num)<=-20)
{f30=-1;}

//----------End of strateguc block----------//

//----------Block of flag values diaplying----------
f[1]=f1;
f[2]=f2;
f[3]=f3;
f[4]=f4;
f[5]=f5;
f[6]=f6;
f[7]=f7;
f[8]=f8;
f[9]=f9;
f[10]=f10;
f[11]=f11;
f[12]=f12;
f[13]=f13;
f[14]=f14;
f[15]=f15;
f[16]=f16;
f[17]=f17;
f[18]=f18;
f[19]=f19;
f[20]=f20;
f[21]=f21;
f[22]=f22;
f[23]=f23;
f[24]=f24;
f[25]=f25;
f[26]=f26;
f[27]=f27;
f[28]=f28;
f[29]=f29;
f[30]=f30;



string infobox = "";
string name;
string mes;
double diff;
string name_var;
int x,y;
x = 1;
y = 1;
   for (int j=1;j<=30;j++) //Loop of values displaying

   //Forming unique object names
   {
if (num == 1) {
      infobox = StringConcatenate(infobox, "f", j, ": ", f[j], ", ", fs[j], "\n");
}
      name = "f_" + j + "_" + num;
      mes = j + ": " + f[j];
      /*if (f[j] > 0) {
         
         if (Period() == PERIOD_M1) diff = (x * 5 * Point);
         if (Period() == PERIOD_M5) diff = (x * 10 * Point);
         if (Period() == PERIOD_M15) diff = (x * 15 * Point);
         if (Period() == PERIOD_M30) diff = (x * 20 * Point);
         if (Period() == PERIOD_H1) diff = (x * 25 * Point);
         if (Period() == PERIOD_H4) diff = (x * 30 * Point);
         x++;
         createobj(name, OBJ_TEXT, num, Low[num] - diff, mes);
      }
      else if (f[j] < 0) {
         if (Period() == PERIOD_M1) diff = (y * 5 * Point);
         if (Period() == PERIOD_M5) diff = (y * 10 * Point);
         if (Period() == PERIOD_M15) diff = (y * 15 * Point);
         if (Period() == PERIOD_M30) diff = (y * 20 * Point);
         if (Period() == PERIOD_H1) diff = (y * 25 * Point);
         if (Period() == PERIOD_H4) diff = (y * 30 * Point);
         y++;
         createobj(name, OBJ_TEXT, num, High[num] + diff, mes);
      }*/
   }
Comment(infobox);
}

void createobj(string name, int type, int shift, double price, string message)
{
   if (ObjectCreate(name, type, 0, Time[shift], price)) {
      if (type == OBJ_TEXT)
         ObjectSetText(name, message, 8, "Arial", Blue);
   } else {
      Print("error: can't create text_object! code #",GetLastError());
      return(0);

   
   }

}