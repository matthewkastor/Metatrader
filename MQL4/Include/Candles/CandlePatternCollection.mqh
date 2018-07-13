//+------------------------------------------------------------------+
//|                                      CandlePatternCollection.mqh |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict

#include <Candles\CandlePatternBase.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CandlePatternCollection
  {
private:

public:
                     CandlePatternCollection(CandlePatternBase *&candlePatterns[]);
                    ~CandlePatternCollection();
   CandlePatternBase *CandlePatterns[];
   void              SetCandlePatterns(CandlePatternBase *&candlePatterns[]);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CandlePatternCollection::CandlePatternCollection(CandlePatternBase *&candlePatterns[])
  {
   this.SetCandlePatterns(candlePatterns);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CandlePatternCollection::~CandlePatternCollection()
  {
  }
//+------------------------------------------------------------------+
//| Populates the pattern series array.                              |
//+------------------------------------------------------------------+
void CandlePatternCollection::SetCandlePatterns(CandlePatternBase *&candlePatterns[])
  {
   int sz=ArraySize(candlePatterns);
   ArrayResize(CandlePatterns,sz);
   int x= 0;
   for(x=0; x<sz; x++)
     {
      CandlePatterns[x]=candlePatterns[x];
     }
  }
//+------------------------------------------------------------------+
