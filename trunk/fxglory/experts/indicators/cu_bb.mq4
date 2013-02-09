//+------------------------------------------------------------------+
//|                                                   macdchange.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_width1 2
#property indicator_color2 Orange
#property indicator_width2 2
double CrossUp[];
double CrossDown[];
extern bool VoiceAlert = false;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_ARROW, EMPTY);
   SetIndexArrow(0, 233);
   SetIndexBuffer(0, CrossUp);
   SetIndexStyle(1, DRAW_ARROW, EMPTY);
   SetIndexArrow(1, 234);
   SetIndexBuffer(1, CrossDown);
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
int start()
  {
   int limit, i, counter;
   double Range, AvgRange;
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;

   limit=Bars-counted_bars;
   double val, val2, val3, val4, val5, val6, val7, val8, val9;
   double bbupper_1, bblower_1, bbupper_2, bblower_2;
   int intval1, intval2, j;
   bool condition_buy, condition_sell;
   for(i = limit; i >= 0; i--) {
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      val = iCCI(NULL,0,45,PRICE_CLOSE,i);
      val2 = iCustom(NULL, 0, "BollingersSqueezejv7",0,i);
      val3 = iCustom(NULL, 0, "BollingersSqueezejv7",1,i);
      val4 = iCustom(NULL, 0, "BollingersSqueezejv7",0,i+1);
      val5 = iCustom(NULL, 0, "BollingersSqueezejv7",1,i+1);
      val6 = iCustom(NULL, 0, "BollingersSqueezejv7",0,i+2);
      val7 = iCustom(NULL, 0, "BollingersSqueezejv7",1,i+2);
      val8 = iCustom(NULL, 0, "MACD_Complete",1,i);
      val9 = iCustom(NULL, 0, "MACD_Complete",2,i);
      intval1 = 0;
      intval2 = 0;
      bbupper_1 = iBands(NULL,0,20,1,0,PRICE_CLOSE,MODE_UPPER,i);
      bblower_1 = iBands(NULL,0,20,1,0,PRICE_CLOSE,MODE_LOWER,i);
      bbupper_2 = iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_UPPER,i);
      bblower_2 = iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_LOWER,i);
      if (i == 0) {
         if (Bid < bblower_1) intval2 = 1;
         if (Bid > bbupper_1) intval1 = 1;
         Comment("Macd: ", val8, ", ", val9
         , "\nCCI: ", val
         , "\nintval1: ", intval1
         , "\nintval2: ", intval2
         );
      }
      if (
      (
         //(Close[i] < bblower_1 && Open[i] > bblower_1) 
         //|| 
         //(Close[i] < bblower_2 && Open[i] > bblower_2)
         
         //Close[i] < bblower_1 || intval2 == 1
         
         (Close[i] < bblower_2 && Open[i] > bblower_2)
      ) 
      && val < -100 
      //&& (val5 == 0 || val7 == 0) 
      //&& val3 < 0
      && val8 < val9
      ) {
         CrossDown[i] = High[i] + Range*0.5;
         if (VoiceAlert==true){
            Alert("BB Sell");
         }
      
      } else if (
      (
         //(Close[i] > bbupper_1 && Open[i] < bbupper_1) 
         //|| 
         //(Close[i] > bbupper_2 && Open[i] < bbupper_2)
         
         //Close[i] > bbupper_1 || intval1 == 1
         
         
         (Close[i] > bbupper_2 && Open[i] < bbupper_2)
      ) 
      && val > 100 
      //&& (val4 == 0 || val6 == 0) 
      //&& val2 > 0
      && val8 > val9
      ) {
         CrossUp[i] = Low[i] - Range*0.5;
         if (VoiceAlert==true && (i == 1)){
            Alert("BB Buy");
         }
      } 
      
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+