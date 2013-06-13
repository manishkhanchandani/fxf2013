
#property copyright "Jerome"
#property link      "4xCoder@gmail.com"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red

#import "kernel32.dll"
   void GetLocalTime(int& a0[]);
   int GetTimeZoneInformation(int& a0[]);
#import

extern bool ShowLocal = TRUE;
extern int corner = 3;
extern int topOff = 120;
extern color labelColor = White;
extern color clockColor = White;
extern bool show12HourTime = FALSE;
int gi_100;
double g_ibuf_104[];
int gi_108 = 0;
int gi_112 = 9;
int gi_116 = -5;

string TimeToString(int ai_0) {
   if (!show12HourTime) return (TimeToStr(ai_0, TIME_MINUTES));
   int li_4 = TimeHour(ai_0);
   int l_minute_8 = TimeMinute(ai_0);
   string ls_12 = " AM";
   if (li_4 >= 12) {
      li_4 -= 12;
      ls_12 = " PM";
   }
   if (li_4 == 0) li_4 = 12;
   string ls_ret_20 = DoubleToStr(li_4, 0) + ":";
   if (l_minute_8 < 10) ls_ret_20 = ls_ret_20 + "0";
   ls_ret_20 = ls_ret_20 + DoubleToStr(l_minute_8, 0);
   ls_ret_20 = ls_ret_20 + ls_12;
   return (ls_ret_20);
}

int start() {
   int lia_4[4];
   int lia_8[43];
   string ls_unused_40;
   if (!IsDllsAllowed()) {
      Alert("Clock V1_2: DLLs are disabled.  To enable tick the checkbox in the Common Tab of indicator");
      return;
   }
   int l_ind_counted_0 = IndicatorCounted();
   GetLocalTime(lia_4);
   int li_12 = lia_4[0] & 65535;
   int li_16 = lia_4[0] >> 16;
   int li_20 = lia_4[1] >> 16;
   int li_24 = lia_4[2] & 65535;
   int li_28 = lia_4[2] >> 16;
   int li_32 = lia_4[3] & 65535;
   int li_36 = lia_4[3] >> 16;
   string ls_48 = FormatDateTime(li_12, li_16, li_20, li_24, li_28, li_32);
   int l_str2time_56 = StrToTime(ls_48);
   gi_108 = GMT_Offset("LONDON", l_str2time_56);
   gi_112 = GMT_Offset("TOKYO", l_str2time_56);
   gi_116 = GMT_Offset("US", l_str2time_56);
   int li_60 = -420;
   int li_64 = GetTimeZoneInformation(lia_8);
   if (li_64 != 0) li_60 = lia_8[0];
   if (li_64 == 2) li_60 += lia_8[42];
   int l_datetime_68 = TimeCurrent();
   int li_72 = l_str2time_56 + 60 * li_60;
   int li_76 = li_72 + 3600 * gi_108;
   int li_80 = li_72 + 3600 * gi_112;
   int li_84 = li_72 + 3600 * gi_116;
   string l_text_88 = TimeToString(li_72);
   string l_text_96 = TimeToString(l_str2time_56);
   string l_text_104 = TimeToString(li_76);
   string l_text_112 = TimeToString(li_80);
   string l_text_120 = TimeToString(li_84);
   string l_text_128 = TimeToString(TimeCurrent());
   string l_time2str_136 = TimeToStr(TimeCurrent() - Time[0], TIME_MINUTES);
   if (ShowLocal) {
      ObjectSetText("locl", "Local:", 10, "Arial", labelColor);
      ObjectSetText("loct", l_text_96, 10, "Arial", clockColor);
   }
   ObjectSetText("gmtl", "GMT:", 10, "Arial", labelColor);
   ObjectSetText("gmtt", l_text_88, 10, "Arial", clockColor);
   ObjectSetText("nyl", "New York:", 10, "Arial", labelColor);
   ObjectSetText("nyt", l_text_120, 10, "Arial", clockColor);
   ObjectSetText("lonl", "London:", 10, "Arial", labelColor);
   ObjectSetText("lont", l_text_104, 10, "Arial", clockColor);
   ObjectSetText("tokl", "Tokyo:", 10, "Arial", labelColor);
   ObjectSetText("tokt", l_text_112, 10, "Arial", clockColor);
   ObjectSetText("brol", "Broker:", 10, "Arial", labelColor);
   ObjectSetText("brot", l_text_128, 10, "Arial", clockColor);
   ObjectSetText("barl", "Bar:", 10, "Arial", labelColor);
   ObjectSetText("bart", l_time2str_136, 10, "Arial", clockColor);
   gi_100 = NormalizeDouble((Ask - Bid) / Point, 0);
   ObjectSetText("Spread Monitor1", "Spread:", 10, "Arial", labelColor);
   ObjectSetText("Spread Monitor2", DoubleToStr(gi_100, 0), 10, "Arial", clockColor);
   return (0);
}

int ObjectMakeLabel(string a_name_0, int a_x_8, int a_y_12) {
   ObjectCreate(a_name_0, OBJ_LABEL, 0, 0, 0);
   ObjectSet(a_name_0, OBJPROP_CORNER, corner);
   ObjectSet(a_name_0, OBJPROP_XDISTANCE, a_x_8);
   ObjectSet(a_name_0, OBJPROP_YDISTANCE, a_y_12);
   ObjectSet(a_name_0, OBJPROP_BACK, TRUE);
   return (0);
}

string FormatDateTime(int ai_0, int ai_4, int ai_8, int ai_12, int ai_16, int ai_20) {
   string ls_24 = ai_4 + 100;
   ls_24 = StringSubstr(ls_24, 1);
   string ls_32 = ai_8 + 100;
   ls_32 = StringSubstr(ls_32, 1);
   string ls_40 = ai_12 + 100;
   ls_40 = StringSubstr(ls_40, 1);
   string ls_48 = ai_16 + 100;
   ls_48 = StringSubstr(ls_48, 1);
   string ls_56 = ai_20 + 100;
   ls_56 = StringSubstr(ls_56, 1);
   return (StringConcatenate(ai_0, ".", ls_24, ".", ls_32, " ", ls_40, ":", ls_48, ":", ls_56));
}

int init() {
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, g_ibuf_104);
   int li_0 = topOff;
   int li_4 = 90;
   if (show12HourTime) li_4 = 102;
   if (ShowLocal) {
      ObjectMakeLabel("locl", li_4, li_0);
      ObjectMakeLabel("loct", 45, li_0);
   }
   ObjectMakeLabel("gmtl", li_4, li_0 - 15);
   ObjectMakeLabel("gmtt", 45, li_0 - 15);
   ObjectMakeLabel("nyl", li_4, li_0 - 30);
   ObjectMakeLabel("nyt", 45, li_0 - 30);
   ObjectMakeLabel("lonl", li_4, li_0 - 45);
   ObjectMakeLabel("lont", 45, li_0 - 45);
   ObjectMakeLabel("tokl", li_4, li_0 - 60);
   ObjectMakeLabel("tokt", 45, li_0 - 60);
   ObjectMakeLabel("brol", li_4, li_0 - 75);
   ObjectMakeLabel("brot", 45, li_0 - 75);
   ObjectMakeLabel("barl", li_4, li_0 - 90);
   ObjectMakeLabel("bart", 45, li_0 - 90);
   ObjectMakeLabel("Spread Monitor1", li_4, li_0 - 105);
   ObjectMakeLabel("Spread Monitor2", 70, li_0 - 105);
   return (0);
}

int deinit() {
   ObjectDelete("locl");
   ObjectDelete("loct");
   ObjectDelete("nyl");
   ObjectDelete("nyt");
   ObjectDelete("gmtl");
   ObjectDelete("gmtt");
   ObjectDelete("lonl");
   ObjectDelete("lont");
   ObjectDelete("tokl");
   ObjectDelete("tokt");
   ObjectDelete("brol");
   ObjectDelete("brot");
   ObjectDelete("barl");
   ObjectDelete("bart");
   ObjectDelete("Spread Monitor1");
   ObjectDelete("Spread Monitor2");
   return (0);
}

int GMT_Offset(string as_0, int ai_8) {
   int li_ret_12 = 0;
   if (as_0 == "FRANKFURT") li_ret_12 = GMT1(ai_8);
   else {
      if (as_0 == "LONDON") li_ret_12 = GMT0(ai_8);
      else {
         if (as_0 == "US") li_ret_12 = GMT_5(ai_8);
         else
            if (as_0 == "TOKYO") li_ret_12 = GMT9(ai_8);
      }
   }
   return (li_ret_12);
}

int GMT0(int ai_0) {
   if (ai_0 > last_sunday(TimeYear(ai_0), 3) && ai_0 < last_sunday(TimeYear(ai_0), 10)) return (1);
   else return (0);
}

int GMT_5(int ai_0) {
   if (TimeYear(ai_0) < 2007) {
      if (ai_0 > first_sunday(TimeYear(ai_0), 4) && ai_0 < last_sunday(TimeYear(ai_0), 10)) return (-4);
      else return (-5);
   } else {
      if (ai_0 > second_sunday(TimeYear(ai_0), 3) && ai_0 < first_sunday(TimeYear(ai_0), 11)) return (-4);
      else return (-5);
   }
}

int GMT9(int ai_unused_0) {
   return (9);
}

bool is_leap_year(int ai_0) {
   if (MathMod(ai_0, 100) == 0.0 && MathMod(ai_0, 400) == 0.0) return (TRUE);
   else {
      if (MathMod(ai_0, 100) != 0.0 && MathMod(ai_0, 4) == 0.0) return (TRUE);
      else return (FALSE);
   }
}

int n_days(int ai_0, int ai_4) {
   int li_ret_8;
   if (ai_4 == 1) li_ret_8 = 31;
   else {
      if (ai_4 == 2) {
         if (is_leap_year(ai_0)) li_ret_8 = 29;
         else li_ret_8 = 28;
      } else {
         if (ai_4 == 3) li_ret_8 = 31;
         else {
            if (ai_4 == 4) li_ret_8 = 30;
            else {
               if (ai_4 == 5) li_ret_8 = 31;
               else {
                  if (ai_4 == 6) li_ret_8 = 30;
                  else {
                     if (ai_4 == 7) li_ret_8 = 31;
                     else {
                        if (ai_4 == 8) li_ret_8 = 31;
                        else {
                           if (ai_4 == 9) li_ret_8 = 30;
                           else {
                              if (ai_4 == 10) li_ret_8 = 31;
                              else {
                                 if (ai_4 == 11) li_ret_8 = 30;
                                 else
                                    if (ai_4 == 12) li_ret_8 = 31;
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }
   return (li_ret_8);
}

int n_sdays(int ai_0, int ai_4) {
   int l_str2time_8;
   int li_12 = n_days(ai_0, ai_4);
   int l_count_20 = 0;
   for (int li_16 = 1; li_16 <= li_12; li_16++) {
      l_str2time_8 = StrToTime(DoubleToStr(ai_0, 0) + "." + DoubleToStr(ai_4, 0) + "." + DoubleToStr(li_16, 0) + " 00:00");
      if (TimeDayOfWeek(l_str2time_8) == 0) l_count_20++;
   }
   return (l_count_20);
}

int last_sunday(int ai_0, int ai_4) {
   int l_str2time_24;
   int l_str2time_28;
   int li_12 = n_days(ai_0, ai_4);
   int li_20 = n_sdays(ai_0, ai_4);
   int l_count_16 = 0;
   for (int li_8 = 1; li_8 <= li_12; li_8++) {
      l_str2time_24 = StrToTime(DoubleToStr(ai_0, 0) + "." + DoubleToStr(ai_4, 0) + "." + DoubleToStr(li_8, 0) + " 00:00");
      if (TimeDayOfWeek(l_str2time_24) == 0) l_count_16++;
      if (l_count_16 == li_20) {
         l_str2time_28 = l_str2time_24;
         break;
      }
   }
   return (l_str2time_28);
}

int first_sunday(int ai_0, int ai_4) {
   int l_str2time_24;
   int l_str2time_28;
   int li_12 = n_days(ai_0, ai_4);
   int li_20 = 1;
   int l_count_16 = 0;
   for (int li_8 = 1; li_8 <= li_12; li_8++) {
      l_str2time_24 = StrToTime(DoubleToStr(ai_0, 0) + "." + DoubleToStr(ai_4, 0) + "." + DoubleToStr(li_8, 0) + " 00:00");
      if (TimeDayOfWeek(l_str2time_24) == 0) l_count_16++;
      if (l_count_16 == li_20) {
         l_str2time_28 = l_str2time_24;
         break;
      }
   }
   return (l_str2time_28);
}

int second_sunday(int ai_0, int ai_4) {
   int l_str2time_24;
   int l_str2time_28;
   int li_12 = n_days(ai_0, ai_4);
   int li_20 = 2;
   int l_count_16 = 0;
   for (int li_8 = 1; li_8 <= li_12; li_8++) {
      l_str2time_24 = StrToTime(DoubleToStr(ai_0, 0) + "." + DoubleToStr(ai_4, 0) + "." + DoubleToStr(li_8, 0) + " 00:00");
      if (TimeDayOfWeek(l_str2time_24) == 0) l_count_16++;
      if (l_count_16 == li_20) {
         l_str2time_28 = l_str2time_24;
         break;
      }
   }
   return (l_str2time_28);
}

int GMT1(int ai_0) {
   if (ai_0 > last_sunday(TimeYear(ai_0), 3) && ai_0 < last_sunday(TimeYear(ai_0), 10)) return (2);
   else return (1);
}