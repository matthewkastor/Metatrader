//+------------------------------------------------------------------+
//|                                            CandlePatternBase.mqh |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict

#include <Candles\CandleTaggerCollection.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CandlePatternBase
  {
private:

protected:

public:
   string            Name;
   double            Priority;
   int               CandleCount;
   CandleTaggerCollection *CandleTaggerCollections[];
                     CandlePatternBase(string patternName,double priority,int candleCount,CandleTaggerCollection *&candleTaggerCollections[]);
                    ~CandlePatternBase();
   bool              Scan(CandleMetrics &candleMetricsArr[]);
   virtual bool      Analyze(CandleMetrics &candleMetricsArr[]) { return false; }
   virtual bool      Action(CandleMetrics &candleMetricsArr[]) { return false; }
   void              SetCandleTaggerCollections(CandleTaggerCollection *&candleTaggerCollections[]);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CandlePatternBase::CandlePatternBase(string patternName,double priority,int candleCount,CandleTaggerCollection *&candleTaggerCollections[])
  {
   this.Name=patternName;
   this.Priority=priority;
   this.CandleCount=candleCount;
   this.SetCandleTaggerCollections(candleTaggerCollections);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CandlePatternBase::~CandlePatternBase()
  {
  }
//+------------------------------------------------------------------+
//| Populates the tagger series array.                               |
//+------------------------------------------------------------------+
void CandlePatternBase::SetCandleTaggerCollections(CandleTaggerCollection *&candleTaggerCollections[])
  {
   int sz=ArraySize(candleTaggerCollections);
   ArrayResize(CandleTaggerCollections,sz);
   int x= 0;
   for(x=0; x<sz; x++)
     {
      CandleTaggerCollections[x]=candleTaggerCollections[x];
     }
  }
//+------------------------------------------------------------------+
//| Scan candles in search of the pattern.                           |
//+------------------------------------------------------------------+
bool CandlePatternBase::Scan(CandleMetrics &candleMetricsArr[])
  {
   if(this.CandleCount<1)
     {
      return false;
     }

   int metricsSize=ArraySize(candleMetricsArr);

   if(metricsSize<1 || metricsSize<this.CandleCount)
     {
      return false;
     }

   int taggerCollectionSize=ArraySize(this.CandleTaggerCollections);

   if(taggerCollectionSize<1)
     {
      return false;
     }

   int metricIndex=0;
   int taggerIndex=0;
   int taggerIndexSize=0;
   for(metricIndex=0; metricIndex<this.CandleCount; metricIndex++)
     {
      taggerIndexSize=ArraySize(this.CandleTaggerCollections[metricIndex].CandleTaggers);
      for(taggerIndex=0; taggerIndex<taggerIndexSize; taggerIndex++)
        {
         this.CandleTaggerCollections[metricIndex].CandleTaggers[taggerIndex].TagCandle(candleMetricsArr[metricIndex]);

         if(!(candleMetricsArr[metricIndex].HasTag(this.CandleTaggerCollections[metricIndex].CandleTaggers[taggerIndex].Name)))
           {
            return false;
           }
        }
     }

   return this.Analyze(candleMetricsArr);
  }
//+------------------------------------------------------------------+
