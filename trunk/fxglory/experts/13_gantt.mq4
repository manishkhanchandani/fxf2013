//+------------------------------------------------------------------+
//|                                                     12_gantt.mq4 |
//|                                              Manish Khanchandani |
//|                                              http://mkgalaxy.com |
//+------------------------------------------------------------------+
#property copyright "Manish Khanchandani"
#property link      "http://mkgalaxy.com"
#define MAGICMA  1974060512

extern double Lots               = 0.01;
double build = 1.1;
int g_entry_1_type = 0;
int g_entry_2_type = 0;

int CalculateCurrentOrders()
  {
   int cnt=0;
//----
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA)
        {
         cnt++;
        }
     }
//---- return orders volume
   return (cnt);
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
   }
}

void CheckForOpen()
  {
   
   Print("Checking for open conditions.");
   string res;
   string comment;
   string description = StringTrimRight(ObjectDescription("Type"));
   double entry_1 = StrToDouble(StringSubstr(ObjectDescription("Entry1"), 12));
   double entry_2 = StrToDouble(StringSubstr(ObjectDescription("Entry2"), 12));
   double tp_1 = StrToDouble(StringSubstr(ObjectDescription("TP1"), 8));
   double tp_2 = StrToDouble(StringSubstr(ObjectDescription("TP2"), 8));
   double sl = StrToDouble(StringSubstr(ObjectDescription("SL "), 7));
   int type;
   int result;
   double price;
   Print("description: ", description, ", entry 1: ", entry_1, ", entry 2: ", entry_2, ", tp1: ", tp_1, ", tp2: ", tp_2,", sl: ", sl);
   if(description == "SELL") {
      type = OP_SELL;
      price = Bid;
   } else {
      type = OP_BUY;
      price = Ask;
   }
   comment = StringConcatenate("GTech: ", build, ", ", TimeframeToString(Period()));
   if (g_entry_1_type == 1 && Bid < entry_1) {
      //create new order
      g_entry_1_type = 0;
      result = createorder(type, Lots, price, sl, tp_1, comment);
   } else if (g_entry_1_type == -1 && Bid > entry_1) {
      //create new order
      g_entry_1_type = 0;
      result = createorder(type, Lots, price, sl, tp_1, comment);
   } else if (g_entry_2_type == 1 && Bid < entry_2) {
      //create new order
      g_entry_2_type = 0;
      result = createorder(type, Lots, price, sl, entry_1, comment);
   } else if (g_entry_2_type == -1 && Bid > entry_2) {
      //create new order
      g_entry_2_type = 0;
      result = createorder(type, Lots, price, sl, entry_1, comment);
   }
   
   
   
   if (Bid > entry_1) {
      g_entry_1_type = 1;
   } else {
      g_entry_1_type = -1;
   }
   if (Bid > entry_2) {
      g_entry_2_type = 1;
   } else {
      g_entry_2_type = -1;
   }
   Print("End of open checking function.");
   return;
  }

void CheckForClose()
{
//----
   return;
   int i;
   int res;
   for(i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
     }
    
//----
  }
  
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   Print("Expert Advisor : Gnatt");
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
   if(Bars<100 || IsTradeAllowed()==false) return;
   int orders = CalculateCurrentOrders();
   Print("orders: ", orders);
   if(orders==0) CheckForOpen();
   else                                    CheckForClose();
//----
   return(0);
  }
//+------------------------------------------------------------------+


int createorder(int type, double lot, double price, double sl, double tp, string comment)
{
   //res=OrderSend(Symbol(),OP_SELL,LotsOptimized(),Bid,3,0,0,"",MAGICMA,0,Red);
   int res = 0;
   res = OrderSend(Symbol(), type, lot, price, 3, sl, tp, comment, MAGICMA, 0, Red);
   Print("Result: ", res, " with error: ", GetLastError());
   return (res);
}