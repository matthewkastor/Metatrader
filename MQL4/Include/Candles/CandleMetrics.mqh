//+------------------------------------------------------------------+
//|                                                CandleMetrics.mqh |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict

#include <SpatialReasoning\EuclideanVector.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CandleMetrics
  {
private:

   ENUM_TIMEFRAMES   Timeframe;

   void Initialize(MqlRates &rates,ENUM_TIMEFRAMES timeframe)
     {
      this.IsSet=true;
      this.Timeframe=timeframe;
      this.Time = rates.time;
      this.Open = rates.open;
      this.High = rates.high;
      this.Low=rates.low;
      this.Close=rates.close;
      this.TickVolume=rates.tick_volume;
      this.Spread=rates.spread;
      this.RealVolume=rates.real_volume;
     };

public:
   bool              IsSet;                 // True when candle has been initialized.
   datetime          Time;                  // Period start time
   double            Open;                  // Open price
   double            High;                  // The highest price of the period
   double            Low;                   // The lowest price of the period
   double            Close;                 // Close price
   long              TickVolume;            // Tick volume
   int               Spread;                // Spread
   long              RealVolume;            // Trade volume
   string            Tags[];                // Descriptive tokens describing this candle

   void ~CandleMetrics() {};

   void CandleMetrics(MqlRates &rates,ENUM_TIMEFRAMES timeframe)
     {
      this.Initialize(rates,timeframe);
     };

   void CandleMetrics(string symbol,ENUM_TIMEFRAMES timeframe,int shift)
     {
      MqlRates rates[];
      int copied=CopyRates(symbol,timeframe,shift,1,rates);
      if(copied>0)
        {
         this.Initialize(rates[0],timeframe);
        }
     };

   double GetTotalHeight()
     {
      return this.High-this.Low;
     };

   double GetBodyHeight()
     {
      return MathAbs(this.Open-this.Close);
     };

   double GetWidth()
     {
      return(((double)PeriodSeconds(this.Timeframe))/60.0);
     };

   double GetMagnitude()
     {
      return(MathSqrt(MathPow(this.GetBodyHeight(),2)+MathPow(this.GetWidth(),2)));
     };

   bool HasTag(string tagName)
     {
      int sz=ArraySize(this.Tags);
      int x = 0;
      for(x=0;x<sz;x++)
        {
         if(this.Tags[x]==tagName)
           {
            return true;
           }
        }
      return false;
     };

   void AddTag(string tag)
     {
      if(this.HasTag(tag))
        {
         return;
        }

      int sz=ArraySize(this.Tags);
      ArrayResize(this.Tags,sz+1);
      this.Tags[sz]=tag;
     };

   double GetUpperWickHeight(void)
     {
      double result = 0;
      if(this.Open >= this.Close)
        {
         result=this.High-this.Open;
        }
      else
        {
         result=this.High-this.Close;
        }
      if(result<0)
        {
         result=0;
        }
      return result;
     };

   double GetLowerWickHeight(void)
     {
      double result = 0;
      if(this.Open <= this.Close)
        {
         result=this.Open-this.Low;
        }
      else
        {
         result=this.Close-this.Low;
        }
      if(result<0)
        {
         result=0;
        }
      return result;
     };

   double GetDirection()
     {
      CoordinatePoint initialPoint,terminalPoint;
      terminalPoint.Set(this.GetWidth(),this.GetBodyHeight());
      EuclideanVector v(initialPoint,terminalPoint);
      return v.GetDirectionInDegrees();
     };

   double GetBodyPercent()
     {
      if(this.GetTotalHeight()<=0)
        {
         return 0;
        }
      return(100 *(this.GetBodyHeight()/this.GetTotalHeight()));
     };

   double GetUpperWickPercent()
     {
      if(this.GetTotalHeight()<=0)
        {
         return 0;
        }
      return (100 * (this.GetUpperWickHeight() / this.GetTotalHeight()));
     };

   double GetLowerWickPercent()
     {
      if(this.GetTotalHeight()<=0)
        {
         return 0;
        }
      return (100 * (this.GetLowerWickHeight() / this.GetTotalHeight()));
     };

  };
//+------------------------------------------------------------------+
