//+------------------------------------------------------------------+
//|                                                       stocks.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 SeaGreen
#property indicator_color2 Red

double CrossUp[];
double CrossDown[];
   string name;
   double height, height1, height2;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   ObjectsDeleteAll();
   SetIndexStyle(0, DRAW_ARROW, EMPTY,3);
   SetIndexArrow(0, 233);
   SetIndexBuffer(0, CrossUp);
   SetIndexStyle(1, DRAW_ARROW, EMPTY,3);
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
   ObjectsDeleteAll();
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   int limit, i, counter;
   double Range, AvgRange;
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   double smovingaverage;
   for(i = 1; i <= limit; i++) {
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      smovingaverage = iMA(NULL, 0, 20, 0, MODE_SMA, PRICE_CLOSE, i);
      momentum(Symbol(), Period(), i);
      ichimuko(Symbol(), Period(), i);
      bblaw1(Symbol(), Period(), i, smovingaverage);
      engulfing(Symbol(), Period(), i, smovingaverage);
      twintowers(Symbol(), Period(), i, smovingaverage);
      //if (Low[i] > smovingaverage) {
         //CrossUp[i] = Low[i] - Range*0.5;
      //}
      //else if (High[i] < smovingaverage) {
          //CrossDown[i] = High[i] + Range*0.5;
      //}
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

void createobj(string name, int type, int shift, double price, string message)
{
   if (ObjectCreate(name, type, 0, Time[shift], price)) {
      if (type == OBJ_TEXT)
         ObjectSetText(name, message, 10, "Arial", Blue);
   }
}

int momentum(string symbol, int timeframe, int shift)
{
   int num = shift;
   int num1 = shift + 1;
   double sma21 = iMA(symbol, timeframe, 21, 0, MODE_SMA, PRICE_CLOSE, shift);
   double sma11 = iMA(symbol, timeframe, 11, 0, MODE_SMA, PRICE_CLOSE, shift);
   double momentum = iMomentum(symbol,timeframe,30,PRICE_CLOSE,shift);
   double rsi = iRSI(symbol, timeframe,14,PRICE_CLOSE,shift);
   if (tenkan_sen < kijunsen
      && chinkouspan < senkouspana
      && chinkouspan < senkouspanb
      && tenkan_sen < senkouspana
      && tenkan_sen < senkouspanb
      && tenkan_sen1 > kijunsen1
   )
   {       
         name = "ichimukosell_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, Low[shift], "ichimuko sell");
         CrossDown[shift] = High[shift];
         return (-1); 
   } else if (tenkan_sen > kijunsen
      && chinkouspan > senkouspana
      && chinkouspan > senkouspanb
      && tenkan_sen > senkouspana
      && tenkan_sen > senkouspanb
      && tenkan_sen1 < kijunsen1
   )
   {        
         name = "ichimukobuy_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, High[shift], "ichimuko buy");
         CrossUp[shift] = Low[shift];
         return (1);  
   }
   return (0);
}
int ichimuko(string symbol, int timeframe, int shift)
{
   int num = shift;
   int num1 = shift + 1;
   double tenkan_sen = iIchimoku(symbol, timeframe, 9, 26, 52, MODE_TENKANSEN, num);
   double kijunsen = iIchimoku(symbol, timeframe, 9, 26, 52, MODE_KIJUNSEN, num);
   double senkouspana = iIchimoku(symbol, timeframe, 9, 26, 52, MODE_SENKOUSPANA, num);
   double senkouspanb = iIchimoku(symbol, timeframe, 9, 26, 52, MODE_SENKOUSPANB, num);
   double chinkouspan = iIchimoku(symbol, timeframe, 9, 26, 52, MODE_CHINKOUSPAN, (num+26));
   
   double tenkan_sen1 = iIchimoku(symbol, timeframe, 9, 26, 52, MODE_TENKANSEN, num1);
   double kijunsen1 = iIchimoku(symbol, timeframe, 9, 26, 52, MODE_KIJUNSEN, num1);
   double senkouspana1 = iIchimoku(symbol, timeframe, 9, 26, 52, MODE_SENKOUSPANA, num1);
   double senkouspanb1 = iIchimoku(symbol, timeframe, 9, 26, 52, MODE_SENKOUSPANB, num1);
   double chinkouspan1 = iIchimoku(symbol, timeframe, 9, 26, 52, MODE_CHINKOUSPAN, (num1+26));
   if (tenkan_sen < kijunsen
      && chinkouspan < senkouspana
      && chinkouspan < senkouspanb
      && tenkan_sen < senkouspana
      && tenkan_sen < senkouspanb
      && tenkan_sen1 > kijunsen1
   )
   {       
         name = "ichimukosell_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, Low[shift], "ichimuko sell");
         CrossDown[shift] = High[shift];
         return (-1); 
   } else if (tenkan_sen > kijunsen
      && chinkouspan > senkouspana
      && chinkouspan > senkouspanb
      && tenkan_sen > senkouspana
      && tenkan_sen > senkouspanb
      && tenkan_sen1 < kijunsen1
   )
   {        
         name = "ichimukobuy_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, High[shift], "ichimuko buy");
         CrossUp[shift] = Low[shift];
         return (1);  
   }
   return (0);
}
int bblaw1(string symbol, int timeframe, int shift, double smovingaverage)
{
   return (0);
   int num = shift;
   int num1 = shift + 1;
   if (Open[num1] < Close[num1]
      && Open[num] > Close[num]
      && Low[num1] > smovingaverage
      && High[num1] > High[num]
      && Low[num1] < Low[num]
   )
   {       
         name = "bblaw1sell_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, Low[shift], "bblaw1 sell");
         CrossDown[shift] = High[shift];
         return (-1); 
   } else if (Open[num1] > Close[num1]
      && Open[num] < Close[num]
      && High[num1] < smovingaverage
      && High[num1] > High[num]
      && Low[num1] < Low[num]
   )
   {        
         name = "bblaw1buy_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, High[shift], "bblaw1 buy");
         CrossUp[shift] = Low[shift];
         return (1);  
   }
   return (0);
}
//improvement is needed
int engulfing(string symbol, int timeframe, int shift, double smovingaverage)
{
   return (0);
   int num = shift;
   int num1 = shift + 1;
   if (Open[num1] < Close[num1]
      && Open[num] > Close[num]
      && Low[num] > smovingaverage
   )
   {
      height = Open[num] - Close[num];
      height1 = Close[num1] - Open[num1];
      if (height > height1) {         
         name = "engulfingsell_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, Low[shift], "engulfing sell");
         CrossDown[shift] = High[shift];
         return (-1);  
      }
   } else if (Open[num1] > Close[num1]
      && Open[num] < Close[num]
      && High[num] < smovingaverage
   )
   {
      height = Close[num] - Open[num];
      height1 = Open[num1] - Close[num1];
      if (height > height1) {         
         name = "engulfingbuy_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, High[shift], "engulfing buy");
         CrossUp[shift] = Low[shift];
         return (1);  
      }
   }
   return (0);
}

int twintowers(string symbol, int timeframe, int shift, double smovingaverage)
{
   return (0);
   int num = shift;
   int num1 = shift + 1;
   double macd = iMACD(symbol,timeframe,12,26,9,PRICE_CLOSE,MODE_MAIN,num);
   double macd1 = iMACD(symbol,timeframe,12,26,9,PRICE_CLOSE,MODE_MAIN,num1);
   double bbupper = iBands(symbol,timeframe,20,2,0,PRICE_CLOSE,MODE_UPPER,num);
   double bblower = iBands(symbol,timeframe,20,2,0,PRICE_CLOSE,MODE_LOWER,num);
   double bbupper1 = iBands(symbol,timeframe,20,2,0,PRICE_CLOSE,MODE_UPPER,num1);
   double bblower1 = iBands(symbol,timeframe,20,2,0,PRICE_CLOSE,MODE_LOWER,num1);
   int threshold = 25;
   //sell
   if (Open[num1] < Close[num1]
      && Open[num] > Close[num]
      && Low[num] > smovingaverage
      && macd > macd1
      && (High[num] > bbupper || High[num1] > bbupper1)
      )
      {
         height1 = Close[num1] - Open[num1];
         height = Open[num] - Close[num];
         height2 = height1 * (3 / 4);
         if (height > height2) {         
            name = "twintowersell_";
            name = StringConcatenate(name, shift);
            createobj(name, OBJ_TEXT, shift, Low[shift], "TwinTower");
            CrossDown[shift] = High[shift];
            return (-1);  
         }
      }
   //sell
   else if (Open[num1] > Close[num1]
      && Open[num] < Close[num]
      && High[num] < smovingaverage
      && macd < macd1
      && (Low[num] < bbupper || Low[num1] < bbupper1)
      )
      {
         height1 = Open[num1] - Close[num1];
         height = Close[num] - Open[num];
         height2 = height1 * (3 / 4);
         if (height > height2) {         
            name = "twintowerbuy_";
            name = StringConcatenate(name, shift);
            createobj(name, OBJ_TEXT, shift, High[shift], "TwinTower");
            CrossUp[shift] = Low[shift];
            return (1);  
         }
      }
   return (0);
}