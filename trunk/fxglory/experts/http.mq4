//+------------------------------------------------------------------+
//|                                                         http.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"
#include <http51.mqh>

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
   string params [0,2];
   //params[?,0] = Key
   //params[?,1] = Value

   ArrayResize( params, 0); // Flush old data
   int status[1];           // HTTP Status code
  
   // Setup parameters addParam(Key,Value,paramArray)
   addParam("Bid",Bid,params);
   addParam("Ask",Ask,params);
   // TODO .... any other parameters

   //create URLEncoded string from parameters array
   string req = ArrayEncode(params);

   //Send Request 
   Alert("http://10.194.82.74/mkhancha2/liveevents/deploy_properties?"+ req);
   string res = httpGET("http://10.194.82.74/mkhancha2/liveevents/deploy_properties?"+ req, status);
   //string res = httpPOST("http://127.0.0.1/test", req, status);
   
   Alert("HTTP:",status[0]," ", res);
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