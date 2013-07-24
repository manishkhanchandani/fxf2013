//+------------------------------------------------------------------+
//|                                                     cuAngles.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Yellow
#property indicator_color2 Red


double CrossUp[];
double CrossDown[];
extern int Cycle=144;
int now;//define a time variant

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_ARROW, EMPTY,2);
   SetIndexArrow(0, 233);
   SetIndexBuffer(0, CrossUp);
   SetIndexStyle(1, DRAW_ARROW, EMPTY,2);
   SetIndexArrow(1, 234);
   SetIndexBuffer(1, CrossDown);
   DropAllAngleLine();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   DropAllAngleLine();
   
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
   if (now!=Minute()) //every minute refresh once
      {
       now=Minute();
       double HighValue,LowValue;
       int    HstBar,LstBar;
       DropAllAngleLine(); 
       DropAllAngleLine(); //twice delete

       HighValue=High[iHighest(NULL,0,MODE_HIGH,Cycle,1)]; 
       LowValue= Low[iLowest(NULL,0,MODE_LOW,Cycle,1)];
       HstBar=Time[iHighest(NULL,0,MODE_HIGH,Cycle,1)];
       LstBar=Time[iLowest(NULL,0,MODE_LOW,Cycle,1)];    
   
       DrawAngleLine("UpAngleA",LstBar,LowValue,82.5, Aqua, STYLE_DOT);
       DrawAngleLine("UpAngleB",LstBar,LowValue,75, Blue, STYLE_DOT);
       DrawAngleLine("UpAngleC",LstBar,LowValue,71.25, Aqua, STYLE_DOT);
       DrawAngleLine("UpAngleD",LstBar,LowValue,63.75, Blue, STYLE_DOT);
       DrawAngleLine("UpAngleE",LstBar,LowValue,45, White, STYLE_SOLID);
       DrawAngleLine("UpAngleF",LstBar,LowValue,26.25, Blue, STYLE_DOT);
       DrawAngleLine("UpAngleG",LstBar,LowValue,18.75, Aqua, STYLE_DOT);
       DrawAngleLine("UpAngleH",LstBar,LowValue,15, Blue, STYLE_DOT);
       DrawAngleLine("UpAngleI",LstBar,LowValue,7.5, Aqua, STYLE_DOT);
       
       
       DrawAngleLine("DownAngleA",HstBar,HighValue,-82.5, Red, STYLE_DOT);
       DrawAngleLine("DownAngleB",HstBar,HighValue,-75, Yellow, STYLE_DOT);
       DrawAngleLine("DownAngleC",HstBar,HighValue,-71.25, Red, STYLE_DOT);
       DrawAngleLine("DownAngleD",HstBar,HighValue,-63.75, Yellow, STYLE_DOT);
       DrawAngleLine("DownAngleE",HstBar,HighValue,-45, White, STYLE_SOLID);
       DrawAngleLine("DownAngleF",HstBar,HighValue,-26.25, Yellow, STYLE_DOT);
       DrawAngleLine("DownAngleG",HstBar,HighValue,-18.75, Red, STYLE_DOT);
       DrawAngleLine("DownAngleH",HstBar,HighValue,-15, Yellow, STYLE_DOT);
       DrawAngleLine("DownAngleI",HstBar,HighValue,-7.5, Red, STYLE_DOT);
       
       string name;
       name = "50perc";
       ObjectDelete(name);
       hline(name, HighValue - ((HighValue - LowValue)/2), Gold, STYLE_SOLID);
       string box = "";
       box = box + "\nDigits: " + Digits;
       box = box + "\nPoint: " + Point;
       double factor = Point * 25 * 10;
       box = box + "\nFactor: " + factor;
       double diff = (HighValue - LowValue) / 8;
      // box = box + "\nPart 1: " + HighValue - (diff * 1);
       double close;
       if (iHighest(NULL,0,MODE_HIGH,Cycle,1) < iLowest(NULL,0,MODE_LOW,Cycle,1)) {
         close = HighValue;
       } else {
         close = LowValue;
       }
       box = box + "\nClose: " + close;
       double sqRootClose = MathSqrt(close);
       box = box + "\nSquare Root of Close: " + sqRootClose;
       int i;
         double sqRootfactoradd = sqRootClose + (factor * 8);
         box = box + "\nSquare Root Factor Up: " + sqRootfactoradd;
         double level_up = MathPow(sqRootfactoradd, 2);
         box = box + ", Level Up: " + level_up;
         name = "up_8";
         ObjectDelete(name);
         hline(name, level_up, Blue, STYLE_DOT);
         sqRootfactoradd = sqRootClose + (factor * 16);
         box = box + "\nSquare Root Factor Up: " + sqRootfactoradd;
         level_up = MathPow(sqRootfactoradd, 2);
         box = box + ", Level Up: " + level_up;
         name = "up_8b";
         ObjectDelete(name);
         hline(name, level_up, Blue, STYLE_DOT);
       
         double sqRootfactorsub = sqRootClose - (factor * 8);
         box = box + "\nSquare Root Factor Down: " + sqRootfactorsub;
         double level_down = MathPow(sqRootfactorsub, 2);
         box = box + ", Level Down: " + level_down;
         name = "down_8";
         ObjectDelete(name);
         hline(name, level_up, Red, STYLE_DOT);
         
         sqRootfactorsub = sqRootClose - (factor * 16);
         box = box + "\nSquare Root Factor Down: " + sqRootfactorsub;
         level_down = MathPow(sqRootfactorsub, 2);
         box = box + ", Level Down: " + level_down;
         name = "down_8b";
         ObjectDelete(name);
         hline(name, level_up, Red, STYLE_DOT);
       Comment(box);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+


void DrawAngleLine(string lname,int bar,double value,int angle, color linecolor, int style)
  { 
   /*
     int   style;
     color linecolor;
 
      if (angle>0)
        {
         linecolor=Aqua;
         if (angle==85 || angle==25) style=STYLE_DASHDOT;else style=STYLE_DOT; 
        }
      else 
        {
         linecolor=Red;
         if (angle==-85 || angle==-25) style=STYLE_DASHDOT;else style=STYLE_DOT;
        } */
      ObjectCreate(lname,OBJ_TRENDBYANGLE,0,bar,value); 
      ObjectSet(lname,OBJPROP_COLOR,linecolor);
      ObjectSet(lname,OBJPROP_STYLE,style);
      ObjectSet(lname,OBJPROP_WIDTH,1);
      ObjectSet(lname,OBJPROP_ANGLE,angle);     
  }
  
void DropAllAngleLine()
  {
   int obj_total=ObjectsTotal();
   string obj_name;
  for(int i=0;i<obj_total;i++)
    {
     obj_name=ObjectName(i);
     if (StringFind(obj_name,"Angle",0)>0) ObjectDelete(obj_name);
    }
    
       obj_name = "50perc";
       ObjectDelete(obj_name);
       
         obj_name = "up_8";
         ObjectDelete(obj_name);
         
         obj_name = "down_8";
         ObjectDelete(obj_name);
         obj_name = "up_8b";
         ObjectDelete(obj_name);
         
         obj_name = "down_8b";
         ObjectDelete(obj_name);
  }
  
  

void hline(string name, double price, color TextColor, int style)
{
   ObjectCreate(name, OBJ_HLINE, 0, 0, price);
   ObjectSet(name, OBJPROP_COLOR, TextColor);
   ObjectSet(name,OBJPROP_STYLE,style);
   ObjectSet(name,OBJPROP_WIDTH,1);
}