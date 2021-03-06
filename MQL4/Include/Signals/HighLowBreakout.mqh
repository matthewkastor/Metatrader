//+------------------------------------------------------------------+
//|                                              HighLowBreakout.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <Signals\HighLowBase.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class HighLowBreakout : public HighLowBase
  {
private:
   bool              _invertedSignal;
public:
                     HighLowBreakout(int period,ENUM_TIMEFRAMES timeframe,int shift=2,double minimumSpreadsTpSl=1,color indicatorColor=clrAquamarine);
   SignalResult     *Analyzer(string symbol,int shift);
   void InvertedSignal(bool invertSignal) { this._invertedSignal=invertSignal; }
   bool InvertedSignal() { return this._invertedSignal; }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
HighLowBreakout::HighLowBreakout(int period,ENUM_TIMEFRAMES timeframe,int shift=2,double minimumSpreadsTpSl=1,color indicatorColor=clrAquamarine):HighLowBase(period,timeframe,shift,minimumSpreadsTpSl,indicatorColor)
  {
   this._invertedSignal=true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SignalResult *HighLowBreakout::Analyzer(string symbol,int shift)
  {
   PriceRange pr=this.CalculateRange(symbol,shift);

   
   PriceRange t1 = this.CalculateRangeByPriceLowHigh(symbol,shift);
   PriceRange t2 = this.CalculateRangeByPriceLowHigh(symbol,shift+(this.Period()*2));
   if((t1.high < t2.low) || (t2.high < t1.low))
   {
      this.InvertedSignal(false);
   }
   else
   {
      this.InvertedSignal(true);
   }

   MqlTick tick;
   bool gotTick=SymbolInfoTick(symbol,tick);
   bool sell=(tick.bid<pr.low);
   bool buy=(tick.ask>pr.high);
   bool sellSignal=(_compare.Ternary(this.InvertedSignal(),buy,sell));
   bool buySignal=(_compare.Ternary(this.InvertedSignal(),sell,buy));
   
   
   if(gotTick && sellSignal!=buySignal)
     {
      if(sellSignal)
        {
         this.Signal.isSet=true;
         this.Signal.time=tick.time;
         this.Signal.symbol=symbol;
         this.Signal.orderType=OP_SELL;
         this.Signal.price=tick.bid;
         this.Signal.stopLoss=0;
         this.Signal.takeProfit=0;
        }
      else if(buySignal)
        {
         this.Signal.isSet=true;
         this.Signal.orderType=OP_BUY;
         this.Signal.price=tick.ask;
         this.Signal.symbol=symbol;
         this.Signal.time=tick.time;
         this.Signal.stopLoss=0;
         this.Signal.takeProfit=0;
        }
     }
     
   this.DrawIndicatorRectangle(symbol,shift+(this.Period()*2),t2.high,t2.low,"_t2");
   this.DrawIndicatorRectangle(symbol,shift,pr.high,pr.low);
   
   return this.Signal;
  }
//+------------------------------------------------------------------+
