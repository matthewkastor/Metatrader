//+------------------------------------------------------------------+
//|                                       CandleTaggerCollection.mqh |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict

#include <Candles\CandleTaggerBase.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CandleTaggerCollection
  {
private:

public:
                     CandleTaggerCollection(CandleTaggerBase *&candleTaggers[]);
                    ~CandleTaggerCollection();
   CandleTaggerBase *CandleTaggers[];
   void              SetCandleTaggers(CandleTaggerBase *&candleTaggers[]);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CandleTaggerCollection::CandleTaggerCollection(CandleTaggerBase *&candleTaggers[])
  {
   this.SetCandleTaggers(candleTaggers);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CandleTaggerCollection::~CandleTaggerCollection()
  {
  }
//+------------------------------------------------------------------+
//| Populates the tagger series array.                               |
//+------------------------------------------------------------------+
void CandleTaggerCollection::SetCandleTaggers(CandleTaggerBase *&candleTaggers[])
  {
   int sz=ArraySize(candleTaggers);
   ArrayResize(CandleTaggers,sz);
   int x= 0;
   for(x=0; x<sz; x++)
     {
      CandleTaggers[x]=candleTaggers[x];
     }
  }
//+------------------------------------------------------------------+
