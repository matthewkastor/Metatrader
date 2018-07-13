//+------------------------------------------------------------------+
//|                                                                  |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property description "Tests functionality of the Schedule class."
#property strict
//#property script_show_inputs
#include <Schedule\Schedule.mqh>

ENUM_DAY_OF_WEEK StartDay=1;//Start Day
ENUM_DAY_OF_WEEK EndDay=5;//End Day
string   StartTime="12:30";//Start Time
string   EndTime="14:30";//End Time
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   Schedule s(StartDay,StartTime,EndDay,EndTime);
   Print("Schedule : ",s.ToString());

   datetime ted0 = StrToTime(StringConcatenate("2018.06.10 ", (string)(s.TimeEnd.Hour), ":", (string)(s.TimeEnd.Minute)));
   datetime ted1 = StrToTime(StringConcatenate("2018.06.11 ", (string)(s.TimeEnd.Hour), ":", (string)(s.TimeEnd.Minute)));
   datetime ted2 = StrToTime(StringConcatenate("2018.06.12 ", (string)(s.TimeEnd.Hour), ":", (string)(s.TimeEnd.Minute)));
   datetime ted3 = StrToTime(StringConcatenate("2018.06.13 ", (string)(s.TimeEnd.Hour), ":", (string)(s.TimeEnd.Minute)));
   datetime ted4 = StrToTime(StringConcatenate("2018.06.14 ", (string)(s.TimeEnd.Hour), ":", (string)(s.TimeEnd.Minute)));
   datetime ted5 = StrToTime(StringConcatenate("2018.06.15 ", (string)(s.TimeEnd.Hour), ":", (string)(s.TimeEnd.Minute)));
   datetime ted6 = StrToTime(StringConcatenate("2018.06.16 ", (string)(s.TimeEnd.Hour), ":", (string)(s.TimeEnd.Minute)));

   datetime te0 = StrToTime(StringConcatenate("2018.06.11 ", (string)(s.TimeEnd.Hour), ":", (string)(s.TimeEnd.Minute)));
   datetime te1 = StrToTime(StringConcatenate("2018.06.11 ", (string)(s.TimeEnd.Hour), ":", (string)(s.TimeEnd.Minute + 1)));
   datetime te2 = StrToTime(StringConcatenate("2018.06.11 ", (string)(s.TimeEnd.Hour), ":", (string)(s.TimeEnd.Minute - 1)));
   datetime te3 = StrToTime(StringConcatenate("2018.06.11 ", (string)(s.TimeEnd.Hour - 1), ":", (string)(s.TimeEnd.Minute + 1)));
   datetime te4 = StrToTime(StringConcatenate("2018.06.11 ", (string)(s.TimeEnd.Hour - 1), ":", (string)(s.TimeEnd.Minute - 1)));
   datetime te5 = StrToTime(StringConcatenate("2018.06.11 ", (string)(s.TimeEnd.Hour + 1), ":", (string)(s.TimeEnd.Minute + 1)));
   datetime te6 = StrToTime(StringConcatenate("2018.06.11 ", (string)(s.TimeEnd.Hour + 1), ":", (string)(s.TimeEnd.Minute - 1)));

   datetime ts0 = StrToTime(StringConcatenate("2018.06.11 ", (string)(s.TimeStart.Hour), ":", (string)(s.TimeStart.Minute)));
   datetime ts1 = StrToTime(StringConcatenate("2018.06.11 ", (string)(s.TimeStart.Hour), ":", (string)(s.TimeStart.Minute + 1)));
   datetime ts2 = StrToTime(StringConcatenate("2018.06.11 ", (string)(s.TimeStart.Hour), ":", (string)(s.TimeStart.Minute - 1)));
   datetime ts3 = StrToTime(StringConcatenate("2018.06.11 ", (string)(s.TimeStart.Hour - 1), ":", (string)(s.TimeStart.Minute + 1)));
   datetime ts4 = StrToTime(StringConcatenate("2018.06.11 ", (string)(s.TimeStart.Hour - 1), ":", (string)(s.TimeStart.Minute - 1)));
   datetime ts5 = StrToTime(StringConcatenate("2018.06.11 ", (string)(s.TimeStart.Hour + 1), ":", (string)(s.TimeStart.Minute + 1)));
   datetime ts6 = StrToTime(StringConcatenate("2018.06.11 ", (string)(s.TimeStart.Hour + 1), ":", (string)(s.TimeStart.Minute - 1)));

   if(s.IsActive(ted0)) Print("Fail! Schedule active at ",ted0," = ",s.IsActive(ted0));
   if(!s.IsActive(ted1)) Print("Fail! Schedule active at ", ted1, " = ", s.IsActive(ted1));
   if(!s.IsActive(ted2)) Print("Fail! Schedule active at ", ted2, " = ", s.IsActive(ted2));
   if(!s.IsActive(ted3)) Print("Fail! Schedule active at ", ted3, " = ", s.IsActive(ted3));
   if(!s.IsActive(ted4)) Print("Fail! Schedule active at ", ted4, " = ", s.IsActive(ted4));
   if(!s.IsActive(ted5)) Print("Fail! Schedule active at ", ted5, " = ", s.IsActive(ted5));
   if(s.IsActive(ted6)) Print("Fail! Schedule active at ",ted6," = ",s.IsActive(ted6));

   if(!s.IsActive(te0)) Print("Fail! Schedule active at ",te0," = ",s.IsActive(te0));
   if(s.IsActive(te1)) Print("Fail! Schedule active at ",te1," = ",s.IsActive(te1));
   if(!s.IsActive(te2)) Print("Fail! Schedule active at ", te2, " = ", s.IsActive(te2));
   if(!s.IsActive(te3)) Print("Fail! Schedule active at ", te3, " = ", s.IsActive(te3));
   if(!s.IsActive(te4)) Print("Fail! Schedule active at ", te4, " = ", s.IsActive(te4));
   if(s.IsActive(te5)) Print("Fail! Schedule active at ", te5, " = ", s.IsActive(te5));
   if(s.IsActive(te6)) Print("Fail! Schedule active at ", te6, " = ", s.IsActive(te6));

   if(!s.IsActive(ts0)) Print("Fail! Schedule active at ", ts0, " = ", s.IsActive(ts0));
   if(!s.IsActive(ts1)) Print("Fail! Schedule active at ", ts1, " = ", s.IsActive(ts1));
   if(s.IsActive(ts2)) Print("Fail! Schedule active at ", ts2, " = ", s.IsActive(ts2));
   if(s.IsActive(ts3)) Print("Fail! Schedule active at ", ts3, " = ", s.IsActive(ts3));
   if(s.IsActive(ts4)) Print("Fail! Schedule active at ", ts4, " = ", s.IsActive(ts4));
   if(!s.IsActive(ts5)) Print("Fail! Schedule active at ", ts5, " = ", s.IsActive(ts5));
   if(!s.IsActive(ts6)) Print("Fail! Schedule active at ", ts6, " = ", s.IsActive(ts6));
   Print("If there are no failure messages then the scheduler is working as expected");
   Comment("Check the Experts tab of the Terminal window for test results");
  }
//+------------------------------------------------------------------+
