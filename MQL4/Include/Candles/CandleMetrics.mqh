//+------------------------------------------------------------------+
//|                                                CandleMetrics.mqh |
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
class CandleMetrics
  {
private:
   double            GetUpperWickHeight(void);
   double            GetLowerWickHeight(void);
   double            GetDirection(void);
public:
                     CandleMetrics(MqlRates &rates,ENUM_TIMEFRAMES timeframe);
                    ~CandleMetrics();
   bool              HasTag(string tagName);
   void              AddTag(string tag);
   datetime          Time;             // Period start time
   double            Open;             // Open price
   double            High;             // The highest price of the period
   double            Low;              // The lowest price of the period
   double            Close;            // Close price
   long              TickVolume;       // Tick volume
   int               Spread;           // Spread
   long              RealVolume;       // Trade volume
   double            TotalHeight;      // Difference between high and low
   double            BodyHeight;       // Difference between open and close
   double            UpperWickHeight;  // Height of upper wick
   double            LowerWickHeight;  // Height of lower wick
   double            BodyPercent;      // Height of the candle body relative to the total height, in percent.
   double            UpperWickPercent; // Height of the upper wick relative to total height, in percent.
   double            LowerWickPercent; // Height of the lower wick relative to total height, in percent.
   double            Width;            // Candle width in seconds
   double            Magnitude;        // The magnitude of the candle from open to close
   double            Direction;        // The direction of the candle vector, in degrees
   string            Tags[];             // Descriptive tokens describing this candle
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CandleMetrics::CandleMetrics(MqlRates &rates,ENUM_TIMEFRAMES timeframe)
  {
   this.Time = rates.time;
   this.Open = rates.open;
   this.High = rates.high;
   this.Low=rates.low;
   this.Close=rates.close;
   this.TickVolume=rates.tick_volume;
   this.Spread=rates.spread;
   this.RealVolume=rates.real_volume;
   this.TotalHeight= rates.high-rates.low;
   this.BodyHeight = MathAbs(rates.open-rates.close);
   this.UpperWickHeight = GetUpperWickHeight(); // Height of upper wick
   this.LowerWickHeight = GetLowerWickHeight(); // Height of lower wick
   this.BodyPercent=100 *(this.BodyHeight/this.TotalHeight); // Height of the candle body relative to the total height, in percent.
   this.UpperWickPercent = 100 * (this.UpperWickHeight / this.TotalHeight); // Height of the upper wick relative to total height, in percent.
   this.LowerWickPercent = 100 * (this.LowerWickHeight / this.TotalHeight); // Height of the lower wick relative to total height, in percent.
   this.Width=(double)PeriodSeconds(timeframe)/60.0; // Candle width in minutes
   this.Magnitude=MathSqrt(MathPow(this.BodyHeight,2)+MathPow(this.Width,2)); // The magnitude of the candle from open to close
   this.Direction=GetDirection(); // The direction of the candle vector, in degrees
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CandleMetrics::~CandleMetrics()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CandleMetrics::GetUpperWickHeight(void)
  {
   double result = 0;
   if(this.Open >= this.Close)
     {
      result=this.High-this.Open;
     }
   else
     {
      result=this.High-this.Close;
     }
   if(result<0)
     {
      result=0;
     }
   return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CandleMetrics::GetLowerWickHeight(void)
  {
   double result = 0;
   if(this.Open <= this.Close)
     {
      result=this.Open-this.Low;
     }
   else
     {
      result=this.Close-this.Low;
     }
   if(result<0)
     {
      result=0;
     }
   return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CandleMetrics::GetDirection(void)
  {
   double result=0;
   double t=(this.Close-this.Open)/this.Width;
   double r= MathArctan(t); // radians
   result = r*(180.0/M_PI); // degrees
   return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CandleMetrics::HasTag(string tagName)
  {
   int sz=ArraySize(this.Tags);
   int x = 0;
   for(x=0;x<sz;x++)
     {
      if(this.Tags[x]==tagName)
        {
         return true;
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CandleMetrics::AddTag(string tag)
  {
   if(this.HasTag(tag))
     {
      return;
     }

   int sz=ArraySize(this.Tags);
   ArrayResize(this.Tags,sz+1);
   this.Tags[sz]=tag;
  }
//+------------------------------------------------------------------+
