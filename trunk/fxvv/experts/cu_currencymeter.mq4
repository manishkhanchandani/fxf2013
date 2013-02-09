//+------------------------------------------------------------------+
//|                                             cu_currencymeter.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <ghttp.mqh>
int openTime;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
/*#include <ghttp.mqh>
string params[2][2];

params[0][0] = "key1"; 

params[0][1] = "value1";

params[1][0] = "key2"; 
params[1][1] = "value2";

// for multiple file upload
string filenames[2][2];

filenames[0][0] = "uploaded1"; // name of form field for file upload 
filenames[0][1] = "test1.txt"; // file name in experts/files/ subfolder

filenames[1][0] = "uploaded2"; 
filenames[1][1] = "test2.txt"; 

string response; 

HttpPOST("127.0.0.1", "/upload.php", params, filenames, response); 
HttpGET("http://www.google.com?q=hello", response);
Comment(response); */
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
   if (openTime != Time[0]) {
      Alert("new time");
      openTime = Time[0];

      //get the data
      string response; 
      HttpGET("http://wc5.org/forex/api/currency_strength.php", response);
      Comment(response);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+