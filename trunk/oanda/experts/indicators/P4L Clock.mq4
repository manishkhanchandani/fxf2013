//+------------------------------------------------------------------+
//|                                                    P4L Clock.mq4 |
//| New rewrite by: Pips4life, a user at forexfactory.com            |
//| 2008-09-28: v2_3  P4L Clock.mq4                                  |
//|  (See Version History below)                                     |
//|                                                                  |
//| Previous names: Clock_v1_3.mq4, Clock.mq4, ...                   |
//| Previous version:   Jerome,  4xCoder@gmail.com, ...              |
//|                                                                  |
//+------------------------------------------------------------------+
//
// Version History:
// 2008-09-28: v2_3  pips4life:
//    Added Auckland, Moscow, Berlin, Seattle for Jodie(jhp2025). Default topOffsetPixels is now 10.
// 2008-09-28: v2_2  pips4life: Turns out the ST/DST crossover dates are good
//    until any market zone country legistlatively changes their dates.
//    No annual update is necessary!  I updated the comments accordingly.
//    I moved the init() block before start for easier readability of the flow.
//    Mostly cosmetic changes.
// 2008-09-27: v2_1  pips4life: 
//    Modified Sydney changes NuckingFuts made. (Thx for the prelim work).
//    The original world time ST/DST calculation method which I had not looked
//    at enough to understand is fatally flawed, so...all that is rewritten! 
//    The new method uses true clock data and  *should* work from every timezone, 
//    and *should* handle ST/DST changes for each TZ, independently,
//    regardless of your local TS and/or ST/DST status. (Depends on Windows
//    being correct, however). CONSEQUENTLY, the changes require ANNUAL UPDATES
//    to get the world ST/DST changeover dates!! Check this thread for updates:
//       http://forexfactory.com/showthread.php?t=109305
//    If no update, in JUST ONE CHART (!!), set If_TZ_ChangesSetTrueOn_ONE_chart=TRUE 
//    and follow the directions...  Do NOT compile the code with that variable=TRUE!!
//    Added Weekend_Test_Mode so simulated ticks show true times over the weekend.
// 2008-09-25:  mods by NuckingFuts
//    Fixed timezones with no daylight savings
//    Added Sydney
// 2008-09-24:  v2_0 "P4L Clock.mq4" by pips4life @ forexfactory.com 
//    Different highlight color(s) used for Market Open hours (Assuming 8AM - 5PM local market hours)
//    Added seconds display, and used method such that single digits look better (":09" not ":9")
//    Added "Broker_MMSS_Is_Gold_Standard" to adjust (by a few seconds or minutes) the market hours, because
//      as if often the case, the local computer clock may be off by a small amount.
//    Two extern variables to control display of seconds: bool Display_Time_With_Seconds, int Display_Bar_With_Seconds.
//    When Display_Bar_With_Seconds=2 (Auto mode), seconds display when < 2min, OR, if Display_Time_With_Seconds=True.
//    "Bar:" changed to "Bar Left:" (remaining time). Also, it will say "wait4bar" (rather than to display
//      a negative number as would have occurred) during periods of low activity until a new bar is formed.
//    "Suppress_Bar_HH_Below_H1" displays only [MM:SS] for H1 and below since HH in [HH:MM:SS] is always "00" 
//    Adjusted pixel distance between labels depending on options.
//    "Bar Left:" time does not display above D1 charts.  A future enhancement (not planned) could report DD_HH:MM[:SS]
//    Added Show_DIBS_London clock with user-setable start/stop hour relative to London (6AM and 7PM at present).
//
// 2008-??   v1_4  Was NOT an indicator, rather a script; however, it didn't handle new bars (Time[0] stuck), nor could
//    one change timeframes without having to "Disable" and re-add the script. May have been more CPU intensive??
// 2008-??   v1_3 and earlier.  Details can be found on the web.

//#property copyright "Jerome" //previous author
//#property link      "4xCoder@gmail.com"
#property copyright "pips4life" //P4L Clock.mq4 is rewrite of Clock.mq4, Clock_v1_3.mq4
#property link      "pips4life, a user at forexfactory.com"

#import "kernel32.dll"
void GetLocalTime(int& localTimeArray[]);
void GetSystemTime(int& systemTimeArray[]);
int  GetTimeZoneInformation(int& localTZInfoArray[]);
bool SystemTimeToTzSpecificLocalTime(int& targetTZinfoArray[], int& systemTimeArray[], int& targetTimeArray[]);
#import

//------------------------------------------------------------------
// Instructions
//    Copy this file to:  C:\Program Files\--your-MT4-directory-here---\experts\indicators
//    Review the "extern" variable settings below. Change as desired, then restart MT4 or do "Compile" in MetaEditor.
//    
//    Open a chart and add this indicator. Assuming you compiled with the "extern" defaults you prefer,
//    you shouldn't need to change any of the defaults, *except* one:
//    ***This Version requires "Allow DLL Imports" be set in Common Tab when you add this to a chart!
//    FYI, the DLLs retrieve the local CPU clock time and timezone info as well as world timezone info.
//
//    NOTE! The world timezone times are only as accurate as your LOCAL CPU CLOCK! Verify and set it accurately!
//    NOTE! Your Broker time is independent.
// DISCLAIMER: Use completely at your own risk!! Author(s) accept no liabilities whatsoever!

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red


//---- input parameters -- FYI, THE USER MAY CUSTOMIZE THESE EXTERN VARIABLE SETTINGS AS DESIRED:
extern string   _INFO_Set_your_computer_clock = "Accuracy depends on YOUR CPU CLOCK!!";
extern string   _INFO_Verify_times_with_URL   = "http://www.worldtimezone.net/index24.php";
extern string   _INFO_Re_labelCorner          = "0=Top-left, 1=TR, 2=BL, 3=BR";
extern int      labelCorner                   = 1;          // 1 & 3 work best:  0=top-left; 1=top-right; 2=bottom-left; 3=bottom-right
extern int      topOffsetPixels               = 10;         // 10 pixels from top to show the 1st clock ("Bar Left:")
extern color    labelColor                    = DarkGreen;  // Color of label, off-hours
extern color    clockColor                    = MediumBlue; // Color of clock, off-hours
extern color    labelMktOpenColor             = Red;        // Color of label, market-open
extern color    clockMktOpenColor             = Red;        // Color of clock, market-open
extern bool     Highlight_Market_Open         = true ;      // When true, the above market-open colors are used between 8AM - 5PM (market local)
extern bool     Display_Times_With_AMPM       = false;      // True=show 12 hour AM/PM time, false=show 24 hour time
extern bool     Broker_MMSS_Is_Gold_Standard  = true ;      // If true, make a correction up to a few seconds/minutes vs. your local CPU clock. FYI, we don't know Broker TZ/DST info but don't care.
extern bool 	 Display_Time_With_Seconds     = false;      // Turn on seconds.
extern string   _INFO_Re_Bar_With_Seconds    = "0=No; 1=Yes; 2=Auto"; // Auto is: if < 120 seconds or if Display_Time_With_Seconds is true.
extern int  	 Display_Bar_With_Seconds      = 1;          // Control "Bar Left:" to display ":SS" independently from other times.
extern bool     Suppress_Bar_HH_Below_H1      = true ;      // For "Bar Left:" on H1 and below, display only [MM:SS] since HH in [HH:MM:SS] is always "00"
extern bool     ShowAuckland                  = true ;
extern bool     ShowSydney                    = true ;
extern bool     ShowTokyo                     = true ;
extern bool     ShowMoscow                    = true ;
extern bool     ShowBerlin                    = true ;
extern bool 	 ShowLondon                    = true ;
extern bool 	 ShowNewYork                   = true ;
extern bool 	 ShowSeattle                   = true ;
extern bool 	 ShowUTC_GMT                   = true ; // FYI, UTC_GMT does not change with Daylight Savings Time. In winter, London=UTC; in summer, London=UTC+1
extern bool     ShowLocal                     = true ; // FYI, this is your local computer clock.  Your clock should be accurate for all other timezones to be accurate!!
extern bool     Show_DIBS_London              = false; // FYI, for DIBS method, see http://www.forexfactory.com/showthread.php?t=86766
extern int      DIBS_LondonOpenHour           = 6;     // DIBS relative to London local time. 6 ~= 2 hours before London ~= Chicago midnight. (Follows London DST)
extern int      DIBS_LondonCloseHour          = 15;    // MAX is 23!! Subjective choice. Change as desired. 9 hours length?? (Do NOT use # < DIBS_LondonOpenHour). 
extern bool     Weekend_Test_Mode             = false; // Normally false. True forces Broker_MMSS_Is_Gold_Standard=false as well. Clock updates are >=once-per-broker-second but on weekends the Broker clock freezes
//

// FYI: If a market zone changes ST/DST dates (e.g. if Tokyo adopts DST), or, to add a new market timezone to this program,
//   you need to obtain the timezone ST/DST crossover date information.  To do that, add "extern" before this variable but leave it FALSE!
//  Add indicator to one chart and set this variable True ON ONE CHART ONLY, then follow the directions...
// WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING!
//extern
bool  New_DST_SetTrueOnONEchart   = FALSE; // WARNING! Do NOT compile this as TRUE! Rather, make it "extern bool", compile, then change just ONE CHART value to TRUE for instructions!

//---- buffers

int    localTZInfoArray[43];
int    newyorkTZInfoArray[43];
int    londonTZInfoArray[43];
int    tokyoTZInfoArray[43];
int    sydneyTZInfoArray[43];
int    aucklandTZInfoArray[43];
int    moscowTZInfoArray[43];
int    berlinTZInfoArray[43];
int    seattleTZInfoArray[43];


double ExtMapBuffer1[];
//int LondonTZ = 0; // These offsets aren't needed any more
//int TokyoTZ = 9;
//int SydneyTZ = 10;
//int NewYorkTZ = -5;


// Most local markets assumed open 8AM to 5PM
int localOpenHour = 8;
int localCloseHour = 17;

// Sydney market local is 7am-4pm per "NuckingFuts"
int sydneyLocalOpenHour = 7;
int sydneyLocalCloseHour = 16;


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   
   if (New_DST_SetTrueOnONEchart) writeLocalTZInfoToFile("tzdata.csv", false); // The false obtains only the limited data which is needed.
   
   GetAllTimeZoneInfo(localTZInfoArray, newyorkTZInfoArray, londonTZInfoArray, tokyoTZInfoArray, sydneyTZInfoArray, aucklandTZInfoArray, moscowTZInfoArray, berlinTZInfoArray, seattleTZInfoArray);
   
   int top=topOffsetPixels;
   int left = 90;
   int right = 22;
   if (!Display_Times_With_AMPM && !Display_Time_With_Seconds && Display_Bar_With_Seconds == 0) right = 42;
   else if (Display_Times_With_AMPM && !Display_Time_With_Seconds) right = 32;
   
   if ( Display_Times_With_AMPM )
      left = 102;
   int offset=0;
   
   if(Period() <= PERIOD_D1)
   {
      ObjectMakeLabel( "barl", left, top+offset );
      ObjectMakeLabel( "bart", right, top+offset );
      offset+=15;
   } else offset+=15; //offset bar label regardless if it displays or not
   // BrokerTime always displays
   ObjectMakeLabel( "brol", left, top+offset );
   ObjectMakeLabel( "brot", right, top+offset );
  	offset+=15;
  	//
   if(ShowAuckland)
   {
   	ObjectMakeLabel( "auckl", left, top+offset );
   	ObjectMakeLabel( "auckt", right, top+offset );
   	offset+=15;
   }
   if(ShowSydney)
   {
   	ObjectMakeLabel( "sydl", left, top+offset );
   	ObjectMakeLabel( "sydt", right, top+offset );
   	offset+=15;
   }
   if(ShowTokyo)
   {
   	ObjectMakeLabel( "tokl", left, top+offset );
   	ObjectMakeLabel( "tokt", right, top+offset );
   	offset+=15;
   }
   if(ShowMoscow)
   {
   	ObjectMakeLabel( "mosl", left, top+offset );
   	ObjectMakeLabel( "most", right, top+offset );
   	offset+=15;
   }
   if(ShowBerlin)
   {
   	ObjectMakeLabel( "berl", left, top+offset );
   	ObjectMakeLabel( "bert", right, top+offset );
   	offset+=15;
   }
   if(ShowLondon)
   {
	   ObjectMakeLabel( "lonl", left, top+offset );
   	ObjectMakeLabel( "lont", right, top+offset );
   	offset+=15;
   }
   if(ShowNewYork)
   {
	   ObjectMakeLabel( "nyl", left, top+offset );
   	ObjectMakeLabel( "nyt", right, top+offset );
   	offset+=15;
   }
   if(ShowSeattle)
   {
	   ObjectMakeLabel( "seal", left, top+offset );
   	ObjectMakeLabel( "seat", right, top+offset );
   	offset+=15;
   }
   if(ShowUTC_GMT)
   {
   	ObjectMakeLabel( "utcl", left, top+offset );
   	ObjectMakeLabel( "utct", right, top+offset );
   	offset+=15;
   }
   if ( Show_DIBS_London ) {
      ObjectMakeLabel( "dibsl", left, top+offset );
      ObjectMakeLabel( "dibst", right, top+offset );
      offset+=15;
   }
   if ( ShowLocal ) {
      ObjectMakeLabel( "locl", left, top+offset );
      ObjectMakeLabel( "loct", right, top+offset );
      offset+=15;
   }

//----
   return(0);
  } // end of init()
//+------------------------------------------------------------------+
//| Custom indicator iteration function -- Runs with each new tick   |
//+------------------------------------------------------------------+
int start()
  {
   static datetime last_timecurrent;
   if ( !IsDllsAllowed() ) 
   {
      if (TimeCurrent() - last_timecurrent < 7) return; // With a lot of fast ticks, this error message would be annoying if not delayed a bit
      last_timecurrent = TimeCurrent();
      Alert( WindowExpertName(),": ERROR. DLLs are disabled. To enable, select 'Allow DLL Imports' in the Common Tab of indicator" );
      return;
   }
   
   // FYI, if uncommented, saves CPU but won't update on weekends. If commented, on weekends the Broker_MMSS_Is_Gold_Standard must be FALSE. Better, just use Weekend_Test_Mode=true to update every tick.
   if (!Weekend_Test_Mode && TimeCurrent() - last_timecurrent == 0) return; // No point in processing more than 1 tick per second.
   last_timecurrent = TimeCurrent();
   
   int    localTimeArray[4];
   int    systemTimeArray[4];
   int    newyorkTimeArray[4];
   int    londonTimeArray[4];
   int    tokyoTimeArray[4];
   int    sydneyTimeArray[4];
   int    aucklandTimeArray[4];
   int    moscowTimeArray[4];
   int    berlinTimeArray[4];
   int    seattleTimeArray[4];
   
   
   GetLocalTime(localTimeArray);
   datetime localTime = TimeArrayToTime(localTimeArray);

   datetime brokerTime = TimeCurrent();
   datetime brokerCorrection = 0;
   
   if (Broker_MMSS_Is_Gold_Standard && !Weekend_Test_Mode) 
   {
      brokerCorrection = TimeMinute(brokerTime)*60 + TimeSeconds(brokerTime) - TimeMinute(localTime)*60 - TimeSeconds(localTime);
      if (brokerCorrection > 1800) brokerCorrection = brokerCorrection - 3600;
      else if (brokerCorrection < -1800) brokerCorrection = brokerCorrection + 3600;
      //Alert("brokerCorrection seconds: ", brokerCorrection);
   }   
     
   GetSystemTime(systemTimeArray);
   datetime UTC = TimeArrayToTime(systemTimeArray)+brokerCorrection;

   SystemTimeToTzSpecificLocalTime(newyorkTZInfoArray, systemTimeArray, newyorkTimeArray);
   datetime newyork = TimeArrayToTime(newyorkTimeArray)+brokerCorrection;
   
   SystemTimeToTzSpecificLocalTime(sydneyTZInfoArray, systemTimeArray, sydneyTimeArray);
   datetime sydney  = TimeArrayToTime(sydneyTimeArray)+brokerCorrection;
   
   SystemTimeToTzSpecificLocalTime(londonTZInfoArray, systemTimeArray, londonTimeArray);
   datetime london  = TimeArrayToTime(londonTimeArray)+brokerCorrection;
   
   SystemTimeToTzSpecificLocalTime(tokyoTZInfoArray, systemTimeArray, tokyoTimeArray);
   datetime tokyo   = TimeArrayToTime(tokyoTimeArray)+brokerCorrection;
      
   SystemTimeToTzSpecificLocalTime(aucklandTZInfoArray, systemTimeArray, aucklandTimeArray);
   datetime auckland   = TimeArrayToTime(aucklandTimeArray)+brokerCorrection;
      
   SystemTimeToTzSpecificLocalTime(moscowTZInfoArray, systemTimeArray, moscowTimeArray);
   datetime moscow   = TimeArrayToTime(moscowTimeArray)+brokerCorrection;
      
   SystemTimeToTzSpecificLocalTime(berlinTZInfoArray, systemTimeArray, berlinTimeArray);
   datetime berlin   = TimeArrayToTime(berlinTimeArray)+brokerCorrection;
      
   SystemTimeToTzSpecificLocalTime(seattleTZInfoArray, systemTimeArray, seattleTimeArray);
   datetime seattle   = TimeArrayToTime(seattleTimeArray)+brokerCorrection;
      
   string UTCs = TimeToString( UTC );
   string sydneys = TimeToString(sydney);
   string locals = TimeToString( localTime  );
   string londons = TimeToString( london  );
   string tokyos = TimeToString( tokyo  );
   string aucklands = TimeToString( auckland  );
   string moscows = TimeToString( moscow  );
   string berlins = TimeToString( berlin  );
   string seattles = TimeToString( seattle  );
   string newyorks = TimeToString( newyork  );
   string brokers = TimeToString( TimeCurrent() );
   
   int secondsleft = Period()*60 + Time[0] - TimeCurrent(); // FYI, this CAN go negative if a new bar hasn't formed yet!
   string bars;
   if (secondsleft >= 0) 
   {
      if (Display_Bar_With_Seconds != 0 && (Display_Bar_With_Seconds == 1 || Display_Time_With_Seconds || (Display_Bar_With_Seconds == 2 && secondsleft < 120))) bars = TimeToStr( Period()*60 + Time[0] - TimeCurrent(), TIME_MINUTES|TIME_SECONDS );
      else bars = TimeToStr( Period()*60 + Time[0] - TimeCurrent(), TIME_MINUTES );
      
      if (Suppress_Bar_HH_Below_H1 && Period() <= PERIOD_H1 && StringLen(bars) > 6) bars = StringSubstr(bars,3);
   }
   else // negative means no new bar yet formed
     {
      if (Display_Bar_With_Seconds == 0) bars = "wait"; // or "--:--"
      else bars = "wait4bar"; // or "--:--:--"; 
     }
   
   if(Show_DIBS_London)
   {
   	if (TimeDayOfWeek(london) != 0 && TimeDayOfWeek(london) != 6 && Highlight_Market_Open && TimeHour(london) >= DIBS_LondonOpenHour && TimeHour(london) < DIBS_LondonCloseHour)
   	{
   	   ObjectSetText( "dibsl", "* DIBS UK:", 10, "Arial", labelMktOpenColor );
      	ObjectSetText( "dibst", londons, 10, "Arial",clockMktOpenColor );
   	}
   	else
   	{
   	   ObjectSetText( "dibsl", "DIBS UK:", 10, "Arial", labelColor );
      	ObjectSetText( "dibst", londons, 10, "Arial",clockColor );
      }
   }
   if ( ShowLocal ) {
      ObjectSetText( "locl", "Local:", 10, "Arial", labelColor );
      ObjectSetText( "loct", locals, 10, "Arial",clockColor );
   }
   if(ShowUTC_GMT)
   {
   	ObjectSetText( "utcl", "UTC_GMT:", 10, "Arial", labelColor );
   	ObjectSetText( "utct", UTCs, 10, "Arial",clockColor );
   }
   if(ShowNewYork)
   {
   	if (TimeDayOfWeek(newyork) != 0 && TimeDayOfWeek(newyork) != 6 && Highlight_Market_Open && TimeHour(newyork) >= localOpenHour && TimeHour(newyork) < localCloseHour)
   	{
   	   ObjectSetText( "nyl", "* New York:", 10, "Arial", labelMktOpenColor );
      	ObjectSetText( "nyt", newyorks, 10, "Arial",clockMktOpenColor );
   	}
   	else
   	{
   	   ObjectSetText( "nyl", "New York:", 10, "Arial", labelColor );
      	ObjectSetText( "nyt", newyorks, 10, "Arial",clockColor );
      }
   }
   if(ShowLondon)
   {
   	if (TimeDayOfWeek(london) != 0 && TimeDayOfWeek(london) != 6 && Highlight_Market_Open && TimeHour(london) >= localOpenHour && TimeHour(london) < localCloseHour)
   	{
      	ObjectSetText( "lonl", "* London:", 10, "Arial", labelMktOpenColor );
      	ObjectSetText( "lont", londons, 10, "Arial",clockMktOpenColor );
   	}
   	else
   	{
   	   ObjectSetText( "lonl", "London:", 10, "Arial", labelColor );
   	   ObjectSetText( "lont", londons, 10, "Arial",clockColor );
   	}
   }
   if(ShowTokyo)
   {
   	if (TimeDayOfWeek(tokyo) != 0 && TimeDayOfWeek(tokyo) != 6 && Highlight_Market_Open && TimeHour(tokyo) >= localOpenHour && TimeHour(tokyo) < localCloseHour)
   	{
   	   ObjectSetText( "tokl", "* Tokyo:", 10, "Arial", labelMktOpenColor );
   	   ObjectSetText( "tokt", tokyos, 10, "Arial",clockMktOpenColor );
   	}
   	else
   	{
   	   ObjectSetText( "tokl", "Tokyo:", 10, "Arial", labelColor );
   	   ObjectSetText( "tokt", tokyos, 10, "Arial",clockColor );
   	}
   }
   if(ShowSydney)
   {
   	if (TimeDayOfWeek(sydney) != 0 && TimeDayOfWeek(sydney) != 6 && Highlight_Market_Open && TimeHour(sydney) >= sydneyLocalOpenHour && TimeHour(sydney) < sydneyLocalCloseHour)
   	{
   	   ObjectSetText( "sydl", "* Sydney:", 10, "Arial", labelMktOpenColor );
   	   ObjectSetText( "sydt", sydneys, 10, "Arial",clockMktOpenColor );
   	}
   	else
   	{
   	   ObjectSetText( "sydl", "Sydney:", 10, "Arial", labelColor );
   	   ObjectSetText( "sydt", sydneys, 10, "Arial",clockColor );
   	}
   }
   if(ShowAuckland)
   {
   	if (TimeDayOfWeek(auckland) != 0 && TimeDayOfWeek(auckland) != 6 && Highlight_Market_Open && TimeHour(auckland) >= localOpenHour && TimeHour(auckland) < localCloseHour)
   	{
   	   ObjectSetText( "auckl", "* Auckland:", 10, "Arial", labelMktOpenColor );
   	   ObjectSetText( "auckt", aucklands, 10, "Arial",clockMktOpenColor );
   	}
   	else
   	{
   	   ObjectSetText( "auckl", "Auckland:", 10, "Arial", labelColor );
   	   ObjectSetText( "auckt", aucklands, 10, "Arial",clockColor );
   	}
   }
   if(ShowMoscow)
   {
   	if (TimeDayOfWeek(moscow) != 0 && TimeDayOfWeek(moscow) != 6 && Highlight_Market_Open && TimeHour(moscow) >= localOpenHour && TimeHour(moscow) < localCloseHour)
   	{
   	   ObjectSetText( "mosl", "* Moscow:", 10, "Arial", labelMktOpenColor );
   	   ObjectSetText( "most", moscows, 10, "Arial",clockMktOpenColor );
   	}
   	else
   	{
   	   ObjectSetText( "mosl", "Moscow:", 10, "Arial", labelColor );
   	   ObjectSetText( "most", moscows, 10, "Arial",clockColor );
   	}
   }
   if(ShowBerlin)
   {
   	if (TimeDayOfWeek(berlin) != 0 && TimeDayOfWeek(berlin) != 6 && Highlight_Market_Open && TimeHour(berlin) >= localOpenHour && TimeHour(berlin) < localCloseHour)
   	{
   	   ObjectSetText( "berl", "* Berlin:", 10, "Arial", labelMktOpenColor );
   	   ObjectSetText( "bert", berlins, 10, "Arial",clockMktOpenColor );
   	}
   	else
   	{
   	   ObjectSetText( "berl", "Berlin:", 10, "Arial", labelColor );
   	   ObjectSetText( "bert", berlins, 10, "Arial",clockColor );
   	}
   }
   if(ShowSeattle)
   {
   	if (TimeDayOfWeek(seattle) != 0 && TimeDayOfWeek(seattle) != 6 && Highlight_Market_Open && TimeHour(seattle) >= localOpenHour && TimeHour(seattle) < localCloseHour)
   	{
   	   ObjectSetText( "seal", "* Seattle:", 10, "Arial", labelMktOpenColor );
   	   ObjectSetText( "seat", seattles, 10, "Arial",clockMktOpenColor );
   	}
   	else
   	{
   	   ObjectSetText( "seal", "Seattle:", 10, "Arial", labelColor );
   	   ObjectSetText( "seat", seattles, 10, "Arial",clockColor );
   	}
   }
   
   // Always display Broker Time
   ObjectSetText( "brol", "Broker:", 10, "Arial", labelColor );
   ObjectSetText( "brot", brokers, 10, "Arial",clockColor );
   
   if(Period() <= PERIOD_D1)
   {
      ObjectSetText( "barl", "Bar Left:", 10, "Arial", labelColor );
      ObjectSetText( "bart", StringConcatenate("[ ",bars," ]"), 10, "Arial",clockColor );
   }
//----
   return(0);
  } // end of start()


//+------------------------------------------------------------------+
//| Custom functions                                                 |
//+------------------------------------------------------------------+

string TimeToString( datetime when ) {
   string timeStr;
   int hour = TimeHour( when );
   if ( !Display_Times_With_AMPM ) 
     {
      if (Display_Time_With_Seconds) timeStr = (TimeToStr( when, TIME_MINUTES|TIME_SECONDS));
      else timeStr = (TimeToStr( when, TIME_MINUTES));
     }
   else
     {
      // User wants 12HourTime format with "AM" or "PM".   
      // FYI, if >12:00, subtract 12 hours in seconds which is 12*60*60=43200
      if (Display_Time_With_Seconds)
        {
         if ( hour >  12 || hour == 0) timeStr = TimeToStr( (when - 43200), TIME_MINUTES|TIME_SECONDS);
         else timeStr = TimeToStr( when, TIME_MINUTES|TIME_SECONDS);
         if ( hour >= 12) timeStr = StringConcatenate(timeStr, " PM");
         else timeStr = StringConcatenate(timeStr, " AM");
        }
      else
        {
         if ( hour >  12 || hour == 0) timeStr = TimeToStr( (when - 43200), TIME_MINUTES);
         else timeStr = TimeToStr( when, TIME_MINUTES);
         if ( hour >= 12) timeStr = StringConcatenate(timeStr, " PM");
         else timeStr = StringConcatenate(timeStr, " AM");
        }
     }
   return (timeStr);
} // end of TimeToString
//+------------------------------------------------------------------+


int ObjectMakeLabel( string n, int xoff, int yoff ) {
   ObjectCreate( n, OBJ_LABEL, 0, 0, 0 );
   ObjectSet( n, OBJPROP_CORNER, labelCorner );
   ObjectSet( n, OBJPROP_XDISTANCE, xoff );
   ObjectSet( n, OBJPROP_YDISTANCE, yoff );
   ObjectSet( n, OBJPROP_BACK, true );
} // end of ObjectMakeLabel
//+------------------------------------------------------------------+

string FormatDateTime(int nYear,int nMonth,int nDay,int nHour,int nMin,int nSec)
  {
   string sMonth,sDay,sHour,sMin,sSec;
   sMonth=100+nMonth;
   sMonth=StringSubstr(sMonth,1);
   sDay=100+nDay;
   sDay=StringSubstr(sDay,1);
   sHour=100+nHour;
   sHour=StringSubstr(sHour,1);
   sMin=100+nMin;
   sMin=StringSubstr(sMin,1);
   sSec=100+nSec;
   sSec=StringSubstr(sSec,1);
   return(StringConcatenate(nYear,".",sMonth,".",sDay," ",sHour,":",sMin,":",sSec));
} // end of FormatDateTime
//+------------------------------------------------------------------+

datetime TimeArrayToTime(int& localTimeArray[])
{
   //---- parse date and time from array
   
   int    nYear,nMonth,nDOW,nDay,nHour,nMin,nSec,nMilliSec;
   //string sMilliSec;

   nYear=localTimeArray[0]&0x0000FFFF;
   nMonth=localTimeArray[0]>>16;
   //nDOW=localTimeArray[1]&0x0000FFFF;
   nDay=localTimeArray[1]>>16;
   nHour=localTimeArray[2]&0x0000FFFF;
   nMin=localTimeArray[2]>>16;
   nSec=localTimeArray[3]&0x0000FFFF;
   nMilliSec=localTimeArray[3]>>16;
   string LocalTimeS = FormatDateTime(nYear,nMonth,nDay,nHour,nMin,nSec);
   datetime localTime = StrToTime( LocalTimeS );
   return(localTime);
} // end of TimeArrayToTime
//+------------------------------------------------------------------+

void GetAllTimeZoneInfo(int& localTZInfoArray[], int& newyorkTZInfoArray[],int& londonTZInfoArray[],int& tokyoTZInfoArray[], int& sydneyTZInfoArray[], int& aucklandTZInfoArray[], int& moscowTZInfoArray[], int& berlinTZInfoArray[], int& seattleTZInfoArray[])
{
   int dst=GetTimeZoneInformation(localTZInfoArray);
   // Note: the dst return info is no longer used.  However, FYI, the Return info is: dst =
   //  0 = Your local TZ does not switch between Std Time and DST (e.g. Tokyo, Jakarta)
   //  1 = Your local TZ does switch to DST, but is presently on ST
   //  2 = Your local TZ does switch to DST and is presently on DST
   //
   // FYI:  localTZInfoArray[n] =
   //   0 = bias, in minutes(!)    // ************* This is important and used below
   //   1-16 TZ-standard-name
   //   17-20 = StdTimeArray       // ************* This is important and used below
   //   21 = std-bias              // ************* This is important and used below
   //   22-37 = TZ-daylight-name
   //   38-41 = DaylightTimeArray  // ************* This is important and used below
   //   42 = dst-bias              // ************* This is important and used below
   
   // FYI:
   // From: http://www.tech-archive.net/Archive/DotNet/microsoft.public.dotnet.framework.interop/2005-05/msg00278.html
   //"To select the correct day in the month, set the wYear member to zero, the 
   //wHour and wMinute members to the transition time, the wDayOfWeek member to 
   //the appropriate weekday, and the wDay member to indicate the occurence of the 
   //day of the week within the month (first through fifth). 
   //
   //"Using this notation, specify the 2:00a.m. on the first Sunday in April as 
   //follows: wHour = 2, wMonth = 4, wDayOfWeek = 0, wDay = 1. Specify 2:00a.m. on 
   //the last Thursday in October as follows: wHour = 2, wMonth = 10, wDayOfWeek = 
   //4, wDay = 5."
   
   // 1<<16  = 065536 // Syntax 1<<16 is take the # and bitwise-shift it to the left 16 bits. The new (least significant) right-bits are zeros.
   // 2<<16  = 131072
   // 3<<16  = 196608
   // 4<<16  = 262144
   // 5<<16  = 327680
   // 6<<16  = 393216
   // 7<<16  = 458752
   // 8<<16  = 524288
   // 9<<16  = 589824
   // 10<<16 = 655360
   // 11<<16 = 720896
   // 12<<16 = 786432
   
   // FYI, for all the TZ ST/DST dates, the wYear=0 and wDay= the # for wDayOfWeek IN the month, e.g. wDayOfWeek=0 and wDay=1 means 1st Sunday.
   // Consequently, these numbers should be good into perpetuity, until of course, countries legistlatively change 
   // their DST/ST changeover dates. (e.g. Tokyo is considering DST, and the US changed it's dates not long ago)
   //ArrayCopy(newyorkTZInfoArray, localTZInfoArray); // Not necessary. All key fields set below.
   newyorkTZInfoArray[0] = 300;
   newyorkTZInfoArray[17] = 720896; // wYear = 0. wMonth = 11, and 11<<16 == 720896
   newyorkTZInfoArray[18] = 65536;  // wDOW = 0 = Sunday. nDay = 1 and 1<<16 == 65536 // NOTE! When wYear = 0, wDay is the # for wDOW IN the month. 1 = 1st... Sunday for example.
   newyorkTZInfoArray[19] = 2;
   newyorkTZInfoArray[20] = 0;
   newyorkTZInfoArray[21] = 0;
   newyorkTZInfoArray[38] = 196608; // 3<<16 == 196608  March
   newyorkTZInfoArray[39] = 131072; // 2<<16 == 131072  2nd Sunday
   newyorkTZInfoArray[40] = 2;
   newyorkTZInfoArray[41] = 0;
   newyorkTZInfoArray[42] = -60;
   
   londonTZInfoArray[0] = 0;
   londonTZInfoArray[17] = 655360; // 10<<16 == 655360  October
   londonTZInfoArray[18] = 327680; // 5<<16 == 327680.  5th/Last Sunday. BECAUSE this is already "5" even though in 2008 the last Sunday in Oct is the 4th Sunday, this must mean "last" Sunday.
   londonTZInfoArray[19] = 2;
   londonTZInfoArray[20] = 0;
   londonTZInfoArray[21] = 0;
   londonTZInfoArray[38] = 196608; // 3<<16 == 196608  March
   londonTZInfoArray[39] = 327680; // 5<<16 == 327680  5th/Last Sunday
   londonTZInfoArray[40] = 1;
   londonTZInfoArray[41] = 0;
   londonTZInfoArray[42] = -60;
   
   tokyoTZInfoArray[0] = -540;
   tokyoTZInfoArray[17] = 0; 
   tokyoTZInfoArray[18] = 0;
   tokyoTZInfoArray[19] = 0;
   tokyoTZInfoArray[20] = 0;
   tokyoTZInfoArray[21] = 0;
   tokyoTZInfoArray[38] = 0;
   tokyoTZInfoArray[39] = 0;
   tokyoTZInfoArray[40] = 0;
   tokyoTZInfoArray[41] = 0;
   tokyoTZInfoArray[42] = 0;
   
   sydneyTZInfoArray[0] = -600;
   sydneyTZInfoArray[17] = 262144; // 4<<16 == 262144  April
   sydneyTZInfoArray[18] = 65536;  // 1<<16 == 65536   1st Sunday
   sydneyTZInfoArray[19] = 3;
   sydneyTZInfoArray[20] = 0;
   sydneyTZInfoArray[21] = 0;
   sydneyTZInfoArray[38] = 655360; // 10<<16 == 655360  October
   sydneyTZInfoArray[39] = 65536;  // 1<<16 == 65536    1st Sunday
   sydneyTZInfoArray[40] = 2;
   sydneyTZInfoArray[41] = 0;
   sydneyTZInfoArray[42] = -60;
   
   aucklandTZInfoArray[0] = -720;
   aucklandTZInfoArray[17] = 262144; // 4<<16 == 262144  April
   aucklandTZInfoArray[18] = 65536;  // 1<<16 == 65536   1st Sunday
   aucklandTZInfoArray[19] = 3;
   aucklandTZInfoArray[20] = 0;
   aucklandTZInfoArray[21] = 0;
   aucklandTZInfoArray[38] = 589824; // 9<<16 == 589824  September
   aucklandTZInfoArray[39] = 327680; // 5<<16 == 327680  5th/Last Sunday
   aucklandTZInfoArray[40] = 2;
   aucklandTZInfoArray[41] = 0;
   aucklandTZInfoArray[42] = -60;
   
   ArrayCopy(moscowTZInfoArray, londonTZInfoArray);
   moscowTZInfoArray[0] = -180;
   
   ArrayCopy(berlinTZInfoArray, londonTZInfoArray);
   berlinTZInfoArray[0] = -60;
   
   ArrayCopy(seattleTZInfoArray, newyorkTZInfoArray);
   seattleTZInfoArray[0] = 480;
} // end of GetAllTimeZoneInfo
//+------------------------------------------------------------------+

void writeLocalTZInfoToFile(string filename, bool AllTZData)
{
   int    TimeArray[4];
   int    TZInfoArray[43];
   int    z[43];
   int dst=GetTimeZoneInformation(z);
   
   if (ObjectFind("timezone") < 0)
   {
      Alert(WindowExpertName(),": Open your Terminal window. Go to Experts tab for timezone update instructions!");
      Print(WindowExpertName(),": If the market zone ST/DST changeover dates change, or to ADD a new market zone, do these steps!");
      Print("... First check for any program updates at: http://forexfactory.com/showthread.php?t=109305");
      Print("... If no update, you can start editing the version you already have.");
      Print("... First temporarily set your CPU clock to the newyork Eastern US timezone.");
      Print("... Next create a text. Make the name 'timezone'. Make the description 'newyork'.");
      Print("... Change chart period JUST ONCE -- the file will be appended each change!");
      Print("... Repeat steps to change CPU clock and text for GMT, Tokyo, Sydney, etc.");
      Print("... Start Excel. Open a blank file. Go to Data => Import External Data => Import Data");
      Print("... Import the file: ",TerminalPath(),"\x5Cexperts\x5Cfiles\x5C",filename);
      Print("... The file is Tab delimited and should provide simple readable columns of data");
      Print("... In MetaEditor, open: ",WindowExpertName(),".mq4, search for: newyorkTZInfoArray[17]"); 
      Print("... Change all array values for all timezones according to your Excel spreadsheet");
      Print("... If you THOUGHT you just wrote data but you see this, you missed a step.");
      Print("... Check your text name/description and try again...");
      Print("... When finished... change CPU clock back to normal. Change the timezone update boolean back to FALSE");
      return(0);
   }
   string tzname = ObjectDescription("timezone");
   
   int handle;
   handle = FileOpen(filename,FILE_READ,"\t");
   if (handle<0)
   {
      // If file does not exist, open new file and write a single line with column labels and then close it.
      handle = FileOpen(filename,FILE_CSV|FILE_READ|FILE_WRITE,"\t");
      if(handle<0) 
        {
         Print(filename," OPEN Error: ",GetLastError());
         return(0);
        }
      else FileSeek(handle,0,SEEK_END);
   
      if (AllTZData) 
      {
         FileWrite(handle, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,"tzname");
      }
      else 
      {
         FileWrite(handle, 0,17,18,19,20,21,38,39,40,41,42,"tzname");
      }
      FileClose(handle);
   }
   
   // File should exist by now.
   handle = FileOpen(filename,FILE_CSV|FILE_READ|FILE_WRITE,"\t");
   if(handle<0) 
     {
      Print(filename," OPEN Error: ",GetLastError());
      return(0);
     }
   else FileSeek(handle,0,SEEK_END);
   
   if (AllTZData)
   {
      FileWrite(handle, z[0], z[1], z[2], z[3], z[4], z[5], z[6], z[7], z[8], z[9], z[10], z[11], z[12], z[13], z[14], z[15], z[16], z[17], z[18], z[19],
         z[20], z[21], z[22], z[23], z[24], z[25], z[26], z[27], z[28], z[29], z[30], z[31], z[32], z[33], z[34], z[35], z[36], z[37], z[38], z[39], z[40], z[41], z[42], tzname);
   }
   else
   {
      FileWrite(handle, z[0], z[17], z[18], z[19], z[20], z[21], z[38], z[39], z[40], z[41], z[42], tzname);
   
   }
   FileClose(handle);
   Print(WindowExpertName(),": ",tzname," data written to ",TerminalPath(),"\x5Cexperts\x5Cfiles\x5C",filename);
} // end of writeLocalTZInfoToFile


//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   if(ShowLocal)
   {
      ObjectDelete( "locl" );
      ObjectDelete( "loct" );
   }
   if(ShowNewYork)
   {
   	ObjectDelete( "nyl" );
   	ObjectDelete( "nyt" );
   }
   if(ShowUTC_GMT)
   {
	   ObjectDelete( "utcl" );
   	ObjectDelete( "utct" );
   }
   if(ShowLondon)
   {
   	ObjectDelete( "lonl" );
   	ObjectDelete( "lont" );
   }
   if(ShowTokyo)
   {
	   ObjectDelete( "tokl" );
   	ObjectDelete( "tokt" );
   }
   if(ShowSydney)
   {
	   ObjectDelete( "sydl" );
   	ObjectDelete( "sydt" );
   }
   // Broker time is always displayed so remove objects 
   ObjectDelete( "brol" );
   ObjectDelete( "brot" );
   // Bar Left time is always displayed so remove objects 
   ObjectDelete( "barl" );
   ObjectDelete( "bart" );
   if(Show_DIBS_London)
   {
   	ObjectDelete( "dibsl" );
   	ObjectDelete( "dibst" );
   }
   if(ShowAuckland)
   {
   	ObjectDelete( "auckl" );
   	ObjectDelete( "auckt" );
   }
   if(ShowMoscow)
   {
   	ObjectDelete( "mosl" );
   	ObjectDelete( "most" );
   }
   if(ShowBerlin)
   {
   	ObjectDelete( "berl" );
   	ObjectDelete( "bert" );
   }
   if(ShowSeattle)
   {
   	ObjectDelete( "seal" );
   	ObjectDelete( "seat" );
   }

//----
   return(0);
  } // end of deinit()

