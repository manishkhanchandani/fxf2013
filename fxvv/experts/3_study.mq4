//+------------------------------------------------------------------+
//|                                                      3_study.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

extern double increment = 0.00025;
extern bool UseAlerts = true;
extern bool UseEmailAlerts = false;

double start_ask = 0;
double start_ask_max = 0;
double start_ask_min = 0;
double start_bid = 0;
string text = "";

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   start_ask = Ask;
   //Alert(DoubleToStr(start_ask, Digits));
   start_ask_max = Ask + increment;
   //Alert(DoubleToStr(start_ask_max, Digits));
   start_ask_min = Ask - increment;
   //Alert(DoubleToStr(start_ask_min, Digits));
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   
   if (Ask < 0.81100) {
   Alert("Sell price: ", DoubleToStr(Ask,Digits));
   }
   Comment("\n\n\nCurrent Ask Price: ", DoubleToStr(Ask, Digits), "\nCurrent Bid Price: ", DoubleToStr(Bid, Digits));
   
   /*Comment("\n\n\nCurrent Ask Price: ", DoubleToStr(Ask, Digits), "\nMax: \n\nCurrent Bid Price: ", DoubleToStr(Bid, Digits), ", DoubleToStr(start_ask_max, Digits), "\nMin: ", DoubleToStr(start_ask_min, Digits));
   
   if (Ask > start_ask_max) {
      //replace start_ask_max with new Ask
      text = StringConcatenate("Max: ", start_ask_max);
      SendAlert(text);
      start_ask_max = Ask + increment;
      start_ask_min = Ask - increment;
   }
   if (Ask < start_ask_min) {
      //replace start_ask_max with new Ask
      text = StringConcatenate("Min: ", start_ask_min);
      SendAlert(text);
      start_ask_max = Ask + increment;
      start_ask_min = Ask - increment;
   }*/
//----
   return(0);
  }
  /*
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
      Alert(dir + " Pinbar on ", Symbol(), " @ ", per);
      PlaySound("alert.wav");
   }
   if (UseEmailAlerts)
      SendMail(Symbol() + " @ " + per + " - " + dir + " Pinbar", dir + " Pinbar on " + Symbol() + " @ " + per + " as of " + TimeToStr(TimeCurrent()));
}*/
//+------------------------------------------------------------------+