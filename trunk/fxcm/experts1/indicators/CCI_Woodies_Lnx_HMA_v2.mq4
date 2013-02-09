//+------------------------------------------------------------------+
//|                                          HMA with WoodiesCCI.mq4 |
//|                     Based on the code of WoodiesCCI.mq4 by thorr |
//|                                          Made by request of Igor |
//|                                                                  |
//| Linuxser 2007                                                    |
//| for any doubts or suggestions contact me on Forex-TSD forum      |
//| http://www.linuxser.com.ar                                       |
//+------------------------------------------------------------------+
#property copyright "Under The GNU General Public License"
#property link      "www.gnu.org"

#property indicator_separate_window
#property indicator_buffers 7
#property indicator_color1 Green
#property indicator_color2 Red
#property indicator_color3 Green
#property indicator_color4 Aqua
#property indicator_color5 Yellow
#property indicator_color6 Orange
#property indicator_color7 Magenta

#property indicator_level1 300
#property indicator_level2 200
#property indicator_level3 100
#property indicator_level4 -100
#property indicator_level5 -200
#property indicator_level6 -300
#property indicator_levelcolor Silver
#property indicator_levelstyle STYLE_DOT
#property indicator_levelwidth 1



//---- input parameters
extern int       A_period=14;
extern int       B_period=6;
extern int       neutral = 5;
extern int       num_bars=500;
extern double    period=20;
extern double    factor=2.0;
extern double    period_divider=2.0;
extern double    smoothing_power=0.5;
extern int       method=3;
extern int       price=0;
extern int       time_frame = 0;
extern int       Size= 2;
extern int       CCISize=2;
extern int       TCCISize=1;
extern int       HistoSize=2;
extern int       LineSize=2;


// parameters
int i=0;
bool initDone=true;
int bar=0;
int prevbars=0;
int startpar=0;
int cs=0;
int prevcs=0;
string commodt="nonono";
int frame=0;
int bars=0;


int count = 0, thisbar = 0;
double now, prev;
bool flag;

//---- buffers
double FastWoodieCCI[];
double SlowWoodieCCI[];
double HistoWoodieCCI[];
double Uptrend[];
double Dntrend[];
double UpCCItrend[];
double DnCCItrend[];
double ExtMapBuffer[]; 
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorBuffers(8); 
   SetIndexStyle(0,DRAW_NONE,HistoSize);
   SetIndexBuffer(0,HistoWoodieCCI); 
   SetIndexLabel (0, NULL);
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID,HistoSize);
   SetIndexBuffer(1,UpCCItrend);  
   SetIndexLabel (1, NULL);
   SetIndexStyle(2,DRAW_HISTOGRAM,STYLE_SOLID,HistoSize);
   SetIndexBuffer(2,DnCCItrend);  
   SetIndexLabel (2, NULL);  
   SetIndexStyle(3,DRAW_LINE,STYLE_SOLID,CCISize);
   SetIndexBuffer(3,SlowWoodieCCI); 
   
   SetIndexStyle(4,DRAW_LINE,STYLE_SOLID,TCCISize);
   SetIndexBuffer(4,FastWoodieCCI);
   
   SetIndexStyle(5,DRAW_LINE,STYLE_SOLID,LineSize);
   SetIndexBuffer(5, Uptrend);
   SetIndexLabel (5, NULL);
   SetIndexStyle(6,DRAW_LINE,STYLE_SOLID,LineSize);
   SetIndexBuffer(6, Dntrend);  
   SetIndexLabel (6, NULL);
   SetIndexBuffer(7, ExtMapBuffer); 
   ArraySetAsSeries(ExtMapBuffer, true);  

   
   IndicatorShortName("Woodies CCI ("+A_period+","+B_period+") HMA "+period+","+factor+")");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();

   cs = A_period + B_period + num_bars; //checksum used to see if parameters have been changed

   if ((cs==prevcs) && (commodt == Symbol()) && 
      (frame == (Time[4] - Time[5])) &&
      ((Bars - prevbars) < 2))
      startpar = Bars - prevbars; 
   else 
      startpar = -1;  //params haven't changed only need to calculate new bar

   commodt = Symbol();
   frame= Time[4] - Time[5];
   prevbars = Bars;
   prevcs = cs;

   if (startpar == 1 | startpar == 0)  
      bar = startpar;
   else 
      initDone = true;

   if (initDone) {
      HistoWoodieCCI[num_bars-1]=0;
      FastWoodieCCI[num_bars-1]=0;
      SlowWoodieCCI[num_bars-1]=0;      

      bar=num_bars-2;
      initDone=false;
   }

   for (i = bar; i >= 0; i--) {
      HistoWoodieCCI[i]=iCCI(NULL,0,A_period,PRICE_TYPICAL,i); 
      FastWoodieCCI[i]=iCCI(NULL,0,B_period,PRICE_TYPICAL,i);
      SlowWoodieCCI[i]=iCCI(NULL,0,A_period,PRICE_TYPICAL,i);
      
    if (HistoWoodieCCI[i]>0)
    { UpCCItrend[i] = HistoWoodieCCI[i]; 
      DnCCItrend[i] = EMPTY_VALUE;
    }
    else              
    if (HistoWoodieCCI[i]<0)
    { 
      DnCCItrend[i] = HistoWoodieCCI[i];       
      UpCCItrend[i] = EMPTY_VALUE;     
    } 
      
      now = iCCI(NULL,0,A_period,PRICE_TYPICAL,i);

      if ((prev >= 0 && now < 0) || (prev < 0 && now >= 0)) { // change of sign detected
         flag = true;
         count = 0;
      }

      if (flag) { // neutral territory
         if (thisbar != i)
            count++;
         prev = now;
         HistoWoodieCCI[i] = now;
         if (count >= neutral)
            flag = false;
         thisbar = i;
         continue;
      }

   }
   

    int x = 0; 
    int p = MathSqrt(period);              
    int e = Bars - counted_bars + period + 1; 
    
    double vect[], trend[]; 
    
    if(e > Bars) e = Bars;    

    ArrayResize(vect, e); 
    ArraySetAsSeries(vect, true);
    ArrayResize(trend, e); 
    ArraySetAsSeries(trend, true); 
    
    for(x = 0; x < e; x++) 
    { 
        vect[x] = factor*iMA(NULL,time_frame, period/period_divider, 0, method, price, x)-iMA(NULL, 0, period, 0, method, price, x);
 
    } 

    for(x = 0; x < e-period; x++)
     
        ExtMapBuffer[x] = iMAOnArray(vect, 0, p, 0, method, x);        
    
    for(x = e-period; x >= 0; x--)
    {     
        trend[x] = trend[x+1];
        if (ExtMapBuffer[x]> ExtMapBuffer[x+1]) trend[x] =1;
        if (ExtMapBuffer[x]< ExtMapBuffer[x+1]) trend[x] =-1;
       
    Uptrend[x] = 1;
    Dntrend[x] = 1; 
    
    if (trend[x]>0)
    { Uptrend[x] = 1; 
      if (trend[x+1]<0) Uptrend[x+1]=1;
      Dntrend[x] = EMPTY_VALUE;
    }
    else              
    if (trend[x]<0)
    { 
      Dntrend[x] = 1; 
      if (trend[x+1]>0) Dntrend[x+1]=1;
      Uptrend[x] = EMPTY_VALUE;
    } 
    }             

   return(0);
  }

