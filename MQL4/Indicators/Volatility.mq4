//+------------------------------------------------------------------+
//|                                                   Volatility.mq4 |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_minimum 0
#property indicator_buffers 4
#property indicator_plots   4
//--- plot A
#property indicator_label1  "A"
#property indicator_type1   DRAW_HISTOGRAM
#property indicator_color1  clrSilver
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2
//--- plot B
#property indicator_label2  "B"
#property indicator_type2   DRAW_HISTOGRAM
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  2
//--- plot C
#property indicator_label3  "C"
#property indicator_type3   DRAW_HISTOGRAM
#property indicator_color3  clrOrange
#property indicator_style3  STYLE_SOLID
#property indicator_width3  2
//--- plot C
#property indicator_label4  "D"
#property indicator_type4   DRAW_HISTOGRAM
#property indicator_color4  clrYellow
#property indicator_style4  STYLE_SOLID
#property indicator_width4  2
//--- input parameters
input int      VolatilityPeriod=5;//Volatility Period
//--- indicator buffers
double         aBuffer[];
double         bBuffer[];
double         cBuffer[];
double         dBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   IndicatorShortName(StringFormat("Volatility (%i, %i, %i, %i)",(int)MathPow(VolatilityPeriod,1),(int)MathPow(VolatilityPeriod,2),(int)MathPow(VolatilityPeriod,3),(int)MathPow(VolatilityPeriod,4)));

   SetIndexBuffer(0,aBuffer);
   SetIndexBuffer(1,bBuffer);
   SetIndexBuffer(2,cBuffer);
   SetIndexBuffer(3,dBuffer);

   SetIndexLabel(0,StringFormat("Volatility %i",(int)MathPow(VolatilityPeriod,4)));
   SetIndexLabel(1,StringFormat("Volatility %i",(int)MathPow(VolatilityPeriod,3)));
   SetIndexLabel(2,StringFormat("Volatility %i",(int)MathPow(VolatilityPeriod,2)));
   SetIndexLabel(3,StringFormat("Volatility %i",(int)MathPow(VolatilityPeriod,1)));

   ZoomHistograms();

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
   int i=Bars-IndicatorCounted()-1;

   while(i>0)
     {
      i--;
      aBuffer[i]=iStdDev(Symbol(),Period(),(int)MathPow(VolatilityPeriod,4),0,MODE_SMA,PRICE_MEDIAN,i);
      bBuffer[i]=iStdDev(Symbol(),Period(),(int)MathPow(VolatilityPeriod,3),0,MODE_SMA,PRICE_MEDIAN,i);
      cBuffer[i]=iStdDev(Symbol(),Period(),(int)MathPow(VolatilityPeriod,2),0,MODE_SMA,PRICE_MEDIAN,i);
      dBuffer[i]=iStdDev(Symbol(),Period(),(int)MathPow(VolatilityPeriod,1),0,MODE_SMA,PRICE_MEDIAN,i);
     }

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ZoomHistograms()
  {
   int zoom=(int)ChartGetInteger(0,CHART_SCALE,0);
   int px=0;
   switch(zoom)
   {
      case 0 :
         px=1;
         break;
      case 1:
         px=1;
         break;
      case 2:
         px=2;
         break;
      case 3:
         px=3;
         break;
      case 4:
         px=6;
         break;
      case 5:
         px=13;
         break;
   }
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,px,clrSilver);
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID,px,clrRed);
   SetIndexStyle(2,DRAW_HISTOGRAM,STYLE_SOLID,px,clrOrange);
   SetIndexStyle(3,DRAW_HISTOGRAM,STYLE_SOLID,px,clrYellow);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   if(id==CHARTEVENT_CHART_CHANGE)
     {
      ZoomHistograms();
     }
  }
//+------------------------------------------------------------------+
