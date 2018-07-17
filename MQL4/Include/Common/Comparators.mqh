//+------------------------------------------------------------------+
//|                                                  Comparators.mqh |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Comparators
  {
public:
   static bool F() { return false; }                                       // 0
   static bool T() { return true; }                                        // 1
   static bool Not(bool p) { return !p; }                                  // 10
   static bool And(bool p,bool q) { return p && q; }                       // 0001
   static bool NonImplication(bool p,bool q) { return p && !q; }           // 0010
   static bool ProjectP(bool p,bool q) { return p; }                       // 0011
   static bool ConverseNonImplication(bool p,bool q) { return !p && q; }   // 0100
   static bool ProjectQ(bool p,bool q) { return q; }                       // 0101
   static bool Xor(bool p,bool q) { return (p || q) && (!(p && q)); }      // 0110
   static bool Or(bool p,bool q) { return p || q; }                        // 0111
   static bool Nor(bool p,bool q) { return !(p || q); }                    // 1000
   static bool Xnor(bool p,bool q) { return !((p || q) && (!(p && q))); }  // 1001
   static bool NotQ(bool p,bool q) { return !q; }                          // 1010
   static bool ConverseImplication(bool p,bool q) { return p || !q; }      // 1011
   static bool NotP(bool p,bool q) { return !p; }                          // 1100
   static bool Implication(bool p,bool q) { return !p || q; }              // 1101
   static bool Nand(bool p,bool q) { return !(p && q); }                   // 1110
   
   template<typename T>
   static bool       IsEqualTo(T a,T b);
   template<typename T>
   static bool       IsGreaterThan(T a,T b);
   template<typename T>
   static bool       IsGreaterThanOrEqualTo(T a,T b);
   template<typename T>
   static bool       IsLessThan(T a,T b);
   template<typename T>
   static bool       IsLessThanOrEqualTo(T a,T b);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
bool Comparators::IsEqualTo(T a,T b)
  {
   return a==b;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
bool Comparators::IsGreaterThan(T greater,T lesser)
  {
   return greater>lesser;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
bool Comparators::IsGreaterThanOrEqualTo(T greater,T lesser)
  {
   return greater>=lesser;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
bool Comparators::IsLessThan(T lesser,T greater)
  {
   return Comparators::IsGreaterThan(greater,lesser);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
bool Comparators::IsLessThanOrEqualTo(T lesser,T greater)
  {
   return Comparators::IsGreaterThanOrEqualTo(greater,lesser);
  }
//+------------------------------------------------------------------+
