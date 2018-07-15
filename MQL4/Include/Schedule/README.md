# Schedule

The Schedule class defines a schedule as beginning at a certain day of the week and time, and running until the ending day of the week and time. There are also tests included in `"Scripts\Tests\Schedule\ScheduleTests.mq4"` that give extensive usage examples and codify the expected behavior of the Schedule.

## Constructor Parameters

```
void Schedule(
    ENUM_DAY_OF_WEEK startDay,
    string startTime,
    ENUM_DAY_OF_WEEK endDay,
    string endTime
)
```

 - startDay : ENUM_DAY_OF_WEEK, The day that the schedule starts
 - startTime : string, The time that the schedule starts in 24 hour format
 - endDay : ENUM_DAY_OF_WEEK, The day that the schedule ends
 - endTime : string, The time that the schedule ends in 24 hour format

## Properties

```
ENUM_DAY_OF_WEEK  DayStart;    // the day when the schedule begins
TimeStamp        *TimeStart;   // the time when the schedule starts
ENUM_DAY_OF_WEEK  DayEnd;      // the day when the schedule ends
TimeStamp        *TimeEnd;     // the time when the schedule ends
```

The TimeStamp properties are instances of a simple TimeStamp object included in this library. They have two properties "Hour" and "Minute" as integers.

## Methods

```
string ToString() // returns a description of the schedule in English.
bool IsActive(datetime when) // returns true if the schedule is active on the given datetime.
```

## Usage

```
#include <Schedule\Schedule.mqh>

ENUM_DAY_OF_WEEK StartDay=1; // Start Day
ENUM_DAY_OF_WEEK EndDay=5;   // End Day
string   StartTime="12:30";  // Start Time
string   EndTime="14:30";    // End Time

// Creating the schedule
Schedule s(StartDay,StartTime,EndDay,EndTime);

// Displaying an English description of the schedule.
Print("Schedule : ",s.ToString());

// Creating some datetimes to check against the schedule
datetime ted0 = StrToTime(StringConcatenate("2018.06.10 ", (string)(s.TimeEnd.Hour), ":", (string)(s.TimeEnd.Minute)));
datetime ted1 = StrToTime(StringConcatenate("2018.06.11 ", (string)(s.TimeEnd.Hour), ":", (string)(s.TimeEnd.Minute)));

// the day of week is outside of the schedule, schedule should not be active
if(s.IsActive(ted0)) Print("Fail! Schedule active at ",ted0," = ",s.IsActive(ted0));

// the day of week and time are within the schedule, schedule should be active
if(!s.IsActive(ted1)) Print("Fail! Schedule active at ", ted1, " = ", s.IsActive(ted1));
```
