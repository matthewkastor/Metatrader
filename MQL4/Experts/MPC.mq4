//+------------------------------------------------------------------+
//|                                                              MPC |
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
#include <stdlib.mqh>
#include <MPC\MPC.mqh>

input string WatchedSymbols="";
input int ExtremeBreakPeriod=45;
input int ExtremeBreakShift=1;
input double Lots=0.04;
input double ProfitTarget=13; // Profit target in account currency
input double MaxLoss=9; // Maximum allowed loss in account currency
input int Slippage=10; // Allowed slippage
extern ENUM_DAY_OF_WEEK Start_Day=1;//Start Day
extern ENUM_DAY_OF_WEEK End_Day=5;//End Day
extern string   Start_Time="12:00";//Start Time
extern string   End_Time="15:00";//End Time
input bool ScheduleIsDaily=true;// Use start and stop times daily?

MPC *mpc;
SymbolSet *ss;
ScheduleSet *sched;
OrderManager *om;
PLManager *plman;
SignalSet *signalSet;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void deinit()
  {
   delete mpc;
   delete ss;
   delete sched;
   delete om;
   delete plman;
   delete signalSet;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void init()
  {
   string symbols=WatchedSymbols;
   ss=new SymbolSet();
   ss.AddSymbolsFromCsv(symbols);

   sched=new ScheduleSet();
   if(ScheduleIsDaily==true)
     {
      sched.AddWeek(Start_Time,End_Time,Start_Day,End_Day);
     }
   else
     {
      sched.Add(new Schedule(Start_Day,Start_Time,End_Day,End_Time));
     }

   om=new OrderManager();
   om.Slippage=Slippage;

   plman=new PLManager(ss,om);
   plman.ProfitTarget=ProfitTarget;
   plman.MaxLoss=MaxLoss;
   plman.MinAge=60;

   signalSet=new SignalSet();
   signalSet.Add(new ExtremeBreak(ExtremeBreakPeriod,(ENUM_TIMEFRAMES)Period(),ExtremeBreakShift));
   signalSet.Add(new ExtremeBreak(ExtremeBreakPeriod,(ENUM_TIMEFRAMES)Period(),ExtremeBreakShift+(ExtremeBreakPeriod*3)));
   signalSet.Add(new ExtremeBreak(ExtremeBreakPeriod,(ENUM_TIMEFRAMES)Period(),ExtremeBreakShift+(ExtremeBreakPeriod*6)));

   mpc=new MPC(Lots,ss,sched,om,plman,signalSet);

   mpc.ExpertOnInit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   mpc.ExpertOnTick();
  }
//+------------------------------------------------------------------+
