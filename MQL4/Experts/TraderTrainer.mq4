//+------------------------------------------------------------------+
//|                                                TraderTrainer.mq4 |
//|                                                   Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property strict

extern bool HedgingAllowed=false;
extern double StopLossDistance=0.00500;
extern double TakeProfitDistance=0.00500;

string CloseAllButton="CloseAllButton";
string BuyButton="Buy";
string SellButton="Sell";
string PositionSizeLabel="PositionSizeLabel";
string PositionSizeInput="PositionSize";
string StopLossLabel="StopLossLabel";
string StopLossInput="StopLoss";
string TakeProfitLabel="TakeProfitLabel";
string TakeProfitInput="TakeProfit";
string OrderCommentLabel="OrderCommentLabel";
string OrderCommentInput="OrderComment";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MakeUserInput(ENUM_OBJECT objectType,string inputName,string inputText,int x=0,int y=0,int width=100,int height=50,int inpColor=Gray,int inpBacgroundColor=Black,int inpBorderColor=Black,int inpBorderType=BORDER_FLAT,int fontSize=12)
  {
   ObjectCreate(0,inputName,objectType,0,0,0);
   ObjectSetInteger(0,inputName,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,inputName,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,inputName,OBJPROP_XSIZE,width);
   ObjectSetInteger(0,inputName,OBJPROP_YSIZE,height);

   ObjectSetString(0,inputName,OBJPROP_TEXT,inputText);

   ObjectSetInteger(0,inputName,OBJPROP_COLOR,inpColor);
   ObjectSetInteger(0,inputName,OBJPROP_BGCOLOR,inpBacgroundColor);
   ObjectSetInteger(0,inputName,OBJPROP_BORDER_COLOR,inpBorderColor);

   ObjectSetInteger(0,inputName,OBJPROP_BORDER_TYPE,inpBorderType);

   ObjectSetInteger(0,inputName,OBJPROP_HIDDEN,true);
   ObjectSetInteger(0,inputName,OBJPROP_STATE,false);
   ObjectSetInteger(0,inputName,OBJPROP_FONTSIZE,fontSize);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MakeButton(string buttonName,string buttonText,int x=0,int y=0,int width=100,int height=50,int btnColor=Gray,int btnBacgroundColor=Black,int btnBorderColor=Black,int btnBorderType=BORDER_FLAT,int fontSize=12)
  {
   MakeUserInput(OBJ_BUTTON,buttonName,buttonText,x,y,width,height,btnColor,btnBacgroundColor,btnBorderColor,btnBorderType,fontSize);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MakeInputBox(string inputName,string inputText,int x=0,int y=0,int width=100,int height=50,int inpColor=Gray,int inpBacgroundColor=Black,int inpBorderColor=Black,int inpBorderType=BORDER_FLAT,int fontSize=12)
  {
   MakeUserInput(OBJ_EDIT,inputName,inputText,x,y,width,height,inpColor,inpBacgroundColor,inpBorderColor,inpBorderType,fontSize);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MakeLabel(string labelName,string labelText,int x=0,int y=0,int width=100,int height=50,int lblColor=Gray,int lblBacgroundColor=Black,int lblBorderColor=Black,int lblBorderType=BORDER_FLAT,int fontSize=12)
  {
   MakeUserInput(OBJ_EDIT,labelName,labelText,x,y,width,height,lblColor,lblBacgroundColor,lblBorderColor,lblBorderType,fontSize);
   ObjectSetInteger(0,labelName,OBJPROP_READONLY,1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MakeManualEntryPanel()
  {
   int fontSize=12;

   MakeButton(BuyButton,"Buy",10,25,87,50,White,Blue,Gray,BORDER_RAISED,fontSize);
   MakeButton(SellButton,"Sell",97,25,88,50,White,Red,Gray,BORDER_RAISED,fontSize);
   MakeButton(CloseAllButton,"Close All",10,75,175,50,White,Green,Gray,BORDER_RAISED,fontSize);

   MakeLabel(PositionSizeLabel,"Lots : ",10,125,100,25,White,Gray,Gray,BORDER_FLAT,fontSize);
   MakeInputBox(PositionSizeInput,"0.01",110,125,75,25,Black,White,Gray,BORDER_FLAT,fontSize);

   MakeLabel(StopLossLabel,"Stop Loss : ",10,150,100,25,White,Gray,Gray,BORDER_FLAT,fontSize);
   MakeInputBox(StopLossInput,"0.00100",110,150,75,25,Black,White,Gray,BORDER_FLAT,fontSize);
   SetInputText(StopLossInput,DoubleToString(StopLossDistance,5));

   MakeLabel(TakeProfitLabel,"Take Profit : ",10,175,100,25,White,Gray,Gray,BORDER_FLAT,fontSize);
   MakeInputBox(TakeProfitInput,"0.00100",110,175,75,25,Black,White,Gray,BORDER_FLAT,fontSize);
   SetInputText(TakeProfitInput,DoubleToString(TakeProfitDistance,5));

   MakeLabel(OrderCommentLabel,"Comment : ",10,200,100,25,White,Gray,Gray,BORDER_FLAT,fontSize);
   MakeInputBox(OrderCommentInput,"Training",110,200,75,25,Black,White,Gray,BORDER_FLAT,fontSize);
  }
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   MakeManualEntryPanel();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(ObjectFind(0,BuyButton)<0)
     {
      MakeManualEntryPanel();
     }
// Only needed in Visual Testing Mode
   if(IsVisualMode())
     {
      if(bool(ObjectGetInteger(0,BuyButton,OBJPROP_STATE)))
        {
         BuyButton_Click();
        }
      if(bool(ObjectGetInteger(0,SellButton,OBJPROP_STATE)))
        {
         SellButton_Click();
        }
      if(bool(ObjectGetInteger(0,CloseAllButton,OBJPROP_STATE)))
        {
         CloseAllButton_Click();
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetInputText(string inputName,string text)
  {
   ObjectSetString(0,inputName,OBJPROP_TEXT,text);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string GetInputText(string inputName)
  {
   return ObjectGetString(0,inputName,OBJPROP_TEXT);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetInputTextAsDouble(string inputName)
  {
   return StrToDouble(GetInputText(inputName));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetPositionSize()
  {
   return GetInputTextAsDouble(PositionSizeInput);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetStopLoss(int orderType)
  {
   if(orderType==OP_BUY)
     {
      return Bid - GetInputTextAsDouble(StopLossInput);
     }
   if(orderType==OP_SELL)
     {
      return Ask + GetInputTextAsDouble(StopLossInput);
     }
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetTakeProfit(int orderType)
  {
   if(orderType==OP_BUY)
     {
      return Bid + GetInputTextAsDouble(TakeProfitInput);
     }
   if(orderType==OP_SELL)
     {
      return Ask - GetInputTextAsDouble(TakeProfitInput);
     }
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string GetOrderComment()
  {
   return GetInputText(OrderCommentInput);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BuyButton_Click()
  {
   ObjectSetInteger(0,BuyButton,OBJPROP_STATE,false);
   bool hedgeViolation=false;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      bool ret = OrderSelect(i,SELECT_BY_POS);
      if(OrderType()==OP_SELL && OrderSymbol()==Symbol())
        {
         Comment("Hedging Prohibited");
         hedgeViolation=true;
        }
     }
   if(!hedgeViolation)
     {
      int ret =OrderSend(NULL,OP_BUY,GetPositionSize(),Ask,0,GetStopLoss(OP_BUY),GetTakeProfit(OP_BUY),GetOrderComment());
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SellButton_Click()
  {
   ObjectSetInteger(0,SellButton,OBJPROP_STATE,false);
   bool hedgeViolation=false;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      bool ret = OrderSelect(i,SELECT_BY_POS);
      if(OrderType()==OP_BUY && OrderSymbol()==Symbol())
        {
         Comment("Hedging Prohibited");
         hedgeViolation=true;
        }
     }
   if(!hedgeViolation)
     {
      int ret = OrderSend(NULL,OP_SELL,GetPositionSize(),Bid,0,GetStopLoss(OP_SELL),GetTakeProfit(OP_SELL),GetOrderComment());
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseAllButton_Click()
  {
   ObjectSetInteger(0,CloseAllButton,OBJPROP_STATE,false);
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      bool ret = OrderSelect(i,SELECT_BY_POS);
      if(OrderType()==OP_BUY || OrderType()==OP_SELL)
         ret = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),5);
      else
         ret = OrderDelete(OrderTicket());
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,         // Event ID
                  const long& lparam,   // Parameter of type long event
                  const double& dparam, // Parameter of type double event
                  const string& sparam  // Parameter of type string events
                  )
  {
   if(sparam==BuyButton) // Buy button has been pressed
     {
      BuyButton_Click();
     }
   if(sparam==SellButton) // Sell button has been pressed
     {
      SellButton_Click();
     }
   if(sparam==CloseAllButton) // Close button has been pressed
     {
      CloseAllButton_Click();
     }
  }
//+------------------------------------------------------------------+
