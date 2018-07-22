//+------------------------------------------------------------------+
//|                                                     UnitTest.mqh |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict

#include <Arrays/List.mqh>
#include <UnitTesting\UnitTestData.mqh>
#include <UnitTesting\UnitTestStats.mqh>
#include <Common\BaseLogger.mqh>
#include <Common\Comparators.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class UnitTest
  {
private:
   BaseLogger       *Logger;
   bool              deleteLogger;
public:
   string            Name;
   UnitTestStats    *Stats;
                     UnitTest(BaseLogger *logger);
                    ~UnitTest();

   Comparators       compare;
   void              addTest(string name);
   void              setSuccess(string name);
   void              setFailure(string name,string message);
   void              calculateStats();
   void              printDetail();
   void              printSummary();

   template<typename T>
   bool              assertEquals(string name,string message,T expected,T actual);

   template<typename T>
   bool              assertEquals(string name,string message,T &expected[],T &actual[]);

   bool              assertTrue(string name,string message,bool actual);
   bool              assertFalse(string name,string message,bool actual);

   void              fail(string name,string message);

private:
   CList             m_testList;

   UnitTestData     *findTest(string name);
   void              clearTestList();

   bool              assertArraySize(string name,string message,int expectedSize,int actualSize);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
UnitTest::UnitTest(BaseLogger *aLogger=NULL)
  {
   this.Name="UnitTest";
   this.Stats=new UnitTestStats(aLogger);
   this.calculateStats();
   if(aLogger==NULL)
     {
      this.Logger=new BaseLogger();
      this.deleteLogger=true;
     }
   else
     {
      this.Logger=aLogger;
      this.deleteLogger=false;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
UnitTest::~UnitTest(void)
  {
   delete this.Stats;
   clearTestList();
   if(this.deleteLogger==true)
     {
      delete this.Logger;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::addTest(string name)
  {
   UnitTestData *test=findTest(name);
   if(test!=NULL)
     {
      return;
     }

   m_testList.Add(new UnitTestData(name));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::clearTestList(void)
  {
   if(m_testList.GetLastNode()!=NULL)
     {
      while(m_testList.DeleteCurrent())
        {
         // just keeps deleting until there are none left.
        };
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
UnitTestData *UnitTest::findTest(string name)
  {
   UnitTestData *data;
   for(data=m_testList.GetFirstNode(); data!=NULL; data=m_testList.GetNextNode())
     {
      if(data.m_name==name)
        {
         return data;
        }
     }

   return NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::setSuccess(string name)
  {
   this.Stats.SuccessAssertionCount+=1;
   UnitTestData *test=findTest(name);
   if(test==NULL)
     {
      addTest(name);
      test=findTest(name);
     }

   if(test!=NULL)
     {
      if(test.m_asserted)
        {
         return;
        }

      test.m_result=true;
      test.m_asserted=true;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::setFailure(string name,string message)
  {
   this.Stats.FailureAssertionCount+=1;
   UnitTestData *test=findTest(name);
   if(test==NULL)
     {
      addTest(name);
      test=findTest(name);
     }

   if(test!=NULL)
     {
      test.m_result=false;
      test.m_message=StringConcatenate(test.m_message,message);
      test.m_asserted=true;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::calculateStats()
  {
   UnitTestData *data;
   int success=0,failure=0;

   for(data=m_testList.GetLastNode(); data!=NULL; data=m_testList.GetPrevNode())
     {
      if(data.m_result)
        {
         success+=1;
        }
      else
        {
         failure+=1;
        }
     }
     
   this.Stats.SuccessTestCount=success;
   this.Stats.FailureTestCount=failure;
   this.Stats.Calculate();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::printSummary(void)
  {
   this.calculateStats();
   this.Stats.PrintSummary(this.Name);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::printDetail(void)
  {
   UnitTestData *data;

   this.Logger.Log("UnitTest : Results Detail : Start : "+this.Name);

   for(data=m_testList.GetLastNode(); data!=NULL; data=m_testList.GetPrevNode())
     {
      if(data.m_result)
        {
         this.Logger.Log(StringFormat("UnitTest : Result : PASS : %s",data.m_name));
        }
      else
        {
         this.Logger.Log(StringFormat("UnitTest : Result : FAIL : %s : %s",data.m_name,data.m_message));
        }
     }

   this.Logger.Log("UnitTest : Results Detail : End : "+this.Name);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
bool UnitTest::assertEquals(string name,string message,T expected,T actual)
  {
   bool out=compare.IsEqualTo(expected,actual);
   if(out)
     {
      setSuccess(name);
     }
   else
     {
      string m=StringConcatenate(message,": expected <",((string)expected),"> but found <",((string)actual),">");
      setFailure(name,m);
      this.Logger.Error("Test failed: "+name+": "+m);
     }
   return out;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool UnitTest::assertTrue(string name,string message,bool actual)
  {
   return this.assertEquals(name,message,true,actual);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool UnitTest::assertFalse(string name,string message,bool actual)
  {
   return this.assertEquals(name,message,false,actual);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
bool UnitTest::assertEquals(string name,string message,T &expected[],T &actual[])
  {
   int expectedSize=ArraySize(expected);
   int actualSize=ArraySize(actual);
   bool out=compare.IsEqualTo(expectedSize,actualSize);
   if(!(out))
     {
      string m=message+": expected array size is <"+((string)expectedSize)+
               "> but found <"+((string)actualSize)+">";
      setFailure(name,m);
      this.Logger.Error("Test failed: "+name+": "+m);
     }
   else
     {
      for(int i=0; i<actualSize; i++)
        {
         if(expected[i]!=actual[i])
           {
            string m=StringConcatenate(message,": expected array[",((string)i),"] is <",
                                       ((string)expected[i]),"> but found <",((string)actual[i]),">");
            setFailure(name,m);
            this.Logger.Error("Test failed: "+name+": "+m);
            out=false;
           }
        }
     }
   if(out)
     {
      setSuccess(name);
     }
   return out;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::fail(string name,string message)
  {
   setFailure(name,message);
   this.Logger.Error("Test failed: "+name+": "+message);
  }
//+------------------------------------------------------------------+
