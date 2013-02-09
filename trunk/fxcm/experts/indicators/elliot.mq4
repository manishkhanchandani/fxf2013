//+------------------------------------------------------------------+
//|                                           Elliott Wave indic.mq4 |
//|                                  Copyright © 2006, GwadaTradeBoy |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, GwadaTradeBoy"
#property link      "http://www.metaquotes.net"

/*
An Impulse pattern moves in the direction of the underlying trend && is 
made up of five waves, or moves.
Each wave is labeled at its endpoint. 
The Elliott Wave Principle identifies an Impulse wave when:

   1. Wave 2 does not fall below the starting price of wave 1.
   2. Wave 3 is not the shortest wave by price movement when comparing 
   to wave 1 && wave 5.
   3. Wave 4 does not overlap the range of wave 1. 
/* Rappel des fmles de calcul 
Pivot point (Pivot) = (H + L + C) / 3
First resistance level (R1) = (2 * P) - L
First support level (S1) = (2 * P) - H
Second resistance level (R2) = P + (R1 - S1)
Second support level (S2) = P - (R1 - S1)
H, L, C are the previous High, Low && Close.
*/

#property indicator_chart_window
//---- Insertion
//---- 
#property indicator_buffers 2
#property indicator_color1 White
#property indicator_color2 Violet

//********** Variables pour l'indicateur **********//
//---- Section des #define
#define MaxBars 200
#define RetracementBars 100
#define EWPeriod 10
#define NoisePips 30
#define MinTakeProfit 50
#define SARstep 0.0015
#define SARmax 0.0100
#define MaxTrades 1
#define AntiStopLoss 0
#define Slippage 5
#define DelayedBidsTimeout 172800
#define BidStopPoints 60
#define BidLimitPoints 50
#define TrailingStep 10
#define IncrementLots 1
#define MinMoney 0
#define MiniForexMode 1
//---- Insertion
#define Title "EW"
#define UpperDistance 15
#define LowerDistance 5

//---- Section des variables numériques
//double counter = 0;
int    counter = 0;
double counter2 = 0;
double ComputedPricesCount = 0;
//---- Section Parametre EW
double EW1 = 0, EW2 = 0, EW3 = 0, EW4 = 0, EW5 = 0;
double LastEW1 = 0, LastEW2 = 0, LastEW3 = 0, LastEW4 = 0, LastEW5 = 0;
double EW0MARK = 0, EW1MARK = 0, EW2MARK = 0, EW3MARK = 0, EW4MARK = 0, EW5MARK = 0;
double EW1MARKTIME = 0, EW2MARKTIME = 0, EW3MARKTIME = 0, EW4MARKTIME = 0, EW5MARKTIME = 0;
double EW1MARKARROW = 0, EW2MARKARROW = 0, EW3MARKARROW = 0, EW4MARKARROW = 0, EW5MARKARROW = 0;
double EW1MARKBAR = 0, EW2MARKBAR = 0, EW3MARKBAR = 0, EW4MARKBAR = 0, EW5MARKBAR = 0;
double tempval = 0;
string tempval2 = "";
double EWOscillator = 0,EWLevel = 0,ShortPeriod = 0,LongPeriod = 0,LastEW = 0;
double SARAngle = 0;
double WaveAngle = 0;
double MaxPriceBar = 0, MinPriceBar = 0;
double BarsShift = 0;
double BarsCount = 0;
double prevbars = 0;
double CalcBarDiff = 0;
double ParabolicSAR = 0;
double MA = 0, MA2 = 0;
double ShortMA = 0, LongMA = 0;
double MACD = 0, ShortMACD = 0;
double MACDAngle = 0, ShortMACDAngle = 0;
//---- Pivot, Support, Résistance
double Pivot = 0,SupportLevel1 = 0,SupportLevel2 = 0,ResistanceLevel1 = 0,ResistanceLevel2 = 0;
double tmpPivot = 0,tmpSupportLevel1 = 0,tmpSupportLevel2 = 0,tmpResistanceLevel1 = 0,tmpResistanceLevel2 = 0;
double RSI = 0,CCI = 0,ShortRSI = 0,PriceLevel = 0,LastPriceLevel = 0,FiboLevel = 0;
//---- indicator buffers
double ExtMapBuffer[];
double ExtMapBuffer2[];
//---- Calcul et dessin
int    shift, back,lasthighpos,lastlowpos;
double val,res;
double curlow,curhigh,lasthigh,lastlow;
int num=0;
int Elliot[6];
string ElliotWave="None";
double Winkel1, Winkel2;
bool found=false;

//---- Parametre des Ordres
double StartMoney = 0;
double EW3ORDERMARK = 0;
double EW5PRICE = 0;
double ORDERMARK = 0;
double ORDERANGLE = 0;
double ORDERSKIP = 0, ORDERPRICE = 0, ORDERCOUNT = 0;
double ENTRYPRICE = 0, LASTENTRYPRICE = 0;
double MinTakeProfitPtS = 0;
double MaxPrice = 0, MinPrice = 0;
double TrailingStopPoint = 0;
double Trace = 0;
double TradingPrice = 0;
double TotalLots = 0;
double TradesCount = 0;
double StartDeposit = 0;
double BuyStopLoss = 0, SellStopLoss = 0, BuyBidStopLoss = 0, SellBidStopLoss = 0,BuyLimitStopLoss = 0;
double SellLimitStopLoss = 0, TrailingStopLoss = 0;
double TakeProfit = 0;
double BidStopPts = 0;
double BidLimitPts = 0;
//double OrderType = 0;
double LastBidTime = 0;
double BadOrder = 0, CloseBadOrder = 0;
double LastBadTime = 0,OrderRecovery = 0,LastOp = 0,LastOldOp = 0,BuyOp = 0,SellOp = 0,EntryTrail = 0,StopLoss = 0,StopLossTrail = 0;
double Bears = 0,Bulls = 0,BearsAngle = 0,BullsAngle = 0;


//+------------------------------------------------------------------+
//| Fonction d'initialisation de l'indicateur                        |
//+------------------------------------------------------------------+
int init()
   {
//---- 
      IndicatorBuffers(2);
//---- drawing settings
      SetIndexStyle(0,DRAW_ARROW);
      SetIndexArrow(0,217);
      SetIndexStyle(1,DRAW_ARROW);
      SetIndexArrow(1,217);
      SetIndexStyle(3,DRAW_SECTION);
//---- indicator buffers mapping
      SetIndexBuffer(0,ExtMapBuffer);
      SetIndexEmptyValue(0,0.0);
      ArraySetAsSeries(ExtMapBuffer,true);
      SetIndexBuffer(1,ExtMapBuffer2); 
      SetIndexEmptyValue(1,0.0);
      ArraySetAsSeries(ExtMapBuffer2,true);
//---- indicators
      EW0MARK = 0;
      EW1MARK = 0;
      EW2MARK = 0;
      EW3MARK = 0;
      EW4MARK = 0;
      EW5MARK = 0;
      ORDERMARK = 0;
      prevbars = 0;
/*
      if BidStopPts < BidStopPoints  BidStopPts = BidStopPoints;
      if BidLimitPts < BidLimitPoints  BidLimitPts = BidLimitPoints;
      BidStopPts = BidStopPts * Point;
      BidLimitPts = BidLimitPts * Point;
      StartDeposit = MinMoney;
      if StartDeposit = 0  
         StartMoney=Balance;
      else 
         StartMoney = StartDeposit;*/
//      Print(AccountName,"(#",AccountNumber,") ",Symbol()," Elliot Wave Retracement analizer loaded.");
//---- indicator short name
      IndicatorShortName("Elliot Wave");
//----
      return(0);
   }
//+------------------------------------------------------------------+
//| Fonction de desinitialisation de l'indicateur                    |
//+------------------------------------------------------------------+
int deinit()
   {
//----
      
//----
      return(0);
   }
//+------------------------------------------------------------------+
//| Fonction d'itération de l'indicateur                             |
//+------------------------------------------------------------------+
int start()
   {
      int   counted_bars=IndicatorCounted();
      int   Peak[MaxBars],h,i,j;

//----
      if (Bars != prevbars) 
// Save extra CPU when making signals because we do not have new price in chart in test mode
         {

            Bears=iBearsPower(NULL,0,RetracementBars,MODE_HIGH,0);
            Bulls=iBullsPower(NULL,0,RetracementBars,MODE_LOW,0);
            RSI=iRSI(NULL,0,RetracementBars,PRICE_CLOSE,0); 
            CCI=iCCI(NULL,0,MaxBars,PRICE_CLOSE,0);
            ShortRSI=iRSI(NULL,0,RetracementBars/5,PRICE_CLOSE,0);
            ParabolicSAR=iSAR(NULL,0,SARstep,SARmax,0); 
            MA=iMA(NULL,0,MaxBars,0,MODE_EMA,PRICE_CLOSE,0);
            MA2=iMA(NULL,0,MaxBars,0,MODE_SMA,PRICE_CLOSE,0);
            ShortMA=iMA(NULL,0,RetracementBars,0,MODE_EMA,PRICE_CLOSE,0);  
            LongMA=iMA(NULL,0,MaxBars*2,0,MODE_LWMA,PRICE_CLOSE,0);
            MACD=iMACD(NULL,0,RetracementBars,MaxBars,RetracementBars,PRICE_CLOSE,MODE_EMA,0);
            ShortMACD=iMACD(NULL,0,RetracementBars/5,RetracementBars,RetracementBars/5,PRICE_CLOSE,MODE_EMA,0);

            MaxPriceBar = Highest (MODE_CLOSE,MaxBars+1, MaxBars*2);
            MinPriceBar = Lowest (MODE_CLOSE, MaxBars+1, MaxBars*2);

/*
            if (MaxPriceBar < MinPriceBar) 
            //&& EW0MARK = 0
// first Elliot Wave would be UP
               WaveAngle = 1; 

            if (MinPriceBar < MaxPriceBar)
            //&& EW0MARK = 0
// first Elliot Wave would be DOWN
               WaveAngle = 2; 
*/
            if (MaxPriceBar < MinPriceBar) 
            //&& EW0MARK = 0
// first Elliot Wave would be UP
               WaveAngle = 1; 
            else 
            //if (MinPriceBar < MaxPriceBar)
            //&& EW0MARK = 0
// first Elliot Wave would be DOWN
               WaveAngle = 2; 

            MaxPrice = iClose(NULL,0,MaxPriceBar);
            MinPrice = iClose(NULL,0,MinPriceBar);
            if (WaveAngle == 1)
               FiboLevel = (MaxPrice - MinPrice) / (iOpen(NULL,0,0) - MinPrice)  * 100;
            else 
               FiboLevel = (MaxPrice - MinPrice) / (MaxPrice - iOpen(NULL,0,0) ) * 100;
            //LastPriceLevel=0;
            if (Bars > prevbars)
               {
                  ORDERANGLE = 0; 
                  Pivot=0;
                  SupportLevel1=0;
                  SupportLevel2=0;
                  ResistanceLevel1=0;
                  ResistanceLevel2=0;
                  LastPriceLevel=PriceLevel;

                  for (counter=RetracementBars;counter >=0; counter--)
                     {
                        MaxPriceBar = Highest (MODE_CLOSE,MaxBars+1+counter, MaxBars);
                        MinPriceBar = Lowest (MODE_CLOSE, MaxBars+1+counter, MaxBars);
                        MaxPrice = iClose(NULL,0,MaxPriceBar);
                        MinPrice = iClose(NULL,0,MinPriceBar);

                        tmpPivot=(MaxPrice+MinPrice+iOpen(NULL,0,counter+MaxBars)) / 3;
                        tmpResistanceLevel1=(2 * tmpPivot) - MinPrice;
                        tmpSupportLevel1=(2 * tmpPivot) - MaxPrice;  
                        tmpResistanceLevel2=tmpPivot + (tmpResistanceLevel1 - tmpSupportLevel1);
                        tmpSupportLevel2=tmpPivot - (tmpResistanceLevel1 - tmpSupportLevel1);

                        Pivot=Pivot + tmpPivot;
                        ResistanceLevel1=ResistanceLevel1 + tmpResistanceLevel1;
                        SupportLevel1=SupportLevel1 + tmpSupportLevel1;
                        ResistanceLevel2=ResistanceLevel2 + tmpResistanceLevel2;
                        SupportLevel2=SupportLevel2 + tmpSupportLevel2;
                        if (counter < MaxBars)
                           {
                              Pivot=Pivot / 2;
                              ResistanceLevel1=ResistanceLevel1 / 2;
                              SupportLevel1=SupportLevel1 / 2;
                              ResistanceLevel2=ResistanceLevel2 / 2;
                              SupportLevel2=SupportLevel2 / 2;
                           }
                        return(0);

                        if (WaveAngle == 1)
                           PriceLevel = (iOpen(NULL,0,0) / Point - SupportLevel2 / Point) / (ResistanceLevel2 / Point - SupportLevel2 / Point) * 100;

                        if (WaveAngle == 2)
                           PriceLevel = -(ResistanceLevel2 / Point - iOpen(NULL,0,0) / Point) / (ResistanceLevel2 / Point - SupportLevel2 / Point) * 100 ;


                        if (PriceLevel >151 
                        || PriceLevel < -151)
                           {
                              ComputedPricesCount = NormalizeDouble(PriceLevel / 100,0);
                              if (ComputedPricesCount < 0)
                                 ComputedPricesCount = -ComputedPricesCount;
                                 ComputedPricesCount=(2 + ComputedPricesCount) * MaxBars;
                                 //Print(TimeToStr(iTime(NULL,0,shift]),": ",Symbol," Price Level is over limit:",PriceLevel," Increasing Prices Count to:",ComputedPricesCount);
                              if (Bars <= ComputedPricesCount + MaxBars + 1)
                                 break;//Avoid out of range computing
 
                              ORDERANGLE = 0; 
                              Pivot=0;
                              SupportLevel1=0;
                              SupportLevel2=0;
                              ResistanceLevel1=0;
                              ResistanceLevel2=0;

                              for (counter=RetracementBars;counter >=0; counter--) //jusqu'a 0
                                 {
                                    MaxPriceBar = Highest (MODE_CLOSE,ComputedPricesCount+1+counter, ComputedPricesCount);
                                    MinPriceBar = Lowest (MODE_CLOSE, ComputedPricesCount+1+counter, ComputedPricesCount);
                                    MaxPrice = iClose(NULL,0,MaxPriceBar);
                                    MinPrice = iClose(NULL,0,MinPriceBar);

                                    tmpPivot=(MaxPrice+MinPrice+iOpen(NULL,0,counter+ComputedPricesCount)) / 3;
                                    tmpResistanceLevel1=(2 * tmpPivot) - MinPrice;
                                    tmpSupportLevel1=(2 * tmpPivot) - MaxPrice;
                                    tmpResistanceLevel2=tmpPivot + (tmpResistanceLevel1 - tmpSupportLevel1);
                                    tmpSupportLevel2=tmpPivot - (tmpResistanceLevel1 - tmpSupportLevel1);

                                    Pivot=Pivot + tmpPivot;
                                    ResistanceLevel1=ResistanceLevel1 + tmpResistanceLevel1;
                                    SupportLevel1=SupportLevel1 + tmpSupportLevel1;
                                    ResistanceLevel2=ResistanceLevel2 + tmpResistanceLevel2;
                                    SupportLevel2=SupportLevel2 + tmpSupportLevel2;
                                    if (counter < MaxBars)
                                       {
                                          Pivot=Pivot / 2;
                                          ResistanceLevel1=ResistanceLevel1 / 2;
                                          SupportLevel1=SupportLevel1 / 2;
                                          ResistanceLevel2=ResistanceLevel2 / 2;
                                          SupportLevel2=SupportLevel2 / 2;
                                       }
                                    return(0);


                        if (WaveAngle == 1)
                           PriceLevel = (iOpen(NULL,0,0) / Point - SupportLevel2 / Point) / (ResistanceLevel2 / Point - SupportLevel2 / Point) * 100;

                        if (WaveAngle == 2)
                           PriceLevel = -(ResistanceLevel2 / Point - iOpen(NULL,0,0) / Point) / (ResistanceLevel2 / Point - SupportLevel2 / Point) * 100 ;
                     }

                  /*MoveObject("Pivot",OBJ_HLINE,Time,Pivot,iTime(NULL,0,MaxBars],Pivot,White,1,STYLE_SOLID);
                  MoveObject(" ResistanceLevel2",OBJ_HLINE,Time,ResistanceLevel2,iTime(NULL,0,MaxBars],ResistanceLevel2,Blue,1,STYLE_SOLID);
                  MoveObject(" SupportLevel2",OBJ_HLINE,Time,SupportLevel2,iTime(NULL,0,MaxBars],SupportLevel2,Blue,1,STYLE_SOLID);
                  MoveObject(" ResistanceLevel1",OBJ_HLINE,Time,ResistanceLevel1,iTime(NULL,0,MaxBars],ResistanceLevel1,Red,1,STYLE_SOLID);
                  MoveObject(" SupportLevel1",OBJ_HLINE,Time,SupportLevel1,iTime(NULL,0,MaxBars],SupportLevel1,Red,1,STYLE_SOLID); */
                  ObjectCreate("Pivot",OBJ_HLINE,Time,Pivot,iTime(NULL,0,MaxBars),Pivot,White,1,STYLE_SOLID);
                  ObjectCreate(" ResistanceLevel2",OBJ_HLINE,Time,ResistanceLevel2,iTime(NULL,0,MaxBars),ResistanceLevel2,Blue,1,STYLE_SOLID);
                  ObjectCreate(" SupportLevel2",OBJ_HLINE,Time,SupportLevel2,iTime(NULL,0,MaxBars),SupportLevel2,Blue,1,STYLE_SOLID);
                  ObjectCreate(" ResistanceLevel1",OBJ_HLINE,Time,ResistanceLevel1,iTime(NULL,0,MaxBars),ResistanceLevel1,Red,1,STYLE_SOLID);
                  ObjectCreate(" SupportLevel1",OBJ_HLINE,Time,SupportLevel1,iTime(NULL,0,MaxBars),SupportLevel1,Red,1,STYLE_SOLID);

                  if (MaxPriceBar < MinPriceBar)
                     //MoveObject("Fibo",OBJ_FIBO,Time,ResistanceLevel2,iTime(NULL,0,MaxBars),SupportLevel2,Green,1,STYLE_DOT);
                     ObjectCreate("Fibo",OBJ_FIBO,Time,ResistanceLevel2,iTime(NULL,0,MaxBars),SupportLevel2,Green,1,STYLE_DOT);
                  else
                     //MoveObject("Fibo",OBJ_FIBO,Time,SupportLevel2,iTime(NULL,0,MaxBars),ResistanceLevel2,Green,1,STYLE_DOT);
                     ObjectCreate("Fibo",OBJ_FIBO,Time,SupportLevel2,iTime(NULL,0,MaxBars),ResistanceLevel2,Green,1,STYLE_DOT);

               }
               
/*
            if (WaveAngle = 1 
            && PriceLevel > 0
            && PriceLevel < 50)
               WaveAngle = 2;

            if (WaveAngle = 2 
            && PriceLevel < 0
            && PriceLevel > -50)
               WaveAngle = 1;

*/
/*
            if (EW3MARK == 1)
               {
                  //Print("EW0MARK:",EW0MARK," EW1MARK:",EW1MARK," EW2MARK:",EW2MARK," EW3MARK:",EW3MARK," EW3MARKBAR=",EW3MARKBAR," EW4MARK:",EW4MARK," EW0:",EW5PRICE," EW1:",EW1," EW2:",EW2," EW3:",EW3);
                  //Print("EW1MARKBAR:",EW1MARKBAR," EW2MARKBAR:",EW2MARKBAR," EW3MARKBAR:",EW3MARKBAR," EW3MARKBAR=",EW3MARKBAR," EW4MARK:",EW4MARK," EW0:",EW5PRICE," EW1:",EW1," EW2:",EW2," EW3:",EW3);
                  Print(TimeToStr(time),  
                  ": EW0=",TimeToStr(EW5MARKTIME),
                  " ",EW5,
                  " EW1=",TimeToStr(EW1MARKTIME),
                  " ",EW1,
                  " EW2=",TimeToStr(EW2MARKTIME),
                  " ",EW2,
                  " EW3=",TimeToStr(EW3MARKTIME),
                  " ",EW3
                  );
               }
*/
// Reallign Elliot Wave marked bars
            if (EW0MARK > 0)
               EW5MARKBAR= 0;
            if (EW1MARK > 0)
               EW1MARKBAR = 0;
            if (EW2MARK > 0)
               EW2MARKBAR = 0;
            if (EW3MARK > 0)
               EW3MARKBAR = 0;
            if (EW4MARK > 0) 
               EW4MARKBAR = 0;
            if (EW5MARK > 0)
               EW5MARKBAR = 0;
            if (EW0MARK > 0 || EW5MARK > 0)
               for (counter = 0;counter >= Bars -1; counter ++)
                  {
                     if (EW5MARKBAR > 0)
                        break; // reallign finished
                     tempval = iTime(NULL,0,counter);
                     if (EW5MARK == 0 && tempval == EW5MARKTIME)
                        EW5MARKBAR = counter;
                     if (EW1MARK > 0 && tempval == EW1MARKTIME)
                        EW1MARKBAR = counter;
                     if (EW2MARK > 0 && tempval == EW2MARKTIME)
                        EW2MARKBAR = counter;
                     if (EW3MARK > 0 && tempval == EW3MARKTIME)
                        EW3MARKBAR = counter;
                     if (EW4MARK > 0 && tempval == EW4MARKTIME)
                        EW4MARKBAR = counter;
                     if (EW5MARK > 0 && tempval == EW5MARKTIME)
                        EW5MARKBAR = counter;
                  }
            CalcBarDiff=(iTime(NULL,0,0)-iTime(NULL,0,Bars-1))/60/Period() - Bars + 1;

            if (Bars < MaxBars+2
            || (EW1MARK == 1 && EW1MARKBAR == 0)
            || (EW2MARK == 1 && EW2MARKBAR == 0)
            || (EW3MARK == 1 && EW3MARKBAR == 0)
            || (EW4MARK == 1 && EW4MARKBAR == 0)
            || (EW0MARK == 1 && EW5MARKBAR == 0)
            || (EW5MARK == 1 && EW5MARKBAR == 0)
            || EW1MARKBAR > Bars - 1
            || EW2MARKBAR > Bars - 1
            || EW3MARKBAR > Bars - 1
            || EW4MARKBAR > Bars - 1
            || EW5MARKBAR > Bars - 1)
               {
                  if (Bars > MaxBars+2
                  && prevbars < Bars)
                     {
                        //prevbars=Bars;
/*
                        Print("Bars:",Bars," EW1MARKBAR:",EW1MARKBAR," EW2MARKBAR:",EW2MARKBAR," EW3MARKBAR:",EW3MARKBAR," EW3MARKBAR=",EW3MARKBAR," EW4MARKBAR:",EW4MARKBAR," EW5MARKBAR:",EW5MARKBAR);
                        Print(TimeToStr(time),  
                        ": EW0=",TimeToStr(EW5MARKTIME),
                        " ",EW5,
                        " EW1=",TimeToStr(EW1MARKTIME),
                        " ",EW1,
                        " EW2=",TimeToStr(EW2MARKTIME),
                        " ",EW2,
                        " EW3=",TimeToStr(EW3MARKTIME),
                        " ",EW3
                        );
                        //Print(iTime(NULL,0,1]," ",iTime(NULL,0,Bars-1]," ",iTime(NULL,0,100]," ",iTime(NULL,0,1]-iTime(NULL,0,Bars-1]," ",(iTime(NULL,0,1]-iTime(NULL,0,Bars-1])/60/Period(), " ", iTime(NULL,0,0] - EW5MARKTIME);
*/
                        if (EW0MARK == 1 && EW1MARK == 0)
                           Print("ERROR: Bars:",Bars-1," EW0 Bar:", EW5MARKBAR, " EW0 Time:",TimeToStr(EW5MARKTIME), " Calculated EW0 Time:",TimeToStr(iTime(NULL,0,EW5MARKBAR))," EW0 Bars Diff:",(EW5MARKTIME - iTime(NULL,0,EW5MARKBAR))/60/Period());
                        if (EW1MARK == 1 && EW2MARK == 0)
                           Print("ERROR: Bars:",Bars-1," EW1 Bar:", EW1MARKBAR, " EW1 Time:",TimeToStr(EW1MARKTIME), " Calculated EW1 Time:",TimeToStr(iTime(NULL,0,EW1MARKBAR))," EW1 Bars Diff:",(EW1MARKTIME - iTime(NULL,0,EW1MARKBAR))/60/Period());
                        if (EW2MARK == 1 && EW3MARK == 0)
                           Print("ERROR: Bars:",Bars-1," EW2 Bar:", EW2MARKBAR, " EW2 Time:",TimeToStr(EW2MARKTIME), " Calculated EW2 Time:",TimeToStr(iTime(NULL,0,EW2MARKBAR))," EW2 Bars Diff:",(EW2MARKTIME - iTime(NULL,0,EW2MARKBAR))/60/Period());
                        if (EW3MARK == 1 && EW4MARK == 0)
                           Print("ERROR: Bars:",Bars-1," EW3 Bar:", EW3MARKBAR, " EW3 Time:",TimeToStr(EW3MARKTIME), " Calculated EW3 Time:",TimeToStr(iTime(NULL,0,EW3MARKBAR))," EW3 Bars Diff:",(EW3MARKTIME - iTime(NULL,0,EW3MARKBAR))/60/Period());
                        if (EW4MARK == 1 && EW5MARK == 0)
                           Print("ERROR: Bars:",Bars-1," EW4 Bar:", EW4MARKBAR, " EW4 Time:",TimeToStr(EW4MARKTIME), " Calculated EW4 Time:",TimeToStr(iTime(NULL,0,EW4MARKBAR))," EW4 Bars Diff:",(EW4MARKTIME - iTime(NULL,0,EW4MARKBAR))/60/Period());
                        if (EW5MARK == 1 && EW0MARK == 0)
                           Print("ERROR: Bars:",Bars-1," EW5 Bar:", EW5MARKBAR, " EW5 Time:",TimeToStr(EW5MARKTIME), " Calculated EW5 Time:",TimeToStr(iTime(NULL,0,EW5MARKBAR))," EW5 Bars Diff:",(EW5MARKTIME - iTime(NULL,0,EW5MARKBAR))/60/Period());
                     }
                  EW0MARK=0;
                  EW1MARK=0;  
                  EW1=0;
                  EW1MARKTIME=0;
                  EW1MARKBAR=0;
                  EW2MARK=0;
                  EW2=0;
                  EW2MARKTIME=0;
                  EW2MARKBAR=0;
                  EW3MARK=0;
                  EW3=0;
                  EW3MARKTIME=0;
                  EW3MARKBAR=0;
                  EW4MARK=0;
                  EW4=0;
                  EW4MARKTIME=0;
                  EW4MARKBAR=0;
                  EW5MARK=0;
                  EW5=0;
                  EW5MARKTIME=0;
                  EW5MARKBAR=0;
                  ORDERMARK=0;
                  //break;
               }

            if (EW0MARK == 0 && EW1MARK == 0)
               {
                  EW0MARK = 0;
                  EW1MARK = 0;
                  EW1MARKBAR = 0;
                  EW1MARKTIME = 0;
                  EW2MARK = 0;
                  EW2MARKBAR = 0;
                  EW2MARKTIME = 0;
                  EW3MARK = 0;
                  EW3MARKBAR = 0;
                  EW3MARKTIME = 0;
                  EW4MARK = 0;
                  EW4MARKBAR = 0;
                  EW4MARKTIME = 0;
                  EW5MARK = 0;
                  EW5MARKBAR = 0;
                  EW5MARKTIME = 0;
               }

            MaxPriceBar = Highest (MODE_CLOSE,MaxBars+1, MaxBars);
            MinPriceBar = Lowest (MODE_CLOSE, MaxBars+1, MaxBars);
            MaxPrice = iClose(NULL,0,MaxPriceBar);
            MinPrice = iClose(NULL,0,MinPriceBar);
            //MaxPriceBar=iTime(NULL,0,MaxPriceBar];
            //MinPriceBar=iTime(NULL,0,MinPriceBar];


            if (EW0MARK == 1 && EW2MARK == 0 && EW3MARK == 0)
// Recalculate EW entry point while have only Elliot Wave [I]
               {
                  MaxPriceBar = Highest (MODE_CLOSE,MaxBars+1, MaxBars);
                  MinPriceBar = Lowest (MODE_CLOSE, MaxBars+1, MaxBars);
                  MaxPrice = iClose(NULL,0,MaxPriceBar);
                  MinPrice = iClose(NULL,0,MinPriceBar);
                  if ((WaveAngle == 1 && MinPrice < EW5PRICE)
                  || (WaveAngle == 2 && MaxPrice > EW5PRICE))
                     {
                        if (EW5MARKBAR <= MaxBars)
                           {
//****
                              //DelArrow(EW5MARKTIME,EW5PRICE + StopLoss / 2 * Point);
                              //DelArrow(EW5MARKTIME,EW5PRICE - StopLoss / 2 * Point);
                              ObjectDelete("Arrow"+EW5MARKTIME);
                             
                           }
                        EW0MARK=0;
                     }
               }
/*
            if WaveAngle = 1 && Close[counter] > MaxPrice  
               Print("Counter:",counter, " MaxPrice:",MaxPrice);
            if WaveAngle = 2 && Close[counter] < MaxPrice  
               Print("Counter:",counter, " MinPrice:",MinPrice);
/*
//Reallign Elliot wave entry point
            if WaveAngle = 1 && MaxPriceBar < RetracementBars  
               WaveAngle = 2
            else
               if WaveAngle = 2 && MinPriceBar < RetracementBars*/

            //Print("PriceLevel:",PriceLevel);

            if (EW0MARK == 0)
            //or (MaxPriceBar > MinPriceBar && WaveAngle = 1)
            //or (MaxPriceBar < MinPriceBar && WaveAngle = 2)
               {
                  EW0MARK=1;
                  EW1MARK=0;
                  EW2MARK=0;
                  EW3MARK=0;
                  EW4MARK=0;
                  EW5MARK=0;
                  if (WaveAngle == 1)
// try to mark first Elliot Wave
                     {
                        EW5=MinPrice;
                        EW5MARKBAR=MinPriceBar;
                        EW5MARKTIME=iTime(NULL,0,MinPriceBar);
                        EW5PRICE=MinPrice;
                        EW1=MinPrice;
//*****
                        //SetArrow(EW5MARKTIME,EW5PRICE,128,White);
                        //SetArrow(EW5MARKTIME,EW5PRICE - StopLoss / 2 * Point,384,White);
                        ObjectCreate("Arrow"+EW5MARKTIME,OBJ_ARROW,0,EW5MARKTIME,EW5PRICE);
                        ObjectCreate("Arrow"+EW5MARKTIME,OBJ_ARROW,0,EW5MARKTIME,EW5PRICE - StopLoss / 2 * Point);
                        Comment("\nEWTrend=Possible UP",
                        "\nLastTime=",TimeToStr(iTime(NULL,0,0)),
                        "\nEW0=",TimeToStr(EW5MARKTIME),
                        "    ",EW5,
                        "\nPivot                         ",Pivot,
                        "\nResistance Level I            ",ResistanceLevel1,
                        "\nSupport Level I               ",SupportLevel1,
                        "\nResistance Level II           ",ResistanceLevel2,
                        "\nSupport Level II              ",SupportLevel2,
                        "\nPrice Level                   ",PriceLevel," %"
                        );
                        //Print(Symbol," EW0 Time:",TimeToStr(EW5MARKTIME),": EW0:",EW5," WaveAngle:",WaveAngle," MaxPriceBar:",MaxPriceBar," MinPriceBar:",MinPriceBar);
                     }

                  if (WaveAngle == 2)
// try to mark first reversed Elliot Wave
                     {
                        EW5=MaxPrice;
                        EW5MARKBAR=MaxPriceBar;
                        EW5MARKTIME=iTime(NULL,0,MaxPriceBar);
                        EW5PRICE=MaxPrice;
                        EW1=MaxPrice;
//*****
                        //SetArrow(EW5MARKTIME,EW5PRICE,128,Violet);
                        //SetArrow(EW5MARKTIME,EW5PRICE + StopLoss / 2 * Point,384,Violet);
                        ObjectCreate("Arrow"+EW5MARKTIME,OBJ_ARROW,0,EW5MARKTIME,EW5PRICE);
                        ObjectCreate("Arrow"+EW5MARKTIME,OBJ_ARROW,0,EW5MARKTIME,EW5PRICE + StopLoss / 2 * Point);
                        Comment("\nEWTrend=Possible DOWN",
                        "\nLastTime=",TimeToStr(iTime(NULL,0,0)),
                        "\nEW0=",TimeToStr(EW5MARKTIME),
                        "    ",EW5,
                        "\nPivot                         ",Pivot,
                        "\nResistance Level I            ",ResistanceLevel1,
                        "\nSupport Level I               ",SupportLevel1,
                        "\nResistance Level II           ",ResistanceLevel2,
                        "\nSupport Level II              ",SupportLevel2,
                        "\nPrice Level                   ",PriceLevel," %"
                        );
                        //Print(Symbol," EW0 Time:",TimeToStr(EW5MARKTIME),": EW0:",EW5," WaveAngle:",WaveAngle," MaxPriceBar:",MaxPriceBar," MinPriceBar:",MinPriceBar);
                     }
                  //Print ("waveangle=",WaveAngle);
               }

            //if IsTesting && EW3MARK = 1  Print("EW0MARK:",EW0MARK," EW1MARK:",EW1MARK," EW2MARK:",EW2MARK," EW3MARK:",EW3MARK," EW4MARK:",EW4MARK);

            BarsShift=EW5MARKBAR;
/*
            if EW5MARKBAR > MaxBars 
// reset EW count start entry 
               {
                  EW0MARK=0;
                  if WaveAngle = 1  
                     //DelArrow(EW5MARKTIME,EW5PRICE + StopLoss / 2 * Point);
                     ObjectDelete("Arrow"+EW5MARKTIME);
                  if WaveAngle = 2  
                     //DelArrow(EW5MARKTIME,EW5PRICE - StopLoss / 2 * Point);
                     ObjectDelete("Arrow"+EW5MARKTIME);
               }
*/
            if (EW0MARK==1 && EW2MARK==0 && EW3MARK==0
            //&& EW5MARKBAR > BarsCount
            )
               {
                  for (counter=BarsShift - 1;counter > 1;counter--)
                     {
                        BarsCount = BarsShift - counter;
                        MaxPriceBar = Highest (MODE_CLOSE,EW5MARKBAR , BarsCount);
                        MinPriceBar = Lowest (MODE_CLOSE,EW5MARKBAR , BarsCount);
                        MaxPrice = iClose(NULL,0,MaxPriceBar);
                        MinPrice = iClose(NULL,0,MinPriceBar);
                     }
               }

            if (WaveAngle == 1 && MaxPrice > EW1 && MaxPriceBar < EW5MARKBAR)
               {
                  EW1 = MaxPrice;
                  if (EW1MARKBAR <= MaxBars)
//*****
                     //DelArrow(EW1MARKTIME , Open[counter] + StopLoss / 2 * Point);
                     ObjectDelete("Arrow"+EW1MARKTIME);
                     EW1MARKTIME=iTime(NULL,0,MaxPriceBar);
                     //Print("EW1=",EW1);
               }
            if (WaveAngle == 2 && MinPrice < EW1 && MinPriceBar < EW5MARKBAR)   
               {
                  if (EW1MARKBAR <= MaxBars)
//*****
                     //DelArrow(EW1MARKTIME , Open[counter] - StopLoss / 2 * Point);
                     ObjectDelete("Arrow"+EW1MARKTIME);
                     EW1MARKTIME=iTime(NULL,0,MinPriceBar);
                     EW1 = MinPrice;
                     //Print("EW1=",EW1);
               }
/*
            if (IsTesting && (counter = BarsShift-1 || counter = 1)) 
               {
                  if (WaveAngle == 1)  
                     Print("BarCount:",BarsCount ," Counter:",counter," Price:",Close[counter]," MaxPrice: ",MaxPrice," MaxPriceBar:",MaxPriceBar);
                  if (WaveAngle == 2)
                     Print("BarCount:",BarsCount ," Counter:",counter," Price:",Close[counter]," MinPrice:",MinPrice," MinPriceBar:",MinPriceBar);
                     Print("Bars:",Bars-1," EW0 Bar:", EW5MARKBAR, " EW0 Time:",TimeToStr(EW5MARKTIME), " Calculated EW0 Time:",TimeToStr(iTime(NULL,0,EW5MARKBAR])," EW0 Bars Diff:",(EW5MARKTIME-iTime(NULL,0,EW5MARKBAR])/60/Period());
                     Print("Bars:",Bars-1," EW1 Bar:", EW1MARKBAR, " EW1 Time:",TimeToStr(EW1MARKTIME), " Calculated EW1 Time:",TimeToStr(iTime(NULL,0,EW1MARKBAR])," EW1 Bars Diff:",(EW1MARKTIME-iTime(NULL,0,EW1MARKBAR])/60/Period());
                     Print("WaveAngle:",WaveAngle," EW1MARK:",EW1MARK," EW0:",EW5PRICE," EW1:",EW1);
               }
*/
            if (WaveAngle == 1
            && iClose(NULL,0,EW5MARKBAR) + NoisePips * Point < Close[counter]
            && MaxPrice <= Close[counter]
            && EW1 > iClose(NULL,0,EW5MARKBAR) + NoisePips * Point
            && EW1 <= Close[counter]
            )
               {
                  if (EW1MARKBAR <= MaxBars)
//*****
                     //DelArrow(EW1MARKTIME , Open[counter] + StopLoss / 2 * Point);
                     ObjectDelete("Arrow"+EW1MARKTIME);
                  if (Close[counter] > MaxPrice)
                     {
                        EW1 = Close[counter];
                        EW1MARKTIME=iTime(NULL,0,counter);
                     }
                  EW1MARK=1;
                  EW2=EW1;
                  EW1MARKTIME=iTime(NULL,0,counter);
                  EW1MARKBAR=counter;
/****
                  //SetArrow(EW1MARKTIME,Open[counter] + StopLoss / 2 * Point,129,White);
                  ObjectCreate("Arrow"+EW1MARKTIME,OBJ_ARROW,0,EW1MARKTIME,Open[counter] + StopLoss / 2 * Point);
                  Comment("\nEWTrend=Possible UP",
                  "\nEW0=",TimeToStr(EW5MARKTIME),
                  "    ",EW5,
                  "\nEW1=",TimeToStr(EW1MARKTIME),
                  "    ",EW1,
                  "\nPivot                         ",Pivot,
                  "\nResistance Level I            ",ResistanceLevel1,
                  "\nSupport Level I               ",SupportLevel1,
                  "\nResistance Level II           ",ResistanceLevel2,
                  "\nSupport Level II              ",SupportLevel2,
                  "\nPrice Level                   ",PriceLevel," %"
                  );
                  //Print("EW1 Time:",TimeToStr(EW1MARKTIME),": EW1:",EW1," WaveAngle:",WaveAngle," MaxPriceBar:",MaxPriceBar," MinPriceBar:",MinPriceBar);
               }

            if (WaveAngle == 2 
            && iClose(NULL,0,EW5MARKBAR) - NoisePips * Point > Close[counter]
            && MinPrice >= Close[counter]
            && EW1 < iClose(NULL,0,EW5MARKBAR) - NoisePips * Point
            && EW1 >= Close[counter]
            )
               {
                  if (EW1MARKBAR <= MaxBars) 
//*****
                     //DelArrow(EW1MARKTIME , Open[counter] - StopLoss / 2 * Point);
                     ObjectDelete("Arrow"+EW1MARKTIME);
                  if (Close[counter] < MinPrice)
                     {
                        EW1 = Close[counter];
                        EW1MARKTIME=iTime(NULL,0,counter];
                     }
                  EW1MARK=1;
                  EW2=EW1;
                  EW1MARKBAR=counter;
                  //SetArrow(EW1MARKTIME,Open[counter] - StopLoss / 2 * Point,129,Violet);
                  ObjectCreate("Arrow"+EW1MARKTIME,OBJ_ARROW,0,EW1MARKTIME,Open[counter] - StopLoss / 2 * Point);
                  EW5MARKTIME,EW5PRICE + StopLoss / 2 * Point
                  Comment("\nEWTrend=Possible DOWN",
                  "\nEW0=",TimeToStr(EW5MARKTIME),
                  "    ",EW5,
                  "\nEW1=",TimeToStr(EW1MARKTIME),
                  "    ",EW1,
                  "\nPivot                         ",Pivot,
                  "\nResistance Level I            ",ResistanceLevel1,
                  "\nSupport Level I               ",SupportLevel1,
                  "\nResistance Level II           ",ResistanceLevel2,
                  "\nSupport Level II              ",SupportLevel2,
                  "\nPrice Level                   ",PriceLevel," %"
                  );
                  //Print("EW1 Time:",TimeToStr(EW1MARKTIME),": EW1:",EW1," WaveAngle:",WaveAngle," MaxPriceBar:",MaxPriceBar," MinPriceBar:",MinPriceBar);
               }


            if (EW1MARK == 1 && counter < EW1MARKBAR
            && (WaveAngle == 1 && Close[counter] < EW1 - NoisePips * Point 
            || (WaveAngle == 2 && Close[counter] > EW1 + NoisePips * Point)) 
            )
// Wave 1 ended
               {
                  EW3MARK=1;
                  //break;
               }
            return(0);

            if (EW0MARK==1 && EW2MARK==0 && EW3MARK==1)
               {
                  EW3MARK=0;
                  if (WaveAngle == 1)
                     { 
                        if (EW1MARKBAR <= MaxBars)
                           {
//*****                              
                              //DelArrow(EW1MARKTIME, EW1 + StopLoss / 2 * Point);
                              //SetArrow(EW1MARKTIME, EW1 + StopLoss / 2 * Point,129,White);
                              ObjectDelete("Arrow"+EW1MARKTIME);
                              ObjectCreate("Arrow"+EW1MARKTIME,OBJ_ARROW,0,EW1MARKTIME,EW1 + StopLoss / 2 * Point);
                           }
                     }
                  else
                     { 
                        if (EW1MARKBAR <= MaxBars)
                           {
//*****
                              //DelArrow(EW1MARKTIME, EW1 - StopLoss / 2 * Point);
                              //SetArrow(EW1MARKTIME, EW1 - StopLoss / 2 * Point,129,Violet);
                              ObjectDelete("Arrow"+EW1MARKTIME);
                              ObjectCreate("Arrow"+EW1MARKTIME,OBJ_ARROW,0,EW1MARKTIME,EW1 - StopLoss / 2 * Point);
                           }
                     }
               }

            BarsShift=EW1MARKBAR;
            if (Bars < BarsShift)
               //break;
// Check for failed Elliot Wave 1
            if ((EW3MARK==0 && EW1MARK==1 && EW2MARK==0 && WaveAngle == 1 && EW1 < EW5PRICE - NoisePips * Point)
            || (EW3MARK==0 && EW1MARK==1 && EW2MARK==0 && WaveAngle == 2 && EW1 > EW5PRICE + NoisePips * Point))
               {
                  for (counter=1;counter >= EW5MARKBAR; counter ++) 
                     {
//*****
                        //DelArrow(iTime(NULL,0,counter] , Close[counter] + StopLoss / 2 * Point);
                        //DelArrow(iTime(NULL,0,counter] , Close[counter] - StopLoss / 2 * Point);
                        ObjectDelete("Arrow"+iTime(NULL,0,counter]);
                     }
                  EW0MARK=0;
                  EW1MARK=0;
                  EW2MARK=0;
                  EW3MARK=0;
                  EW4MARK=0;
                  EW5MARK=0;
               }

            if (EW1MARK==1 && EW3MARK==0)

               for (counter=BarsShift - 1;counter >= 1;counter --)
                  BarsCount = BarsShift - counter;
            MaxPriceBar = Highest (MODE_CLOSE,EW1MARKBAR , BarsCount);
            MinPriceBar = Lowest (MODE_CLOSE,EW1MARKBAR , BarsCount);
            MaxPrice = iClose(NULL,0,MaxPriceBar);
            MinPrice = iClose(NULL,0,MinPriceBar);

            if (WaveAngle == 1 && MinPrice < EW2 && MinPriceBar < EW5MARKBAR)
               {
                  if (EW2MARKBAR <= MaxBars)
//*****
                     //DelArrow(EW2MARKTIME , Open[counter] - StopLoss / 2 * Point);
                     ObjectDelete("Arrow"+EW2MARKTIME);
                  EW2 = MinPrice;
                  EW2MARKTIME=iTime(NULL,0,MinPriceBar);
               }
            if (WaveAngle == 2 && MaxPrice > EW2 && MaxPriceBar < EW5MARKBAR)
               {
                  if (EW2MARKBAR <= MaxBars)
//*****
                     //DelArrow(EW2MARKTIME , Open[counter] + StopLoss / 2 * Point);
                     ObjectDelete("Arrow"+EW2MARKTIME);
                  EW2 = MaxPrice;
                  EW2MARKTIME=iTime(NULL,0,MaxPriceBar);
               }
            if (WaveAngle == 1
            && iClose(NULL,0,EW1MARKBAR) - NoisePips * Point > Close[counter]
            && MinPrice >= Close[counter]
            && EW2 < iClose(NULL,0,EW1MARKBAR) - NoisePips * Point
            && EW2 > Close[counter]
            )
               {
                  if (EW2MARKBAR <= MaxBars)
//*****
                     //DelArrow(EW2MARKTIME , Open[counter] - StopLoss / 2 * Point);
                     ObjectDelete("Arrow"+EW2MARKTIME);
                  if (Close[counter] < MinPrice)
                     {
                        EW2 = Close[counter];
                        EW2MARKTIME=iTime(NULL,0,counter];
                     }
                  EW3=EW2;
                  EW2MARK=1;
                  EW2MARKBAR=counter;
                  EW3MARKBAR=EW2MARKBAR;
                  //SetArrow(EW2MARKTIME,Open[counter] - StopLoss / 2 * Point,130,White);
                  ObjectCreate("Arrow"+EW2MARKTIME,OBJ_ARROW,0,EW2MARKTIME,Open[counter] - StopLoss / 2 * Point);
                  Comment("\nEWTrend=Possible UP",
                  "\nEW0=",TimeToStr(EW5MARKTIME),
                  "    ",EW5,
                  "\nEW1=",TimeToStr(EW1MARKTIME),
                  "    ",EW1,
                  "\nEW2=",TimeToStr(EW2MARKTIME),
                  "    ",EW2,
                  
                  );
                  //Print("EW2 Time:",TimeToStr(EW2MARKTIME),": EW2:",EW2," WaveAngle:",WaveAngle," MaxPriceBar:",MaxPriceBar," MinPriceBar:",MinPriceBar);
               }

            if (WaveAngle == 2 
            && iClose(NULL,0,EW1MARKBAR) + NoisePips * Point < Close[counter]
            && MaxPrice <= Close[counter]
            && EW2 > iClose(NULL,0,EW1MARKBAR) + NoisePips * Point
            && EW2 < Close[counter]
            )
               {     
                  if (EW2MARKBAR <= MaxBars)
//*****
                     //DelArrow(EW2MARKTIME , Open[counter] + StopLoss / 2 * Point);
                     ObjectDelete("Arrow"+EW2MARKTIME);
                  if (Close[counter] > MaxPrice)
                     {
                        EW2 = Close[counter];
                        EW2MARKTIME=iTime(NULL,0,counter];
                     }
                  EW3=EW2;
                  EW2MARK=1;
                  EW2MARKBAR=counter;
                  EW3MARKBAR=EW2MARKBAR;
                  //SetArrow(EW2MARKTIME,Open[counter] + StopLoss / 2 * Point,130,Violet);
                  ObjectCreate("Arrow"+EW2MARKTIME,OBJ_ARROW,0,EW2MARKTIME,Open[counter] + StopLoss / 2 * Point);
                  Comment("\nEWTrend=Possible DOWN",
                  "\nEW0=",TimeToStr(EW5MARKTIME),
                  "    ",EW5,
                  "\nEW1=",TimeToStr(EW1MARKTIME),
                  "    ",EW1,
                  "\nEW2=",TimeToStr(EW2MARKTIME),
                  "    ",EW2,
                  "\nPivot                         ",Pivot,
                  "\nResistance Level I            ",ResistanceLevel1,
                  "\nSupport Level I               ",SupportLevel1,
                  "\nResistance Level II           ",ResistanceLevel2,
                  "\nSupport Level II              ",SupportLevel2,
                  "\nPrice Level                   ",PriceLevel," %"
                  );
                  //Print("EW2 Time:",TimeToStr(EW2MARKTIME),": EW2:",EW2," WaveAngle:",WaveAngle," MaxPriceBar:",MaxPriceBar," MinPriceBar:",MinPriceBar);
               }
// Check for failed Elliot Wave 2
            if ((EW3MARK==0 && EW2MARK==1 && WaveAngle == 1 && EW2 < EW5 - NoisePips * Point)
            || (EW3MARK==0 && EW2MARK==1 && WaveAngle == 2 && EW2 > EW5 + NoisePips * Point))
               {
                  for (counter=1; counter <= EW5MARKBAR; counter ++)
                     {
//*****                        
                        //DelArrow(iTime(NULL,0,counter] , Close[counter] + StopLoss / 2 * Point);
                        //DelArrow(iTime(NULL,0,counter] , Close[counter] - StopLoss / 2 * Point);
                        ObjectDelete("Arrow"+iTime(NULL,0,counter]);
                     }
                  EW0MARK=0;
                  EW1MARK=0;
                  EW2MARK=0;
                  EW3MARK=0;
                  EW4MARK=0;
                  EW5MARK=0; 
                  Comment("\nEWTrend=Recalculating..",
                  "\nEW0=",TimeToStr(EW5MARKTIME),
                  "    ",EW5,
                  "\nEW1=",TimeToStr(EW1MARKTIME),
                  "    ",EW1,
                  "\nEW2=",TimeToStr(EW2MARKTIME),
                  "    ",EW2,
                  "\nEW3=",TimeToStr(EW3MARKTIME),
                  "    ",EW3,
                  "\nPivot                         ",Pivot,
                  "\nResistance Level I            ",ResistanceLevel1,
                  "\nSupport Level I               ",SupportLevel1,
                  "\nResistance Level II           ",ResistanceLevel2,
                  "\nSupport Level II              ",SupportLevel2,
                  "\nPrice Level                   ",PriceLevel," %"
                  );
/*
                  Print(TimeToStr(time),": ",Symbol," Elliot Wave 2 failed, reverting retracement trend vector. ");
                  Print("Old EW0=",TimeToStr(EW5MARKTIME),
                  " ",EW5,
                  " EW1=",TimeToStr(EW1MARKTIME),
                  " ",EW1,
                  " EW2=",TimeToStr(EW2MARKTIME),
                  " ",EW2,
                  " EW3=",TimeToStr(EW3MARKTIME),
                  " ",EW3
                  );
/*
                  MaxPriceBar = Highest (MODE_CLOSE,EW1MARKBAR + MaxBars+1 ,MaxBars);
                  MinPriceBar = Lowest (MODE_CLOSE,EW1MARKBAR + MaxBars+1 ,MaxBars);
                  MaxPrice = iClose(NULL,0,MaxPriceBar];
                  MinPrice = iClose(NULL,0,MinPriceBar];

                  tempval=EW5;
                  EW3=EW2;
                  EW2=EW1;
                  if WaveAngle = 1  
                     EW5 = MinPrice;
                  if WaveAngle = 2  
                     EW5 = MaxPrice;
                  EW5PRICE=EW5;
                  EW1=tempval;

                  tempval=EW5MARKTIME;
                  if WaveAngle = 1  
                     EW5MARKTIME = iTime(NULL,0,MinPriceBar];
                  if WaveAngle = 2  
                     EW5MARKTIME = iTime(NULL,0,MaxPriceBar];
                  EW3MARKTIME=EW2MARKTIME;
                  EW2MARKTIME=EW1MARKTIME;
                  EW1MARKTIME=tempval;
 
                  tempval=EW5MARKBAR;
                  if WaveAngle = 1  
                     EW5MARKBAR = MinPriceBar;
                  if WaveAngle = 2  
                     EW5MARKBAR = MaxPriceBar;
                  EW5MARKBAR=EW1MARKBAR;
                  EW3MARKBAR=EW2MARKBAR;
                  EW2MARKBAR=EW1MARKBAR;
                  EW1MARKBAR=tempval;

                  if Bars < EW1MARKBAR + MaxBars+1 
// Check if we have not enough prices for estimating EW0
                     {
                        EW5=Close[Bars-1];
                        EW5PRICE=EW5;
                        EW5MARKTIME=iTime(NULL,0,Bars-1];
                        EW5MARKBAR=Bars-1;
                     }
                  EW4=0;
                  EW4MARKTIME=0;
                  //Print(TimeToStr(time),": ",TimeToStr(EW5MARKTIME)," ",EW5MARKBAR," ",EW5 + StopLoss / 2 * Point);
                  //Print(time, " ",EW1MARKTIME," ",EW5MARKTIME," ",Period());
                  //Print(TimeToStr(time), " ",TimeToStr(EW1MARKTIME)," ",TimeToStr(EW5MARKTIME)," ",Period());

                  if WaveAngle = 1  
                     {
// WaveAngle = 2;
                        Comment("\nEWTrend=Recalculating..",
                        "\nEW0=",TimeToStr(EW5MARKTIME),
                        "    ",EW5,
                        "\nEW1=",TimeToStr(EW1MARKTIME),
                        "    ",EW1,
                        "\nEW2=",TimeToStr(EW2MARKTIME),
                        "    ",EW2,
                        "\nEW3=",TimeToStr(EW3MARKTIME),
                        "    ",EW3,
                        "\nPivot                         ",Pivot,
                        "\nResistance Level I            ",ResistanceLevel1,
                        "\nSupport Level I               ",SupportLevel1,
                        "\nResistance Level II           ",ResistanceLevel2,
                        "\nSupport Level II              ",SupportLevel2,
                        "\nPrice Level                   ",PriceLevel," %"
                        );
                        //SetArrow(EW5MARKTIME,EW5 + StopLoss / 2 * Point,128,Violet);
                        //SetArrow(EW1MARKTIME,EW1 - StopLoss / 2 * Point,129,Violet);
                        //SetArrow(EW2MARKTIME,EW2 + StopLoss / 2 * Point,130,Violet);
                        //SetArrow(EW3MARKTIME,EW3 - StopLoss / 2 * Point,131,Violet);
                        ObjectCreate("Arrow"+EW5MARKTIME,OBJ_ARROW,0,EW5MARKTIME,EW5 + StopLoss / 2 * Point);
                        ObjectCreate("Arrow"+EW1MARKTIME,OBJ_ARROW,0,EW1MARKTIME,EW1 - StopLoss / 2 * Point);
                        ObjectCreate("Arrow"+EW2MARKTIME,OBJ_ARROW,0,EW2MARKTIME,EW2 + StopLoss / 2 * Point);
                        ObjectCreate("Arrow"+EW3MARKTIME,OBJ_ARROW,0,EW3MARKTIME,EW3 - StopLoss / 2 * Point);
                     }
                  else 
                     {
// WaveAngle = 1;
                        Comment("\nEWTrend=Recalculating..",
                        "\nEW0=",TimeToStr(EW5MARKTIME),
                        "    ",EW5,
                        "\nEW1=",TimeToStr(EW1MARKTIME),
                        "    ",EW1,
                        "\nEW2=",TimeToStr(EW2MARKTIME),
                        "    ",EW2,
                        "\nEW3=",TimeToStr(EW3MARKTIME),
                        "    ",EW3,
                        "\nPivot                         ",Pivot,
                        "\nResistance Level I            ",ResistanceLevel1,
                        "\nSupport Level I               ",SupportLevel1,
                        "\nResistance Level II           ",ResistanceLevel2,
                        "\nSupport Level II              ",SupportLevel2,
                        "\nPrice Level                   ",PriceLevel," %"
                        );
                        //SetArrow(EW5MARKTIME,EW5 - StopLoss / 2 * Point,128,White);
                        //SetArrow(EW1MARKTIME,EW1 + StopLoss / 2 * Point,129,White);
                        ObjectCreate("Arrow"+EW5MARKTIME,OBJ_ARROW,0,EW5MARKTIME,EW5 - StopLoss / 2 * Point);
                        ObjectCreate("Arrow"+EW1MARKTIME,OBJ_ARROW,0,EW1MARKTIME,EW1 + StopLoss / 2 * Point);
                        // Print(TimeToStr(EW1MARKTIME)," ",TimeToStr(iTime(NULL,0,EW1MARKBAR])," ",EW1 + StopLoss / 2 * Point);
                        // Print("EW0 Time:",TimeToStr(EW5MARKTIME),": EW0:",EW5," WaveAngle:",WaveAngle," MaxPriceBar:",MaxPriceBar," MinPriceBar:",MinPriceBar);

                        //SetArrow(EW2MARKTIME,EW2 - StopLoss / 2 * Point,130,White);
                        //SetArrow(EW3MARKTIME,EW3 + StopLoss / 2 * Point,131,White);
                        ObjectCreate("Arrow"+EW2MARKTIME,OBJ_ARROW,0,EW2MARKTIME,EW2 - StopLoss / 2 * Point);
                        ObjectCreate("Arrow"+EW3MARKTIME,OBJ_ARROW,0,EW3MARKTIME,EW3 + StopLoss / 2 * Point);
                     }
 /*
                  Print("\nEWTrend=Recalculating..",
                  "EW0=",TimeToStr(EW5MARKTIME),
                  " ",EW5,
                  " EW1=",TimeToStr(EW1MARKTIME),
                  " ",EW1,
                  " EW2=",TimeToStr(EW2MARKTIME),
                  " ",EW2,
                  " EW3=",TimeToStr(EW3MARKTIME),
                  " ",EW3,
                  " Pivot ",Pivot,
                  " Resistance Level I ",ResistanceLevel1,
                  " Support Level I ",SupportLevel1,
                  " Resistance Level II ",ResistanceLevel2,
                  "\nSupport Level II              ",SupportLevel2,
                  "\nPrice Level                   ",PriceLevel,"%"
                  );
 */
                  //break;
               }  
            return(0);

            if (EW2MARK==1 && EW3MARK==0)
               {
                  if (WaveAngle == 2) 
                     { 
                        if (EW2MARKBAR <= MaxBars)
//*****
                           //DelArrow(EW2MARKTIME, EW2 + StopLoss / 2 * Point);
                           //SetArrow(EW1MARKTIME, EW1 - StopLoss / 2 * Point,129,Violet);
                           //SetArrow(EW2MARKTIME, EW2 + StopLoss / 2 * Point,130,Violet);
                           ObjectDelete("Arrow"+EW2MARKTIME);
                           ObjectCreate("Arrow"+EW1MARKTIME,OBJ_ARROW,0,EW1MARKTIME, EW1 - StopLoss / 2 * Point);
                           ObjectCreate("Arrow"+EW2MARKTIME,OBJ_ARROW,0,EW2MARKTIME, EW2 + StopLoss / 2 * Point);
                     }
                  else
                     { 
                        if (EW2MARKBAR <= MaxBars)
//*****
                           //DelArrow(EW2MARKTIME, EW2 - StopLoss / 2 * Point);
                           //SetArrow(EW1MARKTIME, EW1 + StopLoss / 2 * Point,129,White);
                           //SetArrow(EW2MARKTIME, EW2 - StopLoss / 2 * Point,130,White);
                           ObjectDelete("Arrow"+EW2MARKTIME);
                           ObjectCreate("Arrow"+EW1MARKTIME,OBJ_ARROW,0,EW1MARKTIME, EW1 + StopLoss / 2 * Point);
                           ObjectCreate("Arrow"+EW2MARKTIME,OBJ_ARROW,0,EW2MARKTIME, EW2 - StopLoss / 2 * Point);
                     }
               }

            BarsShift=EW1MARKBAR;
            if (Bars < BarsShift)
               //break;

            if (EW2MARK == 1 && EW4MARK == 0
            //&& EW4MARK == 0 
            )
               for (counter=BarsShift - 1;counter >= 1;counter--)
                  BarsCount = BarsShift - counter;
                  MaxPriceBar = Highest (MODE_CLOSE,EW1MARKBAR , BarsCount);
                  MinPriceBar = Lowest (MODE_CLOSE,EW1MARKBAR , BarsCount);
                  MaxPrice = iClose(NULL,0,MaxPriceBar);
                  MinPrice = iClose(NULL,0,MinPriceBar);

            if (WaveAngle == 1 && MaxPrice > EW3 && MaxPriceBar < EW2MARKBAR)
               {
                  EW3 = MaxPrice;
                  EW3MARKTIME=iTime(NULL,0,MaxPriceBar);
                  EW3MARKBAR=MaxPriceBar;
                  if (EW3MARKBAR <= MaxBars) 
//*****
                     //DelArrow(EW3MARKTIME , Open[counter] + StopLoss / 2 * Point);
                     ObjectDelete("Arrow"+EW3MARKTIME);
                  Print("EW3=",EW3);
               }

            if (WaveAngle == 2 && MinPrice < EW3 && MinPriceBar < EW2MARKBAR)   
               {
                  if (EW3MARKBAR <= MaxBars) 
//*****
                     //DelArrow(EW3MARKTIME , Open[counter] - StopLoss / 2 * Point);
                     ObjectDelete("Arrow"+EW3MARKTIME);
                  EW3MARKTIME=iTime(NULL,0,MinPriceBar);
                  EW3MARKBAR=MinPriceBar;
                  EW3 = MinPrice;
                  //Print("EW3=",EW3);
               }
/*
            if IsTesting && (counter = BarsShift-1 || counter = 1) 
               {
                  if WaveAngle = 1  
                     Print("BarCount:",BarsCount ," Counter:",counter," Price:",Close[counter]," MaxPrice: ",MaxPrice," MaxPriceBar:",MaxPriceBar);
                  if WaveAngle = 2  
                     Print("BarCount:",BarsCount ," Counter:",counter," Price:",Close[counter]," MinPrice:",MinPrice," MinPriceBar:",MinPriceBar);
                  Print("Bars:",Bars-1," EW2 Bar:", EW2MARKBAR, " EW2 Time:",TimeToStr(EW2MARKTIME), " Calculated EW2 Time:",TimeToStr(iTime(NULL,0,EW2MARKBAR])," EW2 Bars Diff:",(EW2MARKTIME-iTime(NULL,0,EW2MARKBAR])/60/Period());
                  Print("Bars:",Bars-1," EW3 Bar:", EW3MARKBAR, " EW3 Time:",TimeToStr(EW3MARKTIME), " Calculated EW3 Time:",TimeToStr(iTime(NULL,0,EW3MARKBAR])," EW3 Bars Diff:",(EW3MARKTIME-iTime(NULL,0,EW3MARKBAR])/60/Period());
                  Print("WaveAngle:",WaveAngle," EW3MARK:",EW3MARK," EW4MARK:",EW4MARK," EW0:",EW5PRICE," EW1:",EW1," EW2:",EW2," EW3:",EW3);
               }
/*
            if WaveAngle = 1 && Close[counter] > MaxPrice  
               Print("Counter:",counter, " MaxPrice:",MaxPrice);
            if WaveAngle = 2 && Close[counter] < MaxPrice  
               Print("Counter:",counter, " MinPrice:",MinPrice);
*/

            if (WaveAngle == 1 
            && EW1 + NoisePips * Point < Close[counter]
            && MaxPrice <= Close[counter]
            && EW3 > EW2 + NoisePips * Point
            && EW3 < Close[counter]
            )
               {
                  if (EW3MARKBAR <= EW5MARKBAR )
//*****
                     //DelArrow(EW3MARKTIME , Open[counter] + StopLoss / 2 * Point);
                     ObjectDelete("Arrow"+EW3MARKTIME);
                  EW3 = Close[counter];
                  EW3MARKTIME=iTime(NULL,0,counter);
                  EW3MARK=1;
                  EW4=EW3;
                  EW3MARKBAR=counter;
                  //SetArrow(iTime(NULL,0,counter],Open[counter] + StopLoss / 2 * Point,131,White);
                  ObjectCreate("Arrow"+iTime(NULL,0,counter),OBJ_ARROW,0,iTime(NULL,0,counter),Open[counter] + StopLoss / 2 * Point);
                  //Print("EW0 date:",TimeToStr(EW5MARKTIME)," EW1 date:",TimeToStr(EW1MARKTIME)," EW2 date:",TimeToStr(EW2MARKTIME)," EW3 date:",TimeToStr(EW3MARKTIME));
                  Comment("\nEWTrend=UP",
                  "\nEW0=",TimeToStr(EW5MARKTIME),
                  "    ",EW5,
                  "\nEW1=",TimeToStr(EW1MARKTIME),
                  "    ",EW1,
                  "\nEW2=",TimeToStr(EW2MARKTIME),
                  "    ",EW2,
                  "\nEW3=",TimeToStr(EW3MARKTIME),
                  "    ",EW3,
                  "\nPivot                         ",Pivot,
                  "\nResistance Level I            ",ResistanceLevel1,
                  "\nSupport Level I               ",SupportLevel1,
                  "\nResistance Level II           ",ResistanceLevel2,
                  "\nSupport Level II              ",SupportLevel2,
                  "\nPrice Level                   ",PriceLevel," %"                  
                  );
                  //Print("EW3 Time:",TimeToStr(EW3MARKTIME),": EW3:",EW3," WaveAngle:",WaveAngle," MaxPriceBar:",MaxPriceBar," MinPriceBar:",MinPriceBar);
               }

            if (WaveAngle == 2 
            && EW1 - NoisePips * Point > Close[counter]
            && MinPrice >= Close[counter]
            && EW3 < EW2 - NoisePips * Point
            && EW3 > Close[counter]
            )
               {
                  if (EW3MARKBAR <= EW5MARKBAR )
//*****
                     //DelArrow(EW3MARKTIME , Open[counter] - StopLoss / 2 * Point);
                     ObjectDelete("Arrow"+EW3MARKTIME);
                  EW3 = Close[counter];
                  EW3MARKTIME=iTime(NULL,0,counter);
                  EW3MARK=1;
                  EW4=EW3;
                  EW4MARKTIME=iTime(NULL,0,counter);
                  EW3MARKBAR=counter;
                  //SetArrow(iTime(NULL,0,counter],Open[counter],131,Violet);
                  ObjectCreate("Arrow"+iTime(NULL,0,counter),OBJ_ARROW,0,iTime(NULL,0,counter),Open[counter]);
                  Comment("\nEWTrend=DOWN",
                  "\nEW0=",TimeToStr(EW5MARKTIME),
                  "    ",EW5,
                  "\nEW1=",TimeToStr(EW1MARKTIME),
                  "    ",EW1,
                  "\nEW2=",TimeToStr(EW2MARKTIME),
                  "    ",EW2,
                  "\nEW3=",TimeToStr(EW3MARKTIME),
                  "    ",EW3,
                  "\nPivot                         ",Pivot,
                  "\nResistance Level I            ",ResistanceLevel1,
                  "\nSupport Level I               ",SupportLevel1,
                  "\nResistance Level II           ",ResistanceLevel2,
                  "\nSupport Level II              ",SupportLevel2,
                  "\nPrice Level                   ",PriceLevel," %"
                  );
                  //Print("EW3 Time:",TimeToStr(EW3MARKTIME),": EW3:",EW3," WaveAngle:",WaveAngle," MaxPriceBar:",MaxPriceBar," MinPriceBar:",MinPriceBar);
               }
/*
            if (EW3MARK == 1 && counter < EW3MARKBAR && (WaveAngle == 1 && Close[counter] < EW3 - NoisePips * Point 
            || (WaveAngle = 2 && Close[counter] > EW3 + NoisePips * Point))
            ) 
// Wave 1 ended
               {
                  EW4MARK=1;
                  break;
               }
*/
            return(0);

//Check if we have failed EW 3 && it falls bellow EW Wave 1
            if ((EW3MARK==1 && WaveAngle == 1 && iOpen(NULL,0,0) < EW2)
            || (EW3MARK==1 && WaveAngle == 2 && iOpen(NULL,0,0) > EW2))
               {
                  Comment("\nEWTrend=Recalculating..",
                  "\nLast EW0=",TimeToStr(EW5MARKTIME),
                  "    ",EW5,
                  "\nLast EW1=",TimeToStr(EW1MARKTIME),
                  "    ",EW1,
                  "\nLast EW2=",TimeToStr(EW2MARKTIME),
                  "    ",EW2,
                  "\nLast EW3=",TimeToStr(EW3MARKTIME),
                  "    ",EW3,
                  "\nPivot                         ",Pivot,
                  "\nResistance Level I            ",ResistanceLevel1,
                  "\nSupport Level I               ",SupportLevel1,
                  "\nResistance Level II           ",ResistanceLevel2,
                  "\nSupport Level II              ",SupportLevel2,
                  "\nPrice Level                   ",PriceLevel," %"
                  );
                  EW0MARK=0;
                  EW1MARK=0; 
                  EW2MARK=0;
                  EW3MARK=0;
                  EW4MARK=0;
                  EW5MARK=0;
                  ORDERMARK=0;
                  for (counter=1 ;counter <= EW2MARKBAR;counter ++)
                     {
                        if (Close[counter] == EW3)
                           {
//*****
                              //DelArrow(iTime(NULL,0,counter] , Close[counter] + StopLoss / 2 * Point);
                              //DelArrow(iTime(NULL,0,counter] , Close[counter] - StopLoss / 2 * Point);
                              ObjectDelete("Arrow"+iTime(NULL,0,counter));
                              break;
                           }
                     }

                  if (WaveAngle == 1)  
//*****
                     //SetArrow(iTime(NULL,0,0),Ask,251,Red);
                     ObjectCreate("Arrow"+iTime(NULL,0,0),OBJ_ARROW,0,iTime(NULL,0,0),Ask);
                  if (WaveAngle == 2)  
//*****
                     //SetArrow(iTime(NULL,0,0),Bid,251,Red);
                     ObjectCreate("Arrow"+iTime(NULL,0,0),OBJ_ARROW,0,iTime(NULL,0,0),Bid);
                  LastEW5 = EW5PRICE;
                  LastEW1=EW1;
                  LastEW2=EW2;
                  LastEW3=EW3;
                  //Print(TimeToStr(time),": ",Symbol," Elliot Wave 3 failed, recalculating EW0...");
               }

            if (EW3MARK == 1 && EW4MARK == 0) 
               {
                  //EWOscillator = iCustom("ElliotOscillator",EWPeriod(),0,RetracementBars,MODE_FIRST,0);
                  //EWLevel = iCustom("ElliotWaves",EWPeriod(),0,RetracementBars,MODE_FIRST,0);
                  EWOscillator = iCustom("ElliotOscillator",EWPeriod,0,RetracementBars,1,0);
                  EWLevel = iCustom("ElliotWaves",EWPeriod,0,RetracementBars,1,0);
               }

            if (EWOscillator != 0 && EWLevel != 0 && EW3MARK == 1 && EW4MARK == 0 )
               {
                  //Print("EW0MARK:",EW0MARK," EW1MARK:",EW1MARK," EW2MARK:",EW2MARK," EW3MARK:",EW3MARK," EW4MARK:",EW4MARK);
                  //Print(TimeToStr(iTime(NULL,0,0]),": EW1MARKBAR:",EW1MARKBAR," EW2MARKBAR:",EW2MARKBAR," EW3MARKBAR:",EW3MARKBAR," EW3MARKBAR=",EW3MARKBAR," EW4MARK:",EW4MARK);
                  Print(TimeToStr(iTime(NULL,0,0)),": EW3 START - Open:",iOpen(NULL,0,0) ," EW0:",EW5PRICE," EW1:",EW1," EW2:",EW2," EW3:",EW3," WaveAngle:",WaveAngle," Price Level:",PriceLevel," Last Price Level:",LastPriceLevel," Max/Min Level:",FiboLevel);
                  Print(TimeToStr(iTime(NULL,0,0)),": EW3 START - Pivot:",Pivot," Resistance Level I:",ResistanceLevel1," Support Level I:",SupportLevel1," Resistance Level II:",ResistanceLevel2," Support Level II:",SupportLevel2);
                  EW3ORDERMARK=0;
                  LastOp=0;

                  if (EW3 > Pivot )
                     { 
                        if (EW3MARKBAR <= MaxBars )
//*****
                           //DelArrow(EW3MARKTIME, EW3 + StopLoss / 2 * Point);
                           //SetArrow(EW3MARKTIME, EW3 + StopLoss / 2 * Point,131,White);
                           //DelArrow(EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point);
                           ObjectDelete("Arrow"+EW3MARKTIME);
                           ObjectCreate("Arrow"+EW3MARKTIME,OBJ_ARROW,0,EW3MARKTIME, EW3 + StopLoss / 2 * Point,131);
                           ObjectSet("Arrow"+EW3MARKTIME,OBJPROP_COLOR,White);
                           //ObjectDelete("Arrow"+EW3MARKTIME);

                        if (EW3 > ResistanceLevel1 
                        && FiboLevel > 99 
                        && ResistanceLevel2 - ResistanceLevel1 < SupportLevel1 - SupportLevel2
                        && BullsAngle == 1)
                           {
//*****
                              //SetArrow(EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point,246,White); //UP
                              ObjectCreate("Arrow"+EW3MARKTIME,OBJ_ARROW,0,EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point);
                              ObjectSet("Arrow"+EW3MARKTIME,OBJPROP_COLOR,White);
                              EW3ORDERMARK=1;
                              LastOp=1;
                           }   
                        else
                           if (EW3 > ResistanceLevel1 
                           && FiboLevel > 100 
                           && FiboLevel < 130 )
                              {
//*****
                                 //SetArrow(EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point,200,White); // UP
                                 ObjectCreate("Arrow"+EW3MARKTIME,OBJ_ARROW,0,EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point);
                                 ObjectSet("Arrow"+EW3MARKTIME,OBJPROP_COLOR,White);
                                 EW3ORDERMARK=1;
                                 LastOp=2;
                              } 
                           else
                              if (EW2 > SupportLevel1 
                              && FiboLevel > 80 
                              && FiboLevel < 130 
                              && PriceLevel > 65)
                                 {
                                    if (iOpen(NULL,0,0) > (MaxPrice + MinPrice) * 2 / 3
                                    || (MACDAngle == 2 && FiboLevel > 100))
                                       {
                                          if (PriceLevel > 87.5 // Murrey 7/8 support/resistance line
                                          //&& FiboLevel < 112.5 // Murrey 8/8+1 support/resistance line
                                          && BullsAngle == 1
                                          && BearsAngle == 1
                                          )
                                             {
//*****
                                                //SetArrow(EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point,200,White); // UP
                                                ObjectCreate("Arrow"+EW3MARKTIME,OBJ_ARROW,0,EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point);
                                                ObjectSet("Arrow"+EW3MARKTIME,OBJPROP_COLOR,White);
                                                EW3ORDERMARK=3;
                                                LastOp=3;
                                             }
                                          else 
                                             {
                                                if (MA < LongMA)
                                                   {
//*****   
                                                      //SetArrow(EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point,200,White); // UNSTABLE UP
                                                      ObjectCreate("Arrow"+EW3MARKTIME,OBJ_ARROW,0,EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point);
                                                      ObjectSet("Arrow"+EW3MARKTIME,OBJPROP_COLOR,White);
                                                      EW3ORDERMARK=1;
                                                      LastOp=4;
                                                   }
                                                else
                                                   {
//*****
                                                      //SetArrow(EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point,200,SkyBlue); // UNSTABLE DOWN, POSSIBLE UP
                                                      ObjectCreate("Arrow"+EW3MARKTIME,OBJ_ARROW,0,EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point);
                                                      ObjectSet("Arrow"+EW3MARKTIME,OBJPROP_COLOR,SkyBlue);
                                                      EW3ORDERMARK=2;
                                                      LastOp=5;
                                                   }
                                             }
                                       }
                                    else
                                       if (FiboLevel > 100) // Over Murrey 8/8 support/resistance line
                                          {
//*****
                                             //SetArrow(EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point,200,SkyBlue); // POSSIBLE UP
                                             ObjectCreate("Arrow"+EW3MARKTIME,OBJ_ARROW,0,EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point);
                                             ObjectSet("Arrow"+EW3MARKTIME,OBJPROP_COLOR,SkyBlue);
                                             EW3ORDERMARK=1;
                                             LastOp=6;
                                          }
                                       else
                                          if (FiboLevel == 100) // Murrey 8/8 support/resistance line
                                             {
//*****
                                                //SetArrow(EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point,202,SkyBlue); // POSSIBLE RESIST DOWN
                                                ObjectCreate("Arrow"+EW3MARKTIME,OBJ_ARROW,0,EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point);
                                                ObjectSet("Arrow"+EW3MARKTIME,OBJPROP_COLOR,SkyBlue);
                                                EW3ORDERMARK=12;
                                                LastOp=7;
                                             }
                                       } 
                                    else 
                                       if (FiboLevel > 70 
                                       && FiboLevel < 150 
                                       && PriceLevel < 60
                                       //&& Bid > EW3 + Slippage * Point
                                       )
                                          {
                                             if (FiboLevel == 100 // Murrey 8/8 support/resistance line
                                             && MACDAngle == 1)
                                                {
//*****
                                                   //SetArrow(EW3MARKTIME, EW3 - (StopLoss / 2 + NoisePips) * Point,196,SkyBlue); //TEMP UP, REVERT TO DOWN
                                                   ObjectCreate("Arrow"+EW3MARKTIME,OBJ_ARROW,0,EW3MARKTIME, EW3 - (StopLoss / 2 + NoisePips) * Point);
                                                   ObjectSet("Arrow"+EW3MARKTIME,OBJPROP_COLOR,SkyBlue);
                                                   EW3ORDERMARK=13;
                                                   LastOp=8;
                                                }
                                             else
                                                {
//*****
                                                   //SetArrow(EW3MARKTIME, EW3 - (StopLoss / 2 + NoisePips) * Point,198,White); //UP
                                                   ObjectCreate("Arrow"+EW3MARKTIME,OBJ_ARROW,0,EW3MARKTIME, EW3 - (StopLoss / 2 + NoisePips) * Point);
                                                   ObjectSet("Arrow"+EW3MARKTIME,OBJPROP_COLOR,White);
                                                   EW3ORDERMARK=3;
                                                   LastOp=9;
                                                }
                                          } 
                                       else
                                          if (PriceLevel > 65 
                                          && MA < iOpen(NULL,0,0))
                                             {
//*****
                                                //SetArrow(EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point,202,White); // DOWN
                                                ObjectCreate("Arrow"+EW3MARKTIME,OBJ_ARROW,0,EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point);
                                                ObjectSet("Arrow"+EW3MARKTIME,OBJPROP_COLOR,White);
                                                EW3ORDERMARK=4;
                                                LastOp=10;
                                             } 
                                       }
                                    else
                                       { 
                                          if (EW3MARKBAR <= MaxBars )
//*****
                                             //DelArrow(EW3MARKTIME, EW3 - StopLoss / 2 * Point);
                                             //SetArrow(EW3MARKTIME, EW3 - StopLoss / 2 * Point,131,Violet);
                                             //DelArrow(EW3MARKTIME, EW3 - (StopLoss / 2 + NoisePips) * Point);
                                             ObjectDelete("Arrow"+EW3MARKTIME);
                                             ObjectCreate("Arrow"+EW3MARKTIME,OBJ_ARROW,0,EW3MARKTIME, EW3 - StopLoss / 2 * Point);
                                             ObjectSet("Arrow"+EW3MARKTIME,OBJPROP_COLOR,Violet);
                                             //ObjectDelete("Arrow"+EW3MARKTIME);
                                          if (EW3 < SupportLevel1 
                                          && FiboLevel > 99 
                                          && ResistanceLevel2 - ResistanceLevel1 < SupportLevel1 - SupportLevel2 
                                          && BearsAngle == 2
                                          )
                                             {
//*****
                                                //SetArrow(EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point,248,Violet); // DOWN
                                                ObjectCreate("Arrow"+EW3MARKTIME,OBJ_ARROW,0,EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point);
                                                ObjectSet("Arrow"+EW3MARKTIME,OBJPROP_COLOR,Violet);
                                                EW3ORDERMARK=11;
                                                LastOp=21;
                                             } 
                                          else
                                             if (EW3 < SupportLevel1  
                                             && FiboLevel < 130 
                                             && FiboLevel > 100 )
                                                {
//*****
                                                   //SetArrow(EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point,202,Violet); // DOWN
                                                   ObjectCreate("Arrow"+EW3MARKTIME,OBJ_ARROW,0,EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point);
                                                   ObjectSet("Arrow"+EW3MARKTIME,OBJPROP_COLOR,Violet);
                                                   EW3ORDERMARK=11;
                                                   LastOp=22;
                                                } 
                                             else
                                                if (EW2 < ResistanceLevel1 
                                                && FiboLevel > 80 
                                                && FiboLevel < 130 
                                                && PriceLevel < -65)
                                                   {
                                                      if (iOpen(NULL,0,0) < (MaxPrice + MinPrice) * 3 / 2
                                                      || (MACDAngle == 2 && FiboLevel > 100))
                                                         {
                                                            if (PriceLevel < -87.5 // Murrey 7/8 support/resistance line
                                                            //&& FiboLevel < 112/5 // Murrey 8/8+1 support/resistance line
                                                            && BullsAngle == 2
                                                            && BearsAngle == 2
                                                            )
                                                               {
//*****
                                                                  //SetArrow(EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point,202,Violet); // DOWN
                                                                  ObjectCreate("Arrow"+EW3MARKTIME,OBJ_ARROW,0,EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point);
                                                                  ObjectSet("Arrow"+EW3MARKTIME,OBJPROP_COLOR,Violet);
                                                                  EW3ORDERMARK=13;
                                                                  LastOp=23;
                                                               }
                                                            else
                                                               {
                                                                  if (MA > LongMA)
                                                                     {
//*****
                                                                        //SetArrow(EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point,202,Violet); // UNSTABLE DOWN
                                                                        ObjectCreate("Arrow"+EW3MARKTIME,OBJ_ARROW,0,EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point);
                                                                        ObjectSet("Arrow"+EW3MARKTIME,OBJPROP_COLOR,Violet);
                                                                        EW3ORDERMARK=11;
                                                                        LastOp=24;
                                                                     }
                                                                  else
                                                                     {
//*****
                                                                        //SetArrow(EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point,202,OrangeRed); // UNSTABLE UP, POSSIBLE DOWN
                                                                        ObjectCreate("Arrow"+EW3MARKTIME,OBJ_ARROW,0,EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point);
                                                                        ObjectSet("Arrow"+EW3MARKTIME,OBJPROP_COLOR,OrangeRed);
                                                                        EW3ORDERMARK=12;
                                                                        LastOp=25;
                                                                     }  
                                                               }
                                                         }
                                                      else
                                                         if (FiboLevel > 100) // Over Murrey 8/8 support/resistance line
                                                            {
//*****
                                                               //SetArrow(EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point,202,OrangeRed); // POSSIBLE DOWN
                                                               ObjectCreate("Arrow"+EW3MARKTIME,OBJ_ARROW,0,EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point);
                                                               ObjectSet("Arrow"+EW3MARKTIME,OBJPROP_COLOR,OrangeRed);
                                                               EW3ORDERMARK=11;
                                                               LastOp=26;
                                                            }
                                                         else
                                                            if (FiboLevel == 100) // Murrey 8/8 support/resistance line
                                                               {
//*****
                                                                  //SetArrow(EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point,200,OrangeRed); // POSSIBLE RESIST && UP
                                                                  ObjectCreate("Arrow"+EW3MARKTIME,OBJ_ARROW,0,EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point);
                                                                  ObjectSet("Arrow"+EW3MARKTIME,OBJPROP_COLOR,OrangeRed);
                                                                  EW3ORDERMARK=2;
                                                                  LastOp=27;
                                                               }  
                                                         } 
                                                      else 
                                                         if (FiboLevel > 70 
                                                         && FiboLevel < 150 
                                                         && PriceLevel > -60
                                                         //&& Ask < EW3 - Slippage * Point
                                                         )
                                                            {
                                                               if (FiboLevel == 100 // Murrey 8/8 support/resistance line
                                                               && MACDAngle == 2)
                                                                  {
//*****
                                                                     //SetArrow(EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point,198,OrangeRed); //TEMP DOWN, REVERT TO UP
                                                                     ObjectCreate("Arrow"+EW3MARKTIME,OBJ_ARROW,0,EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point);
                                                                     ObjectSet("Arrow"+EW3MARKTIME,OBJPROP_COLOR,OrangeRed);
                                                                     EW3ORDERMARK=3;
                                                                     LastOp=28;
                                                                  }
                                                               else
                                                                  {
//*****
                                                                     //SetArrow(EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point,196,Violet); //DOWN
                                                                     ObjectCreate("Arrow"+EW3MARKTIME,OBJ_ARROW,0,EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point);
                                                                     ObjectSet("Arrow"+EW3MARKTIME,OBJPROP_COLOR,Violet);
                                                                     EW3ORDERMARK=13;
                                                                     LastOp=29;
                                                                  }
                                                            } 
                                                         else
                                                            if (PriceLevel < -65 
                                                            && MA > iOpen(NULL,0,0)) 
                                                               {
//*****
                                                                  //SetArrow(EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point,200,Violet); // UP
                                                                  ObjectCreate("Arrow"+EW3MARKTIME,OBJ_ARROW,0,EW3MARKTIME, EW3 + (StopLoss / 2 + NoisePips) * Point);
                                                                  ObjectSet("Arrow"+EW3MARKTIME,OBJPROP_COLOR,Violet);
                                                                  EW3ORDERMARK=14;
                                                                  LastOp=30;
                                                               } 
                                                         }
                                                      EW4MARK=1;
                                                      EW4MARKTIME=EW3MARKTIME;
                                                      EW4MARKBAR=EW3MARKBAR;
                                                   }

                                                if (EW3MARK==1  
                                                && ((WaveAngle == 1 && EW3 - iOpen(NULL,0,0) > EW1 - EW2 )
                                                || (WaveAngle == 2 && iOpen(NULL,0,0) - EW3 > EW2 - EW1 ))
                                                )
                                                   {
                                                      //Print(TimeToStr(time),": ",Symbol," Elliot Wave 3 retracement ended. Last EW3:",EW3," Last EW3 Time:",TimeToStr(EW3MARKTIME)," Order Stop:",TrailingStopPoint);
                                                      //Alert(TimeToStr(time),": ",Symbol," Elliot Wave 3 retracement ended. Last EW3:",EW3," Last EW3 Time:",TimeToStr(EW3MARKTIME)," Order Stop:",TrailingStopPoint);
                                                      Comment("\nEWTrend=Recalculating..",
                                                      "\nLast EW0=",TimeToStr(EW5MARKTIME),
                                                      "    ",EW5,
                                                      "\nLast EW1=",TimeToStr(EW1MARKTIME),
                                                      "    ",EW1,
                                                      "\nLast EW2=",TimeToStr(EW2MARKTIME),
                                                      "    ",EW2,
                                                      "\nLast EW3=",TimeToStr(EW3MARKTIME),
                                                      "    ",EW3,
                                                      "\nPivot                         ",Pivot,
                                                      "\nResistance Level I            ",ResistanceLevel1,
                                                      "\nSupport Level I               ",SupportLevel1,
                                                      "\nResistance Level II           ",ResistanceLevel2,
                                                      "\nSupport Level II              ",SupportLevel2,
                                                      "\nPrice Level                   ",PriceLevel," %"
                                                      );
                                                      EW0MARK=0;
                                                      EW1MARK=0;
                                                      EW2MARK=0;
                                                      EW3MARK=0;
                                                      EW4MARK=0;
                                                      EW5MARK=0;
                                                      ORDERMARK=0;
                                                   }

                                                if (prevbars > 0 && EW3ORDERMARK==99
                                                && Bars != prevbars
                                                && ((PriceLevel > 0 && LastPriceLevel <= 0) 
                                                || (PriceLevel < 0 && LastPriceLevel >= 0))
                                                //&& CCI < 200
                                                )
                                                   {
                                                      ENTRYPRICE=iOpen(NULL,0,0);
                                                      if (ParabolicSAR < iOpen(NULL,0,0))
                                                         { 
                                                            ORDERANGLE=1; 
                                                            ENTRYPRICE=Pivot;
                                                            MinTakeProfitPtS=ResistanceLevel2;
                                                         }
                                                      if (ParabolicSAR > iOpen(NULL,0,0))  
                                                         { 
                                                            ORDERANGLE=11; 
                                                            ENTRYPRICE=Pivot;
                                                            MinTakeProfitPtS=SupportLevel2;
                                                         } 
                                                      Trace = 1;
                                                      //Print(TimeToStr(time),": Trace:",Trace," ORDERMARK:",ORDERMARK," ORDERANGLE:",ORDERANGLE," Price: ",Ask," Commodity Channel Index ",CCI," Pivot ",Pivot," Resistance Level I ",ResistanceLevel1," Support Level I ",SupportLevel1," Resistance Level II ",ResistanceLevel2," Support Level II ",SupportLevel2," Price Level ",PriceLevel," Last Price Level ",LastPriceLevel);    
                                                      LastOp=0;
                                                      ORDERMARK=1;
                                                      ORDERCOUNT=0;
                                                      if (WaveAngle == 1)  
                                                         SARAngle = 1;
                                                      if (WaveAngle == 2)  
                                                         SARAngle = 2;
                                                      for (counter = 1; counter < 10; counter++)
                                                         {
                                                            tempval =iSAR(NULL,0,SARstep,SARmax,counter);                         
                                                            //Print("Price:",Close[counter]," SAR:",tempval);
                                                            if (WaveAngle == 1 && tempval > Close[counter])
                                                               SARAngle = 2;
                                                            if (WaveAngle == 2 && tempval < Close[counter])
                                                               SARAngle = 1;
                                                            return(0);
                                                            if (WaveAngle == 1)
                                                               Print(TimeToStr(iTime(NULL,0,0)),": Support/Resistance cross at price:",iOpen(NULL,0,0) ," WaveAngle: UP SAR:",ParabolicSAR, " SARAngle:",SARAngle," PriceLevel: ",PriceLevel," LastPriceLevel: ",LastPriceLevel);
                                                            if (WaveAngle == 2)
                                                               Print(TimeToStr(iTime(NULL,0,0)),": Support/Resistance cross at price:",iOpen(NULL,0,0) ," WaveAngle: DOWN SAR:",ParabolicSAR, " SARAngle:",SARAngle," PriceLevel: ",PriceLevel," LastPriceLevel: ",LastPriceLevel);  
                                                            Print(TimeToStr(iTime(NULL,0,0)),": Support/Resistance - Pivot:",Pivot," Resistance Level I:",ResistanceLevel1," Support Level I:",SupportLevel1," Resistance Level II:",ResistanceLevel2," Support Level II:",SupportLevel2);
                                                            Print(" Support/Resistance - EW0MARK:",EW0MARK," EW1MARK:",EW1MARK," EW2MARK:",EW2MARK," EW3MARK:",EW3MARK," EW3MARKBAR=",EW3MARKBAR," EW4MARK:",EW4MARK," EW0:",EW5PRICE," EW1:",EW1," EW2:",EW2," EW3:",EW3);
//*****
                                                            //SetArrow(iTime(NULL,0,0),iOpen(NULL,0,0) ,254,Blue);
                                                            ObjectCreate("Arrow"+iTime(NULL,0,0),OBJ_ARROW,0,iTime(NULL,0,0),iOpen(NULL,0,0));
                                                            ObjectSet("Arrow"+EW3MARKTIME,OBJPROP_COLOR,Blue);

                                                            if (WaveAngle == 1 )
                                                               { 
                                                                  if (EW0MARK == 1 
                                                                  && EW1MARK==1
                                                                  && EW2MARK==0
                                                                  )
                                                                     ORDERANGLE=2;
                                                                  if (EW0MARK == 1 
                                                                  && EW1MARK==1
                                                                  && EW2MARK==1
                                                                  && EW3MARK==0
                                                                  )
                                                                     ORDERANGLE=23;
                                                                  if (EW0MARK == 1 
                                                                  && EW1MARK==1
                                                                  && EW2MARK==1
                                                                  && EW3MARK==1
                                                                  )
                                                                     ORDERANGLE=4;
                                                               }
                                                            if (WaveAngle == 2)
                                                               { 
                                                                  if (EW0MARK == 1
                                                                  && EW1MARK==1
                                                                  && EW2MARK==0
                                                                  )
                                                                     ORDERANGLE=21;
                                                                  if (EW0MARK == 1 
                                                                  && EW1MARK==1
                                                                  && EW2MARK==1
                                                                  && EW3MARK==0
                                                                  )
                                                                     ORDERANGLE=22;
                                                                  if (EW0MARK == 1 
                                                                  && EW1MARK==1
                                                                  && EW2MARK==1
                                                                  && EW3MARK==1
                                                                  )
                                                                     ORDERANGLE=3;
                                                               }
                                                            LastOp = 1;
                                                         }
                                                      if (ORDERMARK > 9990)
                                                         {
                                                            ORDERANGLE=WaveAngle;
                                                            if (ORDERCOUNT > TradesCount 
                                                            && EW3 <= iOpen(NULL,0,0))
                                                               ORDERCOUNT = TradesCount;   
                                                            if (WaveAngle == 1 && iOpen(NULL,0,0) - TakeProfit * Point > EW1)  
                                                               ORDERMARK = 1; // Additional Orders h&&ling
                                                            if (WaveAngle == 2 && iOpen(NULL,0,0) + TakeProfit * Point < EW1)  
                                                               ORDERMARK = 1; // Additional Orders h&&ling
                                                         }
                                                      if (WaveAngle == 1)  
                                                         SARAngle = 1;
                                                      if (WaveAngle == 2)  
                                                         SARAngle = 2;
                                                      for (counter=1;counter >= RetracementBars; counter ++)
                                                         tempval =iSAR(NULL,0,SARstep,SARmax,counter);
                                                         //Print("Price:",Close[counter]," SAR:",tempval);
                                                      if (WaveAngle == 1 && tempval > Close[counter])
                                                         SARAngle = 2;
                                                      if (WaveAngle == 2 && tempval < Close[counter])
                                                         SARAngle = 1;
                                                      return(0);

                                                      if (WaveAngle == 1)  
                                                         MACDAngle = 1;
                                                      if (WaveAngle == 2)  
                                                         MACDAngle = 2;
                                                      for (counter=1;counter >= RetracementBars; counter ++)
                                                         tempval=iMACD(NULL,0,RetracementBars/5,RetracementBars,RetracementBars/5,PRICE_CLOSE,MODE_EMA,counter);
                                                         //Print("MACD:",tempval);
                                                      if (WaveAngle == 1)
                                                         {
                                                            if (tempval > 0 && tempval < MACD)  
                                                               MACDAngle = 1;
                                                            if (tempval < 0 || tempval > MACD)  
                                                               MACDAngle = 2;
                                                         }  
                                                      if (WaveAngle == 2)
                                                         {
                                                            if (tempval > 0 || tempval < MACD)  
                                                               MACDAngle = 1;
                                                            if (tempval < 0 && tempval > MACD)  
                                                               MACDAngle = 2;
                                                         }  
                                                      return(0);
                                                      ShortMACDAngle = MACDAngle;
                                                      if (WaveAngle == 1)  
                                                         MACDAngle = 1;
                                                      if (WaveAngle == 2)  
                                                         MACDAngle = 2;
                                                      for (counter=1;counter >= RetracementBars; counter ++)
                                                         tempval=iMACD(NULL,0,RetracementBars,MaxBars,RetracementBars,PRICE_CLOSE,MODE_EMA,counter);
                                                         //Print("MACD:",tempval);
                                                      if (WaveAngle == 1)
                                                         {
                                                            if (tempval > 0 && tempval < MACD)  
                                                               MACDAngle = 1;
                                                            //if (tempval < 0 || tempval > MACD)  
                                                               //MACDAngle = 2;
                                                            if (tempval > MACD)
                                                               MACDAngle = 2;
                                                         }  
                                                      if (WaveAngle == 2)
                                                         {
                                                            if (tempval > 0 || tempval < MACD)  
                                                               MACDAngle = 1;
                                                            //if (tempval < 0 && tempval > MACD)  
                                                               //MACDAngle = 2;
                                                            if (tempval > MACD)  
                                                               MACDAngle = 2;
                                                         }  
                                                      return(0);
                                                      MaxPriceBar = Highest (MODE_CLOSE,MaxBars+1, RetracementBars);
                                                      MinPriceBar = Lowest (MODE_CLOSE, MaxBars+1, RetracementBars);
                                                      MaxPrice = iClose(NULL,0,MaxPriceBar);
                                                      MinPrice = iClose(NULL,0,MinPriceBar);
                                                      if (WaveAngle == 1) 
                                                         {
                                                            BearsAngle=1;
                                                            BullsAngle=1;
                                                            for (counter=1;counter >= RetracementBars; counter ++)
                                                               {
                                                                  tempval=iBearsPower(NULL,0,RetracementBars,MODE_HIGH,counter);
                                                                  //if (tempval < 0 || tempval > Bears)  
                                                                     //BearsAngle=2;
                                                                  if (tempval > Bears)  
                                                                     BearsAngle=2;
                                                                  tempval=iBullsPower(NULL,0,RetracementBars,MODE_LOW,counter); 
                                                                  //if (tempval < 0 || tempval > Bulls)  
                                                                     //BullsAngle=2;
                                                                  if (tempval > Bulls)  
                                                                     BullsAngle=2;
                                                               }
                                                         } 
                                                      if (WaveAngle == 2)
                                                         {
                                                            BearsAngle=2;
                                                            BullsAngle=2;
                                                            for (counter=1;counter >= RetracementBars; counter ++)
                                                               {
                                                                  tempval=iBearsPower(NULL,0,RetracementBars,MODE_HIGH,counter);
                                                                  //if (tempval > 0 || tempval < Bears)  
                                                                     //BearsAngle=1;
                                                                  if (tempval < Bears)  
                                                                     BearsAngle=1;
                                                                  tempval=iBullsPower(NULL,0,RetracementBars,MODE_LOW,counter); 
                                                                  //if (tempval > 0 || tempval < Bulls)  
                                                                     //BullsAngle=1;
                                                                  if (tempval < Bulls)  
                                                                     BullsAngle=1;
                                                               }
                                                         } 
                                                      if (EW3ORDERMARK > 0)
                                                         {  
                                                            ORDERCOUNT=0;
                                                            ORDERMARK=1;
                                                            if (EW3ORDERMARK == 1 
                                                            //&& Bid > EW3 + Slippage * Point
                                                            //&& iOpen(NULL,0,0) >= EW3
                                                            //&& Bid > EW3 + NoisePips * Point
                                                            )
                                                                  {
                                                                     ORDERANGLE=4;
                                                                  }  

                                                            if (EW3ORDERMARK == 2
                                                            //&& iOpen(NULL,0,0) >= EW3
                                                            //&& Ask < EW3 - NoisePips * Point
                                                            )
                                                               {
                                                                  ORDERANGLE = 3;    
                                                               }  

                                                            if (EW3ORDERMARK == 3
                                                            //&& iOpen(NULL,0,0) >= EW3
                                                            //&& Bid > EW3 + NoisePips * Point
                                                            )
                                                               {
                                                                  ORDERANGLE = 2;    
                                                               }  

                                                            if (EW3ORDERMARK == 4
                                                            //&& Ask < EW3 - NoisePips * Point
                                                            )
                                                               {
                                                                  ORDERANGLE = 22;
                                                               }  
                                                            if (EW3ORDERMARK == 11 
                                                            //&& Ask < EW3 - Slippage * Point
                                                            //&& iOpen(NULL,0,0) >= EW3
                                                            //&& Ask < EW3 - NoisePips * Point
                                                            )
                                                               {
                                                                  ORDERANGLE = 23;    
                                                               }  

                                                            if (EW3ORDERMARK == 12
                                                            //&& iOpen(NULL,0,0) >= EW3
                                                            //&& Bid > EW3 + NoisePips * Point
                                                            )
                                                               {
                                                                  ORDERANGLE = 22;  
                                                               }  
      
                                                            if (EW3ORDERMARK == 13
                                                            //&& iOpen(NULL,0,0) >= EW3
                                                            //&& Ask < EW3 - NoisePips * Point
                                                            )
                                                               {
                                                                  ORDERANGLE = 21;  
                                                               }  

                                                            if (EW3ORDERMARK == 14
                                                            //&& Ask < EW3 - NoisePips * Point
                                                            )
                                                               {
                                                                  ORDERANGLE = 3;    
                                                               }  
                                                            //EW3ORDERMARK=0; 
                                                         }  

                                                      MaxPriceBar = Highest (MODE_CLOSE,MaxBars+1, MaxBars);
                                                      MinPriceBar = Lowest (MODE_CLOSE, MaxBars+1, MaxBars);
                                                      MaxPrice = iClose(NULL,0,MaxPriceBar);
                                                      MinPrice = iClose(NULL,0,MinPriceBar);

                                                      if (EW2MARK == 1 && EW3MARK == 0 )
                                                         {
                                                            if (WaveAngle == 1 
                                                            && Bid > EW2 + NoisePips * Point
                                                            && Bid > SupportLevel1 + NoisePips * Point
                                                            && ((EW2 - SupportLevel1 > 0 && (EW2 - SupportLevel1) / 2 < NoisePips * 2 / 2) || (SupportLevel1 - EW2 > 0 && (SupportLevel1 - EW2) / 2 < NoisePips * 2 / 2))
                                                            && EW1 - Bid > MinTakeProfit * Point + NoisePips * Point + Slippage
                                                            )
                                                               {
                                                                  ENTRYPRICE=SupportLevel1;
                                                                  ORDERMARK=1;
//*****
                                                                  //SetArrow(iTime(NULL,0,0),Low,196,Violet);
                                                                  ObjectCreate("Arrow"+iTime(NULL,0,0),OBJ_ARROW,0,iTime(NULL,0,0),Low);
                                                                  ObjectSet("Arrow"+EW3MARKTIME,OBJPROP_COLOR,Violet);
                                                                  Print(TimeToStr(iTime(NULL,0,0)),": ",Symbol()," Elliot Wave 2 collision with Support Level 1 detected. Last EW2:",EW2," Last EW2 Time:",TimeToStr(EW2MARKTIME)," Recommended action: BUYLIMIT at ", ENTRYPRICE, " with T/P at ",EW1 - NoisePips * Point);
                                                                  Alert(TimeToStr(iTime(NULL,0,0)),": ",Symbol()," Elliot Wave 2 collision with Support Level 1 detected. Last EW2:",EW2," Last EW2 Time:",TimeToStr(EW2MARKTIME)," Recommended action: BUYLIMIT at ", ENTRYPRICE, " with T/P at ",EW1 - NoisePips * Point);
                                                                  Print(TimeToStr(iTime(NULL,0,0)),Symbol()," : Elliot Wave 2 collision - Pivot:",Pivot," Resistance Level I:",ResistanceLevel1," Support Level I:",SupportLevel1," Resistance Level II:",ResistanceLevel2," Support Level II:",SupportLevel2);
                                                               }

                                                            if (WaveAngle == 2 
                                                            && Ask < EW2 - NoisePips * Point
                                                            && Ask < SupportLevel1 - NoisePips * Point
                                                            && ((EW2 - SupportLevel1 > 0 && (EW2 - SupportLevel1) / 2 < NoisePips * 2 / 2) || (SupportLevel1 - EW2 > 0 && (SupportLevel1 - EW2) / 2 < NoisePips * 2 / 2))
                                                            && Ask - EW1 > MinTakeProfit * Point + NoisePips * Point + Slippage)
                                                               {
                                                                  ENTRYPRICE=SupportLevel1;
                                                                  ORDERMARK=2;
//*****
                                                                  //SetArrow(iTime(NULL,0,0),High,198,Violet);
                                                                  ObjectCreate("Arrow"+iTime(NULL,0,0),OBJ_ARROW,0,iTime(NULL,0,0),High);
                                                                  ObjectSet("Arrow"+EW3MARKTIME,OBJPROP_COLOR,Violet);
                                                                  Print(TimeToStr(iTime(NULL,0,0)),": ",Symbol()," Elliot Wave 2 collision with Resistance Level 1 detected. Last EW2:",EW2," Last EW2 Time:",TimeToStr(EW2MARKTIME)," Recommended action: BUYLIMIT at ", ENTRYPRICE, " with T/P at ",EW1 - NoisePips * Point);
                                                                  Alert(TimeToStr(iTime(NULL,0,0)),": ",Symbol()," Elliot Wave 2 collision with Resistance Level 1 detected. Last EW2:",EW2," Last EW2 Time:",TimeToStr(EW2MARKTIME)," Recommended action: BUYLIMIT at ", ENTRYPRICE, " with T/P at ",EW1 - NoisePips * Point);
                                                                  Print(TimeToStr(iTime(NULL,0,0)),Symbol()," : Elliot Wave 2 collision - Pivot:",Pivot," Resistance Level I:",ResistanceLevel1," Support Level I:",SupportLevel1," Resistance Level II:",ResistanceLevel2," Support Level II:",SupportLevel2);
                                                               }
                                                         }
                                                   }
                                             }
//----========== Section dessin ==========----//
                                             /*
                                             i=0;
                                             for(h=0; h<Bars && i<MaxBars; h++)
                                                {
                                                   if ((ExtMapBuffer[h]!=0) || (ExtMapBuffer2[h]!=0)) 
                                                      {
                                                         Peak[i]= h;
                                                         i++;    
                                                      }
                                                }
   
                                             for(j=0;j<i && j<MaxBars && found==false;j++) 
                                                {
                                                   Elliot[1]=Peak[j+4]; // 1 High
                                                   Elliot[2]=Peak[j+3]; // 2 Low
                                                   Elliot[3]=Peak[j+2]; // 3 High 
                                                   Elliot[4]=Peak[j+1]; // 4 Low 
                                                   Elliot[5]=Peak[j+0]; // 5 High
                                                   if (     // Buy Elliotwave
                                                   Low[Elliot[1]]<High[Elliot[2]] &&  // 1. + 3.a.//1-3
                                                   Low[Elliot[3]]<Low[Elliot[1]] &&   // 2. + 3.b. //3-1
                                                   Low[Elliot[3]]<High[Elliot[4]]  // 4//3-4
                                                   ) 
                                                      {
                                                         ElliotWave="Buy";
                                                      } 
                                                      else if 
                                                         (     // Sell Elliotwave
                                                         High[Elliot[1]]>Low[Elliot[2]] &&  // 1. + 3.a.
                                                         High[Elliot[3]]>High[Elliot[1]] &&   // 2. + 3.b. 
                                                         High[Elliot[3]]>Low[Elliot[4]]  // 4
                                                         ) 
                                                            {
                                                               ElliotWave="Sell";
                                                            } 
                                                         else 
                                                            {
                                                               ElliotWave="Not";
                                                            }
      
                                                         if(ElliotWave=="Buy") 
                                                            {
      	                                                        ObjectCreate(Title + "Line-1-3", OBJ_TREND, 0, Time[Elliot[1]],Low[Elliot[1]], Time[Elliot[3]],Low[Elliot[3]] );
                                                                  //ObjectSet(Title + "Line-1-3",OBJPROP_RAY,0);
        	                                                         ObjectSet(Title + "Line-1-3", OBJPROP_COLOR, Lime);
          	                                                       ObjectSet(Title + "Line-1-3", OBJPROP_WIDTH, 2);
                                                                  //ObjectSet(Title + "Line-1-3",OBJPROP_BACK,1);
          	
        	                                                      if (ObjectGetValueByShift(Title + "Line-1-3", Elliot[3]) >= Low[Elliot[3]]) 
        	                                                         {
           	                                                         ObjectCreate(Title + "1", OBJ_TEXT, 0, Time[Elliot[1]],Low[Elliot[1]]-LowerDistance*Point );
           	                                                         ObjectSetText(Title + "1", ""+DoubleToStr(1,0), 10, "Arial", Blue);
           	                                                         ObjectCreate(Title + "2", OBJ_TEXT, 0, Time[Elliot[2]],High[Elliot[2]]+UpperDistance*Point );
           	                                                         ObjectSetText(Title + "2", ""+DoubleToStr(2,0), 10, "Arial", Blue);
           	                                                         ObjectCreate(Title + "3", OBJ_TEXT, 0, Time[Elliot[3]],Low[Elliot[3]]-LowerDistance*Point );
           	                                                         ObjectSetText(Title + "3", ""+DoubleToStr(3,0), 10, "Arial", Blue);
           	                                                         ObjectCreate(Title + "4", OBJ_TEXT, 0, Time[Elliot[4]],High[Elliot[4]]+UpperDistance*Point );
           	                                                         ObjectSetText(Title + "4", ""+DoubleToStr(4,0), 10, "Arial", Blue);
           	                                                         ObjectCreate(Title + "5", OBJ_TEXT, 0, Time[Elliot[5]],Low[Elliot[5]]-LowerDistance*Point );
           	                                                         ObjectSetText(Title + "5", ""+DoubleToStr(5,0), 10, "Arial", Blue);
           	
           	                                                         ObjectCreate(Title + "Line-1-4", OBJ_TREND, 0, Time[Elliot[1]],Low[Elliot[1]], Time[Elliot[4]],High[Elliot[4]] );
           	                                                         ObjectSet(Title + "Line-1-4", OBJPROP_COLOR, Red);
                                                                     //ObjectSet(Title + "Line-1-4",OBJPROP_RAY,0);
           	                                                         ObjectSet(Title,OBJPROP_STYLE,STYLE_DOT);
          	                                                         ObjectSet(Title + "Line-1-4", OBJPROP_WIDTH, 0);
          	                                                         ObjectSet(Title + "Line-1-4",OBJPROP_BACK,0);
          	                                                         ObjectSet(Title + "Line-2-5",OBJPROP_BACK,0);
          	
                                                                     //ObjectCreate(Title + "Line-2-5", OBJ_TREND, 0, Time[Elliot[2]],High[Elliot[2]], Time[Elliot[5]],Low[Elliot[5]] );
                                                                     //ObjectSet(Title,OBJPROP_STYLE,STYLE_DOT);
                                                                     //ObjectSet(Title + "Line-2-5",OBJPROP_RAY,0);
                                                                     //ObjectSet(Title + "Line-2-5", OBJPROP_COLOR, Lime);
                                                                     //ObjectSet(Title + "Line-2-5", OBJPROP_WIDTH, 1);
          	
                                                                     //Comment("Buy Elliotwave (" + TimeToStr(Time[Elliot[5]],TIME_DATE|TIME_MINUTES) + ") at " + (ObjectGetValueByShift("Line-1-3", Elliot[5])-5*Point) + " SL " + High[Elliot[5]]);
          	                                                         // found=true;
                                                                  //} 
                                                               //else 
                                                                  //{
                                                                     //ObjectDelete(Title + "Line-1-3");
                                                                  }
                                                               } 
                                                            else if (ElliotWave=="Sell") 
                                                               {
                                                                     ObjectCreate(Title + "Line-1-3", OBJ_TREND, 0, Time[Elliot[1]],High[Elliot[1]], Time[Elliot[3]],High[Elliot[3]] );
                                                                     //ObjectSet(Title + "Line-1-3",OBJPROP_RAY,0);
         	                                                         ObjectSet(Title + "Line-1-3", OBJPROP_COLOR, Lime);
          	                                                         ObjectSet(Title + "Line-1-3", OBJPROP_WIDTH, 2);
                                                                     //ObjectSet(Title + "Line-1-3",OBJPROP_BACK,1);
          	
                                                                     if ( ObjectGetValueByShift(Title + "Line-1-3", Elliot[3]) <= High[Elliot[3]] ) 
                                                                        {
           	                                                               ObjectCreate(Title + "1", OBJ_TEXT, 0, Time[Elliot[1]],High[Elliot[1]]+UpperDistance*Point );
                                                                           ObjectSetText(Title + "1", ""+DoubleToStr(1,0), 10, "Arial", Blue);
                                                                           ObjectCreate(Title + "2", OBJ_TEXT, 0, Time[Elliot[2]],Low[Elliot[2]]-LowerDistance*Point );
                                                                           ObjectSetText(Title + "2", ""+DoubleToStr(2,0), 10, "Arial", Blue);
                                                                           ObjectCreate(Title + "3", OBJ_TEXT, 0, Time[Elliot[3]],High[Elliot[3]]+UpperDistance*Point );
                                                                           ObjectSetText(Title + "3", ""+DoubleToStr(3,0), 10, "Arial", Blue);
                                                                           ObjectCreate(Title + "4", OBJ_TEXT, 0, Time[Elliot[4]],Low[Elliot[4]]-LowerDistance*Point );
                                                                           ObjectSetText(Title + "4", ""+DoubleToStr(4,0), 10, "Arial", Blue);
                                                                           ObjectCreate(Title + "5", OBJ_TEXT, 0, Time[Elliot[5]],High[Elliot[5]]+UpperDistance*Point );
                                                                           ObjectSetText(Title + "5", ""+DoubleToStr(5,0), 10, "Arial", Blue);
            
                                                                           ObjectCreate(Title + "Line-1-4", OBJ_TREND, 0, Time[Elliot[1]],High[Elliot[1]], Time[Elliot[4]],Low[Elliot[4]] );
                                                                           ObjectSet(Title + "Line-1-4", OBJPROP_COLOR, Red);
                                                                           //ObjectSet(Title + "Line-1-4",OBJPROP_RAY,0);
                                                                           ObjectSet(Title,OBJPROP_STYLE,STYLE_DOT);
                                                                           ObjectSet(Title + "Line-1-4", OBJPROP_WIDTH, 0);
                                                                           ObjectSet(Title + "Line-1-4",OBJPROP_BACK,0);
            
            
                                                                           //ObjectCreate(Title + "Line-2-5", OBJ_TREND, 0, Time[Elliot[2]],Low[Elliot[2]], Time[Elliot[5]],High[Elliot[5]] );
                                                                           //ObjectSet(Title,OBJPROP_STYLE,STYLE_DOT);
                                                                           //ObjectSet(Title + "Line-2-5",OBJPROP_RAY,0);
                                                                           //ObjectSet(Title + "Line-2-5", OBJPROP_COLOR, Yellow);
                                                                           //ObjectSet(Title + "Line-2-5", OBJPROP_WIDTH, 1);
                                                                           //ObjectSet(Title + "Line-2-5",OBJPROP_BACK,0);
      
    
                                                                           //found=true;
                                                                        } 
                                                                     //else 
                                                                        //{
                                                                              //ObjectDelete(Title + "Line-1-3");
                                                                              ObjectsRedraw();
                                                                        //}
                                                   } 
                                             }
                                             */
                                       }
                                 }
//----
      return(0);
   }
//+------------------------------------------------------------------+