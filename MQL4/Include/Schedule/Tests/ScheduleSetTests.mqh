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
   void              BasicTests(int scheduleSetSize=1);
   void              CanAddWeeklySchedule();
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
   string message=StringConcatenate(s.ToString()," includes ",EnumToString((ENUM_DAY_OF_WEEK)TimeDayOfWeek(time))," ",time);
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
   string message=StringConcatenate(s.ToString()," includes ",EnumToString((ENUM_DAY_OF_WEEK)TimeDayOfWeek(time))," ",time);
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
void ScheduleSetTests::BasicTests(int scheduleSetSize=1)
  {
   string name=StringConcatenate(__FUNCTION__, "(", (string)scheduleSetSize, ")");
   CLinkedList<datetime>*shouldBe=new CLinkedList<datetime>();
   CLinkedList<datetime>*shouldNotBe=new CLinkedList<datetime>();
   this.s.Clear();

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
//| Script program start function                                    |
//+------------------------------------------------------------------+
void ScheduleSetTests::CanAddWeeklySchedule()
  {
   string name=__FUNCTION__;
   CLinkedList<datetime>*shouldBe=new CLinkedList<datetime>();
   CLinkedList<datetime>*shouldNotBe=new CLinkedList<datetime>();
   this.s.Clear();

   string startTime="08:00";
   string mid="12:00";
   string endTime="17:00";

   // sunday
   shouldNotBe.Add(StrToTime(StringConcatenate("2018.07.15 ",startTime)));
   shouldNotBe.Add(StrToTime(StringConcatenate("2018.07.15 ",endTime)));
   // monday
   shouldNotBe.Add(StrToTime(StringConcatenate("2018.07.16 ",startTime)));
   shouldNotBe.Add(StrToTime(StringConcatenate("2018.07.16 ",endTime)));
   // tuesday
   shouldBe.Add(StrToTime(StringConcatenate("2018.07.17 ",startTime))); 
   shouldBe.Add(StrToTime(StringConcatenate("2018.07.17 ",mid))); 
   shouldNotBe.Add(StrToTime(StringConcatenate("2018.07.17 ",endTime)));
   // wednesday
   shouldBe.Add(StrToTime(StringConcatenate("2018.07.18 ",startTime))); 
   shouldBe.Add(StrToTime(StringConcatenate("2018.07.18 ",mid))); 
   shouldNotBe.Add(StrToTime(StringConcatenate("2018.07.18 ",endTime)));
   // thursday
   shouldBe.Add(StrToTime(StringConcatenate("2018.07.19 ",startTime))); 
   shouldBe.Add(StrToTime(StringConcatenate("2018.07.19 ",mid))); 
   shouldNotBe.Add(StrToTime(StringConcatenate("2018.07.19 ",endTime)));
   // friday
   shouldNotBe.Add(StrToTime(StringConcatenate("2018.07.20 ",startTime))); 
   shouldNotBe.Add(StrToTime(StringConcatenate("2018.07.20 ",endTime)));
   // saturday
   shouldNotBe.Add(StrToTime(StringConcatenate("2018.07.21 ",startTime))); 
   shouldNotBe.Add(StrToTime(StringConcatenate("2018.07.21 ",endTime)));

   this.s.AddWeek(startTime,endTime,TUESDAY,THURSDAY);
   
   Print(this.s.ToString());

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
   this.BasicTests(1);
   this.BasicTests(1000);
   this.CanAddWeeklySchedule();
  }
//+------------------------------------------------------------------+
