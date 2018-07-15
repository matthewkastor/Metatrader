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
         ;
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
      if(test.m_asserted)
        {
         return;
        }

      test.m_result=true;
      test.m_asserted=true;

      m_successTestCount+= 1;
      m_failureTestCount = m_allTestCount - m_successTestCount;
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
      test.m_result=false;
      test.m_message=message;
      test.m_asserted=true;

      m_failureTestCount+= 1;
      m_successTestCount = m_allTestCount - m_failureTestCount;
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
         this.Logger.Log(StringFormat("UnitTest : Result : PASS : %s",data.m_name));
        }
      else
        {
         this.Logger.Log(StringFormat("UnitTest : Result : FAIL : %s : %s",data.m_name,data.m_message));
        }
     }

   double successPercent= 100.0 * m_successTestCount/m_allTestCount;
   double failurePrcent = 100.0 * m_failureTestCount/m_allTestCount;

   this.Logger.Log(StringFormat("UnitTest : Results Summary : Total Run : %d",m_allTestCount));

   this.Logger.Log(StringFormat("UnitTest : Results Summary : Total Pass : %d",m_successTestCount));

   this.Logger.Log(StringFormat("UnitTest : Results Summary : Pass Rate : %.2f%%",successPercent));

   this.Logger.Log(StringFormat("UnitTest : Results Summary : Total Fail : %d",m_failureTestCount));

   this.Logger.Log(StringFormat("UnitTest : Results Summary : Fail Rate : %.2f%%",failurePrcent));

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
      string m=StringConcatenate(message,": expected is <",expected,"> but <",actual,">");
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
      string m=message+": expected is <"+CharToString(expected)+
               "> but <"+CharToString(actual)+">";
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
      string m=message+": expected is <"+CharToString(expected)+
               "> but <"+CharToString(actual)+">";
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
      string m=message+": expected is <"+IntegerToString(expected)+
               "> but <"+IntegerToString(actual)+">";
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
      string m=message+": expected is <"+IntegerToString(expected)+
               "> but <"+IntegerToString(actual)+">";
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
      string m=message+": expected is <"+IntegerToString(expected)+
               "> but <"+IntegerToString(actual)+">";
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
      string m=message+": expected is <"+IntegerToString(expected)+
               "> but <"+IntegerToString(actual)+">";
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
      string m=message+": expected is <"+IntegerToString(expected)+
               "> but <"+IntegerToString(actual)+">";
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
      string m=message+": expected is <"+IntegerToString(expected)+
               "> but <"+IntegerToString(actual)+">";
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
      string m=message+": expected is <"+TimeToString(expected)+
               "> but <"+TimeToString(actual)+">";
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
      string m=message+": expected is <"+ColorToString(expected)+
               "> but <"+ColorToString(actual)+">";
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
      string m=message+": expected is <"+DoubleToString(expected)+
               "> but <"+DoubleToString(actual)+">";
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
      string m=message+": expected is <"+DoubleToString(expected)+
               "> but <"+DoubleToString(actual)+">";
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
      string m=message+": expected is <"+expected+
               "> but <"+actual+">";
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
               "> but <"+IntegerToString(actualSize)+">";
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
                                    expected[i],"> but <",actual[i],">");
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
                  "> but <"+CharToString(actual[i])+">";
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
                  "> but <"+CharToString(actual[i])+">";
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
                  "> but <"+IntegerToString(actual[i])+">";
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
                  "> but <"+IntegerToString(actual[i])+">";
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
                  "> but <"+IntegerToString(actual[i])+">";
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
                  "> but <"+IntegerToString(actual[i])+">";
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
                  "> but <"+IntegerToString(actual[i])+">";
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
                  "> but <"+IntegerToString(actual[i])+">";
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
                  "> but <"+TimeToString(actual[i])+">";
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
                  "> but <"+ColorToString(actual[i])+">";
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
                  "> but <"+DoubleToString(actual[i])+">";
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
                  "> but <"+DoubleToString(actual[i])+">";
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
                  "> but <"+actual[i]+">";
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
