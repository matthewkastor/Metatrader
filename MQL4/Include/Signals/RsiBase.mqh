//+------------------------------------------------------------------+
//|                                                      RsiBase.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <Signals\AbstractSignal.mqh>
#include <Signals\Config\RsiBaseConfig.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class RsiBase : public AbstractSignal
  {
protected:
   ENUM_APPLIED_PRICE _appliedPrice;
   HighLowThresholds _wideband;
public:
                     RsiBase(RsiBaseConfig &config,AbstractSignal *aSubSignal=NULL);
   virtual bool      DoesSignalMeetRequirements();
   virtual bool      Validate(ValidationResult *v);
   virtual double    GetRsi(string symbol,int shift);
   virtual bool      IsOverbought(string symbol,int shift);
   virtual bool      IsOversold(string symbol,int shift);
   virtual bool      IsBullish(string symbol,int shift);
   virtual bool      IsBearish(string symbol,int shift);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
RsiBase::RsiBase(RsiBaseConfig &config,AbstractSignal *aSubSignal=NULL):AbstractSignal(config,aSubSignal)
  {
   this._appliedPrice=config.AppliedPrice;
   this._wideband=config.Wideband;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool RsiBase::Validate(ValidationResult *v)
  {
   AbstractSignal::Validate(v);
   
   if(this._compare.IsNotBetween(this._wideband.High,0.0,100.0))
     {
      v.Result=false;
      v.AddMessage("Wideband High must be between 0 and 100.");
     }
   
   if(this._compare.IsNotBetween(this._wideband.Low,0.0,100.0))
     {
      v.Result=false;
      v.AddMessage("Wideband Low must be between 0 and 100.");
     }

   return v.Result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool RsiBase::DoesSignalMeetRequirements()
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
double RsiBase::GetRsi(string symbol,int shift)
  {
   return this.GetRsi(symbol,shift,this._appliedPrice);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool RsiBase::IsOverbought(string symbol,int shift)
  {
   return this._compare.IsGreaterThanOrEqualTo(this.GetRsi(symbol,shift),this._wideband.High);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool RsiBase::IsOversold(string symbol,int shift)
  {
   return this._compare.IsLessThanOrEqualTo(this.GetRsi(symbol,shift),this._wideband.Low);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool RsiBase::IsBullish(string symbol,int shift)
  {
   return this._compare.IsGreaterThan(this.GetRsi(symbol,shift),50.0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool RsiBase::IsBearish(string symbol,int shift)
  {
   return this._compare.IsLessThan(this.GetRsi(symbol,shift),50.0);
  }
//+------------------------------------------------------------------+
