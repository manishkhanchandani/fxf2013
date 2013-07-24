//+------------------------------------------------------------------+
//|                                                 Swing Arrows.mq4 |
//|                                        Copyright © 2012, FXTools |
//|                                                 www.fxtools.info |             
//+------------------------------------------------------------------+
#property copyright "© FXTools"
#property link "http://www.fxtools.info"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Lime

extern int MA1_Period = 4;
extern int MA2_Period = 34;
extern int Signal_Period = 4; 
extern int Arrow_Size = 1;
extern int Arrow_PointGap = 15;
extern bool Alerts = false;

int Barcount;
string Timeframe; 

//---- buffers
double      Buffer1[],
            Buffer2[],
            b2[],
            b3[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators

   IndicatorBuffers(4);
   IndicatorShortName("Swing Arrows");
   
   SetIndexStyle(0,DRAW_ARROW,STYLE_SOLID,Arrow_Size);
   SetIndexArrow(0,234);
   SetIndexBuffer(0,b2);

   SetIndexStyle(1,DRAW_ARROW,STYLE_SOLID,Arrow_Size);
   SetIndexArrow(1,233);  
   SetIndexBuffer(1,b3);
   
   SetIndexBuffer (2,Buffer1);
   SetIndexBuffer (3,Buffer2);
   
  if (Period() == PERIOD_M1) Timeframe="M1";
  if (Period() == PERIOD_M5) Timeframe="M5";
  if (Period() == PERIOD_M15) Timeframe="M15";
  if (Period() == PERIOD_M30) Timeframe="M30";
  if (Period() == PERIOD_H1) Timeframe="H1";
  if (Period() == PERIOD_H4) Timeframe="H4";
  if (Period() == PERIOD_D1) Timeframe="D1";
  if (Period() == PERIOD_W1) Timeframe="W1";
  if (Period() == PERIOD_MN1) Timeframe="MN1";

  Barcount = 0;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- 
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i, counted_bars=IndicatorCounted();
   int limit=Bars-counted_bars;
   if(counted_bars>0) limit++;
   double MA1,MA2;
   
// Main line
   for(i=0; i<limit; i++)
   {
      MA1=iMA(NULL,0,MA1_Period,0,MODE_SMA,PRICE_MEDIAN,i);
      MA2=iMA(NULL,0,MA2_Period,0,MODE_SMA,PRICE_MEDIAN,i);
      
      Buffer1[i]=MA1-MA2;
    }       

// Signal line

  for(i=0; i<limit; i++)
   {
      Buffer2[i]=iMAOnArray(Buffer1,Bars,Signal_Period,0,MODE_LWMA,i);
   }
      
// Arrows

   for(i=0; i<limit; i++)
   {
         if(Buffer1[i] > Buffer2[i] && Buffer1[i-1] < Buffer2[i-1])
               b2[i] = High[i]+Arrow_PointGap*Point;      
         if(Buffer1[i] < Buffer2[i] && Buffer1[i-1] > Buffer2[i-1])
               b3[i] = Low[i]-Arrow_PointGap*Point; 
   }
   
// Alerts

 if (Alerts && iBars(Symbol(),0)>Barcount)
  {
   if(Buffer1[1] > Buffer2[1] && Buffer1[0] < Buffer2[0])
    {Alert("Swing Arrows "+Timeframe+": Sell "+Symbol()+" @ "+DoubleToStr(Bid,Digits));}
   if(Buffer1[1] < Buffer2[1] && Buffer1[0] > Buffer2[0])
    {Alert("Swing Arrows "+Timeframe+": Buy "+Symbol()+" @ "+DoubleToStr(Ask,Digits));}
  }
   
  Barcount = iBars(Symbol(),0); 
//----
   return(0);
  }
//+------------------------------------------------------------------+