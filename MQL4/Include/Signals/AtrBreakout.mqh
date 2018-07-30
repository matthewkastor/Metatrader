//+------------------------------------------------------------------+
//|                                                  AtrBreakout.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <Signals\AtrBase.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class AtrBreakout : public AtrBase
  {
public:
                     AtrBreakout(int period,double atrMultiplier,ENUM_TIMEFRAMES timeframe,int shift=0,double minimumSpreadsTpSl=1,color indicatorColor=clrAquamarine);
   SignalResult     *Analyzer(string symbol,int shift);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
AtrBreakout::AtrBreakout(int period,double atrMultiplier,ENUM_TIMEFRAMES timeframe,int shift=0,double minimumSpreadsTpSl=1,color indicatorColor=clrAquamarine):AtrBase(period,atrMultiplier,timeframe,shift,minimumSpreadsTpSl,indicatorColor)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SignalResult *AtrBreakout::Analyzer(string symbol,int shift)
  {
   PriceRange pr=this.CalculateRangeByPriceLowHighMidpoint(symbol,shift);

   this.DrawIndicatorRectangle(symbol,shift,pr.high,pr.low);

   MqlTick tick;
   bool gotTick=SymbolInfoTick(symbol,tick);

   if(gotTick)
     {
      if(tick.ask<=pr.mid)
        {
         this.Signal.isSet=true;
         this.Signal.time=tick.time;
         this.Signal.symbol=symbol;
         this.Signal.orderType=OP_SELL;
         this.Signal.price=tick.bid;
         this.Signal.stopLoss=(tick.ask+MathAbs(pr.high-pr.mid));
         this.Signal.takeProfit=(tick.ask-MathAbs(pr.low-pr.mid));
        }
      if(tick.bid>=pr.mid)
        {
         this.Signal.isSet=true;
         this.Signal.orderType=OP_BUY;
         this.Signal.price=tick.ask;
         this.Signal.symbol=symbol;
         this.Signal.time=tick.time;
         this.Signal.stopLoss=(tick.bid-MathAbs(pr.mid-pr.low));
         this.Signal.takeProfit=(tick.bid+MathAbs(pr.mid-pr.high));
        }
     }
   return this.Signal;
  }
//+------------------------------------------------------------------+
