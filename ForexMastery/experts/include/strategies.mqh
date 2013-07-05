//+------------------------------------------------------------------+
//|                                                   strategies.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

int get_strategy_result(int strategy, string symbol, int period, int shift, int current)
{
   int check = 0;
   int check1 = 0;
   int check2 = 0;
   int check3 = 0;
   int check4 = 0;
   int check5 = 0;
   int check6 = 0;
   switch (strategy)
   {
      case 1:
         //spanAB
         if (current == 1)
            check = s_spanABC(symbol, period, shift);
         else
            check = s_spanAB(symbol, period, shift);
         break;
      case 2:
         //tenkan
         if (current == 1)
            check = s_tenkanC(symbol, period, shift);
         else
            check = s_tenkan(symbol, period, shift);
         break;
      case 3:
         //kijun
         if (current == 1)
         check = s_kijunC(symbol, period, shift);
         else
         check = s_kijun(symbol, period, shift);
         break;
      case 4:
         //macdRshift
         if (current == 1)
         check = s_macdRshiftC(symbol, period, shift);
         else 
         check = s_macdRshift(symbol, period, shift);
         break;
      case 5:
         //macdRChange
         if (current == 1)
         check = s_macdRChangeC(symbol, period, shift);
         else
         check = s_macdRChange(symbol, period, shift);
         break;
      case 6:
         //fisher
         if (current == 1)
         check = s_fisherC(symbol, period, shift);
         else
         check = s_fisher(symbol, period, shift);
         break;
      case 7:
         //heiken
         if (current == 1)
         check = s_heikenC(symbol, period, shift);
         else
         check = s_heiken(symbol, period, shift);
         break;
      case 8:
         //sma 9,50
         if (current == 1)
            check = s_smaC(symbol, period, shift, 9, 50);
         else 
            check = s_sma(symbol, period, shift, 9, 50);
         break;
      case 9:
         //bbtrend
         if (current == 1)
         check = s_bbtrendC(symbol, period, shift);
         else
         check = s_bbtrend(symbol, period, shift);
         break;
      case 10:
         //cobra
         if (current == 1)
         check = s_cobraC(symbol, period, shift);
         else
         check = s_cobra(symbol, period, shift);
         break;
         
      case 11:
         //combo1
         if (current == 1) {
            check1 = s_tenkanC(symbol, period, shift);
            check2 = s_macdRChangeC(symbol, period, shift);
            if (check1 == 1 && check2 == 1) check = 1;
            else if (check1 == -1 && check2 == -1) check = -1;
         } else {
            check1 = s_tenkanC(symbol, period, shift);
            check2 = s_macdRChangeC(symbol, period, shift);
            check3 = s_tenkanC(symbol, period, shift + 1);
            check4 = s_macdRChangeC(symbol, period, shift + 1);
            if (check1 == 1 && check2 == 1 && (check3 != 1 || check4 != 1)) check = 1;
            else if (check1 == -1 && check2 == -1 && (check3 != -1 || check4 != -1)) check = -1;
         }
         break;
      case 12:
         if (current == 1) {
            check1 = s_sma1421(symbol, period, shift);
            check2 = s_macdRshiftC(symbol, period, shift);
            check3 = s_tenkanC(symbol, period, shift);
            if (check1 == 1 && check2 == 1 && check3 == 1) check = 1;
            else if (check1 == -1 && check2 == -1 && check3 == -1) check = -1;
         } else {
            check1 = s_sma1421(symbol, period, shift);
            check2 = s_macdRshiftC(symbol, period, shift);
            check3 = s_tenkanC(symbol, period, shift);
            
            check4 = s_sma1421(symbol, period, shift+1);
            check5 = s_macdRshiftC(symbol, period, shift+1);
            check6 = s_tenkanC(symbol, period, shift+1);
            if ((check1 == 1 && check2 == 1 && check3 == 1) && (check4 == -1 || check5 == -1 || check6 == -1)) check = 1;
            else if ((check1 == -1 && check2 == -1 && check3 == -1) && (check4 == 1 || check5 == 1 || check6 == 1)) check = -1;
         }
         break;
      case 13:
         //combo1
         if (current == 1) {
            check1 = s_spanABC(symbol, period, shift);
            check2 = s_tenkanC(symbol, period, shift);
            if (check1 == 1 && check2 == 1) check = 1;
            else if (check1 == -1 && check2 == -1) check = -1;
         } else {
            check1 = s_spanABC(symbol, period, shift);
            check2 = s_tenkanC(symbol, period, shift);
            check3 = s_spanABC(symbol, period, shift + 1);
            check4 = s_tenkanC(symbol, period, shift + 1);
            if (check1 == 1 && check2 == 1 && (check3 != 1 || check4 != 1)) check = 1;
            else if (check1 == -1 && check2 == -1 && (check3 != -1 || check4 != -1)) check = -1;
         }
         break;
      case 14:
         if (current == 1) {
            check = s_kumoC(symbol, period, shift);
         } else {
            check = s_kumo(symbol, period, shift);
         }
         /*
         //combo1
         if (current == 1) {
            check1 = s_spanABC(symbol, period, shift);
            check2 = s_macdRshiftC(symbol, period, shift);
            if (check1 == 1 && check2 == 1) check = 1;
            else if (check1 == -1 && check2 == -1) check = -1;
         } else {
            check1 = s_spanABC(symbol, period, shift);
            check2 = s_macdRshiftC(symbol, period, shift);
            check3 = s_spanABC(symbol, period, shift + 1);
            check4 = s_macdRshiftC(symbol, period, shift + 1);
            if (check1 == 1 && check2 == 1 && (check3 != 1 || check4 != 1)) check = 1;
            else if (check1 == -1 && check2 == -1 && (check3 != -1 || check4 != -1)) check = -1;
         }
         */
         break;
      case 15:
         if (current == 1)
            check = s_sma2550(symbol, period, shift);
         else {
            check1 = s_sma2550(symbol, period, shift);
            check2 = s_sma2550(symbol, period, shift+1);
            if (check1 == 1 && check2 != 1) check = 1;
            else if (check1 == -1 && check2 != -1) check = -1;
         }
         /*
         if (current == 1) {
            check1 = s_spanABC(symbol, period, shift);
            check2 = s_macdRshiftC(symbol, period, shift);
            check3 = s_tenkanC(symbol, period, shift);
            if (check1 == 1 && check2 == 1 && check3 == 1) check = 1;
            else if (check1 == -1 && check2 == -1 && check3 == -1) check = -1;
         } else {
            check1 = s_spanAB(symbol, period, shift);
            check2 = s_macdRshiftC(symbol, period, shift);
            check3 = s_tenkanC(symbol, period, shift);
            if (check1 == 1 && (check2 == 1 || check3 == 1)) check = 1;
            else if (check1 == -1 && (check2 == -1 || check3 == -1)) check = -1;
         }*/
         break;
      case 16:
         //ma25
         if (current == 1) {
            check = s_sma25C(symbol, period, shift);
         } else {
            check = s_sma25(symbol, period, shift);
         }
         break;
      case 17:
         if (current == 1) {
            check1 = s_spanABC(symbol, period, shift);
            check2 = s_macdRshiftC(symbol, period, shift);
            check3 = s_tenkanC(symbol, period, shift);
            if (check1 == 1 && check2 == 1 && check3 == 1) check = 1;
            else if (check1 == -1 && check2 == -1 && check3 == -1) check = -1;
         } else {
            check1 = s_spanABC(symbol, period, shift);
            check2 = s_macdRshiftC(symbol, period, shift);
            check3 = s_tenkanC(symbol, period, shift);
            
            check4 = s_spanABC(symbol, period, shift+1);
            check5 = s_macdRshiftC(symbol, period, shift+1);
            check6 = s_tenkanC(symbol, period, shift+1);
            if ((check1 == 1 && check2 == 1 && check3 == 1) && (check4 == -1 || check5 == -1 || check6 == -1)) check = 1;
            else if ((check1 == -1 && check2 == -1 && check3 == -1) && (check4 == 1 || check5 == 1 || check6 == 1)) check = -1;
         }
         break;
      case 18:
         //ma50
         if (current == 1) {
            check = s_sma50C(symbol, period, shift);
         } else {
            check = s_sma50(symbol, period, shift);
         }
         break;
      case 19:
         if (current == 1)
            check = s_tenkan_sma(symbol, period, shift);
         else {
            check1 = s_tenkan_sma(symbol, period, shift);
            check2 = s_tenkan_sma(symbol, period, shift+1);
            if (check1 == 1 && check2 != 1) check = 1;
            else if (check1 == -1 && check2 != -1) check = -1;
         }
         break;
      
      case 20:
         //heiken
         if (current == 1)
            check = s_sma9C(symbol, period, shift);
         else
            check = s_sma9(symbol, period, shift);
         break;
      case 21:
         if (current == 1)
            check = s_sma92550(symbol, period, shift);
         else {
            check1 = s_sma92550(symbol, period, shift);
            check2 = s_sma92550(symbol, period, shift+1);
            if (check1 == 1 && check2 != 1) check = 1;
            else if (check1 == -1 && check2 != -1) check = -1;
         }
         break;
      case 22:
         if (current == 1)
            check = s_sma1421(symbol, period, shift);
         else {
            check1 = s_sma1421(symbol, period, shift);
            check2 = s_sma1421(symbol, period, shift+1);
            if (check1 == 1 && check2 != 1) check = 1;
            else if (check1 == -1 && check2 != -1) check = -1;
         }
         break;
      case 23:
         if (current == 1)
            check = s_sma5200C(symbol, period, shift);
         else 
            check = s_sma5200(symbol, period, shift);
         break;
      case 24:
         if (current == 1)
            check = s_sma5500C(symbol, period, shift);
         else 
            check = s_sma5500(symbol, period, shift);
         break;
      case 25:
         if (current == 1)
            check = s_sma51000C(symbol, period, shift);
         else 
            check = s_sma51000(symbol, period, shift);
         break;
      case 26:
         if (current == 1)
            check = s_slopetrendC(symbol, period, shift);
         else 
            check = s_slopetrend(symbol, period, shift);
         break;
      case 27:
         //tenkan
         if (current == 1)
            check = s_chickoC(symbol, period, shift);
         else
            check = s_chicko(symbol, period, shift);
         break;
      case 28:
         if (current == 1)
            check = s_tenkan_sma2(symbol, period, shift);
         else {
            check1 = s_tenkan_sma2(symbol, period, shift);
            check2 = s_tenkan_sma2(symbol, period, shift+1);
            if (check1 == 1 && check2 != 1) check = 1;
            else if (check1 == -1 && check2 != -1) check = -1;
         }
         break;
      default:
         check = 0;
         break;
   }
   return (check);
}

string get_strategy_name(int strategy)
{
   switch (strategy)
   {
      case 1:
         return ("spanAB");
         break;
      case 2:
         return ("tenkan");
         break;
      case 3:
         return ("kijun");
         break;
      case 4:
         return ("macdRshift");
         break;
      case 5:
         return ("macdRChange");
         break;
      case 6:
         return ("fisher");
         break;
      case 7:
         return ("heiken");
         break;
      case 8:
         return ("sma950");
         break;
      case 9:
         return ("bbtrend");
         break;
      case 10:
         return ("cobra");
         break;
      case 11:
         return ("tenkan macdRChange");
         break;
      case 12:
         return ("tenkan macdRShift 1421sma");
         break;
      case 13:
         return ("spanAB tenkan");
         break;
      case 14:
         return ("kumo"); //("spanAB macdRshift");
         break;
      case 15:
         return ("sma 25 50");//return ("spanAB macdRshift tenkan");
         break;
      case 16:
         return ("sma25");
         break;
      case 17:
         return ("spanab macdRshift tenkan");
         break;
      case 18:
         return ("sma50");
         break;
      case 19:
         return ("tenkanKijun sma20");
         break;
      case 20:
         return ("sma9");
         break;
      case 21:
         return ("sma92550");
         break;
      case 22:
         return ("sma1421");
         break;
      case 23:
         return ("sma5200");
         break;
      case 24:
         return ("sma5500");
         break;
      case 25:
         return ("sma51000");
         break;
      case 26:
         return ("slopetrend");
         break;
      case 27:
         return ("chickouspan");
         break;
      case 28:
         return ("tenkan sma20");
         break;
      default:
         return ("");
         break;
   }
   return ("");
}
int stoch_i(string symbol, int period, int shift)
{
   double stoch = iStochastic(symbol,period,14,3,3,MODE_SMA,0,MODE_MAIN,shift);
   if (stoch > 80) {
      return (-1);
   } else if (stoch < 20) {
      return (1);
   }
   return (0);
}
string parse(int type)
{
   switch(type)
   {
      case 1: return ("Buy");
      case -1: return ("Sell");
      case 0: return ("");
   }
}
/*
double percentage(double previousRate, double curRate)
{
   double change = curRate - previousRate;
	
   double div = change / previousRate;
   double perc = div * 100;	
   return (perc);
	
}
int twintower(string symbol, int period, int shift)
{
   
}

int pinbar(string symbol, int period, int shift)
{
   
}

int engulfsmall(string symbol, int period, int shift)
{
   
}
int engulflarge(string symbol, int period, int shift)
{
   
}
*/
int s_cobra(string symbol, int period, int shift)
{
   double ma72h = iMA(symbol,period,72,0,MODE_SMA,PRICE_HIGH,shift);
   double ma72l = iMA(symbol,period,72,0,MODE_SMA,PRICE_LOW,shift);
   
   if (iClose(symbol, period, shift) > ma72h && iOpen(symbol, period, shift) > ma72h 
   && (iClose(symbol, period, shift+1) <= ma72h || iOpen(symbol, period, shift+1) <= ma72h)
      //&& High[i] > High[i+1]
      ) {
      return (1);
   } else if (iClose(symbol, period, shift) < ma72l && iOpen(symbol, period, shift) < ma72l 
      && (iClose(symbol, period, shift+1) >= ma72l || iOpen(symbol, period, shift+1) >= ma72l)
      //&& Low[i] < Low[i+1]
      ) {
      return (-1);
   }
   return (0);
}
int s_sma9(string symbol, int period, int shift)
{
   double ma9 = iMA(symbol,period,9,0,MODE_SMA,PRICE_CLOSE,shift);
   double ma9_2 = iMA(symbol,period,9,0,MODE_SMA,PRICE_CLOSE,shift+1);
   
   if (iClose(symbol, period, shift) > ma9 && iOpen(symbol, period, shift) > ma9 
      && (iClose(symbol, period, shift+1) < ma9_2 || iOpen(symbol, period, shift+1) < ma9_2)) {
      return (1);
   } else if (iClose(symbol, period, shift) < ma9 && iOpen(symbol, period, shift) < ma9 
      && (iClose(symbol, period, shift+1) > ma9_2 || iOpen(symbol, period, shift+1) > ma9_2)) {
      return (-1);
   }
   return (0);
}

int s_sma9C(string symbol, int period, int shift)
{
   double ma9 = iMA(symbol,period,9,0,MODE_SMA,PRICE_CLOSE,shift);
   
   if (iClose(symbol, period, shift) > ma9 && iOpen(symbol, period, shift) > ma9) {
      return (1);
   } else if (iClose(symbol, period, shift) < ma9 && iOpen(symbol, period, shift) < ma9) {
      return (-1);
   }
   return (0);
}


int s_sma25(string symbol, int period, int shift)
{
   double ma9 = iMA(symbol,period,25,0,MODE_SMA,PRICE_CLOSE,shift);
   double ma9_2 = iMA(symbol,period,25,0,MODE_SMA,PRICE_CLOSE,shift+1);
   
   if (iClose(symbol, period, shift) > ma9 && iOpen(symbol, period, shift) > ma9 
      && (iClose(symbol, period, shift+1) < ma9_2 || iOpen(symbol, period, shift+1) < ma9_2)) {
      return (1);
   } else if (iClose(symbol, period, shift) < ma9 && iOpen(symbol, period, shift) < ma9 
      && (iClose(symbol, period, shift+1) > ma9_2 || iOpen(symbol, period, shift+1) > ma9_2)) {
      return (-1);
   }
   return (0);
}

int s_sma25C(string symbol, int period, int shift)
{
   double ma9 = iMA(symbol,period,25,0,MODE_SMA,PRICE_CLOSE,shift);
   
   if (iClose(symbol, period, shift) > ma9 && iOpen(symbol, period, shift) > ma9) {
      return (1);
   } else if (iClose(symbol, period, shift) < ma9 && iOpen(symbol, period, shift) < ma9) {
      return (-1);
   }
   return (0);
}


int s_sma50(string symbol, int period, int shift)
{
   double ma9 = iMA(symbol,period,50,0,MODE_SMA,PRICE_CLOSE,shift);
   double ma9_2 = iMA(symbol,period,50,0,MODE_SMA,PRICE_CLOSE,shift+1);
   
   if (iClose(symbol, period, shift) > ma9 && iOpen(symbol, period, shift) > ma9 
      && (iClose(symbol, period, shift+1) < ma9_2 || iOpen(symbol, period, shift+1) < ma9_2)) {
      return (1);
   } else if (iClose(symbol, period, shift) < ma9 && iOpen(symbol, period, shift) < ma9 
      && (iClose(symbol, period, shift+1) > ma9_2 || iOpen(symbol, period, shift+1) > ma9_2)) {
      return (-1);
   }
   return (0);
}

int s_sma50C(string symbol, int period, int shift)
{
   double ma9 = iMA(symbol,period,50,0,MODE_SMA,PRICE_CLOSE,shift);
   
   if (iClose(symbol, period, shift) > ma9 && iOpen(symbol, period, shift) > ma9) {
      return (1);
   } else if (iClose(symbol, period, shift) < ma9 && iOpen(symbol, period, shift) < ma9) {
      return (-1);
   }
   return (0);
}

int s_sma92550(string symbol, int period, int shift)
{
   double ma25 = iMA(symbol,period,25,0,MODE_SMA,PRICE_CLOSE,shift);
   double ma50 = iMA(symbol,period,50,0,MODE_SMA,PRICE_CLOSE,shift);
   
   if (ma25 > ma50) {
      return (1);
   } else if (ma25 < ma50) {
      return (-1);
   }
   return (0);
}
int s_sma2550(string symbol, int period, int shift)
{
   double ma25 = iMA(symbol,period,25,0,MODE_SMA,PRICE_CLOSE,shift);
   double ma50 = iMA(symbol,period,50,0,MODE_SMA,PRICE_CLOSE,shift);
   
   if (ma25 < iClose(symbol, period, shift) && ma50 < iClose(symbol, period, shift)
      && (ma25 < iOpen(symbol, period, shift) || ma50 < iOpen(symbol, period, shift))
      ) {
      return (1);
   } else if (ma25 > iClose(symbol, period, shift) && ma50 > iClose(symbol, period, shift)
      && (ma25 > iOpen(symbol, period, shift) || ma50 > iOpen(symbol, period, shift))
      ) {
      return (-1);
   }
   return (0);
}
int s_sma1421(string symbol, int period, int shift)
{
   double ma25 = iMA(symbol,period,14,0,MODE_SMA,PRICE_CLOSE,shift);
   double ma50 = iMA(symbol,period,21,0,MODE_SMA,PRICE_CLOSE,shift);
   
   if (ma25 > ma50) {
      return (1);
   } else if (ma25 < ma50) {
      return (-1);
   }
   return (0);
}


int s_sma5200(string symbol, int period, int shift)
{
   double ma5 = iMA(symbol,period,5,0,MODE_SMA,PRICE_CLOSE,shift);
   double ma200 = iMA(symbol,period,200,0,MODE_SMA,PRICE_CLOSE,shift);
   double ma52 = iMA(symbol,period,5,0,MODE_SMA,PRICE_CLOSE,shift+1);
   double ma2002 = iMA(symbol,period,200,0,MODE_SMA,PRICE_CLOSE,shift+1);
   
   if (ma5 > ma200 && ma52 < ma2002) {
      return (1);
   } else if (ma5 < ma200 && ma52 > ma2002) {
      return (-1);
   }
   return (0);
}

int s_sma5200C(string symbol, int period, int shift)
{
   double ma5 = iMA(symbol,period,5,0,MODE_SMA,PRICE_CLOSE,shift);
   double ma200 = iMA(symbol,period,200,0,MODE_SMA,PRICE_CLOSE,shift);
   
   if (ma5 > ma200) {
      return (1);
   } else if (ma5 < ma200) {
      return (-1);
   }
   return (0);
}



int s_sma5500(string symbol, int period, int shift)
{
   double ma5 = iMA(symbol,period,5,0,MODE_SMA,PRICE_CLOSE,shift);
   double ma200 = iMA(symbol,period,500,0,MODE_SMA,PRICE_CLOSE,shift);
   double ma52 = iMA(symbol,period,5,0,MODE_SMA,PRICE_CLOSE,shift+1);
   double ma2002 = iMA(symbol,period,500,0,MODE_SMA,PRICE_CLOSE,shift+1);
   
   if (ma5 > ma200 && ma52 < ma2002) {
      return (1);
   } else if (ma5 < ma200 && ma52 > ma2002) {
      return (-1);
   }
   return (0);
}

int s_sma5500C(string symbol, int period, int shift)
{
   double ma5 = iMA(symbol,period,5,0,MODE_SMA,PRICE_CLOSE,shift);
   double ma200 = iMA(symbol,period,500,0,MODE_SMA,PRICE_CLOSE,shift);
   
   if (ma5 > ma200) {
      return (1);
   } else if (ma5 < ma200) {
      return (-1);
   }
   return (0);
}



int s_sma51000(string symbol, int period, int shift)
{
   double ma5 = iMA(symbol,period,5,0,MODE_SMA,PRICE_CLOSE,shift);
   double ma200 = iMA(symbol,period,1000,0,MODE_SMA,PRICE_CLOSE,shift);
   double ma52 = iMA(symbol,period,5,0,MODE_SMA,PRICE_CLOSE,shift+1);
   double ma2002 = iMA(symbol,period,1000,0,MODE_SMA,PRICE_CLOSE,shift+1);
   
   if (ma5 > ma200 && ma52 < ma2002) {
      return (1);
   } else if (ma5 < ma200 && ma52 > ma2002) {
      return (-1);
   }
   return (0);
}

int s_sma51000C(string symbol, int period, int shift)
{
   double ma5 = iMA(symbol,period,5,0,MODE_SMA,PRICE_CLOSE,shift);
   double ma200 = iMA(symbol,period,1000,0,MODE_SMA,PRICE_CLOSE,shift);
   
   if (ma5 > ma200) {
      return (1);
   } else if (ma5 < ma200) {
      return (-1);
   }
   return (0);
}


int s_tenkan_sma(string symbol, int period, int shift)
{
   double ma = iMA(symbol,period,20,0,MODE_SMA,PRICE_TYPICAL,shift);
   double tenkan_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_TENKANSEN, shift);
   double kijun_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, shift);
   if (iClose(symbol, period, shift) > ma && iClose(symbol, period, shift) > tenkan_sen_1
    && iClose(symbol, period, shift) > kijun_sen_1
      ) {
      return (1);
   } else if (iClose(symbol, period, shift) < ma && iClose(symbol, period, shift) < tenkan_sen_1
    && iClose(symbol, period, shift) < kijun_sen_1
      ) {
      return (-1);
   }
   return (0);
}


int s_tenkan_sma2(string symbol, int period, int shift)
{
   double ma = iMA(symbol,period,20,0,MODE_SMA,PRICE_TYPICAL,shift);
   double tenkan_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_TENKANSEN, shift);
   double kijun_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, shift);
   if (iClose(symbol, period, shift) > ma && iClose(symbol, period, shift) > tenkan_sen_1
      ) {
      return (1);
   } else if (iClose(symbol, period, shift) < ma && iClose(symbol, period, shift) < tenkan_sen_1
      ) {
      return (-1);
   }
   return (0);
}


int s_kumo(string symbol, int period, int shift)
{
   double spanA = iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANA, shift);
   double spanB = iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANB, shift);
   double spanhigh, spanlow;
   if (spanA > spanB) {
      spanhigh = spanA;
      spanlow = spanB;
   } else {
      spanhigh = spanB;
      spanlow = spanA;
   }
   
   double spanA2 = iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANA, shift+1);
   double spanB2 = iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANB, shift+1);
   double spanhigh2, spanlow2;
   if (spanA2 > spanB2) {
      spanhigh2 = spanA2;
      spanlow2 = spanB2;
   } else {
      spanhigh2 = spanB2;
      spanlow2 = spanA2;
   }
   if (iClose(symbol, period, shift) > spanhigh && iClose(symbol, period, shift+1) <= spanhigh2) {
      return (1);
   } else if (iClose(symbol, period, shift) < spanlow && iClose(symbol, period, shift+1) >= spanlow2) {
      return (-1);
   }
   return (0);
}


int s_kumoC(string symbol, int period, int shift)
{
   double spanA = iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANA, shift);
   double spanB = iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANB, shift);
   double spanhigh, spanlow;
   if (spanA > spanB) {
      spanhigh = spanA;
      spanlow = spanB;
   } else {
      spanhigh = spanB;
      spanlow = spanA;
   }
   
   if (iClose(symbol, period, shift) > spanhigh) {
      return (1);
   } else if (iClose(symbol, period, shift) < spanlow) {
      return (-1);
   }
   return (0);
}

int s_cobraC(string symbol, int period, int shift)
{
   double ma72h = iMA(symbol,period,72,0,MODE_SMA,PRICE_HIGH,shift);
   double ma72l = iMA(symbol,period,72,0,MODE_SMA,PRICE_LOW,shift);
   
   if (iClose(symbol, period, shift) > ma72h && iOpen(symbol, period, shift) > ma72h
      ) {
      return (1);
   } else if (iClose(symbol, period, shift) < ma72l && iOpen(symbol, period, shift) < ma72l 
      ) {
      return (-1);
   }
   return (0);
}


int s_bbtrend(string symbol, int period, int shift)
{
   double val3 = iCustom(symbol, period, "Bollinger Bands_Stop_v2 ", 20, 1, 1.0, 1, 1, 1000, false, 4, shift);
   double val4 = iCustom(symbol, period, "Bollinger Bands_Stop_v2 ", 20, 1, 1.0, 1, 1, 1000, false, 5, shift);
   int current = 0;
   if (val3 == EMPTY_VALUE) current = -1;
   else if (val4 == EMPTY_VALUE) current = 1;
   double val3a = iCustom(symbol, period, "Bollinger Bands_Stop_v2 ", 20, 1, 1.0, 1, 1, 1000, false, 4, shift+1);
   double val4a = iCustom(symbol, period, "Bollinger Bands_Stop_v2 ", 20, 1, 1.0, 1, 1, 1000, false, 5, shift+1);
   int past = 0;
   if (val3a == EMPTY_VALUE) past = -1;
   else if (val4a == EMPTY_VALUE) past = 1;
   if (past != 1 && current == 1) return (1);
   else if (past != -1 && current == -1) return (-1);
   return (0);
}
int s_bbtrendC(string symbol, int period, int shift)
{
   double val3 = iCustom(symbol, period, "Bollinger Bands_Stop_v2 ", 20, 1, 1.0, 1, 1, 1000, false, 4, shift);
   double val4 = iCustom(symbol, period, "Bollinger Bands_Stop_v2 ", 20, 1, 1.0, 1, 1, 1000, false, 5, shift);
   if (val3 == EMPTY_VALUE) return (-1);
   else if (val4 == EMPTY_VALUE) return (1);
   return (0);
}

int s_sar(string symbol, int period, int shift)
{
   double val2 = iSAR(symbol,period,0.02,0.2,shift);
   double val3 = iSAR(symbol,period,0.02,0.2,shift+1);
         
   if (val2 < iOpen(symbol, period, shift) && val3 > iOpen(symbol, period, shift+1)) {
      return (1);
   } else if (val2 > iOpen(symbol, period, shift) && val3 < iOpen(symbol, period, shift+1)) {
      return (-1);
   }

   return (0);
}

int s_sarC(string symbol, int period, int shift)
{
   double val2 = iSAR(symbol,period,0.02,0.2,shift);
         
   if (val2 < iOpen(symbol, period, shift)) {
      return (1);
   } else if (val2 > iOpen(symbol, period, shift)) {
      return (-1);
   }

   return (0);
}

int s_chicko(string symbol, int period, int shift)
{
   double chinkou=iIchimoku(symbol, period, 9, 26, 52, MODE_CHINKOUSPAN, shift+26);
   double chinkou2=iIchimoku(symbol, period, 9, 26, 52, MODE_CHINKOUSPAN, shift+27);
         
   if (chinkou > iClose(symbol, period, shift+26) && chinkou > iOpen(symbol, period, shift+26)
      && (chinkou2 < iClose(symbol, period, shift+27) || chinkou2 < iOpen(symbol, period, shift+27))
      ) {
      return (1);
   } else if (chinkou < iClose(symbol, period, shift+26) && chinkou < iOpen(symbol, period, shift+26)
      && (chinkou2 > iClose(symbol, period, shift+27) || chinkou2 > iOpen(symbol, period, shift+27))) {
      return (-1);
   }

   return (0);
}
int s_tenkan(string symbol, int period, int shift)
{
   double tenkan_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_TENKANSEN, shift);
   double kijun_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, shift);
   double tenkan_sen_2=iIchimoku(symbol, period, 9, 26, 52, MODE_TENKANSEN, shift+1);
   double kijun_sen_2=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, shift+1);
         
   if (tenkan_sen_1 > kijun_sen_1 && tenkan_sen_2 <= kijun_sen_2) {// && tenkan_sen_1 < iClose(symbol, period, shift)
      return (1);
   } else if (tenkan_sen_1 < kijun_sen_1 && tenkan_sen_2 >= kijun_sen_2) {// && tenkan_sen_1 > iClose(symbol, period, shift)
      return (-1);
   }

   return (0);
}

int s_spanAB(string symbol, int period, int shift)
{
   double spanA_1 =iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANA, shift-26);
   double spanB_1=iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANB, shift-26);
   double spanA_2 =iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANA, shift-25);
   double spanB_2=iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANB, shift-25);
         
   if (spanA_1 > spanB_1 && spanA_2 <= spanB_2) {
      return (1);
   } else if (spanA_1 < spanB_1 && spanA_2 >= spanB_2) {
      return (-1);
   }

   return (0);
}

int s_kijun(string symbol, int period, int shift)
{
   double kijun_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, shift);
   double kijun_sen_2=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, shift+1);
         
   if (iOpen(symbol, period, shift) > kijun_sen_1 && iClose(symbol, period, shift) > kijun_sen_1
      && (iOpen(symbol, period, shift+1) <= kijun_sen_2 || iClose(symbol, period, shift+1) <= kijun_sen_2)
      ) {
      return (1);
   } else if (iOpen(symbol, period, shift) < kijun_sen_1 && iClose(symbol, period, shift) < kijun_sen_1
      && (iOpen(symbol, period, shift+1) >= kijun_sen_2 || iClose(symbol, period, shift+1) >= kijun_sen_2)
      ) {
      return (-1);
   }

   return (0);
}


int s_heiken(string symbol, int period, int shift)
{
   double val2 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,shift);
   double val3 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,shift);
   double val6 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,shift+1);
   double val7 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,shift+1);
         
   if (val2 < val3 && val6 > val7) {
      return (1);
   } else if (val2 > val3 && val6 < val7) {
      return (-1);
   }

   return (0);
}

int s_fisher(string symbol, int period, int shift)
{
   double val2 = iCustom(symbol, period, "Fisher_no_repainting", 30, 0, shift);
   double val3 = iCustom(symbol, period, "Fisher_no_repainting", 30, 0, shift+1);
   if (val2 > 0 && val3 < 0) {
      return (1);
   } else if (val2 < 0 && val3 > 0) {
      return (-1);
   }

   return (0);
}
int s_macdRshift(string symbol, int period, int shift)
{
      double MacdCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,shift);
      double MacdPrevious=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,shift+1);
      double SignalCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_SIGNAL,shift);
      double SignalPrevious=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_SIGNAL,shift+1);
         
   if (MacdCurrent > SignalCurrent && MacdPrevious < SignalPrevious) {
      return (1);
   } else if (MacdCurrent < SignalCurrent && MacdPrevious > SignalPrevious) {
      return (-1);
   }

   return (0);
}
int s_macdRChange(string symbol, int period, int shift)
{
      double MacdCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,shift);
      double MacdPrevious=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,shift+1);
         
   if (MacdCurrent > 0 && MacdPrevious < 0) {
      return (1);
   } else if (MacdCurrent < 0 && MacdPrevious > 0) {
      return (-1);
   }

   return (0);
}

//---------------------------
int s_tenkanC(string symbol, int period, int shift)
{
   double tenkan_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_TENKANSEN, shift);
   double kijun_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, shift);
         
   if (tenkan_sen_1 > kijun_sen_1) {
      return (1);
   } else if (tenkan_sen_1 < kijun_sen_1) {
      return (-1);
   }

   return (0);
}

int s_chickoC(string symbol, int period, int shift)
{
   double chinkou=iIchimoku(symbol, period, 9, 26, 52, MODE_CHINKOUSPAN, shift+26);
         
   if (chinkou > iClose(symbol, period, shift+26) && chinkou > iOpen(symbol, period, shift+26)) {
      return (1);
   } else if (chinkou < iClose(symbol, period, shift+26) && chinkou < iOpen(symbol, period, shift+26)) {
      return (-1);
   }

   return (0);
}

int s_spanABC(string symbol, int period, int shift)
{
   double spanA_1 =iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANA, shift-26);
   double spanB_1=iIchimoku(symbol, period, 9, 26, 52, MODE_SENKOUSPANB, shift-26);
         
   if (spanA_1 > spanB_1) {
      return (1);
   } else if (spanA_1 < spanB_1) {
      return (-1);
   }

   return (0);
}

int s_kijunC(string symbol, int period, int shift)
{
   double kijun_sen_1=iIchimoku(symbol, period, 9, 26, 52, MODE_KIJUNSEN, shift);
         
   if (iOpen(symbol, period, shift) > kijun_sen_1 && iClose(symbol, period, shift) > kijun_sen_1
      ) {
      return (1);
   } else if (iOpen(symbol, period, shift) < kijun_sen_1 && iClose(symbol, period, shift) < kijun_sen_1
      ) {
      return (-1);
   }

   return (0);
}


int s_heikenC(string symbol, int period, int shift)
{
   double val2 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",2,shift);
   double val3 = iCustom(symbol, period, "Heiken_Ashi_Smoothed",3,shift);
         
   if (val2 < val3) {
      return (1);
   } else if (val2 > val3) {
      return (-1);
   }

   return (0);
}

int s_fisherC(string symbol, int period, int shift)
{
   double val2 = iCustom(symbol, period, "Fisher_no_repainting", 30, 0, shift);
   if (val2 > 0) {
      return (1);
   } else if (val2 < 0) {
      return (-1);
   }

   return (0);
}
int s_macdRshiftC(string symbol, int period, int shift)
{
      double MacdCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,shift);
      double SignalCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_SIGNAL,shift);
         
   if (MacdCurrent > SignalCurrent) {
      return (1);
   } else if (MacdCurrent < SignalCurrent) {
      return (-1);
   }

   return (0);
}
int s_macdRChangeC(string symbol, int period, int shift)
{
      double MacdCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,shift);
      double MacdPrevious=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,shift+1);
         
   if (MacdCurrent > 0) {
      return (1);
   } else if (MacdCurrent < 0) {
      return (-1);
   }

   return (0);
}


int envelopeC(string symbol, int period, int shift)
{
   double enu = iEnvelopes(symbol,period, 14, MODE_SMA, 0, PRICE_CLOSE, 0.5, MODE_UPPER, shift);
   double enl = iEnvelopes(symbol,period, 14, MODE_SMA, 0, PRICE_CLOSE, 0.5, MODE_LOWER, shift);
   if (iLow(symbol, period, shift) < enl) {
      return (1);
   } else if (iHigh(symbol, period, shift) > enu) {
      return (-1);
   }
   return (0);

}



int s_smaHL(string symbol, int period, int shift, int p1, int p2)
{
   double ma5H = iMA(symbol,period,p1,0,MODE_SMA,PRICE_HIGH,shift);
   double ma5L = iMA(symbol,period,p1,0,MODE_SMA,PRICE_LOW,shift);
   double ma200H = iMA(symbol,period,p2,0,MODE_SMA,PRICE_HIGH,shift);
   double ma200L = iMA(symbol,period,p2,0,MODE_SMA,PRICE_LOW,shift);
   double ma52H = iMA(symbol,period,p1,0,MODE_SMA,PRICE_HIGH,shift+1);
   double ma52L = iMA(symbol,period,p1,0,MODE_SMA,PRICE_LOW,shift+1);
   double ma2002H = iMA(symbol,period,p2,0,MODE_SMA,PRICE_HIGH,shift+1);
   double ma2002L = iMA(symbol,period,p2,0,MODE_SMA,PRICE_LOW,shift+1);
   
   if (ma5L > ma200H && ma52L < ma2002H) {
      return (1);
   } else if (ma5H < ma200L && ma52H > ma2002L) {
      return (-1);
   }
   return (0);
}



int s_smaHLC(string symbol, int period, int shift, int p1, int p2)
{
   double ma5H = iMA(symbol,period,p1,0,MODE_SMA,PRICE_HIGH,shift);
   double ma5L = iMA(symbol,period,p1,0,MODE_SMA,PRICE_LOW,shift);
   double ma200H = iMA(symbol,period,p2,0,MODE_SMA,PRICE_HIGH,shift);
   double ma200L = iMA(symbol,period,p2,0,MODE_SMA,PRICE_LOW,shift);
   
   if (ma5L > ma200H) {
      return (1);
   } else if (ma5L < ma200H) {
      return (-1);
   }
   return (0);
}


int s_sma(string symbol, int period, int shift, int p1, int p2)
{
   double ma5 = iMA(symbol,period,p1,0,MODE_SMA,PRICE_CLOSE,shift);
   double ma200 = iMA(symbol,period,p2,0,MODE_SMA,PRICE_CLOSE,shift);
   double ma52 = iMA(symbol,period,p1,0,MODE_SMA,PRICE_CLOSE,shift+1);
   double ma2002 = iMA(symbol,period,p2,0,MODE_SMA,PRICE_CLOSE,shift+1);
   
   if (ma5 > ma200 && ma52 < ma2002) {
      return (1);
   } else if (ma5 < ma200 && ma52 > ma2002) {
      return (-1);
   }
   return (0);
}



int s_smaC(string symbol, int period, int shift, int p1, int p2)
{
   double ma5 = iMA(symbol,period,p1,0,MODE_SMA,PRICE_CLOSE,shift);
   double ma200 = iMA(symbol,period,p2,0,MODE_SMA,PRICE_CLOSE,shift);
   
   if (ma5 > ma200) {
      return (1);
   } else if (ma5 < ma200) {
      return (-1);
   }
   return (0);
}


int s_slopetrend(string symbol, int period, int shift)
{
   double up = iCustom(symbol, period, "Slope Direction Line", 0, shift);
   double up1 = iCustom(symbol, period, "Slope Direction Line", 0, shift+1);
   double down = iCustom(symbol, period, "Slope Direction Line", 1, shift);
   double down1 = iCustom(symbol, period, "Slope Direction Line", 1, shift+1);
   if (up > 0 && up != EMPTY_VALUE && down == EMPTY_VALUE && down1 != EMPTY_VALUE ) {
      return (1);
   } else if (down > 0 && down != EMPTY_VALUE && up == EMPTY_VALUE && up1 != EMPTY_VALUE ) {
      return (-1);
   }

   return (0);
}

int s_slopetrendC(string symbol, int period, int shift)
{
   double up = iCustom(symbol, period, "Slope Direction Line", 0, shift);
   double down = iCustom(symbol, period, "Slope Direction Line", 1, shift);
   if (up > 0 && down == EMPTY_VALUE) {
      return (1);
   } else if (down > 0 && up == EMPTY_VALUE) {
      return (-1);
   }

   return (0);
}

