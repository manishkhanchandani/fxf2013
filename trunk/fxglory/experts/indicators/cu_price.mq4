//+------------------------------------------------------------------+
//|                                                     cu_price.mq4 |
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
   string name;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   ObjectsDeleteAll();
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
   ObjectsDeleteAll();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int limit, i, counter, strategy;
   double Range, AvgRange;
   int    counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//----
   for(i = limit; i >= 1; i--) {
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
      strategy = strategy(Symbol(), Period(), i);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+

int strategy(string symbol, int timeframe, int shift)
{
   int strategy = 0;
   int pinbar = pinbar(symbol, timeframe, shift);
}

int pinbar_formation(string symbol, int timeframe, int shift, int type)
{
   double top, bottom, shadowtop, shadowbottom, body;
   if (Open[shift] > Close[shift]) {
      top = Open[shift];
      bottom = Close[shift];
   } else if (Open[shift] < Close[shift]) {
      top = Close[shift];
      bottom = Open[shift];
   }  
   shadowtop = High[shift] - top;
   shadowbottom = bottom - Low[shift];
   body = top - bottom;
   if (type == 1) {
      if ((3 * body) < shadowbottom && (3 * shadowtop) < shadowbottom) {
         return (1);
      }
   } else if (type == -1) {
      if ((3 * body) < shadowtop && (3 * shadowbottom) < shadowtop) {
         return (-1);
      }
   }
   return (0);
}
int pinbar(string symbol, int timeframe, int shift)
{
   int result;
   double smovingaverage = iMA(symbol, timeframe, 20, 0, MODE_SMA, PRICE_CLOSE, shift+1);
   if (Open[shift] > Close[shift] && Open[shift+2] < Close[shift+2] && Low[shift+1] < Low[shift] && Low[shift+1] < Low[shift+2]
      && smovingaverage < Low[shift+1] && smovingaverage < Low[shift+2] && smovingaverage < Low[shift]
   ) {
         result = pinbar_formation(symbol, timeframe, shift+1, -1);
         if (result == -1) {
            name = "pinbar_";
            name = StringConcatenate(name, shift);
            createobj(name, OBJ_TEXT, shift, Low[shift], "sell");
            CrossDown[shift] = High[shift];
            return (-1);   
         }
   } else if (Open[shift] < Close[shift] && Open[shift+2] > Close[shift+2] && High[shift+1] < High[shift] && High[shift+1] < High[shift+2]
      && smovingaverage > High[shift+1] && smovingaverage > High[shift] && smovingaverage > High[shift+2]
      ) {
         result = pinbar_formation(symbol, timeframe, shift+1, 1);
         if (result == 1) {
            name = "pinbar_";
            name = StringConcatenate(name, shift);
            createobj(name, OBJ_TEXT, shift, High[shift], "buy");
            CrossUp[shift] = Low[shift];
            return (1);
         }
   }
   return (0);
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

/*

int template(string symbol, int timeframe, int shift)
{
   if (Open[shift] > Close[shift]) {
         name = "pinbar_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, Low[shift], "sell");
         CrossDown[shift] = High[shift];
         return (-1);   
   } else if (Open[shift] < Close[shift]) {
         name = "pinbar_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, High[shift], "buy");
         CrossUp[shift] = Low[shift];
         return (1);
   }
}
int engulf(string symbol, int timeframe, int shift)
{
   int num = shift;
   int num1 = shift + 1;
   int num2 = shift + 2;
   //sell condition
   if (Open[num2] < Close[num2] //buy previous
      && Open[num] > Close[num] //current sell
      && High[num2] > High[num1]
      && Low[num2] < Low[num1]
      )
      {
         name = "engulf_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, Low[shift], "eng:sell");
         CrossDown[shift] = High[shift];
         return (-1);
      }
   else if (Open[num2] > Close[num2] //buy sell
      && Open[num] < Close[num] //current buy
      && High[num2] > High[num1]
      && Low[num2] < Low[num1])
      {
         name = "engulf_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, High[shift], "eng:buy");
         CrossUp[shift] = Low[shift];
         return (1);
      }
         return (0);
}*/