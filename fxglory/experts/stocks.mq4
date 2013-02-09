//+------------------------------------------------------------------+
//|                                                       stocks.mq4 |
//|                                              Manish Khanchandani |
//|                                   http://manishkhanchandani.info |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://manishkhanchandani.info"

double initial_bid, initial_ask, initial_sub_bid, initial_sub_ask;
string filename;
int handle;

string var_names[100][2];//0 is name, 1 is label
double var_values[100][9][50];
double common_values[10];
string filenames[9];
extern int number = 1;
int handles[9];
int timeperiod[9] = {PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1, PERIOD_H4, PERIOD_D1, PERIOD_W1, PERIOD_MN1};
string infobox;
string startbox;
//0 is initial bid, 1 is initial ask
 
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
   //Check condition first
   startbox = "\n";
   double t1 = common_values[2];
   double t2 = Bid;
   double t3 = t2 - t1;
   int t4 = t3 / Point;
   if (t4 >= 100 || t4 < -100) {
      startbox = StringConcatenate(startbox, "Initial Bid: ", common_values[2], ", Current: ", Bid, ", points: ", t4);
      common_values[2] = Bid;
      common_values[3] = Ask;
      gatherdata();
      FileAppend(filename, "");
      FileAppend(filename, "Time: " + TimeToStr(TimeCurrent()));
      if (t4 >= 100) {
         FileAppend(filename, "Buy");
      } else if (t4 < -100) {
         FileAppend(filename, "Sell");
      }
      FileAppend(filename, "Initial Bid, Initial Ask, Sub Bid, Sub Ask");
      FileAppend(filename, DoubleToStr(common_values[0], Digits) + ", " + DoubleToStr(common_values[1], Digits) + ", " + DoubleToStr(common_values[2], Digits) + ", " + DoubleToStr(common_values[3], Digits));

      for (int i=0; i<9; i++) {
         FileAppend(filename, "");
         FileAppend(filename, "MACD " + TimeframeToString(timeperiod[i]));
         FileAppend(filename, "MACD 0" + ", " + "MACD 1" + ", " + "MACD 2");
         FileAppend(filename, DoubleToStr(var_values[0][i][0], Digits) + ", " + DoubleToStr(var_values[0][i][1], Digits) + ", " + DoubleToStr(var_values[0][i][2], Digits));
      }
   }

   Comment(infobox, startbox);
//----
   return(0);
  }
//+------------------------------------------------------------------+

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
   }
}
void custom_init()
{
   //variable names
   var_names[0][0] = "MACD";
   var_names[0][1] = "MACD";
   //initial price
   common_values[0] = Bid;
   common_values[1] = Ask;
   common_values[2] = Bid;
   common_values[3] = Ask;

   gatherdata();
   filename = Symbol() + "/" + Time[0] + ".csv";
   infobox = "";
   infobox = StringConcatenate(infobox, "Filename: ", filename);
   FileAppend(filename, "INITIAL DATA");
   FileAppend(filename, "Symbol: " + Symbol());
   FileAppend(filename, "Time: " + TimeToStr(TimeCurrent()));
   FileAppend(filename, "Initial Bid, Initial Ask, Initial Sub Bid, Initial Sub Ask");
   FileAppend(filename, DoubleToStr(common_values[0], Digits) + ", " + DoubleToStr(common_values[1], Digits) + ", " + DoubleToStr(common_values[2], Digits) + ", " + DoubleToStr(common_values[3], Digits));
   infobox = StringConcatenate(infobox, "\nInitial Bid: ", DoubleToStr(common_values[0], Digits));
   infobox = StringConcatenate(infobox, "\nInitial Ask: ", DoubleToStr(common_values[1], Digits));
   infobox = StringConcatenate(infobox, "\nSub Bid: ", DoubleToStr(common_values[2], Digits));
   infobox = StringConcatenate(infobox, "\nSub Ask: ", DoubleToStr(common_values[3], Digits));
   Comment(infobox);
      for (int i=0; i<9; i++) {
         FileAppend(filename, "");
         FileAppend(filename, "MACD " + TimeframeToString(timeperiod[i]));
         FileAppend(filename, "MACD 0" + ", " + "MACD 1" + ", " + "MACD 2");
         FileAppend(filename, DoubleToStr(var_values[0][i][0], Digits) + ", " + DoubleToStr(var_values[0][i][1], Digits) + ", " + DoubleToStr(var_values[0][i][2], Digits));
      }
   
   return(0);
}

void gatherdata()
{
   for (int i=0; i<9; i++) {
      var_values[0][i][0] = iMACD(NULL,timeperiod[i],12,26,9,PRICE_CLOSE,MODE_MAIN,0);
      var_values[0][i][1] = iMACD(NULL,timeperiod[i],12,26,9,PRICE_CLOSE,MODE_MAIN,1);
      var_values[0][i][2] = iMACD(NULL,timeperiod[i],12,26,9,PRICE_CLOSE,MODE_MAIN,2);
   }
}

void FileAppend(string name,string txt)
{
   int handle = FileOpen(name,FILE_READ|FILE_WRITE);
	FileSeek(handle,0,SEEK_END);
	FileWrite(handle,txt);
	FileFlush(handle);
	FileClose(handle);
}