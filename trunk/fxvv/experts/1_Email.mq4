//+------------------------------------------------------------------+
//|                                                      1_Email.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

extern double my_signal = 0.81600;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
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
   double lastclose=Close[0];
   Print("my_signal: ", DoubleToStr(my_signal,Digits));
   Print("last close: ", DoubleToStr(lastclose,Digits));
   Print("Ask: ", DoubleToStr(Ask,Digits));
   Print("Bid: ", DoubleToStr(Bid,Digits));
   //if(lastclose<my_signal)
    //SendMail("from your expert", "Price dropped down to "+DoubleToStr(lastclose,Digits));

//----
   return(0);
  }
//+------------------------------------------------------------------+