//+------------------------------------------------------------------+
//|                                    ForexMasteryMillionDollar.mq4 |
//|                                     ForexMaster Development Team |
//|                                          http://forexmastery.org |
//+------------------------------------------------------------------+
#property copyright "ForexMaster Development Team"
#property link      "http://forexmastery.org"

#include <stdlib.mqh>
#include <WinUser32.mqh>
#include <http51.mqh>
#include <strategies.mqh>

extern string EA_Version = "1.4"; /*1.1 changes: settings shown*/
extern string label_0 = " === Account Information === ";
extern string username = "nkhanchandani";
extern double inital_amount = 0;
extern string label_1 = " === Order Information === ";
extern double lotsize = 0.05;
extern int max_orders = 28;
extern int maxspread = 150;
extern int stop_loss = 0;
extern int take_profit = 0;
extern int magic = 123;
extern int magic_0 = 124;
extern int magic_1 = 125;
extern string symbol_suffix = "";
extern string label_2 = " === Symbol Information === ";
extern string label_3 = "USE All for all symbols, else comma separated symbols to include those";
extern string includeSymbols = "All";
extern string label_4 = "USE comma separated symbols to include those";
extern string excludeSymbols = "";
extern bool calculateSelf = false;
extern bool logs = false;
string product = "MillionDollar";
int auth = 0;
int opentime, opentimeAuth, opentimeOrders, opentimeOrders2;
string infobox;
string inference;
string inference2;
string inference3;
double lots;
int counter = 0;
int checked = 0;

string final_symbol[50];
int final_strategy[50];
int final_period[50];
int final_shift[50];
int final_ordertype[50];
int final_closeonprofit[50];
int final_closeonsltp[50];
      
int totalSymbols = 0;
      
int gSymbolStrategy[5][30];
int gSymbolVal[5][30];
int gSymbol20[5][30];
int gSymbol50[5][30];
int gSymbol100[5][30];
int gSymbol200[5][30];
int gSymbol300[5][30];
int gSymbol500[5][30];

      double bestValue = -999999;
      int bestStrategy = 0;
      int bestTime = 0;
      int bestP = -1;  
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   opentimeAuth = 0;
   opentime = 0;
   opentimeOrders = 0;
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
   opentimeAuth = 0;
   opentime = 0;
   opentimeOrders = 0;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   if (opentimeAuth != iTime(Symbol(), PERIOD_D1, 0)) {
      auth();
      opentimeAuth = iTime(Symbol(), PERIOD_D1, 0);
   }
   
   if (auth == 0) {
      infobox = "";
      authfailuremessage();
      Comment(infobox);
      return (0);
   }
   int k;
   string message;
   int check = 0;
   int check2 = 0;
   int current = 0;
   int strategy;
   int periods[5] = {PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4, PERIOD_D1};
   int period;
   int p;
   string symbol = Symbol();
   int val;
   int gtotal = 0;
   int proceed = 0;
   string fnSt = "";
   int handle = 0;
   string str = "";
   string resultString[];
   if (calculateSelf) {
      fnSt = symbol + "/strategy.txt";
      handle = FileOpen(fnSt, FILE_READ);
      str = "";
      if(handle>0)
      {
         str=FileReadString(handle);
         FileClose(handle);
         checked = 1;
         SplitString(str, ",", resultString);
         symbol = resultString[0];
         bestTime = StrToInteger(resultString[1]);
         bestStrategy = StrToInteger(resultString[2]);
         bestValue = StrToInteger(resultString[3]);
      }
      if (checked == 1) {
         if (opentime != iTime(Symbol(), PERIOD_M15, 0)) {
            opentime = iTime(Symbol(), PERIOD_M15, 0);
            infobox = "";
            inference3 = intro();
            check = get_strategy_result(bestStrategy, symbol, bestTime, 1, 0);
            check2 = get_strategy_result(bestStrategy, symbol, bestTime, 1, 1);
            inference3 = inference3 + "\n\nSymbol: " + symbol + ", Time Period: " + TimeframeToString(bestTime)
                     + ", Strategy: " + bestStrategy 
                     + " (" + get_strategy_name(bestStrategy) + ") "
                     + ", Value: " + bestValue;
            inference3 = inference3 + "\nSymbol: " + symbol + ", Check: " + check + ", Check Current: " + check2;
            infobox = infobox + "\n\nSelf";
            infobox = infobox + condition_for_close_single(magic, symbol);
            message = magic + ", " + bestTime + ", " + bestStrategy + ", 1";
            if (check == 1) {
               create_order(symbol, 1, lots, magic, message, stop_loss, take_profit);
            } else if (check == -1) {
               create_order(symbol, -1, lots, magic, message, stop_loss, take_profit);
            }
            Comment(inference3, infobox);
         }
         return (0);
      }
      counter++;
      if (counter % 2 == 0) {
         infobox = "";
         inference = "INFERENCE:\n";
         inference2 = "\n\nINFERENCE2:\n";
         inference3 = intro();
         proceed = 0;
         for (p = 0; p < 5; p++) {
            period = periods[p];
            for (strategy = 1; strategy <= 29; strategy++) {
               if (gSymbolStrategy[p][strategy] > 0) {
                  if (p == 4 && strategy == 29) {
                     checked = 1;
                     FileDelete(fnSt);
                     FileAppend(fnSt, symbol + "," + bestTime + "," + bestStrategy + "," + bestValue);
                  }
               } else {
                  gtotal = 0;
                  for (int start=5; start <= 40; start = start + 5) {
                     int end = start - 5;
                     val = iCustom(symbol, period, "cuSpanTimeClose", strategy, start, end, 4, 0);
                     if (val == EMPTY_VALUE) val = 0;
                     gtotal = gtotal + val;
                  }
                  gSymbolStrategy[p][strategy] = strategy;
                  gSymbolVal[p][strategy] = gtotal;
                  gSymbol20[p][strategy] = iCustom(symbol, period, "cuSpanTimeClose", strategy, 20, 0, 4, 0);
                  if (gSymbol20[p][strategy] == EMPTY_VALUE) gSymbol20[p][strategy] = 0;
                  gSymbol50[p][strategy] = iCustom(symbol, period, "cuSpanTimeClose", strategy, 50, 0, 4, 0);
                  if (gSymbol50[p][strategy] == EMPTY_VALUE) gSymbol50[p][strategy] = 0;
                  gSymbol100[p][strategy] = iCustom(symbol, period, "cuSpanTimeClose", strategy, 100, 0, 4, 0);
                  if (gSymbol100[p][strategy] == EMPTY_VALUE) gSymbol100[p][strategy] = 0;
                  gSymbol200[p][strategy] = iCustom(symbol, period, "cuSpanTimeClose", strategy, 200, 0, 4, 0);
                  if (gSymbol200[p][strategy] == EMPTY_VALUE) gSymbol200[p][strategy] = 0;
                  gSymbol300[p][strategy] = iCustom(symbol, period, "cuSpanTimeClose", strategy, 300, 0, 4, 0);
                  if (gSymbol300[p][strategy] == EMPTY_VALUE) gSymbol300[p][strategy] = 0;
                  gSymbol500[p][strategy] = iCustom(symbol, period, "cuSpanTimeClose", strategy, 500, 0, 4, 0);
                  if (gSymbol500[p][strategy] == EMPTY_VALUE) gSymbol500[p][strategy] = 0;
                  proceed = 1;
                  break;
               }//end if
            }//end for
            if (proceed == 1) {
               break;
            }
         }
         for (p = 0; p < 5; p++) {
            period = periods[p];
            for (strategy = 1; strategy <= 29; strategy++) {
               /*if (
               gSymbol200[p][strategy] > gSymbol100[p][strategy]
                  && gSymbol100[p][strategy] > gSymbol50[p][strategy]
                  && gSymbol50[p][strategy] > gSymbolVal[p][strategy]
                  && gSymbolVal[p][strategy] > gSymbol20[p][strategy]
                  && gSymbolVal[p][strategy] > 3000
                  && gSymbol200[p][strategy] > 15000
               ) {*/
               if (strategy == 4 || strategy == 24 || strategy == 25) {
               
               } else {
                  double avg = (gSymbol500[p][strategy] + gSymbol300[p][strategy] + 
                  gSymbol200[p][strategy] + gSymbol100[p][strategy] + gSymbol50[p][strategy]
                     + gSymbolVal[p][strategy] + gSymbol20[p][strategy]) / 7;
                  inference = inference + "\n\nSymbol: " + symbol + ", Time Period: " + TimeframeToString(period)
                  + ", Strategy: " + strategy 
                  + " (" + get_strategy_name(strategy) + ") "
                  + ", Start: 40, End: 0 has value: " + gSymbolVal[p][strategy]
                  + ", Days 200: " + gSymbol200[p][strategy]
                  + ", Days 300: " + gSymbol300[p][strategy]
                  + ", Days 500: " + gSymbol500[p][strategy]
                  + ", Average: " + avg;
                  if (avg > bestValue) {
                     bestValue = avg;
                     bestStrategy = strategy;
                     bestTime = period;
                     bestP = p;
                  }
               }
               //}
               infobox = infobox + "\n\nSymbol: " + symbol + ", Time Period: " + TimeframeToString(period)
                  + ", Strategy: " + strategy 
                  + " (" + get_strategy_name(strategy) + ") "
                  + ", Start: 40, End: 0 has value: " + gSymbolVal[p][strategy];
               infobox = infobox + "\nSymbol: " + symbol + ", Time Period: " + TimeframeToString(period)
                     + ", Strategy: " + strategy 
                     + " (" + get_strategy_name(strategy) + ") "
                     + ", Days: 20 has value: " + gSymbol20[p][strategy];
               infobox = infobox + "\nSymbol: " + symbol + ", Time Period: " + TimeframeToString(period)
                     + ", Strategy: " + strategy 
                     + " (" + get_strategy_name(strategy) + ") "
                     + ", Days: 50 has value: " + gSymbol50[p][strategy];
               infobox = infobox + "\nSymbol: " + symbol + ", Time Period: " + TimeframeToString(period)
                     + ", Strategy: " + strategy 
                     + " (" + get_strategy_name(strategy) + ") "
                     + ", Days: 100 has value: " + gSymbol100[p][strategy];
               infobox = infobox + "\nSymbol: " + symbol + ", Time Period: " + TimeframeToString(period)
                     + ", Strategy: " + strategy 
                     + " (" + get_strategy_name(strategy) + ") "
                     + ", Days: 200 has value: " + gSymbol200[p][strategy];
               infobox = infobox + "\nSymbol: " + symbol + ", Time Period: " + TimeframeToString(period)
                     + ", Strategy: " + strategy 
                     + " (" + get_strategy_name(strategy) + ") "
                     + ", Days: 300 has value: " + gSymbol300[p][strategy];
               infobox = infobox + "\nSymbol: " + symbol + ", Time Period: " + TimeframeToString(period)
                     + ", Strategy: " + strategy 
                     + " (" + get_strategy_name(strategy) + ") "
                     + ", Days: 500 has value: " + gSymbol500[p][strategy];
            }
         }
         if (bestStrategy > 0) {
            inference2 = inference2 + "\n\nSymbol: " + symbol + ", Time Period: " + TimeframeToString(bestTime)
                  + ", Strategy: " + bestStrategy 
                  + " (" + get_strategy_name(bestStrategy) + ") "
                  + ", Value: " + bestValue;
         }
         string fn = symbol + "/forexmasteryEAv4.txt";
         FileDelete(fn);
         FileAppend(fn, inference3 + inference2 + "\n----------------------------\n" + inference + "\n----------------------------\n" + infobox);
         Comment(inference3 + inference2 + "\n----------------------------\n" + inference + "\n----------------------------\n" + infobox);
      }
   } else {
      if (opentime != iTime(Symbol(), PERIOD_M5, 0)) {
         opentime = iTime(Symbol(), PERIOD_M5, 0);
         infobox = "";
         infobox = infobox + intro();
         infobox = infobox + signals();
         //if (opentimeOrders2 != iTime(Symbol(), PERIOD_M15, 0)) {
            //opentimeOrders2 = iTime(Symbol(), PERIOD_M15, 0);
            getStrategies();
         //}
         infobox = infobox + "\n\nAutomatic";
         infobox = infobox + condition_for_close(magic);
         for (k = 0; k<totalSymbols;k++) {
            if (!checkSymbol(final_symbol[k])) {
               continue;
            }
            if (final_shift[k] != 1) continue;
            current = 1;
            if (final_shift[k] == 1) current = 0;
            message = magic + ", " + final_period[k] + ", " + final_strategy[k] + ", " + final_shift[k];
            check = get_strategy_result(final_strategy[k], final_symbol[k], final_period[k], final_shift[k], current);
            infobox = infobox + "\nSymbol: " + final_symbol[k] + ", Best: " + final_strategy[k] + "(" + get_strategy_name(final_strategy[k]) 
                        + "), Change: " + check
                        + ", Period: " + TimeframeToString(final_period[k])
                        + ", Shift: " + final_shift[k]
                        + ", OrderType: " + final_ordertype[k]
                        + ", CloseonProfit: " + final_closeonprofit[k]
                        + ", Closeonsltp: " + final_closeonsltp[k]
                        + ", Message: " + message
                        + ", Spread: " + DoubleToStr(MarketInfo(final_symbol[k], MODE_SPREAD), 0)
                        ;
            if (check == 1 && (final_ordertype[k] == 0 || final_ordertype[k] == 1)) {
               create_order(final_symbol[k], 1, lots, magic, message, stop_loss, take_profit);
            } else if (check == -1 && (final_ordertype[k] == 0 || final_ordertype[k] == -1)) {
               create_order(final_symbol[k], -1, lots, magic, message, stop_loss, take_profit);
            }
         }
      
         if (opentimeOrders != iTime(Symbol(), PERIOD_H4, 0)) {
            orders();
            opentimeOrders = iTime(Symbol(), PERIOD_H4, 0);
         }
         ordersOpen();
         //string fn = "forexmasteryEAv3_"+symbol+".txt";
         //FileDelete(fn);
         //FileAppend(fn, infobox);
      }
      string zerobox = "\n\nManual";
      zerobox = zerobox + condition_for_close(magic_0);
      for (k = 0; k<totalSymbols;k++) {
         if (!checkSymbol(final_symbol[k])) {
            continue;
         }
         if (final_shift[k] != 0) continue;
         message = magic_0 + ", " + final_period[k] + ", " + final_strategy[k] + ", " + final_shift[k];
         current = 0;
         if (final_shift[k] == 0) current = 1;
         check = get_strategy_result(final_strategy[k], final_symbol[k], final_period[k], final_shift[k], current);
         zerobox = zerobox + "\nSymbol: " + final_symbol[k] + ", Best: " + final_strategy[k] + "(" + get_strategy_name(final_strategy[k]) 
                        + "), Change: " + check
                        + ", Period: " + TimeframeToString(final_period[k])
                        + ", Shift: " + final_shift[k]
                        + ", Current: " + current
                        + ", Message: " + message
                        + ", Spread: " + DoubleToStr(MarketInfo(final_symbol[k], MODE_SPREAD), 0)
                        ;
         if (check == 1) {
            create_order(final_symbol[k], 1, lots, magic_0, message, stop_loss, take_profit);
         } else if (check == -1) {
            create_order(final_symbol[k], -1, lots, magic_0, message, stop_loss, take_profit);
         }
      }
      Comment(infobox, zerobox);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+

int converttotime(string timeframe)
{
   if (timeframe == "M1") return (1);
   else if (timeframe == "M5") return (5);
   else if (timeframe == "M15") return (15);
   else if (timeframe == "M30") return (30);
   else if (timeframe == "H1") return (60);
   else if (timeframe == "H4") return (240);
   else if (timeframe == "D1") return (1440);
   else return (0);
}

void FileAppend(string name,string txt)
{
   int handle = FileOpen(name,FILE_READ|FILE_WRITE);
	FileSeek(handle,0,SEEK_END);
	FileWrite(handle,txt);
	FileFlush(handle);
	FileClose(handle);
}

int getStrategies()
{
   int status[1];
   string response;
   string url = "http://wc5.org/forex/api/new_signals_manual.php?username="+username+"&account="+AccountNumber()+"&product="+product+"&version="+EA_Version;
   //Print(url);
   response = httpGET(url, status);
   //Print(response);
   int i;
   for (i=0;i<50;i++) {
      final_symbol[i] = "";
      final_strategy[i] = 0;
      final_period[i] = -1;
      final_shift[i] = -1;
      final_ordertype[i] = 0;
      final_closeonprofit[i] = 0;
      final_closeonsltp[i] = 0;
   }
   string resultArr[];
   SplitString(response, "\n", resultArr);
   int count = ArraySize(resultArr);
   int counter = 0;
   for (i=0;i<count;i++) {
      if (resultArr[i] == "") continue;
      string resultArr2[];
      //Print("i: " + i + ", resultArr: " + resultArr[i]);
      SplitString(resultArr[i], ",", resultArr2);
      final_symbol[i] = resultArr2[0]+symbol_suffix;
      final_strategy[i] = StrToInteger(resultArr2[2]);
      final_period[i] = converttotime(resultArr2[1]);
      final_shift[i] = StrToInteger(resultArr2[3]);
      final_ordertype[i] = StrToInteger(resultArr2[4]);
      final_closeonprofit[i] = StrToInteger(resultArr2[5]);
      final_closeonsltp[i] = StrToInteger(resultArr2[6]);
      counter++;
   }
   totalSymbols = counter;
}

int auth()
{
   int status[1];
   string response;
   string url = "http://wc5.org/forex/api/accessMillionDollar.php?username="+username+"&account="+AccountNumber()+"&product="+product+"&version="+EA_Version;
   //Print(url);
   response = httpGET(url, status);
   //Print(response);
   if (response == "Success") {
      auth = 1;
   } else {
      auth = 0;
   }
}



int authfailuremessage()
{
   if (auth == 0) {
      infobox = infobox + "\n\nUnauthorised Email or Account Number.\n" +
      "Go to http://forexmastery.org/ and make sure you have assigned proper account number.\n" +
      "Or email us at milliondollar@forexmastery.org";
   }

}



//+------------------------------------------------------------------+  
//+------------------------------------------------------------------+
// Helper function for parsing command strings, results resides in g_parsedString.
bool SplitString(string stringValue, string separatorSymbol, string& results[])
{
//	 Alert("--SplitString--");
//	 Alert(stringValue);

   if (StringFind(stringValue, separatorSymbol) < 0)
   {// No separators found, the entire string is the result.
      ArrayResize(results, 1);
      results[0] = stringValue;
   }
   else
   {   
      int separatorPos = 0;
      int newSeparatorPos = 0;
      int size = 0;

      while(newSeparatorPos > -1)
      {
         size = size + 1;
         newSeparatorPos = StringFind(stringValue, separatorSymbol, separatorPos);
         
         ArrayResize(results, size);
         if (newSeparatorPos > -1)
         {
            if (newSeparatorPos - separatorPos > 0)
            {  // Evade filling empty positions, since 0 size is considered by the StringSubstr as entire string to the end.
               results[size-1] = StringSubstr(stringValue, separatorPos, newSeparatorPos - separatorPos);
            }
         }
         else
         {  // Reached final element.
            results[size-1] = StringSubstr(stringValue, separatorPos, 0);
         }
         
         
         //Alert(results[size-1]);
         separatorPos = newSeparatorPos + 1;
      }
   }   
   
   if (ArraySize(results) > 0)
   {  // Results OK.
      return (true);
   }
   else
   {  // Results are WRONG.
      Print("ERROR - size of parsed string not expected.", true);
      return (false);
   }
}




string TimeframeToString(int P)
{
   switch(P)
   {
      case PERIOD_M1:  return("M1");
      case PERIOD_M5:  return("M5");
      case PERIOD_M15: return("M15");
      case PERIOD_M30: return("M30");
      case PERIOD_H1:  return("H1");
      case PERIOD_H4:  return("H4");
      case PERIOD_D1:  return("D1");
      case PERIOD_W1:  return("W1");
      case PERIOD_MN1: return("MN1");
      case 0: return ("Any");
   }
}

string condition_for_close(int magicNumber)
{
   string closebox;
   closebox = closebox + "\nCHECKING CLOSURES: " + magicNumber;
   int cnt=0;
   int i;
   int timePeriod;
   int st;
   for(i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderMagicNumber()==magicNumber) {
         cnt++;
         string result[3];
         SplitString(OrderComment(), ", ", result);
         int newMagic = StrToInteger(result[0]);
         timePeriod = StrToInteger(result[1]);
         st = StrToInteger(result[2]);
         int shift = StrToInteger(result[3]);
         int current = 0;
         if (shift == 0) current = 1;
         if (newMagic != OrderMagicNumber()) continue;
         int check = 0;
         check = get_strategy_result(st, OrderSymbol(), timePeriod, shift, current);
         closebox = closebox + "\nClosing Strategy: Strategy: " + st + ", symbol: " + OrderSymbol() + ", timePeriod: " + timePeriod + ", Check: " + check
         + ", magic: " + newMagic + ", Shift: " + shift + ", Current: " + current
          + ", Profit: " + OrderProfit()
          ;
         string msg;
         if (check == 1) {
            closelogicwithoutprofit(OrderSymbol(), newMagic, 1);
         }
         else if (check == -1) {
            closelogicwithoutprofit(OrderSymbol(), newMagic, -1);
         }
      }
   }
      
   return (closebox);
}



string condition_for_close_single(int magicNumber, string symbol)
{
   string closebox;
   closebox = closebox + "\nCHECKING CLOSURES: " + magicNumber + " and symbol: " + symbol;
   int cnt=0;
   int i;
   int timePeriod;
   int st;
   for(i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderMagicNumber()==magicNumber && OrderSymbol() == symbol) {
         cnt++;
         string result[3];
         SplitString(OrderComment(), ", ", result);
         int newMagic = StrToInteger(result[0]);
         timePeriod = StrToInteger(result[1]);
         st = StrToInteger(result[2]);
         int shift = StrToInteger(result[3]);
         int current = 0;
         if (shift == 0) current = 1;
         if (newMagic != OrderMagicNumber()) continue;
         int check = 0;
         check = get_strategy_result(st, OrderSymbol(), timePeriod, shift, current);
         closebox = closebox + "\nClosing Strategy: Strategy: " + st + ", symbol: " + OrderSymbol() + ", timePeriod: " + timePeriod + ", Check: " + check
         + ", magic: " + newMagic + ", Shift: " + shift + ", Current: " + current
          + ", Profit: " + OrderProfit()
          ;
         string msg;
         if (check == 1) {
            closelogicwithoutprofit(OrderSymbol(), newMagic, 1);
         }
         else if (check == -1) {
            closelogicwithoutprofit(OrderSymbol(), newMagic, -1);
         }
      }
   }
      
   return (closebox);
}


bool checkIncludeSymbol(string symbol)
{
   if (includeSymbols == "All") {
      return (true);
   }

   if (includeSymbols == "") {
      return (false);
   }
   
   string results[];
   SplitString(includeSymbols, ",", results);
   bool proceed = false;
   for (int i=0; i < ArraySize(results); i++) {
      if (symbol == results[i]) {
         proceed = true;
      }
   }

   return (proceed);
}

bool checkExcludeSymbol(string symbol)
{
   if (excludeSymbols == "All") {
      return (false);
   }

   if (excludeSymbols == "") {
      return (true);
   }
   
   string results[];
   SplitString(excludeSymbols, ",", results);
   bool proceed = true;
   for (int i=0; i < ArraySize(results); i++) {
      if (symbol == results[i]) {
         proceed = false;
      }
   }

   return (proceed);
}

bool checkSymbol(string symbol)
{
   if (!checkIncludeSymbol(symbol)) {
      return (false);
   }
   if (!checkExcludeSymbol(symbol)) {
      return (false);
   }
   return (true);
}

int create_order(string symbol, int type, double Lots, int magicnumber, string message, int stoploss, int takeprofit)
{
   int orders;
   int ordertype;
   double price;
   double val3;
   int sleeptime = 1000;
   double bids, asks, pt, digit;
   int ticket;
   double tp, sl;
   tp = 0;
   sl = 0;
   if (logs) Print("Creating order for symbol: ", symbol, " with magic: ", magicnumber);
   string createbox = symbol + ", " + magicnumber;
   //Step 1: check different conditions
   if (IsTradeAllowed()==false) {
      createbox = createbox + " TRADING NOW ALLOWED";
      if (logs) Print(createbox);
      return (0);
   }
   if (MarketInfo(symbol, MODE_SPREAD) >= maxspread) {
      createbox = createbox + " Spread is " + MarketInfo(symbol, MODE_SPREAD);
      if (logs) Print(createbox);
      return (0);
   }
   if (!checkSymbol(symbol)) {
      createbox = createbox + " Symbol Not Allowed.";
      if (logs) Print(createbox);
      return (0);
   }
   if (type == 1) {
      ordertype = OP_BUY;
   } else if (type == -1) {
      ordertype = OP_SELL;
   } else {
      return (0);
   }
   
   orders = CalculateCurrentOrdersv3(symbol, magicnumber);
   if (orders > 0)
   {
      createbox = createbox + " previous orders: " + orders + " NO TRADING";
      if (logs) Print(createbox);
       return (0);
   }
   orders = CalculateCurrent(symbol);
   if (orders > 0)
   {
      createbox = createbox + " previous symbol orders: " + orders + " NO TRADING";
      if (logs) Print(createbox);
       return (0);
   }
   orders = CalculateMaxOrders();
   if (orders >= max_orders)
   {
      createbox = createbox + " max orders: " + orders + " NO TRADING";
      if (logs) Print(createbox);
       return (0);
   }
   //Step 2: create order
   string msg;
   bids = MarketInfo(symbol, MODE_BID);
   asks = MarketInfo(symbol, MODE_ASK);
   pt = MarketInfo(symbol, MODE_POINT);
   digit = MarketInfo(symbol, MODE_DIGITS);
   bids = NormalizeDouble(bids, digit);
   asks = NormalizeDouble(asks, digit);
   int s;
   int expiration = TimeCurrent()+(6*3600);
   if (type == 1) {
      ticket=OrderSend(symbol,OP_BUY,Lots,MarketInfo(symbol, MODE_ASK),3,0,0,message,magicnumber,0,Green);
      Sleep(sleeptime);
      if(ticket>0) {
         if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
            msg = "Symbol: " + symbol + ", Buy Order Created on "
                           + TimeToStr(TimeCurrent())
                           + ", At Price: " + MarketInfo(symbol, MODE_ASK);
            SendNotification(msg);
            price = MarketInfo(symbol, MODE_ASK);
            if (stoploss > 0) {
               sl = price - (stoploss * pt);
               sl = NormalizeDouble(sl, digit);
            }
            if (takeprofit > 0) {
               tp = price + (takeprofit * pt);
               tp = NormalizeDouble(tp, digit);
            }
            OrderModify(OrderTicket(),OrderOpenPrice(),sl,tp,0,Green); 
            Sleep(sleeptime);
         }
      } else {
         Print(symbol, ", Error opening BUY order : ",ErrorDescription(GetLastError()), ", asks: ", asks, ", lots: ", Lots);
         Sleep(sleeptime);
         //create_order(symbol, type, Lots, magicnumber, message, stoploss, takeprofit);
      }
      Sleep(sleeptime);
      return(0);
   } else if (type == -1) {
       ticket=OrderSend(symbol,OP_SELL,Lots,bids,3,0,0,message,magicnumber,0,Red);
      Sleep(sleeptime);
      if(ticket>0) {
         if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) {
            msg = "Symbol: " + symbol + ", Sell Order Created on "
                           + TimeToStr(TimeCurrent())
                           + ", At Price: " + MarketInfo(symbol, MODE_ASK);
            SendNotification(msg);
            price = bids;
            if (stoploss > 0) {
               sl = price + (stoploss * pt);
               sl = NormalizeDouble(sl, digit);
            }
            if (takeprofit > 0) {
               tp = price - (takeprofit * pt);
               tp = NormalizeDouble(tp, digit);
            }
            OrderModify(OrderTicket(),OrderOpenPrice(),sl,tp,0,Green);
            Sleep(sleeptime);            
         }
      } else {
         Print(symbol, ", Error opening SELL order : ",ErrorDescription(GetLastError()), ", bids: ", bids, ", lots: ", Lots);
         Sleep(sleeptime);
         //create_order(symbol, type, Lots, magicnumber, message, stoploss, takeprofit);
      }
      Sleep(sleeptime);
      return(0);
   }
}


int CalculateCurrentOrdersv3(string symbol, int magicnumber)
{
   int cnt=0;
   int i;
   for(i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==symbol && OrderMagicNumber() == magicnumber) {
         cnt++;
      }
   }
      
   return (cnt);
}


int CalculateCurrent(string symbol)
{
   int cnt=0;
   int i;
   for(i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==symbol) {
         cnt++;
      }
   }
      
   return (cnt);
}

int CalculateMaxOrders()
{
   int cnt=0;
   int i;
   for(i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderMagicNumber() == magic || OrderMagicNumber() == magic_0 || OrderMagicNumber() == magic_1) {
         cnt++;
      }
   }
      
   return (cnt);
}




int closelogicwithoutprofit(string symbol, int magicnumber, int typeHere)
{
   int i;
   string msg;
   for(i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()==magicnumber && OrderSymbol()==symbol) {
         if(OrderType()==OP_BUY && typeHere == -1)
           {
            Print(symbol, ", closing buy order");
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_BID),3,White);
            
            msg = "Symbol: " + OrderSymbol() + ", Buy Order Closed on "
                           + TimeToStr(TimeCurrent())
                           + ", At Profit: " + OrderProfit();
            SendNotification(msg);
           }
         if(OrderType()==OP_SELL && typeHere == 1)
           {
            Print(symbol, ", closing sell order");
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_ASK),3,White);
            
            msg = "Symbol: " + OrderSymbol() + ", Sell Order Closed on "
                           + TimeToStr(TimeCurrent())
                           + ", At Profit: " + OrderProfit();
            SendNotification(msg);
         
           }
     }
   }
   return (0);
}

double totalprofitResult(double lots, int fpips)
{
   if (fpips == EMPTY_VALUE) fpips = 0;
   return (lots * fpips);
}

string totalprofit(double lots, int fpips)
{
   return (DoubleToStr(totalprofitResult(lots, fpips), 2));
}



string signals()
{
   string processbox = "";
   int status[1]; 
   string url = "http://wc5.org/forex/api/signals.php?username="+username+"&account="+AccountNumber()+"&product="+product;
   //Print(url);
   string res = httpGET(url, status);
   //Print("HTTP:",status[0]," ", res);
   string signals[100];
   SplitString(res, "\n", signals);
   for (int i=0; i < ArraySize(signals)-1; i++) {
      //Print(i,", ",signals[i]);
      string signals2[100];
      SplitString(signals[i], "|", signals2);
      string signal_type = signals2[0];
      string order_symbol = signals2[1];
      string order_type = signals2[2];
      string order_lots = signals2[3];
      double order_lots_dbl = StrToDouble(order_lots);
      string order_price = signals2[4];
      double order_price_dbl = StrToDouble(order_price);
      string order_stop_loss = signals2[5];
      int order_stop_loss_int = StrToInteger(order_stop_loss);
      string order_take_profit = signals2[6];
      int order_take_profit_int = StrToInteger(order_take_profit);
      string order_comments = signals2[7];
      string order_magic_number = signals2[8];
      int order_magic_number_int = StrToInteger(order_magic_number);
      string order_expiration = signals2[9];
      int order_expiration_int = StrToInteger(order_expiration);
      string order_ticket = signals2[10];
      int order_ticket_int = StrToInteger(order_ticket);
      Print("Signal_type:",signal_type,
         ",order_symbol:",order_symbol,
         ",order_type:",order_type,
         ",order_lots:",order_lots_dbl,
         ",order_price:",order_price_dbl,
         ",order_stop_loss:",order_stop_loss_int,
         ",order_take_profit:",order_take_profit_int,
         ",order_comments:",order_comments,
         ",order_magic_number:",order_magic_number_int,
         ",order_expiration:",order_expiration_int,
         ",order_ticket:",order_ticket_int
      );
      processbox = processbox + process(signal_type, order_symbol, order_type, order_lots_dbl, order_price_dbl, order_stop_loss_int, 
         order_take_profit_int, order_comments, order_magic_number_int, order_expiration_int, order_ticket_int);
   }
   return (processbox);
}

string process(string signal_type, string order_symbol, string order_type, double order_lots, double order_price, int order_stop_loss, 
         int order_take_profit, string order_comments, int order_magic_number, int order_expiration, int order_ticket)
{
   string processbox = "";
   string symbol = order_symbol+symbol_suffix;

   int digits = MarketInfo(symbol, MODE_DIGITS);
   double pt = MarketInfo(symbol, MODE_POINT);
   
   int current_order_type = -1;
   if (order_type == "Buy") current_order_type = OP_BUY;
   else if (order_type == "Sell") current_order_type = OP_SELL;
   else if (order_type == "SellStop") current_order_type = OP_SELLSTOP;
   else if (order_type == "BuyStop") current_order_type = OP_BUYSTOP;
   else if (order_type == "SellLimit") current_order_type = OP_SELLLIMIT;
   else if (order_type == "BuyLimit") current_order_type = OP_BUYLIMIT;

   double current_lots;
   order_lots = NormalizeDouble(order_lots, 2);
   if (order_lots > 0)
      current_lots = NormalizeDouble(order_lots, 2);
   else current_lots = lots;

   double current_order_price = 0;
   order_price = NormalizeDouble(order_price, digits);
   if (order_price > 0 && current_order_type > OP_SELL) current_order_price = order_price;

   int current_stop_loss = 0;
   if (order_stop_loss > 0) current_stop_loss = order_stop_loss;
   else if (stop_loss > 0) current_stop_loss = stop_loss;
   
   int current_take_profit = 0;
   if (order_take_profit > 0) current_take_profit = order_take_profit;
   else if (take_profit > 0) current_take_profit = take_profit;
   
   processbox = processbox + "\nSymbol: " + symbol + ", Signal: " + signal_type + ", Order Type: " + order_type
         + ", Order Type: " + current_order_type
         + ", Lots: " + DoubleToStr(current_lots, 2)
         + ", Order Price: " + current_order_price
         + ", Stop Loss: " + current_stop_loss
         + ", Take Profit: " + current_take_profit
         + ", Order Ticket: " + order_ticket
         + ", Spread: " + DoubleToStr(MarketInfo(symbol, MODE_SPREAD), 0)
      ;
   int orders = 0;
   if (signal_type == "New") {
      if (current_order_type == -1) return (0);
      //orders = CalculateMaxOrders(magic);
      int ordertype = -1;
      if (current_order_type == OP_BUY) {
         ordertype = 1;
      } else if (current_order_type == OP_SELL) {
         ordertype = -1;
      } else {
         return (processbox);
      }
      create_order(symbol, ordertype, current_lots, magic_1, magic_1, current_stop_loss, current_take_profit);
   } else if (signal_type == "Modify") {
      bool responce = OrderSelect(order_ticket, SELECT_BY_TICKET);
      symbol = OrderSymbol();
      pt = MarketInfo(symbol, MODE_POINT);
      double price;
      double sl = 0;
      double tp = 0;
      if (OrderType() == OP_BUY) {
         price = MarketInfo(symbol, MODE_ASK);
         if (current_stop_loss > 0) {
            sl = price - (current_stop_loss * pt);
            sl = NormalizeDouble(sl, digits);
         }
         if (current_take_profit > 0) {
            tp = price + (current_take_profit * pt);
            tp = NormalizeDouble(tp, digits);
         }
         OrderModify(OrderTicket(),OrderOpenPrice(),sl,tp,0,Green);
      } else if (OrderType() == OP_SELL) {
         price = MarketInfo(symbol, MODE_BID);
         if (current_stop_loss > 0) {
            sl = price + (current_stop_loss * pt);
            sl = NormalizeDouble(sl, digits);
         }
         if (current_take_profit > 0) {
            tp = price - (current_take_profit * pt);
            tp = NormalizeDouble(tp, digits);
         }
         OrderModify(OrderTicket(),OrderOpenPrice(),sl,tp,0,Red);
      }
         
      processbox = processbox + "\nOrder ticket: " + OrderTicket() + ", order open price: " + OrderOpenPrice()
      + ", price: " + price + ", pt: " + MarketInfo(symbol, MODE_POINT)
      + ", sl: " + current_stop_loss + ", tp: " + current_take_profit
      + ", sl: " + sl + ", tp: " + tp;
   } else if (signal_type == "Close") {
      close_order(symbol, current_order_type); //for op_buy close buy order, for op_sell close sell order and for others delete
   } else if (signal_type == "CloseTicket") {
      close_order_ticket(order_ticket);
   }
   return (processbox);
}


int close_order(string symbol, int order_type)
{
   int i;
   for(i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderMagicNumber()==magic_1 && OrderSymbol() == symbol) {
         if (OrderType() == order_type && OrderType() == OP_BUY) {
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_BID),3,Green);
         } else if (OrderType() == order_type && OrderType() == OP_SELL) {
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_ASK),3,Green);
         } else if (order_type == -1) {
            if (OrderType() == OP_BUY) {
               OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_BID),3,Green);
            } else if (OrderType() == OP_SELL) {
               OrderClose(OrderTicket(),OrderLots(),MarketInfo(symbol, MODE_ASK),3,Green);
            }
         }
      }
   }
}


int close_order_ticket(string ticket)
{
   Print("Closing order for ticket: ", ticket);
   OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES);
   if (OrderType() == OP_BUY)
      OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(), MODE_BID),3,Green);
   else if (OrderType() == OP_SELL)
      OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(), MODE_ASK),3,Red);
}

double orders()
{
   int cnt;
   string str = "";
   string str2 = "";
   int total = OrdersHistoryTotal();
   for(cnt=0;cnt<total;cnt++)
   {
      OrderSelect(cnt, SELECT_BY_POS, MODE_HISTORY);
      //if (OrderMagicNumber()==magic || OrderMagicNumber()==magic1 || OrderMagicNumber()==magic2) {
         str = str + "OrderTicket:" + OrderTicket();
         str = str + "|OrderLots:" + OrderLots();
         str = str + "|OrderOpenPrice:" + OrderOpenPrice();
         str = str + "|OrderOpenTime:" + OrderOpenTime();
         str = str + "|OrderType:" + OrderType();
         str = str + "|OrderSymbol:" + OrderSymbol();
         str = str + "|OrderStopLoss:" + OrderStopLoss();
         str = str + "|OrderTakeProfit:" + OrderTakeProfit();
         str = str + "|OrderClosePrice:" + OrderClosePrice();
         str = str + "|OrderCloseTime:" + OrderCloseTime();
         str = str + "|OrderCommission:" + OrderCommission();
         str = str + "|OrderSwap:" + OrderSwap();
         str = str + "|OrderComment:" + OrderComment();
         str = str + "|OrderMagicNumber:" + OrderMagicNumber();
         str = str + "|OrderProfit:" + OrderProfit();
         str = str + "\n";
      //}
   }
   
   int total2 = OrdersTotal();
   for(cnt=0;cnt<total2;cnt++)
   {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      //if (OrderMagicNumber()==magic || OrderMagicNumber()==magic1 || OrderMagicNumber()==magic2) {
         str2 = str2 + "OrderTicket:" + OrderTicket();
         str2 = str2 + "|OrderLots:" + OrderLots();
         str2 = str2 + "|OrderOpenPrice:" + OrderOpenPrice();
         str2 = str2 + "|OrderOpenTime:" + OrderOpenTime();
         str2 = str2 + "|OrderType:" + OrderType();
         str2 = str2 + "|OrderSymbol:" + OrderSymbol();
         str2 = str2 + "|OrderStopLoss:" + OrderStopLoss();
         str2 = str2 + "|OrderTakeProfit:" + OrderTakeProfit();
         str2 = str2 + "|OrderClosePrice:" + OrderClosePrice();
         str2 = str2 + "|OrderCloseTime:" + OrderCloseTime();
         str2 = str2 + "|OrderCommission:" + OrderCommission();
         str2 = str2 + "|OrderSwap:" + OrderSwap();
         str2 = str2 + "|OrderComment:" + OrderComment();
         str2 = str2 + "|OrderMagicNumber:" + OrderMagicNumber();
         str2 = str2 + "|OrderProfit:" + OrderProfit();
         str2 = str2 + "\n";
      //}
   }

   string str3 = "";
   str3 = str3 + "AccountBalance:" + AccountBalance();
   str3 = str3 + "|AccountCredit:" + AccountCredit();
   str3 = str3 + "|AccountCurrency:" + AccountCurrency();
   str3 = str3 + "|AccountCompany:" + AccountCompany();
   str3 = str3 + "|AccountCurrency:" + AccountCurrency();
   str3 = str3 + "|AccountEquity:" + AccountEquity();
   str3 = str3 + "|AccountFreeMargin:" + AccountFreeMargin();
   str3 = str3 + "|AccountFreeMarginMode:" + AccountFreeMarginMode();
   str3 = str3 + "|AccountLeverage:" + AccountLeverage();
   str3 = str3 + "|AccountMargin:" + AccountMargin();
   str3 = str3 + "|AccountName:" + AccountName();
   str3 = str3 + "|AccountProfit:" + AccountProfit();
   str3 = str3 + "|AccountServer:" + AccountServer();
   str3 = str3 + "|AccountStopoutLevel:" + AccountStopoutLevel();
   str3 = str3 + "|AccountStopoutMode:" + AccountStopoutMode();
   string params [0,3];
   ArrayResize( params, 0);
   int status[1];
   addParam("history",str,params);
   addParam("current",str2,params);
   addParam("company",str3,params);
   string req = ArrayEncode(params);
   string url = "http://wc5.org/forex/api/accessOrders.php?username="+username+"&account="+AccountNumber()+"&product="+product;
   
   Print(url);
   string res = httpPOST(url, req, status);
   Print("HTTP:",status[0]," ", res);
   return (0);
}


int sample()
  {
  
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
   //string res = httpGET("http://127.0.0.1/test?"+ req, status);
   string url = "http://wc5.org/forex/api/accessOrders.php?username="+username+"&account="+AccountNumber()+"&product="+product;
   
   Print(url);
   string res = httpPOST(url, req, status);
   Print("HTTP:",status[0]," ", res);
    
   return(0);
  }
  
  
double ordersOpen()
{
   int cnt;
   string str = "";
   string str2 = "";   
   int total2 = OrdersTotal();
   for(cnt=0;cnt<total2;cnt++)
   {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      //if (OrderMagicNumber()==magic || OrderMagicNumber()==magic1 || OrderMagicNumber()==magic2) {
         str2 = str2 + "OrderTicket:" + OrderTicket();
         str2 = str2 + "|OrderLots:" + OrderLots();
         str2 = str2 + "|OrderOpenPrice:" + OrderOpenPrice();
         str2 = str2 + "|OrderOpenTime:" + OrderOpenTime();
         str2 = str2 + "|OrderType:" + OrderType();
         str2 = str2 + "|OrderSymbol:" + OrderSymbol();
         str2 = str2 + "|OrderStopLoss:" + OrderStopLoss();
         str2 = str2 + "|OrderTakeProfit:" + OrderTakeProfit();
         str2 = str2 + "|OrderClosePrice:" + OrderClosePrice();
         str2 = str2 + "|OrderCloseTime:" + OrderCloseTime();
         str2 = str2 + "|OrderCommission:" + OrderCommission();
         str2 = str2 + "|OrderSwap:" + OrderSwap();
         str2 = str2 + "|OrderComment:" + OrderComment();
         str2 = str2 + "|OrderMagicNumber:" + OrderMagicNumber();
         str2 = str2 + "|OrderProfit:" + OrderProfit();
         str2 = str2 + "\n";
      //}
   }

   if (str2 == "") return (0);
   string params [0,1];
   ArrayResize( params, 0);
   int status[1]; 
   addParam("current",str2,params);
   string req = ArrayEncode(params);
   string url = "http://wc5.org/forex/api/accessOrders.php?username="+username+"&account="+AccountNumber()+"&product="+product;
   Print(url);
   string res = httpPOST(url, req, status);
   Print("HTTP:",status[0]," ", res);
   return (0);
}


double weeklyprofit()
{
   int total = OrdersHistoryTotal();
   double gtotal = 0;
   int weekday=TimeDayOfWeek(TimeCurrent());
   int timeStart = TimeCurrent() - (60*60*24*weekday);
   Print("start: ", TimeToStr(timeStart));
   int newTime =StrToTime(TimeYear(timeStart)+"."+TimeMonth(timeStart)+"."+TimeDay(timeStart)+" 00:00");
   Print("newTime: ", TimeToStr(newTime));
   for(int cnt=0;cnt<total;cnt++)
   {
      OrderSelect(cnt, SELECT_BY_POS, MODE_HISTORY);
      if (OrderCloseTime() < newTime) continue;
      if (OrderType()==OP_BUY || OrderType()==OP_SELL) {
         gtotal = gtotal + OrderProfit();
      }
   }
   return (gtotal);
}

string intro()
{
   string box = "";
      box = box + "\nWelcome to MillionDollar Expert Advisor";
      box = box + "\nVersion: " + EA_Version;
      box = box + "\nLicensed To: " + username;
      double total = AccountBalance();
      if (inital_amount > 0) total = inital_amount;
      double d = 100 / max_orders;
      int percPerDay = 1;
      double aim = (total * percPerDay/100);
      lots = ((total / 100) * (d / 100)) / 100;
      if (lots < 0.01) lots = 0.01;
      if (lotsize > 0) lots = lotsize;
      lots = NormalizeDouble(lots, 2);
      double weeklytotal = weeklyprofit();
      box = box + "\nTotal Amount: " + total + ", Max Orders: " + max_orders + ", Max Spread: " + maxspread
         + ", Lots: " + lots
          + ", Magic: " + magic
          + ", Aim Per Day: " + aim
          + ", Aim Per Week: " + (aim * 5)
          + "\nWeek Profit: " + weeklytotal
          + ", Profit Remaining: " + ((aim * 5) - weeklytotal)
      ;
    return (box);
}