# Rayner Teo Moving Average Trading Strategy
Notes taken from his video at https://youtu.be/clAQxb-PMSI

## Summary
*Looking to enter on pullbacks while there is a strong trend.*

## Identify Long Term Trend
- Using 200 period moving average

## Define the "Area of Value"
- Using 50 period moving average +- 10 periods
- Area of value means an approximate target, not exact.
	
## Entry
- On 200 period MA with MA trending up
- Looking at 50 period MA, with price testing it and then going up again
- Buy on the swing low of the third test of 50 MA

## Stop Loss
- Stop loss is set to a recent low, below the 50 MA or 1 ATR(50) below the entry.
- For trend trading, the stop is set to follow the 50 MA.

## Targets

### Trend Target
- The trend traders target is defined by a trailing stop tied to the 50 MA.
- Trend trader isn't worried about the immediate rejection hazard posed by the recent extreme of price, he's counting on the trend and momentum to carry price through.

### Swing Target
- The swing trader's target would be set just below the most recent high, no sense in fighting against the resistance that already rejected price once.
- Looking to profit from periodic lulz in the momentum of the trend, where the price can pull back to the fast MA and reliably be pushed back up to the recent price extreme.

## Implmentation
I have implemented this strategy on my framework here. All of the options described in Rayner's video are available, plus all of the standard features of my framework.

What you'll see in this implementation is 3 trendlines, 1 representing the MA for identifying the longer term trend, 2 for defining the borders of the "Value Area". You will also see 3 boxes and 3 bombs. The boxes are proximity sensors for detecting when price touches the fast moving average. The bombs align with the proximity sensors when a touch is detected and the slope of the moving average inside of the box has the same direction as the fast moving average at present. You know, so we can tell that the fast MA has been going in the same direction and has been tested multiple times.

With the swing trader exits enabled (by setting the trend following setting to false), another box appears once an order is open. This box shows the chart sample used in determining the high and low levels for placing SL & TP. You may notice the SL & TP moving, this is because the High Low sensor does not consider the newest bar in its calculations. This allows the TP to go higher and gives you a trailing stop in extremely fortunate coincidences of timing. If you notice the TP shrinking, or the SL growing, then you've disabled the option to "pin exits". Unpinning exits isn't going to be very helpful with this strategy but you can try it if you want to.

 It is important that you set the "fast" MA to a smaller value than the "medium" one, otherwise it won't be doing things right... you'd notice by running a backtest anyway. I've made options for defining the two exit styles Rayner described as well. For setting SL & TP by the recent high and low price (swing trader), you get to define how many bars to consider. In the video he didn't actually say how far back to look, but did say it was up to your discretion. For setting a trailing stop (trend trader), he did say it was a good idea to have the trailing stop follow the 50 MA, but then he kept saying that the 50 MA was somewhat arbitrary because it defines a "Value Area" and not a hard line. I figured you might want to set an arbitrary trailing stop somewhere between your slow and fast moving average settings, or something else entirely, so the setting is there. Also, for the trailing stop he mentions using "1 ATR", I assumed he meant the ATR should have the same period as the trailing stop's moving average. You can disable adding the initial SL by ATR if you want to, but then you won't get a trailing stop until after the price is in profit and above the moving average by "1 ATR".

Now, with all that said, there are two settings files in the MQL4\Presets folder. One of them configured to do the swing trading and the other configured to do the trend trading. The settings in those two files will have you set up just like Rayner described in the video for both strategies, and you can start your explorations from there. I wouldn't go live with those settings exactly, you'll probably lose money. You can use the backtester to check out the strengths and weaknesses of the strategy.

What you're looking for while the bot is operating : 3 boxes with bombs inside of them, 3 moving averages fanned out in ascending or descending order (one is buy the other is sell), and the price to fall somewhere between the tast and medium MA. At that point a buy or sell order will open up and the exit strategy you've selected will begin managing the trade. No bars, no math, just boxes, bombs, and easy trend lines to look at. Then you can set a portfolio of symbols to trade on and watch it go to town on all of them in your demo account... When you're ready to forward test that is...