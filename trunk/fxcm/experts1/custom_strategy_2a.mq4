//+------------------------------------------------------------------+
//|                                            custom_strategy_1.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <custom_currency_fetch.mqh>

double initial[30];
double final[30];
int pd[30];
int pd2[30];
int diff = 50;

//multiple
int diff2[13]={50,100,150,200,250,300,350,400,450,500,750,1000};
double initial2[30][13];
double final2[30][13];
int pd3[30][13];
int pd4[30][13];
string messages2[30][13];
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   custom_init();
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
   custom_start();   
//----
   return(0);
  }
//+------------------------------------------------------------------+

int strategy(string symbol, int number)
{
   multiples(symbol, number);
   /*
   double diffamountbuy = 0;
   double diffamountsell = 0;
   if (!initial[number]) {
      initial[number] = MarketInfo(symbol, MODE_BID);
      final[number] = MarketInfo(symbol, MODE_BID);
      pd[number] = TimeCurrent(); 
   }

   if (MarketInfo(symbol, MODE_BID) > initial[number]) {
      diffamountbuy = (MarketInfo(symbol, MODE_BID) - initial[number]) / MarketInfo(symbol, MODE_POINT);
   } else if (MarketInfo(symbol, MODE_BID) < initial[number]) {
      diffamountsell = (initial[number] - MarketInfo(symbol, MODE_BID)) / MarketInfo(symbol, MODE_POINT);
   }
   
   if (diffamountbuy > diff) {
      final[number] = initial[number];
      pd2[number] = TimeCurrent() - pd[number];
      messages[number] = "Buy";
      initial[number] = MarketInfo(symbol, MODE_BID);
      pd[number] = TimeCurrent(); 
      SendAlert("Buy "+ pd2[number], symbol, 0);
   } else if (diffamountsell > diff) {
      final[number] = initial[number];
      pd2[number] = TimeCurrent() - pd[number];
      messages[number] = "Sell";
      initial[number] = MarketInfo(symbol, MODE_BID);
      pd[number] = TimeCurrent(); 
      SendAlert("Sell " + pd2[number], symbol, 0);
   } 

   infobox = StringConcatenate(infobox, " - final[number]: ", DoubleToStr(final[number], MarketInfo(symbol, MODE_DIGITS)));   
   infobox = StringConcatenate(infobox, " - pd2[number]: ", pd2[number]);  
   infobox = StringConcatenate(infobox, " - diffamountbuy: ", diffamountbuy); 
   infobox = StringConcatenate(infobox, " - diffamountsell: ", diffamountsell);
   infobox = StringConcatenate(infobox, " - Message: ", messages[number]);
   infobox = StringConcatenate(infobox, " - Bid: ", DoubleToStr(MarketInfo(symbol, MODE_BID), MarketInfo(symbol, MODE_DIGITS)));
   infobox = StringConcatenate(infobox, " - Ask: ", DoubleToStr(MarketInfo(symbol, MODE_ASK), MarketInfo(symbol, MODE_DIGITS)));
   infobox = StringConcatenate(infobox, " - initial[number]: ", DoubleToStr(initial[number], MarketInfo(symbol, MODE_DIGITS)));
   */  
}

void multiples(string symbol, int number)
{
   string filename = symbol + "/file_" + Year() + "_" + Month() + "_" + Day()  + ".txt";
   double diffamountbuy = 0;
   double diffamountsell = 0;
   for(int num=0; num < 12; num++) {
      if (!initial2[number][num]) {
         initial2[number][num] = MarketInfo(symbol, MODE_BID);
         final2[number][num] = MarketInfo(symbol, MODE_BID);
         pd3[number][num] = TimeCurrent(); 
         
         FileAppend(filename, "INITIAL DATA: Bid: "
                              + DoubleToStr(initial2[number][num], MarketInfo(symbol, MODE_DIGITS)));
         FileAppend(filename, "Pip Difference: " + diff2[num]);
         FileAppend(filename, "");
      }
      diffamountbuy=0;
      diffamountsell=0;
      if (MarketInfo(symbol, MODE_BID) > initial2[number][num]) {
         diffamountbuy = (MarketInfo(symbol, MODE_BID) - initial2[number][num]) / MarketInfo(symbol, MODE_POINT);
      } else if (MarketInfo(symbol, MODE_BID) < initial[number]) {
         diffamountsell = (initial2[number][num] - MarketInfo(symbol, MODE_BID)) / MarketInfo(symbol, MODE_POINT);
      }
      if (diffamountbuy > diff2[num]) {
         final2[number][num] = initial2[number][num];
         pd4[number][num] = TimeCurrent() - pd3[number][num];
         messages2[number][num] = "Buy";
         initial2[number][num] = MarketInfo(symbol, MODE_BID);
         pd3[number][num] = TimeCurrent(); 
         SendAlert("Buy " + pd4[number][num] + ", " + num, symbol, 0);
         FileAppend(filename, "Initial Bid: " + DoubleToStr(final2[number][num], MarketInfo(symbol, MODE_DIGITS)));
         FileAppend(filename, "New Bid: " + DoubleToStr(initial2[number][num], MarketInfo(symbol, MODE_DIGITS)));
         FileAppend(filename, "Message: " + messages2[number][num]);
         FileAppend(filename, "Required Difference: " + diff2[num]);
         FileAppend(filename, "Actual Difference: " + diffamountbuy);
         FileAppend(filename, "Time Required: " + pd4[number][num]);
         FileAppend(filename, "");
      } else if (diffamountsell > diff2[num]) {
         final2[number][num] = initial2[number][num];
         pd4[number][num] = TimeCurrent() - pd3[number][num];
         messages2[number][num] = "Sell";
         initial2[number][num] = MarketInfo(symbol, MODE_BID);
         pd3[number][num] = TimeCurrent(); 
         SendAlert("Sell " + pd4[number][num] + ", " + num, symbol, 0);
         FileAppend(filename, "Initial Bid: " + DoubleToStr(final2[number][num], MarketInfo(symbol, MODE_DIGITS)));
         FileAppend(filename, "New Bid: " + DoubleToStr(initial2[number][num], MarketInfo(symbol, MODE_DIGITS)));
         FileAppend(filename, "Message: " + messages2[number][num]);
         FileAppend(filename, "Required Difference: " + diff2[num]);
         FileAppend(filename, "Actual Difference: " + diffamountbuy);
         FileAppend(filename, "Time Required: " + pd4[number][num]);
         FileAppend(filename, "");
      } 
   }
}