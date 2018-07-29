//+------------------------------------------------------------------+
//|                                                CodeGenerator.mqh |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict

#include <Common\Strings.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CodeGenerator
  {
public:

   //+------------------------------------------------------------------+
   //| Generates an array with an initializer
   //+------------------------------------------------------------------+
   static string ArrayWithInitializer(string typeName,string varName,string &initializerValues[],string indent="  ")
     {
      string indent2=indent+indent;
      string head = StringConcatenate(typeName," ",varName, "=\r\n",indent,"{\r\n");
      string body = "";
      string tail = indent+"};";
      int sz=ArraySize(initializerValues);
      int i = 0;
      for(i=0;i<(sz-1);i++)
        {
         body=StringConcatenate(body,indent2,initializerValues[i],",\r\n");
        }
      body=StringConcatenate(body,indent2,initializerValues[i],"\r\n");

      string dec=StringConcatenate(head,body,tail);
      return dec;
     }

   //+------------------------------------------------------------------+
   //| Searches through an enum for its members, then generates an array
   //| containing the enumerations. Returns a string to use in code,
   //| because this would be dumb to use at runtime.
   //+------------------------------------------------------------------+
   template<typename E>
   static string EnumToArrayDef(E dummy,const int start=-500,const int stop=500)
     {
      string typeName=typename(E);
      string varName=StringConcatenate(Strings::CamelCase(typeName,"_"),"[]");
      string t=typeName+"::";
      int length=StringLen(t);

      string values[];
      ArrayResize(values,0);
      int count=0;
      string desc;
      int le;
      for(int i=start; i<stop && !IsStopped(); i++)
        {
         le=0;
         desc=NULL;
         ResetLastError();
         desc=EnumToString((E)i);
         le=GetLastError();

         if(le!=0)
           {
            ResetLastError();
           }
         else
           {
            if(!Strings::StartsWith(desc,t))
              {
               ArrayResize(values,count+1);
               values[count]=desc;
               count+=1;
              }
           }
        }
      return ArrayWithInitializer(typeName,varName,values);
     }
  };
//+------------------------------------------------------------------+
