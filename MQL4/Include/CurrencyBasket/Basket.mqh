//+------------------------------------------------------------------+
//|                                                       Basket.mqh |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict
#include <CurrencyBasket\BasketComponent.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Basket
  {
private:
   int StrSplit(string inString,string separator,string &result[])
     {
      ushort u_sep=StringGetCharacter(separator,0);
      int k=StringSplit(inString,u_sep,result);
      return k;
     }

public:
   BasketComponent   BasketComponents[];

   void Basket(string basketSpec)
     {
      string specs[];
      int specCt=StrSplit(basketSpec,";",specs);
      ArrayResize(BasketComponents,specCt);
      int partCt=0;
      for(int i=0;i<specCt;i++)
        {
         string parts[];
         partCt=0;

         partCt=StrSplit(specs[i],",",parts);
         if(partCt==3)
           {
            BasketComponents[i].Symbol_Name=parts[0];
            BasketComponents[i].Direction=parts[1];
            BasketComponents[i].Weight=StrToDouble(parts[2]);
            //PrintFormat("processing spec for %s %s %f",BasketComponents[i].Symbol_Name,BasketComponents[i].Direction,BasketComponents[i].Weight);
           }
        }
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   bool ValidatePairsExist()
     {
      bool out=true;
      int k=ArraySize(BasketComponents);
      if(k<=0)
        {
         Print("There were no symbols in the specification.");
         out=false;
        }
      else
        {
         for(int i=0;i<k;i++)
           {
            if(!BasketComponents[i].AddSymbolToMarketWatch())
              {
               out=false;
               PrintFormat("Symbol %s does not exist.",BasketComponents[i].Symbol_Name);
              }
           }
        }
      return out;
     }

   double GetWeightedPoints(int index)
     {
      int pairsCt=ArraySize(BasketComponents);

      double val=0;
      double tmpVal=0;
      int j=0;
      for(j=0;j<pairsCt;j++)
        {
         tmpVal=0;
         tmpVal=BasketComponents[j].GetWeightedPoints(index);
         if(tmpVal==0)
           {
            val=0;
            break;
           }
         else
           {
            val+=tmpVal;
           }
        }
      return val;
     }
     
   double GetWeightedVolume(int index)
     {
      int pairsCt=ArraySize(BasketComponents);

      double val=0;
      double tmpVal=0;
      int j=0;
      for(j=0;j<pairsCt;j++)
        {
         tmpVal=0;
         tmpVal=BasketComponents[j].GetWeightedVolume(index);
         if(tmpVal==0)
           {
            val=0;
            break;
           }
         else
           {
            val+=tmpVal;
           }
        }
      return val;
     }
  };
//+------------------------------------------------------------------+
