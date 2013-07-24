//+------------------------------------------------------------------+
//|                                                         test.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"
#include <ghttp.mqh>

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   start();
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
   
      string params[2][2];
      params[0][0] = "key1";
      params[0][1] = "value1";
      params[1][0] = "key2";
      params[1][1] = "value2";
      string filenames[1][2];
      filenames[0][0] = "uploaded";
      filenames[0][1] = "test.txt"; 
      string response;
      //HttpPOST("127.0.0.1", "/upload.php", params, filenames, response);
      HttpGET("http://www.google.com?q=hello", response);
      Alert(response);
      Comment(response);
//----
   return(0);
  }
//+------------------------------------------------------------------+