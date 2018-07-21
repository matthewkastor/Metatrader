//+------------------------------------------------------------------+
//|                                             ScheduleSetTests.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Schedule\ScheduleSet.mqh>
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   ENUM_DAY_OF_WEEK day=MONDAY;
   string startTime="08:00";
   string endTime="17:00";
   string onTime=startTime;
   string offTime="17:01";

   datetime sun_not_on=StrToTime(StringConcatenate("2018.07.15 ",onTime));
   datetime sun_off=StrToTime(StringConcatenate("2018.07.15 ",offTime));

   datetime fri_on=StrToTime(StringConcatenate("2018.07.20 ",onTime));
   datetime fri_off=StrToTime(StringConcatenate("2018.07.20 ",offTime));

   ScheduleSet *s=new ScheduleSet();
// adding 260 start and stop times to profile with (5 * 52)
   int c;
   for(c=0;c<(52);c++)
     {
      day=MONDAY;
      s.Add(new Schedule(day,startTime,day,endTime));
      day=TUESDAY;
      s.Add(new Schedule(day,startTime,day,endTime));
      day=WEDNESDAY;
      s.Add(new Schedule(day,startTime,day,endTime));
      day=THURSDAY;
      s.Add(new Schedule(day,startTime,day,endTime));
      day=FRIDAY;
      s.Add(new Schedule(day,startTime,day,endTime));
     }

   bool a1 = s.IsActive(sun_not_on);
   bool a2 = s.IsActive(sun_off);
   bool a3 = s.IsActive(fri_on);
   bool a4 = s.IsActive(fri_off);

   Print(a1 ? "Fail : sun_not_on" : "Pass : sun_not_on");
   Print(a2 ? "Fail : sun_off" : "Pass : sun_off");
   Print(a3 ? "Pass : fri_on" : "Fail : fri_on");
   Print(a4 ? "Fail : fri_off" : "Pass : fri_off");

   delete s;
  }
//+------------------------------------------------------------------+
