//+------------------------------------------------------------------+
//|                                          Simple_H1_GBPUSD_EA.mq4 |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+

#property copyright "Copyright 2010, O3 Power Ltd"
#property link      "http://www.o3power.co.uk"


int     iMagicNumber      = 971465;
datetime Time0 = 0;
int Day0=0;
int Day1=0;
extern int TakeProfit1 = 18;
extern int TakeProfit2 =150;
extern int StopLoss = 150;
double Poin;
extern bool   useTrailing = true;
extern double iTrailingStop = 18;
extern bool   UseMoneyMgmt = false;
extern double RiskPercent = 1;
extern bool Low_Risk = false;
extern bool Med_Risk = false;
extern bool High_Risk= false;
extern bool Vhigh_Risk= false;
extern bool   Manual_Lot_Size = true;
extern double Lotsize = 0.05;
extern int fast_ema=13;
extern int GMToffset=1;
extern int Start_Time= 23;
extern bool   Show_Settings  = true;

bool   MicroOrdersAllowed = true;
bool   MiniOrdersAllowed = true;
bool trade=false;
double  high_price, low_price , high_price2, low_price2, dLots;
int   iTicket, iTotalOrders,trend,Status,signal, BarCount, TradePerBar, var2;
static double latest;
static double aLots;
static int halt=0;
static double last_high, last_low; 
double TimeOfLastUpFractal, TimeOfLastDownFractal, totalopenorders ;
double LastUpFractal_H1,LastDownFractal_H1,TimeOfLastDownFractal_H1,TimeOfLastUpFractal_H1;
static double latestbuy, latestup, latestdn;
static double latestsell ;  
double dblProfit=0;
double spread;
static int lastv, lastw;
int direction=0;
static double latest_hizig, latest_lozig;
double zigspread, TakeProfit, iStopLoss, average, current;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
iMagicNumber    = subGenerateMagicNumber( iMagicNumber, Symbol(), Period() );

//----
//Checking for unconventional Point digits number
if (Point == 0.00001) Poin = 0.0001; //6 digits
else if (Point == 0.001) Poin = 0.01; //3 digits (for Yen based pairs)
else Poin = Point; //Normal 
   

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
  
  if ( !IsDllsAllowed() ) {
      Alert( "Clock V1_2: DLLs are disabled.  To enable tick the checkbox in the Common Tab of indicator" );
      return;
  }
//----
if (Low_Risk==true){
   if(AccountEquity() <10000) RiskPercent=0.7;
   else if(AccountEquity() >= 10000 && AccountEquity() <=14999) RiskPercent=0.60;
   else if(AccountEquity() >= 15000 && AccountEquity() <=19999) RiskPercent=0.50;
   else if(AccountEquity() >= 20000 && AccountEquity() <=24999) RiskPercent=0.40;
   else if(AccountEquity() >= 25000 && AccountEquity() <=29999) RiskPercent=0.30;
   else if(AccountEquity() >= 30000 && AccountEquity() <=39999) RiskPercent=0.20;
   else if(AccountEquity() >= 40000 && AccountEquity() <=49999) RiskPercent=0.10;
   else if(AccountEquity() >= 50000 && AccountEquity() <=74999) RiskPercent=0.09;
   else if(AccountEquity() >= 750000 && AccountEquity() <=99999) RiskPercent=0.08;
   else if(AccountEquity() >= 100000) RiskPercent=0.07;
   }
if (Med_Risk==true){
   if(AccountEquity() <10000) RiskPercent=0.9;
   else if(AccountEquity() >= 10000 && AccountEquity() <=14999) RiskPercent=0.80;
   else if(AccountEquity() >= 15000 && AccountEquity() <=19999) RiskPercent=0.70;
   else if(AccountEquity() >= 20000 && AccountEquity() <=24999) RiskPercent=0.60;
   else if(AccountEquity() >= 25000 && AccountEquity() <=29999) RiskPercent=0.50;
   else if(AccountEquity() >= 30000 && AccountEquity() <=39999) RiskPercent=0.40;
   else if(AccountEquity() >= 40000 && AccountEquity() <=49999) RiskPercent=0.30;
   else if(AccountEquity() >= 50000 && AccountEquity() <=74999) RiskPercent=0.20;
   else if(AccountEquity() >= 750000 && AccountEquity() <=99999) RiskPercent=0.10;
   else if(AccountEquity() >= 100000) RiskPercent=0.10;
   }
if (High_Risk==true){
   if(AccountEquity() <10000) RiskPercent=1.30;
   else if(AccountEquity() >= 10000 && AccountEquity() <=14999) RiskPercent=1.20;
   else if(AccountEquity() >= 15000 && AccountEquity() <=19999) RiskPercent=1.10;
   else if(AccountEquity() >= 20000 && AccountEquity() <=24999) RiskPercent=1.00;
   else if(AccountEquity() >= 25000 && AccountEquity() <=29999) RiskPercent=0.90;
   else if(AccountEquity() >= 30000 && AccountEquity() <=39999) RiskPercent=0.80;
   else if(AccountEquity() >= 40000 && AccountEquity() <=49999) RiskPercent=0.70;
   else if(AccountEquity() >= 50000 && AccountEquity() <=74999) RiskPercent=0.60;
   else if(AccountEquity() >= 750000 && AccountEquity() <=99999) RiskPercent=0.50;
   else if(AccountEquity() >= 100000) RiskPercent=0.40;
   }
if (Vhigh_Risk==true) RiskPercent=1.00;

  double Risk = RiskPercent / 100;
  int OrdersizeAllowed = 0;
  
  if (MiniOrdersAllowed) OrdersizeAllowed=1;
  if (MicroOrdersAllowed) OrdersizeAllowed=2;        
 if (UseMoneyMgmt==true)
   {
    dLots = NormalizeDouble( AccountBalance()*Risk/StopLoss/(MarketInfo(Symbol(), MODE_TICKVALUE)),OrdersizeAllowed);
      }  
      
  if (Manual_Lot_Size == true) 
   {
  dLots = NormalizeDouble(Lotsize,OrdersizeAllowed); 
      }   
  if ((dLots < 0.01&&MicroOrdersAllowed) || (dLots < 0.1&&MiniOrdersAllowed&&MicroOrdersAllowed==false))
      {
         Comment("YOUR LOTS SIZE IS TOO SMALL TO PLACE!");
      } 

   int  iCrossed, xCrossed;
   
   // get total number of orders 
   iTotalOrders = OrdersTotal();
   
   // see if we have a new cross
   iCrossed  = CheckForCross();
   
   // do functions 
  if(iTotalOrders != 0 && useTrailing == true) TrailingStop(iTotalOrders);
//----
   return(0);
  }
//+------------------------------------------------------------------+

void TrailingStop(int iTotal){

   int iCount;
   
   if(iTrailingStop < 1)return(-1); // error
   
   for(iCount=0;iCount<iTotal;iCount++){

      OrderSelect(iCount, SELECT_BY_POS, MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber() == iMagicNumber)
         switch(OrderType()){
            case OP_BUY:
               if(Bid-OrderOpenPrice()>Poin*iTrailingStop){
                  if(OrderStopLoss()<Bid-Poin*iTrailingStop){
                     OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Poin*iTrailingStop,OrderTakeProfit(),0,Green);
                  }
               }
               break;
            case OP_SELL:
               if((OrderOpenPrice()-Ask)>(Poin*iTrailingStop)){
                  if((OrderStopLoss()>(Ask+Poin*iTrailingStop)) || (OrderStopLoss()==0)){
                     OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Poin*iTrailingStop,OrderTakeProfit(),0,Red);
                  }
               }
               break;
         }
      }
   
      return(0);
}

   
 //+---------------------------------------------------------+

   int CheckForCross(){

  if ( Show_Settings )
       PrintDetails();
   int i, cnt  ;
   int buyorder=0;
   int sellorder=0;
   int sellstop = 0;
   int buystop = 0;
   int dir=0;
   int order=0;
   int Ticket=0;
  
  int total = OrdersTotal();

      i= 0;
      for (i = 0; i < total; i++) 
      {
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == iMagicNumber) 
         {
              if (OrderType()==OP_BUY) {buyorder = buyorder +1;}
         else if (OrderType()==OP_SELL) {sellorder = sellorder +1;}
         } //end if
     } //end for
     
     totalopenorders= buyorder+sellorder;

trade = true;
      
   dblProfit=0;
   i= 0;
      for (i = 0; i < total; i++)
   {
   if(OrderSelect(i,SELECT_BY_POS))
   {
   if(OrderMagicNumber()==iMagicNumber) dblProfit=dblProfit+OrderProfit();
   }
   }
      
      RefreshRates();
      double LastLow, LastHigh, TimeOfLastHigh, TimeOfLastLow;
      int LastLowBar, LastHighBar;
      
      for( int v=1;v<Bars;v++){
      if(iHighest(NULL,0,MODE_HIGH,12,v) !=0){//highest price in previous 12 hours
         high_price=High[iHighest(NULL,0,MODE_HIGH,12,v)];
         lastv=iHighest(NULL,0,MODE_HIGH,12,v);          
         break;
         }//end if        
      }//end for
       
      for( int w=1;w<Bars;w++){
      if(iLowest(NULL,0,MODE_LOW,12,w) !=0){//lowest price in previous 12 hours
         low_price=Low[iLowest(NULL,0,MODE_LOW,12,w)];
         lastw=iLowest(NULL,0,MODE_LOW,12,w);         
         break;
         }//end if         
      }//end for
      int x;
      double adr_total, adr;
      average = 0;
      for( x=1;x<11;x++){
         adr = iHigh(NULL,PERIOD_D1,x)-iLow(NULL,PERIOD_D1,x);
         adr_total = adr_total+adr;        
         }//end for
         average = adr_total/10;
         
         current = MathAbs(iHigh(NULL,PERIOD_D1,0)-iLow(NULL,PERIOD_D1,0));
         
  static double daily_high;
  static double daily_low;
  static double daily_pivot;
   
      if(Hour() == 1){
             daily_high = High[iHighest(NULL,0,MODE_HIGH,24,1)];
             daily_low = Low[iLowest(NULL,0,MODE_LOW,24,1)];
            double daily_range= daily_high-daily_low;
             daily_pivot = daily_low + (daily_range/2);
            double bull_positive1= daily_range*0.34;
            TakeProfit = bull_positive1;
            double bull_target1= daily_high+bull_positive1;
            double bear_negative1=daily_range*0.34;
            iStopLoss = daily_range;
            double bear_target1= daily_low - bear_negative1;
            ObjectDelete("Daily_Pivot");
            ObjectDelete("Daily_High");
            ObjectDelete("Daily_Low");
            ObjectDelete("Bull_Tgt1");
            ObjectDelete("Bear_Tgt1");
            ObjectCreate("Bull_Tgt1",OBJ_HLINE,0,Time[1],bull_target1);
            ObjectSet("Bull_Tgt1",OBJPROP_COLOR,Aqua);          
            ObjectCreate("Daily_Pivot",OBJ_HLINE,0,Time[1],daily_pivot);
            ObjectSet("Daily_Pivot",OBJPROP_COLOR,Yellow);
            ObjectCreate("Daily_High",OBJ_HLINE,0,Time[1],daily_high);
            ObjectSet("Daily_High",OBJPROP_COLOR,Blue);
            ObjectCreate("Daily_Low",OBJ_HLINE,0,Time[1],daily_low);
            ObjectSet("Daily_Low",OBJPROP_COLOR,Lime);
            ObjectCreate("Bear_Tgt1",OBJ_HLINE,0,Time[1],bear_target1);
            ObjectSet("Bear_Tgt1",OBJPROP_COLOR,Magenta);
            }//end if 
          
// Place order..............  
   if(trade==true){
      if(       
                 Hour() == Start_Time+GMToffset
                 && Close[1] > iMA(NULL,0,fast_ema,0,MODE_SMA,PRICE_CLOSE,1)
                
                 )                  
            {                         
             if (buyorder==0 && Time0 != Time[0])
               {
             RefreshRates();
             OrderSend(Symbol(),OP_BUY,dLots,Ask,5,Ask-StopLoss*Poin,Ask+TakeProfit1*Poin,"H1 GBP Buy1",iMagicNumber,0,Blue);
             OrderSend(Symbol(),OP_BUY,dLots,Ask,5,Ask-StopLoss*Poin,Ask+TakeProfit2*Poin,"H1 GBP Buy2",iMagicNumber,0,Blue);
             Time0 = Time[0];
             } 
           }
      
         
             if( 
                 Hour() == Start_Time+GMToffset
                 && Close[1] < iMA(NULL,0,fast_ema,0,MODE_SMA,PRICE_CLOSE,1)
             )               
              {
             if (sellorder==0  && Time0 != Time[0])
               {
               RefreshRates();
               OrderSend(Symbol(),OP_SELL,dLots,Bid,5,Bid+StopLoss*Poin,Bid-TakeProfit1*Poin,"H1 GBP Sell1",iMagicNumber,0,Red);
               OrderSend(Symbol(),OP_SELL,dLots,Bid,5,Bid+StopLoss*Poin,Bid-TakeProfit2*Poin,"H1 GBP Sell2",iMagicNumber,0,Red);
                Time0 = Time[0];
                }
              }              
           }
           
   return(0);
} 

//+-----------------------------------------------------------------------+

  //----------------------- GENERATE MAGIC NUMBER BASE ON SYMBOL AND TIME FRAME FUNCTION
//----------------------- SOURCE   : PENGIE
//----------------------- MODIFIED : FIREDAVE
int subGenerateMagicNumber(int iMagicNumber, string symbol, int timeFrame)
{
   int isymbol = 0;
   if (symbol == "EURUSD")       isymbol = 1;
   else if (symbol == "GBPUSD")  isymbol = 2;
   else if (symbol == "USDJPY")  isymbol = 3;
   else if (symbol == "USDCHF")  isymbol = 4;
   else if (symbol == "AUDUSD")  isymbol = 5;
   else if (symbol == "USDCAD")  isymbol = 6;
   else if (symbol == "EURGBP")  isymbol = 7;
   else if (symbol == "EURJPY")  isymbol = 8;
   else if (symbol == "EURCHF")  isymbol = 9;
   else if (symbol == "EURAUD")  isymbol = 10;
   else if (symbol == "EURCAD")  isymbol = 11;
   else if (symbol == "GBPUSD")  isymbol = 12;
   else if (symbol == "GBPJPY")  isymbol = 13;
   else if (symbol == "GBPCHF")  isymbol = 14;
   else if (symbol == "GBPAUD")  isymbol = 15;
   else if (symbol == "GBPCAD")  isymbol = 16;
   else                          isymbol = 17;
   if(isymbol<10) iMagicNumber = iMagicNumber * 10;
   return (StrToInteger(StringConcatenate(iMagicNumber, isymbol, timeFrame)));
}
void PrintDetails()
{
   string sComment   = "";
   string sp         = "----------------------------------------\n";
   string NL         = "\n";
   
   sComment = sp;
   sComment = sComment + "H1 GBPUSD EA"+ NL;
   sComment = sComment + "Take Profit = " + DoubleToStr(TakeProfit1,0) + " | ";
   sComment = sComment + "StopLoss = " + DoubleToStr(StopLoss,0) + NL;
   sComment = sComment + "TrailingStop = " + DoubleToStr(iTrailingStop,0) + " | ";
   sComment = sComment + "OrderLots = " +DoubleToStr(dLots,2) +NL;
   sComment = sComment + "MM Risk = " +DoubleToStr(RiskPercent,2) + "%"  + NL;  
   sComment = sComment + "Profit/Loss = " + DoubleToStr(dblProfit,2) + NL;
   sComment = sComment + "-------------------------------------------------------------------------" +NL;
   sComment = sComment + "Analysis:"+ NL;
   sComment = sComment + "Average Daily Range  = " +DoubleToStr(average*10000,0) + NL;
   sComment = sComment + "Current Daily Range  = " +DoubleToStr(current*10000,0) + NL;
   if(current >= average){
   sComment = sComment + "AVERAGE DAILY RANGE EXCEEDED"+ NL;} 
   else
   sComment = sComment + "Average Daily Range not reached"+ NL; 
   sComment = sComment + "-------------------------------------------------------------------------" +NL;
   sComment = sComment + "Account Information:"+ NL;
   sComment = sComment + "Account Balance = " +DoubleToStr(AccountBalance(),2)+" USD" + NL;
   sComment = sComment + "Account Equity  = " +DoubleToStr(AccountEquity(),2)+" USD" + NL;
   sComment = sComment + "-------------------------------------------------------------------------" +NL; 
   sComment = sComment + "Start Time = " +DoubleToStr(Start_Time,0)+":00" +NL;
   sComment = sComment + "Current Time = " +DoubleToStr(Hour(),2) +NL;
   sComment = sComment + "-------------------------------------------------------------------------" +NL;  
   sComment = sComment + "Symbols: "+Symbol()+ NL;
   sComment = sComment + sp;
   //---- 3 seconds wait
   Sleep(3000);
   //---- refresh data
   RefreshRates();

   Comment(sComment);
}

