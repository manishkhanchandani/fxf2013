//+------------------------------------------------------------------+
//|                                                masterblaster.mq4 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"

#include <stdlib.mqh>
#include <WinUser32.mqh>
#include <m_external.mqh>
#include <m_vars.mqh>
#include <m_common.mqh>
#include <m_strategy_bb.mqh>
#include <m_orders.mqh>


//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   custom_init();
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
   custom_start();
   int handle;
   string filename = build + ".csv";
   handle=FileOpen(filename, FILE_CSV|FILE_WRITE, ';');
   if(handle>0) {
            FileWrite(handle, TimeToStr(TimeCurrent()));
            FileWrite(handle, inference);
         FileClose(handle);
      }
//----
   return(0);
  }
//+------------------------------------------------------------------+

