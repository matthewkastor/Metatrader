//+------------------------------------------------------------------+
//|                                                          MPC.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property description "Does Magic."
#property strict

#include <Common\Comparators.mqh>
#include <PLManager\PLManager.mqh>
#include <Schedule\ScheduleSet.mqh>
#include <Signals\SignalSet.mqh>
#include <Signals\ExtremeBreak.mqh>
#include <Common\Utils.mqh>
#include <stdlib.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MPC
  {
private:
   bool              deleteLogger;
public:
   SymbolSet        *allowedSymbols;
   ScheduleSet      *schedule;
   OrderManager     *orderManager;
   PLManager        *plmanager;
   SignalSet        *signalSet;
   BaseLogger       *logger;
   datetime          time;
   double            lotSize;
                     MPC(double lots,SymbolSet *aAllowedSymbolSet,ScheduleSet *aSchedule,OrderManager *aOrderManager,PLManager *aPlmanager,SignalSet *aSignalSet,BaseLogger *aLogger);
                    ~MPC();
   bool              Validate(ValidationResult *validationResult);
   bool              Validate();
   bool              ValidateAndLog();
   void              ExpertOnInit();
   void              ExpertOnTick();
   bool              CanTrade();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MPC::MPC(double lots,SymbolSet *aAllowedSymbolSet,ScheduleSet *aSchedule,OrderManager *aOrderManager,PLManager *aPlmanager,SignalSet *aSignalSet,BaseLogger *aLogger=NULL)
  {
   this.lotSize=lots;
   this.allowedSymbols=aAllowedSymbolSet;
   this.schedule=aSchedule;
   this.orderManager=aOrderManager;
   this.plmanager=aPlmanager;
   this.signalSet=aSignalSet;
   if(aLogger==NULL)
     {
      this.logger=new BaseLogger();
      this.deleteLogger=true;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MPC::~MPC()
  {
   if(this.deleteLogger==true)
     {
      delete this.logger;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MPC::Validate()
  {
   ValidationResult *validationResult=new ValidationResult();
   return this.Validate(validationResult);
   delete validationResult;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MPC::Validate(ValidationResult *validationResult)
  {
   validationResult.Result=true;
   Comparators compare;

   bool omv=this.orderManager.Validate(validationResult);
   bool plv=this.plmanager.Validate(validationResult);
   bool sigv=this.signalSet.Validate(validationResult);

   validationResult.Result=(omv && plv && sigv);

   if(!compare.IsGreaterThan(this.lotSize,(double)0))
     {
      validationResult.AddMessage("Lots must be greater than zero.");
      validationResult.Result=false;
     }

   return validationResult.Result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MPC::ValidateAndLog()
  {
   string border[]=
     {
      "",
      "!~ !~ !~ !~ !~ User Settings validation failed ~! ~! ~! ~! ~!",
      ""
     };
   ValidationResult *v=new ValidationResult();
   bool out=this.Validate(v);
   if(out==false)
     {
      this.logger.Log(border);
      this.logger.Warn(v.Messages);
      this.logger.Log(border);
     }
   delete v;
   return out;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MPC::ExpertOnInit()
  {
   if(!this.ValidateAndLog())
     {
      ExpertRemove();
     }
   this.allowedSymbols.LoadSymbolsInMarketWatch();
   this.allowedSymbols.LoadSymbolsHistory((ENUM_TIMEFRAMES)Period(),true);
   int k=this.allowedSymbols.Symbols.Count();
   int i;
   string sym;
   for(i=0;i<k;i++)
     {
      if(this.allowedSymbols.Symbols.TryGetValue(i,sym))
        {
         Utils::OpenChartIfMissing(sym,(ENUM_TIMEFRAMES)Period());
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MPC::ExpertOnTick()
  {
   if(!this.CanTrade())
     {
      return;
     }
   if(true || Time[0]!=this.time)
     {
      this.time=Time[0];
      if(this.schedule.IsActive(TimeCurrent()))
        {
         string symbol;
         int k=this.allowedSymbols.Symbols.Count();
         if(k>0)
           {
            for(int i=0;i<k;i++)
              {
               if(this.allowedSymbols.Symbols.TryGetValue(i,symbol))
                 {
                  this.signalSet.Analyze(symbol);
                  if(this.signalSet.Signal!=NULL)
                    {
                     SignalResult *r=this.signalSet.Signal;
                     if(r.isSet==true)
                       {
                        if(this.orderManager.PairOpenPositionCount(r.symbol,TimeCurrent())<1)
                          {
                           double minStops=(MarketInfo(r.symbol,MODE_STOPLEVEL)+MarketInfo(r.symbol,MODE_SPREAD))*MarketInfo(r.symbol,MODE_POINT);
                           double tpd=MathAbs(r.price - r.takeProfit);
                           double sld=MathAbs(r.price - r.stopLoss);
                           if(sld>minStops && tpd>minStops)
                             {
                              int d=(int)SymbolInfoInteger(r.symbol,SYMBOL_DIGITS);
                              int ticket=OrderSend(
                                                   (string)r.symbol,
                                                   (ENUM_ORDER_TYPE)r.orderType,
                                                   NormalizeDouble(this.lotSize,2),
                                                   NormalizeDouble(r.price,d),
                                                   (int)this.orderManager.Slippage,
                                                   NormalizeDouble(r.stopLoss,d),
                                                   NormalizeDouble(r.takeProfit,d));
                              if(ticket<0)
                                {
                                 this.logger.Error("OrderSend Error : "+ ErrorDescription(GetLastError()));
                                 this.logger.Error(StringConcatenate(
                                                   "Order Sent : symbol= ",r.symbol,
                                                   ", type= ",EnumToString((ENUM_ORDER_TYPE)r.orderType),
                                                   ", lots= ",NormalizeDouble(this.lotSize,2),
                                                   ", price= ",NormalizeDouble(r.price,d),
                                                   ", slippage= ",this.orderManager.Slippage,
                                                   ", stop loss= ",NormalizeDouble(r.stopLoss,d),
                                                   ", take profit=  ",NormalizeDouble(r.takeProfit,d)));
                                 if(IsTesting())
                                   {
                                    ExpertRemove();
                                   }
                                }
                             }
                          }
                       }
                    }
                 }
              }
           }
        }
     }
   this.plmanager.Execute();
  }
//+------------------------------------------------------------------+
//|Rules to stop the bot from even trying to trade                   |
//+------------------------------------------------------------------+
bool MPC::CanTrade()
  {
   return this.plmanager.CanTrade();
  }
//+------------------------------------------------------------------+
