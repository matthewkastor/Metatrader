//+------------------------------------------------------------------+
//|                                             ScheduleSetTests.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Schedule\Tests\ScheduleSetTests.mqh>

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   ScheduleSetTests *tests=new ScheduleSetTests();
   tests.RunAllTests();
   tests.unitTest.printDetail();
   tests.unitTest.printSummary();
   delete tests;
  }
//+------------------------------------------------------------------+
