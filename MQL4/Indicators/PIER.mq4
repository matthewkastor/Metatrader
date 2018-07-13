//+------------------------------------------------------------------+
//|                                                         PIER.mq4 |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_plots   4
//--- plot Power
#property indicator_label1  "Power"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot Current
#property indicator_label2  "Current"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot Voltage
#property indicator_label3  "Voltage"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrYellow
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- plot Resistance
#property indicator_label4  "Resistance"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrGreen
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1
//--- indicator buffers
double         PowerBuffer[];
double         CurrentBuffer[];
double         VoltageBuffer[];
double         ResistanceBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,PowerBuffer);
   SetIndexBuffer(1,CurrentBuffer);
   SetIndexBuffer(2,VoltageBuffer);
   SetIndexBuffer(3,ResistanceBuffer);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   int ct=rates_total-prev_calculated;
   if(prev_calculated!=0)
     {
      ct=ct+1;
     }

   for(int idx=0;idx<ct;idx++)
     {
      double c=NormalizeDouble(MathFloor((High[idx]-Low[idx])/Point),5);
      double e=NormalizeDouble(Volume[idx],5);
      double p=NormalizeDouble(c*e,5);

      if(c==0)
        {
         CurrentBuffer[idx]=0;
         VoltageBuffer[idx]=0;
         PowerBuffer[idx]=0;
         ResistanceBuffer[idx]=0;
         continue;
        }
      double r=NormalizeDouble(e/c,5);
      CurrentBuffer[idx]=c;
      VoltageBuffer[idx]=e;
      PowerBuffer[idx]=p;
      ResistanceBuffer[idx]=r;
     }
   return(rates_total);
  }
//+------------------------------------------------------------------+
