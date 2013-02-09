//+------------------------------------------------------------------+
//|                                                       common.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

extern bool UseAlerts = true;
extern bool UseEmailAlerts = true;
extern bool UsePrintAlerts = true;


//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2005

//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);

// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import

//+------------------------------------------------------------------+
//| EX4 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex4"
//   string ErrorDescription(int error_code);
// #import
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
      Alert(Symbol(), " @ ", per, " - ", TimeToStr(TimeCurrent()), " - ", dir);
      PlaySound("alert.wav");
   }
   if (UseEmailAlerts)
      SendMail(Symbol() + " @ " + per + " - Message", dir + " on " + Symbol() + " @ " + per + " as of " + TimeToStr(TimeCurrent()));
      
   if (UsePrintAlerts)
      Print(Symbol() + " @ " + per + " - Message", dir + " on " + Symbol() + " @ " + per + " as of " + TimeToStr(TimeCurrent()));
}

double twentyfivepercent()
{
   double high, low, totalmove, twentyfivepercent;
   high = High[1];
   low = Low[1];
   totalmove = high - low;
   twentyfivepercent = totalmove / 4;
   return (twentyfivepercent);
}
double lotsize(double lots)
{
   if (lots > 0)
      return (lots);

   double a = (AccountFreeMargin() * 2) / 100; // 2 is riskfactor
   double b = a / 5;
   double c = b / 100;
   double d = NormalizeDouble(c, 2);
   return (d);
}


//strategies

int bollingerbands(int numberb)
{
   int result = 0;
   double b1 = iBands(Symbol(),0,20,2,0,PRICE_CLOSE,MODE_UPPER,numberb);
   double b2 = iBands(Symbol(),0,20,2,0,PRICE_CLOSE,MODE_LOWER,numberb);
   double ma = double iMA(Symbol(), 0, 20, 0, MODE_SMA, PRICE_CLOSE, numberb);
   double low[3];
   double high[3];
   high[0] = High[(numberb)];
   high[1] = High[(numberb+1)];
   high[2] = High[(numberb+2)];
   low[0] = Low[(numberb)];
   low[1] = Low[(numberb+1)];
   low[2] = Low[(numberb+2)];
   //Alert("start: ", DoubleToStr(b1, Digits), ", ", DoubleToStr(ma, Digits), ", ", DoubleToStr(b2, Digits));
   //Alert("Low: ", DoubleToStr(low[0], Digits), ", ", DoubleToStr(low[1], Digits), ", ", DoubleToStr(low[2], Digits));
   //Alert("High: ", DoubleToStr(high[0], Digits), ", ", DoubleToStr(high[1], Digits), ", ", DoubleToStr(high[2], Digits));
   /*bollingerband = StringConcatenate(bollingerband, "start: upper: ", DoubleToStr(b1, Digits), ", ma: ", DoubleToStr(ma, Digits), ", lower: ", DoubleToStr(b2, Digits)
   , ", Low: ", DoubleToStr(low[0], Digits), ", ", DoubleToStr(low[1], Digits), ", ", DoubleToStr(low[2], Digits)
   , ", High: ", DoubleToStr(high[0], Digits), ", ", DoubleToStr(high[1], Digits), ", ", DoubleToStr(high[2], Digits)
   , "\nBollinger Band: "
   );*/
   if (low[0] > ma && low[1] > ma && low[2] > ma) { //search for sell
      //bollingerband = StringConcatenate(bollingerband, "searching sell condition. ");
      //localbox = StringConcatenate("Symbol: ", Symbol(), ", period: ", TimeframeToString(Period()), "(bollingerband) searching strong sell condition. ");
      if (high[0] < high[1] && high[2] < high[1] && Open[numberb] > Close[numberb]) {
         //bollingerband = StringConcatenate(bollingerband, "sell condition exists. ");
         //Alert(symbol, ", period: ", TimeframeToString(timeframe), ", sell condition exists using bollingerband.");
         //localbox = StringConcatenate(localbox, "sell condition exists. ");
         result = -1;
      }
   }
   else if (high[0] < ma && high[1] < ma && high[2] < ma) { //search for sell
      //bollingerband = StringConcatenate(bollingerband, "searching buy condition. ");
      //localbox = StringConcatenate("Symbol: ", Symbol(), ", period: ", TimeframeToString(Period()), "(bollingerband) searching strong buy condition. ");
      if (low[0] > low[1] && low[2] > high[1] && Open[numberb] < Close[numberb]) {
         //bollingerband = StringConcatenate(bollingerband, "buy condition exists. ");
         //Alert(symbol, ", period: ", TimeframeToString(timeframe), ", buy condition exists using bollingerband.");
         //localbox = StringConcatenate(localbox, "buy condition exists. ");
         result = 1;
      }
   }
   return (result);
}

