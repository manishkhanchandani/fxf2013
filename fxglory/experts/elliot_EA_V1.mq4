//Elliot Expert
//Elliot wave oscillator with juice
//Aymen Saket v1.0
//1/5/2006

#define MIN_STOPLOSS_POINT 10
#define MIN_TAKEPROFIT_POINT 10 
#define MAGIC 317324

extern string sNameExpert = "Elliot Expert";
extern int nAccount =0;
extern double dBuyStopLossPoint = 20;
extern double dSellStopLossPoint = 20;
extern double dBuyTakeProfitPoint = 100;
extern double dSellTakeProfitPoint = 100;
extern double dBuyTrailingStopPoint = 20;
extern double dSellTrailingStopPoint = 20;
extern double dLots = 1; 
extern int nSlippage = 3;
extern bool lFlagUseHourTrade = False;
extern int nFromHourTrade = 0;
extern int nToHourTrade = 23;
extern bool lFlagUseSound = False;
extern string sSoundFileName = "alert.wav";
extern color colorOpenBuy = Blue;
extern color colorCloseBuy = Aqua;
extern color colorOpenSell = Red;
extern color colorCloseSell = Aqua;


void deinit() {
   Comment("");
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start(){
   if (lFlagUseHourTrade){
      if (!(Hour()>=nFromHourTrade && Hour()<=nToHourTrade)) {
         Comment("Time for trade has not come else!");
         return(0);
      } else Comment("");
   }else Comment("");
   
   if(Bars < 100){
      Print("bars less than 100");
      return(0);
   }
   
   if (nAccount > 0 && nAccount != AccountNumber()){
      Comment("Trade on account :"+AccountNumber()+" FORBIDDEN!");
      return(0);
   }else Comment("");
   
   if((dBuyStopLossPoint > 0 && dBuyStopLossPoint < MIN_STOPLOSS_POINT) ||
      (dSellStopLossPoint > 0 && dSellStopLossPoint < MIN_STOPLOSS_POINT)){
      Print("StopLoss less than " + MIN_STOPLOSS_POINT);
      return(0);
   }
   if((dBuyTakeProfitPoint > 0 && dBuyTakeProfitPoint < MIN_TAKEPROFIT_POINT) ||
      (dSellTakeProfitPoint > 0 && dSellTakeProfitPoint < MIN_TAKEPROFIT_POINT)){
      Print("TakeProfit less than " + MIN_TAKEPROFIT_POINT);
      return(0);
   }


double dielliot0=iCustom(NULL,0,"Elliott Wave Oscillator", 0,1);
double dielliot1=iCustom(NULL,0,"Elliott Wave Oscillator", 0,0);
double dielliot2=iCustom(NULL,0,"Elliott Wave Oscillator", 0,1);
double dielliot3=iCustom(NULL,0,"Elliott Wave Oscillator", 0,0);
double Juice = iCustom(NULL, 0, "Juice", 0,0);


   if(AccountFreeMargin() < (1000*dLots)){
      Print("We have no money. Free Margin = " + AccountFreeMargin());
      return(0);
   }
   
   bool lFlagBuyOpen = false, lFlagSellOpen = false, lFlagBuyClose = false, lFlagSellClose = false;
   
   lFlagBuyOpen = (dielliot0<0 && dielliot1>0 && Juice>0.0004); //consider the value of elliot as well
                                                                //and consider a 10 pip upward movement
                                                                //before entry for future mod
   lFlagSellOpen = (dielliot2>0 && dielliot3<0 && Juice>0.0004);//consider the value of elliot as well
                                                                //and consider a 10 pip upward movement
                                                                //before entry for future mod
   lFlagBuyClose = False;
   lFlagSellClose = False;
   
   if (!ExistPositions()){

      if (lFlagBuyOpen){
         OpenBuy();
         return(0);
      }

      if (lFlagSellOpen){
         OpenSell();
         return(0);
      }
   }
   if (ExistPositions()){
      if(OrderType()==OP_BUY){
         if (lFlagBuyClose){
            bool flagCloseBuy = OrderClose(OrderTicket(), OrderLots(), Bid, nSlippage, colorCloseBuy); 
            if (flagCloseBuy && lFlagUseSound) 
               PlaySound(sSoundFileName); 
            return(0);
         }
      }
      if(OrderType()==OP_SELL){
         if (lFlagSellClose){
            bool flagCloseSell = OrderClose(OrderTicket(), OrderLots(), Ask, nSlippage, colorCloseSell); 
            if (flagCloseSell && lFlagUseSound) 
               PlaySound(sSoundFileName); 
            return(0);
         }
      }
   }
   
   if (dBuyTrailingStopPoint > 0 || dSellTrailingStopPoint > 0){
      
      for (int i=0; i<OrdersTotal(); i++) { 
         if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) { 
            bool lMagic = true;
            if (MAGIC > 0 && OrderMagicNumber() != MAGIC)
               lMagic = false;
            
            if (OrderSymbol()==Symbol() && lMagic) { 
               if (OrderType()==OP_BUY && dBuyTrailingStopPoint > 0) { 
                  if (Bid-OrderOpenPrice() > dBuyTrailingStopPoint*Point) { 
                     if (OrderStopLoss()<Bid-dBuyTrailingStopPoint*Point) 
                        ModifyStopLoss(Bid-dBuyTrailingStopPoint*Point); 
                  } 
               } 
               if (OrderType()==OP_SELL) { 
                  if (OrderOpenPrice()-Ask>dSellTrailingStopPoint*Point) { 
                     if (OrderStopLoss()>Ask+dSellTrailingStopPoint*Point || OrderStopLoss()==0)  
                        ModifyStopLoss(Ask+dSellTrailingStopPoint*Point); 
                  } 
               } 
            } 
         } 
      } 
   }
   return (0);
}

bool ExistPositions() {
	for (int i=0; i<OrdersTotal(); i++) {
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         bool lMagic = true;
         
         if (MAGIC > 0 && OrderMagicNumber() != MAGIC)
            lMagic = false;

			if (OrderSymbol()==Symbol() && lMagic) {
				return(True);
			}
		} 
	} 
	return(false);
}

void ModifyStopLoss(double ldStopLoss) { 
   bool lFlagModify = OrderModify(OrderTicket(), OrderOpenPrice(), ldStopLoss, OrderTakeProfit(), 0, CLR_NONE); 
   if (lFlagModify && lFlagUseSound) 
      PlaySound(sSoundFileName); 
} 

void OpenBuy() { 
   double dStopLoss = 0, dTakeProfit = 0;

   if (dBuyStopLossPoint > 0)
      dStopLoss = Bid-dBuyStopLossPoint*Point;
   
   if (dBuyTakeProfitPoint > 0)
     dTakeProfit = Ask + dBuyTakeProfitPoint * Point; 
 
   
   int numorder = OrderSend(Symbol(), OP_BUY, dLots, Ask, nSlippage, dStopLoss, dTakeProfit, sNameExpert, MAGIC, 0, colorOpenBuy); 
   
   if (numorder > -1 && lFlagUseSound) 
      PlaySound(sSoundFileName);
} 

void OpenSell() { 
   double dStopLoss = 0, dTakeProfit = 0;
   
   if (dSellStopLossPoint > 0)
      dStopLoss = Ask+dSellStopLossPoint*Point;
   
   if (dSellTakeProfitPoint > 0)
      dTakeProfit = Bid-dSellTakeProfitPoint*Point;
   
   int numorder = OrderSend(Symbol(),OP_SELL, dLots, Bid, nSlippage, dStopLoss, dTakeProfit, sNameExpert, MAGIC, 0, colorOpenSell); 
   
   if (numorder > -1 && lFlagUseSound) 
      PlaySound(sSoundFileName); 
} 

