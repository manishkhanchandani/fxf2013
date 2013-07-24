//+------------------------------------------------------------------+
//|                                                  FantailVMA3.mq4 |
//|                                  Copyright © 2007, Forex-TSD.com |
//|                         Written by IgorAD,igorad2003@yahoo.co.uk |   
//|            http://finance.groups.yahoo.com/group/TrendLaboratory |                                      
//+------------------------------------------------------------------+
//Revision history; 
//FantailVMA1: Modified version of VarMA_v1.1.mq4 and Fantail.tpl
//FantailVMA1.mq4 is intended to used by adding the template FantailVMA1.tpl to the chart. 10 Sept 2007.
//Two lines have been commented out and a third one added to use one less array, VarMA[].
//FantailVMA2 & Fantail2.tpl: Turbo version attempt, fantail not adjusted yet for shorter horizontal, 17 Sept 2007.
//FantailVMA3 & Fantail3.tpl: Live end of previous version had the fantail lines defaulting to MA_Length=1.
#property copyright "Copyright © 2007, Forex-TSD.com "
#property link      "http://www.forex-tsd.com/"

#property indicator_chart_window
#property indicator_buffers   1
#property indicator_color1    Yellow
#property indicator_width1    2 
//#property indicator_color2    Red
//#property indicator_width2    2 
//---- input parameters
//For both user settings, 2 is fast, 8 is slow.Weight=2.3 gives late entry.
extern int    ADX_Length=2; 
extern double Weighting=2.0;
extern int  MA_Length=1;//This must be =1 so that the VMA base line does not get averaged.
extern int  MA_Mode=1;
//---- buffers
double MA[];
double VMA[];
double VarMA[];
double ADX[];
double ADXR[];
double sPDI[];
double sMDI[];
double STR[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
//---- indicators
   IndicatorBuffers(8);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,MA);
   SetIndexBuffer(1,VMA);
//   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,VarMA);
   SetIndexBuffer(3,ADX);
   SetIndexBuffer(4,ADXR);
   SetIndexBuffer(5,sPDI);
   SetIndexBuffer(6,sMDI);
   SetIndexBuffer(7,STR);
   
   //---- name for DataWindow and indicator subwindow label
   string short_name="FantailVMA3";
   IndicatorShortName(short_name);
   SetIndexLabel(0,"FantailVMA3");

   //----
   SetIndexDrawBegin(0,2*MA_Length+40);
//   SetIndexDrawBegin(1,2*MA_Length+40);//Used for displaying internal signals.
//----   Safety limits for user settings 
   
   if (ADX_Length<2)ADX_Length=2;
   if (ADX_Length>8)ADX_Length=8;
   if (Weighting<1)Weighting=1;
   if (Weighting>8)Weighting=8;   
   return(0);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int   limit, i, j, counted_bars=IndicatorCounted();


//---- 
     
   if ( counted_bars < 0 ) return(-1);
   if ( counted_bars ==0 ) limit=Bars-1;
   if ( counted_bars < 1 )

   for(i=1;i<2*(MA_Length+ADX_Length+10);i++) 
   {
   VMA[Bars-i]=Close[Bars-i];    
   VarMA[Bars-i]=Close[Bars-i];  
   MA[Bars-i]=Close[Bars-i];    
   STR[Bars-i] = High[Bars-i]-Low[Bars-i]; 
   sPDI[Bars-i] = 0;
   sMDI[Bars-i] = 0;
   ADX[Bars-i]=0;
   ADXR[Bars-i]=0;
   }
   
     
   if(counted_bars>0) limit=Bars-counted_bars;
   limit--;
   
   for(i=limit; i>=0; i--)
   {
   double Hi  = High[i];
   double Hi1 = High[i+1];
   double Lo  = Low[i];
   double Lo1 = Low[i+1];
   double Close1= Close[i+1];
   
   double Bulls = 0.5*(MathAbs(Hi-Hi1)+(Hi-Hi1));
   double Bears = 0.5*(MathAbs(Lo1-Lo)+(Lo1-Lo));
   
   if (Bulls > Bears) Bears = 0;
   else 
   if (Bulls < Bears) Bulls = 0;
   else
   if (Bulls == Bears) {Bulls = 0;Bears = 0;}
  
   sPDI[i] = (Weighting*sPDI[i+1] + Bulls)/(Weighting+1);//ma weighting 
   sMDI[i] = (Weighting*sMDI[i+1] + Bears)/(Weighting+1);//ma weighting 
   
   double   TR = MathMax(Hi-Lo,Hi-Close1); 
   STR[i]  = (Weighting*STR[i+1] + TR)/(Weighting+1);//ma weighting  
    
      if(STR[i]>0 )
      {
      double PDI = sPDI[i]/STR[i];
      double MDI = sMDI[i]/STR[i];
      }
            
   if((PDI + MDI) > 0) 
   double DX = MathAbs(PDI - MDI)/(PDI + MDI); 
   else DX = 0;
   
   ADX[i] = (Weighting*ADX[i+1] + DX)/(Weighting+1);//ma weighting    
   double vADX = ADX[i]; 
     
    
   
      double ADXmin = 1000000;
      for (j=0; j<=ADX_Length-1;j++) ADXmin = MathMin(ADXmin,ADX[i+j]);
     
      double ADXmax = -1;
      for (j=0; j<=ADX_Length-1;j++) ADXmax = MathMax(ADXmax,ADX[i+j]);

   
   double Diff = ADXmax - ADXmin;
   if(Diff > 0) double Const = (vADX- ADXmin)/Diff; else Const = 0;
    

   VarMA[i]=((2-Const)*VarMA[i+1]+Const*Close[i])/2;//Same equation but one less array, mod 10 Sept 2007.

   }

   for(j=limit; j>=0; j--) MA[j] = iMAOnArray(VarMA,0,MA_Length,0,MA_Mode,j);
       
//----
   return(0);
  }
//+------------------------------------------------------------------+
   