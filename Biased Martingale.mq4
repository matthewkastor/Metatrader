//+------------------------------------------------------------------+
//|                                            Biased Martingale.mq4 |
//|                                                   Matthew Colter |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Colter"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict
bool TestDisabled=false;
//+------------------------------------------------------------------+
//|Enumeration to indicate directional bias.                         |
//+------------------------------------------------------------------+
enum Enum_Direction
  {
   BUYING,
   SELLING,
   NONE
  };

Enum_Direction Direction=NONE;

input double StartFactor=0.5;
input double IncreaseFactor=2;
input ENUM_TIMEFRAMES BiasTimeframe=PERIOD_D1;
input int BiasPeriod=20;
input int BiasLookback=12;

input ENUM_DAY_OF_WEEK StartDay=SUNDAY;
input ENUM_DAY_OF_WEEK EndDay=SUNDAY;
input int StartHour=0;
input int EndHour=0;

datetime lastBarTime=0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(IsTesting() && TestDisabled==true)
     {
      return;
     }
   PositionManagement();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsTimeBetween(int startDay,int startHour,int endDay,int endHour)
  {
   if((startDay==endDay) && (startHour==endHour))
     {
      // The schedule starts and ends at the same time, it is neither
      // day trading nor night trading... so it's always trading because
      // never trading is as simple as removing the EA.
      return true;
     }
   int D=TimeDayOfWeek(TimeCurrent());
   int H=TimeHour(TimeCurrent());

   if((startDay<=D) && (endDay>=D) && (startHour<=H) && (endHour>=H))
     {
      //Print(StartDay+" "+StartHour+" < "+D+" "+H+" < "+EndDay+" "+EndHour);
      return true;
     }
//Print(StartDay+" "+StartHour+" > "+D+" "+H+" > "+EndDay+" "+EndHour);
   return false;
  }
//+------------------------------------------------------------------+
//|Gets the profit of the last closed order.                         |
//+------------------------------------------------------------------+
double PairProfitSince(string symbol,int secondsAgo)
  {
   double num=0;
   for(int i=OrdersHistoryTotal()-1;i>=0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY) && OrderSymbol()==symbol && (OrderType()==OP_BUY || OrderType()==OP_SELL))
        {
         if(OrderCloseTime()>(Time[0]-secondsAgo))
           {
            num+=OrderProfit();
           }
        }
     }
   return num;
  }
//+------------------------------------------------------------------+
//|Gets the total profit on the given currency pair.                 |
//+------------------------------------------------------------------+
double PairLotsTotal(string symbol)
  {
   double num=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==symbol && (OrderType()==OP_BUY || OrderType()==OP_SELL))
        {
         num=num+OrderLots();
        }
     }
   return num;
  }
//+------------------------------------------------------------------+
//|Gets the current average price paid for the given currency pair.  |
//+------------------------------------------------------------------+
double PairAveragePrice(string symbol)
  {
   double num=0;
   double sum=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==symbol && (OrderType()==OP_BUY || OrderType()==OP_SELL))
        {
         sum=sum+OrderOpenPrice() * OrderLots();
         num=num+OrderLots();
        }
     }
   if(num>0 && sum>0)
     {
      return (sum / num);
     }
   else
     {
      return 0;
     }
  }
//+------------------------------------------------------------------+
//|Gets the lowest price paid for any order on the given pair.       |
//+------------------------------------------------------------------+
double PairLowestPricePaid(string symbol)
  {
   double num=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==symbol && (OrderType()==OP_BUY || OrderType()==OP_SELL))
        {
         if(num==0 || OrderOpenPrice()<num)
           {
            num=OrderOpenPrice();
           }
        }
     }
   return num;
  }
//+------------------------------------------------------------------+
//|Gets the highest price paid for any order on the given pair.      |
//+------------------------------------------------------------------+
double PairHighestPricePaid(string symbol)
  {
   double num=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==symbol && (OrderType()==OP_BUY || OrderType()==OP_SELL))
        {
         if(num==0 || OrderOpenPrice()>num)
           {
            num=OrderOpenPrice();
           }
        }
     }
   return num;
  }
//+------------------------------------------------------------------+
//|Gets the direction the given symbol is already traded in.         |
//+------------------------------------------------------------------+
Enum_Direction PairDirection(string symbol)
  {
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==symbol && (OrderType()==OP_BUY || OrderType()==OP_SELL))
        {
         if(OrderType()==OP_BUY)
           {
            return BUYING;
           }
         else
           {
            return SELLING;
           }
        }
     }
   return NONE;
  }
//+------------------------------------------------------------------+
//|Closes all open orders on the given currency pair.                |
//+------------------------------------------------------------------+
void CloseOpenOrders(string symbol)
  {
   double bid = MarketInfo(symbol, MODE_BID);
   double ask = MarketInfo(symbol, MODE_ASK);
   while(PairLotsTotal(symbol)>0)
     {
      for(int i=0;i<OrdersTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==symbol)
           {
            if(OrderType()==OP_BUY)
              {
               bool ret=OrderClose(OrderTicket(),OrderLots(),bid,0);
               if(!ret)
                 {
                  PrintFormat("Attempt to CLOSE ticket %25.0i for %2.2f %s @ %2.5f failed. (mql error %5.0i)",OrderTicket(),OrderLots(),symbol,bid,GetLastError());
                 }
              }
            else if(OrderType()==OP_SELL)
              {
               bool ret=OrderClose(OrderTicket(),OrderLots(),ask,0);
               if(!ret)
                 {
                  PrintFormat("Attempt to CLOSE ticket %25.0i for %2.2f %s @ %2.5f failed. (mql error %5.0i)",OrderTicket(),OrderLots(),symbol,ask,GetLastError());
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|set stop loss on all open orders on the given currency pair.      |
//+------------------------------------------------------------------+
void SetStopLossOpenOrders(string symbol)
  {
   double bid = MarketInfo(symbol, MODE_BID);
   double ask = MarketInfo(symbol, MODE_ASK);
   double pa = PairAveragePrice(symbol);
   double sl = 0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==symbol)
        {
         if(OrderType()==OP_BUY)
           {
            sl=NormalizeDouble((bid+pa)/2,Digits);
            if(OrderStopLoss()==0 || sl>OrderStopLoss())
              {
               bool ret=OrderModify(OrderTicket(),OrderOpenPrice(),sl,OrderTakeProfit(),0);
               if(!ret)
                 {
                  PrintFormat("Attempt to set stop loss on ticket %25.0i for %2.2f %s @ %2.5f failed. (mql error %5.0i)",OrderTicket(),OrderLots(),symbol,bid,GetLastError());
                 }
              }
           }
         else if(OrderType()==OP_SELL)
           {
            sl=NormalizeDouble((ask+pa)/2,Digits);
            if(OrderStopLoss()==0 || sl<OrderStopLoss())
              {
               bool ret=OrderModify(OrderTicket(),OrderOpenPrice(),sl,OrderTakeProfit(),0);
               if(!ret)
                 {
                  PrintFormat("Attempt to set stop loss on ticket %25.0i for %2.2f %s @ %2.5f failed. (mql error %5.0i)",OrderTicket(),OrderLots(),symbol,ask,GetLastError());
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|Opens an order on the given currency pair.                        |
//+------------------------------------------------------------------+
void OpenOrder(string symbol,Enum_Direction buyingOrSelling)
  {
   double bid = MarketInfo(symbol, MODE_BID);
   double ask = MarketInfo(symbol, MODE_ASK);
   double minLot=MarketInfo(symbol,MODE_MINLOT);
   double maxLot=MarketInfo(symbol,MODE_MAXLOT);
   double orderSize=PairLotsTotal(symbol)*IncreaseFactor;
//double riskFactor = (20 / iADX(symbol,PERIOD_W1,104,PRICE_CLOSE,MODE_MAIN,0));
   double riskFactor=1;
   if(orderSize<minLot)
     {
      double accountSizedLots=(AccountBalance()/100000)*StartFactor*riskFactor;
      if(minLot>accountSizedLots)
        {
         orderSize=minLot;
        }
      else
        {
         orderSize=accountSizedLots;
        }
     }
   orderSize=NormalizeDouble(orderSize,2);
   if(orderSize>maxLot)
     {
      //PrintFormat("Not Opening order, maximum lot size exceeded. Reduce the StartFactor. (Max) %2.2f < (Requested) %2.2f lots.",maxLot,orderSize);
      //CloseOpenOrders(symbol);
      orderSize=maxLot-minLot;
      //return;
     }
   if(buyingOrSelling==BUYING)
     {
      if(AccountFreeMarginCheck(symbol,OP_BUY,orderSize)<=AccountEquity()*0.1 || GetLastError()==134)
        {
         PrintFormat("Not Opening order, not enough free margin for %2.2f lots. Reduce the StartFactor.",orderSize);
         //CloseOpenOrders(symbol);
         return;
        }
      int ret=OrderSend(symbol,OP_BUY,orderSize,ask,0,0,0);
      if(ret == -1)
        {
         PrintFormat("Failed attempt to BUY %2.2f %s @ %2.5f (mql error %5.0i)",orderSize,symbol,ask,GetLastError());
        }
     }
   else if(buyingOrSelling==SELLING)
     {
      if(AccountFreeMarginCheck(symbol,OP_SELL,orderSize)<=AccountEquity()*0.1 || GetLastError()==134)
        {
         PrintFormat("Not Opening order, not enough free margin for %2.2f lots. Reduce the StartFactor.",orderSize);
         //CloseOpenOrders(symbol);
         return;
        }
      int ret=OrderSend(symbol,OP_SELL,orderSize,bid,0,0,0);
      if(ret == -1)
        {
         PrintFormat("Failed attempt to SELL %2.2f %s @ %2.5f (mql error %5.0i)",orderSize,symbol,bid,GetLastError());
        }
     }
  }
//+------------------------------------------------------------------+
//|Gets the direction to trade in for the given symbol.              |
//+------------------------------------------------------------------+
Enum_Direction GetBiasDirection(string symbol)
  {
   double custAvgNow=iMA(symbol,BiasTimeframe,BiasPeriod,0,MODE_SMA,PRICE_CLOSE,1);
   double custAvgLookback=iMA(symbol,BiasTimeframe,BiasPeriod,0,MODE_SMA,PRICE_CLOSE,BiasLookback);
   if(custAvgNow>custAvgLookback)
     {
      return BUYING;
     }
   if(custAvgNow<custAvgLookback)
     {
      return SELLING;
     }
   return NONE;
  }
//+------------------------------------------------------------------+
//|Calculates the standard range.                                    |
//+------------------------------------------------------------------+
double GetVolatilityFactor(string symbol)
  {
   return iATR(symbol,PERIOD_W1,6,1) / iATR(symbol,PERIOD_W1,52,1);
  }
//+------------------------------------------------------------------+
//|Calculates the price to take profit at.                           |
//+------------------------------------------------------------------+
double GetProfitPoints(string symbol)
  {
   double bid = MarketInfo(symbol, MODE_BID);
   double ask = MarketInfo(symbol, MODE_ASK);
   double spread=ask-bid;
   if(spread<=0)
     {
      spread=Point*1000;
     }
   double vf=GetVolatilityFactor(symbol);
   if(vf>2)
     {
      vf=2;
     }
   if(vf<=0)
     {
      vf=1;
     }
   double output=1.5 *(vf*iATR(symbol,BiasTimeframe,BiasPeriod,1));
   if(output<spread*6)
     {
      output=spread*6;
     }
   return output;
  }
//+------------------------------------------------------------------+
//|Calculates the price to open another order in the same direction. |
//+------------------------------------------------------------------+
double GetStepSize(string symbol)
  {
   double bid = MarketInfo(symbol, MODE_BID);
   double ask = MarketInfo(symbol, MODE_ASK);
   double spread=ask-bid;
   if(spread<=0)
     {
      spread=Point*1000;
     }
   double vf=GetVolatilityFactor(symbol);
   if(vf<0.25)
     {
      vf=0.25;
     }
   double output=0.5 *(vf*iATR(symbol,BiasTimeframe,BiasPeriod,1));
   if(output<spread*4)
     {
      output=spread*4;
     }
   return output;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetDrawdownPercent()
  {
   return 100 * (1 - (AccountEquity()/AccountBalance()));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetLockFactor()
  {
   int lockFactor=-25+OrdersTotal();
   if(lockFactor>-1)
     {
      lockFactor=-1;
     }
   return lockFactor;
  }
//+------------------------------------------------------------------+
//|Manages the position.                                             |
//+------------------------------------------------------------------+
void PositionManagement()
  {
   string Pair=Symbol();

   int biasBarCount=Bars(Pair,BiasTimeframe);
   int volatilityBarsCount=Bars(Pair,PERIOD_W1);
   if((BiasLookback+BiasPeriod)>biasBarCount)
     {
      Print("Not enough history to form bias : BiasLookback + BiasPeriod");
      return;
     }
   if(52>volatilityBarsCount)
     {
      Print("Not enough history to form bias : volatilityBarsCount");
      return;
     }

   double ProfitPoints=GetProfitPoints(Pair);
   double PairAveragePrice=PairAveragePrice(Pair);
   double PairLots=PairLotsTotal(Pair);
   double bid = MarketInfo(Pair, MODE_BID);
   double ask = MarketInfo(Pair, MODE_ASK);
   double ProfitTarget=0;
   double CurrentOpenPrice=0;
   double CurrentClosePrice=0;
   string dirMsg="No Direction";

// manual entry could initialize the trades while the
// "Direction" latch is considering the opposite direction.
   if(PairAveragePrice>0)
     {
      Direction=PairDirection(Pair);
     }

   if(Direction==BUYING)
     {
      dirMsg="Buying";
      ProfitTarget=PairAveragePrice+ProfitPoints;
      CurrentOpenPrice=ask;
      CurrentClosePrice=bid;
     }

   if(Direction==SELLING)
     {
      dirMsg="Selling";
      ProfitTarget=PairAveragePrice-ProfitPoints;
      CurrentOpenPrice=bid;
      CurrentClosePrice=ask;
     }

   double dd=GetDrawdownPercent();
   Comment(
           StringFormat(
           "%s %3.2f Lots at %3.5f, Targeting %3.5f %2.2f DD %2.2f"
           ,dirMsg,PairLots,PairAveragePrice,ProfitTarget,PairProfitSince(Pair,60*60*24*30),dd));

   bool tradingTime=IsTimeBetween(StartDay,StartHour,EndDay,EndHour);
   if(PairAveragePrice==0 && tradingTime)
     {
      Direction=GetBiasDirection(Pair);
      if(Direction!=NONE)
        {
         Print("Opening order, initializing position.");
         OpenOrder(Pair,Direction);
        }
      return;
     }
   else if(AccountFreeMargin()<AccountBalance()*0.05)
     {
      Print("Closing orders, account free margin is too low.");
      CloseOpenOrders(Pair);
      return;
     }
   else if(PairAveragePrice!=0 && Direction==BUYING && CurrentClosePrice>ProfitTarget)
     {
      Print("Closing orders, profit target reached.");
      CloseOpenOrders(Pair);
      return;
     }
   else if(PairAveragePrice!=0 && Direction==SELLING && CurrentClosePrice<ProfitTarget)
     {
      Print("Closing orders, profit target reached.");
      CloseOpenOrders(Pair);
      return;
     }
   else if(GetDrawdownPercent()<GetLockFactor())
     {
      Print("Setting stop loss to prevent losing all of this gain.");
      SetStopLossOpenOrders(Pair);
      return;
     }
   else if(PairAveragePrice!=0 && Direction==BUYING)
     {
      double stepSize=GetStepSize(Pair);
      if((CurrentClosePrice+stepSize)<PairLowestPricePaid(Pair))
        {
         Print("Opening order, averaging down.");
         OpenOrder(Pair,Direction);
        }
      return;
     }
   else if(PairAveragePrice!=0 && Direction==SELLING)
     {
      double stepSize=GetStepSize(Pair);
      if((CurrentClosePrice-stepSize)>PairHighestPricePaid(Pair))
        {
         Print("Opening order, averaging down.");
         OpenOrder(Pair,Direction);
        }
      return;
     }
  }
//+------------------------------------------------------------------+
