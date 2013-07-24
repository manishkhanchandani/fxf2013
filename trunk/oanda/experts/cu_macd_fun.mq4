//+------------------------------------------------------------------+
//|                                                  cu_macd_fun.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"


#include <3_signal_inc.mqh>
int stime;

int FastEMA=12;
int SlowEMA=26;
int SignalSMA=9;


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
int macdfun[28][5];
int start()
  {
//----
   infobox = "";
   int x;
   int period = Period();
   string symbol;
   int periods[7] = {PERIOD_D1, PERIOD_H4, PERIOD_H1, PERIOD_M30, PERIOD_M15, PERIOD_M5, PERIOD_M1};
   string tmpbox;
   for (x = 0; x < ARRSIZE; x++) {
         tmpbox = "             ";
         symbol = aPair[x];
         if (symbol != Symbol()) {
            continue;
         }
         
         infobox = infobox + "\nSymbol: " + symbol;
            //double macd = iMA(symbol, period,FastEMA,0,MODE_EMA,PRICE_CLOSE,1);
            //double macd2=iMA(symbol, period,SlowEMA,0,MODE_EMA,PRICE_CLOSE,1);
            //double macddiff = macd - macd2;
            double MacdCurrent=iMACD(symbol,period,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
            infobox = infobox + ", MacdCurrent: " + MacdCurrent;
            if ((MacdCurrent > 0 && MacdCurrent < 0.005)) {
               macdfun[x][0] = 1;
            } else if ((MacdCurrent < 0 && MacdCurrent > -0.005)) {
               macdfun[x][0] = -1;
            }
            infobox = infobox + ", macdfun[x][0]: " + macdfun[x][0];
            int heiken = heikenCurrentshift(symbol, period, 0);
            infobox = infobox + ", heiken: " + heiken;
            if (macdfun[x][0] == 1 && MacdCurrent > 0.005 && heiken == 1) {
               infobox = infobox + ", Buy Signal, (Exit Sell and Enter Buy)";
            } else if (macdfun[x][0] == -1 && MacdCurrent < -0.005 && heiken == -1) {
               infobox = infobox + ", Sell Signal, (Exit Buy and Enter Sell)";
            }
         
   }
   Comment(infobox);
//----
   return(0);
  }
//+------------------------------------------------------------------+


extern bool tradefigure1=true;
extern bool tradefigure2=true;
extern bool tradefigure3=true;
extern bool tradefigure4=true;
extern int macdfast=12;
extern int macdslow=26;
extern int macdsma=1;
extern bool macdlevelfilter=true;
extern double macdlevel=0;
int cnt;  
int macdDiv()
{
   double divdownfollow=0;
   
   int barddfmacdbar=0;
   double barddfmacd=0;
   double barddfmacdprice=0;
   for(cnt=1;cnt<=1;cnt++){
      if(barddfmacdbar!=0)continue;
      if(iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt)<iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1)
      && iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1)>iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+2)
      && (macdlevelfilter==false || (macdlevelfilter && iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1)>macdlevel))){
         barddfmacd=iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1);
         barddfmacdprice=High[cnt+1];
         barddfmacdbar=cnt+1;
      }
   }
   int barddfmacdbar2=0;
   double barddfmacd2=0;
   double barddfmacdprice2=0;
   for(cnt=barddfmacdbar;cnt<100;cnt++){
      if(barddfmacdbar!=0 && barddfmacd2<barddfmacd && barddfmacdprice2>barddfmacdprice){divdownfollow=1;continue;}
      if(iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt)<iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1)
      && iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1)>iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+2)
      && (macdlevelfilter==false || (macdlevelfilter && iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1)>macdlevel))){
         barddfmacd2=iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1);
         barddfmacdprice2=High[cnt+1];
         barddfmacdbar2=cnt+1;
      }
   }

   double divdupfollow=0;
   
   int barddfmacdbar3=0;
   double barddfmacd3=0;
   double barddfmacdprice3=0;
   for(cnt=1;cnt<=1;cnt++){
      if(barddfmacdbar3!=0)continue;
      if(iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt)>iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1)
      && iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1)<iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+2)
      && (macdlevelfilter==false || (macdlevelfilter && iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1)<macdlevel))){
         barddfmacd3=iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1);
         barddfmacdprice3=Low[cnt+1];
         barddfmacdbar3=cnt+1;
      }
   }
   int barddfmacdbar4=0;
   double barddfmacd4=0;
   double barddfmacdprice4=0;
   for(cnt=barddfmacdbar;cnt<100;cnt++){
      if(barddfmacdbar3!=0 && barddfmacd4>barddfmacd3 && barddfmacdprice4<barddfmacdprice3){divdupfollow=1;continue;}
      if(iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt)>iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1)
      && iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1)<iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+2)
      && (macdlevelfilter==false || (macdlevelfilter && iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1)<macdlevel))){
         barddfmacd4=iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1);
         barddfmacdprice4=Low[cnt+1];
         barddfmacdbar4=cnt+1;
      }
   }
   
   //----------
   
   double divdownreverse=0;
   
   int barddrmacdbar=0;
   double barddrmacd=0;
   double barddrmacdprice=0;
   for(cnt=1;cnt<=1;cnt++){
      if(barddrmacdbar!=0)continue;
      if(iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt)>iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1)
      && iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1)<iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+2)
      && (macdlevelfilter==false || (macdlevelfilter && iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1)<macdlevel))){
         barddrmacd=iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1);
         barddrmacdprice=Low[cnt+1];
         barddrmacdbar=cnt+1;
      }
   }
   int barddrmacdbar2=0;
   double barddrmacd2=0;
   double barddrmacdprice2=0;
   for(cnt=barddrmacdbar;cnt<100;cnt++){
      if(barddrmacdbar!=0 && barddrmacd2<barddrmacd && barddrmacdprice2>barddrmacdprice){divdownreverse=1;continue;}
      if(iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt)>iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1)
      && iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1)<iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+2)
      && (macdlevelfilter==false || (macdlevelfilter && iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1)<macdlevel))){
         barddrmacd2=iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1);
         barddrmacdprice2=Low[cnt+1];
         barddrmacdbar2=cnt+1;
      }
   }

   double divdupreverse=0;
   
   int barddrmacdbar3=0;
   double barddrmacd3=0;
   double barddrmacdprice3=0;
   for(cnt=1;cnt<=1;cnt++){
      if(barddfmacdbar3!=0)continue;
      if(iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt)<iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1)
      && iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1)>iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+2)
      && (macdlevelfilter==false || (macdlevelfilter && iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1)>macdlevel))){
         barddrmacd3=iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1);
         barddrmacdprice3=High[cnt+1];
         barddrmacdbar3=cnt+1;
      }
   }
   int barddrmacdbar4=0;
   double barddrmacd4=0;
   double barddrmacdprice4=0;
   for(cnt=barddrmacdbar;cnt<100;cnt++){
      if(barddrmacdbar3!=0 && barddrmacd4>barddrmacd3 && barddrmacdprice4<barddrmacdprice3){divdupreverse=1;continue;}
      if(iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt)<iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1)
      && iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1)>iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+2)
      && (macdlevelfilter==false || (macdlevelfilter && iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1)>macdlevel))){
         barddrmacd4=iMACD(NULL,0,macdfast,macdslow,macdsma,PRICE_CLOSE,MODE_MAIN,cnt+1);
         barddrmacdprice4=High[cnt+1];
         barddrmacdbar4=cnt+1;
      }
   }
   
   if(tradefigure4 && barddrmacdbar4<barddfmacdbar2 && barddfmacdbar2!=0 && barddrmacdbar4!=0){divdupreverse=1;divdownfollow=0;}
   if(tradefigure4 && barddrmacdbar4>barddfmacdbar2 && barddfmacdbar2!=0 && barddrmacdbar4!=0){divdupreverse=0;divdownfollow=1;}
   if(tradefigure3 && barddrmacdbar2<barddfmacdbar4 && barddfmacdbar4!=0 && barddrmacdbar2!=0){divdownreverse=1;divdupfollow=0;}
   if(tradefigure3 && barddrmacdbar2>barddfmacdbar4 && barddfmacdbar4!=0 && barddrmacdbar2!=0){divdownreverse=0;divdupfollow=1;}
   
}