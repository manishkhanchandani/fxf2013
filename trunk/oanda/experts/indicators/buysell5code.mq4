/*
   Generated by EX4-TO-MQ4 decompiler V4.0.469.1 [-]
   Website: https://purebeam.biz
   E-mail : purebeam@gmail.com
*/

#property indicator_separate_window
#property indicator_buffers 5
#property indicator_color1 White
#property indicator_color2 Yellow
#property indicator_color3 White
#property indicator_color4 Blue
#property indicator_color5 Yellow

extern int SignalPeriod = 48;
extern int Dee_period = 64;
int gi_84 = 0;
int gi_88 = 0;
int gi_92 = 0;
int g_ma_method_96 = MODE_LWMA;
int g_applied_price_100 = PRICE_CLOSE;
extern double FilterNumber = 2.0;
extern int aTake_Profit = 250;
extern int aStop_Loss = 150;
extern bool aAlerts = TRUE;
extern bool EmailOn = TRUE;
extern color BuyColor = Blue;
extern color SellColor = Red;
int g_width_136 = 3;
int g_width_140 = 1;
double gd_144 = 3.0;
int g_ma_method_152 = MODE_LWMA;
int g_applied_price_156 = PRICE_CLOSE;
int gi_160 = 16;
bool gi_unused_164 = FALSE;
double g_ibuf_168[];
double g_ibuf_172[];
double g_ibuf_176[];
double gda_unused_180[];
double gda_unused_184[];
bool gi_unused_188 = FALSE;
bool gi_unused_192 = FALSE;
datetime g_time_196;
string gs_212;
double g_ibuf_220[];
double g_ibuf_224[];
double g_ibuf_228[];
double g_ibuf_232[];
string gs_trpt_236 = "trpt";
int gi_244;
string gs_248;
string gs_256;
int g_time_264 = 0;

string f0_3() {
   string timeframe_4;
   switch (Period()) {
   case PERIOD_M1:
      timeframe_4 = "M1";
      break;
   case PERIOD_M5:
      timeframe_4 = "";
      break;
   case PERIOD_M15:
      timeframe_4 = "";
      break;
   case PERIOD_M30:
      timeframe_4 = "";
      break;
   case PERIOD_H1:
      timeframe_4 = "";
      break;
   case PERIOD_H4:
      timeframe_4 = "";
      break;
   case PERIOD_D1:
      timeframe_4 = "";
      break;
   case PERIOD_W1:
      timeframe_4 = "";
      break;
   case PERIOD_MN1:
      timeframe_4 = "";
      break;
   default:
      timeframe_4 = Period();
   }
   return (timeframe_4);
}
		    			 	 			 				 	  	  	 		 				   		 	  	    	   	   		  	   		        	  			 			 	 	   	 		 				 	 	   		    	 				 		  		   		 	 		 					 
void f0_12(string as_0, double ad_8, double ad_16, double ad_24) {
   string ls_32;
   string ls_40;
   string ls_48;
   string ls_56;
   if (Time[0] != g_time_196) {
      g_time_196 = Time[0];
      if (gs_212 != as_0) {
         if (gs_212 == "") gs_212 = as_0;
         else {
            gs_212 = as_0;
            if (ad_8 != 0.0) ls_48 = " - Price " + DoubleToStr(ad_8, 5);
            else ls_48 = "";
            if (ad_16 != 0.0) ls_40 = ", TakeProfit   " + DoubleToStr(ad_16, 5);
            else ls_40 = "";
            if (ad_24 != 0.0) ls_32 = ", StopLoss   " + DoubleToStr(ad_24, 5);
            else ls_32 = "";
            ls_56 = gs_248 + " email " + f0_2() + as_0 + ls_48 + ls_40 + ls_32 + "Date & Time = " + TimeToStr(TimeCurrent(), TIME_DATE) + " " + TimeHour(TimeCurrent()) + ":" + TimeMinute(TimeCurrent()) + " ";
         }
      }
   }
}
	 	   		 	  			    	 	   			 		    	   	 	   	  		    	 		 	  	 		 	    			 	  	  				 		 	  	 	 	 			 		 	  		 				 			 	 	  							 	   							
int init() {
   int li_0;
   IndicatorBuffers(7);
   if ((!SetIndexBuffer(0, g_ibuf_220)) && !SetIndexBuffer(1, g_ibuf_224) && (!SetIndexBuffer(2, g_ibuf_228)) && (!SetIndexBuffer(5, g_ibuf_232))) Print("Buffers Up");
   SetIndexStyle(0, DRAW_HISTOGRAM);
   SetIndexStyle(1, DRAW_HISTOGRAM);
   SetIndexStyle(2, DRAW_HISTOGRAM);
   gi_244 = SignalPeriod + MathFloor(MathSqrt(SignalPeriod));
   SetIndexDrawBegin(0, gi_244);
   SetIndexDrawBegin(1, gi_244);
   SetIndexDrawBegin(2, gi_244);
   IndicatorDigits(MarketInfo(Symbol(), MODE_DIGITS) + 1.0);
   gs_256 = "  BUYSELLSECRET (" + SignalPeriod + ", " + Dee_period + ")";
   IndicatorShortName(gs_256);
   SetIndexLabel(0, " BUYSELLSECRET ");
   gs_248 = Symbol() + " (" + f0_3() + "):  ";
   gi_unused_188 = TRUE;
   gi_unused_192 = TRUE;
   gs_212 = "";
   if (Dee_period == 8) li_0 = 2;
   else li_0 = 4;
   string ls_4 = "(" + Dee_period + ")";
   SetIndexBuffer(3, g_ibuf_168);
   SetIndexStyle(3, DRAW_LINE, STYLE_SOLID, li_0);
   SetIndexLabel(3, "BUYSELLSECRET");
   SetIndexBuffer(4, g_ibuf_172);
   SetIndexStyle(4, DRAW_LINE, STYLE_SOLID, li_0);
   SetIndexLabel(4, "BUYSELLSECRET");
   SetIndexBuffer(6, g_ibuf_176);
   ArraySetAsSeries(g_ibuf_176, TRUE);
   return (0);
}
			     	   		 			 	 				 		 	 			 	  	 	    			       	   	   	   	  		  	 	 	 							  		  		 	  				  		  	 	  		 	  	  	      			  							   
int deinit() {
   ObjectsDeleteAll(0, OBJ_ARROW);
   ObjectsDeleteAll(WindowFind(gs_256), OBJ_ARROW);
   Comment("");
   return (0);
}
	 			  	 	 	 	      			  		 		      	 		 	 				 		 		   		  	   		  	 	 				  		  	  				 						 	   				 				  			 		 	 	  	  				       	  	 		
int start() {
   string ls_0;
   double ima_on_arr_28;
   string name_36;
   if (g_ibuf_168[1] != EMPTY_VALUE) ls_0 = "UP trend \n ";
   else ls_0 = "DOWN trend \n ";
   ls_0 = ls_0 + "SignalPeriod: " + SignalPeriod + " \n aTake_Profit: " + aTake_Profit + " \n aStop_Loss: " + aStop_Loss + " \n aAlerts: ";
   if (aAlerts) ls_0 = ls_0 + "true \n ";
   else ls_0 = ls_0 + "false \n ";
   ls_0 = ls_0 + "EmailOn: ";
   if (EmailOn) ls_0 = ls_0 + "true \n ";
   else ls_0 = ls_0 + "false \n ";
   ls_0 = ls_0 + "ArrowSize1: " + g_width_136 + " \n ArrowSize2: " + g_width_140;
   Comment(ls_0);
   f0_7();
   int li_16 = IndicatorCounted();
   if (!f0_8()) return (0);
   if (li_16 < 1) {
      for (int li_12 = 1; li_12 <= gi_244; li_12++) g_ibuf_232[Bars - li_12] = 0;
      for (li_12 = 1; li_12 <= SignalPeriod; li_12++) {
         g_ibuf_220[Bars - li_12] = 0;
         g_ibuf_224[Bars - li_12] = 0;
         g_ibuf_228[Bars - li_12] = 0;
      }
   }
   if (li_16 > 0) li_16--;
   int li_8 = Bars - li_16;
   for (li_12 = 1; li_12 <= li_8; li_12++) {
      g_ibuf_232[li_12] = 2.0 * iMA(NULL, 0, MathFloor(SignalPeriod / FilterNumber), gi_92, g_ma_method_96, g_applied_price_100, li_12) - iMA(NULL, 0, SignalPeriod, gi_92,
         g_ma_method_96, g_applied_price_100, li_12);
   }
   double ima_on_arr_20 = iMAOnArray(g_ibuf_232, 0, MathFloor(MathSqrt(SignalPeriod)), 0, g_ma_method_96, 1);
   for (li_12 = 2; li_12 <= li_8; li_12++) {
      ima_on_arr_28 = iMAOnArray(g_ibuf_232, 0, MathFloor(MathSqrt(SignalPeriod)), 0, g_ma_method_96, li_12);
      if (ima_on_arr_28 > ima_on_arr_20) {
         g_ibuf_220[li_12] = EMPTY_VALUE;
         g_ibuf_224[li_12] = EMPTY_VALUE;
         g_ibuf_228[li_12] = ima_on_arr_28;
         g_ibuf_228[li_12 - 1] = ima_on_arr_20;
      } else {
         if (ima_on_arr_28 < ima_on_arr_20) {
            g_ibuf_220[li_12] = ima_on_arr_28;
            g_ibuf_220[li_12 - 1] = ima_on_arr_20;
            g_ibuf_224[li_12] = EMPTY_VALUE;
            g_ibuf_228[li_12] = EMPTY_VALUE;
         } else {
            g_ibuf_220[li_12] = -1;
            g_ibuf_224[li_12] = ima_on_arr_28;
            g_ibuf_228[li_12 - 1] = ima_on_arr_20;
            g_ibuf_228[li_12] = -1;
         }
      }
      ima_on_arr_20 = ima_on_arr_28;
   }
   f0_4();
   if (aAlerts) {
      li_12 = 2;
      name_36 = gs_trpt_236 + "_1" + DoubleToStr(Time[li_12], 0);
      if (ObjectFind(name_36) != -1) {
         if (g_ibuf_168[li_12 + 1] == EMPTY_VALUE && g_ibuf_168[li_12] != EMPTY_VALUE) {
            Alert("BUYSELLSECRET: on ", Symbol() + " (M" + Period() + ") Buy signal: " + DoubleToStr(Close[1], Digits) + ", TP: " + DoubleToStr(f0_9(), Digits) + ", SL: " + DoubleToStr(f0_5(),
               Digits));
            if (EmailOn) {
               SendMail("Alert", Symbol() + "buysellsecret - Timeframe M:" + Period() + " Buy signal Open: " + DoubleToStr(Close[1], Digits) + " TP: " + DoubleToStr(f0_9(), Digits) +
                  " SL: " + DoubleToStr(f0_5(), Digits));
            }
         }
         if (g_ibuf_172[li_12 + 1] == EMPTY_VALUE && g_ibuf_172[li_12] != EMPTY_VALUE) {
            Alert("BUYSELLSECRET: on ", Symbol() + " (M" + Period() + ") Sell signal: " + DoubleToStr(Close[1], Digits) + ", TP: " + DoubleToStr(f0_10(), Digits) + ", SL: " +
               DoubleToStr(f0_1(), Digits));
            f0_12(Symbol() + " SELL signal", Close[1], f0_10(), f0_1());
            if (EmailOn) {
               SendMail("Alert", Symbol() + "buysellsecret -  Timeframe M:" + Period() + " Sell signal Open: " + DoubleToStr(Close[1], Digits) + " TP: " + DoubleToStr(f0_10(), Digits) +
                  " SL: " + DoubleToStr(f0_1(), Digits));
            }
         }
      }
   }
   return (0);
}
					      	 	 	 	  				  	 		 	 	  	 	    						  		  		   	  		   	 			 		  	  		  		 							      		 						 		 	 		      	   	 	    	 		  	  	
bool f0_8() {
   if (g_time_264 != Time[0]) {
      g_time_264 = Time[0];
      return (TRUE);
   }
   return (FALSE);
}
								   	  	  	  	     	 	 	  	  		 	   		   	  				 	   			 	   		  	 		 	 	 		    						  	       						 	 	 	 	 		    					 	  		  		   			
double f0_10() {
   return (Bid - aTake_Profit * Point);
}
	 	   		 	  			    	 	   			 		    	   	 	   	  		    	 		 	  	 		 	    			 	  	  				 		 	  	 	 	 			 		 	  		 				 			 	 	  							 	   							
double f0_9() {
   return (Ask + aTake_Profit * Point);
}
			 	 			    		 		 			  	 					 		 		  		   		      	 	    		 	    		     	    					 	 	 		 		 		  	 	 	 		 			   							  		 		  		  	 				 			 
double f0_1() {
   return (Bid + aStop_Loss * Point);
}
		 	 	 		 			   			   	 	       			  				 		  	   		 	    	  	    	  		    							  	 		 	 	  			 	 	 		 	 	           		 	  	 	    		  		  	  	 
double f0_5() {
   return (Ask - aStop_Loss * Point);
}
	   	  	 		  	    					  	 			    			 		 		 			 			 	   					   					 	 		    		   	 				   				 			 				   		  		 			 	 				  			 	       	 	 		
int f0_2() {
   return (10000.0 * (SignalPeriod * Point));
}
	  			 	 			      	 	 	  	  	     	 				 				 	 						  			 		  			 			 		 	 			      			  		 		 		   			  		   		  	  	 		 		 			   	         		
double f0_11(int ai_0, int a_period_4) {
   return (iMA(NULL, 0, a_period_4, 0, g_ma_method_152, g_applied_price_156, ai_0));
}
	  		  					 	  	 	 			 		  		  	 	 	 									  				    		 	    		 	 	  	 	  			    			   								  			   			   	  		 				 	  	 	      	    	 	 
int f0_7() {
   double lda_20[];
   double lda_24[];
   double ld_36;
   int ind_counted_0 = IndicatorCounted();
   if (ind_counted_0 < 0) return (-1);
   int li_4 = 1;
   int period_8 = MathFloor(MathSqrt(Dee_period));
   int li_12 = MathFloor(Dee_period / gd_144);
   int li_16 = Bars - ind_counted_0 + Dee_period;
   if (li_16 > Bars) li_16 = Bars;
   ArraySetAsSeries(lda_20, TRUE);
   ArrayResize(lda_20, li_16);
   ArraySetAsSeries(lda_24, TRUE);
   ArrayResize(lda_24, li_16);
   double ld_28 = Close[1];
   for (li_4 = 0; li_4 < li_16; li_4++) lda_20[li_4] = 2.0 * f0_11(li_4, li_12) - f0_11(li_4, Dee_period);
   for (li_4 = 0; li_4 < li_16 - Dee_period; li_4++) g_ibuf_176[li_4] = iMAOnArray(lda_20, 0, period_8, 0, g_ma_method_152, li_4);
   for (li_4 = li_16 - Dee_period; li_4 > 0; li_4--) {
      lda_24[li_4] = lda_24[li_4 + 1];
      if (g_ibuf_176[li_4] > g_ibuf_176[li_4 + 1]) lda_24[li_4] = 1;
      if (g_ibuf_176[li_4] < g_ibuf_176[li_4 + 1]) lda_24[li_4] = -1;
      if (lda_24[li_4] > 0.0) {
         g_ibuf_168[li_4] = g_ibuf_176[li_4];
         if (lda_24[li_4 + 1] < 0.0) g_ibuf_168[li_4 + 1] = g_ibuf_176[li_4 + 1];
         if (lda_24[li_4 + 1] < 0.0) {
            if (li_4 == 1) {
               ld_36 = ld_28 - gi_160 * Point;
               f0_12("Buy signal", 0, ld_36, ld_28);
            }
         }
         g_ibuf_172[li_4] = EMPTY_VALUE;
      } else {
         if (lda_24[li_4] < 0.0) {
            g_ibuf_172[li_4] = g_ibuf_176[li_4];
            if (lda_24[li_4 + 1] > 0.0) g_ibuf_172[li_4 + 1] = g_ibuf_176[li_4 + 1];
            if (lda_24[li_4 + 1] > 0.0) {
               if (li_4 == 1) {
                  ld_36 = ld_28 + gi_160 * Point;
                  f0_12("Sell signal", 0, ld_36, ld_28);
               }
            }
            g_ibuf_168[li_4] = EMPTY_VALUE;
         }
      }
   }
   return (0);
}
		 	   		 				  			  		 	    	  			   			 		 		   		      	       	   	    		 				  				 	 	 				 	 				 	 	 	       	 		 	    	    	   		  		 	 
void f0_4() {
   int li_4;
   int ind_counted_0 = IndicatorCounted();
   if (ind_counted_0 >= 0) {
      li_4 = Bars - ind_counted_0 + 1;
      for (int li_8 = 1; li_8 < li_4; li_8++) {
         if (g_ibuf_168[li_8 + 1] == EMPTY_VALUE && g_ibuf_168[li_8] != EMPTY_VALUE) f0_6(li_8);
         if (g_ibuf_172[li_8 + 1] == EMPTY_VALUE && g_ibuf_172[li_8] != EMPTY_VALUE) f0_0(li_8);
      }
   }
}
		  	 		  	  		  					     				  				  	  	 		  	 	 	 	 	 			 	 	 			   	      	 	 	 	 			  		 	  		 	 			  			 	  					  			 			  	  	  	 	 				
void f0_6(int ai_0) {
   string name_4 = gs_trpt_236 + "_1" + DoubleToStr(Time[ai_0], 0);
   string name_12 = gs_trpt_236 + "_2" + DoubleToStr(Time[ai_0], 0);
   if (ObjectFind(name_4) == -1) {
      if (ObjectCreate(name_4, OBJ_ARROW, 0, Time[ai_0 - 1], Low[ai_0 - 1] - gi_84 * Point)) {
         ObjectSet(name_4, OBJPROP_ARROWCODE, 233);
         ObjectSet(name_4, OBJPROP_COLOR, BuyColor);
         ObjectSet(name_4, OBJPROP_WIDTH, g_width_136);
      }
   }
   int window_20 = WindowFind(gs_256);
   if (window_20 != -1) {
      if (ObjectFind(name_12) == -1) {
         if (ObjectCreate(name_12, OBJ_ARROW, window_20, Time[ai_0 - 1], g_ibuf_168[ai_0 - 1] - gi_88 * Point)) {
            ObjectSet(name_12, OBJPROP_ARROWCODE, 233);
            ObjectSet(name_12, OBJPROP_COLOR, BuyColor);
            ObjectSet(name_12, OBJPROP_WIDTH, g_width_140);
         }
      }
   }
}
	 		 					 		 	 	       			   	 	    	 			 	     	 	 		  	   		  	   	   					 		 	 	  	  		   			  	  	  		  	  		   				   			 		 			 	 	 	 		 
void f0_0(int ai_0) {
   string name_4 = gs_trpt_236 + "_1" + DoubleToStr(Time[ai_0], 0);
   string name_12 = gs_trpt_236 + "_2" + DoubleToStr(Time[ai_0], 0);
   if (ObjectFind(name_4) == -1) {
      if (ObjectCreate(name_4, OBJ_ARROW, 0, Time[ai_0 - 1], High[ai_0 - 1] + gi_84 * Point)) {
         ObjectSet(name_4, OBJPROP_ARROWCODE, 234);
         ObjectSet(name_4, OBJPROP_COLOR, SellColor);
         ObjectSet(name_4, OBJPROP_WIDTH, g_width_136);
      }
   }
   int window_20 = WindowFind(gs_256);
   if (window_20 != -1) {
      if (ObjectFind(name_12) == -1) {
         if (ObjectCreate(name_12, OBJ_ARROW, window_20, Time[ai_0 - 1], g_ibuf_172[ai_0 - 1] + gi_88 * Point)) {
            ObjectSet(name_12, OBJPROP_ARROWCODE, 234);
            ObjectSet(name_12, OBJPROP_COLOR, SellColor);
            ObjectSet(name_12, OBJPROP_WIDTH, g_width_140);
         }
      }
   }
}
