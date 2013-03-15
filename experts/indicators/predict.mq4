//+------------------------------------------------------------------+
//|                                                      predict.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window

double PrevTime;
double OpenTime;
   int result = 0;
   string message;
   string colors;
   double range;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   Comment("");
   ObjectsDeleteAll();
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
   Comment("");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
   Comment("");
   if (Open[0] != OpenTime) {
      message = "";
      result = 0;
      OpenTime = Open[0];
   }
   double standard_diff10 = 10 * Point;
   //double standard_diff = totalmove / 10;
   string name = "predict_"+Time[0];
   string name2 = "predict2_"+Time[0];
   ObjectDelete(name);
   double high, low, cur_high, cur_low, totalmove, twentyfivepercent, totalmove_cur, twentyfivepercent_cur, tenpercent_cur;
   high = High[1];
   low = Low[1];
   totalmove = high - low;
   twentyfivepercent = totalmove / 4;
   cur_high = High[0];
   cur_low = Low[0];
   totalmove_cur = cur_high - cur_low;
   twentyfivepercent_cur = totalmove_cur / 4;
   tenpercent_cur = totalmove_cur / 10;
   double standard_diff = twentyfivepercent_cur;
   double diff_high = High[0] - Open[0];
   double diff_low = Open[0] - Low[0];
   //Alert("Diff High: ", DoubleToStr(diff_high, Digits), ", Diff Low: ", DoubleToStr(diff_low, Digits));
   if ((totalmove / Point) < 150) {
      message = "NA";
   }
   /*if (Bid - Open[0] < standard_diff && Bid - Open[0] > 0 && message == "") {
      
   } else if (Open[0] - Bid < standard_diff && Open[0] - Bid > 0 && message == "") {
        
   } else 
   */
   if (
      diff_high > tenpercent_cur && Bid < Open[0] && (Open[0] - Low[0]) > tenpercent_cur 
      && message == ""
   ) {
      if(Time[0] != PrevTime) {
        Alert(Symbol(), ", symbol, sell"); 
        PrevTime = Time[0];
        message = "Sell";
        result = -1;
      }
   } else if (
      diff_low > standard_diff && Bid > Open[0] && (High[0] - Open[0]) > standard_diff
      && message == ""
      ) {
      if(Time[0] != PrevTime) {
        Alert(Symbol(), ", symbol, buy"); 
        PrevTime = Time[0];
        message = "Buy";
        result = 1;
      }
   } 
   /*else if (Open[0] - Bid > twentyfivepercent && Open[0] > Close[0]) {
      if(Time[0] != PrevTime) {
         Alert(Symbol(), ", symbol, sell"); 
        PrevTime = Time[0];
        result = -1;
      }   
   } else if (Bid - Open[0] > twentyfivepercent && Open[0] < Close[0]) {
      if(Time[0] != PrevTime) {
        Alert(Symbol(), ", symbol, buy"); 
        PrevTime = Time[0];
        result = 1;
      }
   }
   else {
      ObjectCreate(name, OBJ_TEXT, 0, Time[0], (High[0] + (standard_diff10 * 3)));
      ObjectSetText(name, "Wait", 10, "Verdana", Green);
   }
   */
      range = High[0] + (standard_diff10 * 3);
   if (result == 1) {
      colors = "Green";
   } else if (result == -1) {
      colors = "Red";
   } else {
      colors = "Blue";
   }
   ObjectCreate(name, OBJ_TEXT, 0, Time[0], (High[0] + (standard_diff10 * 3)));
   ObjectSetText(name, message, 10, "Verdana", colors);
   
   Comment("\n\nBest Used in Day Chart",
   "\nCurrent Ask Price: ", DoubleToStr(Ask, Digits),
   "\nCurrent Bid Price: ", DoubleToStr(Bid, Digits),
   "\nCurrent Open Price: ", DoubleToStr(Open[0], Digits),
   "\nPrevious High Price: ", DoubleToStr(high, Digits),
   "\nPrevious Low Price: ", DoubleToStr(low, Digits),
   "\nExpected Pips: ", DoubleToStr(twentyfivepercent, Digits),
   "\nPrevious Total Move: ", DoubleToStr(totalmove, Digits),
   "\n\nCurrent Buy Price Guess: ", DoubleToStr(Open[0] + twentyfivepercent, Digits),
   "\nCurrent Buy TP Guess: ", DoubleToStr(Open[0] + twentyfivepercent + twentyfivepercent, Digits),
   "\nCurrent Sell Price Guess: ", DoubleToStr(Open[0] - twentyfivepercent, Digits),
   "\nCurrent Sell TP Guess: ", DoubleToStr(Open[0] - (twentyfivepercent + twentyfivepercent), Digits),
   "\nTotal Move Points: ", (totalmove / Point),
   "\n\n"
   

   );

//----
   return(0);
  }
//+------------------------------------------------------------------+