//+------------------------------------------------------------------+
//|                                             ComparatorsTests.mq4 |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.01"
#property strict

#include <UnitTesting\BaseTestSuite.mqh>
#include <Common\Comparators.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ComparatorsTests : BaseTestSuite
  {
private:

public:
   void              RunAllTests();
   void              BasicComparatorsLogicTest(bool &data[4][2],bool &results[4]);
   void              BasicComparatorsInequalitiesTest();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ComparatorsTests::RunAllTests()
  {
   BasicComparatorsInequalitiesTest();

   int ct=13;
   bool results[];
   while(ct>=0)
     {
      for(int i=0;i<4;i++)
        {
         ArrayResize(results,i+1,0);
         results[i]=LogicTestResults[ct][i];
        }
      BasicComparatorsLogicTest(LogicTestData,results);
      ct-=1;
     }

   this.unitTest.printSummary();
  }

bool LogicTestData[4][2]=
  {
   false,false,
   false,true,
   true,false,
   true,true
  };
bool LogicTestResults[14][4]=
  {
   0,0,0,1,
   0,0,1,0,
   0,0,1,1,
   0,1,0,0,
   0,1,0,1,
   0,1,1,0,
   0,1,1,1,
   1,0,0,0,
   1,0,0,1,
   1,0,1,0,
   1,0,1,1,
   1,1,0,0,
   1,1,0,1,
   1,1,1,0
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ComparatorsTests::BasicComparatorsLogicTest(bool &data[4][2],bool &results[4])
  {
   string op;
   string num;

   for(int i=0;i<4;i++)
     {
      num+=(string)(results[i]? 1 : 0);
     }

   if(num=="0001")
     {
      op="and";
     }
   if(num=="0010")
     {
      op="non implication";
     }
   if(num=="0011")
     {
      op="p";
     }
   if(num=="0100")
     {
      op="converse non implication";
     }
   if(num=="0101")
     {
      op="q";
     }
   if(num=="0110")
     {
      op="xor";
     }
   if(num=="0111")
     {
      op="or";
     }
   if(num=="1000")
     {
      op="nor";
     }
   if(num=="1001")
     {
      op="equality";
     }
   if(num=="1010")
     {
      op="not q";
     }
   if(num=="1011")
     {
      op="converse implication";
     }
   if(num=="1100")
     {
      op="not p";
     }
   if(num=="1101")
     {
      op="implication";
     }
   if(num=="1110")
     {
      op="nand";
     }

   string testName=StringConcatenate(__FUNCTION__," ",op,"(");

   Comparators compare;

   bool p;
   bool q;
   bool expected;
   bool actual;
   string test;
   for(int i=0;i<4;i++)
     {
      actual=false;
      p=data[i][0];
      q=data[i][1];
      expected=results[i];

      test=StringConcatenate(testName,p,", ",q,") = ",expected);
      this.unitTest.addTest(test);

      if(op=="and")
        {
         actual=compare.And(p,q);
        }
      if(op=="or")
        {
         actual=compare.Or(p,q);
        }
      if(op=="nand")
        {
         actual=compare.Nand(p,q);
        }
      if(op=="nor")
        {
         actual=compare.Nor(p,q);
        }
      if(op=="xor")
        {
         actual=compare.Xor(p,q);
        }
      if(op=="p")
        {
         actual=compare.ProjectP(p,q);
        }
      if(op=="not p")
        {
         actual=compare.NotP(p,q);
        }
      if(op=="q")
        {
         actual=compare.ProjectQ(p,q);
        }
      if(op=="not q")
        {
         actual=compare.NotQ(p,q);
        }
      if(op=="implication")
        {
         actual=compare.Implication(p,q);
        }
      if(op=="non implication")
        {
         actual=compare.NonImplication(p,q);
        }
      if(op=="converse implication")
        {
         actual=compare.ConverseImplication(p,q);
        }
      if(op=="converse non implication")
        {
         actual=compare.ConverseNonImplication(p,q);
        }
      if(op=="equality")
        {
         actual=compare.Xnor(p,q);
        }

      this.unitTest.assertEquals(test,"Bad Result",expected,actual);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ComparatorsTests::BasicComparatorsInequalitiesTest()
  {
   Comparators compare;
   this.unitTest.assertTrue("IsEqualTo(true, true) = true","Could not compare booleans", compare.IsEqualTo(true,true));
   this.unitTest.assertTrue("IsEqualTo(true, false) = false","Could not compare booleans", !compare.IsEqualTo(true,false));
   this.unitTest.assertTrue("IsEqualTo(false, true) = false","Could not compare booleans", !compare.IsEqualTo(false,true));
   this.unitTest.assertTrue("IsEqualTo(false, false) = true","Could not compare booleans", compare.IsEqualTo(false,false));
   this.unitTest.assertTrue("IsEqualTo(1, 2) = false","Could not compare int", !compare.IsEqualTo(1,2));
   this.unitTest.assertTrue("IsEqualTo(2, 2) = true","Could not compare int", compare.IsEqualTo(2,2));
   this.unitTest.assertTrue("IsEqualTo(2, 1) = false","Could not compare int", !compare.IsEqualTo(2,1));
   
   this.unitTest.assertTrue("IsGreaterThan(1, 2) = false","Could not compare int", !compare.IsGreaterThan(1,2));
   this.unitTest.assertTrue("IsGreaterThan(2, 2) = false","Could not compare int", !compare.IsGreaterThan(2,2));
   this.unitTest.assertTrue("IsGreaterThan(2, 1) = true","Could not compare int", compare.IsGreaterThan(2,1));
   
   this.unitTest.assertTrue("IsGreaterThanOrEqualTo(1, 2) = false","Could not compare int", !compare.IsGreaterThanOrEqualTo(1,2));
   this.unitTest.assertTrue("IsGreaterThanOrEqualTo(2, 2) = true","Could not compare int", compare.IsGreaterThanOrEqualTo(2,2));
   this.unitTest.assertTrue("IsGreaterThanOrEqualTo(2, 1) = true","Could not compare int", compare.IsGreaterThanOrEqualTo(2,1));
   
   this.unitTest.assertTrue("IsLessThan(1, 2) = true","Could not compare int", compare.IsLessThan(1,2));
   this.unitTest.assertTrue("IsLessThan(2, 2) = false","Could not compare int", !compare.IsLessThan(2,2));
   this.unitTest.assertTrue("IsLessThan(2, 1) = false","Could not compare int", !compare.IsLessThan(2,1));
   
   this.unitTest.assertTrue("IsLessThanOrEqualTo(1, 2) = true","Could not compare int", compare.IsLessThanOrEqualTo(1,2));
   this.unitTest.assertTrue("IsLessThanOrEqualTo(2, 2) = true","Could not compare int", compare.IsLessThanOrEqualTo(2,2));
   this.unitTest.assertTrue("IsLessThanOrEqualTo(2, 1) = false","Could not compare int", !compare.IsLessThanOrEqualTo(2,1));
  }
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   ComparatorsTests *tests=new ComparatorsTests();
   tests.RunAllTests();
   delete tests;
  }
//+------------------------------------------------------------------+
