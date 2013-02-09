//+------------------------------------------------------------------+
//|  BreakoutAlert_V1.10.mq4                                         |
//|  Copyright PipPicker © 2009                                      |
//|  --------------------------                                      |
//|  Version: 1.10                                                   |
//|  Modified Date: 26 April 2009                                    |
//|  Modified by: PipPicker                                          |
//+------------------------------------------------------------------+

#property copyright "PipPicker"
#include <stderror.mqh>
#include <stdlib.mqh>


extern string Signal_Parameters = "-------- Signal Parameters --------"; 

//- Allow Alerting
extern bool AllowAlerting = true; 

//- Acceptable upper and lower range percentage of the bar that open and close should be in
extern double AcceptableBarRangePercentage = 30; 

//- Moving Average Period
extern double MovingAveragePeriod = 21; 

//- Bollinger Band Period
extern double BollingerBandPeriod = 9; 

//- Bollinger Band Shift
extern double BollingerBandShift = 0; 

//- Bollinger Band Deviation
extern double BollingerBandDeviation = 1; 

//- Bollinger Band UpperLevel
extern double BollingerBandUpperLevel = 0.75; 

//- Bollinger Band LowerLevel
extern double BollingerBandLowerLevel = -0.75; 

//- Display Signal Arrow
extern bool DisplaySignalArrow = true; 

//- Display Why It Is Not Signal
extern bool DisplayWhyItIsNotSignal = false; 


extern string Order_Parameters = "-------- Order Parameters --------"; 

//- Allow Trading
extern bool AllowTrading = true; 

//- ATR Period
extern int ATR_Period = 14; 

//- Allow Placing 1st Position Orders (with TakeProfit)
extern bool AllowPlacing1stPosOrders = true; 

//- Allow Placing 2nd Position Orders (without TakeProfit)
extern bool AllowPlacing2ndOrders = true; 

//- Number Of Pips To Place Order On Top Of Spread
extern int PipsToPlaceOrderOnTopOfPrice = 1;

//- Is Take Profit fixed
extern bool FixedTakeProfit = false; 

//- Take Profit Coefficient To ATR
extern double TakeProfitCoefficientToATR = 0.66; 

//- Take Profit In Pips If Fixed
extern double TakeProfitInPipsIfFixed = 15; 

//- Is Stop Loss fixed
extern bool FixedStopLoss = false; 

//- Stop Loss Coefficient To ATR
extern double StopLossCoefficientToATR = 1; 

//- Stop Loss In Pips If Fixed
extern double StopLossInPipsIfFixed = 20; 

//- Order Slippage In Pip
extern double OrderSlippageInPip = 0.5;

//- Is Pending Order Expiration Fixed
extern bool FixedPendingOrderExpiration = false; 

//- Pending Order Expiration In Min If Fixed
extern int PendingOrderExpInMinIfFixed = 30;

//- Max 1st Pos Orders
extern int Max1stPosOrders = 1;

//- Max 2nd Pos Orders
extern int Max2ndPosOrders = 1;

//- No More Order If 2nd Pos Is Open
extern bool NoMoreOrderIf2ndPosIsOpen = true; 

//- Session Price Range Filter Enabled
extern bool SessionRangeFilterEnabled = true; 

//- Session Opening Hour
extern int SessionOpeningHour24 = 23;

//- Session Closing Hour
extern int SessionClosingHour24 = 5;

//- Order Comment (Text)
extern string OrderCommentText = "B.r.e.a.k.o.u.t"; 


extern string Trailing_StopLoss = "-------- Trailing Stop Loss --------"; 

//- Close Trailing Stop On 1st Position Enabled
extern bool CloseTrailingStpOn1stPosEnabled = false; 

//- Close Trailing Stop Level
extern int CloseTralingStopLevelInPips = 7;
 
//- Close Trailing Stop Movement Step
extern int CloseTralingStopStepInPips = 1;
 
//- Trailing Stop On 2nd Position Enabled
extern bool TrailingStopOn2ndPosEnabled = true; 

//- Trailing 2nd Pos Gap In Pips
extern int Trailing2ndPosGapInPips = 1;
 
//- Trailing 2nd Pos Movement Step In Pips
extern int Trailing2ndPosStepInPips = 1;
 
//- Trail 2nd Pos On Every Single Bar
extern bool Trail2ndPosOnEverySingleBar = false;
 
//- Move 2nd Pos StopLoss To BreakEven on Take Profit Hit
extern bool Move2ndPosSLToBEOnTPHit = true;
 
extern string Trading_Schedule = "-------- Trading Schedule --------"; 

//- Trading Schedule1 Enabled
extern bool TradingSchedule1Enabled = false; 

//- Trading Schedule1 Start Time
extern string Schedule1StartTime = "07:00"; 

//- Trading Schedule1 End Time
extern string Schedule1EndTime = "16:00"; 

//- Trading Schedule2 Enabled
extern bool TradingSchedule2Enabled = false; 

//- Trading Schedule2 Start Time
extern string Schedule2StartTime = "07:00"; 

//- Trading Schedule2 End Time
extern string Schedule2EndTime = "16:00"; 

extern string Money_Management = "-------- Money Management --------"; 

//- Is Lot size fixed
extern bool FixedLotSize = true; 

//- Risk Percentage if not fixed
extern int RiskPercentageIfNotFixed = 3; 

//- Maximum Lot size if not fixed
extern double MaxLotSizeIfNotFixed = 10; 

//- Order Lot size if fixed
extern double LotSizeIfFixed = 0.1; 

//- Log Enabled
bool LogEnabled = true; 

int IndicatorsPrecisionDigits = 5;
int NumberOfPointsInOnePip;
int Pos1Orders[1];
int Pos2Orders[1];
int Pos1OrderCount;
int Pos2OrderCount;
int Pos1OpenOrderCount;
int Pos2OpenOrderCount;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
{
   //- Global Variables Initialization
   Pos1OrderCount = 0;
   Pos2OrderCount = 0;
   Pos1OpenOrderCount = 0;
   Pos2OpenOrderCount = 0;
   
   if(Digits == 4 || Digits == 2)
      NumberOfPointsInOnePip = 1;
   else
      NumberOfPointsInOnePip = 10;

   return(0);
  }

//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {

   return(0);
  }

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
{
   static bool isTradingAllowed;
   static string currentTrend;
   string signal;
   int i;
   
   //- Update existing orders status
   UpdateOrdersStatus();
      
   //- Manage Close Trailing Stop Loss if enabled
   if(CloseTrailingStpOn1stPosEnabled && Pos1OrderCount > 0)
      {
         for(i = 0 ; i < Max1stPosOrders; i++)
            {  
               if(Pos1Orders[i] != 0)
                  ManageCloseTrailing(Pos1Orders[i]);
            }
      }
   
   //- Manage 2nd Position BreakEven Trailing Stop Loss if enabled
   if(Move2ndPosSLToBEOnTPHit && Pos2OrderCount > 0)
      {
         for(i = 0 ; i < Max2ndPosOrders; i++)
            {  
               if(Pos2Orders[i] != 0)
                  Manage2ndPosBreakEvenTrailing(Pos2Orders[i]);
            }
      }
   
   //- Check if this is a new bar
   if(InvestigateForNewBar())  
      {
         //- Manage Pending Orders Expiration if not fixed
         if(FixedPendingOrderExpiration == false)
            currentTrend = ManagePendingOrderExpiration(currentTrend);
            
         isTradingAllowed = (TradingSchedule1Enabled == false ||  IsItWithinSchedule(Schedule1StartTime, Schedule1EndTime)) && 
                                 (TradingSchedule2Enabled == false ||  IsItWithinSchedule(Schedule2StartTime, Schedule2EndTime));
         
         if(IsBuySignal())
            {
               signal = "Buy";
               AlertForBuySignal();
               
               if(isTradingAllowed)
                  PlaceBuyOrder();
                  
               currentTrend = "UpTrend";
            }
         else if(IsSellSignal())
            {
               signal = "Sell";
               AlertForSellSignal();
               
               if(isTradingAllowed)
                  PlaceSellOrder();

               currentTrend = "DownTrend";
            }

         /*
         //- TODO: Should be replaced with message management system
         if(isTradingAllowed)
            {
               Comment("");
            }
         else
            {
               Comment("\nOff the Schedule.");
            }
         */
      
         //- Manage 2nd Pos Trailing Stop Loss if enabled
         if(TrailingStopOn2ndPosEnabled && Pos2OrderCount > 0)
         {
            for(i = 0 ; i < Max2ndPosOrders; i++)
               {  
                  if(Pos2Orders[i] != 0)
                     Manage2ndPosTrailing(Pos2Orders[i], signal);
               }
         }   
      }       
      
   string comm = "";
   if(isTradingAllowed)
      comm = comm + "\nTrade: Allowed";
   else
      comm = comm + "\nTrade: Not Allowed";    
  
   comm = comm + "\n1st Position Orders: " + Pos1OrderCount + "/" + Max1stPosOrders + ",  Open: " + Pos1OpenOrderCount;
   comm = comm + "\n2nd Position Orders: " + Pos2OrderCount + "/" + Max2ndPosOrders + ",  Open: " + Pos2OpenOrderCount;
   comm = comm + "\nTrend: " + currentTrend;

   Comment(comm);
     
   return(0);
}
//+------------------------------------------------------------------+


bool InvestigateForNewBar()
{
   static datetime currentTime;
   bool IsNewBar;
   
   if(currentTime == 0)
      {
         if(Volume[0] == 1)
            currentTime = Time[1];
         else
            currentTime = Time[0];
      }
               
   if(currentTime == Time[0])
      {
         IsNewBar = false;
      }
   else 
      {
         IsNewBar = true;
      }
   
   currentTime = Time[0];

   return(IsNewBar);
}

void UpdateOrdersStatus()
{
   int i;
   int orderType;
   
   //- Check current status of 1st Pos orders if they are closed
   for(i = 0, Pos1OrderCount = 0, Pos1OpenOrderCount = 0 ; i < Max1stPosOrders; i++)
      {  
         if(Pos1Orders[i] != 0)
            {
               if(OrderSelect(Pos1Orders[i], SELECT_BY_TICKET))
                  {
                     if(OrderCloseTime() != 0)
                        {
                           Pos1Orders[i] = 0;
                           continue;
                        }
                     else
                        {
                           orderType = OrderType();
                           Pos1OrderCount++;
                           if(orderType == OP_SELL || orderType == OP_BUY)
                              Pos1OpenOrderCount++;
                        }   
                  }                        
            }
      }

   //- Check current status of 2nd Pos orders if they are closed
   for(i = 0, Pos2OrderCount = 0, Pos2OpenOrderCount = 0 ; i < Max2ndPosOrders; i++)
      {  
         if(Pos2Orders[i] != 0)
            {
               if(OrderSelect(Pos2Orders[i], SELECT_BY_TICKET))
                  {
                     if(OrderCloseTime() != 0)
                        {
                           Pos2Orders[i] = 0;
                           continue;
                        }
                     else
                        {
                           orderType = OrderType();
                           Pos2OrderCount++;
                           if(orderType == OP_SELL || orderType == OP_BUY)
                              Pos2OpenOrderCount++;
                        }   
                  }                        
            }
      }

   //- Check for OrdersList array size
   if(ArraySize(Pos1Orders) != Max1stPosOrders)
      {
         ArrayResize(Pos1Orders, Max1stPosOrders);
      }
      
   //- Check for OrdersList array size
   if(ArraySize(Pos2Orders) != Max2ndPosOrders)
      {
         ArrayResize(Pos2Orders, Max2ndPosOrders);
      }
}


void ManageCloseTrailing(int ticket)
{
   double takeProfit;
   double stopLoss;
   int orderType, errorNo;
   
   RefreshRates();
   if(OrderSelect(ticket, SELECT_BY_TICKET))
      {
         if(OrderCloseTime() == 0) //- Order is not closed
            {
               takeProfit = OrderTakeProfit();
               orderType = OrderType();
               
               if(orderType == OP_BUY)
                  {
                     if((takeProfit - Bid) < (CloseTralingStopLevelInPips - CloseTralingStopStepInPips) * NumberOfPointsInOnePip * Point)
                        {
                           takeProfit = Bid + (CloseTralingStopLevelInPips * NumberOfPointsInOnePip * Point);
                           stopLoss = Bid - (CloseTralingStopLevelInPips * NumberOfPointsInOnePip * Point);
               
                           if(OrderModify(ticket, OrderOpenPrice(), stopLoss, takeProfit, 0, Lime) == false)
                              {
                                 errorNo = GetLastError();
                                 Print("Cannot modify order. Error: " + errorNo + " - " + ErrorDescription(errorNo));
                              }
                        }
                  }
                        
               if(orderType == OP_SELL)
                  {
                     if((Ask - takeProfit) < (CloseTralingStopLevelInPips - CloseTralingStopStepInPips) * NumberOfPointsInOnePip * Point)
                        {
                           takeProfit = Ask - (CloseTralingStopLevelInPips * NumberOfPointsInOnePip * Point);
                           stopLoss = Ask + (CloseTralingStopLevelInPips * NumberOfPointsInOnePip * Point);
               
                           if(OrderModify(ticket, OrderOpenPrice(), stopLoss, takeProfit, 0, Red) == false)
                              {
                                 errorNo = GetLastError();
                                 Print("Cannot modify order. Error: " + errorNo + " - " + ErrorDescription(errorNo));
                              }
                        }
                  }
            }   
      }                 
}   

void Manage2ndPosTrailing(int ticket, string signal)
{
   double takeProfit, stopLoss, newStopLoss, orderPrice;
   int orderType, errorNo;
   
   RefreshRates();
   if(OrderSelect(ticket, SELECT_BY_TICKET))
      {
         if(OrderCloseTime() == 0) //- Order is not closed
            {
               takeProfit = StrToDouble(StringTrimRight(StringSubstr(OrderComment(), 0, 7))) / MathPow(10, Digits);
               stopLoss = OrderStopLoss();
               orderType = OrderType();
               orderPrice = OrderOpenPrice();
               
               if(orderType == OP_BUY && (Trail2ndPosOnEverySingleBar || signal == "Buy"))
                  {
                     newStopLoss = Low[1] - (Trailing2ndPosGapInPips * NumberOfPointsInOnePip * Point);
                     if(newStopLoss > stopLoss && newStopLoss >= orderPrice)
                        if(OrderModify(ticket, OrderOpenPrice(), newStopLoss, 0, 0, Lime) == false)
                           {
                              errorNo = GetLastError();
                              Print("Cannot modify order. Error: " + errorNo + " - " + ErrorDescription(errorNo));
                           }
                  }
                        
               if(orderType == OP_SELL && (Trail2ndPosOnEverySingleBar || signal == "Sell"))
                  {
                     newStopLoss = High[1] + (Trailing2ndPosGapInPips * NumberOfPointsInOnePip * Point);
                     if(newStopLoss < stopLoss && newStopLoss <= orderPrice)
                        if(OrderModify(ticket, OrderOpenPrice(), newStopLoss, 0, 0, Red) == false)
                           {
                              errorNo = GetLastError();
                              Print("Cannot modify order. Error: " + errorNo + " - " + ErrorDescription(errorNo));
                           }
                  }
            }   
      }                 
}

void Manage2ndPosBreakEvenTrailing(int ticket)
{
   if(Move2ndPosSLToBEOnTPHit == false)
      return;
      
   double entryPrice;
   double takeProfit;
   double stopLoss;
   int orderType, errorNo;
   
   RefreshRates();
   if(OrderSelect(ticket, SELECT_BY_TICKET))
      {
         if(OrderCloseTime() == 0) //- Order is not closed
            {
               entryPrice = OrderOpenPrice();
               takeProfit = StrToDouble(StringTrimRight(StringSubstr(OrderComment(), 0, 7))) / MathPow(10, Digits);
               stopLoss = OrderStopLoss();
               orderType = OrderType();
               
               if(orderType == OP_BUY)
                  {
                     if(stopLoss < entryPrice && Bid >= takeProfit)
                        {
                           if(OrderModify(ticket, entryPrice, entryPrice, 0, 0, Lime) == false)
                              {
                                 errorNo = GetLastError();
                                 Print("Cannot modify order. Error: " + errorNo + " - " + ErrorDescription(errorNo));
                              }
                        }
                  }
                        
               if(orderType == OP_SELL)
                  {
                     if(stopLoss > entryPrice && Ask <= takeProfit)
                        {
                           if(OrderModify(ticket, entryPrice, entryPrice, 0, 0, Red) == false)
                              {
                                 errorNo = GetLastError();
                                 Print("Cannot modify order. Error: " + errorNo + " - " + ErrorDescription(errorNo));
                              }
                        }
                  }
            }   
      }                 
}

string ManagePendingOrderExpiration(string currentTrend)
{
   if (currentTrend == "UpTrend" || currentTrend == "DownTrend")
      {
         double SMA[2];
         double UpperBand[2];
         double LowerBand[2];
         double MiddleBand[2];
         for(int i=0 ; i < 2 ; i++)
            {
               SMA[i] = iMA(NULL, 0, MovingAveragePeriod, 0, MODE_SMA, PRICE_CLOSE, i + 1);
               UpperBand[i] = iBands(NULL, 0, BollingerBandPeriod, BollingerBandDeviation, BollingerBandShift, PRICE_CLOSE, MODE_UPPER, i + 1);
               LowerBand[i] = iBands(NULL, 0, BollingerBandPeriod, BollingerBandDeviation, BollingerBandShift, PRICE_CLOSE, MODE_LOWER, i + 1);
               MiddleBand[i] = (UpperBand[i] + LowerBand[i])/2;
            }
         
         if((MiddleBand[1] > MiddleBand[0] || SMA[1] > SMA[0]) && currentTrend == "UpTrend")
            {
               //- Expire all Buy Stop orders
               for(i = 0 ; i < Max1stPosOrders; i++)
                  {  
                     if(Pos1Orders[i] != 0)
                        if(OrderSelect(Pos1Orders[i], SELECT_BY_TICKET))
                           if(OrderCloseTime() == 0 && OrderType() == OP_BUYSTOP)
                              if(OrderDelete(Pos1Orders[i]))
                                 {
                                    Pos1Orders[i] = 0;
                                    Pos1OrderCount--;
                                 }
                  }

               for(i = 0 ; i < Max2ndPosOrders; i++)
                  {  
                     if(Pos2Orders[i] != 0)
                        if(OrderSelect(Pos2Orders[i], SELECT_BY_TICKET))
                           if(OrderCloseTime() == 0 && OrderType() == OP_BUYSTOP)
                              if(OrderDelete(Pos2Orders[i]))
                                 {
                                    Pos2Orders[i] = 0;
                                    Pos2OrderCount--;
                                 }
                  }
               
               return("");
            }
            
         if((MiddleBand[1] < MiddleBand[0] || SMA[1] < SMA[0]) && currentTrend == "DownTrend")
            {
               //- Expire all Sell Stop orders
               for(i = 0 ; i < Max1stPosOrders; i++)
                  {  
                     if(Pos1Orders[i] != 0)
                        if(OrderSelect(Pos1Orders[i], SELECT_BY_TICKET))
                           if(OrderCloseTime() == 0 && OrderType() == OP_SELLSTOP)
                              if(OrderDelete(Pos1Orders[i]))
                                 {
                                    Pos1Orders[i] = 0;
                                    Pos1OrderCount--;
                                 }
                  }

               for(i = 0 ; i < Max2ndPosOrders; i++)
                  {  
                     if(Pos2Orders[i] != 0)
                        if(OrderSelect(Pos2Orders[i], SELECT_BY_TICKET))
                           if(OrderCloseTime() == 0 && OrderType() == OP_SELLSTOP)
                              if(OrderDelete(Pos2Orders[i]))
                                 {
                                    Pos2Orders[i] = 0;
                                    Pos2OrderCount--;
                                 }
                  }
               
               return("");
            }
      }
   
   return(currentTrend);
}



bool IsBuySignal()
{
   double sessionHighRange, sessionLowRange;
   if(SessionRangeFilterEnabled)
      GetSessionPriceRange(sessionHighRange, sessionLowRange);
   
   double RangeOfBar = High[1] - Low[1];
   double UpperAcceptableLimit = NormalizeDouble(High[1] - (RangeOfBar * AcceptableBarRangePercentage / 100), IndicatorsPrecisionDigits);
   double LowerAcceptableLimit = NormalizeDouble(Low[1] + (RangeOfBar * AcceptableBarRangePercentage / 100), IndicatorsPrecisionDigits);
  
   //- Is it up bar?
   if (Close[1] > Open[1])
      {
         //- Are the open and close in acceptable range?
         if (Close[1] >= UpperAcceptableLimit && Open[1] <= LowerAcceptableLimit)
            {
               double SMA[2];
               for(int j=0 ; j < 2 ; j++)
                  {
                     SMA[j] = NormalizeDouble(iMA(NULL, 0, MovingAveragePeriod, 0, MODE_SMA, PRICE_CLOSE, j + 1), IndicatorsPrecisionDigits);
                  }
               
               //- Is SMA heading up?
               if (SMA[0] >= SMA[1])
                  {
                     double UpperBand[2];
                     double LowerBand[2];
                     double MiddleBand[2];
                     double UpperLevel[2];
                     double LowerLevel[2];
                     for(int i=0 ; i < 2 ; i++)
                        {
                           UpperBand[i] = iBands(NULL, 0, BollingerBandPeriod, BollingerBandDeviation, BollingerBandShift, PRICE_CLOSE, MODE_UPPER, i + 1);
                           LowerBand[i] = iBands(NULL, 0, BollingerBandPeriod, BollingerBandDeviation, BollingerBandShift, PRICE_CLOSE, MODE_LOWER, i + 1);
                           MiddleBand[i] = (UpperBand[i] + LowerBand[i])/2;
                           UpperLevel[i] = NormalizeDouble(MiddleBand[i] + ((UpperBand[i] - MiddleBand[i]) * BollingerBandUpperLevel), IndicatorsPrecisionDigits);
                           LowerLevel[i] = NormalizeDouble(MiddleBand[i] - ((LowerBand[i] - MiddleBand[i]) * BollingerBandLowerLevel), IndicatorsPrecisionDigits);
                        }
                     
                     //- Is Bollinger Band heading up?
                     //if(UpperLevel[0] >= UpperLevel[1] && LowerLevel[0] >= LowerLevel[1])
                     if(MiddleBand[0] > MiddleBand[1])
                        {
                           //- Has bar closed outside of the Bolliner level band?
                           if (Close[1] > UpperLevel[0])
                              {
                                 if(SessionRangeFilterEnabled == false || Close[1] > sessionHighRange)
                                    return(true);
                                 else
                                    {
                                       if(DisplayWhyItIsNotSignal)
                                          WriteLog("---> " + Symbol() + "(" + GetPeriodName() + "), CloseBar is NOT above session price range. Close: " + DoubleToStr(Close[1],Digits) + ", Higher Session Level: " + DoubleToStr(sessionHighRange,IndicatorsPrecisionDigits));
                                    }                                 
                              }
                           else
                              {
                                 if(DisplayWhyItIsNotSignal)
                                    WriteLog("---> " + Symbol() + "(" + GetPeriodName() + "), CloseBar is NOT above Upper Bollinger Bands. Close: " + DoubleToStr(Close[1],Digits) + ", UpperLevel[1]: " + DoubleToStr(UpperLevel[0],IndicatorsPrecisionDigits));
                              }
                        }
                     else
                        {
                           if(DisplayWhyItIsNotSignal)
                              WriteLog("---> " + Symbol() + "(" + GetPeriodName() + "), Bollinger Bands are NOT heading up. UpperLevel[2]: " + DoubleToStr(UpperLevel[1],IndicatorsPrecisionDigits) + ", UpperLevel[1]: " + DoubleToStr(UpperLevel[0],IndicatorsPrecisionDigits) + ", LowerLevel[2]: " + DoubleToStr(LowerLevel[1],IndicatorsPrecisionDigits) + ", LowerLevel[1]: " + DoubleToStr(LowerLevel[0],IndicatorsPrecisionDigits));
                        }
                  }
               else
                  {
                     if(DisplayWhyItIsNotSignal)
                        WriteLog("---> " + Symbol() + "(" + GetPeriodName() + "), SMA is NOT heading up. SMA[2]: " + DoubleToStr(SMA[1],IndicatorsPrecisionDigits) + ", SMA[1]: " + DoubleToStr(SMA[0],IndicatorsPrecisionDigits));
                  }
            }
         else
            {
               if(DisplayWhyItIsNotSignal)
                  WriteLog("---> " + Symbol() + "(" + GetPeriodName() + "), OpenBar and/or CloseBar is NOT in acceptable range. Open: " + DoubleToStr(Open[1],Digits) + ", Lower Limit: " + DoubleToStr(LowerAcceptableLimit,IndicatorsPrecisionDigits) + ", Close: " + DoubleToStr(Close[1],Digits) + ", Upper Limit: " + DoubleToStr(UpperAcceptableLimit,IndicatorsPrecisionDigits));
            }
      }

   return(false);
}

bool IsSellSignal()
{
   double sessionHighRange, sessionLowRange;
   if(SessionRangeFilterEnabled)
      GetSessionPriceRange(sessionHighRange, sessionLowRange);
   
   double RangeOfBar = High[1] - Low[1];
   double UpperAcceptableLimit = NormalizeDouble(High[1] - (RangeOfBar * AcceptableBarRangePercentage / 100), IndicatorsPrecisionDigits);
   double LowerAcceptableLimit = NormalizeDouble(Low[1] + (RangeOfBar * AcceptableBarRangePercentage / 100), IndicatorsPrecisionDigits);
  
   //- Is it down bar?
   if (Close[1] < Open[1])  
      {
         //- Are the open and close in acceptable range?
         if (Close[1] <= LowerAcceptableLimit && Open[1] >= UpperAcceptableLimit)  
            {
               double SMA[2];
               for(int j=0 ; j < 2 ; j++)
                  {
                     SMA[j] = NormalizeDouble(iMA(NULL, 0, MovingAveragePeriod, 0, MODE_SMA, PRICE_CLOSE, j + 1), IndicatorsPrecisionDigits);
                  }
               
               //- Is SMA heading down?
               if (SMA[0] <= SMA[1])
                  {
                     double UpperBand[2];
                     double LowerBand[2];
                     double MiddleBand[2];
                     double UpperLevel[2];
                     double LowerLevel[2];
                     for(int i=0 ; i < 2 ; i++)
                        {
                           UpperBand[i] = iBands(NULL, 0, BollingerBandPeriod, BollingerBandDeviation, BollingerBandShift, PRICE_CLOSE, MODE_UPPER, i + 1);
                           LowerBand[i] = iBands(NULL, 0, BollingerBandPeriod, BollingerBandDeviation, BollingerBandShift, PRICE_CLOSE, MODE_LOWER, i + 1);
                           MiddleBand[i] = (UpperBand[i] + LowerBand[i])/2;
                           UpperLevel[i] = NormalizeDouble(MiddleBand[i] + ((UpperBand[i] - MiddleBand[i]) * BollingerBandUpperLevel), IndicatorsPrecisionDigits);
                           LowerLevel[i] = NormalizeDouble(MiddleBand[i] - ((LowerBand[i] - MiddleBand[i]) * BollingerBandLowerLevel), IndicatorsPrecisionDigits);
                        }
                     
                     //- Is Bollinger Band heading down?
                     if(MiddleBand[0] < MiddleBand[1])  //if(UpperLevel[0] <= UpperLevel[1] && LowerLevel[0] <= LowerLevel[1])
                        {
                           //- Has bar closed outside of the Bolliner level band?
                           if (Close[1] < LowerLevel[0])
                              {
                                 if(SessionRangeFilterEnabled == false || Close[1] < sessionLowRange)
                                    return(true);
                                 else
                                    {
                                       if(DisplayWhyItIsNotSignal)
                                          WriteLog("---> " + Symbol() + "(" + GetPeriodName() + "), CloseBar is NOT below session price range. Close: " + DoubleToStr(Close[1],Digits) + ", Lower Session Level: " + DoubleToStr(sessionLowRange,IndicatorsPrecisionDigits));
                                    }                                 
                              }
                           else
                              {
                                 if(DisplayWhyItIsNotSignal)
                                    WriteLog("---> " + Symbol() + "(" + GetPeriodName() + "), CloseBar is NOT below lower Bollinger Bands. Close: " + DoubleToStr(Close[1],Digits) + ", LowerLevel[1]: " + DoubleToStr(LowerLevel[1],IndicatorsPrecisionDigits));
                              }
                        }
                     else
                        {
                           if(DisplayWhyItIsNotSignal)
                              WriteLog("---> " + Symbol() + "(" + GetPeriodName() + "), Bollinger Bands are NOT heading down. UpperLevel[2]: " + DoubleToStr(UpperLevel[1],IndicatorsPrecisionDigits) + ", UpperLevel[1]: " + DoubleToStr(UpperLevel[0],IndicatorsPrecisionDigits) + ", LowerLevel[2]: " + DoubleToStr(LowerLevel[1],IndicatorsPrecisionDigits) + ", LowerLevel[1]: " + DoubleToStr(LowerLevel[0],IndicatorsPrecisionDigits));
                        }
                  }
               else
                  {
                     if(DisplayWhyItIsNotSignal)
                        WriteLog("---> " + Symbol() + "(" + GetPeriodName() + "), SMA is NOT heading down. SMA[2]: " + DoubleToStr(SMA[1],IndicatorsPrecisionDigits) + ", SMA[1]: " + DoubleToStr(SMA[0],IndicatorsPrecisionDigits));
                  }
            }
         else
            {
               if(DisplayWhyItIsNotSignal)
                  WriteLog("---> " + Symbol() + "(" + GetPeriodName() + "), OpenBar and/or CloseBar is NOT in acceptable range. Open: " + DoubleToStr(Open[1],Digits) + ", Upper Limit: " + DoubleToStr(UpperAcceptableLimit,IndicatorsPrecisionDigits) + ", Close: " + DoubleToStr(Close[1],Digits) + ", Lower Limit: " + DoubleToStr(LowerAcceptableLimit,IndicatorsPrecisionDigits));
            }
      }

   return(false);
}

void GetSessionPriceRange(double& sessionHighRange, double& sessionLowRange)
{
      int iBegin = SessionClosingHour24 - 1;
      if(iBegin < 0) iBegin = 23;
      int iEnd = SessionOpeningHour24;
      
      int iFrom = -1;
      int iTo = -1;
      int k = 0;
      
      int hour, lastHour = -1;
      
      while(iFrom == -1 || iTo == -1)
         {
            hour = TimeHour(iTime(NULL, PERIOD_H1, k));
            
            if(iFrom == -1 && (lastHour == 0 && hour < iBegin))
               iFrom = k - 1;   
            
            if(iFrom == -1 && hour == iBegin)
               iFrom = k;
               
            if(iFrom > -1 && (lastHour == 0 && hour < iEnd))
               iTo = k - 1;   
            
            if(iFrom > -1 && iTo == -1 && hour == iEnd)
               iTo = k;
               
            lastHour = hour;
            k++;
         }
        
      sessionHighRange = NormalizeDouble(iHigh(NULL, PERIOD_H1, iHighest(NULL, PERIOD_H1, MODE_HIGH, iTo - iFrom + 1, iFrom)), IndicatorsPrecisionDigits);
      sessionLowRange = NormalizeDouble(iLow(NULL, PERIOD_H1, iLowest(NULL, PERIOD_H1, MODE_LOW, iTo - iFrom + 1, iFrom)), IndicatorsPrecisionDigits);
}

void PlaceBuyOrder()
{
   if(AllowTrading && (NoMoreOrderIf2ndPosIsOpen == false || Pos2OpenOrderCount == 0))
      {
         datetime orderExpirationTime;
         double entryPrice;
         double takeProfit;
         double stopLoss;
         double lotSize;
         int ticket;
         int i, errorNo;
         string strTP;
         
         string error = CalculateOrderDetails(OP_BUYSTOP, entryPrice, takeProfit, stopLoss, lotSize);
         if(error == "")
            {
               if(FixedPendingOrderExpiration)
                  orderExpirationTime = Time[0] + (PendingOrderExpInMinIfFixed * 60);
               else
                  orderExpirationTime = 0;

               if(AllowPlacing1stPosOrders && Pos1OrderCount < Max1stPosOrders)
                  {
                     //- Place 1st Position Order
                     ticket = OrderSend(Symbol(), OP_BUYSTOP, lotSize, entryPrice, (OrderSlippageInPip * NumberOfPointsInOnePip), stopLoss, takeProfit, OrderCommentText + " - 1st Position     ", 1, orderExpirationTime, Lime);
                     if(ticket > 0)
                        {  
                           for(i = 0; i < Max1stPosOrders ; i++)
                              {
                                 if(Pos1Orders[i] == 0)
                                    {
                                       Pos1Orders[i] = ticket;
                                       Pos1OrderCount++;
                                       break;
                                    }
                              }
                        }  
                     else
                        {
                           errorNo = GetLastError();
                           WriteLog("Error Placing Order: " + errorNo + " - " + ErrorDescription(errorNo));
                        }
                  }
             
               if(AllowPlacing2ndOrders && Pos2OrderCount < Max2ndPosOrders)
                  {
                     //- Place 2nd Position Order
                     strTP = DoubleToStr(takeProfit * MathPow(10, Digits),0) + "   , ";
                     ticket = OrderSend(Symbol(), OP_BUYSTOP, lotSize, entryPrice, (OrderSlippageInPip * NumberOfPointsInOnePip), stopLoss, 0, strTP + OrderCommentText + " - 2nd Position     ", 2, orderExpirationTime, Lime);
                     if(ticket > 0)
                        {  
                           for(i = 0; i < Max2ndPosOrders ; i++)
                              {
                                 if(Pos2Orders[i] == 0)
                                    {
                                       Pos2Orders[i] = ticket;
                                       Pos2OrderCount++;
                                       break;
                                    }
                              }
                        }  
                     else
                        {
                           errorNo = GetLastError();
                           WriteLog("Error Placing Order: " + errorNo + " - " + ErrorDescription(errorNo));
                        }
                  }
            } 
      }   

   return;
}

void PlaceSellOrder()
{
   if(AllowTrading && (NoMoreOrderIf2ndPosIsOpen == false || Pos2OpenOrderCount == 0))
      {
         datetime orderExpirationTime;
         double entryPrice;
         double takeProfit;
         double stopLoss;
         double lotSize;
         int ticket;
         int i, errorNo;
         string strTP;
         
         string error = CalculateOrderDetails(OP_SELLSTOP, entryPrice, takeProfit, stopLoss, lotSize);
         if(error == "")
            {
               if(FixedPendingOrderExpiration)
                  orderExpirationTime = Time[0] + (PendingOrderExpInMinIfFixed * 60);
               else
                  orderExpirationTime = 0;

               if(AllowPlacing1stPosOrders && Pos1OrderCount < Max1stPosOrders)
                  {
                     //- Place 1st Position Order
                     ticket = OrderSend(Symbol(), OP_SELLSTOP, lotSize, entryPrice, (OrderSlippageInPip * NumberOfPointsInOnePip), stopLoss, takeProfit, OrderCommentText + " - 1st Position     ", 1, orderExpirationTime, Lime);
                     if(ticket > 0)
                        {  
                           for(i = 0; i < Max1stPosOrders ; i++)
                              {
                                 if(Pos1Orders[i] == 0)
                                    {
                                       Pos1Orders[i] = ticket;
                                       Pos1OrderCount++;
                                       break;
                                    }
                              }
                        }  
                     else
                        {
                           errorNo = GetLastError();
                           WriteLog("Error Placing Order: " + errorNo + " - " + ErrorDescription(errorNo));
                        }
                  }

               if(AllowPlacing2ndOrders && Pos2OrderCount < Max2ndPosOrders)
                  {
                     //- Place 2nd Position Order
                     strTP = DoubleToStr(takeProfit * MathPow(10, Digits),0) + "   , ";
                     ticket = OrderSend(Symbol(), OP_SELLSTOP, lotSize, entryPrice, (OrderSlippageInPip * NumberOfPointsInOnePip), stopLoss, 0, strTP + OrderCommentText + " - 2nd Position     ", 2, orderExpirationTime, Lime);
                     if(ticket > 0)
                        {  
                           for(i = 0; i < Max2ndPosOrders ; i++)
                              {
                                 if(Pos2Orders[i] == 0)
                                    {
                                       Pos2Orders[i] = ticket;
                                       Pos2OrderCount++;
                                       break;
                                    }
                              }
                        }  
                     else
                        {
                           errorNo = GetLastError();
                           WriteLog("Error Placing Order: " + errorNo + " - " + ErrorDescription(errorNo));
                        }
                  }
            } 
      }   

   return;
}

bool IsItWithinSchedule(string startTime, string endTime)
{
   if(StringLen(startTime) != 5 || StringLen(endTime) != 5)
      {
         Print("Error in Schedule StartTime or EndTime.");
         return(false);
      }
   
   int startHour = StrToInteger(StringSubstr(startTime, 0, 2));
   int startMinute = StrToInteger(StringSubstr(startTime, 3, 2));
   int startTick = (startHour * 60) + startMinute;
   
   int endHour = StrToInteger(StringSubstr(endTime, 0, 2));
   int endMinute = StrToInteger(StringSubstr(endTime, 3, 2));
   int endTick = (endHour * 60) + endMinute;
   
   int currentHour = TimeHour(TimeCurrent());
   int currentMinute = TimeMinute(TimeCurrent());
   int currentTick = (currentHour * 60) + currentMinute;
   
   if(currentTick >= startTick && currentTick <= endTick)
      return(true);
   else
      return(false);
}

void AlertForBuySignal()
{
   //- Display signal arrow
   if(DisplaySignalArrow)
      {
         string arrowName = "arrow" + Time[1];
         if(ObjectCreate(arrowName, OBJ_ARROW, 0, Time[1], Low[1] - 2 * Point))
            {
               ObjectSet(arrowName, OBJPROP_ARROWCODE, 233);
               ObjectSet(arrowName, OBJPROP_COLOR, Lime);
               ObjectSet(arrowName, OBJPROP_TIMEFRAMES, GetPeriodVisibilityCode());
            }
      }
     
   double entryPrice;
   double takeProfit;
   double stopLoss;
   double lotSize;
   string error = CalculateOrderDetails(OP_BUYSTOP, entryPrice, takeProfit, stopLoss, lotSize);
   
   string message = "We have a BUY signal for " + Symbol() + "(" + GetPeriodName() + "), ";
   message = message + "EP: " + DoubleToStr(entryPrice, Digits) + ", TP: " + DoubleToStr(takeProfit, Digits) + ", SL: " + DoubleToStr(stopLoss, Digits);

   if(error != "")
      message = "(" + error + "), " + message;
      
   //WriteLog(message);
   if(AllowAlerting)
      Alert(message);
   else
      Print(message);
   
   return;
}

void AlertForSellSignal()
{
   //- Display signal arrow
   if(DisplaySignalArrow)
      {
         string arrowName = "arrow" + Time[1];
         if(ObjectCreate(arrowName, OBJ_ARROW, 0, Time[1], Low[1] - 2 * Point))
            {
               ObjectSet(arrowName, OBJPROP_ARROWCODE, 233);
               ObjectSet(arrowName, OBJPROP_COLOR, Red);
               ObjectSet(arrowName, OBJPROP_TIMEFRAMES, GetPeriodVisibilityCode());
            }
      }
     
   double entryPrice;
   double takeProfit;
   double stopLoss;
   double lotSize;
   string error = CalculateOrderDetails(OP_SELLSTOP, entryPrice, takeProfit, stopLoss, lotSize);

   string message = "We have a SELL signal for " + Symbol() + "(" + GetPeriodName() + "), ";
   message = message + "EP: " + DoubleToStr(entryPrice, Digits) + ", TP: " + DoubleToStr(takeProfit, Digits) + ", SL: " + DoubleToStr(stopLoss, Digits);
  
   if(error != "")
      message = "(" + error + "), " + message;

   //WriteLog(message);
   if(AllowAlerting)
      Alert(message);
   else
      Print(message);
   
   return;
}

string CalculateOrderDetails(int orderType, double& entryPrice, double& takeProfit, double& stopLoss, double& lotSize)
{
   if(orderType != OP_BUYSTOP && orderType != OP_SELLSTOP)
      return("Invalid order type!");
      
   double atr = iATR(NULL, 0, ATR_Period, 1);
   double stopLevel = MarketInfo(Symbol(), MODE_STOPLEVEL);
   double highAskPrice = 0;
   
   if(orderType == OP_BUYSTOP)
      {
         //- Calculate Ask price for High[1]
         highAskPrice = MathMax(High[1], Bid) + (MarketInfo(Symbol(), MODE_SPREAD) * Point);
         
         //- Calculate Entry Price
         entryPrice = highAskPrice + (stopLevel * Point) + (PipsToPlaceOrderOnTopOfPrice * NumberOfPointsInOnePip * Point);

         //- Calculate Take Profit
         if(FixedTakeProfit)
            takeProfit = entryPrice + (MathMax(stopLevel, (TakeProfitInPipsIfFixed * NumberOfPointsInOnePip)) * Point);
         else
            takeProfit = entryPrice + MathMax((stopLevel * Point), (TakeProfitCoefficientToATR * atr));
         
         //- Calculate Stop Loss
         if(FixedStopLoss)
            stopLoss = entryPrice - (MathMax(stopLevel, (StopLossInPipsIfFixed * NumberOfPointsInOnePip)) * Point);
         else
            stopLoss = entryPrice - MathMax((stopLevel * Point), (StopLossCoefficientToATR * atr));
            
      }
   else  //- OP_SELLSTOP
      {
         //- Calculate Entry Price
         entryPrice = MathMin(Low[1], Bid) - (stopLevel * Point) - (PipsToPlaceOrderOnTopOfPrice * NumberOfPointsInOnePip * Point);

         //- Calculate Take Profit
         if(FixedTakeProfit)
            takeProfit = entryPrice - (MathMax(stopLevel, (TakeProfitInPipsIfFixed * NumberOfPointsInOnePip)) * Point);
         else
            takeProfit = entryPrice - MathMax((stopLevel * Point), (TakeProfitCoefficientToATR * atr));
         
         //- Calculate Stop Loss
         if(FixedStopLoss)
            stopLoss = entryPrice + (MathMax(stopLevel, (StopLossInPipsIfFixed * NumberOfPointsInOnePip)) * Point);
         else
            stopLoss = entryPrice + MathMax((stopLevel * Point), (StopLossCoefficientToATR * atr));
      }
   
   //- Calculate Lot Size
   lotSize = CalculateLotSize();

   //- Validate the calculated values
   if((orderType == OP_BUYSTOP && (entryPrice - Ask) <= (stopLevel * Point)) || (orderType == OP_SELLSTOP && (Bid - entryPrice) <= (stopLevel * Point)))
      {
         //Print("EP: " + DoubleToStr(entryPrice,Digits) + ", Ask+Stp: " + DoubleToStr(Ask + (stopLevel * Point),Digits) + ", Bid-Stp: " + DoubleToStr(Bid - (stopLevel * Point),Digits));
         return("Invalid Entry Price!");
      }

   if((orderType == OP_BUYSTOP && (takeProfit - entryPrice) <= (stopLevel * Point)) || (orderType == OP_SELLSTOP && (entryPrice - takeProfit) <= (stopLevel * Point)))
      return("Invalid Take Profit!");

   if((orderType == OP_BUYSTOP && (entryPrice - stopLoss) <= (stopLevel * Point)) || (orderType == OP_SELLSTOP && (stopLoss - entryPrice) <= (stopLevel * Point)))
      return("Invalid Stop Loss!");

   if(lotSize < MarketInfo(Symbol(), MODE_MINLOT) || lotSize > MarketInfo(Symbol(), MODE_MAXLOT))
      return("Invalid Lot Size!");

   //- Check for sufficient money
   if(false)
      return("Not Enough Money");

   return("");
}

double CalculateLotSize()
{
   double minLots = MarketInfo(Symbol(), MODE_MINLOT);
   double maxLots = MarketInfo(Symbol(), MODE_MAXLOT);
   double lots = 0;
   if (FixedLotSize)
      {
         lots = LotSizeIfFixed;
      }
   else
      {  
         lots = AccountFreeMargin() / 100000 * RiskPercentageIfNotFixed;
         lots = MathMin(lots, MaxLotSizeIfNotFixed);
      }
   
   if(minLots < 0.1)
      lots = NormalizeDouble(lots, 2);
   else
      {
         if(minLots < 1)
            lots = NormalizeDouble(lots, 1);
         else 
            lots = NormalizeDouble(lots, 0);
      }
   
   lots = MathMin(maxLots, lots);
   lots = MathMax(minLots, lots);
   
   return(lots);
}

string GetPeriodName()
{
   switch(Period())
   {
      case PERIOD_M1: return("M1");
      case PERIOD_M5: return("M5");
      case PERIOD_M15: return("M15");
      case PERIOD_M30: return("M30");
      case PERIOD_H1: return("H1");
      case PERIOD_H4: return("H4");
      case PERIOD_D1: return("D1");
      case PERIOD_W1: return("W1");
      case PERIOD_MN1: return("MN1");
   }
   
   return("???");
}

int GetPeriodVisibilityCode()
{
   switch(Period())
   {
      case PERIOD_M1: return(OBJ_PERIOD_M1);
      case PERIOD_M5: return(OBJ_PERIOD_M5);
      case PERIOD_M15: return(OBJ_PERIOD_M15);
      case PERIOD_M30: return(OBJ_PERIOD_M30);
      case PERIOD_H1: return(OBJ_PERIOD_H1);
      case PERIOD_H4: return(OBJ_PERIOD_H4);
      case PERIOD_D1: return(OBJ_PERIOD_D1);
      case PERIOD_W1: return(OBJ_PERIOD_W1);
      case PERIOD_MN1: return(OBJ_PERIOD_MN1);
   }
   
   return(NULL);
}

void WriteLog(string message)
{
   if(LogEnabled == true)
      Print(message);
}


