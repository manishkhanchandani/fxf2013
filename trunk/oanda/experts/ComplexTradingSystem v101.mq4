//+------------------------------------------------------------------+
//|                                       ComplexTradingSystemV1.mq4 |
//|                                         Copyright © 2008, OmarAli|
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                  MA+MACD+RSI.mq4 |
//|                                       Copyright © 2008, omar ali |
//|                                            omaraljarah@yahoo.com |
//+------------------------------------------------------------------+

extern double Lots = 0.1;
extern double TakeProfit = 50;
extern double StopLoss = 50;
extern int TrailingProfit=0;//|------------------trailing stop after profit reached
extern int TrailingStop=30;//|--------------------trailing stop
extern int TrailingStep=0;//|--------------------trailing step
extern double MACDByeLevel = 0.0;
extern double MACDSellLevel = 0.0;
extern double RSILevel = 50;
extern double FastMA = 5;
extern double SlowMA = 10;

int digits;
double point;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

int init()
{
   digits=Digits;
   point=GetPoints();
}

//|---------x digits broker

double GetPoints()
{
   if(Digits==3 || Digits==5)point=Point*10;
   else point=Point;
   return(point);
}   
   
int start()
  {//
   //|---------trailing stop

   if(TrailingStop>0)MoveTrailingStop();
   
   double MACDCurrent,RSI;
   double FMAcr,FMApr,SMAcr,SMApr;
   int cnt, ticket, total;
   // initial data checks
// it is important to make sure that the expert works with a normal
// chart and the user did not make any mistakes setting external 
// variables (Lots, StopLoss, TakeProfit, 
// TrailingStop) in our case, we check TakeProfit
// on a chart of less than 100 bars
   if(Bars<100)
     {//
      Print("bars less than 100");
      return(0);  
     }//
   if(TakeProfit<10)
     {//
      Print("TakeProfit less than 10");
      return(0);  // check TakeProfit
     }//
     // to simplify the coding and speed up access
// data are put into internal variables

   MACDCurrent=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
   FMAcr=iMA(NULL, 0, FastMA, 0, MODE_SMA, PRICE_CLOSE,0);
   FMApr=iMA(NULL, 0, FastMA, 0, MODE_SMA, PRICE_CLOSE,1);
   SMAcr=iMA(NULL, 0, SlowMA, 0, MODE_SMA, PRICE_CLOSE,0);
   SMApr=iMA(NULL, 0, SlowMA, 0, MODE_SMA, PRICE_CLOSE,1);
   RSI=iRSI(NULL,0,14,0,0);

//   total=OrdersTotal();
   if(!ExistPositions()) 
     {//
      if(AccountFreeMargin()<(1000*Lots))
        {//
         Print("We have no money. Free Margin = ", AccountFreeMargin());
         return(0);  
        }//
        
         if(FMAcr>SMAcr && FMApr<SMApr && MACDCurrent>MACDByeLevel && RSI>50)
        {//
         ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,3,Ask-StopLoss*point,Ask+TakeProfit*point,"ComplexTradingSystem",16384,0,Green);
         if(ticket>0)
           {//
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("BUY order opened : ",OrderOpenPrice());
           }//
         else Print("Error opening BUY order : ",GetLastError()); 
         return(0); 
        }//
        
      if(FMAcr<SMAcr && FMApr>SMApr && MACDCurrent<MACDSellLevel && RSI<50)
        {//
         ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,3,Bid+StopLoss*point,Bid-TakeProfit*point,"ComplexTradingSystem",16384,0,Red);
         if(ticket>0)
           {//
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES)) Print("SELL order opened : ",OrderOpenPrice());
           }//
         else Print("Error opening SELL order : ",GetLastError()); 
         return(0); 
        }//
      return(0);
     }//   if(total<Max_Trades && !ExistPositions())
//--------------------------------------

if(ExistPositions()){ 

   for(cnt=0;cnt<total;cnt++)
     {//
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL &&   
         OrderSymbol()==Symbol())  
        {//
         if(OrderType()==OP_BUY)   
           {//
              if(Bid < OrderOpenPrice()-point*StopLoss)
            {//
                 OrderClose(OrderTicket(),OrderLots(),Bid,3,Violet); 
                 return(0); 
                }//
           }//
         else 
           {//
        
               if(Ask > OrderOpenPrice()+ point*StopLoss)
               {//
               OrderClose(OrderTicket(),OrderLots(),Ask,3,Violet); 
               return(0); // exit
              }//
           }//else
        }//
     }//
   }
   return(0);
}//



bool ExistPositions() {
	for (int i=0; i<OrdersTotal(); i++) {
		if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
			if (OrderSymbol()==Symbol() && OrderMagicNumber()==16384) {
				return(True);
			}
		} 
	} 
	return(false);
}

//|---------trailing stop

void MoveTrailingStop()
{
   int cnt,total=OrdersTotal();
   for(cnt=0;cnt<total;cnt++)
   {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()<=OP_SELL&&OrderSymbol()==Symbol()&&OrderMagicNumber()==16384)
      {
         if(OrderType()==OP_BUY)
         {
            if(TrailingStop>0&&NormalizeDouble(Ask-TrailingStep*point,digits)>NormalizeDouble(OrderOpenPrice()+TrailingProfit*point,digits))  
            {                 
               if((NormalizeDouble(OrderStopLoss(),digits)<NormalizeDouble(Bid-TrailingStop*point,digits))||(OrderStopLoss()==0))
               {
                  OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Bid-TrailingStop*point,digits),OrderTakeProfit(),0,Blue);
                  return(0);
               }
            }
         }
         else 
         {
            if(TrailingStop>0&&NormalizeDouble(Bid+TrailingStep*point,digits)<NormalizeDouble(OrderOpenPrice()-TrailingProfit*point,digits))  
            {                 
               if((NormalizeDouble(OrderStopLoss(),digits)>(NormalizeDouble(Ask+TrailingStop*point,digits)))||(OrderStopLoss()==0))
               {
                  OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Ask+TrailingStop*point,digits),OrderTakeProfit(),0,Red);
                  return(0);
               }
            }
         }
      }
   }
}