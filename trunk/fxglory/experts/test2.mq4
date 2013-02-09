//+------------------------------------------------------------------+
//|                                                        test2.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   string audusd[8];
   audusd[0] = "CCI Trend Display v1.0AUDUSDH4";
   audusd[1] = "CCI Trend Display v1.0AUDUSDH1";
   audusd[2] = "CCI Trend Display v1.0AUDUSDM30";
   audusd[3] = "CCI Trend Display v1.0AUDUSDM15";
   audusd[4] = "nonLagMa Trend Display v1.0AUDUSDH4";
   audusd[5] = "nonLagMa Trend Display v1.0AUDUSDH1";
   audusd[6] = "nonLagMa Trend Display v1.0AUDUSDM30";
   audusd[7] = "nonLagMa Trend Display v1.0AUDUSDM15";

   string nzdusdh4 = "CCI Trend Display v1.0NZDUSDH4";
   string nzdusdh1 = "CCI Trend Display v1.0NZDUSDH1";
   string nzdusdm30 = "CCI Trend Display v1.0NZDUSDM30";
   string nzdusdm15 = "CCI Trend Display v1.0NZDUSDM15";
   string nzdusdh4_nonlag = "nonLagMa Trend Display v1.0NZDUSDH4";
   string nzdusdh1_nonlag = "nonLagMa Trend Display v1.0NZDUSDH1";
   string nzdusdm30_nonlag = "nonLagMa Trend Display v1.0NZDUSDM30";
   string nzdusdm15_nonlag = "nonLagMa Trend Display v1.0NZDUSDM15";
   
   string eurusdh4 = "CCI Trend Display v1.0EURUSDH4";
   string eurusdh1 = "CCI Trend Display v1.0EURUSDH1";
   string eurusdm30 = "CCI Trend Display v1.0EURUSDM30";
   string eurusdm15 = "CCI Trend Display v1.0EURUSDM15";
   string eurusdh4_nonlag = "nonLagMa Trend Display v1.0EURUSDH4";
   string eurusdh1_nonlag = "nonLagMa Trend Display v1.0EURUSDH1";
   string eurusdm30_nonlag = "nonLagMa Trend Display v1.0EURUSDM30";
   string eurusdm15_nonlag = "nonLagMa Trend Display v1.0EURUSDM15";
   
   string gbpusdh4 = "CCI Trend Display v1.0GBPUSDH4";
   string gbpusdh1 = "CCI Trend Display v1.0GBPUSDH1";
   string gbpusdm30 = "CCI Trend Display v1.0GBPUSDM30";
   string gbpusdm15 = "CCI Trend Display v1.0GBPUSDM15";
   string gbpusdh4_nonlag = "nonLagMa Trend Display v1.0GBPUSDH4";
   string gbpusdh1_nonlag = "nonLagMa Trend Display v1.0GBPUSDH1";
   string gbpusdm30_nonlag = "nonLagMa Trend Display v1.0GBPUSDM30";
   string gbpusdm15_nonlag = "nonLagMa Trend Display v1.0GBPUSDM15";
   
   string usdchfh4 = "CCI Trend Display v1.0USDCHFH4";
   string usdchfh1 = "CCI Trend Display v1.0USDCHFH1";
   string usdchfm30 = "CCI Trend Display v1.0USDCHFM30";
   string usdchfm15 = "CCI Trend Display v1.0USDCHFDM15";
   string usdchfh4_nonlag = "nonLagMa Trend Display v1.0USDCHFDH4";
   string usdchfh1_nonlag = "nonLagMa Trend Display v1.0USDCHFH1";
   string usdchfm30_nonlag = "nonLagMa Trend Display v1.0USDCHFM30";
   string usdchfm15_nonlag = "nonLagMa Trend Display v1.0USDCHFM15";

   int audusd_result[8];
   int audusd_result_previous[8];
   int oldColor;
   for (int i = 0; i < 4; i++) {
      oldColor = ObjectGet(audusd[i], OBJPROP_COLOR);
      audusd_result[i] = oldColor;
   }
   Alert(oldColor);
   Alert(getcolor(oldColor));
   
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
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

string getcolor(int number)
{
   //255 for red, 55295 for gold, 16711680
   if (number == 255) return ("red");
   else if (number == 55295) return ("gold");
   else if (number == 16711680) return ("blue");
}