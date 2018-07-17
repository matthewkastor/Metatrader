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
   // 0
   static bool F_0() { return false; }
   static bool F() { return F_0(); }
   // 1
   static bool F_1() { return true; }
   static bool T() { return F_1(); }
   // 01
   static bool F_01(bool p) { return p; }
   static bool If(bool p) { return F_01(p); }
   static bool Identity(bool p) { return If(p); }
   // 10
   static bool F_10(bool p) { return !p; }
   static bool If_Not(bool p) { return F_10(p); }
   static bool Not(bool p) { return If_Not(p); }
   // 0001
   static bool F_0001(bool p,bool q) { return p && q; }
   static bool If_P_And_Q(bool p,bool q) { return F_0001(p,q); }
   static bool And(bool p,bool q) { return If_P_And_Q(p,q); }
   // 0010
   static bool F_0010(bool p,bool q) { return And(p, Not(q)); }
   static bool If_P_And_NotQ(bool p,bool q) { return F_0010(p,q); }
   static bool NonImplication(bool p,bool q) { return If_P_And_NotQ(p,q); }
   // 0011
   static bool F_0011(bool p,bool q) { return p; }
   static bool If_P(bool p,bool q) { return F_0011(p,q); }
   static bool P(bool p,bool q) { return If_P(p,q); }
   static bool ProjectP(bool p,bool q) { return P(p,q); }
   // 0100
   static bool F_0100(bool p,bool q) { return And(Not(p), q); }
   static bool If_NotP_And_Q(bool p,bool q) { return F_0100(p,q); }
   static bool ConverseNonImplication(bool p,bool q) { return If_NotP_And_Q(p,q); }
   // 0101
   static bool F_0101(bool p,bool q) { return q; }
   static bool If_Q(bool p,bool q) { return F_0101(p,q); }
   static bool Q(bool p,bool q) { return If_Q(p,q); }
   static bool ProjectQ(bool p,bool q) { return Q(p,q); }
   // 0110
   static bool F_0110(bool p,bool q) { return And(Or(p,q), Not(And(p,q))); }
   static bool If_P_NotEqualTo_Q(bool p,bool q) { return F_0110(p,q); }
   static bool Xor(bool p,bool q) { return If_P_NotEqualTo_Q(p,q); }
   // 0111
   static bool F_0111(bool p,bool q) { return p || q; }
   static bool If_P_Or_Q(bool p,bool q) { return F_0111(p,q); }
   static bool Or(bool p,bool q) { return If_P_Or_Q(p,q); }
   // 1000
   static bool F_1000(bool p,bool q) { return Not(Or(p,q)); }
   static bool If_Neither_P_Nor_Q(bool p,bool q) { return F_1000(p,q); }
   static bool Nor(bool p,bool q) { return If_Neither_P_Nor_Q(p,q); }
   // 1001
   static bool F_1001(bool p,bool q) { return Not(Xor(p,q)); }
   static bool If_P_EqualTo_Q(bool p,bool q) { return F_1001(p,q); }
   static bool Xnor(bool p,bool q) { return If_P_EqualTo_Q(p,q); }
   // 1010
   static bool F_1010(bool p,bool q) { return Not(Q(p,q)); }
   static bool If_NotQ(bool p,bool q) { return F_1010(p,q); }
   static bool NotQ(bool p,bool q) { return If_NotQ(p,q); }
   // 1011
   static bool F_1011(bool p,bool q) { return Not(ConverseNonImplication(p,q)); }
   static bool If_P_Or_NotQ(bool p,bool q) { return F_1011(p,q); }
   static bool ConverseImplication(bool p,bool q) { return If_P_Or_NotQ(p,q); }
   // 1100
   static bool F_1100(bool p,bool q) { return Not(P(p,q)); }
   static bool If_NotP(bool p,bool q) { return F_1100(p,q); }
   static bool NotP(bool p,bool q) { return If_NotP(p,q); }
   // 1101
   static bool F_1101(bool p,bool q) { return Not(NonImplication(p,q)); }
   static bool If_NotP_Or_Q(bool p,bool q) { return F_1101(p,q); }
   static bool Implication(bool p,bool q) { return If_NotP_Or_Q(p,q); }
   // 1110
   static bool F_1110(bool p,bool q) { return Not(And(p,q)); }
   static bool If_NotP_Or_NotQ(bool p,bool q) { return F_1110(p,q); }
   static bool Nand(bool p,bool q) { return If_NotP_Or_NotQ(p,q); }

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
