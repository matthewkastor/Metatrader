//+------------------------------------------------------------------+
//|                                                UnitTestStats.mqh |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict

#include <Common\BaseLogger.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class UnitTestStats
  {
private:
   bool              _deleteLogger;
   void              Reset(int successAssertionCount,int failureAssertionCount,
                           int successTestCount,int failureTestCount);
public:
   BaseLogger       *Logger;
   int               AllTestsCount;
   int               SuccessTestCount;
   int               FailureTestCount;
   int               SuccessAssertionCount;
   int               FailureAssertionCount;
   double            SuccessPercent;
   double            FailurePrcent;
   int               TotalAssertions;
   double            AssertSuccessPercent;
   double            AssertFailurePrcent;
   void              UnitTestStats(BaseLogger *aLogger=NULL);
   void             ~UnitTestStats();
   void              PrintSummary(string name);
   void              Calculate();
   void              Add(UnitTestStats *s);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTestStats::UnitTestStats(BaseLogger *aLogger=NULL)
  {
   this.SuccessAssertionCount=0;
   this.FailureAssertionCount=0;
   this.TotalAssertions=0;
   this.AssertSuccessPercent=0;
   this.AssertFailurePrcent=0;
   this.AllTestsCount=0;
   this.SuccessTestCount=0;
   this.FailureTestCount=0;
   this.SuccessPercent=0;
   this.FailurePrcent=0;
   if(aLogger==NULL)
     {
      this.Logger=new BaseLogger();
      this._deleteLogger=true;
     }
     else
     {
      this.Logger=aLogger;
      this._deleteLogger=false;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTestStats::~UnitTestStats()
  {
   if(this._deleteLogger)
     {
      delete this.Logger;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void              UnitTestStats::Reset(int successAssertionCount,
                                       int failureAssertionCount,
                                       int successTestCount,
                                       int failureTestCount)
  {
   this.SuccessAssertionCount=successAssertionCount;
   this.FailureAssertionCount=failureAssertionCount;
   this.SuccessTestCount=successTestCount;
   this.FailureTestCount=failureTestCount;
   this.TotalAssertions=0;
   this.AssertSuccessPercent=0;
   this.AssertFailurePrcent=0;
   this.AllTestsCount=0;
   this.SuccessPercent=0;
   this.FailurePrcent=0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTestStats::Calculate()
  {
   this.Reset(this.SuccessAssertionCount,this.FailureAssertionCount,
              this.SuccessTestCount,this.FailureTestCount);

   this.TotalAssertions=this.SuccessAssertionCount+this.FailureAssertionCount;

   if(this.TotalAssertions!=0)
     {
      this.AssertSuccessPercent=100.0 *((double)this.SuccessAssertionCount/(double)this.TotalAssertions);
      this.AssertFailurePrcent=100.0 *((double)this.FailureAssertionCount/(double)this.TotalAssertions);
     }

   this.AllTestsCount=this.SuccessTestCount+this.FailureTestCount;

   if(this.AllTestsCount!=0)
     {
      this.SuccessPercent=100.0 *((double)this.SuccessTestCount/(double)this.AllTestsCount);
      this.FailurePrcent=100.0 *((double)this.FailureTestCount/(double)this.AllTestsCount);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void              UnitTestStats::Add(UnitTestStats *s)
  {
   this.SuccessAssertionCount+=s.SuccessAssertionCount;
   this.FailureAssertionCount+=s.FailureAssertionCount;
   this.SuccessTestCount+=s.SuccessTestCount;
   this.FailureTestCount+=s.FailureTestCount;
   this.Calculate();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UnitTestStats::PrintSummary(string name)
  {
   this.Logger.Log("UnitTest : Results Summary : Start : "+name);

   this.Logger.Log(StringFormat("UnitTest : Results Summary : Total Tests Run : %d",this.AllTestsCount));

   this.Logger.Log(StringFormat("UnitTest : Results Summary : Total Assertions Run : %d",this.TotalAssertions));

   this.Logger.Log(StringFormat("UnitTest : Results Summary : Test Pass Rate : %.2f%%",this.SuccessPercent));

   this.Logger.Log(StringFormat("UnitTest : Results Summary : Assertion Pass Rate : %.2f%%",this.AssertSuccessPercent));

   this.Logger.Log(StringFormat("UnitTest : Results Summary : Total Tests Pass : %d",this.SuccessTestCount));

   this.Logger.Log(StringFormat("UnitTest : Results Summary : Total Assertions Pass : %d",this.SuccessAssertionCount));

   this.Logger.Log(StringFormat("UnitTest : Results Summary : Total Tests Fail : %d",this.FailureTestCount));

   this.Logger.Log(StringFormat("UnitTest : Results Summary : Total Assertions Fail : %d",this.FailureAssertionCount));

   this.Logger.Log(StringFormat("UnitTest : Results Summary : Test Fail Rate : %.2f%%",this.FailurePrcent));

   this.Logger.Log(StringFormat("UnitTest : Results Summary : Assertion Fail Rate : %.2f%%",this.AssertFailurePrcent));

   this.Logger.Log("UnitTest : Results Summary : End : "+name);
  }
//+------------------------------------------------------------------+
