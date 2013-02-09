//+------------------------------------------------------------------+
//|                                                 2_NzdBigEarn.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"
#define MAGICMA  20120329

extern bool upward_trend = false;
extern double    TakeProfit=50;
extern double    BigLot=0.15;
extern double    SmallLot=0.05;
string infobox;
int cnt = 0;
double askprice = 0;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   string demo;
   if(IsDemo()) demo = "Demo Account";
   else demo = "Live Account";
   askprice = Ask;

    infobox = StringConcatenate("\n","\n",
      "Account Number = ",AccountNumber(),
      "\n",
      "Account name = ",AccountName(),
      "\n",
      "Account leverage = ",AccountLeverage(),
      "\n",
      "Account Type = ",demo,
      "\n",
      "Account company name = ",AccountCompany(),
      "\n",
      "Account currency = ",AccountCurrency(),
      "\n",
      "Account server = ",AccountServer());
      

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
   string showinfobox;
   cnt++;
   if (cnt % 15 == 0) {
   askprice = Ask;
   }
    showinfobox = StringConcatenate(
      "\n","\n",
      "Bid Price: ", DoubleToStr(Bid,Digits),
      "\n",
      "Ask Price: ", DoubleToStr(Ask,Digits),
      "\n","\n",
      "Account balance = ",AccountBalance(),
      "\n",
      "Account equity = ",AccountEquity(),
      "\n",
      "Account credit = ",AccountCredit(),
      "\n",
      "Account free margin = ",AccountFreeMargin(),
      "\n",
      "Account margin = ",AccountMargin(),
      "\n",
      "Account profit = ",AccountProfit(),
      "\n",
      "Account StopOut level = ",AccountStopoutLevel(),
      "\n",
      "Account  Stop Out level mode = ",AccountStopoutLevel(),
      "\n",
      "Cnt: ", cnt,
      "\n",
      "Ask Price: ", DoubleToStr(askprice,Digits));
   Comment(infobox, showinfobox);
   //if (Ask < 0.81500)
    //SendMail("from your expert", "Price dropped down to "+DoubleToStr(lastclose,Digits));

   for(int i=0;i<OrdersTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS)==false) { Print("Error in history!"); break; }
      Print("line: ", i);
      Print("order symbol: ", OrderSymbol());
      Print("symbol: ", Symbol());
      Print("order type: ", OrderType());
      Print("order profit: ", OrderProfit());
      Print("OrderOpenPrice: ", OrderOpenPrice());
      Print("OrderOpenTime: ", OrderOpenTime());
      Print("OrderPrint: ", OrderPrint());
      Print("OrderMagicNumber: ", OrderMagicNumber());
      Print("OrderSwap: ", OrderSwap());
      Print("OrderTakeProfit: ", OrderTakeProfit());
      Print("OrderTicket: ", OrderTicket());
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+