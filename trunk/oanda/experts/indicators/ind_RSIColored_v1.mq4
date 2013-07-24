
#property copyright "*"
#property link      "*"

#define IND "ind_DivPeakTroughRSI_SW_v1"

#property indicator_separate_window
#property indicator_buffers 6
#property indicator_color1 LimeGreen
#property indicator_color2 Green
#property indicator_color3 Red
#property indicator_color4 Maroon
#property indicator_color5 C'None'
#property indicator_color6 C'None'

#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2
#property indicator_width4 2


//---- input parameters
extern int RSIPeriod=14;
extern int RSIPrice=0; // 0-Close, 1-Open, 2-High, 3-Low, 4-Median, 5-Typical, 6-Weighted
extern int ExtrLeftBars=2; // баров слева от экстремума
extern int ExtrRightBars=1; // баров справа от экстремума
extern double PlusSens=0.0001;
extern double MinusSens=-0.0001;
       bool DrawLinesSW=false;
       bool DrawLinesChW=false;
       color Col_Peak_1=Red;
       color Col_Peak_2=DeepPink;
       color Col_Trough_1=LimeGreen;
       color Col_Trough_2=YellowGreen;
       string ShortName0="ZX";
extern string ShortName="DPTRSI";       

//---- buffers
double PlusUp[];
double PlusDn[];
double MinusDn[];
double MinusUp[];
double Dot1[];
double Dot2[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init(){

//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,PlusUp);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexBuffer(1,PlusDn);
   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexBuffer(2,MinusDn);
   SetIndexStyle(3,DRAW_HISTOGRAM);
   SetIndexBuffer(3,MinusUp);
   SetIndexStyle(4,DRAW_LINE);
   SetIndexBuffer(4,Dot1);
   SetIndexStyle(5,DRAW_LINE);
   SetIndexBuffer(5,Dot2);
   
   SetIndexLabel(0,"");
   SetIndexLabel(1,"");   
   SetIndexLabel(2,"");   
   SetIndexLabel(3,"");   
   SetIndexLabel(4,"");   
   SetIndexLabel(5,"");      
   
   
   
   IndicatorShortName(ShortName);
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
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
int start(){

         int limit=Bars-IndicatorCounted();

            for(int i=limit-1;i>=0;i--){
            
               PlusUp[i]=0;
               PlusDn[i]=0;                     
               MinusDn[i]=0;                       
               MinusUp[i]=0;               
            
               double osc1=iCustom(NULL,0,IND,RSIPeriod,RSIPrice,ExtrLeftBars,ExtrRightBars,PlusSens,MinusSens,DrawLinesSW,DrawLinesChW,Col_Peak_1,Col_Peak_2,Col_Trough_1,Col_Trough_2,ShortName0,0,i);       
               double osc2=iCustom(NULL,0,IND,RSIPeriod,RSIPrice,ExtrLeftBars,ExtrRightBars,PlusSens,MinusSens,DrawLinesSW,DrawLinesChW,Col_Peak_1,Col_Peak_2,Col_Trough_1,Col_Trough_2,ShortName0,0,i+1);       
               Dot1[i]=iCustom(NULL,0,IND,RSIPeriod,RSIPrice,ExtrLeftBars,ExtrRightBars,PlusSens,MinusSens,DrawLinesSW,DrawLinesChW,Col_Peak_1,Col_Peak_2,Col_Trough_1,Col_Trough_2,ShortName0,1,i);
               Dot2[i]=iCustom(NULL,0,IND,RSIPeriod,RSIPrice,ExtrLeftBars,ExtrRightBars,PlusSens,MinusSens,DrawLinesSW,DrawLinesChW,Col_Peak_1,Col_Peak_2,Col_Trough_1,Col_Trough_2,ShortName0,2,i);       
       
               int Case=0;
                  if(osc1>0){
                     if(osc1>osc2){
                        Case=1;
                     }
                     if(osc1<osc2){
                        Case=2;
                     }
                  }
                  if(osc1<0){
                     if(osc1<osc2){
                        Case=3;  
                     }
                     if(osc1>osc2){
                        Case=4;
                     }                  
                  }    
                  if(Case==0){
                     if(PlusUp[i+1]!=0){
                        Case=1;
                     }
                     if(PlusDn[i+1]!=0){
                        Case=2;
                     }     
                     if(MinusDn[i+1]!=0){
                        Case=3;
                     }
                     if(MinusUp[i+1]!=0){
                        Case=4;
                     }                                          
                  }   
                  switch(Case){
                     case 1:
                        PlusUp[i]=osc1;
                     break;
                     case 2:
                        PlusDn[i]=osc1;                     
                     break;
                     case 3:
                        MinusDn[i]=osc1;  
                     break;                        
                     case 4:
                        MinusUp[i]=osc1;                       
                     break;
                  }
                             
            }

   return(0);
}
//+------------------------------------------------------------------+