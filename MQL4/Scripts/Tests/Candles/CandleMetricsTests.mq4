//+------------------------------------------------------------------+
//|                                           CandleMetricsTests.mq4 |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.01"
#property strict

#include <Candles\Tests\CandleMetricsTests.mqh>
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   CandleMetricsTests *tests=new CandleMetricsTests();
   tests.RunAllTests();
   tests.unitTest.printDetail();
   tests.unitTest.printSummary();
   delete tests;
  }
//+------------------------------------------------------------------+
