//+------------------------------------------------------------------+
//|                                                     AllTests.mq4 |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict

#include <Candles\Tests\CandleMetricsTests.mqh>
#include <Common\Tests\ComparatorsTests.mqh>
#include <Common\Tests\SimpleParsersTests.mqh>
#include <Schedule\Tests\ScheduleSetTests.mqh>
#include <Schedule\Tests\ScheduleTests.mqh>

#include <UnitTesting\TestSuiteSet.mqh>
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   TestSuiteSet *tss = new TestSuiteSet("AllTests");
   tss.Add(new ComparatorsTests());
   tss.Add(new CandleMetricsTests());
   tss.Add(new SimpleParsersTests());
   tss.Add(new ScheduleSetTests());
   tss.Add(new ScheduleTests());
   tss.RunAllTests();
   delete tss;
  }
//+------------------------------------------------------------------+
