//+------------------------------------------------------------------+
//|                                               megamillioninc.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"


double bbupper, bblower, bbupper1, bblower1, bbupper2, bblower2, smovingaverage, squeeze_break, iadx, stochastic, sellzonefibs, buyzonefibs, iadxpdx, iadxmdx, wpr,
rsioma_down, rsioma_up, macd, macd1, parabolic, parabolic1
//,ema80,ema21,ema13,ema05,ema03,ema80_1,ema21_1,ema13_1,ema05_1,ema03_1
,rsi,rsi1
,ema100, ema200, ema100_1, ema200_1, ema100_2, ema200_2
;

double CrossUp[];
double CrossDown[];
double CrossUp2[];
double CrossDown2[];
string infobox2, accountinfo;
double alertTag;
int strategy(string symbol, int timeframe, int shift)
{
   int strategy = 0;
   if (shift == 1) {
      infobox2 = StringConcatenate(infobox2, "Calculating stocks for symbol: ", symbol, " for timeframe: ", TimeframeToString2(timeframe), "\n");
   }
   //Comment(accountinfo, infobox2);
   get_stocks(symbol, timeframe, shift);
   strategy = get_strategies(symbol, timeframe, shift);
   return (strategy);
}
void get_stocks(string symbol, int timeframe, int shift)
{
   int num = shift;
   int num1 = shift + 1;
   int num2 = shift + 2;
   bbupper = iBands(symbol,timeframe,20,2,0,PRICE_CLOSE,MODE_UPPER,num);
   bblower = iBands(symbol,timeframe,20,2,0,PRICE_CLOSE,MODE_LOWER,num);
   bbupper1 = iBands(symbol,timeframe,20,2,0,PRICE_CLOSE,MODE_UPPER,num1);
   bblower1 = iBands(symbol,timeframe,20,2,0,PRICE_CLOSE,MODE_LOWER,num1);
   bbupper2 = iBands(symbol,timeframe,20,2,0,PRICE_CLOSE,MODE_UPPER,num2);
   bblower2 = iBands(symbol,timeframe,20,2,0,PRICE_CLOSE,MODE_LOWER,num2);
   smovingaverage = iMA(symbol, timeframe, 20, 0, MODE_SMA, PRICE_CLOSE, num);
   /*
   squeeze_break = iCustom(symbol, timeframe, "Squeeze_Break", 0, num);
   parabolic = iCustom(symbol, timeframe, "Parabolic", 0, num);
   parabolic1 = iCustom(symbol, timeframe, "Parabolic", 0, num1);
   ema80 = iMA(symbol,timeframe,80,0,MODE_EMA,PRICE_CLOSE,num);
   ema21 = iMA(symbol,timeframe,21,0,MODE_EMA,PRICE_CLOSE,num);
   ema13 = iMA(symbol,timeframe,13,0,MODE_EMA,PRICE_CLOSE,num);
   ema05 = iMA(symbol,timeframe,5,0,MODE_EMA,PRICE_CLOSE,num);
   ema03 = iMA(symbol,timeframe,3,0,MODE_EMA,PRICE_CLOSE,num);
   ema80_1 = iMA(symbol,timeframe,80,0,MODE_EMA,PRICE_CLOSE,num1);
   ema21_1 = iMA(symbol,timeframe,21,0,MODE_EMA,PRICE_CLOSE,num1);
   ema13_1 = iMA(symbol,timeframe,13,0,MODE_EMA,PRICE_CLOSE,num1);
   ema05_1 = iMA(symbol,timeframe,5,0,MODE_EMA,PRICE_CLOSE,num1);
   ema03_1 = iMA(symbol,timeframe,3,0,MODE_EMA,PRICE_CLOSE,num1);
   
   ema09 = iMA(symbol,timeframe,9,0,MODE_EMA,PRICE_CLOSE,num);
   ema09_1 = iMA(symbol,timeframe,9,0,MODE_EMA,PRICE_CLOSE,num1);
   ema100 = iMA(symbol,timeframe,100,0,MODE_EMA,PRICE_CLOSE,num);
   ema200 = iMA(symbol,timeframe,200,0,MODE_EMA,PRICE_CLOSE,num);
   ema100_1 = iMA(symbol,timeframe,100,0,MODE_EMA,PRICE_CLOSE,num1);
   ema200_1 = iMA(symbol,timeframe,200,0,MODE_EMA,PRICE_CLOSE,num1);
   ema100_2 = iMA(symbol,timeframe,100,0,MODE_EMA,PRICE_CLOSE,num2);
   ema200_2 = iMA(symbol,timeframe,200,0,MODE_EMA,PRICE_CLOSE,num2);
   macd = iMACD(symbol, timeframe,12,26,9,PRICE_CLOSE,MODE_MAIN,num);
   macd1 = iMACD(symbol, timeframe,12,26,9,PRICE_CLOSE,MODE_MAIN,num1);
   rsioma_down = gold_rsioma_down(symbol, timeframe, num);
   rsioma_up = gold_rsioma_up(symbol, timeframe, num);
   wpr = gold_william_percent_range(symbol, timeframe, num);
   stochastic = iStochastic(symbol, timeframe, 8, 3, 3, MODE_SMA, 0, MODE_MAIN, num);
   sellzonefibs = gold_sell_zone_fibs(symbol,timeframe,num);
   buyzonefibs = gold_buy_zone_fibs(symbol,timeframe,num);
   iadx = iADX(symbol, timeframe, 14, PRICE_HIGH, MODE_MAIN, num);
   iadxpdx = iADX(symbol, timeframe, 14, PRICE_HIGH, MODE_PLUSDI, num);
   iadxmdx = iADX(symbol, timeframe, 14, PRICE_HIGH, MODE_MINUSDI, num);
   */
   rsi = iRSI(symbol,timeframe,14,PRICE_CLOSE,num);
   rsi1 = iRSI(symbol,timeframe,14,PRICE_CLOSE,num1);
   
}
int get_strategies(string symbol, int timeframe, int shift)
{
   int result;
   int result11 = ema(symbol,timeframe,shift);
   showalert(result11, timeframe, "ema", shift);
   
   //int result1 = mergelines(symbol,timeframe,shift);
   //showalert(result1, timeframe, "Mergelines", shift);
   
   
   int result2 = threeinsidedown(symbol,timeframe,shift);
   showalert(result2, timeframe, "Threeinsidedown", shift);
   int result3 = threeoutsidedown(symbol,timeframe,shift);
   showalert(result3, timeframe, "Threeoutsidedown", shift);
   //int result4 = threecrows(symbol,timeframe,shift);
   //showalert(result4, timeframe, "threecrows", shift);
   int result5 = eveningstar(symbol,timeframe,shift);
   showalert(result5, timeframe, "eveningstar", shift);

   //up
   int result6 = threeinsideup(symbol,timeframe,shift);
   showalert(result6, timeframe, "threeinsideup", shift);
   int result7 = threeoutsideup(symbol,timeframe,shift);
   showalert(result7, timeframe, "threeoutsideup", shift);
   int result8 = morningstar(symbol,timeframe,shift);
   showalert(result8, timeframe, "eveningstar", shift);
   //int result9 = threesoldiers(symbol,timeframe,shift);
   //showalert(result9, timeframe, "threecrows", shift);
   int result10 = twintowers(symbol,timeframe,shift);
   showalert(result10, timeframe, "Twintower", shift);
   //if (result1 != 0) return (result1);
   if (result2 != 0) return (result2);
   if (result3 != 0) return (result3);
   //if (result4 != 0) return (result4);
   if (result5 != 0) return (result5);
   if (result6 != 0) return (result6);
   if (result7 != 0) return (result7);
   if (result8 != 0) return (result8);
   //if (result9 != 0) return (result9);
   if (result10 != 0) return (result10);
   if (result11 != 0) return (result11);
   return (0);
}

int twintowers(string symbol, int timeframe, int shift)
{
   string name;
   int num = shift;
   int num1 = shift + 1;
   int num2 = shift + 2;
   double height, height1;
   //sell
   if (Open[num1] < Close[num1]
      && Open[num] > Close[num]
      && (Close[num1] >= bbupper1 || Open[num] >= bbupper)
      )
      {
         height1 = Close[num1] - Open[num1];
         height = Open[num] - Close[num];
         if (height == height1 || height > (height1/2) || height1 > (height/2)) {         
            /*
            name = "twintowersell_";
            name = StringConcatenate(name, shift);
            createobj(name, OBJ_TEXT, shift, Low[shift], "twintowersell");
            CrossDown[shift] = High[shift];
            */
            return (-1);  
         }
      }
   //sell
   else if (Open[num1] > Close[num1]
      && Open[num] < Close[num]
      && (Close[num1] <= bblower1 || Open[num] <= bblower)
      )
      {
         height1 = Open[num1] - Close[num1];
         height = Close[num] - Open[num];
         if (height == height1 || height > (height1/2) || height1 > (height/2)) {           
            /*      
            name = "twintowerbuy_";
            name = StringConcatenate(name, shift);
            createobj(name, OBJ_TEXT, shift, High[shift], "twintowerbuy");
            CrossUp[shift] = Low[shift];
            */
            return (1);  
         }
      }
   return (0);
}
int threeinsidedown(string symbol, int timeframe, int shift)
{
   string name;
   int num = shift;
   int num1 = shift + 1;
   int num2 = shift + 2;
   if (Open[num2] < Close[num2]
      && Open[num1] > Close[num1]
      && Open[num] > Close[num]
      && (Close[num2] >= bbupper2 || Open[num1] >= bbupper1)
      && (Open[num1] - Close[num] >= Close[num2] - Open[num2])
      && (Close[num2] - Open[num2] >= Open[num1] - Close[num1])
      && rsi < 50
      )
      {
         /*
         name = "threeinsidedown_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, Low[shift], "threeinsidedown");
         CrossDown[shift] = High[shift];
            */
         return (-1);  
      }
   
}
int threeoutsidedown(string symbol, int timeframe, int shift)
{
   string name;
   int num = shift;
   int num1 = shift + 1;
   int num2 = shift + 2;
   if (Open[num2] < Close[num2]
      && Open[num1] > Close[num1]
      && Open[num] > Close[num]
      && (Close[num2] >= bbupper2 || Open[num1] >= bbupper1)
      && (Open[num1] - Close[num1] >= Close[num2] - Open[num2])
      && rsi < 50
      )
      {
         /*
         name = "threeoutsidedown_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, Low[shift], "threeoutsidedown");
         CrossDown[shift] = High[shift];
            */
         return (-1);  
      }
   
}
int threecrows(string symbol, int timeframe, int shift)
{
   string name;
   int num = shift;
   int num1 = shift + 1;
   int num2 = shift + 2;
   if (Open[num2] > Close[num2]
      && Open[num1] > Close[num1]
      && Open[num] > Close[num]
      && (High[num2] >= bbupper2)
      && (smovingaverage < Low[num2])
      && Close[num] - Low[num] < Open[num] - Close[num]
      && Close[num] > bblower
      )
      {
         /*
         name = "threecrows_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, Low[shift], "threecrows");
         CrossDown[shift] = High[shift];
            */
         return (-1);  
      }
   
}
int eveningstar(string symbol, int timeframe, int shift)
{
   string name;
   int num = shift;
   int num1 = shift + 1;
   int num2 = shift + 2;
   if (Open[num2] < Close[num2]
      && Open[num] > Close[num]
      && (High[num1] >= bbupper1)
      && smovingaverage < Low[num1] 
      //&& smovingaverage < Low[num2] && smovingaverage < Low[num]
      && (
         (Open[num1] > Close[num1] && High[num1] - Open[num1] > (3 * (Open[num1] - Close[num1]))) 
         || 
         (Open[num1] <= Close[num1] && High[num1] - Close[num1] > (3 * (Close[num1] - Open[num1])))
         )
      //&&
         //(
            //(Open[num1] > Close[num1] && Open[num] - Close[num] > (2 * (Open[num1] - Close[num1])))
           //||
            //(Open[num1] <= Close[num1] && Open[num] - Close[num] > (2 * (Close[num1] - Open[num1])))
         //)
      )
      {
         /*
         name = "eveningstar_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, Low[shift], "eveningstar");
         CrossDown[shift] = High[shift];
            */
         return (-1);  
      }
   
}


//up

int threeinsideup(string symbol, int timeframe, int shift)
{
   string name;
   int num = shift;
   int num1 = shift + 1;
   int num2 = shift + 2;
   if (Open[num2] > Close[num2]
      && Open[num1] < Close[num1]
      && Open[num] < Close[num]
      && (Close[num2] <= bblower2 || Open[num1] <= bblower1)
      && (Close[num] - Open[num1] >= Open[num2] - Close[num2])
      && (Open[num2] - Close[num2] >= Close[num1] - Open[num1])
      && rsi > 50
      )
      {
         /*
         name = "threeinsideup_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, High[shift], "threeinsideup");
         CrossUp[shift] = Low[shift];
            */
         return (-1);  
      }
   
}

int threeoutsideup(string symbol, int timeframe, int shift)
{
   string name;
   int num = shift;
   int num1 = shift + 1;
   int num2 = shift + 2;
   if (Open[num2] > Close[num2]
      && Open[num1] < Close[num1]
      && Open[num] < Close[num]
      && (Close[num2] <= bblower2 || Open[num1] <= bblower1)
      && (Close[num1] - Open[num1] >= Open[num2] - Close[num2])
      && rsi > 50
      )
      {
         /*
         name = "threeoutsideup_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, High[shift], "threeoutsideup");
         CrossUp[shift] = Low[shift];
            */
         return (-1);  
      }
   
}

int threesoldiers(string symbol, int timeframe, int shift)
{
   string name;
   int num = shift;
   int num1 = shift + 1;
   int num2 = shift + 2;
   if (Open[num2] < Close[num2]
      && Open[num1] < Close[num1]
      && Open[num] < Close[num]
      && (Low[num2] <= bblower2)
      && Open[num2] < Open[num1] && Open[num1] < Open[num]
      && Close[num2] < Close[num1] && Close[num1] < Close[num]
      && (smovingaverage > High[num2])
      && High[num] - Close[num] < Close[num] - Open[num]
      && Close[num] < bbupper
      )
      {
         /*
         name = "threesoldiers_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, High[shift], "threesoldiers");
         CrossUp[shift] = Low[shift];
            */
         return (1);  
      }
   
}
int mergelines(string symbol, int timeframe, int shift)
{
   string name;
   int num = shift;
   double ema700 = iMA(symbol,timeframe,700,0,MODE_EMA,PRICE_CLOSE,num);
   double ema110 = iMA(symbol,timeframe,110,0,MODE_EMA,PRICE_CLOSE,num);
   double ema50 = iMA(symbol,timeframe,50,0,MODE_EMA,PRICE_CLOSE,num);
   double ema9 = iMA(symbol,timeframe,9,0,MODE_EMA,PRICE_CLOSE,num);
   double ema5 = iMA(symbol,timeframe,5,0,MODE_EMA,PRICE_CLOSE,num);
   double ema3 = iMA(symbol,timeframe,3,0,MODE_EMA,PRICE_CLOSE,num);
   double high, low;
   if (Open[num] > Close[num]) {
      high = Open[num];
      low = Close[num];
   } else if (Open[num] < Close[num]) {
      high = Close[num];
      low = Open[num];
   }
   if (
      ema700 > low && ema700 < high
      && ema110 > low && ema110 < high
      && ema50 > low && ema50 < high
      && ema9 > low && ema9 < high
      && ema5 > low && ema5 < high
      && ema3 > low && ema3 < high
   ) {
      if (ema110 > ema50) {
         //sell
         /*
         name = "megadown_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, Low[shift], "megadown");
         CrossDown2[shift] = High[shift];
         */
         return (-1);  
      } else if (ema110 < ema50) {
         //buy
         /*
         name = "megaup_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, High[shift], "megaup");
         CrossUp2[shift] = Low[shift];
            */
         return (1);  
      }
   }
   return (0);
}

int morningstar(string symbol, int timeframe, int shift)
{
   string name;
   int num = shift;
   int num1 = shift + 1;
   int num2 = shift + 2;
   if (Open[num2] > Close[num2]
      && Open[num] < Close[num]
      && (Low[num1] <= bblower1)
      //&& smovingaverage > High[num2] 
      && smovingaverage > High[num1] 
      //&& smovingaverage > High[num])
      && (
         (Open[num1] > Close[num1] && Close[num1] - Low[num1] > (3 * (Open[num1] - Close[num1]))) 
         || 
         (Open[num1] <= Close[num1] && Open[num1] - Low[num1] > (3 * (Close[num1] - Open[num1])))
         )
     // &&
         //(
            //(Open[num1] > Close[num1] && Close[num] - Open[num] > (2 * (Open[num1] - Close[num1])))
            //||
            //(Open[num1] <= Close[num1] && Close[num] - Open[num] > (2 * (Close[num1] - Open[num1])))
         //)
      )
      {
         /*
         name = "morningstar_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, High[shift], "morningstar");
         CrossUp[shift] = Low[shift];
            */
         return (1);  
      }
   
}

int ema(string symbol, int timeframe, int shift)
{
   string name;
   int num = shift;
   int num1 = shift + 1;
   double ema700 = iMA(symbol,timeframe,700,0,MODE_EMA,PRICE_CLOSE,num);
   double ema700p = iMA(symbol,timeframe,700,0,MODE_EMA,PRICE_CLOSE,num1);
   double ema110 = iMA(symbol,timeframe,110,0,MODE_EMA,PRICE_CLOSE,num);
   double ema110p = iMA(symbol,timeframe,110,0,MODE_EMA,PRICE_CLOSE,num1);
   //double ema50 = iMA(symbol,timeframe,50,0,MODE_EMA,PRICE_CLOSE,num);
   //double ema50p = iMA(symbol,timeframe,50,0,MODE_EMA,PRICE_CLOSE,num1);
   double ema3 = iMA(symbol,timeframe,3,0,MODE_EMA,PRICE_CLOSE,num);
   double ema3p = iMA(symbol,timeframe,3,0,MODE_EMA,PRICE_CLOSE,num1);
   double ema9 = iMA(symbol,timeframe,9,0,MODE_EMA,PRICE_CLOSE,num);

      if (
         ema700 > ema110
         && 
         (
            (ema3 < ema700 &&
            ema3p > ema700p &&
            ema9 < ema700)
            ||
            (ema3 < ema110 &&
            ema3p > ema110p &&
            ema9 < ema110)
         )
      
      ) {
         /*
         name = "emasell_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, Low[shift], "emasell");
         CrossDown[shift] = High[shift];
            */
         return (-1);
      } else if (
         ema700 < ema110
         && 
         (
            (ema3 > ema700 &&
            ema3p < ema700p &&
            ema9 > ema700)
            ||
            (ema3 > ema110 &&
            ema3p < ema110p &&
            ema9 > ema110)
         )
      )     
      {
         /*
         name = "emabuy_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, High[shift], "emabuy");
         CrossUp[shift] = Low[shift];
            */
         return (1);
      
      } 
      return (0);
}
void createobj(string name, int type, int shift, double price, string message)
{
   if (ObjectCreate(name, type, 0, Time[shift], price)) {
      if (type == OBJ_TEXT)
         ObjectSetText(name, message, 10, "Times New Roman", Blue);
   } else {
      Print("error: can't create text_object! code #",GetLastError());
      return(0);

   
   }

}

void showalert(int result, int timeframe, string mes, int shift)
{
   if (result != 0) {
      
            string name = mes + "_" + convertbuysell(result) + "_" + Time[shift];
            string name2 = mes + convertbuysell(result);
            if (result== 1) {
            createobj(name, OBJ_TEXT, shift, High[shift], name2);
            CrossUp[shift] = Low[shift];
            } else if (result == -1) {
            createobj(name, OBJ_TEXT, shift, Low[shift], name2);
            CrossDown[shift] = High[shift];
            }
   }
   if (result == 0 || shift != 1)
      return (0);
   if (alertTag != Time[0] && timeframe < PERIOD_D1) {
      Alert(Symbol(), ", shows ", convertbuysell(result), " for timeperiod: ", TimeframeToString2(timeframe));
      alertTag = Time[0];
   }
      infobox2 = StringConcatenate(
         infobox2,
         mes, ": (", TimeframeToString2(timeframe),")", convertbuysell(result), "\n");
}
string TimeframeToString2(int P)
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
string convertbuysell(int val)
{
   if (val == 1) {
      return ("Buy");
   } else if (val == -1) {
      return ("Sell");
   }
}
double gold_sell_zone_fibs(string symbol, int timeframe, int shift)
{
   double tmp;
   int MAPeriod = 55;
   int       MAType=2;
   int fibo1 = 1;
   int fibo2 = 2;
   int fibo3 = 3;
   int fibo4 = 4;
   int fibo5 = 5;
   int fibo6 = 6;
   int fibo7 = 7;
   tmp = iCustom(symbol, timeframe, "sell zone fibs", MAPeriod, MAType, fibo1, fibo2, fibo3, fibo4, fibo5, fibo6, fibo7, 0, shift);
   return (tmp);
}
double gold_buy_zone_fibs(string symbol, int timeframe, int shift)
{
   double tmp;
   int MAPeriod = 55;
   int       MAType=2;
   int fibo1 = 1;
   int fibo2 = 2;
   int fibo3 = 3;
   int fibo4 = 4;
   int fibo5 = 5;
   int fibo6 = 6;
   int fibo7 = 7;
   tmp = iCustom(symbol, timeframe, "buy zone fibs", MAPeriod, MAType, fibo1, fibo2, fibo3, fibo4, fibo5, fibo6, fibo7, 0, shift);
   return (tmp);
}

double gold_rsioma_down(string symbol, int timeframe, int shift)
{
   double tmp;
   tmp = iCustom(symbol, timeframe, "RSIOMA_v3", 1, shift);
   return (tmp);
}

double gold_rsioma_up(string symbol, int timeframe, int shift)
{
   double tmp;
   tmp = iCustom(symbol, timeframe, "RSIOMA_v3", 2, shift);
   return (tmp);
}

double gold_william_percent_range(string symbol, int timeframe, int shift)
{
   double tmp;
   tmp = iCustom(symbol, timeframe, "WPR", 55, 0, shift);
   return (tmp);
}

/*
int instantpip(string symbol, int timeframe, int shift)
{
   string name;
   int num = shift;
   int num1 = shift + 1;
   int num2 = shift + 2;
   if (High[num] <= High[num1] && Low[num] >= Low[num1]
       && smovingaverage > High[num] && smovingaverage > High[num1]
       && Open[num1] > Close[num1]
       && Open[num] < Close[num]
       && Low[num1] < bblower
       ) {
       name = "instantpip_";
       name = StringConcatenate(name, shift);
       createobj(name, OBJ_TEXT, shift, Low[shift], "InstantPipBuy");
       CrossUp[shift] = Low[shift];
      return (1);    
   }
   else if (High[num] <= High[num1] && Low[num] >= Low[num1]
       && smovingaverage < High[num] && smovingaverage < High[num1]
       && Open[num1] < Close[num1]
       && Open[num] > Close[num]
       && High[num1] > bbupper
       ) {
       name = "instantpip_";
       name = StringConcatenate(name, shift);
       createobj(name, OBJ_TEXT, shift, Low[shift], "InstantPipSell");
       CrossDown[shift] = High[shift];
      return (-1);    
   }
   return (0);
}

int trendtradingwithema(string symbol, int timeframe, int shift)
{
   //http://forex-strategies-revealed.com/trendtrading-emas
   string name;
   int num = shift;
   int num1 = shift + 1;
   int num2 = shift + 2;
   if (ema03 > ema05 && ema05 > ema13 && ema13 > ema21 && iadx > 20) { //buy
      if (rsi > 50 && rsi1 < 50) {
         name = "ttebuy_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, Low[shift], "TTE Buy");
         CrossUp[shift] = Low[shift];
         return (1);    
      }
   } else 
   if (ema03 < ema05 && ema05 < ema13 && ema13 < ema21 && iadx > 20) { //sell
      if (rsi < 50 && rsi1 > 50) {
         name = "ttesell_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, Low[shift], "TTE Sell");
         CrossDown[shift] = High[shift];
         return (-1);    
      }   
   }

   return (0);
}

int trendtradingwithema9(string symbol, int timeframe, int shift)
{
   string name;
   int num = shift;
   int num1 = shift + 1;
   int num2 = shift + 2;
   if (ema09 < Low[num] && ema09_1 > Low[num1] && macd > 0 && rsi > 50 && iadxpdx > iadxmdx) { //buy
         name = "ttebuy_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, Low[shift], "TTE Buy");
         CrossUp[shift] = Low[shift];
         return (1); 
   } else 
   if (ema09 > High[num] && ema09_1 < High[num1] && macd < 0 && rsi < 50 && iadxpdx < iadxmdx) { //sell
         name = "ttesell_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, Low[shift], "TTE Sell");
         CrossDown[shift] = High[shift];
         return (-1);  
   }

   return (0);
}
int trendtradingwithmacd(string symbol, int timeframe, int shift)
{
   string name;
   int num = shift;
   int num1 = shift + 1;
   int num2 = shift + 2;
   if (macd > macd1 && rsi > 50 && rsi1 < 50 && iadxpdx > iadxmdx) { //buy
         name = "ttebuy_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, Low[shift], "TTE Buy");
         CrossUp[shift] = Low[shift];
         return (1); 
   } else 
   if (macd < macd1 && rsi < 50 && rsi1 > 50 && iadxpdx < iadxmdx) { //sell
         name = "ttesell_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, Low[shift], "TTE Sell");
         CrossDown[shift] = High[shift];
         return (-1);  
   }

   return (0);
}
int ema(string symbol, int timeframe, int shift)
{
   string name;
   int num = shift;
   int num1 = shift + 1;
   int num2 = shift + 2;
   if (ema200 < ema100 && Open[num] < Close[num] && High[num] > ema100 && Low[num] < ema100 && ema100 > ema100_1
      && ema100_1 > ema100_2 && rsi > rsi1 && squeeze_break > 0// && parabolic < Low[num] && parabolic1 < Low[num1]
      ) { //buy
         name = "emabuy_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, Low[shift], "emabuy");
         CrossUp[shift] = Low[shift];
         return (1); 
   } else 
   if (ema200 > ema100 && Open[num] > Close[num] && High[num] > ema100 && Low[num] < ema100 && ema100 < ema100_1
      && ema100_1 < ema100_2 && rsi < rsi1 && squeeze_break > 0 // && parabolic > High[num] && parabolic1 > High[num1]
   ) { //sell
         name = "emasell_";
         name = StringConcatenate(name, shift);
         createobj(name, OBJ_TEXT, shift, Low[shift], "emasell");
         CrossDown[shift] = High[shift];
         return (-1);  
   }

   return (0);
}
*/
/*

int morning_star(string symbol, int timeframe, int shift)
{
   string name;
   int num = shift;
   int num1 = shift + 1;
   int num2 = shift + 2;
   double body, body1, body2;
   //double ma = double iMA(Symbol(), 0, 20, 0, MODE_SMA, PRICE_CLOSE, num);
   if (Open[num1] > Close[num1]) {
      body = Open[num] - Close[num];
   } else {
      body = Close[num] - Open[num];
   }
   if (Open[num1] > Close[num1]) {
      body1 = Open[num1] - Close[num1];
   } else {
      body1 = Close[num1] - Open[num1];
   }
   if (Open[num2] > Close[num2]) {
      body2 = Open[num2] - Close[num2];
   } else {
      body2 = Close[num2] - Open[num2];
   }
   if (Open[num2] > Close[num2] && Open[num1] <= Close[num2] && Close[num1] <= Close[num2] && Open[num] < Close[num] 
       && Open[num] >= Close[num1] && Open[num] >= Open[num1] && body2 > body1 && body > body1 && body2 > body
       //&& ma > High[num] && ma > High[num1] && ma > High[num2]
       ) {
       name = "morning_star_";
       name = StringConcatenate(name, shift);
       createobj(name, OBJ_TEXT, shift, Low[shift], "Morning Star");
       CrossUp[shift] = Low[shift];
      return (1);    
   }
   return (0);
}


int evening_star(string symbol, int timeframe, int shift)
{
   string name;
   int num = shift;
   int num1 = shift + 1;
   int num2 = shift + 2;
   double body, body1, body2;
   //double ma = double iMA(Symbol(), 0, 20, 0, MODE_SMA, PRICE_CLOSE, num);
   if (Open[num1] > Close[num1]) {
      body = Open[num] - Close[num];
   } else {
      body = Close[num] - Open[num];
   }
   if (Open[num1] > Close[num1]) {
      body1 = Open[num1] - Close[num1];
   } else {
      body1 = Close[num1] - Open[num1];
   }
   if (Open[num2] > Close[num2]) {
      body2 = Open[num2] - Close[num2];
   } else {
      body2 = Close[num2] - Open[num2];
   }
   if (Open[num2] < Close[num2] && Open[num1] >= Close[num2] && Close[num1] >= Close[num2] && Open[num] > Close[num] 
       && Open[num] <= Close[num1] && Open[num] <= Open[num1] && body2 > body1 && body > body1 && body2 > body
       //&& ma < Low[num] && ma < Low[num1] && ma < Low[num2]
       ) {
       name = "morning_star_";
       name = StringConcatenate(name, shift);
       createobj(name, OBJ_TEXT, shift, High[shift], "Evening Star");
       CrossDown[shift] = High[shift];
      return (1);    
   }
   return (0);
}

int bbspecial(string symbol, int timeframe, int shift)
{
   string name;
   int num = shift;
   int num1 = shift + 1;
   int num2 = shift + 2;
   double b1 = iBands(symbol,timeframe,20,2,0,PRICE_CLOSE,MODE_UPPER,num);
   double b2 = iBands(symbol,timeframe,20,2,0,PRICE_CLOSE,MODE_LOWER,num);
   double L_1 = iCustom(symbol, timeframe, "Squeeze_Break", 0, num);
   //Print(shift, ": l1: ", DoubleToStr(L_1, MarketInfo(symbol, MODE_DIGITS))); 
   double ma = double iMA(symbol, timeframe, 20, 0, MODE_SMA, PRICE_CLOSE, num);
   double low[3];
   double high[3];
   high[0] = High[num];
   high[1] = High[num1];
   high[2] = High[num2];
   low[0] = Low[num];
   low[1] = Low[num1];
   low[2] = Low[num2];
   if (
   low[0] > ma && low[1] > ma && low[2] > ma && 
   high[0] < high[1] && high[2] < high[1] 
   && Open[num] > Close[num]
       //&& Open[num1] < Close[num1]
        && Open[num2] < Close[num2]
   && L_1 > 0
   ) {
       name = "bbsell_";
       name = StringConcatenate(name, shift);
       createobj(name, OBJ_TEXT, shift, High[shift], "BBSell");
       CrossDown[shift] = High[shift];
   } else if (
   high[0] < ma && high[1] < ma && high[2] < ma && 
   low[0] > low[1] && low[2] > high[1] 
   && L_1 > 0
   && Open[num] < Close[num]
       //&& Open[num1] > Close[num1] 
       && Open[num2] > Close[num2]
   ) {
       name = "bbbuy_";
       name = StringConcatenate(name, shift);
       createobj(name, OBJ_TEXT, shift, Low[shift], "BBBuy");
       CrossUp[shift] = Low[shift];
   }
}
*/