//+-----------------------------------------------------------------+
//|                                                  BEST.mq4 |
//+-----------------------------------------------------------------+
//| HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH |
//| H\    \               http://wsforex.ru/               /    / H |
//| H )----)----------------------------------------------(----(  H |
//| H/    /   Пишу торговые системы на заказ: wsforex.ru   \    \ H |
//| HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH |
//+-----------------------------------------------------------------+

#property copyright "wsforex@list.ru"
#property link      "http://wsforex.ru/"
//+-----------------------------------------------------------------+
//| Разработка : Сергей.Ж  - мой сайт -  "http://wsforex.ru/"       |
//+-----------------------------------------------------------------+
extern bool    ExpertTime      = True; // Использовать функцию работы по времени True-вкл False-выкл
extern string  TradeDay        = "1,2,3,4,5"; 
extern int     HourStart       = 0;     // Старт в понедельник 
extern int     HourStops       = 19;    // Стоп в пятницу
extern int     Ea.Start        = 0;     // Старт советника
extern int     Ea.Stop         = 23;    // Стоп Советника
// -----
extern bool    MM              = False;
extern double  MaxRisk         = 0.7;
extern double  Lots            = 0.01;
extern int     Otstup          = 0;
extern int     Life_time       = 1440;
extern int     MuStopLevel     = 100;
extern int     MuSpread        = 30;
extern int     MagicNumber     = 777;
extern string  Блок   ="  Настройки флэта  "; 
extern int     StdDevPer       = 37;
extern int     FletBars        = 2;
extern int     CanalMin        = 610;
extern int     CanalMax        = 1860;
//+-----------------------------------------------------------------+
//| Разработка : Сергей.Ж  - мой сайт -  "http://wsforex.ru/"       |
//+-----------------------------------------------------------------+
extern bool    Trailing   = True;
extern double  FiboTral   = 0.873;
//+-----------------------------------------------------------------+
//| Разработка : Сергей.Ж  - мой сайт -  "http://wsforex.ru/"       |
//+-----------------------------------------------------------------+
int tik, exp, dg, lv, sp;
double pa, pb, po;
string Times,  symbol;
string com = "";
string ExpertName;
bool flagup, flagdw, EaDisabled = False;
//+-----------------------------------------------------------------+
//| Разработка : Сергей.Ж  - мой сайт -  "http://wsforex.ru/"       |
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
   if (IsExpertEnabled()) Message("\nСоветник установлен и будет запущен следующим тиком");
   else Message("\nВнимание! отжата кнопка на вкладке советники");
   }
//----
  return(0);
}
//+------------------------------------------------------------------------------+
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
void start(){
// -----
  Times = "Время GMT - "+ TimeToStr(TimeCurrent()-3600, TIME_MINUTES|TIME_SECONDS);
  pb = MarketInfo(symbol,MODE_BID);
  pa = MarketInfo(symbol,MODE_ASK); 
  dg = MarketInfo(symbol,MODE_DIGITS);
  po = MarketInfo(symbol,MODE_POINT);
  lv = MarketInfo(symbol,MODE_STOPLEVEL)+MarketInfo(symbol,MODE_SPREAD);
// -----           
  Comment("\nСоветник "+ExpertName+" весь в работе: - ",IIcm(Tradetime(ExpertTime, Ea.Start, Ea.Stop)==1 && EaDisabled==False),
          "\nДень: - ",Dayof(),
          "\nТорговый счёт: - ",shet(),
          "\nCompany: - ",AccountCompany(),
          "\nEquity: - ",AccountEquity(),
          "\nStop Out: - ",AccountStopoutLevel(),
          "\nВремя по GMT: - " +Times,
          "\nSpread: - ",MarketInfo(symbol,MODE_SPREAD),
          "\nStopLevel: - ",lv,
          "\nПлечо: - ",AccountLeverage()
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
// ---- У С Т А Н О В К А - О Р Д Е Р А -----------------------------------------+
 if(ChCan>=CanalMin *po && ChCan<CanalMax*po && ress>=FletBars && Tradetime(ExpertTime, Ea.Start, Ea.Stop)==1 && EaDisabled==False){
 int Loss, Profit, stops=0;
 double lot, op, sl, tp;
 //---
    int orders=OrdersHistoryTotal();
      for (int i = orders - 1; i >= 0; i--) {
         if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) == FALSE) {
            Print("Ошибка в истории!");
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
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
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
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
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
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
double stddev(int i=0){
  return(iStdDev(Symbol(),0,StdDevPer,0,MODE_SMMA,PRICE_MEDIAN,i));
}
//+------------------------------------------------------------------------------+
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
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
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
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
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
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
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
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
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
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
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
string Dayof(){
string dd;
  switch(DayOfWeek()){
    case 1: dd="Понедельник"; break;
    case 2: dd="Вторник";     break;
    case 3: dd="Среда";       break;
    case 4: dd="Четверг";     break;
    case 5: dd="Пятница";     break;
    case 6: dd="Суббота";     break;
    case 7: dd="Воскресенье"; break;
  }
  return(dd);
}
//+------------------------------------------------------------------------------+
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
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
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
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
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
string IIcm(int com){
 if(com==1)return("да:"); else return("нет:");
}
//+------------------------------------------------------------------------------+
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
string shet(){
  string s;
  if (IsDemo())s="Демо"; else s="Реал";
  return(s);
}
//+------------------------------------------------------------------------------+
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
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
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
void Message(string m) {
  if (StringLen(m)>0) 
  Print(m);
  WriteLineInFile(ExpertName+" Ошибки",m);
}
//+------------------------------------------------------------------------------+
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
color IIFc(bool condition, color ifTrue, color ifFalse) {
  if (condition) return(ifTrue); else return(ifFalse);
}
//+------------------------------------------------------------------------------+
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
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
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
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
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
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
      Print("SetOrder(): Остановка работы функции");
      Message("SetOrder(): Остановка работы функции");
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
      if (pa==0 && pb==0) Message("SetOrder(): Проверьте в обзоре рынка наличие символа "+sy);
      Print("Error(",err,") set order: ",error(err),", try ",it);
      Message("Error("+err+") set order: "+error(err)+", try "+it);
      Print("Ask=",pa,"  Bid=",pb,"  sy=",sy,"  ll=",ll,"  op=",GetNameOP(op),
            "  pp=",pp,"  sl=",sl,"  tp=",tp,"  mn=",mn);
      Message("Ask="+DT(pa)+"  Bid="+DT(pb)+"  sy="+sy+"  ll="+ll+"  op="+GetNameOP(op)+
              "  pp="+DT(pp)+"  sl="+DT(sl)+"  tp="+DT(tp)+"  mn="+mn);      
      // Блокировка работы советника
      if (err==2 || err==64 || err==65 || err==133) {
        EaDisabled=True; break;
      }
      // Длительная пауза
      if (err==4 || err==131 || err==132) {
        Sleep(1000*300); break;
      }
      // Слишком частые запросы (8) или слишком много запросов (141)
      if (err==8 || err==141) Sleep(1000*100);
      if (err==139 || err==140 || err==148) break;
      // Ожидание освобождения подсистемы торговли
      if (err==146) while (IsTradeContextBusy()) Sleep(1000*11);
      // Обнуление даты истечения
      if (err==147) {
        ex=0; continue;
      }
      if (err!=135 && err!=138) Sleep(1000*7.7);
    }
  }
  return(ticket);
}
//+------------------------------------------------------------------------------+
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
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
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
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
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
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
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
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
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
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
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
string error(int eer)
{
   string er;
   switch(eer)
     {
      //---- 
      case 0:
      case 1:   er="Нет ошибки, но результат неизвестен";                         break;
      case 2:   er="Общая ошибка";                                                break;
      case 3:   er="Неправильные параметры";                                      break;
      case 4:   er="Торговый сервер занят";                                       break;
      case 5:   er="Старая версия клиентского терминала";                         break;
      case 6:   er="Нет связи с торговым сервером";                               break;
      case 7:   er="Недостаточно прав";                                           break;
      case 8:   er="Слишком частые запросы";                                      break;
      case 9:   er="Недопустимая операция нарушающая функционирование сервера";   break;
      case 64:  er="Счет заблокирован";                                           break;
      case 65:  er="Неправильный номер счета";                                    break;
      case 128: er="Истек срок ожидания совершения сделки";                       break;
      case 129: er="Неправильная цена";                                           break;
      case 130: er="Неправильные стопы";                                          break;
      case 131: er="Неправильный объем";                                          break;
      case 132: er="Рынок закрыт";                                                break;
      case 133: er="Торговля запрещена";                                          break;
      case 134: er="Недостаточно денег для совершения операции";                  break;
      case 135: er="Цена изменилась";                                             break;
      case 136: er="Нет цен";                                                     break;
      case 137: er="Брокер занят";                                                break;
      case 138: er="Новые цены - Реквот";                                         break;
      case 139: er="Ордер заблокирован и уже обрабатывается";                     break;
      case 140: er="Разрешена только покупка";                                    break;
      case 141: er="Слишком много запросов";                                      break;
      case 145: er="Модификация запрещена, так как ордер слишком близок к рынку"; break;
      case 146: er="Подсистема торговли занята";                                  break;
      case 147: er="Использование даты истечения ордера запрещено брокером";      break;
      case 148: er="Количество открытых и отложенных ордеров достигло предела ";  break;
      //---- 
      case 4000: er="Нет ошибки";                                                 break;
      case 4001: er="Неправильный указатель функции";                             break;
      case 4002: er="Индекс массива - вне диапазона";                             break;
      case 4003: er="Нет памяти для стека функций";                               break;
      case 4004: er="Переполнение стека после рекурсивного вызова";               break;
      case 4005: er="На стеке нет памяти для передачи параметров";                break;
      case 4006: er="Нет памяти для строкового параметра";                        break;
      case 4007: er="Нет памяти для временной строки";                            break;
      case 4008: er="Неинициализированная строка";                                break;
      case 4009: er="Неинициализированная строка в массиве";                      break;
      case 4010: er="Нет памяти для строкового массива";                          break;
      case 4011: er="Слишком длинная строка";                                     break;
      case 4012: er="Остаток от деления на ноль";                                 break;
      case 4013: er="Деление на ноль";                                            break;
      case 4014: er="Неизвестная команда";                                        break;
      case 4015: er="Неправильный переход";                                       break;
      case 4016: er="Неинициализированный массив";                                break;
      case 4017: er="Вызовы DLL не разрешены";                                    break;
      case 4018: er="Невозможно загрузить библиотеку";                            break;
      case 4019: er="Невозможно вызвать функцию";                                 break;
      case 4020: er="eВызовы внешних библиотечных функций не разрешены";          break;
      case 4021: er="Недостаточно памяти для строки, возвращаемой из функции";    break;
      case 4022: er="Система занята";                                             break;
      case 4050: er="Неправильное количество параметров функции";                 break;
      case 4051: er="Недопустимое значение параметра функции";                    break;
      case 4052: er="Внутренняя ошибка строковой функции";                        break;
      case 4053: er="Ошибка массива";                                             break;
      case 4054: er="Неправильное использование массива-таймсерии";               break;
      case 4055: er="Ошибка пользовательского индикатора";                        break;
      case 4056: er="Массивы несовместимы";                                       break;
      case 4057: er="Ошибка обработки глобальныех переменных";                    break;
      case 4058: er="Глобальная переменная не обнаружена";                        break;
      case 4059: er="Функция не разрешена в тестовом режиме";                     break;
      case 4060: er="Функция не подтверждена";                                    break;
      case 4061: er="Ошибка отправки почты";                                      break;
      case 4062: er="Ожидается параметр типа string";                             break;
      case 4063: er="Ожидается параметр типа integer";                            break;
      case 4064: er="Ожидается параметр типа double";                             break;
      case 4065: er="В качестве параметра ожидается массив";                      break;
      case 4066: er="Запрошенные исторические данные в состоянии обновления";     break;
      case 4067: er="Ошибка при выполнении торговой операции";                    break;
      case 4099: er="Конец файла";                                                break;
      case 4100: er="Ошибка при работе с файлом";                                 break;
      case 4101: er="Неправильное имя файла";                                     break;
      case 4102: er="Слишком много открытых файлов";                              break;
      case 4103: er="Невозможно открыть файл";                                    break;
      case 4104: er="Несовместимый режим доступа к файлу";                        break;
      case 4105: er="Ни один ордер не выбран";                                    break;
      case 4106: er="Неизвестный символ";                                         break;
      case 4107: er="Неправильный параметр цены для торговой функции";            break;
      case 4108: er="Неверный номер тикета";                                      break;
      case 4109: er="Торговля не разрешена";                                      break;
      case 4110: er="Длинные позиции не разрешены";                               break;
      case 4111: er="Короткие позиции не разрешены";                              break;
      case 4200: er="Объект уже существует";                                      break;
      case 4201: er="Запрошено неизвестное свойство объекта";                     break;
      case 4202: er="Объект не существует";                                       break;
      case 4203: er="Неизвестный тип объекта";                                    break;
      case 4204: er="Нет имени объекта";                                          break;
      case 4205: er="Ошибка координат объекта";                                   break;
      case 4206: er="Не найдено указанное подокно";                               break;
      case 4207: er="Ошибка при работе с объектом";                               break;
      default:   er="unknown error";
     }
  return(er);
}
//+------------------------------------------------------------------------------+
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+
string DT(double s) { return(DoubleToStr(s,Digits)); }
//+------------------------------------------------------------------------------+
//|       Автор : Сергей   - мой сайт -  "http://wsforex.ru/"                    |
//+------------------------------------------------------------------------------+




