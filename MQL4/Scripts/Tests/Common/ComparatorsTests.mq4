//+------------------------------------------------------------------+
//|                                             ComparatorsTests.mq4 |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.01"
#property strict

#include <Common\Tests\ComparatorsTests.mqh>
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   ComparatorsTests *tests=new ComparatorsTests();
   tests.RunAllTests();
   tests.unitTest.printDetail();
   tests.unitTest.printSummary();
   delete tests;
  }
//+------------------------------------------------------------------+
