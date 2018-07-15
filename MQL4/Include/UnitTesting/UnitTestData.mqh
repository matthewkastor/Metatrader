//+------------------------------------------------------------------+
//|                                                 UnitTestData.mqh |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict

//based on GPL3 licensed work by micclly
//#property copyright "Copyright 2014, micclly."
//#property link      "https://github.com/micclly"

#include <Object.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class UnitTestData : public CObject
  {
public:
   string            m_name;
   bool              m_result;
   string            m_message;
   bool              m_asserted;

                     UnitTestData(string name);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
UnitTestData::UnitTestData(string name)
   : m_name(name),m_result(false),m_message(""),m_asserted(false)
  {
  }
//+------------------------------------------------------------------+
