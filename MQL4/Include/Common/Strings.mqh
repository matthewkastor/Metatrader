//+------------------------------------------------------------------+
//|                                                      Strings.mqh |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict

typedef string(*TStringAction)(string const);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Strings
  {
public:

   //+------------------------------------------------------------------+
   //| Does something to the first character of a string.
   //| @param str is the input string
   //| @param action is the callback function that will
   //|   receive the first character for processing.
   //| @returns {string} returns the input string with its first
   //|   character altered.
   //+------------------------------------------------------------------+
   static string First(string const str,TStringAction action)
     {
      int len=StringLen(str);
      if(len>0)
        {
         string first=StringSubstr(str,0,1);
         first = action(first);
         if(len==1)
           {
            return first;
           }

         string last=StringSubstr(str,1,StringLen(str));
         return StringConcatenate(first,last);
        }
      return str;
     }

   //+------------------------------------------------------------------+
   //| Makes the string lowercase
   //+------------------------------------------------------------------+
   static string Lowercase(string const str)
     {
      string out=str;
      if(StringToLower(out))
        {
         return out;
        }
      else
        {
         return str;
        }
     }

   //+------------------------------------------------------------------+
   //| Makes the string uppercase
   //+------------------------------------------------------------------+
   static string Uppercase(string const str)
     {
      string out=str;
      if(StringToUpper(out))
        {
         return out;
        }
      else
        {
         return str;
        }
     }

   //+------------------------------------------------------------------+
   //| Makes the first character lowercase
   //+------------------------------------------------------------------+
   static string LowercaseFirst(string const str)
     {
      return Strings::First(str,Strings::Lowercase);
     }

   //+------------------------------------------------------------------+
   //| Makes the first character uppercase
   //+------------------------------------------------------------------+
   static string UppercaseFirst(string const str)
     {
      return Strings::First(str,Strings::Uppercase);
     }

   //+------------------------------------------------------------------+
   //| Makes the string camel case
   //+------------------------------------------------------------------+
   static string CamelCase(string const str,string const space=" ")
     {
      string parts[];
      string out="";
      int sz=StringSplit(str,StringGetChar(space,0),parts);
      if(0<sz)
        {
         int i=0;
         out += Strings::Lowercase(parts[i]);
         if(1<sz)
           {
            for(i=1;i<sz;i++)
              {
               out=StringConcatenate(out,Strings::UppercaseFirst(Strings::Lowercase(parts[i])));
              }
           }
        }
      else
        {
         out=str;
        }
      return out;
     }

   //+------------------------------------------------------------------+
   //| Wraps the string with another string
   //+------------------------------------------------------------------+
   static string WrapWith(string const str,string const wrapper)
     {
      return StringConcatenate(wrapper,str,wrapper);
     }

   //+------------------------------------------------------------------+
   //| Wraps the string in quotes
   //+------------------------------------------------------------------+
   static string WrapInQuotes(string const str)
     {
      return Strings::WrapWith(str,"\"");
     }

   //+------------------------------------------------------------------+
   //| Tells whether the searchString starts with the needle
   //+------------------------------------------------------------------+
   static bool StartsWith(string const searchString,string const needle)
     {
      int len=StringLen(needle);
      string chop=StringSubstr(searchString,0,len);
      return (StringCompare(chop,needle)==0);
     }
  };
//+------------------------------------------------------------------+
