//+------------------------------------------------------------------+
//|                                                 TestSuiteSet.mqh |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict

#include <Generic\LinkedList.mqh>
#include <UnitTesting\BaseTestSuite.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TestSuiteSet : public CLinkedList<BaseTestSuite *>
  {
private:
   bool              _deleteSuitesWhenDone;
   void              UpdateStats(UnitTestStats *s);
public:
   string   Name;
   UnitTestStats    *Stats;
   void              RunAllTests();
   void              TestSuiteSet(string name, bool deleteSuitesWhenDone=true);
   void             ~TestSuiteSet();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TestSuiteSet::TestSuiteSet(string name="TestSuiteSet", bool deleteSuitesWhenDone=true)
  {
   this.Name=name;
   this.Stats=new UnitTestStats();
   this._deleteSuitesWhenDone=deleteSuitesWhenDone;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TestSuiteSet::~TestSuiteSet()
  {
   delete this.Stats;
   
   if(this._deleteSuitesWhenDone)
     {
      CLinkedListNode<BaseTestSuite*>*node=this.First();
      bool done=false;
      while(!done)
        {
         delete node.Value();
         node=node.Next();
         done= node==this.First();
        }
     }
   this.Clear();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TestSuiteSet::RunAllTests()
  {
   CLinkedListNode<BaseTestSuite*>*node=this.First();
   BaseTestSuite *t;
   bool done=false;
   while(!done)
     {

      t=node.Value();
      t.RunAllTests();
      t.unitTest.calculateStats();
      this.Stats.Add(t.unitTest.Stats);
      t.unitTest.printDetail();
      node=node.Next();
      done= node==this.First();
     }
     this.Stats.Calculate();
     this.Stats.PrintSummary(this.Name);
  }
//+------------------------------------------------------------------+
