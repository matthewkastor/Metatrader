//+------------------------------------------------------------------+
//|                                             CandleTaggerBase.mqh |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict

#include <Candles\CandleMetrics.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CandleTaggerBase
  {
private:

protected:

public:
   string            Name;
                     CandleTaggerBase(string name);
                    ~CandleTaggerBase();
   bool              TagCandle(CandleMetrics &candleMetrics);
   virtual bool      Analyze(CandleMetrics &candleMetrics) { return false; }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CandleTaggerBase::TagCandle(CandleMetrics &candleMetrics)
  {

   if(candleMetrics.HasTag(this.Name))
     {
      return true;
     }

   if(this.Analyze(candleMetrics))
     {
      candleMetrics.AddTag(this.Name);
      return true;
     }

   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CandleTaggerBase::CandleTaggerBase(string name)
  {
   this.Name=name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CandleTaggerBase::~CandleTaggerBase()
  {
  }
//+------------------------------------------------------------------+
