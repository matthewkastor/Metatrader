//+------------------------------------------------------------------+
//|                                           CandleMetricsTests.mq4 |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict

#include <Candles\CandleMetrics.mqh>
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
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

   CandleMetrics *metric=new CandleMetrics(rate,tf);

   TestEqual(metric.Time, t, "Time");
   TestEqual(metric.Open, rate.open, "Open");
   TestEqual(metric.High, rate.high, "High");
   TestEqual(metric.Low, rate.low, "Low");
   TestEqual(metric.Close, rate.close, "Close");
   TestEqual(metric.TickVolume, rate.tick_volume, "TickVolume");
   TestEqual(metric.Spread, rate.spread, "Spread");
   TestEqual(metric.RealVolume, rate.real_volume, "RealVolume");
   TestEqual(metric.TotalHeight, 6.5, "TotalHeight");
   TestEqual(metric.BodyHeight, 5.0, "BodyHeight");
   TestEqual(metric.UpperWickHeight, 1.0, "UpperWickHeight");
   TestEqual(metric.LowerWickHeight, 0.5, "LowerWickHeight");
   TestEqual(NormalizeDouble(metric.BodyPercent,2), 76.92, "BodyPercent");
   TestEqual(NormalizeDouble(metric.UpperWickPercent,2), 15.38, "UpperWickPercent");
   TestEqual(NormalizeDouble(metric.LowerWickPercent,2), 7.69, "LowerWickPercent");
   TestEqual(metric.Width,60.0,"Width");
   TestEqual(NormalizeDouble(metric.Magnitude,5), 60.20797, "Magnitude");
   TestEqual(NormalizeDouble(metric.Direction,5), -4.76364, "Direction");
   
   delete metric;

   double d=rate.open;
   rate.open=rate.close;
   rate.close=d;
   
   metric=new CandleMetrics(rate,tf);

   TestEqual(metric.Time, t, "Time");
   TestEqual(metric.Open, rate.open, "Open");
   TestEqual(metric.High, rate.high, "High");
   TestEqual(metric.Low, rate.low, "Low");
   TestEqual(metric.Close, rate.close, "Close");
   TestEqual(metric.TickVolume, rate.tick_volume, "TickVolume");
   TestEqual(metric.Spread, rate.spread, "Spread");
   TestEqual(metric.RealVolume, rate.real_volume, "RealVolume");
   TestEqual(metric.TotalHeight, 6.5, "TotalHeight");
   TestEqual(metric.BodyHeight, 5.0, "BodyHeight");
   TestEqual(metric.UpperWickHeight, 1.0, "UpperWickHeight");
   TestEqual(metric.LowerWickHeight, 0.5, "LowerWickHeight");
   TestEqual(NormalizeDouble(metric.BodyPercent,2), 76.92, "BodyPercent");
   TestEqual(NormalizeDouble(metric.UpperWickPercent,2), 15.38, "UpperWickPercent");
   TestEqual(NormalizeDouble(metric.LowerWickPercent,2), 7.69, "LowerWickPercent");
   TestEqual(metric.Width,60.0,"Width");
   TestEqual(NormalizeDouble(metric.Magnitude,5), 60.20797, "Magnitude");
   TestEqual(NormalizeDouble(metric.Direction,5), 4.76364, "Direction");
   
   delete metric;
   Comment("Check the experts tab for failure messages");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TestEqual(datetime actual,datetime expected,string whatFailed)
  {
   if(expected!=actual) PrintFormat("Fail : %s expected %s but was %s",whatFailed,expected,actual);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TestEqual(double actual,double expected,string whatFailed)
  {
   if(expected!=actual) PrintFormat("Fail : %s expected %f but was %f",whatFailed,expected,actual);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TestEqual(long actual,long expected,string whatFailed)
  {
   if(expected!=actual) PrintFormat("Fail : %s expected %f but was %f",whatFailed,expected,actual);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TestEqual(int actual,int expected,string whatFailed)
  {
   if(expected!=actual) PrintFormat("Fail : %d expected %f but was %f",whatFailed,expected,actual);
  }
//+------------------------------------------------------------------+
