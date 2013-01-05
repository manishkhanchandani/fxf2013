//+------------------------------------------------------------------+
//|                                                strengthmeter.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <3_signal_inc.mqh>

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
   infobox = "\n";
   getallinfo();
   string symbol;
   string testbox;
   for (int x = 0; x < ARRSIZE; x++) {
      symbol = aPair[x];
      getallinfoorders(symbol, x);
      getallinfoSingle(symbol);
      infobox = infobox + "\nSymbol: "+ symbol + ", aLookupSingle: " +aLookupSingle + ", aStrengthSingle: " + aStrengthSingle;
   }
   Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+


int getallinfoorders(string symbol, int x)
{
   double top = 5.9;
   double bottom = 2.1;
   double middlebottom = 4;
   double middletop = 4.5;
   int meter_direction;
   string current_currency1 = StringSubstr(symbol, 0, 3);
   string current_currency2 = StringSubstr(symbol, 3, 3);
   //meter_direction
   /*string strength = "\nCurrent Meter: USD: " + aMeter[USD] + ", EUR: " + aMeter[EUR] + "\nGBP: " + aMeter[GBP]
         + ", CHF: " + aMeter[CHF] + "\nCAD: " + aMeter[CAD] + ", AUD: " + aMeter[AUD]
          + "\nJPY: " + aMeter[JPY] + ", NZD: " + aMeter[NZD];
   infobox = infobox + strength;*/
   int m1 = 0;
   int m2 = 0;
   int m3 = 0;
   int m4 = 0;
   double tp, bt;
   for (int z=0; z < PAIRSIZE; z++) {
      if (current_currency1 == aMajor[z] && aMeter[z] > top) {
         m1 = 1;
         tp = aMeter[z];
      } else if (current_currency1 == aMajor[z] && aMeter[z] < bottom) {
         m1 = -1;
         bt = aMeter[z];
      } else if (current_currency2 == aMajor[z] && aMeter[z] > top) {
         m2 = 1;
         tp = aMeter[z];
      } else if (current_currency2 == aMajor[z] && aMeter[z] < bottom) {
         m2 = -1;
         bt = aMeter[z];
      } else if (current_currency1 == aMajor[z] && aMeter[z] <= middletop && aMeter[z] >= middlebottom) {
         m3 = 1;
      } else if (current_currency2 == aMajor[z] && aMeter[z] <= middletop && aMeter[z] >= middlebottom) {
         m4 = 1;
      }
   }
   meter_direction = 0;


   if (m1 == 1 && m2 == -1) { // buy
      
      infobox = infobox + "\nBUY ORDER - Currency 1: " + current_currency1 + ", Currency 2: " + current_currency2;
      infobox = infobox + "\nm1: " + m1 + ", m2: " + m2 + ", m3: " + m3 + ", m4: " + m4 + "\n";
      
   } else if (m1 == -1 && m2 == 1) { //sell
      
      infobox = infobox + "\nBUY ORDER - Currency 1: " + current_currency1 + ", Currency 2: " + current_currency2;
      infobox = infobox + "\nm1: " + m1 + ", m2: " + m2 + ", m3: " + m3 + ", m4: " + m4 + "\n";
   }
      
}