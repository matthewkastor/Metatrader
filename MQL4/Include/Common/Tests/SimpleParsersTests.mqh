//+------------------------------------------------------------------+
//|                                           SimpleParsersTests.mqh |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict

#include <UnitTesting\BaseTestSuite.mqh>
#include <Common\SimpleParsers.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class SimpleParsersTests : public BaseTestSuite
  {
private:
   SimpleParsers     simpleParsers;
public:
   void              SimpleParsersTests();
   void              RunAllTests();
   void              CanParseCsvLine(string &args[]);
   void              CanParseCsvLine(string csv,string &expected[]);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SimpleParsersTests::SimpleParsersTests()
  {
   this.unitTest.Name="SimpleParsersTests";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SimpleParsersTests::RunAllTests()
  {
   string a[]={"this,is,fancy","this","is","fancy"};
   string b[]={""};
   CanParseCsvLine(a);
   CanParseCsvLine(b);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SimpleParsersTests::CanParseCsvLine(string &args[])
  {
   string arr[];
   int argc=ArraySize(args);
   if(argc>1)
     {
      ArrayResize(arr,argc-1,0);
      ArrayCopy(arr,args,0,1);
     }
   this.CanParseCsvLine(args[0],arr);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SimpleParsersTests::CanParseCsvLine(string csv,string &expected[])
  {
   string testName=StringConcatenate(__FUNCTION__," : \"",csv,"\"");
   this.unitTest.addTest(testName);
   string actual[];
   this.simpleParsers.ParseCsvLine(csv,actual);
   this.unitTest.assertEquals(testName,"Could not parse csv line: <"+csv+">",expected,actual);
  }
//+------------------------------------------------------------------+
