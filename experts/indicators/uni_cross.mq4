//+------------------------------------------------------------------+
//|                                                                  |
//|                                                          Kalenzo |
//|                                                  simone@konto.pl |
//|                                    Modified by Newdigital        |
//|                                    Modified by Linuxser          |
//+------------------------------------------------------------------+

#property copyright "Kalenzo"
#property link      "simone@konto.pl"

#property indicator_chart_window
#property indicator_color1 Blue
#property indicator_color2 Red
#property indicator_width1 1
#property indicator_width2 1

extern bool UseSound = False;
extern bool TypeChart = False;
extern bool UseAlert = true;
extern string NameFileSound = "alert.wav";
extern int    T3Period  = 14;
extern int    T3Price   = PRICE_CLOSE;
extern double b         = 0.618;
extern int Snake_HalfCycle=5; // Snake_HalfCycle = 4...10 or other
extern int Inverse = 0; //0=T3 crossing Snake, 1=Snake crossing T3
extern int DeltaForSell = 0;
extern int DeltaForBuy = 0;

#property indicator_buffers 2
//---- input parameters
//---- buffers
double UpBuffer[];
double DnBuffer[];
double alertBar;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators

  // IndicatorBuffers(2);
   SetIndexStyle(0,DRAW_ARROW,EMPTY);
   SetIndexStyle(1,DRAW_ARROW,EMPTY);
  
   SetIndexBuffer(0,UpBuffer);
   SetIndexBuffer(1,DnBuffer);
  
   SetIndexArrow(0,233);
   SetIndexArrow(1,234);

   SetIndexLabel(0,"Up Signal");
   SetIndexLabel(1,"Down Signal");

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
  
   int limit;
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) counted_bars=0;
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   
  
   for(int i = 0 ;i < limit ;i++)
   {       
   
      if( Inverse == 0)
      
      double pwma5 = iCustom(Symbol(),0,"Snake",Snake_HalfCycle,0,i+1);
      double cwma5 = iCustom(Symbol(),0,"Snake",Snake_HalfCycle,0,i);
      
      double pwma50 = iCustom(Symbol(),0,"T3_clean",T3Period,T3Price,b,0,i+1);
      double cwma50 = iCustom(Symbol(),0,"T3_clean",T3Period,T3Price,b,0,i);
      
/*    if( Inverse == 1)
      
       pwma5 = iCustom(Symbol(),0,"T3_clean",T3Period,T3Price,b,0,i+1);
       cwma5 = iCustom(Symbol(),0,"T3_clean",T3Period,T3Price,b,0,i);      

      
       pwma50 = iCustom(Symbol(),0,"Snake",Snake_HalfCycle,0,i+1);
       cwma50 = iCustom(Symbol(),0,"Snake",Snake_HalfCycle,0,i);
*/   
            
      if( cwma5 > (cwma50 +(DeltaForBuy*Point)) && pwma5 <= pwma50)
      {  
        UpBuffer[i] = iLow(Symbol(),0,i)-(3*Point);
        DnBuffer[i] = EMPTY_VALUE;
      if (UseSound==1) PlaySound(NameFileSound);
      if (UseAlert==1 && Bars>alertBar) {Alert(Symbol(), "Buy signal", Period());alertBar = Bars;}
      if (TypeChart==1) Comment ("Buy signal at Ask=",Ask,", Bid=",Bid,", Date=",TimeToStr(CurTime(),TIME_DATE)," ",TimeHour(CurTime()),":",TimeMinute(CurTime())," Symbol=",Symbol()," Period=",Period());
      }
      
      else if( pwma5 >= pwma50 && cwma5 < (cwma50 - (DeltaForSell*Point)))
      {
        UpBuffer[i] = EMPTY_VALUE;
        DnBuffer[i] = iHigh(Symbol(),0,i)+(3*Point);
      if (UseSound==1) PlaySound(NameFileSound);
      if (UseAlert==1 && Bars>alertBar) {Alert(Symbol(), "Sell signal", Period());alertBar = Bars;} 
      if (TypeChart==1) Comment ("Sell signal at Ask=",Ask,", Bid=",Bid,", Date=",TimeToStr(CurTime(),TIME_DATE)," ",TimeHour(CurTime()),":",TimeMinute(CurTime())," Symbol=",Symbol()," Period=",Period());
      }
      else
      {
        DnBuffer[i] = EMPTY_VALUE;
        UpBuffer[i] = EMPTY_VALUE;
      }
      
      
  
   }
//----

   return(0);
  }
//+------------------------------------------------------------------+



