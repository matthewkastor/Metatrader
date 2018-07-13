//+------------------------------------------------------------------+
//|                                                         PIER.mq4 |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2
//--- plot Label1
//#property indicator_label1  "Label1"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot Label2
//#property indicator_label2  "Label2"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrViolet
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- indicator buffers
double         Label1Buffer[];
double         Label2Buffer[];

extern color colorOne=clrRed; //Instrument 1 Color
extern color colorTwo=clrGray; //Instrument 2 Color
extern int indicatorPeriod = 14; //Indicator Period
extern int multiplier=1;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName(StringFormat("ATR(%i) Channel",indicatorPeriod));
//--- indicator buffers mapping
   SetIndexBuffer(0,Label1Buffer);
   SetIndexLabel(0,"ATR high");
   SetIndexStyle(0,0,0,1,colorOne);
   SetIndexBuffer(1,Label2Buffer);
   SetIndexLabel(1,"ATR low");
   SetIndexStyle(1,0,0,1,colorTwo);

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i=Bars-IndicatorCounted()-1;
   double Atr=0;
   double Midpoint=0;
   while(i>=0)
     {
      Atr = (iATR(Symbol(),Period(),indicatorPeriod,i)*multiplier)/2;
      Midpoint=Open[i-1];
      Label1Buffer[i]=Midpoint + Atr;
      Label2Buffer[i]=Midpoint - Atr;

      i--;
     }
   return (0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
