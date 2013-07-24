//+------------------------------------------------------------------+
//|                                                          TSF.mq4 |
//|                                         Copyright © 2007 Mulyadi |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007 Mulyadi Santoso"
#property link      "musanto@yahoo.com"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red

//---- input parameters
extern int        TSFper=20;
//---- buffers
double ExtMapBuffer1[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
bool     start;
double   sigma;
int init()
  {string   shortname;
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   shortname="TSF ("+DoubleToStr(TSFper,0)+")";
   IndicatorShortName(shortname);
   SetIndexLabel(0,shortname);   
   start=true;

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   int      counted_bars=IndicatorCounted();
   int      limit;

//----
   
   limit = Bars - counted_bars;
   
   if (start) limit = limit - TSFper;
   start=false;
   for (int i=limit;i>=0;i--)
   {  
      ExtMapBuffer1[i] = Lreg(i,i+TSFper-1);
   }//for
   return(0);
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
double Lreg(int st0, int st1)
{ double    Sx=0,Sxx=0,Sxy=0,Sy;
  double    Beta,Alfa,x,y,c,value,rv;
  int       i,n;

  rv = 0.0;
  n = st1 - st0 + 1 ;                       //int n=m_pos[1]-m_pos[0]+1;
  Sy  =iClose(NULL,0,st0);          //double sumy=value;
  Sx  = 0.0;                                // double sumx=0.0;
  Sxy = 0.0;                                // double sumxy=0.0;
  Sxx = 0.0;                                // double sumx2=0.0;
  for (i=1;i<n;i++)                         //for(i=1; i<n; i++)
  {  
     x   = i;   
     y   = iClose(NULL,0,st0+i);    //value  = Close[m_pos[0]+i];
     Sx  = Sx + x;                          //sumx+  = i;
     Sy  = Sy + y;                          //sumy+  = value
     Sxx = Sxx + (x* x);                    //sumx2+ = i*i
     Sxy = Sxy + (x* y);                    //sumxy+ = value*i;
  }
  c    = Sxx*n - Sx * Sx;                   //c=sumx2*n-sumx*sumx;
  if (c==0.0) return;                     //if(c==0.0) return;
  Beta = (n*Sxy-Sx*Sy)/c;                   //b=(sumxy*n-sumx*sumy)/c;
  Alfa = (Sy-Beta*Sx)/n;                    //a=(sumy-sumx*b)/n;
  rv = Alfa;       
   return(rv);
}

