//+------------------------------------------------------------------+
//|                                                BaseTestSuite.mqh |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict

#include <UnitTesting\UnitTest.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class BaseTestSuite
  {
public:
   UnitTest          unitTest;
   virtual void      RunAllTests() = 0;
  };
//+------------------------------------------------------------------+
