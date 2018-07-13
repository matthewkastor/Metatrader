//+------------------------------------------------------------------+
//|                                          AtrPointsComparison.mq4 |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_plots   3
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
//--- plot Label3
//#property indicator_label3  "Label3"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrGreen
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- indicator buffers
double         Label1Buffer[];
double         Label2Buffer[];
double         Label3Buffer[];

extern string instrOne = "EURUSDpro"; //Instrument 1
extern color colorOne=clrRed; //Instrument 1 Color
extern string instrTwo = "EURJPYpro"; //Instrument 2
extern color colorTwo=clrViolet; //Instrument 2 Color
extern string instrThree= "USDJPYpro"; //Instrument 3
extern color colorThree=clrGreen; //Instrument 3 Color
extern int indicatorPeriod = 14; //Indicator Period
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName(StringFormat("ATR(%i) Points Comparison : %s, %s, %s",indicatorPeriod,instrOne,instrTwo,instrThree));
//--- indicator buffers mapping
   SetIndexBuffer(0,Label1Buffer);
   SetIndexLabel(0,instrOne);
   SetIndexStyle(0,0,0,1,colorOne);
   SetIndexBuffer(1,Label2Buffer);
   SetIndexLabel(1,instrTwo);
   SetIndexStyle(1,0,0,1,colorTwo);
   SetIndexBuffer(2,Label3Buffer);
   SetIndexLabel(2,instrThree);
   SetIndexStyle(2,0,0,1,colorThree);

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i=Bars-IndicatorCounted()-1;

   while(i>0)
     {
      Label1Buffer[i]=iATR(instrOne,Period(),indicatorPeriod,i) * MathPow(10, MarketInfo(instrOne,MODE_DIGITS));
      Label2Buffer[i]=iATR(instrTwo,Period(),indicatorPeriod,i) * MathPow(10, MarketInfo(instrTwo,MODE_DIGITS));
      Label3Buffer[i]=iATR(instrThree,Period(),indicatorPeriod,i) * MathPow(10, MarketInfo(instrThree,MODE_DIGITS));

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
