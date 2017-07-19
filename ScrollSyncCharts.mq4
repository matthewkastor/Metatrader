//+------------------------------------------------------------------+
//|                                             ScrollSyncCharts.mq4 |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict
#property script_show_inputs

input ENUM_TIMEFRAMES OtherTimeframe=1440;
input int UpdateFrequency=50;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   datetime some_time;
   long chartId=0;
   chartId=ChartOpen(Symbol(),OtherTimeframe);
   if(!(chartId>0))
     {
      Print(GetLastError());
     }
   ChartSetInteger(chartId,CHART_AUTOSCROLL,false);
   ChartSetInteger(chartId,CHART_SHIFT,false);
   ChartSetInteger(chartId,CHART_MODE,0,CHART_CANDLES);

   int shift=0;
   int lastShift=0;
   int bar=0;
   int lastBar=0;
   ChartNavigate(chartId,CHART_END,0);
   while(!IsStopped())
     {
      bar=(int)ChartGetInteger(0,CHART_FIRST_VISIBLE_BAR,0);
      if(!(lastBar==bar))
        {
         some_time=iTime(NULL,0,bar);
         shift=iBarShift(NULL,OtherTimeframe,some_time)*-1;
         if(shift<1 && (lastShift != shift))
           {
            if(MathAbs(lastShift-shift)==1) 
              {
               ChartNavigate(chartId,CHART_CURRENT_POS,(lastShift-shift)*-1);
              }
            else
              {
               ChartNavigate(chartId,CHART_END,shift);
              }
           }
         lastBar=bar;
         lastShift=shift;
        }
      Sleep(UpdateFrequency);
     }
   ChartClose(chartId);
  }
//+------------------------------------------------------------------+
