//+------------------------------------------------------------------+
//|                                   custom_one_minute_scalping.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red //sell
#property indicator_width1 2
#property indicator_color2 Blue //buy
#property indicator_width2 2

// Indicator buffers
double Down[];
double Up[];
double Ma25[];
double Ma50[];
double Ma100[];
int previous = 0;
int previous1 = 0;
int previous2 = 0;
int signal = 0;

int LastBars = 0;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators

//---- indicator buffers mapping  
   SetIndexBuffer(0, Down);
   SetIndexBuffer(1, Up);
 
//---- drawing settings
   SetIndexStyle(0, DRAW_ARROW);
   SetIndexArrow(0, 74);
   SetIndexStyle(1, DRAW_ARROW);
   SetIndexArrow(1, 74);

//----
   SetIndexEmptyValue(0, EMPTY_VALUE);
   SetIndexEmptyValue(1, EMPTY_VALUE);

//---- indicator labels
   SetIndexLabel(0, "Bearish Bar");
   SetIndexLabel(1, "Bullish Bar");


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
   if (LastBars == Bars) return(0);

   int    counted_bars=IndicatorCounted();
   int NeedBarsCounted;
   NeedBarsCounted = Bars - LastBars;
   LastBars = Bars;
   
   double avg;
   double ima25, ima50, ima100, iadx;
   int counter = 0;
   for (int i = NeedBarsCounted; i >= 1; i--)
   {
      ima25 = iMA(NULL,0,25,0,MODE_EMA,PRICE_CLOSE,i);
      ima50 = iMA(NULL,0,50,0,MODE_EMA,PRICE_CLOSE,i);
      ima100 = iMA(NULL,0,100,0,MODE_EMA,PRICE_CLOSE,i);
      if (High[i] < ima25 && High[i] < ima50 && High[i] < ima100 && Open[i] > Close[i]) {
         //sell position
         avg = High[i] + (5 * Point);
         Down[i] = avg;
         if (i <= 25)
            counter--;
      } else if (Low[i] > ima25 && Low[i] > ima50 && Low[i] > ima100 && Open[i] < Close[i]) {
         //buy position
         avg = Low[i] - (5 * Point);
         Up[i] = avg;
         if (i <= 25)
            counter++;
      }      
   }
//----
   string trend;
   if (counter > 0) trend = "Buy";
   else if (counter < 0) trend = "Sell";
   else trend = "Consolidated";
   
   iadx = iADX(NULL, 0, 14, PRICE_CLOSE, MODE_MAIN, 0);
   string trendtype = "Consolidated";
   if (iadx > 20 && iadx < 40) {
      trendtype = "Gaining Strong Trend";
   } else if (iadx < 20) {
      trendtype = "Weak Trend";
   } else if (iadx > 40) {
      trendtype = "Strong Trend";
   }
   ima25 = iMA(NULL,0,25,0,MODE_EMA,PRICE_CLOSE,0);
   ima50 = iMA(NULL,0,50,0,MODE_EMA,PRICE_CLOSE,0);
   ima100 = iMA(NULL,0,100,0,MODE_EMA,PRICE_CLOSE,0);
   
   Comment("Bars: ", Bars,
   "\nCounter: ", counter,
   "\nTrend: ", trend,
   "\nADX: ", DoubleToStr(iadx, Digits),
   "\ntrendtype: ", trendtype,
   "\nima25: ", DoubleToStr(ima25, Digits),
   "\nima50: ", DoubleToStr(ima50, Digits),
   "\nima100: ", DoubleToStr(ima100, Digits));
//----
   return(0);
  }
//+------------------------------------------------------------------+