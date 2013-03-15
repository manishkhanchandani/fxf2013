#define   FileName       "Ranger"
#define   Version        "1.0.3"
#define   Created        "2010-08-06"
#define   Author         "S. Richard Holloway" // srh@quantivgroup.com

// THE CODE CONTAINED WITHIN THIS PROGRAM IS A WORK FOR HIRE AND IS NOT OWNED BY THE AUTHOR
// The properties below should be updated according to the owners requirements
#property link           "http://"
#property copyright      "©2010"

// THIS INDICATOR OUTPUTS THE AVERAGE HOURLY RANGE TO THE FILE [metatrader4]\experts\RangerOutput.csv

#property indicator_chart_window

// VERSION 1.0.0 RELEASE DATE 2010-08-09

// Changes for this version
// ----------------------------
//  1. Added HUD [beta 2]
//  2. Added window handler to object names [beta 3]
//  3. Added TableSize parameter (small, medium, large) [beta 3]
//  4. Added ColorScheme parameter (Original, NewBlackBG, NewWhiteBG) [beta 3]
//  5. Added window handler to file names [beta 3]
//  6. Fixed error with averaging counter [beta 3]
//  7. Added TestMode and changed time parameters to enable backtesting [beta 3]
//  8. Fixed problem with last trade hour on Friday [beta 4]
//  9. Added options to hide Saturday and Sunday columns [beta 5]
// 10. Added column for hourly range over the last 24 hours [beta 5]
// 11. Fixed error is calculation of current hour range in 24 hour column [1.0.0]
// 12. Fixed error in LastHour initialization value [1.0.1]
// 13. Fixed error in current hour exclusion from average calculation [1.0.2]
// 14. Fixed reverse order error in 24 hour column [1.0.2]
// ============================

// Include headers
// ----------------------------
// ============================

// Define constants
// ----------------------------
// ============================

// Declare external variables
// ----------------------------
   extern int   Days=30; // maximum is 999
   extern int   TableSize=1; // 0=Small, 1=Medium, 2=Large
   extern int   ColorScheme=2; // 0=Original, 1=NewBlackBG, 2=NewWhiteBG
   extern bool  ShowSat=false; // false removes the Saturday column
   extern bool  ShowSun=true; // false removes the Sunday column
   
   // These need to be set according to the trader server used
   extern bool  LastTradeAdjust=true; // This must be true if the server does not trade 7 days per week
   extern int   LastTradeHour=22; // [0..23]
   extern int   LastTradeDay=5; // 0=Sunday, [1..5], 6=Saturday
   
   // Other settings
   extern bool  TestMode=false; // Set to true if using in backtester
   extern bool  debug=false; // if true, full array is output as RangerArray.csv
   
// ============================

// Declare global variables
// ----------------------------
// ============================

// Declare program local variables
// ----------------------------
   int   Range[120][24];
   int   RangeDay[120];
   int   AverageRange[9][24];
   int   AverageRangeCount[8][24];
   int   LastHour=-1;
   int   lb=-1;
   int   ld=-1;
   int   fh[3];
   string HourLabel[24];
   int   win;
   color HUD1, HUD2, HUD3, HUD4, HUD5, HUD6, HUD7;
   int   WeekStart=0;
   int   WeekEnd=7;
   
// ============================

int init() {
   IndicatorShortName("Ranger");
   win=WindowHandle(Symbol(),0);
   
   // Input variable error checking...
   if (Days<1 || Days>999) {
      Days=30;
      Print ("The input Days must be between 1 and 999.  Days has been reset to the default value of 30.");
   }
   if (TableSize<0 || TableSize>2) {
      TableSize=1;
      Print ("The input TableSize must be 0=Small, 1=Medium, or 2=Large.  TableSize has been reset to the default value of 1.");
   }
   if (ColorScheme<0 || ColorScheme>2) {
      ColorScheme=2;
      Print ("The input ColorScheme must be 0=Original, 1=NewBlackBG, or 2=NewWhiteBG.  ColorScheme has been reset to the default value of 2.");
   }
   
   // Here we open the *.csv file needed for writing the output table
   fh[0]=FileOpen(win+"RangerOutput["+Symbol()+"].csv",FILE_CSV|FILE_WRITE,',');
   if (fh[0]==-1) Print("Error opening output file (",GetLastError(),")");
   // If debug is set to true, we are going to open a second file to dump the full range array
   if (debug) {
      fh[1]=FileOpen(win+"RangerArray["+Symbol()+"].csv",FILE_CSV|FILE_WRITE,',');
      if (fh[1]==-1) Print("Error opening output file (",GetLastError(),")");
   }
   
   // Setup the hour labels
   HourLabel[0] ="12:00AM-01:00AM";
   HourLabel[1] ="01:00AM-02:00AM";
   HourLabel[2] ="02:00AM-03:00AM";
   HourLabel[3] ="03:00AM-04:00AM";
   HourLabel[4] ="04:00AM-05:00AM";
   HourLabel[5] ="05:00AM-06:00AM";
   HourLabel[6] ="06:00AM-07:00AM";
   HourLabel[7] ="07:00AM-08:00AM";
   HourLabel[8] ="08:00AM-09:00AM";
   HourLabel[9] ="09:00AM-10:00AM";
   HourLabel[10]="10:00AM-11:00AM";
   HourLabel[11]="11:00AM-12:00AM";
   HourLabel[12]="12:00AM-01:00PM";
   HourLabel[13]="01:00PM-02:00PM";
   HourLabel[14]="02:00PM-03:00PM";
   HourLabel[15]="03:00PM-04:00PM";
   HourLabel[16]="04:00PM-05:00PM";
   HourLabel[17]="05:00PM-06:00PM";
   HourLabel[18]="06:00PM-07:00PM";
   HourLabel[19]="07:00PM-08:00PM";
   HourLabel[20]="08:00PM-09:00PM";
   HourLabel[21]="09:00PM-10:00PM";
   HourLabel[22]="10:00PM-11:00PM";
   HourLabel[23]="11:00PM-12:00PM";
   
   // ColorScheme setup for HUD
   switch (ColorScheme) {
      case 0: HUD1=White; HUD2=Goldenrod; HUD3=Yellow; HUD4=DarkTurquoise; HUD5=PaleTurquoise; HUD6=White; HUD7=Chartreuse; break;
      case 1: HUD1=White; HUD2=DarkGray; HUD3=RoyalBlue; HUD4=Red; HUD5=Pink; HUD6=White; HUD7=MediumOrchid; break;
      case 2: HUD1=Black; HUD2=DimGray; HUD3=DarkSlateBlue; HUD4=Red; HUD5=Maroon; HUD6=Black; HUD7=Green; break;
   }
   
   // TableSize variable setup for HUD
   int fs, dx1, dx2, dx3, xpos, dy1, dy2, ypos;
   switch (TableSize) {
      case 0: fs=7; dx1=25; dx2=30; dx3=5; xpos=256; dy1=6; dy2=12; ypos=40; break;
      case 1: fs=9; dx1=35; dx2=40; dx3=8; xpos=352; dy1=9; dy2=15; ypos=45; break;
      case 2: fs=11; dx1=40; dx2=48; dx3=8; xpos=400; dy1=12; dy2=18; ypos=50; break;
   }
   
   // Objects setup for the HUD
   if (!ShowSun) xpos-=dx1;
   if (!ShowSat) xpos-=dx1;
   int x=15;
   int y=10;
   string ObjName;
   ObjName=win+"-HUD-RangerTitle"; ObjectCreate(ObjName,23,0,0,0); ObjectSetText(ObjName,"RANGER HUD",fs,"Lucida Console",HUD1); ObjectSet(ObjName,101,1); ObjectSet(ObjName,102,x); ObjectSet(ObjName,103,y);
   y+=dy2;
   ObjName=win+"-HUD-RangerUpdate"; ObjectCreate(ObjName,23,0,0,0); ObjectSetText(ObjName,"Last Updated: "+TimeToStr(iTime(Symbol(),60,0)),fs,"Lucida Console",HUD1); ObjectSet(ObjName,101,1); ObjectSet(ObjName,102,x); ObjectSet(ObjName,103,y);
   
   // HOUR column
   x=xpos;
   y=ypos;
   ObjName=win+"-HUD-HourTitle"; ObjectCreate(ObjName,23,0,0,0); ObjectSetText(ObjName,"     HOUR      ",fs,"Lucida Console",HUD2); ObjectSet(ObjName,101,1); ObjectSet(ObjName,102,x); ObjectSet(ObjName,103,y);
   y+=dy1;
   ObjName=win+"-HUD-HourTitleBorder"; ObjectCreate(ObjName,23,0,0,0); ObjectSetText(ObjName,"---------------",fs,"Lucida Console",HUD2); ObjectSet(ObjName,101,1); ObjectSet(ObjName,102,x); ObjectSet(ObjName,103,y);
   y+=dy2;
   for (int i=0; i<24; i++) {
      ObjName=win+"-HUD-HourLabel"+i;
      ObjectCreate(ObjName,23,0,0,0);
      ObjectSetText(ObjName,HourLabel[i],fs,"Lucida Console",HUD2);
      ObjectSet(ObjName,101,1);
      ObjectSet(ObjName,102,x);
      ObjectSet(ObjName,103,y);
      y+=dy2;
   }
   // Day columns
   string DAY;
   x-=dx2;
   if (!ShowSun) WeekStart=1;
   if (!ShowSat) WeekEnd=6;
   for (int d=WeekStart; d<WeekEnd; d++) {
      y=ypos;
      switch (d) {
         case 0:  DAY="SUN"; break;
         case 1:  DAY="MON"; break;
         case 2:  DAY="TUE"; break;
         case 3:  DAY="WED"; break;
         case 4:  DAY="THU"; break;
         case 5:  DAY="FRI"; break;
         case 6:  DAY="SAT"; break;
      }
      ObjName=win+"-HUD-"+DAY+"Title"; ObjectCreate(ObjName,23,0,0,0); ObjectSetText(ObjName," "+DAY+" ",fs,"Lucida Console",HUD2); ObjectSet(ObjName,101,1); ObjectSet(ObjName,102,x); ObjectSet(ObjName,103,y);
      y+=dy1;
      ObjName=win+"-HUD-"+DAY+"TitleBorder"; ObjectCreate(ObjName,23,0,0,0); ObjectSetText(ObjName,"-----",fs,"Lucida Console",HUD2); ObjectSet(ObjName,101,1); ObjectSet(ObjName,102,x); ObjectSet(ObjName,103,y);
      y+=dy2;
      for (i=0; i<24; i++) {
         ObjName=win+"-HUD-"+DAY+"Value"+i;
         ObjectCreate(ObjName,23,0,0,0);
         ObjectSetText(ObjName,"0 ",fs,"Lucida Console",HUD2);
         ObjectSet(ObjName,101,1);
         ObjectSet(ObjName,102,x);
         ObjectSet(ObjName,103,y);
         y+=dy2;
      }
      x-=dx1;
   }
   // Summary column
   x-=dx3;
   y=ypos;
   string Sum;
   if (Days<100) Sum=" "+Days; else Sum=Days;
   ObjName=win+"-HUD-SummaryTitle"; ObjectCreate(ObjName,23,0,0,0); ObjectSetText(ObjName,"["+Sum+"]",fs,"Lucida Console",HUD3); ObjectSet(ObjName,101,1); ObjectSet(ObjName,102,x); ObjectSet(ObjName,103,y);
   y+=dy1;
   ObjName=win+"-HUD-SummaryTitleBorder"; ObjectCreate(ObjName,23,0,0,0); ObjectSetText(ObjName,"-----",fs,"Lucida Console",HUD3); ObjectSet(ObjName,101,1); ObjectSet(ObjName,102,x); ObjectSet(ObjName,103,y);
   y+=dy2;
   for (i=0; i<24; i++) {
      ObjName=win+"-HUD-SummaryValue"+i;
      ObjectCreate(ObjName,23,0,0,0);
      ObjectSetText(ObjName,"0 ",fs,"Lucida Console",HUD3);
      ObjectSet(ObjName,101,1);
      ObjectSet(ObjName,102,x);
      ObjectSet(ObjName,103,y);
      y+=dy2;
   }
   // 24 Hour column
   x-=(dx1+dx3);
   y=ypos;
   ObjName=win+"-HUD-24HourTitle"; ObjectCreate(ObjName,23,0,0,0); ObjectSetText(ObjName,"24-HR",fs,"Lucida Console",HUD7); ObjectSet(ObjName,101,1); ObjectSet(ObjName,102,x); ObjectSet(ObjName,103,y);
   y+=dy1;
   ObjName=win+"-HUD-24HourTitleBorder"; ObjectCreate(ObjName,23,0,0,0); ObjectSetText(ObjName,"-----",fs,"Lucida Console",HUD7); ObjectSet(ObjName,101,1); ObjectSet(ObjName,102,x); ObjectSet(ObjName,103,y);
   y+=dy2;
   for (i=0; i<24; i++) {
      ObjName=win+"-HUD-24HourValue"+i;
      ObjectCreate(ObjName,23,0,0,0);
      ObjectSetText(ObjName,"0 ",fs,"Lucida Console",HUD7);
      ObjectSet(ObjName,101,1);
      ObjectSet(ObjName,102,x);
      ObjectSet(ObjName,103,y);
      y+=dy2;
   }
   WindowRedraw();
   
   return(0);
}

int start() {
   // We want to update the table every hour, so here we will determine if we have reached a new hour
   datetime Now;
   if (TestMode) Now=iTime(Symbol(),60,0); else Now=TimeCurrent();
   int CurrentHour=TimeHour(Now);
   if (CurrentHour!=LastHour) {
   
      //if (TestMode) Now+=1800;
      
      // First, we need to clear out the averaging array from the last hour
      ArrayInitialize(Range,0);
      ArrayInitialize(RangeDay,0);
      ArrayInitialize(AverageRange,0);
      ArrayInitialize(AverageRangeCount,0);
      
      // In order to capture the full range of days, we are going to countdown from the current time
      // to the same time on the last day of the specified range
      int j=Now-60*60*24*Days;
      
      // Declare a couple of variables we will need...
      int k=0, d, h, b;
      
      // Now we start the countdown loop.  We will use intervals of 1200 second (20 minutes) to make it quick,
      // but also make sure we don't miss any hours
      for (int i=Now; i>j; i-=1200) {
      
         // In MQL4, each day of the week has a number (0=Sunday.. 6=Saturday).  We will need this later for our daily summary
         d=TimeDayOfWeek(i);
         
         // Now we check whether we have count down to a new day
         if (d!=ld) {
            k++; // this is our serial day increment
            RangeDay[k]=d; // here we link the serial day to the day of week number
            ld=d; // if it is a new day, we want to set our test variable for future checks
         }
         
         // Here we get the hour for the count down time
         h=TimeHour(i);
         
         // Using the hour, we now grab the PERIOD_H1 bar number for that hour
         b=iBarShift(Symbol(),60,i,false);
         
         // If the server doesn't trade 7 days per week, this is needed to reset the bar test variable
         if (LastTradeAdjust && h==LastTradeHour && d==LastTradeDay) lb=-1;
            
         // If our count down hour is in a new bar, we want to calculate a new range value
         if (b!=lb) {
         
            // Here we calculate the pip range for the selected hour bar
            Range[k][h]=(iHigh(Symbol(),60,b)-iLow(Symbol(),60,b))/Point;
            
            // If debug is true, we want to dump the entire range array
            if (debug) FileWrite(fh[1],k,RangeDay[k],h,b,Range[k][h]);
            
            // reset our bar test variable for future checks
            lb=b;
         }
      }
   
      // Ok, now we need to collect our data our of the range array and calculate the averages
   
      // We are going to put the averages in the AverageRange array according to the day of week number
      for (i=1; i<=k; i++) {
         
         // Scheme to exclude current hour from range average calculation
         int g; 
         if (i==1) g=TimeHour(Now)+1; else g=0;
         
         for (h=g; h<24; h++) {
            
            // Here we are simply adding the ranges for all the same days of the week across the full range of days specified
            AverageRange[RangeDay[i]][h]+=Range[i][h];
         
            // if we added a non-zero value, we need to increment the counter to calculate the correct average
            if (Range[i][h]>0) AverageRangeCount[RangeDay[i]][h]++;
         }
      }
   
      // Here we increment through each day of week and each hour and calculate the average pip range
      for (i=0; i<7; i++) {
         for (h=0; h<24; h++) {
         
            // In order to round the average properly, we need to force double type division (MQL4 is a bit rudimentary here)
            if (AverageRangeCount[i][h]>0) AverageRange[i][h]=NormalizeDouble(1.0*AverageRange[i][h]/(1.0*AverageRangeCount[i][h]),0);
         }
      }
   
      // Now that we have the averages for each day of week, we will calculate the total average across the day range
      // and put this values in the last column of the array
      for (i=0; i<=6; i++) {
         for (h=0; h<24; h++) {
      
            // Sum the daily averages
            AverageRange[7][h]+=AverageRange[i][h];
         
            // Coun the non-zero values
            if (AverageRange[i][h]>0) AverageRangeCount[7][h]++;
         }
      }
   
      // Increment through each hour
      for (h=0; h<24; h++) {
   
         // Calculate the average using force double type division
         if (AverageRangeCount[7][h]>0) AverageRange[7][h]=NormalizeDouble(1.0*AverageRange[7][h]/(1.0*AverageRangeCount[7][h]),0);
      
         // Add ranges for last 24 hours
         
         //*************************************************
         int b24=TimeHour(Now)-h;
         if (b24<0) b24+=24;
         AverageRange[8][h]=(iHigh(Symbol(),60,b24)-iLow(Symbol(),60,b24))/Point;
         
      }
   
      // Output the AverageRange array to the HUD
      string DAY;
      string ObjName;
      string ObjValue;
      for (i=WeekStart; i<WeekEnd; i++) {
         switch (i) {
            case 0:  DAY="SUN"; break;
            case 1:  DAY="MON"; break;
            case 2:  DAY="TUE"; break;
            case 3:  DAY="WED"; break;
            case 4:  DAY="THU"; break;
            case 5:  DAY="FRI"; break;
            case 6:  DAY="SAT"; break;
         }
         for (h=0; h<24; h++) {
            ObjName=win+"-HUD-"+DAY+"Value"+h;
            ObjValue=AverageRange[i][h]+" ";
            if (i==TimeDayOfWeek(Now)) {
               ObjectSet(win+"-HUD-"+DAY+"Title",6,HUD4);
               ObjectSet(win+"-HUD-"+DAY+"TitleBorder",6,HUD4);
               ObjectSet(ObjName,6,HUD4);
               if (!ObjectSetText(ObjName,ObjValue)) Print("Error("+GetLastError()+")");
            } else {
               ObjectSet(win+"-HUD-"+DAY+"Title",6,HUD2);
               ObjectSet(win+"-HUD-"+DAY+"TitleBorder",6,HUD2);
               ObjectSet(ObjName,6,HUD2);
               if (!ObjectSetText(ObjName,ObjValue)) Print("Error("+GetLastError()+")");
            }
            if (h==TimeHour(Now)) {
               ObjectSet(win+"-HUD-HourLabel"+h,6,HUD4);
               ObjectSet(ObjName,6,HUD4);
            } else {
               ObjectSet(win+"-HUD-HourLabel"+h,6,HUD2);
            }
            if (i==TimeDayOfWeek(Now) && h==TimeHour(Now)) ObjectSet(ObjName,6,HUD5);
         }
      }
      for (h=0; h<24; h++) {
      
         // Output summary values
         ObjName=win+"-HUD-SummaryValue"+h;
         ObjValue=AverageRange[7][h]+" ";
         if (!ObjectSetText(ObjName,ObjValue)) Print("Error("+GetLastError()+")");
         if (h==TimeHour(Now)) ObjectSet(ObjName,6,HUD6); else ObjectSet(ObjName,6,HUD3);
         
         // Output 24 hour values
         ObjName=win+"-HUD-24HourValue"+h;
         ObjValue=AverageRange[8][h]+" ";
         if (!ObjectSetText(ObjName,ObjValue)) Print("Error("+GetLastError()+")");
         if (h==TimeHour(Now)) ObjectSet(ObjName,6,HUD6); else ObjectSet(ObjName,6,HUD7);
      }
      ObjectSetText(win+"-HUD-RangerUpdate","Last Updated: "+TimeToStr(Now));
      WindowRedraw();
   
      // Now we are ready to output the table
      if (fh[0]>=0) {
   
         // First we will set up a header in the .csv file
         FileWrite(fh[0],"AVERAGE HOURLY RANGE (in PIPs)");
         FileWrite(fh[0],Symbol(),"( "+Digits+" DIGIT PRICING)");
         FileWrite(fh[0],"Last updated at "+TimeToStr(Now));
         FileWrite(fh[0],"Hour","Sun","Mon","Tue","Wed","Thu","Fri","Sat",Days+" Day Range","24 Hour");
      
         // Now we output the rows containing the daily averages, and the symbol average for the entire day range (in the last column)
         for (h=0; h<24; h++) FileWrite(fh[0],HourLabel[h],AverageRange[0][h],AverageRange[1][h],AverageRange[2][h],AverageRange[3][h],AverageRange[4][h],AverageRange[5][h],AverageRange[6][h],AverageRange[7][h],AverageRange[8][h]);
      }
   
      // reset our hour test variable for future checks
      LastHour=CurrentHour;
   }
   
   // Update current range with every tick
   h=TimeHour(Now);
   AverageRange[8][h]=(iHigh(Symbol(),60,0)-iLow(Symbol(),60,0))/Point;
   ObjName=win+"-HUD-24HourValue"+h;
   ObjValue=AverageRange[8][h]+" ";
   if (!ObjectSetText(ObjName,ObjValue)) Print("Error("+GetLastError()+")");
   WindowRedraw();
   
   return;
}

int deinit() {
   
   // Just a little housekeeping to close the output files
   FileClose(fh[0]);
   if (debug) FileClose(fh[1]);
   
   // Housekeeping to remove HUD objects
   ObjectDelete(win+"-HUD-RangerTitle");
   ObjectDelete(win+"-HUD-RangerUpdate");
   ObjectDelete(win+"-HUD-HourTitle");
   ObjectDelete(win+"-HUD-HourTitleBorder");
   for (int i=0; i<24; i++) {
      ObjectDelete(win+"-HUD-HourLabel"+i);
   }
   string DAY;
   for (int d=WeekStart; d<WeekEnd; d++) {
      switch (d) {
         case 0:  DAY="SUN"; break;
         case 1:  DAY="MON"; break;
         case 2:  DAY="TUE"; break;
         case 3:  DAY="WED"; break;
         case 4:  DAY="THU"; break;
         case 5:  DAY="FRI"; break;
         case 6:  DAY="SAT"; break;
      }
      ObjectDelete(win+"-HUD-"+DAY+"Title");
      ObjectDelete(win+"-HUD-"+DAY+"TitleBorder");
      for (i=0; i<24; i++) {
         ObjectDelete(win+"-HUD-"+DAY+"Value"+i);
      }
   }
   ObjectDelete(win+"-HUD-SummaryTitle");
   ObjectDelete(win+"-HUD-SummaryTitleBorder");
   for (i=0; i<24; i++) {
      ObjectDelete(win+"-HUD-SummaryValue"+i);
   }
   ObjectDelete(win+"-HUD-24HourTitle");
   ObjectDelete(win+"-HUD-24HourTitleBorder");
   for (i=0; i<24; i++) {
      ObjectDelete(win+"-HUD-24HourValue"+i);
   }
   
   // Clear any comments used in debugging
   Comment("");
   
   return(0);
}

