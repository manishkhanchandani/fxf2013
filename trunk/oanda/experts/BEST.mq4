//+-----------------------------------------------------------------+
//|                                                  BEST.mq4 |
//+-----------------------------------------------------------------+
//| HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH |
//| H\    \               http://wsforex.ru/               /    / H |
//| H )----)----------------------------------------------(----(  H |
//| H/    /   ���� �������� ������� �� �����: wsforex.ru   \    \ H |
//| HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH |
//+-----------------------------------------------------------------+

#property copyright "wsforex@list.ru"
#property link      "http://wsforex.ru/"
//+-----------------------------------------------------------------+
//| ���������� : ������.�  - ��� ���� -  "http://wsforex.ru/"       |
//+-----------------------------------------------------------------+
extern bool    ExpertTime      = True; // ������������ ������� ������ �� ������� True-��� False-����
extern string  TradeDay        = "1,2,3,4,5"; 
extern int     HourStart       = 0;     // ����� � ����������� 
extern int     HourStops       = 19;    // ���� � �������
extern int     Ea.Start        = 0;     // ����� ���������
extern int     Ea.Stop         = 23;    // ���� ���������
// -----
extern bool    MM              = False;
extern double  MaxRisk         = 0.7;
extern double  Lots            = 0.01;
extern int     Otstup          = 0;
extern int     Life_time       = 1440;
extern int     MuStopLevel     = 100;
extern int     MuSpread        = 30;
extern int     MagicNumber     = 777;
extern string  ����   ="  ��������� �����  "; 
extern int     StdDevPer       = 37;
extern int     FletBars        = 2;
extern int     CanalMin        = 610;
extern int     CanalMax        = 1860;
//+-----------------------------------------------------------------+
//| ���������� : ������.�  - ��� ���� -  "http://wsforex.ru/"       |
//+-----------------------------------------------------------------+
extern bool    Trailing   = True;
extern double  FiboTral   = 0.873;
//+-----------------------------------------------------------------+
//| ���������� : ������.�  - ��� ���� -  "http://wsforex.ru/"       |
//+-----------------------------------------------------------------+
int tik, exp, dg, lv, sp;
double pa, pb, po;
string Times,  symbol;
string com = "";
string ExpertName;
bool flagup, flagdw, EaDisabled = False;
//+-----------------------------------------------------------------+
//| ���������� : ������.�  - ��� ���� -  "http://wsforex.ru/"       |
//+-----------------------------------------------------------------+
int init()
  {
//----
   symbol = Symbol();
   ExpertName=WindowExpertName();
//----
   if(symbol=="EURUSD")
   {
   }
//----
   if(symbol=="GBPUSD")
   {
   }
//----
   if (!IsTesting()) {
   if (IsExpertEnabled()) Message("\n�������� ���������� � ����� ������� ��������� �����");
   else Message("\n��������! ������ ������ �� ������� ���������");
   }
//----
  return(0);
}
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
void start(){
// -----
  Times = "����� GMT - "+ TimeToStr(TimeCurrent()-3600, TIME_MINUTES|TIME_SECONDS);
  pb = MarketInfo(symbol,MODE_BID);
  pa = MarketInfo(symbol,MODE_ASK); 
  dg = MarketInfo(symbol,MODE_DIGITS);
  po = MarketInfo(symbol,MODE_POINT);
  lv = MarketInfo(symbol,MODE_STOPLEVEL)+MarketInfo(symbol,MODE_SPREAD);
// -----           
  Comment("\n�������� "+ExpertName+" ���� � ������: - ",IIcm(Tradetime(ExpertTime, Ea.Start, Ea.Stop)==1 && EaDisabled==False),
          "\n����: - ",Dayof(),
          "\n�������� ����: - ",shet(),
          "\nCompany: - ",AccountCompany(),
          "\nEquity: - ",AccountEquity(),
          "\nStop Out: - ",AccountStopoutLevel(),
          "\n����� �� GMT: - " +Times,
          "\nSpread: - ",MarketInfo(symbol,MODE_SPREAD),
          "\nStopLevel: - ",lv,
          "\n�����: - ",AccountLeverage()
          );               
// ----- 
  if(AccountEquity()<=AccountStopoutLevel())
   {
     ClosePosBySelect(OP_BUY,  MagicNumber);
     DeleteOrders(OP_BUYSTOP,  MagicNumber);
     ClosePosBySelect(OP_SELL, MagicNumber);
     DeleteOrders(OP_SELLSTOP, MagicNumber);
   }
// -----  
  static datetime BARflag = 0;
  datetime now = Time[0];
  if(BARflag < now){
  BARflag = now;
  if(OrdersCount(OP_SELL,MagicNumber)==1)DeleteOrders(OP_BUYSTOP, MagicNumber);
  if(OrdersCount(OP_BUY,MagicNumber)==1)DeleteOrders(OP_SELLSTOP, MagicNumber);
// -----
  int ress = ChecBarsFlet();
  double Pricemax = PriceMaxBars(ress);
  double Pricemin = PriceMinBars(ress);
  double ChCan=Pricemax-Pricemin;
  double TPBuy=Pricemax+ChCan;
  double TPSell=Pricemin-ChCan;
  double SLBuy=Pricemax-ChCan*2;
  double SLSell=Pricemin+ChCan*2;
// -----
  if(ChCan<CanalMax*po && ChCan>=CanalMin*po && ress>=FletBars && OrdersCount(-1, MagicNumber)==0)
   {
     TrendLine("Max", Time[ress],Time[0], Pricemax, Pricemax, 0,BlueViolet);
     TrendLine("Min", Time[ress],Time[0], Pricemin, Pricemin, 0, BlueViolet);
     TrendLine("TPBuy", Time[ress],Time[0], TPBuy, TPBuy, 1, Red);
     TrendLine("TPSell", Time[ress],Time[0], TPSell, TPSell, 1, Red);
   }
// ----- 
   exp=CurTime()+PERIOD_D1*Life_time;
   if(Trailing) ModificacionsOrders(MagicNumber); 
// ---- � � � � � � � � � - � � � � � � -----------------------------------------+
 if(ChCan>=CanalMin *po && ChCan<CanalMax*po && ress>=FletBars && Tradetime(ExpertTime, Ea.Start, Ea.Stop)==1 && EaDisabled==False){
 int Loss, Profit, stops=0;
 double lot, op, sl, tp;
 //---
    int orders=OrdersHistoryTotal();
      for (int i = orders - 1; i >= 0; i--) {
         if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) == FALSE) {
            Print("������ � �������!");
            break;
         }
         if (OrderSymbol() != Symbol() || OrderType() > OP_SELL) continue;
         if (OrderMagicNumber() !=MagicNumber) continue;
         if (OrderProfit() > 0.0) break;
         if (OrderProfit() < 0.0) Loss++;
      }
//---
   srvol();
   lot=GetLots();
   if(Loss==1)lot=Lots*4;
   if(flagup==true && pa>Pricemin && pa<Pricemax && OrdersCount(OP_BUYSTOP, MagicNumber)==0 && 
   OrdersCount(OP_BUY,MagicNumber)==0 && OrdersCount(OP_SELL,MagicNumber)==0) {
   op=Pricemax;
   sl=SLBuy;
   tp=TPBuy;
   if((op-pa)/po>lv && (op-sl)/po>lv && (tp-op)/po>lv) { 
   tik=SetOrder(symbol, OP_BUYSTOP, lot, op, sl, tp, MagicNumber, com, exp);
   if(tik>0)flagup=false;
   }
 }
   if(flagdw==true && pb>Pricemin && pb<Pricemax && OrdersCount(OP_SELLSTOP,MagicNumber)==0 &&
   OrdersCount(OP_SELL,MagicNumber)==0 && OrdersCount(OP_BUY,MagicNumber)==0) {
   op=Pricemin;
   sl=SLSell;
   tp=TPSell;
   if((pb-op)/po>lv && (sl-op)/po>lv && (op-tp)/po>lv) {
   tik=SetOrder(symbol, OP_SELLSTOP, lot, op, sl, tp, MagicNumber, com, exp);
   if(tik>0)flagdw=false;   
       }
     }
   }
 }
// -----
 return(0);
}
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
int srvol(int bar=100){
  int ress, pp;
  for (int i=0; i<bar; i++){ 
  pp=pp+MathAbs(Close[i]-Open[i])/Point;
  }
  ress=pp/bar;
 return(ress);
}

/*
int vol(int bar=100){
  int ress, pp;
  for (int i=0; i<bar; i++){ 
  pp=pp+Volume[i];
  }
  ress=pp/bar;
 return(ress);
}*/
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
int ChecBarsFlet(){
// -----
   int i,ress=0;
   for (i=0; i<100; i++){ 
   if(stddev(i)>stddev(i+1)) break;
   if(stddev(i)<stddev(i+1)){
      ress++;
      flagup=true;
      flagdw=true; 
      }
   }
// -----
  return(ress);
}
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
double stddev(int i=0){
  return(iStdDev(Symbol(),0,StdDevPer,0,MODE_SMMA,PRICE_MEDIAN,i));
}
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
double PriceMaxBars(int bar=0){
// -----
 double new_extremum;
  for(int i=1;i<=bar;i++)
    {
    if (i==1) new_extremum = iHigh(Symbol(),0,i); else 
    if (new_extremum<iHigh(Symbol(),0,i)) new_extremum = iHigh(Symbol(),0,i);
    } 
// -----
  return(new_extremum);
}
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
double PriceMinBars(int bar=0){
// -----
 double new_extremum;
  for(int i=1;i<=bar;i++)
    {
    if (i==1) new_extremum = iLow(Symbol(),0,i); else 
    if (new_extremum>iLow(Symbol(),0,i)) new_extremum = iLow(Symbol(),0,i);
    } 
// -----
  return(new_extremum);
}
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
void TrendLine(string name, datetime x1, 
               datetime x2, double y1, double y2, bool ly, color col)
  {
   string label = "Line " + name;
   ObjectDelete(label);
   ObjectCreate(label, OBJ_TREND, 0, x1, y1, x2, y2, 0, 0);
   ObjectSet(label, OBJPROP_RAY, ly);//True
   ObjectSet(label, OBJPROP_WIDTH, 2);
   ObjectSet(label, OBJPROP_COLOR, col);
   ObjectSet(label, OBJPROP_STYLE, STYLE_SOLID);
  }
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
double GetLots(int Loss=1000){
// -----
 double Free =AccountFreeMargin();
 double LotVal =MarketInfo(Symbol(),MODE_TICKVALUE);
 double Min_Lot =MarketInfo(Symbol(),MODE_MINLOT);
 double Max_Lot =MarketInfo(Symbol(),MODE_MAXLOT);
 double Step =MarketInfo(Symbol(),MODE_LOTSTEP);
 double Lot =MathFloor((Free*MaxRisk/100)/(Loss*LotVal)/Step)*Step;
 if(Lot<Min_Lot) Lot=Min_Lot;
 if(Lot>Max_Lot) Lot=Max_Lot;
 if(!MM)Lot=Lots;
// -----
 return(Lot);
}
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
void ModificacionsOrders(int mn=0){
//+----
  double sl,ur;
  int cnt=OrdersTotal();
  for (int i=0; i<cnt; i++) {
   if (!(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))) continue; 
    if (OrderSymbol() != symbol) continue;
    if (OrderMagicNumber() != mn) continue;
//+----
   if(OrderType()==OP_BUY){
    ur=OrderOpenPrice()+ND((OrderTakeProfit()-OrderOpenPrice())*FiboTral);
     if(OrderOpenPrice()>OrderStopLoss() && ND(ur)<ND(Bid)){
        ModifyOrder(OrderOpenPrice(),ND(OrderOpenPrice()+1*po),OrderTakeProfit(),OrderExpiration());
     }
  } 
//+----
   if(OrderType()==OP_SELL){
   ur=OrderOpenPrice()-ND((OrderOpenPrice()-OrderTakeProfit())*FiboTral);
     if(OrderOpenPrice()<OrderStopLoss() && ND(ur)>ND(Ask)){ 
        ModifyOrder(OrderOpenPrice(),ND(OrderOpenPrice()-1*po),OrderTakeProfit(),OrderExpiration());
     } 
   }
 }
//+----
  return(0);
}
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
string Dayof(){
string dd;
  switch(DayOfWeek()){
    case 1: dd="�����������"; break;
    case 2: dd="�������";     break;
    case 3: dd="�����";       break;
    case 4: dd="�������";     break;
    case 5: dd="�������";     break;
    case 6: dd="�������";     break;
    case 7: dd="�����������"; break;
  }
  return(dd);
}
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
int OrdersCount(int type, int mn)
{
//+----
  int orders=0;
  int cnt=OrdersTotal();
  for (int i=0; i<cnt; i++) {
    if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
    if (OrderSymbol()!=Symbol()) continue;
    if (OrderMagicNumber()!=mn) continue;
    if (OrderType()==type||type<0) orders++;
  }
//+----
  return (orders);
}
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
void DeleteOrders(int op=-1, int mn=-1) {
  bool fd;
  int  i, it, k=OrdersTotal();
  for (i=k-1; i>=0; i--) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
        if (OrderSymbol()==Symbol() && OrderType()==op) {
          if (OrderMagicNumber()==mn) {
            for (it=1; it<=5; it++) {
              if (!IsTesting() && (!IsExpertEnabled() || IsStopped())) break;
              while (!IsTradeAllowed()) Sleep(5000);
              fd=OrderDelete(OrderTicket(), 0);
              if (fd) { PlaySound("ok.wav"); break;
              Sleep(1000*5);
            }
          }
        }
      }
    }
  }
  return(0);
}
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
string IIcm(int com){
 if(com==1)return("��:"); else return("���:");
}
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
string shet(){
  string s;
  if (IsDemo())s="����"; else s="����";
  return(s);
}
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
bool ExistOrders(string sy="", int op=-1, int mn=-1, datetime ot=0) {
  int i, k=OrdersTotal(), ty;
// ----
  if (sy=="0") sy=Symbol();
  for (i=0; i<k; i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      ty=OrderType();
      if (ty>1 && ty<6) {
        if ((OrderSymbol()==sy || sy=="") && (op<0 || ty==op)) {
          if (mn<0 || OrderMagicNumber()==mn) {
            if (ot<=OrderOpenTime()) return(True);
          }
        }
      }
    }
  }
  return(False);
}
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
void Message(string m) {
  if (StringLen(m)>0) 
  Print(m);
  WriteLineInFile(ExpertName+" ������",m);
}
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
color IIFc(bool condition, color ifTrue, color ifFalse) {
  if (condition) return(ifTrue); else return(ifFalse);
}
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
string GetNameTF(int TimeFrame=0) {
  if (TimeFrame==0) TimeFrame=Period();
  switch (TimeFrame) {
    case PERIOD_M1:  return("M1");
    case PERIOD_M5:  return("M5");
    case PERIOD_M15: return("M15");
    case PERIOD_M30: return("M30");
    case PERIOD_H1:  return("H1");
    case PERIOD_H4:  return("H4");
    case PERIOD_D1:  return("Daily");
    case PERIOD_W1:  return("Weekly");
    case PERIOD_MN1: return("Monthly");
    default:         return("Unknown Period");
  }
}
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
string GetNameOP(int op) {
  switch (op) {
    case OP_BUY      : return("Buy");
    case OP_SELL     : return("Sell");
    case OP_BUYLIMIT : return("Buy Limit");
    case OP_SELLLIMIT: return("Sell Limit");
    case OP_BUYSTOP  : return("Buy Stop");
    case OP_SELLSTOP : return("Sell Stop");
    default          : return("Unknown Operation");
  }
}
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+      
int SetOrder(string sy, int op, double ll, double pp,
              double sl=0, double tp=0, int mn=0, string co="", datetime ex=0) {
  color    cl=IIFc(op==OP_BUYLIMIT || op==OP_BUYSTOP, LightBlue, LightCoral);
  datetime ot;
  double   pa, pb, mp;
  int      err, it, ticket, msl, sp;
// ----
  if (sy=="" || sy=="0") sy=Symbol();
  msl=MarketInfo(sy, MODE_STOPLEVEL);
  if (co=="") co=WindowExpertName()+" "+GetNameTF(Period());
  if (ex>0 && ex<TimeCurrent()) ex=0;
  for (it=1; it<=5; it++) {
    if (!IsTesting() && (!IsExpertEnabled() || IsStopped())) {
      Print("SetOrder(): ��������� ������ �������");
      Message("SetOrder(): ��������� ������ �������");
      break;
    }
    while (!IsTradeAllowed()) Sleep(5000);
    RefreshRates();
    ot=TimeCurrent();
    sp=MarketInfo(sy, MODE_SPREAD);
    pp=NormalizeDouble(pp, Digits);
    sl=NormalizeDouble(sl, Digits);
    tp=NormalizeDouble(tp, Digits);
    ticket=OrderSend(sy, op, ll, pp, sp, sl, tp, co, mn, ex, cl);
    if (ticket>0) { PlaySound("ok.wav"); break;
    } else {
      err=GetLastError();
      if (err==128 || err==142 || err==143) {
        Sleep(1000*66);
        if (ExistOrders(sy, op, mn, ot)) { PlaySound("ok.wav"); break;
        }
        Print("Error(",err,") set order: ",error(err),", try ",it);
        Message("Error("+err+") set order: "+error(err)+", try "+it);
        continue;
      }
      PlaySound("timeout.wav");
      mp=MarketInfo(sy, MODE_POINT);
      pa=MarketInfo(sy, MODE_ASK);
      pb=MarketInfo(sy, MODE_BID);
      if (pa==0 && pb==0) Message("SetOrder(): ��������� � ������ ����� ������� ������� "+sy);
      Print("Error(",err,") set order: ",error(err),", try ",it);
      Message("Error("+err+") set order: "+error(err)+", try "+it);
      Print("Ask=",pa,"  Bid=",pb,"  sy=",sy,"  ll=",ll,"  op=",GetNameOP(op),
            "  pp=",pp,"  sl=",sl,"  tp=",tp,"  mn=",mn);
      Message("Ask="+DT(pa)+"  Bid="+DT(pb)+"  sy="+sy+"  ll="+ll+"  op="+GetNameOP(op)+
              "  pp="+DT(pp)+"  sl="+DT(sl)+"  tp="+DT(tp)+"  mn="+mn);      
      // ���������� ������ ���������
      if (err==2 || err==64 || err==65 || err==133) {
        EaDisabled=True; break;
      }
      // ���������� �����
      if (err==4 || err==131 || err==132) {
        Sleep(1000*300); break;
      }
      // ������� ������ ������� (8) ��� ������� ����� �������� (141)
      if (err==8 || err==141) Sleep(1000*100);
      if (err==139 || err==140 || err==148) break;
      // �������� ������������ ���������� ��������
      if (err==146) while (IsTradeContextBusy()) Sleep(1000*11);
      // ��������� ���� ���������
      if (err==147) {
        ex=0; continue;
      }
      if (err!=135 && err!=138) Sleep(1000*7.7);
    }
  }
  return(ticket);
}
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
int Tradetime(bool exptime, int OpenHour, int  CloseHour){
// ---
  int day[]; 
  int i=0, np;
  int Trading=0;
  string st, tmp=TradeDay;
  ArrayResize(day, 0);
  while (StringLen(tmp)>0) {
    np=StringFind(tmp, ",");
    if (np<0) {
      st=tmp;
      tmp="";
    } else {
      st=StringSubstr(tmp, 0, np);
      tmp=StringSubstr(tmp, np+1);
    }
    i++;
    ArrayResize(day, i);
    day[i-1]=StrToInteger(st);
  }
// ---
  int TradingTime=0;
  for (int f=0; f<7; f++) {
  if (DayOfWeek()==day[f])Trading=1;
  }
  if (OpenHour>CloseHour){
  if (Hour()<=CloseHour || Hour()>=OpenHour)TradingTime=1;
  }
  if (OpenHour<CloseHour){
  if (Hour()>=OpenHour && Hour()<=CloseHour)TradingTime=1;
  }
  if (OpenHour==CloseHour){
  if (Hour()==OpenHour)TradingTime=1;
  }
  if (DayOfWeek()==1 && Hour() < HourStart)TradingTime=0;
  if (DayOfWeek()==5 && Hour() >= HourStops)TradingTime=0; 
  if (Trading!=1)TradingTime=0;
  if (exptime!=true)TradingTime=1;
// ---
  return(TradingTime); 
}
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
void ClosePosBySelect(int type, int mn=-1) {
  bool   fc;
  color  clClose;
  double ll, pa, pb, pp;
  int    sp, i, k=OrdersTotal();
  int    dg=MarketInfo(OrderSymbol(), MODE_DIGITS), err, it;

  for (i=k-1; i>=0; i--) {
  if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
  if (OrderType()==type && OrderMagicNumber()==mn) {
    for (it=1; it<=5; it++) {
      if (!IsTesting() && (!IsExpertEnabled() || IsStopped())) break;
      while (!IsTradeAllowed()) Sleep(5000);
      RefreshRates();
      pa=MarketInfo(OrderSymbol(), MODE_ASK);
      pb=MarketInfo(OrderSymbol(), MODE_BID);
      sp=MarketInfo(OrderSymbol(), MODE_SPREAD);
      if (OrderType()==OP_BUY) {
        pp=pb; clClose=Blue;
      } else {
        pp=pa; clClose=Red;
      }
      ll=OrderLots();
      pp=NormalizeDouble(pp, dg);
      fc=OrderClose(OrderTicket(), ll, pp, sp, clClose);
      if (fc) { PlaySound("ok.wav"); break;
      } else {
        err=GetLastError();
        PlaySound("timeout.wav");
        if (err==146) while (IsTradeContextBusy()) Sleep(1000*11);
        Print("Error(",err,") Close ",GetNameOP(OrderType())," ",
              error(err),", try ",it);
        Message("Error("+err+") Close "+GetNameOP(OrderType())+" "+
                error(err)+", try "+it);
        Print(OrderTicket(),"  Ask=",pa,"  Bid=",pb,"  pp=",pp);
        Message(OrderTicket()+"  Ask="+DT(pa)+"  Bid="+DT(pb)+"  pp="+DT(pp));
        Print("sy=",OrderSymbol(),"  ll=",ll,"  sl=",DT(OrderStopLoss()),
              "  tp=",DT(OrderTakeProfit()),"  mn=",OrderMagicNumber());
        Message("sy="+OrderSymbol()+"  ll="+ll+"  sl="+DT(OrderStopLoss())+
                "  tp="+DT(OrderTakeProfit())+"  mn="+OrderMagicNumber());   
        Sleep(1000*5);
          }
        }
      }
    }
  }
}
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
void ModifyOrder(double pp=-1, double sl=0, double tp=0, datetime ex=0) {
  bool   fm;
  color  cl=IIFc(OrderType()==OP_BUY
              || OrderType()==OP_BUYLIMIT
              || OrderType()==OP_BUYSTOP, Blue, Red);
  double op, pa, pb, os, ot;
  int    dg=MarketInfo(OrderSymbol(), MODE_DIGITS), er, it;

  if (pp<=0) pp=OrderOpenPrice();
  if (sl<0 ) sl=OrderStopLoss();
  if (tp<0 ) tp=OrderTakeProfit();
  
  pp=NormalizeDouble(pp, dg);
  sl=NormalizeDouble(sl, dg);
  tp=NormalizeDouble(tp, dg);
  op=NormalizeDouble(OrderOpenPrice() , dg);
  os=NormalizeDouble(OrderStopLoss()  , dg);
  ot=NormalizeDouble(OrderTakeProfit(), dg);

  if (pp!=op || sl!=os || tp!=ot) {
    for (it=1; it<=5; it++) {
      if (!IsTesting() && (!IsExpertEnabled() || IsStopped())) break;
      while (!IsTradeAllowed()) Sleep(5000);
      RefreshRates();
      fm=OrderModify(OrderTicket(), pp, sl, tp, ex, cl);
      if (fm) { PlaySound("Stops.wav"); break;
      } else {
        er=GetLastError();
        PlaySound("timeout.wav");
        pa=MarketInfo(OrderSymbol(), MODE_ASK);
        pb=MarketInfo(OrderSymbol(), MODE_BID);
        Print("Error(",er,") modifying order: ",error(er),", try ",it);
        Message("Error("+er+") modifying order: "+error(er)+", try "+it);
        Print("Ask=",DT(pa),"  Bid=",DT(pb),"  sy=",OrderSymbol(),
              "  op="+GetNameOP(OrderType()),"  pp=",DT(pp),"  sl=",DT(sl),"  tp=",DT(tp));
        Message("Ask="+DT(pa)+"  Bid="+DT(pb)+"  sy="+OrderSymbol()+
                "  op="+GetNameOP(OrderType())+"  pp="+DT(pp)+"  sl="+DT(sl)+"  tp="+DT(tp));      
        Sleep(1000*10);
      }
    }
  }
}
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
double ND(double np) {
  double pp, ts=MarketInfo(Symbol(), MODE_TICKSIZE);
  int di=MarketInfo(Symbol(), MODE_DIGITS);
  if (ts>0) pp=NormalizeDouble(np/ts, 0)*ts;
  else {if (di>0) pp=NormalizeDouble(np*di, 0)/di; else pp=np;
  }
  return(pp);
}
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
void WriteLineInFile(string FileName,string Line)
  {
   int er;
   int HFile=FileOpen(FileName,FILE_READ|FILE_WRITE," ");
   if(HFile>0)
     {
      FileSeek(HFile,0,SEEK_END);
      FileWrite(HFile,Line);
      FileFlush(HFile);
      FileClose(HFile);
     }else{ er=GetLastError();
      Print("Error: "+er+"  "+error(er));
    }
   return;
  }
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
string error(int eer)
{
   string er;
   switch(eer)
     {
      //---- 
      case 0:
      case 1:   er="��� ������, �� ��������� ����������";                         break;
      case 2:   er="����� ������";                                                break;
      case 3:   er="������������ ���������";                                      break;
      case 4:   er="�������� ������ �����";                                       break;
      case 5:   er="������ ������ ����������� ���������";                         break;
      case 6:   er="��� ����� � �������� ��������";                               break;
      case 7:   er="������������ ����";                                           break;
      case 8:   er="������� ������ �������";                                      break;
      case 9:   er="������������ �������� ���������� ���������������� �������";   break;
      case 64:  er="���� ������������";                                           break;
      case 65:  er="������������ ����� �����";                                    break;
      case 128: er="����� ���� �������� ���������� ������";                       break;
      case 129: er="������������ ����";                                           break;
      case 130: er="������������ �����";                                          break;
      case 131: er="������������ �����";                                          break;
      case 132: er="����� ������";                                                break;
      case 133: er="�������� ���������";                                          break;
      case 134: er="������������ ����� ��� ���������� ��������";                  break;
      case 135: er="���� ����������";                                             break;
      case 136: er="��� ���";                                                     break;
      case 137: er="������ �����";                                                break;
      case 138: er="����� ���� - ������";                                         break;
      case 139: er="����� ������������ � ��� ��������������";                     break;
      case 140: er="��������� ������ �������";                                    break;
      case 141: er="������� ����� ��������";                                      break;
      case 145: er="����������� ���������, ��� ��� ����� ������� ������ � �����"; break;
      case 146: er="���������� �������� ������";                                  break;
      case 147: er="������������� ���� ��������� ������ ��������� ��������";      break;
      case 148: er="���������� �������� � ���������� ������� �������� ������� ";  break;
      //---- 
      case 4000: er="��� ������";                                                 break;
      case 4001: er="������������ ��������� �������";                             break;
      case 4002: er="������ ������� - ��� ���������";                             break;
      case 4003: er="��� ������ ��� ����� �������";                               break;
      case 4004: er="������������ ����� ����� ������������ ������";               break;
      case 4005: er="�� ����� ��� ������ ��� �������� ����������";                break;
      case 4006: er="��� ������ ��� ���������� ���������";                        break;
      case 4007: er="��� ������ ��� ��������� ������";                            break;
      case 4008: er="�������������������� ������";                                break;
      case 4009: er="�������������������� ������ � �������";                      break;
      case 4010: er="��� ������ ��� ���������� �������";                          break;
      case 4011: er="������� ������� ������";                                     break;
      case 4012: er="������� �� ������� �� ����";                                 break;
      case 4013: er="������� �� ����";                                            break;
      case 4014: er="����������� �������";                                        break;
      case 4015: er="������������ �������";                                       break;
      case 4016: er="�������������������� ������";                                break;
      case 4017: er="������ DLL �� ���������";                                    break;
      case 4018: er="���������� ��������� ����������";                            break;
      case 4019: er="���������� ������� �������";                                 break;
      case 4020: er="e������ ������� ������������ ������� �� ���������";          break;
      case 4021: er="������������ ������ ��� ������, ������������ �� �������";    break;
      case 4022: er="������� ������";                                             break;
      case 4050: er="������������ ���������� ���������� �������";                 break;
      case 4051: er="������������ �������� ��������� �������";                    break;
      case 4052: er="���������� ������ ��������� �������";                        break;
      case 4053: er="������ �������";                                             break;
      case 4054: er="������������ ������������� �������-���������";               break;
      case 4055: er="������ ����������������� ����������";                        break;
      case 4056: er="������� ������������";                                       break;
      case 4057: er="������ ��������� ����������� ����������";                    break;
      case 4058: er="���������� ���������� �� ����������";                        break;
      case 4059: er="������� �� ��������� � �������� ������";                     break;
      case 4060: er="������� �� ������������";                                    break;
      case 4061: er="������ �������� �����";                                      break;
      case 4062: er="��������� �������� ���� string";                             break;
      case 4063: er="��������� �������� ���� integer";                            break;
      case 4064: er="��������� �������� ���� double";                             break;
      case 4065: er="� �������� ��������� ��������� ������";                      break;
      case 4066: er="����������� ������������ ������ � ��������� ����������";     break;
      case 4067: er="������ ��� ���������� �������� ��������";                    break;
      case 4099: er="����� �����";                                                break;
      case 4100: er="������ ��� ������ � ������";                                 break;
      case 4101: er="������������ ��� �����";                                     break;
      case 4102: er="������� ����� �������� ������";                              break;
      case 4103: er="���������� ������� ����";                                    break;
      case 4104: er="������������� ����� ������� � �����";                        break;
      case 4105: er="�� ���� ����� �� ������";                                    break;
      case 4106: er="����������� ������";                                         break;
      case 4107: er="������������ �������� ���� ��� �������� �������";            break;
      case 4108: er="�������� ����� ������";                                      break;
      case 4109: er="�������� �� ���������";                                      break;
      case 4110: er="������� ������� �� ���������";                               break;
      case 4111: er="�������� ������� �� ���������";                              break;
      case 4200: er="������ ��� ����������";                                      break;
      case 4201: er="��������� ����������� �������� �������";                     break;
      case 4202: er="������ �� ����������";                                       break;
      case 4203: er="����������� ��� �������";                                    break;
      case 4204: er="��� ����� �������";                                          break;
      case 4205: er="������ ��������� �������";                                   break;
      case 4206: er="�� ������� ��������� �������";                               break;
      case 4207: er="������ ��� ������ � ��������";                               break;
      default:   er="unknown error";
     }
  return(er);
}
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
string DT(double s) { return(DoubleToStr(s,Digits)); }
//+------------------------------------------------------------------------------+
//|       ����� : ������   - ��� ���� -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+




