//+------------------------------------------------------------------+
//|                                                CodeGenerator.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include<CodeGenerator\CodeGenerator.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnStart()
  {
   string p=CodeGenerator::EnumToArrayDef(PERIOD_M1);
   Print(p);
  }
//+------------------------------------------------------------------+
