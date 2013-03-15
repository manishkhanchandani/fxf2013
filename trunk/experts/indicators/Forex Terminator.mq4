
int gi_76 = 0;
int gi_80 = 1;
extern double Lots = 0.1;
extern bool RiskManagement = TRUE;
extern double Risk = 7.0;
bool gi_104 = FALSE;
double gd_108 = 1.5;
double gd_116 = 0.0;
bool gi_124 = FALSE;
int gi_128 = 5;
bool gi_132 = FALSE;
int gi_136 = 10;
extern int StopLoss = 100;
extern int TakeProfit = 250;
extern int TrailingStop = 0;
int gi_152 = 1;
int gi_156 = 0;
extern bool Reverse = FALSE;
extern bool AddPositions = TRUE;
extern int MaxOrders = 5;
bool gi_172 = TRUE;
int g_period_176 = 20;
int g_ma_method_180 = MODE_EMA;
int g_applied_price_184 = PRICE_CLOSE;
extern bool TimeFilter = TRUE;
extern int StartHour = 8;
extern int EndHour = 21;
extern int Magic = 3577;
int g_slippage_204 = 3;
int gi_unused_208 = 0;
double gd_212 = 0.0;
int gi_unused_220 = 0;

int start() {
   string ls_28;
   double l_ima_36;
   string ls_44;
   string ls_52;
   double l_icustom_60;
   double l_icustom_68;
   double l_icustom_76;
   double l_icustom_84;
   string ls_92;
   string ls_100;
   int l_pos_0 = 0;
   int li_4 = 1;
   double ld_8 = 0;
   double ld_16 = 0;
   ld_8 = 0;
   ld_16 = 0;
   if (CntO(OP_BUY, Magic) > 0) gi_unused_208 = 1;
   if (CntO(OP_SELL, Magic) > 0) gi_unused_208 = -1;
   for (int li_24 = 1; li_24 <= li_4; li_24++) {
      ls_28 = "false";
      if (TimeFilter)
         if (!(Hour() >= StartHour && Hour() <= EndHour)) ls_28 = "true";
      l_ima_36 = iMA(Symbol(), 0, g_period_176, 0, g_ma_method_180, g_applied_price_184, li_24);
      ls_44 = "false";
      ls_52 = "false";
      if (gi_172 == FALSE || (gi_172 && Bid > l_ima_36)) ls_44 = "true";
      if (gi_172 == FALSE || (gi_172 && Ask < l_ima_36)) ls_52 = "true";
      l_icustom_60 = iCustom(Symbol(), 0, "SuperSignal", gi_76, gi_80, 0, li_24 + 1);
      l_icustom_68 = iCustom(Symbol(), 0, "SuperSignal", gi_76, gi_80, 0, li_24);
      l_icustom_76 = iCustom(Symbol(), 0, "SuperSignal", gi_76, gi_80, 1, li_24 + 1);
      l_icustom_84 = iCustom(Symbol(), 0, "SuperSignal", gi_76, gi_80, 1, li_24);
      ls_92 = "false";
      ls_100 = "false";
      if (l_icustom_68 > l_icustom_84) ls_92 = "true";
      if (l_icustom_84 > l_icustom_68) ls_100 = "true";
      if (ls_44 == "true" && ls_92 == "true" && ls_28 == "false") {
         if (Reverse) {
            ld_16 = 1;
            break;
         }
         ld_8 = 1;
         break;
      }
      if (ls_52 == "true" && ls_100 == "true" && ls_28 == "false") {
         if (Reverse) {
            ld_8 = 1;
            break;
         }
         ld_16 = 1;
         break;
      }
   }
   bool l_bool_108 = RiskManagement;
   if (l_bool_108) {
      if (Risk < 0.1 || Risk > 100.0) {
         Comment("Invalid Risk Value.");
         return (0);
      }
      Lots = MathFloor(100.0 * (AccountFreeMargin() * AccountLeverage() * Risk * Point) / (Ask * MarketInfo(Symbol(), MODE_LOTSIZE) * MarketInfo(Symbol(), MODE_MINLOT))) * MarketInfo(Symbol(), MODE_MINLOT);
   }
   if (l_bool_108 == FALSE) {
   }
   if (gd_212 != 0.0 && gi_104 == TRUE) {
      if (gd_212 > AccountBalance()) Lots = gd_108 * Lots;
      else {
         if (gd_212 + gd_116 < AccountBalance()) Lots /= gd_108;
         else {
            if (gd_212 + gd_116 >= AccountBalance() && gd_212 <= AccountBalance()) {
            }
         }
      }
   }
   gd_212 = AccountBalance();
   int l_pos_112 = 0;
   int l_count_116 = 0;
   bool li_120 = FALSE;
   bool li_124 = FALSE;
   bool li_128 = FALSE;
   bool li_132 = FALSE;
   l_count_116 = 0;
   for (l_pos_112 = 0; l_pos_112 < OrdersTotal(); l_pos_112++) {
      OrderSelect(l_pos_112, SELECT_BY_POS, MODE_TRADES);
      if (OrderType() == OP_SELL || OrderType() == OP_BUY && OrderSymbol() == Symbol() && OrderMagicNumber() == Magic || Magic == 0) l_count_116++;
   }
   if (l_count_116 >= 1) {
      li_120 = FALSE;
      li_124 = FALSE;
   }
   li_124 = FALSE;
   li_120 = FALSE;
   li_132 = FALSE;
   li_128 = FALSE;
   int li_136 = StopLoss;
   int li_140 = TakeProfit;
   if (ld_16 > 0.0) {
      li_120 = TRUE;
      li_124 = FALSE;
   }
   if (ld_8 > 0.0) {
      li_124 = TRUE;
      li_120 = FALSE;
   }
   if (ld_16 > 0.0 || ls_28 == "true" || (gi_124 && (OrderOpenPrice() - Bid) / Point >= gi_128) || (gi_132 && (Ask - OrderOpenPrice()) / Point >= gi_136)) li_132 = TRUE;
   if (ld_8 > 0.0 || ls_28 == "true" || (gi_124 && (Ask - OrderOpenPrice()) / Point >= gi_128) || (gi_132 && (OrderOpenPrice() - Bid) / Point >= gi_136)) li_128 = TRUE;
   for (l_pos_112 = 0; l_pos_112 < OrdersTotal(); l_pos_112++) {
      OrderSelect(l_pos_112, SELECT_BY_POS, MODE_TRADES);
      if (OrderType() == OP_BUY && OrderSymbol() == Symbol() && OrderMagicNumber() == Magic || Magic == 0) {
         if (li_132 == TRUE) {
            OrderClose(OrderTicket(), OrderLots(), Bid, g_slippage_204, Red);
            return (0);
         }
      }
      if (OrderType() == OP_SELL && OrderSymbol() == Symbol() && OrderMagicNumber() == Magic || Magic == 0) {
         if (li_128 == TRUE) {
            OrderClose(OrderTicket(), OrderLots(), Ask, g_slippage_204, Red);
            return (0);
         }
      }
   }
   double l_price_144 = 0;
   double l_price_152 = 0;
   int l_ticket_160 = 0;
   if ((AddP() && AddPositions && l_count_116 <= MaxOrders) || (l_count_116 == 0 && !AddPositions)) {
      if (li_120 == FALSE && li_124 == FALSE) Comment("no order opened");
      if (li_120 == TRUE) {
         if (li_140 == 0) l_price_152 = 0;
         else l_price_152 = Bid - li_140 * Point;
         if (li_136 == 0) l_price_144 = 0;
         else l_price_144 = Bid + li_136 * Point;
         l_ticket_160 = OrderSend(Symbol(), OP_SELL, Lots, Bid, g_slippage_204, l_price_144, l_price_152, "The Forex Terminator", Magic, 0, Red);
         li_120 = FALSE;
         Comment("sell order opened", 
         "\n", "magic number : ", Magic);
         return (0);
      }
      if (li_124 == TRUE) {
         if (li_140 == 0) l_price_152 = 0;
         else l_price_152 = Ask + li_140 * Point;
         if (li_136 == 0) l_price_144 = 0;
         else l_price_144 = Ask - li_136 * Point;
         l_ticket_160 = OrderSend(Symbol(), OP_BUY, Lots, Ask, g_slippage_204, l_price_144, l_price_152, "The Forex Terminator", Magic, 0, Lime);
         li_124 = FALSE;
         Comment("buy order opened", 
         "\n", "magic number : ", Magic);
         return (0);
      }
   }
   for (l_pos_0 = 0; l_pos_0 < OrdersTotal(); l_pos_0++) {
      if (OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES))
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic || Magic == 0) TrP();
   }
   return (0);
}

int CntO(int a_cmd_0, int a_magic_4) {
   int l_count_8 = 0;
   for (int l_pos_12 = 0; l_pos_12 < OrdersTotal(); l_pos_12++) {
      OrderSelect(l_pos_12, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol())
         if (OrderType() == a_cmd_0 && OrderMagicNumber() == a_magic_4 || a_magic_4 == 0) l_count_8++;
   }
   return (l_count_8);
}

void TrP() {
   int li_0;
   double l_bid_4;
   double l_ask_12;
   int li_28;
   double l_point_20 = MarketInfo(OrderSymbol(), MODE_POINT);
   if (OrderType() == OP_BUY) {
      l_bid_4 = MarketInfo(OrderSymbol(), MODE_BID);
      li_0 = gi_156;
      if (li_0 > 0) {
         if (l_bid_4 - OrderOpenPrice() > li_0 * l_point_20)
            if (OrderStopLoss() - OrderOpenPrice() < 0.0) ModSL(OrderOpenPrice() + 0.0 * l_point_20);
      }
      li_28 = TrailingStop;
      if (li_28 > 0) {
         if (l_bid_4 - OrderOpenPrice() > li_28 * l_point_20) {
            if (OrderStopLoss() < l_bid_4 - (li_28 + gi_152 - 1) * l_point_20) {
               ModSL(l_bid_4 - li_28 * l_point_20);
               return;
            }
         }
      }
   }
   if (OrderType() == OP_SELL) {
      l_ask_12 = MarketInfo(OrderSymbol(), MODE_ASK);
      li_0 = gi_156;
      if (li_0 > 0) {
         if (OrderOpenPrice() - l_ask_12 > li_0 * l_point_20)
            if (OrderOpenPrice() - OrderStopLoss() < 0.0) ModSL(OrderOpenPrice() - 0.0 * l_point_20);
      }
      if (li_28 > 0) {
         if (OrderOpenPrice() - l_ask_12 > li_28 * l_point_20)
            if (OrderStopLoss() > l_ask_12 + (li_28 + gi_152 - 1) * l_point_20 || OrderStopLoss() == 0.0) ModSL(l_ask_12 + li_28 * l_point_20);
      }
   }
}

void ModSL(double a_price_0) {
   int l_bool_8 = OrderModify(OrderTicket(), OrderOpenPrice(), a_price_0, OrderTakeProfit(), 0, CLR_NONE);
}

int AddP() {
   int l_count_0 = 0;
   int l_datetime_4 = 0;
   for (int l_pos_8 = 0; l_pos_8 < OrdersTotal(); l_pos_8++) {
      if (OrderSelect(l_pos_8, SELECT_BY_POS) == TRUE && OrderSymbol() == Symbol() && OrderType() < OP_SELLLIMIT && OrderMagicNumber() == Magic || Magic == 0) {
         l_count_0++;
         if (OrderOpenTime() > l_datetime_4) l_datetime_4 = OrderOpenTime();
      }
   }
   if (l_count_0 == 0) return (1);
   if (l_count_0 > 0 && Time[0] - l_datetime_4 > 0) return (1);
   return (0);
}