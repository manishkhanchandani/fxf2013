//+------------------------------------------------------------------+
//|                                                 Trend Arrows.mq4 |
//|                                        Copyright © 2012, FXTools |
//|                                                 www.fxtools.info |             
//+------------------------------------------------------------------+
#property copyright "© FXTools"
#property link "http://www.fxtools.info"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Lime

extern int Arrow_Size = 0;
extern int Arrow_PointGap = 15;
extern bool Alerts = false;

int Barcount;
string Timeframe; 

//---- buffers
double b1[],b2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators

   IndicatorBuffers(2);
   IndicatorShortName("Trend Arrows");
   
   SetIndexStyle(0,DRAW_ARROW,STYLE_SOLID,Arrow_Size);
   SetIndexArrow(0,230);  
   SetIndexBuffer(0,b1);

   SetIndexStyle(1,DRAW_ARROW,STYLE_SOLID,Arrow_Size);
   SetIndexArrow(1,228);  
   SetIndexBuffer(1,b2);
   
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
      
// Arrows

   for(i=0; i<limit; i++)
   {
     if(High[i] < High[i+1] && Low[i] < Low[i+1])
        {b1[i] = High[i]+Arrow_PointGap*Point;}  
     if(High[i] > High[i+1] && Low[i] > Low[i+1])
        {b2[i] = Low[i]-Arrow_PointGap*Point;}
     if((High[i+1] <= High[i+2] && Low[i+1] >= Low[i+2])||(High[i+1] >= High[i+2] && Low[i+1] <= Low[i+2]))
        {if(High[i+2] < High[i+3] && Low[i+2] < Low[i+3]) {b1[i+1] = High[i+1]+Arrow_PointGap*Point;}
         if(High[i+2] > High[i+3] && Low[i+2] > Low[i+3]) {b2[i+1] = Low[i+1]-Arrow_PointGap*Point;}}  
   }
   
// Alerts
 
 if (Alerts && iBars(Symbol(),0)>Barcount)
  { 
   if ((High[0] < High[1] && Low[0] < Low[1])&&(High[1] > High[2] && Low[1] > Low[2])) 
    {Alert("Trend Arrows "+Timeframe+": "+Symbol()+" turning DOWN @ "+DoubleToStr(Bid,Digits));}
   if ((High[0] > High[1] && Low[0] > Low[1])&&(High[1] < High[2] && Low[1] < Low[2]))
    {Alert("Trend Arrows "+Timeframe+": "+Symbol()+" turning UP @ "+DoubleToStr(Bid,Digits));}
  }
   
  Barcount = iBars(Symbol(),0);
//----
   return(0);
  }
//+------------------------------------------------------------------+