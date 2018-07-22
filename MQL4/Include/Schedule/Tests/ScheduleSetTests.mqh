//+------------------------------------------------------------------+
//|                                             ScheduleSetTests.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <UnitTesting\BaseTestSuite.mqh>
#include <Generic\LinkedList.mqh>
#include <Schedule\ScheduleSet.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ScheduleSetTests : public BaseTestSuite
  {
private:
   ScheduleSet      *s;
   void              AssertShouldBeInSchedule(string name,datetime time);
   void              AssertShouldBeInSchedule(string name,CLinkedList<datetime>*time);
   void              AssertShouldNotBeInSchedule(string name,datetime time);
   void              AssertShouldNotBeInSchedule(string name,CLinkedList<datetime>*time);
public:
   void              ScheduleSetTests();
   void             ~ScheduleSetTests();
   void              BasicTests();
   void              RunAllTests();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ScheduleSetTests::ScheduleSetTests()
  {
   this.unitTest.Name="ScheduleSetTests";

   this.s=new ScheduleSet();
   this.s.Name="Test Schedule";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ScheduleSetTests::~ScheduleSetTests()
  {
   delete s;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ScheduleSetTests::AssertShouldBeInSchedule(string name,datetime time)
  {
   string message=StringConcatenate(s.ToString()," includes ",time);
   bool actual=s.IsActive(time);
   this.unitTest.assertTrue(name,message,actual);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ScheduleSetTests::AssertShouldBeInSchedule(string name,CLinkedList<datetime>*time)
  {
   int sz=time.Count();
   CLinkedListNode<datetime>*node=time.First();
   AssertShouldBeInSchedule(name,node.Value());

   while(node!=time.Last())
     {
      node=node.Next();
      AssertShouldBeInSchedule(name,node.Value());
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ScheduleSetTests::AssertShouldNotBeInSchedule(string name,datetime time)
  {
   string message=StringConcatenate(s.ToString()," includes ",time);
   bool actual=s.IsActive(time);
   this.unitTest.assertFalse(name,message,actual);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ScheduleSetTests::AssertShouldNotBeInSchedule(string name,CLinkedList<datetime>*time)
  {
   int sz=time.Count();
   CLinkedListNode<datetime>*node=time.First();
   AssertShouldNotBeInSchedule(name,node.Value());

   while(node!=time.Last())
     {
      node=node.Next();
      AssertShouldNotBeInSchedule(name,node.Value());
     }
  }
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void ScheduleSetTests::BasicTests()
  {
   string name=__FUNCTION__;
   CLinkedList<datetime>*shouldBe=new CLinkedList<datetime>();
   CLinkedList<datetime>*shouldNotBe=new CLinkedList<datetime>();

   ENUM_DAY_OF_WEEK day=MONDAY;
   string startTime="08:00";
   string endTime="17:00";
   string lateHoursEnd="20:00";

   shouldNotBe.Add(StrToTime(StringConcatenate("2018.07.15 ",startTime))); // sunday should always be off.
   shouldNotBe.Add(StrToTime(StringConcatenate("2018.07.15 ",endTime)));// sunday should always be off.

   shouldBe.Add(StrToTime(StringConcatenate("2018.07.16 ",startTime))); // monday start of day.
   shouldNotBe.Add(StrToTime(StringConcatenate("2018.07.16 ",endTime))); // monday after hours.

   shouldBe.Add(StrToTime(StringConcatenate("2018.07.17 ",startTime))); // tuesday start of day.
   shouldNotBe.Add(StrToTime(StringConcatenate("2018.07.17 ",endTime))); // tuesday after hours.

   shouldBe.Add(StrToTime(StringConcatenate("2018.07.18 ",startTime))); // wednesday start of day.
   shouldBe.Add(StrToTime(StringConcatenate("2018.07.18 ",endTime))); // wednesday after normal hours.
   shouldNotBe.Add(StrToTime(StringConcatenate("2018.07.18 ",lateHoursEnd))); // wednesday after late hours.

   shouldBe.Add(StrToTime(StringConcatenate("2018.07.19 ",startTime))); // thursday start of day.
   shouldNotBe.Add(StrToTime(StringConcatenate("2018.07.19 ",endTime))); // thursday after hours.

   shouldBe.Add(StrToTime(StringConcatenate("2018.07.20 ",startTime))); // friday start of day.
   shouldNotBe.Add(StrToTime(StringConcatenate("2018.07.20 ",endTime))); // friday after hours.

   shouldNotBe.Add(StrToTime(StringConcatenate("2018.07.21 ",startTime))); // saturday should always be off.
   shouldNotBe.Add(StrToTime(StringConcatenate("2018.07.21 ",endTime)));// saturday should always be off.

   int c;
   int scheduleSetSize=52; // lots of schedules to search through.
   for(c=0;c<(scheduleSetSize);c++)
     {
      day=MONDAY;
      this.s.Add(new Schedule(day,startTime,day,endTime));
      day=TUESDAY;
      this.s.Add(new Schedule(day,startTime,day,endTime));
      day=WEDNESDAY;
      this.s.Add(new Schedule(day,startTime,day,endTime));
      day=THURSDAY;
      this.s.Add(new Schedule(day,startTime,day,endTime));
      day=FRIDAY;
      this.s.Add(new Schedule(day,startTime,day,endTime));
     }

   day=WEDNESDAY;
// on wednesday there are extended hours.
   this.s.Add(new Schedule(day,endTime,day,lateHoursEnd));

   this.AssertShouldBeInSchedule(name,shouldBe);
   this.AssertShouldNotBeInSchedule(name,shouldNotBe);

   delete shouldBe;
   delete shouldNotBe;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ScheduleSetTests::RunAllTests()
  {
   this.BasicTests();
  }
//+------------------------------------------------------------------+
