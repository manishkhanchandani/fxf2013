//+------------------------------------------------------------------+
//|                                                    pv_points.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#property indicator_chart_window
extern int number = 1;
double bid, ask;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   ObjectDelete("S1");
   ObjectDelete("S2");
   ObjectDelete("S3");
   ObjectDelete("R1");
   ObjectDelete("R2");
   ObjectDelete("R3");
   ObjectDelete("PIVIOT");
   ObjectDelete("Support 1");
   ObjectDelete("Support 2");
   ObjectDelete("Support 3");
   ObjectDelete("Piviot level");
   ObjectDelete("Resistance 1");
   ObjectDelete("Resistance 2");
   ObjectDelete("Resistance 3");
   Comment("");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectDelete("S1");
   ObjectDelete("S2");
   ObjectDelete("S3");
   ObjectDelete("R1");
   ObjectDelete("R2");
   ObjectDelete("R3");
   ObjectDelete("PIVIOT");
   ObjectDelete("Support 1");
   ObjectDelete("Support 2");
   ObjectDelete("Support 3");
   ObjectDelete("Piviot level");
   ObjectDelete("Resistance 1");
   ObjectDelete("Resistance 2");
   ObjectDelete("Resistance 3");
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
double high = iHigh(Symbol(), PERIOD_D1, number);
double low = iLow(Symbol(), PERIOD_D1, number);
double close = iClose(Symbol(), PERIOD_D1, number);
double R = high - low;//range
double p = (high + low + close)/3;// Standard Pivot
double r3 = high + 2 * (p - low); //p + (R * 1.000);
double r2 = p + (high - low); //p + (R * 0.618);
double r1 = (2 * p) - low; //p + (R * 0.382);
double s1 = (2 * p) - high; //p - (R * 0.382);
double s2 = p - (high - low); //p - (R * 0.618);
double s3 = low - 2 * (high - p); //p - (R * 1.000);

drawLine(r3,"R3", Lime,0);
drawLabel("Resistance 3",r3,Lime);
drawLine(r2,"R2", Green,0);
drawLabel("Resistance 2",r2,Green);
drawLine(r1,"R1", DarkGreen,0);
drawLabel("Resistance 1",r1,DarkGreen);

drawLine(p,"PIVIOT",Blue,1);
drawLabel("Piviot level",p,Blue);

drawLine(s1,"S1",Maroon,0);
drawLabel("Support 1",s1,Maroon);
drawLine(s2,"S2",Crimson,0);
drawLabel("Support 2",s2,Crimson);
drawLine(s3,"S3",Red,0);
drawLabel("Support 3",s3,Red);

//----
   return(0);
  }
//+------------------------------------------------------------------+


void drawLabel(string name,double lvl,color Color)
{
    if(ObjectFind(name) != 0)
    {
        ObjectCreate(name, OBJ_TEXT, 0, Time[10], lvl);
        ObjectSetText(name, name, 8, "Arial", EMPTY);
        ObjectSet(name, OBJPROP_COLOR, Color);
    }
    else
    {
        ObjectMove(name, 0, Time[10], lvl);
    }
}


void drawLine(double lvl,string name, color Col,int type)
{
         if(ObjectFind(name) != 0)
         {
            ObjectCreate(name, OBJ_HLINE, 0, Time[0], lvl,Time[0],lvl);
            
            if(type == 1)
            ObjectSet(name, OBJPROP_STYLE, STYLE_SOLID);
            else
            ObjectSet(name, OBJPROP_STYLE, STYLE_DOT);
            
            ObjectSet(name, OBJPROP_COLOR, Col);
            ObjectSet(name,OBJPROP_WIDTH,1);
            
         }
         else
         {
            ObjectDelete(name);
            ObjectCreate(name, OBJ_HLINE, 0, Time[0], lvl,Time[0],lvl);
            
            if(type == 1)
            ObjectSet(name, OBJPROP_STYLE, STYLE_SOLID);
            else
            ObjectSet(name, OBJPROP_STYLE, STYLE_DOT);
            
            ObjectSet(name, OBJPROP_COLOR, Col);        
            ObjectSet(name,OBJPROP_WIDTH,1);
          
         }
}