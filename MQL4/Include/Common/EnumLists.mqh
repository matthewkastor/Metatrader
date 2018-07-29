//+------------------------------------------------------------------+
//|                                                    EnumLists.mqh |
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
class EnumLists
  {
public:
   static const ENUM_TIMEFRAMES TimeframesAll[];
   static const ENUM_TIMEFRAMES TimeframesOnline[];
  };
static const ENUM_TIMEFRAMES EnumLists::TimeframesAll[]=
  {
   PERIOD_M1,
   PERIOD_M2,
   PERIOD_M3,
   PERIOD_M4,
   PERIOD_M5,
   PERIOD_M6,
   PERIOD_M10,
   PERIOD_M12,
   PERIOD_M15,
   PERIOD_M20,
   PERIOD_M30,
   PERIOD_H1,
   PERIOD_H2,
   PERIOD_H3,
   PERIOD_H4,
   PERIOD_H6,
   PERIOD_H8,
   PERIOD_D1,
   PERIOD_W1,
   PERIOD_MN1
  };
static const ENUM_TIMEFRAMES EnumLists::TimeframesOnline[]=
  {
   PERIOD_M1,
   PERIOD_M5,
   PERIOD_M15,
   PERIOD_M30,
   PERIOD_H1,
   PERIOD_H4,
   PERIOD_D1,
   PERIOD_W1,
   PERIOD_MN1
  };
//+------------------------------------------------------------------+
