//+------------------------------------------------------------------+
//|                                           BollingerBandsBase.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <Common\Comparators.mqh>
#include <Signals\AbstractSignal.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class BollingerBandsBase : public AbstractSignal
  {
protected:
   double            _bbDeviation;
   int               _bbShift;
   ENUM_APPLIED_PRICE _bbAppliedPrice;
   virtual PriceRange GetBollingerBand(string symbol,int shift);
   virtual double GetBollingerBandUpper(string symbol,int shift);
   virtual double GetBollingerBandMain(string symbol,int shift);
   virtual double GetBollingerBandLower(string symbol,int shift);
   virtual PriceRange CalculateRange(string symbol,int shift);

public:
                     BollingerBandsBase(int period,ENUM_TIMEFRAMES timeframe,double bbDeviation,int bbShift,ENUM_APPLIED_PRICE bbAppliedPrice,int shift=0,double minimumSpreadsTpSl=1,color indicatorColor=clrAquamarine);
   virtual bool      DoesSignalMeetRequirements();
   virtual bool      Validate(ValidationResult *v);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BollingerBandsBase::BollingerBandsBase(int period,ENUM_TIMEFRAMES timeframe,double bbDeviation,int bbShift,ENUM_APPLIED_PRICE bbAppliedPrice,int shift=0,double minimumSpreadsTpSl=1,color indicatorColor=clrAquamarine):AbstractSignal(period,timeframe,shift,indicatorColor,minimumSpreadsTpSl)
  {
   this._bbDeviation=bbDeviation;
   this._bbShift=bbShift;
   this._bbAppliedPrice=bbAppliedPrice;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool BollingerBandsBase::Validate(ValidationResult *v)
  {
   AbstractSignal::Validate(v);

   if(!this._compare.IsGreaterThan(this._bbDeviation,0.0))
     {
      v.Result=false;
      v.AddMessage("BollingerBands Multiplier must be greater than zero.");
     }

   if(!this._compare.IsNotBelow(this._bbShift,0))
     {
      v.Result=false;
      v.AddMessage("BollingerBands shift must be 0 or greater.");
     }

   return v.Result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool BollingerBandsBase::DoesSignalMeetRequirements()
  {
   if(!(AbstractSignal::DoesSignalMeetRequirements()))
     {
      return false;
     }

   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
PriceRange BollingerBandsBase::GetBollingerBand(string symbol,int shift)
  {
   return this.GetBollingerBands(symbol,shift,this._bbDeviation,this._bbShift,this._bbAppliedPrice);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double BollingerBandsBase::GetBollingerBandUpper(string symbol,int shift)
  {
   return this.GetBollingerBand(symbol,shift).high;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double BollingerBandsBase::GetBollingerBandMain(string symbol,int shift)
  {
   return this.GetBollingerBand(symbol,shift).mid;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double BollingerBandsBase::GetBollingerBandLower(string symbol,int shift)
  {
   return this.GetBollingerBand(symbol,shift).low;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
PriceRange BollingerBandsBase::CalculateRange(string symbol,int shift)
  {
   PriceRange pr;
   pr.high=this.GetBollingerBandUpper(symbol,shift);
   pr.mid=this.GetBollingerBandMain(symbol,shift);
   pr.low=this.GetBollingerBandLower(symbol,shift);
   return pr;
  }
//+------------------------------------------------------------------+
