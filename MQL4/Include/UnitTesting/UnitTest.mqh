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
                     UnitTest();
                     UnitTest(BaseLogger *logger);
                    ~UnitTest();

   Comparators       compare;
   void              addTest(string name);
   void              setSuccess(string name);
   void              setFailure(string name,string message);
   void              printSummary();

   template<typename T>
   bool              assertEquals(string name,string message,T expected,T actual);

   template<typename T>
   bool              assertEquals(string name,string message,T &expected[],T &actual[]);

   template<typename T>
   bool              assertTrue(string name,string message,T actual);

   void              fail(string name,string message);

private:
   int               m_allTestCount;
   int               m_successTestCount;
   int               m_failureTestCount;
   int               m_successAssertionCount;
   int               m_failureAssertionCount;
   CList             m_testList;

   UnitTestData     *findTest(string name);
   void              clearTestList();

   bool              assertArraySize(string name,string message,int expectedSize,int actualSize);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
UnitTest::UnitTest()
   : m_testList(),m_allTestCount(0),m_successTestCount(0)
  {
   this.Logger=new BaseLogger();
   this.deleteLogger=true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
UnitTest::UnitTest(BaseLogger *logger)
   : m_testList(),m_allTestCount(0),m_successTestCount(0)
  {
   this.Logger=logger;
   this.deleteLogger=false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
UnitTest::~UnitTest(void)
  {
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
   m_allTestCount+=1;
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
   UnitTestData *test=findTest(name);
   if(test==NULL)
     {
      addTest(name);
     }
   test=findTest(name);

   if(test!=NULL)
     {
      m_successAssertionCount+=1;
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
   UnitTestData *test=findTest(name);
   if(test==NULL)
     {
      addTest(name);
     }
   test=findTest(name);

   if(test!=NULL)
     {
      m_failureAssertionCount+=1;
      test.m_result=false;
      test.m_message=StringConcatenate(test.m_message,message);
      test.m_asserted=true;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::printSummary(void)
  {
   UnitTestData *data;

   this.Logger.Log("UnitTest : Results Summary : Start");

   for(data=m_testList.GetLastNode(); data!=NULL; data=m_testList.GetPrevNode())
     {
      if(data.m_result)
        {
         m_successTestCount+=1;
         this.Logger.Log(StringFormat("UnitTest : Result : PASS : %s",data.m_name));
        }
      else
        {
         m_failureTestCount+=1;
         this.Logger.Log(StringFormat("UnitTest : Result : FAIL : %s : %s",data.m_name,data.m_message));
        }
     }

   double successPercent=0;
   if(m_allTestCount!=0)
     {
      successPercent=100.0 *((double)m_successTestCount/(double)m_allTestCount);
     }
   double failurePrcent=0;
   if(m_allTestCount!=0)
     {
      failurePrcent=100.0 *((double)m_failureTestCount/(double)m_allTestCount);
     }

   int totalAssertions=m_successAssertionCount+m_failureAssertionCount;
   double assertSuccessPercent=0;
   if(totalAssertions!=0)
     {
      assertSuccessPercent=100.0 *((double)m_successAssertionCount/(double)totalAssertions);
     }
   double assertFailurePrcent=0;
   if(totalAssertions!=0)
     {
      assertFailurePrcent=100.0 *((double)m_failureAssertionCount/(double)totalAssertions);
     }

   this.Logger.Log(StringFormat("UnitTest : Results Summary : Total Tests Run : %d",m_allTestCount));

   this.Logger.Log(StringFormat("UnitTest : Results Summary : Total Assertions Run : %d",totalAssertions));

   this.Logger.Log(StringFormat("UnitTest : Results Summary : Test Pass Rate : %.2f%%",successPercent));

   this.Logger.Log(StringFormat("UnitTest : Results Summary : Assertion Pass Rate : %.2f%%",assertSuccessPercent));

   this.Logger.Log(StringFormat("UnitTest : Results Summary : Total Tests Pass : %d",m_successTestCount));

   this.Logger.Log(StringFormat("UnitTest : Results Summary : Total Assertions Pass : %d",m_successAssertionCount));

   this.Logger.Log(StringFormat("UnitTest : Results Summary : Total Tests Fail : %d",m_failureTestCount));

   this.Logger.Log(StringFormat("UnitTest : Results Summary : Total Assertions Fail : %d",m_failureAssertionCount));

   this.Logger.Log(StringFormat("UnitTest : Results Summary : Test Fail Rate : %.2f%%",failurePrcent));

   this.Logger.Log(StringFormat("UnitTest : Results Summary : Assertion Fail Rate : %.2f%%",assertFailurePrcent));

   this.Logger.Log("UnitTest : Results Summary : End");
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
template<typename T>
bool UnitTest::assertTrue(string name,string message,T actual)
  {
   bool expected=true;
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
            return;
           }
        }
      setSuccess(name);
     }
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
