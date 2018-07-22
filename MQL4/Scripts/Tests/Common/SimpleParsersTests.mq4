//+------------------------------------------------------------------+
//|                                           SimpleParsersTests.mq4 |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict

#include <Common\Tests\SimpleParsersTests.mqh>
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   SimpleParsersTests *tests=new SimpleParsersTests();
   tests.RunAllTests();
   tests.unitTest.printDetail();
   tests.unitTest.printSummary();
   delete tests;
  }
//+------------------------------------------------------------------+
