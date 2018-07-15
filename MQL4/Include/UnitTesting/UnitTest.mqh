//+------------------------------------------------------------------+
//|                                                     UnitTest.mqh |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict

//based on GPL3 licensed work by micclly
//#property copyright "Copyright 2014, micclly."
//#property link      "https://github.com/micclly"

#include <Arrays/List.mqh>
#include <UnitTesting\UnitTestData.mqh>
#include <Common\BaseLogger.mqh>
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

   void              addTest(string name);
   void              setSuccess(string name);
   void              setFailure(string name,string message);
   void              printSummary();

   void              assertEquals(string name,string message,bool expected,bool actual);
   void              assertEquals(string name,string message,char expected,char actual);
   void              assertEquals(string name,string message,uchar expected,uchar actual);
   void              assertEquals(string name,string message,short expected,short actual);
   void              assertEquals(string name,string message,ushort expected,ushort actual);
   void              assertEquals(string name,string message,int expected,int actual);
   void              assertEquals(string name,string message,uint expected,uint actual);
   void              assertEquals(string name,string message,long expected,long actual);
   void              assertEquals(string name,string message,ulong expected,ulong actual);
   void              assertEquals(string name,string message,datetime expected,datetime actual);
   void              assertEquals(string name,string message,color expected,color actual);
   void              assertEquals(string name,string message,float expected,float actual);
   void              assertEquals(string name,string message,double expected,double actual);
   void              assertEquals(string name,string message,string expected,string actual);

   void              assertEquals(string name,string message,bool &expected[],bool &actual[]);
   void              assertEquals(string name,string message,char &expected[],char &actual[]);
   void              assertEquals(string name,string message,uchar &expected[],uchar &actual[]);
   void              assertEquals(string name,string message,short &expected[],short &actual[]);
   void              assertEquals(string name,string message,ushort &expected[],ushort &actual[]);
   void              assertEquals(string name,string message,int &expected[],int &actual[]);
   void              assertEquals(string name,string message,uint &expected[],uint &actual[]);
   void              assertEquals(string name,string message,long &expected[],long &actual[]);
   void              assertEquals(string name,string message,ulong &expected[],ulong &actual[]);
   void              assertEquals(string name,string message,datetime &expected[],datetime &actual[]);
   void              assertEquals(string name,string message,color &expected[],color &actual[]);
   void              assertEquals(string name,string message,float &expected[],float &actual[]);
   void              assertEquals(string name,string message,double &expected[],double &actual[]);
   void              assertEquals(string name,string message,string &expected[],string &actual[]);

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

   if(test!=NULL)
     {
      m_failureAssertionCount+=1;
      test.m_result=false;
      test.m_message=StringConcatenate(test.m_message, message);
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

   double successPercent= 100.0 * m_successTestCount/m_allTestCount;
   double failurePrcent = 100.0 * m_failureTestCount/m_allTestCount;

   int totalAssertions=m_successAssertionCount+m_failureAssertionCount;
   double assertSuccessPercent= 100.0 * m_successAssertionCount/totalAssertions;
   double assertFailurePrcent = 100.0 * m_failureAssertionCount/totalAssertions;
   
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
void UnitTest::assertEquals(string name,string message,bool expected,bool actual)
  {
   if(expected==actual)
     {
      setSuccess(name);
     }
   else
     {
      string m=StringConcatenate(message,": expected <",expected,"> but found <",actual,">");
      setFailure(name,m);
      this.Logger.Error("Test failed: "+name+": "+m);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,char expected,char actual)
  {
   if(expected==actual)
     {
      setSuccess(name);
     }
   else
     {
      string m=message+": expected <"+CharToString(expected)+
               "> but found <"+CharToString(actual)+">";
      setFailure(name,m);
      this.Logger.Error("Test failed: "+name+": "+m);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,uchar expected,uchar actual)
  {
   if(expected==actual)
     {
      setSuccess(name);
     }
   else
     {
      string m=message+": expected <"+CharToString(expected)+
               "> but found <"+CharToString(actual)+">";
      setFailure(name,m);
      this.Logger.Error("Test failed: "+name+": "+m);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,short expected,short actual)
  {
   if(expected==actual)
     {
      setSuccess(name);
     }
   else
     {
      string m=message+": expected <"+IntegerToString(expected)+
               "> but found <"+IntegerToString(actual)+">";
      setFailure(name,m);
      this.Logger.Error("Test failed: "+name+": "+m);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,ushort expected,ushort actual)
  {
   if(expected==actual)
     {
      setSuccess(name);
     }
   else
     {
      string m=message+": expected <"+IntegerToString(expected)+
               "> but found <"+IntegerToString(actual)+">";
      setFailure(name,m);
      this.Logger.Error("Test failed: "+name+": "+m);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,int expected,int actual)
  {
   if(expected==actual)
     {
      setSuccess(name);
     }
   else
     {
      string m=message+": expected <"+IntegerToString(expected)+
               "> but found <"+IntegerToString(actual)+">";
      setFailure(name,m);
      this.Logger.Error("Test failed: "+name+": "+m);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,uint expected,uint actual)
  {
   if(expected==actual)
     {
      setSuccess(name);
     }
   else
     {
      string m=message+": expected <"+IntegerToString(expected)+
               "> but found <"+IntegerToString(actual)+">";
      setFailure(name,m);
      this.Logger.Error("Test failed: "+name+": "+m);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,long expected,long actual)
  {
   if(expected==actual)
     {
      setSuccess(name);
     }
   else
     {
      string m=message+": expected <"+IntegerToString(expected)+
               "> but found <"+IntegerToString(actual)+">";
      setFailure(name,m);
      this.Logger.Error("Test failed: "+name+": "+m);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,ulong expected,ulong actual)
  {
   if(expected==actual)
     {
      setSuccess(name);
     }
   else
     {
      string m=message+": expected <"+IntegerToString(expected)+
               "> but found <"+IntegerToString(actual)+">";
      setFailure(name,m);
      this.Logger.Error("Test failed: "+name+": "+m);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,datetime expected,datetime actual)
  {
   if(expected==actual)
     {
      setSuccess(name);
     }
   else
     {
      string m=message+": expected <"+TimeToString(expected)+
               "> but found <"+TimeToString(actual)+">";
      setFailure(name,m);
      this.Logger.Error("Test failed: "+name+": "+m);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,color expected,color actual)
  {
   if(expected==actual)
     {
      setSuccess(name);
     }
   else
     {
      string m=message+": expected <"+ColorToString(expected)+
               "> but found <"+ColorToString(actual)+">";
      setFailure(name,m);
      this.Logger.Error("Test failed: "+name+": "+m);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,float expected,float actual)
  {
   if(expected==actual)
     {
      setSuccess(name);
     }
   else
     {
      string m=message+": expected <"+DoubleToString(expected)+
               "> but found <"+DoubleToString(actual)+">";
      setFailure(name,m);
      this.Logger.Error("Test failed: "+name+": "+m);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,double expected,double actual)
  {
   if(expected==actual)
     {
      setSuccess(name);
     }
   else
     {
      string m=message+": expected <"+DoubleToString(expected)+
               "> but found <"+DoubleToString(actual)+">";
      setFailure(name,m);
      this.Logger.Error("Test failed: "+name+": "+m);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,string expected,string actual)
  {
   if(expected==actual)
     {
      setSuccess(name);
     }
   else
     {
      string m=message+": expected <"+expected+
               "> but found <"+actual+">";
      setFailure(name,m);
      this.Logger.Error("Test failed: "+name+": "+m);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool UnitTest::assertArraySize(string name,string message,int expectedSize,int actualSize)
  {
   if(expectedSize==actualSize)
     {
      return true;
     }
   else
     {
      string m=message+": expected array size is <"+IntegerToString(expectedSize)+
               "> but found <"+IntegerToString(actualSize)+">";
      setFailure(name,m);
      this.Logger.Error("Test failed: "+name+": "+m);
      return false;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,bool &expected[],bool &actual[])
  {
   int expectedSize=ArraySize(expected);
   int actualSize=ArraySize(actual);

   if(!assertArraySize(name,message,expectedSize,actualSize))
     {
      return;
     }

   for(int i=0; i<actualSize; i++)
     {
      if(expected[i]!=actual[i])
        {
         string m=StringConcatenate(message,": expected array[",IntegerToString(i),"] is <",
                                    expected[i],"> but found <",actual[i],">");
         setFailure(name,m);
         this.Logger.Error("Test failed: "+name+": "+m);
         return;
        }
     }

   setSuccess(name);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,char &expected[],char &actual[])
  {
   int expectedSize=ArraySize(expected);
   int actualSize=ArraySize(actual);

   if(!assertArraySize(name,message,expectedSize,actualSize))
     {
      return;
     }

   for(int i=0; i<actualSize; i++)
     {
      if(expected[i]!=actual[i])
        {
         string m=message+": expected array["+IntegerToString(i)+"] is <"+
                  CharToString(expected[i])+
                  "> but found <"+CharToString(actual[i])+">";
         setFailure(name,m);
         this.Logger.Error("Test failed: "+name+": "+m);
         return;
        }
     }

   setSuccess(name);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,uchar &expected[],uchar &actual[])
  {
   int expectedSize=ArraySize(expected);
   int actualSize=ArraySize(actual);

   if(!assertArraySize(name,message,expectedSize,actualSize))
     {
      return;
     }

   for(int i=0; i<actualSize; i++)
     {
      if(expected[i]!=actual[i])
        {
         string m=message+": expected array["+IntegerToString(i)+"] is <"+
                  CharToString(expected[i])+
                  "> but found <"+CharToString(actual[i])+">";
         setFailure(name,m);
         this.Logger.Error("Test failed: "+name+": "+m);
         return;
        }
     }

   setSuccess(name);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,short &expected[],short &actual[])
  {
   int expectedSize=ArraySize(expected);
   int actualSize=ArraySize(actual);

   if(!assertArraySize(name,message,expectedSize,actualSize))
     {
      return;
     }

   for(int i=0; i<actualSize; i++)
     {
      if(expected[i]!=actual[i])
        {
         string m=message+": expected array["+IntegerToString(i)+"] is <"+
                  IntegerToString(expected[i])+
                  "> but found <"+IntegerToString(actual[i])+">";
         setFailure(name,m);
         this.Logger.Error("Test failed: "+name+": "+m);
         return;
        }
     }

   setSuccess(name);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,ushort &expected[],ushort &actual[])
  {
   int expectedSize=ArraySize(expected);
   int actualSize=ArraySize(actual);

   if(!assertArraySize(name,message,expectedSize,actualSize))
     {
      return;
     }

   for(int i=0; i<actualSize; i++)
     {
      if(expected[i]!=actual[i])
        {
         string m=message+": expected array["+IntegerToString(i)+"] is <"+
                  IntegerToString(expected[i])+
                  "> but found <"+IntegerToString(actual[i])+">";
         setFailure(name,m);
         this.Logger.Error("Test failed: "+name+": "+m);
         return;
        }
     }

   setSuccess(name);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,int &expected[],int &actual[])
  {
   int expectedSize=ArraySize(expected);
   int actualSize=ArraySize(actual);

   if(!assertArraySize(name,message,expectedSize,actualSize))
     {
      return;
     }

   for(int i=0; i<actualSize; i++)
     {
      if(expected[i]!=actual[i])
        {
         string m=message+": expected array["+IntegerToString(i)+"] is <"+
                  IntegerToString(expected[i])+
                  "> but found <"+IntegerToString(actual[i])+">";
         setFailure(name,m);
         this.Logger.Error("Test failed: "+name+": "+m);
         return;
        }
     }

   setSuccess(name);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,uint &expected[],uint &actual[])
  {
   int expectedSize=ArraySize(expected);
   int actualSize=ArraySize(actual);

   if(!assertArraySize(name,message,expectedSize,actualSize))
     {
      return;
     }

   for(int i=0; i<actualSize; i++)
     {
      if(expected[i]!=actual[i])
        {
         string m=message+": expected array["+IntegerToString(i)+"] is <"+
                  IntegerToString(expected[i])+
                  "> but found <"+IntegerToString(actual[i])+">";
         setFailure(name,m);
         this.Logger.Error("Test failed: "+name+": "+m);
         return;
        }
     }

   setSuccess(name);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,long &expected[],long &actual[])
  {
   int expectedSize=ArraySize(expected);
   int actualSize=ArraySize(actual);

   if(!assertArraySize(name,message,expectedSize,actualSize))
     {
      return;
     }

   for(int i=0; i<actualSize; i++)
     {
      if(expected[i]!=actual[i])
        {
         string m=message+": expected array["+IntegerToString(i)+"] is <"+
                  IntegerToString(expected[i])+
                  "> but found <"+IntegerToString(actual[i])+">";
         setFailure(name,m);
         this.Logger.Error("Test failed: "+name+": "+m);
         return;
        }
     }

   setSuccess(name);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,ulong &expected[],ulong &actual[])
  {
   int expectedSize=ArraySize(expected);
   int actualSize=ArraySize(actual);

   if(!assertArraySize(name,message,expectedSize,actualSize))
     {
      return;
     }

   for(int i=0; i<actualSize; i++)
     {
      if(expected[i]!=actual[i])
        {
         string m=message+": expected array["+IntegerToString(i)+"] is <"+
                  IntegerToString(expected[i])+
                  "> but found <"+IntegerToString(actual[i])+">";
         setFailure(name,m);
         this.Logger.Error("Test failed: "+name+": "+m);
         return;
        }
     }

   setSuccess(name);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,datetime &expected[],datetime &actual[])
  {
   int expectedSize=ArraySize(expected);
   int actualSize=ArraySize(actual);

   if(!assertArraySize(name,message,expectedSize,actualSize))
     {
      return;
     }

   for(int i=0; i<actualSize; i++)
     {
      if(expected[i]!=actual[i])
        {
         string m=message+": expected array["+IntegerToString(i)+"] is <"+
                  TimeToString(expected[i])+
                  "> but found <"+TimeToString(actual[i])+">";
         setFailure(name,m);
         this.Logger.Error("Test failed: "+name+": "+m);
         return;
        }
     }

   setSuccess(name);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,color &expected[],color &actual[])
  {
   int expectedSize=ArraySize(expected);
   int actualSize=ArraySize(actual);

   if(!assertArraySize(name,message,expectedSize,actualSize))
     {
      return;
     }

   for(int i=0; i<actualSize; i++)
     {
      if(expected[i]!=actual[i])
        {
         string m=message+": expected array["+IntegerToString(i)+"] is <"+
                  ColorToString(expected[i])+
                  "> but found <"+ColorToString(actual[i])+">";
         setFailure(name,m);
         this.Logger.Error("Test failed: "+name+": "+m);
         return;
        }
     }

   setSuccess(name);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,float &expected[],float &actual[])
  {
   int expectedSize=ArraySize(expected);
   int actualSize=ArraySize(actual);

   if(!assertArraySize(name,message,expectedSize,actualSize))
     {
      return;
     }

   for(int i=0; i<actualSize; i++)
     {
      if(expected[i]!=actual[i])
        {
         string m=message+": expected array["+IntegerToString(i)+"] is <"+
                  DoubleToString(expected[i])+
                  "> but found <"+DoubleToString(actual[i])+">";
         setFailure(name,m);
         this.Logger.Error("Test failed: "+name+": "+m);
         return;
        }
     }

   setSuccess(name);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,double &expected[],double &actual[])
  {
   int expectedSize=ArraySize(expected);
   int actualSize=ArraySize(actual);

   if(!assertArraySize(name,message,expectedSize,actualSize))
     {
      return;
     }

   for(int i=0; i<actualSize; i++)
     {
      if(expected[i]!=actual[i])
        {
         string m=message+": expected array["+IntegerToString(i)+"] is <"+
                  DoubleToString(expected[i])+
                  "> but found <"+DoubleToString(actual[i])+">";
         setFailure(name,m);
         this.Logger.Error("Test failed: "+name+": "+m);
         return;
        }
     }

   setSuccess(name);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTest::assertEquals(string name,string message,string &expected[],string &actual[])
  {
   int expectedSize=ArraySize(expected);
   int actualSize=ArraySize(actual);

   if(!assertArraySize(name,message,expectedSize,actualSize))
     {
      return;
     }

   for(int i=0; i<actualSize; i++)
     {
      if(expected[i]!=actual[i])
        {
         string m=message+": expected array["+IntegerToString(i)+"] is <"+
                  expected[i]+
                  "> but found <"+actual[i]+">";
         setFailure(name,m);
         this.Logger.Error("Test failed: "+name+": "+m);
         return;
        }
     }

   setSuccess(name);
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
