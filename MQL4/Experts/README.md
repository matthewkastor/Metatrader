# Experts

Expert Advisors for metatrader

## EA List

* **Biased Martingale** : A martingale system that uses ATR to calculate take profit levels.
* **Bollinger Band Pullback Trader** : A system built on the Portfolio Manager framework, using bollinger bands and pullbacks to the moving average to enter trades.
* **Keltner Pullback Trader** : A system buuilt on the Portfolio Manager framework, using keltner channels to enter trades.
* **MA Crossover** : A general purpose program for studying multiple trading systems.
* **Multi Pair Closer** : A profit and loss manager for currency basket trading.
* **Portfolio Trader** : A system built on the Portfolio Manager framework, using recent highs and lows as breakout or fade indicators and entering trades accordingly.
* **Trader Trainer** : A program to enable manual trading in the backtester.

## Common Settings for Portfolio Manager

EAs based on the Portfolio Manager have some common settings as shown in the screenshots.

**Portfolio Manager Settings**

These settings control the global behavior of the portfolio manager.

![Screenshot of Portfolio Manager Settings](README%20images/Portfolio%20Manager%20Settings.png)

* **Currency Basket** : A comma separated list of currency symbols traded by this portfolio.
* **Portfolio Timeframe** : The timeframe that this portfolio trades on. A chart for each symbol in the basket will be opened with this timeframe selected.
* **Lots to trade** : The lot size per trade.
* **Profit Target** : All trades in this portfolio will be closed if the net profit reaches this target.
* **Maximum allowed loss** : All trades in this portfolio will be closed if the net loss exceeds this amount.
* **Allowed Slippage** : When sending orders, this slippage amount will be specified.

*These settings control when the portfolio is allowed to trade.*

* **Start Day** : The first day of the work week.
* **End Day** : The last day of the work week.
* **Start Time** : The starting time of the work week or work day.
* **End Time** : The ending time of the work week or work day.
*  **Use start and stop times daily** : When set to false, the schedule will be enabled from the start day and time until the end day and timei.e. Monday at 8:15 to Friday at 16:45 would only allow trading between Monday at 8:15 a.m. and Friday at 4:45 p.m.. When set to true, the schedule will be considered a recurring daily schedule that begins and ends each day at the start and end time, for each day beginning on the start day and ending on the end day i.e. Monday to Friday from 8:15 to 16:45 would only allow trading between 8:15 a.m. and 4:45 p.m. daily from Monday to Friday.

*Entry and exit controls*

* **Trade only at opening of new bar** : When true, this restricts trading action to only occur at the beginning of each bar on the chart. For example, on an hourly timeframe chart, this would mean that at most there would be one evaluation of the trading signals at the beginning of the hour.
* **Disable Signals from moving exits backward** : When false, this will allow signals to move the stop loss farther out and the take profit closer in. 
* **Allow signal switching to close orders** : When true, this allows a sell signal to indicate that an existing buy order should be closed and a sell order should be opened. When false, a signal calling for a trade in the opposite direction will be ignored.

**Backtest Custom Optimization Settings**

These settings control the scoring of performance during backtesting. You can use this score to help the backtester's genetic algo select appropriate parameters to test, by selecting the "custom" optimization criteria. You could also skip genetic testing and simply select the "custom" optimization criteria to chart results based on this metric. The final score given combines the metrics specified in these settings with factors for profitability and equity curve "smoothness", so the closer that the final score is to the initial score the better. A perfect score should be nearly impossible.

![Screenshot of Backtest Custom Optimization Settings](README%20images/Backtest%20Custom%20Optimization%20Settings.png)

* **Backtest Initial Score** : This is the score to start with, a perfect score will be this high. By default it is 100.

*A tighter standard deviation means that measured values were generally more consistent.*

* **Minimum Value of StdDev of Gains** : Given a standard deviation of gains from profitable trades, this is the lowest value to consider acceptable. 
* **Maximum Value of StdDev of Gains** : Given a standard deviation of gains from profitable trades, this is the highest value to consider acceptable.
* **Weight of metric Gains StdDev Limit** : How important this metric is compared to the others?
* **Minimmum Value of StdDev of Losses** : Given a standard deviation of losses from unprofitable trades, this is the lowest value to consider acceptable. 
* **Maximum Value of StdDev of Losses** : Given a standard deviation of losses from unprofitable trades, this is the maximum value to consider acceptable. 
* **Weight of metric Losses StdDev Limit** : How important this metric is compared to the others?

*The net profit range filters out unprofitable or unrealistic results, as in you want to ignore fluke results from spurious market events and luck*

* **Minimum Net Profit** : The minimum acceptable net profit during the testing period.
* **Maximum Net Profit** : The maximum acceptable net profit during the testing period.
* **Weight of Metric Net Profit Range** : How important this metric is compared to the others?

*The expected average gain metric helps filter out results where TP levels are curve fit to hit a few extremes of price, here the average gain is the net gain divided by the number of trades*

* **Minimum Expected Average Gain** : The minimum acceptable average gain.
* **Maximum Expected Average Gain** : The maximum acceptable average gain.
* **Weight of Metric Expected Average Gain** : How important this metric is compared to the others?

*The trades per day metric helps filter out results where there was over trading or under trading*

* **Minimum Amount of Trades Per Day** : The minimum amount of trades per day (0.033333 = one trade per month).
* **Maximum Amount of Trades Per Day** : The maximum amount of trades per day.
* **Weight of Metric Trades Per Day** : How important this metric is compared to the others?

*The largest loss per total gain metric helps filter out curve fit results where there are massive loss trades*

* **Max Percent of Largest Loss Per Total Gain** : The maximum acceptable single loss, as a percent of total gains taken during the testing period.
* **Weight of Metric Max Percent of Largest Loss Per Total Gain** : How important this metric is compared to the others?

*The median loss per median gain metric tells you your median risk to reward, use it to filter out curve fit results that push the risk reward outside of the design of your strategy*

* **Max Percent of Median Loss Per Median Gain** : The worst median risk reward ratio acceptable. (|median loss|/median gain)
* **Weight of Metric Max Percent of Median Loss Per Median Gain** : How important this metric is compared to the others?