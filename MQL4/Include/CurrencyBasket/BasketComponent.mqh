//+------------------------------------------------------------------+
//|                                              BasketComponent.mqh |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class BasketComponent
  {
private:
   string            _baseCurrency,_counterCurrency;
   double            _pointValue,_pointFactor;
   datetime          _pointCacheTime;
   int               _pointCacheExpiresIn;
public:
   string            Symbol_Name; // Name of the symbol
   double            Weight; // Weight in the basket
   string            Direction; // buy or sell

   void BasketComponent()
     {
      _baseCurrency="";
      _counterCurrency="";
      _pointValue=0;
      _pointFactor=0;
      _pointCacheTime=0;
      _pointCacheExpiresIn=60*5;
     }

   string GetBaseCurrency()
     {
      if(_baseCurrency=="")
        {
         _baseCurrency=SymbolInfoString(Symbol_Name,SYMBOL_CURRENCY_BASE);
        }
      return _baseCurrency;
     }

   string GetCounterCurrency()
     {
      if(_counterCurrency=="")
        {
         _counterCurrency=SymbolInfoString(Symbol_Name,SYMBOL_CURRENCY_PROFIT);
        }
      return _counterCurrency;
     }

   bool DoesSymbolExist()
     {
      bool out=false;
      int ct=SymbolsTotal(false);
      for(int i=0; i<ct; i++)
        {
         if(Symbol_Name==SymbolName(i,false))
           {
            out=true;
           }
        }
      return out;
     }

   bool IsSymbolWatched()
     {
      bool out=false;
      int ct=SymbolsTotal(true);
      for(int i=0; i<ct; i++)
        {
         if(Symbol_Name==SymbolName(i,true))
           {
            out=true;
           }
        }
      return out;
     }

   bool AddSymbolToMarketWatch()
     {
      bool result=false;
      if(IsSymbolWatched())
        {
         result=true;
        }
      else if(DoesSymbolExist())
        {
         result=SymbolSelect(Symbol_Name,true);
        }
      return result;
     }

   bool RemoveSymbolFromMarketWatch()
     {
      bool result=false;
      if(!IsSymbolWatched())
        {
         result=true;
        }
      else
        {
         result=SymbolSelect(Symbol_Name,false);
        }
      return result;
     }

   double GetPointFactor()
     {
      if(_pointFactor==0)
        {
         _pointFactor=MathPow(10,MarketInfo(Symbol_Name,MODE_DIGITS));
        }
      return _pointFactor;
     }

   double GetPointValue()
     {
      if(_pointValue==0 || (_pointCacheTime+_pointCacheExpiresIn)<TimeCurrent())
        {
         _pointCacheTime=TimeCurrent();
         _pointValue=MarketInfo(Symbol_Name,MODE_TICKVALUE)/(MarketInfo(Symbol_Name,MODE_TICKSIZE)/MarketInfo(Symbol_Name,MODE_POINT));
        }
      return _pointValue;
     }

   double GetWeightedPoints(int index)
     {
      double output=0;
      double pv=GetPointValue();
      _pointFactor=GetPointFactor();
      double h=iHigh(Symbol_Name,Period(),index);
      double l=iLow(Symbol_Name,Period(),index);
      double o=iOpen(Symbol_Name,Period(),index);
      double c=iClose(Symbol_Name,Period(),index);
      double typical=(h+l+o+c)/4;
      output=typical*Weight*_pointFactor*pv;
      StringToLower(Direction);
      if(Direction=="sell")
        {
         output=output*-1;
        }
      return output;
     }

   double GetWeightedVolume(int index)
     {
      double pv=GetPointValue();
      return Weight * iVolume(Symbol_Name,Period(),index) * pv;
     }
  };
//+------------------------------------------------------------------+
