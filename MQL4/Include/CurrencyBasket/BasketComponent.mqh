//+------------------------------------------------------------------+
//|                                              BasketComponent.mqh |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict

#include <Common\Strings.mqh>
#include <MarketWatch\MarketWatch.mqh>
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
   void              BasketComponent();
   bool              DoesSymbolExist();
   bool              IsSymbolWatched();
   bool              AddSymbolToMarketWatch();
   bool              RemoveSymbolFromMarketWatch();
   string            GetBaseCurrency();
   string            GetCounterCurrency();
   double            GetPointFactor();
   double            GetPointValue();
   double            GetWeightedPoints(int index);
   double            GetWeightedVolume(int index);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BasketComponent::BasketComponent()
  {
   this._baseCurrency="";
   this._counterCurrency="";
   this._pointValue=0;
   this._pointFactor=0;
   this._pointCacheTime=0;
   this._pointCacheExpiresIn=60*5;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string BasketComponent::GetBaseCurrency()
  {
   if(Strings::IsNullOrBlank(this._baseCurrency))
     {
      this._baseCurrency=SymbolInfoString(this.Symbol_Name,SYMBOL_CURRENCY_BASE);
     }
   return this._baseCurrency;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string BasketComponent::GetCounterCurrency()
  {
   if(Strings::IsNullOrBlank(this._counterCurrency))
     {
      this._counterCurrency=SymbolInfoString(this.Symbol_Name,SYMBOL_CURRENCY_PROFIT);
     }
   return this._counterCurrency;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double BasketComponent::GetPointFactor()
  {
   if(this._pointFactor==0)
     {
      this._pointFactor=MathPow(10,MarketInfo(this.Symbol_Name,MODE_DIGITS));
     }
   return this._pointFactor;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double BasketComponent::GetPointValue()
  {
   if(this._pointValue==0 || (this._pointCacheTime+this._pointCacheExpiresIn)<TimeCurrent())
     {
      this._pointCacheTime=TimeCurrent();
      this._pointValue=MarketInfo(this.Symbol_Name,MODE_TICKVALUE)/(MarketInfo(this.Symbol_Name,MODE_TICKSIZE)/MarketInfo(this.Symbol_Name,MODE_POINT));
     }
   return this._pointValue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double BasketComponent::GetWeightedPoints(int index)
  {
   double output=0;
   double pv=GetPointValue();
   this._pointFactor=GetPointFactor();
   double h=iHigh(this.Symbol_Name,Period(),index);
   double l=iLow(this.Symbol_Name,Period(),index);
   double o=iOpen(this.Symbol_Name,Period(),index);
   double c=iClose(this.Symbol_Name,Period(),index);
   double typical=(h+l+o+c)/4;
   output=typical*this.Weight*this._pointFactor*pv;
   StringToLower(this.Direction);
   if(this.Direction=="sell")
     {
      output=output*-1;
     }
   return output;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double BasketComponent::GetWeightedVolume(int index)
  {
   double pv=GetPointValue();
   return this.Weight * iVolume(this.Symbol_Name,Period(),index) * pv;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool BasketComponent::DoesSymbolExist()
  {
   return MarketWatch::DoesSymbolExist(this.Symbol_Name);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool BasketComponent::IsSymbolWatched()
  {
   return MarketWatch::IsSymbolWatched(this.Symbol_Name);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool BasketComponent::AddSymbolToMarketWatch()
  {
   return MarketWatch::AddSymbolToMarketWatch(this.Symbol_Name);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool BasketComponent::RemoveSymbolFromMarketWatch()
  {
   return MarketWatch::RemoveSymbolFromMarketWatch(this.Symbol_Name);
  }
//+------------------------------------------------------------------+
