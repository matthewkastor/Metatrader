//+------------------------------------------------------------------+
//|                                                  Basket Case.mq4 |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict
#include <CurrencyBasket\Basket.mqh>

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_plots   1
//--- plot Label1
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrDeepSkyBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- indicator buffers
double         IndexLineBuffer[];

extern int BarsLimit=5000;
extern color colorOne=clrDeepSkyBlue; //Line Color
extern string BasketSpecs1="EURUSDpro,sell,0.576"; //Pair,direction,weight;Pair,direction,weight
extern string BasketSpecs2=";USDJPYpro,buy,0.136"; //;Pair,direction,weight;Pair,direction,weight
extern string BasketSpecs3=";GBPUSDpro,sell,0.119"; //;Pair,direction,weight;Pair,direction,weight
extern string BasketSpecs4=";USDCADpro,buy,0.091"; //;Pair,direction,weight;Pair,direction,weight
extern string BasketSpecs5=";USDSEKpro,buy,0.042"; //;Pair,direction,weight;Pair,direction,weight
extern string BasketSpecs6=";USDCHFpro,buy,0.036"; //;Pair,direction,weight;Pair,direction,weight
extern string BasketSpecs7=""; //;Pair,direction,weight;Pair,direction,weight

Basket *basket;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   IndicatorShortName("Basket Case");
   SetIndexBuffer(0,IndexLineBuffer);
   SetIndexLabel(0,"Basket Points");
   SetIndexStyle(0,0,0,1,colorOne);

   string basketSpecs=StringConcatenate(BasketSpecs1,BasketSpecs2,BasketSpecs3,BasketSpecs4,BasketSpecs5,BasketSpecs6,BasketSpecs7);
   basket=new Basket(basketSpecs);
   if(!basket.ValidatePairsExist())
     {
      return (INIT_FAILED);
     }
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i=Bars-IndicatorCounted()-1;

   if(i>BarsLimit)
     {
      i=BarsLimit;
     }

   double val=0;

   while(i>0)
     {
      val=basket.GetWeightedPoints(i);
      if(val==0)
        {
         IndexLineBuffer[i]=EMPTY_VALUE;
        }
      else
        {
         IndexLineBuffer[i]=val;
        }

      i--;
     }
   return (0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   delete basket;
   return(0);
  }
//+------------------------------------------------------------------+
