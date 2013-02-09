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

extern bool UseAlerts = true;
extern bool UseEmailAlerts = true;

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
   double ima25p, ima50p, ima100p;
   int counter = 0;
   for (int i = NeedBarsCounted; i >= 1; i--)
   {
      ima25 = iMA(NULL,0,25,0,MODE_EMA,PRICE_CLOSE,i);
      ima50 = iMA(NULL,0,50,0,MODE_EMA,PRICE_CLOSE,i);
      ima100 = iMA(NULL,0,100,0,MODE_EMA,PRICE_CLOSE,i);
      
      //check if red crosses blue
      if (ima25 < ima50 && ima25 < ima100) {
         signal = -1;
      } else if (ima25 > ima50 && ima25 > ima100) {
         signal = 1;
      } else {
         signal = 0;
      }
      //Print("signal: ", i, ", ", signal);
      if (High[i] < ima25 && High[i] < ima50 && High[i] < ima100 && Open[i] > Close[i]) {
         //sell position
         if (i <= 25)
            counter--;
      } else if (Low[i] > ima25 && Low[i] > ima50 && Low[i] > ima100 && Open[i] < Close[i]) {
         //buy position
         if (i <= 25)
            counter++;
      }      
      
      if (High[i] < ima25 && High[i] < ima50 && High[i] < ima100 && signal == -1 && previous1 == 0 && Open[i] > Close[i]) {
         //sell position
         avg = High[i] + (15 * Point);
         //if (signal == -1) {
            Down[i] = avg;
         //}
         previous2 = 0;
         previous1 = 1;
         if (i == 1) SendAlert("Bearish");
      } else if (Low[i] > ima25 && Low[i] > ima50 && Low[i] > ima100 && signal == 1 && previous2 == 0 && Open[i] < Close[i]) {
         //buy position
         avg = Low[i] - (15 * Point);
         //if (signal == 1) {
            Up[i] = avg;
         //}
         previous1 = 0;
         previous2 = 1;
         if (i == 1) SendAlert("Bullish");
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
   ima25 = iMA(NULL,0,25,0,MODE_EMA,PRICE_OPEN,0);
   ima50 = iMA(NULL,0,50,0,MODE_EMA,PRICE_OPEN,0);
   ima100 = iMA(NULL,0,100,0,MODE_EMA,PRICE_OPEN,0);
   
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


string TimeframeToString(int P)
{
   switch(P)
   {
      case PERIOD_M1:  return("M1");
      case PERIOD_M5:  return("M5");
      case PERIOD_M15: return("M15");
      case PERIOD_M30: return("M30");
      case PERIOD_H1:  return("H1");
      case PERIOD_H4:  return("H4");
      case PERIOD_D1:  return("D1");
      case PERIOD_W1:  return("W1");
      case PERIOD_MN1: return("MN1");
   }
}

void SendAlert(string dir)
{
   string per = TimeframeToString(Period());
   if (UseAlerts)
   {
      Alert(dir + " Indicator Scalping on ", Symbol(), " @ ", per);
      PlaySound("alert.wav");
   }
   if (UseEmailAlerts)
      SendMail(Symbol() + " @ " + per + " - " + dir + " Indicator Scalping", dir + " Indicator Scalping on " + Symbol() + " @ " + per + " as of " + TimeToStr(TimeCurrent()));
}