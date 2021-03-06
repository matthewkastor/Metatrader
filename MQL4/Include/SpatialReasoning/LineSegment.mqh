//+------------------------------------------------------------------+
//|                                                  LineSegment.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <SpatialReasoning\RightTriangle.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct LineSegment
  {
protected:

public:
   CoordinatePoint   A;
   CoordinatePoint   B;

   void Set(CoordinatePoint &a,CoordinatePoint &b)
     {
      this.A.Set(a);
      this.B.Set(b);
     }

   void LineSegment()
     {
     }

   void LineSegment(CoordinatePoint &a,CoordinatePoint &b)
     {
      this.Set(a,b);
     }

   double GetLength()
     {
      RightTriangle t(this.A,this.B);
      return t.GetHypotenuseLength();
     }
  };
//+------------------------------------------------------------------+
