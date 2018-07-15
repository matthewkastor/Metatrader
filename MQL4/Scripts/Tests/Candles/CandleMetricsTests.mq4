//+------------------------------------------------------------------+
//|                                           CandleMetricsTests.mq4 |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict

#include <UnitTesting\BaseTestSuite.mqh>
#include <Candles\CandleMetrics.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CandleMetricsTests : BaseTestSuite
  {
public:
   void              RunAllTests();
   void              BasicMetricsTest1();
   void              BasicMetricsTest2();
   void              BasicMetricsTest(string testName,MqlRates &rate,ENUM_TIMEFRAMES tf,double totalHeight,double bodyHeight,
                                      double upperWickHeight,double lowerWickHeight,double bodyPercent,
                                      double upperWickPercent,double lowerWickPercent,double width,
                                      double magnitude,double direction);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CandleMetricsTests::RunAllTests()
  {
   BasicMetricsTest1();
   BasicMetricsTest2();
   this.unitTest.printSummary();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CandleMetricsTests::BasicMetricsTest1()
  {
   string testName=__FUNCTION__;

   ENUM_TIMEFRAMES tf=PERIOD_H1;
   datetime t=TimeCurrent();

   MqlRates rate;
   rate.time = t;
   rate.open = 6.0;
   rate.close= 1.0;
   rate.high = 7.0;
   rate.low=0.5;
   rate.spread=23;
   rate.real_volume = 22;
   rate.tick_volume = 21;

   double totalHeight= 6.5;
   double bodyHeight = 5.0;
   double upperWickHeight = 1.0;
   double lowerWickHeight = 0.5;
   double bodyPercent=76.92;
   double upperWickPercent = 15.38;
   double lowerWickPercent = 7.69;
   double width=60.0;
   double magnitude = 60.20797;
   double direction = -4.76364;

   this.BasicMetricsTest(testName,rate,tf,totalHeight,bodyHeight,upperWickHeight,
                         lowerWickHeight,bodyPercent,upperWickPercent,
                         lowerWickPercent,width,magnitude,direction);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CandleMetricsTests::BasicMetricsTest2()
  {
   string testName=__FUNCTION__;

   ENUM_TIMEFRAMES tf=PERIOD_H1;
   datetime t=TimeCurrent();

   MqlRates rate;
   rate.time = t;
   rate.open = 1.0;
   rate.close= 6.0;
   rate.high = 7.0;
   rate.low=0.5;
   rate.spread=23;
   rate.real_volume = 22;
   rate.tick_volume = 21;

   double totalHeight= 6.5;
   double bodyHeight = 5.0;
   double upperWickHeight = 1.0;
   double lowerWickHeight = 0.5;
   double bodyPercent=76.92;
   double upperWickPercent = 15.38;
   double lowerWickPercent = 7.69;
   double width=60.0;
   double magnitude = 60.20797;
   double direction = 4.76364;

   this.BasicMetricsTest(testName,rate,tf,totalHeight,bodyHeight,upperWickHeight,
                         lowerWickHeight,bodyPercent,upperWickPercent,
                         lowerWickPercent,width,magnitude,direction);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CandleMetricsTests::BasicMetricsTest(string testName,MqlRates &rate,ENUM_TIMEFRAMES tf,double totalHeight,double bodyHeight,
                                     double upperWickHeight,double lowerWickHeight,double bodyPercent,
                                     double upperWickPercent,double lowerWickPercent,double width,
                                     double magnitude,double direction)
  {
   this.unitTest.addTest(testName);

   CandleMetrics *metric=new CandleMetrics(rate,tf);
   
   this.unitTest.assertEquals(testName,"Incorrect Time",rate.time,metric.Time);
   this.unitTest.assertEquals(testName,"Incorrect Open",rate.open,metric.Open);
   this.unitTest.assertEquals(testName,"Incorrect High",rate.high,metric.High);
   this.unitTest.assertEquals(testName,"Incorrect Low",rate.low,metric.Low);
   this.unitTest.assertEquals(testName,"Incorrect Close",rate.close,metric.Close);
   this.unitTest.assertEquals(testName,"Incorrect TickVolume",rate.tick_volume,metric.TickVolume);
   this.unitTest.assertEquals(testName,"Incorrect Spread",rate.spread,metric.Spread);
   this.unitTest.assertEquals(testName,"Incorrect RealVolume",rate.real_volume,metric.RealVolume);
   this.unitTest.assertEquals(testName,"Incorrect TotalHeight",totalHeight,metric.TotalHeight);
   this.unitTest.assertEquals(testName,"Incorrect BodyHeight",bodyHeight,metric.BodyHeight);
   this.unitTest.assertEquals(testName,"Incorrect UpperWickHeight",upperWickHeight,metric.UpperWickHeight);
   this.unitTest.assertEquals(testName,"Incorrect LowerWickHeight",lowerWickHeight,metric.LowerWickHeight);
   this.unitTest.assertEquals(testName,"Incorrect BodyPercent",bodyPercent,NormalizeDouble(metric.BodyPercent,2));
   this.unitTest.assertEquals(testName,"Incorrect UpperWickPercent",upperWickPercent,NormalizeDouble(metric.UpperWickPercent,2));
   this.unitTest.assertEquals(testName,"Incorrect LowerWickPercent",lowerWickPercent,NormalizeDouble(metric.LowerWickPercent,2));
   this.unitTest.assertEquals(testName,"Incorrect Width",width,metric.Width);
   this.unitTest.assertEquals(testName,"Incorrect Magnitude",magnitude,NormalizeDouble(metric.Magnitude,5));
   this.unitTest.assertEquals(testName,"Incorrect Direction",direction,NormalizeDouble(metric.Direction,5));
   
   delete metric;
  }
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   CandleMetricsTests *tests=new CandleMetricsTests();
   tests.RunAllTests();
   delete tests;
  }
//+------------------------------------------------------------------+
