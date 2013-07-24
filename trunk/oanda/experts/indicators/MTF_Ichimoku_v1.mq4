//+------------------------------------------------------------------+
//|                                              MTF_Ichimoku_v1.mq4 |
//|                                  Copyright © 2007, Forex-TSD.com |
//|                         Written by IgorAD,igorad2003@yahoo.co.uk |   
//|            http://finance.groups.yahoo.com/group/TrendLaboratory |                                      
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, Forex-TSD.com "
#property link      "http://www.forex-tsd.com/"

#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1 Red
#property indicator_color2 Blue
#property indicator_color3 SandyBrown
#property indicator_color4 Thistle
#property indicator_color5 Lime
#property indicator_color6 SandyBrown
#property indicator_color7 Thistle
#property indicator_width1 2
#property indicator_width2 2
#property indicator_style3 2
#property indicator_style4 2
#property indicator_style6 1
#property indicator_style7 1
//---- input parameters
extern int TimeFrame=0;
extern int Tenkan=9;
extern int Kijun=26;
extern int Senkou=52;

//---- buffers
double Tenkan_Buffer[];
double Kijun_Buffer[];
double SpanA_Buffer[];
double SpanB_Buffer[];
double Chinkou_Buffer[];
double SpanA2_Buffer[];
double SpanB2_Buffer[];

int a_begin;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

int init()
{
//----
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,Tenkan_Buffer);
   SetIndexDrawBegin(0,Tenkan-1);
   SetIndexLabel(0,"Tenkan Sen");
//----
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,Kijun_Buffer);
   SetIndexDrawBegin(1,Kijun-1);
   SetIndexLabel(1,"Kijun Sen");
//----
   a_begin=Kijun; if(a_begin<Tenkan) a_begin=Tenkan;
   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexBuffer(2,SpanA_Buffer);
   SetIndexDrawBegin(2,Kijun+a_begin-1);
   if(TimeFrame==0) TimeFrame = Period();
   SetIndexShift(2,Kijun*TimeFrame/Period());
   SetIndexLabel(2,NULL);

   SetIndexStyle(5,DRAW_LINE);
   SetIndexBuffer(5,SpanA2_Buffer);
   SetIndexDrawBegin(5,Kijun+a_begin-1);
   SetIndexShift(5,Kijun*TimeFrame/Period());
   SetIndexLabel(5,"Senkou Span A");

//----
   SetIndexStyle(3,DRAW_HISTOGRAM);
   SetIndexBuffer(3,SpanB_Buffer);
   SetIndexDrawBegin(3,Kijun+Senkou-1);
   SetIndexShift(3,Kijun*TimeFrame/Period());
   SetIndexLabel(3,NULL);

   SetIndexStyle(6,DRAW_LINE);
   SetIndexBuffer(6,SpanB2_Buffer);
   SetIndexDrawBegin(6,Kijun+Senkou-1);
   SetIndexShift(6,Kijun*TimeFrame/Period());

   SetIndexLabel(6,"Senkou Span B");
//----
   SetIndexStyle(4,DRAW_LINE);
   SetIndexBuffer(4,Chinkou_Buffer);
   SetIndexShift(4,-Kijun*TimeFrame/Period());
   SetIndexLabel(4,"Chinkou Span");

   IndicatorShortName("MTF_Ichimoku_v1");
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   datetime TimeArray[];
   int i,limit,y=0,counted_bars=IndicatorCounted();

   ArrayCopySeries(TimeArray,MODE_TIME,Symbol(),TimeFrame);

   limit=Bars-counted_bars+TimeFrame/Period();
   
   for(i=0,y=0;i<limit;i++) 
   {
   if (Time[i]<TimeArray[y]) y++;
   double UpTenkan = iHigh(NULL,TimeFrame,iHighest(NULL,TimeFrame,MODE_HIGH,Tenkan,y));
   double DnTenkan =  iLow(NULL,TimeFrame, iLowest(NULL,TimeFrame,MODE_LOW ,Tenkan,y));
   Tenkan_Buffer[i] = 0.5*(UpTenkan + DnTenkan);

   double UpKijun = iHigh(NULL,TimeFrame,iHighest(NULL,TimeFrame,MODE_HIGH,Kijun,y));
   double DnKijun =  iLow(NULL,TimeFrame, iLowest(NULL,TimeFrame,MODE_LOW ,Kijun,y));
   Kijun_Buffer[i] = 0.5*(UpKijun + DnKijun);
   
   double UpSenkou = iHigh(NULL,TimeFrame,iHighest(NULL,TimeFrame,MODE_HIGH,Senkou,y));
   double DnSenkou =  iLow(NULL,TimeFrame, iLowest(NULL,TimeFrame,MODE_LOW ,Senkou,y));
         
   SpanA_Buffer[i]= 0.5*(Kijun_Buffer[i]+Tenkan_Buffer[i]);
   SpanB_Buffer[i]= 0.5*(UpSenkou + DnSenkou);
   
   double chinko=iClose(NULL,TimeFrame,y);
   if(chinko>0) Chinkou_Buffer[i]=chinko;
   
   SpanA2_Buffer[i]= SpanA_Buffer[i];
   SpanB2_Buffer[i]= SpanB_Buffer[i];
   }
return(0);
}