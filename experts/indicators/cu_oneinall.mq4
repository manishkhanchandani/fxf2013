//+------------------------------------------------------------------+
//|                                                  cu_oneinall.mq4 |
//|                                              Manish Khanchandani |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://forexmastery.org"

#property indicator_chart_window
#include <3_signal_inc.mqh>


int positionX[8];
int positionY[8];

   int curPositionX[8][8];
   int curPositiony[8][8];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   deleteobject();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   deleteobject();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   heading();
   getallinfo();
   string name;
   
   int i, x, y;
   y = 40;
   int tmp = 75;
   color colors;
   for (i = 0; i< PAIRSIZE; i++) {
      x = tmp * (i + 1);
      name = "points_"+aMajor[i];
      ObjectDelete(name);
      if (aMeter[i] > 6) colors = Blue;
      else if (aMeter[i] < 3) colors = Red;
      else colors = Yellow;
      create_label_v2(name, x, y, DoubleToStr(aMeter[i], 1), colors, 0);
   }
   string symbol;
   string current_currency1, current_currency2;
   int z;
   int m1, m2;
   int j;
   for (j = 0; j < ARRSIZE; j++) {
      symbol = aPair[j];
      current_currency1 = StringSubstr(symbol, 0, 3);
      current_currency2 = StringSubstr(symbol, 3, 3);
      m1 = 0;
      m2 = 0;
      x = -1;
      y = -1;
      for (z=0; z < PAIRSIZE; z++) {
            if (current_currency1 == aMajor[z] && aMeter[z] > 6) {
               m1 = 1;
            } else if (current_currency1 == aMajor[z] && aMeter[z] < 3) {
               m1 = -1;
            } else if (current_currency2 == aMajor[z] && aMeter[z] > 6) {
               m2 = 1;
            } else if (current_currency2 == aMajor[z] && aMeter[z] < 3) {
               m2 = -1;
            } 
            if (current_currency1 == aMajor[z]) {
               x = z;
            } else if (current_currency2 == aMajor[z]) {
               y = z;
            }    
      }
      /*name = "cur_"+j;
      ObjectDelete(name);
         if (m1 == 1 && m2 == -1) {
            create_arrow(name, positionX[x], positionY[y], 1);
         } else if (m1 == -1 && m2 == 1) {
            create_arrow(name, positionX[x], positionY[y], -1);
         } else {
            create_arrow(name, positionX[x], positionY[y], 0);
         }*/
   }

   int m,n;
   int m_inc, n_inc;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   curPositionX[EUR][USD] = 150; curPositiony[EUR][USD] = 100;
   for (x = 0; x < PAIRSIZE; x++) {
      for (y = 0; y < PAIRSIZE; y++) {
         name = "pair3_"+x+"_"+y;
         ObjectDelete(name);
         if (x == y) continue;
         create_label_v2(name, positionX[x], positionY[y], positionX[x]+","+positionY[y], White, 0);//aMajor[x] + "/" + aMajor[y] + ","+
      }
   }
   
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

int deleteobject()
{
   string name;
   
   for (int j = 0; j < ARRSIZE; j++) {
      name = "cur_"+j;
      ObjectDelete(name);
   }
   for (int i = 0; i< PAIRSIZE; i++) {
      name = "pair_"+aMajor[i];
      ObjectDelete(name);
      name = "pair2_"+aMajor[i];
      ObjectDelete(name);
      name = "points_"+aMajor[i];
      ObjectDelete(name);
   }
}
int heading()
{
   string name;
   int i, x, y;
   y = 20;
   int tmp = 75;
   for (i = 0; i< PAIRSIZE; i++) {
      x = tmp * (i + 1);
      positionX[i] = x;
      name = "pair_"+aMajor[i];
      create_label_v2(name, x, y, aMajor[i], White, 0);
   }
   x = 20;
   tmp = 40;
   y = tmp + 20;
   for (i = 0; i< PAIRSIZE; i++) {
      y = y + tmp;
      positionY[i] = y;
      name = "pair2_"+aMajor[i];
      create_label_v2(name, x, y, aMajor[i], White, 0);
   }
}